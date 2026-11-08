-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Bytecode (Base64):
-- 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

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local Packages = ReplicatedStorage:WaitForChild("Packages")
local Icon = require(Packages:WaitForChild("Icon"))
local Knit = require(Packages:WaitForChild("Knit"))
local Signal = require(Packages:WaitForChild("Signal"))

require(ReplicatedStorage.Shared.Info.CustomEnum)

local v1 = Knit.CreateController({
	Name = "TopbarController"
})

v1.DebugToggle = Signal.new()
Icon.modifyBaseTheme({
	{ "IconLabel", "FontFace", Font.new("BuilderSans", Enum.FontWeight.Bold) },
	{ "IconLabel", "TextSize", 20 }
})

local SettingsSimple = Players.LocalPlayer.PlayerGui:WaitForChild("Windows"):WaitForChild("SettingsSimple")

function v1.KnitInit(p1) --[[ KnitInit | Line: 40 | Upvalues: Knit (copy) ]]
	p1.UI_Manager = Knit.GetController("UI_Manager")
	p1.HotbarController = Knit.GetController("HotbarController")
end
function v1.KnitStart(p1) --[[ KnitStart | Line: 45 | Upvalues: Icon (copy), SettingsSimple (copy) ]]
	Icon.new():setImage(131456359260980):setCaption("Open Settings"):bindEvent("deselected", function() --[[ Line: 50 | Upvalues: p1 (copy), SettingsSimple (ref) ]]
		p1.UI_Manager:ToggleWindow(SettingsSimple, true)
	end):oneClick()
	Icon.new():setImage(136007455575706):setCaption("Open Inventory"):bindEvent("deselected", function() --[[ Line: 58 | Upvalues: p1 (copy) ]]
		p1.HotbarController:ToggleInventory()
	end):oneClick()
end
function v1.AddDebug(p1) --[[ AddDebug | Line: 64 | Upvalues: Icon (copy) ]]
	Icon.new():setImage(560667850):setCaption("Open Debug Menu"):bindEvent("deselected", function() --[[ Line: 68 | Upvalues: p1 (copy) ]]
		p1.DebugToggle:Fire()
	end):oneClick()
end

return v1