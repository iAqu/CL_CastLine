-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Debris = game:GetService("Debris")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local SoundService = game:GetService("SoundService")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")
local Audio = require(ReplicatedStorage.Shared.Audio)
local Cinema = require(script.Cinema)
local CursedIslandWars = require(ReplicatedStorage.Data.CursedIslandWars)
local Fx = require(script.Fx)
local Hud = require(script.Hud)
local Input = require(script.Input)
local LightingController = require(ReplicatedStorage.Controllers.Game.LightingController)
local MusicDirector = require(ReplicatedStorage.Client.MusicDirector)
local Preferences = require(ReplicatedStorage.Shared.Preferences)
local Preload = require(ReplicatedStorage.Shared.Utils.Preload)
local Remotes = require(ReplicatedStorage.Shared.Remotes)
local State = require(script.State)
local Trove = require(ReplicatedStorage.Packages.Trove)
local LocalPlayer = Players.LocalPlayer
local Controls = require(LocalPlayer:WaitForChild("PlayerScripts"):WaitForChild("PlayerModule")):GetControls()
local Sounds = ReplicatedStorage.Assets.Sounds
local Music, SuddenDeathMusic = CursedIslandWars.Assets.Music, CursedIslandWars.Assets.SuddenDeathMusic
local v1 = Color3.fromRGB(255, 60, 60)
local v2 = Color3.fromRGB(255, 140, 30)
local v3 = TweenInfo.new(1.5, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut)
local v4 = Trove.new()
local v5
local n1 = 0
local n2 = 0

task.spawn(function() -- line: 46
    -- upvalues: RunService (copy), Workspace (copy), CursedIslandWars (copy), Preload (copy), LocalPlayer (copy)
    local ShowAt = CursedIslandWars.ShowAt
    local ServerTimeNow = Workspace:GetServerTimeNow()

    if not (ShowAt + 3600 < ServerTimeNow) then
        if not RunService:IsStudio() then
            local v6 = Random.new(LocalPlayer.UserId + ShowAt)
            local v7 = ShowAt - 3600
            local v8 = ServerTimeNow < v7

            if v8 then
                task.wait(v7 - ServerTimeNow)
            end

            task.wait(v6:NextNumber(0, v8 and 600 or 60))
        end

        Preload.WarmAtWorkspace(script.Name, { CursedIslandWars.Assets })
    end
end)

local function teamOf(p1) -- line: 67
    -- upvalues: State (copy)
    local v9 = State.Entry(p1)

    if v9 then
        return v9.Team
    end

    return "Red"
end

local function eyesPosition() -- line: 72
    -- upvalues: State (copy)
    local v10 = State.Island()
    local Pieces = if not (v10 and v10.Parent) then nil else v10.Parent:FindFirstChild("Pieces")
    local SkyEyes = if Pieces then Pieces:FindFirstChild("SkyEyes") else nil

    return if SkyEyes then SkyEyes:GetPivot().Position else nil
end

local function safeZone(p2) -- line: 79
    -- upvalues: Fx (copy), Hud (copy), State (copy)
    local v11 = State.Island()

    Fx.SafeZone(p2)
    Hud.SafeZone(if not p2 or not v11 then nil else v11.Centre.Top)
end

local function playOutro() -- line: 85
    -- upvalues: Hud (copy), Remotes (copy), v4 (copy)
    Hud.Hide()

    local Run = require(script.Cutscenes.OutroCutscene)(v4).Run
    local _warn = warn

    xpcall(Run, _warn)
    Remotes.IslandWars.OutroFinished:FireServer()
end

local function onCrystal(p3, p4, p5) -- line: 92
    -- upvalues: Cinema (copy), CursedIslandWars (copy), Fx (copy), Hud (copy), State (copy), v1 (copy), n2 (ref)
    local v12 = State.Me()
    local v13 = v12 ~= nil and v12.Team == p4
    local v14 = CursedIslandWars.Teams[p4]

    if p3 == "CrystalHit" then
        local Snapshot = State.Snapshot
        local v15 = if Snapshot then Snapshot.Crystals[p4] else nil
        local v16 = if v15 then p5 / v15.MaxHealth else 1

        Fx.CrystalHit(p4, v16)

        if v13 and os.clock() - n2 > 6 then
            n2 = os.clock()
            Hud.Banner("YOUR CRYSTAL IS UNDER ATTACK!", nil, v1, 2)
            Hud.Hurt()
        end

        if v16 <= 0.25 then
            Fx.Eyes("Narrow")
        end
    elseif p3 == "CrystalStage" then
        Fx.CrystalStage(p4, p5)
        Cinema.Shake(0.2)
    elseif p3 == "CrystalShattered" then
        Fx.CrystalShattered(p4)
        Fx.Eyes("Flare")
        Cinema.Shake(0.8)

        if p5 then
            Hud.Banner(("%* shattered the %* CRYSTAL!"):format(p5, v14.Name), ("%* can no longer respawn."):format(v14.Name), v14.Color, 4)
            task.delay(1.5, function() -- line: 118
                -- upvalues: Fx (copy), State (copy)
                if State.Phase() == "Match" then
                    Fx.Eyes("Open")
                end
            end)
        end
    end
end

local function onBarrier(p6, p7, p8, p9) -- line: 127
    -- upvalues: Cinema (copy), CursedIslandWars (copy), Fx (copy), Hud (copy), State (copy), v1 (copy), n2 (ref)
    local v17 = State.Me()
    local v18 = v17 ~= nil and v17.Team == p7
    local v19 = CursedIslandWars.Teams[p7]

    if p6 == "BarrierHit" then
        local Snapshot = State.Snapshot
        local v20 = if Snapshot then Snapshot.Barriers[p7] else nil

        Fx.BarrierHit(p7, if v20 then p8 / v20.MaxHealth else 1, p9)

        if v18 and os.clock() - n2 > 6 then
            n2 = os.clock()
            Hud.Banner("YOUR WALL IS UNDER ATTACK!", nil, v1, 2)
        end
    elseif p6 == "BarrierStage" then
        Fx.BarrierStage(p7, p8)
        Cinema.Shake(0.15)
    elseif p6 == "BarrierBroken" then
        Fx.BarrierBroken(p7)
        Cinema.Shake(0.5)

        local v21 = if p8 then ("%* broke the %* WALL!"):format(p8, v19.Name) else ("The %* WALL is down!"):format(v19.Name)

        Hud.Banner(v21, ("The %* CRYSTAL can now be destroyed."):format(v19.Name), v19.Color, 4)
    end
end

local function onMoment(p10, ...) -- line: 150
    -- upvalues: Workspace (copy), Audio (copy), Cinema (copy), Fx (copy), Hud (copy), Input (copy), State (copy), LocalPlayer (copy), Sounds (copy), v1 (copy), v2 (copy), v4 (copy), v5 (ref), playOutro (copy), onCrystal (copy), onBarrier (copy)
    local v22 = State.Me()
    local Id = if v22 then v22.Id else nil

    if p10 == "Launch" then
        local v23, v24, v25, v26, v27 = ...

        if v23 ~= Id then
            local Launch = Fx.Launch
            local v28 = ("%*:%*"):format(v23, v24)
            local v29 = State.Entry(v23)

            Launch(v28, v25, v26, v27, if v29 then v29.Team else "Red")
        end
    else
        if p10 == "Lock" then
            local v30, v31, v32, v33 = ...

            Fx.Lock(("%*:%*"):format(v30, v31), v32, State.Root(State.Entry(v33)))

            return
        end

        if p10 == "Impact" then
            local v34, v35 = ...

            Fx.Land((("%*:%*"):format(v34, v35)))

            return
        end

        if p10 == "Explode" then
            local v36, v37 = ...

            Fx.Explode(v36, v37)

            local v38 = v36 == "Mine"

            Cinema.ShakeAt(v37, v38 and 0.7 or 0.3, v38 and 70 or 35)

            return
        end

        if p10 == "Mine" then
            local v39, v40 = ...
            local Mine = Fx.Mine
            local v41 = State.Entry(v39)

            Mine(v40, if v41 then v41.Team else "Red")

            return
        end

        if p10 == "MineTrigger" then
            Fx.MineTrigger(...)
        elseif p10 == "Built" then
            local v42, v43 = ...

            Fx.Built(v42, v43)
        elseif p10 == "Bricks" then
            Fx.Bricks(...)
        elseif p10 == "Pad" then
            local v44, v45 = ...
            local Pad = Fx.Pad
            local v46 = State.Entry(v44)

            Pad(v45, if v46 then v46.Team else "Red")
        elseif p10 == "PadLaunch" then
            local v47, v48 = ...
            local v49 = State.Entry(v48)

            if v48 ~= Id and v49 then
                Fx.PadLaunch(v47, v49.Model, v49.Team)
            end
        elseif p10 == "Hit" then
            local v50, v51, v52 = ...
            local v53 = State.Entry(v50)

            Fx.Hit(if v53 then v53.Model else nil)

            if v50 == Id then
                Hud.Hurt()
                Cinema.Shake(0.25)
            else
                local HitMarker, Model

                if v52 ~= nil and v52 == Id then
                    HitMarker = Hud.HitMarker

                    if v53 then
                        Model = v53.Model
                    end

                    HitMarker(Model, v51)
                end
            end
        elseif p10 == "Knockout" then
            local v54, v55, v56, v57 = ...

            Fx.Knockout(v55)
            Hud.Knockout(v54, v56, v57)

            if v54 == Id then
                Cinema.Shake(0.5)
                Hud.Banner(v57 and "ELIMINATED" or "KNOCKED OUT", nil, v1, 2)
            elseif v56 ~= nil and v56 == Id then
                Hud.Banner("KNOCKOUT!", nil, v2, 1.2)
            end
        else
            if p10 == "Respawn" then
                local v58, v59 = ...
                local v60 = State.Entry(v58)
                local Respawn = Fx.Respawn
                local Model = if v60 then v60.Model else nil
                local v61 = State.Entry(v58)

                Respawn(v58, v59, Model, if v61 then v61.Team else "Red")

                return
            end

            if p10 == "ShieldEnded" then
                Fx.EndShield(...)
            elseif p10 == "CrystalHit" or p10 == "CrystalStage" or p10 == "CrystalShattered" then
                local v62, v63 = ...

                onCrystal(p10, v62, v63)
            elseif p10 == "BarrierHit" or p10 == "BarrierStage" or p10 == "BarrierBroken" then
                local v64, v65, v66 = ...

                onBarrier(p10, v64, v65, v66)
            elseif p10 == "PickupDrop" then
                local v67, v68 = ...

                Fx.PickupDrop(v67, v68)
            elseif p10 == "PickupTaken" then
                local v69, v70, v71 = ...

                Fx.PickupTaken(v69, v70)

                if v71 == Id then
                    Fx.Ui(Sounds.MountRace.CountdownGo, 1.3, 0.8)
                end
            elseif p10 == "WallsOpen" then
                Fx.WallsOpen(...)
                Hud.WallsOpen()
                Fx.Eyes("Open")
                Fx.Ui(Sounds.MountRace.CountdownGo, 1, 1.2)
                Cinema.Shake(0.4)
            elseif p10 == "Warning" then
                local v72 = ...
                local Snapshot = State.Snapshot
                local v73 = if Snapshot then Snapshot.Crystals else {}
                local n3 = 0

                for _, v74 in v73 do
                    if v74.Health > 0 then
                        n3 += 1
                    end
                end

                if v72 <= 15 then
                    Hud.Banner(("SUDDEN DEATH IN %*!"):format(v72), "The island falls from the edges in. Head for the centre!", v1, 4)

                    local v75 = State.Island()

                    Fx.SafeZone(true)
                    Hud.SafeZone(if v75 then v75.Centre.Top else nil)
                else
                    local v76 = if n3 > 1 then ("The crystals break in %* seconds!"):format(v72) else ("The last crystal breaks in %* seconds!"):format(v72)

                    Hud.Banner("THE ISLAND IS CRUMBLING...", v76, v2, 3)
                end

                Fx.Eyes("Narrow")
            elseif p10 == "EarlySuddenDeath" then
                local v77 = ...

                Hud.Banner("BOTH CRYSTALS SHATTERED!", ("Sudden Death in %*! The island falls from the edges in. Head for the centre!"):format(v77), v1, 4)

                local v78 = State.Island()

                Fx.SafeZone(true)
                Hud.SafeZone(if v78 then v78.Centre.Top else nil)
                Fx.Eyes("Narrow")
            elseif p10 == "SuddenDeath" then
                local v79 = State.Island()

                Fx.SafeZone(true)
                Hud.SafeZone(if v79 then v79.Centre.Top else nil)
                Hud.Banner("SUDDEN DEATH", "No more respawns. Get to the centre!", v1, 4)
                Fx.Eyes("Flare")
                Fx.SuddenDeath()
                Cinema.Shake(0.6)

                local v80 = Audio.Play(Sounds.ScrambleBoss.Rumble, Workspace.CurrentCamera, {
                    Looped = true,
                    Volume = 1.2
                })

                if v80 then
                    v5 = v80
                    v4:Add(v80)
                end
            else
                if p10 == "CollapseWarn" then
                    local v81, v82 = ...

                    Fx.CollapseWarn(v81, v82)
                    Hud.Alarm(v81, State.Now() + v82)
                    Cinema.Shake(0.25)

                    return
                end

                if p10 == "CollapseDrop" then
                    local v83, v84, v85 = ...

                    Fx.CollapseDrop(v83, v84, v85)
                    Cinema.Shake(0.5)
                elseif p10 == "Win" then
                    local v86, v87 = ...
                    local v88 = v5

                    v5 = nil

                    if v88 then
                        v88:Destroy()
                    end

                    State.Island()
                    Fx.SafeZone(false)
                    Hud.SafeZone(nil)
                    Hud.Win(v86, v87)
                    Fx.Eyes("Closed")

                    local Character = LocalPlayer.Character
                    local HumanoidRootPart = if Character then Character:FindFirstChild("HumanoidRootPart") else nil

                    Fx.Victory(if HumanoidRootPart then HumanoidRootPart.CFrame else Workspace.CurrentCamera.CFrame)
                elseif p10 == "Outro" then
                    task.spawn(playOutro)
                elseif p10 == "Knock" then
                    Input.Knock(...)
                else
                    if p10 ~= "Cooldown" then
                        return
                    end

                    local v89, v90 = ...

                    Input.SetCooldown(v89, v90)
                end
            end
        end
    end
end

local function matchMusic(p11) -- line: 300
    -- upvalues: Debris (copy), SoundService (copy), TweenService (copy), MusicDirector (copy), Preferences (copy), Music (copy), SuddenDeathMusic (copy), v3 (copy)
    local t1 = {}

    for _, v91 in { Music, SuddenDeathMusic } do
        local clone = v91:Clone()

        t1[v91] = {
            Sound = clone,
            Volume = clone.Volume
        }
        clone.Volume = 0
        clone.Parent = SoundService
    end

    local v92
    local v93 = true

    local function apply() -- line: 310
        -- upvalues: t1 (copy), v92 (ref), v93 (ref), TweenService (copy), v3 (copy)
        for v94, v95 in t1 do
            local v96 = v93 and v94 == v92

            if v96 and not v95.Sound.IsPlaying then
                v95.Sound:Play()
            end

            TweenService:Create(v95.Sound, v3, {
                Volume = if v96 then v95.Volume else 0
            }):Play()
        end
    end

    p11:Add(Preferences.Observe("Music", function(p12) -- line: 319
        -- upvalues: v93 (ref), apply (copy)
        v93 = p12 ~= false
        apply()
    end))
    p11:Add(function() -- line: 323
        -- upvalues: t1 (copy), v92 (ref), Debris (copy), TweenService (copy), MusicDirector (copy), v3 (copy)
        if v92 then
            MusicDirector.SetEventMusic(false)
        end

        for _, v97 in t1 do
            TweenService:Create(v97.Sound, v3, {
                Volume = 0
            }):Play()
            Debris:AddItem(v97.Sound, v3.Time)
        end
    end)

    return function(p13) -- line: 332
        -- upvalues: v92 (ref), apply (copy), MusicDirector (copy)
        if v92 == p13 then
            return
        end

        if v92 == nil ~= (p13 == nil) then
            MusicDirector.SetEventMusic(p13 ~= nil)
        end

        v92 = p13
        apply()
    end
end

local function watchPhases(p14) -- line: 343
    -- upvalues: RunService (copy), Cinema (copy), Fx (copy), Hud (copy), LightingController (copy), State (copy), Controls (copy), Sounds (copy), Music (copy), SuddenDeathMusic (copy), eyesPosition (copy), matchMusic (copy)
    local v98 = matchMusic(p14)
    local v99, Phase
    local n4 = 0
    local v100 = false

    p14:Add(function() -- line: 349
        -- upvalues: v100 (ref), LightingController (copy), Controls (copy)
        LightingController.ClearLayer("CursedIslandWars", 2)

        if v100 then
            Controls:Enable()
        end
    end)
    p14:Add(State.Changed:Connect(function(p15) -- line: 355
        -- upvalues: v98 (copy), v99 (ref), Phase (ref), v100 (ref), Cinema (copy), Fx (copy), Hud (copy), LightingController (copy), State (copy), Controls (copy), Music (copy), SuddenDeathMusic (copy), eyesPosition (copy)
        local Phase2 = if p15 then p15.Phase else nil

        if Phase2 == Phase then
            return
        end

        Phase = Phase2

        local v101 = Phase2 == "Intro" or Phase2 == "Reveal"

        if v101 ~= v100 then
            v100 = v101

            if v101 then
                Controls:Disable()
            else
                Controls:Enable()
            end
        end

        local v102 = Phase2 ~= nil and Phase2 ~= "Intro" and Phase2 ~= "Outro"

        v99 = if not v102 then nil elseif Phase2 == "SuddenDeath" then SuddenDeathMusic else Phase2 == "Win" and v99 or Music
        v98(v99)

        if v102 then
            LightingController.SetLayer("CursedIslandWars", "CursedIslandWars", 25, 2)
        else
            LightingController.ClearLayer("CursedIslandWars", 2)
        end

        if Phase2 == "Reveal" then
            local v103 = State.Me()

            if v103 then
                Hud.TeamCard(v103.Team)
            end

            task.delay(2.6, function() -- line: 389
                -- upvalues: Cinema (copy), Fx (copy), State (copy), eyesPosition (copy)
                local v104 = eyesPosition()

                if v104 and State.Phase() == "Reveal" then
                    Fx.Eyes("Open")
                    Cinema.Reveal(v104)
                end

                Fx.Pillars(true)
            end)
        elseif Phase2 == "Prep" or Phase2 == "Match" or Phase2 == "SuddenDeath" then
            Fx.Pillars(true)
        end
    end))
    p14:Add(RunService.Heartbeat:Connect(function() -- line: 401
        -- upvalues: n4 (ref), Fx (copy), State (copy), Sounds (copy)
        local Snapshot = State.Snapshot

        if Snapshot ~= nil and Snapshot.Phase == "Prep" then
            local v106 = math.ceil(Snapshot.PhaseEndsAt - State.Now())

            if v106 <= 5 and v106 >= 1 and v106 ~= n4 then
                n4 = v106
                Fx.Ui(Sounds.MountRace.CountdownTick, (5 - v106) * 0.08 + 1, 1)
            end
        end
    end))
end

return {
    StartEvent = function(_, _, p18) -- StartEvent | line: 416
        -- upvalues: Cinema (copy), Fx (copy), Hud (copy), Input (copy), Remotes (copy), State (copy), v4 (copy), n1 (ref), n2 (ref), onMoment (copy), watchPhases (copy)
        v4:Clean()
        n2 = 0
        p18 = p18 or {}

        local v108 = v4:Extend()

        State.Set(nil)
        v108:Add(function() -- line: 422
            -- upvalues: State (copy)
            State.Set(nil)
        end)
        v108:Add(Remotes.IslandWars.State.OnClientEvent:Connect(State.Set))
        v108:Add(Remotes.IslandWars.Moment.OnClientEvent:Connect(onMoment))
        Fx.Start(v108)
        Cinema.Start(v108)
        Input.Start(v108)
        watchPhases(v108)
        task.spawn(function() -- line: 431
            -- upvalues: Remotes (copy), State (copy)
            local v109 = Remotes.IslandWars.Fetch:InvokeServer()

            if State.Snapshot == nil and v109 ~= nil then
                State.Set(v109)
            end
        end)
        n1 += 1

        local v110 = n1

        if not p18.SkipCutscenes and not p18.WasInProgress then
            local Run = require(script.Cutscenes.IntroCutscene)(v108).Run
            local _warn = warn

            xpcall(Run, _warn)
        end

        if n1 == v110 then
            Hud.Start(v108)
        end
    end,
    StopEvent = function(_) -- StopEvent | line: 448
        -- upvalues: v4 (copy), n1 (ref)
        n1 += 1
        v4:Clean()
    end
}
