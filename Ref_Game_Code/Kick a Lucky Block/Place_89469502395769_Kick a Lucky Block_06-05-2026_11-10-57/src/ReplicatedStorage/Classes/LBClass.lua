-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
require(ReplicatedStorage.Modules.ServicesLoader.VFXService)
require(ReplicatedStorage.Shared.Data.RarityData)
local t = {}
t.__index = t
function t.new(p1) --[[ new | Line: 14 | Upvalues: t (copy) ]]
	local v2 = setmetatable({
		Rarity = nil,
		Part = p1
	}, t)
	v2:_init()
	return v2
end
function t.OpenAtCFrame(p1) --[[ OpenAtCFrame | Line: 24 ]] end
function t.ChangeRarity(p1, p2) --[[ ChangeRarity | Line: 28 | Upvalues: ReplicatedStorage (copy) ]]
	if p1.Rarity ~= p2 then
		p1.Rarity = p2
		if p1.VisualBlock then
			p1.VisualBlock:Destroy()
		end
		local v1 = ReplicatedStorage.Objects.LuckyBlocks:FindFirstChild(p2)
		if v1 then
			local v2 = v1:Clone()
			v2:WaitForChild("Root").Anchored = false
			local Weld = Instance.new("Weld")
			Weld.Part0 = p1.Part
			Weld.Part1 = v2.Root
			p1.VisualBlock = v2
			Weld.C0 = CFrame.new(0, v2.Root.Size.Y / 2 - p1.Part.Size.Y / 2, 0)
			Weld.Parent = v2.Root
			v2.Parent = workspace.Debris
		else
			p1.VisualBlock = nil
		end
	end
end
function t._init(p1) --[[ _init | Line: 58 ]]
	p1:ChangeRarity("Common")
end
return t