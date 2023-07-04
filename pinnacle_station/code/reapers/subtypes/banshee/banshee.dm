/datum/species/asari
	name = SPECIES_BANSHEE
	name_plural = SPECIES_BANSHEE
	icobase = 'code/modules/pinnacle_station/species/asari/asari.dmi'
	deform = 'code/modules/pinnacle_station/species/asari/asari.dmi'
	unarmed_types = list(/datum/unarmed_attack/stomp, /datum/unarmed_attack/kick, /datum/unarmed_attack/punch, /datum/unarmed_attack/bite)
	description =
	"Banshees are the corrupted asari often found leading a Reaper strike force. The Reapers create them specifically from asari with active or latent predispositions to becoming Ardat-Yakshi, \
	 a rare neurological condition that enhances the asari's biotic power while causing the immediate death of anyone she mates with."
	assisted_langs = list(LANGUAGE_NABBER)
	min_age = 110
	max_age = 340
	hidden_from_codex = FALSE
	bandages_icon = 'icons/mob/bandage.dmi'

	spawn_flags = SPECIES_CAN_JOIN
	appearance_flags = HAS_SKIN_COLOR | HAS_LIPS | HAS_UNDERWEAR | HAS_EYE_COLOR

	sexybits_location = BP_GROIN

	exertion_effect_chance = 10
	exertion_hydration_scale = 1
	exertion_charge_scale = 1
	exertion_reagent_scale = 5
	exertion_reagent_path = /datum/reagent/lactate
	exertion_emotes_biological = list(
		/decl/emote/exertion/biological,
		/decl/emote/exertion/biological/breath,
		/decl/emote/exertion/biological/pant
	)
	exertion_emotes_synthetic = list(
		/decl/emote/exertion/synthetic,
		/decl/emote/exertion/synthetic/creak
	)



/datum/species/asari/get_bodytype(var/mob/living/carbon/asari/H)
	return SPECIES_HUMAN

	genders = list(FEMALE)