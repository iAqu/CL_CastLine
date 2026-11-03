-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
game:GetService("Players")
game:GetService("RunService")
local Net = require(ReplicatedStorage.Packages.Net)
local Replion = require(ReplicatedStorage.Packages.Replion)
local Observers = require(ReplicatedStorage.Packages.Observers)
local Trove = require(ReplicatedStorage.Packages.Trove)
local PlayerStatsUtility = require(ReplicatedStorage.Shared.PlayerStatsUtility)
local ItemUtility = require(ReplicatedStorage.Shared.ItemUtility)
local Soundbook = require(ReplicatedStorage.Shared.Soundbook)
local TextNotificationController = require(ReplicatedStorage.Controllers.TextNotificationController)
local spr = require(ReplicatedStorage:WaitForChild("Packages"):WaitForChild("spr"))
local ModelDownloader = require(game.ReplicatedStorage.Modules.ModelDownloader)
local v1 = Replion.Client:WaitReplion("Data")
local v2 = Net:RemoteEvent("PlaceLeverItem")
local t = {
	["Crescent Artifact"] = Color3.fromRGB(112, 255, 69),
	["Arrow Artifact"] = Color3.fromRGB(255, 47, 47),
	["Hourglass Diamond Artifact"] = Color3.fromRGB(255, 248, 49),
	["Diamond Artifact"] = Color3.fromRGB(219, 38, 255)
}
local function OpenLever(p1) --[[ OpenLever | Line: 43 | Upvalues: v1 (copy), spr (copy), t (copy) ]]
	if not v1 then
		return
	end
	local v12 = p1:GetAttribute("Type")
	if not v1:GetExpect("TempleLevers")[v12] then
		return
	end
	local MovePiece = p1:WaitForChild("MovePiece", 5)
	local TargetPivot = p1:WaitForChild("TargetPivot", 5)
	local Crystal = p1:WaitForChild("Crystal", 5)
	if not MovePiece then
		return
	end
	if not TargetPivot then
		return
	end
	if Crystal then
		spr.target(MovePiece, 1, 3, {
			Pivot = TargetPivot.CFrame
		})
		spr.target(Crystal, 1, 1, {
			Color = t[v12]
		})
	end
end
Replion.Client:AwaitReplion("Data", function(p1) --[[ Line: 76 | Upvalues: Observers (copy), Trove (copy), OpenLever (copy), ItemUtility (copy), PlayerStatsUtility (copy), TextNotificationController (copy), v2 (copy), ModelDownloader (copy), Soundbook (copy), spr (copy) ]]
	Observers.observeTag("Lever", function(p12) --[[ Line: 78 | Upvalues: Trove (ref), OpenLever (ref), p1 (copy), ItemUtility (ref), PlayerStatsUtility (ref), TextNotificationController (ref), v2 (ref), ModelDownloader (ref), Soundbook (ref), spr (ref) ]]
		local v1 = Trove.new()
		local v22 = p12.Parent
		local v3 = v22:GetAttribute("Type")
		if not v3 then
			return
		end
		local function Clean() --[[ Clean | Line: 90 | Upvalues: p12 (copy), OpenLever (ref), v22 (copy), v1 (ref) ]]
			local ProximityPrompt = p12:FindFirstChild("ProximityPrompt")
			if ProximityPrompt then
				ProximityPrompt:Destroy()
			end
			OpenLever(v22)
			if not v1 then
				return
			end
			v1:Destroy()
			v1 = nil
		end
		local function IsClaimed() --[[ IsClaimed | Line: 108 | Upvalues: p1 (ref), v3 (copy) ]]
			return p1:GetExpect({ "TempleLevers" })[v3] or false
		end
		if p1:GetExpect({ "TempleLevers" })[v3] then
			return Clean()
		end
		local ProximityPrompt = p12:FindFirstChild("ProximityPrompt")
		if not ProximityPrompt then
			local ProximityPrompt_2 = Instance.new("ProximityPrompt")
			ProximityPrompt_2.ObjectText = ""
			ProximityPrompt_2.ActionText = "Place Item"
			ProximityPrompt_2.ClickablePrompt = true
			ProximityPrompt_2.RequiresLineOfSight = false
			ProximityPrompt_2.MaxActivationDistance = 15
			ProximityPrompt_2.GamepadKeyCode = Enum.KeyCode.DPadDown
			ProximityPrompt_2.Style = Enum.ProximityPromptStyle.Custom
			ProximityPrompt_2.Parent = p12
			ProximityPrompt = ProximityPrompt_2
		end
		v1:Add(ProximityPrompt.Triggered:Connect(function() --[[ Line: 136 | Upvalues: ItemUtility (ref), v3 (copy), PlayerStatsUtility (ref), p1 (ref), TextNotificationController (ref), v2 (ref) ]]
			local v1 = ItemUtility.GetItemDataFromItemType("Items", v3)
			if not v1 then
				return
			end
			if PlayerStatsUtility:GetItemFromInventory(p1, function(p1) --[[ Line: 142 | Upvalues: v1 (copy) ]]
				return p1.Id == v1.Data.Id
			end) then
				v2:FireServer(v3)
			else
				TextNotificationController:DeliverNotification({
					Type = "Text",
					CustomDuration = 3,
					Text = ("You need a %*!"):format(v3),
					TextColor = {
						R = 255,
						G = 0,
						B = 0
					}
				})
			end
		end))
		p1:OnChange("TempleLevers", function() --[[ Line: 165 | Upvalues: p1 (ref), v3 (copy), ItemUtility (ref), ModelDownloader (ref), Soundbook (ref), spr (ref), p12 (copy), v1 (ref), OpenLever (ref), v22 (copy) ]]
			if not p1:GetExpect({ "TempleLevers" })[v3] then
				return
			end
			local v12 = ItemUtility.GetItemDataFromItemType("Items", v3)
			if not v12 then
				return
			end
			local v2 = ModelDownloader:GetModel(v12.Data.Type, v12.Data.Id)
			if v2 then
				local v32 = v2:Clone()
				for k, v in pairs(v32:GetDescendants()) do
					if v:IsA("BasePart") then
						v.CanCollide = false
						v.CanQuery = false
						v.CanTouch = false
						v.Anchored = true
						if v.Name == "Handle" and not v32.PrimaryPart then
							v32.PrimaryPart = v
						end
					end
				end
				v32:PivotTo(game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame)
				v32.Parent = game.Workspace
				Soundbook.Sounds.JunglePlacement:Play()
				spr.target(v32, 1, 1, {
					Pivot = p12.CFrame
				})
				v1:Add(v32)
				spr.completed(v32, function() --[[ Line: 214 | Upvalues: v32 (copy), p12 (ref), OpenLever (ref), v22 (ref), v1 (ref) ]]
					v32:Destroy()
					local ProximityPrompt = p12:FindFirstChild("ProximityPrompt")
					if ProximityPrompt then
						ProximityPrompt:Destroy()
					end
					OpenLever(v22)
					if not v1 then
						return
					end
					v1:Destroy()
					v1 = nil
				end)
			else
				local ProximityPrompt = p12:FindFirstChild("ProximityPrompt")
				if ProximityPrompt then
					ProximityPrompt:Destroy()
				end
				OpenLever(v22)
				if not v1 then
					return
				end
				v1:Destroy()
				v1 = nil
			end
		end)
		return function() --[[ Line: 227 | Upvalues: v1 (ref) ]]
			if not v1 then
				return
			end
			v1:Destroy()
			v1 = nil
		end
	end)
end)
return {}