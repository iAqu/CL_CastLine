-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
game:GetService("RunService")
require(ReplicatedStorage.Packages.Net)
local Replion = require(ReplicatedStorage.Packages.Replion)
local Observers = require(ReplicatedStorage.Packages.Observers)
local Trove = require(ReplicatedStorage.Packages.Trove)
require(ReplicatedStorage.Packages.spr)
Replion.Client:AwaitReplion("Data", function(p1) --[[ Line: 18 | Upvalues: ReplicatedStorage (copy), Observers (copy), Trove (copy), Players (copy) ]]
	local TextNotificationController = require(ReplicatedStorage.Controllers.TextNotificationController)
	local PromptController = require(ReplicatedStorage.Controllers.PromptController)
	local PurchaseScreenBlackoutController = require(ReplicatedStorage.Controllers.PurchaseScreenBlackoutController)
	local Soundbook = require(ReplicatedStorage.Shared.Soundbook)
	Observers.observeTag("CrystalCavernFastTravel", function(p12) --[[ Line: 25 | Upvalues: Trove (ref), Players (ref), p1 (copy), TextNotificationController (copy), PromptController (copy), Soundbook (copy), PurchaseScreenBlackoutController (copy) ]]
		local v1 = Trove.new()
		local StartTeleport = p12:WaitForChild("StartTeleport", 30)
		if not StartTeleport then
			return
		end
		local TELEPORT_PROMPT = StartTeleport:WaitForChild("TELEPORT_PROMPT", 30)
		if not TELEPORT_PROMPT then
			return
		end
		local ProximityPrompt = TELEPORT_PROMPT:WaitForChild("ProximityPrompt", 40)
		if not ProximityPrompt then
			return
		end
		local TeleportTo = p12:WaitForChild("TeleportTo", 30)
		if TeleportTo then
			local v2 = false
			v1:Add(ProximityPrompt.Triggered:Connect(function(p12) --[[ Line: 49 | Upvalues: Players (ref), p1 (ref), TextNotificationController (ref), v2 (ref), PromptController (ref), TeleportTo (copy), Soundbook (ref), PurchaseScreenBlackoutController (ref) ]]
				if not p12 then
					return
				end
				if p12 ~= Players.LocalPlayer then
					return
				end
				local Character = p12.Character
				if not Character then
					return
				end
				if not Character:FindFirstChildWhichIsA("Humanoid") then
					return
				end
				local v1 = p1:GetExpect("Level") or 0
				if not v1 then
					return
				end
				local v22 = p1:GetExpect("CandyCorns") or 0
				if not v22 then
					return
				end
				if v1 < 30 then
					TextNotificationController:DeliverNotification({
						Type = "Text",
						Text = "You need to be < LEVEL 30+ >",
						TextColor = {
							R = 255,
							G = 0,
							B = 0
						}
					})
					return
				end
				if v22 < 10000 then
					TextNotificationController:DeliverNotification({
						Type = "Text",
						Text = "You need at least < 10,000 > Candy Corns \240\159\142\131!",
						TextColor = {
							R = 255,
							G = 0,
							B = 0
						}
					})
					return
				end
				if v2 then
					return
				end
				v2 = true
				local v3, v4 = PromptController:FirePrompt("Teleport to Crystal Cavern?"):catch(warn):await()
				if v3 and v4 then
					task.delay(2, function() --[[ Line: 114 | Upvalues: Character (copy), TeleportTo (ref) ]]
						if not (Character and Character:IsDescendantOf(workspace)) then
							return
						end
						Character:PivotTo(TeleportTo.CFrame * CFrame.new(0, 5, 0))
					end)
					Soundbook.Sounds.TeleportActivated:Play()
					PurchaseScreenBlackoutController.blackoutScreen(TeleportTo.CFrame, true)
				end
				v2 = false
			end))
			return function() --[[ Line: 133 | Upvalues: v1 (ref) ]]
				if not v1 then
					return
				end
				v1:Destroy()
				v1 = nil
			end
		end
	end)
end)
return {}