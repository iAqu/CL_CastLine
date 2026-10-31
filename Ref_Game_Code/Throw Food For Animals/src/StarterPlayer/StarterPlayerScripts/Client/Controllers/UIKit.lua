-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UITheme = require(ReplicatedStorage.Config.UITheme)
local RarityConfig = require(ReplicatedStorage.Config.RarityConfig)
local Sounds = require(script.Parent.Sounds)
local UIScaler = require(script.Parent.UIScaler)
local Colors = UITheme.Colors
local PlayerGui = Players.LocalPlayer:WaitForChild("PlayerGui")
local t1 = {}

function t1.ScreenGui(p1, p2, p3) -- line: 34
    -- upvalues: PlayerGui (copy)
    local ScreenGui = Instance.new("ScreenGui")

    ScreenGui.Name = p1
    ScreenGui.ResetOnSpawn = false
    ScreenGui.IgnoreGuiInset = p3 ~= false
    ScreenGui.DisplayOrder = p2 or 5
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.Parent = PlayerGui

    return ScreenGui
end

function t1.Corner(p4, p5) -- line: 45
    -- upvalues: UITheme (copy)
    local UICorner = Instance.new("UICorner")

    UICorner.CornerRadius = UDim.new(0, p5 or UITheme.Corner.Button)
    UICorner.Parent = p4

    return UICorner
end

function t1.Stroke(p6, p7, p8, p9) -- line: 52
    local UIStroke = Instance.new("UIStroke")

    UIStroke.Thickness = p7 or 3
    UIStroke.Color = p8 or Color3.new(0, 0, 0)
    UIStroke.ApplyStrokeMode = p9 and Enum.ApplyStrokeMode.Contextual or Enum.ApplyStrokeMode.Border
    UIStroke.Parent = p6

    return UIStroke
end

function t1.Gradient(p10, p11, p12, p13) -- line: 61
    local UIGradient = Instance.new("UIGradient")

    if typeof(p11) == "ColorSequence" then
        UIGradient.Color = p11
        UIGradient.Rotation = p12 or 90
    else
        UIGradient.Color = ColorSequence.new(p11, p12)
        UIGradient.Rotation = p13 or 90
    end

    UIGradient.Parent = p10

    return UIGradient
end

function t1.RarityGradient(p14, p15, p16) -- line: 74
    -- upvalues: RarityConfig (copy), t1 (copy)
    local v1 = RarityConfig.Get(p15)

    return t1.Gradient(p14, v1.Gradient, p16 or 90)
end

function t1.Stripes(p17, p18, p19, p20) -- line: 80
    -- upvalues: UITheme (copy), t1 (copy)
    local Frame = Instance.new("Frame")

    Frame.Name = "Stripes"
    Frame.Size = UDim2.fromScale(1, 1)
    Frame.BackgroundColor3 = Color3.new(1, 1, 1)
    Frame.BackgroundTransparency = p19 or 0.9
    Frame.BorderSizePixel = 0
    Frame.ZIndex = (p17:IsA("GuiObject") and p17.ZIndex or 1) + 1
    t1.Corner(Frame, p20 or UITheme.Corner.Card)

    local UIGradient = Instance.new("UIGradient")

    UIGradient.Color = ColorSequence.new(Color3.new(1, 1, 1))
    UIGradient.Rotation = p18 or 20
    UIGradient.Transparency = UITheme.StripeTransparency()
    UIGradient.Parent = Frame
    Frame.Parent = p17

    return Frame
end

function t1.Frame(p21) -- line: 98
    -- upvalues: t1 (copy), Colors (copy)
    local Frame = Instance.new("Frame")

    Frame.Name = p21.Name or "Frame"
    Frame.Size = p21.Size or UDim2.fromScale(1, 1)
    Frame.Position = p21.Position or UDim2.new()
    Frame.AnchorPoint = p21.AnchorPoint or Vector2.new()
    Frame.BackgroundColor3 = p21.Color or Colors.Panel
    Frame.BackgroundTransparency = p21.Transparency or 0
    Frame.BorderSizePixel = 0
    Frame.ZIndex = p21.ZIndex or 1
    Frame.ClipsDescendants = p21.Clip or false

    if p21.Corner then
        t1.Corner(Frame, p21.Corner)
    end

    if p21.Stroke then
        t1.Stroke(Frame, p21.Stroke, p21.StrokeColor)
    end

    if p21.Gradient then
        t1.Gradient(Frame, p21.Gradient[1], p21.Gradient[2], p21.Gradient[3])
    end

    Frame.Parent = p21.Parent

    return Frame
end

function t1.Text(p22) -- line: 116
    -- upvalues: UITheme (copy), t1 (copy), Colors (copy)
    local v2 = Instance.new(if p22.Button then "TextButton" else "TextLabel")

    v2.Name = p22.Name or "Text"
    v2.Size = p22.Size or UDim2.fromScale(1, 1)
    v2.Position = p22.Position or UDim2.new()
    v2.AnchorPoint = p22.AnchorPoint or Vector2.new()
    v2.BackgroundTransparency = 1
    v2.BorderSizePixel = 0
    v2.FontFace = UITheme.Font
    v2.Text = p22.Text or ""
    v2.TextColor3 = p22.Color or Colors.Text
    v2.TextScaled = p22.Scaled ~= false
    v2.TextSize = p22.TextSize or 20
    v2.TextXAlignment = p22.XAlign or Enum.TextXAlignment.Center
    v2.TextYAlignment = p22.YAlign or Enum.TextYAlignment.Center
    v2.RichText = p22.Rich or false
    v2.ZIndex = p22.ZIndex or 1
    v2.TextTransparency = p22.TextTransparency or 0

    if p22.Stroke ~= false then
        t1.Stroke(v2, p22.Stroke or UITheme.Stroke.Text, Colors.TextStroke, true).Name = "TextStroke"
    end

    if p22.MaxTextSize then
        local UITextSizeConstraint = Instance.new("UITextSizeConstraint")

        UITextSizeConstraint.MaxTextSize = p22.MaxTextSize
        UITextSizeConstraint.MinTextSize = p22.MinTextSize or 8
        UITextSizeConstraint.Parent = v2
    end

    v2.Parent = p22.Parent

    return v2
end

function t1.RarityText(p23) -- line: 149
    -- upvalues: t1 (copy)
    local v3 = t1.Text(p23)

    v3.TextColor3 = Color3.new(1, 1, 1)
    t1.RarityGradient(v3, p23.Rarity or "Common", p23.Rotation or 90)

    return v3
end

function t1.Shadow(p24, p25, p26) -- line: 156
    -- upvalues: UITheme (copy), UIScaler (copy), t1 (copy)
    local Frame = Instance.new("Frame")

    Frame.Name = "Shadow"
    Frame.Size = UDim2.fromScale(1, 1)

    local v4 = (p25 or 6) * UIScaler.Factor()

    Frame.Position = UDim2.fromOffset(v4, v4 * 1.5)
    Frame.BackgroundColor3 = Color3.new(0, 0, 0)
    Frame.BackgroundTransparency = 0.5
    Frame.BorderSizePixel = 0
    Frame.ZIndex = math.max(1, (p24.ZIndex or 1) - 1)
    t1.Corner(Frame, p26 or UITheme.Corner.Panel + 2)
    Frame.Parent = p24

    return Frame
end

function t1.Tween(p27, p28, p29, p30, p31) -- line: 175
    -- upvalues: TweenService (copy)
    local tween = TweenService:Create(p27, TweenInfo.new(p29 or 0.25, p30 or Enum.EasingStyle.Quad, p31 or Enum.EasingDirection.Out), p28)

    tween:Play()

    return tween
end

function t1.AddJuice(p32, p33) -- line: 182
    -- upvalues: Sounds (copy), t1 (copy)
    local v6 = p33

    p33 = p33 or {}
    v6 = p33

    local UIScale = p32:FindFirstChildOfClass("UIScale")

    if not UIScale then
        UIScale = Instance.new("UIScale")
        UIScale.Parent = p32
    end

    local v8 = p33.HoverScale or 1.06
    local v9 = p33.PressScale or 0.94
    local v10 = false
    local v11 = false

    local function refresh() -- line: 192
        -- upvalues: UIScale (ref), v8 (copy), v9 (copy), v10 (ref), v11 (ref), t1 (copy)
        local v12 = if v11 then v9 elseif v10 then v8 else 1

        t1.Tween(UIScale, {
            Scale = v12
        }, 0.12, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
    end

    p32.MouseEnter:Connect(function() -- line: 197
        -- upvalues: v6 (ref), UIScale (ref), v8 (copy), v9 (copy), v10 (ref), v11 (ref), Sounds (copy), t1 (copy)
        v10 = true

        local v13 = if v11 then v9 elseif v10 then v8 else 1

        t1.Tween(UIScale, {
            Scale = v13
        }, 0.12, Enum.EasingStyle.Back, Enum.EasingDirection.Out)

        if v6.HoverSound ~= false then
            Sounds.Play("ButtonHover")
        end
    end)
    p32.MouseLeave:Connect(function() -- line: 202
        -- upvalues: UIScale (ref), v8 (copy), v9 (copy), v10 (ref), v11 (ref), t1 (copy)
        v10 = false
        v11 = false

        local v14 = if v11 then v9 elseif v10 then v8 else 1

        t1.Tween(UIScale, {
            Scale = v14
        }, 0.12, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
    end)
    p32.MouseButton1Down:Connect(function() -- line: 207
        -- upvalues: UIScale (ref), v8 (copy), v9 (copy), v10 (ref), v11 (ref), t1 (copy)
        v11 = true

        local v15 = if v11 then v9 elseif v10 then v8 else 1

        t1.Tween(UIScale, {
            Scale = v15
        }, 0.12, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
    end)
    p32.MouseButton1Up:Connect(function() -- line: 211
        -- upvalues: UIScale (ref), v8 (copy), v9 (copy), v10 (ref), v11 (ref), t1 (copy)
        v11 = false

        local v16 = if v11 then v9 elseif v10 then v8 else 1

        t1.Tween(UIScale, {
            Scale = v16
        }, 0.12, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
    end)

    if v6.ClickSound ~= false then
        p32.Activated:Connect(function() -- line: 216
            -- upvalues: Sounds (copy)
            Sounds.Play("ButtonClick")
        end)
    end

    return UIScale
end

function t1.PopIn(p34, p35, p36) -- line: 224
    -- upvalues: t1 (copy)
    local UIScale = p34:FindFirstChildOfClass("UIScale")

    if not UIScale then
        UIScale = Instance.new("UIScale")
        UIScale.Parent = p34
    end

    UIScale.Scale = p36 or 0.6
    p34.Visible = true

    return t1.Tween(UIScale, {
        Scale = 1
    }, p35 or 0.35, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
end

function t1.PopOut(p37, p38, p39) -- line: 235
    -- upvalues: t1 (copy)
    local UIScale = p37:FindFirstChildOfClass("UIScale")

    if not UIScale then
        UIScale = Instance.new("UIScale")
        UIScale.Parent = p37
    end

    local v17 = t1.Tween(UIScale, {
        Scale = p39 or 0.6
    }, p38 or 0.2, Enum.EasingStyle.Back, Enum.EasingDirection.In)

    v17.Completed:Once(function() -- line: 242
        -- upvalues: p37 (copy), UIScale (ref)
        p37.Visible = false
        UIScale.Scale = 1
    end)

    return v17
end

function t1.Punch(p40, p41, p42) -- line: 250
    -- upvalues: t1 (copy)
    local UIScale = p40:FindFirstChildOfClass("UIScale")

    if not UIScale then
        UIScale = Instance.new("UIScale")
        UIScale.Parent = p40
    end

    UIScale.Scale = 1 + (p41 or 0.25)

    return t1.Tween(UIScale, {
        Scale = 1
    }, p42 or 0.35, Enum.EasingStyle.Elastic, Enum.EasingDirection.Out)
end

function t1.Popup(p43, p44, p45) -- line: 261
    -- upvalues: UITheme (copy), t1 (copy), Colors (copy)
    p45 = p45 or {}

    local Frame = Instance.new("Frame")

    Frame.AnchorPoint = Vector2.new(0.5, 0.5)
    Frame.Position = p45.Position or UDim2.fromScale(0.5, 0.5)
    Frame.Size = p45.Size or UDim2.fromScale(0.3, 0.08)
    Frame.BackgroundTransparency = 1
    Frame.ZIndex = p45.ZIndex or 50
    Frame.Parent = p43

    local v19 = t1.Text({
        Parent = Frame,
        Text = p44,
        Color = p45.Color or Colors.Text,
        ZIndex = Frame.ZIndex,
        Stroke = p45.Stroke or UITheme.Stroke.TextBig,
        Rich = p45.Rich
    })

    if p45.Gradient then
        t1.Gradient(v19, p45.Gradient[1], p45.Gradient[2], 90)
    end

    if p45.Rotation then
        Frame.Rotation = p45.Rotation
    end

    t1.PopIn(Frame, 0.3, 0.3)

    local v20 = p45.Rise or 0.12
    local v21 = p45.Duration or 1.1
    local v22 = Frame.Position + UDim2.fromScale(0, -v20)

    task.delay(0.15, function() -- line: 282
        -- upvalues: Frame (copy), v21 (copy), v22 (copy), t1 (copy)
        t1.Tween(Frame, {
            Position = v22
        }, v21, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    end)
    task.delay(v21 * 0.55, function() -- line: 285
        -- upvalues: v19 (copy), v21 (copy), t1 (copy)
        t1.Tween(v19, {
            TextTransparency = 1
        }, v21 * 0.45)

        local TextStroke = v19:FindFirstChild("TextStroke")

        if TextStroke then
            t1.Tween(TextStroke, {
                Transparency = 1
            }, v21 * 0.45)
        end
    end)
    task.delay(v21 + 0.25, function() -- line: 290
        -- upvalues: Frame (copy)
        Frame:Destroy()
    end)

    return Frame
end

local t3 = {}

function t1.CountTo(p46, p47, p48, p49) -- line: 296
    -- upvalues: TweenService (copy), RunService (copy), t3 (copy)
    local v23 = t3[p46]
    local Current

    if v23 then
        Current = v23.Current or p47
        v23.Cancelled = true
    else
        Current = p47
    end

    local t4 = {
        Cancelled = false,
        Current = Current
    }

    t3[p46] = t4

    if math.abs(p47 - Current) < 1E-09 or not p48 or p48 <= 0 then
        t4.Current = p47
        p46.Text = p49(p47)

        return
    end

    local elapsed = os.clock()
    local spawn = task.spawn
    local Current2 = Current

    spawn(function() -- line: 308
        -- upvalues: p46 (copy), p47 (copy), p48 (copy), p49 (copy), t4 (copy), elapsed (copy), Current2 (copy), TweenService (copy), RunService (copy)
        while not t4.Cancelled do
            local v26 = math.clamp((os.clock() - elapsed) / p48, 0, 1)
            local Value = TweenService:GetValue(v26, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)

            t4.Current = Current2 + (p47 - Current2) * Value
            p46.Text = p49(t4.Current)

            if v26 >= 1 then
                break
            end

            RunService.RenderStepped:Wait()
        end

        if not t4.Cancelled then
            t4.Current = p47
            p46.Text = p49(p47)
        end
    end)
end

function t1.Button(p50) -- line: 329
    -- upvalues: UITheme (copy), t1 (copy), Colors (copy)
    local v27 = p50.Colors or {
        Colors.GreenA,
        Colors.GreenB
    }
    local TextButton = Instance.new("TextButton")

    TextButton.Name = p50.Name or "Button"
    TextButton.Size = p50.Size or UDim2.fromScale(0.3, 0.1)
    TextButton.Position = p50.Position or UDim2.new()
    TextButton.AnchorPoint = p50.AnchorPoint or Vector2.new()
    TextButton.BackgroundColor3 = v27[1]
    TextButton.BorderSizePixel = 0
    TextButton.Text = ""
    TextButton.AutoButtonColor = false
    TextButton.ZIndex = p50.ZIndex or 5
    t1.Corner(TextButton, p50.Corner or UITheme.Corner.Button)
    t1.Stroke(TextButton, UITheme.Stroke.Button, Color3.new(0, 0, 0))
    t1.Gradient(TextButton, v27[1], v27[2], 90)

    local v28 = t1.Text({
        Name = "Label",
        Parent = TextButton,
        Text = p50.Text or "",
        ZIndex = TextButton.ZIndex + 1,
        Size = UDim2.fromScale(0.9, 0.8),
        Position = UDim2.fromScale(0.5, 0.5),
        AnchorPoint = Vector2.new(0.5, 0.5),
        Stroke = p50.TextStroke or UITheme.Stroke.Text,
        Rich = p50.Rich
    })

    if p50.Ratio then
        local UIAspectRatioConstraint = Instance.new("UIAspectRatioConstraint")

        UIAspectRatioConstraint.AspectRatio = p50.Ratio
        UIAspectRatioConstraint.Parent = TextButton
    end

    t1.AddJuice(TextButton, p50.Juice)

    if p50.OnClick then
        TextButton.Activated:Connect(function() -- line: 356
            -- upvalues: p50 (copy), TextButton (copy)
            p50.OnClick(TextButton)
        end)
    end

    TextButton.Parent = p50.Parent

    return TextButton, v28
end

function t1.SetButtonColors(p51, p52) -- line: 365
    local UIGradient = p51:FindFirstChildOfClass("UIGradient")

    if UIGradient then
        UIGradient.Color = ColorSequence.new(p52[1], p52[2])
    end

    p51.BackgroundColor3 = p52[1]
end

function t1.Panel(p53) -- line: 373
    -- upvalues: UITheme (copy), UIScaler (copy), t1 (copy), Colors (copy)
    local Frame = Instance.new("Frame")

    Frame.Name = p53.Name or "Panel"
    Frame.Size = p53.Size or UDim2.fromScale(0.6, 0.7)
    Frame.Position = p53.Position or UDim2.fromScale(0.5, 0.5)
    Frame.AnchorPoint = p53.AnchorPoint or Vector2.new(0.5, 0.5)
    Frame.BackgroundTransparency = 1
    Frame.ZIndex = p53.ZIndex or 2

    if p53.Ratio then
        local UIAspectRatioConstraint = Instance.new("UIAspectRatioConstraint")

        UIAspectRatioConstraint.AspectRatio = p53.Ratio
        UIAspectRatioConstraint.Parent = Frame
    end

    t1.Shadow(Frame, 6, UITheme.Corner.Panel + 2)

    local v29 = t1.Frame({
        Name = "Body",
        Clip = false,
        Parent = Frame,
        ZIndex = Frame.ZIndex + 1,
        Color = Colors.Panel,
        Corner = UITheme.Corner.Panel,
        Stroke = UITheme.Stroke.Panel,
        StrokeColor = Colors.PanelStroke,
        Gradient = {
            Colors.PanelGradientA,
            Colors.PanelGradientB,
            90
        }
    })
    local v30 = p53.HeaderColors or {
        Colors.HeaderA,
        Colors.HeaderB
    }
    local v31 = t1.Frame({
        Name = "Header",
        Parent = v29,
        Size = UDim2.fromScale(1, p53.HeaderHeight or 0.135),
        ZIndex = v29.ZIndex + 2,
        Color = v30[1],
        Corner = UITheme.Corner.Panel,
        Gradient = {
            v30[1],
            v30[2],
            0
        }
    })

    t1.Frame({
        Name = "BottomPatch",
        Parent = v31,
        Size = UDim2.fromScale(1, 0.45),
        Position = UDim2.fromScale(0, 1),
        AnchorPoint = Vector2.new(0, 1),
        ZIndex = v31.ZIndex,
        Color = v30[1],
        Gradient = {
            v30[1],
            v30[2],
            0
        }
    })
    t1.Stripes(v31, 20, 0.88, UITheme.Corner.Panel)
    t1.Frame({
        Name = "BottomLine",
        Parent = v31,
        Size = UDim2.new(1, 0, 0, (math.max(2, (math.round(4 * UIScaler.Factor()))))),
        Position = UDim2.fromScale(0, 1),
        AnchorPoint = Vector2.new(0, 1),
        ZIndex = v31.ZIndex + 2,
        Color = Colors.PanelStroke
    })

    local v34 = t1.Text({
        Name = "Title",
        Parent = v31,
        Text = p53.Title or "",
        Size = UDim2.fromScale(0.7, 0.66),
        Position = UDim2.fromScale(0.025, 0.5),
        AnchorPoint = Vector2.new(0, 0.5),
        XAlign = Enum.TextXAlignment.Left,
        ZIndex = v31.ZIndex + 3,
        Stroke = UITheme.Stroke.TextBig
    })
    local v35 = if p53.OnClose then t1.Button({
        Name = "CloseButton",
        Text = "X",
        Ratio = 1,
        Parent = v31,
        Size = UDim2.fromScale(0.09, 0.72),
        Position = UDim2.fromScale(0.985, 0.5),
        AnchorPoint = Vector2.new(1, 0.5),
        Colors = {
            Colors.RedA,
            Colors.RedB
        },
        ZIndex = v31.ZIndex + 3,
        OnClick = p53.OnClose
    }) else nil
    local v36 = t1.Frame({
        Name = "Content",
        Transparency = 1,
        Parent = v29,
        Size = UDim2.fromScale(1, 1 - (p53.HeaderHeight or 0.135)),
        Position = UDim2.fromScale(0, p53.HeaderHeight or 0.135),
        ZIndex = v29.ZIndex + 1
    })

    Frame.Parent = p53.Parent

    if p53.Fit ~= false then
        UIScaler.FitWindow(Frame, {
            Reposition = p53.Reposition,
            PhoneRatio = p53.PhoneRatio
        })
    end

    return {
        Root = Frame,
        Panel = v29,
        Header = v31,
        Title = v34,
        Close = v35,
        Content = v36
    }
end

function t1.Card(p54) -- line: 407
    -- upvalues: UITheme (copy), t1 (copy), Colors (copy)
    local Frame = Instance.new("Frame")

    Frame.Name = p54.Name or "Card"
    Frame.Size = p54.Size or UDim2.fromScale(0.3, 1)
    Frame.Position = p54.Position or UDim2.new()
    Frame.AnchorPoint = p54.AnchorPoint or Vector2.new()
    Frame.BackgroundColor3 = Color3.new(1, 1, 1)
    Frame.BorderSizePixel = 0
    Frame.ZIndex = p54.ZIndex or 5
    t1.Corner(Frame, UITheme.Corner.Card)
    t1.Stroke(Frame, UITheme.Stroke.Card, Color3.new(0, 0, 0))

    if p54.Rarity then
        t1.RarityGradient(Frame, p54.Rarity, 90)
    else
        t1.Gradient(Frame, Colors.CardA, Colors.CardB, 90)
    end

    t1.Stripes(Frame, 0, 0.94, UITheme.Corner.Card)

    if p54.Ratio then
        local UIAspectRatioConstraint = Instance.new("UIAspectRatioConstraint")

        UIAspectRatioConstraint.AspectRatio = p54.Ratio
        UIAspectRatioConstraint.Parent = Frame
    end

    Frame.Parent = p54.Parent

    return Frame
end

local t7 = {}

local function fitCamera(p55, p56, p57, p58, p59) -- line: 441
    local v37 = p56[1]
    local v40 = p56[2].Magnitude / 2 / math.tan(math.rad(p55.CurrentCamera.FieldOfView) / 2) * (p59 or 1.05)
    local v43 = (CFrame.Angles(0, p57, 0) * CFrame.Angles(p58, 0, 0)):VectorToWorldSpace((Vector3.new(0, 0, -v40)))

    p55.CurrentCamera.CFrame = CFrame.lookAt(v37.Position + v43, v37.Position)
end

function t1.Viewport(p60) -- line: 453
    -- upvalues: ReplicatedStorage (copy), t7 (copy), fitCamera (copy)
    local ViewportFrame = Instance.new("ViewportFrame")

    ViewportFrame.Name = p60.Name or "Viewport"
    ViewportFrame.Size = p60.Size or UDim2.fromScale(1, 1)
    ViewportFrame.Position = p60.Position or UDim2.new()
    ViewportFrame.AnchorPoint = p60.AnchorPoint or Vector2.new()
    ViewportFrame.BackgroundTransparency = 1
    ViewportFrame.BorderSizePixel = 0
    ViewportFrame.ZIndex = p60.ZIndex or 6
    ViewportFrame.Ambient = Color3.fromRGB(200, 200, 200)
    ViewportFrame.LightColor = Color3.fromRGB(255, 255, 255)
    ViewportFrame.LightDirection = Vector3.new(-1, -1.5, -1)

    local Camera = Instance.new("Camera")

    Camera.FieldOfView = 40
    Camera.Parent = ViewportFrame
    ViewportFrame.CurrentCamera = Camera

    local WorldModel = Instance.new("WorldModel")

    WorldModel.Parent = ViewportFrame
    ViewportFrame.Parent = p60.Parent

    local t8 = {
        Model = nil,
        Frame = ViewportFrame,
        Camera = Camera,
        World = WorldModel,
        Yaw = p60.Yaw or -0.5235987755982988,
        Pitch = p60.Pitch or -0.2617993877991494,
        Padding = p60.Padding,
        Rotate = p60.Rotate
    }

    function t8.SetModel(p61, p62, p63) -- line: 475
        -- upvalues: ViewportFrame (copy), WorldModel (copy), ReplicatedStorage (copy), fitCamera (copy)
        if p61.Model then
            p61.Model:Destroy()
        end

        p61.Model = p62

        if not p62 then
            return
        end

        if p63 then
            require(ReplicatedStorage.Shared.AnimalUtil).MakeSilhouette(p62)
            ViewportFrame.Ambient = Color3.new(0, 0, 0)
            ViewportFrame.LightColor = Color3.new(0, 0, 0)
        else
            ViewportFrame.Ambient = Color3.fromRGB(200, 200, 200)
            ViewportFrame.LightColor = Color3.fromRGB(255, 255, 255)
        end

        p62:PivotTo(CFrame.new())
        p62.Parent = WorldModel
        p61.Box = { require(ReplicatedStorage.Shared.AnimalUtil).GetPosedBoundingBox(p62) }
        fitCamera(ViewportFrame, p61.Box, p61.Yaw, p61.Pitch, p61.Padding)
    end

    function t8.Destroy(_) -- line: 496
        -- upvalues: ViewportFrame (copy), t8 (copy), t7 (copy)
        t7[t8] = nil
        ViewportFrame:Destroy()
    end

    if p60.Model then
        t8:SetModel(p60.Model, p60.Silhouette)
    end

    if p60.Rotate then
        t7[t8] = true
    end

    ViewportFrame.Destroying:Connect(function() -- line: 507
        -- upvalues: t8 (copy), t7 (copy)
        t7[t8] = nil
    end)

    return t8
end

RunService.RenderStepped:Connect(function(p65) -- line: 512
    -- upvalues: t7 (copy), fitCamera (copy)
    for v44 in pairs(t7) do
        if v44.Model and v44.Box and v44.Frame.Visible then
            v44.Yaw += p65 * 0.8
            fitCamera(v44.Frame, v44.Box, v44.Yaw, v44.Pitch, v44.Padding)
        end
    end
end)

function t1.AnimateViewportModel(p66) -- line: 523
    -- upvalues: ReplicatedStorage (copy)
    local AnimationLibrary = require(ReplicatedStorage.Shared.AnimationLibrary)

    task.spawn(function() -- line: 525
        -- upvalues: p66 (copy), AnimationLibrary (copy)
        local function v45() -- line: 526
            -- upvalues: p66 (copy), AnimationLibrary (copy)
            AnimationLibrary.EnsureAnimalClips(p66:GetAttribute("AnimalName") or p66.Name)

            if p66.Parent then
                AnimationLibrary.PlayAnimal(p66, "Idle")
            end
        end

        pcall(v45)
    end)
end

return t1
