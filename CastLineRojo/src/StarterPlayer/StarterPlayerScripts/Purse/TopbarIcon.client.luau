--!strict

-- Modified copy of ryanlua/purse@1.1.6 (const -> local for tooling, topbarplus
-- require rerouted to ReplicatedStorage.Packages.TopbarPlus). See LICENSE.md.

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local BackpackScript = require(script.Parent)
local Icon = require(ReplicatedStorage.Packages.TopbarPlus)

local icon = Icon.new()
icon:modifyTheme({
	{ "IconLabelContainer", "TargetWidth", 0 }, -- Force minimum width
	{ "IconLabel", "AutoLocalize", false }, -- Don't translate font icon
})
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

syncIconState()
