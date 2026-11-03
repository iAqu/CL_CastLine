-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:21:59
-- Luau version 6, Types version 3
-- Time taken: 0.000651 seconds

local any_load_result1 = require(script.Parent.loader).load(script)
local any_load_result1_result1_upvr_2 = any_load_result1("BasicPane")
local setmetatable_result1_upvr_2 = setmetatable({}, any_load_result1_result1_upvr_2)
setmetatable_result1_upvr_2.ClassName = "DialogPromptPaneBase"
setmetatable_result1_upvr_2.__index = setmetatable_result1_upvr_2
local any_load_result1_result1_upvr = any_load_result1("Signal")
function setmetatable_result1_upvr_2.new(arg1) -- Line 14
	--[[ Upvalues[3]:
		[1]: any_load_result1_result1_upvr_2 (readonly)
		[2]: setmetatable_result1_upvr_2 (readonly)
		[3]: any_load_result1_result1_upvr (readonly)
	]]
	local setmetatable_result1_upvr = setmetatable(any_load_result1_result1_upvr_2.new(arg1), setmetatable_result1_upvr_2)
	setmetatable_result1_upvr.Removing = any_load_result1_result1_upvr.new()
	setmetatable_result1_upvr._maid:GiveTask(function() -- Line 18
		--[[ Upvalues[1]:
			[1]: setmetatable_result1_upvr (readonly)
		]]
		setmetatable_result1_upvr.Removing:Fire()
		setmetatable_result1_upvr.Removing:Destroy()
	end)
	return setmetatable_result1_upvr
end
return setmetatable_result1_upvr_2