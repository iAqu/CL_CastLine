-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local Parent, Parent2 = script.Parent, script.Parent
local BG = Parent2:WaitForChild("BG")
local ShadowBG = Parent2:FindFirstChild("ShadowBG")
local StrokeBG = Parent2:FindFirstChild("StrokeBG")
local Content = Parent2:FindFirstChild("Content")
local Close = Parent2:FindFirstChild("Close")
local CheckItOutBtn = Parent2:FindFirstChild("CheckItOutBtn")
local v2 = Content and Content:FindFirstChild("Icon")
local v3 = Content and Content:FindFirstChild("EggName")
local v4 = Content and Content:FindFirstChild("Label")
local v5 = Content and Content:FindFirstChild("Item")
local v6 = Content and Content:FindFirstChild("NewLabel")
local v1 = Content and Content:FindFirstChild("TimerHolder")
local Icon = v1 and v1:FindFirstChild("Icon")
local UIScale = v2 and v2:FindFirstChildOfClass("UIScale")
local UIScale2 = Icon and Icon:FindFirstChildOfClass("UIScale")

local function ensureScale(p1, p2) -- line: 84
    if not p1 then
        return nil
    end

    local v7 = p1:FindFirstChild(p2)

    if not (v7 and v7:IsA("UIScale")) then
        v7 = Instance.new("UIScale")
        v7.Name = p2
        v7.Parent = p1
    end

    v7.Scale = 1

    return v7
end

local OpenAnimScale

if Parent2 then
    OpenAnimScale = Parent2:FindFirstChild("OpenAnimScale")

    if not OpenAnimScale or not OpenAnimScale:IsA("UIScale") then
        OpenAnimScale = Instance.new("UIScale")
        OpenAnimScale.Name = "OpenAnimScale"
        OpenAnimScale.Parent = Parent2
    end

    OpenAnimScale.Scale = 1
end

local PressScale

if Close then
    PressScale = Close:FindFirstChild("PressScale")

    if not PressScale or not PressScale:IsA("UIScale") then
        PressScale = Instance.new("UIScale")
        PressScale.Name = "PressScale"
        PressScale.Parent = Close
    end

    PressScale.Scale = 1
end

local t1 = {
    {
        dx = 0,
        dy = 0,
        rot = 0,
        scale = 0.94,
        inDelay = 0.06,
        inFade = 0.16,
        outDelay = 0.08,
        inst = ShadowBG
    },
    {
        dx = -0.06,
        dy = 0,
        rot = 0,
        scale = 0.92,
        inDelay = 0.14,
        inFade = 0.18,
        outDelay = 0.04,
        inst = v1
    },
    {
        dx = 0,
        dy = 0,
        rot = 0,
        scale = 1,
        scaleFrom = 0.55,
        inDelay = 0.24,
        inFade = 0.14,
        outDelay = 0,
        inst = Icon,
        scaleObject = UIScale2
    },
    {
        dx = -0.03,
        dy = -0.04,
        rot = 0,
        scale = 0.96,
        inDelay = 0.18,
        inFade = 0.18,
        outDelay = 0.06,
        inst = v3
    },
    {
        dx = -0.03,
        dy = -0.04,
        rot = 0,
        scale = 0.96,
        inDelay = 0.22,
        inFade = 0.18,
        outDelay = 0.06,
        inst = v4
    },
    {
        dx = 0,
        dy = 0,
        rot = -6,
        scale = 0.6,
        inDelay = 0.26,
        inFade = 0.14,
        outDelay = 0.02,
        inst = v6
    },
    {
        dx = 0.07,
        dy = 0.03,
        rot = 4,
        scale = 0.94,
        inDelay = 0.3,
        inFade = 0.18,
        outDelay = 0,
        inst = v5
    },
    {
        dx = 0,
        dy = 0,
        rot = 0,
        scale = 1,
        scaleFrom = 0.8,
        inDelay = 0.34,
        inFade = 0.18,
        outDelay = 0.02,
        inst = v2,
        scaleObject = UIScale
    },
    {
        dx = 0,
        dy = 0.06,
        rot = 0,
        scale = 0.88,
        inDelay = 0.38,
        inFade = 0.18,
        outDelay = 0.02,
        inst = CheckItOutBtn
    },
    {
        dx = 0,
        dy = -0.03,
        rot = 0,
        scale = 0.7,
        inDelay = 0.42,
        inFade = 0.16,
        outDelay = 0,
        inst = Close
    }
}

for i = #t1, 1, -1 do
    if not t1[i].inst then
        table.remove(t1, i)
    end
end

local t2 = {}

for _, v8 in ipairs(t1) do
    t2[v8.inst] = true
end

if Content then
    local n1 = 0

    for _, child in ipairs(Content:GetChildren()) do
        if child:IsA("GuiObject") and not t2[child] then
            table.insert(t1, {
                dx = 0,
                dy = 0.04,
                rot = 0,
                scale = 0.95,
                inFade = 0.18,
                outDelay = 0.04,
                inst = child,
                inDelay = n1 * 0.04 + 0.46
            })
            n1 += 1
        end
    end
end

local t4 = {
    ImageLabel = { "ImageTransparency", "BackgroundTransparency" },
    ImageButton = { "ImageTransparency", "BackgroundTransparency" },
    TextLabel = { "TextTransparency", "TextStrokeTransparency", "BackgroundTransparency" },
    TextButton = { "TextTransparency", "TextStrokeTransparency", "BackgroundTransparency" },
    TextBox = { "TextTransparency", "TextStrokeTransparency", "BackgroundTransparency" },
    Frame = { "BackgroundTransparency" },
    CanvasGroup = { "GroupTransparency", "BackgroundTransparency" },
    ScrollingFrame = { "ScrollBarImageTransparency", "BackgroundTransparency" },
    ViewportFrame = { "ImageTransparency", "BackgroundTransparency" },
    UIStroke = { "Transparency" },
    UIShadow = { "Transparency" }
}

local function collectFade(p3, p4) -- line: 205
    -- upvalues: t4 (copy)
    local t5 = {}

    local function add(p5) -- line: 208
        -- upvalues: t5 (copy), t4 (copy)
        local v9 = t4[p5.ClassName]

        if not v9 then
            return
        end

        local t6 = {}

        for _, v10 in ipairs(v9) do
            local v11 = p5[v10]

            if typeof(v11) == "number" and v11 < 1 then
                table.insert(t6, {
                    name = v10,
                    base = v11
                })
            end
        end

        if #t6 > 0 then
            table.insert(t5, {
                inst = p5,
                props = t6,
                gui = p5:IsA("GuiObject")
            })
        end
    end

    add(p3)

    for _, descendant in ipairs(p3:GetDescendants()) do
        local v12 = false

        if p4 then
            for _, v13 in ipairs(p4) do
                if v13 ~= p3 and (descendant == v13 or descendant:IsDescendantOf(v13)) then
                    v12 = true
                    break
                end

                v12 = false
            end
        end

        if not v12 then
            add(descendant)
        end
    end

    return t5
end

local function scaled(p6, p7) -- line: 243
    return UDim2.new(p6.X.Scale * p7, p6.X.Offset * p7, p6.Y.Scale * p7, p6.Y.Offset * p7)
end

local function fadeGoal(p8, p9) -- line: 248
    local t9 = {}

    for _, v14 in ipairs(p8.props) do
        t9[v14.name] = v14.base + (1 - v14.base) * p9
    end

    return t9
end

local function applyFadeList(p10, p11) -- line: 256
    for _, v15 in ipairs(p10) do
        for _, v16 in ipairs(v15.props) do
            v15.inst[v16.name] = v16.base + (1 - v16.base) * p11
        end
    end
end

local t10 = {}

for _, v17 in ipairs(t1) do
    table.insert(t10, v17.inst)
end

local t11 = {}

for _, v18 in ipairs(t1) do
    table.insert(t11, {
        inTime = 0.272,
        outTime = 0.128,
        inst = v18.inst,
        fade = collectFade(v18.inst, t10),
        homePos = v18.inst.Position,
        homeSize = v18.inst.Size,
        homeRot = v18.inst.Rotation,
        parkPos = v18.inst.Position + UDim2.fromScale(v18.dx, v18.dy),
        parkSize = scaled(v18.inst.Size, v18.scale),
        parkRot = v18.inst.Rotation + v18.rot,
        scaleObject = v18.scaleObject,
        scaleHome = v18.scaleObject and v18.scaleObject.Scale or nil,
        scaleFrom = v18.scaleObject and v18.scaleObject.Scale * (v18.scaleFrom or 0.8) or nil,
        inDelay = v18.inDelay * 0.8,
        inFade = v18.inFade * 0.8,
        outDelay = v18.outDelay * 0.8
    })
end

local t13 = {}

for _, v19 in ipairs({ BG, StrokeBG }) do
    if v19 then
        local _ipairs = ipairs
        local t14 = {}

        local function add(p12) -- line: 208
            -- upvalues: t4 (copy), t14 (copy)
            local v20 = t4[p12.ClassName]

            if not v20 then
                return
            end

            local t15 = {}

            for _, v21 in ipairs(v20) do
                local v22 = p12[v21]

                if typeof(v22) == "number" and v22 < 1 then
                    table.insert(t15, {
                        name = v21,
                        base = v22
                    })
                end
            end

            if #t15 > 0 then
                table.insert(t14, {
                    inst = p12,
                    props = t15,
                    gui = p12:IsA("GuiObject")
                })
            end
        end

        add(v19)

        for _, descendant in ipairs(v19:GetDescendants()) do
            add(descendant)
        end

        for _, v23 in _ipairs(t14) do
            table.insert(t13, v23)
        end
    end
end

local n2 = 0
local v24 = false
local v25 = false
local v26 = false
local t18 = {}

local function play(p13, p14, p15) -- line: 312
    -- upvalues: TweenService (copy), t18 (copy)
    local tween = TweenService:Create(p13, p14, p15)

    table.insert(t18, tween)
    tween:Play()

    return tween
end

local function stopTweens() -- line: 319
    -- upvalues: t18 (copy)
    for _, v27 in ipairs(t18) do
        v27:Cancel()
    end

    table.clear(t18)
end

local function playFade(p16, p17, p18) -- line: 329
    -- upvalues: TweenService (copy), fadeGoal (copy), t18 (copy)
    if not p16.gui or p16.inst.Visible then
        local tween = TweenService:Create(p16.inst, p17, (fadeGoal(p16, p18)))

        table.insert(t18, tween)
        tween:Play()
    else
        for _, v29 in ipairs(p16.props) do
            p16.inst[v29.name] = v29.base + (1 - v29.base) * p18
        end
    end
end

local function setArtRunning(p19) -- line: 350
    -- upvalues: Parent (copy)
    Parent:SetAttribute("UIEffectsPaused", not p19 or nil)
end

local function park(p20) -- line: 356
    -- upvalues: applyFadeList (copy)
    p20.inst.Position = p20.parkPos
    p20.inst.Size = p20.parkSize
    p20.inst.Rotation = p20.parkRot

    if p20.scaleObject then
        p20.scaleObject.Scale = p20.scaleFrom
    end

    applyFadeList(p20.fade, 1)
end

local function home(p21) -- line: 366
    p21.inst.Position = p21.homePos
    p21.inst.Size = p21.homeSize
    p21.inst.Rotation = p21.homeRot

    if p21.scaleObject then
        p21.scaleObject.Scale = p21.scaleHome
    end
end

local function snapOpenRest() -- line: 375
    -- upvalues: Parent2 (copy), OpenAnimScale (ref), PressScale (ref), applyFadeList (copy), t11 (copy), t13 (copy)
    for _, v31 in ipairs(t11) do
        v31.inst.Position = v31.homePos
        v31.inst.Size = v31.homeSize
        v31.inst.Rotation = v31.homeRot

        if v31.scaleObject then
            v31.scaleObject.Scale = v31.scaleHome
        end

        applyFadeList(v31.fade, 0)
    end

    applyFadeList(t13, 0)
    OpenAnimScale.Scale = 1

    if PressScale then
        PressScale.Scale = 1
    end

    Parent2.Visible = true
end

local function finishClose() -- line: 388
    -- upvalues: Parent (copy), Parent2 (copy), OpenAnimScale (ref), PressScale (ref), applyFadeList (copy), t11 (copy), t13 (copy), v24 (ref), v25 (ref), t18 (copy)
    for _, v32 in ipairs(t18) do
        v32:Cancel()
    end

    table.clear(t18)
    Parent:SetAttribute("UIEffectsPaused", true)
    Parent2.Visible = false
    OpenAnimScale.Scale = 1

    if PressScale then
        PressScale.Scale = 1
    end

    for _, v33 in ipairs(t11) do
        v33.inst.Position = v33.homePos
        v33.inst.Size = v33.homeSize
        v33.inst.Rotation = v33.homeRot

        if v33.scaleObject then
            v33.scaleObject.Scale = v33.scaleHome
        end

        applyFadeList(v33.fade, 1)
    end

    applyFadeList(t13, 1)
    v24 = false
    v25 = false
end

local function isShown() -- line: 405
    -- upvalues: Parent (copy)
    return Parent.Visible and Parent:IsDescendantOf(game)
end

local function playOpen() -- line: 411
    -- upvalues: TweenService (copy), Parent (copy), Parent2 (copy), OpenAnimScale (ref), PressScale (ref), applyFadeList (copy), t11 (copy), t13 (copy), n2 (ref), v24 (ref), v25 (ref), v26 (ref), t18 (copy), playFade (copy), snapOpenRest (copy)
    n2 += 1

    local v34 = n2

    v24 = true
    v25 = false
    v26 = false

    for _, v35 in ipairs(t18) do
        v35:Cancel()
    end

    table.clear(t18)
    Parent:SetAttribute("UIEffectsPaused", true)

    for _, v36 in ipairs(t11) do
        v36.inst.Position = v36.parkPos
        v36.inst.Size = v36.parkSize
        v36.inst.Rotation = v36.parkRot

        if v36.scaleObject then
            v36.scaleObject.Scale = v36.scaleFrom
        end

        applyFadeList(v36.fade, 1)
    end

    applyFadeList(t13, 1)
    OpenAnimScale.Scale = 0.9

    if PressScale then
        PressScale.Scale = 1
    end

    Parent2.Visible = true

    if not Parent.Visible or not Parent:IsDescendantOf(game) then
        snapOpenRest()
        v26 = true

        return
    end

    local v37 = TweenInfo.new(0.336, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
    local t19 = {
        Scale = 1
    }
    local tween = TweenService:Create(OpenAnimScale, v37, t19)

    table.insert(t18, tween)
    tween:Play()

    local v38 = TweenInfo.new(0.11200000000000002, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

    for _, v39 in ipairs(t13) do
        playFade(v39, v38, 0)
    end

    local n3 = 0.336

    for _, v40 in ipairs(t11) do
        local v41 = TweenInfo.new(v40.inTime, Enum.EasingStyle.Back, Enum.EasingDirection.Out, 0, false, v40.inDelay)
        local tween = TweenService:Create(v40.inst, v41, {
            Position = v40.homePos,
            Size = v40.homeSize,
            Rotation = v40.homeRot
        })

        table.insert(t18, tween)
        tween:Play()

        if v40.scaleObject then
            local tween = TweenService:Create(v40.scaleObject, v41, {
                Scale = v40.scaleHome
            })

            table.insert(t18, tween)
            tween:Play()
        end

        local v42 = TweenInfo.new(v40.inFade, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, 0, false, v40.inDelay)

        for _, v43 in ipairs(v40.fade) do
            playFade(v43, v42, 0)
        end

        n3 = math.max(n3, v40.inDelay + v40.inTime)
    end

    task.delay(n3, function() -- line: 467
        -- upvalues: v34 (copy), Parent (copy), n2 (ref), v24 (ref), v26 (ref)
        if n2 == v34 and v24 and not v26 then
            Parent:SetAttribute("UIEffectsPaused", nil)
        end
    end)
end

local function playClose() -- line: 476
    -- upvalues: TweenService (copy), Parent (copy), OpenAnimScale (ref), t11 (copy), t13 (copy), n2 (ref), v24 (ref), v25 (ref), v26 (ref), t18 (copy), playFade (copy), finishClose (copy)
    n2 += 1

    local v45 = n2

    v24 = false
    v25 = true

    for _, v46 in ipairs(t18) do
        v46:Cancel()
    end

    table.clear(t18)
    Parent:SetAttribute("UIEffectsPaused", true)

    if v26 or not Parent.Visible or not Parent:IsDescendantOf(game) then
        finishClose()
        v26 = false

        return
    end

    local n4 = 0

    for _, v47 in ipairs(t11) do
        local v48 = TweenInfo.new(v47.outTime, Enum.EasingStyle.Quad, Enum.EasingDirection.In, 0, false, v47.outDelay)
        local tween = TweenService:Create(v47.inst, v48, {
            Position = v47.parkPos,
            Size = v47.parkSize,
            Rotation = v47.parkRot
        })

        table.insert(t18, tween)
        tween:Play()

        if v47.scaleObject then
            local tween = TweenService:Create(v47.scaleObject, v48, {
                Scale = v47.scaleFrom
            })

            table.insert(t18, tween)
            tween:Play()
        end

        for _, v49 in ipairs(v47.fade) do
            playFade(v49, v48, 1)
        end

        n4 = math.max(n4, v47.outDelay + v47.outTime)
    end

    local v51 = TweenInfo.new(0.096, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, 0, false, 0.19199999999999998)
    local t24 = {
        Scale = 1.03
    }
    local tween = TweenService:Create(OpenAnimScale, v51, t24)

    table.insert(t18, tween)
    tween:Play()
    task.delay(0.288, function() -- line: 514
        -- upvalues: v45 (copy), TweenService (copy), OpenAnimScale (ref), n2 (ref), t18 (copy)
        if n2 ~= v45 then
            return
        end

        local v52 = TweenInfo.new(0.272, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
        local t25 = {
            Scale = 0.9
        }
        local tween = TweenService:Create(OpenAnimScale, v52, t25)

        table.insert(t18, tween)
        tween:Play()
    end)

    local v53 = TweenInfo.new(0.272, Enum.EasingStyle.Linear, Enum.EasingDirection.In, 0, false, 0.288)

    for _, v54 in ipairs(t13) do
        playFade(v54, v53, 1)
    end

    local v55 = math.max(n4, 0.56) + 0.02

    task.delay(v55, function() -- line: 530
        -- upvalues: v45 (copy), n2 (ref), finishClose (copy)
        if n2 == v45 then
            finishClose()
        end
    end)
end

local function setOpen(p22) -- line: 539
    -- upvalues: v24 (ref), v25 (ref), playOpen (copy), playClose (copy)
    if p22 ~= v24 or p22 and v25 then
        if p22 then
            playOpen()
        else
            playClose()
        end
    end
end

if Close then
    local Activated = Close.Activated
    local PressScale2 = PressScale

    Activated:Connect(function() -- line: 551
        -- upvalues: TweenService (copy), Parent (copy), v24 (ref), PressScale2 (copy)
        if v24 then
            if PressScale2 then
                TweenService:Create(PressScale2, TweenInfo.new(0.06, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                    Scale = 0.88
                }):Play()
            end

            Parent:SetAttribute("Open", false)
        end
    end)
end

Parent:GetAttributeChangedSignal("Open"):Connect(function() -- line: 566
    -- upvalues: Parent (copy), v24 (ref), v25 (ref), playOpen (copy), playClose (copy)
    local v56 = Parent:GetAttribute("Open") == true

    if v56 == v24 and (not v56 or not v25) then
        return
    end

    if v56 then
        playOpen()
    else
        playClose()
    end
end)

local function onShownChanged() -- line: 591
    -- upvalues: Parent (copy), n2 (ref), v24 (ref), v25 (ref), v26 (ref), t18 (copy), snapOpenRest (copy), finishClose (copy)
    if Parent.Visible and Parent:IsDescendantOf(game) then
        if v26 and v24 then
            v26 = false
            n2 += 1
            Parent:SetAttribute("UIEffectsPaused", nil)
        end
    elseif v24 and not v26 or v25 then
        n2 += 1

        if v25 or not v24 then
            finishClose()
        else
            for _, v60 in ipairs(t18) do
                v60:Cancel()
            end

            table.clear(t18)
            Parent:SetAttribute("UIEffectsPaused", true)
            snapOpenRest()
            v26 = true
        end
    end
end

local function onMainVisibleChanged() -- line: 604
    -- upvalues: Parent (copy), Parent2 (copy), n2 (ref), v24 (ref), v25 (ref), finishClose (copy), playOpen (copy)
    if Parent2.Visible then
        if not (v24 or v25) then
            if v24 ~= true or v25 then
                playOpen()
            end

            Parent:SetAttribute("Open", true)
        end
    elseif v24 or v25 then
        n2 += 1
        finishClose()
        Parent:SetAttribute("Open", false)
    end
end

Parent2.Visible = false
Parent:SetAttribute("UIEffectsPaused", true)

for _, v61 in ipairs(t11) do
    applyFadeList(v61.fade, 1)
end

applyFadeList(t13, 1)

if Parent:GetAttribute("Open") == true then
    playOpen()
elseif Parent:GetAttribute("Open") == nil then
    Parent:SetAttribute("Open", false)
end

Parent:GetPropertyChangedSignal("Visible"):Connect(onShownChanged)
Parent.AncestryChanged:Connect(onShownChanged)
Parent2:GetPropertyChangedSignal("Visible"):Connect(onMainVisibleChanged)
Parent.Destroying:Once(function() -- line: 639
    -- upvalues: Parent (copy), n2 (ref), t18 (copy)
    n2 += 1

    for _, v62 in ipairs(t18) do
        v62:Cancel()
    end

    table.clear(t18)
    Parent:SetAttribute("UIEffectsPaused", true)
end)
task.spawn(function() -- line: 645
    -- upvalues: ReplicatedStorage (copy), TweenService (copy), Parent (copy), Content (copy)
    local LimitedEgg = require(ReplicatedStorage.Data.LimitedEgg)
    local Assets = require(ReplicatedStorage.Data.Assets)
    local AssetId = LimitedEgg.MechaReroll.Entries[1].AssetId
    local v63 = Assets.Directory[AssetId]
    local Icon, Icon2 = Content.Item.Icon, Content.Item.Icon2

    Icon.Image = v63.Icon
    Icon2.Image = v63.Icon

    local n5 = 1

    while true do
        if not (Parent.Visible and Parent:IsDescendantOf(game)) then
            Parent:GetPropertyChangedSignal("Visible"):Wait()
        end

        n5 = n5 % #LimitedEgg.MechaReroll.Entries + 1

        local AssetId = LimitedEgg.MechaReroll.Entries[n5].AssetId
        local v64 = Assets.Directory[AssetId]

        Icon2.Image = v64.Icon
        TweenService:Create(Icon, TweenInfo.new(0.5), {
            ImageTransparency = 1
        }):Play()
        TweenService:Create(Icon2, TweenInfo.new(0.5), {
            ImageTransparency = 0
        }):Play()
        task.wait(1)
        Icon.Image = v64.Icon
        Icon.ImageTransparency = 0
        Icon2.ImageTransparency = 1
        task.wait(1)
    end
end)
