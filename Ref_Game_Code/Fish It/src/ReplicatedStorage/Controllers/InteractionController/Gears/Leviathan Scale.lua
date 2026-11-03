-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Lighting = game:GetService("Lighting")
local Replion = require(ReplicatedStorage.Packages.Replion)
local Net = require(ReplicatedStorage.Packages.Net)
local spr = require(ReplicatedStorage.Packages.spr)
local Soundbook = require(ReplicatedStorage.Shared.Soundbook)
local TextNotificationController = require(ReplicatedStorage.Controllers.TextNotificationController)
local v1 = Net:RemoteFunction("ConsumeItem")
return function(p1, p2) --[[ Line: 18 | Upvalues: Replion (copy), TextNotificationController (copy), v1 (copy), Soundbook (copy), Lighting (copy), spr (copy) ]]
	local v12 = Replion.Client:GetReplion("LeviathanEvent")
	if not v12 then
		return
	end
	if not Replion.Client:GetReplion("Data") then
		return
	end
	if not p2 then
		return
	end
	if v12:GetExpect("Lobby") or v12:GetExpect("Event") then
		TextNotificationController:DeliverNotification({
			Type = "Text",
			Text = "Event is already active!",
			TextColor = {
				R = 255,
				G = 0,
				B = 0
			}
		})
		return
	end
	if not v1:InvokeServer(p2.UUID) then
		return
	end
	local v2 = Soundbook.Sounds.DivingToggle:Play()
	v2.Volume = v2.Volume * 2
	v2.PlaybackSpeed = 1 + math.random() * 0.5
	local LeviathanEffect = script.ColorCorrection:Clone()
	LeviathanEffect.Name = "LeviathanEffect"
	LeviathanEffect.Parent = Lighting
	spr.target(LeviathanEffect, 0.6, 0.3, {
		Brightness = 0,
		Contrast = 0,
		TintColor = Color3.new(255/255, 255/255, 255/255)
	})
	spr.completed(LeviathanEffect, function() --[[ Line: 63 | Upvalues: LeviathanEffect (copy) ]]
		LeviathanEffect:Destroy()
	end)
	TextNotificationController:DeliverNotification({
		Type = "Text",
		Text = "CONSUMED LEVIATHAN SCALE!",
		TextColor = {
			R = 51,
			G = 33,
			B = 255
		}
	})
end