-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local SoundService = game:GetService("SoundService")
local ContentProvider = game:GetService("ContentProvider")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local SoundsConfig = require(ReplicatedStorage.Config.SoundsConfig)
local t1 = {}
local Folder = Instance.new("Folder")

Folder.Name = "GameSounds"
Folder.Parent = SoundService

local function resolvePitch(p1, p2) -- line: 24
    if p2 then
        return p2
    end

    local Pitch = p1.Pitch

    if type(Pitch) == "table" then
        return Pitch[1] + math.random() * (Pitch[2] - Pitch[1])
    end

    return Pitch or 1
end

local function build(p3, p4) -- line: 33
    -- upvalues: SoundsConfig (copy), Folder (copy)
    local v1 = SoundsConfig.Get(p3)

    if v1 then
        local v2 = p4 or {}
        local Sound = Instance.new("Sound")

        Sound.Name = p3
        Sound.SoundId = "rbxassetid://" .. tostring(v1.Id)
        Sound.Volume = v2.Volume ~= nil and v2.Volume or v1.Volume or 0.5

        local Pitch = v2.Pitch

        if not Pitch then
            local Pitch2 = v1.Pitch

            Pitch = if type(Pitch2) == "table" then Pitch2[1] + math.random() * (Pitch2[2] - Pitch2[1]) else Pitch2 or 1
        end

        Sound.PlaybackSpeed = Pitch
        Sound.Looped = v2.Looped or v1.Looped or false
        Sound.RollOffMaxDistance = v2.MaxDistance or 120
        Sound.RollOffMinDistance = 6

        if v1.Start then
            Sound.TimePosition = v1.Start
        end

        if v2.Start then
            Sound.TimePosition = v2.Start
        end

        Sound.Parent = v2.Parent or Folder

        return Sound
    end

    warn("[Sounds] Unknown sound: " .. tostring(p3))

    return nil
end

function t1.Play(p5, p6) -- line: 55
    -- upvalues: build (copy)
    local v3 = build(p5, p6)

    if not v3 then
        return nil
    end

    if not (p6 and p6.Delay) then
        v3:Play()
    else
        task.delay(p6.Delay, function() -- line: 59
            -- upvalues: v3 (copy)
            if v3.Parent then
                v3:Play()
            end
        end)
    end

    v3.Ended:Once(function() -- line: 65
        -- upvalues: v3 (copy)
        v3:Destroy()
    end)
    task.delay(15, function() -- line: 68
        -- upvalues: v3 (copy)
        if v3.Parent then
            v3:Destroy()
        end
    end)

    return v3
end

function t1.Loop(p7, p8) -- line: 75
    -- upvalues: TweenService (copy), build (copy)
    p8 = p8 or {}
    p8.Looped = true

    local v5 = build(p7, p8)

    if not v5 then
        return nil
    end

    v5:Play()

    local t2 = {
        Sound = v5
    }

    function t2.SetVolume(_, p10, p11) -- line: 82
        -- upvalues: v5 (copy), TweenService (copy)
        if v5.Parent then
            if not (p11 and p11 > 0) then
                v5.Volume = p10
            else
                TweenService:Create(v5, TweenInfo.new(p11), {
                    Volume = p10
                }):Play()
            end
        end
    end

    function t2.SetPitch(_, p13, p14) -- line: 90
        -- upvalues: v5 (copy), TweenService (copy)
        if v5.Parent then
            if not (p14 and p14 > 0) then
                v5.PlaybackSpeed = p13
            else
                TweenService:Create(v5, TweenInfo.new(p14), {
                    PlaybackSpeed = p13
                }):Play()
            end
        end
    end

    function t2.Stop(_, p16) -- line: 98
        -- upvalues: v5 (copy), TweenService (copy)
        if v5.Parent then
            if not (p16 and p16 > 0) then
                v5:Destroy()
            else
                TweenService:Create(v5, TweenInfo.new(p16), {
                    Volume = 0
                }):Play()
                task.delay(p16, function() -- line: 102
                    -- upvalues: v5 (copy)
                    v5:Destroy()
                end)
            end
        end
    end

    return t2
end

function t1.Preload() -- line: 110
    -- upvalues: ContentProvider (copy), SoundsConfig (copy)
    task.spawn(function() -- line: 111
        -- upvalues: ContentProvider (copy), SoundsConfig (copy)
        local t3 = {}

        for _, v6 in pairs(SoundsConfig.Library) do
            local Sound = Instance.new("Sound")

            Sound.SoundId = "rbxassetid://" .. tostring(v6.Id)
            table.insert(t3, Sound)
        end

        local function v7() -- line: 118
            -- upvalues: t3 (copy), ContentProvider (copy)
            ContentProvider:PreloadAsync(t3)
        end

        pcall(v7)

        for _, v8 in ipairs(t3) do
            v8:Destroy()
        end
    end)
end

return t1
