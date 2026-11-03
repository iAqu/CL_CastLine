-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local SoundService = game:GetService("SoundService")
local EntitiesData = require(ReplicatedStorage.Shared.Data.EntitiesData)
local RarityData = require(ReplicatedStorage.Shared.Data.RarityData)
local Tags = require(ReplicatedStorage.Shared.Data.Tags)
local MutationService = require(ReplicatedStorage.Shared.Services.MutationService)
local v1 = Random.new()
local Anim_Placeholder = Instance.new("Folder")
Anim_Placeholder.Name = "Anim_Placeholder"
Anim_Placeholder.Parent = ReplicatedStorage
local Tick = SoundService.Wheel.Tick
local Reward = SoundService.Effects.Reward
function LoadEntity(p1, p2, p3) --[[ LoadEntity | Line: 29 | Upvalues: ReplicatedStorage (copy), Anim_Placeholder (copy), Tags (copy) ]]
	if p1 and typeof(p1) == "table" then
		local v1 = ReplicatedStorage.Objects.Entities:FindFirstChild(p1.Name)
		if v1 then
			local v2 = v1:Clone()
			v2:WaitForChild("Root")
			v2.PrimaryPart.PivotOffset = CFrame.new(0, -v2.PrimaryPart.Size.Y / 2, 0)
			v2:PivotTo(p2)
			for i, v in ipairs(v2:GetDescendants()) do
				if v:IsA("BasePart") or v:IsA("MeshPart") then
					v.CanCollide = false
					v.CanQuery = false
					v.CanTouch = false
				end
			end
			v2.Parent = Anim_Placeholder
			v2:AddTag(Tags.Entity)
			return v2
		end
	end
end
function GetEntity(p1, p2) --[[ GetEntity | Line: 57 | Upvalues: v1 (copy), MutationService (copy) ]]
	local t = {
		Name = p1[v1:NextInteger(1, #p1)]
	}
	t.Mutation = if p2 then p2 else MutationService:GenerateMutation()
	return t
end
function Load_HiddenVFX(p1) --[[ Load_HiddenVFX | Line: 61 | Upvalues: ReplicatedStorage (copy) ]]
	local v1 = ReplicatedStorage.Objects.VFX.OpenVFXPart:Clone()
	v1.CFrame = p1 * CFrame.new(0, 2, 0)
	v1.Parent = workspace.Debris
	return function() --[[ Line: 66 | Upvalues: v1 (copy) ]]
		v1:Destroy()
	end
end
return function(p1, p2, p3, p4, p5, p6) --[[ Line: 71 | Upvalues: RarityData (copy), EntitiesData (copy), Anim_Placeholder (copy), MutationService (copy), ReplicatedStorage (copy), Tick (copy), Reward (copy), RunService (copy), TweenService (copy) ]]
	local v1 = RarityData.BrainrotPool[p1] or EntitiesData.LuckyBlocks[p1] and EntitiesData.LuckyBlocks[p1].Pool
	if v1 then
		assert(p2, "Point variable not passed or nil.")
		assert(p3, "Final Entity Data not passed or nil.")
		if typeof(p2) == "Vector3" then
			p2 = CFrame.new(p2)
		end
		local t = {}
		for i, v in ipairs(v1) do
			table.insert(t, v.Name)
		end
		local Highlight = Instance.new("Highlight")
		Highlight.FillColor = Color3.new()
		Highlight.FillTransparency = 0
		Highlight.OutlineTransparency = 1
		Highlight.DepthMode = Enum.HighlightDepthMode.Occluded
		local t2 = {}
		local t3 = {}
		local t4 = {}
		local t5 = {}
		for i = 1, 20 do
			local v4 = i == 20 and p3 or GetEntity(t, p6)
			t2[i] = v4.Name
			t3[i] = v4.Mutation or "None"
			if not t4[v4.Name] then
				local v5 = LoadEntity(v4, p2)
				if v5 then
					t4[v4.Name] = v5
					t5[v4.Name] = v5:GetScale()
				end
			end
		end
		local function HideEntity(p1) --[[ HideEntity | Line: 114 | Upvalues: t4 (copy), Anim_Placeholder (ref) ]]
			local v1 = t4[p1]
			if v1 then
				v1.Parent = Anim_Placeholder
			end
		end
		local function ShowEntity(p1, p2, p3) --[[ ShowEntity | Line: 122 | Upvalues: t4 (copy), MutationService (ref), Highlight (copy) ]]
			local v1 = t4[p1]
			if v1 then
				for i, v in ipairs(MutationService:GetMutationsFromInstance(v1) or {}) do
					v1:RemoveTag(v)
				end
				v1:AddTag(p2)
				v1:SetAttribute("Mutation", p2)
				if p3 then
					Highlight.Parent = script
				else
					Highlight.Parent = v1
				end
				v1.Parent = workspace.Debris
			end
		end
		local function emitVFX(p1) --[[ emitVFX | Line: 145 | Upvalues: t4 (copy), ReplicatedStorage (ref) ]]
			local v1 = t4[p1]
			if v1 then
				local v2 = v1.PrimaryPart or v1:FindFirstChild("Root")
				if v2 then
					local v3 = ReplicatedStorage.Objects.VFX.SlapVFX:Clone()
					v3.Parent = v2
					for i, v in ipairs(v3:GetDescendants()) do
						if v:IsA("ParticleEmitter") then
							v:Emit(v:GetAttribute("EmitCount") or 1)
						end
					end
					game.Debris:AddItem(v3, 2)
				end
			end
		end
		local function OnIndexChanged(p1, p2) --[[ OnIndexChanged | Line: 167 | Upvalues: t2 (copy), t3 (copy), Tick (ref), emitVFX (copy), Reward (ref), ShowEntity (copy), t4 (copy), Anim_Placeholder (ref) ]]
			local v1 = t2[p1]
			local v2 = t2[p2]
			local v3 = p2 == 20
			local v4 = t3[p2]
			Tick:Play()
			if v3 then
				emitVFX(v2)
				Reward:Play()
			end
			if v1 == v2 then
				ShowEntity(v1, v4, v3)
			else
				local v5 = t4[v1]
				if v5 then
					v5.Parent = Anim_Placeholder
				end
				ShowEntity(v2, v4, v3)
			end
		end
		local function UpdateScale(p1, p2) --[[ UpdateScale | Line: 189 | Upvalues: t2 (copy), t4 (copy), t5 (copy) ]]
			local v1 = t2[p1]
			local v2 = t4[v1]
			if v2 then
				local v3 = t5[v1]
				v2:ScaleTo((math.lerp(v3 * 0.2, v3, p2)))
			end
		end
		local function Cleanup() --[[ Cleanup | Line: 199 | Upvalues: t4 (copy), Highlight (copy) ]]
			for k, v in pairs(t4) do
				v:Destroy()
			end
			Highlight:Destroy()
		end
		local v6 = nil
		local v7 = 0
		local v8 = nil
		local v9 = p4 and p4 - workspace:GetServerTimeNow() or 3
		local v10 = Load_HiddenVFX(p2)
		v8 = RunService.PreRender:Connect(function(p1) --[[ Line: 214 | Upvalues: v7 (ref), v9 (copy), TweenService (ref), v6 (ref), OnIndexChanged (copy), v10 (copy), t2 (copy), t4 (copy), t5 (copy), v8 (ref), p5 (copy), Cleanup (copy) ]]
			v7 = v7 + p1
			local v2 = TweenService:GetValue(math.clamp(v7 / v9, 0, 1), Enum.EasingStyle.Cubic, Enum.EasingDirection.Out)
			local v3 = v2 * 20.99
			local v4 = math.floor(v3)
			local v5 = v3 - v4
			if v4 ~= v6 then
				OnIndexChanged(v6, v4)
				v6 = v4
				if v4 == 20 then
					v10()
				end
			end
			local v62 = t2[v6]
			local v72 = t4[v62]
			if v72 then
				local v82 = t5[v62]
				v72:ScaleTo((math.lerp(v82 * 0.2, v82, v5)))
			end
			if v2 == 1 then
				v8:Disconnect()
				if p5 then
					task.delay(p5, Cleanup)
					return
				end
				task.defer(Cleanup)
			end
		end)
	else
		print("no pool", p1)
	end
end