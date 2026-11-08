-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local CollectionService = game:GetService("CollectionService")
local GuiService = game:GetService("GuiService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local StarterGui = game:GetService("StarterGui")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local LightingController = require(ReplicatedStorage.Controllers.Game.LightingController)
local Notifications = require(ReplicatedStorage.Client.Notifications)
local PumpkinBossFlags = require(ReplicatedStorage.Shared.Flags.PumpkinBossFlags)
local PumpkinBossState = require(ReplicatedStorage.Shared.Util.PumpkinBossState)
local ShrinePadZone = require(ReplicatedStorage.Shared.Util.ShrinePadZone)
local TutorialBeam = require(ReplicatedStorage.Client.WorldFX.TutorialBeam)
local Kit = require(script.Parent.Kit)
local Phases, Attributes, TrapAttributes, CannonAttributes = PumpkinBossState.Phases, PumpkinBossState.Attributes, PumpkinBossState.TrapAttributes, PumpkinBossState.CannonAttributes
local MemberAttribute = PumpkinBossState.MemberAttribute
local v1 = Color3.fromRGB(70, 20, 0)
local t1 = {
    "Assets",
    "UI",
    "HalloweenDimension"
}
local t2 = {
    [Phases.KingIntro] = true,
    [Phases.King] = true,
    [Phases.Shield] = true,
    [Phases.Stunned] = true,
    [Phases.Defeated] = true
}
local v2 = Kit.Orange:ToHex()
local t3 = {
    "Assets",
    "UI",
    "Notifs",
    "CorruptedPlate"
}
local t4 = {
    BrokenRail = true,
    BrokenBracket = true
}
local v3 = Color3.fromRGB(26, 12, 3)
local v4 = Color3.fromRGB(150, 255, 110)
local t5 = {
    { "BossHPBar", "BossName" },
    { "BossHPBar", "BarHolder", "HealthAmount" },
    { "BossHPBar", "BarHolder", "BarBG", "Bar" },
    { "BossHPBar", "BarHolder", "BarBG", "PhantomBar" },
    { "BossHPBar", "BarHolder", "ShieldBarHolder" },
    { "BossHPBar", "Frame", "Title" },
    { "BossHPBar", "Frame", "TimerLabel" },
    { "BossHPBar", "Countdown", "Plate", "Body" },
    { "Target", "Title" },
    { "Target", "Sub" },
    { "Target", "Countdown" },
    { "Flash" }
}
local LocalPlayer = Players.LocalPlayer
local v5 = false
local v6 = false

local function now() -- line: 122
    -- upvalues: Workspace (copy)
    return Workspace:GetServerTimeNow()
end

local function walk(p1, p2) -- line: 126
    for _, v8 in p2 do
        p1 = p1 and p1:FindFirstChild(v8)
    end

    return p1
end

local function label(p3, p4, p5) -- line: 134
    local TextLabel = Instance.new("TextLabel")

    TextLabel.Name = p3
    TextLabel.BackgroundTransparency = 1
    TextLabel.Font = Enum.Font.FredokaOne
    TextLabel.TextColor3 = Color3.new(1, 1, 1)
    TextLabel.TextScaled = true
    TextLabel.TextStrokeTransparency = 0.3
    TextLabel.Text = ""

    for v9, v10 in p5 do
        TextLabel[v9] = v10
    end

    TextLabel.Parent = p4

    return TextLabel
end

local function frame(p6, p7, p8) -- line: 150
    local Frame = Instance.new("Frame")

    Frame.Name = p6
    Frame.BorderSizePixel = 0

    for v11, v12 in p8 do
        Frame[v11] = v12
    end

    Frame.Parent = p7

    return Frame
end

local function buildFallback() -- line: 162
    -- upvalues: Kit (copy), label (copy)
    local ScreenGui = Instance.new("ScreenGui")

    ScreenGui.Name = "PumpkinBossUI"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.IgnoreGuiInset = true
    ScreenGui.Enabled = false

    local t6 = {
        BackgroundTransparency = 1,
        AnchorPoint = Vector2.new(0.5, 0),
        Position = UDim2.fromScale(0.5, 0.06),
        Size = UDim2.fromScale(0.42, 0.11)
    }
    local Frame = Instance.new("Frame")

    Frame.Name = "BossHPBar"
    Frame.BorderSizePixel = 0

    for v13, v14 in t6 do
        Frame[v13] = v14
    end

    Frame.Parent = ScreenGui
    Instance.new("UIScale", Frame).Name = "JuiceScale"
    label("BossName", Frame, {
        Size = UDim2.fromScale(1, 0.35),
        TextColor3 = Kit.Orange
    })

    local t7 = {
        BackgroundTransparency = 1,
        Position = UDim2.fromScale(0, 0.38),
        Size = UDim2.fromScale(1, 0.32)
    }
    local Frame2 = Instance.new("Frame")

    Frame2.Name = "BarHolder"
    Frame2.BorderSizePixel = 0

    for v15, v16 in t7 do
        Frame2[v15] = v16
    end

    Frame2.Parent = Frame

    local t8 = {
        Size = UDim2.fromScale(1, 1),
        BackgroundColor3 = Color3.fromRGB(30, 15, 5)
    }
    local Frame3 = Instance.new("Frame")

    Frame3.Name = "BarBG"
    Frame3.BorderSizePixel = 0

    for v17, v18 in t8 do
        Frame3[v17] = v18
    end

    Frame3.Parent = Frame2

    local t9 = {
        Size = UDim2.fromScale(1, 1),
        BackgroundColor3 = Color3.new(1, 1, 1)
    }
    local Frame4 = Instance.new("Frame")

    Frame4.Name = "PhantomBar"
    Frame4.BorderSizePixel = 0

    for v19, v20 in t9 do
        Frame4[v19] = v20
    end

    Frame4.Parent = Frame3

    local t10 = {
        ZIndex = 2,
        Size = UDim2.fromScale(1, 1),
        BackgroundColor3 = Kit.Orange
    }
    local Frame5 = Instance.new("Frame")

    Frame5.Name = "Bar"
    Frame5.BorderSizePixel = 0

    for v21, v22 in t10 do
        Frame5[v21] = v22
    end

    Frame5.Parent = Frame3
    label("HealthAmount", Frame2, {
        ZIndex = 3,
        Size = UDim2.fromScale(1, 1)
    })

    local t11 = {
        BackgroundTransparency = 1,
        Position = UDim2.fromScale(0, 1.1),
        Size = UDim2.fromScale(1, 0.35)
    }
    local Frame6 = Instance.new("Frame")

    Frame6.Name = "ShieldBarHolder"
    Frame6.BorderSizePixel = 0

    for v23, v24 in t11 do
        Frame6[v23] = v24
    end

    Frame6.Parent = Frame2

    local UIListLayout = Instance.new("UIListLayout")

    UIListLayout.FillDirection = Enum.FillDirection.Horizontal
    UIListLayout.Padding = UDim.new(0.01, 0)
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    UIListLayout.Parent = Frame6

    for i = 1, 4 do
        local v25 = ("Phase%*"):format(i)
        local t12 = {
            LayoutOrder = i,
            Size = UDim2.fromScale(0.2425, 1),
            BackgroundColor3 = Color3.fromRGB(20, 20, 40)
        }
        local Frame = Instance.new("Frame")

        Frame.Name = v25
        Frame.BorderSizePixel = 0

        for v26, v27 in t12 do
            Frame[v26] = v27
        end

        Frame.Parent = Frame6

        local t13 = {
            Size = UDim2.fromScale(1, 1),
            BackgroundColor3 = Kit.Purple
        }
        local Frame2 = Instance.new("Frame")

        Frame2.Name = "Fill"
        Frame2.BorderSizePixel = 0

        for v28, v29 in t13 do
            Frame2[v28] = v29
        end

        Frame2.Parent = Frame
    end

    local t14 = {
        BackgroundTransparency = 1,
        Position = UDim2.fromScale(0.78, 0),
        Size = UDim2.fromScale(0.22, 0.35)
    }
    local Frame7 = Instance.new("Frame")

    Frame7.Name = "Frame"
    Frame7.BorderSizePixel = 0

    for v30, v31 in t14 do
        Frame7[v30] = v31
    end

    Frame7.Parent = Frame
    label("Title", Frame7, {
        Size = UDim2.fromScale(0.5, 1)
    })
    label("TimerLabel", Frame7, {
        Position = UDim2.fromScale(0.5, 0),
        Size = UDim2.fromScale(0.5, 1)
    })

    local CanvasGroup = Instance.new("CanvasGroup")

    CanvasGroup.Name = "Countdown"
    CanvasGroup.BackgroundTransparency = 1
    CanvasGroup.Position = UDim2.fromScale(0, 1.1)
    CanvasGroup.Size = UDim2.fromScale(1, 0.4)
    CanvasGroup.Parent = Frame

    local t15 = {
        BackgroundTransparency = 1,
        Size = UDim2.fromScale(1, 1)
    }
    local Frame8 = Instance.new("Frame")

    Frame8.Name = "Plate"
    Frame8.BorderSizePixel = 0

    for v32, v33 in t15 do
        Frame8[v32] = v33
    end

    Frame8.Parent = CanvasGroup
    label("Body", Frame8, {
        RichText = true,
        Size = UDim2.fromScale(1, 1)
    })

    local t16 = {
        BackgroundTransparency = 1,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromScale(0.5, 0.72),
        Size = UDim2.fromScale(0.4, 0.14)
    }
    local Frame9 = Instance.new("Frame")

    Frame9.Name = "Target"
    Frame9.BorderSizePixel = 0

    for v34, v35 in t16 do
        Frame9[v34] = v35
    end

    Frame9.Parent = ScreenGui
    label("Title", Frame9, {
        Size = UDim2.fromScale(1, 0.45),
        TextColor3 = Kit.Orange
    })
    label("Sub", Frame9, {
        Position = UDim2.fromScale(0, 0.45),
        Size = UDim2.fromScale(1, 0.25)
    })
    label("Countdown", Frame9, {
        Position = UDim2.fromScale(0, 0.72),
        Size = UDim2.fromScale(1, 0.28)
    })

    local t17 = {
        BackgroundTransparency = 1,
        ZIndex = 10,
        Size = UDim2.fromScale(1, 1),
        BackgroundColor3 = Color3.new(1, 1, 1)
    }
    local Frame10 = Instance.new("Frame")

    Frame10.Name = "Flash"
    Frame10.BorderSizePixel = 0

    for v36, v37 in t17 do
        Frame10[v36] = v37
    end

    Frame10.Parent = ScreenGui

    return ScreenGui
end

local function acquireGui() -- line: 243
    -- upvalues: ReplicatedStorage (copy), StarterGui (copy), t1 (copy), t5 (copy), LocalPlayer (copy), v5 (ref), buildFallback (copy)
    local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
    local PumpkinBossUI = PlayerGui:FindFirstChild("PumpkinBossUI")

    if PumpkinBossUI and PumpkinBossUI:IsA("ScreenGui") then
        return PumpkinBossUI
    end

    local ScrambleBossUI = StarterGui:FindFirstChild("ScrambleBossUI")
    local clone

    if not (ScrambleBossUI and ScrambleBossUI:IsA("ScreenGui")) then
        if not v5 then
            v5 = true
            warn("[PumpkinBoss] StarterGui.ScrambleBossUI is missing; using fallback HUD")
        end
    else
        clone = ScrambleBossUI:Clone()
        clone.Name = "PumpkinBossUI"
        clone.ResetOnSpawn = false
        clone.Enabled = false

        local v38 = ReplicatedStorage

        for _, v39 in t1 do
            v38 = v38 and v38:FindFirstChild(v39)
        end

        local PumpkinCountdown = v38 and v38:FindFirstChild("PumpkinCountdown")
        local v40 = clone

        for _, v41 in { "BossHPBar", "Countdown" } do
            v40 = v40 and v40:FindFirstChild(v41)
        end

        if PumpkinCountdown and PumpkinCountdown:IsA("GuiObject") then
            local v42 = PumpkinCountdown

            for _, v43 in { "Plate", "Body" } do
                v42 = v42 and v42:FindFirstChild(v43)
            end

            if v42 and v40 then
                local clone = PumpkinCountdown:Clone()

                clone.Name = "Countdown"
                clone.Parent = v40.Parent
                v40:Destroy()
            end
        end

        for _, v44 in t5 do
            local v45 = clone

            for _, v46 in v44 do
                v45 = v45 and v45:FindFirstChild(v46)
            end

            if v45 == nil then
                warn((("[PumpkinBoss] ScrambleBossUI is missing %*; using fallback HUD"):format((table.concat(v44, ".")))))
                clone:Destroy()
                clone = nil
                break
            end
        end
    end

    local v47 = clone or buildFallback()

    v47.Parent = PlayerGui

    return v47
end

local function textLabel(p9) -- line: 285
    return if p9 ~= nil and p9:IsA("TextLabel") then p9 else nil
end

local function frameOf(p10) -- line: 289
    return if p10 ~= nil and p10:IsA("Frame") then p10 else nil
end

local function timerLabels(p11) -- line: 294
    local Title = p11:FindFirstChild("Title")

    if Title == nil or not Title:IsA("TextLabel") then
        Title = nil
    end

    local TimerLabel = p11:FindFirstChild("TimerLabel")

    if TimerLabel == nil or not TimerLabel:IsA("TextLabel") then
        TimerLabel = nil
    end

    if Title ~= nil and TimerLabel ~= nil then
        return Title, TimerLabel
    end

    local t18 = {}

    for _, child in p11:GetChildren() do
        if child:IsA("TextLabel") then
            table.insert(t18, child)
        end
    end

    if #t18 < 2 then
        return nil, nil
    end

    table.sort(t18, function(p12, p13) -- line: 309
        if p12.Position.Y.Scale == p13.Position.Y.Scale then
            return p12.Position.Y.Offset < p13.Position.Y.Offset
        end

        return p12.Position.Y.Scale < p13.Position.Y.Scale
    end)

    return t18[1], t18[#t18]
end

local function segmentsOf(p14) -- line: 318
    local t19 = {}
    local t20 = {}

    for v48, child in p14:GetChildren() do
        if child:IsA("Frame") then
            table.insert(t19, child)
            t20[child] = v48
        end
    end

    table.sort(t19, function(p15, p16) -- line: 327
        -- upvalues: t20 (copy)
        if p15.LayoutOrder == p16.LayoutOrder then
            return t20[p15] < t20[p16]
        end

        return p15.LayoutOrder < p16.LayoutOrder
    end)

    for v49, v50 in t19 do
        v50.LayoutOrder = v49
    end

    return t19
end

local function bindBar(p17, p18) -- line: 340
    -- upvalues: timerLabels (copy), segmentsOf (copy)
    local BossHPBar = p17:FindFirstChild("BossHPBar")
    local BarHolder = BossHPBar and BossHPBar:FindFirstChild("BarHolder")
    local BarBG = BarHolder and BarHolder:FindFirstChild("BarBG")
    local BossName = BossHPBar and BossHPBar:FindFirstChild("BossName")

    if BossName == nil or not BossName:IsA("TextLabel") then
        BossName = nil
    end

    local v51 = BarHolder and (BarHolder:FindFirstChild("HealthAmount") or BarHolder:FindFirstChild("TextLabel"))

    if v51 == nil or not v51:IsA("TextLabel") then
        v51 = nil
    end

    local Bar = BarBG and BarBG:FindFirstChild("Bar")

    if Bar == nil or not Bar:IsA("Frame") then
        Bar = nil
    end

    local PhantomBar = BarBG and BarBG:FindFirstChild("PhantomBar")

    if PhantomBar == nil or not PhantomBar:IsA("Frame") then
        PhantomBar = nil
    end

    local ShieldBarHolder = BarHolder and BarHolder:FindFirstChild("ShieldBarHolder")
    local Frame = BossHPBar and BossHPBar:FindFirstChild("Frame")

    if BossHPBar == nil
        or not BossHPBar:IsA("GuiObject")
        or BossName == nil
        or v51 == nil
        or Bar == nil
        or PhantomBar == nil
        or ShieldBarHolder == nil
        or not ShieldBarHolder:IsA("GuiObject")
        or Frame == nil
        or not Frame:IsA("GuiObject") then
        return nil
    end

    local v52, v53 = timerLabels(Frame)

    if v52 == nil or v53 == nil then
        return nil
    end

    local JuiceScale = BossHPBar:FindFirstChild("JuiceScale")

    if JuiceScale == nil or not JuiceScale:IsA("UIScale") then
        JuiceScale = Instance.new("UIScale")
        JuiceScale.Name = "JuiceScale"
        JuiceScale.Parent = BossHPBar
    end

    return {
        Gui = p17,
        Root = BossHPBar,
        BossName = BossName,
        DesignedName = if p18 then BossName.Text else nil,
        HealthText = v51,
        HealthSuffix = p18 and " HP" or "",
        Fill = Bar,
        Phantom = PhantomBar,
        ShieldHolder = ShieldBarHolder,
        Segments = segmentsOf(ShieldBarHolder),
        Scale = JuiceScale,
        TimerFrame = Frame,
        TimerTitle = v52,
        TimerLabel = v53,
        TimerColor = v53.TextColor3,
        Top = BossHPBar.Position.Y.Scale,
        NameTop = BossName.Position.Y.Scale - BossName.AnchorPoint.Y * BossName.Size.Y.Scale
    }
end

local function acquireBar(p19, p20) -- line: 401
    -- upvalues: CollectionService (copy), ReplicatedStorage (copy), t1 (copy)
    local v54 = p19:FindFirstChild(p20)

    if v54 and v54:IsA("ScreenGui") then
        return v54
    end

    local v55 = ReplicatedStorage

    for _, v56 in t1 do
        v55 = v55 and v55:FindFirstChild(v56)
    end

    local v57 = v55 and v55:FindFirstChild(p20)
    local clone, v58

    if v57 ~= nil then
        if v57:IsA("ScreenGui") then
            clone = v57:Clone()
            clone.ResetOnSpawn = false
            clone.Enabled = false
            clone.IgnoreGuiInset = true
            clone.ScreenInsets = Enum.ScreenInsets.None

            local BossHPBar = clone:FindFirstChild("BossHPBar")

            if BossHPBar then
                CollectionService:AddTag(BossHPBar, "TopNotificationBlocker")
            end

            v58 = false
        else
            v58 = true
        end
    else
        v58 = true
    end

    if v58 then
        return nil
    end

    clone.Parent = p19

    return clone
end

local function acquirePhaseBars() -- line: 428
    -- upvalues: t1 (copy), LocalPlayer (copy), v6 (ref), bindBar (copy), acquireBar (copy)
    local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
    local HalloweenBossHPBarP1 = acquireBar(PlayerGui, "HalloweenBossHPBarP1")
    local HalloweenBossHPBarP2 = acquireBar(PlayerGui, "HalloweenBossHPBarP2")
    local v59 = HalloweenBossHPBarP1 and bindBar(HalloweenBossHPBarP1, true)
    local v60 = HalloweenBossHPBarP2 and bindBar(HalloweenBossHPBarP2, true)

    if v59 ~= nil and v60 ~= nil then
        return v59, v60
    end

    if not v6 then
        v6 = true

        local v61 = v59 == nil and "HalloweenBossHPBarP1" or "HalloweenBossHPBarP2"

        warn((("[PumpkinBoss] ReplicatedStorage.%*.%* is missing or incomplete; using the old boss bar"):format(table.concat(t1, "."), v61)))
    end

    return nil, nil
end

local function formatClock(p21) -- line: 446
    local v63 = math.max(math.ceil(p21), 0)

    return string.format("%02d:%02d", v63 // 60, v63 % 60)
end

local function actionHint() -- line: 451
    -- upvalues: UserInputService (copy)
    local LastInputType = UserInputService:GetLastInputType()

    if LastInputType == Enum.UserInputType.Touch then
        return "Tap to FIRE!"
    end

    if string.find(LastInputType.Name, "Gamepad") then
        return "Press R2 to FIRE!"
    end

    return "Click to FIRE!"
end

local function attachCountdownPlate(p22, p23, p24) -- line: 462
    -- upvalues: ReplicatedStorage (copy), Kit (copy), t3 (copy), t4 (copy), v3 (copy)
    local v64 = ReplicatedStorage

    for _, v65 in t3 do
        v64 = v64 and v64:FindFirstChild(v65)
    end

    if v64 == nil or not v64:IsA("GuiObject") then
        return nil
    end

    local clone = p22:Clone(v64)

    clone.Visible = false
    clone.BackgroundColor3 = v3
    clone.ZIndex = p24.ZIndex - 2

    for _, child in clone:GetChildren() do
        if child:IsA("GuiObject") then
            if t4[child.Name] then
                child.BackgroundColor3 = Kit.Orange
            else
                child:Destroy()
            end
        end
    end

    local Scale = clone.Size.Y.Scale
    local t22 = {}

    for _, child in p24:GetChildren() do
        if child:IsA("TextLabel") then
            table.insert(t22, child)
        end
    end

    local function fit() -- line: 490
        -- upvalues: p23 (copy), clone (copy), Scale (copy), t22 (copy)
        local X = p23.AbsoluteSize.X

        if X <= 0 then
            return
        end

        local n1 = 0

        for _, v66 in t22 do
            if v66.Visible then
                n1 += v66.TextBounds.X
            end
        end

        local v68 = math.clamp(n1 / X + 0.2, 0.3, 1)

        clone.Size = UDim2.fromScale(v68, Scale)
    end

    for _, v69 in t22 do
        p22:Connect(v69:GetPropertyChangedSignal("TextBounds"), fit)
        p22:Connect(v69:GetPropertyChangedSignal("Visible"), fit)
    end

    p22:Connect(p23:GetPropertyChangedSignal("AbsoluteSize"), fit)
    clone.Parent = p23
    fit()

    return clone
end

local t23 = {}

t23.__index = t23

function t23.new(p25, p26) -- line: 518
    -- upvalues: RunService (copy), LightingController (copy), acquireGui (copy), bindBar (copy), acquirePhaseBars (copy), attachCountdownPlate (copy), t23 (copy)
    local v70 = acquireGui()

    local function get(p27) -- line: 520
        -- upvalues: v70 (copy)
        local v71 = v70

        for _, v72 in p27 do
            v71 = v71 and v71:FindFirstChild(v72)
        end

        return v71
    end

    local v73 = bindBar(v70, false)

    assert(v73 ~= nil, "PumpkinBossUI is missing its BossHPBar")

    local v75, v76 = acquirePhaseBars()
    local t24 = {
        Active = nil,
        PlateHeight = -1,
        PlateWidth = -1,
        CountdownBackdrop = nil,
        Beam = nil,
        BeamTarget = nil,
        DisplayedHealth = 1,
        PhantomValue = 1,
        LastHealth = -1,
        Lit = false,
        Trove = p25,
        Arena = p26,
        Gui = v70,
        Legacy = v73,
        BruteBar = v75 or v73,
        KingBar = v76 or v73
    }
    local v77 = v70

    for _, v78 in { "BossHPBar", "Countdown" } do
        v77 = v77 and v77:FindFirstChild(v78)
    end

    t24.Countdown = v77

    local v79 = v70

    for _, v80 in { "BossHPBar", "Countdown", "Plate" } do
        v79 = v79 and v79:FindFirstChild(v80)
    end

    t24.CountdownPlate = v79

    local v81 = v70

    for _, v82 in { "BossHPBar", "Countdown", "Plate", "Body" } do
        v81 = v81 and v81:FindFirstChild(v82)
    end

    t24.CountdownBody = v81

    local v83 = v70

    for _, v84 in { "Target" } do
        v83 = v83 and v83:FindFirstChild(v84)
    end

    t24.Target = v83

    local v85 = v70

    for _, v86 in { "Target", "Title" } do
        v85 = v85 and v85:FindFirstChild(v86)
    end

    t24.TargetTitle = v85

    local v87 = v70

    for _, v88 in { "Target", "Sub" } do
        v87 = v87 and v87:FindFirstChild(v88)
    end

    t24.TargetSub = v87

    local v89 = v70

    for _, v90 in { "Target", "Countdown" } do
        v89 = v89 and v89:FindFirstChild(v90)
    end

    t24.TargetCountdown = v89

    local v91 = v70

    for _, v92 in { "Target" } do
        v91 = v91 and v91:FindFirstChild(v92)
    end

    t24.TargetTop = v91.Position.Y.Scale

    local v93 = v70

    for _, v94 in { "Flash" } do
        v93 = v93 and v93:FindFirstChild(v94)
    end

    t24.Flash = v93
    t24.Juice = p25:Extend()

    local v95 = setmetatable(t24, t23)

    v73.Root.Visible = v75 == nil
    p25:Add(function() -- line: 559
        -- upvalues: v70 (copy), v73 (copy), v95 (copy)
        v95.Countdown.Parent = v73.Root
        v73.Root.Visible = true

        for _, v96 in {
                v95.BruteBar,
                v95.KingBar
            } do
            v95:Veil(v96, false)
            v96.Scale.Scale = 1
            v96.Root.Position = UDim2.fromScale(v96.Root.Position.X.Scale, v96.Top)

            if v96.Gui ~= v70 then
                v96.Gui.Enabled = false
            end
        end

        v95.Target.Position = UDim2.fromScale(v95.Target.Position.X.Scale, v95.TargetTop)
    end)
    v95:UseBar(v95.BruteBar)

    for _, v97 in { "Callout", "BarTop", "BarBottom" } do
        local v98 = v70:FindFirstChild(v97)

        if v98 and v98:IsA("GuiObject") then
            v98.Visible = false
        end
    end

    local v99 = v70

    for _, v100 in { "BossHPBar", "BarHolder", "BoxxIcon" } do
        v99 = v99 and v99:FindFirstChild(v100)
    end

    if v99 and v99:IsA("GuiObject") then
        v99.Visible = false
    end

    v95.CountdownBody.RichText = true
    v95.CountdownBackdrop = attachCountdownPlate(p25, v95.Countdown, v95.CountdownPlate)

    local UIGradient = v95.TargetTitle:FindFirstChildOfClass("UIGradient")

    if UIGradient then
        UIGradient.Enabled = false
    end

    v95.Target.Visible = false
    v95.Flash.BackgroundTransparency = 1
    v95.Countdown.Visible = false

    for _, v101 in {
            v95.BruteBar,
            v95.KingBar
        } do
        v101.ShieldHolder.Visible = false
    end

    p25:Add(function() -- line: 599
        -- upvalues: v70 (copy), v95 (copy), LightingController (copy)
        v70.Enabled = false
        v95:PointBeam(nil)

        if v95.Lit then
            LightingController.ClearLayer("PumpkinBoss", 2)
        end
    end)
    p25:Connect(RunService.RenderStepped, function(p28) -- line: 606
        -- upvalues: v95 (copy)
        v95:Step(p28)
    end)

    return v95
end

function t23.UseBar(p29, p30) -- line: 613
    local Active = p29.Active

    if Active == p30 then
        return
    end

    if Active ~= nil then
        p29:Veil(Active, false)
        Active.Scale.Scale = 1

        if Active.Gui ~= p29.Gui then
            Active.Gui.Enabled = false
        end
    end

    p29.Juice:Clean()
    p29.Active = p30
    p29.Countdown.Parent = p30.Root
end

function t23.Veil(p31, p32, p33) -- line: 632
    local Veiled = p32.Veiled

    if p33 ~= (Veiled ~= nil) then
        if Veiled then
            for v102, v103 in Veiled do
                v102.Visible = v103
            end

            p32.Veiled = nil
        else
            local t25 = {}

            for _, child in p32.Root:GetChildren() do
                if child:IsA("GuiObject") and child ~= p32.TimerFrame and child ~= p31.Countdown then
                    t25[child] = child.Visible
                    child.Visible = false
                end
            end

            p32.Veiled = t25
        end
    end
end

function t23.InArena(_) -- line: 656
    -- upvalues: MemberAttribute (copy), LocalPlayer (copy)
    return LocalPlayer:GetAttribute(MemberAttribute) == true
end

function t23.Say(p35, p36, p37, p38) -- line: 660
    -- upvalues: Notifications (copy), Kit (copy), v1 (copy)
    local v104, v105

    if string.match(p36, "%S") ~= nil then
        if p35:InArena() then
            v104 = p37 ~= nil and p37 ~= ""
            v105 = false
        else
            v105 = true
        end
    else
        v105 = true
    end

    if v105 then
        return
    end

    Notifications.Toast.Show({
        Lane = "Banner",
        SingleLine = true,
        Unique = true,
        Text = p36,
        Seconds = p38 or 2.5,
        PreText = if v104 then {
            Text = ("%*:"):format(p37),
            Color = Kit.Orange,
            StrokeColor = v1
        } else nil
    })
end

function t23.FlashScreen(p39, p40, p41, p42) -- line: 676
    -- upvalues: TweenService (copy)
    p39.Flash.BackgroundColor3 = p40
    p39.Flash.BackgroundTransparency = p41
    TweenService:Create(p39.Flash, TweenInfo.new(p42), {
        BackgroundTransparency = 1
    }):Play()
end

function t23.Punch(p43) -- line: 682
    -- upvalues: GuiService (copy), TweenService (copy)
    local Scale = p43.Active.Scale

    if GuiService.ReducedMotionEnabled then
        return
    end

    p43.Juice:Clean()
    Scale.Scale = 1.05

    local tween = TweenService:Create(Scale, TweenInfo.new(0.18, Enum.EasingStyle.Back), {
        Scale = 1
    })

    p43.Juice:Add(tween)
    tween:Play()
end

function t23.SetSegments(p44, p45) -- line: 695
    local Active = p44.Active

    Active.ShieldHolder.Visible = p45 ~= nil

    if p45 ~= nil then
        for v106, v107 in Active.Segments do
            local Fill = v107:FindFirstChild("Fill")

            if Fill then
                local v109 = math.clamp(p45 * #Active.Segments - (v106 - 1), 0, 1)

                Fill.Visible = v109 > 0
                Fill.Size = UDim2.fromScale(v109, 1)
            end
        end
    end
end

local function uiScale(p46) -- line: 713
    local n2 = 1
    local v110 = p46

    while v110 do
        local UIScale = v110:FindFirstChildOfClass("UIScale")

        if UIScale then
            n2 *= UIScale.Scale
        end

        v110 = v110.Parent
    end

    return (math.max(n2, 0.01))
end

local function fitText(p47, p48, p49) -- line: 726
    p47.TextSize = p48

    local X = p47.TextBounds.X

    if not (X <= p49) and not (X <= 0) then
        local v113 = math.max(math.floor(p48 * p49 / X), 1)

        p47.TextSize = v113

        while v113 > 1 and p49 < p47.TextBounds.X do
            v113 -= 1
            p47.TextSize = v113
        end
    end
end

function t23.SetCountdown(p50, p51, p52) -- line: 742
    -- upvalues: uiScale (copy), fitText (copy)
    p50.Countdown.Visible = p51 ~= nil

    if p51 == nil then
        return
    end

    local CountdownBackdrop = p50.CountdownBackdrop
    local v114 = p52 == true

    if CountdownBackdrop and CountdownBackdrop.Visible ~= v114 then
        CountdownBackdrop.Visible = v114
    end

    local CountdownBody = p50.CountdownBody
    local v115 = CountdownBody.Text ~= p51

    if v115 then
        CountdownBody.Text = p51
    end

    local Y = p50.CountdownPlate.AbsoluteSize.Y
    local X = p50.Countdown.AbsoluteSize.X

    if Y > 0 and X > 0 and (v115 or Y ~= p50.PlateHeight or X ~= p50.PlateWidth) then
        p50.PlateHeight = Y
        p50.PlateWidth = X
        fitText(CountdownBody, math.clamp(math.floor(Y / uiScale(CountdownBody) * 1), 1, 100), X * 0.8)
    end
end

function t23.ClearTopbar(p53, p54) -- line: 773
    -- upvalues: GuiService (copy)
    local Root = p54.Root
    local AbsoluteSize = p54.Gui.AbsoluteSize
    local v119 = math.max(p54.Scale.Scale, 0.01)
    local v120 = Root.AbsoluteSize.X / v119
    local v121 = Root.AbsoluteSize.Y / v119

    if AbsoluteSize.X <= 0 or AbsoluteSize.Y <= 0 or v120 <= 0 then
        return
    end

    local TopbarInset = GuiService.TopbarInset
    local v122 = AbsoluteSize.X * Root.Position.X.Scale - v120 * Root.AnchorPoint.X
    local v123 = v122 < TopbarInset.Min.X or v122 + v120 > TopbarInset.Max.X
    local v124 = AbsoluteSize.Y * p54.Top + v121 * (p54.NameTop - Root.AnchorPoint.Y)
    local v125 = if v123 then math.max(TopbarInset.Max.Y - v124, 0) / AbsoluteSize.Y else 0
    local v127 = p54.Top + v125

    if Root.Position.Y.Scale ~= v127 then
        Root.Position = UDim2.fromScale(Root.Position.X.Scale, v127)
    end

    local v128 = p53.TargetTop + v125

    if p53.Target.Position.Y.Scale ~= v128 then
        p53.Target.Position = UDim2.fromScale(p53.Target.Position.X.Scale, v128)
    end
end

function t23.SetTarget(p55, p56, p57, p58, p59) -- line: 798
    p55.Target.Visible = p56 ~= nil

    if p56 == nil then
        return
    end

    p55.TargetTitle.Text = p56
    p55.TargetTitle.TextColor3 = p59 or Color3.new(1, 1, 1)
    p55.TargetSub.Text = p57 or ""
    p55.TargetCountdown.Text = p58 or ""
end

local function myCannon(p60) -- line: 810
    -- upvalues: PumpkinBossState (copy), CannonAttributes (copy), LocalPlayer (copy)
    local v129 = p60:FindFirstChild(PumpkinBossState.CannonFolder)

    if v129 ~= nil then
        for _, child in v129:GetChildren() do
            if child:GetAttribute(CannonAttributes.OwnerUserId) == LocalPlayer.UserId then
                return child
            end
        end
    end

    return nil
end

local function trappedTeammate(p61) -- line: 824
    -- upvalues: Players (copy), PumpkinBossState (copy), TrapAttributes (copy), LocalPlayer (copy)
    local v130 = p61:FindFirstChild(PumpkinBossState.VineFolder)

    if v130 == nil then
        return nil
    end

    local Character = LocalPlayer.Character
    local HumanoidRootPart = Character and Character:FindFirstChild("HumanoidRootPart")
    local n3 = 1e999
    local v131

    for _, child in v130:GetChildren() do
        local Attribute = child:GetAttribute(TrapAttributes.TrapUserId)
        local v132 = if typeof(Attribute) == "number" then Players:GetPlayerByUserId(Attribute) else nil

        if v132 and v132 ~= LocalPlayer and child:IsA("BasePart") then
            local v133 = if HumanoidRootPart then (child.Position - HumanoidRootPart.Position).Magnitude else 0

            if v133 < n3 then
                n3 = v133
                v131 = v132
            end
        end
    end

    return v131
end

function t23.PointBeam(p62, p63) -- line: 847
    -- upvalues: TutorialBeam (copy)
    if p63 == p62.BeamTarget then
        return
    end

    p62.BeamTarget = p63

    local v134 = p63 == nil
    local Beam

    if v134 then
        Beam = p62.Beam
    else
        if p62.Beam then
            TutorialBeam.Retarget(p62.Beam, p63)

            return
        end

        p62.Beam = TutorialBeam.Attach(p63)
    end

    if (not v134 or Beam) and v134 then
        TutorialBeam.Destroy(p62.Beam)
        p62.Beam = nil
    end
end

function t23.UpdateBeam(p64, p65) -- line: 866
    -- upvalues: Phases (copy), CannonAttributes (copy), myCannon (copy)
    local v135 = if p65 == Phases.Shield or p65 == Phases.Stunned then myCannon(p64.Arena) else nil
    local v136

    if v135 then
        local OperatorZone = v135:FindFirstChild("OperatorZone")
        local v137 = v135.PrimaryPart or v135:FindFirstChildWhichIsA("BasePart", true)

        v136 = if v135:GetAttribute(CannonAttributes.Ready) == true and OperatorZone and OperatorZone:IsA("BasePart") then OperatorZone else v137
    end

    p64:PointBeam(v136)
end

function t23.UpdateTarget(p66, p67, p68) -- line: 877
    -- upvalues: UserInputService (copy), ShrinePadZone (copy), Kit (copy), Phases (copy), TrapAttributes (copy), CannonAttributes (copy), v4 (copy), LocalPlayer (copy), myCannon (copy), trappedTeammate (copy)
    local Attribute = LocalPlayer:GetAttribute(TrapAttributes.TrapEnds)

    if typeof(Attribute) == "number" and p68 < Attribute then
        p66:SetTarget("ROOTED!", "A teammate can bash you free!", string.format("%.1f", Attribute - p68), Kit.Red)

        return
    end

    if p67 == Phases.Shield or p67 == Phases.Stunned then
        local v138 = myCannon(p66.Arena)

        if v138 then
            if v138:GetAttribute(CannonAttributes.Ready) == true then
                local OperatorZone = v138:FindFirstChild("OperatorZone")
                local Character = LocalPlayer.Character
                local HumanoidRootPart = Character and Character:FindFirstChild("HumanoidRootPart")

                if OperatorZone and HumanoidRootPart and ShrinePadZone.ContainsPoint(OperatorZone, HumanoidRootPart.Position) then
                    local v139 = if p67 == Phases.Shield then "Break the King's shield!" else "Fire at the stunned King!"
                    local LastInputType = UserInputService:GetLastInputType()

                    p66:SetTarget(if LastInputType == Enum.UserInputType.Touch then "Tap to FIRE!" elseif string.find(LastInputType.Name, "Gamepad") then "Press R2 to FIRE!" else "Click to FIRE!", v139, nil, Kit.Orange)

                    return
                end

                p66:SetTarget("MAN YOUR CANNON!", "Stand on your cannon's pad", nil, Kit.Orange)
            else
                p66:SetTarget("FREE YOUR CANNON!", "Smash the roots with your bat!", nil, v4)
            end

            return
        end
    end

    local v140 = trappedTeammate(p66.Arena)

    if v140 then
        p66:SetTarget(("SAVE %*!"):format((string.upper(v140.DisplayName))), "Smash the vines to free them", nil, v4)
    else
        p66:SetTarget(nil)
    end
end

function t23.UpdateTimer(p69, p70, p71) -- line: 916
    -- upvalues: PumpkinBossFlags (copy), Kit (copy), Phases (copy), Attributes (copy)
    local Active = p69.Active
    local Attribute = p69.Arena:GetAttribute(Attributes.EndsAt)
    local v141 = typeof(Attribute) == "number" and Attribute > 0
    local Visible = p69.Countdown.Visible

    if not Visible then
        Visible = p69.Arena:GetAttribute(Attributes.Scene) == "BruteRise" or p70 == Phases.Defeated and not v141
    end

    Active.TimerFrame.Visible = not Visible

    if Visible then
        return
    end

    local v142 = if v141 then math.max(Attribute - p71, 0) else PumpkinBossFlags.FightSeconds:Get()

    Active.TimerTitle.Text = "Time Left"

    local TimerLabel = Active.TimerLabel
    local v145 = math.max(math.ceil(v142), 0)

    TimerLabel.Text = string.format("%02d:%02d", v145 // 60, v145 % 60)

    local TimerLabel2 = Active.TimerLabel

    if not (v141 and v142 <= 60) then
        TimerLabel2.TextColor3 = Active.TimerColor
    else
        TimerLabel2.TextColor3 = Kit.Red
    end
end

function t23.Step(p72, p73) -- line: 934
    -- upvalues: Workspace (copy), LightingController (copy), Phases (copy), Attributes (copy), t2 (copy), v2 (copy)
    local v146 = p72:InArena()

    p72.Gui.Enabled = v146

    if v146 ~= p72.Lit then
        p72.Lit = v146

        local PumpkinBoss = if v146 then LightingController.Presets.PumpkinBoss else nil

        if not v146 or not PumpkinBoss then
            LightingController.ClearLayer("PumpkinBoss", 2)
        else
            LightingController.SetLayer("PumpkinBoss", "PumpkinBoss", 170, 2)
        end
    end

    local Arena = p72.Arena
    local v147 = Arena:GetAttribute(Attributes.Phase) or Phases.Waiting
    local v148 = Arena:GetAttribute(Attributes.Boss) == "King" or t2[v147] == true

    p72:UseBar(if v148 then p72.KingBar else p72.BruteBar)

    local Active = p72.Active

    Active.Gui.Enabled = v146

    if not v146 then
        p72:PointBeam(nil)

        return
    end

    p72:ClearTopbar(Active)
    p72:Veil(Active, v147 == Phases.Waiting or Arena:GetAttribute(Attributes.Scene) ~= nil)

    local ServerTimeNow = Workspace:GetServerTimeNow()
    local v149 = Arena:GetAttribute(Attributes.Health) or 0
    local v151 = math.max(Arena:GetAttribute(Attributes.MaxHealth) or 1, 1)
    local BossName = Active.BossName

    if v147 == Phases.Waiting then
        if Active.DesignedName ~= nil then
            BossName.Text = "The Pumpkin Patch"
        else
            BossName.Text = "THE PUMPKIN PATCH"
        end
    elseif Active.DesignedName ~= nil then
        BossName.Text = Active.DesignedName
    elseif v148 then
        BossName.Text = "PUMPKIN KING"
    else
        BossName.Text = "PUMPKIN BRUTE"
    end

    local v152 = if v147 == Phases.Waiting or v147 == Phases.BruteIntro then 1 else math.clamp(v149 / v151, 0, 1)

    if v149 ~= p72.LastHealth then
        if p72.LastHealth >= 0 and v149 < p72.LastHealth then
            p72:Punch()
        end

        p72.LastHealth = v149
    end

    p72.DisplayedHealth = p72.DisplayedHealth + (v152 - p72.DisplayedHealth) * math.min(p73 * 12, 1)

    if p72.PhantomValue < p72.DisplayedHealth then
        p72.PhantomValue = p72.DisplayedHealth
    else
        p72.PhantomValue = p72.PhantomValue + (p72.DisplayedHealth - p72.PhantomValue) * math.min(p73 * 2.5, 1)
    end

    Active.Fill.Size = UDim2.fromScale(p72.DisplayedHealth, Active.Fill.Size.Y.Scale)
    Active.Phantom.Size = UDim2.fromScale(p72.PhantomValue, Active.Phantom.Size.Y.Scale)

    local HealthText = Active.HealthText

    if v147 == Phases.Waiting then
        HealthText.Text = "Waiting for challengers..."
    else
        HealthText.Text = ("%* / %*%*"):format(math.ceil(v149), math.ceil(v151), Active.HealthSuffix)
    end

    local Attribute = Arena:GetAttribute(Attributes.ShieldMax)

    if Arena:GetAttribute(Attributes.ShieldActive) == true and typeof(Attribute) == "number" and Attribute > 0 then
        p72:SetSegments((math.clamp((Arena:GetAttribute(Attributes.ShieldHealth) or 0) / Attribute, 0, 1)))
    else
        p72:SetSegments(nil)
    end

    local Attribute2 = Arena:GetAttribute(Attributes.SpawnsAt)
    local Attribute3 = Arena:GetAttribute(Attributes.StunEnds)

    if v147 == Phases.Waiting and typeof(Attribute2) == "number" and ServerTimeNow < Attribute2 then
        local v160 = math.ceil(Attribute2 - ServerTimeNow)

        p72:SetCountdown(("The battle will begin in <font color=\"#%*\">%*</font> %*"):format(v2, v160, v160 == 1 and "second" or "seconds"), true)
    elseif v147 == Phases.Stunned and typeof(Attribute3) == "number" and ServerTimeNow < Attribute3 then
        p72:SetCountdown((("STUNNED! <b>%*</b>s - keep shooting at him!"):format((string.format("%.1f", Attribute3 - ServerTimeNow)))))
    elseif v147 == Phases.Shield then
        p72:SetCountdown((("Shield <b>%*</b> / %* - fire the cannons!"):format(Arena:GetAttribute(Attributes.ShieldHealth) or 0, Attribute or 0)))
    else
        p72:SetCountdown(nil)
    end

    p72:UpdateTimer(v147, ServerTimeNow)
    p72:UpdateTarget(v147, ServerTimeNow)
    p72:UpdateBeam(v147)
end

return t23
