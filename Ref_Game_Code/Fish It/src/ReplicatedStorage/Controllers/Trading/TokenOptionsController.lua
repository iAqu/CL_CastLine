-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
require(ReplicatedStorage.Packages.Net)
require(ReplicatedStorage.Packages.Replion)
local GuiControl = require(ReplicatedStorage.Modules.GuiControl)
local v1 = Players.LocalPlayer.PlayerGui:WaitForChild("! Trade Tokens")
local BottomButtons = v1.Frame.BottomButtons
local TopButtons = v1.Frame.TopButtons
return {
	Start = function(p1) --[[ Start | Line: 18 | Upvalues: GuiControl (copy), BottomButtons (copy), TopButtons (copy) ]]
		GuiControl:Hook("Hold Button", BottomButtons["5"].Switch).Clicked:Connect(function() --[[ Line: 19 | Upvalues: BottomButtons (ref) ]]
			BottomButtons["5"].Visible = not BottomButtons["5"].Visible
			BottomButtons["6"].Visible = not BottomButtons["6"].Visible
		end)
		GuiControl:Hook("Hold Button", BottomButtons["6"].Switch).Clicked:Connect(function() --[[ Line: 24 | Upvalues: BottomButtons (ref) ]]
			BottomButtons["5"].Visible = not BottomButtons["5"].Visible
			BottomButtons["6"].Visible = not BottomButtons["6"].Visible
		end)
		GuiControl:Hook("Hold Button", TopButtons["1"].Switch).Clicked:Connect(function() --[[ Line: 29 | Upvalues: TopButtons (ref) ]]
			TopButtons["1"].Visible = not TopButtons["1"].Visible
			TopButtons["1.5"].Visible = not TopButtons["1.5"].Visible
		end)
		GuiControl:Hook("Hold Button", TopButtons["1.5"].Switch).Clicked:Connect(function() --[[ Line: 34 | Upvalues: TopButtons (ref) ]]
			TopButtons["1"].Visible = not TopButtons["1"].Visible
			TopButtons["1.5"].Visible = not TopButtons["1.5"].Visible
		end)
	end
}