-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Debris = game:GetService("Debris")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local t = require(ReplicatedStorage.Packages.t)
local t1 = {}

t1.__index = t1
t1.__class = "EggEnergyOrbField"

local function getOrbTransparency(p1) -- line: 70
    if p1 < 0.14 then
        return 1 - p1 / 0.14
    end

    if p1 > 0.72 then
        return (p1 - 0.72) / 0.28
    end

    return 0
end

local function randomUnitVector(p2) -- line: 80
    local v1 = p2:NextNumber(-1, 1)
    local v2 = p2:NextNumber(0, 6.283185307179586)
    local v5 = math.sqrt((math.max(1 - v1 * v1, 0)))

    return (Vector3.new(v5 * math.cos(v2), v5 * math.sin(v2), v1))
end

local function randomOrbitPlane(p3) -- line: 88
    local v8 = p3:NextNumber(-1, 1)
    local v9 = p3:NextNumber(0, 6.283185307179586)
    local v12 = math.sqrt((math.max(1 - v8 * v8, 0)))
    local v15 = Vector3.new(v12 * math.cos(v9), v12 * math.sin(v9), v8)
    local Unit = v15:Cross(if math.abs(v15.Y) < 0.9 then Vector3.new(0, 1, 0) else Vector3.new(1, 0, 0)).Unit

    return Unit, v15:Cross(Unit).Unit
end

function t1.new(p4, p5) -- line: 99
    -- upvalues: t (copy), t1 (copy)
    t.strict(t.Instance)(p4)
    t.strict(t.Color3)(p5)

    local self = setmetatable({}, t1)

    self._color = p5
    self._parent = p4
    self._rng = Random.new()
    self._orbs = {}
    self._spawnAccumulator = 0
    self._destroyed = false

    return self
end

function t1:_resetOrb(p7, p8) -- line: 118
    local _rng = self._rng
    local v17 = _rng:NextNumber(-1, 1)
    local v18 = _rng:NextNumber(0, 6.283185307179586)
    local v21 = math.sqrt((math.max(1 - v17 * v17, 0)))
    local v24 = Vector3.new(v21 * math.cos(v18), v21 * math.sin(v18), v17)
    local Unit = v24:Cross(if math.abs(v24.Y) < 0.9 then Vector3.new(0, 1, 0) else Vector3.new(1, 0, 0)).Unit
    local Unit2 = v24:Cross(Unit).Unit

    p7.PlaneU = Unit
    p7.PlaneV = Unit2
    p7.Radius = _rng:NextNumber(4.5, 6.5)
    p7.Angle = _rng:NextNumber(0, 6.283185307179586)
    p7.AngularSpeed = _rng:NextNumber(3, 7) * (_rng:NextInteger(0, 1) == 0 and -1 or 1)
    p7.Age = 0
    p7.CurrentRadius = p7.Radius
    p7.Part.Position = p8 + (p7.PlaneU * math.cos(p7.Angle) + p7.PlaneV * math.sin(p7.Angle)) * p7.Radius
    p7.Part.Transparency = 1
    p7.Trail.Enabled = true
    p7.Trail:Clear()
end

function t1:_createOrb(p10) -- line: 137
    local Part = Instance.new("Part")

    Part.Name = "EnergyOrb"
    Part.Shape = Enum.PartType.Ball
    Part.Anchored = true
    Part.CanCollide = false
    Part.CanQuery = false
    Part.CanTouch = false
    Part.CastShadow = false
    Part.Material = Enum.Material.Neon
    Part.Color = self._color
    Part.Size = Vector3.new(0.26, 0.26, 0.26)

    local Attachment = Instance.new("Attachment")

    Attachment.Position = Vector3.new(0, 0.13, 0)
    Attachment.Parent = Part

    local Attachment2 = Instance.new("Attachment")

    Attachment2.Position = Vector3.new(0, -0.13, 0)
    Attachment2.Parent = Part

    local Trail = Instance.new("Trail")

    Trail.Attachment0 = Attachment
    Trail.Attachment1 = Attachment2
    Trail.Lifetime = 0.32
    Trail.LightEmission = 1
    Trail.LightInfluence = 0
    Trail.FaceCamera = true
    Trail.MinLength = 0
    Trail.Color = ColorSequence.new(self._color)
    Trail.WidthScale = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0.85),
        NumberSequenceKeypoint.new(1, 0)
    })
    Trail.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0.2),
        NumberSequenceKeypoint.new(1, 1)
    })
    Trail.Parent = Part

    local t3 = {
        CurrentRadius = 6.5,
        PlaneU = Vector3.new(1, 0, 0),
        PlaneV = Vector3.new(0, 0, 1),
        Radius = 6.5,
        Angle = 0,
        AngularSpeed = 3,
        Age = 0,
        Part = Part,
        Trail = Trail,
        AbsorbSeconds = self._rng:NextNumber(0.9, 1.8)
    }

    self:_resetOrb(t3, p10)
    Part.Parent = self._parent

    return t3
end

function t1:Step(p12, p13, p14) -- line: 197
    if self._destroyed then
        return
    end

    local _orbs = self._orbs

    if #_orbs < 26 then
        self._spawnAccumulator += p14

        local v26 = math.clamp(p13, 0, 1) * -0.19999999999999998 + 0.24

        while v26 <= self._spawnAccumulator and #_orbs < 26 do
            self._spawnAccumulator -= v26
            table.insert(_orbs, self:_createOrb(p12))
        end
    end

    for _, v27 in _orbs do
        v27.Age += p14

        local v28 = v27.Age / v27.AbsorbSeconds

        if v28 >= 1 then
            self:_resetOrb(v27, p12)
        else
            v27.Angle += v27.AngularSpeed * p14 * (1 + v28 * 2.5)
            v27.CurrentRadius = v27.Radius * (1 - v28) ^ 1.5
            v27.Part.Position = p12 + (v27.PlaneU * math.cos(v27.Angle) + v27.PlaneV * math.sin(v27.Angle)) * v27.CurrentRadius

            local Part2 = v27.Part

            if v28 < 0.14 then
                Part2.Transparency = 1 - v28 / 0.14
            elseif v28 > 0.72 then
                Part2.Transparency = (v28 - 0.72) / 0.28
            else
                Part2.Transparency = 0
            end

            v27.Trail.Enabled = v28 <= 0.72
        end
    end
end

function t1:Absorb(p16, p17, p18) -- line: 238
    -- upvalues: Debris (copy), RunService (copy), TweenService (copy)
    if self._destroyed then
        return
    end

    self._destroyed = true

    local v30 = table.clone(self._orbs)

    table.clear(self._orbs)

    if #v30 == 0 then
        return
    end

    local n1 = 0

    while n1 < p17 do
        local v31 = RunService.Heartbeat:Wait()

        n1 += v31

        local v33 = math.min(n1 / p17, 1)
        local v34 = 1 - TweenService:GetValue(v33, Enum.EasingStyle.Quart, Enum.EasingDirection.In)
        local v36 = math.max((v33 - 0.72) / 0.28, 0)

        for _, v37 in v30 do
            v37.Angle += v37.AngularSpeed * v31 * 3.5
            v37.Part.Position = p16 + (v37.PlaneU * math.cos(v37.Angle) + v37.PlaneV * math.sin(v37.Angle)) * (v37.CurrentRadius * v34)
            v37.Part.Transparency = math.max(v37.Part.Transparency, v36)

            if v33 >= 0.82 then
                v37.Trail.Enabled = false
            end
        end

        if p18 ~= nil then
            p18(v31)
        end
    end

    for _, v39 in v30 do
        v39.Part.Transparency = 1
        v39.Trail.Enabled = false
        Debris:AddItem(v39.Part, 0.32)
    end
end

function t1:Destroy() -- line: 289
    if self._destroyed then
        return
    end

    self._destroyed = true

    for _, v40 in self._orbs do
        v40.Part:Destroy()
    end

    table.clear(self._orbs)
end

return t1
