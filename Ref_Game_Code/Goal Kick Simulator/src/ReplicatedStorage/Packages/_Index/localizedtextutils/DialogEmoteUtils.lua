-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:22:47
-- Luau version 6, Types version 3
-- Time taken: 0.001511 seconds

local any_load_result1 = require(script.Parent.loader).load(script)
local module_upvr = {}
function module_upvr.replaceEmoteTags(arg1) -- Line 16
	--[[ Upvalues[1]:
		[1]: module_upvr (readonly)
	]]
	repeat
	until 1 > #arg1
end
local var1_result1_upvr_2 = any_load_result1("DialogEventTypes")
local any_load_result1_result1_upvr = any_load_result1("DialogTextUtils")
local var1_result1_upvr_3 = any_load_result1("DialogHumanoidParticipantEventTypes")
local HttpService_upvr = game:GetService("HttpService")
local var1_result1_upvr = any_load_result1("HumanoidEmotePlayerConstants")
function module_upvr.handleEmoteTag(arg1, arg2) -- Line 23
	--[[ Upvalues[5]:
		[1]: var1_result1_upvr_2 (readonly)
		[2]: any_load_result1_result1_upvr (readonly)
		[3]: var1_result1_upvr_3 (readonly)
		[4]: HttpService_upvr (readonly)
		[5]: var1_result1_upvr (readonly)
	]]
	local var9 = arg1[arg2]
	if var9.type ~= var1_result1_upvr_2.TAG then
		return arg2 + 1
	end
	local var10, var11 = var9.text:gmatch("emote:(%w+)/(%w+)$")()
	if not var10 or not var11 then
		return arg2 + 1
	end
	table.remove(arg1, arg2)
	table.insert(arg1, arg2, any_load_result1_result1_upvr.createDialogHumanoidParticipantEvent({
		type = var1_result1_upvr_3.PLAY_EMOTE;
		entityKey = var10;
		emoteName = var11;
		emoteGuid = HttpService_upvr:GenerateGUID(false);
		blendAmount = var1_result1_upvr.DEFAULT_BLEND_AMOUNT;
	}))
	return arg2 + 1
end
return module_upvr