//M8 Avenger

/obj/projectile/bullet/m8_avenger
	name = "bullet"
	icon_state = "bullet"
	damage = 60
	damage_type = BRUTE
	nodamage = FALSE
	armor_flag = BULLET
	hitsound_wall = SFX_RICOCHET
	sharpness = SHARP_POINTY
	impact_effect_type = /obj/effect/temp_visual/impact_effect
	shrapnel_type = /obj/item/shrapnel/bullet
	embedding = list(embed_chance=20, fall_chance=2, jostle_chance=0, ignore_throwspeed_threshold=TRUE, pain_stam_pct=0.5, pain_mult=3, rip_time=10)
	wound_falloff_tile = -5
	embed_falloff_tile = -3

/obj/item/ammo_casing/m8_avenger
	name = "M8 Avenger Flek"
	desc = "A flek from an M8 Avenger"
	caliber = CALIBER_M8_AVENGER
	projectile_type = /obj/projectile/bullet/m8_avenger

/obj/item/ammo_box/magazine/m8_avenger
	name = "M8 Avenger Block"
	icon_state = "5.56m"
	ammo_type = /obj/item/ammo_casing/m8_avenger
	caliber = CALIBER_M8_AVENGER
	max_ammo = 1000
	multiple_sprites = AMMO_BOX_FULL_EMPTY

//M99 Sabre

/obj/projectile/bullet/m99_sabre
	name = "bullet"
	icon_state = "bullet"
	damage = 60
	damage_type = BRUTE
	nodamage = FALSE
	armor_flag = BULLET
	hitsound_wall = SFX_RICOCHET
	sharpness = SHARP_POINTY
	impact_effect_type = /obj/effect/temp_visual/impact_effect
	shrapnel_type = /obj/item/shrapnel/bullet
	embedding = list(embed_chance=20, fall_chance=2, jostle_chance=0, ignore_throwspeed_threshold=TRUE, pain_stam_pct=0.5, pain_mult=3, rip_time=10)
	wound_falloff_tile = -5
	embed_falloff_tile = -3

/obj/item/ammo_casing/m8_avenger
	name = "M8 Avenger Flek"
	desc = "A flek from an M8 Avenger"
	caliber = CALIBER_M8_AVENGER
	projectile_type = /obj/projectile/bullet/m8_avenger

/obj/item/ammo_box/magazine/m8_avenger
	name = "M8 Avenger Block"
	icon_state = "5.56m"
	ammo_type = /obj/item/ammo_casing/m8_avenger
	caliber = CALIBER_M8_AVENGER
	max_ammo = 1000
	multiple_sprites = AMMO_BOX_FULL_EMPTY
