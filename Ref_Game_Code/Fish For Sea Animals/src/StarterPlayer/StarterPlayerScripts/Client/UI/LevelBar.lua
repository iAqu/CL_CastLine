-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Config = require(ReplicatedStorage.Shared.Config)
local Format = require(ReplicatedStorage.Shared.Format)
local UIUtil = require(script.Parent.UIUtil)
local LevelUpFx = require(script.Parent.LevelUpFx)
local LocalPlayer = Players.LocalPlayer
local t1 = {}
local v1 = Color3.fromRGB(20, 20, 30)
local v2 = Color3.fromRGB(45, 80, 50)
local v3 = Color3.fromRGB(110, 175, 255)
local v4 = Color3.fromRGB(45, 110, 235)
local Frame, Frame2, Frame3, Frame4, TextLabel, TextLabel2, Level
local n1 = 0

local function corner(p1, p2) -- line: 33
    local UICorner = Instance.new("UICorner")

    UICorner.CornerRadius = UDim.new(0, p2)
    UICorner.Parent = p1
end

local function stroke(p3, p4, p5) -- line: 39
    -- upvalues: v1 (copy)
    local UIStroke = Instance.new("UIStroke")

    UIStroke.Thickness = p4
    UIStroke.Color = v1

    if p5 then
        UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    end

    UIStroke.Parent = p3
end

local function label(p6, p7) -- line: 49
    -- upvalues: Config (copy), v1 (copy)
    local TextLabel = Instance.new("TextLabel")

    TextLabel.BackgroundTransparency = 1
    TextLabel.FontFace = Config.Font
    TextLabel.TextScaled = true
    TextLabel.TextColor3 = Color3.new(1, 1, 1)
    TextLabel.TextXAlignment = p7
    TextLabel.ZIndex = 4

    local UIStroke = Instance.new("UIStroke")

    UIStroke.Thickness = 3
    UIStroke.Color = v1
    UIStroke.Parent = TextLabel
    TextLabel.Parent = p6

    return TextLabel
end

local function share(p8, p9) -- line: 62
    return math.clamp(p8 / p9, 0, 1) * 0.78 + 0.22
end

local function refresh() -- line: 66
    -- upvalues: Format (copy), UIUtil (copy), LevelUpFx (copy), LocalPlayer (copy), Frame2 (ref), Frame3 (ref), Frame4 (ref), TextLabel (ref), TextLabel2 (ref), Level (ref), n1 (ref)
    local Level2 = LocalPlayer:GetAttribute("Level")
    local LevelXP = LocalPlayer:GetAttribute("LevelXP")
    local LevelNeed = LocalPlayer:GetAttribute("LevelNeed")

    if Level2 == nil or LevelXP == nil or LevelNeed == nil then
        return
    end

    local v6 = LocalPlayer:GetAttribute("Strength") or 0
    local TextLabel3 = TextLabel

    TextLabel3.Text = ("Level %*"):format((LevelUpFx.levelText(Level2)))

    local TextLabel4 = TextLabel2

    TextLabel4.Text = ("%*/%*"):format(Format.short((math.floor(LevelXP))), (Format.short(LevelNeed)))

    local v8 = UDim2.fromScale(math.clamp(LevelXP / LevelNeed, 0, 1) * 0.78 + 0.22, 1)

    if Level and Level < Level2 then
        UIUtil.tween(Frame3, 0.07, {
            Size = UDim2.fromScale(1, 1)
        })
        task.delay(0.07, function() -- line: 79
            -- upvalues: v8 (copy), UIUtil (copy), Frame2 (ref), Frame3 (ref), Frame4 (ref)
            UIUtil.pop(Frame2, 1.18)
            Frame4.BackgroundTransparency = 0
            UIUtil.tween(Frame4, 0.4, {
                BackgroundTransparency = 1
            }, Enum.EasingStyle.Quad)
            task.delay(0.12, function() -- line: 83
                -- upvalues: v8 (copy), UIUtil (copy), Frame3 (ref)
                Frame3.Size = UDim2.fromScale(0.22, 1)
                UIUtil.tween(Frame3, 0.3, {
                    Size = v8
                }, Enum.EasingStyle.Back)
            end)
        end)
        LevelUpFx.play(Level2, Level2 - Level, Frame2, v6 - n1)
    else
        UIUtil.tween(Frame3, 0.25, {
            Size = v8
        })
    end

    if Level2 ~= Level then
        n1 = v6
    end

    Level = Level2
end

function t1.setVisible(p10) -- line: 98
    -- upvalues: UIUtil (copy), Frame (ref), Frame2 (ref)
    if p10 and not Frame.Visible then
        UIUtil.pop(Frame2, 0.6)
    end

    Frame.Visible = p10
end

function t1.init() -- line: 105
    -- upvalues: Config (copy), UIUtil (copy), LocalPlayer (copy), v1 (copy), v2 (copy), v3 (copy), v4 (copy), Frame (ref), Frame2 (ref), Frame3 (ref), Frame4 (ref), TextLabel (ref), TextLabel2 (ref), refresh (copy)
    local HUD = UIUtil.gui("HUD")

    Frame = Instance.new("Frame")
    Frame.Name = "LevelBar"
    Frame.AnchorPoint = Vector2.new(0.5, 1)
    Frame.Position = UDim2.new(0.5, 0, 1, -16)
    Frame.Size = UDim2.fromOffset(560, 58)
    Frame.BackgroundTransparency = 1
    Frame.Visible = false

    local UIScale = Instance.new("UIScale")

    UIScale.Name = "Scale"
    UIScale.Parent = Frame
    Frame2 = Instance.new("Frame")
    Frame2.Name = "Bar"
    Frame2.AnchorPoint = Vector2.new(0.5, 0.5)
    Frame2.Position = UDim2.fromScale(0.5, 0.5)
    Frame2.Size = UDim2.fromScale(1, 1)
    Frame2.BackgroundColor3 = v2

    local Frame11 = Frame2
    local UICorner = Instance.new("UICorner")

    UICorner.CornerRadius = UDim.new(0, 16)
    UICorner.Parent = Frame11

    local Frame12 = Frame2
    local UIStroke = Instance.new("UIStroke")

    UIStroke.Thickness = 4
    UIStroke.Color = v1
    UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    UIStroke.Parent = Frame12
    Frame2.Parent = Frame
    Frame3 = Instance.new("Frame")
    Frame3.Name = "Fill"
    Frame3.Position = UDim2.fromOffset(0, 0)
    Frame3.Size = UDim2.fromScale(0.22, 1)
    Frame3.BackgroundColor3 = Color3.new(1, 1, 1)
    Frame3.ZIndex = 2

    local Frame16 = Frame3
    local UICorner2 = Instance.new("UICorner")

    UICorner2.CornerRadius = UDim.new(0, 16)
    UICorner2.Parent = Frame16

    local Frame17 = Frame3
    local UIStroke2 = Instance.new("UIStroke")

    UIStroke2.Thickness = 3
    UIStroke2.Color = v1
    UIStroke2.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    UIStroke2.Parent = Frame17

    local UIGradient = Instance.new("UIGradient")

    UIGradient.Color = ColorSequence.new(v3, v4)
    UIGradient.Rotation = 90
    UIGradient.Parent = Frame3
    Frame3.Parent = Frame2
    Frame4 = Instance.new("Frame")
    Frame4.Name = "Glow"
    Frame4.Size = UDim2.fromScale(1, 1)
    Frame4.BackgroundColor3 = Color3.fromRGB(255, 250, 210)
    Frame4.BackgroundTransparency = 1
    Frame4.ZIndex = 3

    local Frame20 = Frame4
    local UICorner3 = Instance.new("UICorner")

    UICorner3.CornerRadius = UDim.new(0, 16)
    UICorner3.Parent = Frame20
    Frame4.Parent = Frame2

    local Frame21 = Frame2
    local Left = Enum.TextXAlignment.Left
    local TextLabel3 = Instance.new("TextLabel")

    TextLabel3.BackgroundTransparency = 1
    TextLabel3.FontFace = Config.Font
    TextLabel3.TextScaled = true
    TextLabel3.TextColor3 = Color3.new(1, 1, 1)
    TextLabel3.TextXAlignment = Left
    TextLabel3.ZIndex = 4

    local UIStroke3 = Instance.new("UIStroke")

    UIStroke3.Thickness = 3
    UIStroke3.Color = v1
    UIStroke3.Parent = TextLabel3
    TextLabel3.Parent = Frame21
    TextLabel = TextLabel3
    TextLabel.Position = UDim2.new(0, 16, 0, 9)
    TextLabel.Size = UDim2.new(0.5, -16, 1, -18)

    local Frame22 = Frame2
    local Right = Enum.TextXAlignment.Right
    local TextLabel6 = Instance.new("TextLabel")

    TextLabel6.BackgroundTransparency = 1
    TextLabel6.FontFace = Config.Font
    TextLabel6.TextScaled = true
    TextLabel6.TextColor3 = Color3.new(1, 1, 1)
    TextLabel6.TextXAlignment = Right
    TextLabel6.ZIndex = 4

    local UIStroke4 = Instance.new("UIStroke")

    UIStroke4.Thickness = 3
    UIStroke4.Color = v1
    UIStroke4.Parent = TextLabel6
    TextLabel6.Parent = Frame22
    TextLabel2 = TextLabel6
    TextLabel2.Position = UDim2.new(0.5, 0, 0, 11)
    TextLabel2.Size = UDim2.new(0.5, -16, 1, -22)
    Frame.Parent = HUD

    for _, v9 in { "Level", "LevelXP", "LevelNeed" } do
        LocalPlayer:GetAttributeChangedSignal(v9):Connect(refresh)
    end

    refresh()
end

return t1
