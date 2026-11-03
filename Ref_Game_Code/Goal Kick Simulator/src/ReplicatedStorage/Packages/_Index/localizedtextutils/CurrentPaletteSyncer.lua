-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:22:07
-- Luau version 6, Types version 3
-- Time taken: 0.004784 seconds

local any_load_result1 = require(script.Parent.loader).load(script)
local var1_result1_upvr = any_load_result1("BaseObject")
local any_load_result1_result1_upvr = any_load_result1("GuiThemeUtils")
local setmetatable_result1_upvr = setmetatable({}, var1_result1_upvr)
setmetatable_result1_upvr.ClassName = "CurrentPaletteSyncer"
setmetatable_result1_upvr.__index = setmetatable_result1_upvr
local var1_result1_upvr_2 = any_load_result1('t')
function setmetatable_result1_upvr.new(arg1, arg2, arg3) -- Line 16
	--[[ Upvalues[4]:
		[1]: var1_result1_upvr (readonly)
		[2]: setmetatable_result1_upvr (readonly)
		[3]: any_load_result1_result1_upvr (readonly)
		[4]: var1_result1_upvr_2 (readonly)
	]]
	local setmetatable_result1_upvr_2 = setmetatable(var1_result1_upvr.new(arg1), setmetatable_result1_upvr)
	setmetatable_result1_upvr_2._colorPalette = assert(arg2, "No colorPalette")
	setmetatable_result1_upvr_2._fontPalette = assert(arg3, "No fontPalette")
	setmetatable_result1_upvr_2._maid:GiveTask(setmetatable_result1_upvr_2._colorPalette:ObserveSwatchNames():Subscribe(function(arg1_2) -- Line 22
		--[[ Upvalues[3]:
			[1]: setmetatable_result1_upvr_2 (readonly)
			[2]: any_load_result1_result1_upvr (copied, readonly)
			[3]: var1_result1_upvr_2 (copied, readonly)
		]]
		setmetatable_result1_upvr_2:_setupAttributeSync(any_load_result1_result1_upvr.toColorAttributeName(arg1_2), setmetatable_result1_upvr_2._colorPalette:GetColorValue(arg1_2), var1_result1_upvr_2.Color3)
	end))
	setmetatable_result1_upvr_2._maid:GiveTask(setmetatable_result1_upvr_2._colorPalette:ObserveGradeNames():Subscribe(function(arg1_3) -- Line 29
		--[[ Upvalues[3]:
			[1]: any_load_result1_result1_upvr (copied, readonly)
			[2]: setmetatable_result1_upvr_2 (readonly)
			[3]: var1_result1_upvr_2 (copied, readonly)
		]]
		setmetatable_result1_upvr_2:_setupAttributeSync(any_load_result1_result1_upvr.toGradeAttributeName(arg1_3), setmetatable_result1_upvr_2._colorPalette:GetGradeValue(arg1_3), var1_result1_upvr_2.number)
		setmetatable_result1_upvr_2:_setupAttributeSync(any_load_result1_result1_upvr.toVividnessAttributeName(arg1_3), setmetatable_result1_upvr_2._colorPalette:GetVividnessValue(arg1_3), var1_result1_upvr_2.optional(var1_result1_upvr_2.number))
	end))
	setmetatable_result1_upvr_2._maid:GiveTask(setmetatable_result1_upvr_2._fontPalette:ObserveFontNames():Subscribe(function(arg1_4) -- Line 39
		--[[ Upvalues[2]:
			[1]: any_load_result1_result1_upvr (copied, readonly)
			[2]: setmetatable_result1_upvr_2 (readonly)
		]]
		setmetatable_result1_upvr_2:_setupFontSync(any_load_result1_result1_upvr.toFontAttributeName(arg1_4), setmetatable_result1_upvr_2._fontPalette:GetFontValue(arg1_4))
	end))
	return setmetatable_result1_upvr_2
end
function setmetatable_result1_upvr.SetPreferredThemeNameValue(arg1, arg2) -- Line 48
	arg1._preferredThemeNameValue = arg2
	arg1._obj:SetAttribute("PreferredThemeName", arg1._preferredThemeNameValue.Value)
	arg1._maid:GiveTask(arg1._preferredThemeNameValue.Changed:Connect(function() -- Line 52
		--[[ Upvalues[1]:
			[1]: arg1 (readonly)
		]]
		arg1._obj:SetAttribute("PreferredThemeName", arg1._preferredThemeNameValue.Value)
	end))
	arg1._maid:GiveTask(arg1._obj:GetAttributeChangedSignal("PreferredThemeName"):Connect(function() -- Line 56
		--[[ Upvalues[1]:
			[1]: arg1 (readonly)
		]]
		local PreferredThemeName = arg1._obj:GetAttribute("PreferredThemeName")
		if type(PreferredThemeName) == "string" then
			arg1._preferredThemeNameValue.Value = PreferredThemeName
		end
	end))
end
function setmetatable_result1_upvr._setupAttributeSync(arg1, arg2, arg3, arg4) -- Line 64
	local syncToGuiThemeService
	if type(arg2) ~= "string" then
		syncToGuiThemeService = false
	else
		syncToGuiThemeService = true
	end
	assert(syncToGuiThemeService, "Bad attributeKey")
	syncToGuiThemeService = arg3
	assert(syncToGuiThemeService, "No valueObj")
	if type(arg4) ~= "function" then
		syncToGuiThemeService = false
	else
		syncToGuiThemeService = true
	end
	assert(syncToGuiThemeService, "No validateType")
	local function update(arg1_5) -- Line 70
		--[[ Upvalues[2]:
			[1]: arg1 (readonly)
			[2]: arg2 (readonly)
		]]
		arg1._obj:SetAttribute(arg2, arg1_5)
	end
	syncToGuiThemeService = arg1._maid:GiveTask
	syncToGuiThemeService(arg3.Changed:Connect(update))
	syncToGuiThemeService = arg3.Value
	arg1._obj:SetAttribute(arg2, syncToGuiThemeService)
	function syncToGuiThemeService() -- Line 77
		--[[ Upvalues[4]:
			[1]: arg1 (readonly)
			[2]: arg2 (readonly)
			[3]: arg4 (readonly)
			[4]: arg3 (readonly)
		]]
		local attribute = arg1._obj:GetAttribute(arg2)
		local arg4_result1_2, arg4_result2_2 = arg4(attribute)
		if not arg4_result1_2 then
			warn("Bad valuetype for %q. %s":format(tostring(arg2), tostring(arg4_result2_2)))
		else
			arg3.Value = attribute
		end
	end
	arg1._maid:GiveTask(arg1._obj:GetAttributeChangedSignal(arg2):Connect(syncToGuiThemeService))
	local attribute_2 = arg1._obj:GetAttribute(arg2)
	local arg4_result1, arg4_result2 = arg4(attribute_2)
	if not arg4_result1 then
		warn("Bad valuetype for %q. %s":format(tostring(arg2), tostring(arg4_result2)))
	else
		arg3.Value = attribute_2
	end
end
function setmetatable_result1_upvr._setupFontSync(arg1, arg2, arg3) -- Line 91
	--[[ Upvalues[1]:
		[1]: any_load_result1_result1_upvr (readonly)
	]]
	arg1._maid:GiveTask(arg3.Changed:Connect(function(arg1_6) -- Line 93, Named "update"
		--[[ Upvalues[3]:
			[1]: arg1 (readonly)
			[2]: arg2 (readonly)
			[3]: any_load_result1_result1_upvr (copied, readonly)
		]]
		arg1._obj:SetAttribute(arg2, any_load_result1_result1_upvr.encodeFontAttribute(arg1_6))
	end))
	arg1._obj:SetAttribute(arg2, any_load_result1_result1_upvr.encodeFontAttribute(arg3.Value))
	arg1._maid:GiveTask(arg1._obj:GetAttributeChangedSignal(arg2):Connect(function() -- Line 100, Named "syncToGuiThemeService"
		--[[ Upvalues[4]:
			[1]: arg1 (readonly)
			[2]: arg2 (readonly)
			[3]: any_load_result1_result1_upvr (copied, readonly)
			[4]: arg3 (readonly)
		]]
		local any_decodeFontAttribute_result1_2 = any_load_result1_result1_upvr.decodeFontAttribute(arg1._obj:GetAttribute(arg2))
		if any_decodeFontAttribute_result1_2 then
			arg3.Value = any_decodeFontAttribute_result1_2
		end
	end))
	local any_decodeFontAttribute_result1 = any_load_result1_result1_upvr.decodeFontAttribute(arg1._obj:GetAttribute(arg2))
	if any_decodeFontAttribute_result1 then
		arg3.Value = any_decodeFontAttribute_result1
	end
end
return setmetatable_result1_upvr