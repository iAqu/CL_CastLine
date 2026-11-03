-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local RunService = game:GetService("RunService")
local function effectCallback(p1) --[[ effectCallback | Line: 3 | Upvalues: RunService (copy) ]]
	local Character = p1.ActorPlayer.Character
	if not Character then
		return
	end
	local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")
	if not (HumanoidRootPart and HumanoidRootPart:IsA("BasePart")) then
		return
	end
	local v1 = script.Discoball:Clone()
	local PrimaryPart = v1.PrimaryPart
	local v2 = HumanoidRootPart.CFrame * CFrame.new(0, 5, 0)
	if v1:IsA("Model") then
		v1:PivotTo(v2)
	else
		PrimaryPart.CFrame = v2
	end
	v1.Parent = Character
	local Motor6D = Instance.new("Motor6D")
	Motor6D.Part0 = HumanoidRootPart
	Motor6D.Part1 = PrimaryPart
	Motor6D.C0 = CFrame.new(0, 5, 0)
	Motor6D.Parent = HumanoidRootPart
	local v3 = 0
	local v4 = RunService.Heartbeat:Connect(function(p1) --[[ Line: 33 | Upvalues: v3 (ref), Motor6D (copy) ]]
		v3 = v3 + p1
		Motor6D.C0 = CFrame.new(0, 5, 0) * CFrame.Angles(0, v3 * math.rad(120), 0)
	end)
	return function() --[[ Line: 38 | Upvalues: v4 (copy), Motor6D (copy), v1 (copy) ]]
		v4:Disconnect()
		if Motor6D.Parent then
			Motor6D:Destroy()
		end
		if not v1.Parent then
			return
		end
		v1:Destroy()
	end
end
return {
	AnimationId = "rbxassetid://124719355733181",
	PlaybackSpeed = 1,
	Looped = true,
	RequiresTarget = false,
	MaxDistance = 15,
	Data = {
		Id = 22,
		Type = "Emotes",
		Name = "Disco Mode",
		Description = "Bring the disco anywhere.",
		Icon = "rbxassetid://100086603663689",
		Tier = 4
	},
	AnimationPriority = Enum.AnimationPriority.Action3,
	EffectCallback = effectCallback,
	_moduleScript = script
}