---========================---
---== LUA MODULE IMPORTS ==---
---========================---
local debugdraw = require("extensions.defold.debug-draw.debug-draw")
local defmath = require("extensions.defold.defmath.defmath")
local lume = require("extensions.external.lume.lume")
local c = require("gamedata.constants")
local color1 = require("extensions.external.color-converter.convertcolor")

----------------------------------------------------------------

---================================---
-----=== GENERIC LUA FUNCTIONS ===----
---================================---

-- Return length of a LUA table (nb of entries)
function tablelength(table)
	local count = 0
	for _ in pairs(table) do count = count + 1 end
	return count
end

function emptytable(table)
	for k,v in pairs(table) do table[k]=nil end
end

-- Split a string (using a separator, ex: "|") and insert the pieces into a table
function mysplit (inputstr, sep)
	if sep == nil then
		sep = "%s"
	end
	local t={}
	for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
		table.insert(t, str)
	end
	return t
end

function math.average(t)
	local sum = 0
	for _,v in pairs(t) do -- Get the sum of all numbers in t
		sum = sum + v
	end
	return sum / #t
end

function average_table_vector3(table)
	local max = tablelength(table)
	local sum_x = 0
	local sum_y = 0
	local sum_z = 0
	local avg_x = 0
	local avg_y = 0
	local avg_z = 0

	for i=1,max do
		sum_x = sum_x + table[i].x
		sum_y = sum_y + table[i].y
		sum_z = sum_z + table[i].z
	end

	if max == 0 then
		avg_x = 0
		avg_y = 0
		avg_z = 0		
	else
		avg_x = sum_x / max
		avg_y = sum_y / max
		avg_z = sum_z / max
	end

	return avg_x,avg_y,avg_z

end


---========================---
-----=== GUI FUNCTIONS ===----
---========================---

function gui_button_state(node_img, node_txt, button_id, state_target)
	-- Image
	local node = gui.get_node(node_img) -- node_img => the button shape
	gui.set_texture(node, "gui") -- texture = atlas in this case
	gui.play_flipbook(node, button_id.."_state"..state_target) -- button_id => 001 (standard), 002, 003 etc.
	-- Text outline
	local node = gui.get_node(node_txt) -- node_img => the main text written on the button (ex: "PLAY")
	local R,G,B,A = 0,0,0,0
	if state_target == 0 then
		R,G,B,A = 100,100,100,1
	elseif state_target == 1 then
		R,G,B,A = 0,51,0,1
	end
	local color = vmath.vector4(R/255, G/255, B/255, A)
	gui.set_outline(node,color)
end


function gui_node2node_position(node2move_id, target_node_id)
	-- based on this: https://forum.defold.com/t/gui-set-screen-position-and-gui-screen-pos-to-node-pos/47365
	-- get screen position of the node
	local node = gui.get_node(target_node_id)
	local screen_pos_TEST = gui.get_screen_position(node)

	-- set screen position for another node
	local node = gui.get_node(node2move_id)	
	gui.set_screen_position(node, screen_pos_TEST)
end

function gui_color_text(node_id, text_color, outline_color)
	local node = gui.get_node(node_id)
	gui.set_color(node, text_color)
	gui.set_outline(node, outline_color)
end


---========================---
----=== TEST FUNCTIONS ===----
---========================---

function addition(param1,param2)  -- JC 16/01/2021 19:21 # Just a quick test to see how to import functions from external modules
	local result = param1 + param2
	return result
end


---========================---
---=== DEBUG FUNCTIONS ===----
---========================---

function DEBUGdrawsquare(center_x,center_y,square_width,square_height,color)
	debugdraw.line(center_x-square_width/2, center_y+square_height/2, center_x+square_width/2, center_y+square_height/2, color)
	debugdraw.line(center_x-square_width/2, center_y-square_height/2, center_x+square_width/2, center_y-square_height/2, color)
	debugdraw.line(center_x+square_width/2, center_y+square_height/2, center_x+square_width/2, center_y-square_height/2, color)
	debugdraw.line(center_x-square_width/2, center_y+square_height/2, center_x-square_width/2, center_y-square_height/2, color)
end