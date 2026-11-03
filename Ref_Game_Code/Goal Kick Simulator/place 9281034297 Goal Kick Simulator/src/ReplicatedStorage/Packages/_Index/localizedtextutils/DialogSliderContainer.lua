-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:22:59
-- Luau version 6, Types version 3
-- Time taken: 0.001439 seconds

local any_load_result1 = require(script.Parent.loader).load(script)
local var1_result1_upvr_2 = any_load_result1("DialogPromptContainerBase")
local setmetatable_result1_2_upvr = setmetatable({}, var1_result1_upvr_2)
setmetatable_result1_2_upvr.ClassName = "DialogSliderContainer"
setmetatable_result1_2_upvr.__index = setmetatable_result1_2_upvr
function setmetatable_result1_2_upvr.new(arg1, arg2, arg3, arg4) -- Line 14
	--[[ Upvalues[2]:
		[1]: var1_result1_upvr_2 (readonly)
		[2]: setmetatable_result1_2_upvr (readonly)
	]]
	local setmetatable_result1 = setmetatable(var1_result1_upvr_2.new(arg2), setmetatable_result1_2_upvr)
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
local var1_result1_upvr = any_load_result1("DialogSlider")
function setmetatable_result1_2_upvr.BuildPrompt(arg1, arg2, arg3, arg4) -- Line 25
	--[[ Upvalues[1]:
		[1]: var1_result1_upvr (readonly)
	]]
	local var8
	if type(arg3) ~= "table" then
		var8 = false
	else
		var8 = true
	end
	assert(var8, "Bad sliderOptions")
	if typeof(arg4) ~= "Color3" then
		var8 = false
	else
		var8 = true
	end
	assert(var8, "Bad accentColor")
	var8 = var1_result1_upvr
	var8 = arg1._serviceBag
	local any_new_result1_upvr = var8.new(var8, arg3, arg1._dialogInput)
	var8 = any_new_result1_upvr:SetAccentColor
	var8(arg4)
	var8 = arg2:GiveTask
	var8(any_new_result1_upvr.WaitingForRequestNextInput.Changed:Connect(function() -- Line 32
		--[[ Upvalues[2]:
			[1]: arg1 (readonly)
			[2]: any_new_result1_upvr (readonly)
		]]
		arg1._dialogTextContainer:HandleWaitingForRequestNextInput(any_new_result1_upvr.WaitingForRequestNextInput)
	end))
	var8 = arg1._dialogTextContainer:HandleWaitingForRequestNextInput
	var8(any_new_result1_upvr.WaitingForRequestNextInput)
	return any_new_result1_upvr
end
return setmetatable_result1_2_upvr