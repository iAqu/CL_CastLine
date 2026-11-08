-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")

require(ReplicatedStorage.Shared.Types.AreaEggs)

local Audio = require(ReplicatedStorage.Shared.Audio)
local EggState = require(ReplicatedStorage.Client.EggState)
local ScreenEffects = require(script.ScreenEffects)
local HiddenUIHandler = require(ReplicatedStorage.Client.HiddenUIHandler)
local MusicDirector = require(ReplicatedStorage.Client.MusicDirector)
local Player = require(ReplicatedStorage.Shared.Player)
local Trove = require(ReplicatedStorage.Packages.Trove)
local LocalPlayer = Players.LocalPlayer
local World = Workspace.World

assert(World:IsA("Folder"), "Workspace.World must be a Folder")

local Areas = World.Areas

assert(Areas:IsA("Folder"), "Workspace.World.Areas must be a Folder")

local GuardAreas = Areas.GuardAreas

assert(GuardAreas:IsA("Folder"), "Workspace.World.Areas.GuardAreas must be a Folder")

local t1
local t2 = {}

local function stopGuardedMusic(p1) -- line: 55
    -- upvalues: MusicDirector (copy)
    if p1.GuardedMusicActive then
        p1.GuardedMusicActive = false
        MusicDirector.SetGuardedGameplay(false)
    end
end

local function releaseUiHide(p2) -- line: 64
    local ReleaseUiHide = p2.ReleaseUiHide

    if ReleaseUiHide ~= nil then
        p2.ReleaseUiHide = nil
        ReleaseUiHide()
    end
end

local function cancelGuardStateWait(p3) -- line: 74
    local GuardStateConnection = p3.GuardStateConnection

    if GuardStateConnection ~= nil then
        p3.GuardStateConnection = nil
        GuardStateConnection:Disconnect()
    end
end

local function acquireUiHide() -- line: 84
    -- upvalues: HiddenUIHandler (copy)
    return HiddenUIHandler.Acquire()
end

local function stopGuardedMusicForGeneration(p4, p5) -- line: 86
    -- upvalues: MusicDirector (copy)
    if p4.GuardedMusicGeneration == p5 and p4.GuardedMusicActive then
        p4.GuardedMusicActive = false
        MusicDirector.SetGuardedGameplay(false)
    end
end

local function stopRunBackState(p6) -- line: 94
    -- upvalues: MusicDirector (copy)
    local GuardStateConnection = p6.GuardStateConnection

    if GuardStateConnection ~= nil then
        p6.GuardStateConnection = nil
        GuardStateConnection:Disconnect()
    end

    if p6.Active then
        p6.Active = false
        p6.Effects:Stop()

        if p6.GuardedMusicActive then
            p6.GuardedMusicActive = false
            MusicDirector.SetGuardedGameplay(false)
        end

        MusicDirector.SetCarryingAreaEgg(false)
    end
end

local function startCarryState(p7) -- line: 106
    -- upvalues: HiddenUIHandler (copy), Player (copy), LocalPlayer (copy)
    if p7.ReleaseUiHide ~= nil then
        return
    end

    local v1 = Player.FindHumanoid(LocalPlayer)

    if v1 ~= nil then
        v1:UnequipTools()
    end

    p7.ReleaseUiHide = HiddenUIHandler.Acquire()
end

local function stopCarryState(p8) -- line: 119
    -- upvalues: MusicDirector (copy)
    p8.CarryGeneration += 1

    local GuardStateConnection = p8.GuardStateConnection

    if GuardStateConnection ~= nil then
        p8.GuardStateConnection = nil
        GuardStateConnection:Disconnect()
    end

    if p8.Active then
        p8.Active = false
        p8.Effects:Stop()

        if p8.GuardedMusicActive then
            p8.GuardedMusicActive = false
            MusicDirector.SetGuardedGameplay(false)
        end

        MusicDirector.SetCarryingAreaEgg(false)
    end

    local ReleaseUiHide = p8.ReleaseUiHide

    if ReleaseUiHide ~= nil then
        p8.ReleaseUiHide = nil
        ReleaseUiHide()
    end
end

local function startRunBackState(p9, p10) -- line: 125
    -- upvalues: Audio (copy), MusicDirector (copy)
    local GuardStateConnection = p9.GuardStateConnection

    if GuardStateConnection ~= nil then
        p9.GuardStateConnection = nil
        GuardStateConnection:Disconnect()
    end

    if p9.Active then
        return
    end

    p9.Active = true
    p9.GuardedMusicGeneration += 1

    local GuardedMusicGeneration = p9.GuardedMusicGeneration

    MusicDirector.SetCarryingAreaEgg(true)
    p9.GuardedMusicActive = true
    MusicDirector.SetGuardedGameplay(true)
    p9.Effects:Start(p10)

    local v2 = Audio.Play("rbxassetid://113113198465358", script, {
        PlaybackSpeed = 1.07,
        Volume = 2
    })

    if v2 == nil or v2.SoundId == "" then
        if p9.GuardedMusicGeneration == GuardedMusicGeneration and p9.GuardedMusicActive then
            p9.GuardedMusicActive = false
            MusicDirector.SetGuardedGameplay(false)
        end
    else
        p9.Trove:Add(v2.Ended:Once(function() -- line: 149
            -- upvalues: p9 (copy), GuardedMusicGeneration (copy), MusicDirector (copy)
            if p9.GuardedMusicGeneration == GuardedMusicGeneration and p9.GuardedMusicActive then
                p9.GuardedMusicActive = false
                MusicDirector.SetGuardedGameplay(false)
            end
        end))
        p9.Trove:Add(v2.Stopped:Once(function() -- line: 154
            -- upvalues: p9 (copy), GuardedMusicGeneration (copy), MusicDirector (copy)
            if p9.GuardedMusicGeneration == GuardedMusicGeneration and p9.GuardedMusicActive then
                p9.GuardedMusicActive = false
                MusicDirector.SetGuardedGameplay(false)
            end
        end))
    end
end

local function startWhenGuardWakeFinishes(p11, p12) -- line: 159
    -- upvalues: GuardAreas (copy), startRunBackState (copy)
    p11.CarryGeneration += 1

    local CarryGeneration, GuardStateConnection = p11.CarryGeneration, p11.GuardStateConnection

    if GuardStateConnection ~= nil then
        p11.GuardStateConnection = nil
        GuardStateConnection:Disconnect()
    end

    if not p11.Active then
        local v3 = p12.GuardDisabled == true

        if p12.RunBackWakeDelayRequired == true then
            local AreaId = p12.AreaId

            assert(AreaId ~= nil, "Carried area egg state must include AreaId")

            local v5 = GuardAreas[AreaId]

            assert(v5 ~= nil, (("Workspace.World.Areas.GuardAreas.%* is required"):format(AreaId)))
            assert(v5:IsA("Model"), (("Workspace.World.Areas.GuardAreas.%* must be a Model"):format(AreaId)))

            local Guard = v5.Guard

            assert(Guard ~= nil, (("%*.Guard is required"):format((v5:GetFullName()))))
            assert(Guard:IsA("Model"), (("%*.Guard must be a Model"):format((v5:GetFullName()))))

            if Guard:GetAttribute("GuardState") == "Chasing" then
                startRunBackState(p11, v3)
            else
                p11.GuardStateConnection = Guard:GetAttributeChangedSignal("GuardState"):Connect(function() -- line: 195
                    -- upvalues: p11 (copy), CarryGeneration (copy), Guard (copy), v3 (copy), startRunBackState (copy)
                    if p11.CarryGeneration == CarryGeneration and Guard:GetAttribute("GuardState") == "Chasing" then
                        startRunBackState(p11, v3)
                    end
                end)
            end
        else
            startRunBackState(p11, v3)
        end
    end
end

local function applyCarryState(p13, p14) -- line: 208
    -- upvalues: HiddenUIHandler (copy), MusicDirector (copy), Player (copy), LocalPlayer (copy), startWhenGuardWakeFinishes (copy)
    if p14.IsCarrying then
        if p13.ReleaseUiHide == nil then
            local v12 = Player.FindHumanoid(LocalPlayer)

            if v12 ~= nil then
                v12:UnequipTools()
            end

            p13.ReleaseUiHide = HiddenUIHandler.Acquire()
        end

        startWhenGuardWakeFinishes(p13, p14)
    else
        p13.CarryGeneration += 1

        local GuardStateConnection = p13.GuardStateConnection

        if GuardStateConnection ~= nil then
            p13.GuardStateConnection = nil
            GuardStateConnection:Disconnect()
        end

        if p13.Active then
            p13.Active = false
            p13.Effects:Stop()

            if p13.GuardedMusicActive then
                p13.GuardedMusicActive = false
                MusicDirector.SetGuardedGameplay(false)
            end

            MusicDirector.SetCarryingAreaEgg(false)
        end

        local ReleaseUiHide = p13.ReleaseUiHide

        if ReleaseUiHide ~= nil then
            p13.ReleaseUiHide = nil
            ReleaseUiHide()
        end
    end
end

local function resolveRuntime() -- line: 221
    -- upvalues: ScreenEffects (copy), Trove (copy), t1 (ref)
    local t3 = t1

    if t3 ~= nil then
        return t3
    end

    local t4 = {
        Active = false,
        CarryGeneration = 0,
        GuardStateConnection = nil,
        GuardedMusicActive = false,
        GuardedMusicGeneration = 0,
        ReleaseUiHide = nil,
        Started = false,
        Effects = ScreenEffects.new(),
        Trove = Trove.new()
    }

    t1 = t4

    return t4
end

function t2.Start() -- line: 246
    -- upvalues: EggState (copy), HiddenUIHandler (copy), MusicDirector (copy), Player (copy), LocalPlayer (copy), startWhenGuardWakeFinishes (copy), resolveRuntime (copy)
    local v13 = resolveRuntime()

    if v13.Started then
        return
    end

    v13.Started = true
    v13.Trove:Add(EggState.CarryChanged:Connect(function(p15) -- line: 255
        -- upvalues: v13 (copy), HiddenUIHandler (copy), MusicDirector (copy), Player (copy), LocalPlayer (copy), startWhenGuardWakeFinishes (copy)
        if p15.IsCarrying then
            if v13.ReleaseUiHide == nil then
                local v14 = Player.FindHumanoid(LocalPlayer)

                if v14 ~= nil then
                    v14:UnequipTools()
                end

                v13.ReleaseUiHide = HiddenUIHandler.Acquire()
            end

            startWhenGuardWakeFinishes(v13, p15)
        else
            v13.CarryGeneration += 1

            local GuardStateConnection = v13.GuardStateConnection

            if GuardStateConnection ~= nil then
                v13.GuardStateConnection = nil
                GuardStateConnection:Disconnect()
            end

            if v13.Active then
                v13.Active = false
                v13.Effects:Stop()

                if v13.GuardedMusicActive then
                    v13.GuardedMusicActive = false
                    MusicDirector.SetGuardedGameplay(false)
                end

                MusicDirector.SetCarryingAreaEgg(false)
            end

            local ReleaseUiHide = v13.ReleaseUiHide

            if ReleaseUiHide ~= nil then
                v13.ReleaseUiHide = nil
                ReleaseUiHide()
            end
        end
    end))
    v13.Trove:Connect(LocalPlayer.CharacterRemoving, function() -- line: 262
        -- upvalues: v13 (copy), MusicDirector (copy)
        v13.CarryGeneration += 1

        local GuardStateConnection = v13.GuardStateConnection

        if GuardStateConnection ~= nil then
            v13.GuardStateConnection = nil
            GuardStateConnection:Disconnect()
        end

        if v13.Active then
            v13.Active = false
            v13.Effects:Stop()

            if v13.GuardedMusicActive then
                v13.GuardedMusicActive = false
                MusicDirector.SetGuardedGameplay(false)
            end

            MusicDirector.SetCarryingAreaEgg(false)
        end

        local ReleaseUiHide = v13.ReleaseUiHide

        if ReleaseUiHide ~= nil then
            v13.ReleaseUiHide = nil
            ReleaseUiHide()
        end
    end)
    v13.Trove:Add(function() -- line: 264
        -- upvalues: v13 (copy), MusicDirector (copy)
        v13.CarryGeneration += 1

        local GuardStateConnection = v13.GuardStateConnection

        if GuardStateConnection ~= nil then
            v13.GuardStateConnection = nil
            GuardStateConnection:Disconnect()
        end

        if v13.Active then
            v13.Active = false
            v13.Effects:Stop()

            if v13.GuardedMusicActive then
                v13.GuardedMusicActive = false
                MusicDirector.SetGuardedGameplay(false)
            end

            MusicDirector.SetCarryingAreaEgg(false)
        end

        local ReleaseUiHide = v13.ReleaseUiHide

        if ReleaseUiHide ~= nil then
            v13.ReleaseUiHide = nil
            ReleaseUiHide()
        end
    end)

    local v15 = EggState.ReadCarryState()

    if v15.IsCarrying then
        if v15.IsCarrying then
            if v13.ReleaseUiHide == nil then
                local v16 = Player.FindHumanoid(LocalPlayer)

                if v16 ~= nil then
                    v16:UnequipTools()
                end

                v13.ReleaseUiHide = HiddenUIHandler.Acquire()
            end

            startWhenGuardWakeFinishes(v13, v15)
        else
            v13.CarryGeneration += 1

            local GuardStateConnection = v13.GuardStateConnection

            if GuardStateConnection ~= nil then
                v13.GuardStateConnection = nil
                GuardStateConnection:Disconnect()
            end

            if v13.Active then
                v13.Active = false
                v13.Effects:Stop()

                if v13.GuardedMusicActive then
                    v13.GuardedMusicActive = false
                    MusicDirector.SetGuardedGameplay(false)
                end

                MusicDirector.SetCarryingAreaEgg(false)
            end

            local ReleaseUiHide = v13.ReleaseUiHide

            if ReleaseUiHide == nil then
                return
            end

            v13.ReleaseUiHide = nil
            ReleaseUiHide()
        end
    end
end

function t2.ForceStart(p16) -- line: 273
    -- upvalues: HiddenUIHandler (copy), Player (copy), LocalPlayer (copy), startRunBackState (copy), resolveRuntime (copy)
    local v17 = resolveRuntime()

    v17.CarryGeneration += 1

    if v17.ReleaseUiHide == nil then
        local v18 = Player.FindHumanoid(LocalPlayer)

        if v18 ~= nil then
            v18:UnequipTools()
        end

        v17.ReleaseUiHide = HiddenUIHandler.Acquire()
    end

    startRunBackState(v17, p16 == true)
end

function t2.ForceStop() -- line: 280
    -- upvalues: MusicDirector (copy), resolveRuntime (copy)
    local v19 = resolveRuntime()

    v19.CarryGeneration += 1

    local GuardStateConnection = v19.GuardStateConnection

    if GuardStateConnection ~= nil then
        v19.GuardStateConnection = nil
        GuardStateConnection:Disconnect()
    end

    if v19.Active then
        v19.Active = false
        v19.Effects:Stop()

        if v19.GuardedMusicActive then
            v19.GuardedMusicActive = false
            MusicDirector.SetGuardedGameplay(false)
        end

        MusicDirector.SetCarryingAreaEgg(false)
    end

    local ReleaseUiHide = v19.ReleaseUiHide

    if ReleaseUiHide ~= nil then
        v19.ReleaseUiHide = nil
        ReleaseUiHide()
    end
end

return t2
