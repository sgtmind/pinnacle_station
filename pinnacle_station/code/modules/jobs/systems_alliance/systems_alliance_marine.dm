/datum/job/systems_alliance_marine
title = "Marine"
description = "A bog standard marine of the Systems Alliance."

	/// Innate skill levels unlocked at roundstart. Based on config.jobs_have_minimal_access config setting, for example with a skeleton crew. Format is list(/datum/skill/foo = SKILL_EXP_NOVICE) with exp as an integer or as per code/_DEFINES/skills.dm
	var/list/skills
	/// Innate skill levels unlocked at roundstart. Based on config.jobs_have_minimal_access config setting, for example with a full crew. Format is list(/datum/skill/foo = SKILL_EXP_NOVICE) with exp as an integer or as per code/_DEFINES/skills.dm
	var/list/minimal_skills

	/// Determines who can demote this position
	var/department_head = list()

	/// Tells the given channels that the given mob is the new department head. See communications.dm for valid channels.
	var/list/head_announce = null

	/// Bitflags for the job
	var/auto_deadmin_role_flags = NONE

	/// Players will be allowed to spawn in as jobs that are set to "Station"
	var/faction = FACTION_NONE

	/// How many players can be this job
	var/total_positions = 0

	/// How many players can spawn in as this job
	var/spawn_positions = 0

	/// How many players have this job
	var/current_positions = 0

	/// Supervisors, who this person answers to directly
	var/supervisors = ""

	/// Selection screen color
	var/selection_color = "#ffffff"

	/// What kind of mob type joining players with this job as their assigned role are spawned as.
	var/spawn_type = /mob/living/carbon/human

	/// If this is set to 1, a text is printed to the player when jobs are assigned, telling him that he should let admins know that he has to disconnect.
	var/req_admin_notify

	/// If you have the use_age_restriction_for_jobs config option enabled and the database set up, this option will add a requirement for players to be at least minimal_player_age days old. (meaning they first signed in at least that many days before.)
	var/minimal_player_age = 0

	var/outfit = null

	/// Minutes of experience-time required to play in this job. The type is determined by [exp_required_type] and [exp_required_type_department] depending on configs.
	var/exp_requirements = 0
	/// Experience required to play this job, if the config is enabled, and `exp_required_type_department` is not enabled with the proper config.
	var/exp_required_type = ""
	/// Department experience required to play this job, if the config is enabled.
	var/exp_required_type_department = ""
	/// Experience type granted by playing in this job.
	var/exp_granted_type = ""

	///How much money does this crew member make in a single paycheck? Note that passive paychecks are capped to PAYCHECK_CREW in regular gameplay after roundstart.
	var/paycheck = PAYCHECK_CREW
	///Which department does this paycheck pay from?
	var/paycheck_department = ACCOUNT_CIV

	/// Traits added to the mind of the mob assigned this job
	var/list/mind_traits

	///Lazylist of traits added to the liver of the mob assigned this job (used for the classic "cops heal from donuts" reaction, among others)
	var/list/liver_traits = null

	var/display_order = JOB_DISPLAY_ORDER_DEFAULT

	///What types of bounty tasks can this job recieve past the default?
	var/bounty_types = CIV_JOB_BASIC

	/// Goodies that can be received via the mail system.
	// this is a weighted list.
	/// Keep the _job definition for this empty and use /obj/item/mail to define general gifts.
	var/list/mail_goodies = list()

	/// If this job's mail goodies compete with generic goodies.
	var/exclusive_mail_goodies = FALSE

	/// Bitfield of departments this job belongs to. These get setup when adding the job into the department, on job datum creation.
	var/departments_bitflags = NONE

	/// If specified, this department will be used for the preferences menu.
	var/datum/job_department/department_for_prefs = null

	/// Lazy list with the departments this job belongs to.
	/// Required to be set for playable jobs.
	/// The first department will be used in the preferences menu,
	/// unless department_for_prefs is set.
	var/list/departments_list = null

	/// Should this job be allowed to be picked for the bureaucratic error event?
	var/allow_bureaucratic_error = TRUE

	///Is this job affected by weird spawns like the ones from station traits
	var/random_spawns_possible = TRUE

	/// List of family heirlooms this job can get with the family heirloom quirk. List of types.
	var/list/family_heirlooms

	/// All values = (JOB_ANNOUNCE_ARRIVAL | JOB_CREW_MANIFEST | JOB_EQUIP_RANK | JOB_CREW_MEMBER | JOB_NEW_PLAYER_JOINABLE | JOB_BOLD_SELECT_TEXT | JOB_ASSIGN_QUIRKS | JOB_CAN_BE_INTERN)
	var/job_flags = NONE

	/// Multiplier for general usage of the voice of god.
	var/voice_of_god_power = 1
	/// Multiplier for the silence command of the voice of god.
	var/voice_of_god_silence_power = 1

	/// String. If set to a non-empty one, it will be the key for the policy text value to show this role on spawn.
	var/policy_index = ""

	///RPG job names, for the memes
	var/rpg_title

	/// Does this job ignore human authority?
	var/ignore_human_authority = FALSE