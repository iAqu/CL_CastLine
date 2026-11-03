-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local t = {}
local v1 = nil
local v2 = nil
local v3 = CFrame.new(0, -10000, 0) * CFrame.Angles(0, math.pi, 0)
local t2 = {
	["!!!FISHING_VIEW_MODEL!!!"] = true,
	["!!!EQUIPPED_TOOL!!!"] = true,
	["!!!FISHING_BAIT_MODEL!!!"] = true,
	["!!!CHARM_MODEL!!!"] = true,
	["!!!FISHING_LANTERN!!!"] = true,
	["!!!OXYGEN_TANK_MODEL!!!"] = true
}
local t3 = {
	[Enum.HumanoidRigType.R6] = "rbxassetid://180435571"
}
local function removePreviewClutter(p1) --[[ removePreviewClutter | Line: 26 | Upvalues: t2 (copy) ]]
	if t2[p1.Name] then
		return true
	end
	if p1:HasTag("FishingRod") then
		return true
	end
	if p1:IsA("Tool") then
		return true
	end
	if p1:IsA("Script") or p1:IsA("LocalScript") then
		return true
	end
	if p1:IsA("ParticleEmitter") or (p1:IsA("Trail") or p1:IsA("Beam")) then
		return true
	else
		return (p1:IsA("Fire") or (p1:IsA("Smoke") or (p1:IsA("Sparkles") or p1:IsA("Highlight")))) and true or false
	end
end
local function playIdleAnimation(p1) --[[ playIdleAnimation | Line: 54 | Upvalues: t3 (copy) ]]
	local Humanoid = p1:FindFirstChildOfClass("Humanoid")
	if not Humanoid then
		return
	end
	local Animator = Humanoid:FindFirstChildOfClass("Animator")
	if not Animator then
		local Animator_2 = Instance.new("Animator")
		Animator_2.Parent = Humanoid
		Animator = Animator_2
	end
	local v1 = t3[Humanoid.RigType]
	if v1 then
		local Animation = Instance.new("Animation")
		Animation.AnimationId = v1
		Animation.Parent = p1
		local v2 = Animator:LoadAnimation(Animation)
		v2.Priority = Enum.AnimationPriority.Idle
		v2.Looped = true
		v2:Play()
	end
end
local function prepareRig(p1) --[[ prepareRig | Line: 81 | Upvalues: removePreviewClutter (copy), v3 (copy), playIdleAnimation (copy) ]]
	p1.Name = "AbilityPreviewRig"
	for i, v in ipairs(p1:GetDescendants()) do
		if removePreviewClutter(v) then
			v:Destroy()
		end
	end
	for i, v in ipairs(p1:GetDescendants()) do
		if v:IsA("BasePart") then
			v.Anchored = v.Name == "HumanoidRootPart"
			v.CanCollide = false
			v.CanTouch = false
			v.CanQuery = false
			v.Massless = true
		end
	end
	local Humanoid = p1:FindFirstChildOfClass("Humanoid")
	if Humanoid then
		Humanoid.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
		Humanoid.HealthDisplayType = Enum.HumanoidHealthDisplayType.AlwaysOff
		Humanoid.AutoRotate = false
	end
	p1:PivotTo(v3)
	playIdleAnimation(p1)
end
local function getFolder() --[[ getFolder | Line: 111 | Upvalues: v1 (ref) ]]
	if v1 and v1:IsDescendantOf(workspace) then
		return v1
	else
		local AbilityPreview = Instance.new("Folder")
		AbilityPreview.Name = "AbilityPreview"
		AbilityPreview.Parent = workspace
		v1 = AbilityPreview
		return AbilityPreview
	end
end
local function createDescriptionRig(p1) --[[ createDescriptionRig | Line: 123 | Upvalues: Players (copy) ]]
	local Humanoid = p1:FindFirstChildOfClass("Humanoid")
	if not Humanoid then
		return nil
	end
	local v1 = Humanoid:GetAppliedDescription()
	local v2, v3 = pcall(function() --[[ Line: 130 | Upvalues: Players (ref), v1 (copy), Humanoid (copy) ]]
		return Players:CreateHumanoidModelFromDescription(v1, Humanoid.RigType)
	end)
	if v2 and (v3 and v3:IsA("Model")) then
		return v3
	else
		return nil
	end
end
local function cloneCharacter(p1) --[[ cloneCharacter | Line: 141 ]]
	local Archivable = p1.Archivable
	p1.Archivable = true
	local v1 = p1:Clone()
	p1.Archivable = Archivable
	return v1
end
function t.Open(p1) --[[ Open | Line: 150 | Upvalues: LocalPlayer (copy), createDescriptionRig (copy), prepareRig (copy), v1 (ref), v2 (ref) ]]
	p1:Close()
	local Character = LocalPlayer.Character
	if not Character then
		return nil
	end
	local v12 = createDescriptionRig(Character)
	if not v12 then
		local Archivable = Character.Archivable
		Character.Archivable = true
		local v22 = Character:Clone()
		Character.Archivable = Archivable
		v12 = v22
	end
	if not v12 then
		return nil
	end
	prepareRig(v12)
	local v3
	if v1 and v1:IsDescendantOf(workspace) then
		v3 = v1
	else
		local AbilityPreview = Instance.new("Folder")
		AbilityPreview.Name = "AbilityPreview"
		AbilityPreview.Parent = workspace
		v1 = AbilityPreview
		v3 = AbilityPreview
	end
	v12.Parent = v3
	v2 = v12
	return v12
end
function t.Close(p1) --[[ Close | Line: 170 | Upvalues: v2 (ref), v1 (ref) ]]
	if v2 then
		v2:Destroy()
		v2 = nil
	end
	if not v1 then
		return
	end
	v1:Destroy()
	v1 = nil
end
function t.GetRig(p1) --[[ GetRig | Line: 182 | Upvalues: v2 (ref) ]]
	if v2 and v2:IsDescendantOf(workspace) then
		return v2
	else
		return nil
	end
end
function t.IsActive(p1) --[[ IsActive | Line: 190 ]]
	return p1:GetRig() ~= nil
end
function t.GetCFrame(p1) --[[ GetCFrame | Line: 194 | Upvalues: v3 (copy) ]]
	return v3
end
return t