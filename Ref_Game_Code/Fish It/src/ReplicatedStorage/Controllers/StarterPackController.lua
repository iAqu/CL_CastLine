-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local Replion = require(ReplicatedStorage.Packages.Replion)
local spr = require(ReplicatedStorage.Packages.spr)
local GuiControl = require(ReplicatedStorage.Modules.GuiControl)
local v1 = nil
local PlayerGui = Players.LocalPlayer.PlayerGui
local v2 = PlayerGui:WaitForChild("HUD").Frame["Starter Pack"]
local v3 = v2["!!! Starter Pack"]
local v4 = PlayerGui:WaitForChild("!!! Starter Pack")
local t = {
	Start = function(p1) --[[ Start | Line: 30 | Upvalues: v1 (ref), Replion (copy) ]]
		v1 = Replion.Client:WaitReplion("Data")
		v1:OnChange("StarterPackTimer", UpdateStarterPack)
		v1:OnChange("StarterPack", UpdateStarterPack)
		UpdateStarterPack()
	end
}
function FormatPackTime(p1) --[[ FormatPackTime | Line: 38 ]]
	if p1 == 0 then
		return "Offer Expired!", "0s"
	end
	local v1 = math.floor(p1 % 3600 / 60)
	local v2 = p1 % 60
	local v3 = if v1 == 1 then "Minute" else "Minutes"
	local v4 = if v2 == 1 then "Second" else "Seconds"
	if v1 >= 1 then
		return string.format("%02d %s Left!", v1, v3), string.format("%02dm, %02ds", v1, v2)
	else
		return string.format("%02d %s Left!", v2, v4), string.format("%02ds", v2)
	end
end
function UpdateStarterPack() --[[ UpdateStarterPack | Line: 56 | Upvalues: GuiControl (copy), v1 (ref), v4 (copy), v3 (copy), spr (copy), v2 (copy) ]]
	local v12 = GuiControl:IsOpen("!!! Starter Pack")
	local v22 = v1:Get("StarterPack")
	local v32 = v1:Get("StarterPackTimer")
	local v42 = false
	if v22 then
		v42 = false
	elseif v32 and v32 > 0 then
		v42 = true
	end
	if v32 then
		local v5, v6 = FormatPackTime(v32)
		local v7 = math.clamp(v32 / 900, 0, 1)
		local TimerBar = v4.Center.StarterPack.Main.TimerBar
		TimerBar.Label.Text = v5
		v3.EventTimer.Timer.Text = v6
		spr.stop(TimerBar.Progress.Mover)
		spr.target(TimerBar.Progress.Mover, 1, 3, {
			Size = UDim2.fromScale(v7, 1)
		})
	end
	v1:OnChange("StarterPackPrompted", function() --[[ Line: 83 | Upvalues: v1 (ref), v12 (copy), GuiControl (ref) ]]
		if v1:Get("StarterPackPrompted") ~= true or v12 then
			return
		end
		GuiControl:Open("!!! Starter Pack")
	end)
	v2.Visible = v42
	if not v12 or v42 then
		return
	end
	GuiControl:Close()
end
return t