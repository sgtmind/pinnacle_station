/datum/species/turian
	name = "\improper turian"
	plural_form = "turian"
	id = SPECIES_TURIAN
	say_mod = "says"
	species_traits = list(HAS_FLESH, HAS_BONE)
	inherent_traits = list(
		TRAIT_ADVANCEDTOOLUSER,
		TRAIT_CAN_STRIP,
		TRAIT_CAN_USE_FLIGHT_POTION,
	)
	inherent_biotypes = MOB_ORGANIC|MOB_HUMANOID
	coldmod = 1
	heatmod = 1
	payday_modifier = 0.75
	changesource_flags = MIRROR_BADMIN | WABBAJACK | MIRROR_PRIDE | MIRROR_MAGIC | RACE_SWAP | ERT_SPAWN | SLIME_EXTRACT
	species_cookie = /obj/item/food/meat/slab
	attack_verb = "slash"
	attack_effect = ATTACK_EFFECT_CLAW
	attack_sound = 'sound/weapons/slash.ogg'
	miss_sound = 'sound/weapons/slashmiss.ogg'
	exotic_bloodtype = "L"
	deathsound = 'sound/voice/lizard/deathsound.ogg'
	species_language_holder = /datum/language_holder/lizard
'

	bodypart_overrides = list(
		BODY_ZONE_HEAD = /obj/item/bodypart/head/lizard,
		BODY_ZONE_CHEST = /obj/item/bodypart/chest/lizard,
		BODY_ZONE_L_ARM = /obj/item/bodypart/l_arm/lizard,
		BODY_ZONE_R_ARM = /obj/item/bodypart/r_arm/lizard,
		BODY_ZONE_L_LEG = /obj/item/bodypart/l_leg/lizard,
		BODY_ZONE_R_LEG = /obj/item/bodypart/r_leg/lizard,
	)


/datum/species/turian/random_name(gender,unique,lastname)
	if(unique)
		return random_unique_turian_name(gender)

	var/randname = lizard_name(gender)

	if(lastname)
		randname += " [lastname]"

	return randname

/datum/species/turian/get_scream_sound(mob/living/carbon/human/lizard)
	return pick(
		'sound/voice/lizard/lizard_scream_1.ogg',
		'sound/voice/lizard/lizard_scream_2.ogg',
		'sound/voice/lizard/lizard_scream_3.ogg',
	)

/datum/species/turian/get_species_description()
	return "Originally from the planet Palaven, turians are best known for their military role, \
	particularly their contributions of soldiers and starships to the Citadel Fleet. They are respected \
	for their public service ethic. It was the turians who first proposed creating the now ubitiquos C-Sec \
	but are often viewed as imperialist or rigid by other races."