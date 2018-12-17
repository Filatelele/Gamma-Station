/datum/game_mode
	var/list/tachankas = list()

/datum/game_mode/spetsnaz
	name = "spetsnaz"
	config_tag = "spetsnaz"
	role_type = ROLE_SPETSNAZ
	required_players = 1
	required_players_secret = 1
	required_enemies = 1
	recommended_enemies = 5
	restricted_jobs = list("Star Vigil Officer", "Star Vigil Sergeant", "Star Vigil Commander", "AI", "Cyborg","Captain", "Head of Personnel", "Head of Security", "Chief Engineer", "Research Director", "Chief Medical Officer")
	votable = 0

	var/list/raid_objectives = list()     //Raid objectives.
	var/list/tachanka_names = list()
	var/list/tachanka_surnames = list()

/datum/game_mode/spetsnaz/announce()
	to_chat(world, "<B>The current game mode is - Soviet Raid!</B>")
	to_chat(world, "<B>Soviet spetsnaz is approaching [station_name()]!</B>")

/datum/game_mode/nuclear/can_start()
	if(!..())
		return 0

	var/agent_number = 0

	var/n_players = num_players()
	agent_number = Clamp((n_players/5), 2, 6)

	if(antag_candidates.len < agent_number)
		agent_number = antag_candidates.len

	while(agent_number > 0)
		var/datum/mind/new_soviet = pick(antag_candidates)
		tachankas += new_soviet
		antag_candidates -= new_soviet
		agent_number--

	for(var/datum/mind/synd_mind in syndicates)
		synd_mind.assigned_role = "MODE"
		synd_mind.special_role = "Soviet Spetsnaz"
	return 1

/datum/game_mode/spetsnaz/pre_setup()
	return 1

///////////////////////////////////////
//HANDLE ICONS
///////////////////////////////////////

/datum/game_mode/proc/update_all_spetsnaz_icons()
	for(var/datum/mind/tachanka in tachankas)
		if(!tachanka.current || !tachanka.current.client)
			continue
		for(var/image/I in tachanka.current.client.images)
			if(I.icon_state == "soviet")
				qdel(I)

	for(var/datum/mind/tachanka in tachankas)
		if(!tachanka.current || !tachanka.current.client)
			continue
		for(var/datum/mind/tachanka2 in tachankas)
			if(tachanka2.current)
				var/I = image('icons/mob/mob.dmi', loc = tachanka2.current, icon_state = "soviet")
				tachanka.current.client.images += I

/datum/game_mode/proc/update_spetsnaz_icons_added(datum/mind/tachanka)
	if(tachanka.current && tachanka.current.client)
		var/I = image('icons/mob/mob.dmi', loc = tachanka.current, icon_state = "soviet")
		tachanka.current.client.images += I

	for(var/datum/mind/tachanka2 in tachankas)
		if(!tachanka2.current || !tachanka2.current.client)
			continue
		var/I = image('icons/mob/mob.dmi', loc = tachanka.current, icon_state = "soviet")
		tachanka2.current.client.images += I

/datum/game_mode/proc/update_spetsnaz_icons_removed(datum/mind/tachanka)
	for(var/datum/mind/tachanka2 in tachankas)
		if(!tachanka2.current || !tachanka2.current.client)
			continue
		for(var/image/I in tachanka2.current.client.images)
			if(I.icon_state == "soviet" && I.loc == tachanka.current)
				qdel(I)

	if(!tachanka.current || !tachanka.current.client)
		return
	for(var/image/I in tachanka.current.client.images)
		if(I.icon_state == "soviet")
			qdel(I)

///////////////////////////////////////
///////////////////////////////////////

/datum/game_mode/spetsnaz/post_setup()

	var/list/turf/spets_spawn = list()

	for(var/obj/effect/landmark/A in landmarks_list)
		if(A.name == "Spetsnaz-Spawn")
			spets_spawn += get_turf(A)
			qdel(A)
			continue

	var/spawnpos = 1

	var/highest_player_age
	var/client/leader_client
	for(var/datum/mind/tachanka in tachankas)
		if(!tachanka.current || !tachanka.current.client)
			continue
		if(tachanka.current.client.player_ingame_age > highest_player_age)
			highest_player_age = tachanka.current.client.player_ingame_age
			leader_client = tachanka.current.client

	leader_client.mob.faction = "soviets"
	//prepare_tachanka_leader(leader_client)
	greet_tachanka(leader_client.mob, FALSE, TRUE)
	equip_tachanka(leader_client.mob, TRUE)

	for(var/datum/mind/tachanka in tachankas)
		if(tachanka == leader_client.mob.mind)
			continue
		//THERE ARE ONLY HUMANS IN SOVIET UNION! NO XENOS ALLOWED, COMRADEZ!
		tachanka.current.faction = "soviets"
		greet_tachanka(tachanka)
		equip_tachanka(tachanka.current)
		tachanka.current.loc = spets_spawn[spawnpos]

		if(!config.objectives_disabled)
			forge_syndicate_objectives(tachanka)

		spawnpos++

	update_all_spetsnaz_icons()

	return ..()

/datum/game_mode/proc/equip_tachanka(mob/living/carbon/human/tachanka, leader)

	var/obj/item/device/radio/R = new /obj/item/device/radio/headset/syndicate(tachanka)
	R.set_frequency(SYND_FREQ) //Same frequency as the syndicate team in Nuke mode.
	tachanka.equip_to_slot_or_del(R, slot_l_ear)

	tachanka.equip_to_slot_or_del(new /obj/item/clothing/under/syndicate(tachanka), slot_w_uniform)
	tachanka.equip_to_slot_or_del(new /obj/item/clothing/shoes/combat(tachanka), slot_shoes)
	tachanka.equip_to_slot_or_del(new /obj/item/device/price_tool(tachanka), slot_l_store)
	tachanka.equip_to_slot_or_del(new /obj/item/device/flashlight(tachanka), slot_r_store)
	if(tachanka.backbag == 2)
		tachanka.equip_to_slot_or_del(new /obj/item/weapon/storage/backpack(tachanka), slot_back)
	if(tachanka.backbag == 3)
		tachanka.equip_to_slot_or_del(new /obj/item/weapon/storage/backpack/satchel/norm(tachanka), slot_back)
	if(tachanka.backbag == 4)
		tachanka.equip_to_slot_or_del(new /obj/item/weapon/storage/backpack/satchel(tachanka), slot_back)

	if(leader)//GRU OFFICER IN COMMAND
		tachanka.equip_to_slot_or_del(new /obj/item/weapon/extraction_pack(tachanka), slot_l_hand)

	return 1

/datum/game_mode/proc/greet_tachanka(mob/living/carbon/human/tachanka, leader)
