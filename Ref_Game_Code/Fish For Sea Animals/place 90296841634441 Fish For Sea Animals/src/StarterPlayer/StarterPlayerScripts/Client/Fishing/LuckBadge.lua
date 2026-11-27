-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Config = require(ReplicatedStorage.Shared.Config)
local UIUtil = require(script.Parent.Parent.UI.UIUtil)
local t1 = {}
local v1 = Color3.fromRGB(20, 20, 30)
local v2 = Color3.new(1, 1, 1)
local v3 = Random.new()
local t2 = {}

local function star(p1, p2, p3, p4, p5, p6) -- line: 57
    -- upvalues: v1 (copy), v2 (copy)
    local t3 = if p6 then { true, false } else { false }

    for _, v4 in t3 do
        for i = 0, p2 - 1 do
            local Frame = Instance.new("Frame")

            Frame.Name = v4 and "Outline" or "Fill"
            Frame.AnchorPoint = Vector2.new(0.5, 0.5)
            Frame.Position = UDim2.fromScale(0.5, 0.5)

            if v4 then
                Frame.Size = UDim2.new(p4 * 0.7, 12, p4 * 0.7, 12)
            else
                Frame.Size = UDim2.fromScale(p4 * 0.7, p4 * 0.7)
            end

            Frame.Rotation = i * 90 / p2
            Frame.BorderSizePixel = 0

            if v4 then
                Frame.BackgroundColor3 = v1
            else
                Frame.BackgroundColor3 = p3
            end

            Frame.ZIndex = p5 + (v4 and 0 or 1)

            local UICorner = Instance.new("UICorner")

            UICorner.CornerRadius = UDim.new(0.1, 0)
            UICorner.Parent = Frame

            if not v4 then
                local UIGradient = Instance.new("UIGradient")

                UIGradient.Rotation = 90 - Frame.Rotation
                UIGradient.Color = ColorSequence.new(p3:Lerp(v2, 0.35), p3:Lerp(v1, 0.2))
                UIGradient.Parent = Frame
            end

            Frame.Parent = p1
        end
    end
end

local function circle(p7, p8, p9, p10) -- line: 87
    local Frame = Instance.new("Frame")

    Frame.Name = p7
    Frame.AnchorPoint = Vector2.new(0.5, 0.5)
    Frame.Position = UDim2.fromScale(0.5, 0.5)
    Frame.BackgroundColor3 = p8
    Frame.BackgroundTransparency = p9
    Frame.BorderSizePixel = 0
    Frame.ZIndex = p10

    local UICorner = Instance.new("UICorner")

    UICorner.CornerRadius = UDim.new(0.5, 0)
    UICorner.Parent = Frame

    return Frame
end

local function twinkle(p11, p12) -- line: 103
    local Frame = Instance.new("Frame")

    Frame.Name = "Twinkle"
    Frame.BackgroundTransparency = 1
    Frame.AnchorPoint = Vector2.new(0.5, 0.5)
    Frame.ZIndex = p12

    for i = 0, 1 do
        local Frame2 = Instance.new("Frame")

        Frame2.AnchorPoint = Vector2.new(0.5, 0.5)
        Frame2.Position = UDim2.fromScale(0.5, 0.5)
        Frame2.Size = UDim2.fromScale(0.22, 1)
        Frame2.Rotation = i * 90
        Frame2.BorderSizePixel = 0
        Frame2.BackgroundColor3 = p11
        Frame2.ZIndex = p12

        local UICorner = Instance.new("UICorner")

        UICorner.CornerRadius = UDim.new(0.5, 0)
        UICorner.Parent = Frame2

        local UIGradient = Instance.new("UIGradient")

        UIGradient.Rotation = 90
        UIGradient.Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 1),
            NumberSequenceKeypoint.new(0.5, 0),
            NumberSequenceKeypoint.new(1, 1)
        })
        UIGradient.Parent = Frame2
        Frame2.Parent = Frame
    end

    return Frame
end

local function ring(p13, p14, p15, p16, p17, p18, p19) -- line: 131
    -- upvalues: UIUtil (copy), circle (copy)
    task.delay(p19 or 0, function() -- line: 132
        -- upvalues: p13 (copy), p14 (copy), p15 (copy), p16 (copy), p17 (copy), p18 (copy), UIUtil (copy), circle (copy)
        if p13.Parent then
            local v5 = circle("Ring", p14, 1, 0)

            v5.Size = UDim2.fromScale(p15, p15)

            local UIStroke = Instance.new("UIStroke")

            UIStroke.Color = p14
            UIStroke.Thickness = p18 * UIUtil.scale
            UIStroke.Parent = v5
            v5.Parent = p13
            UIUtil.tween(v5, p17, {
                Size = UDim2.fromScale(p16, p16)
            }, Enum.EasingStyle.Quart)
            UIUtil.tween(UIStroke, p17, {
                Thickness = 0,
                Transparency = 1
            }, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
            task.delay(p17 + 0.05, v5.Destroy, v5)
        end
    end)
end

local function sparks(p20, p21, p22, p23, p24) -- line: 150
    -- upvalues: UIUtil (copy), v2 (copy), v3 (copy)
    for i = 1, p22 do
        local v6 = i / p22 * 3.141592653589793 * 2 + v3:NextNumber(-0.2, 0.2)
        local v7 = Vector2.new(math.cos(v6), (math.sin(v6)))
        local Frame = Instance.new("Frame")

        Frame.Name = "Spark"
        Frame.AnchorPoint = Vector2.new(0.5, 0.5)
        Frame.BorderSizePixel = 0

        if i % 3 == 0 then
            Frame.BackgroundColor3 = v2
        else
            Frame.BackgroundColor3 = p21:Lerp(v2, 0.25)
        end

        Frame.Position = UDim2.fromScale(0.5 + v7.X * 0.3, 0.5 + v7.Y * 0.3)

        local v8 = v3:NextNumber(0.1, 0.2)

        Frame.Size = UDim2.fromScale(0.035, v8)
        Frame.Rotation = math.deg(v6) + 90
        Frame.ZIndex = 3

        local UICorner = Instance.new("UICorner")

        UICorner.CornerRadius = UDim.new(0.5, 0)
        UICorner.Parent = Frame
        Frame.Parent = p20

        local v9 = p23 * v3:NextNumber(0.75, 1.1)
        local v10 = p24 * v3:NextNumber(0.8, 1.1)

        UIUtil.tween(Frame, v10, {
            BackgroundTransparency = 1,
            Position = UDim2.fromScale(0.5 + v7.X * v9, 0.5 + v7.Y * v9),
            Size = UDim2.fromScale(0.01, v8 * 0.3)
        }, Enum.EasingStyle.Quart)
        task.delay(v10 + 0.05, Frame.Destroy, Frame)
    end
end

local function makeBadge(p25) -- line: 175
    -- upvalues: Config (copy), v2 (copy), star (copy)
    local Color = Config.LuckStages[p25].Color
    local CanvasGroup = Instance.new("CanvasGroup")

    CanvasGroup.Name = "Rung" .. p25
    CanvasGroup.BackgroundTransparency = 1
    CanvasGroup.AnchorPoint = Vector2.new(0.5, 0.5)
    CanvasGroup.Position = UDim2.fromScale(0.5, 0.5)
    CanvasGroup.Size = UDim2.fromScale(1, 1)

    if p25 >= 3 then
        local ImageLabel = Instance.new("ImageLabel")

        ImageLabel.Name = "Rays"
        ImageLabel.BackgroundTransparency = 1
        ImageLabel.Image = "rbxassetid://86205314584043"
        ImageLabel.ImageColor3 = Color:Lerp(v2, 0.4)
        ImageLabel.ImageTransparency = 0.15
        ImageLabel.AnchorPoint = Vector2.new(0.5, 0.5)
        ImageLabel.Position = UDim2.fromScale(0.5, 0.5)
        ImageLabel.Size = UDim2.fromScale(1.7, 1.7)
        ImageLabel.ZIndex = 1
        ImageLabel.Parent = CanvasGroup
    end

    local v12 = math.min(p25 + 1, 5)

    star(CanvasGroup, v12, if p25 >= 6 then v2 else Color, 1, 2, true)

    if p25 >= 4 then
        star(CanvasGroup, v12, if p25 >= 6 then Color else v2, 0.55, 4, false)
    end

    local UIScale = Instance.new("UIScale")

    UIScale.Name = "Pop"
    UIScale.Parent = CanvasGroup

    return CanvasGroup
end

local function step(p26) -- line: 211
    -- upvalues: Config (copy), UIUtil (copy), v1 (copy), v2 (copy), v3 (copy), circle (copy), twinkle (copy), sparks (copy), makeBadge (copy)
    local v15 = p26.shown + 1

    p26.shown = v15

    local badge = p26.badge

    if badge then
        local Pop = badge:FindFirstChild("Pop")

        UIUtil.tween(Pop, 0.3, {
            Scale = 1.7
        })
        UIUtil.tween(badge, 0.3, {
            GroupTransparency = 1
        })
        task.delay(0.32, function() -- line: 220
            -- upvalues: badge (copy)
            badge:Destroy()
        end)
    end

    local v16 = makeBadge(v15)

    v16.Rotation = p26.spin

    local Pop = v16:FindFirstChild("Pop")

    Pop.Scale = 0.2
    v16.Parent = p26.holder
    p26.badge = v16
    UIUtil.tween(Pop, 0.4, {
        Scale = 1
    }, Enum.EasingStyle.Back)

    local v17 = Config.LuckStages[v15]
    local Color = v17.Color
    local v18 = v15 >= 7

    for _, v19 in p26.glows do
        UIUtil.tween(v19, 0.3, {
            BackgroundColor3 = Color
        })
        v19:SetAttribute("Kick", os.clock())
    end

    p26.shine.ImageColor3 = Color:Lerp(v2, 0.3)

    local holder = p26.holder
    local v20 = Color:Lerp(v2, 0.3)
    local v22 = if v18 then 3.2 else 2.4
    local v23 = if v18 then 0.6 else 0.45
    local v21 = if v18 then 8 else 5
    local delay = task.delay
    local n1 = 0.8

    delay(0, function() -- line: 132
        -- upvalues: holder (copy), v20 (copy), n1 (copy), v21 (copy), v22 (copy), v23 (copy), UIUtil (copy), circle (copy)
        if holder.Parent then
            local v24 = circle("Ring", v20, 1, 0)

            v24.Size = UDim2.fromScale(n1, n1)

            local UIStroke = Instance.new("UIStroke")

            UIStroke.Color = v20
            UIStroke.Thickness = v21 * UIUtil.scale
            UIStroke.Parent = v24
            v24.Parent = holder
            UIUtil.tween(v24, v23, {
                Size = UDim2.fromScale(v22, v22)
            }, Enum.EasingStyle.Quart)
            UIUtil.tween(UIStroke, v23, {
                Thickness = 0,
                Transparency = 1
            }, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
            task.delay(v23 + 0.05, v24.Destroy, v24)
        end
    end)

    local holder2 = p26.holder
    local v25 = if v18 then 22 else v15 + 8
    local v26 = if v18 then 1.7 else 1.25

    sparks(holder2, Color, v25, v26, v18 and 0.6 or 0.45)

    if v18 then
        local holder = p26.holder
        local delay = task.delay
        local n2 = 0.6
        local n3 = 5
        local n4 = 0.5
        local n5 = 2.4

        delay(0.08, function() -- line: 132
            -- upvalues: holder (copy), n2 (copy), n3 (copy), n4 (copy), n5 (copy), UIUtil (copy), v2 (copy), circle (copy)
            if holder.Parent then
                local v27 = circle("Ring", v2, 1, 0)

                v27.Size = UDim2.fromScale(n2, n2)

                local UIStroke = Instance.new("UIStroke")

                UIStroke.Color = v2
                UIStroke.Thickness = n3 * UIUtil.scale
                UIStroke.Parent = v27
                v27.Parent = holder
                UIUtil.tween(v27, n4, {
                    Size = UDim2.fromScale(n5, n5)
                }, Enum.EasingStyle.Quart)
                UIUtil.tween(UIStroke, n4, {
                    Thickness = 0,
                    Transparency = 1
                }, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
                task.delay(n4 + 0.05, v27.Destroy, v27)
            end
        end)

        local v28 = circle("Flash", v2, 0.15, 0)

        v28.Size = UDim2.fromScale(0.7, 0.7)
        v28.Parent = p26.holder
        UIUtil.tween(v28, 0.35, {
            BackgroundTransparency = 1,
            Size = UDim2.fromScale(2.1, 2.1)
        }, Enum.EasingStyle.Quad)
        task.delay(0.4, v28.Destroy, v28)
    end

    while true and #p26.twinkles < math.min(v15 + 2, 10) do
        local v31 = twinkle(v2, 3)

        v31:SetAttribute("Phase", v3:NextNumber(0, 6.283185307179586))
        v31:SetAttribute("Orbit", v3:NextNumber(0.5, 0.68))
        v31.Parent = p26.aura
        table.insert(p26.twinkles, v31)
    end

    for _, v32 in p26.twinkles do
        for _, child in v32:GetChildren() do
            if child:IsA("Frame") then
                if v32:GetAttribute("Phase") > 3.141592653589793 then
                    child.BackgroundColor3 = v2
                else
                    child.BackgroundColor3 = Color:Lerp(v2, 0.4)
                end
            end
        end
    end

    local callout = p26.callout

    if callout then
        callout:Destroy()
    end

    local TextLabel = Instance.new("TextLabel")

    TextLabel.Name = "RungTitle"
    TextLabel.BackgroundTransparency = 1
    TextLabel.AnchorPoint = Vector2.new(0.5, 0)
    TextLabel.Position = UDim2.fromScale(0.5, 0.9)
    TextLabel.Size = UDim2.fromScale(3.2, 0.36)
    TextLabel.FontFace = Config.Font
    TextLabel.TextScaled = true
    TextLabel.Text = v17.Title
    TextLabel.TextColor3 = v2
    TextLabel.ZIndex = 3

    local UIStroke = Instance.new("UIStroke")

    UIStroke.Thickness = 3 * UIUtil.scale
    UIStroke.Color = v1
    UIStroke.Parent = TextLabel

    local UIGradient = Instance.new("UIGradient")

    UIGradient.Rotation = 90
    UIGradient.Color = ColorSequence.new(v2, Color)
    UIGradient.Parent = TextLabel

    local UIScale = Instance.new("UIScale")

    UIScale.Scale = 0.3
    UIScale.Parent = TextLabel
    TextLabel.Rotation = v3:NextNumber(-6, 6)
    TextLabel.Parent = p26.holder
    p26.callout = TextLabel
    UIUtil.tween(UIScale, 0.3, {
        Scale = 1
    }, Enum.EasingStyle.Back)
    task.delay(1.1, function() -- line: 297
        -- upvalues: TextLabel (copy), UIStroke (copy), UIUtil (copy)
        if TextLabel.Parent then
            UIUtil.tween(TextLabel, 0.3, {
                TextTransparency = 1
            })
            UIUtil.tween(UIStroke, 0.3, {
                Transparency = 1
            })
            task.delay(0.32, TextLabel.Destroy, TextLabel)
        end
    end)

    if v18 then
        UIUtil.sound("LuckRungHit", 1, 1)
        UIUtil.sound("LuckRungRewards", 0.8, (v15 - 7) * 0.04 + 1)
    else
        UIUtil.sound("LuckRung", 0.9, (v15 - 1) * 0.06 + 1)
    end
end

local function stop(p27) -- line: 313
    -- upvalues: t2 (copy)
    p27.conn:Disconnect()
    p27.holder:Destroy()
    t2[p27.gui] = nil
end

local function start(p28) -- line: 319
    -- upvalues: RunService (copy), v2 (copy), t2 (copy), circle (copy), step (copy)
    local Odds = p28:WaitForChild("Odds")
    local Frame = Instance.new("Frame")

    Frame.Name = "LuckBadge"
    Frame.BackgroundTransparency = 1
    Frame.AnchorPoint = Vector2.new(0.5, 0.5)
    Frame.ZIndex = Odds.ZIndex - 1
    Frame.Parent = p28

    local Frame2 = Instance.new("Frame")

    Frame2.Name = "Aura"
    Frame2.BackgroundTransparency = 1
    Frame2.Size = UDim2.fromScale(1, 1)
    Frame2.ZIndex = 0
    Frame2.Parent = Frame

    local t4 = {}

    for v33, v34 in {
            { 1.15, 0.72 },
            { 1.5, 0.84 },
            { 1.95, 0.92 }
        } do
        local v35 = circle("Glow" .. v33, v2, 1, 0)

        v35:SetAttribute("Base", v34[1])
        v35:SetAttribute("Alpha", v34[2])
        v35.Size = UDim2.fromScale(v34[1], v34[1])
        v35.Parent = Frame2
        t4[v33] = v35
    end

    local ImageLabel = Instance.new("ImageLabel")

    ImageLabel.Name = "Shine"
    ImageLabel.BackgroundTransparency = 1
    ImageLabel.Image = "rbxassetid://86205314584043"
    ImageLabel.ImageTransparency = 1
    ImageLabel.AnchorPoint = Vector2.new(0.5, 0.5)
    ImageLabel.Position = UDim2.fromScale(0.5, 0.5)
    ImageLabel.Size = UDim2.fromScale(2.6, 2.6)
    ImageLabel.ZIndex = 0
    ImageLabel.Parent = Frame2

    local t5

    t5 = {
        callout = nil,
        badge = nil,
        shown = 0,
        target = 0,
        spin = 0,
        nextRung = 0,
        gui = p28,
        holder = Frame,
        aura = Frame2,
        glows = t4,
        shine = ImageLabel,
        twinkles = {},
        conn = RunService.RenderStepped:Connect(function(p29) -- line: 367
            -- upvalues: Odds (copy), Frame (copy), t5 (ref), t2 (copy), step (copy)
            if Odds.Visible then
                local AbsoluteSize = Odds.AbsoluteSize
                local v36 = Odds.AnchorPoint - Vector2.new(0.5, 0.5)

                Frame.Position = Odds.Position - UDim2.fromOffset(v36.X * AbsoluteSize.X, v36.Y * AbsoluteSize.Y)
                Frame.Size = UDim2.fromOffset(AbsoluteSize.Y * 2.5, AbsoluteSize.Y * 2.5)
                t5.spin = (t5.spin + 50 * p29) % 360

                local elapsed = os.clock()

                if t5.shown < t5.target and t5.nextRung <= elapsed then
                    t5.nextRung = elapsed + 0.32
                    step(t5)
                end

                local shown = t5.shown

                if shown > 0 then
                    local v38 = math.min(shown / 8, 1)

                    for _, v39 in t5.glows do
                        local v41 = math.max(0, 1 - (elapsed - (v39:GetAttribute("Kick") or 0)) / 0.35)
                        local v43 = v39:GetAttribute("Base") * (math.sin(elapsed * 3) * 0.06 + 1 + v41 * 0.25)

                        v39.Size = UDim2.fromScale(v43, v43)
                        v39.BackgroundTransparency = math.clamp(1 - (1 - v39:GetAttribute("Alpha")) * (v38 * 0.45 + 0.55) * (v41 + 1), 0, 1)
                    end

                    t5.shine.ImageTransparency = 0.85 - v38 * 0.35
                    t5.shine.Rotation = -t5.spin * 0.6

                    for v45, v46 in t5.twinkles do
                        local Phase = v46:GetAttribute("Phase")
                        local v47 = Phase + elapsed * (v45 % 3 * 0.1 + 0.9)
                        local Orbit = v46:GetAttribute("Orbit")

                        v46.Position = UDim2.fromScale(0.5 + math.cos(v47) * Orbit, 0.5 + math.sin(v47) * Orbit)

                        local v49 = (math.sin(elapsed * 5 + Phase * 3) * 0.5 + 0.5) * 0.1 * (v38 * 0.4 + 0.6) + 0.08

                        v46.Size = UDim2.fromScale(v49, v49)
                        v46.Rotation = elapsed * 90 + Phase * 57
                    end
                end

                local badge = t5.badge

                if badge then
                    badge.Rotation = t5.spin

                    local Rays = badge:FindFirstChild("Rays")

                    if Rays then
                        Rays.Rotation = -t5.spin * 2.6
                    end

                    if t5.shown >= 5 then
                        badge.GroupColor3 = Color3.fromHSV(elapsed * 0.35 % 1, 0.35, 1)
                    end
                end
            else
                local t9 = t5

                t9.conn:Disconnect()
                t9.holder:Destroy()
                t2[t9.gui] = nil
            end
        end)
    }
    t2[p28] = t5

    return t5
end

function t1.climb(p30, p31) -- line: 429
    -- upvalues: Config (copy), t2 (copy), start (copy)
    local v51 = math.clamp(p31, 0, #Config.LuckStages)

    if v51 <= 0 then
        return
    end

    local v52 = t2[p30] or start(p30)

    v52.target = math.max(v52.target, v51)
end

function t1.shown(p32) -- line: 439
    -- upvalues: t2 (copy)
    local v53 = t2[p32]

    if v53 then
        return v53.shown
    end

    return 0
end

function t1.land(p33, p34) -- line: 446
    -- upvalues: UIUtil (copy), v2 (copy), t2 (copy), circle (copy), sparks (copy)
    local v54 = t2[p33]
    local Frame, v55

    if v54 then
        Frame = v54.holder
        v55 = v54.shown
    else
        local Odds = p33:FindFirstChild("Odds")

        if not Odds then
            return
        end

        local AbsoluteSize = Odds.AbsoluteSize
        local v56 = Odds.AnchorPoint - Vector2.new(0.5, 0.5)

        Frame = Instance.new("Frame")
        Frame.Name = "OddsLand"
        Frame.BackgroundTransparency = 1
        Frame.AnchorPoint = Vector2.new(0.5, 0.5)
        Frame.Position = Odds.Position - UDim2.fromOffset(v56.X * AbsoluteSize.X, v56.Y * AbsoluteSize.Y)
        Frame.Size = UDim2.fromOffset(AbsoluteSize.Y * 2.5, AbsoluteSize.Y * 2.5)
        Frame.ZIndex = Odds.ZIndex - 1
        Frame.Parent = p33
        v55 = 0
        task.delay(1, Frame.Destroy, Frame)
    end

    local v57 = p34:Lerp(v2, 0.35)
    local v58 = v55 * 0.15 + 2.6
    local delay = task.delay
    local n6 = 0.6
    local n7 = 6
    local n8 = 0.55

    delay(0, function() -- line: 132
        -- upvalues: Frame (ref), v57 (copy), v58 (copy), n6 (copy), n7 (copy), n8 (copy), UIUtil (copy), circle (copy)
        if Frame.Parent then
            local v59 = circle("Ring", v57, 1, 0)

            v59.Size = UDim2.fromScale(n6, n6)

            local UIStroke = Instance.new("UIStroke")

            UIStroke.Color = v57
            UIStroke.Thickness = n7 * UIUtil.scale
            UIStroke.Parent = v59
            v59.Parent = Frame
            UIUtil.tween(v59, n8, {
                Size = UDim2.fromScale(v58, v58)
            }, Enum.EasingStyle.Quart)
            UIUtil.tween(UIStroke, n8, {
                Thickness = 0,
                Transparency = 1
            }, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
            task.delay(n8 + 0.05, v59.Destroy, v59)
        end
    end)
    sparks(Frame, p34, v55 * 2 + 10, v55 * 0.05 + 1.4, 0.55)

    if not (v55 >= 7) then
        return
    end

    local delay2 = task.delay
    local n9 = 0.5
    local n10 = 4
    local n11 = 0.7
    local n12 = 3.4

    delay2(0.1, function() -- line: 132
        -- upvalues: Frame (ref), n9 (copy), n10 (copy), n11 (copy), n12 (copy), UIUtil (copy), v2 (copy), circle (copy)
        if Frame.Parent then
            local v60 = circle("Ring", v2, 1, 0)

            v60.Size = UDim2.fromScale(n9, n9)

            local UIStroke = Instance.new("UIStroke")

            UIStroke.Color = v2
            UIStroke.Thickness = n10 * UIUtil.scale
            UIStroke.Parent = v60
            v60.Parent = Frame
            UIUtil.tween(v60, n11, {
                Size = UDim2.fromScale(n12, n12)
            }, Enum.EasingStyle.Quart)
            UIUtil.tween(UIStroke, n11, {
                Thickness = 0,
                Transparency = 1
            }, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
            task.delay(n11 + 0.05, v60.Destroy, v60)
        end
    end)
end

function t1.reset(p35) -- line: 478
    -- upvalues: t2 (copy)
    local v61 = t2[p35]

    if not v61 then
        return
    end

    v61.conn:Disconnect()
    v61.holder:Destroy()
    t2[v61.gui] = nil
end

return t1
