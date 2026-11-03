-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:26:16
-- Luau version 6, Types version 3
-- Time taken: 0.007824 seconds

local any_load_result1 = require(script.Parent.loader).load(script)
local any_load_result1_result1_upvr_3 = any_load_result1("BaseObject")
local any_load_result1_result1_upvr_5 = any_load_result1("Rx")
local setmetatable_result1_upvr = setmetatable({}, any_load_result1_result1_upvr_3)
setmetatable_result1_upvr.ClassName = "ColorGradePalette"
setmetatable_result1_upvr.__index = setmetatable_result1_upvr
local any_load_result1_result1_upvr_4 = any_load_result1("ValueObject")
function setmetatable_result1_upvr.new() -- Line 18
	--[[ Upvalues[3]:
		[1]: any_load_result1_result1_upvr_3 (readonly)
		[2]: setmetatable_result1_upvr (readonly)
		[3]: any_load_result1_result1_upvr_4 (readonly)
	]]
	local setmetatable_result1 = setmetatable(any_load_result1_result1_upvr_3.new(), setmetatable_result1_upvr)
	setmetatable_result1._grades = {}
	setmetatable_result1._vividness = {}
	setmetatable_result1._defaultSurfaceName = any_load_result1_result1_upvr_4.new()
	setmetatable_result1._maid:GiveTask(setmetatable_result1._defaultSurfaceName)
	return setmetatable_result1
end
function setmetatable_result1_upvr.SetDefaultSurfaceName(arg1, arg2) -- Line 30
	local var7
	if type(arg2) ~= "string" then
		var7 = false
	else
		var7 = true
	end
	assert(var7, "Bad gradeName")
	arg1._defaultSurfaceName.Value = arg2
end
function setmetatable_result1_upvr.HasGrade(arg1, arg2) -- Line 36
	if arg1._grades[arg2] then
		return true
	end
	return false
end
function setmetatable_result1_upvr.GetGrade(arg1, arg2) -- Line 44
	--[[ Upvalues[1]:
		[1]: any_load_result1_result1_upvr_5 (readonly)
	]]
	-- KONSTANTWARNING: Variable analysis failed. Output will have some incorrect variable assignments
	local var8
	if type(arg2) ~= "string" then
		var8 = false
	else
		var8 = true
	end
	assert(var8, "Bad gradeName")
	var8 = arg1._grades
	local var9 = var8[arg2]
	if not var9 then
		var8 = error
		var8("No grade for gradeName %q defined":format(arg2))
		return
	end
	var8 = any_load_result1_result1_upvr_5.toPromise(var9)
	if var8:IsPending() then
		error("Failed to retrieve grade, async load required")
	end
	local any_Yield_result1_2, any_Yield_result2 = var8:Yield()
	if not any_Yield_result1_2 then
		error("Failed to retrieve grade %q due to %s":format(arg2, tostring(any_Yield_result2)))
	end
	if type(any_Yield_result2) ~= "number" then
	else
	end
	assert(true, "Bad grade retrieved")
	return any_Yield_result2, arg1:GetVividness(arg2)
end
function setmetatable_result1_upvr.GetVividness(arg1, arg2) -- Line 67
	--[[ Upvalues[1]:
		[1]: any_load_result1_result1_upvr_5 (readonly)
	]]
	-- KONSTANTWARNING: Variable analysis failed. Output will have some incorrect variable assignments
	local var12
	if type(arg2) ~= "string" then
		var12 = false
	else
		var12 = true
	end
	assert(var12, "Bad gradeName")
	var12 = arg1._vividness
	local var13 = var12[arg2]
	if not var13 then
		var12 = error
		var12("No vividness for gradeName %q defined":format(arg2))
		return
	end
	var12 = any_load_result1_result1_upvr_5.toPromise(var13)
	if var12:IsPending() then
		error("Failed to retrieve vividness, async load required")
	end
	local any_Yield_result1, any_Yield_result2_2 = var12:Yield()
	if not any_Yield_result1 then
		error("Failed to retrieve vividness %q due to %s":format(arg2, tostring(any_Yield_result2_2)))
	end
	if type(any_Yield_result2_2) ~= "number" then
	else
	end
	assert(true, "Bad vividness retrieved")
	return any_Yield_result2_2
end
local any_load_result1_result1_upvr = any_load_result1("Blend")
function setmetatable_result1_upvr.Add(arg1, arg2, arg3, arg4) -- Line 91
	--[[ Upvalues[2]:
		[1]: any_load_result1_result1_upvr (readonly)
		[2]: any_load_result1_result1_upvr_5 (readonly)
	]]
	local var17
	if type(arg2) ~= "string" then
		var17 = false
	else
		var17 = true
	end
	assert(var17, "Bad gradeName")
	var17 = any_load_result1_result1_upvr.toPropertyObservable(arg3)
	if not var17 then
		var17 = any_load_result1_result1_upvr_5.of(arg3)
	end
	arg1._grades[arg2] = var17
	if not any_load_result1_result1_upvr.toPropertyObservable(arg4) then
	end
	arg1._vividness[arg2] = any_load_result1_result1_upvr_5.of(nil)
end
function setmetatable_result1_upvr.ObserveGrade(arg1, arg2) -- Line 98
	local var18
	if type(arg2) ~= "string" then
		var18 = false
	else
		var18 = true
	end
	assert(var18, "Bad gradeName")
	var18 = arg1._grades
	if not var18[arg2] then
		var18 = "No grade for gradeName %q defined":format(arg2)
		error(var18)
		return
	end
	var18 = arg1._grades
	var18 = arg1._vividness[arg2]
	return var18[arg2], var18
end
function setmetatable_result1_upvr.ObserveVividness(arg1, arg2) -- Line 109
	local var19
	if type(arg2) ~= "string" then
		var19 = false
	else
		var19 = true
	end
	assert(var19, "Bad gradeName")
	var19 = arg1._vividness[arg2]
	assert(var19, "No vividness for gradeName")
	var19 = arg1._vividness
	return var19[arg2]
end
function setmetatable_result1_upvr.ObserveModified(arg1, arg2, arg3, arg4) -- Line 116
	--[[ Upvalues[1]:
		[1]: any_load_result1_result1_upvr_5 (readonly)
	]]
	return any_load_result1_result1_upvr_5.combineLatest({
		grade = arg1:_observeGradeFromName(arg2);
		amount = arg1:_observeGradeFromName(arg3);
		multiplier = arg4 or 1;
	}):Pipe({any_load_result1_result1_upvr_5.map(function(arg1_2) -- Line 122
		local var23
		if type(arg1_2.grade) ~= "number" then
			var23 = false
		else
			var23 = true
		end
		assert(var23, "Bad state.grade")
		if type(arg1_2.amount) ~= "number" then
			var23 = false
		else
			var23 = true
		end
		assert(var23, "Bad state.amount")
		var23 = arg1_2.grade
		return var23 + arg1_2.multiplier * arg1_2.amount
	end)})
end
function setmetatable_result1_upvr.ObserveOn(arg1, arg2, arg3, arg4) -- Line 130
	--[[ Upvalues[1]:
		[1]: any_load_result1_result1_upvr_5 (readonly)
	]]
	local var24
	if arg4 == nil then
		var24 = arg1:ObserveDefaultSurfaceGrade()
	else
		var24 = arg1:_observeGradeFromName(arg4)
	end
	return any_load_result1_result1_upvr_5.combineLatest({
		grade = arg1:_observeGradeFromName(arg2);
		newSurfaceGrade = arg1:_observeGradeFromName(arg3);
		baseSurfaceGrade = var24;
	}):Pipe({any_load_result1_result1_upvr_5.map(function(arg1_3) -- Line 143
		-- KONSTANTWARNING: Variable analysis failed. Output will have some incorrect variable assignments
		local var28 = arg1_3.grade - arg1_3.baseSurfaceGrade
		local var29 = arg1_3.newSurfaceGrade + var28
		if 100 < var29 or var29 < 0 then
			local var30 = arg1_3.newSurfaceGrade - var28
			if math.abs(math.clamp(var29, 0, 100) - arg1_3.newSurfaceGrade) < math.abs(math.clamp(var30, 0, 100) - arg1_3.newSurfaceGrade) then
			end
		end
		return var30
	end)}), arg1._vividness[arg2]
end
local any_load_result1_result1_upvr_2 = any_load_result1("ColorGradeUtils")
local any_load_result1_result1_upvr_6 = any_load_result1("Observable")
function setmetatable_result1_upvr._observeGradeFromName(arg1, arg2) -- Line 164
	--[[ Upvalues[3]:
		[1]: any_load_result1_result1_upvr_5 (readonly)
		[2]: any_load_result1_result1_upvr_2 (readonly)
		[3]: any_load_result1_result1_upvr_6 (readonly)
	]]
	if typeof(arg2) == "Color3" then
		return any_load_result1_result1_upvr_5.of(any_load_result1_result1_upvr_2.getGrade(arg2))
	end
	if any_load_result1_result1_upvr_6.isObservable(arg2) then
		return arg2
	end
	local var33 = arg1._grades[arg2]
	if not var33 then
		error("No grade for gradeName %q":format(tostring(arg2)))
	end
	return var33
end
function setmetatable_result1_upvr.ObserveDefaultSurfaceGrade(arg1) -- Line 179
	--[[ Upvalues[1]:
		[1]: any_load_result1_result1_upvr_5 (readonly)
	]]
	return arg1._defaultSurfaceName:Observe():Pipe({any_load_result1_result1_upvr_5.switchMap(function(arg1_4) -- Line 181
		--[[ Upvalues[2]:
			[1]: arg1 (readonly)
			[2]: any_load_result1_result1_upvr_5 (copied, readonly)
		]]
		if arg1_4 and arg1._grades[arg1_4] then
			return arg1._grades[arg1_4]
		end
		return any_load_result1_result1_upvr_5.EMPTY
	end)})
end
return setmetatable_result1_upvr