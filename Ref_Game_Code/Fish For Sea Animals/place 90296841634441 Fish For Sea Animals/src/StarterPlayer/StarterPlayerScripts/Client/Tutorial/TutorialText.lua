-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local GuiService = game:GetService("GuiService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Config = require(ReplicatedStorage.Shared.Config)
local UIUtil = require(script.Parent.Parent.UI.UIUtil)
local LocalPlayer = Players.LocalPlayer
local t1 = {}

local function textScale(p1) -- line: 24
    -- upvalues: GuiService (copy), UIUtil (copy)
    local v1 = UIUtil.smallScreenBoost(p1, 1.6)

    if GuiService:IsTenFootInterface() then
        v1 *= 1.3
    end

    return p1 * v1
end

local Frame, TextLabel, v2, TextLabel2

function t1.init() -- line: 37
    -- upvalues: GuiService (copy), RunService (copy), Config (copy), UIUtil (copy), LocalPlayer (copy), Frame (ref), TextLabel (ref), TextLabel2 (ref)
    local ScreenGui = Instance.new("ScreenGui")

    ScreenGui.Name = "TutorialText"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.IgnoreGuiInset = true
    ScreenGui.DisplayOrder = 40

    local Frame2 = Instance.new("Frame")

    Frame2.BackgroundTransparency = 1
    Frame2.AnchorPoint = Vector2.new(0.5, 0.5)
    Frame2.Position = UDim2.fromScale(0.5, 0.24)
    Frame2.Size = UDim2.fromOffset(900, 70)

    local UIScale = Instance.new("UIScale")

    UIScale.Name = "TextScale"
    UIScale.Parent = Frame2
    UIUtil.onScale(function(p2) -- line: 51
        -- upvalues: UIScale (copy), GuiService (copy), UIUtil (copy)
        local v3 = UIUtil.smallScreenBoost(p2, 1.6)

        if GuiService:IsTenFootInterface() then
            v3 *= 1.3
        end

        UIScale.Scale = p2 * v3
    end)
    Frame = Instance.new("Frame")
    Frame.Name = "Band"
    Frame.AnchorPoint = Vector2.new(0.5, 0.5)
    Frame.Position = UDim2.fromScale(0.5, 0.5)
    Frame.Size = UDim2.fromOffset(0, 84)
    Frame.AutomaticSize = Enum.AutomaticSize.X
    Frame.BackgroundColor3 = Color3.new(0, 0, 0)
    Frame.BorderSizePixel = 0
    Frame.Visible = false

    local UIGradient = Instance.new("UIGradient")

    UIGradient.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 1),
        NumberSequenceKeypoint.new(0.28, 0.2),
        NumberSequenceKeypoint.new(0.72, 0.2),
        NumberSequenceKeypoint.new(1, 1)
    })
    UIGradient.Parent = Frame

    local UIPadding = Instance.new("UIPadding")

    UIPadding.PaddingLeft = UDim.new(0, 170)
    UIPadding.PaddingRight = UDim.new(0, 170)
    UIPadding.Parent = Frame
    Frame.Parent = Frame2
    TextLabel = Instance.new("TextLabel")
    TextLabel.Name = "Text"
    TextLabel.BackgroundTransparency = 1
    TextLabel.Size = UDim2.fromScale(0, 1)
    TextLabel.AutomaticSize = Enum.AutomaticSize.X
    TextLabel.FontFace = Config.Font
    TextLabel.TextSize = 50
    TextLabel.TextColor3 = Color3.new(1, 1, 1)

    local UIStroke = Instance.new("UIStroke")

    UIStroke.Thickness = 4
    UIStroke.Color = Color3.fromRGB(20, 20, 30)
    UIStroke.Parent = TextLabel
    TextLabel.Parent = Frame
    Frame2.Parent = ScreenGui

    local Frame8 = Instance.new("Frame")

    Frame8.Name = "Headline"
    Frame8.BackgroundTransparency = 1
    Frame8.AnchorPoint = Vector2.new(0.5, 0.5)
    Frame8.Position = UDim2.fromScale(0.5, 0.3)
    Frame8.Size = UDim2.fromOffset(1200, 130)

    local UIScale2 = Instance.new("UIScale")

    UIScale2.Name = "TextScale"
    UIScale2.Parent = Frame8
    UIUtil.onScale(function(p3) -- line: 102
        -- upvalues: UIScale2 (copy), GuiService (copy), UIUtil (copy)
        local v4 = UIUtil.smallScreenBoost(p3, 1.6)

        if GuiService:IsTenFootInterface() then
            v4 *= 1.3
        end

        UIScale2.Scale = p3 * v4
    end)
    TextLabel2 = Instance.new("TextLabel")
    TextLabel2.Name = "Text"
    TextLabel2.BackgroundTransparency = 1
    TextLabel2.AnchorPoint = Vector2.new(0.5, 0.5)
    TextLabel2.Position = UDim2.fromScale(0.5, 0.5)
    TextLabel2.Size = UDim2.fromScale(1, 1)
    TextLabel2.FontFace = Config.Font
    TextLabel2.TextSize = 96
    TextLabel2.TextColor3 = Color3.fromRGB(255, 225, 90)
    TextLabel2.Visible = false

    local UIStroke2 = Instance.new("UIStroke")

    UIStroke2.Thickness = 7
    UIStroke2.Color = Color3.fromRGB(20, 20, 30)
    UIStroke2.Parent = TextLabel2
    TextLabel2.Parent = Frame8
    Frame8.Parent = ScreenGui
    ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
    RunService.RenderStepped:Connect(function() -- line: 123
        -- upvalues: Frame (ref), TextLabel2 (ref)
        if Frame.Visible then
            Frame.Position = UDim2.new(0.5, 0, 0.5, math.sin(os.clock() * 3) * 4)
        end

        if TextLabel2.Visible then
            TextLabel2.Rotation = math.sin(os.clock() * 2.2) * 2
        end
    end)
end

function t1.set(p4, p5) -- line: 135
    -- upvalues: UIUtil (copy), Frame (ref), TextLabel (ref), v2 (ref)
    if p4 == v2 then
        return
    end

    local v7 = v2 ~= nil

    v2 = p4

    if not p4 then
        Frame.Visible = false

        return
    end

    TextLabel.Text = p4
    Frame.Visible = true

    if not p5 or not v7 then
        UIUtil.pop(Frame, 0.6)
        UIUtil.sound("LuckTick", 0.7, 1.1)
    else
        UIUtil.pop(Frame, 1.12)
    end
end

function t1.announce(p6) -- line: 156
    -- upvalues: UIUtil (copy), TextLabel2 (ref)
    if not p6 then
        TextLabel2.Visible = false

        return
    end

    TextLabel2.Text = p6
    TextLabel2.Visible = true
    UIUtil.pop(TextLabel2, 0.4)
    UIUtil.sound("LuckTick", 0.9, 0.9)
end

return t1
