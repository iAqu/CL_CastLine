-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local SoundService = game:GetService("SoundService")
local Workspace = game:GetService("Workspace")
local Audio = require(ReplicatedStorage.Shared.Audio)
local GuardAreaGeometry = require(ReplicatedStorage.Shared.Util.GuardAreaGeometry)
local HiddenUIHandler = require(ReplicatedStorage.Client.HiddenUIHandler)
local Player = require(ReplicatedStorage.Shared.Player)
local Preferences = require(ReplicatedStorage.Shared.Preferences)
local Remotes = require(ReplicatedStorage.Shared.Remotes)
local AreaEggResetCycle = require(ReplicatedStorage.Data.AreaEggResetCycle)
local Shuffle = require(ReplicatedStorage.Shared.Utils.Numeric).Shuffle
local TreadmillVideoGate = require(ReplicatedStorage.Client.TreadmillVideoGate)
local t1 = {
    1836009208, 1846088038, 9045766074, 1842150151
}
local t2 = {}
local SeparationLine = Workspace:WaitForChild("World"):WaitForChild("Areas"):WaitForChild("SeparationLine")
local LocalPlayer = Players.LocalPlayer
local v1 = table.clone(t1)

Shuffle(v1, Random.new())

local n1 = 1
local v2 = Audio.MusicTrack({
    Name = "OutdoorMusic",
    Looped = false,
    Source = v1[1]
})
local v3 = Audio.MusicTrack({
    Name = "ArenaMusic",
    Source = 5026653246,
    Looped = true
})
local v4 = Audio.MusicTrack({
    Name = "ChaseMusic",
    Source = 9044545570,
    Looped = true
})
local v5 = Audio.MusicTrack({
    Name = "SafeZoneMusic",
    Source = 9044545570,
    Looped = true
})
local v6 = if AreaEggResetCycle.NightMusic then Audio.MusicTrack({
    Name = "ResetNightMusic",
    Looped = true,
    Source = AreaEggResetCycle.NightMusic.Id
}) else nil
local v7 = Audio.MusicTrack({
    Name = "DrScrambleMusic",
    Source = 116561685928578,
    Looped = true
})
local t3 = {
    v2,
    v3,
    v4,
    v5,
    v7
}

if v6 then
    table.insert(t3, v6)
end

local t4 = {}
local v8 = false
local v9 = false
local v10 = false
local v11 = false
local v12 = false
local v13 = false
local v14 = false
local v15 = false
local v16 = false
local v17 = false
local v18 = Workspace:GetAttribute("AdminAbuseOnTop") == true
local v19 = Preferences.IsOn("Music")
local v20 = HiddenUIHandler.IsHidden()
local v21 = ""
local n2 = 0
local BindableEvent = Instance.new("BindableEvent")
local n3 = 0

local function fade(p1, p2, p3, p4) -- line: 86
    -- upvalues: Audio (copy), t4 (copy)
    local v22 = t4[p1]

    if v22 then
        v22:Cancel()
    end

    if (p2 > 0 or p4) and not p1.IsPlaying then
        p1:Play()
    end

    local v23 = Audio.FadeTo(p1, {
        Volume = p2,
        Seconds = p3,
        Style = Enum.EasingStyle.Quad,
        Direction = Enum.EasingDirection.InOut
    })

    t4[p1] = v23
    v23.Completed:Once(function(p5) -- line: 103
        -- upvalues: p1 (copy), p2 (copy), p4 (copy), v23 (copy), t4 (copy)
        if t4[p1] == v23 then
            t4[p1] = nil

            if p5 == Enum.PlaybackState.Completed and p2 <= 0 and not p4 then
                p1:Pause()
            end
        end
    end)
end

local function treadmillFeedActive() -- line: 115
    -- upvalues: TreadmillVideoGate (copy), v14 (ref)
    return v14 and not TreadmillVideoGate.IsVideoPlayerDisabled()
end

local function mode() -- line: 119
    -- upvalues: TreadmillVideoGate (copy), v8 (ref), v9 (ref), v10 (ref), v11 (ref), v12 (ref), v14 (ref), v15 (ref), v16 (ref), v17 (ref), v18 (ref), v19 (ref), v20 (ref), n2 (ref)
    if not v19 or n2 > 0 or v18 or v17 then
        return "Silent"
    end

    if v16 and not v15 then
        local v24 = v14 and not TreadmillVideoGate.IsVideoPlayerDisabled()

        if not v24 and not v20 then
            return "Scramble"
        end
    end

    if v12 then
        return "Night"
    end

    if v14 and not TreadmillVideoGate.IsVideoPlayerDisabled() then
        return "Treadmill"
    end

    if v15 or v9 then
        return "Silent"
    end

    if v10 then
        if v8 then
            return "Chase"
        end

        return "Arena"
    end

    if v20 then
        return "Silent"
    end

    if v11 then
        return "SafeZone"
    end

    return "Outdoor"
end

local function refresh(p6) -- line: 148
    -- upvalues: SoundService (copy), AreaEggResetCycle (copy), TreadmillVideoGate (copy), v2 (copy), v3 (copy), v4 (copy), v5 (copy), v7 (copy), v6 (copy), v13 (ref), v14 (ref), v18 (ref), v21 (ref), fade (copy), mode (copy)
    local v25 = mode()
    local v26 = v21

    v21 = v25

    local v27 = v25 == "Chase" or v26 == "Chase"
    local v28 = if p6 ~= nil then p6
        elseif v27 then 0.1
        elseif v25 == "Arena" or v26 == "Arena" then 0.4
        else 0.8

    fade(v2, v25 == "Outdoor" and 0.22 or 0, v28, true)
    fade(v3, v25 == "Arena" and 1.5 or 0, v28)
    fade(v4, v25 == "Chase" and 0.4 or 0, v28)
    fade(v5, v25 == "SafeZone" and 0.5 or 0, v28)
    fade(v7, v25 == "Scramble" and 0.5 or 0, v28)

    if v6 then
        fade(v6, if v25 == "Night" and v13 then AreaEggResetCycle.NightMusic.Volume else 0, p6 or AreaEggResetCycle.MusicTransitionSeconds)
    end

    local AdminAbuseMusic = SoundService.Music:FindFirstChild("AdminAbuseMusic")

    if AdminAbuseMusic and AdminAbuseMusic:IsA("SoundGroup") then
        AdminAbuseMusic.Volume = (v14 and not TreadmillVideoGate.IsVideoPlayerDisabled() or v18) and 0 or 1
    end

    local AdminAbusePriorityMusic = SoundService.Music:FindFirstChild("AdminAbusePriorityMusic")

    if not (AdminAbusePriorityMusic and AdminAbusePriorityMusic:IsA("SoundGroup")) then
        return
    end

    AdminAbusePriorityMusic.Volume = v14 and not TreadmillVideoGate.IsVideoPlayerDisabled() and 0 or 1
end

local function updateArena() -- line: 183
    -- upvalues: GuardAreaGeometry (copy), Player (copy), SeparationLine (copy), LocalPlayer (copy), v10 (ref), refresh (copy)
    local v30 = Player.FindRootPart(LocalPlayer)
    local v31 = v30 ~= nil and GuardAreaGeometry.IsPastLine(SeparationLine, v30.Position)

    if v10 ~= v31 then
        v10 = v31
        refresh()
    end
end

function t2.EnterSaveZone() -- line: 192
    -- upvalues: v11 (ref), refresh (copy)
    if not v11 then
        v11 = true
        refresh()
    end
end

function t2.ExitSaveZone() -- line: 199
    -- upvalues: v11 (ref), refresh (copy)
    if v11 then
        v11 = false
        refresh()
    end
end

function t2.HasCustomTreadmill() -- line: 206
    -- upvalues: v14 (ref)
    return v14
end

function t2.SetCarryingAreaEgg(p7) -- line: 210
    -- upvalues: v8 (ref), refresh (copy)
    if v8 ~= p7 then
        v8 = p7
        refresh()
    end
end

function t2.SetGuardedGameplay(p8) -- line: 217
    -- upvalues: v9 (ref), refresh (copy)
    if v9 ~= p8 then
        v9 = p8
        refresh()
    end
end

function t2.SetScrambleActive(p9) -- line: 224
    -- upvalues: v16 (ref), refresh (copy)
    if v16 ~= p9 then
        v16 = p9
        refresh()
    end
end

function t2.SetEventMusic(p10) -- line: 231
    -- upvalues: v15 (ref), refresh (copy)
    if v15 ~= p10 then
        v15 = p10
        refresh()
    end
end

function t2.IsSuppressed() -- line: 238
    -- upvalues: n2 (ref)
    return n2 > 0
end

function t2.Suppress() -- line: 242
    -- upvalues: n2 (ref), BindableEvent (copy), refresh (copy)
    n2 += 1

    if n2 == 1 then
        refresh(0.5)
        BindableEvent:Fire(true)
    end

    local v32 = false

    return function() -- line: 249
        -- upvalues: v32 (ref), n2 (ref), BindableEvent (copy), refresh (copy)
        if v32 then
            return
        end

        v32 = true
        n2 -= 1

        if n2 == 0 then
            refresh()
            BindableEvent:Fire(false)
        end
    end
end

t2.SuppressedChanged = BindableEvent.Event

function t2.SetHalloweenDimension(p11) -- line: 264
    -- upvalues: v17 (ref), refresh (copy)
    if v17 ~= p11 then
        v17 = p11
        refresh()
    end
end

function t2.SetResetNight(p12, p13) -- line: 271
    -- upvalues: v12 (ref), v13 (ref), refresh (copy)
    local v33 = p12 and p13 == true

    if v12 == p12 and v13 == v33 then
        return
    end

    v12 = p12
    v13 = v33
    refresh()
end

v2.Ended:Connect(function() -- line: 280
    -- upvalues: Shuffle (copy), v1 (copy), n1 (ref), v2 (copy)
    n1 += 1

    if n1 > #v1 then
        Shuffle(v1, Random.new())
        n1 = 1
    end

    v2.SoundId = ("rbxassetid://%*"):format(v1[n1])
    v2:Play()
end)
Preferences.Observe("Music", function(p14) -- line: 290
    -- upvalues: v19 (ref), refresh (copy)
    if p14 ~= v19 then
        v19 = p14
        refresh()
    end
end)
HiddenUIHandler.Changed:Connect(function(p15) -- line: 298
    -- upvalues: v20 (ref), refresh (copy)
    v20 = p15
    refresh()
end)
Remotes.Treadmill.AssignedBeltShifted.OnClientEvent:Connect(function(p16) -- line: 303
    -- upvalues: v14 (ref), refresh (copy)
    v14 = p16 ~= nil
    refresh()
end)
Workspace:GetAttributeChangedSignal("AdminAbuseOnTop"):Connect(function() -- line: 308
    -- upvalues: Workspace (copy), v18 (ref), refresh (copy)
    v18 = Workspace:GetAttribute("AdminAbuseOnTop") == true
    refresh()
end)
TreadmillVideoGate.Changed:Connect(function() -- line: 313
    -- upvalues: v14 (ref), refresh (copy)
    if v14 then
        refresh()
    end
end)
RunService.Heartbeat:Connect(function(p17) -- line: 319
    -- upvalues: GuardAreaGeometry (copy), Player (copy), SeparationLine (copy), LocalPlayer (copy), v10 (ref), n3 (ref), refresh (copy)
    n3 += p17

    if not (n3 >= 0.1) then
        return
    end

    n3 %= 0.1

    local v35 = Player.FindRootPart(LocalPlayer)
    local v36 = v35 ~= nil and GuardAreaGeometry.IsPastLine(SeparationLine, v35.Position)

    if v10 ~= v36 then
        v10 = v36
        refresh()
    end
end)
v2:Play()

local v37 = Player.FindRootPart(LocalPlayer)
local v38 = v37 ~= nil and GuardAreaGeometry.IsPastLine(SeparationLine, v37.Position)

if v10 ~= v38 then
    v10 = v38
    refresh()
end

refresh()

return table.freeze(t2)
