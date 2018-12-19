/obj/item/weapon/gun/projectile/automatic //Hopefully someone will find a way to make these fire in bursts or something. --Superxpdude
	name = "submachine gun"
	desc = "A lightweight, fast firing gun. Uses 9mm rounds."
	icon_state = "saber"	//ugly
	w_class = 3.0
	origin_tech = "combat=4;materials=2"
	mag_type = /obj/item/ammo_box/magazine/msmg9mm
	var/alarmed = 0

/obj/item/weapon/gun/projectile/automatic/isHandgun()
	return 0

/obj/item/weapon/gun/projectile/automatic/update_icon()
	..()
	icon_state = "[initial(icon_state)][magazine ? "-[magazine.max_ammo]" : ""][chambered ? "" : "-e"]"
	return

/obj/item/weapon/gun/projectile/automatic/attackby(obj/item/A, mob/user)
	if(..() && chambered)
		alarmed = 0

/obj/item/weapon/gun/projectile/automatic/mini_uzi
	name = "Mac-10"
	desc = "A lightweight, fast firing gun, for when you want someone dead. Uses 9mm rounds."
	icon_state = "mac"
	item_state = "mac"
	w_class = 3.0
	origin_tech = "combat=5;materials=2;syndicate=8"
	mag_type = /obj/item/ammo_box/magazine/uzim9mm

/obj/item/weapon/gun/projectile/automatic/update_icon()
	..()
	icon_state = "[initial(icon_state)][magazine ? "" : "-e"]"
	return


/obj/item/weapon/gun/projectile/automatic/c20r
	name = "C-20r SMG"
	desc = "A lightweight, compact bullpup SMG. Uses .45 ACP rounds in medium-capacity magazines and has a threaded barrel for silencers. Has a 'Scarborough Arms - Per falcis, per pravitas' buttstamp."
	icon_state = "c20r"
	item_state = "c20r"
	w_class = 3.0
	origin_tech = "combat=5;materials=2;syndicate=8"
	mag_type = /obj/item/ammo_box/magazine/m12mm
	fire_sound = 'sound/weapons/Gunshot_smg.ogg'


/obj/item/weapon/gun/projectile/automatic/c20r/atom_init()
	. = ..()
	update_icon()

/obj/item/weapon/gun/projectile/automatic/c20r/afterattack(atom/target, mob/living/user, flag)
	..()
	if(!chambered && !get_ammo() && !alarmed)
		playsound(user, 'sound/weapons/smg_empty_alarm.ogg', 40, 1)
		update_icon()
		alarmed = 1
	return

/obj/item/weapon/gun/projectile/automatic/c20r/attack_self(mob/user)
	if(silenced)
		switch(alert("Would you like to unscrew silencer, or extract magazine?","Choose.","Silencer","Magazine"))
			if("Silencer")
				if(loc == user)
					if(silenced)
						silencer_attack_hand(user)
			if("Magazine")
				..()
	else
		..()

/obj/item/weapon/gun/projectile/automatic/c20r/attackby(obj/item/I, mob/user)
	if(istype(I, /obj/item/weapon/silencer))
		return silencer_attackby(I,user)
	return ..()

/obj/item/weapon/gun/projectile/automatic/c20r/update_icon()
	..()
	overlays.Cut()
	if(magazine)
		var/image/magazine_icon = image('icons/obj/gun.dmi', "mag-[ceil(get_ammo(0) / 4) * 4]")
		overlays += magazine_icon
	if(silenced)
		var/image/silencer_icon = image('icons/obj/gun.dmi', "c20r-silencer")
		overlays += silencer_icon
	icon_state = "c20r[chambered ? "" : "-e"]"
	return

/obj/item/weapon/gun/projectile/automatic/l6_saw
	name = "\improper L6 SAW"
	desc = "A heavily modified light machine gun with a tactical plasteel frame resting on a rather traditionally-made ballistic weapon. Has 'Aussec Armoury - 2531' engraved on the reciever, as well as '7.62x51mm'."
	icon_state = "l6closed100"
	item_state = "l6closedmag"
	wielded_state = "l6"
	w_class = 5
	slot_flags = 0
	origin_tech = "combat=5;materials=1;syndicate=2"
	mag_type = /obj/item/ammo_box/magazine/m762
	fire_sound = 'sound/weapons/gunshot3.wav'

/obj/item/weapon/gun/projectile/automatic/l6_saw/update_icon()
	icon_state = "l6[magazine ? ceil(get_ammo(0) / 12.5) * 25 : "-empty"]"
	wielded_state = "[magazine ? "l6" : "l6_empty"]"

/obj/item/weapon/gun/projectile/automatic/l6_saw/attack_hand(mob/user)
	if(loc != user)
		..()
		return	//let them pick it up
	if(!magazine)
		..()
	else if(magazine)
		//drop the mag
		magazine.update_icon()
		magazine.loc = get_turf(src.loc)
		user.put_in_hands(magazine)
		magazine = null
		update_icon()
		to_chat(user, "<span class='notice'>You remove the magazine from [src].</span>")

/obj/item/weapon/gun/projectile/automatic/tommygun
	name = "thompson SMG"
	desc = "Based on the classic 'Chicago Typewriter'."
	icon_state = "tommygun"
	item_state = "shotgun"
	w_class = 5
	slot_flags = 0
	origin_tech = "combat=5;materials=1;syndicate=2"
	mag_type = /obj/item/ammo_box/magazine/tommygunm45
	fire_sound = 'sound/weapons/Gunshot_smg.ogg'
	//can_suppress = 0
 	//burst_size = 4
 	//fire_delay = 1

/* The thing I found with guns in ss13 is that they don't seem to simulate the rounds in the magazine in the gun.
   Afaik, since projectile.dm features a revolver, this would make sense since the magazine is part of the gun.
   However, it looks like subsequent guns that use removable magazines don't take that into account and just get
   around simulating a removable magazine by adding the casings into the loaded list and spawning an empty magazine
   when the gun is out of rounds. Which means you can't eject magazines with rounds in them. The below is a very
   rough and poor attempt at making that happen. -Ausops */

/* Where Ausops failed, I have not. -SirBayer */

//=================NEW GUNS=================\\

/obj/item/weapon/gun/projectile/automatic/l10c
	name = "L10-c"
	desc = "A basic energy-based carbine with fast rate of fire."
	icon_state = "l10-car"
	item_state = "l10-car"
	wielded_state = "l10"
	w_class = 4.0
	origin_tech = "combat=3;magnets=2"
	mag_type = /obj/item/ammo_box/magazine/l10mag
	fire_sound = 'sound/weapons/guns/l10c-shot.ogg'
	recoil = 0
	energy_gun = 1

/obj/item/weapon/gun/projectile/automatic/l10c/atom_init()
	. = ..()
	update_icon()

/obj/item/weapon/gun/projectile/automatic/l10c/process_chamber()
	return ..(0, 1, 1)

/obj/item/weapon/gun/projectile/automatic/l10c/afterattack(atom/target, mob/living/user, flag)
	..()
	update_icon(user)
	return

/obj/item/weapon/gun/projectile/automatic/l10c/attack_self(mob/user)
	if(magazine && magazine.ammo_count())
		playsound(user, 'sound/weapons/guns/l10c-unload.ogg', 70, 1)
	if(chambered)
		var/obj/item/ammo_casing/AC = chambered //Find chambered round
		qdel(AC)
		chambered = null
		magazine.stored_ammo += new magazine.ammo_type(magazine)
	if (magazine)
		magazine.loc = get_turf(src.loc)
		user.put_in_hands(magazine)
		magazine.update_icon()
		magazine = null
		to_chat(user, "<span class='notice'>You pull the magazine out of \the [src]!</span>")
	else
		to_chat(user, "<span class='notice'>There's no magazine in \the [src].</span>")
	update_icon(user)
	return

/obj/item/weapon/gun/projectile/automatic/l10c/attackby(obj/item/A, mob/user)
	if (istype(A, /obj/item/ammo_box/magazine))
		var/obj/item/ammo_box/magazine/AM = A
		if (!magazine && istype(AM, mag_type))
			user.remove_from_mob(AM)
			magazine = AM
			magazine.loc = src
			to_chat(user, "<span class='notice'>You load a new magazine into \the [src].</span>")
			if(AM.ammo_count())
				playsound(user, 'sound/weapons/guns/l10c-load.ogg', 70, 1)
			chamber_round()
			A.update_icon()
			update_icon(user)
			return 1
		else if (magazine)
			to_chat(user, "<span class='notice'>There's already a magazine in \the [src].</span>")
	..()

/obj/item/weapon/gun/projectile/automatic/l10c/update_icon(mob/M)
	if(!magazine)
		icon_state = "[initial(icon_state)]-e"
		item_state = "[initial(item_state)]-e"
		wielded_state = "l10_empty"
	else if(chambered)
		icon_state = "[initial(icon_state)]"
		item_state = "[initial(item_state)]"
		wielded_state = "l10_empty"
	else if(magazine && magazine.ammo_count())
		icon_state = "[initial(icon_state)]"
		item_state = "[initial(item_state)]"
		wielded_state = "l10"
	else
		icon_state = "[initial(icon_state)]-0"
		item_state = "[initial(item_state)]-0"
		wielded_state = "l10"
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		H.update_inv_l_hand()
		H.update_inv_r_hand()
		H.update_inv_belt()
	return


/obj/item/weapon/gun/projectile/automatic/c5
	name = "security submachine gun"
	desc = "C-5 submachine gun - cheap and light. Uses 9mm ammo."
	icon_state = "c5"
	item_state = "c5"
	w_class = 3.0
	origin_tech = "combat=4;materials=2"
	mag_type = /obj/item/ammo_box/magazine/c5_9mm
	fire_sound = 'sound/weapons/guns/c5_shot.wav'

/obj/item/weapon/gun/projectile/automatic/c5/update_icon(mob/M)
	icon_state = "c5[magazine ? "" : "-e"]"
	item_state = "c5[magazine ? "" : "-e"]"
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		H.update_inv_l_hand()
		H.update_inv_r_hand()
		H.update_inv_belt()
	return

/obj/item/weapon/gun/projectile/automatic/l13
	name = "security submachine gun"
	desc = "L13 personal defense weapon - for combat security operations. Uses .38 ammo."
	icon_state = "l13"
	item_state = "l13"
	w_class = 3.0
	origin_tech = "combat=4;materials=2"
	mag_type = /obj/item/ammo_box/magazine/l13_38
	fire_sound = 'sound/weapons/guns/l13_shot.ogg'

/obj/item/weapon/gun/projectile/automatic/l13/update_icon(mob/M)
	icon_state = "l13[magazine ? "" : "-e"]"
	item_state = "l13[magazine ? "" : "-e"]"
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		H.update_inv_l_hand()
		H.update_inv_r_hand()
		H.update_inv_belt()
	return

/obj/item/weapon/gun/projectile/automatic/tommygun
	name = "tommy gun"
	desc = "A genuine Chicago Typewriter."
	icon_state = "tommygun"
	item_state = "tommygun"
	slot_flags = 0
	origin_tech = "combat=5;materials=1;syndicate=2"
	mag_type = /obj/item/ammo_box/magazine/tommygunm45
	fire_sound = 'sound/weapons/Gunshot_smg.ogg'

/obj/item/weapon/gun/projectile/automatic/tommygun/isHandgun()
	return 0

/obj/item/weapon/gun/projectile/automatic/bar
	name = "Browning M1918"
	desc = "Browning Automatic Rifle."
	icon_state = "bar"
	item_state = "bar"
	w_class = 5.0
	origin_tech = "combat=5;materials=2"
	mag_type = /obj/item/ammo_box/magazine/m3006
	fire_sound = 'sound/weapons/gunshot3.wav'

/obj/item/weapon/gun/projectile/automatic/luger
	name = "Luger P08"
	desc = "A small, easily concealable gun. Uses 9mm rounds."
	icon_state = "p08"
	w_class = 2
	origin_tech = "combat=2;materials=2;syndicate=2"
	mag_type = /obj/item/ammo_box/magazine/m9pmm

/obj/item/weapon/gun/projectile/automatic/luger/update_icon()
	..()
	icon_state = "[initial(icon_state)][magazine ? "" : "-e"]"

/obj/item/weapon/gun/projectile/automatic/luger/isHandgun()
	return 1

/obj/item/weapon/gun/projectile/automatic/colt1911/dungeon
	desc = "A single-action, semi-automatic, magazine-fed, recoil-operated pistol chambered for the .45 ACP cartridge."
	name = "\improper Colt M1911"
	mag_type = /obj/item/ammo_box/magazine/c45m
	mag_type2 = /obj/item/ammo_box/magazine/c45r

/obj/item/weapon/gun/projectile/automatic/borg
	name = "Robot SMG"
	icon_state = "borg_smg"
	mag_type = /obj/item/ammo_box/magazine/borg45

/obj/item/weapon/gun/projectile/automatic/borg/update_icon()
	return

/obj/item/weapon/gun/projectile/automatic/borg/attack_self(mob/user)
	if (magazine)
		magazine.loc = get_turf(src.loc)
		magazine.update_icon()
		magazine = null
		to_chat(user, "<span class='notice'>You pull the magazine out of \the [src]!</span>")
	else
		to_chat(user, "<span class='notice'>There's no magazine in \the [src].</span>")
	return

/obj/item/weapon/gun/projectile/automatic/bulldog
	name = "V15 Bulldog shotgun"
	desc = "A compact, mag-fed semi-automatic shotgun for combat in narrow corridors. Compatible only with specialized magazines."
	icon_state = "bulldog"
	item_state = "bulldog"
	w_class = 3.0
	origin_tech = "combat=5;materials=4;syndicate=6"
	mag_type = /obj/item/ammo_box/magazine/m12g
	fire_sound = 'sound/weapons/Gunshot.ogg'

/obj/item/weapon/gun/projectile/automatic/bulldog/atom_init()
	. = ..()
	update_icon()

/obj/item/weapon/gun/projectile/automatic/bulldog/proc/update_magazine()
	if(magazine)
		src.overlays = 0
		overlays += "[magazine.icon_state]_o"
		return

/obj/item/weapon/gun/projectile/automatic/bulldog/update_icon()
	src.overlays = 0
	update_magazine()
	icon_state = "bulldog[chambered ? "" : "-e"]"
	return

/obj/item/weapon/gun/projectile/automatic/bulldog/afterattack(atom/target, mob/living/user, flag)
	..()
	if(!chambered && !get_ammo() && !alarmed)
		playsound(user, 'sound/weapons/smg_empty_alarm.ogg', 40, 1)
		update_icon()
		alarmed = 1
	return

/obj/item/weapon/gun/projectile/automatic/a28
	name = "A28 assault rifle"
	desc = ""
	icon_state = "a28"
	item_state = "a28"
	w_class = 3.0
	origin_tech = "combat=5;materials=4;syndicate=6"
	mag_type = /obj/item/ammo_box/magazine/m556
	fire_sound = 'sound/weapons/Gunshot.ogg'

/obj/item/weapon/gun/projectile/automatic/a28/atom_init()
	. = ..()
	update_icon()

/obj/item/weapon/gun/projectile/automatic/a28/update_icon()
	overlays.Cut()
	if(magazine)
		overlays += "[magazine.icon_state]-o"
	icon_state = "[initial(icon_state)][chambered ? "" : "-e"]"
	return

/obj/item/weapon/gun/projectile/automatic/a74
	name = "A74 assault rifle"
	desc = "Stradi and Practican Maid Bai Spess soviets corporation, bazed he original design of 20 centuriyu fin about baars and vodka vile patrimonial it, saunds of balalaika place minvile, yuzes 7.74 caliber"
	mag_type = /obj/item/ammo_box/magazine/a74mm
	w_class = 3.0
	icon_state = "a74"
	item_state = "a74"
	origin_tech = "combat=5;materials=4;syndicate=6"
	fire_sound = 'sound/weapons/guns/ak74_fire.ogg'
	var/icon/mag_icon = icon('icons/obj/gun.dmi',"mag-a74")

/obj/item/weapon/gun/projectile/automatic/a74/atom_init()
	. = ..()
	update_icon()

/obj/item/weapon/gun/projectile/automatic/a74/update_icon()
	overlays.Cut()
	if(magazine)
		overlays += mag_icon
		item_state = "[initial(icon_state)]"
	else
		item_state = "[initial(icon_state)]-e"

/obj/item/weapon/gun/projectile/automatic/a74/attack_self(mob/user)
	if(..())
		playsound(user, 'sound/weapons/guns/ak74_reload.ogg', 50, 1)
	update_icon()

/obj/item/weapon/gun/projectile/automatic/a74/attackby(obj/item/A, mob/user)
	if(..())
		playsound(user, 'sound/weapons/guns/ak74_reload.ogg', 50, 1)
	update_icon()

/obj/item/weapon/gun/projectile/automatic/type76
	name = "Type .76"
	desc = "Type 76 this is semi-automatic submachine gun that shoots 3 rounds per one shot. You've definitely seen this pretty one in some movie 'bout those Space-Vietnam wars. Pull the trigger, and become a narrow-eyed Solider!"
	icon_state = "type76"
	item_state = "type76"
	w_class = 3.0
	origin_tech = "combat=4;materials=2;"
	mag_type = /obj/item/ammo_box/magazine/type76_rubber
	fire_sound = 'sound/weapons/guns/type76_shot.ogg'
	burst_mode = TRUE
	burst_amount = 3
	burst_delay = 4


/obj/item/weapon/gun/projectile/automatic/type76/atom_init()
	. = ..()
	update_icon()

/obj/item/weapon/gun/projectile/automatic/type76/afterattack(atom/target, mob/living/user, flag)
	..()
	if(!chambered && !get_ammo() && !alarmed)
		playsound(user, 'sound/weapons/smg_empty_alarm.ogg', 40, 1)
		update_icon()
		alarmed = 1

/obj/item/weapon/gun/projectile/automatic/type76/update_icon()
	..()
	icon_state = "type76_[magazine ? "clip" : "empty"]"
	item_state = "type76_[magazine ? "clip" : "empty"]"
