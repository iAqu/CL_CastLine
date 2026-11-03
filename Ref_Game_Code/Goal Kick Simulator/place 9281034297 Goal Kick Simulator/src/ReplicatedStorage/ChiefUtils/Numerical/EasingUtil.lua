-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:20:17
-- Luau version 6, Types version 3
-- Time taken: 0.005391 seconds

local function _(arg1, arg2, arg3, arg4) -- Line 3
	local var2 = arg1 / arg4
	return arg3 * var2 * var2 + arg2
end
local function _(arg1, arg2, arg3, arg4) -- Line 4
	local var4 = arg1 / arg4
	return -arg3 * var4 * (var4 - 2) + arg2
end
local function _(arg1, arg2, arg3, arg4) -- Line 5
	local var6 = (arg1) / (arg4 / 2)
	if var6 < 1 then
		return arg3 / 2 * var6 * var6 + arg2
	end
	return -arg3 / 2 * (var6 * (var6 - 2) - 1) + arg2
end
local function var7_upvr(arg1, arg2, arg3, arg4) -- Line 6
	local var8 = arg1 / arg4
	if var8 < 0.36363636363636365 then
		return (arg3) * (7.5625 * var8 * var8) + arg2
	end
	if var8 < 0.7272727272727273 then
		local var9 = var8 - 0.5454545454545454
		return arg3 * (7.5625 * var9 * var9 + 0.75) + arg2
	end
	if var9 < 0.9090909090909091 then
		local var10 = var9 - 0.8181818181818182
		return arg3 * (7.5625 * var10 * var10 + 0.9375) + arg2
	end
	local var11 = var10 - 0.9545454545454546
	return arg3 * (7.5625 * var11 * var11 + 0.984375) + arg2
end
local function _(arg1) -- Line 7
	return math.pow(2, -10 * arg1) * math.sin((arg1 * 10 - 0.75) * (-math.pi*2) / 3) + 1
end
local module = {}
local module_upvr = {
	Linear = function(arg1, arg2) -- Line 12, Named "Linear"
		arg1.SecondsPassed += arg2
		local var15 = 0
		local clamped_2 = math.clamp(arg1.SecondsPassed / arg1.Duration, var15, 1)
		if 1 > clamped_2 then
			var15 = false
		else
			var15 = true
		end
		return clamped_2, var15
	end;
	QuadIn = function(arg1, arg2) -- Line 17, Named "QuadIn"
		arg1.SecondsPassed += arg2
		local var17 = arg1.SecondsPassed / arg1.Duration / arg1.Duration
		var17 = 0
		local var18 = var17
		local clamped_4 = math.clamp(1 * var17 * var17 + 0, var18, 1)
		if 1 > clamped_4 then
			var18 = false
		else
			var18 = true
		end
		return clamped_4, var18
	end;
	QuadOut = function(arg1, arg2) -- Line 22, Named "QuadOut"
		arg1.SecondsPassed += arg2
		local var20 = arg1.SecondsPassed / arg1.Duration / arg1.Duration
		var20 = 0
		local var21 = var20
		local clamped_3 = math.clamp(-1 * var20 * (var20 - 2) + 0, var21, 1)
		if 1 > clamped_3 then
			var21 = false
		else
			var21 = true
		end
		return clamped_3, var21
	end;
	QuadInOut = function(arg1, arg2) -- Line 27, Named "QuadInOut"
		-- KONSTANTWARNING: Variable analysis failed. Output will have some incorrect variable assignments
		arg1.SecondsPassed += arg2
		local var23 = (arg1.SecondsPassed / arg1.Duration) / (arg1.Duration / 2)
		local var24
		if var23 < 1 then
			var24 = 0.5 * var23 * var23 + 0
		else
			var24 = -0.5 * (var23 * (var23 - 2) - 1) + 0
		end
		var23 = 0
		local var25 = var23
		local clamped = math.clamp(var24, var25, 1)
		var24 = clamped
		if 1 > clamped then
		else
		end
		return var24, true
	end;
	BounceOut = function(arg1, arg2) -- Line 32, Named "BounceOut"
		--[[ Upvalues[1]:
			[1]: var7_upvr (readonly)
		]]
		arg1.SecondsPassed += arg2
		local var27 = 0
		local clamped_5 = math.clamp(var7_upvr(arg1.SecondsPassed / arg1.Duration, 0, 1, arg1.Duration), var27, 1)
		if 1 > clamped_5 then
			var27 = false
		else
			var27 = true
		end
		return clamped_5, var27
	end;
	ElasticOut = function(arg1, arg2) -- Line 37, Named "ElasticOut"
		arg1.SecondsPassed += arg2
		local var29 = arg1.SecondsPassed / arg1.Duration
		if 1 <= arg1.SecondsPassed / arg1.Duration then
			return 1, true
		end
		return math.pow(2, -10 * var29) * math.sin((var29 * 10 - 0.75) * (-math.pi*2) / 3) + 1
	end;
	Looped = function(arg1, arg2) -- Line 45, Named "Looped"
		arg1.SecondsPassed += arg2
		return arg1.SecondsPassed % arg1.Duration / arg1.Duration
	end;
}
local Time_upvr = require(script.Parent.Parent.Utilities.Time)
function module_upvr.Target(arg1, arg2) -- Line 50
	--[[ Upvalues[1]:
		[1]: Time_upvr (readonly)
	]]
	-- KONSTANTWARNING: Variable analysis failed. Output will have some incorrect variable assignments
	local sign = math.sign(arg1.Target or 0)
	if sign == 0 then
		sign = -math.sign(arg1.SecondsPassed)
	end
	if sign == 0 then
		return 0, true
	end
	if arg1.UpdateTime then
		arg1.SecondsPassed = arg1.RegisteredSeconds + (Time_upvr.GetSyncedUTC() - arg1.UpdateTime) * sign
		arg1.UpdateTime = nil
		arg1.RegisteredSeconds = nil
	else
		arg1.SecondsPassed += sign * arg2
	end
	if 0 >= sign or not math.min then
	end
	local maximum = math.max(arg1.SecondsPassed / arg1.Duration, arg1.Target)
	if maximum ~= arg1.Target then
	else
	end
	return maximum, true
end
function module.GetEasingStyles(arg1) -- Line 76
	--[[ Upvalues[1]:
		[1]: module_upvr (readonly)
	]]
	return module_upvr
end
return module