-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Net = require(ReplicatedStorage.Packages.Net)
local Replion = require(ReplicatedStorage.Packages.Replion)
local ColorOptions = require(script.ColorOptions)
local TableUtil = require(ReplicatedStorage.Modules.Util.TableUtil)
local TweenUtil = require(ReplicatedStorage.Modules.Util.TweenUtil)
local v1 = nil
local Chest = script:WaitForChild("Chest")
local OpenChest = script:WaitForChild("OpenChest")
local v2 = Net:RemoteEvent("ClaimPirateChest")
Net:RemoteEvent("AwardPirateChest")
local function SpawnChest(p1) --[[ SpawnChest | Line: 26 | Upvalues: Chest (copy), v1 (ref), ColorOptions (copy), Players (copy), OpenChest (copy), v2 (copy) ]]
	local v12 = Chest:Clone()
	v12.Name = p1.Id
	local v22 = CFrame.new(p1.Location)
	local Angles = CFrame.Angles
	v12:PivotTo(v22 * Angles(0, math.rad((math.random(-180, 180))), 0))
	v12.Parent = v1
	local v4 = ColorOptions[math.random(1, #ColorOptions)]
	for v5, v6 in v12:GetDescendants() do
		if v6:IsA("BasePart") then
			local v7 = v6:GetAttribute("ColorState")
			if v7 then
				v6.Color = v4[v7]
			end
		end
	end
	v12.Cover.ProximityPrompt.Triggered:Connect(function(p1) --[[ Line: 43 | Upvalues: Players (ref), OpenChest (ref), v2 (ref), v12 (copy) ]]
		if p1 ~= Players.LocalPlayer or not p1.Character then
			return
		end
		p1.Character.Humanoid.Animator:LoadAnimation(OpenChest):Play()
		task.wait(0.35)
		v2:FireServer(v12.Name)
	end)
end
local function RemoveChest(p1) --[[ RemoveChest | Line: 65 | Upvalues: v1 (ref), TweenUtil (copy) ]]
	local v12 = v1:FindFirstChild(p1.Id)
	if not v12 then
		return
	end
	for v2, v3 in v12:GetDescendants() do
		if v3:IsA("BasePart") then
			v3.CanCollide = false
			v3.CastShadow = false
		end
	end
	v12.Cover.ProximityPrompt:Destroy()
	TweenUtil.TweenModelCFrame(v12.Top, v12.Top:GetPivot() * CFrame.Angles(2.6179938779914944, 0, 0), false, TweenInfo.new(0.2), function() --[[ Line: 78 | Upvalues: TweenUtil (ref), v12 (copy) ]]
		TweenUtil.TweenModelTransparency(v12, 1, TweenInfo.new(0.5))
	end)
	v12:Destroy()
end
return {
	Start = function(p1) --[[ Start | Line: 90 | Upvalues: v1 (ref), Replion (copy), TableUtil (copy), SpawnChest (copy), RemoveChest (copy) ]]
		v1 = Instance.new("Folder")
		v1.Name = "PirateChestStorage"
		v1.Parent = workspace
		Replion.Client:AwaitReplion("PirateTreasureChests", function(p1) --[[ Line: 95 | Upvalues: TableUtil (ref), v1 (ref), SpawnChest (ref), RemoveChest (ref) ]]
			p1:OnChange("SpawnedChests", function(p12, p2) --[[ Line: 96 | Upvalues: p1 (copy), TableUtil (ref), v1 (ref) ]]
				local v12 = p1:GetExpect("RespawningChests")
				if not (TableUtil.Count(p12) <= 0 and v12) then
					return
				end
				v1:ClearAllChildren()
			end)
			p1:OnArrayInsert("SpawnedChests", function(p1, p2) --[[ Line: 104 | Upvalues: SpawnChest (ref) ]]
				SpawnChest(p2)
			end)
			p1:OnArrayRemove("SpawnedChests", function(p1, p2) --[[ Line: 108 | Upvalues: RemoveChest (ref) ]]
				task.defer(RemoveChest, p2)
			end)
			for v12, v2 in p1:GetExpect("SpawnedChests") do
				SpawnChest(v2)
			end
		end)
	end
}