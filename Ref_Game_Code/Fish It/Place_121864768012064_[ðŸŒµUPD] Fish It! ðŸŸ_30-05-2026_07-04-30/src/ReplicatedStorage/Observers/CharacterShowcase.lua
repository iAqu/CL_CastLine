-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
require(ReplicatedStorage.Packages.Replion)
local Observers = require(ReplicatedStorage.Packages.Observers)
local Promise = require(ReplicatedStorage.Packages.Promise)
local Trove = require(ReplicatedStorage.Packages.Trove)
require(ReplicatedStorage.Packages.Thread)
require(ReplicatedStorage.Shared.Constants)
require(ReplicatedStorage.Modules.Animations)
local t = {
	["Boat Stand"] = {
		RigType = "LimitedRig3",
		CycleAnimations = {
			{
				Name = "Idle",
				ID = require(ReplicatedStorage.Boats["Magma Surfboard"]).Animations.Idle
			},
			{
				Name = "SlowSurfing",
				ID = require(ReplicatedStorage.Boats["Magma Surfboard"]).Animations.SlowSurfing
			},
			{
				Name = "Surfing",
				ID = require(ReplicatedStorage.Boats["Magma Surfboard"]).Animations.Surfing
			}
		}
	}
}
local t2 = {}
local v1 = Promise.promisify(function(p1) --[[ Line: 29 | Upvalues: Players (copy) ]]
	local Character = p1.Character
	local v1 = if Character then Character:FindFirstChildWhichIsA("Humanoid") else Character
	if v1 then
		return v1:GetAppliedDescription()
	else
		return Players:GetHumanoidDescriptionFromUserId(p1.UserId)
	end
end)
local function loadTrack(p1, p2, p3, p4) --[[ loadTrack | Line: 39 | Upvalues: t2 (copy) ]]
	if not t2[p1] then
		t2[p1] = {}
	end
	local v1, v2 = pcall(function() --[[ Line: 43 | Upvalues: p2 (copy), p4 (copy) ]]
		return p2:LoadAnimation(p4)
	end)
	if v1 then
		v2.Priority = Enum.AnimationPriority.Action4
		v2.Looped = true
		t2[p1][p3] = v2
		return v2
	end
end
local function loopTracks(p1, p2, p3) --[[ loopTracks | Line: 58 | Upvalues: t2 (copy), loadTrack (copy) ]]
	if t2[p1] == nil then
		t2[p1] = {}
	end
	for i, v in ipairs(p3) do
		local v1 = t2[p1]
		if v1 then
			local v2 = v1[v.Name]
			if not v2 then
				local Animation = Instance.new("Animation")
				Animation.AnimationId = v.ID
				v2 = loadTrack(p1, p2, v.Name, Animation)
			end
			if v2 then
				for k, v3 in pairs(v1) do
					v3:Stop()
				end
				v2:Play()
				task.wait(v2.Length)
			end
			task.wait(3)
		end
	end
end
local function createShowcase(p1) --[[ createShowcase | Line: 87 | Upvalues: t (copy), ReplicatedStorage (copy), Promise (copy), v1 (copy), Players (copy), Trove (copy), loopTracks (copy) ]]
	local v12 = t[p1.Name]
	if not v12 then
		return
	end
	local CharacterSpawnPart = p1:WaitForChild("CharacterSpawnPart", 100000)
	local v2 = ReplicatedStorage.Assets:FindFirstChild(v12.RigType)
	if v2 then
		local v3 = v2:Clone()
		v3:WaitForChild("Head")
		v3:WaitForChild("HumanoidRootPart")
		local Humanoid = v3.Humanoid
		local Animator = Humanoid.Animator
		v3:PivotTo(CharacterSpawnPart.CFrame)
		v3.Parent = workspace
		Promise.try(v1, Players.LocalPlayer):andThen(function(p1) --[[ Line: 110 | Upvalues: Humanoid (copy) ]]
			Humanoid:ApplyDescription(p1)
		end):catch(warn):await()
		local v4 = Trove.new()
		v4:Add(task.spawn(function() --[[ Line: 117 | Upvalues: loopTracks (ref), v3 (copy), Animator (copy), v12 (copy) ]]
			while true do
				task.wait()
				loopTracks(v3, Animator, v12.CycleAnimations)
			end
		end))
		return function() --[[ Line: 124 | Upvalues: v4 (copy) ]]
			v4:Destroy()
		end
	end
end
Observers.observeTag("CharacterShowcase", function(p1) --[[ Line: 129 | Upvalues: createShowcase (copy) ]]
	return createShowcase(p1)
end)
return {}