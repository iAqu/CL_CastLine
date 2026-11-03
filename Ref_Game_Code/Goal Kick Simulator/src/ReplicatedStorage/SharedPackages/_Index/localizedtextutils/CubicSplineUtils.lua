-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:27:23
-- Luau version 6, Types version 3
-- Time taken: 0.003303 seconds

local module_upvr = {}
local any_load_result1 = require(script.Parent.loader).load(script)
function module_upvr.newSplineNode(arg1, arg2, arg3) -- Line 30
	local module = {}
	module.t = arg1
	module.p = arg2
	module.v = arg3
	return module
end
local var2_result1_upvr = any_load_result1("BinarySearchUtils")
function module_upvr.tween(arg1, arg2) -- Line 44
	--[[ Upvalues[2]:
		[1]: var2_result1_upvr (readonly)
		[2]: module_upvr (readonly)
	]]
	local any_spanSearchNodes_result1, any_spanSearchNodes_result2 = var2_result1_upvr.spanSearchNodes(arg1, 't', arg2)
	local var7 = arg1[any_spanSearchNodes_result1]
	local var8 = arg1[any_spanSearchNodes_result2]
	if var7 and var8 then
		return module_upvr.tweenSplineNodes(var7, var8, arg2)
	end
	if var8 then
		return module_upvr.cloneSplineNode(var8)
	end
	if var7 then
		return module_upvr.cloneSplineNode(var7)
	end
	return nil
end
function module_upvr.cloneSplineNode(arg1) -- Line 67
	--[[ Upvalues[1]:
		[1]: module_upvr (readonly)
	]]
	return module_upvr.newSplineNode(arg1.t, arg1.p, arg1.v)
end
local var2_result1_upvr_2 = any_load_result1("CubicTweenUtils")
function module_upvr.tweenSplineNodes(arg1, arg2, arg3) -- Line 78
	--[[ Upvalues[2]:
		[1]: var2_result1_upvr_2 (readonly)
		[2]: module_upvr (readonly)
	]]
	local t_2 = arg1.t
	local t = arg2.t
	local p = arg1.p
	local p_2 = arg2.p
	local v = arg1.v
	local v_2 = arg2.v
	local any_getConstants_result1, any_getConstants_result2, any_getConstants_result3, any_getConstants_result4 = var2_result1_upvr_2.getConstants(t - t_2, arg3 - t_2)
	local any_getDerivativeConstants_result1, any_getDerivativeConstants_result2, any_getDerivativeConstants_result3, any_getDerivativeConstants_result4 = var2_result1_upvr_2.getDerivativeConstants(t - t_2, arg3 - t_2)
	return module_upvr.newSplineNode(arg3, var2_result1_upvr_2.applyConstants(any_getConstants_result1, any_getConstants_result2, any_getConstants_result3, any_getConstants_result4, p, v, p_2, v_2), var2_result1_upvr_2.applyConstants(any_getDerivativeConstants_result1, any_getDerivativeConstants_result2, any_getDerivativeConstants_result3, any_getDerivativeConstants_result4, p, v, p_2, v_2))
end
function module_upvr.sort(arg1) -- Line 96
	return table.sort(arg1, function(arg1_2, arg2) -- Line 97
		local var25
		if arg1_2.t >= arg2.t then
			var25 = false
		else
			var25 = true
		end
		return var25
	end)
end
local function _(arg1, arg2, arg3) -- Line 102, Named "sumIndex"
	if arg1[arg2] then
		arg1[arg2] += arg3
	else
		arg1[arg2] = arg3
	end
end
local any_load_result1_result1_upvr = any_load_result1("LinearSystemsSolverUtils")
function module_upvr.populateVelocities(arg1, arg2, arg3) -- Line 117
	--[[ Upvalues[1]:
		[1]: any_load_result1_result1_upvr (readonly)
	]]
	-- KONSTANTERROR: [0] 1. Error Block 67 start (CF ANALYSIS FAILED)
	if #arg1 <= 1 then
		if arg1[1] then
			arg1[1].v = 0 * arg1[1].v
		end
		return
	end
	local var29 = arg2 or 1
	local var30 = arg3
	if not var30 then
		var30 = #arg1
	end
	local var31 = var30
	for i = var29, var31 do
		local var32 = arg1[i]
		if var32.optimize then
			var32.v = nil
		elseif var32.v then
			({})[i - var29 + 1] = var32.v
			;({})[i - var29 + 1] = 1
			;({})[i - var29] = 0
			;({})[i - var29 + 1] = 0
		end
	end
	local _ = var29
	-- KONSTANTERROR: [0] 1. Error Block 67 end (CF ANALYSIS FAILED)
	-- KONSTANTERROR: [154] 135. Error Block 44 start (CF ANALYSIS FAILED)
	-- KONSTANTERROR: [154] 135. Error Block 44 end (CF ANALYSIS FAILED)
	-- KONSTANTERROR: [64] 54. Error Block 81 start (CF ANALYSIS FAILED)
	-- KONSTANTWARNING: Failed to evaluate expression, replaced with nil [154.13]
	-- KONSTANTWARNING: Failed to evaluate expression, replaced with nil [154.2299]
	-- KONSTANTWARNING: Failed to evaluate expression, replaced with nil [154.14]
	if nil == nil then
	else
	end
	-- KONSTANTERROR: [64] 54. Error Block 81 end (CF ANALYSIS FAILED)
end
return module_upvr