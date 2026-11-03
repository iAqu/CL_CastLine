-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
require(ReplicatedStorage.Packages.Net)
local Replion = require(ReplicatedStorage.Packages.Replion)
local Observers = require(ReplicatedStorage.Packages.Observers)
local spr = require(ReplicatedStorage.Packages.spr)
local ItemUtility = require(ReplicatedStorage.Shared.ItemUtility)
local PlayerStatsUtility = require(ReplicatedStorage.Shared.PlayerStatsUtility)
Replion.Client:AwaitReplion("Data", function(p1) --[[ Line: 13 | Upvalues: ReplicatedStorage (copy), ItemUtility (copy), PlayerStatsUtility (copy), Observers (copy), Players (copy), spr (copy) ]]
	local TextNotificationController = require(ReplicatedStorage.Controllers.TextNotificationController)
	local v1 = ItemUtility.GetItemDataFromItemType("Gears", "Ruin Key")
	if v1 then
		local function doesOwnKey() --[[ doesOwnKey | Line: 22 | Upvalues: PlayerStatsUtility (ref), p1 (copy), v1 (copy) ]]
			local v12 = PlayerStatsUtility:GetItemFromInventory(p1, function(p1_2_2) --[[ Line: 23 | Upvalues: v1 (ref) ]]
				return p1_2_2.Id == v1.Data.Id
			end, "Items")
			if not v12 then
				return false, nil
			end
			return v12 ~= nil, v12.UUID
		end
		Observers.observeTag("OverlordDoor", function(p12) --[[ Line: 34 | Upvalues: Players (ref), PlayerStatsUtility (ref), p1 (copy), v1 (copy), ReplicatedStorage (ref), TextNotificationController (copy), spr (ref) ]]
			local v12 = false
			local Room = p12:WaitForChild("Room")
			local InputPart = p12:WaitForChild("InputPart")
			local Door = p12:WaitForChild("Door")
			Door:GetAttribute("Start")
			local v2 = Door:GetAttribute("Goal")
			local function createPrompt(p1, p2, p3) --[[ createPrompt | Line: 45 | Upvalues: Players (ref) ]]
				local ProximityPrompt = Instance.new("ProximityPrompt")
				ProximityPrompt.ObjectText = ""
				ProximityPrompt.ActionText = "???"
				ProximityPrompt.ClickablePrompt = true
				ProximityPrompt.RequiresLineOfSight = false
				ProximityPrompt.MaxActivationDistance = 15
				ProximityPrompt.GamepadKeyCode = Enum.KeyCode.DPadDown
				ProximityPrompt.Style = Enum.ProximityPromptStyle.Custom
				ProximityPrompt.Parent = p1
				ProximityPrompt.Triggered:Connect(function(p1) --[[ Line: 56 | Upvalues: Players (ref), p3 (copy), ProximityPrompt (copy) ]]
					if p1 == Players.LocalPlayer then
						p3(ProximityPrompt)
					end
				end)
				return {
					updateCallback = function() --[[ updateCallback | Line: 65 | Upvalues: p2 (copy), ProximityPrompt (copy) ]]
						p2(ProximityPrompt)
					end,
					interactionCallback = function() --[[ interactionCallback | Line: 68 | Upvalues: p3 (copy), ProximityPrompt (copy) ]]
						p3(ProximityPrompt)
					end
				}
			end
			local v3 = createPrompt(InputPart, function(p13) --[[ Line: 76 | Upvalues: v12 (ref), PlayerStatsUtility (ref), p1 (ref), v1 (ref), Room (copy), p12 (copy), ReplicatedStorage (ref) ]]
				if v12 then
					return
				end
				local v13 = PlayerStatsUtility:GetItemFromInventory(p1, function(p1_2_2) --[[ Line: 23 | Upvalues: v1 (ref) ]]
					return p1_2_2.Id == v1.Data.Id
				end, "Items")
				local v2
				if v13 then
					v2 = if v13 == nil then false else true
					local UUID = v13.UUID
				else
					v2 = false
				end
				if v2 then
					p13.ActionText = "Open Door"
					p13.Enabled = true
					Room.Parent = p12
				else
					p13.Enabled = true
					Room.Parent = ReplicatedStorage.Assets
				end
			end, function(p12) --[[ Line: 90 | Upvalues: v12 (ref), PlayerStatsUtility (ref), p1 (ref), v1 (ref), TextNotificationController (ref), spr (ref), Door (copy), v2 (copy) ]]
				if v12 then
					return
				end
				local v13 = PlayerStatsUtility:GetItemFromInventory(p1, function(p1_2_2) --[[ Line: 23 | Upvalues: v1 (ref) ]]
					return p1_2_2.Id == v1.Data.Id
				end, "Items")
				local v22, v3
				if v13 then
					v22 = if v13 == nil then false else true
					v3 = v13.UUID
				else
					v22 = false
					v3 = nil
				end
				if not v22 then
					TextNotificationController:DeliverNotification({
						Type = "Text",
						Text = "I can\'t access this door...",
						TextColor = {
							R = 255,
							G = 0,
							B = 0
						}
					})
					return
				end
				if p1:GetExpect("EquippedId") == v3 then
					v12 = true
					p12.Enabled = false
					TextNotificationController:DeliverNotification({
						Type = "Text",
						Text = "The door lowered!",
						TextColor = {
							R = 132,
							G = 84,
							B = 255
						}
					})
					spr.target(Door, 0.9, 0.2, {
						Pivot = v2
					})
				else
					TextNotificationController:DeliverNotification({
						Type = "Text",
						Text = "This requires a hefty key!",
						TextColor = {
							R = 0,
							G = 255,
							B = 255
						}
					})
				end
			end)
			p1:OnChange("Inventory", v3.updateCallback)
			v3.updateCallback()
		end)
	end
end)
return {}