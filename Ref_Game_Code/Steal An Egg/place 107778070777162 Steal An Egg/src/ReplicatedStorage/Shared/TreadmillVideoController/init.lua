-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local CollectionService = game:GetService("CollectionService")
local ContextActionService = game:GetService("ContextActionService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local SocialService = game:GetService("SocialService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local ButtonFX = require(ReplicatedStorage.Client.UI.VFX.ButtonFX)
local ButtonHintStrip = require(ReplicatedStorage.Client.ButtonHintStrip)
local CommentsController = require(script.CommentsController)
local Constants = require(ReplicatedStorage.Shared.Globals.Constants)
local FeedSequencer = require(script.FeedSequencer)
local FriendLikesController = require(script.FriendLikesController)
local GUI = require(ReplicatedStorage.Client.GUI)
local GamepadBindings = require(ReplicatedStorage.Client.GamepadBindings)
local ImageColorPulse = require(ReplicatedStorage.Client.UI.VFX.ImageColorPulse)
local LikeController = require(script.LikeController)
local Log = require(ReplicatedStorage.Packages.Log)
local Media = require(script.Media)
local PlatformController = require(ReplicatedStorage.Client.PlatformController)
local WarmAssets, WarmSounds = require(ReplicatedStorage.Shared.Utils.Preload).WarmAssets, require(ReplicatedStorage.Shared.Utils.Preload).WarmSounds
local RecommendationFeedSource = require(script.RecommendationFeedSource)
local RecommendationFlags = require(script.RecommendationFlags)
local RecommendationSignals = require(script.RecommendationSignals)
local Remotes = require(ReplicatedStorage.Shared.Remotes)
local Schema = require(script.Types.Schema)
local Signal = require(ReplicatedStorage.Packages.Signal)
local TouchTapTracker = require(ReplicatedStorage.Client.Input.TouchTapTracker)
local TreadmillMediaIdentity = require(ReplicatedStorage.Shared.Modules.TreadmillMediaIdentity)
local TreadmillMediaOverlay = require(ReplicatedStorage.Shared.Modules.TreadmillMediaOverlay)
local TreadmillUtil = require(ReplicatedStorage.Shared.Util.TreadmillUtil)
local Trove = require(ReplicatedStorage.Packages.Trove)

require(script.Types.Interface)

local VideoFramePool = require(script.VideoFramePool)
local TryCall = require(ReplicatedStorage.Shared.Utils.TryCall)
local v1 = TweenInfo.new(0.75, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, -1, false)
local Value = Enum.ContextActionPriority.High.Value
local ButtonL2, ButtonR2 = Enum.KeyCode.ButtonL2, Enum.KeyCode.ButtonR2
local v2 = TweenInfo.new(0.18, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
local v3 = TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
local v4 = Color3.fromRGB(255, 0, 0)
local v5 = TweenInfo.new(0.7, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut, -1, true)
local v6 = TweenInfo.new(0.45, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local v7 = TweenInfo.new(0.9, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local v8 = TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

task.spawn(WarmAssets, "rbxassetid://84371411600743", "rbxassetid://90908618020821")

local LocalPlayer = Players.LocalPlayer
local v9 = Log.new()
local v10 = GUI.TreadmillScreenButtonSwapLeft()

assert(v10:IsA("SurfaceGui"), "Treadmill left swap GUI must be a SurfaceGui")

local v11 = GUI.TreadmillScreenButtonSwapRight()

assert(v11:IsA("SurfaceGui"), "Treadmill right swap GUI must be a SurfaceGui")

local v12 = GUI.TreadmillScreenButtonShare()

assert(v12:IsA("SurfaceGui"), "Treadmill share GUI must be a SurfaceGui")

local v13 = GUI.TreadmillScreenSideButtons()

assert(v13:IsA("SurfaceGui"), "Treadmill side buttons GUI must be a SurfaceGui")

local v14 = GUI.TreadmillVideoSurfaceGui()

assert(v14:IsA("SurfaceGui"), "Treadmill video GUI must be a SurfaceGui")

local ButtonSwapLeft = v10.ButtonSwapLeft

assert(ButtonSwapLeft:IsA("GuiButton"), "Treadmill left swap button must be a GuiButton")

local ButtonSwapRight = v11.ButtonSwapRight

assert(ButtonSwapRight:IsA("ImageButton"), "Treadmill right swap button must be an ImageButton")

local GamepadGlyph = v10.ButtonSwapLeft.GamepadGlyph

assert(GamepadGlyph:IsA("GuiObject"), "Treadmill left swap glyph must be a GuiObject")
assert(GamepadGlyph:GetAttribute("GamepadKey") == "ButtonL1", "Treadmill left swap glyph must use ButtonL1")

local GamepadGlyph2 = v11.ButtonSwapRight.GamepadGlyph

assert(GamepadGlyph2:IsA("GuiObject"), "Treadmill right swap glyph must be a GuiObject")
assert(GamepadGlyph2:GetAttribute("GamepadKey") == "ButtonR1", "Treadmill right swap glyph must use ButtonR1")

local ShareButton = v12.Frame.ShareButton

assert(ShareButton:IsA("GuiButton"), "Treadmill share button must be a GuiButton")

local VideoFrame = v14.VideoFrame

assert(VideoFrame:IsA("Frame"), "Treadmill video frame container must be a Frame")

local MainVideo = VideoFrame.MainVideo

assert(MainVideo:IsA("VideoFrame"), "Treadmill main video must be a VideoFrame")

local StopPlay = VideoFrame.StopPlay

assert(StopPlay:IsA("ImageLabel"), "Treadmill stop-play indicator must be an ImageLabel")

local MusicImage = VideoFrame.MusicImage

assert(MusicImage:IsA("ImageLabel"), "Treadmill music image must be an ImageLabel")

local Loading = VideoFrame.Loading

assert(Loading:IsA("GuiObject"), "Treadmill video loading frame must be a GuiObject")

local Spin = Loading.Spin

assert(Spin:IsA("GuiObject"), "Treadmill video loading spinner must be a GuiObject")

local Bar = VideoFrame.Bar

assert(Bar:IsA("GuiObject"), "Treadmill video bar must be a GuiObject")

local Progress = Bar.Progress

assert(Progress:IsA("GuiObject"), "Treadmill video progress must be a GuiObject")

local GoToNext = VideoFrame.GoToNext

assert(GoToNext:IsA("Frame"), "Treadmill VideoFrame.GoToNext must be a Frame")

local Glow = GoToNext.Glow

assert(Glow:IsA("ImageLabel"), "Treadmill GoToNext.Glow must be an ImageLabel")

local Arrow = GoToNext.Arrow

assert(Arrow:IsA("ImageLabel"), "Treadmill GoToNext.Arrow must be an ImageLabel")

local ArrowShadow = GoToNext.ArrowShadow

assert(ArrowShadow:IsA("ImageLabel"), "Treadmill GoToNext.ArrowShadow must be an ImageLabel")

local Label = GoToNext.Label

assert(Label:IsA("TextLabel"), "Treadmill GoToNext.Label must be a TextLabel")

local LabelShadow = GoToNext.LabelShadow

assert(LabelShadow:IsA("TextLabel"), "Treadmill GoToNext.LabelShadow must be a TextLabel")

local ArrowPosition = Arrow.Position
local ArrowShadowPosition = ArrowShadow.Position
local Paused = VideoFrame.Paused

assert(Paused:IsA("Frame"), "Treadmill VideoFrame.Paused must be a Frame")

local Glow2 = Paused.Glow

assert(Glow2:IsA("ImageLabel"), "Treadmill Paused.Glow must be an ImageLabel")

local StopPlay2 = Paused.StopPlay

assert(StopPlay2:IsA("ImageLabel"), "Treadmill Paused.StopPlay must be an ImageLabel")

local EnjoyFree = StopPlay2:FindFirstChild("EnjoyFree")
local VideoCounter = VideoFrame:FindFirstChild("VideoCounter")
local t1 = {
    {
        Property = "BackgroundTransparency",
        Instance = GoToNext,
        Value = GoToNext.BackgroundTransparency
    },
    {
        Property = "ImageTransparency",
        Instance = Glow,
        Value = Glow.ImageTransparency
    },
    {
        Property = "ImageTransparency",
        Instance = Arrow,
        Value = Arrow.ImageTransparency
    },
    {
        Property = "ImageTransparency",
        Instance = ArrowShadow,
        Value = ArrowShadow.ImageTransparency
    },
    {
        Property = "TextTransparency",
        Instance = Label,
        Value = Label.TextTransparency
    },
    {
        Property = "TextTransparency",
        Instance = LabelShadow,
        Value = LabelShadow.TextTransparency
    }
}
local t2 = {
    {
        Property = "BackgroundTransparency",
        Instance = Paused,
        Value = Paused.BackgroundTransparency
    },
    {
        Property = "ImageTransparency",
        Instance = Glow2,
        Value = Glow2.ImageTransparency
    },
    {
        Property = "ImageTransparency",
        Instance = StopPlay2,
        Value = StopPlay2.ImageTransparency
    }
}

if EnjoyFree ~= nil and EnjoyFree:IsA("TextLabel") then
    table.insert(t2, {
        Property = "TextTransparency",
        Instance = EnjoyFree,
        Value = EnjoyFree.TextTransparency
    })
end

local n1 = 0
local v15 = nil
local t4
local v16 = table.clone(Media)

if Constants.IS_STUDIO then
    local spawn, v17 = Schema.TreadmillMediaEntries(v16)

    assert(spawn, (("Failed to validate treadmill video media entries: %*"):format(v17)))
end

TreadmillMediaOverlay.ApplyTo(v16)
task.spawn(function() -- line: 255
    -- upvalues: RecommendationFeedSource (copy), RecommendationFlags (copy), v16 (copy)
    RecommendationFlags.Enabled.Loaded:Wait()
    task.wait(math.random() * RecommendationFlags.PrefetchJitterSeconds:Get())
    RecommendationFeedSource.PrefetchFeed(v16)
end)

local t5 = {
    MediaChanged = Signal.new(),
    Stopped = Signal.new()
}

local function scaleUDim2(p1, p2) -- line: 271
    return UDim2.new(UDim.new(p1.X.Scale * p2, p1.X.Offset * p2), UDim.new(p1.Y.Scale * p2, p1.Y.Offset * p2))
end

local function cancelStopPlayTween(p3) -- line: 278
    local StopPlayTween = p3.StopPlayTween

    p3.StopPlayTween = nil

    if StopPlayTween ~= nil then
        StopPlayTween:Cancel()
    end
end

local function resetStopPlayIndicator(p4) -- line: 286
    local StopPlayTween = p4.StopPlayTween

    p4.StopPlayTween = nil

    if StopPlayTween ~= nil then
        StopPlayTween:Cancel()
    end

    p4.StopPlay.ImageTransparency = 0
    p4.StopPlay.Size = p4.StopPlayBaseSize
end

local function animateStopPlayIndicator(p5, p6) -- line: 292
    -- upvalues: TweenService (copy), v2 (copy), v3 (copy)
    local StopPlayTween = p5.StopPlayTween

    p5.StopPlayTween = nil

    if StopPlayTween ~= nil then
        StopPlayTween:Cancel()
    end

    local StopPlay = p5.StopPlay

    StopPlay.Visible = true
    StopPlay.Image = p6 and "rbxassetid://90908618020821" or "rbxassetid://84371411600743"
    StopPlay.ImageTransparency = 0

    local StopPlayBaseSize = p5.StopPlayBaseSize
    local v19 = if p6 then 1.24 else 0.76

    StopPlay.Size = UDim2.new(UDim.new(StopPlayBaseSize.X.Scale * v19, StopPlayBaseSize.X.Offset * v19), UDim.new(StopPlayBaseSize.Y.Scale * v19, StopPlayBaseSize.Y.Offset * v19))

    local tween = TweenService:Create(StopPlay, v2, {
        Size = p5.StopPlayBaseSize
    })

    p5.StopPlayTween = tween
    tween.Completed:Once(function() -- line: 308
        -- upvalues: p5 (copy), p6 (copy), StopPlay (copy), tween (copy), TweenService (copy), v3 (copy)
        if p5.StopPlayTween ~= tween then
            return
        end

        p5.StopPlayTween = nil

        if p6 then
            local tween = TweenService:Create(StopPlay, v3, {
                ImageTransparency = 1
            })

            p5.StopPlayTween = tween
            tween.Completed:Once(function() -- line: 322
                -- upvalues: tween (copy), p5 (copy), StopPlay (copy)
                if p5.StopPlayTween ~= tween then
                    return
                end

                p5.StopPlayTween = nil
                StopPlay.Visible = false
                StopPlay.ImageTransparency = 0
            end)
            tween:Play()
        end
    end)
    tween:Play()
end

local function playCardFadeIn(p7, p8, p9) -- line: 336
    -- upvalues: TweenService (copy)
    for _, v20 in p7 do
        local Instance = v20.Instance

        Instance[v20.Property] = 1

        local tween = TweenService:Create(v20.Instance, p9, {
            [v20.Property] = v20.Value
        })

        p8:Add(function() -- line: 343
            -- upvalues: v20 (copy), Instance (copy), tween (copy)
            tween:Cancel()
            Instance[v20.Property] = v20.Value
        end)
        tween:Play()
    end
end

local function hidePausedCard(p10) -- line: 351
    -- upvalues: Paused (copy)
    local PausedCardTrove = p10.PausedCardTrove

    p10.PausedCardTrove = nil

    if PausedCardTrove ~= nil then
        PausedCardTrove:Destroy()
    end

    Paused.Visible = false

    if p10.MusicSound ~= nil then
        p10.MusicImage.Visible = true
    end

    local PausedPreviewFrame, PausedPreviewBaseSize = p10.PausedPreviewFrame, p10.PausedPreviewBaseSize

    p10.PausedPreviewFrame = nil
    p10.PausedPreviewBaseSize = nil

    if PausedPreviewFrame ~= nil and PausedPreviewBaseSize ~= nil then
        PausedPreviewFrame.Size = PausedPreviewBaseSize
    end
end

local function showPausedCard(p11) -- line: 371
    -- upvalues: Trove (copy), v8 (copy), Paused (copy), EnjoyFree (copy), t2 (copy), playCardFadeIn (copy)
    if p11.PausedCardTrove == nil and p11.EndCardTrove == nil then
        local v21 = Trove.new()

        p11.PausedCardTrove = v21
        playCardFadeIn(t2, v21, v8)

        if EnjoyFree ~= nil and EnjoyFree:IsA("TextLabel") then
            EnjoyFree.Visible = not p11.HasPlayedMedia
        end

        Paused.Visible = true
        p11.MusicImage.Visible = false

        local v22 = p11.VideoFramePool.GetActiveFrame()

        if v22.TimePosition <= 0 and not v22.Playing then
            local function v23() -- line: 391
                -- upvalues: v22 (copy)
                v22:Play()
                v22:Pause()
                v22.TimePosition = 0
            end

            pcall(v23)
        end

        local Size = v22.Size
        local v26 = math.max(if Size.X.Scale > 0 then 1 / Size.X.Scale else 1, if Size.Y.Scale > 0 then 1 / Size.Y.Scale else 1)

        if not (v26 > 1) then
            return
        end

        p11.PausedPreviewFrame = v22
        p11.PausedPreviewBaseSize = Size
        v22.Size = UDim2.new(UDim.new(Size.X.Scale * v26, Size.X.Offset * v26), UDim.new(Size.Y.Scale * v26, Size.Y.Offset * v26))
    end
end

local function hideGoToNext(p12) -- line: 409
    -- upvalues: GoToNext (copy)
    local EndCardTrove = p12.EndCardTrove

    p12.EndCardTrove = nil

    if EndCardTrove ~= nil then
        EndCardTrove:Destroy()
    end

    GoToNext.Visible = false
end

local function spawnGoToNextPulse(p13) -- line: 418
    -- upvalues: TweenService (copy), v7 (copy), GoToNext (copy), Arrow (copy)
    local clone = Arrow:Clone()

    clone.Name = "ArrowPulse"
    clone.ZIndex = math.max(Arrow.ZIndex - 1, 0)
    clone.ImageTransparency = 0.35
    clone.Parent = GoToNext
    p13:Add(clone)

    local t6 = {
        ImageTransparency = 1
    }
    local Size = Arrow.Size

    t6.Size = UDim2.new(UDim.new(Size.X.Scale * 2.2, Size.X.Offset * 2.2), UDim.new(Size.Y.Scale * 2.2, Size.Y.Offset * 2.2))

    local tween = TweenService:Create(clone, v7, t6)

    tween.Completed:Once(function() -- line: 430
        -- upvalues: clone (copy)
        clone:Destroy()
    end)
    tween:Play()
end

local function showGoToNext(p14) -- line: 436
    -- upvalues: Trove (copy), v6 (copy), GoToNext (copy), Arrow (copy), ArrowShadow (copy), ArrowPosition (copy), ArrowShadowPosition (copy), Paused (copy), t1 (copy), playCardFadeIn (copy), spawnGoToNextPulse (copy)
    if p14.EndCardTrove ~= nil then
        return
    end

    local PausedCardTrove = p14.PausedCardTrove

    p14.PausedCardTrove = nil

    if PausedCardTrove ~= nil then
        PausedCardTrove:Destroy()
    end

    Paused.Visible = false

    if p14.MusicSound ~= nil then
        p14.MusicImage.Visible = true
    end

    local PausedPreviewFrame, PausedPreviewBaseSize = p14.PausedPreviewFrame, p14.PausedPreviewBaseSize

    p14.PausedPreviewFrame = nil
    p14.PausedPreviewBaseSize = nil

    if PausedPreviewFrame ~= nil and PausedPreviewBaseSize ~= nil then
        PausedPreviewFrame.Size = PausedPreviewBaseSize
    end

    local v28 = Trove.new()

    p14.EndCardTrove = v28
    p14.StopPlay.Visible = false
    p14.SideButtonsSurfaceGui.Enabled = false
    p14.ShareSurfaceGui.Enabled = false
    playCardFadeIn(t1, v28, v6)
    GoToNext.Visible = true

    local v29 = GoToNext:GetAttribute("SwaySeconds") or 1.2
    local v30 = GoToNext:GetAttribute("SwayScale") or 0.02
    local elapsed = os.clock()
    local n2 = 0

    v28:BindToRenderStep("TreadmillGoToNextCard", Enum.RenderPriority.Last.Value, function() -- line: 454
        -- upvalues: v28 (copy), v29 (copy), v30 (copy), elapsed (copy), n2 (ref), Arrow (copy), ArrowShadow (copy), ArrowPosition (copy), ArrowShadowPosition (copy), spawnGoToNextPulse (copy)
        local v31 = os.clock() - elapsed
        local v33 = math.sin(v31 * 3.141592653589793 * 2 / v29) * v30
        local v34 = UDim2.fromScale(v33, 0)

        Arrow.Position = ArrowPosition + v34
        ArrowShadow.Position = ArrowShadowPosition + v34

        local v36 = math.floor(v31 / v29 + 0.75)

        if n2 < v36 then
            n2 = v36
            spawnGoToNextPulse(v28)
        end
    end)
    v28:Add(function() -- line: 468
        -- upvalues: Arrow (copy), ArrowShadow (copy), ArrowPosition (copy), ArrowShadowPosition (copy)
        Arrow.Position = ArrowPosition
        ArrowShadow.Position = ArrowShadowPosition
    end)
end

local function setSoundPlaying(p15, p16) -- line: 474
    if p16 then
        if p15.TimePosition > 0 then
            p15:Resume()
        else
            p15:Play()
        end
    else
        p15:Pause()
    end
end

local function setMediaPlaying(p17, p18, p19) -- line: 486
    -- upvalues: Paused (copy), animateStopPlayIndicator (copy), showPausedCard (copy)
    local MusicSound = p17.MusicSound

    if MusicSound ~= nil then
        if p18 then
            if MusicSound.TimePosition > 0 then
                MusicSound:Resume()
            else
                MusicSound:Play()
            end
        else
            MusicSound:Pause()
        end
    elseif p18 then
        p17.VideoFramePool.GetActiveFrame():Play()

        local VideoBackgroundMusicSound = p17.VideoBackgroundMusicSound

        if VideoBackgroundMusicSound ~= nil then
            if VideoBackgroundMusicSound.TimePosition > 0 then
                VideoBackgroundMusicSound:Resume()
            else
                VideoBackgroundMusicSound:Play()
            end
        end
    else
        p17.VideoFramePool.GetActiveFrame():Pause()

        local VideoBackgroundMusicSound = p17.VideoBackgroundMusicSound

        if VideoBackgroundMusicSound ~= nil then
            VideoBackgroundMusicSound:Pause()
        end
    end

    if p18 then
        p17.HasPlayedMedia = true

        local PausedCardTrove = p17.PausedCardTrove

        p17.PausedCardTrove = nil

        if PausedCardTrove ~= nil then
            PausedCardTrove:Destroy()
        end

        Paused.Visible = false

        if p17.MusicSound ~= nil then
            p17.MusicImage.Visible = true
        end

        local PausedPreviewFrame, PausedPreviewBaseSize = p17.PausedPreviewFrame, p17.PausedPreviewBaseSize

        p17.PausedPreviewFrame = nil
        p17.PausedPreviewBaseSize = nil

        if PausedPreviewFrame ~= nil and PausedPreviewBaseSize ~= nil then
            PausedPreviewFrame.Size = PausedPreviewBaseSize
        end
    else
        showPausedCard(p17)
    end

    if p19 ~= false then
        animateStopPlayIndicator(p17, p18)

        return
    end

    local StopPlayTween = p17.StopPlayTween

    p17.StopPlayTween = nil

    if StopPlayTween ~= nil then
        StopPlayTween:Cancel()
    end

    p17.StopPlay.ImageTransparency = 0
    p17.StopPlay.Size = p17.StopPlayBaseSize
    p17.StopPlay.Visible = not p18
end

local function getSurfaceHitScale(p20, p21, p22) -- line: 520
    local v37 = if p21 == Enum.NormalId.Front then Vector3.new(0, 0, -1)
        elseif p21 == Enum.NormalId.Back then Vector3.new(0, 0, 1)
        elseif p21 == Enum.NormalId.Right then Vector3.new(1, 0, 0)
        elseif p21 == Enum.NormalId.Left then Vector3.new(-1, 0, 0)
        elseif p21 == Enum.NormalId.Top then Vector3.new(0, 1, 0)
        else Vector3.new(0, -1, 0)
    local Unit = v37:Cross(if math.abs(v37.Y) == 1 then Vector3.new(0, 0, 1) else Vector3.new(0, 1, 0)).Unit
    local Unit2 = Unit:Cross(v37).Unit
    local v38 = p20.CFrame:PointToObjectSpace(p22)
    local v39 = p20.Size * 0.5
    local v42 = math.abs(v37.X) * v39.X + math.abs(v37.Y) * v39.Y + math.abs(v37.Z) * v39.Z
    local v45 = math.abs(Unit.X) * v39.X + math.abs(Unit.Y) * v39.Y + math.abs(Unit.Z) * v39.Z
    local v48 = math.abs(Unit2.X) * v39.X + math.abs(Unit2.Y) * v39.Y + math.abs(Unit2.Z) * v39.Z
    local v49 = v38 - v37 * v42

    return Vector2.new(math.clamp(0.5 - v49:Dot(Unit) / (v45 * 2), 0, 1), (math.clamp(0.5 - v49:Dot(Unit2) / (v48 * 2), 0, 1)))
end

local function getVideoScreenTapScale(p23, p24) -- line: 557
    -- upvalues: Workspace (copy), getSurfaceHitScale (copy)
    local CurrentCamera = Workspace.CurrentCamera

    if CurrentCamera == nil then
        return nil
    end

    local v53 = CurrentCamera:ScreenPointToRay(p24.X, p24.Y)
    local v54 = Workspace:Raycast(v53.Origin, v53.Direction * 1000, p23.VideoScreenRaycastParams)

    if v54 == nil or v54.Instance ~= p23.VideoScreenPart then
        return nil
    end

    return getSurfaceHitScale(p23.VideoScreenPart, p23.VideoSurfaceGui.Face, v54.Position)
end

local function toggleMediaPlaying(p25) -- line: 576
    -- upvalues: setMediaPlaying (copy)
    local MusicSound = p25.MusicSound

    if MusicSound ~= nil then
        setMediaPlaying(p25, not MusicSound.IsPlaying)
    else
        setMediaPlaying(p25, not p25.VideoFramePool.GetActiveFrame().Playing)
    end
end

local function setVideoProgress(p26, p27) -- line: 586
    local Size = p26.Progress.Size

    p26.Progress.Size = UDim2.new(math.clamp(p27, 0, 1), 0, Size.Y.Scale, Size.Y.Offset)
end

local function updateMediaProgress(p28) -- line: 591
    local MusicSound = p28.MusicSound

    if MusicSound ~= nil then
        local TimeLength = MusicSound.TimeLength

        if TimeLength <= 0 then
            local Size = p28.Progress.Size

            p28.Progress.Size = UDim2.new(0, 0, Size.Y.Scale, Size.Y.Offset)
        else
            local v57 = MusicSound.TimePosition / TimeLength
            local Size = p28.Progress.Size

            p28.Progress.Size = UDim2.new(math.clamp(v57, 0, 1), 0, Size.Y.Scale, Size.Y.Offset)
        end
    else
        local v55 = p28.VideoFramePool.GetActiveFrame()
        local TimeLength = v55.TimeLength

        if TimeLength <= 0 then
            local Size = p28.Progress.Size

            p28.Progress.Size = UDim2.new(0, 0, Size.Y.Scale, Size.Y.Offset)
        else
            local v56 = v55.TimePosition / TimeLength
            local Size = p28.Progress.Size

            p28.Progress.Size = UDim2.new(math.clamp(v56, 0, 1), 0, Size.Y.Scale, Size.Y.Offset)
        end
    end
end

local function getWatchedFraction(p29) -- line: 614
    local MusicSound = p29.MusicSound

    if MusicSound == nil then
        local v58 = p29.VideoFramePool.GetActiveFrame()
        local TimeLength = v58.TimeLength

        return if not (TimeLength <= 0) then v58.TimePosition / TimeLength else nil
    end

    local TimeLength = MusicSound.TimeLength

    return if not (TimeLength <= 0) then MusicSound.TimePosition / TimeLength else nil
end

local function hideLoading(p30) -- line: 632
    local LoadingTween = p30.LoadingTween

    p30.LoadingTween = nil

    if LoadingTween ~= nil then
        LoadingTween:Cancel()
    end

    p30.Loading.Visible = false
    p30.LoadingSpin.Rotation = 0
end

local function showLoading(p31) -- line: 643
    -- upvalues: TweenService (copy), v1 (copy)
    local LoadingTween = p31.LoadingTween

    p31.LoadingTween = nil

    if LoadingTween ~= nil then
        LoadingTween:Cancel()
    end

    p31.Loading.Visible = false
    p31.LoadingSpin.Rotation = 0
    p31.Loading.Visible = true
    p31.ShareSurfaceGui.Enabled = false
    p31.SideButtonsSurfaceGui.Enabled = false

    local tween = TweenService:Create(p31.LoadingSpin, v1, {
        Rotation = 360
    })

    p31.LoadingTween = tween
    tween:Play()
end

local function clearMusicImage(p32) -- line: 656
    p32.MusicImage.Visible = false
    p32.MusicImage.Image = ""

    local MusicSound = p32.MusicSound

    p32.MusicSound = nil

    if MusicSound ~= nil then
        MusicSound:Stop()
        MusicSound:Destroy()
    end
end

local function clearVideoBackgroundMusic(p33) -- line: 670
    local VideoBackgroundMusicSound = p33.VideoBackgroundMusicSound

    p33.VideoBackgroundMusicSound = nil

    if VideoBackgroundMusicSound ~= nil then
        VideoBackgroundMusicSound:Stop()
        VideoBackgroundMusicSound:Destroy()
    end
end

local function unloadVideo(p34) -- line: 681
    -- upvalues: GoToNext (copy), Paused (copy)
    p34.VideoTrove:Clean()

    local EndCardTrove = p34.EndCardTrove

    p34.EndCardTrove = nil

    if EndCardTrove ~= nil then
        EndCardTrove:Destroy()
    end

    GoToNext.Visible = false

    local PausedCardTrove = p34.PausedCardTrove

    p34.PausedCardTrove = nil

    if PausedCardTrove ~= nil then
        PausedCardTrove:Destroy()
    end

    Paused.Visible = false

    if p34.MusicSound ~= nil then
        p34.MusicImage.Visible = true
    end

    local PausedPreviewFrame, PausedPreviewBaseSize = p34.PausedPreviewFrame, p34.PausedPreviewBaseSize

    p34.PausedPreviewFrame = nil
    p34.PausedPreviewBaseSize = nil

    if PausedPreviewFrame ~= nil and PausedPreviewBaseSize ~= nil then
        PausedPreviewFrame.Size = PausedPreviewBaseSize
    end

    local LoadingTween = p34.LoadingTween

    p34.LoadingTween = nil

    if LoadingTween ~= nil then
        LoadingTween:Cancel()
    end

    p34.Loading.Visible = false
    p34.LoadingSpin.Rotation = 0
    p34.MusicImage.Visible = false
    p34.MusicImage.Image = ""

    local MusicSound = p34.MusicSound

    p34.MusicSound = nil

    if MusicSound ~= nil then
        MusicSound:Stop()
        MusicSound:Destroy()
    end

    local VideoBackgroundMusicSound = p34.VideoBackgroundMusicSound

    p34.VideoBackgroundMusicSound = nil

    if VideoBackgroundMusicSound ~= nil then
        VideoBackgroundMusicSound:Stop()
        VideoBackgroundMusicSound:Destroy()
    end

    p34.VideoFramePool.ClearActive()
    p34.MainVideo.Size = p34.MainVideoBaseSize
    p34.MainVideo.Volume = 1
    p34.MainVideo.Video = ""

    local StopPlayTween = p34.StopPlayTween

    p34.StopPlayTween = nil

    if StopPlayTween ~= nil then
        StopPlayTween:Cancel()
    end

    p34.StopPlay.ImageTransparency = 0
    p34.StopPlay.Size = p34.StopPlayBaseSize
    p34.StopPlay.Visible = true

    local Size = p34.Progress.Size

    p34.Progress.Size = UDim2.new(0, 0, Size.Y.Scale, Size.Y.Offset)
end

local function wrapVideoIndex(p35) -- line: 697
    -- upvalues: v16 (copy)
    if p35 < 1 then
        return #v16
    end

    if #v16 < p35 then
        return 1
    end

    return p35
end

local function preloadMediaIndices(p36, p37) -- line: 709
    -- upvalues: WarmAssets (copy), WarmSounds (copy), v16 (copy)
    local t7 = {}
    local t8 = {}
    local t9 = {}

    for _, v59 in ipairs(p37) do
        local v60 = v16[v59]

        if v60.Kind == "Video" then
            table.insert(t9, {
                MediaEntry = v60,
                MediaIndex = v59
            })

            local Music = v60.Music

            if Music then
                table.insert(t8, Music.SoundId)
            end
        elseif v60.Kind == "MusicImage" then
            table.insert(t7, v60.Image)
            table.insert(t8, v60.SoundId)
        end
    end

    p36.VideoFramePool.Preload(t9)

    if #t7 > 0 then
        task.spawn(WarmAssets, t7)
    end

    if #t8 > 0 then
        task.spawn(WarmSounds, t8)
    end
end

local function preloadDirectionalAssets(p38, p39, p40) -- line: 739
    -- upvalues: v16 (copy), preloadMediaIndices (copy)
    if p40 < 0 then
        return
    end

    local t11 = {}
    local v61 = p39 + p40 * 1

    if v61 < 1 then
        v61 = #v16
    elseif #v16 < v61 then
        v61 = 1
    end

    table.insert(t11, v61)

    local v62 = p39 + p40 * 2

    if v62 < 1 then
        v62 = #v16
    elseif #v16 < v62 then
        v62 = 1
    end

    table.insert(t11, v62)

    local v63 = p39 + p40 * 3

    if v63 < 1 then
        v63 = #v16
    elseif #v16 < v63 then
        v63 = 1
    end

    table.insert(t11, v63)
    preloadMediaIndices(p38, t11)
end

local function loadVideoBackgroundMusic(p41, p42) -- line: 751
    local Sound = Instance.new("Sound")

    Sound.Name = "TreadmillVideoBackgroundMusic"
    Sound.SoundId = p42.SoundId
    Sound.Volume = p42.Volume
    Sound.Looped = true
    Sound.Parent = p41.MainVideo
    p41.VideoBackgroundMusicSound = Sound
    p41.VideoTrove:Add(function() -- line: 762
        -- upvalues: p41 (copy), Sound (copy)
        if p41.VideoBackgroundMusicSound == Sound then
            p41.VideoBackgroundMusicSound = nil
        end

        if Sound.Parent ~= nil then
            Sound:Stop()
            Sound:Destroy()
        end
    end)
end

local function resetVideoBackgroundMusic(p43) -- line: 774
    local VideoBackgroundMusicSound = p43.VideoBackgroundMusicSound

    if VideoBackgroundMusicSound ~= nil then
        VideoBackgroundMusicSound:Stop()
        VideoBackgroundMusicSound.TimePosition = 0
    end
end

local function loadVideoMedia(p44, p45, p46) -- line: 784
    -- upvalues: RecommendationSignals (copy), n1 (ref), showGoToNext (copy), setMediaPlaying (copy), showLoading (copy), loadVideoBackgroundMusic (copy)
    local v64 = p44.VideoFramePool.Activate(p44.VideoIndex, p45)

    v64.Size = p45.Size or p44.MainVideoBaseSize

    local Size = p44.Progress.Size

    p44.Progress.Size = UDim2.new(0, 0, Size.Y.Scale, Size.Y.Offset)

    local Music = p45.Music

    if Music ~= nil then
        loadVideoBackgroundMusic(p44, Music)
    end

    p44.VideoTrove:Add(v64.Ended:Connect(function() -- line: 797
        -- upvalues: p44 (copy), p46 (copy), RecommendationSignals (copy), n1 (ref), showGoToNext (copy)
        if n1 == p44.Token and p44.VideoSerial == p46 then
            RecommendationSignals.MarkEnded()

            local VideoBackgroundMusicSound = p44.VideoBackgroundMusicSound

            if VideoBackgroundMusicSound ~= nil then
                VideoBackgroundMusicSound:Stop()
                VideoBackgroundMusicSound.TimePosition = 0
            end

            showGoToNext(p44)
        end
    end))

    if v64.IsLoaded then
        local LoadingTween = p44.LoadingTween

        p44.LoadingTween = nil

        if LoadingTween ~= nil then
            LoadingTween:Cancel()
        end

        p44.Loading.Visible = false
        p44.LoadingSpin.Rotation = 0
        p44.ShareSurfaceGui.Enabled = true
        p44.SideButtonsSurfaceGui.Enabled = true
        setMediaPlaying(p44, p44.HasPlayedMedia, false)
    else
        p44.StopPlay.Visible = false
        showLoading(p44)

        local connection

        connection = v64.Loaded:Connect(function() -- line: 818
            -- upvalues: p44 (copy), p46 (copy), connection (ref), n1 (ref), setMediaPlaying (copy)
            if n1 ~= p44.Token or p44.VideoSerial ~= p46 then
                return
            end

            connection:Disconnect()

            local LoadingTween = p44.LoadingTween

            p44.LoadingTween = nil

            if LoadingTween ~= nil then
                LoadingTween:Cancel()
            end

            p44.Loading.Visible = false
            p44.LoadingSpin.Rotation = 0
            p44.ShareSurfaceGui.Enabled = true
            p44.SideButtonsSurfaceGui.Enabled = true
            setMediaPlaying(p44, p44.HasPlayedMedia, false)
        end)
        p44.VideoTrove:Add(connection)
    end
end

local function loadMusicImageMedia(p47, p48, p49) -- line: 832
    -- upvalues: RecommendationSignals (copy), n1 (ref), showGoToNext (copy), setMediaPlaying (copy), showLoading (copy)
    p47.VideoFramePool.ClearActive()
    p47.MainVideo.Video = ""
    p47.MusicImage.Image = p48.Image
    p47.MusicImage.Visible = true

    local Size = p47.Progress.Size

    p47.Progress.Size = UDim2.new(0, 0, Size.Y.Scale, Size.Y.Offset)

    local Sound = Instance.new("Sound")

    Sound.Name = "TreadmillMusicImageSound"
    Sound.SoundId = p48.SoundId
    Sound.Volume = p48.Volume
    Sound.Parent = p47.MainVideo
    Sound.Looped = false
    p47.MusicSound = Sound
    p47.VideoTrove:Add(function() -- line: 850
        -- upvalues: p47 (copy), Sound (copy)
        if p47.MusicSound == Sound then
            p47.MusicSound = nil
        end

        if Sound.Parent ~= nil then
            Sound:Stop()
            Sound:Destroy()
        end
    end)
    p47.VideoTrove:Add(Sound.Ended:Connect(function() -- line: 861
        -- upvalues: p47 (copy), p49 (copy), RecommendationSignals (copy), n1 (ref), showGoToNext (copy)
        if n1 == p47.Token and p47.VideoSerial == p49 then
            RecommendationSignals.MarkEnded()
            showGoToNext(p47)
        end
    end))

    if Sound.IsLoaded then
        local LoadingTween = p47.LoadingTween

        p47.LoadingTween = nil

        if LoadingTween ~= nil then
            LoadingTween:Cancel()
        end

        p47.Loading.Visible = false
        p47.LoadingSpin.Rotation = 0
        p47.ShareSurfaceGui.Enabled = true
        p47.SideButtonsSurfaceGui.Enabled = true
        setMediaPlaying(p47, p47.HasPlayedMedia, false)
    else
        p47.StopPlay.Visible = false
        showLoading(p47)

        local connection

        connection = Sound.Loaded:Connect(function() -- line: 881
            -- upvalues: p47 (copy), p49 (copy), connection (ref), n1 (ref), setMediaPlaying (copy)
            if n1 ~= p47.Token or p47.VideoSerial ~= p49 then
                return
            end

            connection:Disconnect()

            local LoadingTween = p47.LoadingTween

            p47.LoadingTween = nil

            if LoadingTween ~= nil then
                LoadingTween:Cancel()
            end

            p47.Loading.Visible = false
            p47.LoadingSpin.Rotation = 0
            p47.ShareSurfaceGui.Enabled = true
            p47.SideButtonsSurfaceGui.Enabled = true
            setMediaPlaying(p47, p47.HasPlayedMedia, false)
        end)
        p47.VideoTrove:Add(connection)
    end
end

local function loadVideo(p50, p51, p52, p53, p54) -- line: 895
    -- upvalues: RecommendationFeedSource (copy), RecommendationSignals (copy), Remotes (copy), v16 (copy), t5 (copy), unloadVideo (copy), preloadMediaIndices (copy), preloadDirectionalAssets (copy), loadVideoMedia (copy), loadMusicImageMedia (copy)
    p50.VideoSerial += 1

    local VideoSerial = p50.VideoSerial

    if p51 < 1 then
        p50.VideoIndex = #v16
    elseif #v16 < p51 then
        p50.VideoIndex = 1
    else
        p50.VideoIndex = p51
    end

    if RecommendationSignals.HasActiveView() then
        local EndView = RecommendationSignals.EndView
        local MusicSound = p50.MusicSound
        local v69

        if MusicSound ~= nil then
            local TimeLength = MusicSound.TimeLength

            if not (TimeLength <= 0) then
                v69 = MusicSound.TimePosition / TimeLength
            end
        else
            local v70 = p50.VideoFramePool.GetActiveFrame()
            local TimeLength = v70.TimeLength

            if not (TimeLength <= 0) then
                v69 = v70.TimePosition / TimeLength
            end
        end

        EndView(v69)
    end

    if p54 ~= nil then
        Remotes.Treadmill.SubmitClipView:FireServer(p54.MediaKey)
        RecommendationSignals.BeginView(p54)
    elseif p52 ~= nil then
        Remotes.Treadmill.RefreshClipCursor:FireServer(p52)
    end

    unloadVideo(p50)
    p50.LikeController:UpdatePresentation()
    p50.FriendLikesController:HandleMediaChanged()

    local v71 = v16[p50.VideoIndex]

    t5.MediaChanged:Fire(v71, p50.VideoScreenPart)

    if v71.Kind == "Video" then
        loadVideoMedia(p50, v71, VideoSerial)
    else
        loadMusicImageMedia(p50, v71, VideoSerial)
    end

    if p54 ~= nil then
        preloadMediaIndices(p50, RecommendationFeedSource.PeekAhead(3))
    else
        preloadDirectionalAssets(p50, p50.VideoIndex, p53)
    end
end

local function cleanupRuntime() -- line: 933
    -- upvalues: RecommendationSignals (copy), n1 (ref), v15 (ref), t4 (ref), t5 (copy), unloadVideo (copy)
    n1 += 1
    t5.Stopped:Fire()

    local v72 = v15

    v15 = nil

    if v72 ~= nil then
        v72:Destroy()
    end

    local t12 = t4

    t4 = nil

    if t12 == nil then
        return
    end

    if RecommendationSignals.HasActiveView() then
        local EndView = RecommendationSignals.EndView
        local MusicSound = t12.MusicSound
        local v73

        if MusicSound ~= nil then
            local TimeLength = MusicSound.TimeLength

            if not (TimeLength <= 0) then
                v73 = MusicSound.TimePosition / TimeLength
            end
        else
            local v74 = t12.VideoFramePool.GetActiveFrame()
            local TimeLength = v74.TimeLength

            if not (TimeLength <= 0) then
                v73 = v74.TimePosition / TimeLength
            end
        end

        EndView(v73)
    end

    unloadVideo(t12)
    t12.LikeController:Destroy()
    t12.FriendLikesController:Destroy()
    t12.StopPlay.Visible = true
    t12.LeftSurfaceGui.Enabled = false
    t12.RightSurfaceGui.Enabled = false
    t12.ShareSurfaceGui.Enabled = false
    t12.SideButtonsSurfaceGui.Enabled = false
    t12.VideoSurfaceGui.Enabled = false
    t12.Trove:Destroy()
end

local function projectConsoleSwapMarker(p55, p56) -- line: 965
    -- upvalues: GamepadBindings (copy), PlatformController (copy)
    p55.Visible = PlatformController.IsConsole() and p55:GetAttribute("ManualVisibility") ~= true

    if PlatformController.IsConsole() and (p55:IsA("ImageLabel") or p55:IsA("ImageButton")) then
        p55.Image = GamepadBindings.GlyphFor(p56)
    end
end

local function projectConsoleSwapMarkers() -- line: 981
    -- upvalues: GamepadGlyph (copy), GamepadGlyph2 (copy), projectConsoleSwapMarker (copy)
    projectConsoleSwapMarker(GamepadGlyph, "ButtonL1")
    projectConsoleSwapMarker(GamepadGlyph2, "ButtonR1")
end

local function isExcludedMediaIndex(p57) -- line: 986
    -- upvalues: TreadmillMediaIdentity (copy), TreadmillMediaOverlay (copy), v16 (copy)
    local v75 = v16[p57]

    return v75 ~= nil and (TreadmillMediaOverlay.IsExcluded(TreadmillMediaIdentity.GetMediaKey(v75)))
end

local function updateVideoCounter() -- line: 992
    -- upvalues: TreadmillMediaIdentity (copy), TreadmillMediaOverlay (copy), VideoCounter (copy), v16 (copy)
    if VideoCounter ~= nil and VideoCounter:IsA("TextLabel") then
        local n3 = 0

        for v76 in v16 do
            local v77 = v16[v76]

            if v77 == nil or not TreadmillMediaOverlay.IsExcluded(TreadmillMediaIdentity.GetMediaKey(v77)) then
                n3 += 1
            end
        end

        VideoCounter.Text = ("TOTAL VIDEOS: %*"):format(n3)
    end
end

local function sequencerNextSkippingExcluded(p58) -- line: 1008
    -- upvalues: FeedSequencer (copy), Remotes (copy), TreadmillMediaIdentity (copy), TreadmillMediaOverlay (copy), v16 (copy)
    local v78, v79 = FeedSequencer.Next(p58.Feed)

    for _ = 1, #v16 do
        local v80 = v16[v78]

        if v80 == nil or not TreadmillMediaOverlay.IsExcluded(TreadmillMediaIdentity.GetMediaKey(v80)) then
            break
        end

        Remotes.Treadmill.RefreshClipCursor:FireServer(v79)
        v78, v79 = FeedSequencer.Next(p58.Feed)
    end

    return v78, v79
end

local function sequencerPreviousSkippingExcluded(p59) -- line: 1020
    -- upvalues: FeedSequencer (copy), Remotes (copy), TreadmillMediaIdentity (copy), TreadmillMediaOverlay (copy), v16 (copy), sequencerNextSkippingExcluded (copy)
    local v81, v82, v83 = FeedSequencer.Previous(p59.Feed)

    if not v83 then
        return v81, v82, false
    end

    for _ = 1, #v16 do
        local v84 = v16[v81]

        if v84 == nil or not TreadmillMediaOverlay.IsExcluded(TreadmillMediaIdentity.GetMediaKey(v84)) then
            return v81, v82, true
        end

        Remotes.Treadmill.RefreshClipCursor:FireServer(v82)

        local v85

        v81, v82, v85 = FeedSequencer.Previous(p59.Feed)

        if not v85 then
            local v86, v87 = sequencerNextSkippingExcluded(p59)

            return v86, v87, true
        end
    end

    return v81, v82, true
end

local function bindVideoRuntime(p60, p61, p62, p63) -- line: 1043
    -- upvalues: ContextActionService (copy), SocialService (copy), UserInputService (copy), ButtonFX (copy), ButtonHintStrip (copy), CommentsController (copy), FeedSequencer (copy), FriendLikesController (copy), ImageColorPulse (copy), LikeController (copy), PlatformController (copy), RecommendationFeedSource (copy), RecommendationSignals (copy), Remotes (copy), TouchTapTracker (copy), TreadmillMediaIdentity (copy), TreadmillMediaOverlay (copy), TreadmillUtil (copy), Trove (copy), VideoFramePool (copy), TryCall (copy), Value (copy), ButtonL2 (copy), ButtonR2 (copy), v4 (copy), v5 (copy), LocalPlayer (copy), v9 (copy), v10 (copy), v11 (copy), v12 (copy), v13 (copy), v14 (copy), ButtonSwapLeft (copy), ButtonSwapRight (copy), GamepadGlyph (copy), GamepadGlyph2 (copy), ShareButton (copy), VideoFrame (copy), MainVideo (copy), StopPlay (copy), MusicImage (copy), Loading (copy), Spin (copy), Progress (copy), n1 (ref), t4 (ref), v16 (copy), setMediaPlaying (copy), getVideoScreenTapScale (copy), updateMediaProgress (copy), unloadVideo (copy), loadVideo (copy), projectConsoleSwapMarker (copy), projectConsoleSwapMarkers (copy), sequencerNextSkippingExcluded (copy), sequencerPreviousSkippingExcluded (copy)
    if p63 ~= n1 then
        return
    end

    local v88, v89, v90 = TreadmillUtil.FindVideoPresentationParts(p60)

    if v88 == nil or v89 == nil or v90 == nil then
        v9:AtTrace():Log((("[TreadmillVideoController] Skipped video presentation for %*"):format(p61)))

        return
    end

    if p63 == n1 then
        local v91 = Trove.new()
        local v92 = v91:Extend()
        local v93 = RaycastParams.new()

        v93.FilterType = Enum.RaycastFilterType.Include
        v93.FilterDescendantsInstances = { v88 }

        local v94 = FeedSequencer.CreateRuntime(v16, p62, LocalPlayer.UserId)

        RecommendationFeedSource.PrefetchFeed(v16)

        local v95 = RecommendationFeedSource.GetReadyItem()
        local v96 = VideoFramePool.new(MainVideo)
        local t13
        local v97 = LikeController.new(function() -- line: 1077
            -- upvalues: t13 (ref)
            local t14 = t13

            if t14 == nil then
                return 1
            end

            return t14.VideoIndex
        end, function() -- line: 1080
            -- upvalues: t13 (ref), setMediaPlaying (copy)
            local t15 = t13

            assert(t15 ~= nil, "Treadmill runtime must exist before handling like single tap")

            local RequestNext = t15.RequestNext

            if t15.EndCardTrove == nil or RequestNext == nil then
                local MusicSound = t15.MusicSound

                if MusicSound ~= nil then
                    setMediaPlaying(t15, not MusicSound.IsPlaying)
                else
                    setMediaPlaying(t15, not t15.VideoFramePool.GetActiveFrame().Playing)
                end
            else
                RequestNext()
            end
        end, v16, v91, VideoFrame, v88)
        local t16 = {
            EndCardTrove = nil,
            Feed = v94,
            FriendLikesController = FriendLikesController.new(function() -- line: 1092
                -- upvalues: t13 (ref)
                local t17 = t13

                if t17 == nil then
                    return 1
                end

                return t17.VideoIndex
            end, function() -- line: 1096
                -- upvalues: v97 (copy)
                v97:SuppressScreenTap()
            end, v16, v91, v88),
            HasPlayedMedia = false,
            LeftSurfaceGui = v10,
            LikeController = v97,
            Loading = Loading,
            LoadingTween = nil,
            PausedCardTrove = nil,
            PausedPreviewBaseSize = nil,
            PausedPreviewFrame = nil,
            RequestNext = nil,
            LoadingSpin = Spin,
            MainVideo = MainVideo,
            MainVideoBaseSize = MainVideo.Size,
            MusicImage = MusicImage,
            MusicSound = nil,
            Progress = Progress,
            RecommendationActive = v95 ~= nil,
            RightSurfaceGui = v11,
            ShareSurfaceGui = v12,
            SideButtonsSurfaceGui = v13,
            StopPlay = StopPlay,
            StopPlayBaseSize = StopPlay.Size,
            StopPlayTween = nil,
            Token = p63,
            Trove = v91,
            VideoBackgroundMusicSound = nil,
            VideoFrame = VideoFrame,
            VideoIndex = 1,
            VideoScreenPart = v88,
            VideoScreenRaycastParams = v93,
            VideoSerial = 0,
            VideoSurfaceGui = v14,
            VideoTrove = v92,
            VideoFramePool = v96
        }

        t13 = t16
        v91:Add(v96.Destroy)

        if p63 == n1 then
            t4 = t16
            v10.Adornee = v89
            v11.Adornee = v90
            v12.Adornee = v88
            v13.Adornee = v88
            v14.Adornee = v88
            v10.Enabled = true
            v11.Enabled = true
            v12.Enabled = true
            v13.Enabled = true
            v14.Enabled = true
            VideoFrame.Active = true
            MainVideo.Active = true

            local v100

            if not t16.Feed.HasSwappedRight then
                v100 = ImageColorPulse.Start(ButtonSwapRight, v4, v5)
                v91:Add(function() -- line: 1166
                    -- upvalues: v100 (ref)
                    local v101 = v100

                    if v101 ~= nil then
                        v101()
                        v100 = nil
                    end
                end)
            end

            local function swapLeft() -- line: 1175
                -- upvalues: t16 (copy), RecommendationFeedSource (copy), loadVideo (copy), sequencerPreviousSkippingExcluded (copy)
                if t16.RecommendationActive then
                    local v102, v103 = RecommendationFeedSource.Previous()

                    if v102 ~= nil then
                        if v103 then
                            loadVideo(t16, v102.MediaIndex, nil, -1, v102)
                        end

                        return
                    end

                    t16.RecommendationActive = false
                end

                local v104, v105, v106 = sequencerPreviousSkippingExcluded(t16)

                if v106 then
                    loadVideo(t16, v104, v105, -1)
                end
            end

            local function swapRight() -- line: 1194
                -- upvalues: t16 (copy), v100 (ref), RecommendationFeedSource (copy), loadVideo (copy), sequencerNextSkippingExcluded (copy)
                local v107 = v100

                if v107 ~= nil then
                    v107()
                    v100 = nil
                end

                if t16.RecommendationActive then
                    local v108 = RecommendationFeedSource.Next()

                    if v108 ~= nil then
                        loadVideo(t16, v108.MediaIndex, nil, 1, v108)

                        return
                    end

                    t16.RecommendationActive = false
                end

                local v109, v110 = sequencerNextSkippingExcluded(t16)

                loadVideo(t16, v109, v110, 1)
            end

            t16.RequestNext = swapRight
            v91:Add(ButtonFX(ButtonSwapLeft, nil, swapLeft))
            v91:Add(ButtonFX(ButtonSwapRight, nil, swapRight))
            projectConsoleSwapMarker(GamepadGlyph, "ButtonL1")
            projectConsoleSwapMarker(GamepadGlyph2, "ButtonR1")
            v91:Add(PlatformController.Changed:Connect(projectConsoleSwapMarkers))
            ContextActionService:BindActionAtPriority("TreadmillVideoActions", function(_, p65, p66) -- line: 1221
                -- upvalues: v97 (copy), swapLeft (copy), swapRight (copy), CommentsController (copy)
                if p65 == Enum.UserInputState.Begin then
                    local KeyCode = p66.KeyCode

                    if KeyCode == Enum.KeyCode.ButtonL1 then
                        swapLeft()
                    elseif KeyCode == Enum.KeyCode.ButtonR1 then
                        swapRight()
                    elseif KeyCode == Enum.KeyCode.ButtonL2 then
                        v97:Toggle()
                    elseif KeyCode == Enum.KeyCode.ButtonR2 then
                        CommentsController.Toggle()
                    end
                end

                return Enum.ContextActionResult.Sink
            end, false, Value, Enum.KeyCode.ButtonL1, Enum.KeyCode.ButtonR1, Enum.KeyCode.ButtonL2, Enum.KeyCode.ButtonR2)
            v91:Add(function() -- line: 1248
                -- upvalues: ContextActionService (copy)
                ContextActionService:UnbindAction("TreadmillVideoActions")
            end)
            ButtonHintStrip.PinLeft(0.2)
            ButtonHintStrip.Present("TreadmillLike", ButtonL2, "Like")

            if CommentsController.IsAvailable() then
                ButtonHintStrip.Present("TreadmillComments", ButtonR2, "Comments")
            end

            v91:Add(function() -- line: 1254
                -- upvalues: ButtonHintStrip (copy)
                ButtonHintStrip.Retract("TreadmillLike")
                ButtonHintStrip.Retract("TreadmillComments")
                ButtonHintStrip.PinLeft(nil)
            end)
            v91:Add(ButtonFX(ShareButton, nil, function() -- line: 1259
                -- upvalues: t16 (copy), SocialService (copy), RecommendationSignals (copy), TryCall (copy), LocalPlayer (copy)
                t16.LikeController:SuppressScreenTap()

                local v112, v113 = TryCall(SocialService.CanSendGameInviteAsync, SocialService, LocalPlayer)

                if v112 and v113 then
                    SocialService:PromptGameInvite(LocalPlayer)
                    RecommendationSignals.NotifyShared()
                end
            end))

            local v114 = TouchTapTracker.new()

            local function handleVideoScreenTap(p67) -- line: 1270
                -- upvalues: t16 (copy), getVideoScreenTapScale (copy)
                local v115 = getVideoScreenTapScale(t16, Vector2.new(p67.Position.X, p67.Position.Y))

                if v115 ~= nil then
                    t16.FriendLikesController:HandleScreenTap()
                    t16.LikeController:HandleScreenTap(v115)
                end
            end

            v91:Connect(UserInputService.InputBegan, function(p68, p69) -- line: 1282
                -- upvalues: t16 (copy), v114 (copy), UserInputService (copy), getVideoScreenTapScale (copy)
                if p69 then
                    return
                end

                if p68.UserInputType == Enum.UserInputType.Touch then
                    v114:Begin(p68)
                elseif p68.UserInputType == Enum.UserInputType.MouseButton1 and not UserInputService.TouchEnabled then
                    local v116 = getVideoScreenTapScale(t16, Vector2.new(p68.Position.X, p68.Position.Y))

                    if v116 == nil then
                        return
                    end

                    t16.FriendLikesController:HandleScreenTap()
                    t16.LikeController:HandleScreenTap(v116)
                end
            end)
            v91:Connect(UserInputService.InputChanged, function(p70) -- line: 1299
                -- upvalues: v114 (copy)
                if p70.UserInputType == Enum.UserInputType.Touch and v114:IsTrackingInput(p70) then
                    v114:Update(p70)
                end
            end)
            v91:Connect(UserInputService.InputEnded, function(p71, p72) -- line: 1308
                -- upvalues: t16 (copy), v114 (copy), getVideoScreenTapScale (copy)
                if p71.UserInputType == Enum.UserInputType.Touch and v114:IsTrackingInput(p71) and v114:Evaluate(p71, p72) then
                    local v117 = getVideoScreenTapScale(t16, Vector2.new(p71.Position.X, p71.Position.Y))

                    if v117 == nil then
                        return
                    end

                    t16.FriendLikesController:HandleScreenTap()
                    t16.LikeController:HandleScreenTap(v117)
                end
            end)
            v91:Add(function() -- line: 1318
                -- upvalues: v114 (copy)
                v114:Reset()
            end)
            v91:BindToRenderStep("TreadmillVideoProgress", Enum.RenderPriority.Last.Value, function() -- line: 1322
                -- upvalues: t16 (copy), n1 (ref), updateMediaProgress (copy)
                if n1 == t16.Token then
                    updateMediaProgress(t16)
                end
            end)
            v91:Add(function() -- line: 1328
                -- upvalues: t16 (copy), v10 (copy), v11 (copy), v12 (copy), v13 (copy), v14 (copy), StopPlay (copy), unloadVideo (copy)
                unloadVideo(t16)
                t16.LikeController:Destroy()
                t16.FriendLikesController:Destroy()
                StopPlay.Visible = true
                v10.Enabled = false
                v11.Enabled = false
                v12.Enabled = false
                v13.Enabled = false
                v14.Enabled = false
            end)

            if v95 ~= nil then
                loadVideo(t16, v95.MediaIndex, nil, 1, v95)
            else
                local v119, v120 = FeedSequencer.Current(t16.Feed)
                local v121 = v16[v119]

                if v121 ~= nil and TreadmillMediaOverlay.IsExcluded(TreadmillMediaIdentity.GetMediaKey(v121)) then
                    Remotes.Treadmill.RefreshClipCursor:FireServer(v120)
                    v119, v120 = sequencerNextSkippingExcluded(t16)
                end

                loadVideo(t16, v119, v120, 1)
            end

            local v122 = t16.RecommendationActive and "recommendation" or "sequencer"

            v9:AtTrace():Log((("[TreadmillVideoController] Started treadmill video for %* (%* feed)"):format(p61, v122)))
        else
            v91:Destroy()
        end
    end
end

local function findActiveTreadmill(p73) -- line: 1356
    -- upvalues: CollectionService (copy)
    for _, v123 in CollectionService:GetTagged("ActiveTreadmill") do
        if v123:GetAttribute("ActiveTreadmillId") == p73 then
            return v123
        end
    end

    return nil
end

local function bindVideoRuntimeWhenReady(p74, p75, p76) -- line: 1365
    -- upvalues: CollectionService (copy), Trove (copy), n1 (ref), v15 (ref), bindVideoRuntime (copy), findActiveTreadmill (copy)
    local v124 = Trove.new()

    v15 = v124

    local v125 = false

    local function bindIfCurrent(p77) -- line: 1374
        -- upvalues: p74 (copy), p75 (copy), p76 (copy), v124 (copy), v125 (ref), n1 (ref), v15 (ref), bindVideoRuntime (copy)
        if not v125 and p77 ~= nil and p76 == n1 and v15 == v124 then
            assert(p77:IsA("Tool"), (("Runtime treadmill \"%*\" must be a Tool"):format(p74)))
            v125 = true
            v15 = nil
            v124:Destroy()
            bindVideoRuntime(p77, p74, p75, p76)
        end
    end

    v124:Add(CollectionService:GetInstanceAddedSignal("ActiveTreadmill"):Connect(function(p78) -- line: 1393
        -- upvalues: p74 (copy), bindIfCurrent (copy)
        if p78:GetAttribute("ActiveTreadmillId") == p74 then
            bindIfCurrent(p78)
        end
    end))
    bindIfCurrent((findActiveTreadmill(p74)))
end

function t5.Start(p79, p80) -- line: 1407
    -- upvalues: n1 (ref), cleanupRuntime (copy), bindVideoRuntimeWhenReady (copy)
    cleanupRuntime()
    n1 += 1
    bindVideoRuntimeWhenReady(p79, p80, n1)
end

function t5.GetStoppedIconImage() -- line: 1415
    return "rbxassetid://84371411600743"
end

function t5.ResolveCoverImage(p81) -- line: 1417
    if p81.Kind == "Video" then
        return p81.CoverImage or ""
    end

    return p81.Image
end

function t5.GetCurrentMediaEntry(p82) -- line: 1425
    -- upvalues: FeedSequencer (copy), LocalPlayer (copy), v16 (copy)
    local v127 = FeedSequencer.ResolveReleaseTrackingState(p82, LocalPlayer.UserId, p82.HasSwappedRight == true)
    local v128 = FeedSequencer.CreateRuntime(v16, v127, LocalPlayer.UserId)

    return v16[FeedSequencer.Current(v128)]
end

local v130

function t5.GetMediaEntryByKey(p83) -- line: 1441
    -- upvalues: TreadmillMediaIdentity (copy), v16 (copy), v130 (ref)
    local v131 = v130

    if v131 == nil then
        v131 = {}

        for _, v132 in ipairs(v16) do
            local v133 = TreadmillMediaIdentity.GetMediaKey(v132)

            if v131[v133] == nil then
                v131[v133] = v132
            end
        end

        v130 = v131
    end

    return v131[p83]
end

function t5.GetActiveMediaEntry() -- line: 1456
    -- upvalues: t4 (ref), v16 (copy)
    local t18 = t4

    return if t18 ~= nil then v16[t18.VideoIndex] else nil
end

function t5.Stop() -- line: 1464
    -- upvalues: cleanupRuntime (copy)
    cleanupRuntime()
end

function t5.SuppressScreenTap() -- line: 1466
    -- upvalues: t4 (ref)
    local t19 = t4

    if t19 ~= nil then
        t19.LikeController:SuppressScreenTap()
    end
end

function t5.SetShareButtonVisible(p84) -- line: 1473
    -- upvalues: ShareButton (copy)
    ShareButton.Visible = p84
end

TreadmillMediaOverlay.Changed:Connect(function() -- line: 1477
    -- upvalues: TreadmillMediaOverlay (copy), v16 (copy), updateVideoCounter (copy), v130 (ref)
    TreadmillMediaOverlay.ApplyTo(v16)
    v130 = nil
    updateVideoCounter()
end)
updateVideoCounter()

Remotes.Treadmill.GaugeClipLength.OnClientInvoke = function(p85) -- line: 1486
    -- upvalues: LocalPlayer (copy)
    local ScreenGui = Instance.new("ScreenGui")

    ScreenGui.Name = "TreadmillDurationProbe"
    ScreenGui.ResetOnSpawn = false

    local VideoFrame = Instance.new("VideoFrame")

    VideoFrame.Size = UDim2.fromOffset(1, 1)
    VideoFrame.BackgroundTransparency = 1
    VideoFrame.Volume = 0
    VideoFrame.Video = ("rbxassetid://%*"):format(p85)
    VideoFrame.Parent = ScreenGui
    ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

    local v134 = os.clock() + 20

    while os.clock() < v134 and not (VideoFrame.IsLoaded and VideoFrame.TimeLength > 0) do
        task.wait(0.25)
    end

    local TimeLength = VideoFrame.TimeLength

    ScreenGui:Destroy()

    return if not (TimeLength <= 0) then TimeLength else nil
end

CommentsController.Start({
    MediaChanged = t5.MediaChanged,
    SetShareButtonVisible = t5.SetShareButtonVisible,
    Stopped = t5.Stopped,
    SuppressScreenTap = t5.SuppressScreenTap
})

return t5
