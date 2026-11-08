-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Debris = game:GetService("Debris")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local Constants = require(ReplicatedStorage.Shared.Globals.Constants)
local v1 = Random.new()
local t1 = {}

function t1.Discard(p1, p2) -- line: 27
    -- upvalues: Debris (copy)
    Debris:AddItem(p1, if p2 == nil or not (p2 > 0) then 0 else p2)
end

local function numberAttribute(p3, p4, p5) -- line: 33
    local Attribute = p3:GetAttribute(p4)

    if type(Attribute) == "number" then
        return Attribute
    end

    return p5
end

local function stochasticRound(p6) -- line: 40
    -- upvalues: v1 (copy)
    return (math.floor(p6 + v1:NextNumber()))
end

local function thinForHandheld(p7, p8) -- line: 44
    -- upvalues: Constants (copy)
    local v4

    if not p8 or not Constants.IS_MOBILE or p7 <= 1 then
        return p7
    else
        v4 = if type(p8) == "number" then p8 else 0.1
    end

    return (math.max(1, (math.round(p7 * v4))))
end

local function isPlaying(p9) -- line: 52
    return p9.TimeScale > 0
end

local function isHandFired(p10) -- line: 56
    return not (p10 < 1e999)
end

local function cueFor(p11, p12) -- line: 62
    -- upvalues: Constants (copy), v1 (copy)
    local EmitDelay = p11:GetAttribute("EmitDelay")

    if type(EmitDelay) ~= "number" then
        EmitDelay = 0
    end

    if not (p11.TimeScale > 0 and EmitDelay < 1e999) then
        return nil
    end

    local Rate = p11.Rate
    local EmitCount = p11:GetAttribute("EmitCount")

    if type(EmitCount) ~= "number" then
        EmitCount = Rate
    end

    local v9 = math.floor(EmitCount + v1:NextNumber())

    if p12 and Constants.IS_MOBILE and not (v9 <= 1) then
        v9 = math.max(1, (math.round(v9 * (if type(p12) == "number" then p12 else 0.1))))
    end

    return if not (v9 < 1) then {
        emitter = p11,
        pieces = v9,
        at = math.max(EmitDelay, 0)
    } else nil
end

local function lifetimeSeconds(p13) -- line: 72
    return p13.Lifetime.Max / p13.TimeScale
end

local function settleSeconds(p14) -- line: 76
    local at, emitter = p14.at, p14.emitter

    return at + emitter.Lifetime.Max / emitter.TimeScale
end

local function byCueTime(p15, p16) -- line: 80
    return p15.at < p16.at
end

local function playTimeline(p17) -- line: 87
    -- upvalues: byCueTime (copy)
    table.sort(p17, byCueTime)

    local n1 = 0

    for _, v12 in p17 do
        local at, emitter = v12.at, v12.emitter

        n1 = math.max(n1, at + emitter.Lifetime.Max / emitter.TimeScale)
    end

    local n2 = 1
    local n3 = 1

    while n3 <= #p17 and p17[n3].at <= 0 do
        local v14 = p17[n3]

        v14.emitter:Emit(v14.pieces)
        n3 += 1
        n2 = n3
    end

    if n3 <= #p17 then
        task.spawn(function() -- line: 103
            -- upvalues: p17 (copy), n2 (ref)
            local v16 = n2
            local v17 = #p17
            local n4 = 0

            for i = v16, v17 do
                local v18 = p17[i]

                if n4 < v18.at then
                    n4 += task.wait(v18.at - n4)
                end

                if v18.emitter:IsDescendantOf(game) then
                    v18.emitter:Emit(v18.pieces)
                end
            end
        end)
    end

    return n1
end

local function collectEmitters(p18) -- line: 120
    local t2 = {}

    if p18:IsA("ParticleEmitter") then
        table.insert(t2, p18)
    end

    for _, descendant in p18:GetDescendants() do
        if descendant:IsA("ParticleEmitter") then
            table.insert(t2, descendant)
        end
    end

    return t2
end

local function cuesFor(p19, p20) -- line: 133
    -- upvalues: cueFor (copy)
    local t3 = {}

    for _, v19 in p19 do
        local v20 = cueFor(v19, p20)

        if v20 then
            table.insert(t3, v20)
        end
    end

    return t3
end

function t1.EmitOne(p21, p22) -- line: 144
    -- upvalues: cueFor (copy), playTimeline (copy)
    local v21 = cueFor(p21, p22)

    if v21 == nil then
        return 0
    end

    return (playTimeline({ v21 }))
end

function t1.EmitTree(p23, p24) -- line: 152
    -- upvalues: playTimeline (copy), collectEmitters (copy), cuesFor (copy)
    return (playTimeline((cuesFor(collectEmitters(p23), p24))))
end

local function scaleSequence(p25, p26) -- line: 158
    local v22 = table.create(#p25.Keypoints)

    for v23, v24 in p25.Keypoints do
        v22[v23] = NumberSequenceKeypoint.new(v24.Time, v24.Value * p26, v24.Envelope * p26)
    end

    return NumberSequence.new(v22)
end

function t1.Rescale(p27, p28) -- line: 166
    -- upvalues: scaleSequence (copy)
    p27.Acceleration *= p28
    p27.Size = scaleSequence(p27.Size, p28)
    p27.Speed = NumberRange.new(p27.Speed.Min * p28, p27.Speed.Max * p28)
end

local t4 = {
    Anchored = true,
    CanCollide = false,
    CanQuery = false,
    CanTouch = false,
    CastShadow = false,
    Locked = true,
    Massless = true,
    Name = "EffectAnchor",
    Size = Vector3.new(0, 0, 0),
    Transparency = 1
}

local function newAnchorPart(p29) -- line: 187
    -- upvalues: Workspace (copy), t4 (copy)
    local Part = Instance.new("Part")

    for v25, v26 in t4 do
        Part[v25] = v26
    end

    Part:PivotTo(p29)
    Part.Parent = Workspace:WaitForChild("Transient")

    return Part
end

local function hostOfInstance(p30) -- line: 198
    if not p30:IsA("Model") then
        return p30
    end

    local PrimaryPart = p30.PrimaryPart

    assert(PrimaryPart, (("%* needs a PrimaryPart to anchor effects"):format((p30:GetFullName()))))

    return PrimaryPart
end

local t5 = {}

function t5.CFrame(p31) -- line: 208
    -- upvalues: Workspace (copy), t4 (copy)
    local Part = Instance.new("Part")

    for v28, v29 in t4 do
        Part[v28] = v29
    end

    Part:PivotTo(p31)
    Part.Parent = Workspace:WaitForChild("Transient")

    return Part, Part
end

function t5.Instance(p32) -- line: 212
    local PrimaryPart

    if not p32:IsA("Model") then
        PrimaryPart = p32

        return PrimaryPart, nil
    end

    PrimaryPart = p32.PrimaryPart
    assert(PrimaryPart, (("%* needs a PrimaryPart to anchor effects"):format((p32:GetFullName()))))

    return PrimaryPart, nil
end

function t5.Vector3(p33) -- line: 215
    -- upvalues: Workspace (copy), t4 (copy)
    local v31 = CFrame.new(p33)
    local Part = Instance.new("Part")

    for v32, v33 in t4 do
        Part[v32] = v33
    end

    Part:PivotTo(v31)
    Part.Parent = Workspace:WaitForChild("Transient")

    return Part, Part
end

local function anchorFor(p34) -- line: 223
    -- upvalues: t5 (copy)
    local v34 = t5[typeof(p34)]

    if v34 == nil then
        error((("effects cannot be placed at a %*"):format((typeof(p34)))))
    end

    return v34(p34)
end

function t1.EmitAt(p35, p36, p37) -- line: 233
    -- upvalues: t1 (copy), cueFor (copy), playTimeline (copy), t5 (copy)
    local v35 = t5[typeof(p35)]

    if v35 == nil then
        error((("effects cannot be placed at a %*"):format((typeof(p35)))))
    end

    local v36, v37 = v35(p35)
    local t6 = {}
    local t7 = {}

    local function stageClone(p38) -- line: 238
        -- upvalues: p37 (copy), v36 (copy), v37 (copy), t6 (copy), t7 (copy), t1 (copy), cueFor (copy)
        local clone = p38:Clone()

        clone.Enabled = false

        if p37 then
            p37(clone)
        end

        clone.Parent = v36

        local v38 = cueFor(clone, true)

        if v38 ~= nil then
            table.insert(t6, clone)
            table.insert(t7, v38)

            if v37 == nil then
                local Discard = t1.Discard
                local at, emitter = v38.at, v38.emitter

                Discard(clone, at + emitter.Lifetime.Max / emitter.TimeScale)
            end
        else
            clone:Destroy()
        end
    end

    for _, v39 in p36 do
        if v39:IsA("ParticleEmitter") and v39.TimeScale > 0 then
            stageClone(v39)
        end
    end

    local v40 = playTimeline(t7)

    if v37 then
        t1.Discard(v37, v40)
    end

    return {
        clones = t6,
        settleSeconds = v40
    }
end

return table.freeze(t1)
