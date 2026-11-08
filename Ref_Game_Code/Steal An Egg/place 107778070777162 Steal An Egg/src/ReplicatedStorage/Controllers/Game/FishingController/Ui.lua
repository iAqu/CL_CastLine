-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local GuiService = game:GetService("GuiService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer
local v1 = UDim2.fromScale(0.5, 0.5)
local v2 = UDim2.fromScale(0.5, -0.5)
local v3 = UDim2.fromScale(0.5, 1.5)
local v4 = Color3.fromRGB(255, 205, 60)
local v5 = Color3.fromRGB(255, 250, 214)
local v6 = Color3.new(1, 1, 1)
local ffe45a = Color3.fromHex("ffe45a")
local t1
local n1 = 0
local n2 = 0
local v7, v8
local n3 = -1
local t2 = {}

local function child(p1, p2) -- line: 92
    for _, v10 in p2 do
        local v11 = p1:FindFirstChild(v10)

        if v11 == nil then
            error((("[Fishing] FishingUI is missing %*.%*"):format(p1:GetFullName(), v10)))
        end

        p1 = v11
    end

    return p1
end

local function tween(p3, p4, p5, p6) -- line: 104
    -- upvalues: TweenService (copy)
    TweenService:Create(p3, TweenInfo.new(p4, p6 or Enum.EasingStyle.Quad, Enum.EasingDirection.Out), p5):Play()
end

local function scaleOf(p7) -- line: 114
    return p7:FindFirstChildOfClass("UIScale")
end

local function punch(p8, p9, p10) -- line: 118
    -- upvalues: GuiService (copy), TweenService (copy)
    local UIScale = p8:FindFirstChildOfClass("UIScale")

    if UIScale ~= nil then
        if GuiService.ReducedMotionEnabled then
            UIScale.Scale = 1
        else
            UIScale.Scale = p9

            local t3 = {
                Scale = 1
            }
            local Back = Enum.EasingStyle.Back

            TweenService:Create(UIScale, TweenInfo.new(p10, Back or Enum.EasingStyle.Quad, Enum.EasingDirection.Out), t3):Play()
        end
    end
end

local function number(p11, p12, p13) -- line: 131
    local Attribute = p11:GetAttribute(p12)

    if type(Attribute) == "number" then
        return Attribute
    end

    return p13
end

local function span(p14) -- line: 136
    local Scale = p14.Size.Y.Scale

    return p14.Position.Y.Scale - p14.AnchorPoint.Y * Scale, Scale
end

local function digits(p15) -- line: 141
    -- upvalues: child (copy)
    local t4 = {}
    local n4 = 1

    while true do
        local v14 = p15:FindFirstChild((("Digit%*"):format(n4)))

        if v14 == nil then
            break
        end

        table.insert(t4, {
            Current = child(v14, { "Current" }),
            Next = child(v14, { "Next" }),
            Value = child(v14, { "Current" }).Text,
            Tweens = {}
        })
        n4 += 1
    end

    return t4
end

local function glyphs(p16) -- line: 160
    local t6 = {}

    for _, descendant in p16:GetDescendants() do
        if descendant:IsA("TextLabel") then
            table.insert(t6, descendant)
        end
    end

    return t6
end

local function bind() -- line: 170
    -- upvalues: LocalPlayer (copy), t1 (ref), v7 (ref), v8 (ref), n3 (ref), child (copy), digits (copy), glyphs (copy)
    local t7 = t1

    if t7 and t7.Gui.Parent ~= nil and t7.VignetteGui.Parent ~= nil then
        return t7
    end

    local PlayerGui = LocalPlayer:FindFirstChildOfClass("PlayerGui")
    local FishingUI = PlayerGui and PlayerGui:FindFirstChild("FishingUI")
    local FishingVignette, v15

    if FishingUI ~= nil then
        if FishingUI:IsA("ScreenGui") then
            FishingVignette = PlayerGui and PlayerGui:FindFirstChild("FishingVignette")
            v15 = false
        else
            v15 = true
        end
    else
        v15 = true
    end

    if v15 then
        return nil
    end

    local v16, v17, v18, v19, v20, Glow, Scale, v21, WindowTop, v22

    if FishingVignette ~= nil then
        if FishingVignette:IsA("ScreenGui") then
            v16 = child(FishingUI, { "Charge" })
            v17 = child(v16, { "Track" })
            v18 = child(v17, { "Fill" })
            v19 = child(v17, { "Surface" })
            v20 = child(v17, { "Band" })
            Glow = v17:FindFirstChild("Glow")
            Scale = v17.Size.Y.Scale
            v21 = v17.Position.Y.Scale - v17.AnchorPoint.Y * Scale
            WindowTop = v17:GetAttribute("WindowTop")

            if type(WindowTop) ~= "number" then
                WindowTop = 0
            end

            v22 = false
        else
            v22 = true
        end
    else
        v22 = true
    end

    if v22 then
        return nil
    end

    local WindowBottom = v17:GetAttribute("WindowBottom")

    if type(WindowBottom) ~= "number" then
        WindowBottom = 1
    end

    local v23 = child(FishingUI, { "Reel", "Counter" })
    local t8 = {
        Gui = FishingUI,
        Tooltip = child(FishingUI, { "Tooltip" }),
        TooltipLabel = child(FishingUI, { "Tooltip", "Label" }),
        Charge = v16,
        Fill = v18,
        FillGradient = child(v18, { "UIGradient" }),
        Surface = v19,
        SurfaceGradient = child(v19, { "UIGradient" }),
        Band = v20,
        BandGradient = child(v20, { "UIGradient" }),
        BandGlow = if not (Glow and Glow:IsA("GuiObject")) then nil else Glow,
        GlowGradient = if Glow then Glow:FindFirstChildOfClass("UIGradient") else nil,
        WindowLow = 1 - WindowBottom,
        WindowHigh = 1 - WindowTop,
        TagTop = v21 + Scale * WindowTop,
        TagSpan = Scale * (WindowBottom - WindowTop),
        Tag = child(FishingUI, { "Charge", "Tag" }),
        Luck = child(FishingUI, { "Charge", "Tag", "Pill", "Luck" }),
        Perfect = child(FishingUI, { "Perfect" }),
        Reel = child(FishingUI, { "Reel" }),
        ReelTitle = child(FishingUI, { "Reel", "Title" }),
        Counter = v23,
        Digits = digits(v23),
        Glyphs = glyphs(v23),
        FillLeft = child(FishingUI, { "Reel", "Bar", "FillLeft" }),
        FillRight = child(FishingUI, { "Reel", "Bar", "FillRight" }),
        Center = child(FishingUI, { "Reel", "Bar", "Center" }),
        Stop = child(FishingUI, { "Reel", "Stop" }),
        Reveal = child(FishingUI, { "Reveal" }),
        VignetteGui = FishingVignette,
        Vignette = child(FishingVignette, { "Vignette" }),
        Card = child(FishingUI, { "Reveal", "Card" }),
        Shine = child(FishingUI, { "Reveal", "Card", "Shine" }),
        Image = child(FishingUI, { "Reveal", "Card", "Image" }),
        RewardName = child(FishingUI, { "Reveal", "Card", "RewardName" })
    }

    t1 = t8
    v7 = nil
    v8 = nil
    n3 = -1

    return t8
end

local function slab(p17, p18, p19) -- line: 238
    local v26 = math.clamp(p17, p19 + 0.001, 1 - p19 * 2 - 0.002)
    local v28 = math.clamp(p18, v26 + p19 + 0.001, 0.999)

    return NumberSequence.new({
        NumberSequenceKeypoint.new(0, 1),
        NumberSequenceKeypoint.new(v26 - p19, 1),
        NumberSequenceKeypoint.new(v26, 0),
        NumberSequenceKeypoint.new(v28 - p19, 0),
        NumberSequenceKeypoint.new(v28, 1),
        NumberSequenceKeypoint.new(1, 1)
    })
end

local function crest(p20, p21) -- line: 251
    local v30 = math.clamp(p20, p21 + 0.003 + 0.002, 0.999)

    return NumberSequence.new({
        NumberSequenceKeypoint.new(0, 1),
        NumberSequenceKeypoint.new(v30 - p21, 1),
        NumberSequenceKeypoint.new(v30 - 0.003, 0),
        NumberSequenceKeypoint.new(v30, 1),
        NumberSequenceKeypoint.new(1, 1)
    })
end

local function paintBand(p22, p23, p24) -- line: 262
    -- upvalues: v4 (copy), v5 (copy), slab (copy)
    local v32 = math.max(p24 - p23, 0.036000000000000004)
    local v34 = math.clamp(p23, 0.006, 1 - v32 - 0.006)
    local v35 = v34 + v32
    local LineThickness = p22.Band:GetAttribute("LineThickness")

    if type(LineThickness) ~= "number" then
        LineThickness = 0.011
    end

    local v37 = math.min(LineThickness, v32 * 0.2)
    local v38 = v32 * 0.3
    local EdgeTransparency = p22.Band:GetAttribute("EdgeTransparency")

    if type(EdgeTransparency) ~= "number" then
        EdgeTransparency = 0.45
    end

    local CoreTransparency = p22.Band:GetAttribute("CoreTransparency")

    if type(CoreTransparency) ~= "number" then
        CoreTransparency = 0.75
    end

    p22.BandGradient.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 1),
        NumberSequenceKeypoint.new(v34 - 0.003, 1),
        NumberSequenceKeypoint.new(v34, 0),
        NumberSequenceKeypoint.new(v34 + v37, 0),
        NumberSequenceKeypoint.new(v34 + v37 + 0.003, EdgeTransparency),
        NumberSequenceKeypoint.new(v34 + v38, CoreTransparency),
        NumberSequenceKeypoint.new(v35 - v38, CoreTransparency),
        NumberSequenceKeypoint.new(v35 - v37 - 0.003, EdgeTransparency),
        NumberSequenceKeypoint.new(v35 - v37, 0),
        NumberSequenceKeypoint.new(v35, 0),
        NumberSequenceKeypoint.new(v35 + 0.003, 1),
        NumberSequenceKeypoint.new(1, 1)
    })
    p22.BandGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, v5),
        ColorSequenceKeypoint.new(v34 + v37, v5),
        ColorSequenceKeypoint.new(v34 + v37 + 0.003, v4),
        ColorSequenceKeypoint.new(v35 - v37 - 0.003, v4),
        ColorSequenceKeypoint.new(v35 - v37, v5),
        ColorSequenceKeypoint.new(1, v5)
    })

    local BandGlow, GlowGradient = p22.BandGlow, p22.GlowGradient

    if BandGlow and GlowGradient then
        local Spread = BandGlow:GetAttribute("Spread")

        if type(Spread) ~= "number" then
            Spread = 0.035
        end

        GlowGradient.Transparency = slab(v34, v35 + Spread, Spread)
    end
end

local function roll(p25, p26, p27) -- line: 300
    -- upvalues: GuiService (copy), TweenService (copy), v1 (copy), v2 (copy), v3 (copy)
    for _, v39 in p25.Tweens do
        v39:Cancel()
    end

    table.clear(p25.Tweens)
    p25.Current.Text = p25.Value
    p25.Current.Position = v1
    p25.Next.Position = v3
    p25.Value = p26

    if p27 <= 0 or GuiService.ReducedMotionEnabled then
        p25.Current.Text = p26
    else
        p25.Next.Text = p26

        local v40 = TweenInfo.new(p27, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        local tween = TweenService:Create(p25.Current, v40, {
            Position = v2
        })
        local tween2 = TweenService:Create(p25.Next, v40, {
            Position = v1
        })

        tween2.Completed:Once(function(p28) -- line: 317
            -- upvalues: p25 (copy), p26 (copy), v1 (copy), v3 (copy)
            if p28 ~= Enum.PlaybackState.Completed or p25.Value ~= p26 then
                return
            end

            p25.Current.Text = p26
            p25.Current.Position = v1
            p25.Next.Position = v3
            table.clear(p25.Tweens)
        end)
        table.insert(p25.Tweens, tween)
        table.insert(p25.Tweens, tween2)
        tween:Play()
        tween2:Play()
    end
end

local function flashCounter(p29) -- line: 332
    -- upvalues: TweenService (copy), punch (copy)
    local Counter = p29.Counter
    local PunchScale = Counter:GetAttribute("PunchScale")

    if type(PunchScale) ~= "number" then
        PunchScale = 1.18
    end

    local PunchSeconds = Counter:GetAttribute("PunchSeconds")

    if type(PunchSeconds) ~= "number" then
        PunchSeconds = 0.18
    end

    punch(Counter, PunchScale, PunchSeconds)

    local FlashColor = Counter:GetAttribute("FlashColor")

    if typeof(FlashColor) ~= "Color3" then
        return
    end

    local FlashSeconds = Counter:GetAttribute("FlashSeconds")

    if type(FlashSeconds) ~= "number" then
        FlashSeconds = 0.3
    end

    for _, v41 in p29.Glyphs do
        local RestColor = v41:GetAttribute("RestColor")

        if typeof(RestColor) ~= "Color3" then
            RestColor = v41.TextColor3
            v41:SetAttribute("RestColor", RestColor)
        end

        v41.TextColor3 = FlashColor

        local t9 = {
            TextColor3 = RestColor
        }

        TweenService:Create(v41, TweenInfo.new(FlashSeconds, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), t9):Play()
    end
end

local function showClicks(p30, p31) -- line: 351
    -- upvalues: v7 (ref), roll (copy), flashCounter (copy)
    local v44 = math.clamp(math.floor(p31), 0, 999)

    if v7 == v44 then
        return
    end

    local v45 = v7 ~= nil and v7 < v44

    v7 = v44

    local v46 = string.format(`%0{#p30.Digits}d`, v44)
    local RollSeconds

    if v45 then
        RollSeconds = p30.Counter:GetAttribute("RollSeconds")

        if type(RollSeconds) ~= "number" then
            RollSeconds = 0.13
        end
    else
        RollSeconds = 0
    end

    for v47, v48 in p30.Digits do
        local v49 = string.sub(v46, v47, v47)

        if v49 ~= v48.Value or not v45 then
            roll(v48, v49, RollSeconds)
        end
    end

    if v45 then
        flashCounter(p30)
    end
end

local function layoutTitle(p32) -- line: 371
    -- upvalues: n3 (ref)
    local X = p32.Reel.AbsoluteSize.X
    local X2 = p32.ReelTitle.TextBounds.X

    if X <= 0 or X2 <= 0 or X2 == n3 then
        return
    end

    n3 = X2

    local Counter = p32.Counter
    local v50 = X2 / X
    local GapX = Counter:GetAttribute("GapX")

    if type(GapX) ~= "number" then
        GapX = 0.0115
    end

    local Scale = Counter.Size.X.Scale
    local GroupCenterX = Counter:GetAttribute("GroupCenterX")

    if type(GroupCenterX) ~= "number" then
        GroupCenterX = 0.45
    end

    local v51 = GroupCenterX - (v50 + GapX + Scale) / 2

    p32.ReelTitle.Position = UDim2.fromScale(v51 + v50, p32.ReelTitle.Position.Y.Scale)
    Counter.Position = UDim2.fromScale(v51 + v50 + GapX + Scale * Counter.AnchorPoint.X, Counter.Position.Y.Scale)
end

local function commas(p33) -- line: 388
    local v54 = tostring((math.floor(p33 + 0.5)))

    repeat
        local v55

        v54, v55 = string.gsub(v54, "^(-?%d+)(%d%d%d)", "%1,%2")
    until v55 == 0

    return v54
end

function t2.Ready() -- line: 401
    -- upvalues: bind (copy)
    return bind() ~= nil
end

function t2.StopButton() -- line: 405
    -- upvalues: bind (copy)
    local v56 = bind()

    return v56 and v56.Stop
end

function t2.Acquire() -- line: 410
    -- upvalues: n1 (ref), bind (copy)
    local v57 = bind()

    if v57 == nil then
        return function() -- line: 413
        end
    end

    n1 += 1
    v57.Gui.Enabled = true

    local v58 = false

    return function() -- line: 418
        -- upvalues: v57 (copy), v58 (ref), n1 (ref)
        if v58 then
            return
        end

        v58 = true
        n1 -= 1

        if not (n1 <= 0) then
            return
        end

        n1 = 0
        v57.Tooltip.Visible = false
        v57.Charge.Visible = false
        v57.Perfect.Visible = false
        v57.Reel.Visible = false
        v57.Reveal.Visible = false
        v57.VignetteGui.Enabled = false
        v57.Gui.Enabled = false
    end
end

function t2.Tooltip(p34, p35, p36) -- line: 437
    -- upvalues: bind (copy)
    local v59 = bind()

    if v59 ~= nil then
        v59.Tooltip.Visible = p34

        if p34 then
            if p35 and v59.TooltipLabel.Text ~= p35 then
                v59.TooltipLabel.Text = p35
            end

            if p36 then
                local CursorOffsetX = v59.Tooltip:GetAttribute("CursorOffsetX")
                local CursorOffsetY = v59.Tooltip:GetAttribute("CursorOffsetY")
                local Tooltip = v59.Tooltip
                local fromScale = UDim2.fromScale
                local X = p36.X

                if type(CursorOffsetX) ~= "number" then
                    CursorOffsetX = 0.012
                end

                local v60 = X + CursorOffsetX
                local Y = p36.Y

                if type(CursorOffsetY) ~= "number" then
                    CursorOffsetY = 0
                end

                Tooltip.Position = fromScale(v60, Y + CursorOffsetY)
            end
        end
    end
end

function t2.TouchAnchor() -- line: 459
    -- upvalues: bind (copy)
    local v61 = bind()
    local v62 = v61

    if v61 then
        v62 = v61.Tooltip:GetAttribute("TouchX")
        v61 = v61.Tooltip:GetAttribute("TouchY")
    end

    local new = Vector2.new

    if type(v62) ~= "number" then
        v62 = 0.62
    end

    if type(v61) ~= "number" then
        v61 = 0.6
    end

    return new(v62, v61)
end

function t2.ShowCharge(p37, p38, p39) -- line: 469
    -- upvalues: v8 (ref), bind (copy), paintBand (copy)
    local v63 = bind()

    if v63 == nil then
        return
    end

    v63.Charge.Visible = p37
    v8 = nil

    if p37 and p38 and p39 then
        local v65 = math.clamp(math.min(p38, p39), 0, 1)
        local v67 = math.clamp(math.max(p38, p39), 0, 1)
        local v68 = v63.WindowHigh - v63.WindowLow

        paintBand(v63, v63.WindowLow + v68 * v65, v63.WindowLow + v68 * v67)
    end
end

function t2.SetCharge(p40, p41, p42, p43) -- line: 484
    -- upvalues: v6 (copy), ffe45a (copy), v8 (ref), bind (copy), slab (copy), crest (copy)
    local v69 = bind()

    if v69 == nil then
        return
    end

    local v70 = math.clamp(p40, 0, 1)

    if v8 ~= v70 then
        v8 = v70

        local v71 = v69.WindowLow + (v69.WindowHigh - v69.WindowLow) * v70
        local Depth = v69.Surface:GetAttribute("Depth")

        if type(Depth) ~= "number" then
            Depth = 0.03
        end

        local v72 = math.max(Depth, 0.006)

        v69.Fill.Visible = v70 > 0.005

        local Surface = v69.Surface

        if v70 > 0.005 then
            Surface.Visible = v70 < 0.995
        else
            Surface.Visible = false
        end

        v69.FillGradient.Transparency = slab(0, v71, 0.003)
        v69.SurfaceGradient.Transparency = crest(v71, v72)

        local v73 = v69.TagTop + v69.TagSpan * (1 - v70)

        v69.Tag.Position = UDim2.fromScale(v69.Tag.Position.X.Scale, v73)
    end

    v69.Luck.Text = ("%* Luck"):format(p41)

    local Luck = v69.Luck

    if p42 then
        Luck.TextColor3 = ffe45a
    else
        Luck.TextColor3 = v6
    end

    local BandGlow = v69.BandGlow

    if BandGlow then
        local PerfectTransparency

        if p42 then
            PerfectTransparency = BandGlow:GetAttribute("PerfectTransparency")

            if type(PerfectTransparency) ~= "number" then
                PerfectTransparency = 0.05
            end
        else
            PerfectTransparency = BandGlow:GetAttribute("IdleTransparency")

            if type(PerfectTransparency) ~= "number" then
                PerfectTransparency = 0.55
            end
        end

        if BandGlow:IsA("ImageLabel") then
            BandGlow.ImageTransparency = PerfectTransparency
        else
            BandGlow.BackgroundTransparency = PerfectTransparency
        end
    end

    if not p43 then
        return
    end

    local ScreenOffsetX = v69.Charge:GetAttribute("ScreenOffsetX")
    local ScreenOffsetY = v69.Charge:GetAttribute("ScreenOffsetY")
    local Charge = v69.Charge
    local fromScale = UDim2.fromScale
    local X = p43.X

    if type(ScreenOffsetX) ~= "number" then
        ScreenOffsetX = 0.035
    end

    local v75 = math.clamp(X + ScreenOffsetX, 0, 0.85)
    local Y = p43.Y

    if type(ScreenOffsetY) ~= "number" then
        ScreenOffsetY = -0.05
    end

    Charge.Position = fromScale(v75, (math.clamp(Y + ScreenOffsetY, 0.2, 0.8)))
end

function t2.Perfect(p44) -- line: 524
    -- upvalues: TweenService (copy), n2 (ref), punch (copy), bind (copy)
    local v77 = bind()

    if v77 == nil then
        return
    end

    n2 += 1

    local v78 = n2
    local Perfect = v77.Perfect

    if p44 then
        Perfect.Position = UDim2.fromScale(math.clamp(p44.X, 0.15, 0.85), (math.clamp(p44.Y, 0.1, 0.8)))
    end

    Perfect.TextTransparency = 0
    Perfect.Visible = true
    punch(Perfect, 1.8, 0.35)
    task.delay(0.9, function() -- line: 539
        -- upvalues: v78 (copy), Perfect (copy), TweenService (copy), n2 (ref)
        if n2 ~= v78 then
            return
        end

        local t10 = {
            TextTransparency = 1
        }

        TweenService:Create(Perfect, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), t10):Play()
        task.delay(0.26, function() -- line: 544
            -- upvalues: v78 (copy), Perfect (copy), n2 (ref)
            if n2 == v78 then
                Perfect.Visible = false
            end
        end)
    end)
end

function t2.ShowReel(p45, p46) -- line: 552
    -- upvalues: n3 (ref), punch (copy), bind (copy)
    local v81 = bind()

    if v81 == nil then
        return
    end

    v81.Reel.Visible = p45
    n3 = -1

    if p45 then
        if p46 then
            v81.ReelTitle.Text = p46
        end

        punch(v81.Reel, 0.6, 0.3)
    end
end

function t2.SetReel(p47, p48, p49) -- line: 567
    -- upvalues: bind (copy), showClicks (copy), layoutTitle (copy)
    local v82 = bind()

    if v82 == nil then
        return
    end

    local v83 = math.clamp(p47, 0, 1) * 0.5

    v82.FillLeft.Size = UDim2.fromScale(v83, v82.FillLeft.Size.Y.Scale)
    v82.FillRight.Size = UDim2.fromScale(v83, v82.FillRight.Size.Y.Scale)

    if v82.ReelTitle.Text ~= p49 then
        v82.ReelTitle.Text = p49
    end

    showClicks(v82, p48)
    layoutTitle(v82)
end

function t2.PunchReel() -- line: 582
    -- upvalues: punch (copy), bind (copy)
    local v84 = bind()

    if v84 then
        punch(v84.Center, 1.25, 0.15)
    end
end

function t2.Reveal(p50, p51) -- line: 589
    -- upvalues: GuiService (copy), RunService (copy), TweenService (copy), v4 (copy), punch (copy), bind (copy), commas (copy)
    local v85 = bind()

    if v85 == nil then
        return
    end

    local v86 = p50.Amount > 1
    local v87 = if v86 then string.find(p50.DisplayName, tostring(p50.Amount), 1, true) else nil
    local v88 = if not v86 or v87 then "" else ("%*x "):format((commas(p50.Amount)))

    v85.RewardName.Text = ("%*%*"):format(v88, p50.DisplayName)

    local Image = v85.Image

    if not p50.Icon or p50.Icon == "" then
        Image.Image = "rbxassetid://122321649531761"
    else
        Image.Image = p50.Icon
    end

    local v89 = p50.Kind == "ManorKey"
    local ImageColor3 = v85.Shine.ImageColor3
    local TextColor3 = v85.RewardName.TextColor3
    local v90

    if v89 then
        v85.Shine.ImageColor3 = v4
        v90 = 120
        v85.RewardName.TextColor3 = v4
    else
        v90 = 40
    end

    v85.Vignette.GroupTransparency = 1
    v85.VignetteGui.Enabled = true
    v85.Reveal.Visible = true

    local Vignette = v85.Vignette
    local t11 = {
        GroupTransparency = 0
    }

    TweenService:Create(Vignette, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), t11):Play()
    punch(v85.Card, 0.4, 0.4)
    punch(v85.Image, 1.5, 0.5)

    local connection

    if not GuiService.ReducedMotionEnabled then
        local RenderStepped = RunService.RenderStepped
        local v92 = v90

        connection = RenderStepped:Connect(function(p52) -- line: 616
            -- upvalues: v85 (copy), v92 (copy)
            v85.Shine.Rotation = (v85.Shine.Rotation + p52 * v92) % 360
        end)
    end

    task.wait(if v89 then p51 + 1.5 else p51)

    local Vignette2 = v85.Vignette
    local t12 = {
        GroupTransparency = 1
    }

    TweenService:Create(Vignette2, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), t12):Play()

    local UIScale = v85.Card:FindFirstChildOfClass("UIScale")
    local t13, new, v94

    if UIScale and not GuiService.ReducedMotionEnabled then
        t13 = {
            Scale = 0
        }

        local Back = Enum.EasingStyle.Back

        new = TweenInfo.new
        v94 = Back or Enum.EasingStyle.Quad
        TweenService:Create(UIScale, new(0.25, v94, Enum.EasingDirection.Out), t13):Play()
    end

    task.wait(0.3)

    if connection then
        connection:Disconnect()
    end

    if UIScale then
        UIScale.Scale = 1
    end

    v85.Shine.ImageColor3 = ImageColor3
    v85.RewardName.TextColor3 = TextColor3
    v85.Reveal.Visible = false
    v85.VignetteGui.Enabled = false
end

return table.freeze(t2)
