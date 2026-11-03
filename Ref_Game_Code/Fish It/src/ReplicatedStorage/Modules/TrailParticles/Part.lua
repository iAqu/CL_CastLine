-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local t = {}
t.__index = t
function t.new(p1) --[[ new | Line: 5 | Upvalues: t (copy) ]]
	local v2 = setmetatable({}, t)
	v2.CFrame = CFrame.new()
	v2.Att0 = p1.Att0:Clone()
	v2.Att1 = p1.Att1:Clone()
	v2.Trails = {}
	v2.Att0Pos = v2.Att0.Position
	v2.Att1Pos = v2.Att1.Position
	v2.TrailWidth = (p1.Position - v2.Att0Pos).Magnitude + (p1.Position - v2.Att1Pos).Magnitude
	v2.Att0.Parent = workspace.Terrain
	v2.Att1.Parent = workspace.Terrain
	for i, v in ipairs(p1:GetChildren()) do
		if v:IsA("Trail") then
			local v3 = v:Clone()
			v3.Attachment0 = v2.Att0
			v3.Attachment1 = v2.Att1
			v3.Parent = workspace.Terrain
			table.insert(v2.Trails, v3)
		end
	end
	return v2
end
function t.UpdateCFrame(p1, p2) --[[ UpdateCFrame | Line: 37 ]]
	p1.CFrame = p2
	p1:Update()
end
function t.Update(p1) --[[ Update | Line: 42 ]]
	p1.Att0.WorldPosition = (p1.CFrame * CFrame.new(p1.Att0Pos)).Position
	p1.Att1.WorldPosition = (p1.CFrame * CFrame.new(p1.Att1Pos)).Position
end
function t.Destroy(p1) --[[ Destroy | Line: 50 ]]
	p1.Att0:Destroy()
	p1.Att1:Destroy()
	for i, v in ipairs(p1.Trails) do
		v:Destroy()
	end
	table.clear(p1.Trails)
end
setmetatable(t, {
	__index = function(p1, p2) --[[ __index | Line: 62 ]]
		error(string.format("%q is not a valid member of %q", tostring(p2), script.Name), 2)
	end
})
return t