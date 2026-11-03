-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:26:08
-- Luau version 6, Types version 3
-- Time taken: 0.002945 seconds

local any_load_result1 = require(script.Parent.loader).load(script)
local var1_result1_upvr_2 = any_load_result1("RxInstanceUtils")
local var1_result1_upvr = any_load_result1("RxBrioUtils")
local module_upvr = {}
function module_upvr.observeRigAttachmentBrio(arg1, arg2, arg3) -- Line 20
	--[[ Upvalues[3]:
		[1]: module_upvr (readonly)
		[2]: var1_result1_upvr (readonly)
		[3]: var1_result1_upvr_2 (readonly)
	]]
	-- KONSTANTERROR: [0] 1. Error Block 20 start (CF ANALYSIS FAILED)
	local var5
	if typeof(arg1) ~= "Instance" then
		var5 = false
	else
		var5 = true
	end
	assert(var5, "Bad character")
	if type(arg2) ~= "string" then
		var5 = false
		-- KONSTANTWARNING: GOTO [24] #19
	end
	-- KONSTANTERROR: [0] 1. Error Block 20 end (CF ANALYSIS FAILED)
	-- KONSTANTERROR: [23] 18. Error Block 22 start (CF ANALYSIS FAILED)
	var5 = true
	assert(var5, "Bad partName")
	if type(arg3) ~= "string" then
		var5 = false
	else
		var5 = true
	end
	assert(var5, "Bad attachmentName")
	var5 = module_upvr
	var5 = arg1
	do
		return var5.observeCharacterPartBrio(var5, arg2):Pipe({var1_result1_upvr.switchMapBrio(function(arg1_2) -- Line 27
			--[[ Upvalues[2]:
				[1]: var1_result1_upvr_2 (copied, readonly)
				[2]: arg3 (readonly)
			]]
			return var1_result1_upvr_2.observeLastNamedChildBrio(arg1_2, "Attachment", arg3)
		end)})
	end
	-- KONSTANTERROR: [23] 18. Error Block 22 end (CF ANALYSIS FAILED)
end
function module_upvr.observeRigMotorBrio(arg1, arg2, arg3) -- Line 40
	--[[ Upvalues[2]:
		[1]: var1_result1_upvr_2 (readonly)
		[2]: var1_result1_upvr (readonly)
	]]
	-- KONSTANTERROR: [0] 1. Error Block 20 start (CF ANALYSIS FAILED)
	local var8
	if typeof(arg1) ~= "Instance" then
		var8 = false
	else
		var8 = true
	end
	assert(var8, "Bad character")
	if type(arg2) ~= "string" then
		var8 = false
		-- KONSTANTWARNING: GOTO [24] #19
	end
	-- KONSTANTERROR: [0] 1. Error Block 20 end (CF ANALYSIS FAILED)
	-- KONSTANTERROR: [23] 18. Error Block 22 start (CF ANALYSIS FAILED)
	var8 = true
	assert(var8, "Bad partName")
	if type(arg3) ~= "string" then
		var8 = false
	else
		var8 = true
	end
	assert(var8, "Bad motorName")
	var8 = var1_result1_upvr_2
	var8 = arg1
	do
		return var8.observeLastNamedChildBrio(var8, "BasePart", arg2):Pipe({var1_result1_upvr.switchMapBrio(function(arg1_3) -- Line 47
			--[[ Upvalues[2]:
				[1]: var1_result1_upvr_2 (copied, readonly)
				[2]: arg3 (readonly)
			]]
			return var1_result1_upvr_2.observeLastNamedChildBrio(arg1_3, "Motor6D", arg3)
		end), var1_result1_upvr.onlyLastBrioSurvives()})
	end
	-- KONSTANTERROR: [23] 18. Error Block 22 end (CF ANALYSIS FAILED)
end
function module_upvr.observeCharacterPartBrio(arg1, arg2) -- Line 60
	--[[ Upvalues[1]:
		[1]: var1_result1_upvr_2 (readonly)
	]]
	local var11
	if typeof(arg1) ~= "Instance" then
		var11 = false
	else
		var11 = true
	end
	assert(var11, "Bad character")
	if type(arg2) ~= "string" then
		var11 = false
	else
		var11 = true
	end
	assert(var11, "Bad partName")
	var11 = var1_result1_upvr_2
	var11 = arg1
	return var11.observeLastNamedChildBrio(var11, "BasePart", arg2)
end
return module_upvr