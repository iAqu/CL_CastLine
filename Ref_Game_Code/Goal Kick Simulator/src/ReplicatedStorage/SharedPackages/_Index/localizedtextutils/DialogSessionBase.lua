-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:25:37
-- Luau version 6, Types version 3
-- Time taken: 0.001084 seconds

local any_load_result1 = require(script.Parent.loader).load(script)
local var1_result1_upvr_2 = any_load_result1("BaseObject")
local setmetatable_result1_upvr = setmetatable({}, var1_result1_upvr_2)
setmetatable_result1_upvr.ClassName = "DialogSessionBase"
setmetatable_result1_upvr.__index = setmetatable_result1_upvr
local var1_result1_upvr = any_load_result1("Signal")
function setmetatable_result1_upvr.new() -- Line 14
	--[[ Upvalues[3]:
		[1]: var1_result1_upvr_2 (readonly)
		[2]: setmetatable_result1_upvr (readonly)
		[3]: var1_result1_upvr (readonly)
	]]
	local setmetatable_result1_upvr_2 = setmetatable(var1_result1_upvr_2.new(), setmetatable_result1_upvr)
	setmetatable_result1_upvr_2.SessionOver = var1_result1_upvr.new()
	setmetatable_result1_upvr_2._maid:GiveTask(function() -- Line 18
		--[[ Upvalues[1]:
			[1]: setmetatable_result1_upvr_2 (readonly)
		]]
		setmetatable_result1_upvr_2.SessionOver:Fire()
		setmetatable_result1_upvr_2.SessionOver:Destroy()
	end)
	return setmetatable_result1_upvr_2
end
function setmetatable_result1_upvr.ShowChoiceList(arg1) -- Line 26
	error("Not implemented")
end
function setmetatable_result1_upvr.ShowChoices(arg1) -- Line 30
	error("Not implemented")
end
function setmetatable_result1_upvr.ShowText(arg1) -- Line 34
	error("Not implemented")
end
function setmetatable_result1_upvr.EndSession(arg1) -- Line 38
	error("Not implemented")
end
return setmetatable_result1_upvr