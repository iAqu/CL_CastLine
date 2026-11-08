-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local SoundService = game:GetService("SoundService")
local Audio = require(ReplicatedStorage.Shared.Audio)
local ManorInterior = require(ReplicatedStorage.Shared.Util.ManorInterior)

require(ReplicatedStorage.Packages.Trove)

local Markers, Sounds = ManorInterior.Markers, ManorInterior.Sounds
local Hallway = Enum.ReverbType.Hallway
local t1 = {
    Sounds.Creak,
    Sounds.FloorCreak
}
local v1 = NumberRange.new(5, 14)
local t2 = {
    0.25, 0.55
}
local t3 = {
    0.85, 1.1
}
local t4 = {
    0.05, 0.6
}
local v2 = Random.new()
local t5 = {}

local function creakPoint() -- line: 36
    -- upvalues: ManorInterior (copy), Markers (copy), t4 (copy), v2 (copy)
    local v3 = ManorInterior.Marker(Markers.Bounds)

    if v3 == nil then
        return nil
    end

    local v4 = v3.Size / 2
    local v8 = Vector3.new(v2:NextNumber(-v4.X, v4.X), v2:NextNumber(t4[1], t4[2]) * v3.Size.Y - v4.Y, v2:NextNumber(-v4.Z, v4.Z))

    return v3.CFrame:PointToWorldSpace(v8)
end

local function creak() -- line: 50
    -- upvalues: Audio (copy), t1 (copy), t2 (copy), t3 (copy), v2 (copy), creakPoint (copy)
    local v9 = creakPoint()

    if v9 ~= nil then
        Audio.Play(t1[v2:NextInteger(1, #t1)], v9, {
            MaxDistance = 160,
            Volume = t2,
            PlaybackSpeed = t3
        })
    end
end

local function startLoop(p1) -- line: 62
    -- upvalues: SoundService (copy), Audio (copy), Sounds (copy)
    local v10 = Audio.Play(Sounds.Ambience, SoundService, {
        Looped = true,
        Volume = 0
    })

    if v10 ~= nil then
        Audio.FadeTo(v10, {
            Volume = 0.45,
            Seconds = 2.5
        })
        p1:Add(function() -- line: 69
            -- upvalues: v10 (copy), Audio (copy)
            Audio.FadeTo(v10, {
                Volume = 0,
                Seconds = 0.8
            })
            task.delay(0.8500000000000001, function() -- line: 71
                -- upvalues: v10 (copy)
                v10:Destroy()
            end)
        end)
    end
end

local function startReverb(p2) -- line: 77
    -- upvalues: SoundService (copy), Hallway (copy)
    local AmbientReverb = SoundService.AmbientReverb

    SoundService.AmbientReverb = Hallway
    p2:Add(function() -- line: 80
        -- upvalues: AmbientReverb (copy), SoundService (copy), Hallway (copy)
        if SoundService.AmbientReverb == Hallway then
            SoundService.AmbientReverb = AmbientReverb
        end
    end)
end

local function startCreaks(p3) -- line: 87
    -- upvalues: v1 (copy), v2 (copy), creak (copy)
    p3:Add(task.spawn(function() -- line: 88
        -- upvalues: v1 (copy), v2 (copy), creak (copy)
        while true do
            task.wait(v2:NextNumber(v1.Min, v1.Max))
            creak()
        end
    end))
end

function t5.Start(p4) -- line: 100
    -- upvalues: SoundService (copy), Hallway (copy), v1 (copy), v2 (copy), creak (copy), startLoop (copy)
    local v11 = p4:Extend()
    local AmbientReverb = SoundService.AmbientReverb

    SoundService.AmbientReverb = Hallway
    v11:Add(function() -- line: 80
        -- upvalues: AmbientReverb (copy), SoundService (copy), Hallway (copy)
        if SoundService.AmbientReverb == Hallway then
            SoundService.AmbientReverb = AmbientReverb
        end
    end)
    startLoop(v11)
    v11:Add(task.spawn(function() -- line: 88
        -- upvalues: v1 (copy), v2 (copy), creak (copy)
        while true do
            task.wait(v2:NextNumber(v1.Min, v1.Max))
            creak()
        end
    end))
end

return table.freeze(t5)
