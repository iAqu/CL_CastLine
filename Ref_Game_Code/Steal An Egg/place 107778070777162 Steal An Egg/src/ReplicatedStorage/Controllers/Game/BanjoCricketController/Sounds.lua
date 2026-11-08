-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local SoundService = game:GetService("SoundService")
local TweenService = game:GetService("TweenService")
local Audio = require(ReplicatedStorage.Shared.Audio)
local BanjoCricket = require(ReplicatedStorage.Data.BanjoCricket)
local Mushrooms = require(script.Parent.Mushrooms)
local v1
local n1 = 0
local t1 = {}

local function play(p1, p2, p3) -- line: 32
    -- upvalues: Audio (copy), BanjoCricket (copy), Mushrooms (copy)
    local v2 = BanjoCricket.Mushrooms[p1]
    local v3 = Mushrooms.Anchor(p1)

    if v2 == nil or v3 == nil then
        return nil
    end

    return Audio.Play(v2.Sound, v3, {
        MaxDistance = 90,
        PlaybackSpeed = v2.Speed * p2,
        Volume = p3
    })
end

function t1.Note(p4) -- line: 45
    -- upvalues: BanjoCricket (copy), play (copy)
    play(p4, 1, BanjoCricket.Volume.Note)
end

function t1.Muted(p5) -- line: 50
    -- upvalues: TweenService (copy), BanjoCricket (copy), play (copy)
    local v4 = play(p5, 1, BanjoCricket.Volume.Muted)

    if v4 ~= nil then
        task.delay(0.1, function() -- line: 55
            -- upvalues: v4 (copy), TweenService (copy)
            local tween = TweenService:Create(v4, TweenInfo.new(0.06), {
                Volume = 0
            })

            tween.Completed:Once(function() -- line: 57
                -- upvalues: v4 (copy)
                v4:Stop()
            end)
            tween:Play()
        end)
    end
end

function t1.Soft(p6, p7) -- line: 64
    -- upvalues: BanjoCricket (copy), play (copy)
    play(p6, 2 ^ (p7 or 0), BanjoCricket.Volume.Soft)
end

function t1.Fail(p8) -- line: 68
    -- upvalues: Audio (copy), BanjoCricket (copy), Mushrooms (copy)
    local v5 = Mushrooms.Anchor(p8)

    if v5 ~= nil then
        Audio.Play(BanjoCricket.Sounds.Fail, v5, {
            MaxDistance = 90,
            Volume = BanjoCricket.Volume.Fail
        })
    end
end

function t1.Run() -- line: 79
    -- upvalues: BanjoCricket (copy), play (copy)
    for v6 in BanjoCricket.Mushrooms do
        task.delay((v6 - 1) * 0.07, play, v6, 1, BanjoCricket.Volume.Soft)
    end
end

function t1.Strum() -- line: 86
    -- upvalues: Audio (copy), BanjoCricket (copy), Mushrooms (copy)
    local t2 = {
        MaxDistance = 90,
        Volume = BanjoCricket.Volume.Strum
    }

    for v7, v8 in BanjoCricket.Mushrooms do
        local v9 = Mushrooms.Anchor(v7)

        if v9 ~= nil then
            local v10 = (v7 - 1) * 0.045

            task.delay(v10, Audio.Play, v8.Sound, v9, t2)
        end
    end
end

function t1.Creak(p9, p10) -- line: 98
    -- upvalues: Audio (copy), BanjoCricket (copy)
    Audio.Play(BanjoCricket.Sounds.Creak, p9, {
        MaxDistance = 90,
        PlaybackSpeed = 1.1 - p10 * 0.3,
        Volume = BanjoCricket.Volume.Creak * (p10 * 0.5 + 0.5)
    })
end

function t1.Duck(p11) -- line: 108
    -- upvalues: SoundService (copy), TweenService (copy), v1 (ref), n1 (ref)
    local Music = SoundService:FindFirstChild("Music")
    local v11, v12

    if Music ~= nil then
        if Music:IsA("SoundGroup") then
            v11 = v1

            if v11 == nil or v11.Parent == nil then
                v11 = Instance.new("EqualizerSoundEffect")
                v11.Name = "BanjoCricketDuck"
                v11.HighGain = 0
                v11.MidGain = 0
                v11.LowGain = 0
                v11.Parent = Music
                v1 = v11
            end

            v12 = false
        else
            v12 = true
        end
    else
        v12 = true
    end

    if v12 then
        return
    end

    n1 += 1

    local v13 = n1

    TweenService:Create(v11, TweenInfo.new(0.25), {
        HighGain = -10,
        MidGain = -10,
        LowGain = -10
    }):Play()
    task.delay(p11, function() -- line: 131
        -- upvalues: v11 (ref), v13 (copy), TweenService (copy), n1 (ref)
        if n1 == v13 and v11.Parent ~= nil then
            TweenService:Create(v11, TweenInfo.new(0.6), {
                HighGain = 0,
                MidGain = 0,
                LowGain = 0
            }):Play()
        end
    end)
end

return table.freeze(t1)
