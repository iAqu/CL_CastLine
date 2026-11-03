-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
game:GetService("Players")
game:GetService("RunService")
local Net = require(ReplicatedStorage.Packages.Net)
local Replion = require(ReplicatedStorage.Packages.Replion)
local Observers = require(ReplicatedStorage.Packages.Observers)
local Trove = require(ReplicatedStorage.Packages.Trove)
local spr = require(ReplicatedStorage.Packages.spr)
local PlayerStatsUtility = require(ReplicatedStorage.Shared.PlayerStatsUtility)
local ItemUtility = require(ReplicatedStorage.Shared.ItemUtility)
require(ReplicatedStorage.Shared.Soundbook)
local v1 = nil
local v2 = Net:RemoteEvent("PlacePressureItem")
local t = {
	["Freshwater Piranha"] = Color3.fromRGB(97, 129, 188),
	["Goliath Tiger"] = Color3.fromRGB(160, 109, 190),
	["Sacred Guardian Squid"] = Color3.fromRGB(177, 153, 96),
	Crocodile = Color3.fromRGB(172, 88, 89)
}
local function OpenPressure(p1) --[[ OpenPressure | Line: 34 | Upvalues: v1 (ref), spr (copy), t (copy) ]]
	if not v1 then
		return
	end
	local v12 = p1:GetAttribute("Type")
	if not v1:GetExpect("RuinPressurePlates")[v12] then
		return
	end
	local MOVE_PART = p1:WaitForChild("MOVE_PART", 5)
	local ACCENT = MOVE_PART:WaitForChild("ACCENT", 5)
	if not MOVE_PART then
		return
	end
	if ACCENT then
		spr.target(MOVE_PART, 1, 3, {
			Pivot = MOVE_PART:GetAttribute("TargetCF")
		})
		spr.target(ACCENT, 0.5, 1, {
			Color = t[v12]
		})
	end
end
Replion.Client:AwaitReplion("Data", function(p1) --[[ Line: 59 | Upvalues: v1 (ref), ReplicatedStorage (copy), Observers (copy), Trove (copy), OpenPressure (copy), ItemUtility (copy), PlayerStatsUtility (copy), v2 (copy) ]]
	v1 = p1
	local TextNotificationController = require(ReplicatedStorage.Controllers.TextNotificationController)
	local function IsClaimed(p1) --[[ IsClaimed | Line: 64 | Upvalues: v1 (ref) ]]
		return v1:GetExpect({ "RuinPressurePlates" })[p1] or false
	end
	Observers.observeTag("PressurePlate", function(p1) --[[ Line: 70 | Upvalues: Trove (ref), OpenPressure (ref), v1 (ref), ItemUtility (ref), PlayerStatsUtility (ref), TextNotificationController (copy), v2 (ref) ]]
		local v12 = p1.Parent
		local v22 = v12:GetAttribute("Type")
		if not v22 then
			return
		end
		local v3 = Trove.new()
		local function Clean() --[[ Clean | Line: 77 | Upvalues: p1 (copy), OpenPressure (ref), v12 (copy), v3 (ref) ]]
			local ProximityPrompt = p1:FindFirstChild("ProximityPrompt")
			if ProximityPrompt then
				ProximityPrompt:Destroy()
			end
			OpenPressure(v12)
			if not v3 then
				return
			end
			v3:Destroy()
			v3 = nil
		end
		if v1:GetExpect({ "RuinPressurePlates" })[v22] then
			return Clean()
		end
		local ProximityPrompt = p1:FindFirstChild("ProximityPrompt")
		if not ProximityPrompt then
			local ProximityPrompt_2 = Instance.new("ProximityPrompt")
			ProximityPrompt_2.ObjectText = ""
			ProximityPrompt_2.ActionText = "Place Item"
			ProximityPrompt_2.ClickablePrompt = true
			ProximityPrompt_2.RequiresLineOfSight = false
			ProximityPrompt_2.MaxActivationDistance = 15
			ProximityPrompt_2.GamepadKeyCode = Enum.KeyCode.DPadDown
			ProximityPrompt_2.Style = Enum.ProximityPromptStyle.Custom
			ProximityPrompt_2.Parent = p1
			ProximityPrompt = ProximityPrompt_2
		end
		v3:Add(ProximityPrompt.Triggered:Connect(function() --[[ Line: 108 | Upvalues: ItemUtility (ref), v22 (copy), PlayerStatsUtility (ref), v1 (ref), TextNotificationController (ref), v2 (ref) ]]
			local v12 = ItemUtility.GetItemDataFromItemType("Items", v22)
			if not v12 then
				return
			end
			if PlayerStatsUtility:GetItemFromInventory(v1, function(p1) --[[ Line: 112 | Upvalues: v12 (copy) ]]
				return p1.Id == v12.Data.Id
			end, "Items") then
				v2:FireServer(v22)
			else
				TextNotificationController:DeliverNotification({
					Type = "Text",
					CustomDuration = 3,
					Text = ("You need a %*!"):format(v22),
					TextColor = {
						R = 255,
						G = 0,
						B = 0
					}
				})
			end
		end))
		v1:OnChange("RuinPressurePlates", function() --[[ Line: 131 | Upvalues: v22 (copy), v1 (ref), ItemUtility (ref), p1 (copy), OpenPressure (ref), v12 (copy), v3 (ref) ]]
			if not v1:GetExpect({ "RuinPressurePlates" })[v22] then
				return
			end
			if not ItemUtility.GetItemDataFromItemType("Items", v22) then
				return
			end
			local ProximityPrompt = p1:FindFirstChild("ProximityPrompt")
			if ProximityPrompt then
				ProximityPrompt:Destroy()
			end
			OpenPressure(v12)
			if not v3 then
				return
			end
			v3:Destroy()
			v3 = nil
		end)
		return function() --[[ Line: 140 | Upvalues: v3 (ref) ]]
			if not v3 then
				return
			end
			v3:Destroy()
			v3 = nil
		end
	end)
end)
return {}