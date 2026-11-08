-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Audio = require(ReplicatedStorage.Shared.Audio)
local ParticleStage = require(script.Parent.ParticleStage)
local Spread = require(ReplicatedStorage.Shared.Utils.Spread)

local function fade() -- line: 14
    return NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0, 0),
        NumberSequenceKeypoint.new(0.8, 0, 0),
        NumberSequenceKeypoint.new(1, 1, 0)
    })
end

local t1 = {
    Drag = -3.5,
    Enabled = false,
    LightInfluence = 1,
    LockedToPart = true,
    Rate = 70,
    ZOffset = 1,
    EmissionDirection = Enum.NormalId.Top,
    Lifetime = NumberRange.new(1, 2),
    Orientation = Enum.ParticleOrientation.VelocityParallel,
    RotSpeed = NumberRange.new(-360, 360),
    Rotation = NumberRange.new(-45, 45),
    ShapeStyle = Enum.ParticleEmitterShapeStyle.Surface,
    Size = NumberSequence.new(0.25),
    Speed = NumberRange.new(-7, -3),
    SpreadAngle = Vector2.new(0, 15),
    Squash = NumberSequence.new(0),
    Transparency = fade()
}
local Max = t1.Lifetime.Max
local v1 = Random.new()
local t2 = {}

local function orDefault(p1, p2) -- line: 82
    if p1 == nil then
        return p2
    end

    return p1
end

local function resolveTuning(p3) -- line: 86
    -- upvalues: ParticleStage (copy), t1 (copy)
    local v2 = p3.Scale or {}
    local Rate = t1.Rate
    local Rate2 = v2.Rate

    if Rate2 == nil then
        Rate2 = 1
    end

    local v3 = Rate * Rate2 * ParticleStage.QualityBudget()
    local Seconds = p3.Seconds

    if Seconds == nil then
        Seconds = 2.5
    end

    local t3 = {}

    t3.seconds = Seconds
    t3.dropsPerSheet = v3 / #p3.Sheets

    local Speed = v2.Speed

    t3.speed = if Speed == nil then 1 else Speed

    local Size = v2.Size

    t3.size = if Size == nil then 1 else Size

    local Volume = v2.Volume

    t3.loudness = if Volume == nil then 1 else Volume

    return t3
end

local function sheetOverrides(p4, p5) -- line: 98
    -- upvalues: ParticleStage (copy), t1 (copy), v1 (copy)
    local Speed = t1.Speed
    local t4 = {
        Rate = p5.dropsPerSheet,
        Speed = NumberRange.new(Speed.Min * p5.speed, Speed.Max * p5.speed),
        Texture = p4.Texture,
        ZOffset = t1.ZOffset + v1:NextNumber(-0.06, 0.06)
    }

    if p4.Glow ~= nil then
        t4.LightEmission = p4.Glow
    end

    if p4.SizeMultiplier ~= nil then
        t4.Size = ParticleStage.ScaleSequence(t1.Size, p4.SizeMultiplier)
    end

    return t4
end

local function buildSheet(p6, p7) -- line: 115
    -- upvalues: ParticleStage (copy), t1 (copy), sheetOverrides (copy)
    local v4 = ParticleStage.Emitter(t1, (sheetOverrides(p6, p7)))

    if p7.size ~= 1 then
        ParticleStage.Scale(v4, p7.size)
    end

    return v4
end

local function playAmbience(p8, p9) -- line: 123
    -- upvalues: Audio (copy), Spread (copy)
    Audio.Play(p8.Sounds, script, {
        PlaybackSpeed = p8.PlaybackSpeed,
        Volume = Spread.Scale(p8.Volume, p9)
    })
end

function t2.Fall(p10) -- line: 130
    -- upvalues: Audio (copy), ParticleStage (copy), Spread (copy), t1 (copy), Max (copy), resolveTuning (copy), sheetOverrides (copy)
    assert(type(p10) == "table" and type(p10.Sheets) == "table", "a rain recipe needs a Sheets list")
    assert(#p10.Sheets > 0, "a rain recipe needs at least one sheet")

    local v7 = resolveTuning(p10)
    local v8 = ParticleStage.new(9, 1.5)
    local v9 = table.create(#p10.Sheets)

    for v10, v11 in p10.Sheets do
        local v12 = ParticleStage.Emitter(t1, (sheetOverrides(v11, v7)))

        if v7.size ~= 1 then
            ParticleStage.Scale(v12, v7.size)
        end

        v8:Adopt(v12)
        v9[v10] = v12
    end

    local Ambience = p10.Ambience

    if Ambience ~= nil and v7.loudness > 0 then
        local loudness = v7.loudness

        Audio.Play(Ambience.Sounds, script, {
            PlaybackSpeed = Ambience.PlaybackSpeed,
            Volume = Spread.Scale(Ambience.Volume, loudness)
        })
    end

    ParticleStage.SetEnabled(v9, true)
    task.delay(v7.seconds, ParticleStage.SetEnabled, v9, false)
    task.delay(v7.seconds + Max, function() -- line: 149
        -- upvalues: v8 (copy)
        v8:Dispose()
    end)
end

return table.freeze(t2)
