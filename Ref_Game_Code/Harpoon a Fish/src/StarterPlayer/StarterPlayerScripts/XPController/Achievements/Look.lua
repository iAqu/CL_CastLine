-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local t1 = {}
local Modules = game:GetService("ReplicatedStorage"):WaitForChild("Modules")
local _ = {
    top = 0.645,
    height = 0.33,
    width = 0.25,
    words = 0.3,
    gap = 0.04
}

local function rewardIcons(p1, p2) -- line: 28
    -- upvalues: Modules (copy)
    if p1:FindFirstChild("Rewards") then
        return
    end

    local Sub = p1:FindFirstChild("Sub")
    local Button = p1:FindFirstChild("Button")
    local v1 = require(Modules:WaitForChild("FishDisplay"))[p2.fish]
    local Frame = Instance.new("Frame")

    Frame.Name = "Rewards"
    Frame.BackgroundTransparency = 1
    Frame.AnchorPoint = Vector2.new(0.5, 0)
    Frame.Position = UDim2.fromScale(Button.Position.X.Scale, 0.645)
    Frame.Size = UDim2.fromScale(0.25, 0.33)
    Frame.ZIndex = Sub.ZIndex

    local UIListLayout = Instance.new("UIListLayout")

    UIListLayout.FillDirection = Enum.FillDirection.Vertical
    UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    UIListLayout.Parent = Frame

    local clone = Sub:Clone()

    clone.Name = "Word"
    clone.Text = "REWARDS:"
    clone.LayoutOrder = 1
    clone.AnchorPoint = Vector2.new(0, 0)
    clone.Position = UDim2.new()
    clone.Size = UDim2.fromScale(0, 0.3)
    clone.AutomaticSize = Enum.AutomaticSize.X
    clone.TextScaled = false
    clone.TextWrapped = false
    clone.TextXAlignment = Enum.TextXAlignment.Center
    clone.Parent = Frame

    local Frame2 = Instance.new("Frame")

    Frame2.Name = "Icons"
    Frame2.LayoutOrder = 2
    Frame2.BackgroundTransparency = 1
    Frame2.Size = UDim2.fromScale(1, 0.7)
    Frame2.ZIndex = Sub.ZIndex

    local UIListLayout2 = Instance.new("UIListLayout")

    UIListLayout2.FillDirection = Enum.FillDirection.Horizontal
    UIListLayout2.HorizontalAlignment = Enum.HorizontalAlignment.Center
    UIListLayout2.VerticalAlignment = Enum.VerticalAlignment.Center
    UIListLayout2.Padding = UDim.new(0.04, 0)
    UIListLayout2.SortOrder = Enum.SortOrder.LayoutOrder
    UIListLayout2.Parent = Frame2

    local _ipairs = ipairs
    local t2 = {
        v1 and v1.icon or ""
    }

    for v2, v3 in _ipairs(t2) do
        local ImageLabel = Instance.new("ImageLabel")

        ImageLabel.Name = "Fish"
        ImageLabel.LayoutOrder = v2
        ImageLabel.BackgroundTransparency = 1
        ImageLabel.Image = v3
        ImageLabel.ScaleType = Enum.ScaleType.Fit
        ImageLabel.Size = UDim2.fromScale(1, 1)
        ImageLabel.SizeConstraint = Enum.SizeConstraint.RelativeYY
        ImageLabel.ZIndex = Sub.ZIndex
        ImageLabel.Parent = Frame2
    end

    Frame2.Parent = Frame
    Frame.Parent = p1
    Sub.Text = ""
end

local v4 = Color3.new(1, 1, 1)
local v5 = Color3.new(0, 0, 0)

t1.INK = Color3.fromRGB(8, 12, 32)
t1.RAINBOW = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 70, 70)),
    ColorSequenceKeypoint.new(0.2, Color3.fromRGB(255, 170, 40)),
    ColorSequenceKeypoint.new(0.4, Color3.fromRGB(255, 235, 60)),
    ColorSequenceKeypoint.new(0.6, Color3.fromRGB(70, 220, 110)),
    ColorSequenceKeypoint.new(0.8, Color3.fromRGB(60, 150, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(175, 90, 255))
})

function t1.Dress(p3, p4, p5) -- line: 96
    -- upvalues: t1 (copy), rewardIcons (copy), v4 (copy), v5 (copy)
    local Title = p3:FindFirstChild("Title")
    local Sub = p3:FindFirstChild("Sub")
    local Fill = p3:FindFirstChild("Bar"):FindFirstChild("Fill")
    local UIGradient = Title:FindFirstChildOfClass("UIGradient")
    local UIStroke = Title:FindFirstChildOfClass("UIStroke")
    local v6, v7

    if Sub then
        v6 = Sub:FindFirstChildOfClass("UIGradient")
        v7 = Sub:FindFirstChildOfClass("UIStroke")
    else
        v7 = Sub
        v6 = Sub
    end

    if p5 then
        rewardIcons(p3, p4)
        UIGradient.Color = t1.RAINBOW
        UIGradient.Rotation = 0
        UIStroke.Color = t1.INK
        v6.Color = ColorSequence.new(v4)
        v7.Color = t1.INK

        local Word = p3.Rewards:FindFirstChild("Word")

        if Word then
            Word:FindFirstChildOfClass("UIGradient").Color = ColorSequence.new(v4)
            Word:FindFirstChildOfClass("UIStroke").Color = t1.INK
        end

        Fill.ImageColor3 = v4

        local UIGradient2 = Fill:FindFirstChildOfClass("UIGradient")

        if not UIGradient2 then
            UIGradient2 = Instance.new("UIGradient")
            UIGradient2.Parent = Fill
        end

        UIGradient2.Color = t1.RAINBOW
        UIGradient2.Rotation = 0

        return { UIGradient, UIGradient2 }
    end

    local color = p4.color
    local v8 = color:Lerp(v5, 0.7)
    local v9 = 0.299 * color.R + 0.587 * color.G + 0.114 * color.B

    UIGradient.Color = ColorSequence.new(color:Lerp(v4, 0.25), color)
    UIStroke.Color = v8

    local v10 = v9 < 0.2 and {
        ColorSequence.new(v4, Color3.fromRGB(205, 205, 215)),
        color
    } or {
        ColorSequence.new(color:Lerp(v4, 0.15), color:Lerp(v5, 0.1)),
        v8
    }

    if Sub then
        local v11 = v10[1]
        local v12 = v10[2]

        v6.Color = v11
        v7.Color = v12
    end

    local Bonus = p3.Bar.NextStar.Bonus

    Bonus:FindFirstChildOfClass("UIGradient").Color = v10[1]
    Bonus:FindFirstChildOfClass("UIStroke").Color = v10[2]
    color = v9 < 0.2 and color:Lerp(v4, 0.25) or color
    Fill.ImageColor3 = color

    return nil
end

return t1
