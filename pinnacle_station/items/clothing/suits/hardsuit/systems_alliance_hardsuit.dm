
/obj/item/clothing/suit/systems_alliance
	name = "ONYX Standard Battle Armor"
	desc = "Developed by Ariake Technologies, this suit exchanges full protective coverage for visibility, unencumbered mobility, and increased accuracy. This is a full environmental armor, with a built-in biofeedback system regulating wearer's adrenaline surges and monitoring medical conditions. Standard issue for all marines"
	icon = 'pinnacle_station/icons/armor/human/systems_alliance.dmi'
	worn_icon =	'pinnacle_station/icons/armor/human/systems_alliance_worn.dmi'
	body_parts_covered = CHEST|GROIN|LEGS|FEET|ARMS|HANDS
	cold_protection = CHEST|GROIN|LEGS|FEET|ARMS|HANDS
	min_cold_protection_temperature = ARMOR_MIN_TEMP_PROTECT
	heat_protection = CHEST|GROIN|LEGS|FEET|ARMS|HANDS
	max_heat_protection_temperature = ARMOR_MAX_TEMP_PROTECT
	strip_delay = 60
	equip_delay_other = 40
	max_integrity = 250
	resistance_flags = NONE
	armor = list(MELEE = 35, BULLET = 30, LASER = 30, ENERGY = 40, BOMB = 25, BIO = 0, FIRE = 50, ACID = 50, WOUND = 10)

/obj/item/clothing/suit/systems_alliance/n7
	name = "ONYX-N Heavy Battle Armor"
	desc = "Standard issue combat hardsuit for N-series special forces. Built to protect soldiers in long-running engagements where reinforcements may be sparse."
	icon_state = "n7_armor"
	worn_icon_state = "n7_armor_w"
	body_parts_covered = CHEST|GROIN|LEGS|FEET|ARMS|HANDS
	cold_protection = CHEST|GROIN|LEGS|FEET|ARMS|HANDS
	min_cold_protection_temperature = ARMOR_MIN_TEMP_PROTECT
	heat_protection = CHEST|GROIN|LEGS|FEET|ARMS|HANDS
	max_heat_protection_temperature = ARMOR_MAX_TEMP_PROTECT
	strip_delay = 60
	equip_delay_other = 40
	max_integrity = 250
	resistance_flags = NONE
	armor = list(MELEE = 35, BULLET = 30, LASER = 30, ENERGY = 40, BOMB = 25, BIO = 0, FIRE = 50, ACID = 50, WOUND = 10)

/obj/item/clothing/suit/systems_alliance/n7/Initialize(mapload)
	. = ..()
	var/datum/component/kinesis_shield/shield = AddComponent(/datum/component/kinesis_shield)
	shield.power_max = 200
	shield.power_recharge_rate = 50
	shield.damage_flat = 5
	shield.damage_ratio_map[BURN] = 0
	shield.damage_ratio_map[BRUTE] = 2