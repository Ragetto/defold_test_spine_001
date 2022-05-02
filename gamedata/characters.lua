local M = {}
-------------------------------------------------------

M.CHAR = {}

---------============----------
----======= CHAR1 ========----- => "Rag" for now
---------============----------

M.CHAR[1] = {
	-- Gameplay
	id = 1,
	name = "Rag",
	speed_walk = 4,
	speed_dash = 15,
	punch_angle_added = 40,
	punch_speed_boost = 2,
	
	-- Animation
	timer_max_anim_idle = 0.038,
	timer_max_anim_walk = 0.03,
	timer_max_anim_punch = 0.03,
	timer_max_anim_dash = 0.03,
	timer_max_anim_block = 0.0075,

	nb_frames_anim_idle = 14,
	nb_frames_anim_walk = 20,
	nb_frames_anim_punch = 8,
	nb_frames_anim_dash = 6,
	nb_frames_anim_block = 12		
}

---------============----------
----======= CHAR2 ========----- => "Haki" for now
---------============----------

M.CHAR[2] = {
	-- Gameplay
	id = 2,
	name = "Haki",
	speed_walk = 6,
	speed_dash = 20,
	punch_angle_added = 30,
	punch_speed_boost = 1.5,

	-- Animation
	timer_max_anim_idle = 0.038,
	timer_max_anim_walk = 0.03,
	timer_max_anim_punch = 0.03,
	timer_max_anim_dash = 0.03,
	timer_max_anim_block = 0.0075,

	nb_frames_anim_idle = 14,
	nb_frames_anim_walk = 20,
	nb_frames_anim_punch = 8,
	nb_frames_anim_dash = 6,
	nb_frames_anim_block = 12		
}

---------============----------
----======= CHAR3 ========----- => "Jorgen" for now
---------============----------

M.CHAR[3] = {
	-- Gameplay
	id = 3,
	name = "Jorgen",
	speed_walk = 2,
	speed_dash = 10,
	punch_angle_added = 20,
	punch_speed_boost = 2.5,

	-- Animation
	timer_max_anim_idle = 0.038,
	timer_max_anim_walk = 0.03,
	timer_max_anim_punch = 0.03,
	timer_max_anim_dash = 0.03,
	timer_max_anim_block = 0.0075,

	nb_frames_anim_idle = 14,
	nb_frames_anim_walk = 20,
	nb_frames_anim_punch = 8,
	nb_frames_anim_dash = 6,
	nb_frames_anim_block = 12		
}

--]]

return M