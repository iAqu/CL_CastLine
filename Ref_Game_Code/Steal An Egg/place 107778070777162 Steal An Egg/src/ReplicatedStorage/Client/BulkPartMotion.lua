-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local t = require(ReplicatedStorage.Packages.t)
local TryCall = require(ReplicatedStorage.Shared.Utils.TryCall)
local v1 = require(ReplicatedStorage.Packages.Log).new()
local v2 = t.intersection(t.numberMinExclusive((-1e999)), t.numberMaxExclusive(1e999))

local function isFiniteVector(p1) -- line: 24
    -- upvalues: v2 (copy)
    if typeof(p1) == "Vector3" then
        return v2(p1.X) and v2(p1.Y) and v2(p1.Z)
    end

    return false
end

local function isFiniteCFrame(p2) -- line: 33
    -- upvalues: v2 (copy)
    if typeof(p2) ~= "CFrame" then
        return false
    end

    local Position = p2.Position
    local v3 = typeof(Position) == "Vector3" and v2(Position.X) and v2(Position.Y) and v2(Position.Z)

    if not v3 then
        return v3
    end

    local XVector = p2.XVector
    local v4 = typeof(XVector) == "Vector3" and v2(XVector.X) and v2(XVector.Y) and v2(XVector.Z)

    if not v4 then
        return v4
    end

    local YVector = p2.YVector
    local v5 = typeof(YVector) == "Vector3" and v2(YVector.X) and v2(YVector.Y) and v2(YVector.Z)

    if not v5 then
        return v5
    end

    local ZVector = p2.ZVector

    if typeof(ZVector) == "Vector3" then
        return v2(ZVector.X) and v2(ZVector.Y) and v2(ZVector.Z)
    end

    return false
end

local v6 = t.strict(t.instanceIsA("BasePart"))
local v7 = t.strict(isFiniteCFrame)
local v8 = t.strict(t.optional(isFiniteCFrame))
local v9 = t.strict(isFiniteVector)
local v10 = t.strict(t.TweenInfo)
local t1 = {}

t1.__index = t1

local t2 = {}
local t3 = {}
local t4 = {}
local t5 = {}
local t6 = {}
local t7 = {}

local function isAlive(p3) -- line: 75
    return p3 ~= nil and p3.Parent ~= nil
end

local function dropGlide(p4) -- line: 77
    -- upvalues: t5 (copy)
    t5[p4] = nil
    p4.origin = nil
    p4.destination = nil
    p4.curve = nil
    p4.spent = 0
end

local function retire(p5) -- line: 85
    -- upvalues: t3 (copy), t4 (copy), t5 (copy)
    local body = p5.body

    if body then
        t3[body] = nil
    end

    t4[p5] = nil
    t5[p5] = nil
    p5.origin = nil
    p5.destination = nil
    p5.curve = nil
    p5.spent = 0
    p5.body = nil
    p5.root = nil
    p5.queued = nil
    p5.extent = nil
    p5.retired = true
end

local function writable(p6) -- line: 103
    -- upvalues: t3 (copy), t4 (copy), t5 (copy)
    local body = p6.body

    if body ~= nil and body.Parent ~= nil then
        return body
    end

    local body2 = p6.body

    if body2 then
        t3[body2] = nil
    end

    t4[p6] = nil
    t5[p6] = nil
    p6.origin = nil
    p6.destination = nil
    p6.curve = nil
    p6.spent = 0
    p6.body = nil
    p6.root = nil
    p6.queued = nil
    p6.extent = nil
    p6.retired = true

    return nil
end

local function enqueue(p7, p8) -- line: 114
    -- upvalues: t4 (copy)
    p7.root = p8
    p7.queued = p8 * p7.lean
    t4[p7] = true
end

local function reshape(p9, p10, p11) -- line: 122
    -- upvalues: v9 (copy), t3 (copy), t4 (copy), t5 (copy)
    v9(p10 or p11)

    if p9.retired then
        return
    end

    p9.extent = p10 or p9.extent
    p9.stretch = p11 or p9.stretch

    local body = p9.body

    if body == nil or body.Parent == nil then
        local body2 = p9.body

        if body2 then
            t3[body2] = nil
        end

        t4[p9] = nil
        t5[p9] = nil
        p9.origin = nil
        p9.destination = nil
        p9.curve = nil
        p9.spent = 0
        p9.body = nil
        p9.root = nil
        p9.queued = nil
        p9.extent = nil
        body = nil
        p9.retired = true
    end

    if not body then
        return
    end

    local v11 = p9.extent or body.Size
    local stretch = p9.stretch

    body.Size = Vector3.new(v11.X * stretch.X, v11.Y * stretch.Y, v11.Z * stretch.Z)
end

local function reposition(p12, p13, p14) -- line: 141
    -- upvalues: v7 (copy), t3 (copy), t4 (copy), t5 (copy)
    v7(p13)

    local body = p12.body

    if body == nil or body.Parent == nil then
        local body2 = p12.body

        if body2 then
            t3[body2] = nil
        end

        t4[p12] = nil
        t5[p12] = nil
        p12.origin = nil
        p12.destination = nil
        p12.curve = nil
        p12.spent = 0
        p12.body = nil
        p12.root = nil
        p12.queued = nil
        p12.extent = nil
        body = nil
        p12.retired = true
    end

    if not body then
        return
    end

    t5[p12] = nil
    p12.origin = nil
    p12.destination = nil
    p12.curve = nil
    p12.spent = 0
    p12.root = p13
    p12.queued = p13 * p12.lean
    t4[p12] = true

    if p14 then
        t4[p12] = nil
        body.CFrame = p12.queued
    end
end

local function sweepDead() -- line: 158
    -- upvalues: t3 (copy), t4 (copy), t5 (copy)
    for v15, v16 in t3 do
        if v15 == nil or v15.Parent == nil then
            local body = v16.body

            if body then
                t3[body] = nil
            end

            t4[v16] = nil
            t5[v16] = nil
            v16.origin = nil
            v16.destination = nil
            v16.curve = nil
            v16.spent = 0
            v16.body = nil
            v16.root = nil
            v16.queued = nil
            v16.extent = nil
            v16.retired = true
        end
    end
end

local function advanceGlides(p15) -- line: 168
    -- upvalues: TweenService (copy), t3 (copy), t4 (copy), t5 (copy)
    for v17 in t5 do
        local origin, destination, curve = v17.origin, v17.destination, v17.curve
        local v18 = origin ~= nil and destination ~= nil and curve ~= nil
        local body = v17.body

        if body == nil or body.Parent == nil then
            local body2 = v17.body

            if body2 then
                t3[body2] = nil
            end

            t4[v17] = nil
            t5[v17] = nil
            v17.origin = nil
            v17.destination = nil
            v17.curve = nil
            v17.spent = 0
            v17.body = nil
            v17.root = nil
            v17.queued = nil
            v17.extent = nil
            body = nil
            v17.retired = true
        end

        if body ~= nil then
            if v18 then
                local Time = curve.Time

                v17.spent += p15

                local v19 = if Time > 0 then math.clamp(v17.spent / Time, 0, 1) else 1
                local v21 = origin:Lerp(destination, (TweenService:GetValue(v19, curve.EasingStyle, curve.EasingDirection)))

                v17.root = v21
                v17.queued = v21 * v17.lean
                t4[v17] = true

                if v19 >= 1 then
                    t5[v17] = nil
                    v17.origin = nil
                    v17.destination = nil
                    v17.curve = nil
                    v17.spent = 0
                end
            else
                t5[v17] = nil
                v17.origin = nil
                v17.destination = nil
                v17.curve = nil
                v17.spent = 0
            end
        end
    end
end

function t2.Register(p16, p17) -- line: 199
    -- upvalues: v6 (copy), v8 (copy), t1 (copy), t3 (copy)
    v6(p16)
    v8(p17)

    local v22 = t3[p16]

    if v22 == nil or v22.retired then
        v22 = setmetatable({
            root = nil,
            queued = nil,
            origin = nil,
            destination = nil,
            curve = nil,
            spent = 0,
            extent = nil,
            stretch = Vector3.new(1, 1, 1),
            retired = false,
            body = p16,
            lean = CFrame.identity
        }, t1)
    end

    if p17 then
        v22:SetCFrame(p17)
    end

    t3[p16] = v22

    return v22
end

function t2.Forget(p18) -- line: 232
    -- upvalues: v6 (copy), t3 (copy), t4 (copy), t5 (copy)
    v6(p18)

    local v23 = t3[p18]

    if not v23 then
        return
    end

    local body = v23.body

    if body then
        t3[body] = nil
    end

    t4[v23] = nil
    t5[v23] = nil
    v23.origin = nil
    v23.destination = nil
    v23.curve = nil
    v23.spent = 0
    v23.body = nil
    v23.root = nil
    v23.queued = nil
    v23.extent = nil
    v23.retired = true
end

function t2.Commit(p19) -- line: 243
    -- upvalues: TryCall (copy), v1 (copy), t3 (copy), t4 (copy), t5 (copy), t6 (copy), t7 (copy), sweepDead (copy), advanceGlides (copy)
    advanceGlides(p19 or 0)
    table.clear(t6)
    table.clear(t7)

    local n1 = 0

    for v24 in t4 do
        t4[v24] = nil

        local body, queued = v24.body, v24.queued

        v24.queued = nil

        if body ~= nil and body.Parent ~= nil then
            if queued then
                n1 += 1
                t6[n1] = body
                t7[n1] = queued
            end
        else
            local body = v24.body

            if body then
                t3[body] = nil
            end

            t4[v24] = nil
            t5[v24] = nil
            v24.origin = nil
            v24.destination = nil
            v24.curve = nil
            v24.spent = 0
            v24.body = nil
            v24.root = nil
            v24.queued = nil
            v24.extent = nil
            v24.retired = true
        end
    end

    if not (n1 <= 0) and not TryCall(function() -- line: 272
        -- upvalues: t6 (copy), t7 (copy)
        workspace:BulkMoveTo(t6, t7, Enum.BulkMoveMode.FireCFrameChanged)
    end) then
        sweepDead()
        v1:AtWarning():Log("A batched part move was rejected; the roster was swept")
    end
end

function t1.Subject(p20) -- line: 281
    return if not p20.retired then p20.body else nil
end

function t1.Destroy(p21) -- line: 283
    -- upvalues: t3 (copy), t4 (copy), t5 (copy)
    if p21.retired then
        return
    end

    local body = p21.body

    if body then
        t3[body] = nil
    end

    t4[p21] = nil
    t5[p21] = nil
    p21.origin = nil
    p21.destination = nil
    p21.curve = nil
    p21.spent = 0
    p21.body = nil
    p21.root = nil
    p21.queued = nil
    p21.extent = nil
    p21.retired = true
end

function t1.Halt(p22) -- line: 289
    -- upvalues: t5 (copy)
    t5[p22] = nil
    p22.origin = nil
    p22.destination = nil
    p22.curve = nil
    p22.spent = 0
end

function t1.Stretch(p23, p24) -- line: 291
    -- upvalues: reshape (copy)
    reshape(p23, nil, p24)
end

function t1.Span(p25, p26) -- line: 293
    -- upvalues: reshape (copy)
    reshape(p25, p26, nil)
end

function t1.Lean(p27, p28) -- line: 297
    -- upvalues: v7 (copy), t3 (copy), t4 (copy), t5 (copy)
    v7(p28)

    local body = p27.body

    if body == nil or body.Parent == nil then
        local body2 = p27.body

        if body2 then
            t3[body2] = nil
        end

        t4[p27] = nil
        t5[p27] = nil
        p27.origin = nil
        p27.destination = nil
        p27.curve = nil
        p27.spent = 0
        p27.body = nil
        p27.root = nil
        p27.queued = nil
        p27.extent = nil
        body = nil
        p27.retired = true
    end

    if not body then
        return
    end

    p27.lean = p28

    local v25 = p27.root or body.CFrame

    p27.root = v25
    p27.queued = v25 * p27.lean
    t4[p27] = true
end

function t1.Glide(p29, p30, p31) -- line: 307
    -- upvalues: v7 (copy), v10 (copy), t3 (copy), t4 (copy), t5 (copy)
    v10(p30)
    v7(p31)

    local body = p29.body

    if body == nil or body.Parent == nil then
        local body2 = p29.body

        if body2 then
            t3[body2] = nil
        end

        t4[p29] = nil
        t5[p29] = nil
        p29.origin = nil
        p29.destination = nil
        p29.curve = nil
        p29.spent = 0
        p29.body = nil
        p29.root = nil
        p29.queued = nil
        p29.extent = nil
        body = nil
        p29.retired = true
    end

    if not body then
        return
    end

    p29.origin = p29.root or body.CFrame
    p29.destination = p31
    p29.curve = p30
    p29.spent = 0
    t5[p29] = true
    t4[p29] = true
end

function t1.Snap(p32, p33) -- line: 322
    -- upvalues: v7 (copy), t3 (copy), t4 (copy), t5 (copy)
    v7(p33)

    local body = p32.body

    if body == nil or body.Parent == nil then
        local body2 = p32.body

        if body2 then
            t3[body2] = nil
        end

        t4[p32] = nil
        t5[p32] = nil
        p32.origin = nil
        p32.destination = nil
        p32.curve = nil
        p32.spent = 0
        p32.body = nil
        p32.root = nil
        p32.queued = nil
        p32.extent = nil
        body = nil
        p32.retired = true
    end

    if not body then
        return
    end

    t5[p32] = nil
    p32.origin = nil
    p32.destination = nil
    p32.curve = nil
    p32.spent = 0
    p32.root = p33
    p32.queued = p33 * p32.lean
    t4[p32] = true
    t4[p32] = nil
    body.CFrame = p32.queued
end

function t1.SetCFrame(p34, p35) -- line: 324
    -- upvalues: v7 (copy), t3 (copy), t4 (copy), t5 (copy)
    v7(p35)

    local body = p34.body

    if body == nil or body.Parent == nil then
        local body2 = p34.body

        if body2 then
            t3[body2] = nil
        end

        t4[p34] = nil
        t5[p34] = nil
        p34.origin = nil
        p34.destination = nil
        p34.curve = nil
        p34.spent = 0
        p34.body = nil
        p34.root = nil
        p34.queued = nil
        p34.extent = nil
        body = nil
        p34.retired = true
    end

    if not body then
        return
    end

    t5[p34] = nil
    p34.origin = nil
    p34.destination = nil
    p34.curve = nil
    p34.spent = 0
    p34.root = p35
    p34.queued = p35 * p34.lean
    t4[p34] = true
end

RunService.PreSimulation:Connect(t2.Commit)

return t2
