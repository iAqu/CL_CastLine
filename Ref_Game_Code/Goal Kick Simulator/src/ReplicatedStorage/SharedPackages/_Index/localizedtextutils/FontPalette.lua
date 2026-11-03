-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:27:53
-- Luau version 6, Types version 3
-- Time taken: 0.002826 seconds

local any_load_result1 = require(script.Parent.loader).load(script)
local var1_result1_upvr_2 = any_load_result1("BaseObject")
local setmetatable_result1_2_upvr = setmetatable({}, var1_result1_upvr_2)
setmetatable_result1_2_upvr.ClassName = "FontPalette"
setmetatable_result1_2_upvr.__index = setmetatable_result1_2_upvr
local var1_result1_upvr = any_load_result1("Signal")
function setmetatable_result1_2_upvr.new() -- Line 17
	--[[ Upvalues[3]:
		[1]: var1_result1_upvr_2 (readonly)
		[2]: setmetatable_result1_2_upvr (readonly)
		[3]: var1_result1_upvr (readonly)
	]]
	local setmetatable_result1 = setmetatable(var1_result1_upvr_2.new(), setmetatable_result1_2_upvr)
	setmetatable_result1._fonts = {}
	setmetatable_result1._defaultFontMap = {}
	setmetatable_result1.FontAdded = var1_result1_upvr.new()
	setmetatable_result1._maid:GiveTask(setmetatable_result1.FontAdded)
	return setmetatable_result1
end
local any_load_result1_result1_upvr = any_load_result1("Table")
function setmetatable_result1_2_upvr.GetFontNames(arg1) -- Line 29
	--[[ Upvalues[1]:
		[1]: any_load_result1_result1_upvr (readonly)
	]]
	return any_load_result1_result1_upvr.keys(arg1._fonts)
end
local any_load_result1_result1_upvr_2 = any_load_result1("Rx")
function setmetatable_result1_2_upvr.ObserveFontNames(arg1) -- Line 33
	--[[ Upvalues[1]:
		[1]: any_load_result1_result1_upvr_2 (readonly)
	]]
	return any_load_result1_result1_upvr_2.fromSignal(arg1.FontAdded):Pipe({any_load_result1_result1_upvr_2.startFrom(function() -- Line 35
		--[[ Upvalues[1]:
			[1]: arg1 (readonly)
		]]
		if arg1.Destroy then
			return arg1:GetFontNames()
		end
		warn("[FontPalette.ObserveFontNames] - Calling when FontPalette is already dead")
		return {}
	end)})
end
function setmetatable_result1_2_upvr.GetFont(arg1, arg2) -- Line 46
	local var10
	if type(arg2) ~= "string" then
		var10 = false
	else
		var10 = true
	end
	assert(var10, "Bad fontName")
	var10 = arg1:GetFontValue(arg2)
	return var10.Value
end
function setmetatable_result1_2_upvr.ObserveFont(arg1, arg2) -- Line 52
	local var11
	if type(arg2) ~= "string" then
		var11 = false
	else
		var11 = true
	end
	assert(var11, "Bad fontName")
	return arg1:GetFontValue(arg2):Observe()
end
function setmetatable_result1_2_upvr.GetFontValue(arg1, arg2) -- Line 58
	local var12
	if type(arg2) ~= "string" then
		var12 = false
	else
		var12 = true
	end
	assert(var12, "Bad fontName")
	var12 = arg1._fonts
	local var13 = var12[arg2]
	if not var13 then
		var12 = error
		var12("No font with name %q":format(arg2))
	end
	return var13
end
function setmetatable_result1_2_upvr.GetDefaultFontMap(arg1) -- Line 69
	return arg1._defaultFontMap
end
local any_load_result1_result1_upvr_3 = any_load_result1("ValueObject")
function setmetatable_result1_2_upvr.DefineFont(arg1, arg2, arg3) -- Line 73
	--[[ Upvalues[1]:
		[1]: any_load_result1_result1_upvr_3 (readonly)
	]]
	local var15
	if type(arg2) ~= "string" then
		var15 = false
	else
		var15 = true
	end
	assert(var15, "Bad fontName")
	if typeof(arg3) ~= "EnumItem" then
		var15 = false
	else
		var15 = true
	end
	assert(var15, "Bad font")
	var15 = arg1._fonts
	if var15[arg2] then
		var15 = "Already defined font of name %q":format(arg2)
		warn(var15)
		return
	end
	var15 = any_load_result1_result1_upvr_3
	var15 = arg3
	local any_new_result1 = var15.new(var15)
	var15 = arg1._maid:GiveTask
	var15(any_new_result1)
	var15 = arg1._fonts
	var15[arg2] = any_new_result1
	var15 = arg1._defaultFontMap
	var15[arg2] = arg3
	var15 = arg1.FontAdded:Fire
	var15(arg2)
	return any_new_result1
end
return setmetatable_result1_2_upvr