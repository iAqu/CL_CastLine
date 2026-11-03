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
	["Celestial Scythe"] = {
		RigType = "FakeRig1",
		CycleAnimations = {
			["Celestial Scythe - EquipIdle"] = "",
			["Celestial Scythe - StartRodCharge"] = "",
			["Celestial Scythe - LoopedRodCharge"] = "",
			["Celestial Scythe - ReelStart"] = "",
			["Celestial Scythe - ReelingIdle"] = "",
			["Celestial Scythe - RodThrow"] = "",
			["Celestial Scythe - ReelIntermission"] = "",
			["Celestial Scythe - FishCaught"] = ""
		}
	}
}
local t2 = {}
local v2 = Promise.promisify(function(p1) --[[ Line: 41 | Upvalues: Players (copy) ]]
	local Character = p1.Character
	local v1 = if Character then Character:FindFirstChildWhichIsA("Humanoid") else Character
	if v1 then
		return v1:GetAppliedDescription()
	else
		return Players:GetHumanoidDescriptionFromUserId(p1.UserId)
	end
end)
local function playVFX(p1, p2) --[[ playVFX | Line: 51 | Upvalues: v1 (ref), RodThrowVFXData (copy) ]]
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
local function loadTrack(p1, p2, p3, p4) --[[ loadTrack | Line: 82 | Upvalues: playVFX (copy), t2 (copy) ]]
	local v1, v2 = pcall(function() --[[ Line: 83 | Upvalues: p2 (copy), p4 (copy) ]]
		return p2:LoadAnimation(p4.Animation)
	end)
	if v1 then
		v2.Priority = Enum.AnimationPriority.Action4
		v2.Looped = false
		v2:GetMarkerReachedSignal("Throw"):Connect(function(p12) --[[ Line: 94 | Upvalues: playVFX (ref), p1 (copy) ]]
			if not p12 then
				return
			end
			playVFX(p1, p12)
		end)
		t2[p1][p3] = v2
		return v2
	end
end
local function loopTracks(p1, p2, p3) --[[ loopTracks | Line: 105 | Upvalues: t2 (copy), Animations (copy), loadTrack (copy) ]]
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
					for k2, v4 in pairs(v2) do
						v4:Stop()
					end
					local v5 = v1.PlaybackSpeed or 1
					v3:Play(nil, nil, v5)
					if v3.Length <= 0 then
						repeat
							task.wait(0.1)
						until v3.Length > 0
					end
					task.wait(v3.Length * (1 - (v5 - 1)) * 0.94)
					v3:AdjustSpeed(0)
				end
				task.wait(0.5)
			end
		end
	end
end
local function createShowcase(p1) --[[ createShowcase | Line: 146 | Upvalues: t (copy), Trove (copy), ReplicatedStorage (copy), Promise (copy), v2 (copy), Players (copy), loopTracks (copy) ]]
	local v1 = t[p1.Name]
	if not v1 then
		return
	end
	local v22 = Trove.new()
	local SpawnPart = p1:WaitForChild("SpawnPart", 100000)
	local v3 = ReplicatedStorage.Assets:FindFirstChild(v1.RigType)
	if not v3 then
		return
	end
	local v4 = v3:Clone()
	v4:WaitForChild("Head")
	v4:WaitForChild("HumanoidRootPart")
	local Humanoid = v4.Humanoid
	local Animator = Humanoid.Animator
	local RigObject = Instance.new("ObjectValue")
	RigObject.Name = "RigObject"
	RigObject.Value = v4
	RigObject.Parent = p1
	v4:PivotTo(SpawnPart.CFrame)
	v4.Parent = workspace
	local v5 = v1.Aura and ReplicatedStorage.Assets.Auras:FindFirstChild(v1.Aura)
	if v5 then
		for i, v in ipairs(v5:GetChildren()) do
			local v6 = v4:FindFirstChild(v.Name)
			if v6 then
				for i2, v7 in ipairs(v:GetChildren()) do
					v7:Clone().Parent = v6
				end
			end
		end
	end
	Promise.try(v2, Players.LocalPlayer):andThen(function(p1) --[[ Line: 188 | Upvalues: Humanoid (copy) ]]
		Humanoid:ApplyDescription(p1)
	end):catch(warn):await()
	v22:Add(task.spawn(function() --[[ Line: 194 | Upvalues: loopTracks (ref), v4 (copy), Animator (copy), v1 (copy) ]]
		while true do
			task.wait()
			loopTracks(v4, Animator, v1.CycleAnimations)
		end
	end))
	return function() --[[ Line: 201 | Upvalues: v22 (copy) ]]
		v22:Destroy()
	end
end
Observers.observeTag("RodShowcaseNPC", function(p1) --[[ Line: 206 | Upvalues: createShowcase (copy) ]]
	return createShowcase(p1)
end)
Replion.Client:AwaitReplion("Data", function() --[[ Line: 210 | Upvalues: v1 (ref), ReplicatedStorage (copy) ]]
	v1 = require(ReplicatedStorage.Controllers.VFXController)
end)
return {}