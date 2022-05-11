local M = {}

M.item_id_cur = 0
M.item_type_cur = ""
M.item_slot_type_cur = ""

M.slots_updated = {}

M.switch_item = 0

-----------

-----------

M.slots = {}

M.slots[1] = {
	name = "head",
	image = "head",
	gui_btn = "btn_skin",
	id_min = 1,
	id_max = 3,
	id_cur = 1
}

M.slots[2] = {
	name = "arm_left",
	image = "hand_left",
	gui_btn = "btn_skin",
	id_min = 1,
	id_max = 3,
	id_cur = 1
}

M.slots[3] = {
	name = "arm_right",
	image = "hand_right",
	gui_btn = "btn_skin",
	id_min = 1,
	id_max = 3,
	id_cur = 1
}

M.slots[4] = {
	name = "hat",
	image = "hat",
	gui_btn = "btn_hat",
	id_min = 0,
	id_max = 8,
	id_cur = 0
}

M.slots[5] = {
	name = "body",
	image = "body",
	gui_btn = "btn_body",
	id_min = 1,
	id_max = 4,
	id_cur = 1
}

M.slots[6] = {
	name = "leg_left",
	image = "leg_left",
	gui_btn = "btn_legs",
	id_min = 1,
	id_max = 4,
	id_cur = 1
}

M.slots[7] = {
	name = "leg_right",
	image = "leg_right",
	gui_btn = "btn_legs",
	id_min = 1,
	id_max = 4,
	id_cur = 1
}

M.slots[8] = {
	name = "weapon_1h",
	image = "weapon_1h",
	gui_btn = "btn_weapon",
	id_min = 0,
	id_max = 10,
	id_cur = 0
}

M.slots[9] = {
	name = "shield",
	image = "shield",
	gui_btn = "btn_shield",
	id_min = 0,
	id_max = 7,
	id_cur = 0
}

return M