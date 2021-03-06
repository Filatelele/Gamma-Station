/obj/item/clothing/suit/storage
	var/obj/item/weapon/storage/internal/pockets

/obj/item/clothing/suit/storage/atom_init()
	. = ..()
	pockets = new/obj/item/weapon/storage/internal(src)
	pockets.set_slots(slots = 2, slot_size = 2) //two slots, fit only pocket sized items

/obj/item/clothing/suit/storage/Destroy()
	qdel(pockets)
	pockets = null
	return ..()

/obj/item/clothing/suit/storage/attack_hand(mob/user)
	if (pockets && pockets.handle_attack_hand(user))
		..(user)

/obj/item/clothing/suit/storage/MouseDrop(obj/over_object as obj)
	if (pockets && pockets.handle_mousedrop(usr, over_object))
		..(over_object)

/obj/item/clothing/suit/storage/attackby(obj/item/W, mob/user)
	..()
	if(pockets)
		pockets.attackby(W, user)

/obj/item/clothing/suit/storage/emp_act(severity)
	if(pockets)
		pockets.emp_act(severity)
	..()

/obj/item/clothing/suit/storage/hear_talk(mob/M, msg, verb, datum/language/speaking)
	if(pockets)
		pockets.hear_talk(M, msg, verb, speaking)
	..()
