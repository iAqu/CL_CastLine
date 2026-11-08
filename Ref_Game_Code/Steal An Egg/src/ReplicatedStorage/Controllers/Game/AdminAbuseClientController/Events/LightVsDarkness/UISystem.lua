-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")
local GUI = require(ReplicatedStorage.Client.GUI)
local HiddenUIHandler = require(ReplicatedStorage.Client.HiddenUIHandler)
local LightVsDarkness = require(ReplicatedStorage.Data.LightVsDarkness)
local Remotes = require(ReplicatedStorage.Shared.Remotes)

require(ReplicatedStorage.Packages.Trove)

local v1 = Color3.fromRGB(255, 245, 190)
local v2 = Color3.fromRGB(255, 150, 150)
local v3 = Color3.fromRGB(85, 85, 85)
local v4 = Color3.fromRGB(71, 255, 0)
local v5 = UDim2.fromScale(1.03563285, 1.58552635)
local v6 = UDim2.fromScale(-0.470256448, 1.16447556)
local v7 = UDim2.fromScale(1.13319373, 1.7348907)
local v8 = UDim2.fromScale(-0.519036949, 1.16447568)
local v9 = TweenInfo.new(0.22, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local v10 = TweenInfo.new(0.34, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local v11 = TweenInfo.new(0.34, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
local v12 = TweenInfo.new(0.6, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true)
local v13 = Vector2.new(12, 8)
local Back = Enum.EasingStyle.Back
local In = Enum.EasingDirection.In
local v14 = Vector2.new(14, 10)
local LocalPlayer = Players.LocalPlayer
local t1, v15, v16
local v17 = false
local n1 = 0
local n2 = 0
local n3 = 0
local n4 = 0
local n5 = 0
local n6 = -1
local n7 = -1
local n8 = 0
local v18 = ""
local n9 = 0.5
local n10 = 0.5
local n11 = 0
local n12 = 0
local n13 = 0
local n14 = 0.5
local n15 = 0
local n16 = 0
local t2 = {
    p = 0,
    v = 0
}
local t3 = {
    p = 0,
    v = 0
}
local t4 = {
    p = 0,
    v = 0
}
local n17 = 0
local v19 = ""
local v20 = false
local v21 = false
local LvdTeam
local v22 = false
local t5 = {}
local Frame, tween
local v23 = Random.new()

local function spring() -- line: 218
    return {
        p = 0,
        v = 0
    }
end

local function stepSpring(p1, p2) -- line: 222
    p1.v += (p1.p * -260 - p1.v * 14) * p2
    p1.p += p1.v * p2
end

local function uiChild(p3, p4, p5) -- line: 227
    local v24 = p3:FindFirstChild(p4)

    assert(v24 and v24:IsA(p5), (("%*.%* must be a %*"):format(p3:GetFullName(), p4, p5)))

    return v24
end

local function resolveUi() -- line: 233
    -- upvalues: GUI (copy), LightVsDarkness (copy), t1 (ref)
    local t6 = t1

    if t6 then
        return t6
    end

    local v27 = GUI.LightVsDarknessUI()

    assert(v27:IsA("ScreenGui"), "LightVsDarknessUI must be a ScreenGui")

    local ScoreBar = v27:FindFirstChild("ScoreBar")

    assert(ScoreBar and ScoreBar:IsA("Frame"), (("%*.ScoreBar must be a Frame"):format((v27:GetFullName()))))

    local BarHolder = ScoreBar:FindFirstChild("BarHolder")

    assert(BarHolder and BarHolder:IsA("Frame"), (("%*.BarHolder must be a Frame"):format((ScoreBar:GetFullName()))))

    local BarBG = BarHolder:FindFirstChild("BarBG")

    assert(BarBG and BarBG:IsA("GuiObject"), (("%*.BarBG must be a GuiObject"):format((BarHolder:GetFullName()))))

    local LightBar = BarBG:FindFirstChild("LightBar")

    assert(LightBar and LightBar:IsA("Frame"), (("%*.LightBar must be a Frame"):format((BarBG:GetFullName()))))

    local DarkBar = BarBG:FindFirstChild("DarkBar")

    assert(DarkBar and DarkBar:IsA("Frame"), (("%*.DarkBar must be a Frame"):format((BarBG:GetFullName()))))

    local VSIcon = BarHolder:FindFirstChild("VSIcon")

    assert(VSIcon and VSIcon:IsA("ImageLabel"), (("%*.VSIcon must be a ImageLabel"):format((BarHolder:GetFullName()))))

    local VSText = BarHolder:FindFirstChild("VSText")

    assert(VSText and VSText:IsA("GuiObject"), (("%*.VSText must be a GuiObject"):format((BarHolder:GetFullName()))))

    local LightAmount = ScoreBar:FindFirstChild("LightAmount")

    assert(LightAmount and LightAmount:IsA("TextLabel"), (("%*.LightAmount must be a TextLabel"):format((ScoreBar:GetFullName()))))

    local DarknessAmount = ScoreBar:FindFirstChild("DarknessAmount")

    assert(DarknessAmount and DarknessAmount:IsA("TextLabel"), (("%*.DarknessAmount must be a TextLabel"):format((ScoreBar:GetFullName()))))

    local v46 = LightBar.Size.X.Scale + DarkBar.Size.X.Scale
    local PersonalRingMilestone = v27:FindFirstChild("PersonalRingMilestone")

    assert(PersonalRingMilestone and PersonalRingMilestone:IsA("Frame"), (("%*.PersonalRingMilestone must be a Frame"):format((v27:GetFullName()))))

    local ProgressBar = PersonalRingMilestone:FindFirstChild("ProgressBar")

    assert(ProgressBar and ProgressBar:IsA("Frame"), (("%*.ProgressBar must be a Frame"):format((PersonalRingMilestone:GetFullName()))))

    local RingScoreHolder = PersonalRingMilestone:FindFirstChild("RingScoreHolder")

    assert(RingScoreHolder and RingScoreHolder:IsA("Frame"), (("%*.RingScoreHolder must be a Frame"):format((PersonalRingMilestone:GetFullName()))))

    local RingScoreHolder2 = RingScoreHolder:FindFirstChild("RingScoreHolder")

    assert(RingScoreHolder2 and RingScoreHolder2:IsA("Frame"), (("%*.RingScoreHolder must be a Frame"):format((RingScoreHolder:GetFullName()))))

    local t7 = {}

    for v55, v56 in LightVsDarkness.MILESTONES do
        local Frame = v56.Frame
        local v57 = ProgressBar:FindFirstChild(Frame)

        assert(v57 and v57:IsA("Frame"), (("%*.%* must be a Frame"):format(ProgressBar:GetFullName(), Frame)))

        local ClaimButton = v57:FindFirstChild("ClaimButton")

        assert(ClaimButton and ClaimButton:IsA("ImageButton"), (("%*.ClaimButton must be a ImageButton"):format((v57:GetFullName()))))

        local ClaimedOverlay = ClaimButton:FindFirstChild("ClaimedOverlay")

        assert(ClaimedOverlay and ClaimedOverlay:IsA("ImageLabel"), (("%*.ClaimedOverlay must be a ImageLabel"):format((ClaimButton:GetFullName()))))

        local CompletedCheckmark = ClaimedOverlay:FindFirstChild("CompletedCheckmark")

        assert(CompletedCheckmark and CompletedCheckmark:IsA("ImageLabel"), (("%*.CompletedCheckmark must be a ImageLabel"):format((ClaimedOverlay:GetFullName()))))

        local RewardIcon = ClaimButton:FindFirstChild("RewardIcon")

        assert(RewardIcon and RewardIcon:IsA("ImageLabel"), (("%*.RewardIcon must be a ImageLabel"):format((ClaimButton:GetFullName()))))

        local QuantityLabel = RewardIcon:FindFirstChild("QuantityLabel")

        t7[v55] = {
            State = nil,
            FillPoint = 0,
            Index = v55,
            Rings = v56.Rings,
            Frame = v57,
            BaseSize = v57.Size,
            Button = ClaimButton,
            RewardIcon = RewardIcon,
            AuthoredIcon = RewardIcon.Image,
            Overlay = ClaimedOverlay,
            Checkmark = CompletedCheckmark,
            CheckSize = CompletedCheckmark.Size,
            Quantity = QuantityLabel,
            QuantityText = if QuantityLabel then QuantityLabel.Text else "",
            UnlockedDecor = v57:FindFirstChild("UnlockedDecor"),
            LockedDecor = v57:FindFirstChild("NotUnlockedDecor"),
            Tweens = {}
        }
    end

    local t9 = {
        Gui = v27,
        ScoreBar = ScoreBar,
        MilestonePanel = PersonalRingMilestone
    }
    local TeamSelection = v27:FindFirstChild("TeamSelection")

    assert(TeamSelection and TeamSelection:IsA("Frame"), (("%*.TeamSelection must be a Frame"):format((v27:GetFullName()))))
    t9.TeamPanel = TeamSelection
    t9.Holder = BarHolder
    t9.LightBar = LightBar
    t9.DarkBar = DarkBar
    t9.VsIcon = VSIcon
    t9.VsText = VSText

    local AngelWing = ScoreBar:FindFirstChild("AngelWing")

    assert(AngelWing and AngelWing:IsA("ImageLabel"), (("%*.AngelWing must be a ImageLabel"):format((ScoreBar:GetFullName()))))
    t9.AngelWing = AngelWing

    local DemonWing = ScoreBar:FindFirstChild("DemonWing")

    assert(DemonWing and DemonWing:IsA("ImageLabel"), (("%*.DemonWing must be a ImageLabel"):format((ScoreBar:GetFullName()))))
    t9.DemonWing = DemonWing
    t9.LightLabel = LightAmount
    t9.DarkLabel = DarknessAmount

    local BossName = ScoreBar:FindFirstChild("BossName")

    assert(BossName and BossName:IsA("TextLabel"), (("%*.BossName must be a TextLabel"):format((ScoreBar:GetFullName()))))
    t9.Timer = BossName
    t9.BarSpan = v46
    t9.SeamPad = (1 - v46) * 0.5
    t9.HolderPos = BarHolder.Position
    t9.IconPos = VSIcon.Position
    t9.IconSize = VSIcon.Size
    t9.TextPos = VSText.Position
    t9.TextSize = VSText.Size
    t9.LightLabelSize = LightAmount.Size
    t9.DarkLabelSize = DarknessAmount.Size
    t9.LightLabelColor = LightAmount.TextColor3
    t9.DarkLabelColor = DarknessAmount.TextColor3

    local LightYourTeam = ScoreBar:FindFirstChild("LightYourTeam")

    assert(LightYourTeam and LightYourTeam:IsA("TextLabel"), (("%*.LightYourTeam must be a TextLabel"):format((ScoreBar:GetFullName()))))
    t9.LightYourTeam = LightYourTeam

    local DarknessYourTeam = ScoreBar:FindFirstChild("DarknessYourTeam")

    assert(DarknessYourTeam and DarknessYourTeam:IsA("TextLabel"), (("%*.DarknessYourTeam must be a TextLabel"):format((ScoreBar:GetFullName()))))
    t9.DarknessYourTeam = DarknessYourTeam
    t9.MilestoneBar = ProgressBar

    local ProgressBar2 = ProgressBar:FindFirstChild("ProgressBar")

    assert(ProgressBar2 and ProgressBar2:IsA("Frame"), (("%*.ProgressBar must be a Frame"):format((ProgressBar:GetFullName()))))
    t9.MilestoneFill = ProgressBar2
    t9.ScoreHolder = RingScoreHolder
    t9.ScoreHolderSize = RingScoreHolder.Size
    t9.ScoreRow = RingScoreHolder2

    local RingScoreLabel = RingScoreHolder2:FindFirstChild("RingScoreLabel")

    assert(RingScoreLabel and RingScoreLabel:IsA("TextLabel"), (("%*.RingScoreLabel must be a TextLabel"):format((RingScoreHolder2:GetFullName()))))
    t9.RingScore = RingScoreLabel
    t9.Milestones = t7
    t1 = t9

    return t9
end

local function takeOverSprite(p6) -- line: 326
    local Cells = p6:GetAttribute("Cells")
    local FPS = p6:GetAttribute("FPS")

    if typeof(Cells) ~= "Vector2" then
        Cells = Vector2.new(8, 4)
    end

    if type(FPS) ~= "number" then
        FPS = 24
    end

    p6:SetAttribute("UIEffectsPaused", true)

    return {
        frame = 0,
        accum = 0,
        image = p6,
        columns = Cells.X,
        frames = Cells.X * Cells.Y,
        baseFps = FPS,
        fps = FPS,
        baseSize = p6.Size,
        punch = {
            p = 0,
            v = 0
        }
    }
end

local function releaseSprite(p7) -- line: 345
    p7.image.Size = p7.baseSize
    p7.image.Rotation = 0
    p7.image:SetAttribute("UIEffectsPaused", nil)
end

local function advanceSprite(p8, p9) -- line: 351
    p8.accum += p9

    local v84 = 1 / p8.fps
    local v85 = false

    while v84 <= p8.accum do
        p8.accum -= v84
        v85 = true
        p8.frame = (p8.frame + 1) % p8.frames
    end

    if v85 then
        local ImageRectSize = p8.image.ImageRectSize

        p8.image.ImageRectOffset = Vector2.new(ImageRectSize.X * (p8.frame % p8.columns), ImageRectSize.Y * math.floor(p8.frame / p8.columns))
    end

    local punch = p8.punch

    punch.v += (punch.p * -260 - punch.v * 14) * p9
    punch.p += punch.v * p9

    local v88 = p8.punch.p + 1
    local baseSize = p8.baseSize

    p8.image.Size = UDim2.new(baseSize.X.Scale * v88, baseSize.X.Offset, baseSize.Y.Scale * v88, baseSize.Y.Offset)
    p8.image.Rotation = p8.punch.p * 40
end

local function comma(p10) -- line: 374
    local v91 = tostring((math.floor(p10 + 0.5)))

    repeat
        local v92

        v91, v92 = v91:gsub("^(-?%d+)(%d%d%d)", "%1,%2")
    until v92 == 0

    return v91
end

local function formatTimer(p11) -- line: 386
    local v94 = math.max(math.ceil(p11), 0)

    return string.format("%d:%02d", v94 // 60, v94 % 60)
end

local function intensity() -- line: 391
    -- upvalues: Workspace (copy)
    if Workspace:GetAttribute("LvdFinalClash") == true then
        return 2
    end

    return 1
end

local function ratioOf(p12, p13) -- line: 395
    local v95 = p12 + p13

    if v95 <= 0 then
        return 0.5
    end

    return (math.clamp(p12 / v95, 0.12, 0.88))
end

local function applyRatio(p14, p15) -- line: 403
    p14.LightBar.Size = UDim2.new(p14.BarSpan * p15, 0, 1, 0)
    p14.DarkBar.Size = UDim2.new(p14.BarSpan * (1 - p15), 0, 1, 0)
end

local function clash(p16, p17) -- line: 408
    -- upvalues: Workspace (copy), v15 (ref), v16 (ref), n15 (ref), n16 (ref), t2 (ref)
    local v97 = if Workspace:GetAttribute("LvdFinalClash") == true then 2 else 1
    local v98 = v97 * 7
    local v100 = n15

    n15 = math.min(v98, v100 + p16 * 7 * v97)

    local t10 = t2

    t10.v += p16 * 9 * v97

    local v101 = n16

    n16 = v101 + (p17 and 1 or -1) * 26 * p16 * v97

    local v102 = v15
    local v103 = v16

    if not p17 or not v102 then
        if v103 then
            v103.punch.v += p16 * 7 * v97
        end
    else
        v102.punch.v += p16 * 7 * v97
    end
end

local function stepLabels(p18, p19) -- line: 452
    -- upvalues: v1 (copy), v2 (copy), n2 (ref), n3 (ref), n4 (ref), n5 (ref), n6 (ref), n7 (ref), n8 (ref), t3 (ref), t4 (ref), comma (copy)
    local v105 = 1 - math.exp(p19 * -6)
    local v106 = n4
    local v107 = n2

    n4 = v106 + (v107 - n4) * v105

    local v108 = n5
    local v109 = n3

    n5 = v108 + (v109 - n5) * v105

    local t11 = t3

    t11.v += (t11.p * -260 - t11.v * 14) * p19
    t11.p += t11.v * p19

    local t12 = t4

    t12.v += (t12.p * -260 - t12.v * 14) * p19
    t12.p += t12.v * p19
    n8 += p19

    if n8 >= 0.08333333333333333 then
        n8 = 0

        local v111 = math.floor(n4 + 0.5)
        local v113 = math.floor(n5 + 0.5)
        local v115 = math.max(v111 + v113, 1)

        if n6 >= 0 and n6 < v111 then
            local t13 = t3

            t13.v = t13.v + math.min((v111 - n6) / v115 * 60, 1) * 5
        end

        if n7 >= 0 and n7 < v113 then
            local t14 = t4

            t14.v = t14.v + math.min((v113 - n7) / v115 * 60, 1) * 5
        end

        n6 = v111
        n7 = v113

        local v118 = comma(v111)
        local v119 = comma(v113)

        if p18.LightLabel.Text ~= v118 then
            p18.LightLabel.Text = v118
        end

        if p18.DarkLabel.Text ~= v119 then
            p18.DarkLabel.Text = v119
        end
    end

    local v120 = t3.p * 0.5 + 1
    local LightLabelSize = p18.LightLabelSize

    p18.LightLabel.Size = UDim2.new(LightLabelSize.X.Scale * v120, LightLabelSize.X.Offset, LightLabelSize.Y.Scale * v120, LightLabelSize.Y.Offset)
    p18.LightLabel.TextColor3 = p18.LightLabelColor:Lerp(v1, (math.clamp(t3.p * 4, 0, 1)))

    local v122 = t4.p * 0.5 + 1
    local DarkLabelSize = p18.DarkLabelSize

    p18.DarkLabel.Size = UDim2.new(DarkLabelSize.X.Scale * v122, DarkLabelSize.X.Offset, DarkLabelSize.Y.Scale * v122, DarkLabelSize.Y.Offset)
    p18.DarkLabel.TextColor3 = p18.DarkLabelColor:Lerp(v2, (math.clamp(t4.p * 4, 0, 1)))
end

local function cancelTweens(p20) -- line: 500
    for v124, v125 in p20.Tweens do
        v125:Cancel()
        p20.Tweens[v124] = nil
    end
end

local function play(p21, p22, p23, p24, p25) -- line: 508
    -- upvalues: TweenService (copy)
    local v126 = p21.Tweens[p22]

    if v126 then
        v126:Cancel()
    end

    local tween = TweenService:Create(p23, p24, p25)

    p21.Tweens[p22] = tween
    tween:Play()
end

local function punch(p26) -- line: 518
    -- upvalues: TweenService (copy), v10 (copy), v13 (copy)
    local BaseSize = p26.BaseSize

    p26.Frame.Size = UDim2.new(BaseSize.X.Scale, BaseSize.X.Offset + v13.X, BaseSize.Y.Scale, BaseSize.Y.Offset + v13.Y)

    local Frame = p26.Frame
    local t15 = {
        Size = BaseSize
    }
    local punch = p26.Tweens.punch

    if punch then
        punch:Cancel()
    end

    local tween = TweenService:Create(Frame, v10, t15)

    p26.Tweens.punch = tween
    tween:Play()
end

local function setMilestoneState(p27, p28, p29) -- line: 527
    -- upvalues: TweenService (copy), v3 (copy), v4 (copy), v5 (copy), v6 (copy), v7 (copy), v8 (copy), v9 (copy), v11 (copy), v12 (copy), punch (copy)
    if p27.State == p28 then
        return
    end

    p27.State = p28

    for v127, v128 in p27.Tweens do
        v128:Cancel()
        p27.Tweens[v127] = nil
    end

    local v129 = p28 ~= "Locked"

    if p27.UnlockedDecor then
        p27.UnlockedDecor.Visible = v129
    end

    if p27.LockedDecor then
        p27.LockedDecor.Visible = not v129
    end

    p27.Frame.Size = p27.BaseSize

    if p29 then
        local Frame = p27.Frame
        local t16 = {
            BackgroundColor3 = if v129 then v4 else v3
        }
        local bg = p27.Tweens.bg

        if bg then
            bg:Cancel()
        end

        local tween = TweenService:Create(Frame, v9, t16)

        p27.Tweens.bg = tween
        tween:Play()
    else
        local Frame = p27.Frame

        if v129 then
            Frame.BackgroundColor3 = v4
        else
            Frame.BackgroundColor3 = v3
        end
    end

    local Button = p27.Button

    Button.Image = v129 and "rbxassetid://73951419137281" or "rbxassetid://111037630886814"

    if v129 then
        Button.Position = v6
        Button.Size = v5
    else
        Button.Position = v8
        Button.Size = v7
    end

    Button.Active = p28 == "Ready"
    p27.Overlay.Visible = p28 == "Claimed"

    if p28 == "Claimed" then
        if p29 then
            p27.Overlay.ImageTransparency = 1

            local Overlay = p27.Overlay
            local t17 = {
                ImageTransparency = 0.64
            }
            local overlay = p27.Tweens.overlay

            if overlay then
                overlay:Cancel()
            end

            local tween = TweenService:Create(Overlay, v9, t17)

            p27.Tweens.overlay = tween
            tween:Play()
            p27.Checkmark.ImageTransparency = 1
            p27.Checkmark.Size = UDim2.fromScale(p27.CheckSize.X.Scale * 0.2, p27.CheckSize.Y.Scale * 0.2)

            local Checkmark = p27.Checkmark
            local t18 = {
                ImageTransparency = 0,
                Size = p27.CheckSize
            }
            local check = p27.Tweens.check

            if check then
                check:Cancel()
            end

            local tween2 = TweenService:Create(Checkmark, v11, t18)

            p27.Tweens.check = tween2
            tween2:Play()
            punch(p27)
        else
            p27.Overlay.ImageTransparency = 0.64
            p27.Checkmark.ImageTransparency = 0
            p27.Checkmark.Size = p27.CheckSize
        end
    else
        if p29 then
            punch(p27)
        end

        if p28 == "Ready" then
            Button.Size = v5

            local t19 = {
                Size = UDim2.fromScale(v5.X.Scale * 1.07, v5.Y.Scale * 1.07)
            }
            local pulse = p27.Tweens.pulse

            if pulse then
                pulse:Cancel()
            end

            local tween = TweenService:Create(Button, v12, t19)

            p27.Tweens.pulse = tween
            tween:Play()
        end
    end
end

local function measureFillPoints(p30) -- line: 596
    local Y = p30.MilestoneBar.AbsolutePosition.Y
    local Y2 = p30.MilestoneBar.AbsoluteSize.Y

    if Y2 <= 0 then
        return false
    end

    for _, v130 in p30.Milestones do
        v130.FillPoint = math.clamp((v130.Frame.AbsolutePosition.Y + v130.Frame.AbsoluteSize.Y * 0.5 - Y) / Y2, 0, 1)
    end

    return true
end

local function fillScaleFor(p31, p32) -- line: 610
    local n18 = 0
    local n19 = 0

    for _, v132 in p31.Milestones do
        if p32 <= v132.Rings then
            local v133 = v132.Rings - n18
            local v134 = if v133 > 0 then (p32 - n18) / v133 else 1

            return n19 + (v132.FillPoint - n19) * v134
        end

        n18 = v132.Rings
        n19 = v132.FillPoint
    end

    return n19
end

local function readRings() -- line: 623
    -- upvalues: LocalPlayer (copy)
    local LvdRingsCollected = LocalPlayer:GetAttribute("LvdRingsCollected")

    if type(LvdRingsCollected) == "number" then
        return LvdRingsCollected
    end

    return 0
end

local function stepYourTeam(p33) -- line: 629
    -- upvalues: LightVsDarkness (copy), LocalPlayer (copy), LvdTeam (ref), v22 (ref)
    local LvdTeam2 = LocalPlayer:GetAttribute("LvdTeam")

    p33.LightYourTeam.Visible = LvdTeam2 == "Light"
    p33.DarknessYourTeam.Visible = LvdTeam2 == "Darkness"

    if type(LvdTeam2) ~= "string" then
        LvdTeam2 = nil
    end

    if v22 and LvdTeam == LvdTeam2 then
        return
    end

    v22 = true
    LvdTeam = LvdTeam2

    for v135, v136 in p33.Milestones do
        v136.RewardIcon.Image = LightVsDarkness.MilestoneIcon(v135, LvdTeam2) or v136.AuthoredIcon
    end
end

local function isClaimed(p34) -- line: 646
    -- upvalues: LightVsDarkness (copy), LocalPlayer (copy)
    return LocalPlayer:GetAttribute(LightVsDarkness.MilestoneAttribute(p34)) == true
end

local function stepMilestones(p35, _) -- line: 665
    -- upvalues: LightVsDarkness (copy), LocalPlayer (copy), n17 (ref), v20 (ref), v21 (ref), setMilestoneState (copy), measureFillPoints (copy), fillScaleFor (copy)
    local v137 = v20
    local v138

    if not v137 then
        v20 = measureFillPoints(p35)
        v138 = v20
    end

    if not (v137 or v138) then
        return
    end

    local v139 = v21

    v21 = true

    local LvdRingsCollected = LocalPlayer:GetAttribute("LvdRingsCollected")

    if type(LvdRingsCollected) ~= "number" then
        LvdRingsCollected = 0
    end

    p35.MilestoneFill.Size = UDim2.new(1, 0, fillScaleFor(p35, n17), 0)

    for v140, v141 in p35.Milestones do
        setMilestoneState(v141, if LocalPlayer:GetAttribute(LightVsDarkness.MilestoneAttribute(v140)) == true then "Claimed" elseif v141.Rings <= LvdRingsCollected then "Ready" else "Locked", v139)
    end
end

local function flyerLayer(p37) -- line: 686
    -- upvalues: Frame (ref)
    local Frame2 = Frame

    if Frame2 ~= nil and Frame2.Parent == p37.Gui then
        return Frame2
    end

    if Frame2 ~= nil then
        Frame2:Destroy()
    end

    local Frame3 = Instance.new("Frame")

    Frame3.Name = "RingFlight"
    Frame3.BackgroundTransparency = 1
    Frame3.Size = UDim2.fromScale(1, 1)
    Frame3.ZIndex = 50
    Frame3.Parent = p37.Gui
    Frame = Frame3

    return Frame3
end

local function counterTarget(p38) -- line: 704
    return p38.ScoreRow.AbsolutePosition + p38.ScoreRow.AbsoluteSize * 0.5 - p38.Gui.AbsolutePosition
end

local function punchCounter(p39) -- line: 708
    -- upvalues: TweenService (copy), v10 (copy), v14 (copy), tween (ref)
    local ScoreHolderSize = p39.ScoreHolderSize

    p39.ScoreHolder.Size = UDim2.new(ScoreHolderSize.X.Scale, ScoreHolderSize.X.Offset + v14.X, ScoreHolderSize.Y.Scale, ScoreHolderSize.Y.Offset + v14.Y)

    local tween2 = tween

    if tween2 ~= nil then
        tween2:Cancel()
    end

    local tween3 = TweenService:Create(p39.ScoreHolder, v10, {
        Size = ScoreHolderSize
    })

    tween = tween3
    tween3:Play()
end

local function dropFlyer(p40) -- line: 723
    -- upvalues: t5 (copy)
    local v143 = table.remove(t5, p40)

    if v143 ~= nil then
        v143.Frame:Destroy()
    end
end

local function arriveFlyer(p41, p42) -- line: 730
    -- upvalues: t5 (copy), punchCounter (copy)
    local v144 = table.remove(t5, p42)

    if v144 ~= nil then
        v144.Frame:Destroy()
    end

    punchCounter(p41)
end

local function stepFlyers() -- line: 735
    -- upvalues: TweenService (copy), Back (copy), In (copy), t1 (ref), t5 (copy), punchCounter (copy)
    local t20 = t1

    if t20 ~= nil and #t5 ~= 0 then
        local elapsed = os.clock()
        local v145 = t20.ScoreRow.AbsolutePosition + t20.ScoreRow.AbsoluteSize * 0.5 - t20.Gui.AbsolutePosition

        for i = #t5, 1, -1 do
            local v146 = t5[i]

            if v146.Frame.Parent ~= nil then
                local v147 = (elapsed - v146.StartAt) / 0.55

                if v147 >= 1 then
                    local v148 = table.remove(t5, i)

                    if v148 ~= nil then
                        v148.Frame:Destroy()
                    end

                    punchCounter(t20)
                else
                    v146.Frame.Rotation = (elapsed * 140 + v146.Phase) % 360

                    if not (v147 < 0) then
                        local Value = TweenService:GetValue(v147, Back, In)
                        local v149 = 1 - Value
                        local v150 = v146.From * v149 * v149 + v146.Control * 2 * v149 * Value + v145 * Value * Value

                        v146.Frame.Position = UDim2.fromOffset(v150.X, v150.Y)

                        local v151 = 1 - math.clamp(Value, 0, 1) * 0.4

                        v146.Frame.Size = UDim2.fromOffset(v151 * 46, v151 * 46)
                    end
                end
            else
                table.remove(t5, i)
            end
        end
    end
end

local function ringArrived(_, p44) -- line: 768
    -- upvalues: Workspace (copy), t1 (ref), v17 (ref), t5 (copy), v23 (copy), flyerLayer (copy), punchCounter (copy)
    local t21 = t1

    if v17 and t21 ~= nil and t21.Gui.Enabled then
        local Icon = t21.ScoreRow:FindFirstChild("Icon")

        if Icon ~= nil and Icon:IsA("ImageLabel") then
            local CurrentCamera = Workspace.CurrentCamera

            if CurrentCamera ~= nil then
                local v152, v153 = CurrentCamera:WorldToViewportPoint(p44 + Vector3.new(0, 1.5, 0))
                local ViewportSize = CurrentCamera.ViewportSize
                local v154 = (if v153 then Vector2.new(v152.X, v152.Y) else Vector2.new(ViewportSize.X * 0.5, ViewportSize.Y * 0.62)) + Vector2.new(v23:NextNumber(-70, 70), v23:NextNumber(-70, 70) * 0.7) - t21.Gui.AbsolutePosition
                local v155 = t21.ScoreRow.AbsolutePosition + t21.ScoreRow.AbsoluteSize * 0.5 - t21.Gui.AbsolutePosition
                local v156 = v155 - v154
                local v157 = if v156.Magnitude > 1 then Vector2.new(-v156.Y, v156.X).Unit else Vector2.new(0, -1)
                local v158 = (v154 + v155) * 0.5 + v157 * v23:NextNumber(-0.3, 0.3) * v156.Magnitude + Vector2.new(0, -v23:NextNumber(10, 60))

                while #t5 >= 24 do
                    local v159 = table.remove(t5, 1)

                    if v159 ~= nil then
                        v159.Frame:Destroy()
                    end

                    punchCounter(t21)
                end

                local ImageLabel = Instance.new("ImageLabel")

                ImageLabel.Name = "RingFlyer"
                ImageLabel.BackgroundTransparency = 1
                ImageLabel.AnchorPoint = Vector2.new(0.5, 0.5)
                ImageLabel.Size = UDim2.fromOffset(46, 46)
                ImageLabel.Position = UDim2.fromOffset(v154.X, v154.Y)
                ImageLabel.Image = Icon.Image
                ImageLabel.ImageColor3 = Icon.ImageColor3
                ImageLabel.ImageRectOffset = Icon.ImageRectOffset
                ImageLabel.ImageRectSize = Icon.ImageRectSize
                ImageLabel.ScaleType = Enum.ScaleType.Fit
                ImageLabel.Parent = flyerLayer(t21)
                table.insert(t5, {
                    Frame = ImageLabel,
                    From = v154,
                    Control = v158,
                    StartAt = os.clock() + v23:NextNumber(0, 0.12),
                    Phase = v23:NextNumber(0, 360)
                })
            end
        end
    end
end

local function step(p45) -- line: 823
    -- upvalues: Workspace (copy), HiddenUIHandler (copy), LocalPlayer (copy), t1 (ref), v15 (ref), v16 (ref), v17 (ref), n1 (ref), v18 (ref), n9 (ref), n10 (ref), n11 (ref), n12 (ref), n13 (ref), n14 (ref), n15 (ref), n16 (ref), t2 (ref), n17 (ref), v19 (ref), advanceSprite (copy), comma (copy), stepLabels (copy), stepYourTeam (copy), stepMilestones (copy)
    local t23 = t1
    local v160 = v15
    local v161 = v16

    if v17 and t23 ~= nil and v160 ~= nil and v161 ~= nil then
        if HiddenUIHandler.IsHidden() then
            t23.Gui.Enabled = false
        else
            t23.Gui.Enabled = true

            local Visible = t23.TeamPanel.Visible

            t23.ScoreBar.Visible = not Visible
            t23.MilestonePanel.Visible = not Visible

            local v162 = math.min(p45, 0.1)
            local LvdRingsCollected = LocalPlayer:GetAttribute("LvdRingsCollected")

            if type(LvdRingsCollected) ~= "number" then
                LvdRingsCollected = 0
            end

            n17 += (LvdRingsCollected - n17) * (1 - math.exp(v162 * -6))

            if math.abs(LvdRingsCollected - n17) < 0.5 then
                n17 = LvdRingsCollected
            end

            local v168 = comma((math.floor(n17)))

            if v168 ~= v19 then
                v19 = v168
                t23.RingScore.Text = v168
            end

            if not Visible then
                local v169 = math.min(p45, 0.1)
                local v170 = if Workspace:GetAttribute("LvdFinalClash") == true then 2 else 1

                n13 -= n13 * math.min(v169 * 1.6, 1)

                local v175 = math.clamp(n9 + n13, 0.12, 0.88)

                n11 += (v175 - n10) * 55 * v169
                n11 *= math.exp(v169 * -7)

                local v180 = n10

                n10 = math.clamp(v180 + n11 * v169, 0.05, 0.95)

                local v181 = n10

                t23.LightBar.Size = UDim2.new(t23.BarSpan * v181, 0, 1, 0)
                t23.DarkBar.Size = UDim2.new(t23.BarSpan * (1 - v181), 0, 1, 0)
                n12 += (n11 - n12) * (1 - math.exp(v169 * -8))

                local v186 = math.clamp(n12 / 0.5, -1, 1)

                v160.fps = v160.baseFps + (90 - v160.baseFps) * math.max(v186, 0)
                v161.fps = v161.baseFps + (90 - v161.baseFps) * math.max(-v186, 0)
                advanceSprite(v160, v169)
                advanceSprite(v161, v169)

                local v189 = t23.BarSpan * n10 + t23.SeamPad

                n14 += (v189 - n14) * (1 - math.exp(v169 * -22))

                local t24 = t2

                t24.v += (t24.p * -260 - t24.v * 14) * v169
                t24.p += t24.v * v169
                n16 -= n16 * math.min(v169 * 6, 1)

                local v196 = t2.p + 1
                local v197 = v186 * 10 * v170 + n16

                t23.VsIcon.Position = UDim2.new(n14, t23.IconPos.X.Offset, t23.IconPos.Y.Scale, t23.IconPos.Y.Offset)
                t23.VsIcon.Size = UDim2.new(t23.IconSize.X.Scale * v196, t23.IconSize.X.Offset, t23.IconSize.Y.Scale * v196, t23.IconSize.Y.Offset)
                t23.VsIcon.Rotation = v197
                t23.VsText.Position = UDim2.new(n14, t23.TextPos.X.Offset, t23.TextPos.Y.Scale, t23.TextPos.Y.Offset)
                t23.VsText.Size = UDim2.new(t23.TextSize.X.Scale * v196, t23.TextSize.X.Offset, t23.TextSize.Y.Scale * v196, t23.TextSize.Y.Offset)
                t23.VsText.Rotation = v197
                n15 -= n15 * math.min(v169 * 6, 1)

                if v170 > 1 then
                    n15 = math.max(n15, 1.5)
                end

                local HolderPos = t23.HolderPos

                if n15 > 0.05 then
                    t23.Holder.Position = UDim2.new(HolderPos.X.Scale, HolderPos.X.Offset + (math.random() - 0.5) * 2 * n15, HolderPos.Y.Scale, HolderPos.Y.Offset + (math.random() - 0.5) * n15)
                elseif t23.Holder.Position ~= HolderPos then
                    t23.Holder.Position = HolderPos
                end

                stepLabels(t23, v169)
                stepMilestones(t23, v169)
                stepYourTeam(t23)

                local v203 = n1
                local v205 = math.max(math.ceil(v203 - Workspace:GetServerTimeNow()), 0)
                local v206 = string.format("%d:%02d", v205 // 60, v205 % 60)

                if v206 ~= v18 then
                    v18 = v206
                    t23.Timer.Text = v206
                end
            end
        end
    end
end

local function stop() -- line: 908
    -- upvalues: v3 (copy), v7 (copy), v8 (copy), t1 (ref), v15 (ref), v16 (ref), v17 (ref), t5 (copy), Frame (ref), tween (ref)
    if not v17 then
        return
    end

    v17 = false

    for i = #t5, 1, -1 do
        local v207 = table.remove(t5, i)

        if v207 ~= nil then
            v207.Frame:Destroy()
        end
    end

    local tween2 = tween

    tween = nil

    if tween2 ~= nil then
        tween2:Cancel()
    end

    local Frame2 = Frame

    Frame = nil

    if Frame2 ~= nil then
        Frame2:Destroy()
    end

    local t25 = t1

    if t25 then
        t25.Gui.Enabled = false
        t25.ScoreHolder.Size = t25.ScoreHolderSize
        t25.ScoreBar.Visible = true
        t25.MilestonePanel.Visible = true
        t25.Holder.Position = t25.HolderPos
        t25.VsIcon.Position = t25.IconPos
        t25.VsIcon.Size = t25.IconSize
        t25.VsIcon.Rotation = 0
        t25.VsText.Position = t25.TextPos
        t25.VsText.Size = t25.TextSize
        t25.VsText.Rotation = 0
        t25.LightLabel.Size = t25.LightLabelSize
        t25.DarkLabel.Size = t25.DarkLabelSize
        t25.LightLabel.TextColor3 = t25.LightLabelColor
        t25.DarkLabel.TextColor3 = t25.DarkLabelColor
        t25.LightYourTeam.Visible = false
        t25.DarknessYourTeam.Visible = false

        for _, v208 in t25.Milestones do
            for v209, v210 in v208.Tweens do
                v210:Cancel()
                v208.Tweens[v209] = nil
            end

            v208.State = nil

            if v208.State ~= "Locked" then
                v208.State = "Locked"

                for v211, v212 in v208.Tweens do
                    v212:Cancel()
                    v208.Tweens[v211] = nil
                end

                if v208.UnlockedDecor then
                    v208.UnlockedDecor.Visible = false
                end

                if v208.LockedDecor then
                    v208.LockedDecor.Visible = true
                end

                v208.Frame.Size = v208.BaseSize
                v208.Frame.BackgroundColor3 = v3

                local Button = v208.Button

                Button.Image = "rbxassetid://111037630886814"
                Button.Position = v8
                Button.Size = v7
                Button.Active = false
                v208.Overlay.Visible = false
            end

            v208.Frame.Size = v208.BaseSize
            v208.RewardIcon.Image = v208.AuthoredIcon

            local Quantity = v208.Quantity

            if Quantity then
                Quantity.Visible = true
                Quantity.Text = v208.QuantityText
            end
        end
    end

    local v213 = v15
    local v214 = v16

    v15 = nil
    v16 = nil

    if v213 then
        v213.image.Size = v213.baseSize
        v213.image.Rotation = 0
        v213.image:SetAttribute("UIEffectsPaused", nil)
    end

    if not v214 then
        return
    end

    v214.image.Size = v214.baseSize
    v214.image.Rotation = 0
    v214.image:SetAttribute("UIEffectsPaused", nil)
end

return {
    Start = function(p46, p47) -- start | line: 971
        -- upvalues: RunService (copy), GUI (copy), LightVsDarkness (copy), Remotes (copy), LocalPlayer (copy), t1 (ref), v15 (ref), v16 (ref), v17 (ref), n1 (ref), n2 (ref), n3 (ref), n4 (ref), n5 (ref), n6 (ref), n7 (ref), n8 (ref), v18 (ref), n9 (ref), n10 (ref), n11 (ref), n12 (ref), n13 (ref), n14 (ref), n15 (ref), n16 (ref), t2 (ref), t3 (ref), t4 (ref), n17 (ref), v19 (ref), v20 (ref), v21 (ref), v22 (ref), resolveUi (copy), takeOverSprite (copy), comma (copy), clash (copy), stepYourTeam (copy), stepMilestones (copy), stepFlyers (copy), step (copy), stop (copy)
        stop()

        local v215 = resolveUi()

        v17 = true
        n1 = p47
        n2 = 0
        n3 = 0
        n4 = 0
        n5 = 0
        n6 = -1
        n7 = -1
        n8 = 0
        v18 = ""
        n9 = 0.5
        n10 = 0.5
        n11 = 0
        n12 = 0
        n13 = 0
        n14 = v215.BarSpan * 0.5 + v215.SeamPad
        n15 = 0
        n16 = 0

        local t26 = {
            p = 0,
            v = 0
        }
        local t27 = {
            p = 0,
            v = 0
        }

        t2 = {
            p = 0,
            v = 0
        }
        t3 = t26
        t4 = t27
        v15 = takeOverSprite(v215.AngelWing)
        v16 = takeOverSprite(v215.DemonWing)

        local v216 = n10

        v215.LightBar.Size = UDim2.new(v215.BarSpan * v216, 0, 1, 0)
        v215.DarkBar.Size = UDim2.new(v215.BarSpan * (1 - v216), 0, 1, 0)
        v215.LightLabel.Text = "0"
        v215.DarkLabel.Text = "0"

        local LvdRingsCollected = LocalPlayer:GetAttribute("LvdRingsCollected")

        if type(LvdRingsCollected) ~= "number" then
            LvdRingsCollected = 0
        end

        n17 = LvdRingsCollected
        v19 = ""
        v20 = false
        v21 = false
        v22 = false

        for v217, v218 in v215.Milestones do
            v218.State = nil

            local Quantity = v218.Quantity

            if Quantity then
                local v219 = LightVsDarkness.MilestoneQuantity(v217)

                Quantity.Visible = v219 ~= nil
                Quantity.Text = v219 or Quantity.Text
            end

            GUI.OnActivated(v218.Button, function() -- line: 1006
                -- upvalues: v218 (copy), v217 (copy), Remotes (copy), v17 (ref)
                if not v17 or v218.State ~= "Ready" then
                    return
                end

                Remotes.LightVsDarkness.AskClaimMilestone:FireServer(v217)
            end)

            local ValueHolder = v218.Frame:FindFirstChild("ValueHolder")

            if ValueHolder then
                ValueHolder.Title.Text = ("%*"):format(v218.Rings)
            end
        end

        stepYourTeam(v215)

        local LvdRingsCollected2 = LocalPlayer:GetAttribute("LvdRingsCollected")

        if type(LvdRingsCollected2) ~= "number" then
            LvdRingsCollected2 = 0
        end

        local v220 = n17

        n17 = v220 + (LvdRingsCollected2 - n17) * 0.4511883639059736

        if math.abs(LvdRingsCollected2 - n17) < 0.5 then
            n17 = LvdRingsCollected2
        end

        local v223 = comma((math.floor(n17)))

        if v223 ~= v19 then
            v19 = v223
            v215.RingScore.Text = v223
        end

        stepMilestones(v215, 0.1)
        p46:Connect(Remotes.LightVsDarkness.ScoreChanged.OnClientEvent, function(p48, p49) -- line: 1022
            -- upvalues: v17 (ref), n2 (ref), n3 (ref), n9 (ref), n13 (ref), clash (copy)
            if not v17 then
                return
            end

            local v224 = n9

            n2 = p48
            n3 = p49

            local v225 = p48 + p49

            n9 = if v225 <= 0 then 0.5 else math.clamp(p48 / v225, 0.12, 0.88)

            local v228 = n9 - v224

            if v228 == 0 then
                return
            end

            local v230 = math.clamp(math.abs(v228) / 0.05, 0.15, 1)
            local v231 = v228 > 0

            n13 = (v231 and 1 or -1) * 0.22 * v230
            clash(v230, v231)
        end)
        p46:Connect(RunService.PreRender, step)
        p46:Connect(RunService.PreRender, stepFlyers)
        p46:Add(stop)
        p46:Add(task.spawn(function() -- line: 1032
            -- upvalues: Remotes (copy), t1 (ref), v17 (ref), n2 (ref), n3 (ref), n4 (ref), n5 (ref), n9 (ref), n10 (ref), n11 (ref), n13 (ref), n14 (ref)
            local v232, v233 = Remotes.LightVsDarkness.FetchScore:InvokeServer()

            if not v17 or type(v232) ~= "number" or type(v233) ~= "number" or n2 ~= 0 or n3 ~= 0 then
                return
            end

            local _ = n9

            n2 = v232
            n3 = v233

            local v234 = v232 + v233

            n9 = if v234 <= 0 then 0.5 else math.clamp(v232 / v234, 0.12, 0.88)
            n4 = v232
            n5 = v233
            n10 = n9
            n11 = 0
            n13 = 0

            local t28 = t1

            if not t28 then
                return
            end

            n14 = t28.BarSpan * n10 + t28.SeamPad

            local v237 = n10

            t28.LightBar.Size = UDim2.new(t28.BarSpan * v237, 0, 1, 0)
            t28.DarkBar.Size = UDim2.new(t28.BarSpan * (1 - v237), 0, 1, 0)
        end))
    end,
    Stop = stop,
    RingArrived = ringArrived
}
