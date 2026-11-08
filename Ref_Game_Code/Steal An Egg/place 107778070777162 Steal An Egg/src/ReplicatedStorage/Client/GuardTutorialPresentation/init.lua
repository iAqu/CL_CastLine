-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local ArrowPointer3D = require(ReplicatedStorage.Client.WorldFX.ArrowPointer3D)
local GUI = require(ReplicatedStorage.Client.GUI)
local Log = require(ReplicatedStorage.Packages.Log)
local MessageTyper = require(ReplicatedStorage.Client.UI.MessageTyper)
local TutorialBeam = require(ReplicatedStorage.Client.WorldFX.TutorialBeam)
local TutorialHighlightOverlay = require(script.TutorialHighlightOverlay)
local TutorialTapIndicator = require(script.TutorialTapIndicator)
local t = require(ReplicatedStorage.Packages.t)
local v1 = table.freeze({
    CROSSFADE_OUT = TweenInfo.new(0.02),
    CROSSFADE_IN = TweenInfo.new(0.02),
    STROKE_CROSSFADE_OUT = TweenInfo.new(0.02, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut),
    STROKE_CROSSFADE_IN = TweenInfo.new(0.02, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut),
    FILL = TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
    READY_SCALE = TweenInfo.new(0.45, Enum.EasingStyle.Elastic, Enum.EasingDirection.Out, -1, true),
    READY_FLASH = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, -1, true),
    CLICK_PULSE = TweenInfo.new(0.45, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, -1, true)
})

local function wantsAnchorValue(p1) -- line: 75
    assert(typeof(p1) == "Vector3" or typeof(p1) == "Instance" and p1:IsA("BasePart"), "a tutorial anchor has to be a BasePart or a Vector3")
end

local v3 = t.strict(t.string)
local v4 = t.strict(t.Color3)
local v5 = t.strict(t.boolean)
local v6 = t.strict(t.number)
local v7 = t.strict(t.optional(t.number))
local v8 = t.strict(t.instanceIsA("GuiButton"))
local v9 = t.strict(t.instanceIsA("GuiObject"))
local v10 = t.strict(t.instanceIsA("BasePart"))
local v11 = t.strict(t.CFrame)
local v12 = t.strict(t.optional(t.boolean))
local v13 = t.strict(t.optional(t.UDim))
local v14 = t.strict(t.optional(t.UDim2))
local v15 = Log.new()
local t1 = {}

t1.__index = t1
t1.__class = "GuardTutorialPresentation"

local function expect(p2, p3, p4) -- line: 102
    assert(p2:IsA(p3), (("%* is not a %*"):format(p4, p3)))

    return p2
end

local function messageParts(p5) -- line: 110
    -- upvalues: GUI (copy), MessageTyper (copy)
    local message = p5.message

    if message then
        return message
    end

    local v18 = GUI.TutorialInstructions()

    assert(v18:IsA("ScreenGui"), "TutorialInstructions is not a ScreenGui")

    local Frame = v18.Frame

    assert(Frame:IsA("Frame"), "TutorialInstructions.Frame is not a Frame")

    local TextLabel = Frame.TextLabel

    assert(TextLabel:IsA("TextLabel"), "TutorialInstructions.Frame.TextLabel is not a TextLabel")

    local UIStroke = TextLabel.UIStroke

    assert(UIStroke:IsA("UIStroke"), "the tutorial label stroke is not a UIStroke")

    local UIGradient = TextLabel.UIGradient

    assert(UIGradient:IsA("UIGradient"), "the tutorial label gradient is not a UIGradient")

    local t2 = {
        animator = MessageTyper.new(TextLabel),
        frame = Frame,
        gradient = UIGradient,
        label = TextLabel,
        screen = v18,
        stroke = UIStroke
    }

    p5.message = t2

    if p5.messageDefaults == nil then
        p5.messageDefaults = {
            framePosition = Frame.Position,
            strokeAlpha = TextLabel.TextStrokeTransparency,
            textAlpha = TextLabel.TextTransparency
        }
    end

    return t2
end

local function progressParts(p6) -- line: 144
    -- upvalues: messageParts (copy)
    local progress = p6.progress

    if progress then
        return progress
    end

    local Progression = messageParts(p6).frame.Progression

    assert(Progression:IsA("GuiObject"), "the progression frame is not a GuiObject")

    local Fill = Progression.Fill

    assert(Fill:IsA("GuiObject"), "the progression fill is not a GuiObject")

    local ReadyLabel = Progression.ReadyLabel

    assert(ReadyLabel:IsA("GuiObject"), "the ready label is not a GuiObject")

    local ReadyLabelWhite = ReadyLabel.ReadyLabelWhite

    assert(ReadyLabelWhite:IsA("TextLabel"), "the ready flash is not a TextLabel")

    local UIScale = ReadyLabel:FindFirstChildOfClass("UIScale")

    if UIScale == nil then
        UIScale = Instance.new("UIScale")
        UIScale.Parent = ReadyLabel
        p6.ownsReadyScale = true
    end

    local t3 = {
        fill = Fill,
        frame = Progression,
        ready = ReadyLabel,
        readyScale = UIScale,
        white = ReadyLabelWhite
    }

    p6.progress = t3

    return t3
end

local function resetMessageInk(p7) -- line: 175
    local message, messageDefaults = p7.message, p7.messageDefaults

    if message == nil then
        return
    end

    local label = message.label

    if messageDefaults then
        label.TextTransparency = messageDefaults.textAlpha
    else
        label.TextTransparency = 0
    end

    message.stroke.Transparency = 0

    local label2 = message.label

    if messageDefaults then
        label2.TextStrokeTransparency = messageDefaults.strokeAlpha
    else
        label2.TextStrokeTransparency = 1
    end
end

local function stopTween(p8) -- line: 187
    if p8 then
        p8:Cancel()
    end

    return nil
end

local function beginClickPulse(p9) -- line: 196
    -- upvalues: TweenService (copy), v1 (copy)
    p9.Scale = 1

    local tween = TweenService:Create(p9, v1.CLICK_PULSE, {
        Scale = 1.3
    })

    tween:Play()

    return tween
end

local function stopProgressPulse(p10) -- line: 204
    local readyScaleTween = p10.readyScaleTween

    if readyScaleTween then
        readyScaleTween:Cancel()
    end

    p10.readyScaleTween = nil

    local readyWhiteTween = p10.readyWhiteTween

    if readyWhiteTween then
        readyWhiteTween:Cancel()
    end

    p10.readyWhiteTween = nil
end

local function setReadyPulse(p11, p12, p13) -- line: 211
    -- upvalues: TweenService (copy), v1 (copy)
    if p13 then
        if p11.readyScaleTween == nil or p11.readyWhiteTween == nil then
            p12.ready.Visible = true
            p12.readyScale.Scale = 1
            p12.white.TextTransparency = 1

            local tween = TweenService:Create(p12.readyScale, v1.READY_SCALE, {
                Scale = 1.2
            })
            local tween2 = TweenService:Create(p12.white, v1.READY_FLASH, {
                TextTransparency = 0
            })

            p11.readyScaleTween = tween
            p11.readyWhiteTween = tween2
            tween:Play()
            tween2:Play()
        end
    else
        local readyScaleTween = p11.readyScaleTween

        if readyScaleTween then
            readyScaleTween:Cancel()
        end

        p11.readyScaleTween = nil

        local readyWhiteTween = p11.readyWhiteTween

        if readyWhiteTween then
            readyWhiteTween:Cancel()
        end

        p11.readyWhiteTween = nil
        p12.ready.Visible = false
        p12.readyScale.Scale = 1
        p12.white.TextTransparency = 1
    end
end

function t1.new() -- line: 241
    -- upvalues: t1 (copy)
    return (setmetatable({
        arrow = nil,
        beam = nil,
        clickPart = nil,
        clickTween = nil,
        dropRingLater = nil,
        dropTapLater = nil,
        fillTween = nil,
        message = nil,
        messageDefaults = nil,
        ownsReadyScale = false,
        progress = nil,
        readyScaleTween = nil,
        readyWhiteTween = nil,
        screenClick = nil,
        screenClickTween = nil,
        transition = 0
    }, t1))
end

function t1.AnnounceTyped(p14, p15, p16) -- line: 262
    -- upvalues: v3 (copy), v4 (copy), messageParts (copy)
    v3(p15)
    v4(p16)

    local v19 = messageParts(p14)

    p14.transition += 1

    local message, messageDefaults = p14.message, p14.messageDefaults

    if message ~= nil then
        local label = message.label

        if messageDefaults then
            label.TextTransparency = messageDefaults.textAlpha
        else
            label.TextTransparency = 0
        end

        message.stroke.Transparency = 0

        local label2 = message.label

        if messageDefaults then
            label2.TextStrokeTransparency = messageDefaults.strokeAlpha
        else
            label2.TextStrokeTransparency = 1
        end
    end

    v19.screen.Enabled = true
    v19.animator:Type(p15, p16)
end

function t1.AnnounceNow(p17, p18, p19) -- line: 277
    -- upvalues: v3 (copy), v4 (copy), messageParts (copy)
    v3(p18)
    v4(p19)

    local v20 = messageParts(p17)

    p17.transition += 1

    local message, messageDefaults = p17.message, p17.messageDefaults

    if message ~= nil then
        local label = message.label

        if messageDefaults then
            label.TextTransparency = messageDefaults.textAlpha
        else
            label.TextTransparency = 0
        end

        message.stroke.Transparency = 0

        local label2 = message.label

        if messageDefaults then
            label2.TextStrokeTransparency = messageDefaults.strokeAlpha
        else
            label2.TextStrokeTransparency = 1
        end
    end

    v20.screen.Enabled = true
    v20.animator:ShowAll(p18, p19)
end

function t1.CrossfadeTo(p20, p21, p22) -- line: 292
    -- upvalues: TweenService (copy), v1 (copy), v3 (copy), v4 (copy), messageParts (copy)
    v3(p21)
    v4(p22)

    local v21 = messageParts(p20)

    p20.transition += 1

    local transition = p20.transition

    v21.screen.Enabled = true
    v21.animator:Halt()

    local function fadeIn() -- line: 306
        -- upvalues: p20 (copy), p21 (copy), p22 (copy), v21 (copy), transition (copy), TweenService (copy), v1 (copy)
        if transition ~= p20.transition then
            return
        end

        local messageDefaults = p20.messageDefaults

        v21.label.RichText = true
        v21.label.Text = p21
        v21.label.TextColor3 = p22
        v21.label.MaxVisibleGraphemes = -1
        v21.label.TextTransparency = 1
        v21.label.TextStrokeTransparency = 1
        v21.stroke.Transparency = 1
        TweenService:Create(v21.stroke, v1.STROKE_CROSSFADE_IN, {
            Transparency = 0
        }):Play()

        local label = v21.label
        local CROSSFADE_IN = v1.CROSSFADE_IN
        local t5 = {}

        if messageDefaults then
            t5.TextTransparency = messageDefaults.textAlpha
            t5.TextStrokeTransparency = messageDefaults.strokeAlpha
        else
            t5.TextTransparency = 0
            t5.TextStrokeTransparency = 1
        end

        TweenService:Create(label, CROSSFADE_IN, t5):Play()
    end

    if v21.label.Text == "" then
        fadeIn()
    else
        local tween = TweenService:Create(v21.label, v1.CROSSFADE_OUT, {
            TextTransparency = 1,
            TextStrokeTransparency = 1
        })

        TweenService:Create(v21.stroke, v1.STROKE_CROSSFADE_OUT, {
            Transparency = 1
        }):Play()
        tween.Completed:Connect(fadeIn)
        tween:Play()
    end
end

function t1.SetAnnounceGradient(p23, p24) -- line: 342
    -- upvalues: v5 (copy), messageParts (copy)
    v5(p24)
    messageParts(p23).gradient.Enabled = p24
end

function t1.SetAnnounceHeight(p25, p26) -- line: 351
    -- upvalues: v7 (copy), messageParts (copy)
    v7(p26)

    local v22 = messageParts(p25)
    local messageDefaults = p25.messageDefaults
    local v23 = if messageDefaults then messageDefaults.framePosition else v22.frame.Position

    v22.frame.Position = if p26 ~= nil then UDim2.new(v23.X.Scale, v23.X.Offset, p26, v23.Y.Offset) else v23
end

function t1.DropAnnounce(p27) -- line: 365
    p27.transition += 1

    local message = p27.message

    if message == nil then
        return
    end

    message.animator:Blank()
    message.label.Text = ""

    local message2, messageDefaults = p27.message, p27.messageDefaults

    if message2 ~= nil then
        local label = message2.label

        if messageDefaults then
            label.TextTransparency = messageDefaults.textAlpha
        else
            label.TextTransparency = 0
        end

        message2.stroke.Transparency = 0

        local label2 = message2.label

        if messageDefaults then
            label2.TextStrokeTransparency = messageDefaults.strokeAlpha
        else
            label2.TextStrokeTransparency = 1
        end
    end

    local messageDefaults2 = p27.messageDefaults

    if messageDefaults2 then
        message.frame.Position = messageDefaults2.framePosition
    end

    message.gradient.Enabled = false
    message.screen.Enabled = false
end

function t1.TrackSpeedGoal(p28, p29, p30) -- line: 386
    -- upvalues: TweenService (copy), v1 (copy), v5 (copy), v6 (copy), progressParts (copy), setReadyPulse (copy)
    v6(p29)
    v5(p30)

    local v24 = progressParts(p28)

    v24.frame.Visible = true

    local fillTween = p28.fillTween

    if fillTween then
        fillTween:Cancel()
    end

    local Size = v24.fill.Size
    local v25 = UDim2.new(math.clamp(p29, 0, 1), 0, Size.Y.Scale, Size.Y.Offset)
    local tween = TweenService:Create(v24.fill, v1.FILL, {
        Size = v25
    })

    p28.fillTween = tween
    tween:Play()
    setReadyPulse(p28, v24, p30)
end

function t1.DropSpeedGoal(p31) -- line: 407
    local fillTween = p31.fillTween

    if fillTween then
        fillTween:Cancel()
    end

    p31.fillTween = nil

    local readyScaleTween = p31.readyScaleTween

    if readyScaleTween then
        readyScaleTween:Cancel()
    end

    p31.readyScaleTween = nil

    local readyWhiteTween = p31.readyWhiteTween

    if readyWhiteTween then
        readyWhiteTween:Cancel()
    end

    p31.readyWhiteTween = nil

    local progress = p31.progress

    if progress == nil then
        return
    end

    local Size = progress.fill.Size

    progress.fill.Size = UDim2.new(0, 0, Size.Y.Scale, Size.Y.Offset)
    progress.ready.Visible = false
    progress.readyScale.Scale = 1
    progress.white.TextTransparency = 1
    progress.frame.Visible = false
end

function t1.PointBeamAt(p32, p33) -- line: 426
    -- upvalues: TutorialBeam (copy)
    assert(typeof(p33) == "Vector3" or typeof(p33) == "Instance" and p33:IsA("BasePart"), "a tutorial anchor has to be a BasePart or a Vector3")

    local beam = p32.beam

    if beam ~= nil then
        TutorialBeam.Retarget(beam, p33)
    else
        p32.beam = TutorialBeam.Attach(p33)
    end
end

function t1.RetargetBeam(p34, p35) -- line: 437
    -- upvalues: TutorialBeam (copy)
    assert(typeof(p35) == "Vector3" or typeof(p35) == "Instance" and p35:IsA("BasePart"), "a tutorial anchor has to be a BasePart or a Vector3")

    local beam = p34.beam

    if beam ~= nil then
        TutorialBeam.Retarget(beam, p35)
    else
        p34.beam = TutorialBeam.Attach(p35)
    end
end

function t1.DropBeam(p36) -- line: 448
    -- upvalues: TutorialBeam (copy)
    local beam = p36.beam

    if beam ~= nil then
        p36.beam = nil
        TutorialBeam.Destroy(beam)
    end
end

function t1.MarkTapTarget(p37, p38, p39, p40, p41) -- line: 456
    -- upvalues: TutorialTapIndicator (copy), v8 (copy), v12 (copy), v13 (copy), v14 (copy)
    v8(p38)
    v12(p39)
    v13(p40)
    v14(p41)
    p37:DropTapTarget()
    p37.dropTapLater = TutorialTapIndicator.Attach(p38, p39, p40, p41)
end

function t1.MarkSurfaceTapTarget(p42, p43, p44, p45, p46, p47) -- line: 474
    -- upvalues: TutorialTapIndicator (copy), v3 (copy), v10 (copy), v12 (copy), v13 (copy), v14 (copy)
    v10(p43)
    v3(p44)
    v12(p45)
    v13(p46)
    v14(p47)

    local v28

    for _, child in p43:GetChildren() do
        if child:IsA("SurfaceGui") then
            v28 = child:FindFirstChild(p44)

            if v28 ~= nil and v28:IsA("GuiButton") then
                break
            end
        end

        v28 = nil
    end

    p42:DropTapTarget()

    if v28 == nil then
        return false
    end

    p42.dropTapLater = TutorialTapIndicator.Attach(v28, p45, p46, p47)

    return true
end

function t1.DropTapTarget(p48) -- line: 508
    local dropTapLater = p48.dropTapLater

    if dropTapLater ~= nil then
        p48.dropTapLater = nil
        dropTapLater()
    end
end

function t1.PinWorldClickHint(p49, p50) -- line: 516
    -- upvalues: ReplicatedStorage (copy), TweenService (copy), v1 (copy), v11 (copy)
    v11(p50)

    local clickPart = p49.clickPart

    if clickPart ~= nil then
        clickPart.CFrame = p50

        return
    end

    local BillboardTutorialClick = ReplicatedStorage.Assets.Billboards.BillboardTutorialClick

    assert(BillboardTutorialClick:IsA("BasePart"), "Assets.Billboards.BillboardTutorialClick is not a BasePart")

    local clone = BillboardTutorialClick:Clone()

    clone.CFrame = p50
    clone.Parent = workspace

    local BillboardGui = clone.BillboardGui

    assert(BillboardGui:IsA("BillboardGui"), "the click-hint billboard is not a BillboardGui")

    local Image = BillboardGui.Image

    assert(Image:IsA("ImageLabel"), "the click-hint image is not a ImageLabel")

    local UIScale = Image.UIScale

    assert(UIScale:IsA("UIScale"), "the click-hint scale is not a UIScale")
    p49.clickPart = clone
    UIScale.Scale = 1

    local tween = TweenService:Create(UIScale, v1.CLICK_PULSE, {
        Scale = 1.3
    })

    tween:Play()
    p49.clickTween = tween
end

function t1.DropWorldClickHint(p51) -- line: 543
    local clickTween = p51.clickTween

    if clickTween then
        clickTween:Cancel()
    end

    p51.clickTween = nil

    local clickPart = p51.clickPart

    if clickPart ~= nil then
        clickPart:Destroy()
        p51.clickPart = nil
    end
end

function t1.SetScreenClickHint(p52, p53) -- line: 554
    -- upvalues: Players (copy), TweenService (copy), v1 (copy), v5 (copy)
    v5(p53)

    local PlayerGui = Players.LocalPlayer:WaitForChild("PlayerGui")

    assert(PlayerGui:IsA("PlayerGui"), "LocalPlayer.PlayerGui is not a PlayerGui")

    local TutorialClick = PlayerGui:WaitForChild("TutorialClick")

    assert(TutorialClick:IsA("ScreenGui"), "PlayerGui.TutorialClick is not a ScreenGui")

    local Image = TutorialClick.Image

    assert(Image:IsA("ImageLabel"), "TutorialClick.Image is not a ImageLabel")

    local UIScale = Image.UIScale

    assert(UIScale:IsA("UIScale"), "TutorialClick.Image.UIScale is not a UIScale")
    p52.screenClick = TutorialClick

    if not p53 then
        p52:DropScreenClickHint()

        return
    end

    TutorialClick.Enabled = true

    if p52.screenClickTween == nil then
        UIScale.Scale = 1

        local tween = TweenService:Create(UIScale, v1.CLICK_PULSE, {
            Scale = 1.3
        })

        tween:Play()
        p52.screenClickTween = tween
    end
end

function t1.DropScreenClickHint(p54) -- line: 579
    local screenClickTween = p54.screenClickTween

    if screenClickTween then
        screenClickTween:Cancel()
    end

    p54.screenClickTween = nil

    local screenClick = p54.screenClick

    if screenClick ~= nil then
        screenClick.Enabled = false
    end
end

function t1.RingButton(p55, p56) -- line: 588
    -- upvalues: TutorialHighlightOverlay (copy), v9 (copy)
    v9(p56)
    p55:DropRing()
    p55.dropRingLater = TutorialHighlightOverlay.Attach(p56)
end

function t1.DropRing(p57) -- line: 595
    local dropRingLater = p57.dropRingLater

    if dropRingLater ~= nil then
        p57.dropRingLater = nil
        dropRingLater()
    end
end

function t1.PointArrowAt(p58, p59, p60, p61) -- line: 603
    -- upvalues: ArrowPointer3D (copy)
    assert(typeof(p59) == "Vector3" or typeof(p59) == "Instance" and p59:IsA("BasePart"), "a tutorial anchor has to be a BasePart or a Vector3")
    assert(typeof(p60) == "Vector3" or typeof(p60) == "Instance" and p60:IsA("BasePart"), "a tutorial anchor has to be a BasePart or a Vector3")
    assert(ArrowPointer3D.__types.OptionalConfig(p61))
    p58:DropArrow()

    local v31 = ArrowPointer3D.new(p59, p60, p61)

    v31:Start()
    p58.arrow = v31
end

function t1.RetargetArrow(p62, p63) -- line: 619
    assert(typeof(p63) == "Vector3" or typeof(p63) == "Instance" and p63:IsA("BasePart"), "a tutorial anchor has to be a BasePart or a Vector3")
    assert(p62.arrow, "there is no tutorial arrow to retarget"):PointAt(p63)
end

function t1.RebaseArrow(p64, p65) -- line: 625
    assert(typeof(p65) == "Vector3" or typeof(p65) == "Instance" and p65:IsA("BasePart"), "a tutorial anchor has to be a BasePart or a Vector3")
    assert(p64.arrow, "there is no tutorial arrow to rebase"):PointFrom(p65)
end

function t1.DropArrow(p66) -- line: 631
    local arrow = p66.arrow

    if arrow ~= nil then
        p66.arrow = nil
        arrow:Destroy()
    end
end

function t1.DropEverything(p67) -- line: 640
    p67:DropArrow()
    p67:DropBeam()
    p67:DropWorldClickHint()
    p67:DropRing()
    p67:DropTapTarget()
    p67:DropScreenClickHint()
    p67:DropSpeedGoal()
    p67:DropAnnounce()
end

function t1.Destroy(p68) -- line: 651
    -- upvalues: v15 (copy)
    v15:AtTrace():Log("Tearing down the guard tutorial presentation layer")
    p68:DropEverything()

    local progress = p68.progress

    if p68.ownsReadyScale and progress ~= nil then
        progress.readyScale:Destroy()
        p68.progress = nil
    end
end

return t1
