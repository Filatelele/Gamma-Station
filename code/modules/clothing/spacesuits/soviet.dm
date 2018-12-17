//Soviet piratez rigs. Turn on hardbass, my comradez!
/obj/item/clothing/head/helmet/space/rig/soviet
	name = "spec-ops helmet"
	desc = "VSR-98 helmet for special operations in space."
	icon_state = "rig-sovspec"
	armor = list(melee = 60, bullet = 35, laser = 60,energy = 60, bomb = 30, bio = 30, rad = 30, telepathy = 15)

/obj/item/clothing/head/helmet/space/rig/soviet/attack_self()
	return

/obj/item/clothing/suit/space/rig/soviet
	name = "spec-ops space suit"
	desc = "VSR-98 RIG for special operations in space."
	icon_state = "rig-sovspec"
	item_state = "rig-sovspec"
	armor = list(melee = 60, bullet = 35, laser = 60,energy = 60, bomb = 30, bio = 30, rad = 30, telepathy = 20)

/obj/item/clothing/head/helmet/space/rig/soviet/leader
	icon_state = "rig-sovlead"

/obj/item/clothing/suit/space/rig/soviet/leader
	icon_state = "rig-sovlead"
	item_state = "rig-sovlead"