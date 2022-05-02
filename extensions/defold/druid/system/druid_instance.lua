--- Instance of Druid. Make one instance per gui_script with next code:
--
--    local druid = require("druid.druid")
--    function init(self)
--        self.druid = druid.new(self)
--        local button = self.druid:new_button(...)
--    end
--
-- Learn Druid instance function here
-- @module DruidInstance
-- @alias druid_instance
-- @see Button
-- @see Blocker
-- @see BackHandler
-- @see Input
-- @see Text
-- @see LangText
-- @see Timer
-- @see Progress
-- @see StaticGrid
-- @see DynamicGrid
-- @see Scroll
-- @see Slider
-- @see Checkbox
-- @see CheckboxGroup
-- @see RadioGroup
-- @see Swipe
-- @see Drag
-- @see DataList
-- @see Hover

local helper = require("lua-modules.libs-defold.druid.helper")
local class = require("lua-modules.libs-defold.druid.system.middleclass")
local settings = require("lua-modules.libs-defold.druid.system.settings")
local base_component = require("lua-modules.libs-defold.druid.component")
local druid_input = require("lua-modules.libs-defold.druid.helper.druid_input")

local back_handler = require("lua-modules.libs-defold.druid.base.back_handler")
local blocker = require("lua-modules.libs-defold.druid.base.blocker")
local button = require("lua-modules.libs-defold.druid.base.button")
local drag = require("lua-modules.libs-defold.druid.base.drag")
local hover = require("lua-modules.libs-defold.druid.base.hover")
local scroll = require("lua-modules.libs-defold.druid.base.scroll")
local static_grid = require("lua-modules.libs-defold.druid.base.static_grid")
local swipe = require("lua-modules.libs-defold.druid.base.swipe")
local text = require("lua-modules.libs-defold.druid.base.text")

local checkbox = require("lua-modules.libs-defold.druid.extended.checkbox")
local checkbox_group = require("lua-modules.libs-defold.druid.extended.checkbox_group")
local dynamic_grid = require("lua-modules.libs-defold.druid.extended.dynamic_grid")
local input = require("lua-modules.libs-defold.druid.extended.input")
local lang_text = require("lua-modules.libs-defold.druid.extended.lang_text")
local progress = require("lua-modules.libs-defold.druid.extended.progress")
local radio_group = require("lua-modules.libs-defold.druid.extended.radio_group")
local slider = require("lua-modules.libs-defold.druid.extended.slider")
local timer = require("lua-modules.libs-defold.druid.extended.timer")
local data_list = require("lua-modules.libs-defold.druid.extended.data_list")


local DruidInstance = class("lua-modules.libs-defold.druid.druid_instance")


local function input_init(self)
	if sys.get_config("druid.no_auto_input") == "1" then
		return
	end

	if not self.input_inited then
		self.input_inited = true
		druid_input.focus()
	end
end


local function input_release(self)
	if sys.get_config("druid.no_auto_input") == "1" then
		return
	end

	if self.input_inited then
		self.input_inited = false
		druid_input.remove()
	end
end


local function sort_input_stack(self)
	local input_components = self.components[base_component.ON_INPUT]
	if not input_components then
		return
	end

	table.sort(input_components, function(a, b)
		if a:get_input_priority() ~= b:get_input_priority() then
			return a:get_input_priority() < b:get_input_priority()
		end

		return a:get_uid() < b:get_uid()
	end)
end


-- Create the component itself
local function create(self, instance_class)
	local instance = instance_class()
	instance:setup_component(self, self._context, self._style)

	table.insert(self.components[base_component.ALL], instance)

	local register_to = instance:__get_interests()
	for i = 1, #register_to do
		local interest = register_to[i]
		table.insert(self.components[interest], instance)

		if base_component.UI_INPUT[interest] then
			input_init(self)
		end
	end

	return instance
end


local function check_sort_input_stack(self, components)
	if not components or #components == 0 then
		return
	end

	local is_need_sort_input_stack = false

	for i = #components, 1, -1 do
		local component = components[i]
		if component:_is_input_priority_changed() then
			is_need_sort_input_stack = true
		end
		component:_reset_input_priority_changed()
	end

	if is_need_sort_input_stack then
		sort_input_stack(self)
	end
end


local function process_input(action_id, action, components, is_input_consumed)
	if #components == 0 then
		return is_input_consumed
	end

	for i = #components, 1, -1 do
		local component = components[i]
		local meta = component._meta
		if meta.input_enabled then
			if not is_input_consumed then
				is_input_consumed = component:on_input(action_id, action)
			else
				if component.on_input_interrupt then
					component:on_input_interrupt()
				end
			end
		end
	end

	return is_input_consumed
end


--- Druid class constructor
-- @tparam DruidInstance self
-- @tparam table context Druid context. Usually it is self of script
-- @tparam table style Druid style module
function DruidInstance.initialize(self, context, style)
	self._context = context
	self._style = style or settings.default_style
	self._deleted = false
	self._is_input_processing = false
	self._late_remove = {}
	self.url = msg.url()

	self.components = {}
	for i = 1, #base_component.ALL_INTERESTS do
		self.components[base_component.ALL_INTERESTS[i]] = {}
	end
end


--- Create new druid component
-- @tparam DruidInstance self
-- @tparam Component component Component module
-- @tparam args ... Other component params to pass it to component:init function
-- @local
function DruidInstance.create(self, component, ...)
	helper.deprecated("The druid:create is deprecated. Please use druid:new instead")

	local instance = create(self, component)

	if instance.init then
		instance:init(...)
	end

	return instance
end


--- Create new druid component
-- @tparam DruidInstance self
-- @tparam Component component Component module
-- @tparam args ... Other component params to pass it to component:init function
function DruidInstance.new(self, component, ...)
	local instance = create(self, component)

	if instance.init then
		instance:init(...)
	end

	return instance
end


--- Call on final function on gui_script. It will call on_remove
-- on all druid components
-- @tparam DruidInstance self
function DruidInstance.final(self)
	local components = self.components[base_component.ALL]

	for i = #components, 1, -1 do
		if components[i].on_remove then
			components[i]:on_remove()
		end
	end

	self._deleted = true

	input_release(self)
end


--- Remove component from druid instance.
-- Component `on_remove` function will be invoked, if exist.
-- @tparam DruidInstance self
-- @tparam Component component Component instance
function DruidInstance.remove(self, component)
	if self._is_input_processing then
		table.insert(self._late_remove, component)
		return
	end

	-- Recursive remove all children of component
	local children = component._meta.children
	for i = #children, 1, -1 do
		self:remove(children[i])
		local parent = children[i]:get_parent_component()
		if parent then
			parent:__remove_children(children[i])
		end
	end
	component._meta.children = {}

	local all_components = self.components[base_component.ALL]
	for i = #all_components, 1, -1 do
		if all_components[i] == component then
			if component.on_remove then
				component:on_remove()
			end
			table.remove(all_components, i)
		end
	end

	local interests = component:__get_interests()
	for i = 1, #interests do
		local interest = interests[i]
		local components = self.components[interest]
		for j = #components, 1, -1 do
			if components[j] == component then
				table.remove(components, j)
			end
		end
	end
end


--- Druid update function
-- @tparam DruidInstance self
-- @tparam number dt Delta time
function DruidInstance.update(self, dt)
	local components = self.components[base_component.ON_UPDATE]
	for i = 1, #components do
		components[i]:update(dt)
	end
end


--- Druid on_input function
-- @tparam DruidInstance self
-- @tparam hash action_id Action_id from on_input
-- @tparam table action Action from on_input
function DruidInstance.on_input(self, action_id, action)
	self._is_input_processing = true

	local is_input_consumed = false
	local components = self.components[base_component.ON_INPUT]
	check_sort_input_stack(self, components)
	is_input_consumed = process_input(action_id, action, components, is_input_consumed)

	self._is_input_processing = false

	if #self._late_remove > 0 then
		for i = 1, #self._late_remove do
			self:remove(self._late_remove[i])
		end
		self._late_remove = {}
	end

	return is_input_consumed
end


--- Druid on_message function
-- @tparam DruidInstance self
-- @tparam hash message_id Message_id from on_message
-- @tparam table message Message from on_message
-- @tparam hash sender Sender from on_message
function DruidInstance.on_message(self, message_id, message, sender)
	local specific_ui_message = base_component.SPECIFIC_UI_MESSAGES[message_id]

	if specific_ui_message then
		local components = self.components[message_id]
		if components then
			for i = 1, #components do
				local component = components[i]
				component[specific_ui_message](component, message, sender)
			end
		end
	else
		local components = self.components[base_component.ON_MESSAGE]
		for i = 1, #components do
			components[i]:on_message(message_id, message, sender)
		end
	end
end


--- Druid on focus lost interest function.
-- This one called by on_window_callback by global window listener
-- @tparam DruidInstance self
function DruidInstance.on_focus_lost(self)
	local components = self.components[base_component.ON_FOCUS_LOST]
	for i = 1, #components do
		components[i]:on_focus_lost()
	end
end


--- Druid on focus gained interest function.
-- This one called by on_window_callback by global window listener
-- @tparam DruidInstance self
function DruidInstance.on_focus_gained(self)
	local components = self.components[base_component.ON_FOCUS_GAINED]
	for i = 1, #components do
		components[i]:on_focus_gained()
	end
end


--- Druid on layout change function.
-- Called on update gui layout
-- @tparam DruidInstance self
function DruidInstance.on_layout_change(self)
	local components = self.components[base_component.ON_LAYOUT_CHANGE]
	for i = 1, #components do
		components[i]:on_layout_change()
	end
end


--- Druid on language change.
-- This one called by global gruid.on_language_change, but can be
-- call manualy to update all translations
-- @function druid.on_language_change
function DruidInstance.on_language_change(self)
	local components = self.components[base_component.ON_LANGUAGE_CHANGE]
	for i = 1, #components do
		components[i]:on_language_change()
	end
end


--- Create button basic component
-- @tparam DruidInstance self
-- @tparam node node Gui node
-- @tparam function callback Button callback
-- @tparam[opt] table params Button callback params
-- @tparam[opt] node anim_node Button anim node (node, if not provided)
-- @treturn Button button component
function DruidInstance.new_button(self, node, callback, params, anim_node)
	return DruidInstance.new(self, button, node, callback, params, anim_node)
end


--- Create blocker basic component
-- @tparam DruidInstance self
-- @tparam node node Gui node
-- @treturn Blocker blocker component
function DruidInstance.new_blocker(self, node)
	return DruidInstance.new(self, blocker, node)
end


--- Create back_handler basic component
-- @tparam DruidInstance self
-- @tparam callback callback On back button
-- @tparam[opt] any params Callback argument
-- @treturn BackHandler back_handler component
function DruidInstance.new_back_handler(self, callback, params)
	return DruidInstance.new(self, back_handler, callback, params)
end


--- Create hover basic component
-- @tparam DruidInstance self
-- @tparam node node Gui node
-- @tparam function on_hover_callback Hover callback
-- @treturn Hover hover component
function DruidInstance.new_hover(self, node, on_hover_callback)
	return DruidInstance.new(self, hover, node, on_hover_callback)
end


--- Create text basic component
-- @tparam DruidInstance self
-- @tparam node node Gui text node
-- @tparam[opt] string value Initial text. Default value is node text from GUI scene.
-- @tparam[opt] bool no_adjust If true, text will be not auto-adjust size
-- @treturn Tet text component
function DruidInstance.new_text(self, node, value, no_adjust)
	return DruidInstance.new(self, text, node, value, no_adjust)
end


--- Create grid basic component
-- Deprecated
-- @tparam DruidInstance self
-- @tparam node parent The gui node parent, where items will be placed
-- @tparam node element Element prefab. Need to get it size
-- @tparam[opt=1] number in_row How many nodes in row can be placed
-- @treturn StaticGrid grid component
function DruidInstance.new_grid(self, parent, element, in_row)
	helper.deprecated("The druid:new_grid is deprecated. Please use druid:new_static_grid instead")
	return DruidInstance.new(self, static_grid, parent, element, in_row)
end


--- Create static grid basic component
-- @tparam DruidInstance self
-- @tparam node parent The gui node parent, where items will be placed
-- @tparam node element Element prefab. Need to get it size
-- @tparam[opt=1] number in_row How many nodes in row can be placed
-- @treturn StaticGrid grid component
function DruidInstance.new_static_grid(self, parent, element, in_row)
	return DruidInstance.new(self, static_grid, parent, element, in_row)
end


--- Create scroll basic component
-- @tparam DruidInstance self
-- @tparam node view_node GUI view scroll node
-- @tparam node content_node GUI content scroll node
-- @treturn Scroll scroll component
function DruidInstance.new_scroll(self, view_node, content_node)
	return DruidInstance.new(self, scroll, view_node, content_node)
end


--- Create swipe basic component
-- @tparam DruidInstance self
-- @tparam node node Gui node
-- @tparam function on_swipe_callback Swipe callback for on_swipe_end event
-- @treturn Swipe swipe component
function DruidInstance.new_swipe(self, node, on_swipe_callback)
	return DruidInstance.new(self, swipe, node, on_swipe_callback)
end


--- Create drag basic component
-- @tparam DruidInstance self
-- @tparam node node GUI node to detect dragging
-- @tparam function on_drag_callback Callback for on_drag_event(self, dx, dy)
-- @treturn Drag drag component
function DruidInstance.new_drag(self, node, on_drag_callback)
	return DruidInstance.new(self, drag, node, on_drag_callback)
end


--- Create dynamic grid component
-- @tparam DruidInstance self
-- @tparam node parent The gui node parent, where items will be placed
-- @treturn DynamicGrid grid component
function DruidInstance.new_dynamic_grid(self, parent)
	-- return helper.extended_component("dynamic_grid")
	return DruidInstance.new(self, dynamic_grid, parent)
end


--- Create lang_text component
-- @tparam DruidInstance self
-- @tparam node node The text node
-- @tparam string locale_id Default locale id
-- @tparam bool no_adjust If true, will not correct text size
-- @treturn LangText lang_text component
function DruidInstance.new_lang_text(self, node, locale_id, no_adjust)
		-- return helper.extended_component("lang_text")
	return DruidInstance.new(self, lang_text, node, locale_id, no_adjust)
end


--- Create slider component
-- @tparam DruidInstance self
-- @tparam node node Gui pin node
-- @tparam vector3 end_pos The end position of slider
-- @tparam[opt] function callback On slider change callback
-- @treturn Slider slider component
function DruidInstance.new_slider(self, node, end_pos, callback)
	-- return helper.extended_component("slider")
	return DruidInstance.new(self, slider, node, end_pos, callback)
end


--- Create checkbox component
-- @tparam DruidInstance self
-- @tparam node node Gui node
-- @tparam function callback Checkbox callback
-- @tparam[opt=node] node click_node Trigger node, by default equals to node
-- @treturn Checkbox checkbox component
function DruidInstance.new_checkbox(self, node, callback, click_node)
	-- return helper.extended_component("checkbox")
	return DruidInstance.new(self, checkbox, node, callback, click_node)
end


--- Create input component
-- @tparam DruidInstance self
-- @tparam node click_node Button node to enabled input component
-- @tparam node text_node Text node what will be changed on user input
-- @tparam[opt] number keyboard_type Gui keyboard type for input field
-- @treturn Input input component
function DruidInstance.new_input(self, click_node, text_node, keyboard_type)
	-- return helper.extended_component("input")
	return DruidInstance.new(self, input, click_node, text_node, keyboard_type)
end


--- Create checkbox_group component
-- @tparam DruidInstance self
-- @tparam node[] nodes Array of gui node
-- @tparam function callback Checkbox callback
-- @tparam[opt=node] node[] click_nodes Array of trigger nodes, by default equals to nodes
-- @treturn CheckboxGroup checkbox_group component
function DruidInstance.new_checkbox_group(self, nodes, callback, click_nodes)
	-- return helper.extended_component("checkbox_group")
	return DruidInstance.new(self, checkbox_group, nodes, callback, click_nodes)
end


--- Create data list basic component
-- @function druid:new_data_list
-- @tparam druid.scroll druid_scroll The Scroll instance for Data List component
-- @tparam druid.grid druid_grid The Grid instance for Data List component
-- @tparam function create_function The create function callback(self, data, index, data_list). Function should return (node, [component])
-- @treturn DataList data_list component
function DruidInstance.new_data_list(self, druid_scroll, druid_grid, create_function)
	-- return helper.extended_component("data_list")
	return DruidInstance.new(self, data_list, druid_scroll, druid_grid, create_function)
end


--- Create radio_group component
-- @tparam DruidInstance self
-- @tparam node[] nodes Array of gui node
-- @tparam function callback Radio callback
-- @tparam[opt=node] node[] click_nodes Array of trigger nodes, by default equals to nodes
-- @treturn RadioGroup radio_group component
function DruidInstance.new_radio_group(self, nodes, callback, click_nodes)
	-- return helper.extended_component("radio_group")
	return DruidInstance.new(self, radio_group, nodes, callback, click_nodes)
end


--- Create timer component
-- @tparam DruidInstance self
-- @tparam node node Gui text node
-- @tparam number seconds_from Start timer value in seconds
-- @tparam[opt=0] number seconds_to End timer value in seconds
-- @tparam[opt] function callback Function on timer end
-- @treturn Timer timer component
function DruidInstance.new_timer(self, node, seconds_from, seconds_to, callback)
	-- return helper.extended_component("timer")
	return DruidInstance.new(self, timer, node, seconds_from, seconds_to, callback)
end


--- Create progress component
-- @tparam DruidInstance self
-- @tparam string|node node Progress bar fill node or node name
-- @tparam string key Progress bar direction: const.SIDE.X or const.SIDE.Y
-- @tparam[opt=1] number init_value Initial value of progress bar
-- @treturn Progress progress component
function DruidInstance.new_progress(self, node, key, init_value)
	-- return helper.extended_component("progress")
	return DruidInstance.new(self, progress, node, key, init_value)
end


return DruidInstance
