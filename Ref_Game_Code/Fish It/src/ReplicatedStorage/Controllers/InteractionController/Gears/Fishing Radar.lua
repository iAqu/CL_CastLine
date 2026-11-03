-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Lighting = game:GetService("Lighting")
local Replion = require(ReplicatedStorage.Packages.Replion)
local Net = require(ReplicatedStorage.Packages.Net)
local spr = require(ReplicatedStorage.Packages.spr)
local Soundbook = require(ReplicatedStorage.Shared.Soundbook)
local ClientTimeController = require(ReplicatedStorage.Controllers.ClientTimeController)
local TextNotificationController = require(ReplicatedStorage.Controllers.TextNotificationController)
local v1 = Net:RemoteFunction("UpdateFishingRadar")
return function() --[[ Line: 18 | Upvalues: Replion (copy), v1 (copy), Soundbook (copy), Lighting (copy), spr (copy), ClientTimeController (copy), TextNotificationController (copy) ]]
	local v12 = Replion.Client:GetReplion("Data")
	if not v12 then
		return
	end
	local v2 = not v12:Get("RegionsVisible")
	if not v1:InvokeServer(v2) then
		return
	end
	Soundbook.Sounds.RadarToggle:Play().PlaybackSpeed = 1 + math.random() * 0.3
	local v3 = Lighting:FindFirstChildWhichIsA("ColorCorrectionEffect")
	if v3 then
		spr.stop(v3)
		local v4 = ClientTimeController:_getLightingProfile()
		local v5 = if v4 and v4.ColorCorrection then v4.ColorCorrection else {}
		if not v5.Brightness then
			v5.Brightness = 0.04
		end
		if not v5.TintColor then
			v5.TintColor = Color3.fromRGB(255, 255, 255)
		end
		v3.TintColor = Color3.fromRGB(42, 226, 118)
		v3.Brightness = 0.4
		spr.target(v3, 1, 1, v5)
	end
	spr.stop(Lighting)
	Lighting.ExposureCompensation = 1
	spr.target(Lighting, 1, 2, {
		ExposureCompensation = 0
	})
	TextNotificationController:DeliverNotification({
		Type = "Text",
		Text = ("Radar: %*"):format(if v2 then "Enabled" else "Disabled"),
		TextColor = v2 and {
			R = 9,
			G = 255,
			B = 0
		} or {
			R = 255,
			G = 0,
			B = 0
		}
	})
end