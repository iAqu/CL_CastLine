-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Trove = require(ReplicatedStorage.Packages.Trove)
local Util = require(script.Util)
local Terrain = workspace.Terrain
local t = {}
t.__index = t
local v1 = Random.new()
local sin = math.sin
local cos = math.cos
local noise = math.noise
local sqrt = math.sqrt
local function setAttachmentWorldCFrame(p1, p2) --[[ setAttachmentWorldCFrame | Line: 51 ]]
	p1.WorldCFrame = p2
end
local function setBasePartCFrame(p1, p2) --[[ setBasePartCFrame | Line: 55 ]]
	p1.CFrame = p2
end
local function defaultShapeFunction(p1) --[[ defaultShapeFunction | Line: 59 | Upvalues: sin (copy), cos (copy) ]]
	return p1.CFrame * CFrame.new(sin(p1.Time) * p1.Radius, 0, cos(p1.Time) * p1.Radius)
end
function t.new(p1, p2, p3, p4, p5) --[[ new | Line: 85 | Upvalues: t (copy), Trove (copy) ]]
	local v2 = setmetatable({}, t)
	local v3 = if p5 then p5 else {}
	v2.cframe = p1
	v2.radius = p2
	v2.radiusVariation = v3.radiusVariation
	v2.segments = p3
	v2.trailPart = p4
	v2.rotationSpeed = v3.rotationSpeed or 1
	v2.rotationSpeedVariation = v3.rotationSpeedVariation
	v2.shapePartial = v3.shapePartial or 1
	v2.shrink = v3.shrink or 1
	v2.noise = v3.noise
	v2.noiseFrequency = v3.noiseFrequency or 0
	v2.noiseAmplitude = v3.noiseAmplitude
	v2.trove = Trove.new()
	v2._segments = {}
	v2._trailsCreated = false
	return v2
end
function t.SetShapeFunction(p1, p2) --[[ SetShapeFunction | Line: 118 ]]
	p1.shapeFunction = p2
end
function t.GetShapeFunction(p1, p2) --[[ GetShapeFunction | Line: 123 | Upvalues: sin (copy), cos (copy) ]]
	if p1.shapeFunction then
		return p1.shapeFunction(p2)
	else
		return p2.CFrame * CFrame.new(sin(p2.Time) * p2.Radius, 0, cos(p2.Time) * p2.Radius)
	end
end
function t.SetRadius(p1, p2) --[[ SetRadius | Line: 131 ]]
	p1.radius = p2
	for i, v in ipairs(p1._segments) do
		v.BaseRadius = p2
	end
end
function t.GetSegments(p1) --[[ GetSegments | Line: 138 ]]
	return p1._segments
end
function t.CreateTrails(p1) --[[ CreateTrails | Line: 143 | Upvalues: Util (copy), Terrain (copy), sqrt (copy), v1 (copy), setAttachmentWorldCFrame (copy), setBasePartCFrame (copy) ]]
	if p1._trailsCreated then
		return
	end
	p1._trailsCreated = true
	local v12 = p1.cframe * CFrame.new(0, p1.radius, 0)
	for i = 1, p1.segments do
		local v2 = p1.trailPart:Clone()
		p1.trove:Add(v2)
		Util.ToggleAllTrails(v2, true)
		v2.Parent = Terrain
		local v3 = v12 * CFrame.new(0, -(2 * p1.radius * p1.shapePartial / p1.segments) * (i - 0.5), 0)
		local v4 = sqrt(1 - (2 * ((v3.Position - v12.Position).Magnitude / (p1.radius * 2)) - 1) ^ 2) * p1.radius * p1.shrink
		local Position = v3.Position
		local v5 = if p1.radiusVariation then v1:NextNumber(p1.radiusVariation.Min, p1.radiusVariation.Max) else 1
		local v6 = if p1.rotationSpeedVariation then v1:NextNumber(p1.rotationSpeedVariation.Min, p1.rotationSpeedVariation.Max) else 1
		local t = {
			CFrame = v3,
			Index = i,
			Instance = v2
		}
		t.SetCFrame = if v2:IsA("Attachment") then setAttachmentWorldCFrame else setBasePartCFrame
		t.Radius = v4 * v5
		t.BaseRadius = v4 * v5
		t.NoiseX = Position.X
		t.NoiseY = Position.Y
		t.NoiseZ = i * 5
		t.Time = v1:NextNumber(0, 1000000)
		t.RotationSpeed = p1.rotationSpeed * v6
		table.insert(p1._segments, t)
	end
end
function t.Start(p1) --[[ Start | Line: 196 | Upvalues: defaultShapeFunction (copy), RunService (copy), noise (copy) ]]
	p1:CreateTrails()
	local _segments = p1._segments
	local v1 = 0
	local noise_2 = p1.noise
	local v2 = p1.noiseAmplitude or 0
	local v3 = p1.shapeFunction or defaultShapeFunction
	p1._renderConnection = RunService.RenderStepped:Connect(function(p12) --[[ Line: 204 | Upvalues: _segments (copy), v3 (copy), noise_2 (copy), v2 (copy), noise (ref), v1 (ref), p1 (copy) ]]
		for i = 1, #_segments do
			local v12 = _segments[i]
			v12.Time = v12.Time + v12.RotationSpeed * p12
			v12.SetCFrame(v12.Instance, v3(v12))
			if noise_2 then
				v12.Radius = v12.BaseRadius + v2 * noise(v12.NoiseX + v1 * p1.noiseFrequency, v12.NoiseY + v1 * p1.noiseFrequency, v12.NoiseZ)
			end
		end
		v1 = v1 + p12
	end)
	p1.trove:Add(p1._renderConnection)
end
function t.End(p1, p2) --[[ End | Line: 223 | Upvalues: Util (copy) ]]
	p1._renderConnection:Disconnect()
	task.wait(Util.GetMaxLifetime(p1.trailPart))
	if not p2 then
		return
	end
	p1:Destroy()
end
function t.Destroy(p1) --[[ Destroy | Line: 234 ]]
	p1.trove:Clean()
	p1.trove:Destroy()
	table.clear(p1._segments)
	setmetatable(p1, nil)
end
return t