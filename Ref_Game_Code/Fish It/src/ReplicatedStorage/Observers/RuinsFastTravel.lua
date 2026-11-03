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
Replion.Client:AwaitReplion("Data", function(p1) --[[ Line: 20 | Upvalues: ReplicatedStorage (copy), Observers (copy), Trove (copy), Players (copy) ]]
	local ItemUtility = require(ReplicatedStorage.Shared.ItemUtility)
	local PlayerStatsUtility = require(ReplicatedStorage.Shared.PlayerStatsUtility)
	local TextNotificationController = require(ReplicatedStorage.Controllers.TextNotificationController)
	local PromptController = require(ReplicatedStorage.Controllers.PromptController)
	local PurchaseScreenBlackoutController = require(ReplicatedStorage.Controllers.PurchaseScreenBlackoutController)
	local Soundbook = require(ReplicatedStorage.Shared.Soundbook)
	Observers.observeTag("RuinsFastTravel", function(p12) --[[ Line: 30 | Upvalues: Trove (ref), TextNotificationController (copy), Players (ref), p1 (copy), ItemUtility (copy), PlayerStatsUtility (copy), PromptController (copy), Soundbook (copy), PurchaseScreenBlackoutController (copy) ]]
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
			local v2 = p12:GetAttribute("HazmatSuit")
			local v3 = false
			local function ReportUserError(p1) --[[ ReportUserError | Line: 56 | Upvalues: TextNotificationController (ref) ]]
				TextNotificationController:DeliverNotification({
					Type = "Text",
					Text = p1,
					TextColor = {
						R = 255,
						G = 0,
						B = 0
					}
				})
			end
			v1:Add(ProximityPrompt.Triggered:Connect(function(p13) --[[ Line: 64 | Upvalues: Players (ref), p1 (ref), v2 (copy), ItemUtility (ref), ReportUserError (copy), PlayerStatsUtility (ref), p12 (copy), v3 (ref), ProximityPrompt (copy), PromptController (ref), TeleportTo (copy), Soundbook (ref), PurchaseScreenBlackoutController (ref) ]]
				if not p13 then
					return
				end
				if p13 ~= Players.LocalPlayer then
					return
				end
				local Character = p13.Character
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
				if v2 then
					local v22 = ItemUtility.GetItemDataFromItemType("Gears", "Hazmat Suit")
					if not v22 then
						return
					end
					if p1:GetExpect("EquippedOxygenTankId") ~= v22.Data.Id then
						ReportUserError("You are not wearing a Hazmat Suit!")
						return
					end
					if not PlayerStatsUtility:GetItemFromInventory(p1, function(p1) --[[ Line: 98 | Upvalues: v22 (copy) ]]
						return p1.Id == v22.Data.Id
					end) then
						ReportUserError("You do not own a Hazmat Suit!")
						return
					end
				end
				local v32 = p12:GetAttribute("OverrideLevel") or 200
				if v1 < v32 then
					ReportUserError((("You need to be level %*+"):format(v32)))
					return
				end
				if v3 then
					return
				end
				v3 = true
				local v4, v5 = PromptController:FirePrompt(ProximityPrompt:GetAttribute("PromptText") or "Use portal?"):catch(warn):await()
				if not (v4 and v5) then
					v3 = false
					return
				end
				task.delay(2, function() --[[ Line: 131 | Upvalues: Character (copy), TeleportTo (ref) ]]
					if not (Character and Character:IsDescendantOf(workspace)) then
						return
					end
					Character:PivotTo(TeleportTo.CFrame * CFrame.new(0, 5, 0))
				end)
				Soundbook.Sounds.TeleportActivated:Play()
				PurchaseScreenBlackoutController.blackoutScreen(TeleportTo.CFrame, true)
				v3 = false
			end))
			return function() --[[ Line: 150 | Upvalues: v1 (ref) ]]
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