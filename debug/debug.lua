local M = {}

-- enable/disable debug stuff
M.enable_all = 1
M.enable_input = 1

-- performances
M.fps = 0

-- 
M.width = 0
M.height = 0
M.window_width = 0
M.window_height = 0

-- input
M.pos_mouse_w = vmath.vector3()
M.pos_mouse_s = vmath.vector3()
M.pos_cursor = vmath.vector3()

return M