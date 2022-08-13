/obj/item/clothing/suit/hardsuit/turian_hierarchy
	name = "Phantom Battle Armor"
	desc = "A turian hardsuit issued to soldiers of the Hierarchy. Built with two layers of energy-absorbing spall liners, a hard outer layer of battle ceramic, and an inner set of shock padding"
	icon = 'pinnacle_station/icons/armor/turian/turian_armor.dmi'
	worn_icon =	'pinnacle_station/icons/armor/turian/turian_armor.dmi'
	icon_state = "turian_armor"
	worn_icon_state = "turian_armor"
	armor = list(MELEE = 35, BULLET = 30, LASER = 30, ENERGY = 40, BOMB = 25, BIO = 0, FIRE = 50, ACID = 50, WOUND = 10)

/obj/item/clothing/suit/hardsuit/turian_hierarchy/Initialize(mapload)
	. = ..()
	var/datum/component/kinesis_shield/shield = AddComponent(/datum/component/kinesis_shield)
	shield.power_max = 600
	shield.power_recharge_rate = 50
	shield.damage_flat = 5
	shield.damage_ratio_map[BURN] = 0
	shield.damage_ratio_map[BRUTE] = 2


/obj/item/clothing/suit/hardsuit/turian_hierarchy/light
	name = "Thermal Scout Hardsuit"
	desc = "A lighter turian hardsuit built for scouting and skirmishes. Built from a set of nano-weave plastics topped with hard battle ceramics over the chest, cowl, shoulders, and upper legs."
	armor = list(MELEE = 35, BULLET = 30, LASER = 30, ENERGY = 40, BOMB = 25, BIO = 0, FIRE = 50, ACID = 50, WOUND = 10)


/obj/item/clothing/suit/hardsuit/turian_hierarchy/heavy
	name = "Silverback Heavy Combat Armor"
	desc = "A hardsuit designed for use by heavy infantry of the Turian Hierarchy. The surface is laser-polish compressed metals backed with high-impact ceramic, over a gel-padded bodysuit of spall-liners and omnigel that automatically seals suit breaches. Quite heavy."

/obj/item/clothing/suit/hardsuit/turian_hierarchy/blackwatch
	name = "Titan Augmented Battle Armor"
	desc = "A super-heavy, augmented suit of armor, the Titan is the signature suit of armor for the legendary Blackwatch teams. Designed to take extremely heavy fire, and keep moving."