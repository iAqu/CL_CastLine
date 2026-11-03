-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local t = {}
t.__index = t
local t2 = {}
local v1 = 0
local function buildTemplate(p1) --[[ buildTemplate | Line: 12 ]]
	local Part = Instance.new("Part")
	Part.Anchored = true
	Part.CanCollide = false
	Part.CanQuery = false
	Part.CanTouch = false
	Part.CastShadow = false
	Part.TopSurface = Enum.SurfaceType.Studs
	Part.BottomSurface = Enum.SurfaceType.Studs
	Part.LeftSurface = Enum.SurfaceType.Smooth
	Part.RightSurface = Enum.SurfaceType.Smooth
	Part.FrontSurface = Enum.SurfaceType.Smooth
	Part.BackSurface = Enum.SurfaceType.Smooth
	if not p1 or next(p1) == nil then
		Part.Material = Enum.Material.Plastic
		Part.Size = Vector3.new(1, 1, 1)
		return Part
	end
	for k, v in pairs(p1) do
		pcall(function() --[[ Line: 29 | Upvalues: Part (copy), k (copy), v (copy) ]]
			Part[k] = v
		end)
	end
	return Part
end
function t.new(p1) --[[ new | Line: 47 | Upvalues: v1 (ref), buildTemplate (copy), t (copy), t2 (copy) ]]
	v1 = v1 + 1
	local v2 = "Pool_" .. tostring(v1)
	local v4 = setmetatable({
		id = v2,
		_free = {},
		_template = buildTemplate(p1.templateProperties),
		_activeParent = p1.activeParent
	}, t)
	local v5 = Instance.new("Folder")
	v5.Name = (p1.name or "PartPool") .. "_Parking"
	v5.Parent = workspace
	v4._parking = v5
	v4._template.CFrame = CFrame.new(Vector3.new(0, -50000, 0))
	v4._template.Parent = v5
	if p1.templateProperties and p1.templateProperties.Transparency then
		v4._transparency = p1.templateProperties.Transparency
	end
	for i = 1, p1.prewarm or 0 do
		local v6 = v4._template:Clone()
		v6:SetAttribute("PartPoolId", v2)
		v6.CFrame = CFrame.new(Vector3.new(0, -50000, 0))
		v6.Parent = v5
		table.insert(v4._free, v6)
	end
	t2[v2] = v4
	return v4
end
function t.UseDescription(p1, p2) --[[ UseDescription | Line: 83 ]]
	for i = #p1._free, 1, -1 do
		local v1 = p1._free[i]
		if v1 and p2(v1) == true then
			v1.Transparency = p1._transparency or 0
			v1.Parent = p1._activeParent
			table.remove(p1._free, i)
			return v1
		end
	end
	return nil
end
function t.Acquire(p1, p2, p3, p4, p5) --[[ Acquire | Line: 103 ]]
	local v1 = nil
	for i = #p1._free, 1, -1 do
		local v2 = p1._free[i]
		if v2 and not v2:HasTag("Prop") then
			table.remove(p1._free, i)
			v1 = v2
			break
		end
	end
	if not v1 then
		v1 = p1._template:Clone()
	end
	if p3 then
		v1.Color = p3
	end
	if p2 then
		v1.Size = p2
	end
	if p5 then
		v1.Material = p5
	end
	v1.CFrame = p4
	v1.Transparency = p1._transparency or 0
	v1.Parent = p1._activeParent
	return v1
end
function t.Release(p1, p2) --[[ Release | Line: 139 ]]
	if not (p2 and p2.Parent) then
		return
	end
	p2.CFrame = CFrame.new(Vector3.new(0, -50000, 0))
	p2.Parent = p1._parking
	if table.find(p1._free, p2) ~= nil then
		return
	end
	table.insert(p1._free, p2)
end
function t.GetParkingFolder(p1) --[[ GetParkingFolder | Line: 153 ]]
	return p1._parking
end
function t.getById(p1) --[[ getById | Line: 157 | Upvalues: t2 (copy) ]]
	return t2[p1]
end
function t.returnOrDestroy(p1) --[[ returnOrDestroy | Line: 161 | Upvalues: t2 (copy) ]]
	local v1 = p1:GetAttribute("PartPoolId")
	if type(v1) ~= "string" then
		p1:Destroy()
		return
	end
	local v2 = t2[v1]
	if v2 then
		v2:Release(p1)
	else
		p1:Destroy()
	end
end
function t.Destroy(p1) --[[ Destroy | Line: 175 | Upvalues: t2 (copy) ]]
	t2[p1.id] = nil
	if p1._parking then
		p1._parking:Destroy()
	end
	p1._free = {}
end
t.POOL_ATTRIBUTE = "PartPoolId"
t.PARK_POSITION = Vector3.new(0, -50000, 0)
return t