-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")
local SoundService = game:GetService("SoundService")
local BossEventFlags = require(ReplicatedStorage.Shared.Flags.BossEventFlags)
local BossEvent = require(ReplicatedStorage.Data.BossEvent)
local HiddenUIHandler = require(ReplicatedStorage.Client.HiddenUIHandler)
local LightingController = require(ReplicatedStorage.Controllers.Game.LightingController)
local Notifications = require(ReplicatedStorage.Client.Notifications)
local Pads = require(ReplicatedStorage.Client.WorldFX.Pads)
local Player = require(ReplicatedStorage.Shared.Player)
local Remotes = require(ReplicatedStorage.Shared.Remotes)
local RiftEligibility = require(ReplicatedStorage.Shared.Util.RiftEligibility)
local RiftFlags = require(ReplicatedStorage.Shared.Flags.RiftFlags)
local Save = require(ReplicatedStorage.Shared.Save)
local Tabs = require(ReplicatedStorage.Client.Tabs)
local Trove = require(ReplicatedStorage.Packages.Trove)
local VFX = require(ReplicatedStorage.Shared.Utils.VFX)
local t1 = {
    ARENA_MODEL_NAME = "BossArena",
    PORTAL_MODEL_NAME = "BossArenaTeleport",
    FLOOR_NAME = "Floor",
    BOSS_MODEL_NAME = "Boss",
    OUTLINE_PART_NAME = "Cube.030",
    IN_ARENA_ATTRIBUTE = "InBossArena",
    ATTACKING_ATTRIBUTE = "Attacking",
    SPAWNING_ATTRIBUTE = "Spawning",
    LIGHTING_LAYER = "RiftBoss",
    LIGHTING_RANK = 150,
    LIGHTING_SPAN = 2,
    FLASH_COLOR = Color3.fromRGB(255, 0, 0),
    FLASH_INFO = TweenInfo.new(5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
    BLACK_HOLE_COLOR = Color3.fromRGB(255, 40, 40),
    BLACK_HOLE_RADIUS = 20,
    BLACK_HOLE_THICKNESS = 2,
    BLACK_HOLE_HOVER = 0.15,
    BLACK_HOLE_TRANSPARENCY = 0.3,
    BLACK_HOLE_FADED_TRANSPARENCY = 0.8,
    BLACK_HOLE_PULSE = TweenInfo.new(0.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true),
    BLACK_HOLE_START_DELAY = 5,
    BLACK_HOLE_WINDUP_SECONDS = 4,
    BLACK_HOLE_RETRACT_SECONDS = 3,
    BLACK_HOLE_FOLLOW_SPEED_FRACTION = 0.4,
    BLACK_HOLE_HIT_INTERVAL = 1,
    VFX_FOLDER_NAME = "BossFightVFX",
    DEBRIS_FOLDER_NAME = "Transient",
    BLACK_HOLE_VFX_NAME = "BlackholeVFX",
    BLACK_HOLE_VFX_ROTATION = CFrame.Angles(0, 0, -1.5707963267948966),
    BLACK_HOLE_SPAWN_SOUND_NAME = "Blackhole Spawn",
    BLACK_HOLE_LOOP_SOUND_NAME = "Black Hole Loop Sound",
    BLACK_HOLE_LOOP_VOLUME = 2.5,
    GROUND_PROBE_HEIGHT = 50,
    TURN_SPEED = 3,
    MUSIC_NAME = "BossArenaMusic",
    MUSIC_VOLUME = 0.5,
    MUSIC_FADE_INFO = TweenInfo.new(1.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
    MUSIC_DEFEAT_FADE_INFO = TweenInfo.new(10, Enum.EasingStyle.Linear, Enum.EasingDirection.Out),
    UI_NAME = "BossFightUI",
    UI_WAIT_SECONDS = 5,
    COUNTDOWN_UI_NAME = "BossSpawningCountdown",
    COUNTDOWN_TEXT_FORMAT = "%s is spawning in: <font color=\"#C500FF\">%d</font>",
    BAR_INFO = TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
    PHANTOM_INFO = TweenInfo.new(0.6, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, 0, false, 0.35),
    UI_FLASH_COLOR = Color3.new(1, 1, 1),
    UI_FLASH_INFO = TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
    UI_SHAKE_SECONDS = 0.3,
    UI_SHAKE_PIXELS = 6,
    BOSS_SPAWN_NAME = "BossSpawn",
    PHASE_TWO_AT_ATTRIBUTE = "PhaseTwoAt",
    HAND_BONE_NAME = "UpperHand1.R",
    HEALTH_GUI_NAME = "Health",
    ARM_HITS_ATTRIBUTE = "BossArmHits",
    ARM_BEAM_HIT_LIMIT = 5,
    EXTRA_FOLDER_NAME = "Extra",
    GUIDE_BEAM_NAME = "TutorialBeam",
    SHOP_STAND_NAME = "BossShopStand",
    SHOP_ZONE_NAME = "Zone",
    SHOP_TAB_NAME = "BossShop",
    SHOP_BEAM_LIFT = 4,
    CRYSTAL_FOLDER_NAME = "CrystalTowers",
    CRYSTAL_HITBOX_NAME = "Hitbox",
    CRYSTAL_HEALTH_ATTRIBUTE = "Health",
    CRYSTAL_HITS_ATTRIBUTE = "BossCrystalHits",
    CRYSTAL_BEAM_HIT_LIMIT = 5,
    CRYSTAL_HINT_DELAY = 60,
    CRYSTAL_HINT_MESSAGE = "Use your bat to destroy the crystals!",
    CRYSTAL_HINT_SECONDS = 5,
    CRYSTAL_HINT_COLOR = Color3.fromRGB(162, 0, 255),
    HAZARD_FOLDER_NAME = "BossHazards",
    HAZARD_COLOR = Color3.fromRGB(255, 40, 40),
    HAZARD_THICKNESS = 2,
    HAZARD_HOVER = 0.15,
    HAZARD_TRANSPARENCY = 0.2,
    HAZARD_TOUCH_PADDING = 2,
    HAZARD_JUMP_CLEARANCE = 4,
    HAZARD_REPORT_INTERVAL = 1,
    HAZARD_GAP_SECONDS = 2,
    HAZARD_START_DELAY_SECONDS = 5,
    HAZARD_INDICATOR_THICKNESS = 0.6,
    HAZARD_INDICATOR_TRANSPARENCY = 0.7,
    HAZARD_PULSE = TweenInfo.new(0.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true),
    X_KIND = "RotatingX",
    X_BAR_COUNT = 2,
    X_TELEGRAPH_SECONDS = 2,
    X_GROW_SECONDS = 1,
    X_ACTIVE_SECONDS = 15,
    X_DEGREES_PER_SECOND = 20,
    RING_KIND = "ExpandingRing",
    RING_SEGMENTS = 32,
    RING_COUNT = 5,
    RING_SPAWN_INTERVAL = 3,
    RING_SPEED = 40,
    RING_FADE_SECONDS = 0.75,
    HAZARD_MIN_LENGTH = 0.05
}

t1.BLACK_HOLE_LOOP_RISE_INFO = TweenInfo.new(t1.BLACK_HOLE_WINDUP_SECONDS, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
t1.BLACK_HOLE_LOOP_DRAIN_INFO = TweenInfo.new(t1.BLACK_HOLE_RETRACT_SECONDS, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

return {
    Start = function() -- Start | line: 198
        -- upvalues: Players (copy), ReplicatedStorage (copy), RunService (copy), TweenService (copy), Workspace (copy), SoundService (copy), BossEventFlags (copy), BossEvent (copy), HiddenUIHandler (copy), LightingController (copy), Notifications (copy), Pads (copy), Player (copy), Remotes (copy), RiftEligibility (copy), RiftFlags (copy), Save (copy), Tabs (copy), Trove (copy), VFX (copy), t1 (copy)
        local LocalPlayer = Players.LocalPlayer
        local v1 = script:WaitForChild(t1.MUSIC_NAME, 10)
        local tween
        local v2 = ReplicatedStorage.Assets.Particles:WaitForChild(t1.VFX_FOLDER_NAME)
        local v3 = Workspace:WaitForChild(t1.DEBRIS_FOLDER_NAME)
        local v4 = v2:FindFirstChild(t1.BLACK_HOLE_VFX_NAME)
        local v5 = v4 ~= nil and v4:IsA("Attachment")

        assert(v5, (("%* needs a %* Attachment"):format(t1.VFX_FOLDER_NAME, t1.BLACK_HOLE_VFX_NAME)))

        local v7 = ReplicatedStorage.Assets:WaitForChild(t1.EXTRA_FOLDER_NAME):FindFirstChild(t1.GUIDE_BEAM_NAME)
        local v6 = v7 ~= nil and v7:IsA("Beam")

        assert(v6, (("%* needs a %* Beam"):format(t1.EXTRA_FOLDER_NAME, t1.GUIDE_BEAM_NAME)))

        local v9 = Trove.new()
        local v10 = Trove.new()
        local v11 = Trove.new()
        local v12
        local t3 = {}
        local v13, v14, v15, v16, Part, v17, v18, v19, v20
        local n1 = -1
        local t4 = {}
        local t5 = {}
        local t6 = {}
        local v21 = Vector3.new(0, 0, 0)
        local clone, Attachment, v22, v23, Attachment2, clone2, Attachment3
        local v24 = false
        local clone3, Attachment4, Attachment5
        local n2 = 0
        local v25 = false
        local v26 = false
        local n3 = 0
        local n4 = 0
        local n5 = 0
        local n6 = 0
        local n7 = 0
        local n8 = 0
        local v27, connection
        local n9 = 1e999
        local n10 = 0
        local v28, connection2, t7

        local function fadeMusic(p1, p2, p3) -- line: 268
            -- upvalues: v1 (copy), tween (ref), TweenService (copy), t1 (copy)
            local tween2 = tween

            if tween2 ~= nil then
                tween2:Cancel()
            end

            local tween3 = TweenService:Create(v1, p3 or t1.MUSIC_FADE_INFO, {
                Volume = p1
            })

            tween = tween3

            if p2 then
                tween3.Completed:Once(function(p4) -- line: 277
                    -- upvalues: v1 (copy)
                    if p4 == Enum.PlaybackState.Completed then
                        v1:Stop()
                    end
                end)
            end

            tween3:Play()
        end

        local function startMusic() -- line: 288
            -- upvalues: v1 (copy), tween (ref), t1 (copy)
            if v1.IsPlaying then
                return
            end

            local tween2 = tween

            if tween2 ~= nil then
                tween2:Cancel()
                tween = nil
            end

            v1.Volume = t1.MUSIC_VOLUME
            v1:Play()
        end

        local function stopMusic() -- line: 301
            -- upvalues: v1 (copy), fadeMusic (copy)
            if v1.IsPlaying then
                fadeMusic(0, true)
            end
        end

        local function playVfx(p5, p6) -- line: 311
            -- upvalues: v2 (copy), v3 (copy), VFX (copy), t1 (copy)
            local v29 = v2:FindFirstChild(p5)

            assert(v29 ~= nil, (("%* needs %*"):format(t1.VFX_FOLDER_NAME, p5)))

            local clone = v29:Clone()

            for _, descendant in clone:GetDescendants() do
                if descendant:IsA("ParticleEmitter") then
                    descendant.Enabled = false
                end
            end

            if clone:IsA("BasePart") then
                assert(typeof(p6) == "CFrame", (("%* is a part and plays at a CFrame"):format(p5)))
                clone.Anchored = true
                clone.CanCollide = false
                clone.CanQuery = false
                clone.CanTouch = false
                clone.CFrame = p6
                clone.Parent = v3
            elseif clone:IsA("Attachment") then
                assert(typeof(p6) == "Instance", (("%* is an attachment and plays on a part"):format(p5)))
                clone.Parent = p6
            else
                error((("%* must be a BasePart or an Attachment"):format(p5)))
            end

            VFX.Discard(clone, VFX.EmitTree(clone, true))
        end

        local function uiChild(p7, p8, p9) -- line: 339
            local v36 = p7:FindFirstChild(p8)

            assert(v36 ~= nil and v36:IsA(p9), (("%* is missing the %* %*"):format(p7:GetFullName(), p9, p8)))

            return v36
        end

        local function findUi() -- line: 345
            -- upvalues: LocalPlayer (copy), BossEvent (copy), t1 (copy)
            local v39 = LocalPlayer:WaitForChild("PlayerGui"):WaitForChild(t1.UI_NAME, t1.UI_WAIT_SECONDS)

            assert(v39 ~= nil and v39:IsA("ScreenGui"), (("PlayerGui is missing the %* ScreenGui"):format(t1.UI_NAME)))

            local BossHPBar = v39:FindFirstChild("BossHPBar")

            assert(BossHPBar ~= nil and BossHPBar:IsA("Frame"), (("%* is missing the Frame BossHPBar"):format((v39:GetFullName()))))

            local BarHolder = BossHPBar:FindFirstChild("BarHolder")

            assert(BarHolder ~= nil and BarHolder:IsA("Frame"), (("%* is missing the Frame BarHolder"):format((BossHPBar:GetFullName()))))

            local BarBG = BarHolder:FindFirstChild("BarBG")

            assert(BarBG ~= nil and BarBG:IsA("CanvasGroup"), (("%* is missing the CanvasGroup BarBG"):format((BarHolder:GetFullName()))))

            local BossName = BossHPBar:FindFirstChild("BossName")

            assert(BossName ~= nil and BossName:IsA("TextLabel"), (("%* is missing the TextLabel BossName"):format((BossHPBar:GetFullName()))))
            BossName.Text = BossEvent.BossName

            local t8 = {}
            local t9 = {}

            for _, descendant in v39:GetDescendants() do
                if descendant:IsA("UIStroke") and descendant.Color == Color3.new(0, 0, 0) then
                    t8[descendant] = descendant.Color
                elseif descendant:IsA("Frame") and descendant.Name == "Line" then
                    t9[descendant] = descendant.BackgroundColor3
                end
            end

            local t10 = {
                Gui = v39
            }
            local Bar = BarBG:FindFirstChild("Bar")

            assert(Bar ~= nil and Bar:IsA("Frame"), (("%* is missing the Frame Bar"):format((BarBG:GetFullName()))))
            t10.Bar = Bar

            local PhantomBar = BarBG:FindFirstChild("PhantomBar")

            assert(PhantomBar ~= nil and PhantomBar:IsA("Frame"), (("%* is missing the Frame PhantomBar"):format((BarBG:GetFullName()))))
            t10.PhantomBar = PhantomBar

            local HealthAmount = BarHolder:FindFirstChild("HealthAmount")

            assert(HealthAmount ~= nil and HealthAmount:IsA("TextLabel"), (("%* is missing the TextLabel HealthAmount"):format((BarHolder:GetFullName()))))
            t10.HealthAmount = HealthAmount

            local Frame = BossHPBar:FindFirstChild("Frame")

            assert(Frame ~= nil and Frame:IsA("Frame"), (("%* is missing the Frame Frame"):format((BossHPBar:GetFullName()))))

            local TimerLabel = Frame:FindFirstChild("TimerLabel")

            assert(TimerLabel ~= nil and TimerLabel:IsA("TextLabel"), (("%* is missing the TextLabel TimerLabel"):format((Frame:GetFullName()))))
            t10.TimerLabel = TimerLabel

            local BGDecor = BossHPBar:FindFirstChild("BGDecor")

            assert(BGDecor ~= nil and BGDecor:IsA("Frame"), (("%* is missing the Frame BGDecor"):format((BossHPBar:GetFullName()))))
            t10.FightOnly = {
                BarHolder,
                BossName,
                BGDecor
            }
            t10.Shaker = BossHPBar
            t10.ShakerPosition = BossHPBar.Position
            t10.Strokes = t8
            t10.Lines = t9

            return t10
        end

        local function setHealth(p10, p11, p12) -- line: 386
            -- upvalues: v26 (ref), v27 (ref), n9 (ref), fadeMusic (copy), TweenService (copy), t1 (copy)
            local v62 = v27

            if v62 == nil or p11 <= 0 then
                return
            end

            n9 = p10

            if p10 <= 0 and not v26 then
                v26 = true
                fadeMusic(0, true, t1.MUSIC_DEFEAT_FADE_INFO)
            end

            local v64 = UDim2.fromScale(math.clamp(p10 / p11, 0, 1), 1)

            v62.HealthAmount.Text = ("%* / %* HP"):format(math.max(math.ceil(p10), 0), (math.ceil(p11)))

            if p12 then
                TweenService:Create(v62.Bar, t1.BAR_INFO, {
                    Size = v64
                }):Play()
                TweenService:Create(v62.PhantomBar, t1.PHANTOM_INFO, {
                    Size = v64
                }):Play()
            else
                v62.Bar.Size = v64
                v62.PhantomBar.Size = v64
            end
        end

        local function flashUi() -- line: 411
            -- upvalues: v27 (ref), connection (ref), RunService (copy), TweenService (copy), t1 (copy)
            local v66 = v27

            if v66 == nil then
                return
            end

            for v67, v68 in v66.Strokes do
                v67.Color = t1.UI_FLASH_COLOR
                TweenService:Create(v67, t1.UI_FLASH_INFO, {
                    Color = v68
                }):Play()
            end

            for v69, v70 in v66.Lines do
                v69.BackgroundColor3 = t1.UI_FLASH_COLOR
                TweenService:Create(v69, t1.UI_FLASH_INFO, {
                    BackgroundColor3 = v70
                }):Play()
            end

            local connection2 = connection

            if connection2 ~= nil then
                connection2:Disconnect()
            end

            local n11 = 0
            local connection3

            connection3 = RunService.Heartbeat:Connect(function(p13) -- line: 431
                -- upvalues: v66 (copy), n11 (ref), connection3 (ref), t1 (copy)
                n11 = math.min(n11 + p13, t1.UI_SHAKE_SECONDS)

                if n11 >= t1.UI_SHAKE_SECONDS then
                    connection3:Disconnect()
                    v66.Shaker.Position = v66.ShakerPosition
                else
                    local v73 = t1.UI_SHAKE_PIXELS * (1 - n11 / t1.UI_SHAKE_SECONDS)

                    v66.Shaker.Position = v66.ShakerPosition + UDim2.fromOffset((math.random() - 0.5) * 2 * v73, (math.random() - 0.5) * 2 * v73)
                end
            end)
            connection = connection3
        end

        local function findCountdownUi() -- line: 447
            -- upvalues: LocalPlayer (copy), t7 (ref), t1 (copy)
            local t12 = t7

            if t12 ~= nil then
                return t12.Gui, t12.Content
            end

            local v75 = LocalPlayer:WaitForChild("PlayerGui"):WaitForChild(t1.COUNTDOWN_UI_NAME, t1.UI_WAIT_SECONDS)

            assert(v75 ~= nil and v75:IsA("ScreenGui"), (("PlayerGui is missing the %* ScreenGui"):format(t1.COUNTDOWN_UI_NAME)))

            local Main = v75:FindFirstChild("Main")

            assert(Main ~= nil and Main:IsA("Frame"), (("%* is missing the Frame Main"):format((v75:GetFullName()))))

            local Content = Main:FindFirstChild("Content")

            assert(Content ~= nil and Content:IsA("TextLabel"), (("%* is missing the TextLabel Content"):format((Main:GetFullName()))))
            t7 = {
                Gui = v75,
                Content = Content
            }

            return v75, Content
        end

        local function stepCountdown() -- line: 464
            -- upvalues: v28 (ref), connection2 (ref), findCountdownUi (copy), Workspace (copy), BossEvent (copy), HiddenUIHandler (copy), t1 (copy)
            local v82, v83 = findCountdownUi()
            local v84 = v28
            local v85 = if v84 == nil then 0 else v84 - Workspace:GetServerTimeNow()

            if v85 <= 0 then
                v82.Enabled = false
                v28 = nil

                local connection = connection2

                if connection ~= nil then
                    connection2 = nil
                    connection:Disconnect()
                end
            elseif HiddenUIHandler.IsHidden() then
                v82.Enabled = false
            else
                v83.Text = string.format(t1.COUNTDOWN_TEXT_FORMAT, BossEvent.BossName, (math.ceil(v85)))
                v82.Enabled = true
            end
        end

        local function setSpawnCountdown(p14) -- line: 486
            -- upvalues: v28 (ref), connection2 (ref), stepCountdown (copy), RunService (copy)
            v28 = p14

            if p14 ~= nil and connection2 == nil then
                connection2 = RunService.Heartbeat:Connect(function() -- line: 489
                    -- upvalues: stepCountdown (copy)
                    stepCountdown()
                end)
            end

            stepCountdown()
        end

        local function applySnapshot(p15) -- line: 496
            -- upvalues: v26 (ref), v27 (ref), n9 (ref), n10 (ref), v28 (ref), connection2 (ref), fadeMusic (copy), stepCountdown (copy), RunService (copy), t1 (copy)
            n10 = p15.ClosesAt

            local BossSpawnsAt = p15.BossSpawnsAt

            v28 = BossSpawnsAt

            if BossSpawnsAt ~= nil and connection2 == nil then
                connection2 = RunService.Heartbeat:Connect(function() -- line: 489
                    -- upvalues: stepCountdown (copy)
                    stepCountdown()
                end)
            end

            stepCountdown()

            local BossHealth, BossMaxHealth = p15.BossHealth, p15.BossMaxHealth

            if BossHealth ~= nil and BossMaxHealth ~= nil then
                local v86 = v27

                if v86 ~= nil then
                    if BossMaxHealth <= 0 then
                        return
                    end

                    n9 = BossHealth

                    if BossHealth <= 0 and not v26 then
                        v26 = true
                        fadeMusic(0, true, t1.MUSIC_DEFEAT_FADE_INFO)
                    end

                    local v88 = UDim2.fromScale(math.clamp(BossHealth / BossMaxHealth, 0, 1), 1)

                    v86.HealthAmount.Text = ("%* / %* HP"):format(math.max(math.ceil(BossHealth), 0), (math.ceil(BossMaxHealth)))
                    v86.Bar.Size = v88
                    v86.PhantomBar.Size = v88
                end
            end
        end

        local function stepUi() -- line: 508
            -- upvalues: v1 (copy), tween (ref), v16 (ref), v26 (ref), v27 (ref), n10 (ref), Workspace (copy), t1 (copy)
            local v90 = v27

            if v90 == nil then
                return
            end

            local v91 = v16
            local v92 = v26

            if not v92 then
                v92 = v91 ~= nil and not v91.Model:GetAttribute(t1.SPAWNING_ATTRIBUTE)
            end

            if v90.Gui.Enabled ~= v92 then
                v90.Gui.Enabled = v92
            end

            if not v92 then
                return
            end

            local v93 = not v26

            for _, v94 in v90.FightOnly do
                if v94.Visible ~= v93 then
                    v94.Visible = v93
                end
            end

            if not (v26 or v1.IsPlaying) then
                local tween2 = tween

                if tween2 ~= nil then
                    tween2:Cancel()
                    tween = nil
                end

                v1.Volume = t1.MUSIC_VOLUME
                v1:Play()
            end

            local v96 = n10
            local v98 = math.max(math.floor(v96 - Workspace:GetServerTimeNow()), 0)

            v90.TimerLabel.Text = string.format("%02d:%02d", v98 // 60, v98 % 60)
        end

        local function showUi() -- line: 545
            -- upvalues: v9 (copy), v26 (ref), v27 (ref), connection (ref), n9 (ref), n10 (ref), v28 (ref), connection2 (ref), fadeMusic (copy), findUi (copy), setHealth (copy), flashUi (copy), stepCountdown (copy), applySnapshot (copy), stepUi (copy), RunService (copy), Remotes (copy), t1 (copy)
            local v99 = findUi()

            v27 = v99
            v9:Add(function() -- line: 548
                -- upvalues: v99 (copy), v27 (ref), connection (ref), n9 (ref)
                local connection2 = connection

                if connection2 ~= nil then
                    connection2:Disconnect()
                    connection = nil
                end

                v27 = nil
                n9 = 1e999
                v99.Gui.Enabled = false

                for _, v100 in v99.FightOnly do
                    v100.Visible = true
                end
            end)

            local v101 = Remotes.BossEvent.AskSnapshot:InvokeServer()

            n10 = v101.ClosesAt

            local BossSpawnsAt = v101.BossSpawnsAt

            v28 = BossSpawnsAt

            if BossSpawnsAt ~= nil and connection2 == nil then
                connection2 = RunService.Heartbeat:Connect(function() -- line: 489
                    -- upvalues: stepCountdown (copy)
                    stepCountdown()
                end)
            end

            stepCountdown()

            local BossHealth, BossMaxHealth = v101.BossHealth, v101.BossMaxHealth

            if BossHealth ~= nil and BossMaxHealth ~= nil then
                local v102 = v27

                if v102 ~= nil and not (BossMaxHealth <= 0) then
                    n9 = BossHealth

                    if BossHealth <= 0 and not v26 then
                        v26 = true
                        fadeMusic(0, true, t1.MUSIC_DEFEAT_FADE_INFO)
                    end

                    local v104 = UDim2.fromScale(math.clamp(BossHealth / BossMaxHealth, 0, 1), 1)

                    v102.HealthAmount.Text = ("%* / %* HP"):format(math.max(math.ceil(BossHealth), 0), (math.ceil(BossMaxHealth)))
                    v102.Bar.Size = v104
                    v102.PhantomBar.Size = v104
                end
            end

            stepUi()
            v9:Connect(Remotes.BossEvent.HealthShifted.OnClientEvent, function(p16, p17) -- line: 567
                -- upvalues: n9 (ref), setHealth (copy), flashUi (copy)
                if p16 < n9 then
                    flashUi()
                end

                setHealth(p16, p17, true)
            end)
            v9:Connect(Remotes.BossEvent.StateShifted.OnClientEvent, applySnapshot)
        end

        local function findBoss(p18) -- line: 577
            -- upvalues: t1 (copy)
            local v106 = p18:WaitForChild(t1.BOSS_MODEL_NAME, 10)
            local v107, v108, v109

            if v106 ~= nil then
                if v106:IsA("Model") then
                    v107 = v106:WaitForChild(t1.OUTLINE_PART_NAME, 10)
                    v108 = v107 ~= nil and v107:IsA("BasePart")
                    v109 = false
                else
                    v109 = true
                end
            else
                v109 = true
            end

            if v109 then
                return nil
            end

            assert(v108, (("%* needs its %* outline part"):format(t1.BOSS_MODEL_NAME, t1.OUTLINE_PART_NAME)))

            local PrimaryPart = v106.PrimaryPart

            assert(PrimaryPart ~= nil, (("%* needs a PrimaryPart"):format(t1.BOSS_MODEL_NAME)))

            local v113 = v106:FindFirstChild(t1.HAND_BONE_NAME, true)

            assert(v113 ~= nil and v113:IsA("Bone"), (("%* needs a %* bone"):format(t1.BOSS_MODEL_NAME, t1.HAND_BONE_NAME)))

            return {
                Model = v106,
                Root = PrimaryPart,
                Outline = v107,
                OutlineColor = v107.Color,
                HandBone = v113
            }
        end

        local function flashOutline() -- line: 599
            -- upvalues: v16 (ref), TweenService (copy), t1 (copy)
            local v116 = v16

            if v116 ~= nil then
                v116.Outline.Color = t1.FLASH_COLOR
                TweenService:Create(v116.Outline, t1.FLASH_INFO, {
                    Color = v116.OutlineColor
                }):Play()
            end
        end

        local function stopBlackHoleVfx() -- line: 610
            -- upvalues: Part (ref), v17 (ref), TweenService (copy), t1 (copy)
            local Part2 = Part

            if Part2 == nil then
                return
            end

            for _, descendant in Part2:GetDescendants() do
                if descendant:IsA("ParticleEmitter") then
                    descendant.Enabled = false
                end
            end

            local v117 = v17

            if v117 ~= nil then
                TweenService:Create(v117, t1.BLACK_HOLE_LOOP_DRAIN_INFO, {
                    Volume = 0
                }):Play()
            end
        end

        local function clearBlackHole() -- line: 627
            -- upvalues: Part (ref), v17 (ref), v18 (ref)
            local Part2 = Part

            Part = nil
            v17 = nil
            v18 = nil

            if Part2 ~= nil then
                Part2:Destroy()
            end
        end

        local function groundBelow(p19) -- line: 638
            -- upvalues: v15 (ref), Workspace (copy), t1 (copy)
            local v118 = v15

            if v118 == nil then
                return p19
            end

            local v119 = RaycastParams.new()

            v119.FilterType = Enum.RaycastFilterType.Include
            v119.FilterDescendantsInstances = { v118 }

            local v120 = Workspace:Raycast(p19 + Vector3.new(0, 1, 0) * t1.GROUND_PROBE_HEIGHT, Vector3.new(0, 1, 0) * -(t1.GROUND_PROBE_HEIGHT * 4), v119)

            if v120 ~= nil then
                return v120.Position
            end

            return (Vector3.new(p19.X, v118.Position.Y + v118.Size.Y * 0.5, p19.Z))
        end

        local function chasePlayer(p20, p21, p22, p23, p24) -- line: 661
            -- upvalues: t1 (copy)
            local Target = p20.Target
            local v124 = Vector3.new(p21.Position.X - Target.X, 0, p21.Position.Z - Target.Z)
            local v125 = p22.WalkSpeed * t1.BLACK_HOLE_FOLLOW_SPEED_FRACTION * p24 * p23

            if v125 < v124.Magnitude then
                p20.Target = Target + v124.Unit * v125
            else
                p20.Target = Vector3.new(p21.Position.X, Target.Y, p21.Position.Z)
            end
        end

        local function blackHolePart() -- line: 679
            -- upvalues: v4 (copy), Part (ref), v17 (ref), TweenService (copy), Workspace (copy), BossEvent (copy), t1 (copy)
            local Part2 = Part

            if Part2 ~= nil then
                return Part2
            end

            local Part3 = Instance.new("Part")

            Part3.Name = "BossBlackHole"
            Part3.Shape = Enum.PartType.Cylinder
            Part3.Material = Enum.Material.Neon
            Part3.Color = t1.BLACK_HOLE_COLOR
            Part3.Transparency = t1.BLACK_HOLE_TRANSPARENCY
            Part3.Anchored = true
            Part3.CanCollide = false
            Part3.CanQuery = false
            Part3.CanTouch = false
            Part3.CastShadow = false

            local clone = v4:Clone()

            clone.CFrame = t1.BLACK_HOLE_VFX_ROTATION * clone.CFrame
            clone.Parent = Part3
            Part3.Parent = Workspace
            Part = Part3
            TweenService:Create(Part3, t1.BLACK_HOLE_PULSE, {
                Transparency = t1.BLACK_HOLE_FADED_TRANSPARENCY
            }):Play()
            BossEvent.PlaySound(t1.BLACK_HOLE_SPAWN_SOUND_NAME, Part3)

            local v126 = BossEvent.PlaySound(t1.BLACK_HOLE_LOOP_SOUND_NAME, Part3, {
                Looped = true,
                Volume = 0
            })

            if v126 ~= nil then
                TweenService:Create(v126, t1.BLACK_HOLE_LOOP_RISE_INFO, {
                    Volume = t1.BLACK_HOLE_LOOP_VOLUME
                }):Play()
                v17 = v126
            end

            return Part3
        end

        local function faceTowards(p25, p26, p27) -- line: 715
            -- upvalues: t1 (copy)
            local Pivot = p25.Model:GetPivot()
            local v127 = Vector3.new(p26.X, Pivot.Position.Y, p26.Z)

            if (v127 - Pivot.Position).Magnitude < 1 then
                return
            end

            local v128 = CFrame.lookAt(Pivot.Position, v127)

            p25.Model:PivotTo(Pivot:Lerp(v128, (math.min(p27 * t1.TURN_SPEED, 1))))
        end

        local function stepBlackHole(p28) -- line: 725
            -- upvalues: LocalPlayer (copy), v16 (ref), Part (ref), v17 (ref), v18 (ref), v26 (ref), n6 (ref), n7 (ref), n8 (ref), stopBlackHoleVfx (copy), groundBelow (copy), chasePlayer (copy), blackHolePart (copy), faceTowards (copy), Workspace (copy), Player (copy), Remotes (copy), t1 (copy)
            local v130 = v16
            local v131 = Player.FindRootPart(LocalPlayer)
            local v132 = Player.FindHumanoid(LocalPlayer)
            local ServerTimeNow = Workspace:GetServerTimeNow()

            if v130 ~= nil and v130.Model:GetAttribute(t1.SPAWNING_ATTRIBUTE) then
                n7 = ServerTimeNow
            end

            local v133, v134

            if v132 == nil or v131 == nil then
                v134 = true
            elseif v131:IsA("BasePart") then
                if v130 ~= nil then
                    v133 = not v26

                    if v133 then
                        v133 = not v130.Model:GetAttribute(t1.SPAWNING_ATTRIBUTE)

                        if v133 then
                            v133 = not v130.Model:GetAttribute(t1.ATTACKING_ATTRIBUTE)
                            v133 = v133 and ServerTimeNow - math.max(n6, n7) >= t1.BLACK_HOLE_START_DELAY
                        end
                    end
                else
                    v133 = false
                end

                v134 = false
            else
                v134 = true
            end

            if not v134 then
                local v137 = v18

                if v137 ~= nil then
                    if not v133 and v137.RetractingAt == nil then
                        v137.RetractingAt = ServerTimeNow
                        stopBlackHoleVfx()
                    end
                else
                    if not v133 then
                        return
                    end

                    v137 = {
                        RetractingAt = nil,
                        Target = v131.Position,
                        StartedAt = ServerTimeNow
                    }
                    v18 = v137
                end

                local RetractingAt = v137.RetractingAt
                local v138

                if RetractingAt ~= nil then
                    local v140 = 1 - math.min((ServerTimeNow - RetractingAt) / t1.BLACK_HOLE_RETRACT_SECONDS, 1)

                    if v140 <= 0 then
                        local Part2 = Part

                        Part = nil
                        v17 = nil
                        v18 = nil

                        if Part2 ~= nil then
                            Part2:Destroy()
                        end

                        return
                    else
                        v138 = v140
                    end
                else
                    v138 = 1
                end

                local v142 = math.min((ServerTimeNow - v137.StartedAt) / t1.BLACK_HOLE_WINDUP_SECONDS, 1)
                local v143 = v142 >= 1

                if v143 then
                    chasePlayer(v137, v131, v132, p28, v138)
                end

                local Target = v137.Target

                if v130 ~= nil and not v130.Model:GetAttribute(t1.ATTACKING_ATTRIBUTE) then
                    faceTowards(v130, Target, p28)
                end

                local v144 = t1.BLACK_HOLE_RADIUS * v142 * v138
                local v145 = groundBelow((Vector3.new(Target.X, v131.Position.Y, Target.Z)))
                local v146 = blackHolePart()

                v146.Size = Vector3.new(t1.BLACK_HOLE_THICKNESS, v144 * 2, v144 * 2)
                v146.CFrame = CFrame.new(v145 + Vector3.new(0, 1, 0) * t1.BLACK_HOLE_HOVER) * CFrame.Angles(0, 0, 1.5707963267948966)

                local v151 = Vector3.new(v131.Position.X - v145.X, 0, v131.Position.Z - v145.Z)

                if v143 and v151.Magnitude <= v144 and ServerTimeNow - n8 >= t1.BLACK_HOLE_HIT_INTERVAL then
                    n8 = ServerTimeNow
                    Remotes.BossEvent.BlackHoleHit:FireServer()
                end
            else
                local Part2 = Part

                Part = nil
                v17 = nil
                v18 = nil

                if Part2 ~= nil then
                    Part2:Destroy()
                end
            end
        end

        local function measureHazardCycle(p29, p30) -- line: 809
            -- upvalues: n3 (ref), n4 (ref), n5 (ref), t1 (copy)
            local v152 = p29.Size * 0.5
            local n12 = 0

            for _, v153 in {
                    -v152.X,
                    v152.X
                } do
                for _, v155 in {
                        -v152.Z,
                        v152.Z
                    } do
                    local Position = (p29.CFrame * CFrame.new(v153, 0, v155)).Position

                    n12 = math.max(n12, Vector3.new(Position.X - p30.X, 0, Position.Z - p30.Z).Magnitude)
                end
            end

            n3 = n12 / t1.RING_SPEED
            n4 = (t1.RING_COUNT - 1) * t1.RING_SPAWN_INTERVAL + n3 + t1.RING_FADE_SECONDS
            n5 = t1.X_TELEGRAPH_SECONDS + t1.X_ACTIVE_SECONDS + n4 + t1.HAZARD_GAP_SECONDS * 2
        end

        local function hazardFolder() -- line: 824
            -- upvalues: v19 (ref), Workspace (copy), t1 (copy)
            local v158 = v19

            if v158 ~= nil then
                return v158
            end

            local Folder = Instance.new("Folder")

            Folder.Name = t1.HAZARD_FOLDER_NAME
            Folder.Parent = Workspace
            v19 = Folder

            return Folder
        end

        local function hazardPart(p31, p32, p33) -- line: 836
            -- upvalues: v19 (ref), Workspace (copy), t1 (copy)
            local Part = Instance.new("Part")

            Part.Name = p31
            Part.Size = p32
            Part.Material = Enum.Material.Neon
            Part.Color = t1.HAZARD_COLOR
            Part.Transparency = p33
            Part.Anchored = true
            Part.CanCollide = false
            Part.CanQuery = false
            Part.CanTouch = false
            Part.CastShadow = false

            local v159 = v19

            if v159 == nil then
                v159 = Instance.new("Folder")
                v159.Name = t1.HAZARD_FOLDER_NAME
                v159.Parent = Workspace
                v19 = v159
            end

            Part.Parent = v159

            return Part
        end

        local function clearHazards() -- line: 852
            -- upvalues: v19 (ref), t4 (ref), t5 (ref)
            local v160 = v19

            v19 = nil
            t4 = {}
            t5 = {}

            if v160 ~= nil then
                v160:Destroy()
            end
        end

        local function overFloor(p34) -- line: 865
            -- upvalues: v15 (ref)
            local v161 = v15

            if v161 == nil then
                return false
            end

            local v162 = v161.CFrame:PointToObjectSpace(p34)

            if not (math.abs(v162.X) <= v161.Size.X * 0.5) then
                return false
            end

            return math.abs(v162.Z) <= v161.Size.Z * 0.5
        end

        local function withinHazardHeight(p35, p36) -- line: 877
            -- upvalues: t1 (copy)
            return math.abs(p35.Position.Y - p36) <= t1.HAZARD_JUMP_CLEARANCE
        end

        local function reportHazardHit(p37) -- line: 883
            -- upvalues: t6 (copy), Remotes (copy), t1 (copy)
            local elapsed = os.clock()

            if not (elapsed - (t6[p37] or 0) < t1.HAZARD_REPORT_INTERVAL) then
                t6[p37] = elapsed
                Remotes.BossEvent.HazardHit:FireServer(p37)
            end
        end

        local function stepRotatingX(p38, p39, p40, p41, p42) -- line: 895
            -- upvalues: v15 (ref), v19 (ref), t4 (ref), t6 (copy), TweenService (copy), Workspace (copy), Remotes (copy), t1 (copy)
            local v164 = v15

            if v164 == nil then
                return
            end

            local v165 = math.max(v164.Size.X, v164.Size.Z)

            if #t4 == 0 then
                local v166 = if p38 then t1.HAZARD_INDICATOR_THICKNESS else t1.HAZARD_THICKNESS

                for _ = 1, t1.X_BAR_COUNT do
                    local v167 = if p38 then "XIndicator" else "XBar"
                    local v168 = Vector3.new(t1.HAZARD_THICKNESS, v166, v165)
                    local v169 = if p38 then t1.HAZARD_INDICATOR_TRANSPARENCY else t1.HAZARD_TRANSPARENCY
                    local Part = Instance.new("Part")

                    Part.Name = v167
                    Part.Size = v168
                    Part.Material = Enum.Material.Neon
                    Part.Color = t1.HAZARD_COLOR
                    Part.Transparency = v169
                    Part.Anchored = true
                    Part.CanCollide = false
                    Part.CanQuery = false
                    Part.CanTouch = false
                    Part.CastShadow = false

                    local v170 = v19

                    if v170 == nil then
                        v170 = Instance.new("Folder")
                        v170.Name = t1.HAZARD_FOLDER_NAME
                        v170.Parent = Workspace
                        v19 = v170
                    end

                    Part.Parent = v170

                    if p38 then
                        TweenService:Create(Part, t1.HAZARD_PULSE, {
                            Transparency = t1.HAZARD_TRANSPARENCY
                        }):Play()
                    end

                    table.insert(t4, Part)
                end
            end

            local v171

            if p38 then
                v171 = 0
            else
                v165 *= math.clamp(p39 / t1.X_GROW_SECONDS, 0, 1)
                v171 = math.max(p39 - t1.X_GROW_SECONDS, 0)
            end

            local v175 = math.rad(v171 * t1.X_DEGREES_PER_SECOND)

            for v176, v177 in t4 do
                v177.Size = Vector3.new(v177.Size.X, v177.Size.Y, (math.max(v165, t1.HAZARD_MIN_LENGTH)))
                v177.CFrame = CFrame.new(p40.X, p41, p40.Z) * CFrame.Angles(0, v175 + (v176 - 1) * 3.141592653589793 * 0.5, 0)

                if not p38 and p42 ~= nil and math.abs(p42.Position.Y - p41) <= t1.HAZARD_JUMP_CLEARANCE then
                    local v180 = v177.CFrame:PointToObjectSpace((Vector3.new(p42.Position.X, v177.Position.Y, p42.Position.Z)))

                    if math.abs(v180.X) <= t1.HAZARD_THICKNESS * 0.5 + t1.HAZARD_TOUCH_PADDING and math.abs(v180.Z) <= v165 * 0.5 then
                        local X_KIND = t1.X_KIND
                        local elapsed = os.clock()

                        if not (elapsed - (t6[X_KIND] or 0) < t1.HAZARD_REPORT_INTERVAL) then
                            t6[X_KIND] = elapsed
                            Remotes.BossEvent.HazardHit:FireServer(X_KIND)
                        end
                    end
                end
            end
        end

        local function newRing() -- line: 945
            -- upvalues: v19 (ref), Workspace (copy), t1 (copy)
            local t14 = {}

            for _ = 1, t1.RING_SEGMENTS do
                local v181 = Vector3.new(t1.HAZARD_THICKNESS, t1.HAZARD_THICKNESS, t1.HAZARD_MIN_LENGTH)
                local HAZARD_TRANSPARENCY = t1.HAZARD_TRANSPARENCY
                local Part = Instance.new("Part")

                Part.Name = "RingSegment"
                Part.Size = v181
                Part.Material = Enum.Material.Neon
                Part.Color = t1.HAZARD_COLOR
                Part.Transparency = HAZARD_TRANSPARENCY
                Part.Anchored = true
                Part.CanCollide = false
                Part.CanQuery = false
                Part.CanTouch = false
                Part.CastShadow = false

                local v182 = v19

                if v182 == nil then
                    v182 = Instance.new("Folder")
                    v182.Name = t1.HAZARD_FOLDER_NAME
                    v182.Parent = Workspace
                    v19 = v182
                end

                Part.Parent = v182
                table.insert(t14, Part)
            end

            return t14
        end

        local function stepRings(p43, p44, p45, p46) -- line: 959
            -- upvalues: v15 (ref), t5 (ref), t6 (copy), n3 (ref), newRing (copy), Remotes (copy), t1 (copy)
            for i = 0, t1.RING_COUNT - 1 do
                local v183 = p43 - i * t1.RING_SPAWN_INTERVAL

                if not (v183 < 0) then
                    local v184 = t5[i] or newRing()
                    local t15 = t5

                    t15[i] = v184

                    local v186 = math.min(v183, n3) * t1.RING_SPEED
                    local v188 = math.clamp((v183 - n3) / t1.RING_FADE_SECONDS, 0, 1)
                    local v189 = t1.HAZARD_TRANSPARENCY + (1 - t1.HAZARD_TRANSPARENCY) * v188
                    local v191 = math.max(6.283185307179586 * v186 / t1.RING_SEGMENTS, t1.HAZARD_MIN_LENGTH)

                    for v192, v193 in v184 do
                        local v194 = (v192 - 1) / t1.RING_SEGMENTS * 3.141592653589793 * 2
                        local v197 = Vector3.new(p44.X + math.cos(v194) * v186, p45, p44.Z + math.sin(v194) * v186)

                        v193.Size = Vector3.new(t1.HAZARD_THICKNESS, t1.HAZARD_THICKNESS, v191)
                        v193.CFrame = CFrame.new(v197) * CFrame.Angles(0, -v194, 0)

                        local v198 = v15
                        local v199 = false

                        if v198 ~= nil then
                            local v200 = v198.CFrame:PointToObjectSpace(v197)

                            v199 = math.abs(v200.X) <= v198.Size.X * 0.5 and math.abs(v200.Z) <= v198.Size.Z * 0.5
                        end

                        if v199 then
                            v193.Transparency = v189
                        else
                            v193.Transparency = 1
                        end
                    end

                    if p46 ~= nil and not (v188 >= 1) then
                        local v201 = p46.Position.Y - p45

                        if math.abs(v201) <= t1.HAZARD_JUMP_CLEARANCE and math.abs(Vector3.new(p46.Position.X - p44.X, 0, p46.Position.Z - p44.Z).Magnitude - v186) <= t1.HAZARD_THICKNESS * 0.5 + t1.HAZARD_TOUCH_PADDING then
                            local Position = p46.Position
                            local v206 = v15

                            if v206 ~= nil then
                                local v207 = v206.CFrame:PointToObjectSpace(Position)

                                if math.abs(v207.X) <= v206.Size.X * 0.5 and math.abs(v207.Z) <= v206.Size.Z * 0.5 then
                                    local RING_KIND = t1.RING_KIND
                                    local elapsed = os.clock()

                                    if not (elapsed - (t6[RING_KIND] or 0) < t1.HAZARD_REPORT_INTERVAL) then
                                        t6[RING_KIND] = elapsed
                                        Remotes.BossEvent.HazardHit:FireServer(RING_KIND)
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end

        local function stepHazards() -- line: 1004
            -- upvalues: LocalPlayer (copy), v15 (ref), v16 (ref), v19 (ref), v20 (ref), n1 (ref), t4 (ref), t5 (ref), v21 (ref), v26 (ref), n4 (ref), n5 (ref), stepRotatingX (copy), stepRings (copy), Workspace (copy), Player (copy), t1 (copy)
            local v208 = v16
            local v209 = v15
            local v210 = if v208 == nil or v26 then nil else v208.Model:GetAttribute(t1.PHASE_TWO_AT_ATTRIBUTE)

            if v208 ~= nil and v209 ~= nil and typeof(v210) == "number" and not (n5 <= 0) then
                local v211 = Workspace:GetServerTimeNow() - v210 - t1.HAZARD_START_DELAY_SECONDS

                if v211 < 0 then
                    if v20 ~= nil then
                        v20 = nil

                        local v212 = v19

                        v19 = nil
                        t4 = {}
                        t5 = {}

                        if v212 ~= nil then
                            v212:Destroy()
                        end
                    end
                else
                    local v214 = math.floor(v211 / n5)
                    local v215 = v211 - v214 * n5
                    local v216 = t1.X_TELEGRAPH_SECONDS + t1.X_ACTIVE_SECONDS
                    local v217 = v216 + t1.HAZARD_GAP_SECONDS
                    local v218 = if v215 < t1.X_TELEGRAPH_SECONDS then "XTelegraph"
                        elseif v215 < v216 then "XActive"
                        elseif v217 <= v215 and v215 < v217 + n4 then "Rings"
                        else nil

                    if v218 ~= v20 or v214 ~= n1 then
                        local v219 = v19

                        v19 = nil
                        t4 = {}
                        t5 = {}

                        if v219 ~= nil then
                            v219:Destroy()
                        end

                        v20 = v218
                        n1 = v214
                    end

                    if v218 ~= nil then
                        local v220 = Player.FindRootPart(LocalPlayer)
                        local v221 = Player.FindHumanoid(LocalPlayer)

                        if v220 ~= nil and (not v220:IsA("BasePart") or v221 == nil or not (v221.Health > 0)) then
                            v220 = nil
                        end

                        local v222 = v21
                        local v223 = v209.Position.Y + v209.Size.Y * 0.5 + t1.HAZARD_HOVER + t1.HAZARD_THICKNESS * 0.5

                        if v218 == "Rings" then
                            stepRings(v215 - v217, v222, v223, v220)
                        elseif v218 == "XTelegraph" then
                            stepRotatingX(true, v215, v222, v223, v220)
                        else
                            stepRotatingX(false, v215 - t1.X_TELEGRAPH_SECONDS, v222, v223, v220)
                        end
                    end
                end
            else
                if v20 == nil then
                    return
                end

                v20 = nil

                local v224 = v19

                v19 = nil
                t4 = {}
                t5 = {}

                if v224 ~= nil then
                    v224:Destroy()
                end
            end
        end

        local function clearArmBeam() -- line: 1071
            -- upvalues: clone (ref), Attachment (ref)
            local clone2 = clone
            local Attachment2 = Attachment

            clone = nil
            Attachment = nil

            if clone2 ~= nil then
                clone2:Destroy()
            end

            if Attachment2 ~= nil then
                Attachment2:Destroy()
            end
        end

        local function stepArmBeam() -- line: 1088
            -- upvalues: LocalPlayer (copy), v7 (copy), v16 (ref), clone (ref), Attachment (ref), v22 (ref), Player (copy), t1 (copy)
            local v225 = v16

            if v225 ~= nil and v225.HandBone:FindFirstChild(t1.HEALTH_GUI_NAME) ~= nil then
                local Attribute = LocalPlayer:GetAttribute(t1.ARM_HITS_ATTRIBUTE)

                if type(Attribute) ~= "number" then
                    Attribute = 0
                end

                local v226 = v22 or Attribute

                v22 = v226

                local v227 = Player.FindRootPart(LocalPlayer)

                if v227 ~= nil and v227:IsA("BasePart") and not (Attribute - v226 >= t1.ARM_BEAM_HIT_LIMIT) then
                    local clone2 = clone
                    local Attachment2 = Attachment

                    if clone2 ~= nil and Attachment2 ~= nil and Attachment2.Parent == v227 and clone2.Attachment1 == v225.HandBone then
                        return
                    end

                    local clone3 = clone
                    local Attachment3 = Attachment

                    clone = nil
                    Attachment = nil

                    if clone3 ~= nil then
                        clone3:Destroy()
                    end

                    if Attachment3 ~= nil then
                        Attachment3:Destroy()
                    end

                    local Attachment4 = Instance.new("Attachment")

                    Attachment4.Name = "BossArmBeamOrigin"
                    Attachment4.Parent = v227
                    Attachment = Attachment4

                    local clone4 = v7:Clone()

                    clone4.Attachment0 = Attachment4
                    clone4.Attachment1 = v225.HandBone
                    clone4.Parent = Attachment4
                    clone = clone4
                else
                    local clone2 = clone
                    local Attachment2 = Attachment

                    clone = nil
                    Attachment = nil

                    if clone2 ~= nil then
                        clone2:Destroy()
                    end

                    if Attachment2 ~= nil then
                        Attachment2:Destroy()
                    end
                end
            else
                v22 = nil

                local clone2 = clone
                local Attachment2 = Attachment

                clone = nil
                Attachment = nil

                if clone2 ~= nil then
                    clone2:Destroy()
                end

                if Attachment2 ~= nil then
                    Attachment2:Destroy()
                end
            end
        end

        local function clearCrystalBeam() -- line: 1130
            -- upvalues: clone3 (ref), Attachment4 (ref), Attachment5 (ref)
            local clone = clone3
            local Attachment = Attachment4
            local Attachment2 = Attachment5

            clone3 = nil
            Attachment4 = nil
            Attachment5 = nil

            if clone ~= nil then
                clone:Destroy()
            end

            if Attachment ~= nil then
                Attachment:Destroy()
            end

            if Attachment2 ~= nil then
                Attachment2:Destroy()
            end
        end

        local function nearestCrystal(p47) -- line: 1150
            -- upvalues: v14 (ref), t1 (copy)
            local v228 = v14
            local v229 = if v228 == nil then nil else v228:FindFirstChild(t1.CRYSTAL_FOLDER_NAME)

            if v229 == nil then
                return nil
            end

            local n13 = 1e999
            local v230

            for _, child in v229:GetChildren() do
                local v231 = child:FindFirstChild(t1.CRYSTAL_HITBOX_NAME)

                if v231 ~= nil and v231:IsA("BasePart") then
                    local Attribute = v231:GetAttribute(t1.CRYSTAL_HEALTH_ATTRIBUTE)

                    if type(Attribute) == "number" and not (Attribute <= 0) then
                        local Magnitude = (v231.Position - p47).Magnitude

                        if Magnitude < n13 then
                            n13 = Magnitude
                            v230 = v231
                        end
                    end
                end
            end

            return v230
        end

        local function stepCrystalBeam() -- line: 1179
            -- upvalues: LocalPlayer (copy), v7 (copy), v16 (ref), clone3 (ref), Attachment4 (ref), Attachment5 (ref), n2 (ref), v25 (ref), v26 (ref), nearestCrystal (copy), Workspace (copy), Notifications (copy), Player (copy), t1 (copy)
            local v232 = v16

            if v232 ~= nil and not v26 and not v232.Model:GetAttribute(t1.SPAWNING_ATTRIBUTE) and v232.Model:GetAttribute(t1.PHASE_TWO_AT_ATTRIBUTE) == nil then
                local ServerTimeNow = Workspace:GetServerTimeNow()

                if n2 == 0 then
                    n2 = ServerTimeNow
                end

                local Attribute = LocalPlayer:GetAttribute(t1.CRYSTAL_HITS_ATTRIBUTE)

                if type(Attribute) ~= "number" then
                    Attribute = 0
                end

                if t1.CRYSTAL_BEAM_HIT_LIMIT <= Attribute then
                    local clone = clone3
                    local Attachment = Attachment4
                    local Attachment2 = Attachment5

                    clone3 = nil
                    Attachment4 = nil
                    Attachment5 = nil

                    if clone ~= nil then
                        clone:Destroy()
                    end

                    if Attachment ~= nil then
                        Attachment:Destroy()
                    end

                    if Attachment2 ~= nil then
                        Attachment2:Destroy()
                    end
                else
                    if not v25 and ServerTimeNow - n2 >= t1.CRYSTAL_HINT_DELAY then
                        v25 = true
                        Notifications.Toast.Show({
                            Lane = "Banner",
                            Text = t1.CRYSTAL_HINT_MESSAGE,
                            Seconds = t1.CRYSTAL_HINT_SECONDS,
                            Color = t1.CRYSTAL_HINT_COLOR
                        })
                    end

                    local v233 = Player.FindRootPart(LocalPlayer)
                    local v234 = if v233 == nil or not v233:IsA("BasePart") then nil else nearestCrystal(v233.Position)

                    if v233 ~= nil and v233:IsA("BasePart") and v234 ~= nil then
                        local Attachment = Attachment4
                        local Attachment2 = Attachment5

                        if Attachment ~= nil and Attachment2 ~= nil and Attachment.Parent == v233 then
                            if Attachment2.Parent ~= v234 then
                                Attachment2.Parent = v234
                            end

                            return
                        end

                        local clone = clone3
                        local Attachment3 = Attachment4
                        local Attachment6 = Attachment5

                        clone3 = nil
                        Attachment4 = nil
                        Attachment5 = nil

                        if clone ~= nil then
                            clone:Destroy()
                        end

                        if Attachment3 ~= nil then
                            Attachment3:Destroy()
                        end

                        if Attachment6 ~= nil then
                            Attachment6:Destroy()
                        end

                        local Attachment7 = Instance.new("Attachment")

                        Attachment7.Name = "BossCrystalBeamOrigin"
                        Attachment7.Parent = v233
                        Attachment4 = Attachment7

                        local Attachment8 = Instance.new("Attachment")

                        Attachment8.Name = "BossCrystalBeamTarget"
                        Attachment8.Parent = v234
                        Attachment5 = Attachment8

                        local clone2 = v7:Clone()

                        clone2.Attachment0 = Attachment7
                        clone2.Attachment1 = Attachment8
                        clone2.Parent = Attachment7
                        clone3 = clone2
                    else
                        local clone = clone3
                        local Attachment = Attachment4
                        local Attachment2 = Attachment5

                        clone3 = nil
                        Attachment4 = nil
                        Attachment5 = nil

                        if clone ~= nil then
                            clone:Destroy()
                        end

                        if Attachment ~= nil then
                            Attachment:Destroy()
                        end

                        if Attachment2 ~= nil then
                            Attachment2:Destroy()
                        end
                    end
                end
            else
                n2 = 0

                local clone = clone3
                local Attachment = Attachment4
                local Attachment2 = Attachment5

                clone3 = nil
                Attachment4 = nil
                Attachment5 = nil

                if clone ~= nil then
                    clone:Destroy()
                end

                if Attachment ~= nil then
                    Attachment:Destroy()
                end

                if Attachment2 ~= nil then
                    Attachment2:Destroy()
                end
            end
        end

        local function clearShopBeam() -- line: 1247
            -- upvalues: clone2 (ref), Attachment3 (ref)
            local clone = clone2
            local Attachment = Attachment3

            clone2 = nil
            Attachment3 = nil

            if clone ~= nil then
                clone:Destroy()
            end

            if Attachment ~= nil then
                Attachment:Destroy()
            end
        end

        local function bindShopStand(p48) -- line: 1262
            -- upvalues: v9 (copy), v23 (ref), Attachment2 (ref), clone2 (ref), Attachment3 (ref), v24 (ref), Pads (copy), Tabs (copy), t1 (copy)
            local v235 = p48:WaitForChild(t1.SHOP_ZONE_NAME, 5)

            assert(v235 ~= nil and v235:IsA("BasePart"), (("%* needs a %* part"):format(t1.SHOP_STAND_NAME, t1.SHOP_ZONE_NAME)))
            v23 = p48

            local Attachment = Instance.new("Attachment")

            Attachment.Name = "BossShopBeamTarget"
            Attachment.Position = Vector3.new(0, t1.SHOP_BEAM_LIFT, 0)
            Attachment.Parent = v235
            Attachment2 = Attachment
            v9:Add(Attachment)
            v9:Add(Pads.Track(v235, {
                Entered = function() -- Entered | line: 1275
                    -- upvalues: clone2 (ref), Attachment3 (ref), v24 (ref), Tabs (copy), t1 (copy)
                    v24 = true

                    local clone = clone2
                    local Attachment = Attachment3

                    clone2 = nil
                    Attachment3 = nil

                    if clone ~= nil then
                        clone:Destroy()
                    end

                    if Attachment ~= nil then
                        Attachment:Destroy()
                    end

                    Tabs.Activate(t1.SHOP_TAB_NAME)
                end,
                Left = function() -- Left | line: 1281
                    -- upvalues: Tabs (copy), t1 (copy)
                    if Tabs.Active() == t1.SHOP_TAB_NAME then
                        Tabs.Deactivate({
                            instant = true
                        })
                    end
                end
            }))
        end

        local function stepShopStand() -- line: 1289
            -- upvalues: LocalPlayer (copy), v7 (copy), v14 (ref), v23 (ref), Attachment2 (ref), clone2 (ref), Attachment3 (ref), v24 (ref), bindShopStand (copy), Player (copy), t1 (copy)
            local v238 = v14
            local v239 = if v238 == nil then nil else v238:FindFirstChild(t1.SHOP_STAND_NAME)
            local v240 = true

            if v239 ~= nil then
                if v239:IsA("Model") then
                    if v23 ~= v239 then
                        bindShopStand(v239)
                    end

                    v240 = false
                end
            end

            if v240 then
                return
            end

            local Attachment = Attachment2
            local v241 = Player.FindRootPart(LocalPlayer)

            if Attachment ~= nil and v241 ~= nil and v241:IsA("BasePart") and not v24 then
                local clone = clone2
                local Attachment2 = Attachment3

                if clone ~= nil and Attachment2 ~= nil and Attachment2.Parent == v241 then
                    return
                end

                local clone3 = clone2
                local Attachment4 = Attachment3

                clone2 = nil
                Attachment3 = nil

                if clone3 ~= nil then
                    clone3:Destroy()
                end

                if Attachment4 ~= nil then
                    Attachment4:Destroy()
                end

                local Attachment5 = Instance.new("Attachment")

                Attachment5.Name = "BossShopBeamOrigin"
                Attachment5.Parent = v241
                Attachment3 = Attachment5

                local clone4 = v7:Clone()

                clone4.Attachment0 = Attachment5
                clone4.Attachment1 = Attachment
                clone4.Parent = Attachment5
                clone2 = clone4
            else
                local clone = clone2
                local Attachment = Attachment3

                clone2 = nil
                Attachment3 = nil

                if clone ~= nil then
                    clone:Destroy()
                end

                if Attachment ~= nil then
                    Attachment:Destroy()
                end
            end
        end

        local function watchBoss(p49) -- line: 1325
            -- upvalues: v10 (copy), v16 (ref), Part (ref), v17 (ref), v18 (ref), findBoss (copy), t1 (copy)
            v10:Clean()

            local function bind() -- line: 1327
                -- upvalues: p49 (copy), v10 (copy), v16 (ref), Part (ref), v17 (ref), v18 (ref), findBoss (copy)
                local v242 = findBoss(p49)

                if v242 ~= nil then
                    v16 = v242
                    v10:Add(function() -- line: 1333
                        -- upvalues: v16 (ref), Part (ref), v17 (ref), v18 (ref)
                        v16 = nil

                        local Part2 = Part

                        Part = nil
                        v17 = nil
                        v18 = nil

                        if Part2 ~= nil then
                            Part2:Destroy()
                        end
                    end)
                end
            end

            local v243 = findBoss(p49)

            if v243 ~= nil then
                v16 = v243
                v10:Add(function() -- line: 1333
                    -- upvalues: v16 (ref), Part (ref), v17 (ref), v18 (ref)
                    v16 = nil

                    local Part2 = Part

                    Part = nil
                    v17 = nil
                    v18 = nil

                    if Part2 ~= nil then
                        Part2:Destroy()
                    end
                end)
            end

            if v16 == nil then
                v10:Connect(p49.ChildAdded, function(p50) -- line: 1341
                    -- upvalues: bind (copy), v16 (ref), t1 (copy)
                    if p50.Name == t1.BOSS_MODEL_NAME and v16 == nil then
                        task.defer(bind)
                    end
                end)
            end
        end

        local function onEnterArena() -- line: 1349
            -- upvalues: LocalPlayer (copy), v1 (copy), tween (ref), v9 (copy), v10 (copy), v14 (ref), v15 (ref), Part (ref), v17 (ref), v18 (ref), v19 (ref), v20 (ref), n1 (ref), t4 (ref), t5 (ref), v21 (ref), clone (ref), Attachment (ref), v22 (ref), v23 (ref), Attachment2 (ref), clone2 (ref), Attachment3 (ref), v24 (ref), clone3 (ref), Attachment4 (ref), Attachment5 (ref), n2 (ref), v25 (ref), v26 (ref), n5 (ref), n6 (ref), n7 (ref), n8 (ref), playVfx (copy), stepUi (copy), showUi (copy), stepBlackHole (copy), measureHazardCycle (copy), stepHazards (copy), stepArmBeam (copy), stepCrystalBeam (copy), stepShopStand (copy), watchBoss (copy), RunService (copy), TweenService (copy), Workspace (copy), SoundService (copy), LightingController (copy), Remotes (copy), Tabs (copy), t1 (copy)
            v9:Clean()
            n6 = Workspace:GetServerTimeNow()
            n7 = 0
            n8 = 0
            LightingController.SetLayer(t1.LIGHTING_LAYER, "RiftBoss", t1.LIGHTING_RANK, t1.LIGHTING_SPAN)
            v9:Add(function() -- line: 1356
                -- upvalues: v1 (copy), tween (ref), v10 (copy), v14 (ref), v15 (ref), Part (ref), v17 (ref), v18 (ref), v19 (ref), v20 (ref), n1 (ref), t4 (ref), t5 (ref), clone (ref), Attachment (ref), v22 (ref), v23 (ref), Attachment2 (ref), clone2 (ref), Attachment3 (ref), v24 (ref), clone3 (ref), Attachment4 (ref), Attachment5 (ref), n2 (ref), v25 (ref), v26 (ref), n5 (ref), TweenService (copy), SoundService (copy), LightingController (copy), Tabs (copy), t1 (copy)
                LightingController.ClearLayer(t1.LIGHTING_LAYER, t1.LIGHTING_SPAN)
                v10:Clean()

                local Part2 = Part

                Part = nil
                v17 = nil
                v18 = nil

                if Part2 ~= nil then
                    Part2:Destroy()
                end

                local v244 = v19

                v19 = nil
                t4 = {}
                t5 = {}

                if v244 ~= nil then
                    v244:Destroy()
                end

                local clone4 = clone
                local Attachment6 = Attachment

                clone = nil
                Attachment = nil

                if clone4 ~= nil then
                    clone4:Destroy()
                end

                if Attachment6 ~= nil then
                    Attachment6:Destroy()
                end

                local clone5 = clone2
                local Attachment7 = Attachment3

                clone2 = nil
                Attachment3 = nil

                if clone5 ~= nil then
                    clone5:Destroy()
                end

                if Attachment7 ~= nil then
                    Attachment7:Destroy()
                end

                local clone6 = clone3
                local Attachment8 = Attachment4
                local Attachment9 = Attachment5

                clone3 = nil
                Attachment4 = nil
                Attachment5 = nil

                if clone6 ~= nil then
                    clone6:Destroy()
                end

                if Attachment8 ~= nil then
                    Attachment8:Destroy()
                end

                if Attachment9 ~= nil then
                    Attachment9:Destroy()
                end

                n2 = 0
                v25 = false
                v22 = nil
                v23 = nil
                Attachment2 = nil
                v24 = false
                v26 = false

                if Tabs.Active() == t1.SHOP_TAB_NAME then
                    Tabs.Deactivate({
                        instant = true
                    })
                end

                v20 = nil
                n1 = -1
                n5 = 0
                v14 = nil
                v15 = nil

                local tween2 = tween

                if tween2 ~= nil then
                    tween2:Cancel()
                end

                local tween3 = TweenService:Create(v1, t1.MUSIC_FADE_INFO, {
                    Volume = 0
                })

                tween = tween3
                tween3:Play()
                SoundService.Music.GameMusic.Volume = 1
            end)

            if v1.IsPlaying then
                local MUSIC_VOLUME = t1.MUSIC_VOLUME
                local tween2 = tween

                if tween2 ~= nil then
                    tween2:Cancel()
                end

                local tween3 = TweenService:Create(v1, t1.MUSIC_FADE_INFO, {
                    Volume = MUSIC_VOLUME
                })

                tween = tween3
                tween3:Play()
            end

            SoundService.Music.GameMusic.Volume = 0
            v9:Connect(LocalPlayer.CharacterAdded, function() -- line: 1393
                -- upvalues: Part (ref), v17 (ref), v18 (ref), n6 (ref), Workspace (copy)
                n6 = Workspace:GetServerTimeNow()

                local Part2 = Part

                Part = nil
                v17 = nil
                v18 = nil

                if Part2 ~= nil then
                    Part2:Destroy()
                end
            end)
            v9:Connect(Remotes.BossEvent.Vfx.OnClientEvent, playVfx)

            local v245 = Workspace:WaitForChild(t1.ARENA_MODEL_NAME, 5)

            assert(v245 ~= nil and v245:IsA("Model"), (("Entered the Boss World but Workspace.%* is missing"):format(t1.ARENA_MODEL_NAME)))

            if not LocalPlayer:GetAttribute(t1.IN_ARENA_ATTRIBUTE) then
                v9:Clean()

                return
            end

            local v248 = v245:WaitForChild(t1.FLOOR_NAME, 5)

            assert(v248 ~= nil and v248:IsA("BasePart"), (("%* needs a %* part"):format(t1.ARENA_MODEL_NAME, t1.FLOOR_NAME)))

            local v251 = v245:WaitForChild(t1.BOSS_SPAWN_NAME, 5)

            assert(v251 ~= nil and v251:IsA("BasePart"), (("%* needs a %* part"):format(t1.ARENA_MODEL_NAME, t1.BOSS_SPAWN_NAME)))
            v14 = v245
            v15 = v248
            v21 = v251.Position
            measureHazardCycle(v248, v251.Position)
            watchBoss(v245)
            showUi()

            if LocalPlayer:GetAttribute(t1.IN_ARENA_ATTRIBUTE) then
                v9:Connect(RunService.Heartbeat, function(p51) -- line: 1423
                    -- upvalues: stepUi (copy), stepBlackHole (copy), stepHazards (copy), stepArmBeam (copy), stepCrystalBeam (copy), stepShopStand (copy)
                    stepBlackHole(p51)
                    stepHazards()
                    stepArmBeam()
                    stepCrystalBeam()
                    stepShopStand()
                    stepUi()
                end)
            else
                v9:Clean()
            end
        end

        local function onArenaStateChanged() -- line: 1433
            -- upvalues: LocalPlayer (copy), v9 (copy), onEnterArena (copy), t1 (copy)
            if LocalPlayer:GetAttribute(t1.IN_ARENA_ATTRIBUTE) then
                onEnterArena()
            else
                v9:Clean()
            end
        end

        local function recordPortalPiece(p52) -- line: 1441
            -- upvalues: t3 (ref)
            if p52:IsA("BasePart") then
                local t16 = t3

                t16[p52] = {
                    Solidity = {
                        CanCollide = p52.CanCollide,
                        CanQuery = p52.CanQuery,
                        CanTouch = p52.CanTouch
                    }
                }
            else
                if not p52:IsA("ParticleEmitter") and not p52:IsA("Beam") and not p52:IsA("Light") and not p52:IsA("BillboardGui") then
                    if not p52:IsA("Sound") then
                        return false
                    end

                    local t17 = t3

                    t17[p52] = {
                        Volume = p52.Volume
                    }

                    return true
                end

                local t18 = t3

                t18[p52] = {
                    Effect = p52.Enabled
                }
            end

            return true
        end

        local function applyPortalPiece(p53, p54, p55) -- line: 1461
            local Solidity = p54.Solidity

            if Solidity ~= nil then
                p53.LocalTransparencyModifier = p55 and 0 or 1

                if p55 then
                    p53.CanCollide = Solidity.CanCollide
                else
                    p53.CanCollide = false
                end

                if p55 then
                    p53.CanQuery = Solidity.CanQuery
                else
                    p53.CanQuery = false
                end

                if p55 then
                    p53.CanTouch = Solidity.CanTouch
                else
                    p53.CanTouch = false
                end
            elseif p54.Effect ~= nil then
                if p55 then
                    p53.Enabled = p54.Effect
                else
                    p53.Enabled = false
                end
            elseif p54.Volume ~= nil then
                if p55 then
                    p53.Volume = p54.Volume
                else
                    p53.Volume = 0
                end
            end
        end

        local function refreshPortal() -- line: 1476
            -- upvalues: LocalPlayer (copy), v12 (ref), t3 (ref), v13 (ref), applyPortalPiece (copy), BossEventFlags (copy), RiftEligibility (copy), Save (copy)
            if v12 == nil then
                return
            end

            local v254 = Save.Await()
            local v255 = if v254 == nil then 0 else v254.SpeedPower
            local v256 = if v254 == nil then 0 else v254.LastLogout
            local v257 = BossEventFlags.ContentEnabled:Get() and RiftEligibility.IsRevealed(LocalPlayer, v255, v256)

            if v13 ~= v257 then
                v13 = v257

                for v258, v259 in t3 do
                    applyPortalPiece(v258, v259, v257)
                end
            end
        end

        local function adoptPortal(p56) -- line: 1494
            -- upvalues: v11 (copy), v12 (ref), t3 (ref), v13 (ref), recordPortalPiece (copy), applyPortalPiece (copy), refreshPortal (copy)
            v11:Clean()
            v12 = p56
            t3 = {}
            v13 = nil
            v11:Add(function() -- line: 1499
                -- upvalues: v12 (ref), t3 (ref), v13 (ref)
                v12 = nil
                t3 = {}
                v13 = nil
            end)

            for _, descendant in p56:GetDescendants() do
                recordPortalPiece(descendant)
            end

            v11:Connect(p56.DescendantAdded, function(p57) -- line: 1507
                -- upvalues: t3 (ref), v13 (ref), recordPortalPiece (copy), applyPortalPiece (copy)
                if not recordPortalPiece(p57) then
                    return
                end

                local v260 = v13
                local v261 = t3[p57]

                if v260 ~= nil and v261 ~= nil then
                    applyPortalPiece(p57, v261, v260)
                end
            end)
            v11:Connect(p56.DescendantRemoving, function(p58) -- line: 1517
                -- upvalues: t3 (ref)
                t3[p58] = nil
            end)
            refreshPortal()
        end

        Remotes.BossEvent.BossDamaged.OnClientEvent:Connect(flashOutline)
        Remotes.BossEvent.StateShifted.OnClientEvent:Connect(function(p59) -- line: 1527
            -- upvalues: v1 (copy), v28 (ref), connection2 (ref), fadeMusic (copy), stepCountdown (copy), RunService (copy)
            local BossSpawnsAt = p59.BossSpawnsAt

            v28 = BossSpawnsAt

            if BossSpawnsAt ~= nil and connection2 == nil then
                connection2 = RunService.Heartbeat:Connect(function() -- line: 489
                    -- upvalues: stepCountdown (copy)
                    stepCountdown()
                end)
            end

            stepCountdown()

            if not p59.Open then
                if not v1.IsPlaying then
                    return
                end

                fadeMusic(0, true)
            end
        end)
        LocalPlayer:GetAttributeChangedSignal(t1.IN_ARENA_ATTRIBUTE):Connect(onArenaStateChanged)

        if LocalPlayer:GetAttribute(t1.IN_ARENA_ATTRIBUTE) then
            onEnterArena()
        else
            v9:Clean()
        end

        task.spawn(function() -- line: 1536
            -- upvalues: v28 (ref), connection2 (ref), stepCountdown (copy), RunService (copy), Remotes (copy)
            local BossSpawnsAt = Remotes.BossEvent.AskSnapshot:InvokeServer().BossSpawnsAt

            v28 = BossSpawnsAt

            if BossSpawnsAt ~= nil and connection2 == nil then
                connection2 = RunService.Heartbeat:Connect(function() -- line: 489
                    -- upvalues: stepCountdown (copy)
                    stepCountdown()
                end)
            end

            stepCountdown()
        end)
        Workspace.ChildAdded:Connect(function(p60) -- line: 1540
            -- upvalues: adoptPortal (copy), t1 (copy)
            if p60.Name == t1.PORTAL_MODEL_NAME and p60:IsA("Model") then
                adoptPortal(p60)
            end
        end)
        Workspace.ChildRemoved:Connect(function(p61) -- line: 1545
            -- upvalues: v11 (copy), v12 (ref)
            if p61 == v12 then
                v11:Clean()
            end
        end)
        Save.WatchFields("SpeedPower", refreshPortal)
        RiftFlags.SpeedPowerRequirement.Changed:Connect(refreshPortal)
        BossEventFlags.ContentEnabled.Changed:Connect(refreshPortal)
        Workspace:GetAttributeChangedSignal(RiftEligibility.OpenAttribute):Connect(refreshPortal)
        LocalPlayer:GetAttributeChangedSignal(RiftEligibility.CutsceneSeenAttribute):Connect(refreshPortal)
        task.spawn(function() -- line: 1555
            -- upvalues: refreshPortal (copy), adoptPortal (copy), Workspace (copy), Save (copy), t1 (copy)
            local v262 = Workspace:FindFirstChild(t1.PORTAL_MODEL_NAME)

            if v262 ~= nil and v262:IsA("Model") then
                adoptPortal(v262)
            end

            Save.Await()
            refreshPortal()
        end)
    end
}
