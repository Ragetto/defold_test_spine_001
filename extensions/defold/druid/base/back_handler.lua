--- Component to handle back key (android, backspace)
-- @module BackHandler
-- @within BaseComponent
-- @alias druid.back_handler

--- On back handler callback(self, params)
-- @tfield druid_event on_back

--- Params to back callback
-- @tfield any params

---

local Event = require("lua-modules.libs-defold.druid.event")
local const = require("lua-modules.libs-defold.druid.const")
local component = require("lua-modules.libs-defold.druid.component")

local BackHandler = component.create("back_handler", { component.ON_INPUT })


--- Component init function
-- @tparam BackHandler self
-- @tparam callback callback On back button
-- @tparam[opt] any params Callback argument
function BackHandler.init(self, callback, params)
	self.params = params
	self.on_back = Event(callback)
end


--- Input handler for component
-- @tparam BackHandler self
-- @tparam string action_id on_input action id
-- @tparam table action on_input action
function BackHandler.on_input(self, action_id, action)
	if not action[const.RELEASED] then
		return false
	end

	if action_id == const.ACTION_BACK or action_id == const.ACTION_BACKSPACE then
		self.on_back:trigger(self:get_context(), self.params)
		return true
	end

	return false
end


return BackHandler
