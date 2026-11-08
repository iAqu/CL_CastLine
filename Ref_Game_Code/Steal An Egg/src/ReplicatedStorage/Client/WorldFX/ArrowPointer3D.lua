-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local Log = require(ReplicatedStorage.Packages.Log)
local Trove = require(ReplicatedStorage.Packages.Trove)
local t = require(ReplicatedStorage.Packages.t)
local Model = ReplicatedStorage.Assets.Models.Pointers.Model
local Shell = Model:FindFirstChild("Shell")

assert(Shell ~= nil and Shell:IsA("BasePart"), "the pointer template needs a Shell BasePart")

local X = Shell.Size.X
local v2 = X * 0.6666666666666666
local Transient = Workspace:WaitForChild("Transient")
local v3 = Color3.fromRGB(255, 72, 48)
local v4 = table.freeze({
    Amplitude = 4,
    Blink = false,
    BlinkFrequency = 1.2,
    CleanupOnPartDestroyed = false,
    Highlight = false,
    OriginOffset = Vector3.new(0, 0, 0),
    OscillationSpeed = 3.2,
    Radius = 4,
    RotationSpeed = 0,
    TargetOffset = Vector3.new(0, 0, 0),
    Color = Color3.new(1, 1, 1),
    ProximityThreshold = X + X / 2
})
local v5 = t.interface({
    Amplitude = t.optional(t.number),
    Blink = t.optional(t.boolean),
    BlinkFrequency = t.optional(t.number),
    CleanupOnPartDestroyed = t.optional(t.boolean),
    Color = t.optional(t.Color3),
    Highlight = t.optional(t.boolean),
    OriginOffset = t.optional(t.Vector3),
    OscillationSpeed = t.optional(t.number),
    ProximityThreshold = t.optional(t.number),
    Radius = t.optional(t.number),
    RotationSpeed = t.optional(t.number),
    TargetOffset = t.optional(t.Vector3)
})
local t1 = {}

t1.__index = t1
t1.__class = "ArrowPointer3D"
t1.__types = {
    Config = v5,
    OptionalConfig = t.optional(v5)
}

local v6 = Log.new()
local t2 = {}
local v7 = t.optional(t.union(t.instanceIsA("BasePart"), t.Vector3))

local function withDefaults(p1) -- line: 120
    -- upvalues: v4 (copy)
    local v8 = table.clone(v4)

    if p1 ~= nil then
        for v9, v10 in p1 do
            v8[v9] = v10
        end
    end

    return v8
end

local function pointOf(p2, p3) -- line: 130
    return (if typeof(p2) == "Vector3" then p2 else p2.Position) + p3
end

local function inWorld(p4) -- line: 135
    -- upvalues: Workspace (copy)
    if p4 == nil then
        return false
    end

    if typeof(p4) == "Vector3" then
        return true
    end

    return p4:IsDescendantOf(Workspace)
end

local function bothInWorld(p5) -- line: 145
    -- upvalues: Workspace (copy)
    local origin = p5.origin
    local v11 = origin ~= nil and (typeof(origin) == "Vector3" or origin:IsDescendantOf(Workspace))

    if v11 then
        local target = p5.target

        if target == nil then
            return false
        end

        if typeof(target) == "Vector3" then
            return true
        end

        v11 = target:IsDescendantOf(Workspace)
    end

    return v11
end

local function halt(p6) -- line: 149
    -- upvalues: t2 (copy)
    if not p6.isRunning then
        return false
    end

    p6.isRunning = false
    t2[p6] = nil
    p6.model.Parent = nil

    return true
end

local function track(p7, p8, p9) -- line: 161
    -- upvalues: Workspace (copy), t2 (copy)
    local v12 = p7.endScopes[p8]

    v12:Clean()

    if p7.Config.CleanupOnPartDestroyed then
        v12:Connect(p9.Destroying, function() -- line: 166
            -- upvalues: p7 (copy)
            p7:Destroy()
        end)
    end

    v12:Connect(p9.AncestryChanged, function() -- line: 170
        -- upvalues: p7 (copy), Workspace (copy), t2 (copy)
        local origin = p7.origin
        local v13 = origin ~= nil and (typeof(origin) == "Vector3" or origin:IsDescendantOf(Workspace))

        if v13 then
            local target = p7.target

            v13 = target ~= nil and (typeof(target) == "Vector3" or target:IsDescendantOf(Workspace))
        end

        if v13 then
            p7:Start()
        elseif p7.isRunning then
            p7.isRunning = false
            t2[p7] = nil
            p7.model.Parent = nil
            p7.haltedByWorld = true
        end
    end)
end

local function bind(p10, p11, p12) -- line: 179
    -- upvalues: Workspace (copy), track (copy)
    if typeof(p12) == "Instance" then
        if p10.boundParts[p11] ~= p12 then
            p10.boundParts[p11] = p12
            track(p10, p11, p12)
        end
    else
        p10.boundParts[p11] = nil
        p10.endScopes[p11]:Clean()
    end

    p10[p11 == "Origin" and "origin" or "target"] = p12

    if p10.haltedByWorld then
        local origin = p10.origin
        local v14 = origin ~= nil and (typeof(origin) == "Vector3" or origin:IsDescendantOf(Workspace))

        if v14 then
            local target = p10.target

            v14 = target ~= nil and (typeof(target) == "Vector3" or target:IsDescendantOf(Workspace))
        end

        if v14 then
            p10:Start()
        end
    end
end

local function tintAt(p13, p14) -- line: 198
    -- upvalues: v3 (copy)
    if not p13.Blink then
        return p13.Color
    end

    local v16 = math.sin(p14 * p13.BlinkFrequency * 6.283185307179586) * 0.5 + 0.5

    return p13.Color:Lerp(v3, v16)
end

local function settleReach(p15, p16) -- line: 208
    local Config = p15.Config
    local v18 = if math.sin(p15.clock * Config.OscillationSpeed) >= 0 then Config.Amplitude else -Config.Amplitude
    local v19 = Config.Radius + v18
    local v20 = Config.OscillationSpeed * 1.6
    local v21 = -(v20 * v20) * (p15.reach - v19) - 1 * v20 * p15.reachVelocity

    p15.reachVelocity += v21 * p16
    p15.reach += p15.reachVelocity * p16

    if p15.reach < 0 then
        p15.reach = 0
        p15.reachVelocity = math.max(p15.reachVelocity, 0)
    end

    return p15.reach
end

local function poseAlong(p17, p18, p19, p20) -- line: 227
    local Unit = (p18 - p17).Unit
    local Unit2 = Unit:Cross(if math.abs((Unit:Dot((Vector3.new(0, 1, 0))))) > 0.98 then Vector3.new(0, 0, 1) else Vector3.new(0, 1, 0)).Unit
    local v23 = Unit2:Cross(Unit)

    if p20 ~= 0 then
        local v24 = CFrame.fromAxisAngle(Unit, -p20)

        Unit2 = v24:VectorToWorldSpace(Unit2)
        v23 = v24:VectorToWorldSpace(v23)
    end

    return CFrame.fromMatrix(p17 + Unit * p19, -Unit, -Unit2, -v23)
end

local function advance(p21, p22) -- line: 240
    -- upvalues: Workspace (copy), v2 (copy), v3 (copy), settleReach (copy), poseAlong (copy)
    local v25 = math.min(p22, 0.05)

    p21.clock += v25

    local origin = p21.origin
    local v26 = origin ~= nil and (typeof(origin) == "Vector3" or origin:IsDescendantOf(Workspace))

    if v26 then
        local target = p21.target

        v26 = target ~= nil and (typeof(target) == "Vector3" or target:IsDescendantOf(Workspace))
    end

    if not v26 then
        return
    end

    local Config, origin2 = p21.Config, p21.origin
    local OriginOffset = Config.OriginOffset

    if typeof(origin2) ~= "Vector3" then
        origin2 = origin2.Position
    end

    local v27 = origin2 + OriginOffset
    local target = p21.target
    local TargetOffset = Config.TargetOffset

    if typeof(target) ~= "Vector3" then
        target = target.Position
    end

    local v28 = target + TargetOffset
    local Core = p21.model.Core
    local clock = p21.clock

    if Config.Blink then
        local v30 = math.sin(clock * Config.BlinkFrequency * 6.283185307179586) * 0.5 + 0.5

        Core.Color = Config.Color:Lerp(v3, v30)
    else
        Core.Color = Config.Color
    end

    if (v28 - v27).Magnitude < Config.ProximityThreshold then
        p21.model.Parent = nil
    else
        if p21.model.Parent == nil then
            p21.model.Parent = p21.stage
        end

        local v31 = settleReach(p21, v25) + v2

        p21.model:PivotTo(poseAlong(v27, v28, v31, p21.clock * Config.RotationSpeed))
    end
end

function t1.new(p23, p24, p25) -- line: 265
    -- upvalues: Trove (copy), Model (copy), Transient (copy), v4 (copy), t1 (copy), v7 (copy), bind (copy)
    assert(t1.__types.OptionalConfig(p25))
    assert(v7(p23))
    assert(v7(p24))

    local v32 = Trove.new()
    local self = setmetatable({}, t1)
    local v34 = table.clone(v4)

    if p25 ~= nil then
        for v35, v36 in p25 do
            v34[v35] = v36
        end
    end

    self.Config = v34
    self.model = v32:Clone(Model)
    self.stage = Transient
    self.scope = v32
    self.endScopes = {
        Origin = v32:Extend(),
        Target = v32:Extend()
    }
    self.boundParts = {}
    self.clock = 0
    self.reach = self.Config.Radius
    self.reachVelocity = 0
    self.isRunning = false
    self.haltedByWorld = false
    self.retired = false
    self.model.Core.Color = self.Config.Color

    if p24 ~= nil then
        bind(self, "Origin", p24)
    end

    if p23 ~= nil then
        bind(self, "Target", p23)
    end

    return self
end

function t1:Start() -- line: 297
    -- upvalues: Workspace (copy), t2 (copy)
    if self.isRunning or self.retired then
        return false
    end

    local origin = self.origin
    local v37 = origin ~= nil and (typeof(origin) == "Vector3" or origin:IsDescendantOf(Workspace))

    if v37 then
        local target = self.target

        v37 = target ~= nil and (typeof(target) == "Vector3" or target:IsDescendantOf(Workspace))
    end

    assert(v37, "an arrow needs both of its anchors in the world before it starts")
    self.isRunning = true
    self.haltedByWorld = false
    self.model.Parent = self.stage
    t2[self] = true

    return true
end

function t1:Stop() -- line: 310
    -- upvalues: t2 (copy)
    self.haltedByWorld = false

    if not self.isRunning then
        return false
    end

    self.isRunning = false
    t2[self] = nil
    self.model.Parent = nil

    return true
end

function t1.PointFrom(p28, p29) -- line: 315
    -- upvalues: v7 (copy), bind (copy)
    assert(v7(p29))
    bind(p28, "Origin", p29)
end

function t1.PointAt(p30, p31) -- line: 320
    -- upvalues: v7 (copy), bind (copy)
    assert(v7(p31))
    bind(p30, "Target", p31)
end

function t1:Destroy() -- line: 325
    -- upvalues: t2 (copy)
    if self.retired then
        return
    end

    self.retired = true

    if self.isRunning then
        self.isRunning = false
        t2[self] = nil
        self.model.Parent = nil
    end

    self.scope:Destroy()
end

RunService.RenderStepped:Connect(function(p33) -- line: 334
    -- upvalues: v6 (copy), t2 (copy), advance (copy)
    for v38 in t2 do
        local ok, result = pcall(advance, v38, p33)

        if not ok then
            v6:AtError():Log((("arrow pointer step failed: %*"):format(result)))

            if v38.isRunning then
                v38.isRunning = false
                t2[v38] = nil
                v38.model.Parent = nil
            end
        end
    end
end)

return t1
