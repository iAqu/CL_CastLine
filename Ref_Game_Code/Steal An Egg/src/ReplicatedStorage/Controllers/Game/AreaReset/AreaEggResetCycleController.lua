-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ServerClock = require(game:GetService("ReplicatedStorage").Shared.Util.ServerClock)
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local SoundService = game:GetService("SoundService")
local Workspace = game:GetService("Workspace")
local AreaEggCycle = require(ReplicatedStorage.Shared.Util.AreaEggCycle)
local AreaEggResetCycle = require(ReplicatedStorage.Data.AreaEggResetCycle)
local Audio = require(ReplicatedStorage.Shared.Audio)
local LightingController = require(ReplicatedStorage.Controllers.Game.LightingController)
local MusicDirector = require(ReplicatedStorage.Client.MusicDirector)
local Signal = require(ReplicatedStorage.Packages.Signal)
local WarmSounds = require(ReplicatedStorage.Shared.Utils.Preload).WarmSounds
local DayTransitionSoundId = AreaEggResetCycle.DayTransitionSoundId
local v1
local t1 = {
    PhaseChanged = Signal.new(),
    GetPhase = function() -- GetPhase | line: 32
        -- upvalues: v1 (ref)
        return v1
    end
}

function t1.Start() -- line: 36
    -- upvalues: ServerClock (copy), SoundService (copy), Workspace (copy), AreaEggCycle (copy), AreaEggResetCycle (copy), Audio (copy), LightingController (copy), MusicDirector (copy), WarmSounds (copy), DayTransitionSoundId (copy), v1 (ref), t1 (copy)
    local function resolvePhase(p1) -- line: 41
        -- upvalues: Workspace (copy), AreaEggCycle (copy), AreaEggResetCycle (copy)
        if Workspace:GetAttribute("Event_AdminAbuse") ~= true then
            if AreaEggCycle.IsNightPhase(p1) then
                return "Night"
            end

            if AreaEggCycle.IsWithinNightTransition(p1, AreaEggResetCycle.NightLightingTransitionSeconds, AreaEggResetCycle.NightLightingStartDelaySeconds) then
                return "NightTransition"
            end
        end

        return "Day"
    end

    local function setPhase(p2, p3, p4) -- line: 60
        -- upvalues: SoundService (copy), AreaEggCycle (copy), AreaEggResetCycle (copy), Audio (copy), LightingController (copy), MusicDirector (copy), DayTransitionSoundId (copy), v1 (ref), t1 (copy)
        if v1 == p2 then
            return
        end

        local v2 = v1

        v1 = p2

        if p2 == "NightTransition" then
            local v4 = math.max(AreaEggCycle.NightStartTime(p4) + AreaEggResetCycle.NightLightingStartDelaySeconds - p4, 0)

            LightingController.SetLayer("AreaEggResetNight", AreaEggResetCycle.NightLighting, AreaEggResetCycle.LightingModifierPriority, v4)
            MusicDirector.SetResetNight(false)
            t1.PhaseChanged:Fire(p2, v4)
        elseif p2 == "Night" then
            local v6 = math.max(AreaEggCycle.NightStartTime(p4) + AreaEggResetCycle.NightLightingStartDelaySeconds - p4, 0)

            if v2 ~= "NightTransition" then
                LightingController.SetLayer("AreaEggResetNight", AreaEggResetCycle.NightLighting, AreaEggResetCycle.LightingModifierPriority, v6)
            end

            MusicDirector.SetResetNight(true, true)
            t1.PhaseChanged:Fire(p2, v6)
        else
            local v7 = if p3 or v2 == nil then 0 else AreaEggResetCycle.DayLightingTransitionSeconds

            LightingController.ClearLayer("AreaEggResetNight", v7)
            MusicDirector.SetResetNight(false)

            if not p3 and DayTransitionSoundId ~= nil then
                Audio.Play(DayTransitionSoundId, SoundService)
            end

            t1.PhaseChanged:Fire(p2, v7)
        end
    end

    local function runCycle() -- line: 109
        -- upvalues: setPhase (copy), ServerClock (copy), Workspace (copy), AreaEggCycle (copy), AreaEggResetCycle (copy)
        local v8 = true

        while true do
            local v9 = ServerClock.Now()
            local v10 = if Workspace:GetAttribute("Event_AdminAbuse") == true then "Day"
                elseif AreaEggCycle.IsNightPhase(v9) then "Night"
                elseif AreaEggCycle.IsWithinNightTransition(v9, AreaEggResetCycle.NightLightingTransitionSeconds, AreaEggResetCycle.NightLightingStartDelaySeconds) then "NightTransition"
                else "Day"

            setPhase(v10, v8, v9)

            local v11 = if v10 == "Night" then AreaEggCycle.NextResetTime(v9) elseif v10 == "NightTransition" then AreaEggCycle.NightStartTime(v9) else AreaEggCycle.NightTransitionStartTime(v9, AreaEggResetCycle.NightLightingTransitionSeconds, AreaEggResetCycle.NightLightingStartDelaySeconds)
            local wait = task.wait
            local v12 = v11 - ServerClock.Now()
            local SchedulePollSeconds = AreaEggCycle.SchedulePollSeconds

            v8 = false
            wait((math.clamp(v12, 0.05, SchedulePollSeconds)))
        end
    end

    if DayTransitionSoundId ~= nil then
        task.spawn(WarmSounds, DayTransitionSoundId)
    end

    Workspace:GetAttributeChangedSignal("Event_AdminAbuse"):Connect(function() -- line: 148
        -- upvalues: setPhase (copy), ServerClock (copy), Workspace (copy), AreaEggCycle (copy), AreaEggResetCycle (copy)
        local v13 = ServerClock.Now()

        setPhase(if Workspace:GetAttribute("Event_AdminAbuse") == true then "Day"
            elseif AreaEggCycle.IsNightPhase(v13) then "Night"
            elseif AreaEggCycle.IsWithinNightTransition(v13, AreaEggResetCycle.NightLightingTransitionSeconds, AreaEggResetCycle.NightLightingStartDelaySeconds) then "NightTransition"
            else "Day", false, v13)
    end)
    runCycle()
end

return t1
