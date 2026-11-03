-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:22:14
-- Luau version 6, Types version 3
-- Time taken: 0.005838 seconds

local any_load_result1 = require(script.Parent.loader).load(script)
local any_load_result1_result1_upvr_4 = any_load_result1("BaseObject")
local any_load_result1_result1_upvr = any_load_result1("GuiThemeUtils")
local var1_result1_upvr = any_load_result1("Maid")
local setmetatable_result1_upvr = setmetatable({}, any_load_result1_result1_upvr_4)
setmetatable_result1_upvr.ClassName = "GuiThemeClient"
setmetatable_result1_upvr.__index = setmetatable_result1_upvr
local any_load_result1_result1_upvr_2 = any_load_result1("AttributeValue")
function setmetatable_result1_upvr.new(arg1, arg2) -- Line 18
	--[[ Upvalues[3]:
		[1]: any_load_result1_result1_upvr_4 (readonly)
		[2]: setmetatable_result1_upvr (readonly)
		[3]: any_load_result1_result1_upvr_2 (readonly)
	]]
	local setmetatable_result1 = setmetatable(any_load_result1_result1_upvr_4.new(arg1), setmetatable_result1_upvr)
	setmetatable_result1._guiThemeService = assert(arg2, "No guiThemeClient")
	setmetatable_result1._colorPalette = setmetatable_result1._guiThemeService:GetColorPalette()
	setmetatable_result1._fontPalette = setmetatable_result1._guiThemeService:GetFontPalette()
	setmetatable_result1._isPreferred = any_load_result1_result1_upvr_2.new(setmetatable_result1._obj, "IsPreferred", false)
	return setmetatable_result1
end
function setmetatable_result1_upvr.SetIsPreferred(arg1, arg2) -- Line 30
	local var8
	if type(arg2) ~= "boolean" then
		var8 = false
	else
		var8 = true
	end
	assert(var8, "Bad isPreferred")
	arg1._isPreferred.Value = arg2
end
function setmetatable_result1_upvr.ObserveIsPreferred(arg1) -- Line 36
	return arg1._isPreferred:Observe()
end
function setmetatable_result1_upvr.GetThemeKey(arg1) -- Line 40
	return arg1._obj.Name
end
local any_load_result1_result1_upvr_5 = any_load_result1("Observable")
function setmetatable_result1_upvr.ObserveThemeKey(arg1) -- Line 44
	--[[ Upvalues[2]:
		[1]: any_load_result1_result1_upvr_5 (readonly)
		[2]: var1_result1_upvr (readonly)
	]]
	return any_load_result1_result1_upvr_5.new(function(arg1_2) -- Line 45
		--[[ Upvalues[2]:
			[1]: var1_result1_upvr (copied, readonly)
			[2]: arg1 (readonly)
		]]
		local any_new_result1_upvr_2 = var1_result1_upvr.new()
		arg1._maid[any_new_result1_upvr_2] = any_new_result1_upvr_2
		any_new_result1_upvr_2:GiveTask(function() -- Line 49
			--[[ Upvalues[2]:
				[1]: arg1 (copied, readonly)
				[2]: any_new_result1_upvr_2 (readonly)
			]]
			arg1._maid[any_new_result1_upvr_2] = nil
		end)
		arg1_2:Fire(arg1:GetThemeKey())
		any_new_result1_upvr_2:GiveTask(arg1._obj:GetPropertyChangedSignal("Name"):Connect(function() -- Line 55
			--[[ Upvalues[2]:
				[1]: arg1_2 (readonly)
				[2]: arg1 (copied, readonly)
			]]
			arg1_2:Fire(arg1:GetThemeKey())
		end))
		return any_new_result1_upvr_2
	end)
end
function setmetatable_result1_upvr.GetFolder(arg1) -- Line 63
	return arg1._obj
end
local any_load_result1_result1_upvr_3 = any_load_result1('t')
function setmetatable_result1_upvr.SyncToThemeService(arg1) -- Line 67
	--[[ Upvalues[3]:
		[1]: var1_result1_upvr (readonly)
		[2]: any_load_result1_result1_upvr (readonly)
		[3]: any_load_result1_result1_upvr_3 (readonly)
	]]
	local any_new_result1_upvr = var1_result1_upvr.new()
	any_new_result1_upvr:GiveTask(arg1._colorPalette:ObserveSwatchNames():Subscribe(function(arg1_3) -- Line 70
		--[[ Upvalues[4]:
			[1]: any_load_result1_result1_upvr (copied, readonly)
			[2]: arg1 (readonly)
			[3]: any_new_result1_upvr (readonly)
			[4]: any_load_result1_result1_upvr_3 (copied, readonly)
		]]
		arg1:_setupAttributeSync(any_new_result1_upvr, any_load_result1_result1_upvr.toColorAttributeName(arg1_3), arg1._colorPalette:GetColorValue(arg1_3), any_load_result1_result1_upvr_3.Color3)
	end))
	any_new_result1_upvr:GiveTask(arg1._colorPalette:ObserveGradeNames():Subscribe(function(arg1_4) -- Line 76
		--[[ Upvalues[4]:
			[1]: any_load_result1_result1_upvr (copied, readonly)
			[2]: arg1 (readonly)
			[3]: any_new_result1_upvr (readonly)
			[4]: any_load_result1_result1_upvr_3 (copied, readonly)
		]]
		arg1:_setupAttributeSync(any_new_result1_upvr, any_load_result1_result1_upvr.toGradeAttributeName(arg1_4), arg1._colorPalette:GetGradeValue(arg1_4), any_load_result1_result1_upvr_3.number)
		arg1:_setupAttributeSync(any_new_result1_upvr, any_load_result1_result1_upvr.toVividnessAttributeName(arg1_4), arg1._colorPalette:GetVividnessValue(arg1_4), any_load_result1_result1_upvr_3.optional(any_load_result1_result1_upvr_3.number))
	end))
	any_new_result1_upvr:GiveTask(arg1._fontPalette:ObserveFontNames():Subscribe(function(arg1_5) -- Line 86
		--[[ Upvalues[3]:
			[1]: any_load_result1_result1_upvr (copied, readonly)
			[2]: arg1 (readonly)
			[3]: any_new_result1_upvr (readonly)
		]]
		arg1:_setupFontSync(any_new_result1_upvr, any_load_result1_result1_upvr.toFontAttributeName(arg1_5), arg1._fontPalette:GetFontValue(arg1_5))
	end))
	return any_new_result1_upvr
end
function setmetatable_result1_upvr._setupAttributeSync(arg1, arg2, arg3, arg4, arg5) -- Line 95
	local var19
	if type(arg3) ~= "string" then
		var19 = false
	else
		var19 = true
	end
	assert(var19, "Bad attributeKey")
	var19 = arg4
	assert(var19, "No valueObj")
	if type(arg5) ~= "function" then
		var19 = false
	else
		var19 = true
	end
	assert(var19, "No validateType")
	arg2:GiveTask(arg4.Changed:Connect(function(arg1_6) -- Line 100
		--[[ Upvalues[2]:
			[1]: arg1 (readonly)
			[2]: arg3 (readonly)
		]]
		arg1._obj:SetAttribute(arg3, arg1_6)
	end))
	local function syncToGuiThemeService() -- Line 104
		--[[ Upvalues[4]:
			[1]: arg1 (readonly)
			[2]: arg3 (readonly)
			[3]: arg5 (readonly)
			[4]: arg4 (readonly)
		]]
		local attribute = arg1._obj:GetAttribute(arg3)
		local arg5_result1, arg5_result2 = arg5(attribute)
		if not arg5_result1 then
			if attribute ~= nil then
				warn("[GuiThemeClient] - Bad valuetype for %s attribute %q. %s":format(arg1._obj:GetFullName(), tostring(arg3), tostring(arg5_result2)))
			end
		else
			arg4.Value = attribute
		end
	end
	var19 = arg2:GiveTask
	var19(arg1._obj:GetAttributeChangedSignal(arg3):Connect(syncToGuiThemeService))
	var19 = syncToGuiThemeService
	var19()
end
function setmetatable_result1_upvr._setupFontSync(arg1, arg2, arg3, arg4) -- Line 125
	--[[ Upvalues[1]:
		[1]: any_load_result1_result1_upvr (readonly)
	]]
	arg2:GiveTask(arg4.Changed:Connect(function(arg1_7) -- Line 126
		--[[ Upvalues[3]:
			[1]: arg1 (readonly)
			[2]: arg3 (readonly)
			[3]: any_load_result1_result1_upvr (copied, readonly)
		]]
		arg1._obj:SetAttribute(arg3, any_load_result1_result1_upvr.encodeFontAttribute(arg1_7))
	end))
	arg2:GiveTask(arg1._obj:GetAttributeChangedSignal(arg3):Connect(function() -- Line 130, Named "syncToGuiThemeService"
		--[[ Upvalues[4]:
			[1]: arg1 (readonly)
			[2]: arg3 (readonly)
			[3]: any_load_result1_result1_upvr (copied, readonly)
			[4]: arg4 (readonly)
		]]
		local any_decodeFontAttribute_result1_2 = any_load_result1_result1_upvr.decodeFontAttribute(arg1._obj:GetAttribute(arg3))
		if any_decodeFontAttribute_result1_2 then
			arg4.Value = any_decodeFontAttribute_result1_2
		end
	end))
	local any_decodeFontAttribute_result1 = any_load_result1_result1_upvr.decodeFontAttribute(arg1._obj:GetAttribute(arg3))
	if any_decodeFontAttribute_result1 then
		arg4.Value = any_decodeFontAttribute_result1
	end
end
return setmetatable_result1_upvr