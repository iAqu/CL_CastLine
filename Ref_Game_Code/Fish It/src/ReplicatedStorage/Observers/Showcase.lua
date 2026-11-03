-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local Replion = require(ReplicatedStorage.Packages.Replion)
local Observers = require(ReplicatedStorage.Packages.Observers)
local Promise = require(ReplicatedStorage.Packages.Promise)
local Trove = require(ReplicatedStorage.Packages.Trove)
require(ReplicatedStorage.Packages.Thread)
require(ReplicatedStorage.Shared.Constants)
local RodThrowVFXData = require(ReplicatedStorage.Shared.RodThrowVFXData)
local Animations = require(ReplicatedStorage.Modules.Animations)
local v1 = nil
local t = {
	Overdrive = {
		Aura = "Overdrive",
		RigType = "LimitedRig3",
		FlagName = "OldWeeklyLimitedEndTime",
		ProductId = 3591974517,
		CycleAnimations = {
			["Overdrive - EquipIdle"] = "",
			["Overdrive - StartRodCharge"] = "",
			["Overdrive - LoopedRodCharge"] = "",
			["Overdrive - RodThrow"] = "",
			["Overdrive - ReelIntermission"] = "",
			["Overdrive - ReelStart"] = "",
			["Overdrive - ReelingIdle"] = "",
			["Overdrive - FishCaught"] = ""
		}
	},
	["Blossom Guitar"] = {
		Aura = "Blossom Guitar",
		RigType = "LimitedRig1",
		FlagName = "WeeklyLimitedEndTime",
		ProductId = 3597017700,
		CycleAnimations = {
			["Blossom Guitar - EquipIdle"] = "",
			["Blossom Guitar - StartRodCharge"] = "",
			["Blossom Guitar - LoopedRodCharge"] = "",
			["Blossom Guitar - RodThrow"] = "",
			["Blossom Guitar - ReelIntermission"] = "",
			["Blossom Guitar - ReelStart"] = "",
			["Blossom Guitar - ReelingIdle"] = "",
			["Blossom Guitar - FishCaught"] = ""
		}
	}
}
local t2 = {}
local v2 = Promise.promisify(function(p1) --[[ Line: 70 | Upvalues: Players (copy) ]]
	local Character = p1.Character
	local v1 = if Character then Character:FindFirstChildWhichIsA("Humanoid") else Character
	if v1 then
		return v1:GetAppliedDescription()
	else
		return Players:GetHumanoidDescriptionFromUserId(p1.UserId)
	end
end)
local function playVFX(p1, p2) --[[ playVFX | Line: 80 | Upvalues: v1 (ref), RodThrowVFXData (copy) ]]
	if not v1 then
		return
	end
	local v12 = RodThrowVFXData[p2]
	if not v12 then
		return
	end
	local HumanoidRootPart = p1:FindFirstChild("HumanoidRootPart")
	if not HumanoidRootPart then
		return
	end
	if v12.PlayAttachment then
		local CastingEmitVFX = p1:FindFirstChild("CastingEmitVFX", true)
		if CastingEmitVFX then
			v1.Handle(p2, CastingEmitVFX)
		end
	else
		v1.Handle(p2, HumanoidRootPart.CFrame * RodThrowVFXData[p2].Offset)
	end
end
local function loadTrack(p1, p2, p3, p4) --[[ loadTrack | Line: 111 | Upvalues: playVFX (copy), t2 (copy) ]]
	local v1, v2 = pcall(function() --[[ Line: 112 | Upvalues: p2 (copy), p4 (copy) ]]
		return p2:LoadAnimation(p4.Animation)
	end)
	if v1 then
		v2.Priority = Enum.AnimationPriority.Action4
		v2.Looped = false
		v2:GetMarkerReachedSignal("Throw"):Connect(function(p12) --[[ Line: 123 | Upvalues: playVFX (ref), p1 (copy) ]]
			if not p12 then
				return
			end
			playVFX(p1, p12)
		end)
		t2[p1][p3] = v2
		return v2
	end
end
local function loopTracks(p1, p2, p3) --[[ loopTracks | Line: 134 | Upvalues: t2 (copy), Animations (copy), loadTrack (copy) ]]
	if t2[p1] == nil then
		t2[p1] = {}
	end
	for k, v in pairs(p3) do
		local v1 = Animations[k]
		if v1 and v1.Animation then
			local v2 = t2[p1]
			if v2 then
				local v3 = v2[k]
				if not v3 then
					v3 = loadTrack(p1, p2, k, v1)
				end
				if v3 then
					if v3.Length <= 0 then
						repeat
							task.wait(0.1)
						until v3.Length > 0
					end
					for k2, v4 in pairs(v2) do
						v4:Stop()
					end
					if v1.Looped == nil then
						local Looped = v3.Looped
					else
						local Looped = v1.Looped
					end
					local v5 = v1.PlaybackSpeed or 1
					v3:Play(0.1, nil, v5)
					task.wait(v3.Length * (1 - (v5 - 1)) * 0.98)
					v3:AdjustSpeed(0)
					task.wait(1)
				end
			end
		end
	end
end
local function createShowcase(p1) --[[ createShowcase | Line: 177 | Upvalues: t (copy), Trove (copy), ReplicatedStorage (copy), Promise (copy), v2 (copy), Players (copy), loopTracks (copy) ]]
	local v1 = p1.Name
	local v22 = t[v1]
	if not v22 then
		return
	end
	local v3 = Trove.new()
	local Manifest = p1:WaitForChild("Manifest")
	local SpawnPart = p1:WaitForChild("Content"):WaitForChild("SpawnPart", 100000)
	local v4 = ReplicatedStorage.Assets:FindFirstChild(v22.RigType)
	if not v4 then
		return
	end
	local v5 = v4:Clone()
	v5:WaitForChild("Head")
	v5:WaitForChild("HumanoidRootPart")
	local Humanoid = v5.Humanoid
	local Animator = Humanoid.Animator
	local RigObject = Instance.new("ObjectValue")
	RigObject.Name = "RigObject"
	RigObject.Value = v5
	RigObject.Parent = p1
	v5:PivotTo(SpawnPart.CFrame)
	v5.Parent = workspace
	local v6 = v22.Aura and ReplicatedStorage.Assets.Auras:FindFirstChild(v22.Aura)
	if v6 then
		for i, v in ipairs(v6:GetChildren()) do
			local v7 = v5:FindFirstChild(v.Name)
			if v7 then
				for i2, v8 in ipairs(v:GetChildren()) do
					v8:Clone().Parent = v7
				end
			end
		end
	end
	Promise.try(v2, Players.LocalPlayer):andThen(function(p1) --[[ Line: 221 | Upvalues: Humanoid (copy) ]]
		Humanoid:ApplyDescription(p1)
	end):catch(warn):await()
	v3:Add(task.spawn(function() --[[ Line: 227 | Upvalues: loopTracks (ref), v5 (copy), Animator (copy), v22 (copy) ]]
		while true do
			task.wait()
			loopTracks(v5, Animator, v22.CycleAnimations)
		end
	end))
	task.spawn(function() --[[ Line: 234 | Upvalues: Manifest (copy), v1 (copy), v22 (copy) ]]
		local PRODUCT_PROMPT = Manifest:WaitForChild("Stand"):WaitForChild("PRODUCT_PROMPT")
		if not PRODUCT_PROMPT then
			return
		end
		PRODUCT_PROMPT:SetAttribute("ActionText", v1)
		PRODUCT_PROMPT:SetAttribute("DevProductId", v22.ProductId)
		PRODUCT_PROMPT:AddTag("DevProductPrompt")
	end)
	task.spawn(function() --[[ Line: 244 | Upvalues: Manifest (copy), v22 (copy) ]]
		local PurchaseOptions = Manifest:WaitForChild("Part"):WaitForChild("SurfaceGui"):WaitForChild("PurchaseOptions")
		if not PurchaseOptions then
			return
		end
		PurchaseOptions:SetAttribute("DevProductId", v22.ProductId)
		PurchaseOptions:AddTag("DevProductPurchase")
	end)
	task.spawn(function() --[[ Line: 255 | Upvalues: Manifest (copy), v22 (copy) ]]
		local Gui = Manifest:WaitForChild("Gui")
		if not Gui then
			return
		end
		local Remaining = Gui:WaitForChild("Frame"):WaitForChild("Remaining")
		Remaining:SetAttribute("MarkOffsale", true)
		Remaining:SetAttribute("LinkedFlag", v22.FlagName)
		Remaining:AddTag("DHMSLabel")
	end)
	return function() --[[ Line: 266 | Upvalues: v3 (copy) ]]
		v3:Destroy()
	end
end
Observers.observeTag("Showcase", function(p1) --[[ Line: 271 | Upvalues: createShowcase (copy) ]]
	return createShowcase(p1)
end)
Replion.Client:AwaitReplion("Data", function() --[[ Line: 275 | Upvalues: v1 (ref), ReplicatedStorage (copy) ]]
	v1 = require(ReplicatedStorage.Controllers.VFXController)
end)
return {}