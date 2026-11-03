-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local Debris = game:GetService("Debris")
local Players = game:GetService("Players")
game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Net = require(ReplicatedStorage.Packages.Net)
local Tiers = require(ReplicatedStorage.Tiers)
local Soundbook = require(ReplicatedStorage.Shared.Soundbook)
local ItemUtility = require(ReplicatedStorage.Shared.ItemUtility)
local TweenUtil = require(ReplicatedStorage.Modules.Util.TweenUtil)
require(ReplicatedStorage.Modules.Util.TableUtil)
local VFXController = require(ReplicatedStorage.Controllers.VFXController)
local ModelDownloader = require(game.ReplicatedStorage.Modules.ModelDownloader)
local TreasureHuntRewards = require(ReplicatedStorage.Shared.TreasureHuntRewards)
local v1 = Net:RemoteEvent("TreasureChestClaimed")
local t = {}
local function ChangeColor(p1, p2) --[[ ChangeColor | Line: 26 ]]
	for v1, v2 in p1:GetDescendants() do
		if v2:IsA("ParticleEmitter") then
			v2.Color = p2
		end
	end
end
local function PurgeVFX(p1) --[[ PurgeVFX | Line: 33 ]]
	for v1, v2 in p1:GetDescendants() do
		if v2:IsA("ParticleEmitter") or v2:IsA("Beam") then
			v2:Destroy()
		end
	end
end
local function ShouldPlay(p1) --[[ ShouldPlay | Line: 41 | Upvalues: Players (copy) ]]
	local v1 = Players.LocalPlayer and Players.LocalPlayer.Character
	if not v1 then
		return false
	end
	return (v1:GetPivot().Position - p1).Magnitude <= 250
end
local function SetAnchored(p1, p2) --[[ SetAnchored | Line: 49 ]]
	for v1, v2 in p1:GetDescendants() do
		if v2:IsA("BasePart") then
			v2.Anchored = p2
			v2.CastShadow = false
		end
	end
end
local function GetObject(p1) --[[ GetObject | Line: 58 | Upvalues: ReplicatedStorage (copy), ItemUtility (copy), ModelDownloader (copy) ]]
	if p1.Type == "Coins" then
		local Model = Instance.new("Model")
		local v1 = ReplicatedStorage.Assets.Coins:Clone()
		v1.Anchored = true
		v1.Parent = Model
		Model.PrimaryPart = v1
		return Model
	end
	if p1.Type == "Item" then
		ItemUtility:GetItemData(p1.Id)
	elseif p1.Type == "Potion" then
		ItemUtility:GetPotionData(p1.Id)
	elseif p1.Type == "Lanterns" then
		ItemUtility:GetLanternData(p1.Id)
	elseif p1.Type == "Enchant Stones" then
		ItemUtility:GetEnchantData(p1.Id)
	end
	local v2 = ModelDownloader:GetModel(p1.Type, p1.Id, false)
	if not v2 then
		return nil
	end
	if v2:IsA("Tool") then
		local Model = Instance.new("Model")
		Model.Name = v2.Name
		for v3, v4 in v2:GetChildren() do
			v4.Parent = Model
		end
		Model.PrimaryPart = Model:FindFirstChild("Handle")
		return Model
	else
		if v2:IsA("BasePart") then
			local Model = Instance.new("Model")
			Model.Name = v2.Name
			v2.Parent = Model
			Model.PrimaryPart = v2
			return Model
		end
		if v2:IsA("Model") then
			return v2
		else
			warn("Unhandled object type!", v2.ClassName)
			return nil
		end
	end
end
local function GetPossibleRewardObjects(p1, p2) --[[ GetPossibleRewardObjects | Line: 105 | Upvalues: TreasureHuntRewards (copy), GetObject (copy), SetAnchored (copy), ItemUtility (copy) ]]
	local count = 0
	local t = {}
	local t2 = {}
	for v1, v2 in TreasureHuntRewards[p1] do
		local v3, v4, v5, v6, v7, v8
		if v2.Type == "Coins" then
			if count < 2 then
				count = count + 1
				v3 = GetObject(v2)
				if v3 then
					SetAnchored(v3, true)
					v3.Parent = workspace.CurrentCamera
					v3:PivotTo(p2)
					table.insert(t, v3)
					v4 = nil
					if v2.Type == "Item" then
						v5 = ItemUtility:GetItemData(v2.Id)
						v4 = v5
					elseif v2.Type == "Potion" then
						v6 = ItemUtility:GetPotionData(v2.Id)
						v4 = v6
					elseif v2.Type == "Lanterns" then
						v7 = ItemUtility:GetLanternData(v2.Id)
						v4 = v7
					end
					if v4 then
						v8 = v4.Data.Tier
						table.insert(t2, v8)
						continue
					end
					table.insert(t2, 1)
				end
			end
		else
			v3 = GetObject(v2)
			if v3 then
				SetAnchored(v3, true)
				v3.Parent = workspace.CurrentCamera
				v3:PivotTo(p2)
				table.insert(t, v3)
				v4 = nil
				if v2.Type == "Item" then
					v5 = ItemUtility:GetItemData(v2.Id)
					v4 = v5
				elseif v2.Type == "Potion" then
					v6 = ItemUtility:GetPotionData(v2.Id)
					v4 = v6
				elseif v2.Type == "Lanterns" then
					v7 = ItemUtility:GetLanternData(v2.Id)
					v4 = v7
				end
				if v4 then
					v8 = v4.Data.Tier
					table.insert(t2, v8)
					continue
				end
				table.insert(t2, 1)
			end
		end
	end
	return t, t2
end
function t.Start(p1) --[[ Start | Line: 146 | Upvalues: v1 (copy), Players (copy), Debris (copy), ItemUtility (copy), GetObject (copy), Tiers (copy), GetPossibleRewardObjects (copy), TweenUtil (copy), Soundbook (copy), SetAnchored (copy), ChangeColor (copy), ReplicatedStorage (copy), VFXController (copy) ]]
	v1.OnClientEvent:Connect(function(p1, p2) --[[ Line: 147 | Upvalues: Players (ref), Debris (ref), ItemUtility (ref), GetObject (ref), Tiers (ref), GetPossibleRewardObjects (ref), TweenUtil (ref), Soundbook (ref), SetAnchored (ref), ChangeColor (ref), ReplicatedStorage (ref), VFXController (ref) ]]
		local v1 = workspace:FindFirstChild("Sunken Wreckage")
		local v2 = v1 and v1:FindFirstChild("Treasure")
		local v3 = if v2 then v2:FindFirstChild("Top") else v2
		if not v2 or v2:GetAttribute("Opened") ~= nil then
			return
		end
		v2:SetAttribute("Opened", true)
		local Position = v2:GetPivot().Position
		local v4 = Players.LocalPlayer and Players.LocalPlayer.Character
		if not (if v4 then if (v4:GetPivot().Position - Position).Magnitude <= 250 then true else false else false) then
			return false
		end
		local Character = Players.LocalPlayer.Character
		local v6 = if Character then Character:FindFirstChild("Humanoid") else Character
		if v6 and (v6:GetState() == Enum.HumanoidStateType.Swimming and Character:FindFirstChild("HumanoidRootPart")) then
			local VectorForce = Instance.new("VectorForce")
			VectorForce.Attachment0 = Character.HumanoidRootPart.RootAttachment
			VectorForce.Force = Vector3.new(-0, -255, -0)
			VectorForce.Parent = Character.HumanoidRootPart
			Debris:AddItem(VectorForce, 6)
		end
		local v7 = nil
		if p1.Type == "Item" then
			v7 = ItemUtility:GetItemData(p1.Id)
		elseif p1.Type == "Potion" then
			v7 = ItemUtility:GetPotionData(p1.Id)
		elseif p1.Type == "Lanterns" then
			v7 = ItemUtility:GetLanternData(p1.Id)
		end
		local v11 = v7 and v7.Data.Tier or 1
		local v12 = GetObject(p1)
		if v12 then
			v12:PivotTo(CFrame.new(0, 0, 0))
			v12.Parent = workspace.CurrentCamera
			local function RollObject() --[[ RollObject | Line: 184 | Upvalues: Tiers (ref), v11 (copy), v2 (copy), GetPossibleRewardObjects (ref), p2 (copy), TweenUtil (ref), Soundbook (ref), SetAnchored (ref), v12 (copy), ChangeColor (ref), ReplicatedStorage (ref), VFXController (ref) ]]
				local v1 = Random.new()
				local TierColor = Tiers[v11].TierColor
				local v22 = v2.Shine.CFrame + Vector3.new(0, 3, 0)
				local v3, v4 = GetPossibleRewardObjects(p2, v22 - Vector3.new(0, 20, 0))
				local function TweenIn(p1, p2) --[[ TweenIn | Line: 193 | Upvalues: v22 (copy), TweenUtil (ref) ]]
					p1:PivotTo(v22)
					p1:ScaleTo(0.8)
					task.defer(TweenUtil.TweenModelSize, p1, if p2 or false then 1.8 else 1.5, false, TweenInfo.new(0.1, Enum.EasingStyle.Cubic, Enum.EasingDirection.In))
				end
				local function TweenOut(p1) --[[ TweenOut | Line: 200 | Upvalues: TweenUtil (ref) ]]
					task.defer(TweenUtil.TweenModelSize, p1, 0.8, false, TweenInfo.new(0.1, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out), function(p1) --[[ Line: 201 ]]
						p1:PivotTo(CFrame.new(0, 0, 0))
					end)
				end
				local sum = 0.15
				local v5 = nil
				for i = 1, 10 do
					local v6 = v1:NextInteger(1, #v3)
					v5 = v3[v6]
					v2.Shine.Color = Tiers[v4[v6]].TierColor.Keypoints[1].Value
					TweenIn(v5)
					Soundbook.Sounds.BoxTick:Play()
					task.wait(sum + 0.05)
					TweenOut(v5)
					sum = sum + sum * 0.2
				end
				v5.Parent = nil
				for v7, v8 in v3 do
					v8:Destroy()
				end
				SetAnchored(v12, true)
				TweenIn(v12)
				v2.Shine.Color = TierColor.Keypoints[1].Value
				ChangeColor(ReplicatedStorage.VFX["Treasure Reveal"], TierColor)
				VFXController.Handle("Treasure Reveal", v2.Shine)
				task.wait(0.1)
				Soundbook.Sounds.EventRewardClaimed:Play()
				task.wait(2)
				task.defer(TweenUtil.TweenModelTransparency, v12, 1, TweenInfo.new(0.2), function() --[[ Line: 235 | Upvalues: v12 (ref) ]]
					v12:Destroy()
				end)
				ChangeColor(ReplicatedStorage.VFX["Treasure Reveal"], ColorSequence.new({ ColorSequenceKeypoint.new(0, Color3.new(255/255, 255/255, 255/255)), ColorSequenceKeypoint.new(1, Color3.new(255/255, 255/255, 255/255)) }))
			end
			VFXController.Handle("Treasure Bubbles", v2.Shine)
			TweenUtil.TweenModelCFrame(v3, v3:GetPivot() * CFrame.Angles(2.9670597283903604, 0, 0), false, TweenInfo.new(0.2, Enum.EasingStyle.Bounce, Enum.EasingDirection.Out), RollObject)
		end
	end)
end
return t