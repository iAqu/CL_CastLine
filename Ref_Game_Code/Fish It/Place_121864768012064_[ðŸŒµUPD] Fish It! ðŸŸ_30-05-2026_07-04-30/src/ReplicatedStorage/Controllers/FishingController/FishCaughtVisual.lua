-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
game:GetService("TweenService")
game:GetService("RunService")
game:GetService("CollectionService")
game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
game:GetService("Lighting")
game:GetService("Players")
require(ReplicatedStorage.Packages.Replion)
require(ReplicatedStorage.Packages.NumberSpinner)
require(ReplicatedStorage.Packages.Signal)
require(ReplicatedStorage.Packages.Trove)
local Net = require(ReplicatedStorage.Packages.Net)
require(ReplicatedStorage.Packages.Thread)
require(ReplicatedStorage.Packages.spr)
require(ReplicatedStorage.Shared.Soundbook)
local ItemUtility = require(ReplicatedStorage.Shared.ItemUtility)
local TierUtility = require(ReplicatedStorage.Shared.TierUtility)
local ModelProvider = require(ReplicatedStorage.ModelProvider)
local PetVisualController = require(ReplicatedStorage.Controllers.PetVisualController)
local CurveUtil = require(ReplicatedStorage.Modules.Util.CurveUtil)
require(ReplicatedStorage.Types.Modifiers)
workspace:WaitForChild("Characters")
local CosmeticFolder = workspace:WaitForChild("CosmeticFolder")
workspace:WaitForChild("Vehicles")
workspace:WaitForChild("Locations")
workspace:WaitForChild("Zones")
local v1 = Net:RemoteEvent("CaughtFishVisual")
local v2 = Net:RemoteEvent("Pets/CaughtFishVisual")
local function getPrimaryPart(p1) --[[ getPrimaryPart | Line: 44 ]]
	local Handle = p1:FindFirstChild("Handle")
	if Handle and Handle:IsA("BasePart") then
		return Handle
	end
	return p1.PrimaryPart or p1:FindFirstChildWhichIsA("BasePart", true)
end
local function getCaughtVisualTemplate(p1, p2, p3) --[[ getCaughtVisualTemplate | Line: 53 | Upvalues: ReplicatedStorage (copy), ModelProvider (copy) ]]
	local Assets = ReplicatedStorage:FindFirstChild("Assets")
	if Assets then
		local v1 = Assets:FindFirstChild((tostring(p2)))
		if v1 and v1:IsA("Model") then
			return v1:Clone()
		end
	end
	return ModelProvider:GetModel(p1, "Fish", {
		Id = p2,
		Metadata = p3
	}, true)
end
local function CreateCircularPath(p1, p2, p3, p4, p5) --[[ CreateCircularPath | Line: 66 ]]
	local t = {}
	for i = 1, p4 * p5 do
		local v1 = i / p4 * math.pi * 2
		local v2 = p1.X + p2 * math.cos(v1)
		local v3 = p1.Z + p2 * math.sin(v1)
		local v4 = p1.Y + p3
		local v5 = (i + 1) / p4 * math.pi * 2
		local v6 = p1.X + p2 * math.cos(v5)
		local v7 = p1.Z + p2 * math.sin(v5)
		local v8 = Vector3.new(v2, v4, v3)
		local v9 = Vector3.new(v6, v4, v7)
		table.insert(t, CFrame.lookAt(v8, v9) * CFrame.fromOrientation(1.5707963267948966, 0, 0))
	end
	return t
end
local function MoveAlongCurve(p1, p2, p3, p4) --[[ MoveAlongCurve | Line: 93 ]]
	local v1 = tick()
	local v2 = nil
	v2 = game:GetService("RunService").Heartbeat:Connect(function() --[[ Line: 97 | Upvalues: v1 (copy), p3 (copy), p2 (copy), p1 (copy), v2 (ref), p4 (copy) ]]
		local v12_2 = (tick() - v1) / p3
		local v22 = math.min(v12_2, 1)
		local v3 = v22 * (#p2 - 1) + 1
		local v4 = math.floor(v3)
		p1:PivotTo((p2[v4]:Lerp(p2[math.min(v4 + 1, #p2)], v3 - v4)))
		if not (v22 >= 1) then
			return
		end
		v2:Disconnect()
		if not p4 then
			return
		end
		p4()
	end)
end
local function CreateSpiralPath(p1, p2, p3, p4, p5, p6, p7) --[[ CreateSpiralPath | Line: 127 ]]
	local v1 = p6 * p7
	local t = {}
	for i = 1, v1 do
		local v2 = i / v1
		local v3 = v2 * math.pi * 2 * p7
		local v4 = p3 + (p4 - p3) * v2
		local v5 = p2.X + v4 * math.cos(v3)
		local v6 = p2.Z + v4 * math.sin(v3)
		local v7 = p1.Y + (p5 - p1.Y) * math.min(v2 * 2, 1)
		local v8 = (i + 1) / v1 * math.pi * 2 * p7
		local v9 = p3 + (p4 - p3) * ((i + 1) / v1)
		local v10 = p2.X + v9 * math.cos(v8)
		local v11 = p2.Z + v9 * math.sin(v8)
		local v12 = Vector3.new(v5, v7, v6)
		local v13 = Vector3.new(v10, v7, v11)
		table.insert(t, CFrame.lookAt(v12, v13) * CFrame.fromOrientation(1.5707963267948966, 0, 0))
	end
	return t
end
local function playCaughtFishVisual(p1, p2, p3, p4, p5) --[[ playCaughtFishVisual | Line: 158 | Upvalues: getCaughtVisualTemplate (copy), ItemUtility (copy), TierUtility (copy), CosmeticFolder (copy), CreateSpiralPath (copy), CurveUtil (copy) ]]
	local v1 = getCaughtVisualTemplate(game.Players.LocalPlayer, p3, p4)
	if not v1 then
		warn("Failed to generate fish projectile!")
		return
	end
	task.delay(10, function() --[[ Line: 167 | Upvalues: v1 (copy) ]]
		if v1 then
			v1:Destroy()
		end
	end)
	if not p1 then
		return
	end
	if not p1.Character then
		return
	end
	local HumanoidRootPart = p1.Character:FindFirstChild("HumanoidRootPart")
	if not HumanoidRootPart then
		return
	end
	local v2 = if p5 then p5 else HumanoidRootPart.Position
	local Handle = v1:FindFirstChild("Handle")
	local v3
	if Handle and Handle:IsA("BasePart") then
		v3 = Handle
	else
		v3 = v1.PrimaryPart
		if not v3 then
			v3 = v1:FindFirstChildWhichIsA("BasePart", true)
		end
	end
	if not v3 then
		v1:Destroy()
		return
	end
	v1.PrimaryPart = v3
	v1:SetAttribute("UseCosmeticBulletObject", true)
	task.delay(1, function() --[[ Line: 196 | Upvalues: v1 (copy) ]]
		if not v1 then
			return
		end
		v1:Destroy()
	end)
	Instance.new("Attachment").Parent = v3
	local v5 = script.Neon.Att1:Clone()
	local v6 = script.Neon.Att0:Clone()
	local Trail = v6.Trail
	local v7 = ItemUtility:GetItemData(p3)
	if v7 then
		local v8 = nil
		if v7.Probability then
			v8 = TierUtility:GetTierFromRarity(v7.Probability.Chance)
		elseif v7.Data.Tier then
			v8 = TierUtility:GetTier(v7.Data.Tier)
		end
		if v8 then
			Trail.Color = v8.TierColor
		end
	end
	Trail.Attachment0 = v6
	Trail.Attachment1 = v5
	v6.Parent = v3
	v5.Parent = v3
	v1:PivotTo(CFrame.new(p2) * CFrame.fromOrientation(1.5707963267948966, 0, 0))
	v1.Parent = CosmeticFolder
	CreateSpiralPath(v2 + Vector3.new(0, 10, 0), v2 + Vector3.new(0, 5, 0), 10, 3, 3, 30, 2)
	local v9 = CurveUtil.GetCurveBetween({
		numPoints = 15,
		visiualize = false,
		withRotation = true,
		start = p2,
		finish = v2,
		curveHeight = p2.Y + 50,
		yRotation = CFrame.fromOrientation(1.5707963267948966, 0, 0)
	})
	local function f10() --[[ Line: 266 | Upvalues: v1 (copy) ]]
		v1:Destroy()
	end
	local v11 = tick()
	local v12 = nil
	local v13 = 0.5
	v12 = game:GetService("RunService").Heartbeat:Connect(function() --[[ Line: 97 | Upvalues: v11 (copy), v13 (copy), v9 (copy), v1 (copy), v12 (ref), f10 (copy) ]]
		local v12_2 = (tick() - v11) / v13
		local v22 = math.min(v12_2, 1)
		local v3 = v22 * (#v9 - 1) + 1
		local v4 = math.floor(v3)
		v1:PivotTo((v9[v4]:Lerp(v9[math.min(v4 + 1, #v9)], v3 - v4)))
		if not (v22 >= 1) then
			return
		end
		v12:Disconnect()
		if not f10 then
			return
		end
		f10()
	end)
end
v1.OnClientEvent:Connect(function(p1, p2, p3, p4) --[[ Line: 272 | Upvalues: playCaughtFishVisual (copy) ]]
	playCaughtFishVisual(p1, p2, p3, p4)
end)
v2.OnClientEvent:Connect(function(p1, p2, p3, p4, p5) --[[ Line: 276 | Upvalues: PetVisualController (copy), playCaughtFishVisual (copy) ]]
	local v1 = PetVisualController:GetCatchTargetPosition(p1)
	if not v1 then
		return
	end
	PetVisualController:PlayCatchAnimation(p1)
	if p5.SkipFishingPull then
		return
	end
	task.wait(p5.FishingDelay)
	playCaughtFishVisual(p1, p2, p3, p4, v1)
end)
return {}