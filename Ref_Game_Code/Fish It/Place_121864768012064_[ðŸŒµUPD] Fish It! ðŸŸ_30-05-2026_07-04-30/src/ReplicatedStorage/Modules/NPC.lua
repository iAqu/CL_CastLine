-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = game:GetService("Players").LocalPlayer
local v1 = RunService:IsServer()
local v2 = RunService:IsClient()
local Observers = require(ReplicatedStorage.Packages.Observers)
require(ReplicatedStorage.Shared.NPCQuestGivers)
local t = {}
local t2 = {}
local t3 = {}
local t4 = {}
local v4
if v1 then
	local NPC = Instance.new("Folder")
	NPC.Name = "NPC"
	NPC.Parent = workspace
	v4 = NPC
else
	v4 = workspace:WaitForChild("NPC")
end
local v5 = RaycastParams.new()
v5.IgnoreWater = true
v5.RespectCanCollide = true
v5.FilterType = Enum.RaycastFilterType.Exclude
v5.FilterDescendantsInstances = { v4 }
local t5 = {
	CreateNPC = function(p1, p2, p3, p4) --[[ CreateNPC | Line: 44 | Upvalues: ReplicatedStorage (copy), v4 (ref) ]]
		local v1 = ReplicatedStorage.NPC:FindFirstChild(p2)
		if not v1 then
			error(("NPC by the name of %s does not exist!"):format(p2))
		end
		local v2 = v1:Clone()
		local Head = v2:WaitForChild("Head")
		for i, v in ipairs(v2:GetDescendants()) do
			if v:IsA("BasePart") then
				v.CollisionGroup = "Players"
			end
		end
		if p4 then
			p3 = p3 + Vector3.new(0, 1, 0) * (3 * v2:GetScale())
		end
		v2:PivotTo(p3)
		v2.Parent = v4
		Head:AddTag("NPCTracker")
		v2:AddTag("NPC")
		return v2
	end,
	AddInteractionToModel = function(p1, p2) --[[ AddInteractionToModel | Line: 71 | Upvalues: v2 (copy), LocalPlayer (copy) ]]
		if not v2 then
			return
		end
		if p2:FindFirstChildOfClass("Humanoid") and not GetNPC(p2) then
			DoHeadTracking(p2)
		end
		local v1 = nil
		local v22 = GetNPCInteraction(p2.Name)
		if v22 then
			local v3 = p2:FindFirstChildWhichIsA("ProximityPrompt", true)
			if v3 then
				v1 = v3.Triggered:Connect(function(p1) --[[ Line: 86 | Upvalues: LocalPlayer (ref), v22 (copy), p2 (copy) ]]
					if LocalPlayer ~= p1 then
						return
					end
					v22.Interaction(p1, p2)
				end)
			else
				local v4 = nil
				v4 = p2.DescendantAdded:Connect(function(p1) --[[ Line: 93 | Upvalues: v4 (ref), v1 (ref), v3 (copy), LocalPlayer (ref), v22 (copy), p2 (copy) ]]
					if p1.Name ~= "ProximityPrompt" then
						return
					end
					v4:Disconnect()
					v1 = v3.Triggered:Connect(function(p1) --[[ Line: 96 | Upvalues: LocalPlayer (ref), v22 (ref), p2 (ref) ]]
						if LocalPlayer ~= p1 then
							return
						end
						v22.Interaction(p1, p2)
					end)
				end)
			end
		end
		p2.Destroying:Once(function() --[[ Line: 106 | Upvalues: v1 (ref) ]]
			if not v1 then
				return
			end
			v1:Disconnect()
		end)
	end
}
function t5.LoadAnimation(p1, p2) --[[ LoadAnimation | Line: 114 | Upvalues: v1 (copy), t5 (copy), t2 (copy), t3 (copy) ]]
	if v1 then
		error("Animations cannot be loaded from the server!")
	end
	local Humanoid = p2:WaitForChild("Humanoid", 10)
	if not Humanoid then
		print("No humanoid found")
		return
	end
	local Animations = p2:WaitForChild("Animations", 10)
	if not Animations then
		error(("[%s] does not have an Animation folder!"):format(p2:GetFullName()))
	end
	local Animator = Humanoid:FindFirstChildOfClass("Animator")
	if not Animator then
		return
	end
	if not p2:GetAttribute("AnimationsLoaded") then
		p2:SetAttribute("AnimationsLoaded", true)
		t5:AddInteractionToModel(p2)
		for k, v in pairs(Animations:GetAttributes()) do
			local Animation = Instance.new("Animation")
			Animation.Name = k
			Animation.AnimationId = string.format("rbxassetid://%d", v)
			Animation.Parent = Animations
		end
	end
	local function onAnimationChanged() --[[ onAnimationChanged | Line: 145 | Upvalues: p2 (copy), t2 (ref), Animations (copy), Animator (copy), t3 (ref) ]]
		local v1 = p2:GetAttribute("PlayingAnimation")
		local v2 = if v1 then t2[v1] else v1
		if v2 then
			v2:Stop()
		end
		local v3 = p2:GetAttribute("CurrentAnimation")
		local v4 = v3 and Animations:FindFirstChild(v3)
		if not v4 then
			return
		end
		local v5 = t2[v4]
		if v5 then
			v5:Play()
		else
			local v6 = Animator:LoadAnimation(v4)
			t2[v4] = v6
			local v7 = t3
			table.insert(v7, v6)
			p2.Destroying:Once(function() --[[ Line: 166 | Upvalues: v6 (copy), t3 (ref), t2 (ref), v4 (copy) ]]
				v6:Stop()
				local v1 = table.find(t3, v6)
				if not v1 then
					t2[v4] = nil
					v6:Destroy()
					return
				end
				table.remove(t3, v1)
				t2[v4] = nil
				v6:Destroy()
			end)
			v6:Play()
		end
		p2:SetAttribute("PlayingAnimation", v3)
	end
	onAnimationChanged()
	p2:GetAttributeChangedSignal("CurrentAnimation"):Connect(onAnimationChanged)
end
function GetNPC(p1) --[[ GetNPC | Line: 189 | Upvalues: t4 (copy) ]]
	for i, v in ipairs(t4) do
		if v.NPC == p1 then
			return v
		end
	end
end
function GetNPCInteraction(p1) --[[ GetNPCInteraction | Line: 197 | Upvalues: t (copy) ]]
	for i, v in ipairs(t) do
		if v.Name == p1 then
			return v
		end
	end
end
function DoHeadTracking(p1) --[[ DoHeadTracking | Line: 206 | Upvalues: t4 (copy) ]]
	local v2 = p1:WaitForChild(if p1:GetAttribute("R15") then "UpperTorso" else "Torso", 100000)
	if not v2 then
		warn((("Could not set up head tracking for %*!"):format((p1:GetFullName()))))
		return
	end
	local Neck = v2:WaitForChild("Neck", 100000)
	if Neck then
		local C0 = Neck.C0
		local Position = C0.Position
		local _, _2, _3 = C0:ToOrientation()
		p1.Destroying:Once(function() --[[ Line: 224 | Upvalues: t4 (ref), p1 (copy) ]]
			for i, v in ipairs(t4) do
				if v.NPC == p1 then
					table.remove(t4, i)
					return
				end
			end
		end)
		local v3 = t4
		table.insert(v3, {
			NPC = p1,
			OnUpdate = function(p1, p2, p3) --[[ OnUpdate | Line: 235 | Upvalues: v2 (copy), Neck (copy), C0 (copy) ]]
				local v1 = p2:GetAttribute("LookTarget")
				if v1 then
					p3 = v1
				end
				local v22 = p1 * 3
				local v3 = p2.CFrame
				local v5 = if v2.CFrame:ToObjectSpace(p3).Z < 0 and (p3.Position - v3.Position).Magnitude < 18 then true else false
				if v5 then
					local v7 = (v3.Position - p3.Position).Unit:Cross(v2.CFrame.LookVector)
					Neck.C0 = Neck.C0:Lerp(C0 * CFrame.Angles(0, -(math.atan((v3.Y - p3.Y) / (v3.Position - p3.Position).Magnitude) * 0.4), v7.Y), v22)
					return v5
				end
				if Neck.C0 == C0 then
					return v5
				end
				Neck.C0 = Neck.C0:Lerp(C0, v22)
				return v5
			end
		})
	else
		warn((("Could not set up neck weld for %*!"):format((p1:GetFullName()))))
	end
end
function SpawnNPCFromPart(p1) --[[ SpawnNPCFromPart | Line: 269 | Upvalues: v1 (copy), ReplicatedStorage (copy), t5 (copy) ]]
	if not v1 then
		return
	end
	local v12 = game.ServerStorage.ServerNPC:FindFirstChild(p1.Name)
	if v12 then
		v12.Parent = ReplicatedStorage:WaitForChild("NPC")
	end
	task.defer(function() --[[ Line: 276 | Upvalues: p1 (copy) ]]
		p1:Destroy()
	end)
	local v3 = t5:CreateNPC(p1.Name, p1.CFrame, false)
	if not v3 then
		return
	end
	local v4 = p1:GetAttribute("CurrentAnimation")
	if not v4 then
		return
	end
	v3:SetAttribute("CurrentAnimation", v4)
end
if v2 then
	Observers.observeTag("NPC", function(p1) --[[ Line: 297 | Upvalues: t5 (copy) ]]
		t5:LoadAnimation(p1)
	end)
	task.spawn(function() --[[ Line: 301 | Upvalues: LocalPlayer (copy), t4 (copy) ]]
		while true do
			local v1
			local v2
			repeat
				local v3
				repeat
					v2 = task.wait()
					v3 = LocalPlayer.Character
				until v3
				v1 = v3:FindFirstChild("Head")
			until v1
			local v4 = v1.CFrame
			local v5 = (1 / 0)
			local v6 = nil
			for v7, v8 in t4 do
				local NPC = v8.NPC
				if NPC and not NPC:HasTag("IgnoreNPC") then
					local Head = NPC:FindFirstChild("Head")
					if Head then
						local v9 = Head:GetAttribute("Distance") or 15
						local v10 = Head.Position - v4.Position
						if v10.Magnitude < v5 and v10.Magnitude <= v9 then
							v5 = v10.Magnitude
							v6 = NPC
						end
						pcall(function() --[[ Line: 342 | Upvalues: v8 (copy), v2 (copy), Head (copy), v4 (copy) ]]
							v8.OnUpdate(v2, Head, v4)
						end)
					end
				end
			end
			for v11, v12 in t4 do
				local NPC = v12.NPC
				if NPC then
					if NPC == v6 then
						NPC:AddTag("HighlightNPC")
						continue
					end
					NPC:RemoveTag("HighlightNPC")
				end
			end
		end
	end)
end
if v1 then
	local v6 = workspace:WaitForChild("!!! NPC SPAWN PARTS")
	for i, v in ipairs(v6:GetChildren()) do
		task.spawn(SpawnNPCFromPart, v)
	end
	v6.ChildAdded:Connect(SpawnNPCFromPart)
end
return t5