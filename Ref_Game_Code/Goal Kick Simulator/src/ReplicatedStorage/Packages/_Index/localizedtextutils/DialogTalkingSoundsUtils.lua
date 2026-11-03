-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:22:56
-- Luau version 6, Types version 3
-- Time taken: 0.000615 seconds

local any_load_result1 = require(script.Parent.loader).load(script)
local module = {}
local any_load_result1_result1_upvr = any_load_result1("DialogEntityTypes")
local any_load_result1_result1_upvr_2 = any_load_result1("DialogTalkingSounds")
function module.getForTalkerEntity(arg1) -- Line 12
	--[[ Upvalues[2]:
		[1]: any_load_result1_result1_upvr (readonly)
		[2]: any_load_result1_result1_upvr_2 (readonly)
	]]
	local var5
	if arg1.type ~= any_load_result1_result1_upvr.TALKER_ENTITY then
		var5 = false
	else
		var5 = true
	end
	assert(var5, "Bad talkerEntity")
	var5 = any_load_result1_result1_upvr_2.new(arg1.voicePitchAdjustment)
	return var5
end
return module