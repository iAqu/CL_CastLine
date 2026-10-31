-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UITheme = require(ReplicatedStorage.Config.UITheme)
local AnimalUtil = require(ReplicatedStorage.Shared.AnimalUtil)
local Mutations = require(ReplicatedStorage.Shared.Mutations)
local EggModels = require(ReplicatedStorage.Shared.EggModels)
local Sounds = require(script.Parent.Sounds)
local UIScaler = require(script.Parent.UIScaler)
local t1 = {}

local function rgb(p1, p2, p3) -- line: 36
    return Color3.fromRGB(p1, p2, p3)
end

t1.Font = UITheme.Font
t1.RobuxIcon = "rbxasset://textures/ui/common/robux.png"
t1.Icons = {
    Clover = "rbxassetid://103895825256162",
    Gift = "rbxassetid://114440493073627",
    Cash = UITheme.Icons.Money,
    Power = UITheme.Icons.Power
}
t1.Outline = Color3.fromRGB(20, 20, 26)
t1.Palettes = {
    Green = {
        Color3.fromRGB(166, 245, 92),
        Color3.fromRGB(79, 196, 42),
        rgb(44, 122, 22)
    },
    Red = {
        Color3.fromRGB(250, 75, 75),
        Color3.fromRGB(195, 22, 22),
        rgb(122, 14, 14)
    },
    Blue = {
        Color3.fromRGB(96, 205, 255),
        Color3.fromRGB(28, 132, 235),
        rgb(14, 77, 143)
    },
    Gold = {
        Color3.fromRGB(255, 214, 72),
        Color3.fromRGB(255, 146, 24),
        rgb(160, 82, 8)
    },
    Gray = {
        Color3.fromRGB(186, 192, 204),
        Color3.fromRGB(124, 130, 146),
        rgb(72, 76, 88)
    },
    Purple = {
        Color3.fromRGB(205, 145, 255),
        Color3.fromRGB(132, 66, 232),
        rgb(74, 30, 140)
    },
    Pink = {
        Color3.fromRGB(255, 135, 205),
        Color3.fromRGB(232, 62, 152),
        rgb(140, 20, 90)
    },
    Clover = {
        Color3.fromRGB(130, 240, 120),
        Color3.fromRGB(34, 176, 84),
        rgb(16, 100, 44)
    },
    Pumpkin = {
        Color3.fromRGB(255, 190, 70),
        Color3.fromRGB(240, 100, 20),
        rgb(140, 50, 10)
    }
}
t1.PanelColor = Color3.fromRGB(43, 43, 43)
t1.PanelTransparency = 0.25
t1.PanelGradient = {
    Color3.fromRGB(246, 249, 255),
    rgb(214, 224, 238)
}
t1.PillGradient = {
    Color3.fromRGB(59, 71, 99),
    rgb(38, 46, 67)
}
t1.TitleGradient = {
    Color3.fromRGB(255, 255, 255),
    rgb(255, 236, 150)
}

local function palette(p4) -- line: 65
    -- upvalues: t1 (copy)
    if type(p4) == "table" then
        return p4
    end

    return t1.Palettes[p4 or "Green"] or t1.Palettes.Green
end

function t1.Tween(p5, p6, p7, p8, p9) -- line: 74
    -- upvalues: TweenService (copy)
    local tween = TweenService:Create(p5, TweenInfo.new(p7 or 0.25, p8 or Enum.EasingStyle.Quad, p9 or Enum.EasingDirection.Out), p6)

    tween:Play()

    return tween
end

function t1.Corner(p10, p11) -- line: 80
    local UICorner = Instance.new("UICorner")

    if typeof(p11) ~= "UDim" or not p11 then
        UICorner.CornerRadius = UDim.new(0, p11 or 10)
    else
        UICorner.CornerRadius = p11
    end

    UICorner.Parent = p10

    return UICorner
end

function t1.Stroke(p12, p13, p14, p15) -- line: 87
    -- upvalues: t1 (copy)
    local UIStroke = Instance.new("UIStroke")

    UIStroke.Thickness = p13 or 3
    UIStroke.Color = p14 or t1.Outline
    UIStroke.Transparency = p15 or 0
    UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    UIStroke.Parent = p12

    return UIStroke
end

function t1.Gradient(p16, p17, p18, p19) -- line: 97
    local UIGradient = Instance.new("UIGradient")

    if typeof(p17) ~= "ColorSequence" or not p17 then
        UIGradient.Color = ColorSequence.new(p17, p18 or p17)
    else
        UIGradient.Color = p17
    end

    UIGradient.Rotation = p19 or 90
    UIGradient.Parent = p16

    return UIGradient
end

function t1.Sequence(p20) -- line: 106
    local t2 = {}

    for v1, v2 in ipairs(p20) do
        table.insert(t2, ColorSequenceKeypoint.new((v1 - 1) / math.max(1, #p20 - 1), v2))
    end

    return ColorSequence.new(t2)
end

function t1.Stripes(p21, p22, p23, p24) -- line: 114
    -- upvalues: UITheme (copy), t1 (copy)
    local Frame = Instance.new("Frame")

    Frame.Name = "Stripes"
    Frame.Size = UDim2.fromScale(1, 1)
    Frame.BackgroundColor3 = Color3.new(1, 1, 1)
    Frame.BackgroundTransparency = p22 or 0.9
    Frame.BorderSizePixel = 0
    Frame.ZIndex = p21.ZIndex
    t1.Corner(Frame, p23 or 16)

    local UIGradient = Instance.new("UIGradient")

    UIGradient.Rotation = p24 or 20
    UIGradient.Transparency = UITheme.StripeTransparency()
    UIGradient.Parent = Frame
    Frame.Parent = p21

    return Frame
end

function t1.Frame(p25) -- line: 131
    -- upvalues: t1 (copy)
    local Frame = Instance.new("Frame")

    Frame.Name = p25.Name or "Frame"
    Frame.Size = p25.Size or UDim2.fromScale(1, 1)
    Frame.Position = p25.Position or UDim2.new()
    Frame.AnchorPoint = p25.AnchorPoint or Vector2.zero
    Frame.BackgroundColor3 = p25.Color or Color3.new(1, 1, 1)
    Frame.BackgroundTransparency = p25.Transparency or 0
    Frame.BorderSizePixel = 0
    Frame.ZIndex = p25.ZIndex or 1
    Frame.ClipsDescendants = p25.Clip or false
    Frame.Visible = p25.Visible ~= false

    if p25.Rotation then
        Frame.Rotation = p25.Rotation
    end

    if p25.Corner then
        t1.Corner(Frame, p25.Corner)
    end

    if p25.Stroke then
        t1.Stroke(Frame, p25.Stroke, p25.StrokeColor, p25.StrokeTransparency)
    end

    if p25.Gradient then
        t1.Gradient(Frame, p25.Gradient[1], p25.Gradient[2], p25.Gradient[3])
    end

    if p25.Ratio then
        local UIAspectRatioConstraint = Instance.new("UIAspectRatioConstraint")

        UIAspectRatioConstraint.AspectRatio = p25.Ratio

        local Size = Frame.Size

        if Size.Y.Scale == 0 and Size.Y.Offset == 0 then
            UIAspectRatioConstraint.AspectType = Enum.AspectType.ScaleWithParentSize
            UIAspectRatioConstraint.DominantAxis = Enum.DominantAxis.Width
        end

        UIAspectRatioConstraint.Parent = Frame
    end

    Frame.Parent = p25.Parent

    return Frame
end

function t1.Text(p26) -- line: 163
    -- upvalues: t1 (copy)
    local v6 = Instance.new(if p26.Button then "TextButton" else "TextLabel")

    v6.Name = p26.Name or "Text"
    v6.Size = p26.Size or UDim2.fromScale(1, 1)
    v6.Position = p26.Position or UDim2.new()
    v6.AnchorPoint = p26.AnchorPoint or Vector2.zero
    v6.BackgroundTransparency = 1
    v6.BorderSizePixel = 0
    v6.FontFace = t1.Font
    v6.Text = p26.Text or ""
    v6.TextColor3 = p26.Color or Color3.new(1, 1, 1)

    if p26.Wrap then
        v6.TextWrapped = true
    end

    v6.TextScaled = true
    v6.TextXAlignment = p26.XAlign or Enum.TextXAlignment.Center
    v6.TextYAlignment = p26.YAlign or Enum.TextYAlignment.Center
    v6.RichText = p26.Rich or false
    v6.ZIndex = p26.ZIndex or 1
    v6.TextTransparency = p26.TextTransparency or 0

    if p26.Rotation then
        v6.Rotation = p26.Rotation
    end

    if p26.Stroke ~= false then
        local UIStroke = Instance.new("UIStroke")

        UIStroke.Name = "TextStroke"
        UIStroke.Thickness = p26.Stroke or 3
        UIStroke.Color = p26.StrokeColor or t1.Outline
        UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual
        UIStroke.Parent = v6
    end

    if p26.Gradient then
        t1.Gradient(v6, p26.Gradient[1], p26.Gradient[2], p26.Gradient[3] or 90)
    end

    if p26.MaxTextSize then
        local UITextSizeConstraint = Instance.new("UITextSizeConstraint")

        UITextSizeConstraint.MaxTextSize = p26.MaxTextSize
        UITextSizeConstraint.Parent = v6
    end

    v6.Parent = p26.Parent

    return v6
end

function t1.Image(p27) -- line: 203
    local v7 = Instance.new(if p27.Button then "ImageButton" else "ImageLabel")

    v7.Name = p27.Name or "Image"
    v7.BackgroundTransparency = 1
    v7.Image = p27.Image or ""
    v7.ImageColor3 = p27.Color or Color3.new(1, 1, 1)
    v7.ImageTransparency = p27.Transparency or 0
    v7.ScaleType = Enum.ScaleType.Fit
    v7.Size = p27.Size or UDim2.fromScale(1, 1)
    v7.Position = p27.Position or UDim2.new()
    v7.AnchorPoint = p27.AnchorPoint or Vector2.zero
    v7.ZIndex = p27.ZIndex or 1

    if p27.Square then
        v7.SizeConstraint = Enum.SizeConstraint.RelativeYY
    end

    if p27.Rotation then
        v7.Rotation = p27.Rotation
    end

    v7.Parent = p27.Parent

    return v7
end

function t1.Pill(p28) -- line: 221
    -- upvalues: t1 (copy)
    local v8 = t1.Frame({
        Parent = p28.Parent,
        Name = p28.Name or "Pill",
        Size = p28.Size,
        Position = p28.Position,
        AnchorPoint = p28.AnchorPoint,
        ZIndex = p28.ZIndex,
        Rotation = p28.Rotation,
        Corner = UDim.new(0.5, 0),
        Stroke = p28.Stroke or 2,
        Gradient = p28.Gradient or {
            t1.PillGradient[1],
            t1.PillGradient[2],
            90
        }
    })

    return v8, (t1.Text({
        Name = "Label",
        Stroke = 2,
        Parent = v8,
        Text = p28.Text,
        Size = UDim2.fromScale(0.86, 0.74),
        Position = UDim2.fromScale(0.5, 0.5),
        AnchorPoint = Vector2.new(0.5, 0.5),
        ZIndex = v8.ZIndex,
        Rich = p28.Rich,
        Color = p28.TextColor
    }))
end

function t1.SectionTitle(p29) -- line: 229
    -- upvalues: t1 (copy)
    local v9 = t1.Frame({
        Transparency = 1,
        Parent = p29.Parent,
        Name = p29.Name or "Section",
        Size = p29.Size or UDim2.fromScale(1, 0),
        ZIndex = p29.ZIndex,
        Ratio = p29.Ratio or 16
    })

    v9.LayoutOrder = p29.LayoutOrder or 0

    for _, v10 in ipairs({
            { "LineLeft", 0.16, 1, 0 },
            { "LineRight", 0.84, 0, 1 }
        }) do
        local v11 = t1.Frame({
            Corner = 2,
            Parent = v9,
            Name = v10[1],
            Size = UDim2.new(0.3, 0, 0, 3),
            Position = UDim2.fromScale(v10[2], 0.5),
            AnchorPoint = Vector2.new(0.5, 0.5),
            Color = p29.LineColor or Color3.fromRGB(140, 155, 179),
            ZIndex = v9.ZIndex
        })
        local UIGradient = Instance.new("UIGradient")

        UIGradient.Transparency = NumberSequence.new(v10[3], v10[4])
        UIGradient.Parent = v11
    end

    local v12, v13 = t1.Pill({
        Parent = v9,
        Text = p29.Text,
        Size = UDim2.fromScale(p29.Width or 0.34, 0.9),
        Position = UDim2.fromScale(0.5, 0.5),
        AnchorPoint = Vector2.new(0.5, 0.5),
        ZIndex = v9.ZIndex,
        Gradient = p29.PillGradient and {
            p29.PillGradient[1],
            p29.PillGradient[2],
            90
        } or nil
    })

    if p29.PillStroke then
        local UIStroke = v12:FindFirstChildOfClass("UIStroke")

        if UIStroke then
            UIStroke.Color = p29.PillStroke
        end
    end

    if p29.TextGradient then
        t1.Gradient(v13, p29.TextGradient[1], p29.TextGradient[2], 90)
    end

    return v9, v12, v13
end

function t1.Juice(p30, p31, p32) -- line: 255
    -- upvalues: Sounds (copy), t1 (copy)
    local v14 = p32

    p32 = p32 or {}
    v14 = p32

    local JuiceScale = p30:FindFirstChild("JuiceScale")
    local v16 = JuiceScale

    if not JuiceScale then
        local UIScale = Instance.new("UIScale")

        v16 = UIScale
        UIScale.Name = "JuiceScale"
        UIScale.Parent = p30
    end

    local v17 = p32.HoverScale or 1.08
    local Position = p31.Position
    local v18 = false
    local v19 = false
    local v20 = true

    local function refresh() -- line: 266
        -- upvalues: p31 (copy), v16 (ref), v17 (copy), Position (copy), v18 (ref), v19 (ref), v20 (ref), t1 (copy)
        local v21 = if v20 and v19 then v17 * 0.97 elseif v20 and v18 then v17 else 1

        t1.Tween(v16, {
            Scale = v21
        }, 0.16, Enum.EasingStyle.Back, Enum.EasingDirection.Out)

        local v22, v23

        if v20 and v19 then
            local v24 = UDim2.fromOffset(0, 3)

            if v24 then
                v22 = v24
                v23 = true
            else
                v23 = false
            end
        else
            v23 = false
        end

        if not v23 then
            v22 = UDim2.new()
        end

        t1.Tween(p31, {
            Position = Position + v22
        }, 0.08)
    end

    p31.AutoButtonColor = false
    p31.MouseEnter:Connect(function() -- line: 275
        -- upvalues: v14 (ref), v18 (ref), v20 (ref), refresh (copy), Sounds (copy)
        v18 = true
        refresh()

        if v20 and v14.Sound ~= false then
            Sounds.Play("ButtonHover")
        end
    end)
    p31.MouseLeave:Connect(function() -- line: 280
        -- upvalues: v18 (ref), v19 (ref), refresh (copy)
        v18 = false
        v19 = false
        refresh()
    end)
    p31.MouseButton1Down:Connect(function() -- line: 284
        -- upvalues: v19 (ref), refresh (copy)
        v19 = true
        refresh()
    end)
    p31.MouseButton1Up:Connect(function() -- line: 288
        -- upvalues: v19 (ref), refresh (copy)
        v19 = false
        refresh()
    end)
    p31.Activated:Connect(function() -- line: 292
        -- upvalues: v14 (ref), v20 (ref), Sounds (copy)
        if v20 and v14.Sound ~= false then
            Sounds.Play("ButtonClick")
        end
    end)

    return {
        SetEnabled = function(_, p34) -- SetEnabled | line: 296
            -- upvalues: v20 (ref), refresh (copy)
            v20 = p34
            refresh()
        end,
        IsEnabled = function(_) -- IsEnabled | line: 300
            -- upvalues: v20 (ref)
            return v20
        end
    }
end

function t1.SetButtonColor(p36, p37) -- line: 305
    -- upvalues: t1 (copy)
    local v25 = if type(p37) == "table" then p37 else t1.Palettes[p37 or "Green"] or t1.Palettes.Green
    local Edge = p36:FindFirstChild("Edge")
    local Button = p36:FindFirstChild("Button")

    if Edge then
        Edge.BackgroundColor3 = v25[3]
    end

    local UIGradient = Button and Button:FindFirstChildOfClass("UIGradient")

    if UIGradient then
        UIGradient.Color = ColorSequence.new(v25[1], v25[2])
    end
end

function t1.Button(p38) -- line: 317
    -- upvalues: t1 (copy)
    local Color = p38.Color

    if type(Color) ~= "table" then
        Color = t1.Palettes[Color or "Green"] or t1.Palettes.Green
    end

    local v26 = p38.ZIndex or 1
    local v27 = t1.Frame({
        Parent = nil,
        Transparency = 1,
        Name = p38.Name or "Button",
        Size = p38.Size,
        Position = p38.Position,
        AnchorPoint = p38.AnchorPoint,
        ZIndex = v26,
        Ratio = p38.Ratio
    })

    t1.Frame({
        Name = "Edge",
        Corner = 10,
        Stroke = 3,
        Parent = v27,
        Position = UDim2.fromOffset(0, 4),
        Color = Color[3],
        ZIndex = v26
    })

    local TextButton = Instance.new("TextButton")

    TextButton.Name = "Button"
    TextButton.Size = UDim2.fromScale(1, 1)
    TextButton.BackgroundColor3 = Color3.new(1, 1, 1)
    TextButton.BorderSizePixel = 0
    TextButton.Text = ""
    TextButton.AutoButtonColor = false
    TextButton.ZIndex = v26
    t1.Corner(TextButton, 10)
    t1.Stroke(TextButton, 3)
    t1.Gradient(TextButton, Color[1], Color[2], 90)
    TextButton.Parent = v27
    t1.Frame({
        Name = "Shine",
        Transparency = 0.78,
        Corner = 8,
        Parent = TextButton,
        Position = UDim2.fromOffset(5, 3),
        Size = UDim2.new(1, -10, 0.38, 0),
        ZIndex = v26
    })

    local v28
    local v29 = p38.TextScale or 0.66
    local v30, v31, ImageLabel

    if p38.Price then
        local v32 = t1.Frame({
            Name = "Content",
            Transparency = 1,
            Parent = TextButton,
            Size = UDim2.fromScale(0.9, 0.7),
            Position = UDim2.fromScale(0.5, 0.5),
            AnchorPoint = Vector2.new(0.5, 0.5),
            ZIndex = v26
        })
        local UIListLayout = Instance.new("UIListLayout")

        UIListLayout.FillDirection = Enum.FillDirection.Horizontal
        UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
        UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Center
        UIListLayout.Padding = UDim.new(0.04, 0)
        UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
        UIListLayout.Parent = v32

        local ImageLabel2 = Instance.new("ImageLabel")

        ImageLabel2.Name = "RobuxIcon"
        ImageLabel2.BackgroundTransparency = 1
        ImageLabel2.Image = t1.RobuxIcon
        ImageLabel2.Size = UDim2.fromScale(1, 0.92)
        ImageLabel2.SizeConstraint = Enum.SizeConstraint.RelativeYY
        ImageLabel2.ZIndex = v26
        ImageLabel2.LayoutOrder = 1
        ImageLabel2.Parent = v32

        if p38.FitPrice then
            local v33 = t1.Text({
                Name = "PriceLabel",
                Stroke = 3,
                Parent = v32,
                Text = tostring(p38.Price),
                Size = UDim2.fromScale(0, 1),
                ZIndex = v26
            })

            v28 = v33
            v33.TextScaled = false
            v33.AutomaticSize = Enum.AutomaticSize.X

            local function fit() -- line: 362
                -- upvalues: v28 (ref), v32 (copy), ImageLabel2 (copy)
                local AbsoluteSize = v32.AbsoluteSize

                if AbsoluteSize.Y <= 0 then
                    return
                end

                local v36 = math.max(8, (math.floor(AbsoluteSize.Y * 0.98)))
                local v37 = v28

                v37.TextSize = v36

                local v38 = ImageLabel2.Visible and AbsoluteSize.Y * 0.92 + AbsoluteSize.X * 0.04 or 0
                local X = v28.TextBounds.X
                local v39 = (AbsoluteSize.X - v38) * 0.95

                if not (v39 < X and X > 0) then
                    return
                end

                v37.TextSize = math.max(8, (math.floor(v36 * v39 / X)))
            end

            v32:GetPropertyChangedSignal("AbsoluteSize"):Connect(fit)
            v28:GetPropertyChangedSignal("Text"):Connect(fit)
            ImageLabel2:GetPropertyChangedSignal("Visible"):Connect(fit)
            fit()
        else
            v28 = t1.Text({
                Name = "PriceLabel",
                Stroke = 3,
                Parent = v32,
                Text = tostring(p38.Price),
                Size = UDim2.fromScale(0.62, 1),
                ZIndex = v26
            })
        end

        v28.LayoutOrder = 2
        v30 = v28
        v31 = v30
        ImageLabel = ImageLabel2
    else
        local v42 = p38.Icon ~= nil

        v30 = t1.Text({
            Name = "Label",
            Stroke = 3,
            Parent = TextButton,
            Text = p38.Text or "",
            Size = UDim2.fromScale(v42 and 0.6 or 0.86, v29),
            Position = UDim2.fromScale(v42 and 0.62 or 0.5, 0.5),
            AnchorPoint = Vector2.new(0.5, 0.5),
            ZIndex = v26,
            Rich = p38.Rich
        })
        v31 = v30

        if v42 then
            ImageLabel = Instance.new("ImageLabel")
            ImageLabel.Name = "Icon"
            ImageLabel.BackgroundTransparency = 1
            ImageLabel.Image = p38.Icon
            ImageLabel.AnchorPoint = Vector2.new(0.5, 0.5)
            ImageLabel.Position = UDim2.fromScale(0.17, 0.45)
            ImageLabel.Size = UDim2.fromScale(1.15, 1.15)
            ImageLabel.SizeConstraint = Enum.SizeConstraint.RelativeYY
            ImageLabel.ZIndex = v26
            ImageLabel.Parent = TextButton
        end
    end

    local v43 = t1.Juice(v27, TextButton, {
        HoverScale = p38.HoverScale
    })
    local t11 = {
        Holder = v27,
        Button = TextButton,
        Label = v30,
        Icon = ImageLabel,
        Juice = v43,
        SetText = function(_, p40) -- SetText | line: 401
            -- upvalues: v31 (ref)
            v31.Text = p40
        end,
        SetColor = function(_, p42) -- SetColor | line: 402
            -- upvalues: v27 (copy), t1 (copy)
            t1.SetButtonColor(v27, p42)
        end,
        SetEnabled = function(_, p44) -- SetEnabled | line: 403
            -- upvalues: TextButton (copy), v43 (copy)
            v43:SetEnabled(p44)
            TextButton.Active = p44
        end
    }

    if p38.OnClick then
        TextButton.Activated:Connect(function() -- line: 408
            -- upvalues: p38 (copy), v43 (copy), t11 (copy)
            if v43:IsEnabled() then
                p38.OnClick(t11)
            end
        end)
    end

    v27.Parent = p38.Parent

    return t11
end

function t1.Panel(p45) -- line: 424
    -- upvalues: UIScaler (copy), t1 (copy)
    local v44 = p45.ZIndex or 1
    local v45 = p45.Color or "Gold"

    if type(v45) ~= "table" then
        v45 = t1.Palettes[v45 or "Green"] or t1.Palettes.Green
    end

    local v46 = t1.Frame({
        Parent = nil,
        Transparency = 1,
        Name = p45.Name or "Panel",
        Size = p45.Size,
        Position = p45.Position or UDim2.fromScale(0.5, 0.5),
        AnchorPoint = p45.AnchorPoint or Vector2.new(0.5, 0.5),
        ZIndex = v44,
        Ratio = p45.Ratio
    })
    local UIScale = Instance.new("UIScale")

    UIScale.Parent = v46
    t1.Frame({
        Name = "Shadow",
        Transparency = 0.55,
        Corner = 18,
        Parent = v46,
        Position = UDim2.fromOffset(6, 9),
        Color = Color3.new(0, 0, 0),
        ZIndex = v44
    })

    local v47 = t1.Frame({
        Name = "Body",
        Corner = 16,
        Stroke = 5,
        Parent = v46,
        Color = t1.PanelColor,
        Transparency = p45.Transparency or t1.PanelTransparency,
        StrokeColor = Color3.fromRGB(26, 26, 32),
        Gradient = {
            t1.PanelGradient[1],
            t1.PanelGradient[2],
            90
        },
        ZIndex = v44
    })

    t1.Stripes(v47, 0.965, 16, 20)

    local v48 = p45.HeaderHeight or 0.16
    local v49 = t1.Frame({
        Name = "Header",
        Corner = 16,
        Parent = v47,
        Size = UDim2.fromScale(1, v48),
        Gradient = {
            v45[1],
            v45[2],
            0
        },
        ZIndex = v44
    })

    t1.Frame({
        Name = "BottomPatch",
        Parent = v49,
        Size = UDim2.fromScale(1, 0.45),
        Position = UDim2.fromScale(0, 1),
        AnchorPoint = Vector2.new(0, 1),
        Gradient = {
            v45[1],
            v45[2],
            0
        },
        ZIndex = v44
    })
    t1.Stripes(v49, 0.86, 16, 20)
    t1.Frame({
        Name = "BottomLine",
        Parent = v49,
        Size = UDim2.new(1, 0, 0, 4),
        Position = UDim2.fromScale(0, 1),
        AnchorPoint = Vector2.new(0, 1),
        Color = Color3.fromRGB(26, 26, 32),
        ZIndex = v44
    })

    local v50

    if p45.TitleIcon then
        local ImageLabel = Instance.new("ImageLabel")

        ImageLabel.Name = "TitleIcon"
        ImageLabel.BackgroundTransparency = 1
        ImageLabel.Image = p45.TitleIcon
        ImageLabel.Size = UDim2.fromScale(1.05, 1.05)
        ImageLabel.SizeConstraint = Enum.SizeConstraint.RelativeYY
        ImageLabel.AnchorPoint = Vector2.new(0, 0.5)
        ImageLabel.Position = UDim2.fromScale(0.015, 0.45)
        ImageLabel.ZIndex = v44
        v50 = 0.1
        ImageLabel.Parent = v49
    else
        v50 = 0.03
    end

    local v51 = t1.Text({
        Name = "Title",
        Stroke = 4,
        Parent = v49,
        Text = p45.Title or "",
        Size = UDim2.fromScale(0.72, 0.66),
        Position = UDim2.fromScale(v50, 0.5),
        AnchorPoint = Vector2.new(0, 0.5),
        XAlign = Enum.TextXAlignment.Left,
        ZIndex = v44,
        Gradient = {
            t1.TitleGradient[1],
            t1.TitleGradient[2],
            90
        }
    })
    local v52 = if p45.OnClose then t1.Button({
        Name = "CloseButton",
        Text = "X",
        Color = "Red",
        Ratio = 1,
        Parent = v49,
        Size = UDim2.fromScale(0.1, 0.66),
        Position = UDim2.fromScale(0.985, 0.46),
        AnchorPoint = Vector2.new(1, 0.5),
        ZIndex = v44,
        OnClick = p45.OnClose
    }) else nil
    local v53 = t1.Frame({
        Name = "Content",
        Transparency = 1,
        Parent = v47,
        Size = UDim2.fromScale(1, 1 - v48),
        Position = UDim2.fromScale(0, v48),
        ZIndex = v44
    })

    v46.Parent = p45.Parent
    UIScaler.FitWindow(v46)

    return {
        Root = v46,
        Scale = UIScale,
        Panel = v47,
        Header = v49,
        Title = v51,
        Close = v52,
        Content = v53
    }
end

function t1.PopIn(p46, p47, p48) -- line: 465
    -- upvalues: t1 (copy)
    local v54 = p46:FindFirstChildOfClass("UIScale") or Instance.new("UIScale", p46)

    v54.Scale = p48 or 0.6
    p46.Visible = true

    return t1.Tween(v54, {
        Scale = 1
    }, p47 or 0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
end

function t1.PopOut(p49, p50, p51) -- line: 472
    -- upvalues: t1 (copy)
    local v55 = p49:FindFirstChildOfClass("UIScale") or Instance.new("UIScale", p49)

    return (t1.Tween(v55, {
        Scale = p51 or 0.7
    }, p50 or 0.2, Enum.EasingStyle.Back, Enum.EasingDirection.In))
end

function t1.Punch(p52, p53, p54) -- line: 478
    -- upvalues: t1 (copy)
    local PunchScale = p52:FindFirstChild("PunchScale")

    if not PunchScale then
        PunchScale = Instance.new("UIScale")
        PunchScale.Name = "PunchScale"
        PunchScale.Parent = p52
    end

    PunchScale.Scale = 1 + (p53 or 0.2)

    return t1.Tween(PunchScale, {
        Scale = 1
    }, p54 or 0.4, Enum.EasingStyle.Elastic, Enum.EasingDirection.Out)
end

function t1.Dim(p55, p56, p57) -- line: 490
    -- upvalues: UIScaler (copy), t1 (copy)
    local TextButton = Instance.new("TextButton")

    TextButton.Name = "Dim"
    TextButton.Text = ""
    TextButton.AutoButtonColor = false
    TextButton.Size = UDim2.fromScale(1, 1)
    TextButton.BackgroundColor3 = Color3.new(0, 0, 0)
    TextButton.BackgroundTransparency = 1
    TextButton.BorderSizePixel = 0
    TextButton.ZIndex = p56 or 0
    TextButton.Parent = p55
    UIScaler.CoverScreen(TextButton)
    t1.Tween(TextButton, {
        BackgroundTransparency = 1 - (p57 or 0.45)
    }, 0.25)

    return TextButton
end

function t1.InputSink(p58) -- line: 508
    local TextButton = Instance.new("TextButton")

    TextButton.Name = "InputSink"
    TextButton.Text = ""
    TextButton.AutoButtonColor = false
    TextButton.Selectable = false
    TextButton.BackgroundTransparency = 1
    TextButton.Size = UDim2.fromScale(1, 1)
    TextButton.ZIndex = 0
    TextButton.Parent = p58

    return TextButton
end

function t1.FitCamera(p59, p60, p61, p62, p63) -- line: 528
    -- upvalues: AnimalUtil (copy)
    local CurrentCamera = p59.CurrentCamera

    if CurrentCamera and p60 then
        local v56, v57 = AnimalUtil.GetPosedBoundingBox(p60)
        local Position = v56.Position
        local AbsoluteSize = p59.AbsoluteSize
        local v58 = AbsoluteSize.X > 2 and AbsoluteSize.Y > 2 and AbsoluteSize.X / AbsoluteSize.Y or 1
        local v60 = math.tan(math.rad(CurrentCamera.FieldOfView) / 2)
        local v61 = v60 * v58
        local v62 = (CFrame.Angles(0, p61 or 0, 0) * CFrame.Angles(p62 or 0, 0, 0)):VectorToWorldSpace((Vector3.new(0, 0, -1)))
        local v63 = CFrame.lookAt(Position + v62, Position)
        local RightVector, UpVector = v63.RightVector, v63.UpVector
        local v64 = -v63.LookVector
        local v65 = v57 / 2
        local n1 = 0

        for _, v66 in ipairs({ -1, 1 }) do
            local v67 = n1

            for _, v68 in ipairs({ -1, 1 }) do
                for _, v70 in ipairs({ -1, 1 }) do
                    local v74 = v56:PointToWorldSpace((Vector3.new(v65.X * v66, v65.Y * v68, v65.Z * v70))) - Position

                    v67 = math.max(v67, v74:Dot(v64) + math.max(math.abs((v74:Dot(RightVector))) / v61, math.abs((v74:Dot(UpVector))) / v60))
                end

                n1 = v67
            end
        end

        CurrentCamera.CFrame = CFrame.lookAt(Position + v62 * n1 * (p63 or 1), Position)
    end
end

local t14 = {}

function t1.Viewport(p64) -- line: 562
    -- upvalues: AnimalUtil (copy), t1 (copy), t14 (copy)
    local ViewportFrame = Instance.new("ViewportFrame")

    ViewportFrame.Name = p64.Name or "Viewport"
    ViewportFrame.Size = p64.Size or UDim2.fromScale(1, 1)
    ViewportFrame.Position = p64.Position or UDim2.new()
    ViewportFrame.AnchorPoint = p64.AnchorPoint or Vector2.zero
    ViewportFrame.BackgroundTransparency = 1
    ViewportFrame.BorderSizePixel = 0
    ViewportFrame.ZIndex = p64.ZIndex or 1
    ViewportFrame.Ambient = p64.Ambient or Color3.fromRGB(225, 225, 232)
    ViewportFrame.LightColor = Color3.new(1, 1, 1)
    ViewportFrame.LightDirection = Vector3.new(-1, -1.4, -0.8)

    local Camera = Instance.new("Camera")

    Camera.FieldOfView = p64.FieldOfView or 32
    Camera.Parent = ViewportFrame
    ViewportFrame.CurrentCamera = Camera

    local WorldModel = Instance.new("WorldModel")

    WorldModel.Parent = ViewportFrame
    ViewportFrame.Parent = p64.Parent

    local t15 = {
        Model = nil,
        Angle = 0,
        Frame = ViewportFrame,
        World = WorldModel,
        Yaw = p64.Yaw or -0.4886921905584123,
        Pitch = p64.Pitch or 0.20943951023931956,
        Pad = p64.Pad or 1,
        Spin = p64.Spin,
        Bob = p64.Bob,
        Sway = p64.Sway,
        Phase = p64.Phase or 0,
        Active = p64.Active,
        Refit = function(p65) -- Refit | line: 584
            -- upvalues: ViewportFrame (copy), t1 (copy)
            if p65.Model then
                t1.FitCamera(ViewportFrame, p65.Model, p65.Yaw, p65.Pitch, p65.Pad)
            end
        end,
        SetModel = function(p66, p67, p68) -- SetModel | line: 587
            -- upvalues: WorldModel (copy), AnimalUtil (copy)
            if p66.Model then
                p66.Model:Destroy()
            end

            p66.Model = p67

            if p67 then
                p67:PivotTo(p68 or CFrame.new())
                p67.Parent = WorldModel
                p66.Center = AnimalUtil.GetPosedBoundingBox(p67).Position
                p66.BasePivot = p67:GetPivot()
                p66:Refit()
            end
        end
    }

    function t15.Destroy(_) -- line: 598
        -- upvalues: ViewportFrame (copy), t15 (copy), t14 (copy)
        t14[t15] = nil
        ViewportFrame:Destroy()
    end

    ViewportFrame:GetPropertyChangedSignal("AbsoluteSize"):Connect(function() -- line: 602
        -- upvalues: t15 (copy)
        t15:Refit()
    end)
    ViewportFrame.Destroying:Connect(function() -- line: 603
        -- upvalues: t15 (copy), t14 (copy)
        t14[t15] = nil
    end)

    if p64.Model then
        t15:SetModel(p64.Model, p64.ModelRotation)
    end

    if p64.Spin or p64.Bob or p64.Sway then
        t14[t15] = true
    end

    return t15
end

RunService.RenderStepped:Connect(function(p70) -- line: 609
    -- upvalues: t14 (copy)
    local elapsed = os.clock()

    for v81 in pairs(t14) do
        local Model = v81.Model

        if Model and Model.Parent and v81.Frame.Visible and (not v81.Active or v81.Active()) then
            v81.Angle += p70 * (v81.Spin or 0)

            local v89 = v81.Angle + (v81.Sway and math.sin(elapsed * 0.9 + v81.Phase) * v81.Sway or 0)
            local v90 = v81.Bob and math.sin(elapsed * 2.2 + v81.Phase) * v81.Bob or 0
            local Center = v81.Center

            Model:PivotTo(CFrame.new(Center + Vector3.new(0, v90, 0)) * CFrame.Angles(0, v89, 0) * CFrame.new(-Center) * v81.BasePivot)
        end
    end
end)

function t1.ItemModel(p71) -- line: 624
    -- upvalues: AnimalUtil (copy), Mutations (copy), EggModels (copy)
    if p71.Egg then
        return EggModels.Make(p71.Egg, 4)
    end

    if not p71.Animal then
        return nil
    end

    local v92 = AnimalUtil.Create(p71.Animal)

    if v92 and p71.Mutation then
        Mutations.Apply(v92, p71.Mutation, {
            Particles = false
        })
    end

    return v92
end

local t16 = {
    Color3.fromRGB(255, 214, 72),
    Color3.fromRGB(166, 245, 92),
    Color3.fromRGB(96, 205, 255),
    Color3.fromRGB(255, 120, 190),
    Color3.fromRGB(200, 140, 255),
    Color3.new(1, 1, 1)
}

function t1.Confetti(p72, p73, p74, p75) -- line: 644
    -- upvalues: RunService (copy), t16 (copy)
    local v93 = p75

    p75 = p75 or {}
    v93 = p75

    local t17 = {}

    for _ = 1, p74 or 40 do
        local Frame = Instance.new("Frame")
        local v95 = math.random(7, 13)

        Frame.Size = UDim2.fromOffset(v95, math.random(4, 9))
        Frame.AnchorPoint = Vector2.new(0.5, 0.5)
        Frame.BackgroundColor3 = (p75.Colors or t16)[math.random(1, #(p75.Colors or t16))]
        Frame.BorderSizePixel = 0
        Frame.ZIndex = p75.ZIndex or 80
        Frame.Rotation = math.random(0, 360)
        Frame.Parent = p72

        local v96 = p75.Spread or 80
        local v98 = math.rad(math.random(-v96, v96) + (p75.Direction or -90))
        local v99 = math.random(p75.MinSpeed or 380, p75.MaxSpeed or 820)

        table.insert(t17, {
            Age = 0,
            Frame = Frame,
            Pos = p73 + Vector2.new(math.random(-10, 10), math.random(-6, 6)),
            Vel = Vector2.new(math.cos(v98), (math.sin(v98))) * v99,
            Spin = math.random(-540, 540),
            Life = 1.4 + math.random() * 0.9
        })
    end

    local connection

    connection = RunService.RenderStepped:Connect(function(p76) -- line: 670
        -- upvalues: v93 (ref), t17 (copy), connection (ref)
        local n2 = 0

        for _, v100 in ipairs(t17) do
            if v100.Frame.Parent then
                v100.Age += p76
                v100.Vel = Vector2.new(v100.Vel.X * (1 - p76 * 1.4), v100.Vel.Y + (v93.Gravity or 1100) * p76)
                v100.Pos += v100.Vel * p76
                v100.Frame.Position = UDim2.fromOffset(v100.Pos.X, v100.Pos.Y)
                v100.Frame.Rotation += v100.Spin * p76

                local v102 = math.clamp((v100.Age - v100.Life * 0.7) / (v100.Life * 0.3), 0, 1)

                v100.Frame.BackgroundTransparency = v102

                if v100.Age >= v100.Life then
                    v100.Frame:Destroy()
                else
                    n2 += 1
                end
            end
        end

        if n2 == 0 then
            connection:Disconnect()
        end
    end)
end

function t1.Rays(p77, p78, p79) -- line: 694
    -- upvalues: RunService (copy), t1 (copy)
    local v103 = p79

    p79 = p79 or {}
    v103 = p79

    local v105 = t1.Frame({
        Name = "Rays",
        Transparency = 1,
        Ratio = 1,
        Parent = p77,
        Size = p79.Size or UDim2.fromScale(1, 1),
        Position = p79.Position or UDim2.fromScale(0.5, 0.5),
        AnchorPoint = Vector2.new(0.5, 0.5),
        ZIndex = p79.ZIndex or 1
    })
    local v106 = p79.Count or 8

    for i = 1, v106 do
        local v107 = t1.Frame({
            Name = "Ray",
            Parent = v105,
            Size = UDim2.fromScale(p79.Width or 0.12, 1),
            Position = UDim2.fromScale(0.5, 0.5),
            AnchorPoint = Vector2.new(0.5, 0.5),
            Color = p78 or Color3.fromRGB(255, 230, 120),
            ZIndex = v105.ZIndex
        })

        v107.Rotation = (i - 1) * (180 / v106)

        local UIGradient = Instance.new("UIGradient")

        UIGradient.Rotation = 90
        UIGradient.Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 1),
            NumberSequenceKeypoint.new(0.35, p79.Alpha or 0.55),
            NumberSequenceKeypoint.new(0.5, 1),
            NumberSequenceKeypoint.new(0.65, p79.Alpha or 0.55),
            NumberSequenceKeypoint.new(1, 1)
        })
        UIGradient.Parent = v107
    end

    local v108 = p79.Speed or 25
    local connection

    connection = RunService.RenderStepped:Connect(function(p80) -- line: 708
        -- upvalues: v103 (ref), v105 (copy), v108 (copy), connection (ref)
        if v105.Parent then
            if not v103.Active or v103.Active() then
                v105.Rotation = (v105.Rotation + p80 * v108) % 360
            end
        else
            connection:Disconnect()
        end
    end)

    return v105
end

function t1.Spinner(p81, p82) -- line: 717
    -- upvalues: RunService (copy), t1 (copy)
    p82 = p82 or {}

    local v110 = t1.Frame({
        Name = "Spinner",
        Transparency = 1,
        Ratio = 1,
        Parent = p81,
        Size = p82.Size or UDim2.fromScale(0.2, 0.2),
        Position = p82.Position or UDim2.fromScale(0.5, 0.5),
        AnchorPoint = Vector2.new(0.5, 0.5),
        ZIndex = p82.ZIndex or 1,
        Corner = UDim.new(0.5, 0)
    })
    local v111 = t1.Stroke(v110, p82.Thickness or 6, p82.Color or Color3.new(1, 1, 1))
    local UIGradient = Instance.new("UIGradient")

    UIGradient.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0),
        NumberSequenceKeypoint.new(0.55, 0.1),
        NumberSequenceKeypoint.new(0.75, 1),
        NumberSequenceKeypoint.new(1, 1)
    })
    UIGradient.Parent = v111

    local connection

    connection = RunService.RenderStepped:Connect(function(p83) -- line: 725
        -- upvalues: v110 (copy), UIGradient (copy), connection (ref)
        if v110.Parent then
            UIGradient.Rotation = (UIGradient.Rotation + p83 * 360) % 360
        else
            connection:Disconnect()
        end
    end)

    return v110
end

function t1.FormatTime(p84) -- line: 732
    local v117 = math.max(0, (math.floor(p84 + 0.5)))
    local v119 = math.floor(v117 / 3600)
    local v121 = math.floor(v117 % 3600 / 60)
    local v122 = v117 % 60

    if v119 > 0 then
        return string.format("%d:%02d:%02d", v119, v121, v122)
    end

    return string.format("%d:%02d", v121, v122)
end

function t1.FormatRobux(p85) -- line: 742
    return (tostring((math.floor(p85))):reverse():gsub("(%d%d%d)", "%1,"):reverse():gsub("^,", ""))
end

return t1
