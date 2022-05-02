local M = {}
-------------------------------------------------------


----------============---------
----====== FUNCTIONAL =====-----
----------============---------

M.G_DEBUG = 1 -- JC 24/01/2021 00:08 # 0/1 => debug text displayed or not

M.COLLECTION_CHAR_SELECTOR_NAME = "1.char_selector"
M.COLLECTION_GAMEPLAY_NAME = "2.gameplay"

M.CHARACTERS_QUANTITY = 3

----------============---------
----====== GAMEPLAY =====-----
----------============---------

-- UX
M.SCROLLING_MAX_NB_FRAMES = 3 -- JC 29/09/2021 21:02 # Used in the map scrolling (nb of frames recorded / inserted into a table)
M.SCROLLING_SENSIVITY = 0.75  -- from 0.5 to 1
M.SCROLLING_X = 1 -- 0: no / 1: yes
M.SCROLLING_Y = 1 -- 0: no / 1: yes

-- Camera
M.CAMERA_001 = "/camera_001"

----------============---------
-----====== MESSAGES =====-----
----------============---------

M.MSG_PLAYER_TO_BALL_PROPERTIES = hash("collided_player_param_to_ball")
M.MSG_PLAYER_TO_BALL_PUNCH = hash("perfect punch")

return M