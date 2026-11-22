--!strict

-- Modified copy of ryanlua/purse@1.2.1 (const -> local for tooling, topbarplus
-- require rerouted to ReplicatedStorage.Packages.TopbarPlus). See LICENSE.md.

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local player = game:GetService("Players").LocalPlayer

local BackpackScript = require(script.Parent)
local Icon = require(ReplicatedStorage.Packages.TopbarPlus)
local GameplayInputGate = require(ReplicatedStorage.Modules.GameplayInputGate)

local icon = Icon.new()
icon:modifyTheme({ "IconLabel", "AutoLocalize", false })
local iconLabelContainer = icon:getInstance("IconLabelContainer") :: Instance
iconLabelContainer:SetAttribute("TargetWidth", 0)
icon:setLabel("backpack")
icon:setTextSize(24)
icon:setTextFont(
	"rbxasset://LuaPackages/Packages/_Index/BuilderIcons/BuilderIcons/BuilderIcons.json",
	Enum.FontWeight.Bold,
	Enum.FontStyle.Normal,
	"Selected"
)
icon:setTextFont(
	"rbxasset://LuaPackages/Packages/_Index/BuilderIcons/BuilderIcons/BuilderIcons.json",
	Enum.FontWeight.Regular,
	Enum.FontStyle.Normal,
	"Deselected"
)
icon:setOrder(-1)
icon:bindToggleKey(Enum.KeyCode.Backquote)
icon:autoDeselect(false)
icon:setCaption("Inventory")

-- TopbarPlus also uses DPadUp when a GUI has already handled the input.
task.defer(function()
	local highlightKey = Icon.highlightKey
	if not highlightKey then
		return
	end

	local function syncHighlightShortcut()
		local uiHasFocus = GameplayInputGate.IsActive("Popup") or GameplayInputGate.IsActive("Backpack")
		Icon.highlightKey = if uiHasFocus then false else highlightKey
	end

	GameplayInputGate.ContextChanged:Connect(function(context)
		if context == "Popup" or context == "Backpack" then
			syncHighlightShortcut()
		end
	end)
	syncHighlightShortcut()
end)

local function syncIconState()
	if BackpackScript.IsOpen then
		icon:select()
	else
		icon:deselect()
	end
end

BackpackScript.StateChanged.Event:Connect(syncIconState)

icon.toggled:Connect(function(isSelected, fromSource)
	if fromSource == "User" then
		if player:GetAttribute("IsTraining") == true then
			BackpackScript.Close()
			syncIconState()
			return
		end
		-- A queued deselect must not toggle a window that is already closed.
		if isSelected then
			BackpackScript.Open()
		else
			BackpackScript.Close()
		end
		-- Opening may be blocked during fishing; reflect the actual window state.
		syncIconState()
	end
end)

local function syncTrainingVisibility()
	local training = player:GetAttribute("IsTraining") == true
	if training then
		BackpackScript.Close()
	end
	icon:setEnabled(not training)
	syncIconState()
end
player:GetAttributeChangedSignal("IsTraining"):Connect(syncTrainingVisibility)
syncTrainingVisibility()
syncIconState()
