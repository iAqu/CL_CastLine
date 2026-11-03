-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:22:17
-- Luau version 6, Types version 3
-- Time taken: 0.001509 seconds

local any_load_result1 = require(script.Parent.loader).load(script)
local var1_result1_upvr_2 = any_load_result1("DialogChoiceUtils")
local module_upvr = {}
local var1_result1_upvr = any_load_result1("DialogChoiceTypes")
function module_upvr.replaceWithLocalizedText(arg1, arg2) -- Line 13
	--[[ Upvalues[3]:
		[1]: var1_result1_upvr (readonly)
		[2]: module_upvr (readonly)
		[3]: var1_result1_upvr_2 (readonly)
	]]
	-- KONSTANTERROR: [0] 1. Error Block 28 start (CF ANALYSIS FAILED)
	local var9 = arg1
	assert(var9, "No serviceBag")
	if type(arg2) ~= "table" then
		var9 = false
	else
		var9 = true
	end
	assert(var9, "Bad choices")
	if type(arg2.choices) ~= "table" then
		var9 = false
		-- KONSTANTWARNING: GOTO [32] #24
	end
	-- KONSTANTERROR: [0] 1. Error Block 28 end (CF ANALYSIS FAILED)
	-- KONSTANTERROR: [31] 23. Error Block 31 start (CF ANALYSIS FAILED)
	var9 = true
	assert(var9, "Bad choices.choices")
	if type(arg2.key) ~= "string" then
		var9 = false
	else
		var9 = true
	end
	assert(var9, "Bad choices.key")
	var9 = pairs(arg2.choices)
	local pairs_result1, pairs_result2, pairs_result3 = pairs(arg2.choices)
	for _, v in pairs_result1, pairs_result2, pairs_result3 do
		if v.type == var1_result1_upvr.LOCALIZED_DIALOG_CHOICE then
			table.insert({}, module_upvr.createChoiceFromLocalizedChoice(arg1, v))
		else
			-- KONSTANTERROR: Expression was reused, decompilation is incorrect
			table.insert({}, v)
		end
	end
	pairs_result1 = var1_result1_upvr_2.createChoices
	-- KONSTANTERROR: Expression was reused, decompilation is incorrect
	pairs_result1 = pairs_result1(arg2.key, {})
	do
		return pairs_result1
	end
	-- KONSTANTERROR: [31] 23. Error Block 31 end (CF ANALYSIS FAILED)
end
local var1_result1_upvr_3 = any_load_result1("DialogTranslator")
function module_upvr.createChoiceFromLocalizedChoice(arg1, arg2) -- Line 31
	--[[ Upvalues[2]:
		[1]: var1_result1_upvr_2 (readonly)
		[2]: var1_result1_upvr_3 (readonly)
	]]
	assert(arg2.key, "Bad localizedChoice.key")
	assert(arg2.textKey, "Bad localizedChoice.textKey")
	return var1_result1_upvr_2.createChoice(arg2.key, arg1:GetService(var1_result1_upvr_3):FormatByKey(arg2.textKey))
end
return module_upvr