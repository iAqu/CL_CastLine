-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:23:43
-- Luau version 6, Types version 3
-- Time taken: 0.001714 seconds

local any_load_result1 = require(script.Parent.loader).load(script)
local var1_result1_upvr = any_load_result1("BaseObject")
local setmetatable_result1_2_upvr = setmetatable({}, var1_result1_upvr)
setmetatable_result1_2_upvr.ClassName = "DialogPromptContainerBase"
setmetatable_result1_2_upvr.__index = setmetatable_result1_2_upvr
function setmetatable_result1_2_upvr.new(arg1) -- Line 14
	--[[ Upvalues[2]:
		[1]: var1_result1_upvr (readonly)
		[2]: setmetatable_result1_2_upvr (readonly)
	]]
	local setmetatable_result1 = setmetatable(var1_result1_upvr.new(arg1), setmetatable_result1_2_upvr)
	assert(setmetatable_result1._obj, "Bad container")
	setmetatable_result1._currentPrompt = nil
	return setmetatable_result1
end
function setmetatable_result1_2_upvr.GetContainer(arg1) -- Line 23
	return arg1._obj
end
function setmetatable_result1_2_upvr.GetCurrentPrompt(arg1) -- Line 27
	return arg1._currentPrompt
end
function setmetatable_result1_2_upvr.BuildPrompt(arg1, arg2) -- Line 31
	error("Not implemented")
end
local any_load_result1_result1_upvr = any_load_result1("Maid")
function setmetatable_result1_2_upvr.ShowPrompt(arg1, ...) -- Line 35
	--[[ Upvalues[1]:
		[1]: any_load_result1_result1_upvr (readonly)
	]]
	local any_new_result1_upvr = any_load_result1_result1_upvr.new()
	local any_BuildPrompt_result1_upvr = arg1:BuildPrompt(any_new_result1_upvr, ...)
	any_BuildPrompt_result1_upvr.Gui.Parent = arg1._obj
	any_new_result1_upvr:GiveTask(function() -- Line 41
		--[[ Upvalues[1]:
			[1]: any_BuildPrompt_result1_upvr (readonly)
		]]
		any_BuildPrompt_result1_upvr:Hide()
		task.delay(1, function() -- Line 43
			--[[ Upvalues[1]:
				[1]: any_BuildPrompt_result1_upvr (copied, readonly)
			]]
			any_BuildPrompt_result1_upvr:Destroy()
		end)
	end)
	any_new_result1_upvr:GiveTask(any_BuildPrompt_result1_upvr.Removing:Connect(function() -- Line 48
		--[[ Upvalues[2]:
			[1]: arg1 (readonly)
			[2]: any_new_result1_upvr (readonly)
		]]
		if arg1._maid._currentPrompt == any_new_result1_upvr then
			arg1._maid._currentPrompt = nil
		end
	end))
	arg1._currentPrompt = any_BuildPrompt_result1_upvr
	any_new_result1_upvr:GiveTask(function() -- Line 55
		--[[ Upvalues[2]:
			[1]: arg1 (readonly)
			[2]: any_BuildPrompt_result1_upvr (readonly)
		]]
		if arg1._currentPrompt == any_BuildPrompt_result1_upvr then
			arg1._currentPrompt = nil
		end
	end)
	any_BuildPrompt_result1_upvr:Show()
	arg1._maid._currentPrompt = any_new_result1_upvr
	return any_BuildPrompt_result1_upvr
end
function setmetatable_result1_2_upvr.HidePrompt(arg1) -- Line 68
	arg1._maid._currentPrompt = nil
end
return setmetatable_result1_2_upvr