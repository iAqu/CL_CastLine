-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:26:12
-- Luau version 6, Types version 3
-- Time taken: 0.011265 seconds

local any_load_result1 = require(script.Parent.loader).load(script)
local any_load_result1_result1_upvr_3 = any_load_result1("BaseObject")
local var1_result1_upvr_3 = any_load_result1("Rx")
local var1_result1_upvr = any_load_result1("Blend")
local var1_result1_upvr_4 = any_load_result1("Observable")
local any_load_result1_result1_upvr_7 = any_load_result1("Table")
local any_load_result1_result1_upvr_5 = any_load_result1("ColorGradeUtils")
local any_load_result1_result1_upvr_4 = any_load_result1("LuvColor3Utils")
local setmetatable_result1_2_upvr = setmetatable({}, any_load_result1_result1_upvr_3)
setmetatable_result1_2_upvr.ClassName = "ColorPalette"
setmetatable_result1_2_upvr.__index = setmetatable_result1_2_upvr
local var1_result1_upvr_2 = any_load_result1("ColorGradePalette")
local any_load_result1_result1_upvr_6 = any_load_result1("Maid")
local any_load_result1_result1_upvr = any_load_result1("Signal")
function setmetatable_result1_2_upvr.new() -- Line 24
	--[[ Upvalues[5]:
		[1]: any_load_result1_result1_upvr_3 (readonly)
		[2]: setmetatable_result1_2_upvr (readonly)
		[3]: var1_result1_upvr_2 (readonly)
		[4]: any_load_result1_result1_upvr_6 (readonly)
		[5]: any_load_result1_result1_upvr (readonly)
	]]
	local setmetatable_result1 = setmetatable(any_load_result1_result1_upvr_3.new(), setmetatable_result1_2_upvr)
	setmetatable_result1._gradePalette = var1_result1_upvr_2.new()
	setmetatable_result1._maid:GiveTask(setmetatable_result1._gradePalette)
	setmetatable_result1._gradeMaid = any_load_result1_result1_upvr_6.new()
	setmetatable_result1._maid:GiveTask(setmetatable_result1._gradeMaid)
	setmetatable_result1._colorMaid = any_load_result1_result1_upvr_6.new()
	setmetatable_result1._maid:GiveTask(setmetatable_result1._colorMaid)
	setmetatable_result1._vividMaid = any_load_result1_result1_upvr_6.new()
	setmetatable_result1._maid:GiveTask(setmetatable_result1._vividMaid)
	setmetatable_result1._swatches = {}
	setmetatable_result1._colorValues = {}
	setmetatable_result1._colorGradeValues = {}
	setmetatable_result1._vividnessValues = {}
	setmetatable_result1.ColorSwatchAdded = any_load_result1_result1_upvr.new()
	setmetatable_result1._maid:GiveTask(setmetatable_result1.ColorSwatchAdded)
	setmetatable_result1.ColorGradeAdded = any_load_result1_result1_upvr.new()
	setmetatable_result1._maid:GiveTask(setmetatable_result1.ColorGradeAdded)
	return setmetatable_result1
end
function setmetatable_result1_2_upvr.GetSwatchNames(arg1) -- Line 53
	--[[ Upvalues[1]:
		[1]: any_load_result1_result1_upvr_7 (readonly)
	]]
	return any_load_result1_result1_upvr_7.keys(arg1._swatches)
end
function setmetatable_result1_2_upvr.ObserveSwatchNames(arg1) -- Line 57
	--[[ Upvalues[1]:
		[1]: var1_result1_upvr_3 (readonly)
	]]
	return var1_result1_upvr_3.fromSignal(arg1.ColorSwatchAdded):Pipe({var1_result1_upvr_3.startFrom(function() -- Line 59
		--[[ Upvalues[1]:
			[1]: arg1 (readonly)
		]]
		return arg1:GetSwatchNames()
	end)})
end
function setmetatable_result1_2_upvr.GetGradeNames(arg1) -- Line 65
	--[[ Upvalues[1]:
		[1]: any_load_result1_result1_upvr_7 (readonly)
	]]
	return any_load_result1_result1_upvr_7.keys(arg1._colorGradeValues)
end
function setmetatable_result1_2_upvr.ObserveGradeNames(arg1) -- Line 69
	--[[ Upvalues[1]:
		[1]: var1_result1_upvr_3 (readonly)
	]]
	return var1_result1_upvr_3.fromSignal(arg1.ColorGradeAdded):Pipe({var1_result1_upvr_3.startFrom(function() -- Line 71
		--[[ Upvalues[1]:
			[1]: arg1 (readonly)
		]]
		return arg1:GetGradeNames()
	end)})
end
function setmetatable_result1_2_upvr.GetColorValues(arg1) -- Line 77
	return arg1._colorValues
end
function setmetatable_result1_2_upvr.GetColor(arg1, arg2, arg3, arg4) -- Line 81
	--[[ Upvalues[1]:
		[1]: any_load_result1_result1_upvr_5 (readonly)
	]]
	if type(arg2) == "string" then
		return arg1:GetColorSwatch(arg2):GetGraded(arg1:_toGrade(arg3, arg2), arg1:_toVividness(arg4, arg3, arg2))
	end
	if typeof(arg2) == "Color3" then
		return any_load_result1_result1_upvr_5.getGradedColor(arg2, arg1:_toGrade(arg3, arg2), arg1:_toVividness(arg4, arg3, arg2))
	end
	if typeof(arg2) == "Instance" and arg2:IsA("Color3Value") then
		return any_load_result1_result1_upvr_5.getGradedColor(arg2.Value, arg1:_toGrade(arg3, arg2), arg1:_toVividness(arg4, arg3, arg2))
	end
	error("Bad color")
end
function setmetatable_result1_2_upvr.ObserveColor(arg1, arg2, arg3, arg4) -- Line 97
	--[[ Upvalues[3]:
		[1]: var1_result1_upvr (readonly)
		[2]: var1_result1_upvr_3 (readonly)
		[3]: any_load_result1_result1_upvr_5 (readonly)
	]]
	local var18
	if var18 == "string" then
		var18 = arg1:GetColorSwatch(arg2):ObserveGraded(arg1:_toGradeObservable(arg3, arg2), arg1:_toVividnessObservable(arg4, arg3, arg2))
		return var18
	end
	var18 = nil
	if typeof(arg2) == "Color3" then
		var18 = arg2
	else
		var18 = var1_result1_upvr.toPropertyObservable(arg2)
	end
	if var18 then
		if arg3 == nil and arg4 == nil then
			return var18
		end
		return var1_result1_upvr_3.combineLatest({
			baseColor = var18;
			colorGrade = arg1:_toGradeObservable(arg3, var18);
			vividness = arg1:_toVividnessObservable(arg4, arg3, var18);
		}):Pipe({var1_result1_upvr_3.map(function(arg1_2) -- Line 127
			--[[ Upvalues[1]:
				[1]: any_load_result1_result1_upvr_5 (copied, readonly)
			]]
			return any_load_result1_result1_upvr_5.getGradedColor(arg1_2.baseColor, arg1_2.colorGrade, arg1_2.vividness)
		end)})
	end
	error("Bad color")
end
function setmetatable_result1_2_upvr.SetDefaultSurfaceName(arg1, arg2) -- Line 136
	local var22
	if type(arg2) ~= "string" then
		var22 = false
	else
		var22 = true
	end
	assert(var22, "Bad surfaceName")
	arg1._gradePalette:SetDefaultSurfaceName(arg2)
end
function setmetatable_result1_2_upvr.GetColorSwatch(arg1, arg2) -- Line 142
	local var23 = arg1._swatches[arg2]
	if not var23 then
		error("No swatch with name %q":format(arg2))
	end
	return var23
end
local function SetColor(arg1, arg2, arg3) -- Line 151
	local var24
	if type(arg2) ~= "string" then
		var24 = false
	else
		var24 = true
	end
	assert(var24, "Bad colorName")
	var24 = arg1._swatches
	var24[arg2]:SetColor(arg3)
end
setmetatable_result1_2_upvr.SetColor = SetColor
function setmetatable_result1_2_upvr.ObserveGradeOn(arg1, arg2, arg3, arg4) -- Line 157
	return arg1._gradePalette:ObserveOn(arg2, arg3, arg4)
end
function setmetatable_result1_2_upvr._toGradeObservable(arg1, arg2, arg3) -- Line 161
	--[[ Upvalues[4]:
		[1]: var1_result1_upvr_3 (readonly)
		[2]: var1_result1_upvr_4 (readonly)
		[3]: var1_result1_upvr (readonly)
		[4]: any_load_result1_result1_upvr_4 (readonly)
	]]
	if type(arg2) == "string" then
		return arg1._gradePalette:ObserveGrade(arg2)
	end
	if type(arg2) == "number" then
		return var1_result1_upvr_3.of(arg2)
	end
	if var1_result1_upvr_4.isObservable(arg2) then
		return arg2
	end
	local any_toPropertyObservable_result1_2 = var1_result1_upvr.toPropertyObservable(arg2)
	if any_toPropertyObservable_result1_2 then
		return any_toPropertyObservable_result1_2
	end
	if type(arg3) == "string" then
		return arg1._gradePalette:ObserveGrade(arg3)
	end
	if typeof(arg3) == "Color3" then
		return var1_result1_upvr_3.of(any_load_result1_result1_upvr_4.fromColor3(arg3)[3])
	end
	if var1_result1_upvr_4.isObservable(arg3) then
		return arg3:Pipe({var1_result1_upvr_3.map(function(arg1_3) -- Line 183
			--[[ Upvalues[1]:
				[1]: any_load_result1_result1_upvr_4 (copied, readonly)
			]]
			return any_load_result1_result1_upvr_4.fromColor3(arg1_3)[3]
		end)})
	end
	error("Bad fallbackColorSource argument")
end
function setmetatable_result1_2_upvr._toVividnessObservable(arg1, arg2, arg3, arg4) -- Line 193
	--[[ Upvalues[4]:
		[1]: var1_result1_upvr_3 (readonly)
		[2]: var1_result1_upvr_4 (readonly)
		[3]: var1_result1_upvr (readonly)
		[4]: any_load_result1_result1_upvr_4 (readonly)
	]]
	if type(arg2) == "string" then
		return arg1._gradePalette:ObserveVividness(arg2)
	end
	if type(arg2) == "number" then
		return var1_result1_upvr_3.of(arg2)
	end
	if var1_result1_upvr_4.isObservable(arg2) then
		return arg2
	end
	local any_toPropertyObservable_result1 = var1_result1_upvr.toPropertyObservable(arg2)
	if any_toPropertyObservable_result1 then
		return any_toPropertyObservable_result1
	end
	if type(arg3) == "string" then
		return arg1._gradePalette:ObserveVividness(arg3)
	end
	if type(arg4) == "string" then
		return arg1._gradePalette:ObserveVividness(arg4)
	end
	if typeof(arg4) == "Color3" then
		return var1_result1_upvr_3.of(any_load_result1_result1_upvr_4.fromColor3(arg4)[2])
	end
	if var1_result1_upvr_4.isObservable(arg4) then
		return arg4:Pipe({var1_result1_upvr_3.map(function(arg1_4) -- Line 220
			--[[ Upvalues[1]:
				[1]: any_load_result1_result1_upvr_4 (copied, readonly)
			]]
			return any_load_result1_result1_upvr_4.fromColor3(arg1_4)[2]
		end)})
	end
	error("Bad fallbackColorSource argument")
end
function setmetatable_result1_2_upvr._toGrade(arg1, arg2, arg3) -- Line 230
	if type(arg2) == "string" then
		return arg1._gradePalette:GetGrade(arg2)
	end
	if type(arg2) == "number" then
		return arg2
	end
	return arg1._gradePalette:GetGrade(arg3)
end
function setmetatable_result1_2_upvr._toVividness(arg1, arg2, arg3, arg4) -- Line 240
	if type(arg2) == "string" then
		return arg1._gradePalette:GetVividness(arg2)
	end
	if type(arg3) == "number" then
		return arg3
	end
	if type(arg3) == "string" then
		return arg1._gradePalette:GetVividness(arg3)
	end
	return arg1._gradePalette:GetVividness(arg4)
end
function setmetatable_result1_2_upvr.GetColorValue(arg1, arg2) -- Line 254
	local var31
	if type(arg2) ~= "string" then
		var31 = false
	else
		var31 = true
	end
	assert(var31, "Bad colorName")
	var31 = arg1._colorValues
	local var32 = var31[arg2]
	if not var32 then
		var31 = error
		var31("No color with name %q":format(arg2))
	end
	return var32
end
function setmetatable_result1_2_upvr.GetGradeValue(arg1, arg2) -- Line 265
	local var33 = arg1._colorGradeValues[arg2]
	if not var33 then
		error("No grade with name %q":format(arg2))
	end
	return var33
end
function setmetatable_result1_2_upvr.GetVividnessValue(arg1, arg2) -- Line 274
	local var34 = arg1._vividnessValues[arg2]
	if not var34 then
		error("No grade with name %q":format(arg2))
	end
	return var34
end
function setmetatable_result1_2_upvr.ObserveModifiedGrade(arg1, arg2, arg3, arg4) -- Line 284
	return arg1._gradePalette:ObserveModified(arg2, arg3, arg4)
end
function setmetatable_result1_2_upvr.ObserveGrade(arg1, arg2) -- Line 288
	local var35
	if type(arg2) ~= "string" then
		var35 = false
	else
		var35 = true
	end
	assert(var35, "Bad name")
	return arg1._gradePalette:ObserveGrade(arg2)
end
function setmetatable_result1_2_upvr.ObserveVividness(arg1, arg2) -- Line 294
	local var36
	if type(arg2) ~= "string" then
		var36 = false
	else
		var36 = true
	end
	assert(var36, "Bad name")
	return arg1._gradePalette:ObserveVividness(arg2)
end
function setmetatable_result1_2_upvr.GetSwatch(arg1, arg2) -- Line 300
	local var37
	if type(arg2) ~= "string" then
		var37 = false
	else
		var37 = true
	end
	assert(var37, "Bad swatchName")
	var37 = arg1._swatches
	local var38 = var37[arg2]
	if not var38 then
		var37 = error
		var37("No swatch with name %q":format(arg2))
	end
	return var38
end
function setmetatable_result1_2_upvr.SetColor(arg1, arg2, arg3) -- Line 311
	--[[ Upvalues[1]:
		[1]: var1_result1_upvr (readonly)
	]]
	local var39
	if type(arg2) ~= "string" then
		var39 = false
	else
		var39 = true
	end
	assert(var39, "Bad colorName")
	var39 = arg1._colorValues
	if not var39[arg2] then
		var39 = "No color grade with name %q":format(arg2)
		error(var39)
	end
	var39 = var1_result1_upvr.mount
	local tbl_2 = {}
	tbl_2.Value = arg3
	var39 = var39(arg1._colorValues[arg2], tbl_2)
	arg1._colorMaid[arg2] = var39
end
function setmetatable_result1_2_upvr.SetVividness(arg1, arg2, arg3) -- Line 323
	--[[ Upvalues[1]:
		[1]: var1_result1_upvr (readonly)
	]]
	local var41
	if type(arg2) ~= "string" then
		var41 = false
	else
		var41 = true
	end
	assert(var41, "Bad colorName")
	var41 = arg1._vividnessValues
	if not var41[arg2] then
		var41 = "No vividness with name %q":format(arg2)
		error(var41)
	end
	var41 = var1_result1_upvr.mount
	local tbl = {}
	tbl.Value = arg3
	var41 = var41(arg1._vividnessValues[arg2], tbl)
	arg1._vividMaid[arg2] = var41
end
function setmetatable_result1_2_upvr.SetColorGrade(arg1, arg2, arg3) -- Line 335
	--[[ Upvalues[1]:
		[1]: var1_result1_upvr (readonly)
	]]
	local var43
	if type(arg2) ~= "string" then
		var43 = false
	else
		var43 = true
	end
	assert(var43, "Bad colorName")
	var43 = arg1._colorGradeValues
	if not var43[arg2] then
		var43 = "No color grade with name %q":format(arg2)
		error(var43)
	end
	var43 = var1_result1_upvr.mount
	local tbl_3 = {}
	tbl_3.Value = arg3
	var43 = var43(arg1._colorGradeValues[arg2], tbl_3)
	arg1._gradeMaid[arg2] = var43
end
function setmetatable_result1_2_upvr.ObserveColorBaseGradeBetween(arg1, arg2, arg3, arg4) -- Line 348
	local var45
	if type(arg2) ~= "string" then
		var45 = false
	else
		var45 = true
	end
	assert(var45, "Bad colorName")
	return arg1:GetSwatch(arg2):ObserveBaseGradeBetween(arg3, arg4)
end
local var1_result1_upvr_5 = any_load_result1("ValueObject")
function setmetatable_result1_2_upvr.DefineColorGrade(arg1, arg2, arg3, arg4) -- Line 354
	--[[ Upvalues[1]:
		[1]: var1_result1_upvr_5 (readonly)
	]]
	local var47
	if type(arg2) ~= "string" then
		var47 = false
	else
		var47 = true
	end
	assert(var47, "Bad gradeName")
	var47 = arg1._colorGradeValues
	if var47[arg2] then
		var47 = "Already defined grade of name %q":format(arg2)
		warn(var47)
		return
	end
	var47 = "NumberValue"
	local any_2 = Instance.new(var47)
	var47 = arg1._maid:GiveTask
	var47(any_2)
	var47 = var1_result1_upvr_5.new(nil)
	arg1._maid:GiveTask(var47)
	arg1._gradePalette:Add(arg2, any_2, var47)
	arg1._colorGradeValues[arg2] = any_2
	arg1._vividnessValues[arg2] = var47
	arg1:SetVividness(arg2, arg4)
	arg1:SetColorGrade(arg2, arg3)
	arg1.ColorGradeAdded:Fire(arg2)
	return any_2
end
local any_load_result1_result1_upvr_2 = any_load_result1("ColorSwatch")
function setmetatable_result1_2_upvr.DefineColorSwatch(arg1, arg2, arg3) -- Line 381
	--[[ Upvalues[1]:
		[1]: any_load_result1_result1_upvr_2 (readonly)
	]]
	local var50
	if type(arg2) ~= "string" then
		var50 = false
	else
		var50 = true
	end
	assert(var50, "Bad colorName")
	var50 = arg1._swatches
	if var50[arg2] then
		var50 = "Already defined color of name %q":format(arg2)
		warn(var50)
		return
	end
	var50 = "Color3Value"
	local any = Instance.new(var50)
	var50 = arg3
	if not var50 then
		var50 = Color3.new(0, 0, 0)
	end
	any.Value = var50
	arg1._maid:GiveTask(any)
	arg1._maid:GiveTask(any_load_result1_result1_upvr_2.new(any))
	arg1._colorValues[arg2] = any
	-- KONSTANTERROR: Expression was reused, decompilation is incorrect
	arg1._swatches[arg2] = any_load_result1_result1_upvr_2.new(any)
	arg1.ColorSwatchAdded:Fire(arg2)
	-- KONSTANTERROR: Expression was reused, decompilation is incorrect
	return any_load_result1_result1_upvr_2.new(any)
end
return setmetatable_result1_2_upvr