-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local ContextActionService = game:GetService("ContextActionService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserGameSettings = UserSettings():GetService("UserGameSettings")
local LocalPlayer = Players.LocalPlayer
local MutationDisplay = require(ReplicatedStorage:WaitForChild("Modules"):WaitForChild("MutationDisplay"))
local HarpoonConfig = require(ReplicatedStorage:WaitForChild("Modules"):WaitForChild("HarpoonConfig"))
local FishMotionConfig = require(ReplicatedStorage:WaitForChild("Modules"):WaitForChild("FishMotionConfig"))
local TitanConfig = require(ReplicatedStorage.Modules:WaitForChild("TitanConfig"))
local TitanBody = require(ReplicatedStorage.Modules:WaitForChild("TitanBody"))
local FishDisplay = require(ReplicatedStorage.Modules:WaitForChild("FishDisplay"))
local RarityDisplay = require(ReplicatedStorage.Modules:WaitForChild("RarityDisplay"))
local t1 = {}

for v2, v3 in ipairs(RarityDisplay.order) do
    t1[v3] = v2
end

local v4 = UserInputService.TouchEnabled

UserInputService.LastInputTypeChanged:Connect(function(p1) -- line: 35
    -- upvalues: v4 (ref)
    if p1 == Enum.UserInputType.Touch then
        v4 = true
    elseif p1 == Enum.UserInputType.Keyboard or p1.Name:find("Mouse") or p1.Name:find("Gamepad") then
        v4 = false
    end
end)

local Remotes = ReplicatedStorage:WaitForChild("Remotes")
local Leave = LocalPlayer:WaitForChild("PlayerGui"):WaitForChild("DiveGui"):WaitForChild("Leave")
local SpaceHint = Leave.Parent:WaitForChild("SpaceHint")
local ButtonHover = require(ReplicatedStorage:WaitForChild("Modules"):WaitForChild("ButtonHover"))
local Toast = require(ReplicatedStorage:WaitForChild("Modules"):WaitForChild("Toast"))

ButtonHover.Attach(Leave, {
    shine = false,
    highlight = true
})

local Fire = Leave.Parent:WaitForChild("Fire")

ButtonHover.Attach(Fire, {
    shine = false,
    highlight = true,
    icon = Fire:WaitForChild("Icon")
})

local t2 = {
    mode = require(ReplicatedStorage:WaitForChild("Modules"):WaitForChild("InputMode")),
    stick = Vector2.zero
}
local HarpoonEnter = Instance.new("Frame")

HarpoonEnter.Name = "PadSeat"
HarpoonEnter.BackgroundTransparency = 1
HarpoonEnter.AnchorPoint = Vector2.new(0.5, 1)
HarpoonEnter.Position = UDim2.fromScale(0.5, 0.95)
HarpoonEnter.Size = UDim2.fromScale(1, 0.058)

local UIListLayout = Instance.new("UIListLayout")

UIListLayout.FillDirection = Enum.FillDirection.Horizontal
UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Center
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0.012, 0)
UIListLayout.Parent = HarpoonEnter
HarpoonEnter.Parent = Leave.Parent
t2.fire = t2.mode.Prompt(HarpoonEnter, {
    text = "FIRE",
    height = 1,
    name = "Fire",
    key = Enum.KeyCode.ButtonR2
})
t2.depth = t2.mode.Prompt(HarpoonEnter, {
    text = "DEPTH",
    height = 1,
    name = "Depth",
    keys = {
        Enum.KeyCode.DPadUp,
        Enum.KeyCode.DPadDown
    }
})
t2.leave = t2.mode.Prompt(HarpoonEnter, {
    text = "RETURN",
    height = 1,
    name = "Return",
    key = Enum.KeyCode.ButtonB
})

for v5, v6 in ipairs({
        t2.fire,
        t2.depth,
        t2.leave
    }) do
    v6.gui.LayoutOrder = v5
end

function t2.seat(p2) -- line: 86
    -- upvalues: t2 (copy)
    t2.leave.Show(p2)
end

function t2.armed(p3) -- line: 91
    -- upvalues: t2 (copy)
    t2.fire.Show(p3)
    t2.depth.Show(p3)
end

UserInputService.InputChanged:Connect(function(p4) -- line: 96
    -- upvalues: t2 (copy)
    if p4.KeyCode == Enum.KeyCode.Thumbstick2 then
        t2.stick = Vector2.new(p4.Position.X, p4.Position.Y)
    end
end)
UserInputService.InputEnded:Connect(function(p5) -- line: 99
    -- upvalues: t2 (copy)
    if p5.KeyCode == Enum.KeyCode.Thumbstick2 then
        t2.stick = Vector2.zero
    end
end)

function t2.curve(p6) -- line: 103
    -- upvalues: HarpoonConfig (copy)
    local Pad = HarpoonConfig.Pad
    local v7 = math.abs(p6)

    if v7 <= Pad.Deadzone then
        return 0
    end

    local v8 = (v7 - Pad.Deadzone) / (1 - Pad.Deadzone)

    return math.sign(p6) * math.clamp((math.exp(Pad.Curve * v8) - 1) / (math.exp(Pad.Curve) - 1), 0, 1)
end

HarpoonEnter = Remotes:WaitForChild("HarpoonEnter")

local HarpoonExit = Remotes:WaitForChild("HarpoonExit")
local HarpoonAim = Remotes:WaitForChild("HarpoonAim")
local HarpoonFire = Remotes:WaitForChild("HarpoonFire")
local SpearHooked = Remotes:WaitForChild("SpearHooked")
local ReelBeat = Remotes:WaitForChild("ReelBeat")
local ReelState = Remotes:WaitForChild("ReelState")
local t3 = {
    lateral = 10,
    away = { 6, 14 },
    up = { 4, 14 },
    approach = { 6, 12 },
    turns = { 1.5, 2.5 },
    time = { 0.65, 0.9 }
}
local t4 = {
    lateral = 0,
    time = nil,
    away = { 0, 0 },
    up = { 0, 0 },
    approach = { 0, 0 },
    turns = { 0, 0 }
}
local v13 = false
local v14, t5
local v15 = "seated"
local v16, v17, v18, t6, t7
local n1 = 0
local v19, Fish

task.spawn(function() -- line: 147
    -- upvalues: Fish (ref)
    Fish = workspace:WaitForChild("Fish")
end)

local t8 = {
    cur = 0,
    settle = 0,
    kick = 0,
    hover = false,
    diveT0 = nil,
    diveEnd = nil,
    base = workspace.CurrentCamera.FieldOfView
}

local function fovPop(p7) -- line: 155
    -- upvalues: HarpoonConfig (copy), t8 (copy)
    t8.kick += HarpoonConfig.Fov.Pop * (p7 < t8.settle and -1 or 1)
    t8.settle = p7
end

local t9 = {
    FROM = 0.35,
    IN = 0.22,
    OUT = 0.15
}

local function popScaleOf(p8) -- line: 167
    local v20 = p8:FindFirstChild("HoverScale") or p8:FindFirstChild("PopScale")

    if not v20 then
        v20 = Instance.new("UIScale")
        v20.Name = "PopScale"
        v20.Parent = p8
    end

    return v20
end

local v21 = false

local function showLeave(p9) -- line: 177
    -- upvalues: TweenService (copy), LocalPlayer (copy), v4 (ref), Leave (copy), SpaceHint (copy), t2 (copy), v21 (ref)
    local v22 = p9 and not string.find("," .. (LocalPlayer:GetAttribute("TutorialHides") or "") .. ",", ",DiveGui.Leave,", 1, true) and not LocalPlayer:GetAttribute("TurkeyLeaveHeld")

    t2.seat(v22)

    if t2.mode.Pad() then
        Leave.Visible = false
        SpaceHint.Visible = false
        v21 = v22
    else
        local v23 = v4 and Leave or SpaceHint;

        (v4 and SpaceHint or Leave).Visible = false
        v21 = v22

        local DepthKeys = SpaceHint:FindFirstChild("DepthKeys")

        if DepthKeys and v22 then
            DepthKeys.Visible = not LocalPlayer:GetAttribute("TitanRiding")
        end

        local v24 = v23:FindFirstChild("HoverScale") or v23:FindFirstChild("PopScale")

        if not v24 then
            v24 = Instance.new("UIScale")
            v24.Name = "PopScale"
            v24.Parent = v23
        end

        if v22 then
            v24.Scale = 0.35
            v23.Visible = true
            TweenService:Create(v24, TweenInfo.new(0.22, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                Scale = 1
            }):Play()
        else
            local tween = TweenService:Create(v24, TweenInfo.new(0.15, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
                Scale = 0.35
            })

            tween.Completed:Once(function() -- line: 205
                -- upvalues: v23 (copy), v21 (ref)
                if not v21 then
                    v23.Visible = false
                end
            end)
            tween:Play()
        end
    end
end

local v25 = false

local function showFire(p10) -- line: 210
    -- upvalues: TweenService (copy), v4 (ref), Fire (copy), t2 (copy), v25 (ref)
    t2.armed(p10)

    if p10 ~= v25 then
        v25 = p10

        if v4 then
            local v26 = Fire:FindFirstChild("HoverScale") or Fire:FindFirstChild("PopScale")

            if not v26 then
                v26 = Instance.new("UIScale")
                v26.Name = "PopScale"
                v26.Parent = Fire
            end

            if p10 then
                v26.Scale = 0.35
                Fire.Visible = true
                TweenService:Create(v26, TweenInfo.new(0.22, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                    Scale = 1
                }):Play()
            else
                local tween = TweenService:Create(v26, TweenInfo.new(0.15, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
                    Scale = 0.35
                })

                tween.Completed:Once(function() -- line: 225
                    -- upvalues: Fire (copy), v25 (ref)
                    if not v25 then
                        Fire.Visible = false
                    end
                end)
                tween:Play()
            end
        else
            Fire.Visible = false
        end
    end
end

UserInputService.LastInputTypeChanged:Connect(function() -- line: 233
    -- upvalues: TweenService (copy), v4 (ref), Fire (copy), v25 (ref)
    task.defer(function() -- line: 234
        -- upvalues: TweenService (copy), v4 (ref), Fire (copy), v25 (ref)
        if not v25 then
            return
        end

        local Fire2, v27

        if not v4 or Fire.Visible then
            if not v4 and Fire.Visible then
                Fire.Visible = false
            end
        else
            Fire2 = Fire
            v27 = Fire:FindFirstChild("HoverScale") or Fire:FindFirstChild("PopScale")

            if not v27 then
                v27 = Instance.new("UIScale")
                v27.Name = "PopScale"
                v27.Parent = Fire2
            end

            v27.Scale = 0.35
            Fire.Visible = true
            TweenService:Create(v27, TweenInfo.new(0.22, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                Scale = 1
            }):Play()
        end
    end)
end)
t2.mode.Changed:Connect(function() -- line: 247
    -- upvalues: v21 (ref), showLeave (copy)
    if v21 then
        showLeave(true)
    end
end)

local function unbindFire() -- line: 257
    -- upvalues: ContextActionService (copy), LocalPlayer (copy), t5 (ref), showFire (copy)
    if not (t5 and t5.fireBound) then
        return
    end

    t5.fireBound = false

    local PlayerGui = LocalPlayer:FindFirstChild("PlayerGui")
    local HarpoonAimGui = PlayerGui and PlayerGui:FindFirstChild("HarpoonAimGui")

    if HarpoonAimGui then
        HarpoonAimGui.Enabled = false
    end

    showFire(false)
    ContextActionService:UnbindAction("HarpoonFireAction")
end

local function requestLeave() -- line: 266
    -- upvalues: ContextActionService (copy), LocalPlayer (copy), Leave (copy), SpaceHint (copy), t2 (copy), HarpoonExit (copy), v13 (ref), t5 (ref), v19 (ref), showLeave (copy), showFire (copy)
    if not v13
        or not t5
        or t5.leaving
        or v19 and not v19.titan
        or string.find("," .. (LocalPlayer:GetAttribute("TutorialHides") or "") .. ",", ",DiveGui.Leave,", 1, true)
        or LocalPlayer:GetAttribute("TurkeyLeaveHeld")
        or LocalPlayer:GetAttribute("TitanRiding") and not require(script.TitanFight).ConfirmLeave(SpaceHint, Leave, t2.mode.Pad())
        or LocalPlayer:GetAttribute("TurkeyRun") and not require(script.TurkeyLeave).Confirm(SpaceHint, Leave, t2.mode.Pad()) then
        return
    end

    t5.leaving = true
    HarpoonExit:FireServer()

    if t5 and t5.fireBound then
        t5.fireBound = false

        local PlayerGui = LocalPlayer:FindFirstChild("PlayerGui")
        local HarpoonAimGui = PlayerGui and PlayerGui:FindFirstChild("HarpoonAimGui")

        if HarpoonAimGui then
            HarpoonAimGui.Enabled = false
        end

        showFire(false)
        ContextActionService:UnbindAction("HarpoonFireAction")
    end

    showLeave(false)
    task.delay(6, function() -- line: 281
        -- upvalues: v13 (ref), t5 (ref)
        if v13 and t5 and t5.leaving then
            stopAiming()
        end
    end)
end

LocalPlayer:GetAttributeChangedSignal("TutorialHides"):Connect(function() -- line: 286
    -- upvalues: LocalPlayer (copy), v13 (ref), t5 (ref), v19 (ref), v21 (ref), showLeave (copy)
    if v13 and t5 and not t5.leaving and not v19 then
        local v29 = string.find("," .. (LocalPlayer:GetAttribute("TutorialHides") or "") .. ",", ",DiveGui.Leave,", 1, true) ~= nil

        if v29 == v21 then
            showLeave(not v29)
        end
    end
end)
LocalPlayer:GetAttributeChangedSignal("TurkeyLeaveHeld"):Connect(function() -- line: 292
    -- upvalues: v13 (ref), t5 (ref), v19 (ref), showLeave (copy)
    if v13 and t5 and not t5.leaving and not v19 then
        showLeave(true)
    end
end)

local function reelGui() -- line: 297
    -- upvalues: LocalPlayer (copy)
    local PlayerGui = LocalPlayer:FindFirstChild("PlayerGui")

    return PlayerGui and PlayerGui:FindFirstChild("ReelGui")
end

local function setCrosshair(p11) -- line: 303
    -- upvalues: LocalPlayer (copy), v13 (ref)
    local PlayerGui = LocalPlayer:FindFirstChild("PlayerGui")
    local HarpoonAimGui = PlayerGui and PlayerGui:FindFirstChild("HarpoonAimGui")

    if HarpoonAimGui then
        HarpoonAimGui.Enabled = p11 and v13
    end
end

local t10 = {}

t10[1] = 0.425

local function fitArc(p12) -- line: 324
    local Circle = p12.Circle
    local X = Circle.AbsoluteSize.X

    Circle.Arc.Thickness = (Circle.Arc:GetAttribute("ThicknessFrac") or 0.13) * X
    Circle.ArcOutline.Thickness = (Circle.ArcOutline:GetAttribute("ThicknessFrac") or 0.13) * X
end

local self = setmetatable({}, {
    __mode = "k"
})

local function watchArcSize(p13) -- line: 332
    -- upvalues: self (copy)
    if self[p13] then
        return
    end

    self[p13] = true
    p13.Circle:GetPropertyChangedSignal("AbsoluteSize"):Connect(function() -- line: 335
        -- upvalues: p13 (copy)
        local Circle = p13.Circle
        local X = Circle.AbsoluteSize.X

        Circle.Arc.Thickness = (Circle.Arc:GetAttribute("ThicknessFrac") or 0.13) * X
        Circle.ArcOutline.Thickness = (Circle.ArcOutline:GetAttribute("ThicknessFrac") or 0.13) * X
    end)
end

local function arcControlPoints(p14, p15, p16) -- line: 341
    local v33 = math.max(1, (math.ceil((p16 - p15) / 2)))
    local v35 = math.rad((p16 - p15) / v33)
    local v37 = math.tan(v35 / 4) * 1.3333333333333333 * p14
    local v38 = table.create(v33 + 1)

    for i = 0, v33 do
        local v39 = math.rad(p15) + v35 * i
        local v40 = math.sin(v39) * p14 / 1
        local v41 = -math.cos(v39) * p14 / 1
        local v42 = math.cos(v39) * v37 / 1
        local v43 = math.sin(v39) * v37 / 1

        v38[i + 1] = Path2DControlPoint.new(UDim2.fromScale(0.5 + v40, 0.5 + v41), UDim2.fromScale(-v42, -v43), UDim2.fromScale(v42, v43))
    end

    return v38
end

local t13, t14

local function buildReelArc(p17, p18, p19) -- line: 359
    -- upvalues: t10 (copy), self (copy), arcControlPoints (copy), t13 (ref), t14 (ref)
    t14 = t13
    t13 = {
        center = p18,
        size = p19,
        at = os.clock()
    }

    local v44 = p18 - p19 / 2
    local v45 = p18 + p19 / 2

    t10[1] = p17.Circle.Arc:GetAttribute("RadiusFrac") or t10[1]

    if not self[p17] then
        self[p17] = true
        p17.Circle:GetPropertyChangedSignal("AbsoluteSize"):Connect(function() -- line: 335
            -- upvalues: p17 (copy)
            local Circle = p17.Circle
            local X = Circle.AbsoluteSize.X

            Circle.Arc.Thickness = (Circle.Arc:GetAttribute("ThicknessFrac") or 0.13) * X
            Circle.ArcOutline.Thickness = (Circle.ArcOutline:GetAttribute("ThicknessFrac") or 0.13) * X
        end)
    end

    local Circle = p17.Circle
    local X = Circle.AbsoluteSize.X

    Circle.Arc.Thickness = (Circle.Arc:GetAttribute("ThicknessFrac") or 0.13) * X
    Circle.ArcOutline.Thickness = (Circle.ArcOutline:GetAttribute("ThicknessFrac") or 0.13) * X

    local v48 = math.deg(0.0175 / t10[1])
    local v49 = arcControlPoints(t10[1], v44 + v48, v45 - v48)
    local Arc = p17.Circle.Arc

    Arc:SetControlPoints(v49)
    Arc.Visible = true

    local ArcOutline = p17.Circle.ArcOutline

    ArcOutline:SetControlPoints(v49)
    ArcOutline.Visible = true
    require(script.Deadeye).Arc(p17, function(p20) -- line: 378
        -- upvalues: v44 (copy), v45 (copy), t10 (copy), arcControlPoints (copy)
        return (arcControlPoints(t10[1], v44 - p20, v45 + p20))
    end)

    for v50, v51 in ipairs({ v44, v45 }) do
        local v52 = if v50 == 1 then 1 else -1
        local v53 = math.rad(v51) + v52 * 0.0175 / t10[1]
        local v54 = UDim2.fromScale(math.sin(v53) * t10[1] + 0.5, 0.5 - math.cos(v53) * t10[1])

        for _, v55 in ipairs({ "Cap", "CapO" }) do
            local v56 = p17.Circle[v55 .. v50]

            v56.Position = v54
            v56.Rotation = math.deg(v53)
            v56.Visible = true
        end
    end
end

local function hideReelArc(p21) -- line: 394
    local Circle = p21.Circle

    for _, v57 in ipairs({ "Arc", "ArcOutline", "Cap1", "Cap2", "CapO1", "CapO2" }) do
        Circle[v57].Visible = false
    end

    require(script.Deadeye).HideArc(p21)
end

local v58 = nil

local function v59() -- line: 415
    -- upvalues: v58 (ref)
    local elapsed = os.clock()
    local v60 = workspace:GetServerTimeNow() - elapsed
    local v61 = v58
    local v62 = if v61 then math.abs(v60 - v58) > 0.25 else nil

    if not v61 or v62 then
        v58 = v60
    else
        local v64 = v58

        v58 = v64 + (v60 - v58) * 0.05
    end

    return elapsed + v58
end

local v65
local n2 = 0

local function trailOf(p22) -- line: 427
    local Circle = p22.Circle
    local Trail = Circle:FindFirstChild("Trail")

    if Trail then
        return Trail
    end

    local Folder = Instance.new("Folder")

    Folder.Name = "Trail"

    for i = 1, 4 do
        local Frame = Instance.new("Frame")

        Frame.Name = "Ghost" .. i
        Frame.AnchorPoint = Vector2.new(0.5, 0.5)
        Frame.Position = UDim2.fromScale(0.5, 0.5)
        Frame.Size = UDim2.fromScale(1, 1)
        Frame.BackgroundTransparency = 1
        Frame.ZIndex = 7
        Frame.Visible = false

        local clone = Circle.NeedleRotator.Arrow:Clone()

        clone:ClearAllChildren()

        local UICorner = Instance.new("UICorner")

        UICorner.CornerRadius = UDim.new(0.5, 0)
        UICorner.Parent = clone
        clone.Name = "Bar"
        clone.ZIndex = 7
        clone.BackgroundTransparency = i * 0.6 / 5 + 0.35
        clone.Parent = Frame
        Frame.Parent = Folder
    end

    Folder.Parent = Circle

    return Folder
end

local function v66(p23, p24) -- line: 456
    -- upvalues: v65 (ref), n2 (ref), trailOf (copy)
    p23.Circle.NeedleRotator.Rotation = p24

    local v67 = trailOf(p23)
    local elapsed = os.clock()
    local v68 = v65 and elapsed - n2 < 0.1 and (p24 - v65 + 540) % 360 - 180 or 0

    v65 = p24
    n2 = elapsed

    local v69 = math.abs(v68) >= 4 and math.abs(v68) < 120

    for i = 1, 4 do
        local v70 = v67:FindFirstChild("Ghost" .. i)

        if v70 then
            v70.Visible = v69

            if v69 then
                v70.Rotation = p24 - v68 * i / 5
                v70.Bar.BackgroundColor3 = p23.Circle.NeedleRotator.Arrow.BackgroundColor3
            end
        end
    end
end

local function hideTrail(p25) -- line: 475
    -- upvalues: v65 (ref)
    v65 = nil

    local v71 = p25 and p25.Circle:FindFirstChild("Trail")

    if v71 then
        for _, child in ipairs(v71:GetChildren()) do
            child.Visible = false
        end
    end
end

local function needleAngleAt(p26, p27) -- line: 482
    local v73 = math.max(0, p27 - p26.time0)

    if v73 < p26.ramp then
        return (p26.angle0 + p26.v0 * v73 + (p26.v1 - p26.v0) * v73 * v73 / (2 * p26.ramp)) % 360
    end

    return (p26.angle0 + (p26.v0 + p26.v1) * p26.ramp / 2 + p26.v1 * (v73 - p26.ramp)) % 360
end

local Versus = require(script:WaitForChild("Versus"))

require(script:WaitForChild("WallHit"))

local function setProgress(p28, p29) -- line: 495
    -- upvalues: Versus (copy)
    local Pips = p28.Circle.Pips

    if p29.titan then
        Pips.Visible = false
        Versus.Hide(p28)
    elseif p29.pvp then
        Pips.Visible = false
        Versus.Show(p28, p29)
    else
        Versus.Hide(p28)
        Pips.Visible = true

        local v74 = p29.beats or 1
        local v75 = p29.beatsDone or 0

        if p29.extraBeats ~= nil then
            Pips:SetAttribute("Extra", p29.extraBeats)
        end

        if p29.extraStyle ~= nil then
            Pips:SetAttribute("ExtraStyle", p29.extraStyle)
        end

        local v76 = Pips:GetAttribute("Extra") or 0
        local t15 = {}

        for _, child in ipairs(Pips:GetChildren()) do
            if child:IsA("Frame") then
                t15[#t15 + 1] = child
            end
        end

        local t16

        if #t15 == v74 and Pips:GetAttribute("BuiltExtra") == v76 and Pips:GetAttribute("BuiltStyle") == Pips:GetAttribute("ExtraStyle") then
            t16 = t15
        else
            Pips:SetAttribute("BuiltExtra", v76)
            Pips:SetAttribute("BuiltStyle", Pips:GetAttribute("ExtraStyle"))

            for _, v77 in ipairs(t15) do
                v77:Destroy()
            end

            t16 = {}

            for i = 1, v74 do
                local Frame = Instance.new("Frame")

                Frame.Name = "Pip" .. i
                Frame.LayoutOrder = i
                Frame.Size = UDim2.fromScale(1, 1)

                local UIAspectRatioConstraint = Instance.new("UIAspectRatioConstraint")

                UIAspectRatioConstraint.AspectRatio = 1
                UIAspectRatioConstraint.DominantAxis = Enum.DominantAxis.Height
                UIAspectRatioConstraint.Parent = Frame
                Frame.BackgroundColor3 = Color3.new(1, 1, 1)
                Frame.BorderSizePixel = 0
                Frame.ZIndex = 9

                local UICorner = Instance.new("UICorner")

                UICorner.CornerRadius = UDim.new(1, 0)
                UICorner.Parent = Frame

                local UIStroke = Instance.new("UIStroke")

                UIStroke.StrokeSizingMode = Enum.StrokeSizingMode.ScaledSize
                UIStroke.Thickness = 0.2
                UIStroke.Color = Color3.new(1, 1, 1)
                UIStroke.Parent = Frame

                local v78 = Pips:GetAttribute("ExtraStyle") == "Halloween"

                if v78 or v74 - v76 < i then
                    local v79 = Pips:GetAttribute("ExtraStyle") == "Exclusive"
                    local v80 = Pips:GetAttribute("ExtraStyle") == "PinkMoon"

                    for _, v81 in ipairs({ Frame, UIStroke }) do
                        local UIGradient = Instance.new("UIGradient")

                        UIGradient.Rotation = 45

                        if v78 then
                            UIGradient.Color = ColorSequence.new({
                                ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 215, 160)),
                                ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 140, 40)),
                                ColorSequenceKeypoint.new(1, Color3.fromRGB(150, 60, 0))
                            }) or v80 and ColorSequence.new({
                                ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 200, 235)),
                                ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 30, 190)),
                                ColorSequenceKeypoint.new(1, Color3.fromRGB(135, 0, 95))
                            }) or v79 and ColorSequence.new({
                                ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 150, 150)),
                                ColorSequenceKeypoint.new(0.5, Color3.fromRGB(235, 30, 34)),
                                ColorSequenceKeypoint.new(1, Color3.fromRGB(120, 0, 10))
                            }) or ColorSequence.new({
                                ColorSequenceKeypoint.new(0, Color3.fromRGB(215, 165, 255)),
                                ColorSequenceKeypoint.new(0.5, Color3.fromRGB(145, 60, 240)),
                                ColorSequenceKeypoint.new(1, Color3.fromRGB(70, 12, 150))
                            })
                        else
                            UIGradient.Color = v80 and ColorSequence.new({
                                ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 200, 235)),
                                ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 30, 190)),
                                ColorSequenceKeypoint.new(1, Color3.fromRGB(135, 0, 95))
                            }) or v79 and ColorSequence.new({
                                ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 150, 150)),
                                ColorSequenceKeypoint.new(0.5, Color3.fromRGB(235, 30, 34)),
                                ColorSequenceKeypoint.new(1, Color3.fromRGB(120, 0, 10))
                            }) or ColorSequence.new({
                                ColorSequenceKeypoint.new(0, Color3.fromRGB(215, 165, 255)),
                                ColorSequenceKeypoint.new(0.5, Color3.fromRGB(145, 60, 240)),
                                ColorSequenceKeypoint.new(1, Color3.fromRGB(70, 12, 150))
                            })
                        end

                        UIGradient.Parent = v81
                    end
                end

                Frame.Parent = Pips
                t16[i] = Frame
            end
        end

        table.sort(t16, function(p30, p31) -- line: 585
            return p30.LayoutOrder < p31.LayoutOrder
        end)

        for v82, v83 in ipairs(t16) do
            v83.BackgroundTransparency = v82 <= v75 and 0 or 1
        end
    end
end

local v84 = Color3.fromRGB(245, 240, 230)
local v85 = Color3.fromRGB(235, 30, 30)
local v86 = Color3.fromRGB(12, 12, 14)
local v87 = Color3.new(1, 1, 1)
local v88 = Color3.fromRGB(96, 240, 120)
local v89 = Color3.fromRGB(255, 80, 70)
local n3 = 0

local function burstZone(p32) -- line: 611
    -- upvalues: RunService (copy), t10 (copy), arcControlPoints (copy), t13 (ref), t14 (ref), v88 (copy)
    local t17, v90

    if t13 and os.clock() - t13.at < 0.05 then
        local t18 = t14

        if t18 then
            t17 = t18
            v90 = true
        else
            v90 = false
        end
    else
        v90 = false
    end

    if not v90 then
        t17 = t13
    end

    if not t17 then
        return
    end

    local Circle = p32.Circle
    local clone = Circle.Arc:Clone()

    clone.Name = "Burst"
    clone.ZIndex = 2
    clone.Visible = true
    clone.Parent = Circle

    local v91 = Circle.Arc:GetAttribute("ThicknessFrac") or 0.13
    local v92 = t17.center - t17.size / 2
    local v93 = t17.center + t17.size / 2
    local elapsed = os.clock()
    local connection

    connection = RunService.RenderStepped:Connect(function() -- line: 624
        -- upvalues: Circle (copy), clone (copy), v91 (copy), v92 (copy), v93 (copy), elapsed (copy), connection (ref), t10 (copy), arcControlPoints (copy), v88 (copy)
        local v95 = math.min(1, (os.clock() - elapsed) / 0.3)
        local v96 = 1 - (1 - v95) ^ 3

        if not clone.Parent or v95 >= 1 then
            connection:Disconnect()
            clone:Destroy()
        else
            clone:SetControlPoints((arcControlPoints(t10[1] + v96 * 0.16, v92, v93)))
            clone.Thickness = v91 * Circle.AbsoluteSize.X * (1 - v95) ^ 1.5
            clone.Color3 = Color3.new(1, 1, 1):Lerp(v88, v95)
        end
    end)
end

local function popPip(p33) -- line: 637
    -- upvalues: TweenService (copy)
    task.defer(function() -- line: 638
        -- upvalues: p33 (copy), TweenService (copy)
        local child

        for _, child2 in ipairs(p33.Circle.Pips:GetChildren()) do
            if child2:IsA("Frame") and child2.BackgroundTransparency < 0.5 and (not child or child2.LayoutOrder > child.LayoutOrder) then
                child = child2
            end
        end

        if not child then
            return
        end

        local v97 = child:FindFirstChildOfClass("UIScale") or Instance.new("UIScale")

        v97.Parent = child
        v97.Scale = 1.7
        TweenService:Create(v97, TweenInfo.new(0.28, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
            Scale = 1
        }):Play()
    end)
end

local function shrinkPop(p34) -- line: 653
    -- upvalues: TweenService (copy)
    local Pulse = p34.Circle:FindFirstChild("Pulse")

    if Pulse then
        Pulse.Scale = 0.84
        TweenService:Create(Pulse, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
            Scale = 1
        }):Play()
    end
end

local function tintReel(p35, p36, p37) -- line: 659
    -- upvalues: TweenService (copy), v84 (copy), v85 (copy), v86 (copy), v87 (copy), v88 (copy), v89 (copy), n3 (ref), burstZone (copy), shrinkPop (copy)
    local Circle = p35.Circle
    local t19 = {}

    for _, child in ipairs(Circle.Pips:GetChildren()) do
        if child:IsA("Frame") then
            t19[#t19 + 1] = {
                child.UIStroke,
                "Color"
            }
            t19[#t19 + 1] = { child, "BackgroundColor3" }
        end
    end

    local v98 = p36 == v84

    for _, v99 in ipairs(t19) do
        local v100 = v99[1]
        local v101 = v99[2]

        if v98 then
            v100[v101] = v99[3] or v84 or p36
        else
            v100[v101] = p36
        end
    end

    local UIStroke = Circle.Ring.UIStroke
    local Arrow = Circle.NeedleRotator.Arrow
    local Key = Circle.Key

    UIStroke.Color = v86
    Arrow.BackgroundColor3 = v85
    Key.TextColor3 = v87

    local UIStroke2 = Circle.Glow.UIStroke

    n3 += 1

    local v102 = n3

    if v98 then
        UIStroke2.Transparency = 1
    else
        UIStroke2.Color = p36
        UIStroke2.Transparency = 0.2
        TweenService:Create(UIStroke2, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Transparency = 1
        }):Play()

        if p36 == v88 then
            burstZone(p35)
            task.defer(function() -- line: 638
                -- upvalues: p35 (copy), TweenService (copy)
                local child

                for _, child2 in ipairs(p35.Circle.Pips:GetChildren()) do
                    if child2:IsA("Frame") and child2.BackgroundTransparency < 0.5 and (not child or child2.LayoutOrder > child.LayoutOrder) then
                        child = child2
                    end
                end

                if not child then
                    return
                end

                local v103 = child:FindFirstChildOfClass("UIScale") or Instance.new("UIScale")

                v103.Parent = child
                v103.Scale = 1.7
                TweenService:Create(v103, TweenInfo.new(0.28, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                    Scale = 1
                }):Play()
            end)
        elseif p36 == v89 then
            shrinkPop(p35)
        end

        task.delay(p37, function() -- line: 690
            -- upvalues: Circle (copy), t19 (copy), v102 (copy), TweenService (copy), v84 (copy), n3 (ref)
            if v102 == n3 and Circle.Parent then
                local v104 = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

                for _, v105 in ipairs(t19) do
                    if v105[1].Parent then
                        TweenService:Create(v105[1], v104, {
                            [v105[2]] = v105[3] or v84
                        }):Play()
                    end
                end
            end
        end)
    end
end

local v107 = Color3.fromRGB(85, 213, 255)
local v108 = Color3.fromRGB(110, 235, 130)
local v109 = Color3.fromRGB(255, 92, 92)
local v110 = Color3.fromRGB(70, 255, 120)
local v111 = Color3.fromRGB(255, 122, 48)

local function setGlow(p38, p39, p40) -- line: 709
    -- upvalues: TweenService (copy), LocalPlayer (copy)
    local PlayerGui = LocalPlayer:FindFirstChild("PlayerGui")
    local ReelGui = PlayerGui and PlayerGui:FindFirstChild("ReelGui")
    local v112 = ReelGui and ReelGui.Vignette:FindFirstChild("Glow")

    if v112 then
        if p40 <= 0 then
            v112.ImageColor3 = p38
            v112.ImageTransparency = p39
        else
            TweenService:Create(v112, TweenInfo.new(p40, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                ImageColor3 = p38,
                ImageTransparency = p39
            }):Play()
        end
    end
end

local function heartsLost() -- line: 724
    -- upvalues: v19 (ref)
    if v19 and not v19.pvp then
        local v114 = v19.heartsMax or 0
        local v113 = v114 > 0 and math.clamp((v114 - (v19.hearts or v114)) / v114, 0, 1) or 0

        return v113
    end

    return 0
end

local function fightBaseColor() -- line: 729
    -- upvalues: MutationDisplay (copy), v18 (ref), v107 (copy)
    local v116 = v18 and MutationDisplay[v18]

    if v116 and not v116.cycle then
        return v116.color
    end

    return v107
end

local function fightEdge() -- line: 734
    -- upvalues: MutationDisplay (copy), v18 (ref)
    local v117 = v18 and MutationDisplay[v18]

    return v117 and v117.edge or 0.6
end

local function fightGlow() -- line: 742
    -- upvalues: MutationDisplay (copy), v18 (ref), v19 (ref), v107 (copy), v109 (copy), v111 (copy)
    if not v19 then
        return v107, 0.6
    end

    if v19.pvp then
        return v111, 0.6
    end

    local v118 = v19
    local v119

    if not v118 or v19.pvp then
        v119 = 0
    else
        local v120 = v19.heartsMax or 0

        v119 = v120 > 0 and math.clamp((v120 - (v19.hearts or v120)) / v120, 0, 1) or 0
    end

    local v123 = v18 and MutationDisplay[v18]
    local v126 = (if not v123 or v123.cycle then v107 else v123.color):Lerp(v109, (math.min(1, v119 * 1.5)))
    local v127 = v18 and MutationDisplay[v18]

    return v126, (math.max(0.1, (v127 and v127.edge or 0.6) - 0.3 * v119))
end

local function rainbowHue() -- line: 748
    return Color3.fromHSV(os.clock() * 0.4 % 1, 0.75, 1)
end

local function setFightGlow(p41) -- line: 751
    -- upvalues: MutationDisplay (copy), v18 (ref), v19 (ref), v107 (copy), v109 (copy), v111 (copy), setGlow (copy)
    local v129, v130

    if v19 then
        if v19.pvp then
            v129 = v111
            v130 = 0.6
        else
            local n4 = 0

            if v19 then
                if v19.pvp then
                else
                    local v131 = v19.heartsMax or 0

                    n4 = v131 > 0 and math.clamp((v131 - (v19.hearts or v131)) / v131, 0, 1) or 0
                end
            end

            local v133 = v18 and MutationDisplay[v18]

            v129 = (if not v133 or v133.cycle then v107 else v133.color):Lerp(v109, (math.min(1, n4 * 1.5)))

            local v136 = v18 and MutationDisplay[v18]

            v130 = math.max(0.1, (v136 and v136.edge or 0.6) - 0.3 * n4)
        end
    else
        v129 = v107
        v130 = 0.6
    end

    setGlow(v129, v130, p41)
end

local function missGlow() -- line: 758
    -- upvalues: MutationDisplay (copy), v18 (ref), v19 (ref), v107 (copy), v109 (copy), v111 (copy), setGlow (copy)
    setGlow(v109, 0.2, 0.18)
    task.delay(0.3, function() -- line: 760
        -- upvalues: MutationDisplay (copy), v18 (ref), v19 (ref), v107 (copy), v109 (copy), v111 (copy), setGlow (copy)
        if v19 then
            if v19.pvp then
                setGlow(v111, 0.75, 0.8)
            else
                local v138, v139

                if v19 then
                    if v19.pvp then
                        v138 = v111
                        v139 = 0.6
                    else
                        local n5 = 0

                        if v19 then
                            if v19.pvp then
                            else
                                local v140 = v19.heartsMax or 0

                                n5 = v140 > 0 and math.clamp((v140 - (v19.hearts or v140)) / v140, 0, 1) or 0
                            end
                        end

                        local v142 = v18 and MutationDisplay[v18]

                        v138 = (if not v142 or v142.cycle then v107 else v142.color):Lerp(v109, (math.min(1, n5 * 1.5)))

                        local v145 = v18 and MutationDisplay[v18]

                        v139 = math.max(0.1, (v145 and v145.edge or 0.6) - 0.3 * n5)
                    end
                else
                    v138 = v107
                    v139 = 0.6
                end

                setGlow(v138, v139, 0.8)
            end
        end
    end)
end

local t21
local v147 = nil
local n6 = 0

local function updateSpread(p42, p43) -- line: 778
    -- upvalues: LocalPlayer (copy), t21 (ref), v147 (ref), n6 (ref)
    if not t21 then
        local PlayerGui = LocalPlayer:FindFirstChild("PlayerGui")
        local v148 = PlayerGui and PlayerGui:FindFirstChild("HarpoonAimGui")
        local v149, v150, v151

        if v148 then
            v149 = v148:FindFirstChild("Up")
            v150 = v148:FindFirstChild("Down")
            v151 = v148:FindFirstChild("Left")
            v148 = v148:FindFirstChild("Right")
        else
            v151 = v148
            v149 = v148
            v150 = v148
        end

        if not (v149 and v150 and v151 and v148) then
            return
        end

        t21 = {
            up = v149,
            down = v150,
            left = v151,
            right = v148,
            rest = math.abs(v149.Position.Y.Offset)
        }
        v147 = t21.rest
    end

    local t23 = t21
    local v152 = n6

    n6 = v152 * math.exp(-9 * p42)

    if n6 < 0.05 then
        n6 = 0
    end

    local v154 = t23.rest + (if p43 then 6 else 0)
    local v155 = v147

    v147 = v155 + (v154 - v147) * math.min(1, p42 * 9)

    local v158 = v147 + n6

    t23.up.Position = UDim2.new(0.5, 0, 0.5, -v158)
    t23.down.Position = UDim2.new(0.5, 0, 0.5, v158)
    t23.left.Position = UDim2.new(0.5, -v158, 0.5, 0)
    t23.right.Position = UDim2.new(0.5, v158, 0.5, 0)
end

local _ = {
    FROM = 1.55,
    SNAP = 0.09,
    HOLD = 0.06,
    FADE = 0.18,
    TO = 1.22
}
local n7 = 0

local function hitMark() -- line: 813
    -- upvalues: TweenService (copy), LocalPlayer (copy), n7 (ref)
    local PlayerGui = LocalPlayer:FindFirstChild("PlayerGui")
    local HarpoonAimGui = PlayerGui and PlayerGui:FindFirstChild("HarpoonAimGui")
    local Hit = HarpoonAimGui and HarpoonAimGui:FindFirstChild("Hit")
    local Pop = Hit and Hit:FindFirstChild("Pop")

    if not Pop then
        return
    end

    n7 += 1

    local v159 = n7

    Pop.Scale = 1.55
    Hit.Visible = true

    for _, child in ipairs(Hit:GetChildren()) do
        if child:IsA("Frame") then
            child.BackgroundTransparency = 0
        end
    end

    TweenService:Create(Pop, TweenInfo.new(0.09, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Scale = 1
    }):Play()
    task.delay(0.15, function() -- line: 827
        -- upvalues: Hit (copy), Pop (copy), v159 (copy), TweenService (copy), n7 (ref)
        if n7 ~= v159 then
            return
        end

        local v160 = TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

        TweenService:Create(Pop, v160, {
            Scale = 1.22
        }):Play()

        for _, child in ipairs(Hit:GetChildren()) do
            if child:IsA("Frame") then
                TweenService:Create(child, v160, {
                    BackgroundTransparency = 1
                }):Play()
            end
        end

        task.delay(0.18, function() -- line: 834
            -- upvalues: Hit (copy), v159 (copy), n7 (ref)
            if n7 == v159 then
                Hit.Visible = false
            end
        end)
    end)
end

local v161 = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromHSV(0, 0.8, 1)),
    ColorSequenceKeypoint.new(0.2, Color3.fromHSV(0.2, 0.8, 1)),
    ColorSequenceKeypoint.new(0.4, Color3.fromHSV(0.4, 0.8, 1)),
    ColorSequenceKeypoint.new(0.6, Color3.fromHSV(0.6, 0.8, 1)),
    ColorSequenceKeypoint.new(0.8, Color3.fromHSV(0.8, 0.8, 1)),
    ColorSequenceKeypoint.new(1, Color3.fromHSV(0, 0.8, 1))
})

local function revealGlow(p44) -- line: 857
    -- upvalues: LocalPlayer (copy), MutationDisplay (copy), v18 (ref), t6 (ref), setGlow (copy), v161 (copy)
    local v162 = p44 and MutationDisplay[p44]
    local PlayerGui = LocalPlayer:FindFirstChild("PlayerGui")
    local ReelGui = PlayerGui and PlayerGui:FindFirstChild("ReelGui")
    local Reveal = ReelGui and ReelGui:FindFirstChild("Reveal")

    if not (v162 and Reveal) then
        return
    end

    if not ReelGui.Enabled then
        ReelGui.Circle.Visible = false
        ReelGui.Enabled = true
    end

    local UIGradient = Reveal.UIStroke.UIGradient

    UIGradient.Color = v162.cycle and v161 or ColorSequence.new(v162.color)
    UIGradient.Rotation = 0
    Reveal.UIStroke.Transparency = 0.3

    local v163 = v162.cycle and Color3.fromHSV(os.clock() * 0.4 % 1, 0.75, 1) or v162.color
    local v164 = v18 and MutationDisplay[v18]

    setGlow(v163, math.max(0.05, (v164 and v164.edge or 0.6) - 0.25), 0.12)
    t6 = {
        t0 = os.clock(),
        info = v162
    }
end

local function pulseReelCircle() -- line: 874
    -- upvalues: TweenService (copy), LocalPlayer (copy)
    local PlayerGui = LocalPlayer:FindFirstChild("PlayerGui")
    local ReelGui = PlayerGui and PlayerGui:FindFirstChild("ReelGui")

    if not ReelGui then
        return
    end

    local Pulse = ReelGui.Circle.Pulse

    Pulse.Scale = 1.12
    TweenService:Create(Pulse, TweenInfo.new(0.28, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Scale = 1
    }):Play()
end

local function popNeedle(p45) -- line: 892
    -- upvalues: TweenService (copy)
    if not p45 then
        return
    end

    local Arrow = p45.Circle.NeedleRotator.Arrow
    local UIScale = Arrow:FindFirstChildOfClass("UIScale")

    if not UIScale then
        UIScale = Instance.new("UIScale")
        UIScale.Name = "Pop"
        UIScale.Parent = Arrow
    end

    UIScale.Scale = 2.8
    TweenService:Create(UIScale, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Scale = 1
    }):Play()
end

local n8 = 0

local function playHitSound() -- line: 916
    -- upvalues: t2 (copy), n8 (ref)
    local HarpoonSFX = game:GetService("SoundService"):FindFirstChild("HarpoonSFX")
    local HitSound = HarpoonSFX and HarpoonSFX:FindFirstChild("HitSound")

    if not HitSound then
        return
    end

    HitSound.PlaybackSpeed = n8 * 0.025 + 0.95
    n8 += 1
    HitSound:Play()
    t2.mode.Rumble("hit")
end

local function playUiSound(p46) -- line: 928
    local HarpoonSFX = game:GetService("SoundService"):FindFirstChild("HarpoonSFX")
    local v166 = HarpoonSFX and HarpoonSFX:FindFirstChild(p46)

    if v166 then
        v166:Play()
    end
end

local function playTugSound(p47) -- line: 937
    -- upvalues: t2 (copy), n8 (ref)
    local HarpoonSFX = game:GetService("SoundService"):FindFirstChild("HarpoonSFX")

    HarpoonSFX = HarpoonSFX and HarpoonSFX:FindFirstChild(if p47 then "TugB" else "TugA")

    if p47 then
        t2.mode.Rumble("landed")
    end

    if not HarpoonSFX then
        return
    end

    HarpoonSFX.PlaybackSpeed = math.max(0, n8 - 1) * 0.025 + 0.95
    HarpoonSFX:Play()
end

local function reelLoop() -- line: 949
    local HarpoonSFX = game:GetService("SoundService"):FindFirstChild("HarpoonSFX")

    return HarpoonSFX and HarpoonSFX:FindFirstChild("ReelLoop")
end

local function setReelLoop(p48, p49) -- line: 953
    local HarpoonSFX = game:GetService("SoundService"):FindFirstChild("HarpoonSFX")
    local ReelLoop = HarpoonSFX and HarpoonSFX:FindFirstChild("ReelLoop")

    if ReelLoop then
        if p48 then
            ReelLoop.PlaybackSpeed = math.clamp(p49 or 1, 0.8, 1.2)

            if not ReelLoop.IsPlaying then
                ReelLoop:Play()
            end
        elseif ReelLoop.IsPlaying then
            ReelLoop:Stop()
        end
    end
end

task.spawn(function() -- line: 963
    local HarpoonSFX = game:GetService("SoundService"):WaitForChild("HarpoonSFX")

    game:GetService("ContentProvider"):PreloadAsync(HarpoonSFX:GetChildren())
end)
task.spawn(function() -- line: 973
    -- upvalues: LocalPlayer (copy)
    local ReelGui = LocalPlayer:WaitForChild("PlayerGui"):WaitForChild("ReelGui")

    game:GetService("ContentProvider"):PreloadAsync(ReelGui:GetDescendants())
end)

local t24 = {}

t24[2] = {
    volume = 0.25,
    speed = 0.85,
    pulse = 0.08
}
t24[1] = {
    volume = 1,
    speed = 1.1,
    pulse = 0.22
}

local n9 = 0
local t25 = {}

t25[2] = { 0.18, 1.6 }
t25[1] = { 0.42, 1.1 }

local n10 = 5
local n11 = 0

local function heartbeatSound() -- line: 996
    local HarpoonSFX = game:GetService("SoundService"):FindFirstChild("HarpoonSFX")

    return HarpoonSFX and HarpoonSFX:FindFirstChild("HeartbeatLoop")
end

local function setHeartbeat(p50) -- line: 1000
    -- upvalues: TweenService (copy), LocalPlayer (copy), t24 (copy), n9 (ref), n11 (ref)
    if not (p50 and t24[p50]) then
        local PlayerGui = LocalPlayer:FindFirstChild("PlayerGui")

        PlayerGui = PlayerGui and PlayerGui:FindFirstChild("ReelGui")

        local v169 = PlayerGui and PlayerGui.Vignette:FindFirstChild("Beat")

        if v169 and v169.ImageTransparency < 1 then
            TweenService:Create(v169, TweenInfo.new(0.45, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                ImageTransparency = 1
            }):Play()
        end
    end

    local HarpoonSFX = game:GetService("SoundService"):FindFirstChild("HarpoonSFX")
    local HeartbeatLoop = HarpoonSFX and HarpoonSFX:FindFirstChild("HeartbeatLoop")

    if not HeartbeatLoop then
        return
    end

    local v170 = p50 and t24[p50]

    n11 += 1

    local v171 = n11

    if v170 then
        n9 = v170.pulse

        if not HeartbeatLoop.IsPlaying then
            HeartbeatLoop.Volume = 0
            HeartbeatLoop.PlaybackSpeed = v170.speed
            HeartbeatLoop:Play()
        end

        TweenService:Create(HeartbeatLoop, TweenInfo.new(0.6, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Volume = v170.volume,
            PlaybackSpeed = v170.speed
        }):Play()
    else
        n9 = 0

        if HeartbeatLoop.IsPlaying then
            TweenService:Create(HeartbeatLoop, TweenInfo.new(0.5), {
                Volume = 0
            }):Play()
            task.delay(0.5, function() -- line: 1018
                -- upvalues: HeartbeatLoop (copy), v171 (copy), n11 (ref)
                if v171 == n11 then
                    HeartbeatLoop:Stop()
                end
            end)
        end
    end
end

local function shadowRings(p51) -- line: 1037
    local t26 = {}

    for _, child in ipairs(p51:GetChildren()) do
        if child.Name:match("^Shadow") and child:FindFirstChildOfClass("UIStroke") then
            t26[#t26 + 1] = child:FindFirstChildOfClass("UIStroke")
        end
    end

    return t26
end

local v172 = false
local t27

local function resetReelLook(p52) -- line: 1046
    -- upvalues: shadowRings (copy)
    local Circle = p52.Circle

    Circle.Pulse.Scale = 1
    Circle.Ring.UIStroke.Transparency = 0.05
    Circle.RingOutline.UIStroke.Transparency = 0.35

    for _, v173 in ipairs((shadowRings(Circle))) do
        v173.Transparency = 0.88
    end

    Circle.Glow.UIStroke.Transparency = 1
    Circle.Key.UIStroke.Transparency = 0
    Circle.Key.TextTransparency = 0
    Circle.NeedleRotator.Arrow.BackgroundTransparency = 0

    for _, child in ipairs(Circle.Pips:GetChildren()) do
        if child:IsA("Frame") then
            child.UIStroke.Transparency = 0
        end
    end

    for _, child in ipairs(Circle.Hearts:GetChildren()) do
        if child:IsA("ImageLabel") and child.Name ~= "HeartTemplate" then
            child.Shadow.ImageTransparency = 0.55
        end
    end
end

local function finishReel(p53, p54) -- line: 1064
    -- upvalues: TweenService (copy), v19 (ref), hideReelArc (copy), v59 (copy), needleAngleAt (copy), Versus (copy), setHeartbeat (copy), shadowRings (copy), v172 (ref), t27 (ref), resetReelLook (copy)
    if v172 then
        return
    end

    local t28 = {
        tweens = {}
    }

    v172 = t28

    local function play(p55) -- line: 1073
        -- upvalues: t28 (copy)
        p55:Play()
        t28.tweens[#t28.tweens + 1] = p55
    end

    setHeartbeat(nil)

    local Circle = p53.Circle

    hideReelArc(p53)
    require(script.Deadeye).Hide()

    if v19 then
        local v174 = v59()
        local v1

        if p54 then
            v1 = v19.v1

            if not v1 then
                local v175 = v19
                local v176 = -v175.v1
                local v177 = v19

                v1 = v176 * (v177.esc or 1.04)
            end
        else
            local v178 = v19
            local v179 = -v178.v1
            local v180 = v19

            v1 = v179 * (v180.esc or 1.04)
        end

        t27 = {
            a0 = needleAngleAt(v19, v174),
            v = v1,
            t0 = v174,
            base = v19.baseSpeed
        }
    end

    local v181 = TweenInfo.new(0.45, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local tween = TweenService:Create(Circle.Pulse, v181, {
        Scale = 1.28
    })

    tween:Play()
    t28.tweens[#t28.tweens + 1] = tween

    if v19 and v19.pvp then
        Versus.Finish(v181)
    end

    local t29 = {
        {
            Circle.Ring.UIStroke,
            "Transparency"
        },
        {
            Circle.RingOutline.UIStroke,
            "Transparency"
        },
        {
            Circle.Glow.UIStroke,
            "Transparency"
        },
        {
            Circle.Key.UIStroke,
            "Transparency"
        },
        {
            Circle.Key,
            "TextTransparency"
        }
    }

    for _, v182 in ipairs((shadowRings(Circle))) do
        t29[#t29 + 1] = { v182, "Transparency" }
    end

    local child

    for _, child2 in ipairs(Circle.Pips:GetChildren()) do
        if child2:IsA("Frame") then
            child2.BackgroundTransparency = 0

            if not child or child2.LayoutOrder > child.LayoutOrder then
                child = child2
            end
        end
    end

    if child then
        local v183 = child:FindFirstChildOfClass("UIScale") or Instance.new("UIScale")

        v183.Parent = child
        v183.Scale = 1.7
        TweenService:Create(v183, TweenInfo.new(0.28, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
            Scale = 1
        }):Play()
    end

    local v184 = TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, 0, false, 0.2)

    for _, child in ipairs(Circle.Pips:GetChildren()) do
        if child:IsA("Frame") then
            local tween = TweenService:Create(child.UIStroke, v184, {
                Transparency = 1
            })

            tween:Play()
            t28.tweens[#t28.tweens + 1] = tween

            local tween2 = TweenService:Create(child, v184, {
                BackgroundTransparency = 1
            })

            tween2:Play()
            t28.tweens[#t28.tweens + 1] = tween2
        end
    end

    for _, child in ipairs(Circle.Hearts:GetChildren()) do
        if child:IsA("ImageLabel") and child.Name ~= "HeartTemplate" then
            t29[#t29 + 1] = { child, "ImageTransparency" }
            t29[#t29 + 1] = {
                child.Shadow,
                "ImageTransparency"
            }
        end
    end

    for _, v185 in ipairs(t29) do
        local tween = TweenService:Create(v185[1], v181, {
            [v185[2]] = 1
        })

        tween:Play()
        t28.tweens[#t28.tweens + 1] = tween
    end

    local tween2 = TweenService:Create(Circle.NeedleRotator.Arrow, TweenInfo.new(0.15000000000000002, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, 0, false, 0.3), {
        BackgroundTransparency = 1
    })

    tween2:Play()
    t28.tweens[#t28.tweens + 1] = tween2
    task.delay(0.5, function() -- line: 1146
        -- upvalues: p53 (copy), t28 (copy), v172 (ref), resetReelLook (copy)
        if v172 == t28 then
            v172 = false

            if p53.Parent then
                resetReelLook(p53)
                p53.Circle.Visible = false
            end
        end
    end)
end

local function loseReel(p56) -- line: 1166
    -- upvalues: TweenService (copy), v19 (ref), hideReelArc (copy), v65 (ref), v89 (copy), setHeartbeat (copy), shadowRings (copy), v172 (ref), t27 (ref), resetReelLook (copy)
    if v172 then
        return
    end

    v172 = true
    t27 = nil

    local HarpoonSFX = game:GetService("SoundService"):FindFirstChild("HarpoonSFX")
    local ReelLoop = HarpoonSFX and HarpoonSFX:FindFirstChild("ReelLoop")

    if ReelLoop and ReelLoop.IsPlaying then
        ReelLoop:Stop()
    end

    setHeartbeat(nil)
    v65 = nil

    local v186 = p56 and p56.Circle:FindFirstChild("Trail")

    if v186 then
        for _, child in ipairs(v186:GetChildren()) do
            child.Visible = false
        end
    end

    local Circle = p56.Circle

    hideReelArc(p56)
    require(script.Deadeye).Hide()

    local UIStroke = Circle.Glow.UIStroke

    UIStroke.Color = v89
    UIStroke.Transparency = 0.15

    local Pulse = Circle.Pulse
    local v187 = TweenInfo.new(0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
    local v188 = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.In)

    TweenService:Create(Pulse, v187, {
        Scale = 0
    }):Play()

    local t30 = {
        {
            Circle.Ring.UIStroke,
            "Transparency"
        },
        {
            Circle.RingOutline.UIStroke,
            "Transparency"
        },
        { UIStroke, "Transparency" },
        {
            Circle.Key.UIStroke,
            "Transparency"
        },
        {
            Circle.Key,
            "TextTransparency"
        },
        {
            Circle.NeedleRotator.Arrow,
            "BackgroundTransparency"
        }
    }

    for _, v189 in ipairs((shadowRings(Circle))) do
        t30[#t30 + 1] = { v189, "Transparency" }
    end

    for _, child in ipairs(Circle.Pips:GetChildren()) do
        if child:IsA("Frame") then
            t30[#t30 + 1] = {
                child.UIStroke,
                "Transparency"
            }
            t30[#t30 + 1] = { child, "BackgroundTransparency" }
        end
    end

    for _, child in ipairs(Circle.Hearts:GetChildren()) do
        if child:IsA("ImageLabel") and child.Name ~= "HeartTemplate" then
            t30[#t30 + 1] = { child, "ImageTransparency" }
            t30[#t30 + 1] = {
                child.Shadow,
                "ImageTransparency"
            }
        end
    end

    for _, v190 in ipairs(t30) do
        TweenService:Create(v190[1], v188, {
            [v190[2]] = 1
        }):Play()
    end

    task.delay(0.25, function() -- line: 1204
        -- upvalues: p56 (copy), v19 (ref), v172 (ref), resetReelLook (copy)
        v172 = false

        if p56.Parent then
            resetReelLook(p56)

            if not v19 then
                p56.Circle.Visible = false
            end
        end
    end)
end

local v191 = Color3.fromRGB(70, 74, 88)

local function breakHeart(p57, p58) -- line: 1222
    -- upvalues: TweenService (copy), v191 (copy)
    local UIScale = p58.UIScale

    UIScale.Scale = 1.5
    TweenService:Create(UIScale, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Scale = 0.8
    }):Play()
    p58.Rotation = -14
    TweenService:Create(p58, TweenInfo.new(0.5, Enum.EasingStyle.Elastic, Enum.EasingDirection.Out), {
        Rotation = 0
    }):Play()
    p58.ImageColor3 = Color3.new(1, 1, 1)
    TweenService:Create(p58, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        ImageTransparency = 0.35,
        ImageColor3 = v191
    }):Play()

    local Circle = p57.Circle
    local v192 = p58.AbsolutePosition + p58.AbsoluteSize / 2 - Circle.AbsolutePosition
    local v193 = Random.new()
    local v194 = Circle.AbsoluteSize.X / 170

    for i = 1, 6 do
        local ImageLabel = Instance.new("ImageLabel")

        ImageLabel.Image = p58.Image
        ImageLabel.ScaleType = Enum.ScaleType.Fit
        ImageLabel.BackgroundTransparency = 1
        ImageLabel.AnchorPoint = Vector2.new(0.5, 0.5)
        ImageLabel.Position = UDim2.fromOffset(v192.X, v192.Y)
        ImageLabel.Size = UDim2.fromOffset(14 * v194, 14 * v194)
        ImageLabel.Rotation = v193:NextNumber(-40, 40)
        ImageLabel.ImageColor3 = Color3.fromRGB(255, 96, 96)
        ImageLabel.ZIndex = 12
        ImageLabel.Parent = Circle

        local v195 = (i - 1) * 1.0471975511965976 + v193:NextNumber(-0.4, 0.4)
        local v196 = v193:NextNumber(30, 48) * v194

        TweenService:Create(ImageLabel, TweenInfo.new(v193:NextNumber(0.45, 0.6), Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            ImageTransparency = 1,
            Position = UDim2.fromOffset(v192.X + math.cos(v195) * v196, v192.Y + math.sin(v195) * v196 - 10 * v194),
            Size = UDim2.fromOffset(4 * v194, 4 * v194),
            Rotation = ImageLabel.Rotation + v193:NextNumber(-120, 120)
        }):Play()
        task.delay(0.65, function() -- line: 1257
            -- upvalues: ImageLabel (copy)
            ImageLabel:Destroy()
        end)
    end
end

local function setHearts(p59, p60, p61, _) -- line: 1261
    -- upvalues: setHeartbeat (copy), v191 (copy), breakHeart (copy)
    local Hearts = p59.Circle:FindFirstChild("Hearts")
    local HeartTemplate = Hearts and Hearts:FindFirstChild("HeartTemplate")

    if HeartTemplate then
        Hearts.Visible = p61 > 0

        if Hearts.Visible then
            setHeartbeat(p60)

            local t31 = {}

            for _, child in ipairs(Hearts:GetChildren()) do
                if child:IsA("ImageLabel") and child ~= HeartTemplate then
                    t31[#t31 + 1] = child
                end
            end

            if #t31 ~= p61 then
                for _, v198 in ipairs(t31) do
                    v198:Destroy()
                end

                t31 = {}

                for i = 1, p61 do
                    local clone = HeartTemplate:Clone()

                    clone.Name = "Heart" .. i
                    clone.LayoutOrder = i
                    clone.Visible = true
                    clone.Parent = Hearts
                    t31[i] = clone
                end
            end

            table.sort(t31, function(p63, p64) -- line: 1284
                return p63.LayoutOrder < p64.LayoutOrder
            end)

            for v199, v200 in ipairs(t31) do
                local v201 = v199 <= p60
                local v202 = v200:GetAttribute("Alive") ~= false

                v200:SetAttribute("Alive", v201)

                if v201 then
                    v200.ImageColor3 = Color3.new(1, 1, 1)
                    v200.ImageTransparency = 0
                    v200.UIScale.Scale = 1
                elseif v202 then
                    breakHeart(p59, v200)
                else
                    v200.ImageColor3 = v191
                    v200.ImageTransparency = 0.35
                    v200.UIScale.Scale = 0.8
                end
            end
        else
            setHeartbeat(nil)
        end
    end
end

local t32 = {
    transparency = 0,
    hold = 0.22,
    fade = 0.65
}
local t33 = {
    transparency = 0.2,
    hold = 0.14,
    fade = 0.5
}

local function hideReel(p65) -- line: 1308
    -- upvalues: TweenService (copy), LocalPlayer (copy), v4 (ref), Fire (copy), t2 (copy), v13 (ref), t5 (ref), v19 (ref), t9 (copy), v21 (ref), showLeave (copy), v25 (ref), Versus (copy), v110 (copy), setGlow (copy), setHeartbeat (copy), v172 (ref), t32 (copy), t33 (copy)
    v19 = nil

    if v13 and t5 and not t5.leaving and not v21 then
        showLeave(true)
    end

    if v4 and v13 and t5 and t5.fireBound and not t5.leaving then
        t2.armed(true)

        if v25 ~= true then
            v25 = true

            if v4 then
                local v203 = Fire:FindFirstChild("HoverScale") or Fire:FindFirstChild("PopScale")

                if not v203 then
                    v203 = Instance.new("UIScale")
                    v203.Name = "PopScale"
                    v203.Parent = Fire
                end

                v203.Scale = t9.FROM
                Fire.Visible = true
                TweenService:Create(v203, TweenInfo.new(t9.IN, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                    Scale = 1
                }):Play()
            else
                Fire.Visible = false
            end
        end
    end

    Versus.Stop()

    local PlayerGui = LocalPlayer:FindFirstChild("PlayerGui")
    local HarpoonAimGui = PlayerGui and PlayerGui:FindFirstChild("HarpoonAimGui")

    if HarpoonAimGui then
        HarpoonAimGui.Enabled = v13
    end

    if not v172 then
        local HarpoonSFX = game:GetService("SoundService"):FindFirstChild("HarpoonSFX")
        local ReelLoop = HarpoonSFX and HarpoonSFX:FindFirstChild("ReelLoop")

        if ReelLoop and ReelLoop.IsPlaying then
            ReelLoop:Stop()
        end
    end

    setHeartbeat(nil)

    local PlayerGui2 = LocalPlayer:FindFirstChild("PlayerGui")
    local ReelGui = PlayerGui2 and PlayerGui2:FindFirstChild("ReelGui")

    if not ReelGui then
        return
    end

    if not v172 then
        ReelGui.Circle.Visible = false
    end

    local v204 = p65 == v110 and t32 or t33

    setGlow(p65, v204.transparency, 0.06)
    task.delay(v204.hold, function() -- line: 1323
        -- upvalues: p65 (copy), v204 (copy), setGlow (copy)
        setGlow(p65, 1, v204.fade)
    end)
    task.delay(math.max(0.7, v204.hold + v204.fade), function() -- line: 1326
        -- upvalues: ReelGui (copy), v19 (ref), v172 (ref)
        if not v19 and ReelGui.Parent and not v172 then
            ReelGui.Enabled = false
            ReelGui.Circle.Visible = true
        end
    end)
end

local v206

local function getRefs() -- line: 1336
    -- upvalues: v14 (ref)
    local v207 = v14

    if v207 and v207.Parent then
        local Spear = v207:FindFirstChild("Spear")

        if Spear then
            local TopRotate = v207:FindFirstChild("TopRotate")
            local Barrel = TopRotate and TopRotate:FindFirstChild("Barrel")
            local v208 = Barrel and Barrel:FindFirstChild("Barrel")
            local v209, v210

            if v208 then
                v209 = v208:FindFirstChild("RopeBeamAttatchment")
                v210 = v208:FindFirstChild("RopeBeam")
                v208 = v208:FindFirstChild("SpearSeat")
            else
                v210 = v208
                v209 = v208
            end

            local RestTop = v207:GetAttribute("RestTop")
            local RestBarrelOffset = v207:GetAttribute("RestBarrelOffset")

            if TopRotate and Barrel and v209 and v210 and v208 and RestTop and RestBarrelOffset then
                return {
                    harpoon = v207,
                    spear = Spear,
                    top = TopRotate,
                    barrel = Barrel,
                    muzzleAtt = v209,
                    beam = v210,
                    seat = v208,
                    restTop = RestTop,
                    restBarrelOffset = RestBarrelOffset,
                    floaty = v207.Parent:FindFirstChild("Floaty")
                }
            end
        end
    end

    return nil
end

local function yForwardCF(p66, p67) -- line: 1365
    return CFrame.lookAt(p66, p66 + p67) * CFrame.Angles(-1.5707963267948966, 0, 0)
end

local function setRopeSag(p68, p69, p70, p71) -- line: 1375
    local Attachment0, Attachment1 = p68.Attachment0, p68.Attachment1

    if Attachment0 and Attachment1 then
        local v212 = math.min(10, p69 * (Attachment1.WorldPosition - Attachment0.WorldPosition).Magnitude * 0.3)
        local Unit = Vector3.new(math.sin(p71 * 9) * p70, -1, math.cos(p71 * 7.3) * p70).Unit

        Attachment0.WorldAxis = Unit
        Attachment1.WorldAxis = Unit
        p68.CurveSize0 = v212
        p68.CurveSize1 = -v212
    end
end

local t34 = {}
local v217

local function ensureGlueLoop() -- line: 1391
    -- upvalues: RunService (copy), setRopeSag (copy), t34 (copy), v217 (ref)
    v217 = v217 or RunService.RenderStepped:Connect(function() -- line: 1393
        -- upvalues: setRopeSag (copy), t34 (copy), v217 (ref)
        local v218 = false

        for v219, v220 in pairs(t34) do
            local v221 = v220.Parent and v220:GetAttribute("Spears")

            if not v219.Parent or not v220.Parent or v220:GetAttribute("Hooked") == nil then
                t34[v219] = nil
            elseif not v221 or table.find(v221:split(","), v219.Parent.Name) then
                local Spear = v219:FindFirstChild("Spear")
                local PrimaryPart = v220.PrimaryPart or v220:FindFirstChildWhichIsA("BasePart")
                local TopRotate = v219:FindFirstChild("TopRotate")

                TopRotate = TopRotate and TopRotate:FindFirstChild("Barrel")
                TopRotate = TopRotate and TopRotate:FindFirstChild("Barrel")

                local RopeBeamAttatchment = TopRotate and TopRotate:FindFirstChild("RopeBeamAttatchment")

                if Spear and PrimaryPart and RopeBeamAttatchment then
                    local v224 = PrimaryPart.Position - RopeBeamAttatchment.WorldPosition

                    if v224.Magnitude >= 1.5 then
                        local Unit = v224.Unit
                        local v225 = PrimaryPart.Position - Unit * 1.3

                        Spear:PivotTo(CFrame.lookAt(v225, v225 + Unit) * CFrame.Angles(-1.5707963267948966, 0, 0))
                    end

                    local RopeBeam = TopRotate:FindFirstChild("RopeBeam")

                    if RopeBeam then
                        setRopeSag(RopeBeam, 0.12, 0.05, os.clock())
                    end
                end

                v218 = true
            else
                t34[v219] = nil
            end
        end

        if v218 then
            return
        end

        v217:Disconnect()
        v217 = nil
    end)
end

local function glueArrival(p72) -- line: 1430
    -- upvalues: RunService (copy), v14 (ref), setRopeSag (copy), t34 (copy), v217 (ref)
    local Spears = p72:GetAttribute("Spears")

    if Spears and p72:GetAttribute("Hooked") then
        local Plots = workspace:FindFirstChild("Plots")

        for match in Spears:gmatch("[^,]+") do
            local v226 = Plots and Plots:FindFirstChild(match)
            local Harpoon = v226 and v226:FindFirstChild("Harpoon")

            if Harpoon and Harpoon ~= v14 then
                t34[Harpoon] = p72
            end
        end

        v217 = v217 or RunService.RenderStepped:Connect(function() -- line: 1393
            -- upvalues: setRopeSag (copy), t34 (copy), v217 (ref)
            local v227 = false

            for v228, v229 in pairs(t34) do
                local v230 = v229.Parent and v229:GetAttribute("Spears")

                if not v228.Parent or not v229.Parent or v229:GetAttribute("Hooked") == nil then
                    t34[v228] = nil
                elseif not v230 or table.find(v230:split(","), v228.Parent.Name) then
                    local Spear = v228:FindFirstChild("Spear")
                    local PrimaryPart = v229.PrimaryPart or v229:FindFirstChildWhichIsA("BasePart")
                    local TopRotate = v228:FindFirstChild("TopRotate")

                    TopRotate = TopRotate and TopRotate:FindFirstChild("Barrel")
                    TopRotate = TopRotate and TopRotate:FindFirstChild("Barrel")

                    local RopeBeamAttatchment = TopRotate and TopRotate:FindFirstChild("RopeBeamAttatchment")

                    if Spear and PrimaryPart and RopeBeamAttatchment then
                        local v233 = PrimaryPart.Position - RopeBeamAttatchment.WorldPosition

                        if v233.Magnitude >= 1.5 then
                            local Unit = v233.Unit
                            local v234 = PrimaryPart.Position - Unit * 1.3

                            Spear:PivotTo(CFrame.lookAt(v234, v234 + Unit) * CFrame.Angles(-1.5707963267948966, 0, 0))
                        end

                        local RopeBeam = TopRotate:FindFirstChild("RopeBeam")

                        if RopeBeam then
                            setRopeSag(RopeBeam, 0.12, 0.05, os.clock())
                        end
                    end

                    v227 = true
                else
                    t34[v228] = nil
                end
            end

            if v227 then
                return
            end

            v217:Disconnect()
            v217 = nil
        end)
    end
end

task.spawn(function() -- line: 1441
    -- upvalues: glueArrival (copy)
    workspace:WaitForChild("Fish").ChildAdded:Connect(glueArrival)
end)

local t35 = {}
local v235

local function drawFlights() -- line: 1449
    -- upvalues: ReplicatedStorage (copy), HarpoonConfig (copy), v14 (ref), v59 (copy), t34 (copy), t35 (copy), v235 (ref)
    local v236 = v59()
    local v237 = false

    for v238, v239 in pairs(t35) do
        local v240 = v238.Parent and v238:FindFirstChild("Spear")
        local TopRotate = v238:FindFirstChild("TopRotate")
        local Barrel = TopRotate and TopRotate:FindFirstChild("Barrel")
        local Barrel2 = Barrel and Barrel:FindFirstChild("Barrel")
        local SpearSeat = Barrel2 and Barrel2:FindFirstChild("SpearSeat")

        if v240 then
            if not SpearSeat or v238 == v14 or t34[v238] then
                t35[v238] = nil
                require(ReplicatedStorage.Modules.HarpoonFx).SetFlight(v240, false)
            elseif v238:GetAttribute("Flight") == v239.id then
                local v241 = v239.hit - v239.from
                local Magnitude = v241.Magnitude
                local v242 = Magnitude > 0.01 and v241 / Magnitude or Vector3.new(0, 1, 0)
                local v243 = v236 - v239.t0
                local v244 = Magnitude / HarpoonConfig.SpearSpeed
                local v245 = v244 + (v239.didHit and HarpoonConfig.StickTime or 0)

                if not v239.fxOff and v244 <= v243 then
                    v239.fxOff = true
                    require(ReplicatedStorage.Modules.HarpoonFx).SetFlight(v240, false)
                end

                if v239.didHit and not v239.landed and v244 <= v243 then
                    v239.landed = true

                    if v243 < v245 then
                        require(script.WallHit).Play(v239.hit, v242)
                    end
                end

                if v243 < v244 then
                    local v247 = v239.from:Lerp(v239.hit, (math.max(0, v243 / v244)))

                    v240:PivotTo(CFrame.lookAt(v247, v247 + v242) * CFrame.Angles(-1.5707963267948966, 0, 0))
                elseif v243 < v245 then
                    local hit = v239.hit

                    v240:PivotTo(CFrame.lookAt(hit, hit + v242) * CFrame.Angles(-1.5707963267948966, 0, 0))
                else
                    local WorldCFrame = SpearSeat.WorldCFrame
                    local v248 = WorldCFrame.Position - v239.hit
                    local v249 = HarpoonConfig.ReturnSpeed * (v243 - v245)

                    if v248.Magnitude <= v249 then
                        v240:PivotTo(WorldCFrame)
                        t35[v238] = nil
                    else
                        local v250 = CFrame.new(v239.hit + v248.Unit * v249)
                        local hit = v239.hit

                        v240:PivotTo(v250 * (CFrame.lookAt(hit, hit + v242) * CFrame.Angles(-1.5707963267948966, 0, 0)).Rotation)
                    end
                end

                v237 = true
            else
                t35[v238] = nil
                require(ReplicatedStorage.Modules.HarpoonFx).SetFlight(v240, false)
            end
        else
            t35[v238] = nil
        end
    end

    if v237 or not v235 then
        return
    end

    v235:Disconnect()
    v235 = nil
end

local function watchStation(p73) -- line: 1501
    -- upvalues: ReplicatedStorage (copy), RunService (copy), v14 (ref), t35 (copy), v235 (ref), drawFlights (copy)
    p73:GetAttributeChangedSignal("Flight"):Connect(function() -- line: 1502
        -- upvalues: p73 (copy), ReplicatedStorage (copy), RunService (copy), v14 (ref), t35 (copy), v235 (ref), drawFlights (copy)
        if p73 == v14 then
            return
        end

        local FlightFrom = p73:GetAttribute("FlightFrom")
        local FlightHit = p73:GetAttribute("FlightHit")
        local FlightT0 = p73:GetAttribute("FlightT0")

        if typeof(FlightFrom) ~= "Vector3" or typeof(FlightHit) ~= "Vector3" or type(FlightT0) ~= "number" then
            return
        end

        t35[p73] = {
            from = FlightFrom,
            hit = FlightHit,
            t0 = FlightT0,
            didHit = p73:GetAttribute("FlightDidHit") == true,
            id = p73:GetAttribute("Flight")
        }
        require(ReplicatedStorage.Modules.HarpoonFx).SetFlight(p73:FindFirstChild("Spear"), true)
        v235 = v235 or RunService.RenderStepped:Connect(drawFlights)
    end)
end

task.spawn(function() -- line: 1512
    -- upvalues: ReplicatedStorage (copy), RunService (copy), v14 (ref), t35 (copy), v235 (ref), drawFlights (copy)
    local Plots = workspace:WaitForChild("Plots")

    local function plotAdded(p74) -- line: 1514
        -- upvalues: ReplicatedStorage (copy), RunService (copy), v14 (ref), t35 (copy), v235 (ref), drawFlights (copy)
        local v251 = p74:FindFirstChild("Harpoon") or p74:WaitForChild("Harpoon", 30)

        if v251 then
            v251:GetAttributeChangedSignal("Flight"):Connect(function() -- line: 1502
                -- upvalues: v251 (copy), ReplicatedStorage (copy), RunService (copy), v14 (ref), t35 (copy), v235 (ref), drawFlights (copy)
                if v251 == v14 then
                    return
                end

                local FlightFrom = v251:GetAttribute("FlightFrom")
                local FlightHit = v251:GetAttribute("FlightHit")
                local FlightT0 = v251:GetAttribute("FlightT0")

                if typeof(FlightFrom) ~= "Vector3" or typeof(FlightHit) ~= "Vector3" or type(FlightT0) ~= "number" then
                    return
                end

                t35[v251] = {
                    from = FlightFrom,
                    hit = FlightHit,
                    t0 = FlightT0,
                    didHit = v251:GetAttribute("FlightDidHit") == true,
                    id = v251:GetAttribute("Flight")
                }
                require(ReplicatedStorage.Modules.HarpoonFx).SetFlight(v251:FindFirstChild("Spear"), true)
                v235 = v235 or RunService.RenderStepped:Connect(drawFlights)
            end)
        end
    end

    for _, child in ipairs(Plots:GetChildren()) do
        task.spawn(plotAdded, child)
    end

    Plots.ChildAdded:Connect(plotAdded)
end)

local function anglesTo(p75, p76) -- line: 1527
    -- upvalues: HarpoonConfig (copy)
    local v252 = p75.restTop * p75.restBarrelOffset
    local v253 = p76 - v252.Position

    if v253.Magnitude <= 2 then
        return nil
    end

    local Unit = v253.Unit
    local YVector = v252.YVector
    local v254 = Vector3.new(YVector.X, 0, YVector.Z)
    local v255 = Vector3.new(Unit.X, 0, Unit.Z)

    if v254.Magnitude <= 1E-04 or v255.Magnitude <= 1E-04 then
        return nil
    end

    local Unit2 = v254.Unit
    local Unit3 = v255.Unit
    local v256 = if p75.restTop.ZVector.Y >= 0 then 1 else -1
    local v259 = math.deg((math.atan2(Unit2:Cross(Unit3).Y, (Unit2:Dot(Unit3))))) * v256
    local v262 = math.deg((math.asin((math.clamp(YVector.Y, -1, 1)))))
    local v265 = math.deg((math.asin((math.clamp(Unit.Y, -1, 1)))))

    return math.clamp(v259, -HarpoonConfig.YawRange, HarpoonConfig.YawRange), (math.clamp(v262 - v265, -HarpoonConfig.PitchUpMax, HarpoonConfig.PitchDownMax))
end

local function nearestFish(p77) -- line: 1558
    -- upvalues: LocalPlayer (copy), HarpoonConfig (copy), FishDisplay (copy), t1 (copy), t5 (ref), Fish (ref)
    if not (t5 and t5.lookDir and Fish) then
        return nil
    end

    local RarityBias = HarpoonConfig.Assist.RarityBias
    local n12 = 1e999
    local child

    for _, child2 in ipairs(Fish:GetChildren()) do
        local PrimaryPart = child2.PrimaryPart
        local v270 = child2:GetAttribute("Hooked") == nil or child2:GetAttribute("Contestable") == true and child2:GetAttribute("Landing") == nil and child2:GetAttribute("OnlyFor") == nil and child2:GetAttribute("HookedBy") ~= LocalPlayer.UserId

        if PrimaryPart and PrimaryPart.CanQuery and v270 and child2:GetAttribute("PenOwner") == nil then
            local v271 = PrimaryPart.Position - t5.eyePos
            local Magnitude = v271.Magnitude

            if Magnitude > 1 and Magnitude <= HarpoonConfig.SpearRange then
                local v275 = math.deg((math.acos((math.clamp(v271:Dot(t5.lookDir) / Magnitude, -1, 1)))))

                if v275 < (child2:GetAttribute("OnlyFor") == LocalPlayer.UserId and p77 * (HarpoonConfig.Assist.LeviathanSnap or 1) or p77) then
                    local v276 = FishDisplay[child2.Name]
                    local v277 = v275 - ((v276 and t1[v276.rarity] or 0) - 1) * RarityBias

                    if v277 < n12 then
                        n12 = v277
                        child = child2
                    end
                end
            end
        end
    end

    return child
end

local v278 = RaycastParams.new()

v278.FilterType = Enum.RaycastFilterType.Include

local function snapPoint(p78, p79) -- line: 1593
    -- upvalues: v278 (copy)
    local PrimaryPart = p78.PrimaryPart

    v278.FilterDescendantsInstances = { PrimaryPart }

    local CFrame, Size = PrimaryPart.CFrame, PrimaryPart.Size
    local t38 = {
        {
            Vector3.new(1, 0, 0),
            Size.X
        },
        {
            Vector3.new(0, 1, 0),
            Size.Y
        },
        {
            Vector3.new(0, 0, 1),
            Size.Z
        }
    }

    table.sort(t38, function(p80, p81) -- line: 1598
        return p80[2] > p81[2]
    end)

    local v279 = t38[1][1] * (t38[1][2] / 2)
    local v280 = t38[2][1] * (t38[2][2] / 2)

    for _, v281 in ipairs({
            Vector3.new(0, 0, 0),
            v279 * 0.25,
            -v279 * 0.25,
            v280 * 0.25,
            -v280 * 0.25,
            v279 * 0.45,
            -v279 * 0.45
        }) do
        local v282 = CFrame:PointToWorldSpace(v281) - p79
        local v283 = workspace:Raycast(p79, v282.Unit * (v282.Magnitude + Size.Magnitude), v278)

        if v283 then
            return v283.Position
        end
    end

    return PrimaryPart.Position
end

local function updateFov(p82) -- line: 1611
    -- upvalues: LocalPlayer (copy), HarpoonConfig (copy), t8 (copy)
    local Fov = HarpoonConfig.Fov
    local v284

    if t8.diveT0 then
        local Dive = HarpoonConfig.Dive
        local v286 = math.clamp((workspace:GetServerTimeNow() - t8.diveT0 - Dive.Charge) / Dive.Air, 0, 1)
        local v287 = t8.diveEnd and math.min(1, (os.clock() - t8.diveEnd) / Dive.CamBlend) or 0

        v284 = Fov.Dive * (1 - (1 - v286) ^ 2) * (1 - v287) ^ 3

        if v287 >= 1 then
            t8.diveT0 = nil
        end
    else
        v284 = 0
    end

    local settle = t8.settle

    t8.cur = t8.cur + (settle - t8.cur) * math.min(1, p82 * Fov.Ease)

    if math.abs(settle - t8.cur) < 0.02 then
        t8.cur = settle
    end

    t8.kick = t8.kick * math.exp(-Fov.PopDecay * p82)

    if math.abs(t8.kick) < 0.02 then
        t8.kick = 0
    end

    if not LocalPlayer:GetAttribute("Cinematic") and not LocalPlayer:GetAttribute("MenuZoom") then
        if LocalPlayer:GetAttribute("SetReduceFx") == true then
            workspace.CurrentCamera.FieldOfView = t8.base
        else
            workspace.CurrentCamera.FieldOfView = t8.base + v284 + t8.cur + t8.kick + (LocalPlayer:GetAttribute("FovAdd") or 0) + (LocalPlayer:GetAttribute("FovAddChest") or 0) + (LocalPlayer:GetAttribute("FovAddTitan") or 0)
        end
    end

    if t8.diveT0 == nil and t8.kick == 0 and t8.cur == 0 and settle == 0 and LocalPlayer:GetAttribute("FovAdd") == nil and LocalPlayer:GetAttribute("FovAddChest") == nil then
        return LocalPlayer:GetAttribute("FovAddTitan") == nil
    end

    return false
end

local function onRender(p83) -- line: 1647
    -- upvalues: ReplicatedStorage (copy), UserInputService (copy), UserGameSettings (copy), LocalPlayer (copy), MutationDisplay (copy), HarpoonConfig (copy), TitanConfig (copy), TitanBody (copy), v4 (ref), t2 (copy), HarpoonAim (copy), t4 (copy), v13 (ref), v14 (ref), t5 (ref), v15 (ref), v16 (ref), v17 (ref), v18 (ref), t6 (ref), t7 (ref), n1 (ref), v19 (ref), Fish (ref), t8 (copy), v59 (copy), v65 (ref), v66 (copy), v107 (copy), v109 (copy), v111 (copy), setGlow (copy), updateSpread (copy), hitMark (copy), revealGlow (copy), n9 (ref), t25 (copy), n10 (ref), v172 (ref), t27 (ref), v206 (ref), getRefs (copy), setRopeSag (copy), anglesTo (copy), updateFov (copy)
    local v293 = math.min(p83, 0.05)
    local v294 = updateFov(v293)
    local v295 = getRefs()

    if not v295 then
        if v294 and not v13 and v15 == "seated" and n1 == 0 and v206 then
            v206:Disconnect()
            v206 = nil
        end
    else
        local SetSensitivity = v13
        local TouchSmoothing, YawRange, PitchUpMax, CamBack, CamRight, result, v296, v297, Position, v298, v299

        if not (SetSensitivity and v14) then
            v296 = t7

            if v296 then
                v299 = t7.barrelLockedCF
            end

            if not v296 or not v299 then
                v299 = v295.barrel:GetPivot()
            end
        else
            if not v14.Parent then
                stopAiming()

                return
            end

            v296 = LocalPlayer:GetAttribute("AimFree") and Enum.MouseBehavior.Default or Enum.MouseBehavior.LockCenter
            UserInputService.MouseBehavior = v296
            SetSensitivity = LocalPlayer:GetAttribute("SetSensitivity")
            v296 = HarpoonConfig.Sensitivity * (if type(SetSensitivity) ~= "number" or not SetSensitivity then 1 else SetSensitivity)

            local CameraYInvertValue = UserGameSettings:GetCameraYInvertValue()

            YawRange = v4

            if YawRange then
                TouchSmoothing = HarpoonConfig.TouchSmoothing
            end

            if not YawRange or not TouchSmoothing then
                TouchSmoothing = HarpoonConfig.Smoothing
            end

            YawRange = HarpoonConfig.YawRange

            local PitchDownMax = HarpoonConfig.PitchDownMax

            PitchUpMax = HarpoonConfig.PitchUpMax
            CamBack = HarpoonConfig.CamBack

            local CamUp = HarpoonConfig.CamUp

            CamRight = HarpoonConfig.CamRight

            local Pad, ok, v300, v301, v302, v303

            if v15 == "seated" then
                local zero = LocalPlayer:GetAttribute("AimFree") and Vector2.zero or UserInputService:GetMouseDelta()
                local t39 = t5

                v302 = t5.targetYaw + zero.X * v296
                t39.targetYaw = math.clamp(v302, -YawRange, YawRange)
                t39 = t5
                v302 = t5.targetPitch + zero.Y * v296 * CameraYInvertValue
                t39.targetPitch = math.clamp(v302, -PitchUpMax, PitchDownMax)

                if t2.mode.Pad() and t2.stick.Magnitude > 0 then
                    Pad = HarpoonConfig.Pad

                    result = function() -- line: 1689
                        -- upvalues: UserGameSettings (copy)
                        return UserGameSettings.GamepadCameraSensitivity
                    end

                    ok, result = pcall(result)
                    v303 = type(SetSensitivity) == "number" and SetSensitivity or 1
                    v300 = if ok and type(result) == "number" and result > 0 and result then result else 1
                    v302 = v303 * v300
                    v303 = t5

                    local v305 = t5.targetYaw + t2.curve(t2.stick.X) * Pad.YawSpeed * v302 * v293

                    v301 = -YawRange
                    v303.targetYaw = math.clamp(v305, v301, YawRange)
                    v303 = t5
                    v305 = t5.targetPitch - t2.curve(t2.stick.Y) * Pad.PitchSpeed * v302 * v293 * CameraYInvertValue
                    v301 = -PitchUpMax
                    v303.targetPitch = math.clamp(v305, v301, PitchDownMax)
                end

                v302 = v293 * TouchSmoothing
                ok = math.min(1, v302)
                result = t5
                result.yaw += (t5.targetYaw - t5.yaw) * ok
                result = t5
                result.pitch += (t5.targetPitch - t5.pitch) * ok
            elseif v15 == "hooked" and v17 and v17.Parent then
                if not v17:GetAttribute("Landing") and not require(script.LocalFight).Landing() then
                    Pad, ok = anglesTo(v295, v17:GetPivot().Position)

                    if Pad then
                        result = t5
                        result.targetYaw = Pad
                        result = t5
                        result.targetPitch = ok
                    end
                end

                result = v293 * 7
                Pad = math.min(1, result)
                ok = t5
                ok.yaw += (t5.targetYaw - t5.yaw) * Pad
                ok = t5
                ok.pitch += (t5.targetPitch - t5.pitch) * Pad
            elseif v15 == "titan" then
                Pad = require(script.TitanFight).Target(v14)

                if Pad then
                    v302, v303 = anglesTo(v295, Pad)
                end

                if v302 then
                    t5.targetYaw = v302
                    v302 = t5
                    v302.targetPitch = v303
                end

                v303 = v293 * 5
                result = math.min(1, v303)
                v302 = t5
                v302.yaw += (t5.targetYaw - t5.yaw) * result
                v302 = t5
                v302.pitch += (t5.targetPitch - t5.pitch) * result
            end

            YawRange = v295.restTop * CFrame.Angles(0, 0, (math.rad(t5.yaw)))
            v295.top:PivotTo(YawRange)
            CameraYInvertValue = (v295.restTop * v295.restBarrelOffset).YVector
            v296 = YawRange.Rotation * v295.restTop.Rotation:Inverse() * CameraYInvertValue
            Pad = v296:Cross((Vector3.new(0, 1, 0)))

            local Unit = Pad.Magnitude > 1E-04 and Pad.Unit or Vector3.new(0, 0, 1)

            CameraYInvertValue = CFrame.fromAxisAngle(Unit, -math.rad(t5.pitch)) * v296
            v296 = YawRange * v295.restBarrelOffset
            YawRange = Unit:Cross(CameraYInvertValue).Unit
            SetSensitivity = v296.Position - CameraYInvertValue * CamBack + YawRange * CamUp + Unit * CamRight
            CamRight = CFrame.lookAt(SetSensitivity, SetSensitivity + CameraYInvertValue)
            Unit = t5.blendT0

            if Unit then
                result = (os.clock() - t5.blendT0) / HarpoonConfig.Dive.CamBlend
                v297 = math.min(1, result)
            end

            if not Unit or not v297 then
                v297 = 1
            end

            if v297 < 1 and t5.fromCF then
                CamRight = t5.fromCF:Lerp(CamRight, 1 - (1 - v297) ^ 3)
            end

            CamUp = CFrame.identity

            local v306 = if LocalPlayer:GetAttribute("SetReduceFx") == true then CamUp else (LocalPlayer:GetAttribute("CamShake") or CFrame.identity) * (LocalPlayer:GetAttribute("CamShakeChest") or CFrame.identity) * (LocalPlayer:GetAttribute("CamShakeTitan") or CFrame.identity)

            if not LocalPlayer:GetAttribute("Cinematic") then
                workspace.CurrentCamera.CFrame = CamRight * v306
            end

            t5.rayParams.FilterDescendantsInstances = {
                v295.harpoon,
                LocalPlayer.Character,
                v295.spear,
                v295.floaty
            }
            CamRight = workspace:Raycast(SetSensitivity, CameraYInvertValue * 500, t5.rayParams)

            if CamRight then
                Position = CamRight.Position
            end

            if not CamRight or not Position then
                Position = SetSensitivity + CameraYInvertValue * 500
            end

            v297 = t5
            v297.lastTargetPoint = Position
            v297 = t5
            v297.lastRayHit = CamRight ~= nil
            v297 = t5

            local v307 = t5

            v297.eyePos = SetSensitivity
            v307.lookDir = CameraYInvertValue
            CamBack = CamRight and CamRight.Instance:FindFirstAncestorOfClass("Model")
            v307 = v15 == "seated" and CamBack ~= nil and CamBack.Parent == Fish
            t8.hover = v307
            CamRight = (Position - v296.Position):Dot(CameraYInvertValue)

            if not (CamRight >= 12) or not Position then
                Position += CameraYInvertValue * (12 - CamRight)
            end

            CamRight = v296:VectorToObjectSpace((Position - v296.Position).Unit)
            v302 = CamRight.Z
            v303 = CamRight.Y
            result = math.atan2(v302, v303)
            v307 = math.deg(result)
            result = -PitchUpMax
            v297 = math.clamp(v307, result, PitchDownMax)
            CamRight = HarpoonConfig.ConvergeSpeed
            Unit = t5
            result = t5.barrelPitch

            if result then
                local barrelPitch = t5.barrelPitch

                v303 = v297 - t5.barrelPitch
                v301 = v293 * CamRight
                v298 = barrelPitch + v303 * math.min(1, v301)
            end

            if result and v298 then
                v297 = v298
            end

            Unit.barrelPitch = v297
            v297 = CFrame.Angles
            result = t5.barrelPitch
            v299 = v296 * v297(math.rad(result), 0, 0)
            v297 = t5
            v297.sendClock += v293

            if t5.sendClock >= 0.06666666666666667 then
                v297 = t5
                v297.sendClock = 0
                HarpoonAim:FireServer(t5.yaw, t5.barrelPitch)
            end
        end

        if n1 > 0 then
            SetSensitivity = HarpoonConfig.RecoilRecover
            v296 = n1
            TouchSmoothing = -SetSensitivity * v293
            n1 = v296 * math.exp(TouchSmoothing)

            if n1 < 0.005 then
                n1 = 0
            end
        end

        if v13 or t7 then
            v295.barrel:PivotTo(v299 * CFrame.new(0, -n1, 0))
        end

        if v13 then
            updateSpread(v293, t8.hover)
        end

        local v308, v309, v310

        if v15 == "seated" then
            if v13 then
                v295.spear:PivotTo(v295.seat.WorldCFrame)
            end
        elseif v15 == "hooked" then
            v299 = v17

            if v299 and v299.Parent and not v299:GetAttribute("GoneAt") then
                v295.beam.Enabled = true
                SetSensitivity = v299:GetPivot().Position
                v296 = SetSensitivity - v295.muzzleAtt.WorldPosition

                if v296.Magnitude < 1.5 then
                    v295.spear:PivotTo(v295.seat.WorldCFrame)
                else
                    v310 = v296.Unit
                    v308 = v295.spear
                    PitchUpMax = SetSensitivity - v310 * 1.3
                    v308:PivotTo(CFrame.lookAt(PitchUpMax, PitchUpMax + v310) * CFrame.Angles(-1.5707963267948966, 0, 0))
                end
            else
                v295.spear:PivotTo(v295.seat.WorldCFrame)
                v295.beam.Enabled = false
                v15 = "seated"
                v17 = nil
                t7 = nil
            end
        elseif t7 then
            SetSensitivity = t7
            SetSensitivity.clock += v293
            SetSensitivity = HarpoonConfig.StickTime

            if v15 == "fly" then
                v296 = t7.flightTime

                if v296 > 0 then
                    YawRange = t7.clock / v296
                    v310 = math.min(1, YawRange) or 1
                else
                    v310 = 1
                end

                v296 = t7.titan

                if v296 then
                    v308 = TitanBody.Point(v296.rise, TitanConfig.Now(), v296.u, v296.angle)
                end

                if not v296 or not v308 then
                    v308 = t7.hitPoint
                end

                YawRange = v295.spear
                CamBack = t7.startPos:Lerp(v308, v310)
                Position = t7.dir
                YawRange:PivotTo(CFrame.lookAt(CamBack, CamBack + Position) * CFrame.Angles(-1.5707963267948966, 0, 0))

                if v310 >= 1 then
                    require(ReplicatedStorage.Modules.HarpoonFx).SetFlight(v295.spear, false)

                    if v296 then
                        v15 = "titanWait"
                        t7.clock = 0
                        v308 = game:GetService("SoundService"):FindFirstChild("HarpoonSFX")

                        local v311 = v308 and v308:FindFirstChild("FishHitSound")

                        if v311 then
                            v311:Play()
                        end

                        hitMark()
                    elseif v17 then
                        v15 = "hooked"
                        t7.clock = 0

                        local v312 = game:GetService("SoundService"):FindFirstChild("HarpoonSFX")

                        v309 = v312 and v312:FindFirstChild("FishHitSound")

                        if v309 then
                            v309:Play()
                        end

                        hitMark()
                        require(script.HitFx).Play(v14, v17)
                        v312 = v17:GetAttribute("Cracked")
                        v309 = v17
                        v309:SetAttribute("LocalHit", os.clock())

                        if not v312 then
                            revealGlow(v18)
                        end
                    elseif t7.didHit then
                        v15 = "stick"
                        t7.clock = 0
                        require(script.WallHit).Play(t7.hitPoint, t7.dir)
                    else
                        v16(v295, t4)
                    end
                end
            elseif v15 == "snap" then
                v308 = t7.clock / t7.snapTime
                v296 = math.min(1, v308)
                v310 = 1 - (1 - v296) ^ 3
                v308 = v295.seat.WorldCFrame

                local startPos = t7.startPos

                v309 = t7.fling
                PitchUpMax = v308.Position
                CamBack = PitchUpMax + v308.YVector * t7.approach
                Position = 1 - v310
                CamRight = startPos * (Position * Position * Position) + v309 * (Position * 3 * Position * v310) + CamBack * (Position * 3 * v310 * v310) + PitchUpMax * (v310 * v310 * v310)
                result = v296 / 0.6
                v297 = math.min(1, result)
                CamBack = t7.spinTurns * 3.141592653589793 * 2 * (1 - (1 - v297) ^ 2)
                Position = CFrame.fromAxisAngle(t7.spinAxis, CamBack) * t7.startRot
                v298 = (v296 - 0.35) / 0.4
                v297 = math.clamp(v298, 0, 1)
                PitchUpMax = v297 * v297 * (3 - v297 * 2)
                v295.spear:PivotTo(CFrame.new(CamRight) * Position:Lerp(v308.Rotation, PitchUpMax))

                if v296 >= 1 then
                    v295.spear:PivotTo(v308)
                    v295.beam.Enabled = false
                    v15 = "seated"
                    t7 = nil
                end
            elseif v15 == "stick" then
                if SetSensitivity <= t7.clock then
                    v16(v295, t4)
                end
            elseif v15 == "titanWait" then
                v296 = t7.titan
                v310, v308 = TitanBody.SpearEnds(v295.spear)

                if t7.clock >= 1 or not v310 then
                    v16(v295, t4)
                else
                    v295.spear:PivotTo((TitanBody.Spear(v296.rise, TitanConfig.Now(), v296.u, v296.angle, v310, v308)))
                end
            end
        end

        if v295.beam.Enabled then
            if v15 == "snap" and t7 and t7.flare then
                SetSensitivity = 1
                v296 = 0.6
            elseif v15 == "snap" then
                SetSensitivity = 0.1
                v296 = 0.03
            elseif v15 == "fly" then
                SetSensitivity = 0.04
                v296 = 0.03
            elseif v15 == "stick" then
                SetSensitivity = 0.15
                v296 = 0.05
            elseif v15 == "hooked" then
                SetSensitivity = 0.12
                v296 = 0.05
            else
                SetSensitivity = 0.2
                v296 = 0
            end

            setRopeSag(v295.beam, SetSensitivity, v296, os.clock())
        end

        local v313, v314, v315

        if t27 then
            local t40 = t27

            v310 = v59() - t40.t0

            local v316 = math.min(0.45, v310)

            v310 = LocalPlayer:FindFirstChild("PlayerGui")
            v313 = v310 and v310:FindFirstChild("ReelGui")

            if v313 then
                v66(v313, (t40.a0 + t40.v * v316 - t40.v * v316 * v316 / 0.9) % 360)
            end

            v310 = math.abs(t40.v) * (1 - v316 / 0.45)
            v309 = t40.base

            if not v309 then
                PitchUpMax = t40.v
                v309 = math.abs(PitchUpMax)
            end

            v315 = v310 / math.max(v309, 1)
            v309 = game:GetService("SoundService"):FindFirstChild("HarpoonSFX")

            local baseSpeed = v309 and v309:FindFirstChild("ReelLoop")

            if baseSpeed then
                PitchUpMax = v315 or 1
                baseSpeed.PlaybackSpeed = math.clamp(PitchUpMax, 0.8, 1.2)

                if not baseSpeed.IsPlaying then
                    baseSpeed:Play()
                end
            end

            if v316 >= 0.45 then
                t27 = nil
                v315 = game:GetService("SoundService"):FindFirstChild("HarpoonSFX")
                v314 = v315 and v315:FindFirstChild("ReelLoop")

                if v314 and v314.IsPlaying then
                    v314:Stop()
                end

                v65 = nil
                v315 = v313 and v313.Circle:FindFirstChild("Trail")

                if v315 then
                    for _, child in ipairs(v315:GetChildren()) do
                        child.Visible = false
                    end
                end
            end
        elseif v19 then
            local v317 = not require(script.TitanFight).Stunned(v19, v59())

            v308 = v19.v1
            v314 = math.abs(v308)

            local baseSpeed = v19.baseSpeed

            if not baseSpeed then
                v309 = v19.v1
                baseSpeed = math.abs(v309)
            end

            v313 = v314 / math.max(baseSpeed, 1)
            v308 = game:GetService("SoundService"):FindFirstChild("HarpoonSFX")
            v314 = v308 and v308:FindFirstChild("ReelLoop")

            if v314 then
                if v317 then
                    baseSpeed = v313 or 1
                    v314.PlaybackSpeed = math.clamp(baseSpeed, 0.8, 1.2)

                    if not v314.IsPlaying then
                        v314:Play()
                    end
                elseif v314.IsPlaying then
                    v314:Stop()
                end
            end

            v313 = LocalPlayer:FindFirstChild("PlayerGui")

            local ReelGui = v313 and v313:FindFirstChild("ReelGui")

            if ReelGui then
                v313 = v59()
                v314 = v19
                v314.drawnAt = v313
                baseSpeed = v313 - v19.time0
                v314 = math.max(0, baseSpeed)
                v315 = if v314 < v19.ramp then v19.angle0 + v19.v0 * v314 + (v19.v1 - v19.v0) * v314 * v314 / (2 * v19.ramp) else v19.angle0 + (v19.v0 + v19.v1) * v19.ramp / 2 + v19.v1 * (v314 - v19.ramp)
                v66(ReelGui, v315 % 360)
            end
        end

        local v318, v319, v320, v321, v322

        if t6 then
            v313 = LocalPlayer:FindFirstChild("PlayerGui")

            local ReelGui = v313 and v313:FindFirstChild("ReelGui")

            v313 = ReelGui and ReelGui:FindFirstChild("Reveal")
            v322 = os.clock() - t6.t0

            local v323

            if v313 then
                if v322 >= 1.8 then
                    v323 = false
                    v313.UIStroke.Transparency = 1
                else
                    v323 = true
                end
            else
                v323 = false
            end

            if v323 then
                v319 = v322 / 1.8
                v313.UIStroke.UIGradient.Rotation = (1 - (1 - v319) ^ 3) * 360 * 1.25
                v313.UIStroke.Transparency = 0.3 + 0.7 * v319 * v319

                if t6.info.cycle and ReelGui then
                    v319 = Color3.fromHSV(os.clock() * 0.4 % 1, 0.75, 1)
                    v320 = ReelGui.Vignette:FindFirstChild("Glow")

                    if v320 then
                        v320.ImageColor3 = v319
                    end
                end
            else
                t6 = nil
                v315 = v19

                local v324 = false
                local v325 = false
                local v326 = false
                local v327 = false
                local v328 = false
                local v329 = false

                if v315 then
                    v324 = true
                else
                    v329 = true
                end

                if v324 then
                    if v19 then
                        v326 = true
                    else
                        v325 = true
                    end
                end

                v324 = false

                if v325 then
                    v319 = v107
                    v320 = 0.6
                    v329 = false
                end

                v325 = false

                if v326 then
                    if v19.pvp then
                        v324 = true
                    else
                        v325 = true
                    end
                end

                v326 = false

                if v325 then
                    if v19 then
                        v326 = true
                    else
                        v327 = true
                    end
                end

                v325 = false

                if v326 then
                    if v19.pvp then
                        v327 = true
                    else
                        v325 = true
                    end
                end

                v326 = false

                local v330

                if v325 then
                    v330 = v19.heartsMax or 0

                    if v330 > 0 then
                        v326 = true
                    else
                        v328 = true
                    end
                end

                v325 = false

                local v331

                if v326 then
                    Position = (v330 - (v19.hearts or v330)) / v330
                    CamBack = math.clamp(Position, 0, 1)

                    if CamBack then
                        v331 = CamBack
                        v325 = true
                    else
                        v328 = true
                    end
                end

                v326 = false

                if v328 then
                    v331 = 0
                    v325 = true
                end

                v328 = false

                if v327 then
                    v331 = 0
                    v325 = true
                end

                if v325 then
                    CamBack = v18

                    if CamBack then
                        v328 = true
                    else
                        v318 = CamBack
                        v326 = true
                    end
                end

                v325 = false

                if v328 then
                    v318 = MutationDisplay[v18]
                    v326 = true
                end

                v328 = false

                if v326 then
                    if v318 then
                        v328 = true
                    else
                        v325 = true
                    end
                end

                v326 = false

                if v328 then
                    if v318.cycle then
                        v325 = true
                    else
                        v326 = true
                    end
                end

                v328 = false

                local v332

                if v326 then
                    v332 = v318.color
                    v328 = true
                end

                v326 = false

                if v325 then
                    v332 = v107
                    v328 = true
                end

                v325 = false

                local v333, v334

                if v328 then
                    v298 = v331 * 1.5
                    v333 = v332:Lerp(v109, (math.min(1, v298)))
                    v297 = v18

                    if v297 then
                        v326 = true
                    else
                        v334 = v297
                        v325 = true
                    end
                end

                v328 = false

                if v326 then
                    v334 = MutationDisplay[v18]
                    v325 = true
                end

                v326 = false

                if v325 then
                    if v334 then
                        v326 = true
                    else
                        v328 = true
                    end
                end

                v325 = false

                local v335

                if v326 then
                    CamRight = v334.edge

                    if CamRight then
                        v335 = CamRight
                        v325 = true
                    else
                        v328 = true
                    end
                end

                if v328 then
                    v335 = 0.6
                    v325 = true
                end

                if v325 then
                    Position = v335 - 0.3 * v331
                    v319 = v333
                    v320 = math.max(0.1, Position)
                    v329 = false
                end

                if v324 then
                    v319 = v111
                    v320 = 0.6
                    v329 = false
                end

                if v329 then
                    if ReelGui then
                        setGlow(v107, 1, 0.4)
                        task.delay(0.45, function() -- line: 1999
                            -- upvalues: ReelGui (copy), v19 (ref), v172 (ref)
                            if not v19 and not v172 and ReelGui.Parent then
                                ReelGui.Enabled = false
                                ReelGui.Circle.Visible = true
                            end
                        end)
                    end
                else
                    setGlow(v319, v320, 0.6)
                end
            end
        elseif v19 and not v19.pvp then
            v321 = v18 and MutationDisplay[v18]

            if v321 then
                v321 = v321.cycle

                if v321 then
                    v314 = LocalPlayer:FindFirstChild("PlayerGui")
                    v321 = v314 and v314:FindFirstChild("ReelGui")
                end
            end

            if v321 then
                v322 = Color3.fromHSV(os.clock() * 0.4 % 1, 0.75, 1)

                local n13 = 0

                if v19 then
                    if v19.pvp then
                    else
                        local v336 = v19.heartsMax or 0

                        if v336 > 0 then
                            Position = (v336 - (v19.hearts or v336)) / v336
                            n13 = math.clamp(Position, 0, 1) or 0
                        end
                    end
                end

                v322 = v322:Lerp(v109, n13)
                v314 = v321.Vignette:FindFirstChild("Glow")

                if v314 then
                    v314.ImageColor3 = v322
                end
            end
        end

        v321 = v19

        if v321 then
            v321 = not v19.pvp

            if v321 then
                v313 = LocalPlayer:FindFirstChild("PlayerGui")
                v321 = v313 and v313:FindFirstChild("ReelGui")
            end
        end

        v313 = v321 and v321.Vignette:FindFirstChild("Beat")
        v321 = v19 and t25[v19.hearts or -1]

        if v313 then
            if v321 then
                v318 = os.clock() * 3.141592653589793 * 2 / v321[2]
                v322 = 0.5 - 0.5 * math.cos(v318)
                v313.ImageTransparency = 1 - v321[1] * v322
            elseif v313.ImageTransparency < 1 then
                v313.ImageTransparency = 1
            end
        end

        if v19 and n9 > 0 then
            v313 = LocalPlayer:FindFirstChild("PlayerGui")

            local v337 = v313 and v313:FindFirstChild("ReelGui")

            v313 = v337 and v337.Circle:FindFirstChild("Hearts")
            v322 = game:GetService("SoundService"):FindFirstChild("HarpoonSFX")
            v337 = v322 and v322:FindFirstChild("HeartbeatLoop")

            if v313 and v313.Visible and v337 and v337.IsPlaying then
                v322 = v337.PlaybackLoudness
                v320 = n10 * (1 - v293 * 0.4)
                n10 = math.max(v320, v322, 5)
                v320 = v322 / n10
                v319 = math.clamp(v320, 0, 1)
                v322 = v319 * v319 * n9

                for _, child in ipairs(v313:GetChildren()) do
                    if child:IsA("ImageLabel") and child.Name ~= "HeartTemplate" and child:GetAttribute("Alive") ~= false then
                        child.UIScale.Scale = v322 + 1
                    end
                end
            end
        end

        if v13 or v15 ~= "seated" or n1 ~= 0 or not v294 or not v206 then
            return
        end

        v206:Disconnect()
        v206 = nil
    end
end

local function ensureLoop() -- line: 2066
    -- upvalues: RunService (copy), v206 (ref), onRender (copy)
    v206 = v206 or RunService.RenderStepped:Connect(onRender)
end

LocalPlayer:GetAttributeChangedSignal("FovAdd"):Connect(ensureLoop)
LocalPlayer:GetAttributeChangedSignal("FovAddChest"):Connect(ensureLoop)
LocalPlayer:GetAttributeChangedSignal("FovAddTitan"):Connect(ensureLoop)

v16 = function(p84, p85, p86) -- line: 2079
    -- upvalues: RunService (copy), HarpoonConfig (copy), t4 (copy), v15 (ref), t7 (ref), v206 (ref), onRender (copy)
    local Pivot = p84.spear:GetPivot()
    local WorldPosition = p84.muzzleAtt.WorldPosition
    local v339 = Pivot.Position - WorldPosition
    local Magnitude = v339.Magnitude
    local Unit = Magnitude > 0.1 and v339.Unit or Vector3.new(0, 1, 0)
    local v340 = Unit:Cross((Vector3.new(0, 1, 0)))
    local Unit2 = v340.Magnitude > 0.001 and v340.Unit or Vector3.new(1, 0, 0)
    local v341 = Random.new()
    local ReturnSpeed = HarpoonConfig.ReturnSpeed

    local function pick(p87) -- line: 2089
        -- upvalues: v341 (copy)
        return v341:NextNumber(p87[1], p87[2])
    end

    local Magnitude2 = p86 and p86.Magnitude or 0
    local v342, Unit3, v343, v344

    if Magnitude2 > 2 then
        local Unit4 = p86.Unit
        local v346 = math.clamp(Magnitude2 / 40, 0, 1)

        v342 = Pivot.Position + Unit4 * (v346 * 10 + 5) + Vector3.new(0, 1, 0) * (v346 * 8 + 2) + Unit2 * v341:NextNumber(-3, 3)

        local v347 = Unit4:Cross((Vector3.new(0, 1, 0)))

        Unit3 = ((v347.Magnitude > 0.001 and v347.Unit or Unit2) + v341:NextUnitVector() * 0.25).Unit

        local v348 = if Unit:Dot(Unit2:Cross((Vector3.new(0, 1, 0)))) >= 0 then 1 else -1

        v343 = (v346 * 1.7 + 0.8) * v348
        v344 = v346 * 0.3 + 0.6
    else
        local PivotPosition = Pivot.Position
        local away = p85.away
        local v349 = PivotPosition + Unit * v341:NextNumber(away[1], away[2])
        local up = p85.up

        v342 = v349 + Vector3.new(0, 1, 0) * v341:NextNumber(up[1], up[2]) + Unit2 * v341:NextNumber(-p85.lateral, p85.lateral)
        Unit3 = v341:NextUnitVector()

        local turns = p85.turns

        v343 = v341:NextNumber(turns[1], turns[2]) * (if v341:NextNumber() < 0.5 then 1 else -1)

        local time = p85.time

        if time then
            local time = p85.time

            v344 = v341:NextNumber(time[1], time[2])
        end

        if not time or not v344 then
            v344 = math.max(0.35, Magnitude / ReturnSpeed)
        end
    end

    v15 = "snap"

    local t41 = {
        clock = 0,
        startPos = Pivot.Position,
        startRot = Pivot.Rotation,
        flare = p85 ~= t4,
        fling = v342
    }
    local approach = p85.approach

    t41.approach = v341:NextNumber(approach[1], approach[2])
    t41.spinAxis = Unit3
    t41.spinTurns = v343
    t41.snapTime = v344
    t41.barrelLockedCF = p84.barrel:GetPivot()
    t7 = t41
    p84.beam.Enabled = true
    v206 = v206 or RunService.RenderStepped:Connect(onRender)
end

local function beginFlight(p88, p89, p90) -- line: 2130
    -- upvalues: ReplicatedStorage (copy), RunService (copy), HarpoonConfig (copy), v15 (ref), t7 (ref), n1 (ref), n6 (ref), v206 (ref), getRefs (copy), onRender (copy)
    if v15 ~= "seated" then
        return
    end

    local v351 = getRefs()

    if v351 then
        local Pivot = v351.spear:GetPivot()
        local v352 = p88 - Pivot.Position
        local Unit = v352.Magnitude > 0.01 and v352.Unit or v351.barrel:GetPivot().YVector
        local SpearSpeed = HarpoonConfig.SpearSpeed

        t7 = {
            clock = 0,
            hitPoint = p88,
            didHit = p89,
            dir = Unit,
            startPos = Pivot.Position,
            flightTime = (p88 - Pivot.Position).Magnitude / SpearSpeed,
            barrelLockedCF = v351.barrel:GetPivot(),
            titan = p90
        }
        v15 = "fly"
        require(ReplicatedStorage.Modules.HarpoonFx).SetFlight(v351.spear, true)
        n1 = HarpoonConfig.RecoilKick
        n6 = 10
        v351.beam.Enabled = not p90
        v206 = v206 or RunService.RenderStepped:Connect(onRender)
    end
end

local function setCharacterVisible(p91) -- line: 2157
    -- upvalues: LocalPlayer (copy)
    local Character = LocalPlayer.Character

    if Character then
        for _, descendant in ipairs(Character:GetDescendants()) do
            if descendant:IsA("BasePart") or descendant:IsA("Decal") then
                descendant.LocalTransparencyModifier = p91 and 0 or 1
            end
        end
    end
end

function stopAiming(p92) -- line: 2168
    -- upvalues: UserInputService (copy), ContextActionService (copy), LocalPlayer (copy), v13 (ref), v14 (ref), t5 (ref), v19 (ref), t8 (copy), showLeave (copy), showFire (copy), t27 (ref), setCharacterVisible (copy)
    if not v13 then
        return
    end

    v13 = false
    v14 = nil

    if t5 and t5.arrivedConn then
        t5.arrivedConn:Disconnect()
    end

    if t5 and t5.titanConn then
        t5.titanConn:Disconnect()
    end

    t5 = nil
    ContextActionService:UnbindAction("HarpoonExitAction")
    ContextActionService:UnbindAction("HarpoonFireAction")
    v19 = nil
    t27 = nil
    require(script.LocalFight).Stop()

    local HarpoonSFX = game:GetService("SoundService"):FindFirstChild("HarpoonSFX")
    local ReelLoop = HarpoonSFX and HarpoonSFX:FindFirstChild("ReelLoop")

    if ReelLoop and ReelLoop.IsPlaying then
        ReelLoop:Stop()
    end

    local PlayerGui = LocalPlayer:FindFirstChild("PlayerGui")
    local ReelGui = PlayerGui and PlayerGui:FindFirstChild("ReelGui")

    if ReelGui then
        ReelGui.Enabled = false
    end

    UserInputService.MouseBehavior = Enum.MouseBehavior.Default
    UserInputService.MouseIconEnabled = true
    UserInputService.ModalEnabled = false

    local PlayerGui2 = LocalPlayer:FindFirstChild("PlayerGui")
    local HarpoonAimGui = PlayerGui2 and PlayerGui2:FindFirstChild("HarpoonAimGui")

    if HarpoonAimGui then
        HarpoonAimGui.Enabled = false
    end

    showLeave(false)
    showFire(false)
    t8.hover = false
    t8.settle = 0
    setCharacterVisible(true)

    if p92 then
        return
    end

    local CurrentCamera = workspace.CurrentCamera
    local v353 = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")

    CurrentCamera.CameraType = Enum.CameraType.Custom

    if v353 then
        CurrentCamera.CameraSubject = v353
    end
end

local function rideHandOff(p93) -- line: 2205
    -- upvalues: ReplicatedStorage (copy), v15 (ref), t7 (ref), getRefs (copy)
    local v354 = getRefs()

    if v354 then
        require(ReplicatedStorage.Modules.HarpoonFx).SetFlight(v354.spear, false)
    end

    v15 = "titan"
    t7 = nil

    local connection

    connection = p93:GetAttributeChangedSignal("TitanRide"):Connect(function() -- line: 2211
        -- upvalues: p93 (copy), connection (ref), v15 (ref)
        if p93:GetAttribute("TitanRide") then
            return
        end

        connection:Disconnect()

        if v15 == "titan" then
            v15 = "seated"
        end
    end)
    stopAiming(true)
end

local function firePress() -- line: 2222
    -- upvalues: LocalPlayer (copy), HarpoonConfig (copy), FishMotionConfig (copy), TitanConfig (copy), TitanBody (copy), v4 (ref), Toast (copy), t2 (copy), HarpoonFire (copy), ReelBeat (copy), v13 (ref), v14 (ref), t5 (ref), v15 (ref), v19 (ref), t8 (copy), v59 (copy), getRefs (copy), nearestFish (copy), snapPoint (copy), beginFlight (copy)
    if not v13 or not t5 or not t5.fireBound or not v14 then
        return
    end

    if v19 then
        local Stunned = require(script.TitanFight).Stunned
        local v355 = v19

        if not Stunned(v355, v19.drawnAt or v59()) then
            local v356 = (v19.drawnAt or v59()) - (v4 and HarpoonConfig.ReelTouchLead or 0)
            local v357 = v19

            v357.sent = (v19.sent or 0) + 1
            ReelBeat:FireServer(v356)
            predictBeat(v356)
        end
    elseif v15 == "seated" and t5.lastTargetPoint and v14:GetAttribute("SpearReady") ~= false then
        if (LocalPlayer:GetAttribute("BagCount") or 0) >= (LocalPlayer:GetAttribute("BagCap") or 1e999) then
            Toast.Show("BAG FULL!\nGO FEED YOUR FISH!", "", nil, Toast.RED, "deny")
            LocalPlayer:SetAttribute("BagFullTry", os.clock())
        else
            local v358 = getRefs()
            local v359 = false
            local v360 = false
            local v361 = false
            local v362 = false
            local v363 = false

            if v358 then
                v359 = true
            else
                v363 = true
            end

            local lastTargetPoint, lastRayHit, v364, v365

            if v359 then
                lastTargetPoint = t5.lastTargetPoint
                lastRayHit = t5.lastRayHit

                if t8.hover then
                    v364 = lastTargetPoint
                    v365 = lastRayHit
                    v363 = false
                else
                    v360 = true
                end
            end

            v359 = false

            local Assist, SetAimAssist

            if v360 then
                Assist = HarpoonConfig.Assist
                SetAimAssist = LocalPlayer:GetAttribute("SetAimAssist")

                if type(SetAimAssist) == "number" then
                    v359 = true
                else
                    v361 = true
                end
            end

            v360 = false

            local v366

            if v359 then
                local v367 = math.clamp(SetAimAssist, 0, 1)

                if v367 then
                    v366 = v367
                    v360 = true
                else
                    v361 = true
                end
            end

            v359 = false

            if v361 then
                v366 = 1
                v360 = true
            end

            v361 = false

            if v360 then
                if v366 > 0 then
                    v361 = true
                else
                    v359 = true
                end
            end

            v360 = false

            local nearestFish2

            if v361 then
                nearestFish2 = nearestFish

                if v4 then
                    v362 = true
                else
                    v360 = true
                end
            end

            v361 = false

            if v360 then
                if t2.mode.Pad() then
                    v362 = true
                else
                    v361 = true
                end
            end

            v360 = false

            local v368

            if v362 then
                local SnapCone = Assist.SnapCone

                if SnapCone then
                    v368 = SnapCone
                    v360 = true
                else
                    v361 = true
                end
            end

            if v361 then
                v368 = Assist.SnapConeMouse
                v360 = true
            end

            v361 = false

            local v369

            if v360 then
                local v370 = nearestFish2(v368 * v366)

                if v370 then
                    v369 = v370
                    v361 = true
                else
                    v359 = true
                end
            end

            v360 = false

            if v359 then
                v369 = nil
                v361 = true
            end

            if v361 then
                if v369 then
                    v360 = true
                else
                    v364 = lastTargetPoint
                    v365 = lastRayHit
                    v363 = false
                end
            end

            if v360 then
                v364 = snapPoint(v369, v358.muzzleAtt.WorldPosition)
                v365 = true
                v363 = false
            end

            if not v363 then
                local v371 = v364
                local v372 = v365

                if not t8.hover then
                    local SetAimAssist = LocalPlayer:GetAttribute("SetAimAssist")
                    local v373 = type(SetAimAssist) == "number" and math.clamp(SetAimAssist, 0, 1) or 1

                    v371 = require(script.MapSnap).Find(t5.eyePos, t5.lookDir, HarpoonConfig.Assist.MapSnapCone * v373, v358.muzzleAtt.WorldPosition)

                    if v371 then
                        v372 = true
                    else
                        v371 = v364
                    end
                end

                local v374 = TitanConfig.Now()
                local v375 = TitanConfig.Current(v374)
                local WorldPosition, v376, v377, t42
                local v378 = v371
                local v379 = v372

                if not v375 or LocalPlayer:GetAttribute("InTutorial") then
                elseif LocalPlayer:GetAttribute("TurkeyRun") == nil then
                    WorldPosition = v358.muzzleAtt.WorldPosition
                    v376 = v371 - WorldPosition

                    if v376.Magnitude > 1 then
                        v377 = TitanBody.Hit(v375, v374, WorldPosition, v376.Unit, HarpoonConfig.SpearRange)

                        if v377 and (not v372 or v377.dist < v376.Magnitude) then
                            v378 = WorldPosition + v376.Unit * math.max(v377.dist, 4)
                            v379 = true
                            t42 = {
                                rise = v375,
                                u = v377.u,
                                angle = v377.angle
                            }
                        end
                    end
                end

                local SpearRange = HarpoonConfig.SpearRange
                local WorldPosition2 = v358.muzzleAtt.WorldPosition
                local v381 = v378 - WorldPosition2

                if SpearRange < v381.Magnitude then
                    v378 = WorldPosition2 + v381.Unit * SpearRange
                    v379 = false
                end

                HarpoonFire:FireServer(v378, workspace:GetServerTimeNow() - FishMotionConfig.renderLag(), t42 and workspace:GetServerTimeNow() or nil)
                require(game:GetService("ReplicatedStorage").Modules.NightcrawlDodge).predict(WorldPosition2, (v378 - WorldPosition2).Unit, FishMotionConfig, LocalPlayer)
                beginFlight(v378, v379, t42)
            end
        end
    end
end

local function startAiming(p94) -- line: 2318
    -- upvalues: UserInputService (copy), ContextActionService (copy), RunService (copy), LocalPlayer (copy), t2 (copy), v13 (ref), v14 (ref), t5 (ref), v19 (ref), t8 (copy), showLeave (copy), showFire (copy), requestLeave (copy), v206 (ref), onRender (copy), setCharacterVisible (copy), rideHandOff (copy), firePress (copy)
    if not v13 and p94:GetAttribute("RestTop") then
        t2.mode.Rumble("splash")
        v13 = true
        v14 = p94

        local v383 = RaycastParams.new()

        v383.FilterType = Enum.RaycastFilterType.Exclude
        v383.IgnoreWater = true
        t5 = {
            yaw = 0,
            pitch = 0,
            targetYaw = 0,
            targetPitch = 0,
            sendClock = 0,
            lastTargetPoint = nil,
            lastRayHit = false,
            rayParams = v383
        }
        t5.fromCF = workspace.CurrentCamera.CFrame
        t5.blendT0 = os.clock()
        t8.diveEnd = t5.blendT0
        workspace.CurrentCamera.CameraType = Enum.CameraType.Scriptable
        UserInputService.MouseIconEnabled = false
        UserInputService.ModalEnabled = true
        setCharacterVisible(false)
        ContextActionService:BindAction("HarpoonExitAction", function(_, p96) -- line: 2354
            -- upvalues: requestLeave (copy)
            if p96 == Enum.UserInputState.Begin then
                requestLeave()
            end

            return Enum.ContextActionResult.Sink
        end, false, Enum.KeyCode.Space, Enum.KeyCode.ButtonB)
        showLeave(true)

        local function bindFire() -- line: 2364
            -- upvalues: ContextActionService (copy), LocalPlayer (copy), v13 (ref), t5 (ref), v19 (ref), showFire (copy), firePress (copy)
            if not v13 or t5.fireBound then
                return
            else
                t5.fireBound = true
                ContextActionService:BindAction("HarpoonFireAction", function(_, p98, p99) -- line: 2367
                    -- upvalues: t5 (ref), firePress (copy)
                    local v385 = p99 and p99.KeyCode == Enum.KeyCode.ButtonR2

                    if p98 == Enum.UserInputState.Begin then
                        if v385 then
                            if t5.r2Down then
                                return Enum.ContextActionResult.Sink
                            end

                            t5.r2Down = true
                        end

                        firePress()
                    else
                        local v386 = if v385 then p98 == Enum.UserInputState.Change else nil

                        if not v385 or not v386 then
                            if v385 then
                                t5.r2Down = false
                            end
                        elseif not (p99.Position.Z >= 0.5) or t5.r2Down then
                            if p99.Position.Z <= 0.2 then
                                t5.r2Down = false
                            end
                        else
                            t5.r2Down = true
                            firePress()
                        end
                    end

                    return Enum.ContextActionResult.Sink
                end, false, Enum.UserInputType.MouseButton1, Enum.KeyCode.ButtonR2)

                local HarpoonAimGui = LocalPlayer:WaitForChild("PlayerGui"):FindFirstChild("HarpoonAimGui")

                if HarpoonAimGui then
                    HarpoonAimGui.Enabled = true
                end
            end

            showFire(not (v19 and v19.titan))
        end

        t5.bindFire = bindFire
        t5.arrivedConn = p94:GetAttributeChangedSignal("Arrived"):Connect(function() -- line: 2395
            -- upvalues: p94 (copy), bindFire (copy), ContextActionService (copy), LocalPlayer (copy), t5 (ref), showFire (copy)
            if p94:GetAttribute("Arrived") then
                bindFire()
            elseif t5 then
                if not t5.fireBound then
                    return
                end

                t5.fireBound = false

                local PlayerGui = LocalPlayer:FindFirstChild("PlayerGui")
                local HarpoonAimGui = PlayerGui and PlayerGui:FindFirstChild("HarpoonAimGui")

                if HarpoonAimGui then
                    HarpoonAimGui.Enabled = false
                end

                showFire(false)
                ContextActionService:UnbindAction("HarpoonFireAction")
            end
        end)

        if p94:GetAttribute("Arrived") then
            bindFire()
        end

        t5.titanConn = p94:GetAttributeChangedSignal("TitanRide"):Connect(function() -- line: 2399
            -- upvalues: p94 (copy), rideHandOff (copy)
            if p94:GetAttribute("TitanRide") then
                rideHandOff(p94)
            end
        end)
        v206 = v206 or RunService.RenderStepped:Connect(onRender)
    end
end

function predictBeat(p100) -- line: 2412
    -- upvalues: LocalPlayer (copy), MutationDisplay (copy), HarpoonConfig (copy), v17 (ref), v18 (ref), n1 (ref), v19 (ref), t8 (copy), buildReelArc (copy), hideReelArc (copy), needleAngleAt (copy), setProgress (copy), v88 (copy), v89 (copy), tintReel (copy), v107 (copy), v108 (copy), v109 (copy), v111 (copy), setGlow (copy), pulseReelCircle (copy), popNeedle (copy), playHitSound (copy), playTugSound (copy), finishReel (copy), setHearts (copy)
    local v388 = v19

    if v388 and (not v388.graceUntil or not (p100 < v388.graceUntil)) then
        local v389 = needleAngleAt(v388, p100)
        local v391 = math.abs((v389 - v388.arcCenter + 180) % 360 - 180)
        local PlayerGui = LocalPlayer:FindFirstChild("PlayerGui")
        local ReelGui = PlayerGui and PlayerGui:FindFirstChild("ReelGui")

        if v388.arcSize / 2 + 14 < v391 then
            if v388.safe or (v388.hearts or 0) > 1 then
                if not v388.safe then
                    v388.hearts -= 1
                end

                v388.graceUntil = p100 + 0.3
                v388.predictedMiss = true

                local HarpoonSFX = game:GetService("SoundService"):FindFirstChild("HarpoonSFX")
                local HeartSound = HarpoonSFX and HarpoonSFX:FindFirstChild("HeartSound")

                if HeartSound then
                    HeartSound:Play()
                end

                local v392 = t8.settle + HarpoonConfig.Fov.Miss

                t8.kick += HarpoonConfig.Fov.Pop * (v392 < t8.settle and -1 or 1)
                t8.settle = v392

                if ReelGui then
                    tintReel(ReelGui, v89, 0.3)
                    setHearts(ReelGui, v388.hearts, v388.heartsMax or 0, v388.pvp)
                end

                setGlow(v109, 0.2, 0.18)
                task.delay(0.3, function() -- line: 760
                    -- upvalues: MutationDisplay (copy), v18 (ref), v19 (ref), v107 (copy), v109 (copy), v111 (copy), setGlow (copy)
                    if v19 then
                        if v19.pvp then
                            setGlow(v111, 0.75, 0.8)
                        else
                            local v393, v394

                            if v19 then
                                if v19.pvp then
                                    v393 = v111
                                    v394 = 0.6
                                else
                                    local n14 = 0

                                    if v19 then
                                        if v19.pvp then
                                        else
                                            local v395 = v19.heartsMax or 0

                                            n14 = v395 > 0 and math.clamp((v395 - (v19.hearts or v395)) / v395, 0, 1) or 0
                                        end
                                    end

                                    local v397 = v18 and MutationDisplay[v18]

                                    v393 = (if not v397 or v397.cycle then v107 else v397.color):Lerp(v109, (math.min(1, n14 * 1.5)))

                                    local v400 = v18 and MutationDisplay[v18]

                                    v394 = math.max(0.1, (v400 and v400.edge or 0.6) - 0.3 * n14)
                                end
                            else
                                v393 = v107
                                v394 = 0.6
                            end

                            setGlow(v393, v394, 0.8)
                        end
                    end
                end)
                require(script.Combo).Miss()

                if not v388.safe then
                    require(script.Deadeye).Miss()
                end
            end
        else
            require(script.Combo).Hit(ReelGui, v388, p100, v389)

            local v402 = not v388.pvp and not v388.titan and (v388.beatsDone or 0) + 1 >= (v388.beats or 1)

            if not v388.pvp then
                v388.beatsDone = (v388.beatsDone or 0) + 1
            end

            if v402 then
                if ReelGui then
                    hideReelArc(ReelGui)
                end
            else
                v388.angle0 = v389
                v388.time0 = p100
                v388.v1 = -v388.v1 * (v388.esc or 1.04)

                if v388.vMax and math.abs(v388.v1) > v388.vMax then
                    v388.v1 = math.sign(v388.v1) * v388.vMax
                end

                v388.v0 = v388.v1
                v388.ramp = 0
                v388.graceUntil = p100 + 0.05
                v388.arcSize = math.min(v388.arcCap or 1e999, (math.max(v388.arcFloor or 52.8, v388.arcSize * require(script.Deadeye).Shrink(v388))))

                if v388.titan then
                    require(script.TitanFight).Predict(v388)
                end

                v388.k = (v388.k or 0) + 1

                local offsets = v388.offsets

                v388.arcCenter = (v389 + (v388.v1 < 0 and -1 or 1) * (offsets and offsets[(v388.k - 1) % #offsets + 1] or 180)) % 360

                if ReelGui then
                    buildReelArc(ReelGui, v388.arcCenter, v388.arcSize)

                    if not v388.pvp then
                        setProgress(ReelGui, v388)
                    end
                end
            end

            v388.predicted = true

            if not (v388.pvp or v388.titan) then
                require(script.LocalFight).Tug(if v402 then 0 else (v388.beats or 1) - v388.beatsDone)
            end

            n1 = math.max(n1, 0.35)
            playHitSound()
            playTugSound(v402)

            local v408 = t8.settle + HarpoonConfig.Fov.Beat

            t8.kick += HarpoonConfig.Fov.Pop * (v408 < t8.settle and -1 or 1)
            t8.settle = v408

            if v17 and v17.Parent then
                v17:SetAttribute("LocalHit", os.clock())
            end

            if ReelGui then
                tintReel(ReelGui, v88, 0.45)
                popNeedle(ReelGui)
            end

            if v402 then
                if ReelGui then
                    finishReel(ReelGui)
                end
            else
                pulseReelCircle()
            end

            setGlow(v108, 0.3, 0.06)
            task.delay(0.12, function() -- line: 2484
                -- upvalues: MutationDisplay (copy), v18 (ref), v19 (ref), v107 (copy), v109 (copy), v111 (copy), setGlow (copy)
                local v410 = false
                local v411 = false
                local v412 = false
                local v413 = false
                local v414 = false
                local v415 = false

                if v19 then
                    v410 = true
                else
                    v415 = true
                end

                if v410 then
                    if v19 then
                        v412 = true
                    else
                        v411 = true
                    end
                end

                v410 = false

                local v416, v417

                if v411 then
                    v416 = v107
                    v417 = 0.6
                    v415 = false
                end

                v411 = false

                if v412 then
                    if v19.pvp then
                        v410 = true
                    else
                        v411 = true
                    end
                end

                v412 = false

                if v411 then
                    if v19 then
                        v412 = true
                    else
                        v413 = true
                    end
                end

                v411 = false

                if v412 then
                    if v19.pvp then
                        v413 = true
                    else
                        v411 = true
                    end
                end

                v412 = false

                local v418

                if v411 then
                    v418 = v19.heartsMax or 0

                    if v418 > 0 then
                        v412 = true
                    else
                        v414 = true
                    end
                end

                v411 = false

                local v419

                if v412 then
                    local v421 = math.clamp((v418 - (v19.hearts or v418)) / v418, 0, 1)

                    if v421 then
                        v419 = v421
                        v411 = true
                    else
                        v414 = true
                    end
                end

                v412 = false

                if v414 then
                    v419 = 0
                    v411 = true
                end

                v414 = false

                if v413 then
                    v419 = 0
                    v411 = true
                end

                local v422

                if v411 then
                    local v423 = v18

                    if v423 then
                        v414 = true
                    else
                        v422 = v423
                        v412 = true
                    end
                end

                v411 = false

                if v414 then
                    v422 = MutationDisplay[v18]
                    v412 = true
                end

                v414 = false

                if v412 then
                    if v422 then
                        v414 = true
                    else
                        v411 = true
                    end
                end

                v412 = false

                if v414 then
                    if v422.cycle then
                        v411 = true
                    else
                        v412 = true
                    end
                end

                v414 = false

                local v424

                if v412 then
                    v424 = v422.color
                    v414 = true
                end

                v412 = false

                if v411 then
                    v424 = v107
                    v414 = true
                end

                v411 = false

                local v425, v426

                if v414 then
                    v425 = v424:Lerp(v109, (math.min(1, v419 * 1.5)))

                    local v428 = v18

                    if v428 then
                        v412 = true
                    else
                        v426 = v428
                        v411 = true
                    end
                end

                v414 = false

                if v412 then
                    v426 = MutationDisplay[v18]
                    v411 = true
                end

                v412 = false

                if v411 then
                    if v426 then
                        v412 = true
                    else
                        v414 = true
                    end
                end

                v411 = false

                local v429

                if v412 then
                    local edge = v426.edge

                    if edge then
                        v429 = edge
                        v411 = true
                    else
                        v414 = true
                    end
                end

                if v414 then
                    v429 = 0.6
                    v411 = true
                end

                if v411 then
                    v416 = v425
                    v417 = math.max(0.1, v429 - 0.3 * v419)
                    v415 = false
                end

                if v410 then
                    v416 = v111
                    v417 = 0.6
                    v415 = false
                end

                if not v415 then
                    setGlow(v416, v417, 0.45)
                end
            end)
        end
    end
end

HarpoonEnter.OnClientEvent:Connect(startAiming)
HarpoonExit.OnClientEvent:Connect(stopAiming)
LocalPlayer:GetAttributeChangedSignal("Cinematic"):Connect(function() -- line: 2494
    -- upvalues: RunService (copy), TweenService (copy), LocalPlayer (copy), v4 (ref), Fire (copy), t2 (copy), v13 (ref), v14 (ref), t5 (ref), v15 (ref), v19 (ref), t9 (copy), v25 (ref), v206 (ref), onRender (copy), setCharacterVisible (copy)
    local v431 = true

    if LocalPlayer:GetAttribute("Cinematic") then
    elseif v13 and t5 then
        t5.fromCF = workspace.CurrentCamera.CFrame
        t5.blendT0 = os.clock()

        if v15 == "seated" then
            local t49 = t5
            local t50 = t5

            t49.targetYaw = 0
            t50.targetPitch = 0
        end

        v431 = false
    end

    if v431 then
        return
    end

    setCharacterVisible(false)
    v206 = v206 or RunService.RenderStepped:Connect(onRender)

    local v432 = false

    if not v14 or not v14:GetAttribute("Arrived") or t5.leaving or v19 then
        v432 = true
    elseif not t5.fireBound and t5.bindFire then
        t5.bindFire()
    end

    if v432 or not v4 or not t5.fireBound then
        return
    end

    v25 = false
    t2.armed(true)

    if v25 == true then
        return
    end

    v25 = true

    if not v4 then
        Fire.Visible = false
    else
        local v433 = Fire:FindFirstChild("HoverScale") or Fire:FindFirstChild("PopScale")

        if not v433 then
            v433 = Instance.new("UIScale")
            v433.Name = "PopScale"
            v433.Parent = Fire
        end

        v433.Scale = t9.FROM
        Fire.Visible = true
        TweenService:Create(v433, TweenInfo.new(t9.IN, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
            Scale = 1
        }):Play()
    end
end)
Leave.Activated:Connect(function() -- line: 2518
    -- upvalues: Leave (copy), ButtonHover (copy), v13 (ref), requestLeave (copy)
    if v13 then
        ButtonHover.Press(Leave)
        requestLeave()
    end
end)

local t51

Fire.InputBegan:Connect(function(p101) -- line: 2530
    -- upvalues: v4 (ref), ButtonHover (copy), Fire (copy), v13 (ref), t5 (ref), v19 (ref), t51 (ref)
    if (p101.UserInputType == Enum.UserInputType.Touch or p101.UserInputType == Enum.UserInputType.MouseButton1) and not (v19 and v4) and v13 and t5 and t5.fireBound then
        t51 = {
            input = p101,
            at = Vector2.new(p101.Position.X, p101.Position.Y)
        }
        ButtonHover.Press(Fire)
    end
end)
UserInputService.InputEnded:Connect(function(p102) -- line: 2537
    -- upvalues: v4 (ref), Fire (copy), v13 (ref), t5 (ref), v19 (ref), firePress (copy), t51 (ref)
    if not t51 or t51.input ~= p102 then
        return
    end

    local Magnitude = (Vector2.new(p102.Position.X, p102.Position.Y) - t51.at).Magnitude

    t51 = nil

    if not (Fire.AbsoluteSize.X * 0.25 < Magnitude) and not (v19 and v4) and v13 and t5 and t5.fireBound then
        firePress()
    end
end)
UserInputService.InputBegan:Connect(function(p103) -- line: 2550
    -- upvalues: v4 (ref), v19 (ref), firePress (copy)
    if v19 and v4 and p103.UserInputType == Enum.UserInputType.Touch then
        firePress()
    end
end)
SpearHooked.OnClientEvent:Connect(function(p104, p105, p106) -- line: 2553
    -- upvalues: RunService (copy), HarpoonConfig (copy), t2 (copy), v14 (ref), v15 (ref), v17 (ref), v18 (ref), t7 (ref), t8 (copy), revealGlow (copy), v206 (ref), setRopeSag (copy), t34 (copy), v217 (ref), onRender (copy)
    if p104 and p105 then
        local v434 = false
        local v435 = false
        local v436 = false
        local v437 = false

        if p105 == v14 then
            v434 = true
        else
            v437 = true
        end

        if v434 then
            t2.mode.Rumble("hook")
            v17 = p104
            v18 = p106

            if v15 == "stick" then
                v436 = true
            else
                v435 = true
            end
        end

        v434 = false

        if v435 then
            if v15 == "snap" then
                v436 = true
            else
                v434 = true
            end
        end

        v435 = false

        if v434 then
            if v15 == "seated" then
                v436 = true
            else
                v437 = false
            end
        end

        v434 = false

        local HarpoonSFX, v438

        if v436 then
            v15 = "hooked"
            t7 = nil
            HarpoonSFX = game:GetService("SoundService"):FindFirstChild("HarpoonSFX")

            if HarpoonSFX then
                v434 = true
            else
                v438 = HarpoonSFX
                v435 = true
            end
        end

        v436 = false

        if v434 then
            v438 = HarpoonSFX:FindFirstChild("FishHitSound")
            v435 = true
        end

        v434 = false

        if v435 then
            if v438 then
                v434 = true
            else
                v436 = true
            end
        end

        v435 = false

        if v434 then
            v436 = true
            v438:Play()
        end

        v434 = false

        local Hooked, t52, kick, Pop

        if v436 then
            require(script.HitFx).Play(p105, p104)
            Hooked = HarpoonConfig.Fov.Hooked
            t52 = t8
            kick = t8.kick
            Pop = HarpoonConfig.Fov.Pop

            if Hooked < t8.settle then
                v435 = true
            else
                v434 = true
            end
        end

        v436 = false

        local v439

        if v434 then
            v439 = 1
            v436 = true
        end

        if v435 then
            v439 = -1
            v436 = true
        end

        v435 = false

        if v436 then
            t52.kick = kick + Pop * v439
            t8.settle = Hooked

            local Cracked = p104:GetAttribute("Cracked")

            p104:SetAttribute("LocalHit", os.clock())

            if Cracked then
                v437 = false
            else
                v435 = true
            end
        end

        if v435 then
            v437 = false
            revealGlow(p106)
        end

        if not v437 then
            v206 = v206 or RunService.RenderStepped:Connect(onRender)

            return
        end

        t34[p105] = p104
        require(script.HitFx).Play(p105, p104)

        if v217 then
            return
        end

        v217 = RunService.RenderStepped:Connect(function() -- line: 1393
            -- upvalues: setRopeSag (copy), t34 (copy), v217 (ref)
            local v440 = false

            for v441, v442 in pairs(t34) do
                local v443 = v442.Parent and v442:GetAttribute("Spears")

                if not v441.Parent or not v442.Parent or v442:GetAttribute("Hooked") == nil then
                    t34[v441] = nil
                elseif not v443 or table.find(v443:split(","), v441.Parent.Name) then
                    local Spear = v441:FindFirstChild("Spear")
                    local PrimaryPart = v442.PrimaryPart or v442:FindFirstChildWhichIsA("BasePart")
                    local TopRotate = v441:FindFirstChild("TopRotate")

                    TopRotate = TopRotate and TopRotate:FindFirstChild("Barrel")
                    TopRotate = TopRotate and TopRotate:FindFirstChild("Barrel")

                    local RopeBeamAttatchment = TopRotate and TopRotate:FindFirstChild("RopeBeamAttatchment")

                    if Spear and PrimaryPart and RopeBeamAttatchment then
                        local v446 = PrimaryPart.Position - RopeBeamAttatchment.WorldPosition

                        if v446.Magnitude >= 1.5 then
                            local Unit = v446.Unit
                            local v447 = PrimaryPart.Position - Unit * 1.3

                            Spear:PivotTo(CFrame.lookAt(v447, v447 + Unit) * CFrame.Angles(-1.5707963267948966, 0, 0))
                        end

                        local RopeBeam = TopRotate:FindFirstChild("RopeBeam")

                        if RopeBeam then
                            setRopeSag(RopeBeam, 0.12, 0.05, os.clock())
                        end
                    end

                    v440 = true
                else
                    t34[v441] = nil
                end
            end

            if v440 then
                return
            end

            v217:Disconnect()
            v217 = nil
        end)
    end
end)
require(script.Deadeye).Init(function() -- line: 2580
    -- upvalues: v19 (ref)
    return v19
end)
ReelState.OnClientEvent:Connect(function(p107) -- line: 2581
    -- upvalues: RunService (copy), TweenService (copy), LocalPlayer (copy), MutationDisplay (copy), HarpoonConfig (copy), v4 (ref), t2 (copy), t3 (copy), t5 (ref), v15 (ref), v16 (ref), v17 (ref), v18 (ref), t6 (ref), n1 (ref), v19 (ref), t8 (copy), v21 (ref), showLeave (copy), showFire (copy), buildReelArc (copy), Versus (copy), setProgress (copy), v84 (copy), v88 (copy), v89 (copy), tintReel (copy), v107 (copy), v108 (copy), v109 (copy), v110 (copy), v111 (copy), setGlow (copy), pulseReelCircle (copy), popNeedle (copy), n8 (ref), playHitSound (copy), playTugSound (copy), v172 (ref), t27 (ref), resetReelLook (copy), finishReel (copy), loseReel (copy), setHearts (copy), hideReel (copy), v206 (ref), getRefs (copy), onRender (copy)
    local PlayerGui = LocalPlayer:FindFirstChild("PlayerGui")
    local ReelGui = PlayerGui and PlayerGui:FindFirstChild("ReelGui")

    if p107.action == "start" or p107.action == "beat" or p107.action == "arc" or p107.action == "miss" or p107.action == "sync" then
        local v448 = p107.action == "start" and not (v19 and v19.pvp and p107.pvp)

        require(script.Deadeye).Msg(ReelGui, p107, v448)
        require(script.Combo).Msg(p107, v448, not v19 or (p107.presses or 0) >= (v19.sent or 0))
    end

    local v449, v450

    if v19 and (p107.action == "beat" or p107.action == "miss" or p107.action == "sync") then
        if (p107.presses or 0) < (v19.sent or 0) then
            return
        end

        if p107.k == v19.k and p107.hearts == v19.hearts and not p107.secondChance and not p107.extraLife then
            v449 = v19
            v450 = p107.count or v19.count
            v449.count = v450

            return
        end

        v449 = v19
        v450 = v19
        v449.predicted = nil
        v450.predictedMiss = nil
    end

    v449 = v19 ~= nil and v19.predicted == true
    v450 = v19 ~= nil and v19.predictedMiss == true

    if p107.action ~= "start" and p107.action ~= "beat" and p107.action ~= "arc" and p107.action ~= "miss" and p107.action ~= "stun" then
        if p107.action == "sync" then
            if v19 then
                local baseSpeed = v19.baseSpeed

                for v451, v452 in pairs(p107) do
                    v19[v451] = v452
                end

                v19.baseSpeed = baseSpeed

                local v454 = v19
                local v455 = v19

                v454.predicted = nil
                v455.predictedMiss = nil

                if ReelGui then
                    buildReelArc(ReelGui, v19.arcCenter, v19.arcSize)
                    setHearts(ReelGui, v19.hearts or 0, v19.heartsMax or 0, v19.pvp)
                    setProgress(ReelGui, v19)
                end
            end
        elseif p107.action == "titanEnd" then
            hideReel(p107.won and v110 or v109)
        elseif p107.action == "escaped" then
            local v457

            if ReelGui and v19 and not p107.beaten and (v19.heartsMax or 0) > 0 and (v19.hearts or 0) > 0 then
                v457 = v19
                v457.hearts = 0
                setHearts(ReelGui, 0, v19.heartsMax, v19.pvp)
                v457 = game:GetService("SoundService"):FindFirstChild("HarpoonSFX")

                if v457 then
                    v457 = v457:FindFirstChild("HeartSound")

                    if v457 then
                        v457:Play()
                    end
                end
            end

            if ReelGui then
                loseReel(ReelGui)
            end

            hideReel(v109)
            v457 = game:GetService("SoundService"):FindFirstChild("HarpoonSFX")

            local v458 = v457 and v457:FindFirstChild("EscapeSound")

            if v458 then
                v458:Play()
            end

            t8.kick += HarpoonConfig.Fov.Pop * (t8.settle > 0 and -1 or 1)
            t8.settle = 0
            v457 = v17
            v458 = v457 and v457.Parent and (v457.PrimaryPart or v457:FindFirstChildWhichIsA("BasePart"))

            local pvp = if v458 then v458.AssemblyLinearVelocity else nil

            if not v458 or not pvp then
                pvp = nil
            end

            v17 = nil
            require(script.LocalFight).Stop()

            if v15 == "hooked" then
                v458 = getRefs()

                if v458 then
                    v16(v458, t3, pvp)
                    n1 = math.max(n1, 0.3)
                else
                    v15 = "seated"
                end
            end
        else
            if p107.action == "landing" and ReelGui and not v172 then
                if not v449 then
                    if not v19 or not v19.pvp then
                        require(script.LocalFight).Tug(0)
                    end

                    playHitSound()
                    playTugSound(true)
                    popNeedle(ReelGui)

                    local v460 = t8.settle + HarpoonConfig.Fov.Beat

                    t8.kick = t8.kick + HarpoonConfig.Fov.Pop * (v460 < t8.settle and -1 or 1)
                    t8.settle = v460
                end

                finishReel(ReelGui, v449)
            end

            if p107.action ~= "landing" then
                t8.settle = 0
            end

            hideReel(v110)
        end
    else
        local v1

        if p107.action == "start" then
            v1 = p107.v1
            p107.baseSpeed = math.abs(v1)
            p107.sent = p107.presses or 0

            if p107.pvp or not v17 then
                require(script.LocalFight).Stop()
            else
                require(script.LocalFight).Begin(v17, p107.body, function() -- line: 2613
                    -- upvalues: getRefs (copy)
                    local v461 = getRefs()

                    return v461 and v461.muzzleAtt.WorldPosition
                end)
            end
        end

        local pvp

        if p107.action ~= "start" and v19 and v19.baseSpeed then
            pvp = v19.baseSpeed
            v1 = v19.offsets

            local sent = v19.sent

            p107.baseSpeed = pvp
            p107.offsets = v1
            p107.sent = sent
        end

        v19 = p107

        if p107.titan and p107.action == "start" and t5 and not t5.fireBound and t5.bindFire then
            t5.bindFire()
        end

        pvp = LocalPlayer:FindFirstChild("PlayerGui")
        v1 = pvp and pvp:FindFirstChild("HarpoonAimGui")

        if v1 then
            v1.Enabled = false
        end

        local v462

        if ReelGui then
            if p107.action == "start" then
                v1 = v172

                if type(v1) == "table" then
                    for _, v463 in ipairs(v172.tweens) do
                        v463:Cancel()
                    end
                end

                v172 = false
                t27 = nil
                n8 = 0
                resetReelLook(ReelGui)

                if v21 and not p107.titan then
                    showLeave(false)
                end

                if v4 then
                    showFire(false)
                end
            end

            ReelGui.Enabled = true
            ReelGui.Circle.Visible = true
            setProgress(ReelGui, p107)
            buildReelArc(ReelGui, p107.arcCenter, p107.arcSize)
            ReelGui.Circle.Key.Text = v4 and "TAP" or "CLICK"
            pvp = ReelGui.Circle:FindFirstChild("PadKey")

            if not pvp then
                pvp = Instance.new("ImageLabel")
                pvp.Name = "PadKey"
                pvp.BackgroundTransparency = 1
                pvp.AnchorPoint = Vector2.new(0.5, 0.5)
                pvp.Position = ReelGui.Circle.Key.Position
                pvp.Size = UDim2.fromScale(0.2, 0.2)
                pvp.ZIndex = ReelGui.Circle.Key.ZIndex
                pvp.Parent = ReelGui.Circle
            end

            v1 = t2.mode.Pad()

            if v1 then
                v462 = t2.mode.Icon(Enum.KeyCode.ButtonR2)
            end

            if not v1 or not v462 then
                v462 = ""
            end

            pvp.Image = v462
            pvp.Visible = v1
            ReelGui.Circle.Key.Visible = not v1
            setHearts(ReelGui, p107.hearts or 0, p107.heartsMax or 0, p107.pvp)

            if p107.titan and p107.action == "start" then
                require(script.TitanFight).PopIn(ReelGui)
            end
        end

        local v464 = p107.pvp and v111 or v107

        if p107.action == "beat" then
            if not v449 then
                if not p107.pvp then
                    v1 = require(script.LocalFight).Tug
                    v1((math.max(0, (p107.beats or 1) - (p107.beatsDone or 0))))
                end

                v462 = n1
                n1 = math.max(v462, 0.35)
                playHitSound()
                v1 = game:GetService("SoundService"):FindFirstChild("HarpoonSFX")
                v462 = v1 and v1:FindFirstChild("TugA")

                if v462 then
                    v462.PlaybackSpeed = math.max(0, n8 - 1) * 0.025 + 0.95
                    v462:Play()
                end

                v1 = t8.settle + HarpoonConfig.Fov.Beat
                t8.kick += HarpoonConfig.Fov.Pop * (v1 < t8.settle and -1 or 1)
                t8.settle = v1
                pulseReelCircle()

                if ReelGui then
                    tintReel(ReelGui, v88, 0.45)
                    popNeedle(ReelGui)
                end

                setGlow(v108, 0.3, 0.06)
                task.delay(0.12, function() -- line: 2685
                    -- upvalues: MutationDisplay (copy), v18 (ref), v19 (ref), v107 (copy), v109 (copy), v111 (copy), setGlow (copy)
                    local v466 = false
                    local v467 = false
                    local v468 = false
                    local v469 = false
                    local v470 = false
                    local v471 = false

                    if v19 then
                        v466 = true
                    else
                        v471 = true
                    end

                    if v466 then
                        if v19 then
                            v468 = true
                        else
                            v467 = true
                        end
                    end

                    v466 = false

                    local v472, v473

                    if v467 then
                        v472 = v107
                        v473 = 0.6
                        v471 = false
                    end

                    v467 = false

                    if v468 then
                        if v19.pvp then
                            v466 = true
                        else
                            v467 = true
                        end
                    end

                    v468 = false

                    if v467 then
                        if v19 then
                            v468 = true
                        else
                            v469 = true
                        end
                    end

                    v467 = false

                    if v468 then
                        if v19.pvp then
                            v469 = true
                        else
                            v467 = true
                        end
                    end

                    v468 = false

                    local v474

                    if v467 then
                        v474 = v19.heartsMax or 0

                        if v474 > 0 then
                            v468 = true
                        else
                            v470 = true
                        end
                    end

                    v467 = false

                    local v475

                    if v468 then
                        local v477 = math.clamp((v474 - (v19.hearts or v474)) / v474, 0, 1)

                        if v477 then
                            v475 = v477
                            v467 = true
                        else
                            v470 = true
                        end
                    end

                    v468 = false

                    if v470 then
                        v475 = 0
                        v467 = true
                    end

                    v470 = false

                    if v469 then
                        v475 = 0
                        v467 = true
                    end

                    local v478

                    if v467 then
                        local v479 = v18

                        if v479 then
                            v470 = true
                        else
                            v478 = v479
                            v468 = true
                        end
                    end

                    v467 = false

                    if v470 then
                        v478 = MutationDisplay[v18]
                        v468 = true
                    end

                    v470 = false

                    if v468 then
                        if v478 then
                            v470 = true
                        else
                            v467 = true
                        end
                    end

                    v468 = false

                    if v470 then
                        if v478.cycle then
                            v467 = true
                        else
                            v468 = true
                        end
                    end

                    v470 = false

                    local v480

                    if v468 then
                        v480 = v478.color
                        v470 = true
                    end

                    v468 = false

                    if v467 then
                        v480 = v107
                        v470 = true
                    end

                    v467 = false

                    local v481, v482

                    if v470 then
                        v481 = v480:Lerp(v109, (math.min(1, v475 * 1.5)))

                        local v484 = v18

                        if v484 then
                            v468 = true
                        else
                            v482 = v484
                            v467 = true
                        end
                    end

                    v470 = false

                    if v468 then
                        v482 = MutationDisplay[v18]
                        v467 = true
                    end

                    v468 = false

                    if v467 then
                        if v482 then
                            v468 = true
                        else
                            v470 = true
                        end
                    end

                    v467 = false

                    local v485

                    if v468 then
                        local edge = v482.edge

                        if edge then
                            v485 = edge
                            v467 = true
                        else
                            v470 = true
                        end
                    end

                    if v470 then
                        v485 = 0.6
                        v467 = true
                    end

                    if v467 then
                        v472 = v481
                        v473 = math.max(0.1, v485 - 0.3 * v475)
                        v471 = false
                    end

                    if v466 then
                        v472 = v111
                        v473 = 0.6
                        v471 = false
                    end

                    if not v471 then
                        setGlow(v472, v473, 0.45)
                    end
                end)
            end
        elseif p107.action == "start" then
            if ReelGui then
                tintReel(ReelGui, v84, 0)
            end

            if not t6 then
                v462 = LocalPlayer:FindFirstChild("PlayerGui")

                local ReelGui = v462 and v462:FindFirstChild("ReelGui")

                v462 = ReelGui and ReelGui.Vignette:FindFirstChild("Glow")

                if v462 then
                    v462.ImageColor3 = v464
                    v462.ImageTransparency = 1
                end

                local v487

                if v19 then
                    if v19.pvp then
                        v487 = v111
                        v462 = 0.6
                    else
                        local v488, v489

                        if not v19 or v19.pvp then
                            v489 = 0
                        else
                            v487 = v19.heartsMax or 0

                            if v487 > 0 then
                                v488 = (v487 - (v19.hearts or v487)) / v487
                                v489 = math.clamp(v488, 0, 1) or 0
                            else
                                v489 = 0
                            end
                        end

                        local Pop = v18 and MutationDisplay[v18]

                        v487 = if not Pop or Pop.cycle then v107 else Pop.color
                        v487 = v487:Lerp(v109, (math.min(1, v489 * 1.5)))

                        local v491 = v18 and MutationDisplay[v18]
                        local edge = if v491 then v491.edge else nil

                        if not v491 or not edge then
                            edge = 0.6
                        end

                        v462 = math.max(0.1, edge - 0.3 * v489)
                    end
                else
                    v487 = v107
                    v462 = 0.6
                end

                setGlow(v487, v462, 0.35)
            end
        elseif p107.action ~= "miss" or v450 then
            if p107.action ~= "miss" then
                if p107.action == "stun" then
                    v1 = game:GetService("SoundService"):FindFirstChild("HarpoonSFX")

                    local HeartSound = v1 and v1:FindFirstChild("HeartSound")

                    if HeartSound then
                        HeartSound:Play()
                    end

                    v1 = t8.settle + HarpoonConfig.Fov.Miss * 2
                    t8.kick += HarpoonConfig.Fov.Pop * (v1 < t8.settle and -1 or 1)
                    t8.settle = v1

                    if ReelGui then
                        tintReel(ReelGui, v89, 0.6)
                        require(script.TitanFight).Collapse(ReelGui, p107.stunUntil)
                    end

                    setGlow(v109, 0.2, 0.18)
                    task.delay(0.3, function() -- line: 760
                        -- upvalues: MutationDisplay (copy), v18 (ref), v19 (ref), v107 (copy), v109 (copy), v111 (copy), setGlow (copy)
                        if v19 then
                            if v19.pvp then
                                setGlow(v111, 0.75, 0.8)
                            else
                                local v493, v494

                                if v19 then
                                    if v19.pvp then
                                        v493 = v111
                                        v494 = 0.6
                                    else
                                        local n15 = 0

                                        if v19 then
                                            if v19.pvp then
                                            else
                                                local v495 = v19.heartsMax or 0

                                                n15 = v495 > 0 and math.clamp((v495 - (v19.hearts or v495)) / v495, 0, 1) or 0
                                            end
                                        end

                                        local v497 = v18 and MutationDisplay[v18]

                                        v493 = (if not v497 or v497.cycle then v107 else v497.color):Lerp(v109, (math.min(1, n15 * 1.5)))

                                        local v500 = v18 and MutationDisplay[v18]

                                        v494 = math.max(0.1, (v500 and v500.edge or 0.6) - 0.3 * n15)
                                    end
                                else
                                    v493 = v107
                                    v494 = 0.6
                                end

                                setGlow(v493, v494, 0.8)
                            end
                        end
                    end)
                    v462 = n1
                    n1 = math.max(v462, 0.5)
                else
                    local v502

                    if v19 then
                        if v19.pvp then
                            v502 = v111
                            v462 = 0.6
                        else
                            local v503, v504

                            if not v19 or v19.pvp then
                                v504 = 0
                            else
                                v502 = v19.heartsMax or 0

                                if v502 > 0 then
                                    v503 = (v502 - (v19.hearts or v502)) / v502
                                    v504 = math.clamp(v503, 0, 1) or 0
                                else
                                    v504 = 0
                                end
                            end

                            local Pop = v18 and MutationDisplay[v18]

                            v502 = if not Pop or Pop.cycle then v107 else Pop.color
                            v502 = v502:Lerp(v109, (math.min(1, v504 * 1.5)))

                            local v506 = v18 and MutationDisplay[v18]
                            local edge = if v506 then v506.edge else nil

                            if not v506 or not edge then
                                edge = 0.6
                            end

                            v462 = math.max(0.1, edge - 0.3 * v504)
                        end
                    else
                        v502 = v107
                        v462 = 0.6
                    end

                    setGlow(v502, v462, 0.3)
                end
            end
        else
            v1 = game:GetService("SoundService"):FindFirstChild("HarpoonSFX")

            local HeartSound = v1 and v1:FindFirstChild("HeartSound")

            if HeartSound then
                HeartSound:Play()
            end

            v1 = t8.settle + HarpoonConfig.Fov.Miss
            t8.kick += HarpoonConfig.Fov.Pop * (v1 < t8.settle and -1 or 1)
            t8.settle = v1

            if ReelGui then
                tintReel(ReelGui, v89, 0.3)
            end

            setGlow(v109, 0.2, 0.18)
            task.delay(0.3, function() -- line: 760
                -- upvalues: MutationDisplay (copy), v18 (ref), v19 (ref), v107 (copy), v109 (copy), v111 (copy), setGlow (copy)
                if v19 then
                    if v19.pvp then
                        setGlow(v111, 0.75, 0.8)
                    else
                        local v507, v508

                        if v19 then
                            if v19.pvp then
                                v507 = v111
                                v508 = 0.6
                            else
                                local n16 = 0

                                if v19 then
                                    if v19.pvp then
                                    else
                                        local v509 = v19.heartsMax or 0

                                        n16 = v509 > 0 and math.clamp((v509 - (v19.hearts or v509)) / v509, 0, 1) or 0
                                    end
                                end

                                local v511 = v18 and MutationDisplay[v18]

                                v507 = (if not v511 or v511.cycle then v107 else v511.color):Lerp(v109, (math.min(1, n16 * 1.5)))

                                local v514 = v18 and MutationDisplay[v18]

                                v508 = math.max(0.1, (v514 and v514.edge or 0.6) - 0.3 * n16)
                            end
                        else
                            v507 = v107
                            v508 = 0.6
                        end

                        setGlow(v507, v508, 0.8)
                    end
                end
            end)
        end

        if p107.secondChance and ReelGui then
            Versus.SecondChance(ReelGui)
        end

        if p107.extraLife and ReelGui then
            Versus.SecondChance(ReelGui, "ExtraLife")
            v464 = game:GetService("SoundService"):FindFirstChild("HarpoonSFX")

            local v516 = v464 and v464:FindFirstChild("ExtraLife")

            if v516 then
                v516:Play()
            end

            v516 = ReelGui.Circle:FindFirstChild("Hearts")

            local Heart1 = v516 and v516:FindFirstChild("Heart1")

            if Heart1 then
                local t53 = {
                    PEAK = 1.6,
                    UP = 0.18,
                    BACK = 0.55,
                    GOLD = Color3.fromRGB(255, 215, 70)
                }
                local v517 = Heart1:GetAttribute("RestSize") or Heart1.Size

                Heart1:SetAttribute("RestSize", v517)
                Heart1.ImageColor3 = t53.GOLD
                TweenService:Create(Heart1, TweenInfo.new(t53.UP, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                    Size = UDim2.new(v517.X.Scale * t53.PEAK, 0, v517.Y.Scale * t53.PEAK, 0)
                }):Play()
                task.delay(t53.UP, function() -- line: 2735
                    -- upvalues: Heart1 (copy), t53 (copy), v517 (copy), TweenService (copy)
                    if Heart1.Parent then
                        TweenService:Create(Heart1, TweenInfo.new(t53.BACK, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                            Size = v517,
                            ImageColor3 = Color3.new(1, 1, 1)
                        }):Play()
                    end
                end)
            end
        end

        v206 = v206 or RunService.RenderStepped:Connect(onRender)
    end
end)

local function watchDive(p108) -- line: 2816
    -- upvalues: RunService (copy), t8 (copy), v206 (ref), onRender (copy)
    p108:GetAttributeChangedSignal("DiveT0"):Connect(function() -- line: 2817
        -- upvalues: p108 (copy), RunService (copy), t8 (copy), v206 (ref), onRender (copy)
        t8.diveT0 = p108:GetAttribute("DiveT0")
        t8.diveEnd = nil

        if t8.diveT0 and not v206 then
            v206 = RunService.RenderStepped:Connect(onRender)
        end
    end)
end

if LocalPlayer.Character then
    watchDive(LocalPlayer.Character)
end

LocalPlayer.CharacterAdded:Connect(watchDive)
