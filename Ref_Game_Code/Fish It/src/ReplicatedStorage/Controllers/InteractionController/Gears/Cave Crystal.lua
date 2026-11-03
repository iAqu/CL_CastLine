-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Lighting = game:GetService("Lighting")
local Players = game:GetService("Players")
game:GetService("Debris")
local VFX = ReplicatedStorage:WaitForChild("VFX")
local Replion = require(ReplicatedStorage.Packages.Replion)
local Net = require(ReplicatedStorage.Packages.Net)
local spr = require(ReplicatedStorage.Packages.spr)
local Soundbook = require(ReplicatedStorage.Shared.Soundbook)
local TextNotificationController = require(ReplicatedStorage.Controllers.TextNotificationController)
local ForgeVFX = require(ReplicatedStorage.Packages.ForgeVFX)
local LocalPlayer = Players.LocalPlayer
local v1 = Net:RemoteFunction("ConsumeCaveCrystal")
return function() --[[ Line: 21 | Upvalues: Replion (copy), LocalPlayer (copy), v1 (copy), VFX (copy), ForgeVFX (copy), Soundbook (copy), spr (copy), Lighting (copy), TextNotificationController (copy) ]]
	if not Replion.Client:GetReplion("Data") then
		return
	end
	local Character = LocalPlayer.Character
	if not Character then
		return
	end
	local v12, v2 = v1:InvokeServer()
	if not v12 then
		TextNotificationController:DeliverNotification({
			Type = "Text",
			Text = v2 or "Failed to activate!",
			TextColor = {
				R = 255,
				G = 100,
				B = 100
			}
		})
		return
	end
	local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")
	if HumanoidRootPart then
		local CrystalfallActivation = VFX:FindFirstChild("CrystalfallActivation")
		if CrystalfallActivation then
			local v3 = CrystalfallActivation:Clone()
			v3.Parent = HumanoidRootPart
			if v3:IsA("BasePart") then
				v3.CFrame = HumanoidRootPart.CFrame
				v3.Anchored = false
				v3.CanCollide = false
				v3.Massless = true
				local WeldConstraint = Instance.new("WeldConstraint")
				WeldConstraint.Part0 = HumanoidRootPart
				WeldConstraint.Part1 = v3
				WeldConstraint.Parent = v3
			end
			ForgeVFX.emit(v3).Finished:andThen(function() --[[ Line: 55 | Upvalues: v3 (copy) ]]
				v3:Destroy()
			end)
		end
	end
	Soundbook.Sounds.RadarToggle:Play().PlaybackSpeed = 1.2
	spr.stop(Lighting)
	Lighting.ExposureCompensation = 0.5
	spr.target(Lighting, 1, 2, {
		ExposureCompensation = 0
	})
	local v4 = Lighting:FindFirstChildWhichIsA("ColorCorrectionEffect")
	if v4 then
		spr.stop(v4)
		v4.TintColor = Color3.fromRGB(120, 200, 255)
		v4.Brightness = 0.3
		spr.target(v4, 1, 1, {
			Brightness = 0.04,
			TintColor = Color3.fromRGB(255, 255, 255)
		})
	end
	TextNotificationController:DeliverNotification({
		Type = "Text",
		Text = "Crystalized buff activated!",
		TextColor = {
			R = 120,
			G = 200,
			B = 255
		}
	})
end