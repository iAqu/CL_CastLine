-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local TweenService = game:GetService("TweenService")
local Parent = script.Parent
local DRScrambleEventUIMain = Parent:WaitForChild("DRScrambleEventUIMain")
local BG = DRScrambleEventUIMain:WaitForChild("BG")
local Close = DRScrambleEventUIMain:FindFirstChild("Close")
local ContentFrame = DRScrambleEventUIMain:FindFirstChild("ContentFrame")
local RollButton = DRScrambleEventUIMain:FindFirstChild("RollButton")
local MiddleLaser = DRScrambleEventUIMain:FindFirstChild("MiddleLaser")
local LeftTube = DRScrambleEventUIMain:FindFirstChild("LeftTube")
local RightTube = DRScrambleEventUIMain:FindFirstChild("RightTube")
local LeftTopTube = DRScrambleEventUIMain:FindFirstChild("LeftTopTube")
local RightTopTube = DRScrambleEventUIMain:FindFirstChild("RightTopTube")
local LeftLaser = DRScrambleEventUIMain:FindFirstChild("LeftLaser")
local RightLaser = DRScrambleEventUIMain:FindFirstChild("RightLaser")
local PaperNote1 = DRScrambleEventUIMain:FindFirstChild("PaperNote1")
local PaperNote2 = DRScrambleEventUIMain:FindFirstChild("PaperNote2")
local v1 = MiddleLaser and MiddleLaser:FindFirstChild("PlaySprite")

if v1 then
    v1:IsA("BaseScript")
end

local descendant

if ContentFrame then
    v1 = ContentFrame:FindFirstChild("ItemsHolder", true)

    for _, descendant2 in ipairs(ContentFrame:GetDescendants()) do
        if descendant2:IsA("ScrollingFrame") then
            descendant = descendant2
            break
        end
    end
else
    v1 = ContentFrame
end

local t1 = {}
local OpenAnimScale

if v1 then
    OpenAnimScale = {
        mode = "layers",
        container = v1
    }
    table.insert(t1, OpenAnimScale)
end

if descendant then
    OpenAnimScale = {
        mode = "item",
        container = descendant
    }
    table.insert(t1, OpenAnimScale)
end

local t2 = {}
local container

for _, v2 in ipairs(t1) do
    container = v2.container
    table.insert(t2, container)
end

local t3 = {}

for _, child in ipairs(DRScrambleEventUIMain:GetChildren()) do
    if child:IsA("TextLabel") then
        table.insert(t3, child)
    end
end

local v3 = table.freeze({})
local zero = Vector2.zero

OpenAnimScale = DRScrambleEventUIMain:FindFirstChild("OpenAnimScale")

if not (OpenAnimScale and OpenAnimScale:IsA("UIScale")) then
    OpenAnimScale = Instance.new("UIScale")
    OpenAnimScale.Name = "OpenAnimScale"
    OpenAnimScale.Parent = DRScrambleEventUIMain
end

OpenAnimScale.Scale = 1

local v4, v5

if Close then
    v5 = Close:FindFirstChild("PressScale")
    v4 = v5

    if not v5 or not v5:IsA("UIScale") then
        v5 = Instance.new("UIScale")
        v4 = v5
        v5.Name = "PressScale"
        v5.Parent = Close
    end

    v5.Scale = 1
end

v5 = {
    {
        dx = 0.09,
        dy = 0.19,
        rot = 5,
        scale = 0.97,
        hidden = true,
        inDelay = 0.18,
        inTime = 0.55,
        inFade = 0,
        outDelay = 0.08,
        outTime = 0.22,
        inst = LeftTopTube
    },
    {
        dx = -0.09,
        dy = 0.19,
        rot = -5,
        scale = 0.97,
        hidden = true,
        inDelay = 0.18,
        inTime = 0.55,
        inFade = 0,
        outDelay = 0.08,
        outTime = 0.22,
        inst = RightTopTube
    },
    {
        dx = 0.175,
        dy = 0,
        rot = 6,
        scale = 0.97,
        hidden = true,
        inDelay = 0.26,
        inTime = 0.55,
        inFade = 0,
        outDelay = 0.12,
        outTime = 0.22,
        inst = LeftTube
    },
    {
        dx = -0.175,
        dy = 0,
        rot = -6,
        scale = 0.97,
        hidden = true,
        inDelay = 0.26,
        inTime = 0.55,
        inFade = 0,
        outDelay = 0.12,
        outTime = 0.22,
        inst = RightTube
    },
    {
        dx = 0.02,
        dy = 0.18,
        rot = 3,
        scale = 0.95,
        hidden = true,
        inDelay = 0.34,
        inTime = 0.46,
        inFade = 0,
        outDelay = 0.04,
        outTime = 0.22,
        inst = LeftLaser
    },
    {
        dx = -0.02,
        dy = 0.18,
        rot = -3,
        scale = 0.95,
        hidden = true,
        inDelay = 0.34,
        inTime = 0.46,
        inFade = 0,
        outDelay = 0.04,
        outTime = 0.22,
        inst = RightLaser
    },
    {
        dx = 0,
        dy = 0,
        rot = 0,
        scale = 0.55,
        inDelay = 0.48,
        inTime = 0.34,
        inFade = 0.2,
        outDelay = 0,
        outTime = 0.1,
        inst = MiddleLaser
    },
    {
        dx = 0,
        dy = 0.05,
        rot = 0,
        scale = 0.94,
        inDelay = 0.36,
        inTime = 0.34,
        inFade = 0.2,
        outDelay = 0.1,
        outTime = 0.16,
        inst = ContentFrame
    },
    {
        dx = -0.012,
        dy = 0.036,
        rot = -7,
        scale = 0.9,
        inDelay = 0.4,
        inTime = 0.34,
        inFade = 0.18,
        outDelay = 0.06,
        outTime = 0.16,
        inst = PaperNote1
    },
    {
        dx = 0.012,
        dy = 0.036,
        rot = 7,
        scale = 0.9,
        inDelay = 0.4,
        inTime = 0.34,
        inFade = 0.18,
        outDelay = 0.06,
        outTime = 0.16,
        inst = PaperNote2
    },
    {
        dx = 0,
        dy = 0.06,
        rot = 0,
        scale = 0.88,
        inDelay = 0.44,
        inTime = 0.34,
        inFade = 0.18,
        outDelay = 0.02,
        outTime = 0.16,
        inst = RollButton
    },
    {
        dx = 0,
        dy = -0.03,
        rot = 0,
        scale = 0.7,
        inDelay = 0.44,
        inTime = 0.34,
        inFade = 0.16,
        outDelay = 0.08,
        outTime = 0.16,
        inst = Close
    }
}

for i = #v5, 1, -1 do
    if not v5[i].inst then
        table.remove(v5, i)
    end
end

local v6

for v7, v8 in ipairs(t3) do
    v6 = {
        dx = 0,
        dy = 0.045,
        rot = 0,
        scale = 0.92,
        inTime = 0.34,
        inFade = 0.2,
        outDelay = 0.14,
        outTime = 0.16,
        inst = v8,
        inDelay = 0.28 + (v7 - 1) * 0.04
    }
    table.insert(v5, v6)
end

local t4 = {}

for _, v9 in ipairs(v5) do
    t4[v9.inst] = true
end

RightLaser = 0
t4[BG] = true

local v10

for _, child in ipairs(DRScrambleEventUIMain:GetChildren()) do
    if child:IsA("GuiObject") and not t4[child] then
        if child.ZIndex < BG.ZIndex then
            LeftLaser = child.Position.X.Scale - 0.5
            RightTopTube = child.Position.Y.Scale - 0.5
            v6 = LeftLaser * LeftLaser + RightTopTube * RightTopTube
            v10 = math.sqrt(v6)

            local v11 = math.max(v10, 0.05)

            v6 = {
                scale = 0.97,
                inDelay = 0.22,
                inTime = 0.55,
                inFade = 0.12,
                outDelay = 0.1,
                outTime = 0.22,
                inst = child,
                dx = -LeftLaser / v11 * 0.16,
                dy = -RightTopTube / v11 * 0.16
            }
            v6.rot = LeftLaser < 0 and 5 or -5
        else
            v6 = {
                dx = 0,
                dy = 0.045,
                rot = 0,
                scale = 0.95,
                inTime = 0.34,
                inFade = 0.2,
                outDelay = 0.16,
                outTime = 0.16,
                inst = child,
                inDelay = RightLaser * 0.04 + 0.52
            }
        end

        table.insert(v5, v6)
        RightLaser += 1
    end
end

local t5 = {
    ImageLabel = { "ImageTransparency", "BackgroundTransparency" },
    ImageButton = { "ImageTransparency", "BackgroundTransparency" },
    TextLabel = { "TextTransparency", "TextStrokeTransparency", "BackgroundTransparency" },
    TextButton = { "TextTransparency", "TextStrokeTransparency", "BackgroundTransparency" },
    Frame = { "BackgroundTransparency" },
    CanvasGroup = { "GroupTransparency", "BackgroundTransparency" },
    TextBox = { "TextTransparency", "TextStrokeTransparency", "BackgroundTransparency" },
    ScrollingFrame = { "ScrollBarImageTransparency", "BackgroundTransparency" },
    ViewportFrame = { "ImageTransparency", "BackgroundTransparency" },
    VideoFrame = { "BackgroundTransparency" },
    UIStroke = { "Transparency" },
    UIShadow = { "Transparency" }
}

local function collectFade(p1, p2) -- line: 461
    -- upvalues: t5 (copy)
    local t6 = {}

    local function add(p3) -- line: 464
        -- upvalues: t6 (copy), t5 (copy)
        local v12 = t5[p3.ClassName]

        if not v12 then
            return
        end

        local t7 = {}

        for _, v13 in ipairs(v12) do
            local v14 = p3[v13]

            if typeof(v14) == "number" and v14 < 1 then
                table.insert(t7, {
                    name = v13,
                    base = v14
                })
            end
        end

        if #t7 > 0 then
            table.insert(t6, {
                inst = p3,
                props = t7,
                gui = p3:IsA("GuiObject")
            })
        end
    end

    add(p1)

    for _, descendant in ipairs(p1:GetDescendants()) do
        local v15 = false

        if p2 then
            for _, v16 in ipairs(p2) do
                if descendant:IsDescendantOf(v16) then
                    v15 = true
                    break
                end

                v15 = false
            end
        end

        if not v15 then
            add(descendant)
        end
    end

    return t6
end

local function scaled(p4, p5) -- line: 499
    return UDim2.new(p4.X.Scale * p5, p4.X.Offset * p5, p4.Y.Scale * p5, p4.Y.Offset * p5)
end

local function fadeGoal(p6, p7) -- line: 504
    local t10 = {}

    for _, v17 in ipairs(p6.props) do
        t10[v17.name] = v17.base + (1 - v17.base) * p7
    end

    return t10
end

local function applyFadeList(p8, p9) -- line: 512
    for _, v18 in ipairs(p8) do
        for _, v19 in ipairs(v18.props) do
            v18.inst[v19.name] = v19.base + (1 - v19.base) * p9
        end
    end
end

local t11 = {}
local t12 = {}

for _, v20 in ipairs(v5) do
    v10 = collectFade(v20.inst, t2)

    local t13 = {}

    v6 = nil

    for _, v21 in ipairs(v10) do
        if v21.inst ~= v20.inst or v6 then
            table.insert(t13, v21)
        else
            v6 = v21
        end
    end

    local t14 = {
        inst = v20.inst,
        fade = v10,
        rootFade = v6,
        subFade = t13,
        hidden = v20.hidden == true,
        homePos = v20.inst.Position,
        homeSize = v20.inst.Size,
        homeRot = v20.inst.Rotation,
        parkPos = v20.inst.Position + UDim2.fromScale(v20.dx, v20.dy),
        parkSize = scaled(v20.inst.Size, v20.scale),
        parkRot = v20.inst.Rotation + v20.rot,
        inDelay = v20.inDelay * 0.8,
        inTime = v20.inTime * 0.8,
        inFade = v20.inFade * 0.8,
        outDelay = v20.outDelay * 0.8,
        outTime = v20.outTime * 0.8
    }

    table.insert(t11, t14)

    if t14.hidden then
        table.insert(t12, t14)
    end
end

local t15 = {}

local function add(p10) -- line: 464
    -- upvalues: t5 (copy), t15 (copy)
    local v22 = t5[p10.ClassName]

    if not v22 then
        return
    end

    local t16 = {}

    for _, v23 in ipairs(v22) do
        local v24 = p10[v23]

        if typeof(v24) == "number" and v24 < 1 then
            table.insert(t16, {
                name = v23,
                base = v24
            })
        end
    end

    if #t16 > 0 then
        table.insert(t15, {
            inst = p10,
            props = t16,
            gui = p10:IsA("GuiObject")
        })
    end
end

add(BG)

for _, descendant in ipairs(BG:GetDescendants()) do
    add(descendant)
end

local n1 = 0
local v25 = false
local v26 = false
local v27 = false
local v28 = true
local t19 = {}
local v29

local function play(p11, p12, p13) -- line: 577
    -- upvalues: TweenService (copy), t19 (copy)
    local tween = TweenService:Create(p11, p12, p13)

    table.insert(t19, tween)
    tween:Play()

    return tween
end

local function stopTweens() -- line: 584
    -- upvalues: t19 (copy), v29 (ref)
    for _, v30 in ipairs(t19) do
        v30:Cancel()
    end

    table.clear(t19)

    if v29 then
        v29:Cancel()
        v29 = nil
    end
end

local function playFade(p14, p15, p16) -- line: 599
    -- upvalues: TweenService (copy), fadeGoal (copy), t19 (copy)
    if not p14.gui or p14.inst.Visible then
        local tween = TweenService:Create(p14.inst, p15, (fadeGoal(p14, p16)))

        table.insert(t19, tween)
        tween:Play()
    else
        for _, v32 in ipairs(p14.props) do
            p14.inst[v32.name] = v32.base + (1 - v32.base) * p16
        end
    end
end

local t20 = {
    PlaySprite = true,
    GradientLoop = true
}
local v33 = false

local function isArtScript(p17) -- line: 626
    -- upvalues: t20 (copy)
    if p17 == script then
        return false
    end

    return p17:IsA("BaseScript") and (t20[p17.Name] or p17:GetAttribute("ArtLoop") == true)
end

local function setSpriteRunning(p18) -- line: 632
    -- upvalues: Parent (copy), t20 (copy), v33 (ref)
    v33 = p18

    for _, descendant in ipairs(Parent:GetDescendants()) do
        if descendant ~= script and descendant:IsA("BaseScript") and (t20[descendant.Name] or descendant:GetAttribute("ArtLoop") == true) and descendant.Enabled ~= p18 then
            descendant.Enabled = p18
        end
    end
end

local function resetPress() -- line: 641
    -- upvalues: v4 (ref)
    if v4 then
        v4.Scale = 1
    end
end

local function park(p19) -- line: 647
    -- upvalues: applyFadeList (copy)
    p19.inst.Position = p19.parkPos
    p19.inst.Size = p19.parkSize
    p19.inst.Rotation = p19.parkRot
    applyFadeList(p19.fade, 1)
end

local function home(p20) -- line: 654
    p20.inst.Position = p20.homePos
    p20.inst.Size = p20.homeSize
    p20.inst.Rotation = p20.homeRot
end

local v34 = Vector2.new(0.5, 0.5)
local v35 = UDim2.fromScale(0.5, 0.5)
local t21 = {}
local t22 = {}

local function drawsSomething(p21, p22) -- line: 708
    for _, v36 in ipairs(p22) do
        if v36.inst == p21 or v36.inst:IsDescendantOf(p21) then
            return true
        end
    end

    return false
end

local function isSpacer(p23) -- line: 719
    if p23.BackgroundTransparency < 1 or p23:IsA("ImageLabel") or p23:IsA("ImageButton") then
        return false
    end

    for _, descendant in ipairs(p23:GetDescendants()) do
        if descendant:IsA("GuiObject") then
            return false
        end
    end

    return true
end

local function getItem(p24, p25, p26) -- line: 736
    -- upvalues: v3 (copy), t5 (copy), v34 (copy), v35 (copy), t21 (copy), drawsSomething (copy)
    local v37 = t21[p24]

    if v37 and not p25 then
        return v37
    end

    if p26 == "item" then
        local PopScale = p24:FindFirstChild("PopScale")

        if not (PopScale and PopScale:IsA("UIScale")) then
            PopScale = Instance.new("UIScale")
            PopScale.Name = "PopScale"
            PopScale.Parent = p24
        end

        PopScale.Scale = 1

        local v38 = v37 or {
            order = 0,
            index = 0,
            card = p24
        }

        v38.fade = v3
        v38.pops = { PopScale }
        v38.mode = "item"
        t21[p24] = v38

        return v38
    end

    local t23 = {}

    local function add(p27) -- line: 464
        -- upvalues: t23 (copy), t5 (copy)
        local v39 = t5[p27.ClassName]

        if not v39 then
            return
        end

        local t24 = {}

        for _, v40 in ipairs(v39) do
            local v41 = p27[v40]

            if typeof(v41) == "number" and v41 < 1 then
                table.insert(t24, {
                    name = v40,
                    base = v41
                })
            end
        end

        if #t24 > 0 then
            table.insert(t23, {
                inst = p27,
                props = t24,
                gui = p27:IsA("GuiObject")
            })
        end
    end

    add(p24)

    for _, descendant in ipairs(p24:GetDescendants()) do
        add(descendant)
    end

    local t27 = {}

    for _, child in ipairs(p24:GetChildren()) do
        if child:IsA("GuiObject") and child.AnchorPoint == v34 and child.Position == v35 and drawsSomething(child, t23) then
            local PopScale = child:FindFirstChild("PopScale")

            if not (PopScale and PopScale:IsA("UIScale")) then
                PopScale = Instance.new("UIScale")
                PopScale.Name = "PopScale"
                PopScale.Parent = child
            end

            PopScale.Scale = 1
            table.insert(t27, PopScale)
        end
    end

    local v42 = v37 or {
        order = 0,
        index = 0,
        card = p24
    }

    v42.fade = t23
    v42.pops = t27
    v42.mode = "layers"
    t21[p24] = v42

    return v42
end

local function forgetCard(p28) -- line: 786
    -- upvalues: t21 (copy), t22 (copy)
    t21[p28] = nil

    for i = #t22, 1, -1 do
        if t22[i].card == p28 then
            table.remove(t22, i)
        end
    end
end

local function sortCards(p29, p30) -- line: 795
    if p29.order == p30.order then
        return p29.index < p30.index
    end

    return p29.order < p30.order
end

local t28 = {}

local function collectGroup(p31, p32) -- line: 808
    -- upvalues: t22 (copy), isSpacer (copy), getItem (copy), sortCards (copy), t28 (copy)
    table.clear(t28)

    local container = p31.container

    if container.Visible then
        for v43, child in ipairs(container:GetChildren()) do
            if child:IsA("GuiObject") and child.Visible and not isSpacer(child) then
                local v44 = getItem(child, p32, p31.mode)

                v44.order = child.LayoutOrder
                v44.index = v43
                table.insert(t28, v44)
                table.insert(t22, v44)
            end
        end

        table.sort(t28, sortCards)
    end

    return t28
end

local function playItemsIn(p33) -- line: 828
    -- upvalues: TweenService (copy), t1 (copy), zero (copy), applyFadeList (copy), t19 (copy), playFade (copy), t22 (copy), collectGroup (copy)
    table.clear(t22)

    local n2 = 0

    for _, v45 in ipairs(t1) do
        if v45.mode == "item" and v45.container:IsA("ScrollingFrame") then
            v45.container.CanvasPosition = zero
        end

        local v46 = n2

        for v47, v48 in ipairs((collectGroup(v45, p33))) do
            local v49 = (0.4 + (v47 - 1) * 0.03) * 0.8
            local v50 = if v48.mode == "item" then 0 else 0.6

            applyFadeList(v48.fade, 1)

            for _, v51 in ipairs(v48.pops) do
                v51.Scale = v50
            end

            local v52 = TweenInfo.new(0.11200000000000002, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, 0, false, v49)

            for _, v53 in ipairs(v48.fade) do
                playFade(v53, v52, 0)
            end

            local Quint = v48.mode == "item" and Enum.EasingStyle.Quint or Enum.EasingStyle.Back
            local v54 = TweenInfo.new(0.272, Quint, Enum.EasingDirection.Out, 0, false, v49)

            for _, v55 in ipairs(v48.pops) do
                local tween = TweenService:Create(v55, v54, {
                    Scale = 1
                })

                table.insert(t19, tween)
                tween:Play()
            end

            v46 = math.max(v46, v49 + 0.272)
            n2 = v46
        end
    end

    return n2
end

local function playItemsOut(p34) -- line: 862
    -- upvalues: TweenService (copy), t1 (copy), t19 (copy), playFade (copy), t22 (copy), collectGroup (copy)
    table.clear(t22)

    local n3 = 0

    for _, v57 in ipairs(t1) do
        local v58 = collectGroup(v57, p34)
        local v59 = #v58
        local v60 = n3

        for v61, v62 in ipairs(v58) do
            local v63 = (v59 - v61) * 0.012 * 0.8
            local v64 = TweenInfo.new(0.128, Enum.EasingStyle.Quad, Enum.EasingDirection.In, 0, false, v63)

            for _, v65 in ipairs(v62.fade) do
                playFade(v65, v64, 1)
            end

            local v66 = if v62.mode == "item" then 0 else 0.8

            for _, v67 in ipairs(v62.pops) do
                local tween = TweenService:Create(v67, v64, {
                    Scale = v66
                })

                table.insert(t19, tween)
                tween:Play()
            end

            v60 = math.max(v60, v63 + 0.128)
            n3 = v60
        end
    end

    return n3
end

local function restoreItems() -- line: 887
    -- upvalues: applyFadeList (copy), t22 (copy)
    for _, v69 in ipairs(t22) do
        applyFadeList(v69.fade, 0)

        for _, v70 in ipairs(v69.pops) do
            v70.Scale = 1
        end
    end
end

local t31 = {}
local n4 = 0

for _, v71 in ipairs(t11) do
    if v71.inst == PaperNote1 or v71.inst == PaperNote2 then
        n4 += 1

        local v72 = n4 == 1

        table.insert(t31, {
            inst = v71.inst,
            homeRot = v71.homeRot,
            rate = 6.283185307179586 / (v72 and 2.6 or 3.1),
            phase = v72 and 0 or 1.9,
            sway = v72 and 1.5 or -1.5,
            last = v71.homeRot
        })
    end
end

local ImageColor3 = BG.ImageColor3
local v73 = false
local n5 = 1

local function idleStep(p35) -- line: 954
    -- upvalues: BG (copy), t31 (copy), ImageColor3 (copy), n5 (ref)
    for _, v74 in ipairs(t31) do
        local v76 = v74.homeRot + math.sin(p35 * v74.rate + v74.phase) * v74.sway

        if math.abs(v76 - v74.last) >= 0.05 then
            v74.last = v76
            v74.inst.Rotation = v76
        end
    end

    local v79 = 1 - (0.5 - math.cos(p35 * 1.7951958020513104) * 0.5) * 0.045

    if math.abs(v79 - n5) >= 0.0015 then
        n5 = v79
        BG.ImageColor3 = Color3.new(ImageColor3.R * v79, ImageColor3.G * v79, ImageColor3.B * v79)
    end
end

local function stopIdle() -- line: 975
    -- upvalues: BG (copy), t31 (copy), ImageColor3 (copy), v73 (ref), n5 (ref)
    v73 = false

    for _, v81 in ipairs(t31) do
        v81.inst.Rotation = v81.homeRot
        v81.last = v81.homeRot
    end

    BG.ImageColor3 = ImageColor3
    n5 = 1
end

local function runLaserCycle(p36) -- line: 1010
    -- upvalues: TweenService (copy), MiddleLaser (copy), n1 (ref), v29 (ref), setSpriteRunning (copy)
    if not MiddleLaser then
        return
    end

    while true do
        if n1 == p36 then
            local v82 = 4 + math.random() * 1
            local n6 = 0

            while n6 < v82 and n1 == p36 do
                local v83 = 0.05 + math.random() * 0.09

                task.wait(v83)
                n6 += v83
                MiddleLaser.ImageTransparency = math.random() < 0.22 and 0.2 + math.random() * 0.3 or 0
            end

            if n1 == p36 then
                v29 = TweenService:Create(MiddleLaser, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                    ImageTransparency = 1
                })
                v29:Play()
                task.wait(0.3)

                if n1 == p36 then
                    v29 = nil
                    MiddleLaser.Visible = false
                    setSpriteRunning(false)
                    task.wait(1.1 + math.random() * 0.7)

                    if n1 == p36 then
                        setSpriteRunning(true)
                        MiddleLaser.Visible = true
                        v29 = TweenService:Create(MiddleLaser, TweenInfo.new(0.26, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                            ImageTransparency = 0
                        })
                        v29:Play()
                        task.wait(0.26)

                        if n1 == p36 then
                            v29 = nil
                            continue
                        end
                    end
                end

                return
            end

            break
        end

        return
    end
end

local function isShown() -- line: 1068
    -- upvalues: Parent (copy)
    return Parent.Enabled and Parent.Parent ~= nil
end

local function snapOpenRest() -- line: 1074
    -- upvalues: MiddleLaser (copy), OpenAnimScale (ref), v4 (ref), applyFadeList (copy), t11 (copy), t15 (copy), restoreItems (copy)
    for _, v85 in ipairs(t11) do
        v85.inst.Position = v85.homePos
        v85.inst.Size = v85.homeSize
        v85.inst.Rotation = v85.homeRot
        applyFadeList(v85.fade, 0)
    end

    applyFadeList(t15, 0)
    OpenAnimScale.Scale = 1

    if v4 then
        v4.Scale = 1
    end

    if MiddleLaser then
        MiddleLaser.Visible = true
    end

    restoreItems()
end

local function finishClose() -- line: 1089
    -- upvalues: DRScrambleEventUIMain (copy), BG (copy), OpenAnimScale (ref), v4 (ref), applyFadeList (copy), t11 (copy), t15 (copy), v25 (ref), v26 (ref), v27 (ref), v28 (ref), stopTweens (copy), setSpriteRunning (copy), t22 (copy), restoreItems (copy), t31 (copy), ImageColor3 (copy), v73 (ref), n5 (ref)
    v25 = false
    v26 = false
    v27 = false
    v28 = true
    stopTweens()
    v73 = false

    for _, v86 in ipairs(t31) do
        v86.inst.Rotation = v86.homeRot
        v86.last = v86.homeRot
    end

    BG.ImageColor3 = ImageColor3
    n5 = 1
    DRScrambleEventUIMain.Visible = false
    OpenAnimScale.Scale = 1

    if v4 then
        v4.Scale = 1
    end

    setSpriteRunning(false)

    for _, v87 in ipairs(t11) do
        v87.inst.Position = v87.homePos
        v87.inst.Size = v87.homeSize
        v87.inst.Rotation = v87.homeRot
        applyFadeList(v87.fade, 1)
    end

    applyFadeList(t15, 1)
    restoreItems()
    table.clear(t22)
end

local function playOpen() -- line: 1112
    -- upvalues: TweenService (copy), Parent (copy), DRScrambleEventUIMain (copy), BG (copy), MiddleLaser (copy), OpenAnimScale (ref), v4 (ref), applyFadeList (copy), t11 (copy), t12 (copy), t15 (copy), n1 (ref), v25 (ref), v26 (ref), v27 (ref), v28 (ref), t19 (copy), stopTweens (copy), playFade (copy), setSpriteRunning (copy), playItemsIn (copy), t31 (copy), ImageColor3 (copy), v73 (ref), n5 (ref), idleStep (copy), runLaserCycle (copy), snapOpenRest (copy)
    local v88 = v28

    n1 += 1

    local v89 = n1

    v25 = true
    v26 = false
    v27 = false
    v28 = false
    stopTweens()
    v73 = false

    for _, v90 in ipairs(t31) do
        v90.inst.Rotation = v90.homeRot
        v90.last = v90.homeRot
    end

    BG.ImageColor3 = ImageColor3
    n5 = 1

    for _, v91 in ipairs(t11) do
        v91.inst.Position = v91.parkPos
        v91.inst.Size = v91.parkSize
        v91.inst.Rotation = v91.parkRot
        applyFadeList(v91.fade, 1)
    end

    applyFadeList(t15, 1)

    if MiddleLaser then
        MiddleLaser.Visible = true
    end

    setSpriteRunning(true)

    if v4 then
        v4.Scale = 1
    end

    OpenAnimScale.Scale = 0.88
    DRScrambleEventUIMain.Visible = true
    Parent.Enabled = true

    if Parent.Enabled and Parent.Parent ~= nil then
        local OpenAnimScale2 = OpenAnimScale
        local tween = TweenService:Create(OpenAnimScale2, TweenInfo.new(0.336, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
            Scale = 1
        })

        table.insert(t19, tween)
        tween:Play()

        local v93 = TweenInfo.new(0.11200000000000002, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

        for _, v94 in ipairs(t15) do
            playFade(v94, v93, 0)
        end

        if #t12 > 0 then
            task.delay(0.128, function() -- line: 1162
                -- upvalues: v89 (copy), applyFadeList (copy), t12 (copy), n1 (ref)
                if n1 ~= v89 then
                    return
                end

                for _, v95 in ipairs(t12) do
                    applyFadeList(v95.fade, 0)
                end
            end)
        end

        local n7 = 0.336

        for _, v96 in ipairs(t11) do
            local v97 = TweenInfo.new(v96.inTime, Enum.EasingStyle.Back, Enum.EasingDirection.Out, 0, false, v96.inDelay)
            local tween = TweenService:Create(v96.inst, v97, {
                Position = v96.homePos,
                Size = v96.homeSize,
                Rotation = v96.homeRot
            })

            table.insert(t19, tween)
            tween:Play()

            if not v96.hidden then
                local v98 = TweenInfo.new(v96.inFade, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, 0, false, v96.inDelay)

                for _, v99 in ipairs(v96.fade) do
                    playFade(v99, v98, 0)
                end
            end

            n7 = math.max(n7, v96.inDelay + v96.inTime)
        end

        local v102 = math.max(n7, (playItemsIn(v88)))

        task.delay(v102, function() -- line: 1209
            -- upvalues: v89 (copy), n1 (ref), v28 (ref), t19 (copy), v73 (ref), idleStep (copy), runLaserCycle (copy)
            if n1 ~= v89 then
                return
            end

            table.clear(t19)
            v28 = true

            if not v73 then
                v73 = true
                task.spawn(function() -- line: 994
                    -- upvalues: v89 (copy), n1 (ref), v73 (ref), idleStep (copy)
                    local n8 = 0

                    while true do
                        if v73 and n1 == v89 then
                            n8 += task.wait(0.05)

                            if v73 and n1 == v89 then
                                idleStep(n8)
                                continue
                            end

                            break
                        end

                        return
                    end
                end)
            end

            runLaserCycle(v89)
        end)
    else
        setSpriteRunning(false)
        snapOpenRest()
        v27 = true
        v28 = true
    end
end

local function playClose() -- line: 1224
    -- upvalues: TweenService (copy), Parent (copy), BG (copy), OpenAnimScale (ref), applyFadeList (copy), t11 (copy), t12 (copy), t15 (copy), n1 (ref), v25 (ref), v26 (ref), v27 (ref), v28 (ref), t19 (copy), stopTweens (copy), playFade (copy), playItemsOut (copy), t31 (copy), ImageColor3 (copy), v73 (ref), n5 (ref), finishClose (copy)
    local v103 = v28

    n1 += 1

    local v104 = n1

    v25 = false
    v26 = true
    v28 = false
    stopTweens()
    v73 = false

    for _, v105 in ipairs(t31) do
        v105.inst.Rotation = v105.homeRot
        v105.last = v105.homeRot
    end

    BG.ImageColor3 = ImageColor3
    n5 = 1

    if v27 or not Parent.Enabled or Parent.Parent == nil then
        finishClose()

        return
    end

    local n9 = 0

    for _, v106 in ipairs(t11) do
        local v107 = TweenInfo.new(v106.outTime, Enum.EasingStyle.Quad, Enum.EasingDirection.In, 0, false, v106.outDelay)
        local t35 = {
            Position = v106.parkPos,
            Size = v106.parkSize,
            Rotation = v106.parkRot
        }

        if not v106.hidden and v106.rootFade then
            for _, v108 in ipairs(v106.rootFade.props) do
                t35[v108.name] = 1
            end
        end

        local tween = TweenService:Create(v106.inst, v107, t35)

        table.insert(t19, tween)
        tween:Play()

        if not v106.hidden then
            for _, v109 in ipairs(v106.subFade) do
                playFade(v109, v107, 1)
            end
        end

        n9 = math.max(n9, v106.outDelay + v106.outTime)
    end

    local v112 = math.max(n9, (playItemsOut(v103)))

    if #t12 > 0 then
        task.delay(0.32000000000000006, function() -- line: 1283
            -- upvalues: v104 (copy), applyFadeList (copy), t12 (copy), n1 (ref)
            if n1 ~= v104 then
                return
            end

            for _, v113 in ipairs(t12) do
                applyFadeList(v113.fade, 1)
            end
        end)
    end

    local OpenAnimScale2 = OpenAnimScale
    local tween = TweenService:Create(OpenAnimScale2, TweenInfo.new(0.096, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, 0, false, 0.24000000000000002), {
        Scale = 1.03
    })

    table.insert(t19, tween)
    tween:Play()
    task.delay(0.336, function() -- line: 1301
        -- upvalues: v104 (copy), TweenService (copy), OpenAnimScale (ref), n1 (ref), t19 (copy)
        if n1 ~= v104 then
            return
        end

        local tween = TweenService:Create(OpenAnimScale, TweenInfo.new(0.272, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
            Scale = 0.9
        })

        table.insert(t19, tween)
        tween:Play()
    end)

    local v116 = TweenInfo.new(0.272, Enum.EasingStyle.Linear, Enum.EasingDirection.In, 0, false, 0.336)

    for _, v117 in ipairs(t15) do
        playFade(v117, v116, 1)
    end

    local v118 = math.max(v112, 0.32000000000000006, 0.6080000000000001) + 0.02

    task.delay(v118, function() -- line: 1322
        -- upvalues: v104 (copy), n1 (ref), finishClose (copy)
        if n1 == v104 then
            finishClose()
        end
    end)
end

local function setOpen(p37) -- line: 1331
    -- upvalues: v25 (ref), playOpen (copy), playClose (copy)
    if p37 ~= v25 then
        if p37 then
            playOpen()
        else
            playClose()
        end
    end
end

if Close then
    Close.Activated:Connect(function() -- line: 1343
        -- upvalues: TweenService (copy), Parent (copy), v4 (ref), v25 (ref)
        if v25 then
            TweenService:Create(v4, TweenInfo.new(0.06, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                Scale = 0.88
            }):Play()
            Parent:SetAttribute("Open", false)
        end
    end)
end

Parent:GetAttributeChangedSignal("Open"):Connect(function() -- line: 1358
    -- upvalues: Parent (copy), v25 (ref), playOpen (copy), playClose (copy)
    local v119 = Parent:GetAttribute("Open") == true

    if v119 ~= v25 then
        if v119 then
            playOpen()
        else
            playClose()
        end
    end
end)
Parent.DescendantAdded:Connect(function(p38) -- line: 1364
    -- upvalues: t20 (copy), v33 (ref)
    if not v33 and p38 ~= script and p38:IsA("BaseScript") and (t20[p38.Name] or p38:GetAttribute("ArtLoop") == true) then
        p38.Enabled = false
    end
end)

for _, v120 in ipairs(t1) do
    v120.container.ChildRemoved:Connect(forgetCard)
end

local function onShownChanged() -- line: 1407
    -- upvalues: Parent (copy), BG (copy), n1 (ref), v25 (ref), v26 (ref), v27 (ref), v28 (ref), stopTweens (copy), setSpriteRunning (copy), t31 (copy), ImageColor3 (copy), v73 (ref), n5 (ref), idleStep (copy), runLaserCycle (copy), snapOpenRest (copy), finishClose (copy)
    if Parent.Enabled and Parent.Parent ~= nil then
        if v27 then
            v27 = false
            n1 += 1

            local v121 = n1

            setSpriteRunning(true)

            if not v73 then
                v73 = true
                task.spawn(function() -- line: 994
                    -- upvalues: v121 (copy), n1 (ref), v73 (ref), idleStep (copy)
                    local n10 = 0

                    while true do
                        if v73 and n1 == v121 then
                            n10 += task.wait(0.05)

                            if v73 and n1 == v121 then
                                idleStep(n10)
                                continue
                            end

                            break
                        end

                        return
                    end
                end)
            end

            task.spawn(runLaserCycle, v121)
        end
    elseif v25 and not v27 or v26 then
        n1 += 1

        if v26 or not v25 then
            finishClose()
        else
            stopTweens()
            v73 = false

            for _, v125 in ipairs(t31) do
                v125.inst.Rotation = v125.homeRot
                v125.last = v125.homeRot
            end

            BG.ImageColor3 = ImageColor3
            n5 = 1
            setSpriteRunning(false)
            snapOpenRest()
            v27 = true
            v28 = true
        end
    end
end

local function onMainVisibleChanged() -- line: 1420
    -- upvalues: Parent (copy), DRScrambleEventUIMain (copy), n1 (ref), v25 (ref), v26 (ref), finishClose (copy), playOpen (copy)
    if DRScrambleEventUIMain.Visible then
        if not (v25 or v26) then
            if v25 ~= true then
                playOpen()
            end

            Parent:SetAttribute("Open", true)
        end
    elseif v25 or v26 then
        n1 += 1
        finishClose()
        Parent:SetAttribute("Open", false)
    end
end

DRScrambleEventUIMain.Visible = false
setSpriteRunning(false)

for _, v126 in ipairs(t11) do
    applyFadeList(v126.fade, 1)
end

applyFadeList(t15, 1)

if Parent:GetAttribute("Open") == true then
    playOpen()
elseif Parent:GetAttribute("Open") == nil then
    Parent:SetAttribute("Open", false)
end

Parent:GetPropertyChangedSignal("Enabled"):Connect(onShownChanged)
Parent.AncestryChanged:Connect(onShownChanged)
DRScrambleEventUIMain:GetPropertyChangedSignal("Visible"):Connect(onMainVisibleChanged)
Parent.Destroying:Once(function() -- line: 1462
    -- upvalues: n1 (ref), stopTweens (copy), setSpriteRunning (copy), t21 (copy), t22 (copy)
    n1 += 1
    stopTweens()
    setSpriteRunning(false)
    table.clear(t22)
    table.clear(t21)
end)
