-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:24:03
-- Luau version 6, Types version 3
-- Time taken: 0.002262 seconds

local any_load_result1 = require(script.Parent.loader).load(script)
local UserInputService_upvr = game:GetService("UserInputService")
local var1_result1_upvr_2 = any_load_result1("BaseObject")
local setmetatable_result1_upvr = setmetatable({}, var1_result1_upvr_2)
setmetatable_result1_upvr.ClassName = "ResizeOnInputTracker"
setmetatable_result1_upvr.__index = setmetatable_result1_upvr
function setmetatable_result1_upvr.new(arg1) -- Line 17
	--[[ Upvalues[3]:
		[1]: var1_result1_upvr_2 (readonly)
		[2]: setmetatable_result1_upvr (readonly)
		[3]: UserInputService_upvr (readonly)
	]]
	local setmetatable_result1_upvr_2 = setmetatable(var1_result1_upvr_2.new(), setmetatable_result1_upvr)
	setmetatable_result1_upvr_2._inputDown = Instance.new("BoolValue")
	setmetatable_result1_upvr_2._inputDown.Value = false
	setmetatable_result1_upvr_2._maid:GiveTask(setmetatable_result1_upvr_2._inputDown)
	setmetatable_result1_upvr_2.IsActive = Instance.new("BoolValue")
	setmetatable_result1_upvr_2.IsActive.Value = false
	setmetatable_result1_upvr_2._maid:GiveTask(setmetatable_result1_upvr_2.IsActive)
	setmetatable_result1_upvr_2._maid:GiveTask(UserInputService_upvr.TextBoxFocused:Connect(function() -- Line 28
		--[[ Upvalues[1]:
			[1]: setmetatable_result1_upvr_2 (readonly)
		]]
		setmetatable_result1_upvr_2:_updateIsActive()
	end))
	setmetatable_result1_upvr_2._maid:GiveTask(UserInputService_upvr.TextBoxFocusReleased:Connect(function() -- Line 32
		--[[ Upvalues[1]:
			[1]: setmetatable_result1_upvr_2 (readonly)
		]]
		setmetatable_result1_upvr_2:_updateIsActive()
	end))
	setmetatable_result1_upvr_2._maid:GiveTask(setmetatable_result1_upvr_2._inputDown.Changed:Connect(function() -- Line 36
		--[[ Upvalues[1]:
			[1]: setmetatable_result1_upvr_2 (readonly)
		]]
		setmetatable_result1_upvr_2:_updateIsActive()
	end))
	setmetatable_result1_upvr_2:SetInputType(arg1)
	return setmetatable_result1_upvr_2
end
local var1_result1_upvr_3 = any_load_result1("RxValueBaseUtils")
function setmetatable_result1_upvr.ObserveIsActive(arg1) -- Line 45
	--[[ Upvalues[1]:
		[1]: var1_result1_upvr_3 (readonly)
	]]
	return var1_result1_upvr_3.observeValue(arg1.IsActive)
end
local var1_result1_upvr = any_load_result1("Maid")
function setmetatable_result1_upvr.SetInputType(arg1, arg2) -- Line 49
	--[[ Upvalues[2]:
		[1]: var1_result1_upvr (readonly)
		[2]: UserInputService_upvr (readonly)
	]]
	if not arg2 or arg2 == Enum.UserInputType.MouseMovement then
		arg1._inputDown.Value = false
		arg1._maid._current = nil
	else
		local any_new_result1 = var1_result1_upvr.new()
		arg1._inputDown.Value = arg1:_isCurrentlyDown(arg2)
		any_new_result1:GiveTask(UserInputService_upvr.InputBegan:Connect(function(arg1_2) -- Line 60
			--[[ Upvalues[2]:
				[1]: arg2 (readonly)
				[2]: arg1 (readonly)
			]]
			if arg1_2.UserInputType == arg2 or arg1_2.KeyCode == arg2 then
				arg1._inputDown.Value = true
			end
		end))
		any_new_result1:GiveTask(UserInputService_upvr.InputEnded:Connect(function(arg1_3) -- Line 67
			--[[ Upvalues[2]:
				[1]: arg2 (readonly)
				[2]: arg1 (readonly)
			]]
			if arg1_3.UserInputType == arg2 or arg1_3.KeyCode == arg2 then
				arg1._inputDown.Value = false
			end
		end))
		arg1._maid._current = any_new_result1
	end
end
function setmetatable_result1_upvr._isCurrentlyDown(arg1, arg2) -- Line 78
	--[[ Upvalues[1]:
		[1]: UserInputService_upvr (readonly)
	]]
	if typeof(arg2) == "EnumItem" and arg2.EnumType == Enum.KeyCode and UserInputService_upvr:IsKeyDown(arg2) then
		return true
	end
	return false
end
function setmetatable_result1_upvr._updateIsActive(arg1) -- Line 88
	--[[ Upvalues[1]:
		[1]: UserInputService_upvr (readonly)
	]]
	if arg1._inputDown.Value and not UserInputService_upvr:GetFocusedTextBox() then
		arg1.IsActive.Value = true
	else
		arg1.IsActive.Value = false
	end
end
return setmetatable_result1_upvr