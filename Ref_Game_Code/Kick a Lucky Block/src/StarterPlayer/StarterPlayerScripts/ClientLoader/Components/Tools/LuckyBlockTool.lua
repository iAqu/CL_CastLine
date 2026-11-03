-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local PackPity = require(ReplicatedStorage.Modules.UILoader.PackPity)
local Tags = require(ReplicatedStorage.Shared.Data.Tags)
local Trove = require(ReplicatedStorage.Shared.Packages.Trove)
local Network = require(ReplicatedStorage.Shared.Packages.Network)
local LocalPlayer = game:GetService("Players").LocalPlayer
local t = {
	Tag = ({
		Tag = Tags.LuckyBlockTool
	}).Tag
}
t.__index = t
function t.new(p1) --[[ new | Line: 25 | Upvalues: t (copy) ]]
	local v2 = setmetatable({
		Tool = p1,
		Loaded = false,
		Initialized = false
	}, t)
	v2:_init()
	return v2
end
function t.LoadModel(p1) --[[ LoadModel | Line: 37 | Upvalues: ReplicatedStorage (copy) ]]
	local v2 = ReplicatedStorage.Objects.LuckyBlockModels:FindFirstChild(p1.Tool.Name)
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
	end
end
function t._init(p1) --[[ _init | Line: 71 | Upvalues: Trove (copy), LocalPlayer (copy), PackPity (copy), Network (copy) ]]
	if not p1.Initialized then
		p1.Initialized = true
		local Tool = p1.Tool
		p1.Trove = Trove.new()
		p1.Trove:Add(Tool.Equipped:Once(function() --[[ Line: 81 | Upvalues: p1 (copy) ]]
			if not p1.Loaded then
				p1.Loaded = true
				p1:LoadModel()
			end
		end))
		if Tool:IsDescendantOf(LocalPlayer.Backpack) or Tool:IsDescendantOf(LocalPlayer.Character) then
			local v2 = p1.Trove:Extend()
			p1.Trove:Add(Tool.Equipped:Connect(function() --[[ Line: 93 | Upvalues: v2 (copy), PackPity (ref), Tool (copy) ]]
				v2:Add(function() --[[ Line: 95 | Upvalues: PackPity (ref) ]]
					PackPity:Hide()
				end)
				PackPity:ShowPity(Tool.Name)
			end))
			p1.Trove:Add(Tool.Unequipped:Connect(function() --[[ Line: 102 | Upvalues: v2 (copy) ]]
				v2:Clean()
			end))
			p1.Trove:Add(Tool.Activated:Connect(function() --[[ Line: 106 | Upvalues: Network (ref) ]]
				Network.FireServer("lb_open")
			end))
		end
	end
end
function t.Destroy(p1) --[[ Destroy | Line: 112 ]]
	p1.Trove:Destroy()
end
return t