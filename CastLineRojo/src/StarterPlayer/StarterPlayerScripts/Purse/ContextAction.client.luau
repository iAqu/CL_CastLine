--!strict

-- Modified copy of ryanlua/purse@1.1.6 (const -> local for tooling). See LICENSE.md.
-- Kept Disabled (see ContextAction.meta.json): TopbarIcon already binds Backquote
-- via bindToggleKey, so enabling this would double-bind the toggle.

local ContextActionService = game:GetService("ContextActionService")

local BackpackScript = require(script.Parent)

local ACTION_NAME = "BackpackToggle"

local function handleAction(actionName, inputState, _inputObject)
	if actionName == ACTION_NAME and inputState == Enum.UserInputState.Begin then
		if BackpackScript.OpenClose then
			BackpackScript.OpenClose()
		end
	end
end

ContextActionService:BindAction(ACTION_NAME, handleAction, false, Enum.KeyCode.Backquote)
