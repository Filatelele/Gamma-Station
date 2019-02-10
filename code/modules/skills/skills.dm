/datum/skill
	var/name = "Skill name"
	var/ID
	var/desc = "Skil description"
	var/levels = list( 		"Unskilled"			= "Unskilled Description",
							"Basic"				= "Basic Description",
							"Trained"			= "Trained Description",
							"Experienced"		= "Experienced Description",
							"Master"			= "Professional Description")
	var/difficulty = SKILL_AVERAGE			// Used to compute how expensive the skill is
	var/default_max = SKILL_ADEPT			// Makes the skill capped at this value in selection unless overriden at job level.
	var/list/prerequisites = list()			// List of needed skills
	var/list/children = list()

/datum/skill/proc/get_cost(var/level)
	switch(level)
		if(SKILL_BASIC, SKILL_ADEPT)
			return difficulty
		if(SKILL_EXPERT, SKILL_PROF)
			return 2 * difficulty
		else
			return 0

/datum/skill/organizational
	name = "Organizational"
	ID = "organizational"
	difficulty = SKILL_EASY
	default_max = SKILL_MAX

/datum/skill/general
	name = "General"
	ID = "general"
	difficulty = SKILL_EASY
	default_max = SKILL_MAX

/datum/skill/service
	name = "Service"
	ID = "service"
	difficulty = SKILL_EASY
	default_max = SKILL_MAX

/datum/skill/security
	name = "Security"
	ID = "security"

/datum/skill/engineering
	name = "Engineering"
	ID = "engineering"

/datum/skill/research
	name = "Research"
	ID = "research"

/datum/skill/medical
	name = "Medical"
	ID = "medical"
	difficulty = SKILL_HARD