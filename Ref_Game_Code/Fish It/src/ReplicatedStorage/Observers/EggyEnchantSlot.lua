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
	local v1 = ItemUtility.GetItemDataFromItemType("Enchant Stones", "Eggy Enchant Stone")
	if v1 then
		local function doesOwnKey() --[[ doesOwnKey | Line: 21 | Upvalues: PlayerStatsUtility (ref), p1 (copy), v1 (copy) ]]
			local v12 = PlayerStatsUtility:GetItemFromInventory(p1, function(p1_2_2_2) --[[ Line: 22 | Upvalues: v1 (ref) ]]
				return p1_2_2_2.Id == v1.Data.Id
			end, "Items")
			if not v12 then
				return false, nil
			end
			return v12 ~= nil, v12.UUID
		end
		Observers.observeTag("EnchantDoor", function(p12) --[[ Line: 33 | Upvalues: Players (ref), PlayerStatsUtility (ref), p1 (copy), v1 (copy), ReplicatedStorage (ref), TextNotificationController (copy), spr (ref) ]]
			local v12 = nil
			local v2 = false
			local Room = p12:WaitForChild("Room")
			local InputPart = p12:WaitForChild("InputPart")
			local Door = p12:WaitForChild("Door")
			Door:GetAttribute("Start")
			local v3 = Door:GetAttribute("Goal")
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
					updateCallback = function() --[[ Line: 65 | Upvalues: p2 (copy), ProximityPrompt (copy) ]]
						p2(ProximityPrompt)
					end,
					interactionCallback = function(p1) --[[ Line: 68 | Upvalues: p3 (copy), ProximityPrompt (copy) ]]
						p3(ProximityPrompt, p1)
					end
				}
			end
			local v4 = createPrompt(InputPart, function(p13) --[[ Line: 76 | Upvalues: v2 (ref), PlayerStatsUtility (ref), p1 (ref), v1 (ref), Room (copy), p12 (copy), ReplicatedStorage (ref) ]]
				if v2 then
					return
				end
				local v12 = PlayerStatsUtility:GetItemFromInventory(p1, function(p1_2_2_2) --[[ Line: 22 | Upvalues: v1 (ref) ]]
					return p1_2_2_2.Id == v1.Data.Id
				end, "Items")
				local v22
				if v12 then
					v22 = if v12 == nil then false else true
					local UUID = v12.UUID
				else
					v22 = false
				end
				if v22 then
					p13.ActionText = "Open Door"
					p13.Enabled = true
					Room.Parent = p12
				else
					p13.Enabled = true
					Room.Parent = ReplicatedStorage.Assets
				end
			end, function(p12, p2) --[[ Line: 90 | Upvalues: v2 (ref), PlayerStatsUtility (ref), p1 (ref), v1 (ref), TextNotificationController (ref), v12 (ref), Door (copy), v3 (copy), spr (ref) ]]
				if v2 then
					return
				end
				local v13 = PlayerStatsUtility:GetItemFromInventory(p1, function(p1_2_2_2) --[[ Line: 22 | Upvalues: v1 (ref) ]]
					return p1_2_2_2.Id == v1.Data.Id
				end, "Items")
				local v22
				if v13 then
					v22 = if v13 == nil then false else true
					local UUID = v13.UUID
				else
					v22 = false
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
				if v12 then
					v12:Disconnect()
				end
				v2 = true
				p12.Enabled = false
				if p2 then
					Door:PivotTo(v3)
				else
					TextNotificationController:DeliverNotification({
						Type = "Text",
						Text = "The door lowered!",
						TextColor = {
							R = 156,
							G = 234,
							B = 255
						}
					})
					spr.target(Door, 0.9, 0.2, {
						Pivot = v3
					})
				end
			end)
			local v5 = PlayerStatsUtility:GetItemFromInventory(p1, function(p1_2_2_2) --[[ Line: 22 | Upvalues: v1 (ref) ]]
				return p1_2_2_2.Id == v1.Data.Id
			end, "Items")
			local v6
			if v5 then
				v6 = v5 ~= nil
				local UUID = v5.UUID
			else
				v6 = false
			end
			if v6 then
				v4.interactionCallback(true)
			else
				v12 = p1:OnChange("Inventory", v4.updateCallback)
				v4.updateCallback()
			end
		end)
	end
end)
return {}