-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:20:33
-- Luau version 6, Types version 3
-- Time taken: 0.010446 seconds

local module_upvr = {}
local RunService_upvr = game:GetService("RunService")
local function _(arg1, arg2) -- Line 6, Named "sub"
	return arg1:sub(arg2, arg2)
end
local random_upvr = math.random
local function randomid_upvr() -- Line 8, Named "randomid"
	--[[ Upvalues[1]:
		[1]: random_upvr (readonly)
	]]
	local var4 = `abcdefghijklmnopqrstuvwxzyABCDEFGHIJKLMNOPQRSTUVWXZY0123456789-_*?/=()[]{}&%+^'!#$,..` - 1
	local var3_result1 = random_upvr(0, var4)
	local random_upvr_result1_2 = random_upvr(0, var4)
	local random_upvr_result1_5 = random_upvr(0, var4)
	local random_upvr_result1_4 = random_upvr(0, var4)
	local random_upvr_result1_3 = random_upvr(0, var4)
	local var3_result1_2 = random_upvr(0, var4)
	local random_upvr_result1 = random_upvr(0, var4)
	return "abcdefghijklmnopqrstuvwxzyABCDEFGHIJKLMNOPQRSTUVWXZY0123456789-_*?/=()[]{}&%+^'!#$,..":sub(var3_result1, var3_result1).."abcdefghijklmnopqrstuvwxzyABCDEFGHIJKLMNOPQRSTUVWXZY0123456789-_*?/=()[]{}&%+^'!#$,..":sub(random_upvr_result1_2, random_upvr_result1_2).."abcdefghijklmnopqrstuvwxzyABCDEFGHIJKLMNOPQRSTUVWXZY0123456789-_*?/=()[]{}&%+^'!#$,..":sub(random_upvr_result1_5, random_upvr_result1_5).."abcdefghijklmnopqrstuvwxzyABCDEFGHIJKLMNOPQRSTUVWXZY0123456789-_*?/=()[]{}&%+^'!#$,..":sub(random_upvr_result1_4, random_upvr_result1_4).."abcdefghijklmnopqrstuvwxzyABCDEFGHIJKLMNOPQRSTUVWXZY0123456789-_*?/=()[]{}&%+^'!#$,..":sub(random_upvr_result1_3, random_upvr_result1_3).."abcdefghijklmnopqrstuvwxzyABCDEFGHIJKLMNOPQRSTUVWXZY0123456789-_*?/=()[]{}&%+^'!#$,..":sub(var3_result1_2, var3_result1_2).."abcdefghijklmnopqrstuvwxzyABCDEFGHIJKLMNOPQRSTUVWXZY0123456789-_*?/=()[]{}&%+^'!#$,..":sub(random_upvr_result1, random_upvr_result1)
end
local clock_upvr = os.clock
local tbl_upvr_2 = {}
local tbl_upvr_4 = {}
local sign_upvr = math.sign
local sqrt_upvr = math.sqrt
local exp_upvr = math.exp
local cos_upvr = math.cos
local sin_upvr = math.sin
function tbl_upvr_2.FullSpring(arg1) -- Line 35
	--[[ Upvalues[4]:
		[1]: sqrt_upvr (readonly)
		[2]: exp_upvr (readonly)
		[3]: cos_upvr (readonly)
		[4]: sin_upvr (readonly)
	]]
	local StyleK = arg1.StyleK
	local StyleU = arg1.StyleU
	local var22
	local function INLINED() -- Internal function, doesn't exist in bytecode
		var22 = arg1.fixdt
		return var22
	end
	if not arg1.fixdt or not INLINED() then
		var22 = arg1.tick() - arg1.LastEdit
	end
	arg1.LastEdit = arg1.tick()
	local var23
	local var24
	local var25
	local var26
	if StyleU == 1 then
		local exponentiated = math.exp(-StyleK * var22)
		local var28 = var22 * exponentiated
		local var29 = var28 * StyleK
		var23 = var29 + exponentiated
		var24 = var28
		var25 = -StyleK * var29
		var26 = -var29 + exponentiated
	elseif StyleU < 1 then
		local var30 = StyleK * StyleU
		local var31 = StyleK * sqrt_upvr(1 - StyleU * StyleU)
		local exp_upvr_result1_2 = exp_upvr(-var30 * var22)
		local var19_result1 = sin_upvr(var31 * var22)
		local var34 = 1 / var31
		local var35 = exp_upvr_result1_2 * var19_result1
		local var36 = exp_upvr_result1_2 * cos_upvr(var31 * var22)
		local var37 = exp_upvr_result1_2 * var30 * var19_result1 * var34
		var23 = var36 + var37
		var24 = var35 * var34
		var25 = -var35 * var31 - var30 * var37
		var26 = var36 - var37
	elseif 1 < StyleU then
		local var38 = -StyleK * StyleU
		local var39 = StyleK * sqrt_upvr(StyleU * StyleU - 1)
		local var40 = var38 - var39
		local var41 = var38 + var39
		local exp_upvr_result1 = exp_upvr(var41 * var22)
		local var43 = (1) / (2 * var39)
		local var44 = exp_upvr(var40 * var22) * var43
		local var45 = exp_upvr_result1 * var43
		local var46 = var40 * var44
		local var47 = var41 * var45
		var23 = var44 * var41 - var47 + exp_upvr_result1
		var24 = -var44 + var45
		var25 = (var46 - var47 + exp_upvr_result1) * var41
		var26 = -var46 + var47
	end
	local var48 = arg1.Real - arg1.Target
	local Velocity = arg1.Velocity
	arg1.Real = var48 * var23 + Velocity * var24 + arg1.Target
	arg1.Velocity = var48 * var25 + Velocity * var26
	return arg1.Real
end
function tbl_upvr_2.Linear(arg1, arg2) -- Line 109
	--[[ Upvalues[1]:
		[1]: sign_upvr (readonly)
	]]
	arg1.LastEdit = arg1.tick()
	local Real = arg1.Real
	local Target = arg1.Target
	local var52 = Target - Real
	if var52 == 0 then
		return Real
	end
	local var15_result1 = sign_upvr(var52)
	local var54 = Real + var15_result1 * arg1.StyleValue * (arg1.tick() - arg1.LastEdit)
	if sign_upvr(Target - var54) ~= var15_result1 then
		arg1.Real = Target
		return Target
	end
	local clamped_2 = math.clamp(var54, arg1.min, arg1.max)
	arg1.Real = clamped_2
	return clamped_2
end
function tbl_upvr_2.Approach(arg1, arg2) -- Line 126
	--[[ Upvalues[1]:
		[1]: sign_upvr (readonly)
	]]
	arg1.LastEdit = arg1.tick()
	local Real_2 = arg1.Real
	local Target_2 = arg1.Target
	local var58 = Target_2 - Real_2
	if var58 == 0 then
		return Real_2
	end
	local var59 = Real_2 + var58 * arg1.StyleValue * (arg1.tick() - arg1.LastEdit)
	if sign_upvr(Target_2 - var59) ~= sign_upvr(var58) then
		arg1.Real = Target_2
		return Target_2
	end
	local clamped = math.clamp(var59, arg1.min, arg1.max)
	arg1.Real = clamped
	return clamped
end
function tbl_upvr_2.Spring(arg1, arg2) -- Line 143
	local var61 = arg1.tick() - arg1.LastEdit
	arg1.LastEdit = arg1.tick()
	local var62
	local function INLINED_2() -- Internal function, doesn't exist in bytecode
		var62 = var61
		return var62
	end
	if var61 >= 0.1 or not INLINED_2() then
		var62 = 0.1
	end
	local var63 = var62
	var62 = arg1.Real
	arg1.Velocity += (arg1.Target - var62) * arg1.StyleK * var63 - arg1.Velocity * arg1.StyleU * var63
	arg1.Real += arg1.Velocity * var63
	return arg1.Real
end
local tbl_upvr = {"Name", "Style"}
function checktab(arg1) -- Line 160
	--[[ Upvalues[1]:
		[1]: tbl_upvr (readonly)
	]]
	for i = 1, #tbl_upvr do
		if not arg1[tbl_upvr[i]] then
			error("Not a valid input, '"..tbl_upvr[i].."' is not given", 3)
		end
	end
	return true
end
function module_upvr.RemoveValue(arg1) -- Line 169
	--[[ Upvalues[1]:
		[1]: tbl_upvr_4 (readonly)
	]]
	tbl_upvr_4[arg1] = nil
end
function module_upvr.GetValue(arg1) -- Line 173
	--[[ Upvalues[1]:
		[1]: tbl_upvr_4 (readonly)
	]]
	local var66 = tbl_upvr_4[arg1]
	if not var66 then
		error("Name "..arg1.." does not exist", 2)
	end
	return var66.Real
end
function module_upvr.UpdateTarget(arg1, arg2, arg3, arg4) -- Line 181
	--[[ Upvalues[2]:
		[1]: tbl_upvr_4 (readonly)
		[2]: clock_upvr (readonly)
	]]
	if arg4 then
		local var67
		if tbl_upvr_4[arg1].Target ~= arg2 then
			var67 = tbl_upvr_4
			local function INLINED_3() -- Internal function, doesn't exist in bytecode
				var67 = clock_upvr() + arg3
				return var67
			end
			if not arg3 or not INLINED_3() then
				var67 = 0
			end
			var67[arg1].StartTime = var67
			-- KONSTANTWARNING: GOTO [28] #25
		end
	else
		var67 = tbl_upvr_4
		local function INLINED_4() -- Internal function, doesn't exist in bytecode
			var67 = clock_upvr() + arg3
			return var67
		end
		if not arg3 or not INLINED_4() then
			var67 = 0
		end
		var67[arg1].StartTime = var67
	end
	tbl_upvr_4[arg1].Target = arg2
	return tbl_upvr_4[arg1].Real
end
function module_upvr.UpdateReal(arg1, arg2) -- Line 194
	--[[ Upvalues[1]:
		[1]: tbl_upvr_4 (readonly)
	]]
	tbl_upvr_4[arg1].Real = arg2
end
function module_upvr.new(arg1) -- Line 206
	--[[ Upvalues[5]:
		[1]: randomid_upvr (readonly)
		[2]: tbl_upvr_4 (readonly)
		[3]: clock_upvr (readonly)
		[4]: module_upvr (readonly)
		[5]: tbl_upvr_2 (readonly)
	]]
	local var69
	if not var69 then
		var69 = randomid_upvr()
		arg1.Name = var69
	end
	var69 = checktab
	var69(arg1)
	var69 = tbl_upvr_4[arg1.Name]
	if var69 then
		var69 = warn
		var69("value already exists")
	end
	local function INLINED_5() -- Internal function, doesn't exist in bytecode
		var69 = arg1.max
		return var69
	end
	if not arg1.max or not INLINED_5() then
		var69 = math.huge
	end
	arg1.max = var69
	local function INLINED_6() -- Internal function, doesn't exist in bytecode
		var69 = arg1.min
		return var69
	end
	if not arg1.min or not INLINED_6() then
		var69 = (-math.huge)
	end
	arg1.min = var69
	var69 = arg1.StartTime or 0
	arg1.StartTime = var69
	var69 = arg1.Real or 0
	arg1.Real = var69
	var69 = arg1.Target or 0
	arg1.Target = var69
	var69 = arg1.Velocity or 0
	arg1.Velocity = var69
	var69 = arg1.StyleK or 1
	arg1.StyleK = var69
	var69 = arg1.StyleU or 1
	arg1.StyleU = var69
	var69 = arg1.StyleValue or 1
	arg1.StyleValue = var69
	var69 = arg1.tick
	if not var69 then
		var69 = clock_upvr
	end
	arg1.tick = var69
	arg1.LastEdit = arg1.tick()
	tbl_upvr_4[arg1.Name] = arg1
	function arg1.Update(arg1_2, arg2, arg3) -- Line 229
		--[[ Upvalues[2]:
			[1]: module_upvr (copied, readonly)
			[2]: arg1 (readonly)
		]]
		return module_upvr.UpdateTarget(arg1.Name, arg1_2, arg2, arg3)
	end
	function arg1.Get() -- Line 233
		--[[ Upvalues[1]:
			[1]: arg1 (readonly)
		]]
		return arg1.Real
	end
	function arg1.GetAccurate() -- Line 237
		--[[ Upvalues[2]:
			[1]: arg1 (readonly)
			[2]: tbl_upvr_2 (copied, readonly)
		]]
		if arg1.StartTime <= arg1.tick() then
			return tbl_upvr_2[arg1.Style](arg1)
		end
		return arg1.Real
	end
	function arg1.Destroy(...) -- Line 245
		--[[ Upvalues[2]:
			[1]: tbl_upvr_4 (copied, readonly)
			[2]: arg1 (readonly)
		]]
		tbl_upvr_4[arg1.Name] = nil
	end
	return arg1
end
module_upvr.NewValue = module_upvr.new
local tbl_upvr_3 = {}
function module_upvr.EasyLoopAsync(arg1, arg2, arg3, arg4) -- Line 256
	--[[ Upvalues[2]:
		[1]: clock_upvr (readonly)
		[2]: tbl_upvr_3 (readonly)
	]]
	if not arg4 or not arg4 then
	end
	local tbl = {}
	tbl.Dur = arg1
	tbl.F = arg2
	tbl.t = clock_upvr()
	tbl.Cb = arg3
	tbl_upvr_3[tostring(clock_upvr() * 10000)] = tbl
end
function module_upvr.EasyLoopAsyncEnd(arg1) -- Line 266
	--[[ Upvalues[1]:
		[1]: tbl_upvr_3 (readonly)
	]]
	tbl_upvr_3[arg1] = nil
end
function module_upvr.EasyLoopYield(arg1, arg2) -- Line 270
	--[[ Upvalues[2]:
		[1]: clock_upvr (readonly)
		[2]: RunService_upvr (readonly)
	]]
	repeat
		arg2(0)
		RunService_upvr.Heartbeat:Wait()
	until 1 <= (clock_upvr() - clock_upvr()) / arg1
	arg2(1)
end
function module_upvr.Wait(arg1) -- Line 281
	--[[ Upvalues[2]:
		[1]: clock_upvr (readonly)
		[2]: RunService_upvr (readonly)
	]]
	repeat
		RunService_upvr.Heartbeat:Wait()
	until 1 <= (clock_upvr() - clock_upvr()) / arg1
end
coroutine.wrap(function() -- Line 290
	--[[ Upvalues[5]:
		[1]: RunService_upvr (readonly)
		[2]: clock_upvr (readonly)
		[3]: tbl_upvr_4 (readonly)
		[4]: tbl_upvr_2 (readonly)
		[5]: tbl_upvr_3 (readonly)
	]]
	RunService_upvr.Heartbeat:Connect(function(arg1) -- Line 291
		--[[ Upvalues[4]:
			[1]: clock_upvr (copied, readonly)
			[2]: tbl_upvr_4 (copied, readonly)
			[3]: tbl_upvr_2 (copied, readonly)
			[4]: tbl_upvr_3 (copied, readonly)
		]]
		if 0.4 < arg1 then
		else
			for _, v in pairs(tbl_upvr_4) do
				if v.StartTime <= v.tick() and v.auto ~= false then
					v.PrevValue = v.Real
					tbl_upvr_2[v.Style](v)
					if v.OnUpdate then
						v.OnUpdate(v.PrevValue, v.Real)
					end
				end
			end
			for i_3, v_2 in pairs(tbl_upvr_3) do
				local var95 = (clock_upvr() - v_2.t) / v_2.Dur
				if var95 < 1 then
					v_2.F(var95)
				else
					v_2.F(1)
					if v_2.Cb then
						v_2.Cb()
					end
					tbl_upvr_3[i_3] = nil
				end
			end
		end
	end)
end)()
return module_upvr