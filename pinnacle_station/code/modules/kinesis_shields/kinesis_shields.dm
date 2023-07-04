#define OVERLAY_STATE_CLEAR 0
#define OVERLAY_FLICK_BREAK "shield_break"
#define OVERLAY_FLICK_BULLET_ACT "shield_bullet_act"
#define OVERLAY_FLICK_MELEE_ACT "shield_melee_act"
#define OVERLAY_FLICK_RECHARGE_FINISHED "shield_recharge_finish"
#define OVERLAY_STATE_IDLE_MAX "shield_idle_max"
#define OVERLAY_STATE_IDLE_80 "shield_idle_80"
#define OVERLAY_STATE_IDLE_50 "shield_idle_50"
#define OVERLAY_STATE_IDLE_20 "shield_idle_20"
#define OVERLAY_STATE_IDLE_LOW "shield_idle_low"

/mob/living
	var/datum/component/kinesis_shield/shield_master

/datum/component/kinesis_shield
	var/obj/item/clothing/parent_clothing
	var/mob/living/parent_wearing

	/// Current shield power
	var/power = 0
	/// Maximum shield power
	var/power_max = 100
	/// Power recharged every tick
	var/power_recharge_rate = 10

	/// world.time that shield is allowed to begin recharging
	var/break_finish = 0
	/// Time required for shield break before wearing off
	var/break_length = 5 SECONDS

	/// Flat damage applied when shield takes damage
	var/damage_flat = 10
	/// Damage ratio map, for when you have different damage types and want to block different amounts
	var/damage_ratio_map = list(
		BRUTE = 0.5,
		BURN = 1.0,
		CLONE = 0,
		TOX = 0,
	)

	/// Does the action that breaks the shield still get blocked
	var/shield_break_blocks_all_damage = FALSE
	/// Does this shield protect from melee attacks
	var/shield_block_melee = FALSE

	/// Current overlay state
	var/overlay_state = OVERLAY_STATE_CLEAR
	/// Overlay object
	var/mutable_appearance/overlay_actual

	/// Timer storage for our flick timer
	var/flick_timer
	/// Current flick overlay
	var/flick_actual
	/// Assosciative list to get sounds that should play when a flick is started. Assosciative
	var/list/flick_sound_map = list(
		OVERLAY_FLICK_BREAK = "sound here",
		OVERLAY_FLICK_BULLET_ACT = "sound here",
		OVERLAY_FLICK_MELEE_ACT = "sound here",
		OVERLAY_FLICK_RECHARGE_FINISHED = "sound here",
	)

	var/datum/component/kinesis_shield/master_shield = null
	var/list/datum/component/kinesis_shield/child_shields = list()

/datum/component/kinesis_shield/Initialize()
	. = ..()

	if(!isclothing(parent))
		return COMPONENT_INCOMPATIBLE
	parent_clothing = parent
	overlay_actual = mutable_appearance('pinnacle_station/modules/kinesis_shields/kinesis.dmi', "")

/datum/component/kinesis_shield/Destroy(force, silent)
	if(flick_timer)
		deltimer(flick_timer)
		flick_overlay_finish()
	if(parent_wearing)
		UnregisterFromWearingParent()
	if(overlay_state != OVERLAY_STATE_CLEAR)
		overlay_state = OVERLAY_STATE_CLEAR
		update_overlay()
	parent_clothing = null
	parent_wearing = null
	return ..()

/datum/component/kinesis_shield/RegisterWithParent()
	RegisterSignal(parent, COMSIG_ITEM_EQUIPPED, .proc/on_clothing_equipped)
	RegisterSignal(parent, COMSIG_ITEM_PRE_UNEQUIP, .proc/on_clothing_unequipped)

/datum/component/kinesis_shield/UnregisterFromParent()
	UnregisterFromWearingParent()
	UnregisterSignal(parent, list(
		COMSIG_ITEM_EQUIPPED, COMSIG_ITEM_PRE_UNEQUIP
	))

/datum/component/kinesis_shield/proc/RegisterWithWearingParent()
	RegisterSignal(parent_wearing, COMSIG_ATOM_BULLET_ACT, .proc/on_wearer_bullet_act)
	RegisterSignal(parent_wearing, COMSIG_MOB_ATTACKED, .proc/on_wearer_melee_act)
	update_overlay()

/datum/component/kinesis_shield/proc/UnregisterFromWearingParent()
	if(QDELETED(parent_wearing))
		return
	UnregisterSignal(parent_wearing, list(
		COMSIG_ATOM_BULLET_ACT
	))
	update_overlay()

/datum/component/kinesis_shield/proc/on_clothing_equipped(datum/source, mob/equipper, slot)
	SIGNAL_HANDLER

	if(slot == ITEM_SLOT_HANDS)
		return

	parent_wearing = equipper
	RegisterWithWearingParent()

	if(parent_wearing.shield_master)
		master_shield = parent_wearing.shield_master
		link_with_master()
	else
		parent_wearing.shield_master = src

	shield_break(TRUE)
	START_PROCESSING(SSobj, src)

/datum/component/kinesis_shield/proc/on_clothing_unequipped(datum/source)
	SIGNAL_HANDLER

	if(!parent_wearing)
		return

	if(master_shield)
		unlink_from_master()
	else
		if(length(child_shields))
			for(var/datum/component/kinesis_shield/child as anything in child_shields)
				child.unlink_from_master()
			parent_wearing.shield_master = child_shields[1]
			child_shields -= parent_wearing.shield_master
			for(var/datum/component/kinesis_shield/child as anything in child_shields)
				child.link_with_master()
		else
			parent_wearing.shield_master = null

	set_overlay(OVERLAY_STATE_CLEAR)
	STOP_PROCESSING(SSobj, src)
	UnregisterFromWearingParent()
	parent_wearing = null
	power = 0

/datum/component/kinesis_shield/proc/on_wearer_bullet_act(datum/source, obj/projectile/proj)
	SIGNAL_HANDLER

	if(master_shield)
		return

	if(!power)
		shield_break(TRUE)
		return

	var/damage_ratio = damage_ratio_map[proj.damage_type]
	var/shield_damage = round(damage_flat + (proj.damage * damage_ratio))
	var/power_old = power

	if(power > shield_damage)
		power -= shield_damage
		flick_overlay(OVERLAY_FLICK_BULLET_ACT)
		return COMPONENT_BLOCK_BULLET_ACT

	shield_break(FALSE)
	if(shield_break_blocks_all_damage)
		return COMPONENT_BLOCK_BULLET_ACT

	var/pct_blocked = power_old / shield_damage
	proj.damage *= pct_blocked

/datum/component/kinesis_shield/proc/on_wearer_melee_act(mob/source, obj/item/weapon, mob/living/user)
	SIGNAL_HANDLER

	if(master_shield)
		return

	if(!shield_block_melee)
		return
	if(!power)
		return

	var/damage_ratio = damage_ratio_map[weapon.damtype]
	var/shield_damage = weapon.force * damage_ratio
	var/power_old = power

	if(power > shield_damage)
		power -= shield_damage
		flick_overlay(OVERLAY_FLICK_MELEE_ACT)
		return COMPONENT_MOB_ATTACKED_BLOCK_DAMAGE
	else
		shield_break()
		var/pct_blocked = power_old / shield_damage
		var/old_force = weapon.force

		weapon.force *= pct_blocked
		source.attacked_by(weapon, user)
		weapon.force = old_force
		return (COMPONENT_MOB_ATTACKED_BLOCK_MESSAGE|COMPONENT_MOB_ATTACKED_BLOCK_DAMAGE)

/datum/component/kinesis_shield/process(delta_time)
	if(master_shield)
		return PROCESS_KILL

	if(!parent_wearing)
		return PROCESS_KILL

	if(power > power_max)
		power = power_max
		return

	if(break_finish > world.time)
		return

	var/power_old = power
	power = clamp(power + round(power_recharge_rate * delta_time), power, power_max)
	var/pct = round(round(power / power_max, 0.02) * 100)

	if(pct == 100)
		set_overlay(OVERLAY_STATE_IDLE_MAX)
	else
		switch(pct)
			if(80 to 99)
				set_overlay(OVERLAY_STATE_IDLE_80)
			if(50 to 80)
				set_overlay(OVERLAY_STATE_IDLE_50)
			if(20 to 50)
				set_overlay(OVERLAY_STATE_IDLE_20)
			if(01 to 20)
				set_overlay(OVERLAY_STATE_IDLE_LOW)
			if(0)
				set_overlay(OVERLAY_STATE_CLEAR)

	if(power >= power_max && power_old < power_max)
		flick_overlay(OVERLAY_FLICK_RECHARGE_FINISHED)

/**
 * Handles the logic related to a shield breaking
 *
 * If silent is FALSE, which is the default, sends a message to the wearer and adjacent observers about the shield breaking
 */
/datum/component/kinesis_shield/proc/shield_break(silent=FALSE)
	if(master_shield)
		return master_shield.shield_break(silent)

	break_finish = world.time + break_length
	power = 0

	set_overlay(OVERLAY_STATE_CLEAR)
	if(silent)
		return

	flick_overlay(OVERLAY_FLICK_BREAK)
	for(var/observer in viewers(1, parent_wearing))
		to_chat(parent_wearing, span_userdanger("The kinesis shield of [parent_clothing] sparks and fails!"))

/**
 * This proc allows you to flick an overlay on the wearing parent aswell as how long you want that overlay to last
 * Should probably have length be auto filled from the animation length on the flick overlay itself but thats
 * a bit more complicated than I'm willing to put in -ZephyrTFA
 */
/datum/component/kinesis_shield/proc/flick_overlay(overlay_flick, length = 1 SECONDS)
	if(flick_timer)
		flick_overlay_finish()
		deltimer(flick_timer)
	flick_timer = addtimer(CALLBACK(src, .proc/flick_overlay_finish), length, TIMER_STOPPABLE|TIMER_CLIENT_TIME)

	flick_actual = mutable_appearance('pinnacle_station/modules/kinesis_shields/kinesis.dmi', overlay_flick)
	parent_wearing.add_overlay(list(flick_actual))

	var/flick_sound = flick_sound_map[overlay_flick]
	if(flick_sound)
		playsound(parent_wearing, flick_sound, 50, TRUE, falloff_exponent=0.8)

/**
 * Do not manually call this unless you know what you are doing
 */
/datum/component/kinesis_shield/proc/flick_overlay_finish()
	if(QDELETED(parent_wearing))
		return
	parent_wearing.cut_overlay(list(flick_actual))

/**
 * Sets the active idle overlay for this component
 */
/datum/component/kinesis_shield/proc/set_overlay(overlay_state)
	if(src.overlay_state == overlay_state)
		return

	src.overlay_state = overlay_state
	update_overlay()

/**
 * Clears the old idle overlay and adds the new one, relatively simple
 */
/datum/component/kinesis_shield/proc/update_overlay()
	parent_wearing.cut_overlay(list(overlay_actual))
	if(overlay_state == OVERLAY_STATE_CLEAR)
		return
	overlay_actual.icon_state = overlay_state
	parent_wearing.add_overlay(list(overlay_actual))

/datum/component/kinesis_shield/proc/link_with_master()
	master_shield.power_max += power_max
	master_shield.power_recharge_rate += power_recharge_rate

/datum/component/kinesis_shield/proc/unlink_from_master()
	master_shield.power_max -= power_max
	master_shield.power_recharge_rate -= power_recharge_rate

#undef OVERLAY_STATE_CLEAR
#undef OVERLAY_FLICK_BREAK
#undef OVERLAY_FLICK_BULLET_ACT
#undef OVERLAY_FLICK_MELEE_ACT
#undef OVERLAY_FLICK_RECHARGE_FINISHED
#undef OVERLAY_STATE_IDLE_MAX
#undef OVERLAY_STATE_IDLE_80
#undef OVERLAY_STATE_IDLE_50
#undef OVERLAY_STATE_IDLE_20
#undef OVERLAY_STATE_IDLE_LOW
