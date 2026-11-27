-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")
local GuiService = game:GetService("GuiService")
local Pad = require(script.Parent.Pad)
local fromRGB = Color3.fromRGB
local t1 = {}

t1.Font = Enum.Font.FredokaOne
t1.Colors = {
    Outline = fromRGB(14, 14, 22),
    Dark = fromRGB(22, 26, 52),
    Panel = fromRGB(42, 52, 98),
    PanelLight = fromRGB(66, 80, 140),
    White = fromRGB(255, 255, 255),
    Green = fromRGB(120, 228, 60),
    GreenDark = fromRGB(62, 176, 40),
    Red = fromRGB(245, 62, 66),
    RedDark = fromRGB(200, 30, 44),
    Orange = fromRGB(255, 170, 40),
    OrangeDark = fromRGB(240, 120, 20),
    Blue = fromRGB(70, 160, 255),
    BlueDark = fromRGB(40, 105, 230),
    Magenta = fromRGB(238, 70, 215),
    MagentaDark = fromRGB(196, 40, 190),
    Pink = fromRGB(255, 110, 190),
    Gold = fromRGB(255, 210, 60),
    GoldDark = fromRGB(240, 160, 30),
    Grey = fromRGB(120, 124, 140),
    GreyDark = fromRGB(84, 88, 102),
    Cash = fromRGB(120, 235, 90),
    CashStroke = fromRGB(20, 70, 26),
    Power = fromRGB(120, 205, 255),
    PowerStroke = fromRGB(22, 50, 120)
}
t1.ICON_SHEET = "rbxassetid://101919920796715"
t1.ICON_CELL = 192
t1.Icons = {
    Index = { 0, 0 },
    Shop = { 1, 0 },
    Fish = { 2, 0 },
    Power = { 0, 1 },
    Cash = { 1, 1 },
    Arrow = { 2, 1 }
}

local PlayerGui = Players.LocalPlayer:WaitForChild("PlayerGui")

local function playerGuiRef() -- line: 46
    -- upvalues: PlayerGui (copy)
    return PlayerGui
end

function t1.corner(p1, p2) -- line: 51
    local UICorner = Instance.new("UICorner")

    UICorner.CornerRadius = UDim.new(0, p2)
    UICorner.Parent = p1

    return UICorner
end

function t1.stroke(p3, p4, p5) -- line: 58
    -- upvalues: t1 (copy)
    local UIStroke = Instance.new("UIStroke")

    UIStroke.Thickness = p4
    UIStroke.Color = p5 or t1.Colors.Outline
    UIStroke.LineJoinMode = Enum.LineJoinMode.Round

    if p3:IsA("TextLabel") or p3:IsA("TextButton") then
        UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual
    else
        UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    end

    UIStroke.Parent = p3

    return UIStroke
end

function t1.gradient(p6, p7, p8, p9) -- line: 72
    local UIGradient = Instance.new("UIGradient")

    UIGradient.Color = ColorSequence.new(p7, p8)
    UIGradient.Rotation = p9 or 90
    UIGradient.Parent = p6

    return UIGradient
end

function t1.frame(p10, p11) -- line: 80
    -- upvalues: t1 (copy)
    local v1 = Instance.new(p11.Class or "Frame")

    v1.Name = p11.Name or "Frame"
    v1.Size = p11.Size or UDim2.fromScale(1, 1)
    v1.Position = p11.Position or UDim2.new()
    v1.AnchorPoint = p11.AnchorPoint or Vector2.zero
    v1.BackgroundColor3 = p11.Color or t1.Colors.Dark
    v1.BackgroundTransparency = p11.Transparency or 0
    v1.BorderSizePixel = 0
    v1.ZIndex = p11.ZIndex or 1

    if p11.Corner then
        t1.corner(v1, p11.Corner)
    end

    if p11.Stroke then
        t1.stroke(v1, p11.Stroke, p11.StrokeColor)
    end

    if p11.Color2 then
        v1.BackgroundColor3 = t1.Colors.White
        t1.gradient(v1, p11.Color, p11.Color2, p11.GradientRotation)
    end

    v1.Parent = p10

    return v1
end

function t1.text(p12, p13) -- line: 105
    -- upvalues: t1 (copy)
    local v2 = Instance.new(p13.Class or "TextLabel")

    v2.Name = p13.Name or "Text"
    v2.BackgroundTransparency = 1
    v2.Size = p13.Size or UDim2.fromScale(1, 1)
    v2.Position = p13.Position or UDim2.new()
    v2.AnchorPoint = p13.AnchorPoint or Vector2.zero
    v2.Font = t1.Font
    v2.Text = p13.Text or ""
    v2.TextColor3 = p13.Color or t1.Colors.White
    v2.TextXAlignment = p13.XAlign or Enum.TextXAlignment.Center
    v2.TextYAlignment = p13.YAlign or Enum.TextYAlignment.Center
    v2.ZIndex = p13.ZIndex or 1
    v2.Rotation = p13.Rotation or 0

    if p13.TextSize then
        v2.TextSize = p13.TextSize
    else
        v2.TextScaled = true
    end

    if p13.Stroke ~= 0 then
        t1.stroke(v2, p13.Stroke or 4, p13.StrokeColor)
    end

    v2.Parent = p12

    return v2
end

function t1.icon(p14, p15, p16) -- line: 131
    -- upvalues: t1 (copy)
    p16 = p16 or {}

    local v4 = t1.Icons[p15]
    local ImageLabel = Instance.new("ImageLabel")

    ImageLabel.Name = p15 .. "Icon"
    ImageLabel.BackgroundTransparency = 1

    local v5 = t1.Art[p15 .. "Icon"]

    if v5 then
        ImageLabel.Image = v5
        ImageLabel.ScaleType = Enum.ScaleType.Fit
    else
        ImageLabel.Image = t1.ICON_SHEET
        ImageLabel.ImageRectSize = Vector2.new(t1.ICON_CELL, t1.ICON_CELL)
        ImageLabel.ImageRectOffset = Vector2.new(v4[1] * t1.ICON_CELL, v4[2] * t1.ICON_CELL)
    end

    ImageLabel.Size = p16.Size or UDim2.fromOffset(96, 96)
    ImageLabel.Position = p16.Position or UDim2.new()
    ImageLabel.AnchorPoint = p16.AnchorPoint or Vector2.zero
    ImageLabel.ZIndex = p16.ZIndex or 1
    ImageLabel.Rotation = p16.Rotation or 0
    ImageLabel.Parent = p14

    return ImageLabel
end

t1.Art = {
    Clover = "rbxassetid://92789272314558",
    Gift = "rbxassetid://113111533140722",
    Gear = "rbxassetid://123611967922524",
    Lock = "rbxassetid://136653117765654",
    Trophy = "rbxassetid://113084670930406",
    Bubbles = "rbxassetid://109219685767018",
    PowerIcon = "rbxassetid://103824212937236",
    CashIcon = "rbxassetid://94672549133243",
    ArrowIcon = "rbxassetid://117795289541640",
    Rays = "rbxassetid://109650742194378",
    Glow = "rbxassetid://108857238253800",
    Sparkle = "rbxassetid://127293905079829",
    IndexIcon = "rbxassetid://118698986830277",
    ShopIcon = "rbxassetid://84616305523048",
    FishIcon = "rbxassetid://101486568646155"
}
t1.Art.CloverIcon = t1.Art.Clover

function t1.image(p17, p18, p19) -- line: 179
    -- upvalues: t1 (copy)
    p19 = p19 or {}

    local ImageLabel = Instance.new("ImageLabel")

    ImageLabel.Name = p18
    ImageLabel.BackgroundTransparency = 1
    ImageLabel.Image = t1.Art[p18] or p18
    ImageLabel.Size = p19.Size or UDim2.fromOffset(96, 96)
    ImageLabel.Position = p19.Position or UDim2.new()
    ImageLabel.AnchorPoint = p19.AnchorPoint or Vector2.zero
    ImageLabel.ZIndex = p19.ZIndex or 1
    ImageLabel.Rotation = p19.Rotation or 0
    ImageLabel.ImageColor3 = p19.Color or t1.Colors.White
    ImageLabel.ImageTransparency = p19.Transparency or 0
    ImageLabel.ScaleType = Enum.ScaleType.Fit
    ImageLabel.Parent = p17

    return ImageLabel
end

function t1.clover(p20, p21, p22) -- line: 198
    -- upvalues: t1 (copy)
    p22 = p22 or {}

    return t1.image(p20, "Clover", {
        Size = UDim2.fromOffset(p21, p21),
        Position = p22.Position,
        AnchorPoint = p22.AnchorPoint,
        ZIndex = p22.ZIndex,
        Rotation = p22.Rotation
    })
end

local t2 = {}
local t3 = {}
local v8 = false

local function twinkleShowing(p23) -- line: 212
    -- upvalues: PlayerGui (copy)
    local img = p23.img

    if img.Visible then
        if p23.root and p23.root.Parent and p23.layer and img:IsDescendantOf(p23.root) then
            if not p23.layer.Enabled or p23.root:IsA("GuiObject") and not p23.root.Visible then
                return false
            end

            if p23.kind == "rays" then
                return (img:IsDescendantOf(PlayerGui))
            end

            return true
        end

        local LayerCollector = img:FindFirstAncestorWhichIsA("LayerCollector")

        if LayerCollector then
            local v9 = img

            while v9.Parent and v9.Parent ~= LayerCollector do
                v9 = v9.Parent
            end

            p23.root = v9
            p23.layer = LayerCollector

            if p23.layer.Enabled and (not p23.root:IsA("GuiObject") or p23.root.Visible) then
                if p23.kind == "rays" then
                    return (img:IsDescendantOf(PlayerGui))
                end

                return true
            end
        end
    end

    return false
end

local function addTwinkler(p24) -- line: 235
    -- upvalues: t2 (copy), t3 (copy), v8 (ref), twinkleShowing (copy)
    table.insert(t2, p24)

    if v8 then
        return
    end

    v8 = true

    local n1 = 0
    local n2 = 0

    game:GetService("RunService").RenderStepped:Connect(function() -- line: 242
        -- upvalues: n1 (ref), n2 (ref), t2 (copy), t3 (copy), twinkleShowing (copy)
        local elapsed = os.clock()

        if n1 <= elapsed then
            n1 = elapsed + 0.25
            table.clear(t3)

            for i = #t2, 1, -1 do
                local v10 = t2[i]

                if v10.img.Parent then
                    if twinkleShowing(v10) then
                        table.insert(t3, v10)
                    end
                else
                    table.remove(t2, i)
                end
            end
        end

        local v11 = elapsed - n2 >= 0.05

        if v11 then
            n2 = elapsed
        end

        for _, v12 in ipairs(t3) do
            local img = v12.img

            if v12.kind == "rays" then
                img.Rotation = elapsed * v12.speed % 360
            elseif v11 then
                local v14 = math.sin(elapsed * 3 + v12.phase)
                local v15 = v14 * 0.25 + 0.75

                img.Size = UDim2.fromOffset(v12.px * v15, v12.px * v15)
                img.ImageTransparency = 0.25 - v14 * 0.25
            end
        end
    end)
end

function t1.rays(p25, p26) -- line: 274
    -- upvalues: t1 (copy), t2 (copy), t3 (copy), v8 (ref), twinkleShowing (copy)
    local v16 = t1.image(p25, "Rays", p26)

    table.insert(t2, {
        kind = "rays",
        img = v16,
        speed = p26.Speed or 12
    })

    if not v8 then
        v8 = true

        local n3 = 0
        local n4 = 0

        game:GetService("RunService").RenderStepped:Connect(function() -- line: 242
            -- upvalues: n3 (ref), n4 (ref), t2 (copy), t3 (copy), twinkleShowing (copy)
            local elapsed = os.clock()

            if n3 <= elapsed then
                n3 = elapsed + 0.25
                table.clear(t3)

                for i = #t2, 1, -1 do
                    local v17 = t2[i]

                    if v17.img.Parent then
                        if twinkleShowing(v17) then
                            table.insert(t3, v17)
                        end
                    else
                        table.remove(t2, i)
                    end
                end
            end

            local v18 = elapsed - n4 >= 0.05

            if v18 then
                n4 = elapsed
            end

            for _, v19 in ipairs(t3) do
                local img = v19.img

                if v19.kind == "rays" then
                    img.Rotation = elapsed * v19.speed % 360
                elseif v18 then
                    local v21 = math.sin(elapsed * 3 + v19.phase)
                    local v22 = v21 * 0.25 + 0.75

                    img.Size = UDim2.fromOffset(v19.px * v22, v19.px * v22)
                    img.ImageTransparency = 0.25 - v21 * 0.25
                end
            end
        end)
    end

    return v16
end

function t1.sparkle(p27, p28, p29) -- line: 281
    -- upvalues: t1 (copy), t2 (copy), t3 (copy), v8 (ref), twinkleShowing (copy)
    p29 = p29 or {}

    local v24 = t1.image(p27, "Sparkle", {
        Size = UDim2.fromOffset(p28, p28),
        Position = p29.Position,
        AnchorPoint = Vector2.new(0.5, 0.5),
        ZIndex = p29.ZIndex,
        Color = p29.Color,
        Rotation = p29.Rotation
    })

    table.insert(t2, {
        kind = "sparkle",
        img = v24,
        px = p28,
        phase = p29.Phase or math.random() * 6
    })

    if not v8 then
        v8 = true

        local n5 = 0
        local n6 = 0

        game:GetService("RunService").RenderStepped:Connect(function() -- line: 242
            -- upvalues: n5 (ref), n6 (ref), t2 (copy), t3 (copy), twinkleShowing (copy)
            local elapsed = os.clock()

            if n5 <= elapsed then
                n5 = elapsed + 0.25
                table.clear(t3)

                for i = #t2, 1, -1 do
                    local v25 = t2[i]

                    if v25.img.Parent then
                        if twinkleShowing(v25) then
                            table.insert(t3, v25)
                        end
                    else
                        table.remove(t2, i)
                    end
                end
            end

            local v26 = elapsed - n6 >= 0.05

            if v26 then
                n6 = elapsed
            end

            for _, v27 in ipairs(t3) do
                local img = v27.img

                if v27.kind == "rays" then
                    img.Rotation = elapsed * v27.speed % 360
                elseif v26 then
                    local v29 = math.sin(elapsed * 3 + v27.phase)
                    local v30 = v29 * 0.25 + 0.75

                    img.Size = UDim2.fromOffset(v27.px * v30, v27.px * v30)
                    img.ImageTransparency = 0.25 - v29 * 0.25
                end
            end
        end)
    end

    return v24
end

local t6 = {}
local v31 = false

function t1.gleam(p30, p31) -- line: 297
    -- upvalues: t1 (copy), t6 (copy), v31 (ref)
    local v32 = p31

    p31 = p31 or {}
    v32 = p31

    local Frame = Instance.new("Frame")

    Frame.Name = "Gleam"
    Frame.BackgroundColor3 = Color3.new(1, 1, 1)
    Frame.BorderSizePixel = 0
    Frame.Size = UDim2.fromScale(1, 1)
    Frame.Active = false
    Frame.ZIndex = p31.ZIndex or p30.ZIndex
    Frame.Visible = false
    t1.corner(Frame, p31.Corner or 12)

    local v34 = p31.Width or 0.09
    local v36 = 1 - math.clamp(p31.Strength or 0.6, 0, 1)
    local v37 = v36 + (1 - v36) * 0.4
    local UIGradient = Instance.new("UIGradient")

    UIGradient.Rotation = p31.Rotation or 24
    UIGradient.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 1),
        NumberSequenceKeypoint.new(math.max(0.5 - v34 * 2, 0.001), 1),
        NumberSequenceKeypoint.new(0.5 - v34 * 0.4, v37),
        NumberSequenceKeypoint.new(0.5, v36),
        NumberSequenceKeypoint.new(0.5 + v34 * 0.4, v37),
        NumberSequenceKeypoint.new(math.min(0.5 + v34 * 2, 0.999), 1),
        NumberSequenceKeypoint.new(1, 1)
    })
    UIGradient.Offset = Vector2.new(-1, 0)
    UIGradient.Parent = Frame
    Frame.Parent = p30

    local v45 = p31.Period or 3.2
    local v47 = math.min(p31.Sweep or 0.75, v45)
    local v48 = p31.Phase or math.random() * v45

    local function step(p32) -- line: 328
        -- upvalues: v32 (ref), Frame (copy), UIGradient (copy), v45 (copy), v47 (copy), v48 (copy)
        local v49 = (p32 + v48) % v45 / v47

        if v49 < 1 and (not v32.When or v32.When()) then
            local v50 = v49 * v49 * (3 - 2 * v49)

            UIGradient.Offset = Vector2.new(-1.05 + 2.1 * v50, 0)
            Frame.Visible = true
        elseif Frame.Visible then
            Frame.Visible = false
        end
    end

    if not v32.Manual then
        table.insert(t6, {
            target = p30,
            step = step
        })

        if not v31 then
            v31 = true
            game:GetService("RunService").RenderStepped:Connect(function() -- line: 342
                -- upvalues: t6 (copy)
                local elapsed = os.clock()

                for i = #t6, 1, -1 do
                    local v51 = t6[i]

                    if v51.target.Parent then
                        if v51.target.Visible then
                            v51.step(elapsed)
                        end
                    else
                        table.remove(t6, i)
                    end
                end
            end)
        end
    end

    return Frame, step
end

local t8 = {}

function t1.viewModel(p33, p34, p35) -- line: 362
    -- upvalues: t8 (copy)
    p35 = p35 or {}

    local ViewportFrame = Instance.new("ViewportFrame")

    ViewportFrame.Name = p35.Name or "Model"
    ViewportFrame.BackgroundTransparency = 1
    ViewportFrame.Size = p35.Size or UDim2.fromScale(1, 1)
    ViewportFrame.Position = p35.Position or UDim2.new()
    ViewportFrame.AnchorPoint = p35.AnchorPoint or Vector2.zero
    ViewportFrame.ZIndex = p35.ZIndex or 1
    ViewportFrame.Ambient = Color3.fromRGB(215, 215, 215)
    ViewportFrame.LightColor = Color3.new(1, 1, 1)
    ViewportFrame.LightDirection = Vector3.new(-0.6, -1, 0.7)

    local clone = p34:Clone()

    for _, descendant in ipairs(clone:GetDescendants()) do
        if descendant:IsA("ParticleEmitter") or descendant:IsA("PointLight") then
            descendant:Destroy()
        end
    end

    clone:PivotTo(CFrame.new())
    clone.Parent = ViewportFrame

    local BoundingBox, BoundingBox2 = clone:GetBoundingBox()
    local Camera = Instance.new("Camera")

    Camera.FieldOfView = 30

    local v53 = BoundingBox2.Magnitude / 2 / 0.25881904510252074 * 0.8 * (p35.Zoom or 1)
    local Unit = (p35.Dir or Vector3.new(0.6, 0.4, -1)).Unit

    Camera.CFrame = CFrame.lookAt(BoundingBox.Position + Unit * v53, BoundingBox.Position)
    Camera.Parent = ViewportFrame
    ViewportFrame.CurrentCamera = Camera
    ViewportFrame.Parent = p33

    if p35.Spin then
        table.insert(t8, {
            ViewportFrame,
            Camera,
            BoundingBox.Position,
            v53,
            Unit,
            (math.rad(p35.Spin))
        })
    end

    return ViewportFrame
end

local t10 = {
    SpiritLantern = {
        dir = Vector3.new(0.45, 0.22, -1),
        zoom = 0.78
    },
    RainbowCrate = {
        dir = Vector3.new(0.42, 0.12, -1),
        zoom = 0.7
    },
    CosmicEgg = {
        dir = Vector3.new(0.45, 0.3, -1),
        zoom = 0.8
    },
    GoldenHarvest = {
        dir = Vector3.new(0.45, 0.22, -1),
        zoom = 0.72
    }
}

function t1.eggPicture(p36, p37, p38) -- line: 405
    -- upvalues: t1 (copy), t10 (copy)
    p38 = p38 or {}

    local _require = require
    local Shared = game:GetService("ReplicatedStorage"):WaitForChild("Shared")
    local ok, result = pcall(_require, Shared:WaitForChild("EggModels"))

    ok = ok and result.Build and result.Build(p37, CFrame.new())

    if typeof(ok) ~= "Instance" or not ok:IsA("Model") then
        return nil
    end

    local v55 = t10[p37] or {
        dir = Vector3.new(0.5, 0.3, -1),
        zoom = 0.78
    }
    local v56 = t1.viewModel(p36, ok, {
        Name = "Egg",
        Size = p38.Size or UDim2.fromScale(1, 1),
        Position = p38.Position or UDim2.fromScale(0.5, 0.5),
        AnchorPoint = p38.AnchorPoint or Vector2.new(0.5, 0.5),
        ZIndex = p38.ZIndex,
        Dir = v55.dir,
        Zoom = (p38.Zoom or 1) * v55.zoom
    })

    ok:Destroy()

    return v56
end

game:GetService("RunService").RenderStepped:Connect(function() -- line: 426
    -- upvalues: t1 (copy), t8 (copy)
    if #t8 ~= 0 and t1.anyWindowOpen() then
        local elapsed = os.clock()

        for i = #t8, 1, -1 do
            local v57 = t8[i]

            if v57[1].Parent then
                local v58 = CFrame.Angles(0, elapsed * v57[6], 0):VectorToWorldSpace(v57[5])

                v57[2].CFrame = CFrame.lookAt(v57[3] + v58 * v57[4], v57[3])
            else
                table.remove(t8, i)
            end
        end
    end
end)

function t1.dress(p39, p40, p41, p42) -- line: 445
    -- upvalues: t1 (copy)
    p42 = p42 or p39.ZIndex

    local v61 = t1.frame(p39, {
        Name = "Rim",
        Transparency = 1,
        Size = UDim2.new(1, -6, 1, -6),
        Position = UDim2.fromOffset(3, 3),
        Corner = math.max(p40 - 3, 0),
        ZIndex = p42
    })
    local UIStroke = Instance.new("UIStroke")

    UIStroke.Thickness = 2
    UIStroke.Color = p41 or t1.Colors.White
    UIStroke.Transparency = 0.62
    UIStroke.Parent = v61

    local v63 = t1.frame(p39, {
        Name = "Gloss",
        Transparency = 0.86,
        Size = UDim2.new(1, -16, 0.34, 0),
        Position = UDim2.fromOffset(8, 5),
        Color = t1.Colors.White,
        Corner = math.max(p40 - 5, 0),
        ZIndex = p42
    })

    t1.gradient(v63, t1.Colors.White, t1.Colors.White).Transparency = NumberSequence.new(0, 0.8)

    return v61, v63
end

function t1.backdrop(p43, p44, p45) -- line: 459
    -- upvalues: t1 (copy)
    return t1.frame(p43, {
        Class = "CanvasGroup",
        Name = "Backdrop",
        Transparency = 1,
        Corner = p44,
        ZIndex = p45 or 1
    })
end

function t1.scaleOf(p46) -- line: 464
    local KitScale = p46:FindFirstChild("KitScale")

    if not KitScale then
        KitScale = Instance.new("UIScale")
        KitScale.Name = "KitScale"
        KitScale.Parent = p46
    end

    return KitScale
end

local n7 = 58

function t1.topInset() -- line: 476
    -- upvalues: GuiService (copy), n7 (ref)
    local Y = GuiService.TopbarInset.Max.Y

    if Y > 0 then
        n7 = Y
    end

    return n7
end

function t1.tween(p47, p48, p49, p50, p51) -- line: 484
    -- upvalues: TweenService (copy)
    local tween = TweenService:Create(p47, TweenInfo.new(p48, p50 or Enum.EasingStyle.Quad, p51 or Enum.EasingDirection.Out), p49)

    tween:Play()

    return tween
end

function t1.pop(p52, p53) -- line: 491
    -- upvalues: t1 (copy)
    local KitScale = p52:FindFirstChild("KitScale")

    if not KitScale then
        KitScale = Instance.new("UIScale")
        KitScale.Name = "KitScale"
        KitScale.Parent = p52
    end

    KitScale.Scale = p53 or 1.25
    t1.tween(KitScale, 0.28, {
        Scale = 1
    }, Enum.EasingStyle.Back)
end

t1.SoundHandler = nil

function t1.sound(p54, p55) -- line: 500
    -- upvalues: t1 (copy)
    if t1.SoundHandler then
        t1.SoundHandler(p54, p55)
    end
end

local function fitScale(_, p57) -- line: 507
    local CurrentCamera = workspace.CurrentCamera

    local function update() -- line: 509
        -- upvalues: p57 (copy), CurrentCamera (copy)
        local ViewportSize = CurrentCamera.ViewportSize
        local v64 = ViewportSize.Y / 1080

        if ViewportSize.Y < 520 then
            v64 *= 1.3
        end

        p57.Scale = math.clamp(math.min(v64, ViewportSize.X / 1150), 0.35, 1.6)
    end

    local ViewportSize = CurrentCamera.ViewportSize
    local v67 = ViewportSize.Y / 1080

    if ViewportSize.Y < 520 then
        v67 *= 1.3
    end

    p57.Scale = math.clamp(math.min(v67, ViewportSize.X / 1150), 0.35, 1.6)
    CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(update)
end

function t1.screenGui(p58, p59) -- line: 522
    -- upvalues: PlayerGui (copy)
    local ScreenGui = Instance.new("ScreenGui")

    ScreenGui.Name = p58
    ScreenGui.ResetOnSpawn = false
    ScreenGui.IgnoreGuiInset = true
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.DisplayOrder = p59 or 1

    local UIScale = Instance.new("UIScale")

    UIScale.Name = "FitScale"
    UIScale.Parent = ScreenGui

    local CurrentCamera = workspace.CurrentCamera

    local function update() -- line: 509
        -- upvalues: UIScale (copy), CurrentCamera (copy)
        local ViewportSize = CurrentCamera.ViewportSize
        local v70 = ViewportSize.Y / 1080

        if ViewportSize.Y < 520 then
            v70 *= 1.3
        end

        UIScale.Scale = math.clamp(math.min(v70, ViewportSize.X / 1150), 0.35, 1.6)
    end

    local ViewportSize = CurrentCamera.ViewportSize
    local v73 = ViewportSize.Y / 1080

    if ViewportSize.Y < 520 then
        v73 *= 1.3
    end

    UIScale.Scale = math.clamp(math.min(v73, ViewportSize.X / 1150), 0.35, 1.6)
    CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(update)
    ScreenGui.Parent = PlayerGui

    return ScreenGui
end

function t1.bindPress(p60, p61) -- line: 539
    -- upvalues: t1 (copy)
    local KitScale = p60:FindFirstChild("KitScale")

    if not KitScale then
        KitScale = Instance.new("UIScale")
        KitScale.Name = "KitScale"
        KitScale.Parent = p60
    end

    p60.AutoButtonColor = false
    p60.MouseButton1Down:Connect(function() -- line: 542
        -- upvalues: KitScale (ref), t1 (copy)
        t1.tween(KitScale, 0.07, {
            Scale = 0.9
        })
    end)

    local function release() -- line: 545
        -- upvalues: KitScale (ref), t1 (copy)
        t1.tween(KitScale, 0.25, {
            Scale = 1
        }, Enum.EasingStyle.Back)
    end

    p60.MouseButton1Up:Connect(release)
    p60.MouseLeave:Connect(release)
    p60.MouseEnter:Connect(function() -- line: 550
        -- upvalues: KitScale (ref), t1 (copy)
        t1.tween(KitScale, 0.1, {
            Scale = 1.05
        })
        t1.sound("Hover")
    end)
    p60.Activated:Connect(function() -- line: 554
        -- upvalues: p61 (copy), t1 (copy)
        t1.sound("Click")

        if p61 then
            p61()
        end
    end)
end

local function buttonColors(p62, p63) -- line: 564
    local v76 = Color3.new()

    return ColorSequence.new({
        ColorSequenceKeypoint.new(0, p62),
        ColorSequenceKeypoint.new(0.76, p63),
        ColorSequenceKeypoint.new(0.78, p63:Lerp(v76, 0.28)),
        ColorSequenceKeypoint.new(1, p63:Lerp(v76, 0.34))
    })
end

function t1.button(p64, p65) -- line: 576
    -- upvalues: t1 (copy), buttonColors (copy)
    local TextButton = Instance.new("TextButton")

    TextButton.Name = p65.Name or "Button"
    TextButton.Text = ""
    TextButton.Size = p65.Size or UDim2.fromOffset(200, 60)
    TextButton.Position = p65.Position or UDim2.new()
    TextButton.AnchorPoint = p65.AnchorPoint or Vector2.zero
    TextButton.BackgroundColor3 = t1.Colors.White
    TextButton.BorderSizePixel = 0
    TextButton.ZIndex = p65.ZIndex or 1

    local v77 = p65.Corner or 12

    t1.corner(TextButton, v77)
    t1.stroke(TextButton, p65.Stroke or 4).ApplyStrokeMode = Enum.ApplyStrokeMode.Border

    local v78 = t1.gradient(TextButton, p65.Color or t1.Colors.Green, p65.Color2 or p65.Color or t1.Colors.GreenDark)

    v78.Color = buttonColors(p65.Color or t1.Colors.Green, p65.Color2 or p65.Color or t1.Colors.GreenDark)

    local v81 = t1.frame(TextButton, {
        Name = "Gloss",
        Transparency = 0.72,
        Size = UDim2.new(1, -12, 0.4, 0),
        Position = UDim2.fromOffset(6, 4),
        Color = t1.Colors.White,
        Corner = math.max(v77 - 4, 3),
        ZIndex = p65.ZIndex or 1
    })

    t1.gradient(v81, t1.Colors.White, t1.Colors.White).Transparency = NumberSequence.new(0, 0.75)

    local v82 = t1.text(TextButton, {
        Name = "Label",
        Text = p65.Text or "",
        Size = UDim2.new(1, -16, 1, -14),
        Position = UDim2.fromOffset(8, 4),
        Stroke = p65.TextStroke or 3,
        Color = p65.TextColor,
        ZIndex = (p65.ZIndex or 1) + 1
    })

    t1.bindPress(TextButton, p65.OnClick)
    TextButton.Parent = p64

    return TextButton, v82, v78
end

function t1.setButtonColor(p66, p67, p68) -- line: 599
    -- upvalues: buttonColors (copy)
    local UIGradient = p66:FindFirstChildOfClass("UIGradient")

    if UIGradient then
        if p66:FindFirstChild("Gloss") then
            UIGradient.Color = buttonColors(p67, p68 or p67)
        else
            UIGradient.Color = ColorSequence.new(p67, p68 or p67)
        end
    end
end

t1.HudThemes = {
    Index = {
        top = fromRGB(170, 130, 255),
        bottom = fromRGB(92, 50, 214),
        rim = fromRGB(70, 36, 170),
        rim2 = fromRGB(44, 20, 120),
        edge = fromRGB(214, 190, 255),
        glow = fromRGB(240, 225, 255)
    },
    Shop = {
        top = fromRGB(255, 226, 100),
        bottom = fromRGB(255, 142, 34),
        rim = fromRGB(214, 100, 20),
        rim2 = fromRGB(160, 62, 12),
        edge = fromRGB(255, 244, 176),
        glow = fromRGB(255, 252, 220)
    },
    Fish = {
        top = fromRGB(112, 236, 255),
        bottom = fromRGB(26, 140, 232),
        rim = fromRGB(18, 96, 190),
        rim2 = fromRGB(12, 60, 140),
        edge = fromRGB(196, 248, 255),
        glow = fromRGB(230, 252, 255)
    },
    Default = {
        top = fromRGB(96, 110, 150),
        bottom = fromRGB(52, 58, 92),
        rim = fromRGB(40, 44, 70),
        rim2 = fromRGB(26, 28, 46),
        edge = fromRGB(170, 180, 214),
        glow = fromRGB(220, 226, 255)
    }
}

function t1.hudButton(p69, p70, p71, p72, p73) -- line: 615
    -- upvalues: t1 (copy)
    local TextButton = Instance.new("TextButton")

    TextButton.Name = p71 .. "Button"
    TextButton.Text = ""
    TextButton.BackgroundTransparency = 1
    TextButton.Size = UDim2.fromOffset(150, 150)

    local v83 = t1.HudThemes[p70] or t1.HudThemes.Default
    local v84 = t1.frame(TextButton, {
        Name = "Body",
        Corner = 26,
        Stroke = 6,
        Size = UDim2.new(1, -8, 1, -8),
        Position = UDim2.fromOffset(4, 4),
        Color = v83.rim,
        Color2 = v83.rim2
    })
    local v85 = t1.frame(v84, {
        Name = "Inner",
        Corner = 19,
        Size = UDim2.new(1, -14, 1, -14),
        Position = UDim2.fromOffset(7, 7),
        Color = v83.top,
        Color2 = v83.bottom
    })
    local UIStroke = Instance.new("UIStroke")

    UIStroke.Name = "Bevel"
    UIStroke.Thickness = 3
    UIStroke.Color = v83.edge
    UIStroke.Transparency = 0.15
    UIStroke.Parent = v85
    t1.image(v85, "Glow", {
        Transparency = 0.25,
        Size = UDim2.fromScale(1.25, 1.25),
        Position = UDim2.fromScale(0.5, 0.42),
        AnchorPoint = Vector2.new(0.5, 0.5),
        Color = v83.glow
    })
    t1.frame(v85, {
        Name = "Gloss",
        Transparency = 0.72,
        Corner = 13,
        Size = UDim2.new(1, -14, 0, 26),
        Position = UDim2.fromOffset(7, 6),
        Color = t1.Colors.White
    })
    t1.icon(TextButton, p70, {
        ZIndex = 2,
        Size = UDim2.fromOffset(128, 128),
        Position = UDim2.new(0.5, 0, 0, -4),
        AnchorPoint = Vector2.new(0.5, 0)
    })
    t1.text(TextButton, {
        Name = "Label",
        TextSize = 38,
        Stroke = 5,
        ZIndex = 3,
        Text = p71,
        Size = UDim2.new(1, 40, 0, 44),
        Position = UDim2.new(0.5, 0, 1, 2),
        AnchorPoint = Vector2.new(0.5, 1),
        Color = p72
    })
    t1.bindPress(TextButton, p73)
    TextButton.Parent = p69

    return TextButton
end

local BlurEffect = Instance.new("BlurEffect")

BlurEffect.Name = "WindowBlur"
BlurEffect.Size = 0
BlurEffect.Parent = Lighting

local t15 = nil

t1.Windows = {}

local t16 = {}

t16.__index = t16
t16.AWAY = UDim2.new(-10, 0, -10, 0)

function t16.new(p74) -- line: 663
    -- upvalues: t16 (copy)
    local self = setmetatable({}, t16)

    self.Frame = p74
    self.Home = nil

    return self
end

function t16:Park() -- line: 670
    if self.Home == nil then
        self.Home = self.Frame.Position
    end

    self.Frame.Position = self.AWAY

    local function v87() -- line: 675
        -- upvalues: self (copy)
        self.Frame.Interactable = false
    end

    pcall(v87)
end

function t16:Unpark() -- line: 680
    if self.Home ~= nil then
        self.Frame.Position = self.Home
        self.Home = nil
    end

    local function v88() -- line: 685
        -- upvalues: self (copy)
        self.Frame.Interactable = true
    end

    pcall(v88)
end

t1.WindowPark = t16

function t1.window(p77, p78) -- line: 691
    -- upvalues: GuiService (copy), Pad (copy), t1 (copy), fromRGB (copy), BlurEffect (copy), t15 (ref), t16 (copy)
    local t18 = {}
    local v89 = p78.HeaderColor or t1.Colors.Magenta
    local v90 = p78.HeaderColor2 or v89
    local v91 = t1.frame(p77, {
        Transparency = 1,
        ZIndex = 10,
        Name = p78.Name,
        Size = p78.Size or UDim2.fromOffset(900, 620),
        Position = p78.Position or UDim2.fromScale(0.5, 0.5),
        AnchorPoint = p78.AnchorPoint or Vector2.new(0.5, 0.5)
    })

    v91.Visible = false

    local KitScale = v91:FindFirstChild("KitScale")

    if not KitScale then
        KitScale = Instance.new("UIScale")
        KitScale.Name = "KitScale"
        KitScale.Parent = v91
    end

    local v92 = if p78.KeepRendered then t16.new(v91) else nil
    local v93

    local function stopSlide() -- line: 707
        -- upvalues: v93 (ref)
        if v93 then
            v93:Cancel()
            v93 = nil
        end
    end

    local function hide() -- line: 713
        -- upvalues: v91 (copy), v93 (ref), v92 (copy)
        if v93 then
            v93:Cancel()
            v93 = nil
        end

        if v92 and v91.Visible then
            v92:Park()
        else
            v91.Visible = false
        end
    end

    local v94 = t1.image(v91, "Glow", {
        Transparency = 0.3,
        ZIndex = 9,
        Size = UDim2.new(1, 150, 1, 150),
        Position = UDim2.new(0.5, 0, 0.5, 22),
        AnchorPoint = Vector2.new(0.5, 0.5),
        Color = fromRGB(0, 0, 0)
    })

    v94.Name = "Shadow"
    v94.ScaleType = Enum.ScaleType.Stretch

    local v95 = t1.frame(v91, {
        Name = "Body",
        Corner = 26,
        Stroke = 7,
        ZIndex = 10,
        Color = v89:Lerp(fromRGB(18, 20, 44), 0.74),
        Color2 = fromRGB(12, 13, 28)
    })
    local ImageLabel = Instance.new("ImageLabel")

    ImageLabel.Name = "Pattern"
    ImageLabel.BackgroundTransparency = 1
    ImageLabel.Size = UDim2.fromScale(1, 1)
    ImageLabel.Image = t1.Art.Bubbles
    ImageLabel.ScaleType = Enum.ScaleType.Tile
    ImageLabel.TileSize = UDim2.fromOffset(190, 190)
    ImageLabel.ImageColor3 = v89:Lerp(fromRGB(255, 255, 255), 0.5)
    ImageLabel.ImageTransparency = 0.9
    ImageLabel.ZIndex = 10
    t1.corner(ImageLabel, 26)
    ImageLabel.Parent = v95

    local v96 = t1.frame(v95, {
        Name = "Rim",
        Transparency = 1,
        Corner = 22,
        ZIndex = 10,
        Size = UDim2.new(1, -10, 1, -10),
        Position = UDim2.fromOffset(5, 5)
    })
    local UIStroke = Instance.new("UIStroke")

    UIStroke.Thickness = 2
    UIStroke.Color = v89:Lerp(fromRGB(255, 255, 255), 0.55)
    UIStroke.Transparency = 0.55
    UIStroke.Parent = v96

    local v97 = t1.frame(v91, {
        Name = "Header",
        Corner = 24,
        ZIndex = 11,
        Size = UDim2.new(1, 0, 0, 78),
        Color = v89,
        Color2 = v90,
        GradientRotation = p78.GradientRotation
    })

    t1.stroke(v97, 6)

    local v98 = t1.frame(v97, {
        Class = "CanvasGroup",
        Name = "SheenClip",
        Transparency = 1,
        Corner = 24,
        ZIndex = 11
    })

    t1.frame(v98, {
        Name = "Lip",
        Transparency = 0.72,
        ZIndex = 11,
        Size = UDim2.new(1, 0, 0, 12),
        Position = UDim2.new(0, 0, 1, -12),
        Color = fromRGB(0, 0, 0)
    })
    t1.frame(v98, {
        Name = "Gloss",
        Transparency = 0.7,
        Corner = 11,
        ZIndex = 11,
        Size = UDim2.new(1, -24, 0, 22),
        Position = UDim2.fromOffset(12, 7),
        Color = t1.Colors.White
    })

    for i = 0, 2 do
        t1.frame(v98, {
            Name = "Sheen",
            Transparency = 0.8,
            ZIndex = 11,
            Size = UDim2.fromOffset(26 - i * 6, 200),
            Position = UDim2.new(0.62, i * 46, 0.5, 0),
            AnchorPoint = Vector2.new(0.5, 0.5),
            Color = t1.Colors.White
        }).Rotation = 24
    end

    local v99 = t1.text(v91, {
        Name = "Title",
        TextSize = 52,
        Stroke = 6,
        ZIndex = 13,
        Text = p78.Title or "",
        Size = UDim2.new(1, -130, 0, 74),
        Position = UDim2.fromOffset(26, 0),
        XAlign = Enum.TextXAlignment.Left
    })

    t1.gradient(v99, fromRGB(255, 255, 255), v89:Lerp(fromRGB(255, 255, 255), 0.7))

    if p78.Icon or p78.Image then
        (if p78.Icon then t1.icon(v91, p78.Icon, {
            ZIndex = 14,
            Rotation = -8,
            Size = UDim2.fromOffset(96, 96),
            Position = UDim2.fromOffset(6, -14)
        }) else t1.image(v91, p78.Image, {
            ZIndex = 14,
            Rotation = -8,
            Size = UDim2.fromOffset(96, 96),
            Position = UDim2.fromOffset(6, -14),
            Color = p78.ImageColor
        })).Name = "WindowIcon"
        v99.Position = UDim2.fromOffset(106, 0)
    end

    local Red = t1.Colors.Red
    local v106 = math.abs(v89.R - Red.R) + math.abs(v89.G - Red.G) + math.abs(v89.B - Red.B) < 0.35
    local button = t1.button
    local t22 = {
        Name = "Close",
        Text = "X",
        Corner = 29,
        Stroke = 5,
        TextStroke = 4,
        ZIndex = 13,
        Size = UDim2.fromOffset(58, 58),
        Position = UDim2.new(1, -12, 0, 9),
        AnchorPoint = Vector2.new(1, 0)
    }

    if v106 then
        t22.Color = fromRGB(74, 22, 34)
        t22.Color2 = fromRGB(44, 12, 22)
    else
        t22.Color = fromRGB(255, 96, 96)
        t22.Color2 = t1.Colors.RedDark
    end

    local v107 = button(v91, t22)

    Pad.Icon(v107, Enum.KeyCode.ButtonB, {
        ZIndex = 14,
        Size = UDim2.fromOffset(36, 36),
        Position = UDim2.new(1, -4, 0, 4),
        AnchorPoint = Vector2.new(0.5, 0.5)
    })

    local v108 = t1.frame(v91, {
        Name = "Content",
        Transparency = 1,
        ZIndex = 11,
        Size = UDim2.new(1, -28, 1, -102),
        Position = UDim2.fromOffset(14, 88)
    })

    t18.Name = p78.Name
    t18.Frame = v91
    t18.Content = v108
    t18.Header = v97
    t18.IsOpen = false
    t18.OnOpen = nil
    t18.OnClose = nil
    t18.FitHeight = nil

    local n8 = 1

    local function fit() -- line: 790
        -- upvalues: p77 (copy), p78 (copy), t18 (copy), v91 (copy), n8 (ref), t1 (copy)
        local FitScale = p77:FindFirstChild("FitScale")
        local v109 = if not (FitScale and FitScale.Scale > 0) then 1 else FitScale.Scale
        local ViewportSize = workspace.CurrentCamera.ViewportSize
        local v110 = t1.topInset()
        local v111 = (ViewportSize.Y - v110 - 16) / v109

        if t18.FitHeight then
            t18.FitHeight(v111)
        end

        local Offset = v91.Size.Y.Offset

        n8 = if v111 < Offset then math.max(v111 / Offset, 0.5) else 1

        local v113 = t18.FitPosition and t18.FitPosition(v109) or p78.Position or UDim2.fromScale(0.5, 0.5)

        if v113.Y.Scale * ViewportSize.Y / v109 + v113.Y.Offset - Offset * n8 * v91.AnchorPoint.Y < (v110 + 8) / v109 then
            v91.Position = UDim2.new(v113.X.Scale, v113.X.Offset, 0.5, v110 / v109 / 2)
        else
            v91.Position = v113
        end
    end

    t18.Fit = fit

    local function refit() -- line: 811
        -- upvalues: t18 (copy), KitScale (ref), n8 (ref), fit (copy)
        if t18.IsOpen then
            fit()
            KitScale.Scale = n8
        end
    end

    workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(refit)
    GuiService:GetPropertyChangedSignal("TopbarInset"):Connect(refit)

    function t18.Open() -- line: 820
        -- upvalues: p78 (copy), t18 (copy), v91 (copy), KitScale (ref), v93 (ref), v92 (copy), v107 (copy), v108 (copy), n8 (ref), fit (copy), Pad (copy), t1 (copy), BlurEffect (copy), t15 (ref)
        if t18.IsOpen then
            return
        end

        if t15 and t15 ~= t18 then
            t15.Close(true)
        end

        t15 = t18
        t18.IsOpen = true

        if t18.OnOpen then
            t18.OnOpen()
        end

        if v93 then
            v93:Cancel()
            v93 = nil
        end

        if v92 then
            v92:Unpark()
        end

        fit()

        local Position = v91.Position

        v91.Visible = true
        KitScale.Scale = n8

        if v93 then
            v93:Cancel()
            v93 = nil
        end

        v91.Position = Position + UDim2.fromOffset(0, 60)
        v93 = t1.tween(v91, 0.26, {
            Position = Position
        }, Enum.EasingStyle.Back)

        if not p78.NoBlur then
            t1.tween(BlurEffect, 0.2, {
                Size = 14
            })
        end

        t1.sound("WindowOpen")
        Pad.PushBack("Window", function() -- line: 848
            -- upvalues: t18 (copy)
            t18.Close()
        end)
        Pad.SelectIn(v108, v107)
    end

    function t18.Close(p79) -- line: 854
        -- upvalues: t18 (copy), v91 (copy), v93 (ref), v92 (copy), Pad (copy), t1 (copy), BlurEffect (copy), t15 (ref)
        if t18.IsOpen then
            t18.IsOpen = false

            if t15 == t18 then
                t15 = nil
                t1.tween(BlurEffect, 0.15, {
                    Size = 0
                })
                Pad.PopBack("Window")
            end

            Pad.Deselect(v91)

            if t18.OnClose then
                t18.OnClose()
            end

            t1.sound("WindowClose")

            if v93 then
                v93:Cancel()
                v93 = nil
            end

            if p79 then
                if v92 and v91.Visible then
                    v92:Park()
                else
                    v91.Visible = false
                end
            else
                local Position = v91.Position
                local v114 = t1.tween(v91, 0.1, {
                    Position = Position + UDim2.fromOffset(0, 40)
                }, Enum.EasingStyle.Quad, Enum.EasingDirection.In)

                v93 = v114
                v114.Completed:Once(function() -- line: 877
                    -- upvalues: t18 (copy), v91 (copy), v93 (ref), v92 (copy)
                    if t18.IsOpen then
                        return
                    end

                    if v93 then
                        v93:Cancel()
                        v93 = nil
                    end

                    if v92 and v91.Visible then
                        v92:Park()
                    else
                        v91.Visible = false
                    end
                end)
            end
        end
    end

    function t18.Toggle() -- line: 884
        -- upvalues: t18 (copy)
        if t18.IsOpen then
            t18.Close()
        else
            t18.Open()
        end
    end

    v107.Activated:Connect(function() -- line: 892
        -- upvalues: t18 (copy)
        t18.Close()
    end)
    t1.Windows[p78.Name] = t18

    return t18
end

function t1.closeAllWindows() -- line: 899
    -- upvalues: t15 (ref)
    if t15 then
        t15.Close()
    end
end

function t1.anyWindowOpen() -- line: 905
    -- upvalues: t15 (ref)
    return t15 ~= nil
end

return t1
