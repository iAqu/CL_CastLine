-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Audio = require(ReplicatedStorage.Shared.Audio)
local ParticleStage = require(script.Parent.ParticleStage)
local v1 = NumberRange.new(0.92, 1.08)
local v2 = NumberRange.new(1.8, 2.2)

local function fade() -- line: 23
    return NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0, 0),
        NumberSequenceKeypoint.new(0.8, 0, 0),
        NumberSequenceKeypoint.new(1, 1, 0)
    })
end

local t1 = {
    Drag = -0.5,
    Enabled = false,
    LightInfluence = 1,
    LockedToPart = true,
    Rate = 15,
    Texture = "rbxassetid://104352847228921",
    ZOffset = 2,
    EmissionDirection = Enum.NormalId.Top,
    Lifetime = NumberRange.new(3, 5),
    Orientation = Enum.ParticleOrientation.VelocityParallel,
    RotSpeed = NumberRange.new(-60, 60),
    Rotation = NumberRange.new(-180, 180),
    ShapeStyle = Enum.ParticleEmitterShapeStyle.Surface,
    Size = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0.1, 0.03),
        NumberSequenceKeypoint.new(1, 0.1, 0.03)
    }),
    Speed = NumberRange.new(-3, -1.5),
    SpreadAngle = Vector2.new(0, 15),
    Squash = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0, 1),
        NumberSequenceKeypoint.new(1, 0, 1)
    }),
    Transparency = fade()
}
local t2 = {
    Drag = 2.4,
    Speed = NumberRange.new(19, 28)
}
local Max = t1.Lifetime.Max
local v3 = Random.new()
local v6 = (function() -- paintSwatches | line: 93
    local v4 = table.create(5)

    for i = 1, 5 do
        local v5 = ((i - 1) * 0.618033988749895 + 0.74) % 1

        v4[i] = Color3.fromHSV(v5, 0.66, 1)
    end

    return v4
end)()

local function orDefault(p1, p2) -- line: 104
    if p1 == nil then
        return p2
    end

    return p1
end

local function resolveTuning(p3) -- line: 108
    -- upvalues: v6 (copy)
    local v7 = p3.Opening or {}
    local v8 = p3.Scale or {}
    local Seconds = p3.Seconds

    if Seconds == nil then
        Seconds = 4.5
    end

    local t3 = {}

    t3.streamSeconds = Seconds

    local Palette = p3.Palette

    t3.swatches = if Palette ~= nil then Palette else v6
    t3.texture = if p3.Texture == nil or p3.Texture == "" then nil else p3.Texture

    local Pop = v7.Pop

    t3.pops = Pop == nil or Pop

    local Sound = v7.Sound

    t3.audible = Sound == nil or Sound

    local Rate = v8.Rate

    t3.rate = if Rate == nil then 1 else Rate

    local Size = v8.Size

    t3.size = if Size == nil then 1 else Size

    local Speed = v8.Speed

    t3.speed = if Speed == nil then 1 else Speed

    local Volume = v8.Volume

    t3.loudness = if Volume == nil then 1 else Volume

    return t3
end

local function layerOverrides(p4, p5, p6) -- line: 124
    -- upvalues: t1 (copy), v3 (copy)
    local v10 = p5.speed * (1 + v3:NextNumber(-0.08, 0.08))
    local Speed = t1.Speed
    local t4 = {
        Color = ColorSequence.new(p4),
        Rate = t1.Rate * p5.rate * p6,
        Speed = NumberRange.new(Speed.Min * v10, Speed.Max * v10),
        ZOffset = t1.ZOffset + v3:NextNumber(-0.07, 0.07)
    }

    if p5.texture ~= nil then
        t4.Texture = p5.texture
    end

    return t4
end

local function buildStreamer(p7, p8, p9) -- line: 139
    -- upvalues: ParticleStage (copy), t1 (copy), layerOverrides (copy)
    local v11 = ParticleStage.Emitter(t1, (layerOverrides(p7, p8, p9)))

    if p8.size ~= 1 then
        ParticleStage.Scale(v11, p8.size)
    end

    return v11
end

local function throwPop(p10, p11, p12, p13) -- line: 147
    -- upvalues: ParticleStage (copy), t1 (copy), t2 (copy), layerOverrides (copy)
    local v13 = math.round(p12.rate * 100 * p13)

    if v13 < 1 then
        return
    end

    local v14 = layerOverrides(p11, p12, p13)

    for v15, v16 in t2 do
        v14[v15] = v16
    end

    local v17 = ParticleStage.Emitter(t1, v14)

    if p12.size ~= 1 then
        ParticleStage.Scale(v17, p12.size)
    end

    p10:Adopt(v17)
    v17:Emit(v13)
end

local function ringPop(p14) -- line: 164
    -- upvalues: Audio (copy), v1 (copy), v2 (copy), v3 (copy)
    Audio.Play("rbxassetid://135524199765808", script, {
        PlaybackSpeed = v3:NextNumber(v1.Min, v1.Max),
        Volume = v3:NextNumber(v2.Min, v2.Max) * p14
    })
end

local t5 = {
    Burst = function(p15) -- Burst | line: 173
        -- upvalues: ParticleStage (copy), t1 (copy), Max (copy), resolveTuning (copy), layerOverrides (copy), throwPop (copy), ringPop (copy)
        assert(p15 == nil or type(p15) == "table", "a confetti recipe must be a table when given")

        local v19 = resolveTuning(p15 or {})
        local v20 = ParticleStage.QualityBudget()
        local v21 = ParticleStage.new(5.5, 1.25)
        local v22 = table.create(#v19.swatches)

        for v23, v24 in v19.swatches do
            local v25 = ParticleStage.Emitter(t1, (layerOverrides(v24, v19, v20)))

            if v19.size ~= 1 then
                ParticleStage.Scale(v25, v19.size)
            end

            v21:Adopt(v25)
            v22[v23] = v25
        end

        local v26 = 0

        if v19.pops then
            for _, v27 in v19.swatches do
                throwPop(v21, v27, v19, v20)
            end

            if v19.audible and v19.loudness > 0 then
                ringPop(v19.loudness)
            end

            v26 = 0.6
        end

        local v28 = v26 + v19.streamSeconds

        task.delay(v26, ParticleStage.SetEnabled, v22, true)
        task.delay(v28, ParticleStage.SetEnabled, v22, false)
        task.delay(v28 + Max, function() -- line: 201
            -- upvalues: v21 (copy)
            v21:Dispose()
        end)
    end
}

return table.freeze(t5)
