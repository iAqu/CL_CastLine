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

BackpackScript.StateChanged.Event:Connect(function(isNowOpen)
	if isNowOpen then
		icon:select()
	else
		icon:deselect()
	end
end)

icon.toggled:Connect(function(_isSelected, fromSource)
	if fromSource == "User" then
		if BackpackScript.OpenClose then
			BackpackScript.OpenClose()
		end
	end
end)
