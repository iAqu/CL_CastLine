-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local SoundService = game:GetService("SoundService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local ContentProvider = game:GetService("ContentProvider")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local GameConfig = require(ReplicatedStorage.Config.GameConfig)
local ClientState = require(script.Parent.ClientState)
local t1 = {}
local Music = GameConfig.Music
local t2 = {
    "Lobby",
    "Throw",
    "POV"
}
local t3 = {}
local t4 = {}
local v1

local function fadeTo(p1, p2, p3, p4) -- line: 36
    -- upvalues: TweenService (copy), t4 (copy)
    if t4[p1] then
        t4[p1]:Cancel()
    end

    local tween = TweenService:Create(p1, TweenInfo.new(math.max(p3, 0.01), Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
        Volume = p2
    })

    t4[p1] = tween
    tween.Completed:Once(function(p5) -- line: 40
        -- upvalues: p4 (copy)
        if p5 == Enum.PlaybackState.Completed and p4 then
            p4()
        end
    end)
    tween:Play()
end

function t1.Play(p6, p7) -- line: 47
    -- upvalues: Music (copy), t3 (copy), v1 (ref), fadeTo (copy)
    if p6 == v1 then
        return
    end

    p7 = p7 or Music.Fade

    local v3 = v1 and t3[v1]

    v1 = p6

    if v3 then
        local Sound = v3.Sound

        fadeTo(Sound, 0, p7, function() -- line: 54
            -- upvalues: v3 (copy), Sound (copy)
            if v3.Resume then
                Sound:Pause()
            else
                Sound:Stop()
            end
        end)
    end

    local v4 = p6 and t3[p6]

    if not v4 then
        return
    end

    local Sound = v4.Sound

    if not Sound.IsPlaying then
        if v4.Resume and Sound.IsPaused then
            Sound:Resume()
        else
            Sound.TimePosition = 0
            Sound:Play()
        end
    end

    fadeTo(Sound, v4.Volume, p7)
end

function t1.GetCurrent() -- line: 73
    -- upvalues: v1 (ref)
    return v1
end

function t1.Init() -- line: 77
    -- upvalues: SoundService (copy), RunService (copy), ContentProvider (copy), ReplicatedStorage (copy), ClientState (copy), t1 (copy), Music (copy), t2 (copy), t3 (copy), v1 (ref)
    local v5 = ReplicatedStorage:FindFirstChild(Music.Folder)

    if not v5 then
        warn("[MusicController] ReplicatedStorage." .. Music.Folder .. " missing")

        return
    end

    local SoundGroup = Instance.new("SoundGroup")

    SoundGroup.Name = "Music"
    SoundGroup.Parent = SoundService

    local Folder = Instance.new("Folder")

    Folder.Name = "MusicTracks"
    Folder.Parent = SoundService

    local t5 = {}

    for _, v6 in ipairs(t2) do
        local v7 = Music[v6]
        local v8 = v7 and v5:FindFirstChild(v7.Sound)

        if v8 and v8:IsA("Sound") then
            local clone = v8:Clone()

            clone.Name = v6
            clone.Playing = false
            clone.Looped = true
            clone.Volume = 0
            clone.SoundGroup = SoundGroup
            clone.Parent = Folder
            t3[v6] = {
                Sound = clone,
                Volume = v7.Volume,
                Resume = v7.Resume == true
            }
            table.insert(t5, clone)
        else
            local _warn = warn
            local v9 = "[MusicController] missing music: "

            v7 = v7 and v7.Sound
            _warn(v9 .. tostring(v7))
        end
    end

    task.spawn(function() -- line: 108
        -- upvalues: t5 (copy), ContentProvider (copy)
        local function v10() -- line: 109
            -- upvalues: t5 (copy), ContentProvider (copy)
            ContentProvider:PreloadAsync(t5)
        end

        pcall(v10)
    end)
    t1.Play("Lobby", 1.5)
    RunService.Heartbeat:Connect(function() -- line: 114
        -- upvalues: ClientState (copy), t1 (copy), Music (copy), v1 (ref)
        if ClientState.Busy == nil and v1 ~= "Lobby" then
            t1.Play("Lobby", Music.FadeLobby)
        end
    end)
end

return t1
