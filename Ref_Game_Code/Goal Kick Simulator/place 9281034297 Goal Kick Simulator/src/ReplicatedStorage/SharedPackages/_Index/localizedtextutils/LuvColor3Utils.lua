-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:28:20
-- Luau version 6, Types version 3
-- Time taken: 0.002155 seconds

local any_load_result1 = require(script.Parent.loader).load(script)
local var1_result1_upvr_2 = any_load_result1("LuvUtils")
local module_upvr = {}
local var1_result1_upvr = any_load_result1("Math")
function module_upvr.lerp(arg1, arg2, arg3) -- Line 23
	--[[ Upvalues[2]:
		[1]: module_upvr (readonly)
		[2]: var1_result1_upvr (readonly)
	]]
	-- KONSTANTERROR: [0] 1. Error Block 27 start (CF ANALYSIS FAILED)
	local var5
	if typeof(arg1) ~= "Color3" then
		var5 = false
	else
		var5 = true
	end
	assert(var5, "Bad color0")
	if typeof(arg2) ~= "Color3" then
		var5 = false
		-- KONSTANTWARNING: GOTO [24] #19
	end
	-- KONSTANTERROR: [0] 1. Error Block 27 end (CF ANALYSIS FAILED)
	-- KONSTANTERROR: [23] 18. Error Block 29 start (CF ANALYSIS FAILED)
	var5 = true
	assert(var5, "Bad color0")
	if type(arg3) ~= "number" then
		var5 = false
	else
		var5 = true
	end
	assert(var5, "Bad t")
	if arg3 == 0 then
		return arg1
	end
	if arg3 == 1 then
		return arg2
	end
	var5 = module_upvr.fromColor3(arg1)
	local unpack_result1, unpack_result2_3, unpack_result3_2 = unpack(var5)
	local unpack_result1_2, unpack_result2, unpack_result3 = unpack(module_upvr.fromColor3(arg2))
	do
		return module_upvr.toColor3({var1_result1_upvr.lerp(unpack_result1, unpack_result1_2, arg3), var1_result1_upvr.lerp(unpack_result2_3, unpack_result2, arg3), var1_result1_upvr.lerp(unpack_result3_2, unpack_result3, arg3)})
	end
	-- KONSTANTERROR: [23] 18. Error Block 29 end (CF ANALYSIS FAILED)
end
function module_upvr.fromColor3(arg1) -- Line 49
	--[[ Upvalues[1]:
		[1]: var1_result1_upvr_2 (readonly)
	]]
	local var13
	if typeof(arg1) ~= "Color3" then
		var13 = false
	else
		var13 = true
	end
	assert(var13, "Bad color3")
	var13 = var1_result1_upvr_2
	var13 = {}
	var13[1] = arg1.r
	var13[2] = arg1.g
	var13[3] = arg1.b
	return var13.rgb_to_hsluv(var13)
end
function module_upvr.toColor3(arg1) -- Line 60
	--[[ Upvalues[1]:
		[1]: var1_result1_upvr_2 (readonly)
	]]
	local var14
	if type(arg1) ~= "table" then
		var14 = false
	else
		var14 = true
	end
	assert(var14, "Bad luv")
	var14 = var1_result1_upvr_2.hsluv_to_rgb(arg1)
	local unpack_result1_3, unpack_result2_2, unpack_result3_3 = unpack(var14)
	return Color3.new(math.clamp(unpack_result1_3, 0, 1), math.clamp(unpack_result2_2, 0, 1), math.clamp(unpack_result3_3, 0, 1))
end
return module_upvr