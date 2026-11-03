-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:23:41
-- Luau version 6, Types version 3
-- Time taken: 0.005195 seconds

local any_load_result1 = require(script.Parent.loader).load(script)
local any_load_result1_result1_upvr_5 = any_load_result1("BaseObject")
local setmetatable_result1_upvr = setmetatable({}, any_load_result1_result1_upvr_5)
setmetatable_result1_upvr.ClassName = "ConfirmChoicePane"
setmetatable_result1_upvr.__index = setmetatable_result1_upvr
local var1_result1_upvr_2 = any_load_result1("Signal")
local any_load_result1_result1_upvr_2 = any_load_result1("ValueObject")
local any_load_result1_result1_upvr_3 = any_load_result1("DialogConstants")
function setmetatable_result1_upvr.new(arg1, arg2) -- Line 19
	--[[ Upvalues[5]:
		[1]: any_load_result1_result1_upvr_5 (readonly)
		[2]: setmetatable_result1_upvr (readonly)
		[3]: var1_result1_upvr_2 (readonly)
		[4]: any_load_result1_result1_upvr_2 (readonly)
		[5]: any_load_result1_result1_upvr_3 (readonly)
	]]
	local setmetatable_result1 = setmetatable(any_load_result1_result1_upvr_5.new(), setmetatable_result1_upvr)
	setmetatable_result1._serviceBag = assert(arg1, "No serviceBag")
	local var8 = arg2
	if not var8 then
		var8 = error("no container")
	end
	setmetatable_result1._container = var8
	setmetatable_result1.ChoiceConfirmed = var1_result1_upvr_2.new()
	setmetatable_result1._maid:GiveTask(setmetatable_result1.ChoiceConfirmed)
	setmetatable_result1.CurrentChoicePaneValue = any_load_result1_result1_upvr_2.new()
	setmetatable_result1._maid:GiveTask(setmetatable_result1.CurrentChoicePaneValue)
	setmetatable_result1._accentColorValue = Instance.new("Color3Value")
	setmetatable_result1._accentColorValue.Value = any_load_result1_result1_upvr_3.DEFAULT_ACCENT_COLOR
	setmetatable_result1._maid:GiveTask(setmetatable_result1._accentColorValue)
	return setmetatable_result1
end
function setmetatable_result1_upvr.HideChoicePane(arg1) -- Line 38
	arg1._maid._choicePaneMaid = nil
end
function setmetatable_result1_upvr.SetAccentColor(arg1, arg2) -- Line 42
	local var9
	if typeof(arg2) ~= "Color3" then
		var9 = false
	else
		var9 = true
	end
	assert(var9, "Bad accentColor")
	arg1._accentColorValue.Value = arg2
end
function setmetatable_result1_upvr.IsShowingChoicePane(arg1) -- Line 48
	local var10
	if arg1.CurrentChoicePaneValue.Value == nil then
		var10 = false
	else
		var10 = true
	end
	return var10
end
local var1_result1_upvr = any_load_result1("Maid")
local any_load_result1_result1_upvr_4 = any_load_result1("DialogChoiceUtils")
local any_load_result1_result1_upvr = any_load_result1("DialogChoicesPane")
function setmetatable_result1_upvr.ShowChoicePane(arg1, arg2) -- Line 52
	--[[ Upvalues[3]:
		[1]: var1_result1_upvr (readonly)
		[2]: any_load_result1_result1_upvr_4 (readonly)
		[3]: any_load_result1_result1_upvr (readonly)
	]]
	if arg1:IsShowingChoicePane() and not arg2 then
	else
		local any_new_result1 = var1_result1_upvr.new()
		local any_new_result1_upvr = any_load_result1_result1_upvr.new(arg1._serviceBag, any_load_result1_result1_upvr_4.createChoices("sliderChoice", {any_load_result1_result1_upvr_4.createLocalizedChoice("confirm", "slider.confirm"), any_load_result1_result1_upvr_4.createLocalizedChoice("change", "slider.change")}))
		any_new_result1_upvr.Gui.AnchorPoint = Vector2.new(1, 0)
		any_new_result1_upvr.Gui.Position = UDim2.new(1, 0, 0, 0)
		any_new_result1_upvr.Gui.Parent = arg1._container
		any_new_result1_upvr:SetAccentColor(arg1._accentColorValue.Value)
		any_new_result1:GiveTask(function() -- Line 71
			--[[ Upvalues[1]:
				[1]: any_new_result1_upvr (readonly)
			]]
			any_new_result1_upvr:Hide()
			task.delay(1, function() -- Line 73
				--[[ Upvalues[1]:
					[1]: any_new_result1_upvr (copied, readonly)
				]]
				any_new_result1_upvr:Destroy()
			end)
		end)
		any_new_result1:GiveTask(any_new_result1_upvr.ChoiceSelected:Connect(function(arg1_2) -- Line 78
			--[[ Upvalues[1]:
				[1]: arg1 (readonly)
			]]
			if arg1_2.key == "confirm" then
				arg1.ChoiceConfirmed:Fire()
			elseif arg1_2.key == "change" then
				arg1:HideChoicePane()
			end
		end))
		arg1.CurrentChoicePaneValue.Value = any_new_result1_upvr
		any_new_result1:GiveTask(function() -- Line 87
			--[[ Upvalues[2]:
				[1]: arg1 (readonly)
				[2]: any_new_result1_upvr (readonly)
			]]
			if arg1.CurrentChoicePaneValue.Value == any_new_result1_upvr then
				arg1.CurrentChoicePaneValue.Value = nil
			end
		end)
		any_new_result1:GiveTask(arg1._accentColorValue.Changed:Connect(function() -- Line 93
			--[[ Upvalues[2]:
				[1]: any_new_result1_upvr (readonly)
				[2]: arg1 (readonly)
			]]
			any_new_result1_upvr:SetAccentColor(arg1._accentColorValue.Value)
		end))
		any_new_result1_upvr:Show()
		arg1._maid._choicePaneMaid = any_new_result1
	end
end
return setmetatable_result1_upvr