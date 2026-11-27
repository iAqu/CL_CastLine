-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Config = require(ReplicatedStorage.Shared.Config)
local Products = require(ReplicatedStorage.Shared.Products)
local Animals = require(ReplicatedStorage.Shared.Animals)
local UIUtil = require(script.Parent.Parent.UI.UIUtil)
local Kit = require(script.Parent.Parent.MiniGames.Kit)
local Robux = require(script.Parent.Robux)
local LocalPlayer = Players.LocalPlayer
local t1 = {
    WIDTH = 1180,
    GAP = 18,
    NAVY = Color3.fromRGB(14, 32, 66),
    DEEP = Color3.fromRGB(8, 18, 42),
    TEAL = Color3.fromRGB(0, 196, 210),
    OCEAN = Color3.fromRGB(24, 104, 228),
    GOLD = Color3.fromRGB(255, 196, 46),
    BUY = Color3.fromRGB(70, 205, 85),
    PURPLE = Color3.fromRGB(150, 75, 235),
    CORAL = Color3.fromRGB(255, 104, 112),
    SEAFOAM = Color3.fromRGB(46, 214, 150),
    KELP = Color3.fromRGB(70, 160, 70),
    ABYSS = Color3.fromRGB(110, 70, 220),
    SAND = Color3.fromRGB(240, 200, 120),
    GREY = Color3.fromRGB(120, 128, 145),
    YELLOW = Color3.fromRGB(255, 226, 90),
    MINT = Color3.fromRGB(150, 255, 170),
    ROBUX = "rbxasset://textures/ui/common/robux.png",
    STAR = "rbxassetid://127376933714094",
    BORDER = 3,
    RAINBOW = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 90, 110)),
        ColorSequenceKeypoint.new(0.2, Color3.fromRGB(255, 180, 60)),
        ColorSequenceKeypoint.new(0.4, Color3.fromRGB(255, 240, 90)),
        ColorSequenceKeypoint.new(0.6, Color3.fromRGB(90, 235, 130)),
        ColorSequenceKeypoint.new(0.8, Color3.fromRGB(80, 170, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(190, 100, 255))
    }),
    gradient = function(p1, p2, p3) -- gradient | line: 49
        local UIGradient = Instance.new("UIGradient")

        UIGradient.Color = p2
        UIGradient.Rotation = p3 or 90
        UIGradient.Parent = p1

        return UIGradient
    end
}

function t1.tint(p4) -- line: 58
    -- upvalues: t1 (copy)
    return ColorSequence.new(p4:Lerp(Color3.new(1, 1, 1), 0.12), p4:Lerp(t1.DEEP, 0.38))
end

function t1.card(p5, p6, p7) -- line: 63
    -- upvalues: Kit (copy), t1 (copy)
    local v1 = Kit.frame(p5, p7)

    v1.BackgroundColor3 = Color3.new(1, 1, 1)
    Kit.corner(v1, 18)
    Kit.stroke(v1, 5)
    t1.gradient(v1, t1.tint(p6), 60)
    Kit.studs(v1, 0.55, 44, 18)

    return v1
end

function t1.text(p8, p9, p10) -- line: 73
    -- upvalues: Kit (copy)
    local v2 = Kit.text(p8, p9, p10)

    v2.RichText = true

    return v2
end

function t1.title(p11, p12, p13, p14) -- line: 80
    -- upvalues: Kit (copy), t1 (copy)
    local v3 = Kit.frame(p11, {
        BackgroundTransparency = 1,
        Name = "Title_" .. p12,
        Size = UDim2.fromOffset(t1.WIDTH, 92),
        LayoutOrder = p14
    })
    local v4 = Kit.text(v3, ("≈  %*  ≈"):format(p12), {
        StrokeThickness = 5,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromScale(0.5, 0.55),
        Size = UDim2.new(1, 0, 0, 70)
    })

    t1.gradient(v4, ColorSequence.new(Color3.new(1, 1, 1), p13))

    return v3
end

function t1.row(p15, p16, p17) -- line: 98
    -- upvalues: Kit (copy), t1 (copy)
    return Kit.frame(p15, {
        BackgroundTransparency = 1,
        Name = "Row" .. p17,
        Size = UDim2.fromOffset(t1.WIDTH, p16),
        LayoutOrder = p17
    })
end

function t1.split(p18) -- line: 108
    -- upvalues: t1 (copy)
    return (t1.WIDTH - t1.GAP * (p18 - 1)) / p18
end

function t1.tag(p19, p20, p21, p22) -- line: 114
    -- upvalues: Kit (copy), t1 (copy)
    local v5 = Kit.frame(p19, p22)

    v5.BackgroundTransparency = 1
    v5.Rotation = p22.Rotation or 4
    v5.ZIndex = 5

    local v6 = Kit.text(v5, p20, {
        ZIndex = 6,
        StrokeThickness = 5,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromScale(0.5, 0.5),
        Size = UDim2.fromScale(1.1, 1)
    })
    local _, _, v7 = p21:ToHSV()
    local v8 = if v7 < 0.4 then Color3.new(0.9, 0.93, 1) elseif p21 == t1.CORAL then Color3.fromRGB(255, 62, 62) else p21

    t1.gradient(v6, ColorSequence.new(v8:Lerp(Color3.new(1, 1, 1), 0.2), v8))

    return v5
end

function t1.dress(p23, p24) -- line: 140
    -- upvalues: Kit (copy)
    local v9 = p23:FindFirstChildOfClass("UIGradient") or Instance.new("UIGradient")

    v9.Rotation = 90
    v9.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.new(1, 1, 1)),
        ColorSequenceKeypoint.new(0.5, Color3.new(0.93, 0.93, 0.93)),
        ColorSequenceKeypoint.new(0.52, Color3.new(0.8, 0.8, 0.8)),
        ColorSequenceKeypoint.new(1, Color3.new(0.68, 0.68, 0.68))
    })
    v9.Parent = p23

    local UIStroke = p23:FindFirstChildOfClass("UIStroke")

    if UIStroke then
        UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        UIStroke.Thickness = 4
    end

    local v10 = math.max(p23.Size.Y.Offset, 40)

    Kit.studs(p23, 0.75, math.floor(v10 * 0.32), p24)

    local v12 = Kit.frame(p23, {
        Name = "Gloss",
        Interactable = false,
        BackgroundColor3 = Color3.new(1, 1, 1),
        Position = UDim2.fromOffset(6, 4),
        Size = UDim2.new(1, -12, 0.4, 0),
        ZIndex = p23.ZIndex
    })

    Kit.corner(v12, (math.max(p24 - 4, 4)))

    local UIGradient = Instance.new("UIGradient")

    UIGradient.Rotation = 90
    UIGradient.Transparency = NumberSequence.new(0.55, 0.9)
    UIGradient.Parent = v12

    local v16 = Kit.frame(p23, {
        Name = "Lip",
        Interactable = false,
        BackgroundColor3 = Color3.new(0, 0, 0),
        AnchorPoint = Vector2.new(0, 1),
        Position = UDim2.fromScale(0, 1),
        Size = UDim2.new(1, 0, 0, (math.max(p24, (math.floor(v10 * 0.22))))),
        ZIndex = p23.ZIndex
    })

    Kit.corner(v16, p24)

    local UIGradient2 = Instance.new("UIGradient")

    UIGradient2.Rotation = 90
    UIGradient2.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 1),
        NumberSequenceKeypoint.new(0.55, 0.78),
        NumberSequenceKeypoint.new(1, 0.6)
    })
    UIGradient2.Parent = v16
end

function t1.price(p25, p26, p27, p28) -- line: 193
    -- upvalues: Products (copy), UIUtil (copy), Kit (copy), Robux (copy), LocalPlayer (copy), t1 (copy)
    local TextButton = Instance.new("TextButton")

    TextButton.Name = "Buy"
    TextButton.Text = ""
    TextButton.AutoButtonColor = false
    TextButton.BackgroundColor3 = t1.BUY
    TextButton.BorderSizePixel = 0
    TextButton.ZIndex = 3

    for v17, v18 in p27 do
        TextButton[v17] = v18
    end

    local BackgroundColor3 = TextButton.BackgroundColor3

    Kit.corner(TextButton, 14)
    Kit.stroke(TextButton, t1.BORDER).ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    t1.dress(TextButton, 14)

    local Offset = TextButton.Size.Y.Offset
    local v19 = Kit.frame(TextButton, {
        Name = "Content",
        BackgroundTransparency = 1,
        Size = UDim2.fromScale(1, 1),
        ZIndex = TextButton.ZIndex + 1
    })
    local UIListLayout = Instance.new("UIListLayout")

    UIListLayout.FillDirection = Enum.FillDirection.Horizontal
    UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    UIListLayout.Padding = UDim.new(0, (math.floor(Offset * 0.1)))
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    UIListLayout.Parent = v19

    local ImageLabel = Instance.new("ImageLabel")

    ImageLabel.Name = "Icon"
    ImageLabel.BackgroundTransparency = 1
    ImageLabel.Image = t1.ROBUX
    ImageLabel.Size = UDim2.fromOffset(Offset * 0.54, Offset * 0.54)
    ImageLabel.ZIndex = TextButton.ZIndex + 1
    ImageLabel.Parent = v19

    local v22 = Kit.text(v19, "", {
        Name = "Label",
        LayoutOrder = 1,
        TextScaled = false,
        StrokeThickness = 5,
        TextSize = math.floor(Offset * 0.6),
        AutomaticSize = Enum.AutomaticSize.X,
        Size = UDim2.fromOffset(0, Offset * 0.7),
        ZIndex = TextButton.ZIndex + 1
    })

    t1.gradient(v22, ColorSequence.new(Color3.new(1, 1, 1), Color3.fromRGB(225, 255, 225)))
    v22.TextWrapped = false

    local v23 = Products.isPass(p26)

    local function refresh() -- line: 245
        -- upvalues: p26 (copy), TextButton (copy), BackgroundColor3 (copy), ImageLabel (copy), v22 (copy), v23 (copy), Robux (copy), t1 (copy)
        local v24 = v23 and Robux.owns(p26)
        local v25 = Robux.soldOut(p26)

        ImageLabel.Visible = not v24 and not v25

        local v26 = if v24 then "OWNED" elseif v25 then "SOLD OUT" else tostring(Robux.price(p26))

        v22.Text = v26
        TextButton.BackgroundColor3 = if v24 or v25 then t1.GREY else BackgroundColor3
    end

    refresh()
    TextButton:SetAttribute("Key", p26)
    TextButton.Parent = p25
    Robux.onPrices(refresh)

    if v23 then
        LocalPlayer:GetAttributeChangedSignal("Pass_" .. p26):Connect(refresh)
    end

    if Products.Limited[p26] then
        workspace:GetAttributeChangedSignal("Left_" .. p26):Connect(refresh)
    end

    UIUtil.bindButton(TextButton, function() -- line: 262
        -- upvalues: p26 (copy), p28 (copy), Robux (copy)
        Robux.buy(p26, p28)
    end)

    return TextButton
end

function t1.stock(p29, p30, p31) -- line: 272
    -- upvalues: Products (copy), Animals (copy), Robux (copy), t1 (copy)
    local v28 = t1.text(p29, "", p31)

    v28.Name = "Stock"

    local v29 = Products.Limited[p30]

    local function refresh() -- line: 276
        -- upvalues: p30 (copy), v28 (copy), v29 (copy), Animals (copy), Robux (copy)
        local v30 = Robux.left(p30) or 0
        local v31 = Animals.isLimitedTradeable({
            Id = p30
        })

        if v30 <= 0 then
            v28.Text = v31 and "<font color=\"#FF5A5A\">SOLD OUT</font> · 🤝 trade for one!" or "<font color=\"#FF5A5A\">SOLD OUT</font> · all gone!"
        else
            v28.Text = ("⏳ LIMITED · <font color=\"%*\">%* LEFT</font>"):format(v30 <= v29 * 0.2 and "#FF5A5A" or "#FFE25A", v30) .. (v31 and " · 🤝 TRADEABLE" or "")
        end
    end

    workspace:GetAttributeChangedSignal("Left_" .. p30):Connect(refresh)
    refresh()

    return v28
end

function t1.polish(p32) -- line: 295
    -- upvalues: Kit (copy)
    local Studs = p32:FindFirstChild("Studs")

    if Studs then
        Studs.ImageTransparency = 0.8
    end

    local v33 = Kit.frame(p32, {
        Name = "Gloss",
        Interactable = false,
        BackgroundColor3 = Color3.new(1, 1, 1),
        Size = UDim2.fromScale(1, 0.55),
        ZIndex = p32.ZIndex
    })

    Kit.corner(v33, 18)

    local UIGradient = Instance.new("UIGradient")

    UIGradient.Rotation = 90
    UIGradient.Transparency = NumberSequence.new(0.8, 1)
    UIGradient.Parent = v33

    return v33
end

function t1.seal(p33, p34, p35, p36) -- line: 316
    -- upvalues: Kit (copy), t1 (copy)
    local v34 = Kit.frame(p33, p36)

    v34.BackgroundTransparency = 1
    v34.ZIndex = p36.ZIndex or 6
    v34.Rotation = p36.Rotation or -12

    local ImageLabel = Instance.new("ImageLabel")

    ImageLabel.Name = "Star"
    ImageLabel.BackgroundTransparency = 1
    ImageLabel.Image = t1.STAR
    ImageLabel.ScaleType = Enum.ScaleType.Fit
    ImageLabel.Size = UDim2.fromScale(1, 1)
    ImageLabel.ZIndex = v34.ZIndex
    ImageLabel.Parent = v34
    Kit.shade(ImageLabel, 0.8)

    local v35 = Kit.text(v34, p34, {
        StrokeThickness = 4,
        AnchorPoint = Vector2.new(0.5, 1),
        Position = UDim2.fromScale(0.5, 0.6),
        Size = UDim2.fromScale(0.8, 0.4),
        ZIndex = v34.ZIndex + 1
    })

    v35.Name = "Top"
    t1.gradient(v35, ColorSequence.new(Color3.new(1, 1, 1), t1.YELLOW))
    Kit.text(v34, p35, {
        AnchorPoint = Vector2.new(0.5, 0),
        Position = UDim2.fromScale(0.5, 0.58),
        Size = UDim2.fromScale(0.62, 0.2),
        ZIndex = v34.ZIndex + 1
    }).Name = "Bottom"

    return v34
end

function t1.bubble(p37, p38, p39) -- line: 350
    -- upvalues: Config (copy), Kit (copy)
    local v36 = Kit.frame(p37, p39)

    v36.BackgroundColor3 = Color3.new(1, 1, 1)
    v36.BackgroundTransparency = 0.82

    local UICorner = Instance.new("UICorner")

    UICorner.CornerRadius = UDim.new(1, 0)
    UICorner.Parent = v36

    local TextLabel = Instance.new("TextLabel")

    TextLabel.BackgroundTransparency = 1
    TextLabel.AnchorPoint = Vector2.new(0.5, 0.5)
    TextLabel.Position = UDim2.fromScale(0.5, 0.5)
    TextLabel.Size = UDim2.fromScale(0.72, 0.72)
    TextLabel.TextScaled = true
    TextLabel.FontFace = Config.Font
    TextLabel.Text = p38
    TextLabel.ZIndex = v36.ZIndex + 1
    TextLabel.Parent = v36

    return v36
end

function t1.icon(p40, p41) -- line: 371
    local ImageLabel = Instance.new("ImageLabel")

    ImageLabel.Name = "Icon"
    ImageLabel.BackgroundTransparency = 1
    ImageLabel.Image = p41
    ImageLabel.ScaleType = Enum.ScaleType.Fit
    ImageLabel.AnchorPoint = Vector2.new(0.5, 0.5)
    ImageLabel.Position = UDim2.fromScale(0.5, 0.5)
    ImageLabel.Size = UDim2.fromScale(0.86, 0.86)
    ImageLabel.ZIndex = p40.ZIndex + 1
    ImageLabel.Parent = p40

    return ImageLabel
end

function t1.clock(p42) -- line: 386
    local v38 = math.max(0, (math.floor(p42)))
    local v39 = v38 // 3600
    local v40 = v38 % 3600 // 60
    local v41 = v38 % 60

    if v39 > 0 then
        return (string.format("%d:%02d:%02d", v39, v40, v41))
    end

    return (string.format("%d:%02d", v40, v41))
end

return t1
