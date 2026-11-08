-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")

require(ReplicatedStorage.Packages.Trove)

local LocalPlayer = Players.LocalPlayer
local v1 = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Heavy, Enum.FontStyle.Normal)
local v2 = Color3.fromRGB(50, 50, 65)
local v3 = Color3.fromRGB(190, 255, 240)
local v4 = Color3.fromRGB(70, 215, 190)
local t1 = {}

local function fill(p1, p2, p3, p4) -- line: 56
    local Frame = Instance.new("Frame")

    Frame.Name = p1
    Frame.BorderSizePixel = 0
    Frame.BackgroundColor3 = p3
    Frame.BackgroundTransparency = p4
    Frame.Size = UDim2.fromScale(1, 1)
    Frame.Parent = p2

    return Frame
end

local function streaks(p5, p6) -- line: 67
    local t2 = {}

    for i = 1, 10 do
        local Frame = Instance.new("Frame")

        Frame.Name = "Streak"
        Frame.BorderSizePixel = 0
        Frame.AnchorPoint = Vector2.new(0.5, 0.5)
        Frame.BackgroundColor3 = Color3.fromRGB(225, 255, 248)
        Frame.BackgroundTransparency = 1
        Frame.Size = UDim2.fromScale(0.2, 0.0065)

        local UIGradient = Instance.new("UIGradient")

        UIGradient.Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 1),
            NumberSequenceKeypoint.new(0.55, 0.35),
            NumberSequenceKeypoint.new(1, 0.9)
        })
        UIGradient.Parent = Frame
        Frame.Parent = p5
        table.insert(t2, {
            Frame = Frame,
            Angle = (i - 1) / 10 * 3.141592653589793 * 2 + p6:NextNumber(-0.2, 0.2),
            Phase = p6:NextNumber(),
            Speed = p6:NextNumber(1.6, 2.4)
        })
    end

    return t2
end

local function title(p7, p8, p9, p10) -- line: 95
    -- upvalues: v1 (copy)
    local TextLabel = Instance.new("TextLabel")

    TextLabel.Name = p8
    TextLabel.BackgroundTransparency = 1
    TextLabel.Size = UDim2.fromScale(1, 1)
    TextLabel.FontFace = v1
    TextLabel.Text = p9
    TextLabel.TextScaled = true
    TextLabel.TextColor3 = p10
    TextLabel.Parent = p7

    return TextLabel
end

function t1.Build(p11) -- line: 112
    -- upvalues: LocalPlayer (copy), streaks (copy)
    local v5 = p11:Add(Instance.new("ScreenGui"))

    v5.Name = "SewerDrain"
    v5.IgnoreGuiInset = true
    v5.ResetOnSpawn = false
    v5.DisplayOrder = 45
    v5.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    v5.Enabled = true

    local v6 = Random.new()
    local ImageLabel = Instance.new("ImageLabel")

    ImageLabel.Name = "Caustic"
    ImageLabel.BackgroundTransparency = 1
    ImageLabel.Image = "rbxassetid://18177147504"
    ImageLabel.ImageColor3 = Color3.fromRGB(160, 245, 230)
    ImageLabel.ImageTransparency = 1
    ImageLabel.ScaleType = Enum.ScaleType.Tile
    ImageLabel.TileSize = UDim2.fromScale(0.25, 0.25)
    ImageLabel.Size = UDim2.fromScale(1, 2)
    ImageLabel.Position = UDim2.fromScale(0, -1)
    ImageLabel.Parent = v5

    local ImageLabel2 = Instance.new("ImageLabel")

    ImageLabel2.Name = "Vignette"
    ImageLabel2.BackgroundTransparency = 1
    ImageLabel2.Image = "rbxassetid://104574024062008"
    ImageLabel2.ImageColor3 = Color3.fromRGB(2, 16, 20)
    ImageLabel2.ImageTransparency = 1
    ImageLabel2.Size = UDim2.fromScale(1, 1)
    ImageLabel2.Parent = v5

    local Frame = Instance.new("Frame")

    Frame.Name = "Streaks"
    Frame.BackgroundTransparency = 1
    Frame.AnchorPoint = Vector2.new(0.5, 0.5)
    Frame.Position = UDim2.fromScale(0.5, 0.5)
    Frame.Size = UDim2.fromScale(2.2, 2.2)
    Frame.Visible = false

    local UIAspectRatioConstraint = Instance.new("UIAspectRatioConstraint")

    UIAspectRatioConstraint.AspectRatio = 1
    UIAspectRatioConstraint.AspectType = Enum.AspectType.FitWithinMaxSize
    UIAspectRatioConstraint.Parent = Frame
    Frame.Parent = v5

    local Frame2 = Instance.new("Frame")

    Frame2.Name = "Waterline"
    Frame2.BorderSizePixel = 0
    Frame2.BackgroundColor3 = Color3.new(1, 1, 1)
    Frame2.Size = UDim2.fromScale(1, 1.25)
    Frame2.Position = UDim2.fromScale(0, 1)
    Frame2.Visible = false

    local UIGradient = Instance.new("UIGradient")

    UIGradient.Rotation = 90
    UIGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(120, 230, 214)),
        ColorSequenceKeypoint.new(0.12, Color3.fromRGB(14, 96, 92)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(2, 18, 22))
    })
    UIGradient.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0.6),
        NumberSequenceKeypoint.new(0.04, 0.1),
        NumberSequenceKeypoint.new(1, 0)
    })
    UIGradient.Parent = Frame2
    Frame2.Parent = v5

    local ImageLabel3 = Instance.new("ImageLabel")

    ImageLabel3.Name = "Iris"
    ImageLabel3.BackgroundTransparency = 1
    ImageLabel3.Image = "rbxassetid://104574024062008"
    ImageLabel3.ImageColor3 = Color3.new(0, 0, 0)
    ImageLabel3.AnchorPoint = Vector2.new(0.5, 0.5)
    ImageLabel3.Size = UDim2.fromScale(3, 3)
    ImageLabel3.Visible = false

    local UIAspectRatioConstraint2 = Instance.new("UIAspectRatioConstraint")

    UIAspectRatioConstraint2.AspectRatio = 1
    UIAspectRatioConstraint2.AspectType = Enum.AspectType.FitWithinMaxSize
    UIAspectRatioConstraint2.Parent = ImageLabel3

    for _, v7 in {
            {
                Anchor = Vector2.new(0.5, 1),
                Position = UDim2.fromScale(0.5, 0.02),
                Size = UDim2.fromScale(200, 100)
            },
            {
                Anchor = Vector2.new(0.5, 0),
                Position = UDim2.fromScale(0.5, 0.98),
                Size = UDim2.fromScale(200, 100)
            },
            {
                Anchor = Vector2.new(1, 0.5),
                Position = UDim2.fromScale(0.02, 0.5),
                Size = UDim2.fromScale(100, 1)
            },
            {
                Anchor = Vector2.new(0, 0.5),
                Position = UDim2.fromScale(0.98, 0.5),
                Size = UDim2.fromScale(100, 1)
            }
        } do
        local v8 = Color3.new(0, 0, 0)
        local Frame = Instance.new("Frame")

        Frame.Name = "Cover"
        Frame.BorderSizePixel = 0
        Frame.BackgroundColor3 = v8
        Frame.BackgroundTransparency = 0
        Frame.Size = UDim2.fromScale(1, 1)
        Frame.Parent = ImageLabel3
        Frame.AnchorPoint = v7.Anchor
        Frame.Position = v7.Position
        Frame.Size = v7.Size
    end

    ImageLabel3.Parent = v5

    local v9 = Color3.new(0, 0, 0)
    local Frame3 = Instance.new("Frame")

    Frame3.Name = "Black"
    Frame3.BorderSizePixel = 0
    Frame3.BackgroundColor3 = v9
    Frame3.BackgroundTransparency = 0
    Frame3.Size = UDim2.fromScale(1, 1)
    Frame3.Parent = v5
    Frame3.Visible = false
    v5.Parent = LocalPlayer:WaitForChild("PlayerGui")

    return {
        Gui = v5,
        Shell = Frame,
        Streaks = streaks(Frame, v6),
        Caustic = ImageLabel,
        Vignette = ImageLabel2,
        Water = Frame2,
        Hole = ImageLabel3,
        Black = Frame3,
        Random = v6
    }
end

function t1.Streaks(p12, p13, p14, p15) -- line: 230
    local Shell = p12.Shell

    Shell.Visible = p14 > 0.01

    if Shell.Visible then
        Shell.Position = UDim2.fromScale(p13.X, p13.Y)

        for _, v10 in p12.Streaks do
            local v11 = (v10.Phase + p15 * v10.Speed) % 1
            local v12 = v11 * 0.38 + 0.06
            local v14 = Vector2.new(math.cos(v10.Angle), (math.sin(v10.Angle)))
            local Frame = v10.Frame

            Frame.Position = UDim2.fromScale(0.5 + v14.X * v12, 0.5 + v14.Y * v12)
            Frame.Rotation = math.deg(v10.Angle)
            Frame.Size = UDim2.fromScale(v11 * 0.16 + 0.08, 0.0065)
            Frame.BackgroundTransparency = 1 - p14 * (1 - v11 * 0.6) * 0.45
        end
    end
end

function t1.Caustic(p16, p17, p18) -- line: 249
    local Caustic = p16.Caustic

    Caustic.ImageTransparency = 1 - p17 * 0.14
    Caustic.Position = UDim2.fromScale(math.sin(p18 * 0.4) * 0.03, p18 * 0.18 % 1 + -1)
end

function t1.Vignette(p19, p20) -- line: 255
    p19.Vignette.ImageTransparency = 1 - math.clamp(p20, 0, 1)
end

function t1.Waterline(p21, p22) -- line: 259
    local Water = p21.Water

    Water.Visible = p22 > 0.001
    Water.Position = UDim2.fromScale(0, 1 - p22 * 1.25)
end

function t1.Iris(p23, p24, p25) -- line: 265
    local Hole = p23.Hole
    local v16 = p25 <= 0.002

    p23.Black.Visible = v16
    Hole.Visible = not v16 and p25 < 0.999
    Hole.Position = UDim2.fromScale(p24.X, p24.Y)
    Hole.Size = UDim2.fromScale(p25 * 3.2, p25 * 3.2)
end

function t1.Drops(p26, p27, p28) -- line: 274
    -- upvalues: TweenService (copy)
    local Random = p26.Random

    for _ = 1, p28 do
        local ImageLabel = Instance.new("ImageLabel")

        ImageLabel.Name = "Drop"
        ImageLabel.BackgroundTransparency = 1
        ImageLabel.Image = "rbxassetid://7027357365"
        ImageLabel.ImageColor3 = Color3.fromRGB(215, 255, 250)
        ImageLabel.ImageTransparency = 0.86
        ImageLabel.AnchorPoint = Vector2.new(0.5, 0.5)

        local v17 = Random:NextNumber(0.025, 0.045)

        ImageLabel.Size = UDim2.fromScale(v17, v17)

        local UIAspectRatioConstraint = Instance.new("UIAspectRatioConstraint")

        UIAspectRatioConstraint.AspectRatio = 0.72
        UIAspectRatioConstraint.AspectType = Enum.AspectType.FitWithinMaxSize
        UIAspectRatioConstraint.Parent = ImageLabel

        local ImageLabel2 = Instance.new("ImageLabel")

        ImageLabel2.Name = "Shine"
        ImageLabel2.BackgroundTransparency = 1
        ImageLabel2.Image = "rbxassetid://11909833350"
        ImageLabel2.ImageColor3 = Color3.new(1, 1, 1)
        ImageLabel2.ImageTransparency = 0.25
        ImageLabel2.AnchorPoint = Vector2.new(0.5, 0.5)
        ImageLabel2.Position = UDim2.fromScale(0.36, 0.58)
        ImageLabel2.Size = UDim2.fromScale(0.5, 0.5)
        ImageLabel2.Parent = ImageLabel

        local v18 = Random:NextNumber(0.08, 0.92)
        local v19 = Random:NextNumber(0.05, 0.55)

        ImageLabel.Position = UDim2.fromScale(v18, v19)
        ImageLabel.Parent = p26.Gui
        p27:Add(ImageLabel)

        local v20 = Random:NextNumber(0.9, 1.4)
        local tween = TweenService:Create(ImageLabel, TweenInfo.new(v20, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
            ImageTransparency = 1,
            Position = UDim2.fromScale(v18, v19 + Random:NextNumber(0.25, 0.45))
        })
        local tween2 = TweenService:Create(ImageLabel2, TweenInfo.new(v20, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
            ImageTransparency = 1
        })

        tween:Play()
        tween2:Play()
    end
end

function t1.Card(p29, p30, p31, p32) -- line: 324
    -- upvalues: TweenService (copy), v1 (copy), v2 (copy), v3 (copy), v4 (copy)
    local Frame = Instance.new("Frame")

    Frame.Name = "Discovery"
    Frame.BackgroundTransparency = 1
    Frame.AnchorPoint = Vector2.new(0.5, 0.5)
    Frame.Position = UDim2.fromScale(0.5, 0.17)
    Frame.Size = UDim2.fromScale(0.62, 0.1)

    local UIAspectRatioConstraint = Instance.new("UIAspectRatioConstraint")

    UIAspectRatioConstraint.AspectRatio = 8
    UIAspectRatioConstraint.AspectType = Enum.AspectType.FitWithinMaxSize
    UIAspectRatioConstraint.Parent = Frame

    local UIScale = Instance.new("UIScale")

    UIScale.Scale = 0
    UIScale.Parent = Frame

    local TextLabel = Instance.new("TextLabel")

    TextLabel.Name = "Shadow"
    TextLabel.BackgroundTransparency = 1
    TextLabel.Size = UDim2.fromScale(1, 1)
    TextLabel.FontFace = v1
    TextLabel.Text = p31
    TextLabel.TextScaled = true
    TextLabel.TextColor3 = v2
    TextLabel.Parent = Frame
    TextLabel.Position = UDim2.fromScale(0, 0.07)

    local UIStroke = Instance.new("UIStroke")

    UIStroke.Color = v2
    UIStroke.Thickness = 5
    UIStroke.Parent = TextLabel

    local v21 = Color3.new(1, 1, 1)
    local TextLabel2 = Instance.new("TextLabel")

    TextLabel2.Name = "Title"
    TextLabel2.BackgroundTransparency = 1
    TextLabel2.Size = UDim2.fromScale(1, 1)
    TextLabel2.FontFace = v1
    TextLabel2.Text = p31
    TextLabel2.TextScaled = true
    TextLabel2.TextColor3 = v21
    TextLabel2.Parent = Frame

    local UIStroke2 = Instance.new("UIStroke")

    UIStroke2.Color = Color3.new(0, 0, 0)
    UIStroke2.Thickness = 3
    UIStroke2.Parent = TextLabel2

    local UIGradient = Instance.new("UIGradient")

    UIGradient.Rotation = 90
    UIGradient.Color = ColorSequence.new(v3, v4)
    UIGradient.Parent = TextLabel2
    Frame.Parent = p29.Gui
    p30:Add(Frame)
    TweenService:Create(UIScale, TweenInfo.new(0.25, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Scale = 1
    }):Play()
    p30:Add(task.delay(p32 + 0.25, function() -- line: 360
        -- upvalues: TextLabel (copy), UIStroke (copy), TextLabel2 (copy), UIStroke2 (copy), TweenService (copy)
        local v22 = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In)

        TweenService:Create(TextLabel2, v22, {
            TextTransparency = 1
        }):Play()
        TweenService:Create(TextLabel, v22, {
            TextTransparency = 1
        }):Play()
        TweenService:Create(UIStroke2, v22, {
            Transparency = 1
        }):Play()
        TweenService:Create(UIStroke, v22, {
            Transparency = 1
        }):Play()
    end))
end

return table.freeze(t1)
