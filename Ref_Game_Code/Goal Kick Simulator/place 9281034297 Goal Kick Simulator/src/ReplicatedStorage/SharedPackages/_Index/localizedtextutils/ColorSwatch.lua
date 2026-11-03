-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:24:47
-- Luau version 6, Types version 3
-- Time taken: 0.004503 seconds

local any_load_result1 = require(script.Parent.loader).load(script)
local any_load_result1_result1_upvr_3 = any_load_result1("BaseObject")
local any_load_result1_result1_upvr = any_load_result1("Blend")
local var1_result1_upvr = any_load_result1("LuvColor3Utils")
local any_load_result1_result1_upvr_4 = any_load_result1("ColorGradeUtils")
local any_load_result1_result1_upvr_2 = any_load_result1("Rx")
local setmetatable_result1_upvr = setmetatable({}, any_load_result1_result1_upvr_3)
setmetatable_result1_upvr.ClassName = "ColorSwatch"
setmetatable_result1_upvr.__index = setmetatable_result1_upvr
local any_load_result1_result1_upvr_5 = any_load_result1("ValueObject")
function setmetatable_result1_upvr.new(arg1, arg2) -- Line 23
	--[[ Upvalues[3]:
		[1]: any_load_result1_result1_upvr_3 (readonly)
		[2]: setmetatable_result1_upvr (readonly)
		[3]: any_load_result1_result1_upvr_5 (readonly)
	]]
	local setmetatable_result1 = setmetatable(any_load_result1_result1_upvr_3.new(), setmetatable_result1_upvr)
	setmetatable_result1._color = any_load_result1_result1_upvr_5.new(Color3.new(0, 0, 0))
	setmetatable_result1._maid:GiveTask(setmetatable_result1._color)
	setmetatable_result1._vividness = any_load_result1_result1_upvr_5.new(nil)
	setmetatable_result1._maid:GiveTask(setmetatable_result1._vividness)
	setmetatable_result1:SetBaseColor(arg1)
	setmetatable_result1:SetVividness(arg2)
	setmetatable_result1.Changed = setmetatable_result1._color.Changed
	return setmetatable_result1
end
function setmetatable_result1_upvr.GetGraded(arg1, arg2) -- Line 40
	--[[ Upvalues[1]:
		[1]: any_load_result1_result1_upvr_4 (readonly)
	]]
	local var10
	if type(arg2) ~= "number" then
		var10 = false
	else
		var10 = true
	end
	assert(var10, "Bad colorGrade")
	var10 = any_load_result1_result1_upvr_4
	var10 = arg1._color.Value
	return var10.getGradedColor(var10, arg2, arg1._vividness.Value)
end
local any_load_result1_result1_upvr_6 = any_load_result1("Observable")
function setmetatable_result1_upvr.ObserveGraded(arg1, arg2, arg3) -- Line 46
	--[[ Upvalues[4]:
		[1]: any_load_result1_result1_upvr_6 (readonly)
		[2]: any_load_result1_result1_upvr (readonly)
		[3]: any_load_result1_result1_upvr_2 (readonly)
		[4]: any_load_result1_result1_upvr_4 (readonly)
	]]
	local var12 = true
	if type(arg2) ~= "number" then
		var12 = any_load_result1_result1_upvr_6.isObservable(arg2)
	end
	assert(var12, "Bad colorGrade")
	local any_toPropertyObservable_result1_3 = any_load_result1_result1_upvr.toPropertyObservable(arg2)
	if not any_toPropertyObservable_result1_3 then
		any_toPropertyObservable_result1_3 = any_load_result1_result1_upvr_2.of(arg2)
	end
	local var14
	if arg3 then
		local any_toPropertyObservable_result1 = any_load_result1_result1_upvr.toPropertyObservable(arg3)
		if not any_toPropertyObservable_result1 then
			any_toPropertyObservable_result1 = any_load_result1_result1_upvr_2.of(arg3)
		end
		var14 = any_toPropertyObservable_result1
	else
		var14 = arg1:ObserveVividness()
	end
	return any_load_result1_result1_upvr_2.combineLatest({
		colorGrade = any_toPropertyObservable_result1_3;
		vividness = var14;
		baseColor = arg1:ObserveBaseColor();
	}):Pipe({any_load_result1_result1_upvr_2.map(function(arg1_2) -- Line 63
		--[[ Upvalues[1]:
			[1]: any_load_result1_result1_upvr_4 (copied, readonly)
		]]
		return any_load_result1_result1_upvr_4.getGradedColor(arg1_2.baseColor, arg1_2.colorGrade, arg1_2.vividness)
	end)})
end
function setmetatable_result1_upvr.ObserveBaseColor(arg1) -- Line 69
	return arg1._color:Observe()
end
function setmetatable_result1_upvr.ObserveVividness(arg1) -- Line 73
	return arg1._vividness:Observe()
end
function setmetatable_result1_upvr.GetBaseColor(arg1) -- Line 77
	return arg1._color.Value
end
function setmetatable_result1_upvr.GetBaseGrade(arg1) -- Line 81
	--[[ Upvalues[1]:
		[1]: var1_result1_upvr (readonly)
	]]
	return 100 - var1_result1_upvr.fromColor3(arg1._color.Value)[3]
end
function setmetatable_result1_upvr.ObserveBaseGrade(arg1) -- Line 85
	--[[ Upvalues[2]:
		[1]: any_load_result1_result1_upvr_2 (readonly)
		[2]: var1_result1_upvr (readonly)
	]]
	return arg1._color:Observe():Pipe({any_load_result1_result1_upvr_2.map(function(arg1_3) -- Line 87
		--[[ Upvalues[1]:
			[1]: var1_result1_upvr (copied, readonly)
		]]
		return 100 - var1_result1_upvr.fromColor3(arg1_3)[3]
	end)})
end
function setmetatable_result1_upvr.ObserveBaseGradeBetween(arg1, arg2, arg3) -- Line 93
	--[[ Upvalues[1]:
		[1]: any_load_result1_result1_upvr_2 (readonly)
	]]
	return arg1:ObserveBaseGrade():Pipe({any_load_result1_result1_upvr_2.map(function(arg1_4) -- Line 95
		--[[ Upvalues[2]:
			[1]: arg2 (readonly)
			[2]: arg3 (readonly)
		]]
		return math.clamp(arg1_4, arg2, arg3)
	end)})
end
function setmetatable_result1_upvr.GetVividness(arg1) -- Line 101
	return arg1._vividness.Value
end
function setmetatable_result1_upvr.SetVividness(arg1, arg2) -- Line 105
	--[[ Upvalues[1]:
		[1]: any_load_result1_result1_upvr (readonly)
	]]
	if type(arg2) == "number" then
		arg1._vividness.Value = arg2
		arg1._maid._currentVividness = nil
	else
		local any_toPropertyObservable_result1_2 = any_load_result1_result1_upvr.toPropertyObservable(arg2)
		if not any_toPropertyObservable_result1_2 then
			arg1._maid._currentVividness = nil
			return
		end
		arg1._maid._currentColor = any_toPropertyObservable_result1_2:Subscribe(function(arg1_5) -- Line 119
			--[[ Upvalues[1]:
				[1]: arg1 (readonly)
			]]
			if type(arg1_5) == "number" then
				arg1._vividness.Value = arg1_5
			else
				warn("[ColorSwatch.SetVividness] - Observed value was not a valid number")
			end
		end)
	end
end
function setmetatable_result1_upvr.SetBaseColor(arg1, arg2) -- Line 128
	--[[ Upvalues[1]:
		[1]: any_load_result1_result1_upvr (readonly)
	]]
	if typeof(arg2) == "Color3" then
		arg1._color.Value = arg2
		arg1._maid._currentColor = nil
	else
		local any_toPropertyObservable_result1_4 = any_load_result1_result1_upvr.toPropertyObservable(arg2)
		if not any_toPropertyObservable_result1_4 then
			arg1._maid._currentColor = nil
			return
		end
		arg1._maid._currentColor = any_toPropertyObservable_result1_4:Subscribe(function(arg1_6) -- Line 141
			--[[ Upvalues[1]:
				[1]: arg1 (readonly)
			]]
			if typeof(arg1_6) == "Color3" then
				arg1._color.Value = arg1_6
			else
				warn("[ColorSwatch.SetBaseColor] - Resulting value was not a valid color")
			end
		end)
	end
end
return setmetatable_result1_upvr