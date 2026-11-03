-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:25:19
-- Luau version 6, Types version 3
-- Time taken: 0.001106 seconds

local any_load_result1 = require(script.Parent.loader).load(script)
local module = {}
local var1_result1_upvr_2 = any_load_result1("Math")
function module.getTimeBeforeNextUpdate(arg1) -- Line 12
	--[[ Upvalues[1]:
		[1]: var1_result1_upvr_2 (readonly)
	]]
	if arg1 < 128 then
		return 0
	end
	if arg1 < 256 then
		return 0.5 * var1_result1_upvr_2.map(arg1, 128, 256, 0, 1)
	end
	return 0.5
end
local var1_result1_upvr = any_load_result1("CharacterUtils")
function module.getPlayerIKRig(arg1, arg2) -- Line 24
	--[[ Upvalues[1]:
		[1]: var1_result1_upvr (readonly)
	]]
	assert(arg1, "Bad binder")
	local any_getPlayerHumanoid_result1 = var1_result1_upvr.getPlayerHumanoid(arg2)
	if not any_getPlayerHumanoid_result1 then
		return nil
	end
	return arg1:Get(any_getPlayerHumanoid_result1)
end
return module