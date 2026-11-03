-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:24:20
-- Luau version 6, Types version 3
-- Time taken: 0.003470 seconds

local any_load_result1 = require(script.Parent.loader).load(script)
local var1_result1_upvr_5 = any_load_result1("BaseObject")
local setmetatable_result1_upvr = setmetatable({}, var1_result1_upvr_5)
setmetatable_result1_upvr.ClassName = "GuiThemeSyncer"
setmetatable_result1_upvr.__index = setmetatable_result1_upvr
local var1_result1_upvr = any_load_result1("ObservableMapSet")
local var1_result1_upvr_7 = any_load_result1("ValueObject")
function setmetatable_result1_upvr.new(arg1, arg2, arg3) -- Line 21
	--[[ Upvalues[4]:
		[1]: var1_result1_upvr_5 (readonly)
		[2]: setmetatable_result1_upvr (readonly)
		[3]: var1_result1_upvr (readonly)
		[4]: var1_result1_upvr_7 (readonly)
	]]
	local setmetatable_result1 = setmetatable(var1_result1_upvr_5.new(), setmetatable_result1_upvr)
	setmetatable_result1._themeBinder = assert(arg1, "No themeBinder")
	setmetatable_result1._colorPalette = assert(arg2, "No colorPalette")
	setmetatable_result1._fontPalette = assert(arg3, "No fontPalette")
	setmetatable_result1._themeKeyToTheme = var1_result1_upvr.new()
	setmetatable_result1._maid:GiveTask(setmetatable_result1._themeKeyToTheme)
	setmetatable_result1._preferredThemeObject = var1_result1_upvr_7.new()
	setmetatable_result1._maid:GiveTask(setmetatable_result1._preferredThemeObject)
	setmetatable_result1._preferredThemeName = Instance.new("StringValue")
	setmetatable_result1._preferredThemeName.Value = "Light"
	setmetatable_result1._maid:GiveTask(setmetatable_result1._preferredThemeName)
	setmetatable_result1:_syncCurrentPalette()
	setmetatable_result1:_syncPreferredTheme()
	return setmetatable_result1
end
function setmetatable_result1_upvr.SetPreferredThemeName(arg1, arg2) -- Line 48
	local var7
	if type(arg2) ~= "string" then
		var7 = false
	else
		var7 = true
	end
	assert(var7, "Bad themeName")
	arg1._preferredThemeName.Value = arg2
end
function setmetatable_result1_upvr.GetPreferredThemeName(arg1) -- Line 58
	return arg1._preferredThemeName.Value
end
function setmetatable_result1_upvr.GetPreferredThemeNameValue(arg1) -- Line 66
	return arg1._preferredThemeName
end
local var1_result1_upvr_8 = any_load_result1("RxValueBaseUtils")
function setmetatable_result1_upvr.ObservePreferredThemeName(arg1) -- Line 74
	--[[ Upvalues[1]:
		[1]: var1_result1_upvr_8 (readonly)
	]]
	return var1_result1_upvr_8.observeValue(arg1._preferredThemeName)
end
local var1_result1_upvr_9 = any_load_result1("GuiThemeUtils")
local var1_result1_upvr_2 = any_load_result1("CurrentPaletteSyncer")
function setmetatable_result1_upvr._syncCurrentPalette(arg1) -- Line 78
	--[[ Upvalues[2]:
		[1]: var1_result1_upvr_9 (readonly)
		[2]: var1_result1_upvr_2 (readonly)
	]]
	local any_getPreferredThemeParent_result1 = var1_result1_upvr_9.getPreferredThemeParent()
	local CurrentPalette = any_getPreferredThemeParent_result1:FindFirstChild("CurrentPalette")
	while CurrentPalette do
		CurrentPalette:Destroy()
	end
	local Folder = Instance.new("Folder")
	Folder.Name = "CurrentPalette"
	Folder.Archivable = false
	arg1._maid:GiveTask(Folder)
	local any_new_result1_2 = var1_result1_upvr_2.new(Folder, arg1._colorPalette, arg1._fontPalette)
	any_new_result1_2:SetPreferredThemeNameValue(arg1._preferredThemeName)
	arg1._maid:GiveTask(any_new_result1_2)
	Folder.Parent = any_getPreferredThemeParent_result1
end
local var1_result1_upvr_3 = any_load_result1("RxBinderUtils")
function setmetatable_result1_upvr._syncPreferredTheme(arg1) -- Line 98
	--[[ Upvalues[1]:
		[1]: var1_result1_upvr_3 (readonly)
	]]
	arg1._maid:GiveTask(arg1._preferredThemeObject.Changed:Connect(function(arg1_2, arg2) -- Line 99
		if arg1_2 and arg1_2.Destroy then
			arg1_2:SetIsPreferred(true)
		end
		if arg2 and arg2.Destroy then
			arg2:SetIsPreferred(false)
		end
	end))
	arg1._maid:GiveTask(var1_result1_upvr_3.observeAllBrio(arg1._themeBinder):Subscribe(function(arg1_3) -- Line 109
		--[[ Upvalues[1]:
			[1]: arg1 (readonly)
		]]
		if arg1_3:IsDead() then
		else
			local any_ToMaid_result1 = arg1_3:ToMaid()
			local any_GetValue_result1_upvr = arg1_3:GetValue()
			any_ToMaid_result1:GiveTask(any_GetValue_result1_upvr:ObserveIsPreferred():Subscribe(function(arg1_4) -- Line 117
				--[[ Upvalues[2]:
					[1]: arg1 (copied, readonly)
					[2]: any_GetValue_result1_upvr (readonly)
				]]
				if arg1_4 then
					arg1._preferredThemeName.Value = any_GetValue_result1_upvr:GetThemeKey()
				end
			end))
			any_ToMaid_result1:GiveTask(arg1._themeKeyToTheme:Add(any_GetValue_result1_upvr, any_GetValue_result1_upvr:ObserveThemeKey()))
		end
	end))
	arg1._maid:GiveTask(arg1._preferredThemeName.Changed:Connect(function() -- Line 125
		--[[ Upvalues[1]:
			[1]: arg1 (readonly)
		]]
		arg1:_handleThemeNameChanged()
	end))
	arg1:_handleThemeNameChanged()
end
local var1_result1_upvr_4 = any_load_result1("Maid")
local var1_result1_upvr_6 = any_load_result1("RxStateStackUtils")
function setmetatable_result1_upvr._handleThemeNameChanged(arg1) -- Line 132
	--[[ Upvalues[2]:
		[1]: var1_result1_upvr_4 (readonly)
		[2]: var1_result1_upvr_6 (readonly)
	]]
	arg1._maid._preferredMaid = nil
	local any_new_result1_3_upvr = var1_result1_upvr_4.new()
	any_new_result1_3_upvr:GiveTask(arg1._themeKeyToTheme:ObserveItemsForKeyBrio(arg1._preferredThemeName.Value):Pipe({var1_result1_upvr_6.topOfStack()}):Subscribe(function(arg1_5) -- Line 141
		--[[ Upvalues[3]:
			[1]: any_new_result1_3_upvr (readonly)
			[2]: var1_result1_upvr_4 (copied, readonly)
			[3]: arg1 (readonly)
		]]
		any_new_result1_3_upvr._current = nil
		local any_new_result1 = var1_result1_upvr_4.new()
		if arg1_5 then
			any_new_result1:GiveTask(arg1_5:SyncToThemeService())
			arg1._preferredThemeObject.Value = arg1_5
			any_new_result1:GiveTask(function() -- Line 149
				--[[ Upvalues[2]:
					[1]: arg1 (copied, readonly)
					[2]: arg1_5 (readonly)
				]]
				if arg1._preferredThemeObject.Value == arg1_5 then
					arg1._preferredThemeObject.Value = nil
				end
			end)
		end
		any_new_result1_3_upvr._current = any_new_result1
	end))
	arg1._maid._preferredMaid = any_new_result1_3_upvr
end
return setmetatable_result1_upvr