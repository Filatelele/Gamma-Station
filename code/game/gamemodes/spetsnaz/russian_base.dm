var/global/list/spetsnaz_spawn_list = list()

/obj/effect/landmark/spetsnaz_spawn/atom_init()
	. = ..()
	return INITIALIZE_HINT_LATELOAD

/obj/effect/landmark/spetsnaz_spawn/atom_init_late()
	spetsnaz_spawn_list += src

/obj/effect/landmark/spetsnaz_spawn/Destroy()
	spetsnaz_spawn_list -= src
	return ..()

/obj/effect/landmark/spetsnaz_leader_spawn
	name = "Soetsnaz leader spawn"