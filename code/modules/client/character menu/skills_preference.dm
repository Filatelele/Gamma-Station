/datum/preferences
	var/points_remaining
	var/list/preowned_skills

/datum/preferences/proc/edit_skills(mob/user, role)
	if(!islist(skill_by_job[role]))
		skill_by_job[role] = list()
	preowned_skills = get_preowned_skills(role)
	get_owned_cost(role)
	var/dat = "<html><body link='#045EBE' vlink='045EBE' alink='045EBE'><center>"
	dat += "<style type='text/css'><!--A{text-decoration:none}--></style>"
	dat += "<style type='text/css'>a.white, a.white:link, a.white:visited, a.white:active{color: #40628a;text-decoration: none;background: #ffffff;border: 1px solid #161616;padding: 1px;margin: 0 2px 0 0;cursor:default;}</style>"
	dat += "<style>body{background-image:url('dossier_empty_notext.png');background-color: #F5ECDD;background-repeat:no-repeat;background-position:center top;}</style>"
	dat += "<center><b>Skill selection: [role]</b><br>"
	dat += "<b> Skill points remaining: [points_remaining]</b></center>"
	dat += "<a href='?_src_=skills;preference=skills;task=reset'>Reset skills</a> &nbsp"
	dat += "<a href='?_src_=skills;preference=skills;task=close;text=[role]'>Close</a><hr>"
	dat += "<table bgcolor='#ffeef0' align='center' width='400px' cellspacing='0'>"
	dat += "<table  cellpadding='1' cellspacing='1'>"
	for(var/datum/skill/S in skill_categories)
		dat += "<tr style='text-align:center;'><td colspan = 5><b>[S.name]</b><hr></td></tr>"
		for(var/datum/skill/child in S.children)
			dat += "<tr style='text-align:left;'>"
			dat += "<td><a href='?_src_=skills;preference=skills;task=skill_info;skill_name=[child];text=[child.levels]'><font color=black>[child.name]</font></td>"
			var/skill_level = SKILL_NONE
			for(var/i in child.levels)
				if(skill_level == SKILL_NONE)
					dat += "</td><td><a href='?_src_=skills;preference=skills;task=select_skill;skill=[child.ID];rank=[role];text=[skill_level];cost=[child.get_cost(skill_level)]'><font color=#045EBE> [i] ([child.get_cost(skill_level)])</font></a> &nbsp"
				else if(skill_by_job[role][child.ID] && skill_by_job[role][child.ID] == skill_level)
					dat += "</td><td><font color=green>[i]</font></a> &nbsp"
				else if(preowned_skills[child.ID] == skill_level)
					dat += "</td><td><font color=green><i><b>[i]</font></a></i></b> &nbsp"
				else if(child.get_cost(skill_level) > points_remaining )
					dat += "</td><td>[i] ([child.get_cost(skill_level)]) &nbsp </a>"
				else if(skill_level == SKILL_NONE)
					dat += "</td><td><a href='?_src_=skills;preference=skills;task=select_skill;skill=[child.ID];rank=[role];text=[skill_level];cost=[child.get_cost(skill_level)]'><font color=#045EBE> [i] ([child.get_cost(skill_level)])</font></a> &nbsp"
				else
					dat += "</td><td><a href='?_src_=skills;preference=skills;task=select_skill;skill=[child.ID];rank=[role];text=[skill_level];cost=[child.get_cost(skill_level)]'>[i] ([child.get_cost(skill_level)])</a> &nbsp"
				skill_level ++
			dat += "</tr>"
	dat += "</table>"
	user << browse(entity_ja(dat), "window=skills;size=618x800;can_close=0;can_minimize=0;can_maximize=0;can_resize=0")

/datum/preferences/proc/get_owned_cost(role)
	var/datum/job/job = SSjob.GetJob(role)
	points_remaining = job.skill_points
	for(var/i in skill_by_job[role])
		var/datum/skill/skill = new i
		points_remaining -= skill.get_cost(skill_by_job[role][i])
		qdel(skill)

/datum/preferences/proc/get_preowned_skills(role)
	var/datum/job/job = SSjob.GetJob(role)
	var/list/skills = list()
	for(var/o in job.min_skill)
		skills[o] = job.min_skill[o]
	return skills

/datum/preferences/proc/process_link_skills(mob/user, list/href_list)
	if(href_list["preference"] != "skills")
		return
	switch(href_list["task"])
		if("reset")
			edit_skills(user, href_list["text"])
		if("close")
			user << browse(null, "window=skills")
		if("skill_info")
			show_skill_info(user, href_list["skill_name"], href_list["text"])
		if("select_skill")
			select_skill(user, href_list["skill"], href_list["rank"], href_list["text"],  href_list["cost"])

/datum/preferences/proc/show_skill_info(mob/user, skill_name, list/level_list)
	var/dat = "<html><body link='#045EBE' vlink='045EBE' alink='045EBE'><center>"
	dat += "<style type='text/css'><!--A{text-decoration:none}--></style>"
	dat += "<style type='text/css'>a.white, a.white:link, a.white:visited, a.white:active{color: #40628a;text-decoration: none;background: #ffffff;border: 1px solid #161616;padding: 1px 4px 1px 4px;margin: 0 2px 0 0;cursor:default;}</style>"
	dat += "<style>body{background-image:url('dossier_empty_notext.png');background-color: #F5ECDD;background-repeat:no-repeat;background-position:center top;}</style>"
	dat += "<body><center><b>[skill_name] info</b></center><hr>"
	for(var/i in level_list)
		dat += text("[level_list[i]]")
	dat += "</body>"
	user << browse(entity_ja(dat), "window=skills_info;size=350x350;can_close=1;can_minimize=0;can_maximize=0;can_resize=0")

/datum/preferences/proc/select_skill(mob/user, skill, rank, skill_level, skill_cost)
	if(!user || !rank || !skill || text2num(skill_cost) > points_remaining)
		return

	if(preowned_skills[skill] >= text2num(skill_level))
		return

	skill_by_job[rank][skill] = text2num(skill_level)
	points_by_job[rank] -= text2num(skill_cost)
	edit_skills(user, rank)