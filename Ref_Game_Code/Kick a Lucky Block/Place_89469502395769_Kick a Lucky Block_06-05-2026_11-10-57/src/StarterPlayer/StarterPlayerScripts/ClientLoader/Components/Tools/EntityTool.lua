-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local PlacementController = require(ReplicatedStorage.Modules.ControllerLoader.PlacementController)
local Tags = require(ReplicatedStorage.Shared.Data.Tags)
local Trove = require(ReplicatedStorage.Shared.Packages.Trove)
local SetupBrainrotGui = require(ReplicatedStorage.Shared.Functional.SetupBrainrotGui)
local LoadIdleAnimations = require(ReplicatedStorage.Shared.Functional.LoadIdleAnimations)
local LocalPlayer = game:GetService("Players").LocalPlayer
local t = {
	Tag = ({
		Tag = Tags.EntityTool
	}).Tag
}
t.__index = t
function t.new(p1) --[[ new | Line: 26 | Upvalues: t (copy) ]]
	local v2 = setmetatable({
		Tool = p1,
		Loaded = false,
		Initialized = false
	}, t)
	v2:_init()
	return v2
end
function t.LoadModel(p1) --[[ LoadModel | Line: 38 | Upvalues: ReplicatedStorage (copy), SetupBrainrotGui (copy), LoadIdleAnimations (copy) ]]
	local v2 = ReplicatedStorage.Objects.Entities:FindFirstChild(p1.Tool.Name)
	if v2 then
		local v3 = p1.Trove:Clone(v2)
		local v4 = p1.Tool:GetAttribute("Mutation")
		if v4 then
			v3:AddTag(v4)
		end
		v3:WaitForChild("Root")
		for i, v in ipairs(v3:GetDescendants()) do
			if v:IsA("MeshPart") or (v:IsA("Part") or v:IsA("BasePart")) then
				v.CanCollide = false
				v.Massless = true
				v.Anchored = false
				v.CanTouch = false
				v.AudioCanCollide = false
			end
		end
		local v5 = p1.Trove:Add(Instance.new("Weld"))
		v5.Part0 = v3.Root
		v5.Part1 = p1.Tool.Handle
		v5.Parent = v3
		v3.Parent = p1.Tool
		local v6 = SetupBrainrotGui(v3, p1.Tool, nil, true)
		if v6 then
			p1.Trove:Add(v6)
		end
		local v7 = LoadIdleAnimations(v3)
		if v7 then
			p1.Trove:Add(v7)
		end
	end
end
function t._init(p1) --[[ _init | Line: 82 | Upvalues: Trove (copy), LocalPlayer (copy), PlacementController (copy) ]]
	if not p1.Initialized then
		p1.Initialized = true
		local Tool = p1.Tool
		local v1 = Trove.new()
		p1.Trove = v1
		local v2 = v1:Extend()
		local function CheckLoad() --[[ CheckLoad | Line: 94 | Upvalues: Tool (copy), p1 (copy), v2 (copy) ]]
			if Tool:IsDescendantOf(workspace) then
				if p1.Loaded then
					return
				end
				p1.Loaded = true
				p1:LoadModel()
				v2:Clean()
			end
		end
		if Tool:IsDescendantOf(workspace) and not p1.Loaded then
			p1.Loaded = true
			p1:LoadModel()
			v2:Clean()
		end
		v2:Add(Tool.AncestryChanged:Connect(CheckLoad))
		if Tool:IsDescendantOf(LocalPlayer.Backpack) or Tool:IsDescendantOf(LocalPlayer.Character) then
			p1.Trove:Add(Tool.Equipped:Connect(function() --[[ Line: 110 | Upvalues: p1 (copy), PlacementController (ref) ]]
				p1.Equipped = true
				PlacementController.IsHolding = true
				PlacementController.HoldingChanged:Fire()
			end))
			p1.Trove:Add(Tool.Unequipped:Connect(function() --[[ Line: 116 | Upvalues: p1 (copy), PlacementController (ref) ]]
				p1.Equipped = false
				PlacementController.IsHolding = false
				PlacementController.HoldingChanged:Fire()
			end))
		end
	end
end
function t.Destroy(p1) --[[ Destroy | Line: 124 | Upvalues: PlacementController (copy) ]]
	if p1.Equipped then
		PlacementController.IsHolding = false
		PlacementController.HoldingChanged:Fire()
	end
	p1.Trove:Destroy()
end
return t