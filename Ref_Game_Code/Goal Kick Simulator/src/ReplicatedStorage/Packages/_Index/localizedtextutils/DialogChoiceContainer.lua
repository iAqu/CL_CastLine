-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:23:31
-- Luau version 6, Types version 3
-- Time taken: 0.002285 seconds

local any_load_result1 = require(script.Parent.loader).load(script)
local var1_result1_upvr = any_load_result1("DialogPromptContainerBase")
local setmetatable_result1_2_upvr = setmetatable({}, var1_result1_upvr)
setmetatable_result1_2_upvr.ClassName = "DialogChoiceContainer"
setmetatable_result1_2_upvr.__index = setmetatable_result1_2_upvr
function setmetatable_result1_2_upvr.new(arg1, arg2, arg3, arg4) -- Line 17
	--[[ Upvalues[2]:
		[1]: var1_result1_upvr (readonly)
		[2]: setmetatable_result1_2_upvr (readonly)
	]]
	local setmetatable_result1 = setmetatable(var1_result1_upvr.new(arg2), setmetatable_result1_2_upvr)
	setmetatable_result1._serviceBag = assert(arg1, "No serviceBag")
	local var5 = arg3
	if not var5 then
		var5 = error("No dialogTextContainer")
	end
	setmetatable_result1._dialogTextContainer = var5
	var5 = arg4
	local var6 = var5
	if not var6 then
		var6 = error("No dialogInput")
	end
	setmetatable_result1._dialogInput = var6
	return setmetatable_result1
end
local var1_result1_upvr_4 = any_load_result1("DialogChoiceTypes")
local var1_result1_upvr_3 = any_load_result1("DialogChoiceGridPane")
local var1_result1_upvr_5 = any_load_result1("DialogChoicesPane")
local var1_result1_upvr_2 = any_load_result1("DialogUIScaleUtils")
function setmetatable_result1_2_upvr.BuildPrompt(arg1, arg2, arg3, arg4) -- Line 27
	--[[ Upvalues[4]:
		[1]: var1_result1_upvr_4 (readonly)
		[2]: var1_result1_upvr_3 (readonly)
		[3]: var1_result1_upvr_5 (readonly)
		[4]: var1_result1_upvr_2 (readonly)
	]]
	-- KONSTANTERROR: [0] 1. Error Block 40 start (CF ANALYSIS FAILED)
	local var11
	if type(arg3) ~= "table" then
		var11 = false
	else
		var11 = true
	end
	assert(var11, "Bad choices")
	if type(arg3.choices) ~= "table" then
		var11 = false
		-- KONSTANTWARNING: GOTO [25] #19
	end
	-- KONSTANTERROR: [0] 1. Error Block 40 end (CF ANALYSIS FAILED)
	-- KONSTANTERROR: [24] 18. Error Block 43 start (CF ANALYSIS FAILED)
	var11 = true
	assert(var11, "Bad choices.choices")
	if type(arg3.key) ~= "string" then
		var11 = false
		-- KONSTANTWARNING: GOTO [41] #30
	end
	-- KONSTANTERROR: [24] 18. Error Block 43 end (CF ANALYSIS FAILED)
end
return setmetatable_result1_2_upvr