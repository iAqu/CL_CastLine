-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")
local Fx = require(script.Parent.Fx)
local Trove = require(ReplicatedStorage.Packages.Trove)
local t1 = {
    [0] = 1,
    0.9, 0.8, 0.7
}
local t2 = {}

t2.__index = t2

local function easeOutBack(p1) -- line: 60
    return (p1 - 1) ^ 3 * 2.70158 + 1 + (p1 - 1) ^ 2 * 1.70158
end

local function stageOffset(p2, p3) -- line: 66
    if p3 <= 0 then
        return CFrame.identity
    end

    local v2 = math.clamp(math.floor(p3), 1, 2)
    local Attribute = p2:GetAttribute((("Stage%*Offset"):format(v2)))
    local Attribute2 = p2:GetAttribute((("Stage%*Rot"):format(v2)))

    if typeof(Attribute) ~= "Vector3" then
        Attribute = Vector3.new(0, 0, 0)
    end

    if typeof(Attribute2) ~= "Vector3" then
        Attribute2 = Vector3.new(0, 0, 0)
    end

    return CFrame.new(Attribute) * CFrame.Angles(math.rad(Attribute2.X), math.rad(Attribute2.Y), (math.rad(Attribute2.Z)))
end

local function lerpOffset(p4, p5, p6) -- line: 78
    local v6 = p4.Position:Lerp(p5.Position, p6)
    local v7 = p4.Rotation:Lerp(p5.Rotation, (math.clamp(p6, 0, 1)))

    return CFrame.new(v6) * v7
end

local function setTransparency(p7, p8) -- line: 84
    for _, descendant in p7:GetDescendants() do
        if descendant:IsA("BasePart") and descendant:GetAttribute("KeepHidden") ~= true then
            descendant.LocalTransparencyModifier = p8
        end
    end
end

function t2.new(p9, p10, p11, p12) -- line: 96
    -- upvalues: RunService (copy), Fx (copy), Trove (copy), t2 (copy)
    local clone = Fx.Kit():FindFirstChild("Meteor"):Clone()

    clone:PivotTo(p9)

    local PrimaryPart = clone.PrimaryPart
    local Rock = clone:WaitForChild("Rock")
    local Star = clone:WaitForChild("Star")
    local v8 = Trove.new()

    v8:Add(clone)

    local t3 = {}

    for _, child in Rock:GetChildren() do
        if child:IsA("BasePart") then
            local v9 = PrimaryPart.CFrame:ToObjectSpace(child.CFrame)

            table.insert(t3, {
                Velocity = Vector3.new(0, 0, 0),
                Spin = Vector3.new(0, 0, 0),
                Part = child,
                Rest = v9,
                Dir = if v9.Position.Magnitude > 0.01 then v9.Position.Unit else Vector3.new(0, 1, 0)
            })
        end
    end

    local v11 = setmetatable({
        Broken = false,
        _poseFrom = 0,
        _poseTo = 0,
        _poseAt = (-1e999),
        _joltAt = (-1e999),
        _joltPower = 0,
        _hum = nil,
        _starOverride = nil,
        _dim = 1,
        _lightOffAt = nil,
        Model = clone,
        Core = PrimaryPart,
        Star = Star,
        Landing = p9,
        Stage = math.clamp(p11, 0, p10 - 1),
        Total = p10,
        _trove = v8,
        _chunks = t3,
        _starRest = PrimaryPart.CFrame:ToObjectSpace(Star.CFrame),
        _starScale = Star.Size,
        _glow = PrimaryPart:FindFirstChild("Glow"),
        _highlight = clone:FindFirstChild("Aura"),
        _beacon = PrimaryPart:FindFirstChild("Beacon"),
        _startedAt = os.clock()
    }, t2)

    Star.Size = v11._starScale * 0.5
    v11._poseFrom = v11.Stage
    v11._poseTo = v11.Stage
    clone.Parent = p12

    if v11._beacon then
        v11._beacon.Width0 = 0
        v11._beacon.Width1 = 0
    end

    v8:Connect(RunService.RenderStepped, function() -- line: 156
        -- upvalues: v11 (copy)
        v11:_step()
    end)
    v11:_step()

    return v11
end

function t2._step(p13) -- line: 163
    -- upvalues: Workspace (copy), t1 (copy), stageOffset (copy)
    local elapsed = os.clock()
    local v13 = math.clamp((elapsed - p13._poseAt) / 0.42, 0, 1)
    local v14 = (v13 - 1) ^ 3 * 2.70158 + 1 + (v13 - 1) ^ 2 * 1.70158
    local v16 = (1 - math.clamp((elapsed - p13._joltAt) / 0.32, 0, 1)) ^ 2 * p13._joltPower
    local v18 = math.sin((elapsed - p13._startedAt) * 2.4)
    local _CFrame = p13.Core.CFrame

    if not p13.Broken then
        local t6 = {}
        local t7 = {}

        for v19, v20 in p13._chunks do
            local v21 = stageOffset(v20.Part, p13._poseFrom)
            local v22 = stageOffset(v20.Part, p13._poseTo)
            local v23 = v21.Position:Lerp(v22.Position, v14)
            local v24 = v21.Rotation:Lerp(v22.Rotation, (math.clamp(v14, 0, 1)))
            local v25 = CFrame.new(v23) * v24
            local v26

            if v16 > 0 then
                local v27 = v19 * 12.9898 + elapsed * 61

                v26 = Vector3.new(math.noise(v27, 1), math.noise(v27, 2), math.noise(v27, 3)) * v16
            else
                v26 = Vector3.new(0, 0, 0)
            end

            local v30 = v20.Dir * (0.04 + 0.03 * p13.Stage) * v18

            table.insert(t6, v20.Part)
            table.insert(t7, _CFrame * CFrame.new(v25.Position + v26 + v30) * v20.Rest * v25.Rotation)
        end

        Workspace:BulkMoveTo(t6, t7, Enum.BulkMoveMode.FireCFrameChanged)
    end

    local v32 = v18 * 0.08 + 1
    local _dim = p13._dim

    if p13._lightOffAt then
        _dim *= math.clamp(1 - (elapsed - p13._lightOffAt) / 0.3, 0, 1)
    end

    if p13._glow then
        p13._glow.Brightness = v32 * 0.3 * _dim
        p13._glow.Range = 9
        p13._glow.Enabled = _dim > 0
    end

    if p13._highlight and not p13.Broken then
        local v34 = t1[math.clamp(p13.Stage, 0, 3)] or 0.5

        p13._highlight.FillTransparency = math.clamp(v34 - v18 * 0.06 - v16 * 0.4, 0, 1)
    end

    if p13._starOverride then
        p13.Star.CFrame = p13._starOverride
    else
        local v36 = CFrame.Angles(0, (elapsed - p13._startedAt) * 1.3, 0)

        p13.Star.CFrame = _CFrame * p13._starRest * v36
    end
end

function t2.SetStage(p14, p15, p16) -- line: 221
    local v38 = math.clamp(p15, 0, p14.Total - 1)

    if p16 then
        p14._poseFrom = p14._poseTo
    else
        p14._poseFrom = v38
    end

    p14._poseTo = v38

    if p16 then
        p14._poseAt = os.clock()
    else
        p14._poseAt = (-1e999)
    end

    p14.Stage = v38
end

function t2.Rise(p17, p18) -- line: 229
    -- upvalues: TweenService (copy), Fx (copy)
    local _beacon = p17._beacon

    if _beacon then
        TweenService:Create(_beacon, TweenInfo.new(p18, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
            Width0 = 7,
            Width1 = 2.4499999999999997
        }):Play()
    end

    if p17._hum == nil then
        p17._hum = Fx.Sound("StarHum", p17.Core)

        if p17._hum then
            p17._hum.Looped = true
            p17._trove:Add(p17._hum)
        end
    end
end

function t2.Open(p19) -- line: 247
    -- upvalues: RunService (copy), TweenService (copy), Workspace (copy), Fx (copy)
    if p19.Broken then
        return
    end

    local CorePosition = p19.Core.Position
    local _trove = p19._trove

    p19._joltAt = os.clock()
    p19._joltPower = 0.9
    Fx.Sound("StarCharge", CorePosition, 0.6)
    Fx.Emit("Charge", CorePosition, 1)
    task.delay(Fx.ReducedMotion() and 0.2 or 0.42, function() -- line: 260
        -- upvalues: p19 (copy), CorePosition (copy), _trove (copy), RunService (copy), TweenService (copy), Workspace (copy), Fx (copy)
        if p19.Model.Parent == nil then
            return
        end

        p19.Broken = true
        p19.Star.Transparency = 1
        Fx.Sound("StarBurst", CorePosition, 0.75)
        Fx.Emit("Burst", CorePosition, 0.8)
        Fx.Emit("Reveal", CorePosition + Vector3.new(0, 3, 0), 1)
        Fx.Shake(0.4, 0.7, CorePosition)

        if p19._beacon then
            TweenService:Create(p19._beacon, TweenInfo.new(0.6), {
                Width0 = 0,
                Width1 = 0
            }):Play()
        end

        local _highlight = p19._highlight

        if _highlight then
            TweenService:Create(_highlight, TweenInfo.new(0.5), {
                FillTransparency = 1,
                OutlineTransparency = 1
            }):Play()
        end

        local v39 = Random.new()

        for _, v40 in p19._chunks do
            v40.Velocity = (v40.Dir * Vector3.new(1, 0.35, 1) + Vector3.new(0, 0.9, 0)).Unit * v39:NextNumber(26, 44)
            v40.Spin = Vector3.new(v39:NextNumber(-9, 9), v39:NextNumber(-9, 9), v39:NextNumber(-9, 9))
            v40.Free = v40.Part.CFrame
        end

        local v43 = p19.Landing.Position.Y + 0.4
        local elapsed = os.clock()
        local connection

        connection = _trove:Connect(RunService.RenderStepped, function(p20) -- line: 294
            -- upvalues: v43 (copy), elapsed (copy), connection (ref), p19 (copy), Workspace (copy)
            local v44 = os.clock() - elapsed
            local t8 = {}
            local t9 = {}

            for _, v45 in p19._chunks do
                local Free = v45.Free

                v45.Velocity += Vector3.new(0, -120, 0) * p20

                local v46 = Free.Position + v45.Velocity * p20

                if v46.Y < v43 and v45.Velocity.Y < 0 then
                    v46 = Vector3.new(v46.X, v43, v46.Z)
                    v45.Velocity = Vector3.new(v45.Velocity.X * 0.45, -v45.Velocity.Y * 0.32, v45.Velocity.Z * 0.45)
                    v45.Spin *= 0.5
                end

                local v50 = v45.Spin * p20

                v45.Free = CFrame.new(v46) * Free.Rotation * CFrame.Angles(v50.X, v50.Y, v50.Z)
                table.insert(t8, v45.Part)
                table.insert(t9, v45.Free)

                local v52 = math.clamp((v44 - 1.14) / 0.76, 0, 1)

                v45.Part.LocalTransparencyModifier = v52
            end

            Workspace:BulkMoveTo(t8, t9, Enum.BulkMoveMode.FireCFrameChanged)

            if not (v44 > 1.9) then
                return
            end

            connection:Disconnect()

            for _, v53 in p19._chunks do
                v53.Part.Transparency = 1
            end
        end)
    end)
end

function t2.LightOff(p21) -- line: 331
    if p21._lightOffAt == nil then
        p21._lightOffAt = os.clock()
    end
end

function t2.Fade(p22) -- line: 337
    -- upvalues: RunService (copy), TweenService (copy), setTransparency (copy)
    local Model = p22.Model

    if p22._beacon then
        TweenService:Create(p22._beacon, TweenInfo.new(1.5), {
            Width0 = 0,
            Width1 = 0
        }):Play()
    end

    if p22._hum then
        TweenService:Create(p22._hum, TweenInfo.new(1.5), {
            Volume = 0
        }):Play()
    end

    local elapsed = os.clock()
    local connection

    connection = p22._trove:Connect(RunService.RenderStepped, function() -- line: 347
        -- upvalues: p22 (copy), Model (copy), elapsed (copy), connection (ref), setTransparency (copy)
        local v55 = math.clamp((os.clock() - elapsed) / 1.1, 0, 1)

        setTransparency(Model, v55)
        p22._dim = 1 - v55

        if not (v55 >= 1) then
            return
        end

        connection:Disconnect()
        p22:Destroy()
    end)
end

function t2.Destroy(p23) -- line: 358
    p23._trove:Destroy()
end

return t2
