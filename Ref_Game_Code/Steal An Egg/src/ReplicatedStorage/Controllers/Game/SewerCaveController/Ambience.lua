-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local SoundService = game:GetService("SoundService")
local Audio = require(ReplicatedStorage.Shared.Audio)
local SewerCave = require(ReplicatedStorage.Shared.Util.SewerCave)

require(ReplicatedStorage.Packages.Trove)

local Markers = SewerCave.Markers
local StoneRoom = Enum.ReverbType.StoneRoom
local t1 = {
    74697236349743, 104487140689701, 119941771367075
}
local v1 = NumberRange.new(3, 9)
local t2 = {
    0.25, 0.5
}
local t3 = {
    0.85, 1.15
}
local t4 = {
    0.45, 0.9
}
local v2 = Random.new()
local t5 = {}

local function dripEcho() -- line: 37
    local ReverbSoundEffect = Instance.new("ReverbSoundEffect")

    ReverbSoundEffect.DecayTime = 1.8
    ReverbSoundEffect.Density = 0.9
    ReverbSoundEffect.Diffusion = 0.85
    ReverbSoundEffect.DryLevel = 0
    ReverbSoundEffect.WetLevel = -8

    return { ReverbSoundEffect }
end

local function dripPoint() -- line: 47
    -- upvalues: SewerCave (copy), Markers (copy), t4 (copy), v2 (copy)
    local v3 = SewerCave.Marker(Markers.Bounds)

    if v3 == nil then
        return nil
    end

    local v4 = v3.Size / 2
    local v8 = Vector3.new(v2:NextNumber(-v4.X, v4.X), v2:NextNumber(t4[1], t4[2]) * v3.Size.Y - v4.Y, v2:NextNumber(-v4.Z, v4.Z))

    return v3.CFrame:PointToWorldSpace(v8)
end

local function drip() -- line: 61
    -- upvalues: Audio (copy), t1 (copy), t2 (copy), t3 (copy), v2 (copy), dripPoint (copy)
    local v9 = dripPoint()

    if v9 == nil then
        return
    end

    local Play = Audio.Play
    local v10 = t1[v2:NextInteger(1, #t1)]
    local t6 = {
        MaxDistance = 140,
        Volume = t2,
        PlaybackSpeed = t3
    }
    local ReverbSoundEffect = Instance.new("ReverbSoundEffect")

    ReverbSoundEffect.DecayTime = 1.8
    ReverbSoundEffect.Density = 0.9
    ReverbSoundEffect.Diffusion = 0.85
    ReverbSoundEffect.DryLevel = 0
    ReverbSoundEffect.WetLevel = -8
    t6.Effects = { ReverbSoundEffect }
    Play(v10, v9, t6)
end

local function startLoop(p1) -- line: 74
    -- upvalues: SoundService (copy), Audio (copy), SewerCave (copy)
    local v11 = SewerCave.Cave()
    local v12 = v11 and v11:FindFirstChild(SewerCave.AmbienceName)
    local v13, v14

    if v12 ~= nil then
        if v12:IsA("Sound") then
            v13 = if v12.Volume > 0 then v12.Volume else 0.5
            v14 = false
        else
            v14 = true
        end
    else
        v14 = true
    end

    if v14 then
        return
    end

    local v15 = Audio.Play(v12, SoundService, {
        Looped = true,
        Volume = 0
    })

    if v15 ~= nil then
        Audio.FadeTo(v15, {
            Seconds = 2.5,
            Volume = v13
        })
        p1:Add(function() -- line: 87
            -- upvalues: v15 (copy), Audio (copy)
            Audio.FadeTo(v15, {
                Volume = 0,
                Seconds = 0.8
            })
            task.delay(0.8500000000000001, function() -- line: 89
                -- upvalues: v15 (copy)
                v15:Destroy()
            end)
        end)
    end
end

local function startReverb(p2) -- line: 95
    -- upvalues: SoundService (copy), StoneRoom (copy)
    local AmbientReverb = SoundService.AmbientReverb

    SoundService.AmbientReverb = StoneRoom
    p2:Add(function() -- line: 98
        -- upvalues: AmbientReverb (copy), SoundService (copy), StoneRoom (copy)
        if SoundService.AmbientReverb == StoneRoom then
            SoundService.AmbientReverb = AmbientReverb
        end
    end)
end

local function startDrips(p3) -- line: 105
    -- upvalues: v1 (copy), v2 (copy), drip (copy)
    p3:Add(task.spawn(function() -- line: 106
        -- upvalues: v1 (copy), v2 (copy), drip (copy)
        while true do
            task.wait(v2:NextNumber(v1.Min, v1.Max))
            drip()
        end
    end))
end

function t5.Start(p4) -- line: 118
    -- upvalues: SoundService (copy), StoneRoom (copy), v1 (copy), v2 (copy), drip (copy), startLoop (copy)
    local v16 = p4:Extend()
    local AmbientReverb = SoundService.AmbientReverb

    SoundService.AmbientReverb = StoneRoom
    v16:Add(function() -- line: 98
        -- upvalues: AmbientReverb (copy), SoundService (copy), StoneRoom (copy)
        if SoundService.AmbientReverb == StoneRoom then
            SoundService.AmbientReverb = AmbientReverb
        end
    end)
    startLoop(v16)
    v16:Add(task.spawn(function() -- line: 106
        -- upvalues: v1 (copy), v2 (copy), drip (copy)
        while true do
            task.wait(v2:NextNumber(v1.Min, v1.Max))
            drip()
        end
    end))
end

return table.freeze(t5)
