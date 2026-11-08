-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CollectionService = game:GetService("CollectionService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Debris = game:GetService("Debris")
local Emit = require(game.ReplicatedStorage.UserGenerated.VFX.Emit)
local Break = game.ReplicatedStorage.Assets.VFX.Sakura.Break
local Scramble = require(ReplicatedStorage.Shared.Remotes).Scramble
local ScrambleMotion = require(ReplicatedStorage.Shared.Util.ScrambleMotion)
local DroneVisual = require(script.DroneVisual)
local Hud = require(ReplicatedStorage.Client.Hud)
local ButtonFX = require(ReplicatedStorage.Client.UI.VFX.ButtonFX)
local Tabs = require(ReplicatedStorage.Client.Tabs)
local Save = require(ReplicatedStorage.Shared.Save)
local GameplayBalance = require(ReplicatedStorage.Shared.Flags.GameplayBalance)
local Gears = require(ReplicatedStorage.Data.Gears)
local BossEventFlags = require(ReplicatedStorage.Shared.Flags.BossEventFlags)
local ScrambleBossFlags = require(ReplicatedStorage.Shared.Flags.ScrambleBossFlags)
local RaceRallySchedule = require(ReplicatedStorage.Shared.Util.RaceRallySchedule)
local RiftEligibility = require(ReplicatedStorage.Shared.Util.RiftEligibility)
local RiftFlags = require(ReplicatedStorage.Shared.Flags.RiftFlags)
local ScramblePickupMotion = require(ReplicatedStorage.Shared.Util.ScramblePickupMotion)
local Constants = require(ReplicatedStorage.Shared.Globals.Constants)

return {
    Start = function() -- Start | line: 29
        -- upvalues: Players (copy), ReplicatedStorage (copy), CollectionService (copy), RunService (copy), TweenService (copy), Debris (copy), Emit (copy), Break (copy), Scramble (copy), ScrambleMotion (copy), DroneVisual (copy), Hud (copy), ButtonFX (copy), Tabs (copy), Save (copy), GameplayBalance (copy), Gears (copy), BossEventFlags (copy), ScrambleBossFlags (copy), RaceRallySchedule (copy), RiftEligibility (copy), RiftFlags (copy), ScramblePickupMotion (copy), Constants (copy)
        local Scramble2 = ReplicatedStorage.Assets.UI:WaitForChild("Scramble")
        local Audio = require(ReplicatedStorage.Shared.Audio)
        local LightingController = require(ReplicatedStorage.Controllers.Game.LightingController)
        local MusicDirector = require(ReplicatedStorage.Client.MusicDirector)
        local LocalPlayer = Players.LocalPlayer
        local VaultSequence = require(script.VaultSequence)
        local Scramble3 = ReplicatedStorage.Assets.Models:WaitForChild("Scramble")
        local Folder = Instance.new("Folder")

        Folder.Name = "ScrambleLocalVisuals"
        Folder.Parent = workspace

        local t2 = {}
        local t3 = {}
        local t4 = {}
        local t5 = {}
        local v1 = require(script.HitFeedback).new(LocalPlayer:WaitForChild("PlayerGui"), Scramble2.Label)
        local n1 = 0
        local v2
        local n2 = -1
        local n3 = -1
        local t6
        local n4 = 0
        local v3, v4
        local v5 = require(script.SleepingBrock).new()
        local v6 = Color3.fromRGB(168, 244, 120)
        local n5 = 0
        local v7 = ColorSequence.new(Color3.fromRGB(126, 66, 196), Color3.fromRGB(198, 146, 255))
        local v8 = ColorSequence.new(Color3.fromRGB(60, 255, 0), Color3.fromRGB(136, 255, 0))
        local v9 = Color3.fromRGB(38, 12, 76)
        local v10 = Color3.fromRGB(228, 200, 255)
        local v11 = Color3.fromRGB(11, 72, 0)
        local v12 = Color3.fromRGB(190, 255, 180)

        local function questAvailable() -- line: 65
            -- upvalues: v2 (ref)
            if v2 ~= nil and v2.Ready == true and v2.Enabled == true and v2.WorldReady == true then
                return workspace:GetServerTimeNow() < (v2.EventEndsAt or 0)
            end

            return false
        end

        local function updateLive() -- line: 72
            -- upvalues: Constants (copy)
            return workspace:GetServerTimeNow() >= Constants.UPDATE_LIVE_AT
        end

        local function make(p1, p2, p3) -- line: 76
            local v13 = Instance.new(p1)

            for v14, v15 in p3 do
                v13[v14] = v15
            end

            v13.Parent = p2

            return v13
        end

        local function label(p4, p5, p6) -- line: 84
            -- upvalues: Scramble2 (copy)
            local clone = Scramble2.Label:Clone()

            clone.AnchorPoint = Vector2.zero

            local v16 = UDim2.fromOffset(0, 0)
            local v17 = UDim2.new(1, 0, 0, p6)

            clone.Position = v16
            clone.Size = v17
            clone.Text = p5
            clone.TextScaled = true
            clone.TextWrapped = false
            clone.Parent = p4

            return clone
        end

        local ExperimentTimer = Hud.Every("ExperimentTimer")
        local ExperimentTimerValue = Hud.Every("ExperimentTimerValue")

        for _, v18 in ExperimentTimer do
            v18.Visible = false
        end

        local function updateExperimentTimer(p7) -- line: 97
            -- upvalues: LocalPlayer (copy), v2 (ref), ExperimentTimer (copy), ExperimentTimerValue (copy), Save (copy), ScrambleBossFlags (copy), RaceRallySchedule (copy)
            local v19 = v2 and v2.Window
            local v20 = v2 and v2.TimerMinSpeed
            local v21, v22

            if v19 then
                v21 = v19.Active == true
                v22 = if v21 then v19.EndsAt else v19.NextAt
            else
                v22 = v19
                v21 = v19
            end

            local v23 = v2 and v2.EventEndsAt
            local v24 = Save.Peek()
            local v25 = v24 and v24.SpeedPower
            local v26 = if typeof(v22) == "number" then v22 - p7 else 0
            local v27 = false

            if v2 ~= nil then
                if v2.Enabled ~= true or v2.Ready ~= true or v19 == nil then
                elseif v19.Available == true and typeof(v20) == "number" and v20 > 0 and v20 < 1e999 and typeof(v25) == "number" and v20 <= v25 and v25 < 1e999 and typeof(v22) == "number" and typeof(v23) == "number" and (v21 or v22 < v23) and v26 > 0 then
                    v27 = v21 or v26 <= 300
                end
            end

            local v28, v29, v31
            local v30 = v27

            if v27 then
                v31 = 0
            elseif LocalPlayer:GetAttribute("ScrambleCountdownReturningPlayer") ~= true or not ScrambleBossFlags.ContentEnabled:Get() or not ScrambleBossFlags.ScheduleEnabled:Get() or workspace:GetAttribute("Event_ScrambleBoss") == true then
                v31 = 0
            else
                local v32 = ScrambleBossFlags.ScheduleIntervalSeconds:Get()
                local v34 = (math.floor(p7 / v32) + 1) * v32

                if RaceRallySchedule.ClaimsBoundary(v34) then
                    v31 = 0
                else
                    v28 = v34 - p7
                    v29 = v28 > 0 and v28 <= 300
                    v30 = v29
                    v31 = v28
                end
            end

            if v30 then
                local v36 = math.ceil(if v31 > 0 then v31 else v26)
                local v37 = string.format(if v31 > 0 then "in %dm %ds" elseif v21 then "Event ends in %dm %ds" else "in %dm %ds", v36 // 60, v36 % 60)

                for _, v38 in ExperimentTimerValue do
                    if v38.Text ~= v37 then
                        v38.Text = v37
                    end
                end
            end

            for _, v39 in ExperimentTimer do
                if v39.Visible ~= v30 then
                    v39.Visible = v30
                end
            end
        end

        local t7 = {}

        for _, v40 in Hud.Every("QuestlineButton") do
            local RemovalTimer = v40:FindFirstChild("RemovalTimer")

            if RemovalTimer and RemovalTimer:IsA("TextLabel") then
                RemovalTimer.Visible = false
                table.insert(t7, {
                    Prefix = "",
                    Label = RemovalTimer
                })
            end
        end

        local RemovalTimer = require(ReplicatedStorage.Client.GUI).Get("ScrambleBossMastery").Frame.Header:FindFirstChild("RemovalTimer")

        if RemovalTimer and RemovalTimer:IsA("TextLabel") then
            RemovalTimer.Visible = false
            table.insert(t7, {
                Prefix = "Leaves in ",
                Label = RemovalTimer
            })
        end

        local function updateRemovalTimers(p8) -- line: 176
            -- upvalues: t7 (copy), ScrambleBossFlags (copy)
            local v41 = ScrambleBossFlags.RemovalAt:Get()
            local v43 = math.ceil(v41 - p8)
            local v44 = v41 > 0 and v43 > 0
            local v45 = if not v44 then "" elseif v43 >= 86400 then string.format("%dd %dh %dm", v43 // 86400, v43 // 3600 % 24, v43 // 60 % 60) else string.format("%02d:%02d:%02d", v43 // 3600, v43 // 60 % 60, v43 % 60)

            for _, v46 in t7 do
                local v47 = if v44 then v46.Prefix .. v45 else ""

                if v46.Label.Text ~= v47 then
                    v46.Label.Text = v47
                end

                if v46.Label.Visible ~= v44 then
                    v46.Label.Visible = v44
                end
            end
        end

        local StolenVaultEvent = require(ReplicatedStorage.Client.GUI).Get("StolenVaultEvent")
        local v48 = require(script.Interface).new(function(p9, p10, p11) -- line: 206
            -- upvalues: v3 (ref)
            return v3(p9, p10, p11)
        end)
        local v49 = require(script.ShopInterface).new(function(p12, p13, p14) -- line: 209
            -- upvalues: v3 (ref)
            return v3(p12, p13, p14)
        end)
        local v50 = require(script.MasteryInterface).new(function(p15, p16, p17) -- line: 212
            -- upvalues: v3 (ref)
            return v3(p15, p16, p17)
        end, function() -- line: 214
            -- upvalues: v49 (copy)
            v49.Show()
        end)
        local v51 = require(script.Dialogue).new()
        local v52 = false
        local QuestlineButton = Hud.Every("QuestlineButton")
        local RiftButton = Hud.Every("RiftButton")
        local t10 = {}

        local function applyEventButtonStyle(p18, p19) -- line: 223
            -- upvalues: v7 (copy), v8 (copy), v9 (copy), v10 (copy), v11 (copy), v12 (copy)
            local ImageLabel = p18:FindFirstChild("ImageLabel")
            local UIGradient = p18:FindFirstChild("UIGradient")
            local UIStroke = p18:FindFirstChild("UIStroke")
            local UIStrokeClr = p18:FindFirstChild("UIStrokeClr")

            if ImageLabel and ImageLabel:IsA("ImageLabel") then
                ImageLabel.Image = p19 and "rbxassetid://98847011195862" or "rbxassetid://84787104764975"
            end

            if UIGradient and UIGradient:IsA("UIGradient") then
                if p19 then
                    UIGradient.Color = v8
                else
                    UIGradient.Color = v7
                end
            end

            if UIStroke and UIStroke:IsA("UIStroke") then
                if p19 then
                    UIStroke.Color = v11
                else
                    UIStroke.Color = v9
                end
            end

            if UIStrokeClr and UIStrokeClr:IsA("UIStroke") then
                if p19 then
                    UIStrokeClr.Color = v12
                else
                    UIStrokeClr.Color = v10
                end
            end
        end

        local function scrambleHudRequested() -- line: 242
            -- upvalues: v2 (ref)
            if v2 ~= nil then
                return v2.ShowHUD == true
            end

            if workspace:GetAttribute("ScrambleHUDUnlocked") == true then
                return workspace:GetAttribute("ScrambleHUDAwaitingSammyOutro") ~= true
            end

            return false
        end

        local function volcanoSpeedReached() -- line: 250
            -- upvalues: Save (copy), RiftEligibility (copy)
            local v53 = Save.Peek()

            return v53 ~= nil and (RiftEligibility.IsEligible(v53.SpeedPower))
        end

        local function riftHudAvailable() -- line: 255
            -- upvalues: Save (copy), BossEventFlags (copy), RiftEligibility (copy)
            local v54 = BossEventFlags.ContentEnabled:Get()

            if v54 then
                local v55 = Save.Peek()

                v54 = v55 ~= nil and RiftEligibility.IsEligible(v55.SpeedPower)
            end

            return v54
        end

        local function updateEventButtons() -- line: 259
            -- upvalues: v2 (ref), QuestlineButton (copy), RiftButton (copy), Save (copy), BossEventFlags (copy), RiftEligibility (copy)
            local v56 = if v2 == nil then workspace:GetAttribute("ScrambleHUDUnlocked") == true and workspace:GetAttribute("ScrambleHUDAwaitingSammyOutro") ~= true else v2.ShowHUD == true
            local v57

            if v56 then
                local v58 = v2 ~= nil and v2.Ready == true and v2.Enabled == true and v2.WorldReady == true and workspace:GetServerTimeNow() < (v2.EventEndsAt or 0)

                if v58 then
                    local v59 = Save.Peek()

                    v57 = v59 ~= nil and RiftEligibility.IsEligible(v59.SpeedPower)
                else
                    v57 = v58
                end
            else
                v57 = v56
            end

            local v60 = BossEventFlags.ContentEnabled:Get()

            if v60 then
                local v61 = Save.Peek()

                v60 = v61 ~= nil and RiftEligibility.IsEligible(v61.SpeedPower)
            end

            for _, v62 in QuestlineButton do
                v62.Visible = v57
            end

            for _, v63 in RiftButton do
                v63.Visible = v60
            end
        end

        local function bindEventButtons(p20, p21) -- line: 272
            -- upvalues: v2 (ref), v49 (copy), v50 (copy), t10 (copy), applyEventButtonStyle (copy), ButtonFX (copy), Tabs (copy), Save (copy), BossEventFlags (copy), RiftEligibility (copy), Constants (copy)
            for _, v64 in p20 do
                v64.Visible = false
                applyEventButtonStyle(v64, p21)

                local Badge = v64:FindFirstChild("Badge")

                if Badge and Badge:IsA("GuiObject") then
                    Badge.Visible = false
                end

                table.insert(t10, ButtonFX(v64, 1.08, function() -- line: 283
                    -- upvalues: p21 (copy), v2 (ref), v49 (copy), v50 (copy), Tabs (copy), Save (copy), BossEventFlags (copy), RiftEligibility (copy), Constants (copy)
                    if p21 then
                        if (if v2 == nil then workspace:GetAttribute("ScrambleHUDUnlocked") == true and workspace:GetAttribute("ScrambleHUDAwaitingSammyOutro") ~= true else v2.ShowHUD == true) and v2 ~= nil and v2.Ready == true and v2.Enabled == true and v2.WorldReady == true and workspace:GetServerTimeNow() < (v2.EventEndsAt or 0) then
                            local v66 = Save.Peek()

                            if v66 ~= nil and RiftEligibility.IsEligible(v66.SpeedPower) then
                                if Tabs.IsActive("DrScrambleEvent") then
                                    v49.Close()
                                elseif workspace:GetServerTimeNow() >= Constants.UPDATE_LIVE_AT then
                                    v50.Toggle()
                                else
                                    v49.Show()
                                end
                            end
                        end
                    else
                        local v67 = BossEventFlags.ContentEnabled:Get()

                        if v67 then
                            local v68 = Save.Peek()

                            v67 = v68 ~= nil and RiftEligibility.IsEligible(v68.SpeedPower)
                        end

                        if v67 then
                            Tabs.Toggle("BossMastery")
                        end
                    end
                end))
            end
        end

        bindEventButtons(QuestlineButton, true)
        bindEventButtons(RiftButton, false)

        local Toast = require(ReplicatedStorage.Client.Notifications.Toast)

        local function toast(p22) -- line: 310
            -- upvalues: v6 (copy), Toast (copy)
            Toast.Show({
                Seconds = 2.5,
                SingleLine = true,
                Unique = true,
                Text = p22,
                Color = v6
            })
        end

        local function playerRoot(p23) -- line: 319
            local v69 = p23 and p23.Character
            local Humanoid = v69 and v69:FindFirstChildOfClass("Humanoid")

            return if Humanoid and Humanoid.Health > 0 then v69:FindFirstChild("HumanoidRootPart") else nil
        end

        local function root() -- line: 326
            -- upvalues: LocalPlayer (copy)
            local v70 = LocalPlayer and LocalPlayer.Character
            local Humanoid = v70 and v70:FindFirstChildOfClass("Humanoid")

            return if Humanoid and Humanoid.Health > 0 then v70:FindFirstChild("HumanoidRootPart") else nil
        end

        local function batIn(p24) -- line: 329
            -- upvalues: Gears (copy)
            for _, child in p24:GetChildren() do
                if child:IsA("Tool") then
                    if child:GetAttribute("IsBat") == true then
                        return child
                    end

                    local GearName = child:GetAttribute("GearName")
                    local v71 = if typeof(GearName) == "string" then Gears.Directory[GearName] else nil

                    if v71 and (v71.BatControllerData ~= nil or v71.ToolController == "Slap") then
                        return child
                    end
                end
            end

            return nil
        end

        local function droneWithinAutoAttackRadius(p25) -- line: 345
            -- upvalues: t4 (copy)
            for v72 in t4 do
                local Hitbox = v72:FindFirstChild("Hitbox")

                if Hitbox then
                    local Health = Hitbox:GetAttribute("Health")

                    if Hitbox:IsA("BasePart") and typeof(Health) == "number" and Health > 0 and (Hitbox.Position - p25).Magnitude <= 12 then
                        return true
                    end
                end
            end

            return false
        end

        local function updateAutoAttack() -- line: 361
            -- upvalues: LocalPlayer (copy), VaultSequence (copy), v2 (ref), n5 (ref), batIn (copy), droneWithinAutoAttackRadius (copy), GameplayBalance (copy)
            if VaultSequence.IsPlaying() or not v2 or not v2.Window or v2.Window.Active ~= true then
                return
            end

            local Character = LocalPlayer.Character
            local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")
            local v73 = LocalPlayer and LocalPlayer.Character
            local Humanoid2 = v73 and v73:FindFirstChildOfClass("Humanoid")
            local HumanoidRootPart = if not (Humanoid2 and Humanoid2.Health > 0) then nil else v73:FindFirstChild("HumanoidRootPart")

            if Character and Humanoid and HumanoidRootPart and droneWithinAutoAttackRadius(HumanoidRootPart.Position) then
                local v74 = batIn(Character)

                if v74 then
                    local ServerTimeNow = workspace:GetServerTimeNow()
                    local CooldownEndTime = v74:GetAttribute("CooldownEndTime")

                    if typeof(CooldownEndTime) == "number" then
                        n5 = math.max(n5, CooldownEndTime)
                    end

                    if not (ServerTimeNow < n5) and v74:GetAttribute("CooldownActive") ~= true then
                        n5 = ServerTimeNow + math.max(GameplayBalance.BatClient.CLIENT_COOLDOWN, GameplayBalance.BatServer.PLAYER_COOLDOWN)
                        v74:Activate()
                    end
                else
                    local Backpack = LocalPlayer:FindFirstChildOfClass("Backpack")
                    local v76 = if Backpack then batIn(Backpack) else nil

                    if v76 then
                        Humanoid:EquipTool(v76)

                        local v77 = n5

                        n5 = math.max(v77, workspace:GetServerTimeNow() + 0.1)
                    end
                end
            end
        end

        local function removeDrop(p26) -- line: 405
            -- upvalues: t2 (copy), n1 (ref)
            local v79 = t2[p26]

            if not v79 then
                return
            end

            if v79.Observer then
                n1 -= 1
            end

            v79.Model:Destroy()
            t2[p26] = nil
        end

        local function setHidden(p27, p28) -- line: 416
            if p27.Hidden == p28 then
                return
            end

            p27.Hidden = p28

            for _, v80 in p27.Parts do
                v80.LocalTransparencyModifier = p28 and 1 or 0
            end

            if p28 and p27.Floating then
                p27.Model:PivotTo(p27.BasePivot)
            end
        end

        local function stopQuestView(p29) -- line: 428
            if p29.IdleTrack then
                p29.IdleTrack:Stop(0)
                p29.IdleTrack:Destroy()
                p29.IdleTrack = nil
            end

            if p29.Prompt and not p29.Floating then
                p29.Prompt:Destroy()
            end
        end

        local function updateQuestIdle(p30) -- line: 438
            -- upvalues: v2 (ref)
            local IdleTrack = p30.IdleTrack

            if not IdleTrack then
                return
            end

            local CurrentCamera = workspace.CurrentCamera
            local v81 = v2 ~= nil and v2.Ready == true and v2.Enabled == true and v2.WorldReady == true and workspace:GetServerTimeNow() < (v2.EventEndsAt or 0) and not p30.Hidden and CurrentCamera ~= nil and p30.Model:IsDescendantOf(workspace) and (CurrentCamera.CFrame.Position - p30.Model:GetPivot().Position).Magnitude <= 160

            if p30.IdlePlaying ~= v81 then
                p30.IdlePlaying = v81

                if v81 then
                    IdleTrack:Play(0.2)
                else
                    IdleTrack:Stop(0.2)
                end
            end
        end

        local function loadQuestIdle(p31, p32) -- line: 459
            -- upvalues: t3 (copy), updateQuestIdle (copy)
            local AnimationController = p31.Model:FindFirstChildOfClass("AnimationController")
            local v82

            if AnimationController then
                v82 = AnimationController:FindFirstChildOfClass("Animator")
                AnimationController = AnimationController:FindFirstChild("ScrambleIdle")
            else
                v82 = AnimationController
            end

            if not (v82 and AnimationController and AnimationController:IsA("Animation")) then
                return
            end

            task.spawn(function() -- line: 466
                -- upvalues: p31 (copy), p32 (copy), AnimationController (ref), v82 (ref), t3 (copy), updateQuestIdle (copy)
                local function v83() -- line: 467
                    -- upvalues: AnimationController (ref), v82 (ref)
                    return v82:LoadAnimation(AnimationController)
                end

                local ok, result = pcall(v83)

                if not ok then
                    warn("[Scramble] NPC idle could not load:", result)

                    return
                end

                if t3[p32] ~= p31 or not p31.Model:IsDescendantOf(workspace) then
                    result:Destroy()
                else
                    result.Looped = true
                    result.Priority = Enum.AnimationPriority.Idle
                    p31.IdleTrack = result
                    updateQuestIdle(p31)
                end
            end)
        end

        local function syncQuest() -- line: 484
            -- upvalues: VaultSequence (copy), t3 (copy), v2 (ref), v51 (copy), updateQuestIdle (copy)
            if not v2 then
                return
            end

            for v84, v85 in t3 do
                local v86 = not (v2 ~= nil and v2.Ready == true and v2.Enabled == true and v2.WorldReady == true and workspace:GetServerTimeNow() < (v2.EventEndsAt or 0))

                if (v84 == "LostPart1" or v84 == "LostPart2") and not v86 then
                    local v87 = v2

                    v86 = v87.State

                    if v86 then
                        local v88 = v2

                        v86 = v88.State.LostParts[v84]

                        if not v86 then
                            local v89 = v2

                            v86 = v89.State.Completed
                        end
                    end
                end

                local v90 = v86 == true

                if v85.Hidden ~= v90 then
                    v85.Hidden = v90

                    for _, v91 in v85.Parts do
                        v91.LocalTransparencyModifier = v90 and 1 or 0
                    end

                    if v90 and v85.Floating then
                        v85.Model:PivotTo(v85.BasePivot)
                    end
                end

                updateQuestIdle(v85)

                if v85.Prompt then
                    v85.Prompt.Enabled = not v86 and v2.Ready and not v51.IsPlaying(v85.Model) and not VaultSequence.IsPlaying()

                    if v2.Interactions and not v85.Floating then
                        v85.Prompt.MaxActivationDistance = v2.Interactions.NpcRadius
                    end
                end

                if v84 == "ExperimentVault" and v2.State then
                    local Completed = v2.State.Completed

                    if v85.Open ~= Completed and not VaultSequence.IsPlaying() then
                        VaultSequence.SetOpen(v85.Model, Completed)
                        v85.Open = Completed
                    end
                end
            end
        end

        local function registerQuest(p33) -- line: 514
            -- upvalues: VaultSequence (copy), t3 (copy), v2 (ref), v3 (ref), StolenVaultEvent (copy), v48 (copy), v49 (copy), v51 (copy), v52 (ref), loadQuestIdle (copy), syncQuest (copy)
            if StolenVaultEvent.Parent and p33:IsA("Model") and p33:IsDescendantOf(workspace) then
                local ScrambleQuestId = p33:GetAttribute("ScrambleQuestId")

                if type(ScrambleQuestId) ~= "string" then
                    return
                end

                local v92 = ScrambleQuestId == "LostPart1" or ScrambleQuestId == "LostPart2"
                local PrimaryPart = p33.PrimaryPart
                local v93 = if ScrambleQuestId == "EscapedExperiment" then p33:FindFirstChild("InteractionPoint", true) else nil
                local ClaimLostPart = if not v92 or not PrimaryPart then nil else PrimaryPart:FindFirstChild("ClaimLostPart")
                local v94 = t3[ScrambleQuestId]

                if v94 then
                    if v94.Model == p33 then
                        local Prompt = v94.Prompt

                        if ScrambleQuestId == "EscapedExperiment" then
                            if Prompt and Prompt.Parent == v93 and Prompt:IsDescendantOf(p33) then
                                return
                            end
                        elseif not v92 or Prompt and Prompt == ClaimLostPart and Prompt:IsDescendantOf(p33) then
                            return
                        end
                    end

                    if v94.IdleTrack then
                        v94.IdleTrack:Stop(0)
                        v94.IdleTrack:Destroy()
                        v94.IdleTrack = nil
                    end

                    if v94.Prompt and not v94.Floating then
                        v94.Prompt:Destroy()
                    end

                    t3[ScrambleQuestId] = nil
                end

                if PrimaryPart and PrimaryPart:IsDescendantOf(p33) then
                    if not (ScrambleQuestId ~= "EscapedExperiment" or v93 and v93:IsA("Attachment") and v93.Parent and v93.Parent:IsA("BasePart")) or not (not v92 or ClaimLostPart and ClaimLostPart:IsA("ProximityPrompt")) then
                        return
                    end

                    local t11 = {}

                    for _, descendant in p33:GetDescendants() do
                        if descendant:IsA("BasePart") then
                            table.insert(t11, descendant)
                        end
                    end

                    local t12 = {
                        Model = p33,
                        Parts = t11,
                        BasePivot = p33:GetPivot(),
                        Floating = v92,
                        Phase = ScrambleQuestId == "LostPart1" and 0 or 3.141592653589793,
                        Prompt = ClaimLostPart
                    }

                    t3[ScrambleQuestId] = t12

                    if ScrambleQuestId == "EscapedExperiment" then
                        loadQuestIdle(t12, ScrambleQuestId)
                    end

                    if ScrambleQuestId == "EscapedExperiment" and v93 then
                        local t13 = {
                            Name = "ScrambleTalk",
                            ActionText = "Talk",
                            ObjectText = "Escaped Experiment",
                            HoldDuration = 0,
                            Enabled = false,
                            RequiresLineOfSight = true
                        }
                        local ProximityPrompt = Instance.new("ProximityPrompt")

                        for v95, v96 in t13 do
                            ProximityPrompt[v95] = v96
                        end

                        ProximityPrompt.Parent = v93
                        t12.Prompt = ProximityPrompt
                        ProximityPrompt.Triggered:Connect(function() -- line: 595
                            -- upvalues: p33 (copy), ProximityPrompt (copy), VaultSequence (copy), v2 (ref), v3 (ref), v48 (copy), v49 (copy), v51 (copy), v52 (ref)
                            if v51.IsPlaying(p33) or VaultSequence.IsPlaying() then
                                return
                            end

                            local v97 = v2 and v2.State and v2.State.Discovered
                            local Discover = v3("Discover")

                            if Discover and Discover.Ok and v2 and v2.State then
                                if v2.State.TotalParts == 5 or v2.State.Completed or v97 and not v52 then
                                    v48.ShowVault()
                                else
                                    v52 = true
                                    v48.Close()
                                    v49.Close()
                                    v51.Start(p33, ProximityPrompt, function() -- line: 612
                                        -- upvalues: v48 (copy), v52 (ref)
                                        v52 = false
                                        v48.ShowVault()
                                    end)
                                end
                            end
                        end)
                    end

                    syncQuest()
                end
            end
        end

        local v98 = false

        local function v99() -- line: 625
            -- upvalues: v2 (ref), updateExperimentTimer (copy), updateRemovalTimers (copy), v48 (copy), v49 (copy), v50 (copy), QuestlineButton (copy), RiftButton (copy), v98 (ref), Save (copy), BossEventFlags (copy), RiftEligibility (copy), Constants (copy)
            local v100 = if v2 == nil then workspace:GetAttribute("ScrambleHUDUnlocked") == true and workspace:GetAttribute("ScrambleHUDAwaitingSammyOutro") ~= true else v2.ShowHUD == true
            local v101

            if v100 then
                local v102 = v2 ~= nil and v2.Ready == true and v2.Enabled == true and v2.WorldReady == true and workspace:GetServerTimeNow() < (v2.EventEndsAt or 0)

                if v102 then
                    local v103 = Save.Peek()

                    v101 = v103 ~= nil and RiftEligibility.IsEligible(v103.SpeedPower)
                else
                    v101 = v102
                end
            else
                v101 = v100
            end

            local v104 = BossEventFlags.ContentEnabled:Get()

            if v104 then
                local v105 = Save.Peek()

                v104 = v105 ~= nil and RiftEligibility.IsEligible(v105.SpeedPower)
            end

            for _, v106 in QuestlineButton do
                v106.Visible = v101
            end

            for _, v107 in RiftButton do
                v107.Visible = v104
            end

            local ServerTimeNow = workspace:GetServerTimeNow()

            updateExperimentTimer(ServerTimeNow)
            updateRemovalTimers(ServerTimeNow)

            if not v2 then
                return
            end

            v48.Update(v2)
            v49.Update(v2)

            if workspace:GetServerTimeNow() >= Constants.UPDATE_LIVE_AT then
                v50.Update(v2)
                v98 = true
            end
        end

        local function addDrops(p34) -- line: 640
            -- upvalues: LocalPlayer (copy), Scramble3 (copy), Folder (copy), t2 (copy), n1 (ref), label (copy), Players (copy), ReplicatedStorage (copy)
            for _, v108 in p34 do
                if not t2[v108.Id] and not (workspace:GetServerTimeNow() >= v108.ExpiresAt) then
                    local v109 = v108.OwnerUserId ~= nil and v108.OwnerUserId ~= LocalPlayer.UserId
                    local CurrentCamera = workspace.CurrentCamera

                    if v109 then
                        if not (n1 >= 64) and CurrentCamera and not ((CurrentCamera.CFrame.Position - v108.Origin).Magnitude > 180) then
                            local ScrambleCurrency = if v108.Kind == "Samples" then ReplicatedStorage.Assets:FindFirstChild("ScrambleCurrency") elseif v108.Kind == "Part" then Scramble3.Parts:FindFirstChild(v108.PartId) else nil

                            if ScrambleCurrency then
                                local clone = ScrambleCurrency:Clone()
                                local v110 = v108.VisualScale or 1
                                local t14 = {}

                                if clone:IsA("BasePart") then
                                    clone.Size *= v110

                                    local BillboardGui = clone:FindFirstChildWhichIsA("BillboardGui")

                                    if BillboardGui then
                                        BillboardGui.Adornee = clone

                                        local Size = BillboardGui.Size

                                        BillboardGui.Size = UDim2.new(Size.X.Scale * v110, Size.X.Offset * v110, Size.Y.Scale * v110, Size.Y.Offset * v110)
                                        table.insert(t14, clone)

                                        for _, v111 in t14 do
                                            v111.Anchored = true
                                            v111.CanCollide = false
                                            v111.CanTouch = false
                                            v111.CanQuery = false
                                        end

                                        clone:PivotTo(CFrame.new(v108.Origin))
                                        clone.Parent = Folder

                                        local elapsed = os.clock()

                                        v108.Model = clone
                                        v108.SpawnedAt = elapsed
                                        v108.NextTry = 0
                                        v108.Parts = t14
                                        v108.Observer = v109
                                        v108.Owner = Players:GetPlayerByUserId(v108.OwnerUserId)

                                        local v112 = n1

                                        n1 = v112 + 1

                                        if v108.MagnetAt then
                                            v108.MagnetDelay = v108.MagnetAt - v108.CreatedAt
                                        else
                                            v108.MagnetDelay = nil
                                        end

                                        t2[v108.Id] = v108

                                        if v108.Kind == "Samples" then
                                            v108.Billboard = BillboardGui
                                        else
                                            local PrimaryPart = clone.PrimaryPart
                                            local t15 = {
                                                StudsOffset = Vector3.new(0, 2, 0),
                                                AlwaysOnTop = false,
                                                MaxDistance = 100,
                                                Size = UDim2.fromOffset(160, 32)
                                            }
                                            local BillboardGui = Instance.new("BillboardGui")

                                            for v113, v114 in t15 do
                                                BillboardGui[v113] = v114
                                            end

                                            BillboardGui.Parent = PrimaryPart
                                            v108.Billboard = BillboardGui
                                            label(BillboardGui, "⚙️ DRONE PART", 32)
                                        end

                                        if v108.Hidden then
                                            for _, v115 in t14 do
                                                v115.LocalTransparencyModifier = 1
                                            end

                                            if v108.Billboard then
                                                v108.Billboard.Enabled = false
                                            end

                                            v108.Arrived = true
                                        end
                                    else
                                        clone:Destroy()
                                    end
                                else
                                    clone:ScaleTo(clone:GetScale() * v110)

                                    for _, descendant in clone:GetDescendants() do
                                        if descendant:IsA("BasePart") then
                                            table.insert(t14, descendant)
                                        end
                                    end

                                    for _, v116 in t14 do
                                        v116.Anchored = true
                                        v116.CanCollide = false
                                        v116.CanTouch = false
                                        v116.CanQuery = false
                                    end

                                    clone:PivotTo(CFrame.new(v108.Origin))
                                    clone.Parent = Folder

                                    local elapsed = os.clock()

                                    v108.Model = clone
                                    v108.SpawnedAt = elapsed
                                    v108.NextTry = 0
                                    v108.Parts = t14
                                    v108.Observer = v109
                                    v108.Owner = Players:GetPlayerByUserId(v108.OwnerUserId)

                                    local v117 = n1

                                    n1 = v117 + 1

                                    if v108.MagnetAt then
                                        v108.MagnetDelay = v108.MagnetAt - v108.CreatedAt
                                    else
                                        v108.MagnetDelay = nil
                                    end

                                    t2[v108.Id] = v108

                                    local BillboardGui

                                    if v108.Kind == "Samples" then
                                        v108.Billboard = BillboardGui
                                    else
                                        local PrimaryPart = clone.PrimaryPart
                                        local t16 = {
                                            StudsOffset = Vector3.new(0, 2, 0),
                                            AlwaysOnTop = false,
                                            MaxDistance = 100,
                                            Size = UDim2.fromOffset(160, 32)
                                        }
                                        local BillboardGui = Instance.new("BillboardGui")

                                        for v118, v119 in t16 do
                                            BillboardGui[v118] = v119
                                        end

                                        BillboardGui.Parent = PrimaryPart
                                        v108.Billboard = BillboardGui
                                        label(BillboardGui, "⚙️ DRONE PART", 32)
                                    end

                                    if v108.Hidden then
                                        for _, v120 in t14 do
                                            v120.LocalTransparencyModifier = 1
                                        end

                                        if v108.Billboard then
                                            v108.Billboard.Enabled = false
                                        end

                                        v108.Arrived = true
                                    end
                                end
                            end
                        end
                    else
                        local ScrambleCurrency = if v108.Kind == "Samples" then ReplicatedStorage.Assets:FindFirstChild("ScrambleCurrency") elseif v108.Kind == "Part" then Scramble3.Parts:FindFirstChild(v108.PartId) else nil

                        if ScrambleCurrency then
                            local clone = ScrambleCurrency:Clone()
                            local v121 = v108.VisualScale or 1
                            local t17 = {}

                            if clone:IsA("BasePart") then
                                clone.Size *= v121

                                local BillboardGui = clone:FindFirstChildWhichIsA("BillboardGui")

                                if BillboardGui then
                                    BillboardGui.Adornee = clone

                                    local Size = BillboardGui.Size

                                    BillboardGui.Size = UDim2.new(Size.X.Scale * v121, Size.X.Offset * v121, Size.Y.Scale * v121, Size.Y.Offset * v121)
                                    table.insert(t17, clone)

                                    for _, v122 in t17 do
                                        v122.Anchored = true
                                        v122.CanCollide = false
                                        v122.CanTouch = false
                                        v122.CanQuery = false
                                    end

                                    clone:PivotTo(CFrame.new(v108.Origin))
                                    clone.Parent = Folder

                                    local elapsed = os.clock()

                                    v108.Model = clone
                                    v108.SpawnedAt = elapsed
                                    v108.NextTry = 0
                                    v108.Parts = t17
                                    v108.Observer = v109
                                    v108.Owner = LocalPlayer

                                    if v108.MagnetAt then
                                        v108.MagnetDelay = v108.MagnetAt - v108.CreatedAt
                                    else
                                        v108.MagnetDelay = nil
                                    end

                                    t2[v108.Id] = v108

                                    if v108.Kind == "Samples" then
                                        v108.Billboard = BillboardGui
                                    else
                                        local PrimaryPart = clone.PrimaryPart
                                        local t18 = {
                                            StudsOffset = Vector3.new(0, 2, 0),
                                            AlwaysOnTop = false,
                                            MaxDistance = 100,
                                            Size = UDim2.fromOffset(160, 32)
                                        }
                                        local BillboardGui = Instance.new("BillboardGui")

                                        for v123, v124 in t18 do
                                            BillboardGui[v123] = v124
                                        end

                                        BillboardGui.Parent = PrimaryPart
                                        v108.Billboard = BillboardGui
                                        label(BillboardGui, "⚙️ DRONE PART", 32)
                                    end

                                    if v108.Hidden then
                                        for _, v125 in t17 do
                                            v125.LocalTransparencyModifier = 1
                                        end

                                        if v108.Billboard then
                                            v108.Billboard.Enabled = false
                                        end

                                        v108.Arrived = true
                                    end
                                else
                                    clone:Destroy()
                                end
                            else
                                clone:ScaleTo(clone:GetScale() * v121)

                                for _, descendant in clone:GetDescendants() do
                                    if descendant:IsA("BasePart") then
                                        table.insert(t17, descendant)
                                    end
                                end

                                for _, v126 in t17 do
                                    v126.Anchored = true
                                    v126.CanCollide = false
                                    v126.CanTouch = false
                                    v126.CanQuery = false
                                end

                                clone:PivotTo(CFrame.new(v108.Origin))
                                clone.Parent = Folder

                                local elapsed = os.clock()

                                v108.Model = clone
                                v108.SpawnedAt = elapsed
                                v108.NextTry = 0
                                v108.Parts = t17
                                v108.Observer = v109
                                v108.Owner = LocalPlayer

                                if v108.MagnetAt then
                                    v108.MagnetDelay = v108.MagnetAt - v108.CreatedAt
                                else
                                    v108.MagnetDelay = nil
                                end

                                t2[v108.Id] = v108

                                local BillboardGui

                                if v108.Kind == "Samples" then
                                    v108.Billboard = BillboardGui
                                else
                                    local PrimaryPart = clone.PrimaryPart
                                    local t19 = {
                                        StudsOffset = Vector3.new(0, 2, 0),
                                        AlwaysOnTop = false,
                                        MaxDistance = 100,
                                        Size = UDim2.fromOffset(160, 32)
                                    }
                                    local BillboardGui = Instance.new("BillboardGui")

                                    for v127, v128 in t19 do
                                        BillboardGui[v127] = v128
                                    end

                                    BillboardGui.Parent = PrimaryPart
                                    v108.Billboard = BillboardGui
                                    label(BillboardGui, "⚙️ DRONE PART", 32)
                                end

                                if v108.Hidden then
                                    for _, v129 in t17 do
                                        v129.LocalTransparencyModifier = 1
                                    end

                                    if v108.Billboard then
                                        v108.Billboard.Enabled = false
                                    end

                                    v108.Arrived = true
                                end
                            end
                        end
                    end
                end
            end
        end

        local function v130(p35) -- line: 732
            -- upvalues: VaultSequence (copy), v2 (ref), n2 (ref), n3 (ref), t6 (ref), v4 (ref), v48 (copy), syncQuest (copy), v99 (copy), addDrops (copy)
            if not p35 then
                return
            end

            if p35.Drones and v4 then
                v4.Apply(p35.Drones)
            end

            local Revision = p35.Revision

            if typeof(Revision) ~= "number" then
                return
            end

            if n2 < Revision then
                n2 = Revision
                t6 = {
                    State = p35.State,
                    Ready = p35.Ready
                }
            end

            if not p35.Patch and n3 < Revision then
                n3 = Revision
                v2 = p35

                if p35.Drops then
                    addDrops(p35.Drops)
                end
            end

            if v2 and t6 then
                local v131 = v2

                v131.State = t6.State

                local v132 = v2

                v132.Ready = t6.Ready

                if v2 == nil or v2.Ready ~= true or v2.Enabled ~= true or v2.WorldReady ~= true or not (workspace:GetServerTimeNow() < (v2.EventEndsAt or 0)) then
                    VaultSequence.Stop(false)
                    v48.Close()
                end

                v99()
                syncQuest()
            end
        end

        local v133 = false

        v3 = function(p36, p37, p38) -- line: 767
            -- upvalues: v130 (copy), v133 (ref), Scramble (copy)
            if v133 then
                return nil
            end

            v133 = true

            local function v134() -- line: 772
                -- upvalues: p36 (copy), p37 (copy), p38 (copy), Scramble (copy)
                return Scramble.Request:InvokeServer(p36, p37, p38)
            end

            local ok, result = pcall(v134)

            v133 = false

            if not ok or not result then
                return nil
            end

            v130(result.Snapshot)

            return result
        end

        local function registerDrone(p39) -- line: 782
            -- upvalues: Scramble2 (copy), Scramble3 (copy), Folder (copy), t4 (copy), t5 (copy), label (copy), TweenService (copy), ScrambleMotion (copy), DroneVisual (copy)
            if p39:IsA("Model") and not t4[p39] and p39:IsDescendantOf(workspace) then
                local Hitbox = p39:FindFirstChild("Hitbox")
                local v135 = ScrambleMotion.Read(p39)

                if not (Hitbox and Hitbox:IsA("BasePart") and v135) then
                    return
                end

                local t20 = {}
                local t21 = {}
                local v136

                if p39:GetAttribute("ScrambleAnimatedRig") == true then
                    local v137 = Scramble3.Drones:FindFirstChild(p39:GetAttribute("ScrambleTier"))

                    if not v137 then
                        return
                    end

                    v136 = DroneVisual.new(p39, v137, Folder)
                end

                local v138 = if v136 then v136.Root else Hitbox

                for _, descendant in p39:GetDescendants() do
                    if descendant:IsA("BasePart") and descendant ~= Hitbox then
                        table.insert(t20, descendant)
                        table.insert(t21, v135.Home:ToObjectSpace(descendant.CFrame))

                        if descendant.Name == "Body" then
                            v138 = descendant
                        end
                    end
                end

                local BoundingBox, BoundingBox2 = (if v136 then v136.Rig else p39):GetBoundingBox()
                local v141 = (math.abs(BoundingBox.RightVector.Y) * BoundingBox2.X + math.abs(BoundingBox.UpVector.Y) * BoundingBox2.Y + math.abs(BoundingBox.LookVector.Y) * BoundingBox2.Z) / 2
                local v142 = BoundingBox.Position.Y + v141 - v138.Position.Y
                local t22 = {
                    Name = "ScrambleHealth",
                    MaxDistance = 100,
                    AlwaysOnTop = true,
                    LightInfluence = 0,
                    Adornee = v138,
                    Size = UDim2.fromScale(10, 2.2),
                    StudsOffsetWorldSpace = Vector3.new(0, v142 + 2 + 1.1, 0)
                }
                local BillboardGui = Instance.new("BillboardGui")

                for v144, v145 in t22 do
                    BillboardGui[v144] = v145
                end

                BillboardGui.Parent = v138

                local v146 = label(BillboardGui, "DR. SCRAMBLE EXPERIMENT", 26)

                v146.Size = UDim2.fromScale(1, 0.45)
                v146.TextScaled = true

                local clone = Scramble2.Progress:Clone()
                local zero = Vector2.zero

                clone.Name = "HealthProgress"
                clone.AnchorPoint = zero

                local v147 = UDim2.fromScale(0.05, 0.53)
                local v148 = UDim2.fromScale(0.9, 0.41)

                clone.Position = v147
                clone.Size = v148
                clone.Parent = BillboardGui

                local t23 = {
                    Tween = nil,
                    Billboard = BillboardGui,
                    Flight = v135,
                    Parts = t20,
                    Offsets = t21,
                    Animated = v136
                }

                local function update(p40) -- line: 843
                    -- upvalues: Hitbox (copy), clone (copy), t23 (copy), TweenService (copy)
                    local v149 = Hitbox:GetAttribute("Health") or 0
                    local v150 = Hitbox:GetAttribute("MaxHealth") or 1
                    local v152 = math.clamp(v149 / math.max(v150, 1), 0, 1)

                    clone.TextLabel.Text = string.format("%d / %d HP", math.max(0, (math.ceil(v149))), (math.max(1, (math.ceil(v150)))))
                    clone.Fill.Visible = v152 > 0

                    if t23.Tween then
                        t23.Tween:Cancel()
                    end

                    if p40 then
                        clone.Fill.Size = UDim2.fromScale(v152, 1)
                    else
                        t23.Tween = TweenService:Create(clone.Fill, TweenInfo.new(0.15), {
                            Size = UDim2.fromScale(v152, 1)
                        })
                        t23.Tween:Play()
                    end
                end

                t23.Connection = Hitbox:GetAttributeChangedSignal("Health"):Connect(update)
                t23.Id = p39:GetAttribute("ScrambleDroneId")
                t23.DamageHeight = math.max(2, v142 * 0.85)
                t4[p39] = t23
                t5[t23.Id] = t23
                update(true)
            end
        end

        local function burst(p41, p42, p43) -- line: 874
            -- upvalues: Folder (copy), Debris (copy)
            local t24 = {
                Anchored = true,
                CanCollide = false,
                CanTouch = false,
                CanQuery = false,
                Transparency = 1,
                Size = Vector3.new(1, 1, 1),
                Position = p41
            }
            local Part = Instance.new("Part")

            for v157, v158 in t24 do
                Part[v157] = v158
            end

            Part.Parent = Folder

            local t25 = {
                Texture = "rbxasset://textures/particles/sparkles_main.dds",
                Rate = 0,
                LightEmission = 0.6,
                Color = ColorSequence.new(p42),
                Lifetime = NumberRange.new(0.35, 0.9),
                Speed = NumberRange.new(5, 12),
                SpreadAngle = Vector2.new(180, 180),
                Size = NumberSequence.new(0.5)
            }
            local ParticleEmitter = Instance.new("ParticleEmitter")

            for v159, v160 in t25 do
                ParticleEmitter[v159] = v160
            end

            ParticleEmitter.Parent = Part
            ParticleEmitter:Emit(p43 or 24)
            Debris:AddItem(Part, 1.5)
        end

        local function droneBreakBurst(p44) -- line: 897
            -- upvalues: Folder (copy), v6 (copy), Debris (copy), Emit (copy), Break (copy)
            local t26 = {
                Name = "ScrambleDroneBreak",
                Anchored = true,
                CanCollide = false,
                CanTouch = false,
                CanQuery = false,
                CastShadow = false,
                Transparency = 1,
                Size = Vector3.new(1, 1, 1),
                Position = p44
            }
            local Part = Instance.new("Part")

            for v161, v162 in t26 do
                Part[v161] = v162
            end

            Part.Parent = Folder

            for _, descendant in Break:GetDescendants() do
                if descendant:IsA("ParticleEmitter") then
                    local EmitCount = descendant:GetAttribute("EmitCount")

                    if typeof(EmitCount) ~= "number" then
                        EmitCount = descendant.Rate
                    end

                    if EmitCount > 0 then
                        local clone = descendant:Clone()

                        clone.Enabled = false
                        clone.Color = ColorSequence.new(v6, Color3.fromRGB(225, 255, 200))
                        clone.Parent = Part
                    end
                end
            end

            Debris:AddItem(Part, Emit(Part) + 0.1)
        end

        local function effect(p45, p46, p47) -- line: 925
            -- upvalues: Audio (copy), VaultSequence (copy), t3 (copy), t5 (copy), v1 (copy), v6 (copy), v48 (copy), v49 (copy), v51 (copy), Toast (copy), syncQuest (copy), droneBreakBurst (copy), ReplicatedStorage (copy)
            if p45 == "Hit" then
                local v163 = type(p47) == "table" and t5[p47.DroneId]

                if v163 and v163.Animated and type(p47.Amount) == "number" and p47.Amount > 0 then
                    v163.Animated:ReceiveHit(p47.Motion)
                    v1.Hit(v163.Animated.Rig, v163.Animated.Root.Position + Vector3.new(0, v163.DamageHeight, 0), p47.Amount)
                end
            elseif p45 == "Break" then
                droneBreakBurst(p46)
                Audio.Play(ReplicatedStorage.Assets.Sounds.LightVsDarknessSounds.CollectNormalRing, p46, {
                    Volume = 0.55
                })
            elseif p45 == "Rare" then
                Toast.Show({
                    Text = "🚨 A FORBIDDEN EXPERIMENT HAS APPEARED!",
                    Seconds = 2.5,
                    SingleLine = true,
                    Unique = true,
                    Color = v6
                })
            elseif p45 == "Samples" then
                local v164 = "+" .. tostring(p47.Amount) .. " 🧪 Samples"

                Toast.Show({
                    Seconds = 2.5,
                    SingleLine = true,
                    Unique = true,
                    Text = v164,
                    Color = v6
                })
            elseif p45 == "VaultStart" then
                v48.Close()
                v49.Close()
                v51.Close()

                local ExperimentVault = t3.ExperimentVault

                if ExperimentVault then
                    VaultSequence.Start(ExperimentVault.Model, p47)
                end

                syncQuest()
            elseif p45 == "VaultFinish" then
                VaultSequence.Finish(p47.Id, p47.Granted == true)

                local ExperimentVault = t3.ExperimentVault

                if ExperimentVault then
                    ExperimentVault.Open = nil
                end
            end
        end

        Scramble.State.OnClientEvent:Connect(v130)
        Scramble.Drops.OnClientEvent:Connect(addDrops)
        Scramble.RemoveDrops.OnClientEvent:Connect(function(p48) -- line: 966
            -- upvalues: t2 (copy), n1 (ref)
            for _, v165 in p48 do
                local v166 = t2[v165]

                if v166 then
                    if v166.Observer then
                        n1 -= 1
                    end

                    v166.Model:Destroy()
                    t2[v165] = nil
                end
            end
        end)
        Scramble.Effect.OnClientEvent:Connect(effect)
        CollectionService:GetInstanceAddedSignal("ScrambleQuest"):Connect(registerQuest)
        CollectionService:GetInstanceRemovedSignal("ScrambleQuest"):Connect(function(p49) -- line: 973
            -- upvalues: t3 (copy)
            for v167, v168 in t3 do
                if v168.Model == p49 then
                    if v168.IdleTrack then
                        v168.IdleTrack:Stop(0)
                        v168.IdleTrack:Destroy()
                        v168.IdleTrack = nil
                    end

                    if v168.Prompt and not v168.Floating then
                        v168.Prompt:Destroy()
                    end

                    t3[v167] = nil
                end
            end
        end)

        local function removeDrone(p50) -- line: 981
            -- upvalues: t4 (copy), t5 (copy)
            local v169 = t4[p50]

            if not v169 then
                return
            end

            v169.Connection:Disconnect()

            if v169.Tween then
                v169.Tween:Cancel()
            end

            v169.Billboard:Destroy()

            if v169.Animated then
                v169.Animated:Destroy()
            end

            t5[v169.Id] = nil
            t4[p50] = nil
        end

        v4 = require(script.PersonalDrones).new(Folder, registerDrone, removeDrone)

        local connection = Scramble.Drones.OnClientEvent:Connect(v4.Apply)

        for _, v170 in CollectionService:GetTagged("ScrambleQuest") do
            registerQuest(v170)
        end

        local t27 = {
            Anchored = true,
            CanCollide = false,
            CanTouch = false,
            CanQuery = false,
            Transparency = 1,
            Size = Vector3.new(30, 8, 30),
            Position = Vector3.new(0, -10000, 0)
        }
        local Part = Instance.new("Part")

        for v171, v172 in t27 do
            Part[v171] = v172
        end

        Part.Parent = Folder

        local t28 = {
            Texture = "rbxasset://textures/particles/sparkles_main.dds",
            Enabled = false,
            Rate = 8,
            Color = ColorSequence.new(v6),
            Lifetime = NumberRange.new(1, 2),
            Speed = NumberRange.new(0.1, 0.5),
            Size = NumberSequence.new(0.15),
            Transparency = NumberSequence.new(0.65),
            SpreadAngle = Vector2.new(180, 180)
        }
        local ParticleEmitter = Instance.new("ParticleEmitter")

        for v173, v174 in t28 do
            ParticleEmitter[v173] = v174
        end

        ParticleEmitter.Parent = Part

        local function inEventBiome(p51) -- line: 1023
            -- upvalues: v2 (ref)
            if not (v2 and v2.Window.Active) then
                return false
            end

            local World = workspace:FindFirstChild("World")
            local Areas = World and World:FindFirstChild("Areas")
            local GuardAreas = Areas and Areas:FindFirstChild("GuardAreas")

            if GuardAreas then
                for _, v175 in v2.Areas or {} do
                    local v176 = GuardAreas:FindFirstChild(v175)
                    local Bounds = v176 and v176:FindFirstChild("Bounds")

                    if Bounds and Bounds:IsA("BasePart") and v176:GetAttribute("ZoneHidden") ~= true then
                        local v177 = Bounds.CFrame:PointToObjectSpace(p51)
                        local v178 = Bounds.Size / 2

                        if math.abs(v177.X) < v178.X and math.abs(v177.Z) < v178.Z and math.abs(v177.Y) < 35 then
                            return true
                        end
                    end
                end
            end

            return false
        end

        local v179 = false
        local clone, DrScrambleVFX

        local function updateOutbreakPresentation() -- line: 1048
            -- upvalues: LightingController (copy), MusicDirector (copy), LocalPlayer (copy), Scramble3 (copy), Folder (copy), inEventBiome (copy), v179 (ref), clone (ref), DrScrambleVFX (ref)
            local ScrambleOutbreakEndsAt = workspace:GetAttribute("ScrambleOutbreakEndsAt")
            local v180 = LocalPlayer and LocalPlayer.Character
            local Humanoid = v180 and v180:FindFirstChildOfClass("Humanoid")
            local HumanoidRootPart = if not (Humanoid and Humanoid.Health > 0) then nil else v180:FindFirstChild("HumanoidRootPart")
            local v181 = workspace:GetAttribute("ScrambleOutbreakActive") == true and type(ScrambleOutbreakEndsAt) == "number" and workspace:GetServerTimeNow() < ScrambleOutbreakEndsAt and HumanoidRootPart ~= nil and inEventBiome(HumanoidRootPart.Position)
            local DrScrambleVFX2 = Scramble3:FindFirstChild("DrScrambleVFX")

            if clone and (not v181 or DrScrambleVFX ~= DrScrambleVFX2) then
                clone:Destroy()
                clone = nil
                DrScrambleVFX = nil
            end

            if v181 and DrScrambleVFX2 and not clone then
                DrScrambleVFX = DrScrambleVFX2
                clone = DrScrambleVFX2:Clone()
                clone.Parent = Folder
            end

            if v181 == v179 then
                return
            end

            v179 = v181
            MusicDirector.SetScrambleActive(v181)

            if not (v181 and LightingController.Presets.DrScramble) then
                LightingController.ClearLayer("DrScrambleOutbreak", 1)
            else
                LightingController.SetLayer("DrScrambleOutbreak", "DrScramble", 140, 1)
            end
        end

        local n6 = 0
        local n7 = 0
        local t29 = {}
        local t30 = {}
        local connection2 = RunService.RenderStepped:Connect(function(p52) -- line: 1079
            -- upvalues: Audio (copy), t2 (copy), t3 (copy), t4 (copy), v1 (copy), n1 (ref), v6 (copy), burst (copy), n6 (ref), n7 (ref), t29 (copy), t30 (copy), ReplicatedStorage (copy), ScrambleMotion (copy), ScramblePickupMotion (copy)
            n6 += p52

            local CurrentCamera = workspace.CurrentCamera
            local elapsed = os.clock()
            local ServerTimeNow = workspace:GetServerTimeNow()

            v1.Step(p52)
            table.clear(t29)
            table.clear(t30)

            for v182, v183 in t4 do
                local v184 = v182.Parent ~= nil and CurrentCamera ~= nil and (CurrentCamera.CFrame.Position - v182:GetPivot().Position).Magnitude < 180

                if v183.Animated then
                    local v185 = v183.Animated:Step(v183.Flight, ServerTimeNow, v184)

                    v183.Billboard.Enabled = v184 and (not v183.Animated.State or v183.Animated.State.Name ~= "Death")

                    if v184 and (not v183.Animated.State or v183.Animated.State.Name ~= "Death") then
                        table.insert(t29, v183.Animated.Root)
                        table.insert(t30, v185)
                    end
                elseif v184 then
                    local v186 = ScrambleMotion.Pose(v183.Flight, ServerTimeNow)

                    for v187, v188 in v183.Parts do
                        table.insert(t29, v188)
                        table.insert(t30, v186 * v183.Offsets[v187])
                    end
                end
            end

            if #t29 > 0 then
                workspace:BulkMoveTo(t29, t30, Enum.BulkMoveMode.FireCFrameChanged)
            end

            if n6 >= 0.03333333333333333 then
                n6 %= 0.03333333333333333

                for _, v190 in t3 do
                    if v190.Floating and not v190.Hidden and CurrentCamera and (CurrentCamera.CFrame.Position - v190.BasePivot.Position).Magnitude < 100 then
                        v190.Model:PivotTo(CFrame.new(0, math.sin(elapsed * 1.8 + v190.Phase) * 0.25 + 1.4, 0) * v190.BasePivot * CFrame.Angles(0, elapsed * 0.5, 0))
                    end
                end
            end

            for v192, v193 in t2 do
                if not v193.Arrived then
                    local v194 = elapsed - v193.SpawnedAt
                    local Owner = v193.Owner
                    local v195 = Owner and Owner.Character
                    local Humanoid = v195 and v195:FindFirstChildOfClass("Humanoid")
                    local HumanoidRootPart = if Humanoid and Humanoid.Health > 0 then v195:FindFirstChild("HumanoidRootPart") else nil

                    if v193.MagnetDelay and v193.MagnetDelay <= v194 and HumanoidRootPart then
                        v193.MagnetStarted = v193.MagnetStarted or elapsed

                        local v197 = math.clamp((elapsed - v193.MagnetStarted) / ScramblePickupMotion.MagnetSeconds, 0, 1)
                        local v198 = ScramblePickupMotion.MagnetPosition(v193.Position, HumanoidRootPart.Position, v197)

                        v193.Model:PivotTo(CFrame.new(v198) * CFrame.Angles(0, v194 * 8, 0))

                        if v197 == 1 then
                            v193.Arrived = true

                            if v193.Observer then
                                local v199 = t2[v192]

                                if v199 then
                                    if v199.Observer then
                                        n1 -= 1
                                    end

                                    v199.Model:Destroy()
                                    t2[v192] = nil
                                end
                            else
                                for _, v200 in v193.Parts do
                                    v200.LocalTransparencyModifier = 1
                                end

                                if v193.Billboard then
                                    v193.Billboard.Enabled = false
                                end

                                if elapsed - n7 > 0.09 then
                                    n7 = elapsed
                                    burst(HumanoidRootPart.Position, v6, 6)
                                    Audio.Play(ReplicatedStorage.Assets.Sounds.LightVsDarknessSounds.CollectNormalRing, HumanoidRootPart, {
                                        Volume = 0.35
                                    })
                                end
                            end
                        end
                    elseif not v193.Landed then
                        local v201 = ScramblePickupMotion.GroundPosition(v193.Origin, v193.Position, v194)

                        v193.Model:PivotTo(CFrame.new(v201) * CFrame.Angles(0, math.min(v194, ScramblePickupMotion.MagnetDelay) * 4, 0))

                        if ScramblePickupMotion.MagnetDelay <= v194 then
                            v193.Landed = true
                        end
                    end
                end
            end
        end)

        Save.WatchFields("SpeedPower", updateEventButtons)
        BossEventFlags.ContentEnabled.Changed:Connect(updateEventButtons)
        RiftFlags.SpeedPowerRequirement.Changed:Connect(updateEventButtons)
        workspace:GetAttributeChangedSignal("ScrambleHUDUnlocked"):Connect(updateEventButtons)
        workspace:GetAttributeChangedSignal("ScrambleHUDAwaitingSammyOutro"):Connect(updateEventButtons)
        task.spawn(function() -- line: 1182
            -- upvalues: LocalPlayer (copy), t2 (copy), n1 (ref), v2 (ref), n4 (ref), v4 (ref), v5 (copy), updateExperimentTimer (copy), updateRemovalTimers (copy), StolenVaultEvent (copy), v48 (copy), v49 (copy), v51 (copy), QuestlineButton (copy), RiftButton (copy), updateAutoAttack (copy), syncQuest (copy), registerQuest (copy), v98 (ref), v99 (copy), Part (copy), ParticleEmitter (copy), inEventBiome (copy), updateOutbreakPresentation (copy), CollectionService (copy), Scramble (copy), Save (copy), BossEventFlags (copy), RiftEligibility (copy), Constants (copy)
            local v203 = n4

            while StolenVaultEvent.Parent and v203 == n4 do
                local v204 = LocalPlayer and LocalPlayer.Character
                local Humanoid = v204 and v204:FindFirstChildOfClass("Humanoid")
                local HumanoidRootPart = if not (Humanoid and Humanoid.Health > 0) then nil else v204:FindFirstChild("HumanoidRootPart")
                local ServerTimeNow = workspace:GetServerTimeNow()
                local t31 = {}

                for v205, v206 in t2 do
                    if v206.ExpiresAt <= ServerTimeNow or v206.Observer and os.clock() - v206.SpawnedAt > 8 then
                        local v207 = t2[v205]

                        if v207 then
                            if v207.Observer then
                                n1 -= 1
                            end

                            v207.Model:Destroy()
                            t2[v205] = nil
                        end
                    elseif not v206.Observer and HumanoidRootPart and #t31 < 8 and v206.CollectAfter <= ServerTimeNow and os.clock() >= v206.NextTry and (if v206.MagnetAt then v206.Arrived else (HumanoidRootPart.Position - v206.Position).Magnitude <= (v206.Radius or 0)) then
                        v206.NextTry = os.clock() + 1
                        table.insert(t31, v205)
                    end
                end

                if #t31 > 0 then
                    Scramble.Collect:FireServer(t31)
                end

                if not (HumanoidRootPart and inEventBiome(HumanoidRootPart.Position)) then
                    Part.Position = Vector3.new(0, -10000, 0)
                    ParticleEmitter.Enabled = false
                else
                    Part.Position = HumanoidRootPart.Position
                    ParticleEmitter.Enabled = true
                end

                updateOutbreakPresentation()
                v4.Tick()
                updateAutoAttack()
                v5.Tick(v2 ~= nil and v2.Ready == true and v2.Enabled == true and v2.WorldReady == true and workspace:GetServerTimeNow() < (v2.EventEndsAt or 0))

                for _, v209 in CollectionService:GetTagged("ScrambleQuest") do
                    registerQuest(v209)
                end

                syncQuest()

                local v210 = if v2 == nil then workspace:GetAttribute("ScrambleHUDUnlocked") == true and workspace:GetAttribute("ScrambleHUDAwaitingSammyOutro") ~= true else v2.ShowHUD == true
                local v211

                if v210 then
                    local v212 = v2 ~= nil and v2.Ready == true and v2.Enabled == true and v2.WorldReady == true and workspace:GetServerTimeNow() < (v2.EventEndsAt or 0)

                    if v212 then
                        local v213 = Save.Peek()

                        v211 = v213 ~= nil and RiftEligibility.IsEligible(v213.SpeedPower)
                    else
                        v211 = v212
                    end
                else
                    v211 = v210
                end

                local v214 = BossEventFlags.ContentEnabled:Get()

                if v214 then
                    local v215 = Save.Peek()

                    v214 = v215 ~= nil and RiftEligibility.IsEligible(v215.SpeedPower)
                end

                for _, v216 in QuestlineButton do
                    v216.Visible = v211
                end

                for _, v217 in RiftButton do
                    v217.Visible = v214
                end

                v51.Tick(v2 ~= nil and v2.Ready == true and v2.Enabled == true and v2.WorldReady == true and workspace:GetServerTimeNow() < (v2.EventEndsAt or 0))
                v48.Tick(ServerTimeNow)
                v49.Tick(ServerTimeNow)
                updateExperimentTimer(ServerTimeNow)
                updateRemovalTimers(ServerTimeNow)

                if v2 and not v98 then
                    local v218 = workspace:GetServerTimeNow() >= Constants.UPDATE_LIVE_AT

                    if v218 then
                        v99()
                    end
                end

                task.wait(0.2)
            end
        end)
        task.spawn(function() -- line: 1240
            -- upvalues: v2 (ref), v4 (ref), StolenVaultEvent (copy), v130 (copy), Scramble (copy)
            while StolenVaultEvent.Parent and (not v2 or not v2.Ready or not v4.Ready()) do
                local function v219() -- line: 1242
                    -- upvalues: Scramble (copy)
                    return Scramble.Request:InvokeServer("Snapshot")
                end

                local ok, result = pcall(v219)

                if ok then
                    v130(result)
                end

                if not (v2 and v2.Ready and v4.Ready()) then
                    task.wait(2)
                end
            end
        end)
        StolenVaultEvent.Destroying:Connect(function() -- line: 1253
            -- upvalues: LightingController (copy), MusicDirector (copy), VaultSequence (copy), Folder (copy), t3 (copy), t4 (copy), v1 (copy), n4 (ref), v4 (ref), v5 (copy), ExperimentTimer (copy), t7 (copy), v48 (copy), v49 (copy), v50 (copy), v51 (copy), QuestlineButton (copy), RiftButton (copy), t10 (copy), connection (copy), connection2 (copy)
            VaultSequence.Stop(false)
            MusicDirector.SetScrambleActive(false)
            LightingController.ClearLayer("DrScrambleOutbreak", 1)

            for _, v220 in t10 do
                v220()
            end

            for _, v221 in QuestlineButton do
                v221.Visible = false
            end

            for _, v222 in RiftButton do
                v222.Visible = false
            end

            for _, v223 in t3 do
                if v223.IdleTrack then
                    v223.IdleTrack:Stop(0)
                    v223.IdleTrack:Destroy()
                    v223.IdleTrack = nil
                end

                if v223.Prompt and not v223.Floating then
                    v223.Prompt:Destroy()
                end
            end

            table.clear(t3)

            for _, v224 in ExperimentTimer do
                v224.Visible = false
            end

            for _, v225 in t7 do
                v225.Label.Visible = false
            end

            n4 += 1
            v51.Destroy()
            v48.Destroy()
            v49.Destroy()
            v50.Destroy()
            v5.Destroy()
            connection:Disconnect()
            v4.Destroy()
            connection2:Disconnect()
            v1.Destroy()

            for _, v226 in t4 do
                v226.Connection:Disconnect()

                if v226.Tween then
                    v226.Tween:Cancel()
                end

                v226.Billboard:Destroy()

                if v226.Animated then
                    v226.Animated:Destroy()
                end
            end

            Folder:Destroy()
        end)
    end
}
