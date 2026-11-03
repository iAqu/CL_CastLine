-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:22:11
-- Luau version 6, Types version 3
-- Time taken: 0.012678 seconds

local any_load_result1_upvr = require(script.Parent.loader).load(script)
local module_upvr = {
	ServiceName = "GuiThemeService";
	Init = function(arg1) -- Line 23, Named "Init"
		arg1:_initializeNonDefinitions()
		arg1._fontPalette:DefineFont("font", Enum.Font.FredokaOne)
		arg1._fontPalette:DefineFont("title", Enum.Font.FredokaOne)
		arg1._fontPalette:DefineFont("action", Enum.Font.FredokaOne)
		arg1._fontPalette:DefineFont("system", Enum.Font.FredokaOne)
		arg1._colorPalette:DefineColorSwatch("surface")
		arg1._colorPalette:DefineColorSwatch("action")
		arg1._colorPalette:DefineColorSwatch("primary")
		arg1._colorPalette:DefineColorSwatch("world_text")
		arg1._colorPalette:DefineColorSwatch("text")
		arg1._colorPalette:DefineColorSwatch("secondary")
		arg1._colorPalette:DefineColorSwatch("critical")
		arg1._colorPalette:DefineColorSwatch("success")
		arg1._colorPalette:DefineColorSwatch("system", Color3.fromRGB(0, 0, 0))
		arg1._colorPalette:DefineColorSwatch("system_text", Color3.new(1, 1, 1))
		arg1._colorPalette:DefineColorSwatch("system_stroke", Color3.fromRGB(255, 255, 255))
		arg1._colorPalette:DefineColorGrade("surface")
		arg1._colorPalette:DefineColorGrade("text")
		arg1._colorPalette:DefineColorGrade("border")
		arg1._colorPalette:DefineColorGrade("highlight")
		arg1._colorPalette:DefineColorGrade("action", arg1._colorPalette:GetColorSwatch("action"):ObserveBaseGrade())
		arg1._colorPalette:DefineColorGrade("primary", arg1._colorPalette:GetColorSwatch("primary"):ObserveBaseGrade())
		arg1._colorPalette:DefineColorGrade("secondary", arg1._colorPalette:GetColorSwatch("secondary"):ObserveBaseGrade())
		arg1._colorPalette:DefineColorGrade("critical", arg1._colorPalette:GetColorSwatch("critical"):ObserveBaseGrade())
		arg1._colorPalette:DefineColorGrade("success", arg1._colorPalette:GetColorSwatch("success"):ObserveBaseGrade())
		arg1._colorPalette:DefineColorGrade("hover")
		arg1._colorPalette:DefineColorGrade("scrollbar")
		arg1._colorPalette:DefineColorGrade("subdued_text")
		arg1._colorPalette:DefineColorGrade("subdued_surface")
		arg1._colorPalette:DefineColorGrade("world_text")
		arg1._colorPalette:DefineColorGrade("world_text_border")
		arg1._colorPalette:DefineColorGrade("system", 100)
		arg1._colorPalette:DefineColorGrade("system_text", 0)
		arg1._colorPalette:DefineColorGrade("system_stroke", 0)
		arg1._colorPalette:DefineColorGrade("system_hover", 80)
		arg1:_ensureTheme({
			name = "Light";
			defaultColors = {
				surface = Color3.fromRGB(245, 245, 245);
				action = Color3.fromRGB(96, 58, 58);
				primary = Color3.fromRGB(85, 170, 127);
				text = Color3.fromRGB(68, 68, 68);
				secondary = Color3.fromRGB(255, 85, 127);
				critical = Color3.fromRGB(134, 32, 32);
				success = Color3.fromRGB(68, 170, 101);
			};
			defaultFonts = arg1._fontPalette:GetDefaultFontMap();
			defaultGrades = {
				surface = 5;
				text = 75;
				world_text = 10;
				world_text_border = 75;
				subdued_text = 55;
				subdued_surface = 20;
				scrollbar = 50;
				border = 25;
				highlight = 20;
				hover = -15;
			};
			defaultVividness = {
				subdued_surface = 0.4;
				border = 0.4;
			};
		})
		arg1:_ensureTheme({
			name = "Dark";
			defaultColors = {
				surface = Color3.fromRGB(62, 37, 37);
				action = Color3.fromRGB(66, 56, 44);
				primary = Color3.fromRGB(63, 128, 95);
				text = Color3.fromRGB(240, 240, 240);
				secondary = Color3.fromRGB(128, 42, 64);
				critical = Color3.fromRGB(170, 70, 92);
				success = Color3.fromRGB(70, 170, 92);
			};
			defaultFonts = arg1._fontPalette:GetDefaultFontMap();
			defaultGrades = {
				surface = 95;
				subdued_surface = 80;
				text = 10;
				world_text = 10;
				world_text_border = 85;
				subdued_text = 45;
				scrollbar = 50;
				border = 75;
				highlight = 70;
				hover = -15;
			};
			defaultVividness = {
				surface = 0.1;
				subdued_surface = 0.1;
				text = 0.5;
				subdued_text = 0.5;
				border = 0.4;
				highlight = 1;
				action = 0.5;
				primary = 0.8;
				secondary = 0.8;
				critical = 0.8;
				success = 0.8;
				hover = nil;
			};
		})
	end;
	GetDefaultColor = function(arg1, arg2, arg3) -- Line 142, Named "GetDefaultColor"
		local var11
		if type(arg2) ~= "string" then
			var11 = false
		else
			var11 = true
		end
		assert(var11, "Bad themeName")
		if type(arg3) ~= "string" then
			var11 = false
		else
			var11 = true
		end
		assert(var11, "Bad swatchName")
		var11 = arg1._defaultThemeData
		local var12 = var11[arg2]
		if not var12 then
			var11 = nil
			return var11
		end
		var11 = var12.defaultColors[arg3]
		if not var11 then
			return nil
		end
		return var11
	end;
	GetGuiThemeBinder = function(arg1) -- Line 163, Named "GetGuiThemeBinder"
		arg1:_verifyInit()
		return arg1._guiThemeBinder
	end;
}
local var1_result1_upvr_3 = any_load_result1_upvr("Rx")
function module_upvr.ObserveTransparency(arg1, arg2) -- Line 169
	--[[ Upvalues[1]:
		[1]: var1_result1_upvr_3 (readonly)
	]]
	if arg2 == "system" then
		return var1_result1_upvr_3.of(0.3)
	end
	if arg2 == "system_action" then
		return var1_result1_upvr_3.of(0.5)
	end
	error("Bad transparencyName %q":format(tostring(arg2)))
end
function module_upvr.GetFont(arg1, arg2) -- Line 184
	local var14
	if type(arg2) ~= "string" then
		var14 = false
	else
		var14 = true
	end
	assert(var14, "Bad fontName")
	arg1:_verifyInit()
	return arg1._fontPalette:GetFont(arg2)
end
function module_upvr.ObserveFont(arg1, arg2) -- Line 197
	local var15
	if type(arg2) ~= "string" then
		var15 = false
	else
		var15 = true
	end
	assert(var15, "Bad fontName")
	arg1:_verifyInit()
	return arg1._fontPalette:ObserveFont(arg2)
end
function module_upvr.GetColor(arg1, arg2, arg3, arg4) -- Line 214
	local var16
	if type(arg2) ~= "string" then
		var16 = false
	else
		var16 = true
	end
	assert(var16, "Bad colorName")
	arg1:_verifyInit()
	return arg1._colorPalette:GetColor(arg2, arg3, arg4)
end
local any_load_result1_upvr_result1_upvr_2 = any_load_result1_upvr("Blend")
function module_upvr.ObserveColor(arg1, arg2, arg3, arg4) -- Line 231
	--[[ Upvalues[1]:
		[1]: any_load_result1_upvr_result1_upvr_2 (readonly)
	]]
	arg1:_verifyInit()
	return any_load_result1_upvr_result1_upvr_2.Spring(arg1._colorPalette:ObserveColor(arg2, arg3, arg4), 30)
end
function module_upvr.GetSwatch(arg1, arg2) -- Line 244
	local var18
	if type(arg2) ~= "string" then
		var18 = false
	else
		var18 = true
	end
	assert(var18, "Bad colorName")
	arg1:_verifyInit()
	return arg1._colorPalette:GetSwatch(arg2)
end
function module_upvr.ObserveGrade(arg1, arg2) -- Line 252
	return arg1._colorPalette:ObserveGrade(arg2)
end
function module_upvr.ObserveVividness(arg1, arg2) -- Line 256
	return arg1._colorPalette:ObserveVividness(arg2)
end
function module_upvr.ObserveModifiedGrade(arg1, arg2, arg3, arg4) -- Line 260
	arg1:_verifyInit()
	return arg1._colorPalette:ObserveModifiedGrade(arg2, arg3, arg4)
end
function module_upvr.ObserveGradeOn(arg1, arg2, arg3, arg4) -- Line 266
	arg1:_verifyInit()
	return arg1._colorPalette:ObserveGradeOn(arg2, arg3, arg4)
end
function module_upvr.GetColorPalette(arg1) -- Line 278
	return arg1._colorPalette
end
function module_upvr.GetFontPalette(arg1) -- Line 288
	return arg1._fontPalette
end
function module_upvr.SetPreferredThemeName(arg1, arg2) -- Line 296
	local var19
	if type(arg2) ~= "string" then
		var19 = false
	else
		var19 = true
	end
	assert(var19, "Bad themeName")
	arg1:_verifyInit()
	arg1._guiThemeSyncer:SetPreferredThemeName(arg2)
end
function module_upvr.GetPreferredThemeName(arg1) -- Line 307
	arg1:_verifyInit()
	return arg1._guiThemeSyncer:GetPreferredThemeName()
end
function module_upvr.GetPreferredThemeNameValue(arg1) -- Line 317
	arg1:_verifyInit()
	return arg1._guiThemeSyncer:GetPreferredThemeNameValue()
end
local any_load_result1_upvr_result1_upvr_4 = any_load_result1_upvr("RxValueBaseUtils")
function module_upvr.ObservePreferredThemeNameValue(arg1) -- Line 327
	--[[ Upvalues[1]:
		[1]: any_load_result1_upvr_result1_upvr_4 (readonly)
	]]
	arg1:_verifyInit()
	return any_load_result1_upvr_result1_upvr_4.observeValue(arg1._guiThemeSyncer:GetPreferredThemeNameValue())
end
local var1_result1_upvr_4 = any_load_result1_upvr("Maid")
local var1_result1_upvr = any_load_result1_upvr("ColorPalette")
local var1_result1_upvr_2 = any_load_result1_upvr("FontPalette")
local any_load_result1_upvr_result1_upvr_3 = any_load_result1_upvr("Binder")
local any_load_result1_upvr_result1_upvr_5 = any_load_result1_upvr("GuiThemeSyncer")
function module_upvr._initializeNonDefinitions(arg1) -- Line 333
	--[[ Upvalues[6]:
		[1]: var1_result1_upvr_4 (readonly)
		[2]: var1_result1_upvr (readonly)
		[3]: var1_result1_upvr_2 (readonly)
		[4]: any_load_result1_upvr_result1_upvr_3 (readonly)
		[5]: any_load_result1_upvr (readonly)
		[6]: any_load_result1_upvr_result1_upvr_5 (readonly)
	]]
	assert(not arg1._maid, "Already initialized")
	arg1._maid = var1_result1_upvr_4.new()
	arg1._colorPalette = var1_result1_upvr.new()
	arg1._colorPalette:SetDefaultSurfaceName("surface")
	arg1._maid:GiveTask(arg1._colorPalette)
	arg1._fontPalette = var1_result1_upvr_2.new()
	arg1._maid:GiveTask(arg1._fontPalette)
	arg1._guiThemeBinder = any_load_result1_upvr_result1_upvr_3.new("GuiTheme", any_load_result1_upvr("GuiThemeClient"), arg1)
	arg1._maid:GiveTask(function() -- Line 346
		--[[ Upvalues[1]:
			[1]: arg1 (readonly)
		]]
		arg1._maid:DoCleaning()
		arg1._guiThemeBinder:Destroy()
	end)
	arg1._defaultThemeData = {}
	arg1._guiThemeBinder:Start()
	arg1._guiThemeSyncer = any_load_result1_upvr_result1_upvr_5.new(arg1._guiThemeBinder, arg1._colorPalette, arg1._fontPalette)
	arg1._maid:GiveTask(arg1._guiThemeSyncer)
end
local any_load_result1_upvr_result1_upvr = any_load_result1_upvr("GuiThemeUtils")
local var1_result1_upvr_5 = any_load_result1_upvr("AttributeUtils")
function module_upvr._ensureTheme(arg1, arg2) -- Line 361
	--[[ Upvalues[2]:
		[1]: any_load_result1_upvr_result1_upvr (readonly)
		[2]: var1_result1_upvr_5 (readonly)
	]]
	arg1._defaultThemeData[arg2.name] = arg2
	local any_getThemeFromKey_result1 = any_load_result1_upvr_result1_upvr.getThemeFromKey(arg1._guiThemeBinder, arg2.name)
	local var46
	if any_getThemeFromKey_result1 then
		var46 = any_getThemeFromKey_result1:GetFolder()
	else
		var46 = Instance.new("Folder")
		var46.Name = arg2.name
	end
	for i, v in pairs(arg2.defaultColors) do
		var1_result1_upvr_5.initAttribute(var46, any_load_result1_upvr_result1_upvr.toColorAttributeName(i), v)
	end
	for i_2, v_2 in pairs(arg2.defaultGrades) do
		if type(v_2) == "number" then
			var1_result1_upvr_5.initAttribute(var46, any_load_result1_upvr_result1_upvr.toGradeAttributeName(i_2), v_2)
		end
	end
	for i_3, v_3 in pairs(arg2.defaultFonts) do
		var1_result1_upvr_5.initAttribute(var46, any_load_result1_upvr_result1_upvr.toFontAttributeName(i_3), any_load_result1_upvr_result1_upvr.encodeFontAttribute(v_3))
	end
	for i_4, v_4 in pairs(arg2.defaultVividness) do
		var1_result1_upvr_5.initAttribute(var46, any_load_result1_upvr_result1_upvr.toVividnessAttributeName(i_4), v_4)
	end
	arg1._guiThemeBinder:BindClient(var46)
	var46.Parent = any_load_result1_upvr_result1_upvr.getPreferredThemeParent()
	return var46
end
local RunService_upvr = game:GetService("RunService")
function module_upvr._verifyInit(arg1) -- Line 400
	--[[ Upvalues[2]:
		[1]: module_upvr (readonly)
		[2]: RunService_upvr (readonly)
	]]
	local var60
	if arg1 == module_upvr then
		var60 = false
	else
		var60 = true
	end
	assert(var60, "Get GuiThemeService via serviceBag")
	if not RunService_upvr:IsRunning() then
		if not arg1._maid then
			arg1:Init()
		end
	else
		var60 = arg1._maid
		assert(var60, "Not initialized yet")
	end
end
function module_upvr.Destroy(arg1) -- Line 415
	arg1._maid:DoCleaning()
	arg1._maid = nil
	setmetatable(arg1, nil)
end
return module_upvr