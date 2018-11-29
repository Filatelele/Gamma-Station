/obj/item/weapon/gun/energy/gun/bison
	name = "E91 Bison"
	desc = "A soviet rare energy gun. It has two modes - stun and kill. Perfect for taking criminal scum down."
	icon_state = "bull"
	item_state = null	//so the human update icon uses the icon_state instead.
	ammo_type = list(/obj/item/ammo_casing/energy/stun, /obj/item/ammo_casing/energy/laser)
	origin_tech = "combat=4;magnets=3"
	modifystate = 2

/obj/item/weapon/gun/energy/gun/attack_self(mob/living/user)
	select_fire(user)
	update_icon()
	if(user.hand)
		user.update_inv_l_hand()
	else
		user.update_inv_r_hand()