/datum/skillset
	var/mob/living/carbon/human/owner
	var/list/skill_list = list()

/datum/skillset/New(mob/mob)
	owner = mob

/datum/skillset/proc/get_skill_value(skill_path)
	return skill_list[skill_path]

/mob/living/carbon/human/proc/skill_check(skill_path, needed)
	var/points = skillset.get_skill_value(skill_path)
	return points >= needed

/mob/living/carbon/human/proc/skill_fail_chance(skill_path, fail_chance, no_more_fail = SKILL_MAX, factor = 1)
	world.log << "Skill fail chance"
	world.log << skill_path
	world.log << fail_chance
	var/points = skillset.get_skill_value(skill_path)
	if(points >= no_more_fail)
		world.log << "returning false"
		return FALSE
	else
		world.log << fail_chance * 2 * (factor*(SKILL_MIN - points))
		return prob(fail_chance * 2 * (factor*(SKILL_MIN - points)))

/datum/skillset/Destroy()
	owner = null
	QDEL_LIST(skill_list)
	return ..()

/mob/living/carbon/human
	var/datum/skillset/skillset