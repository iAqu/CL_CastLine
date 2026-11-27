-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Config = require(ReplicatedStorage.Shared.Config)
local Format = require(ReplicatedStorage.Shared.Format)
local Products = require(ReplicatedStorage.Shared.Products)
local RodBuilder = require(ReplicatedStorage.Shared.RodBuilder)
local Kit = require(script.Parent.Parent.MiniGames.Kit)
local Viewport = require(script.Parent.Parent.UI.Viewport)
local Style = require(script.Parent.Style)
local Fx = require(script.Parent.Fx)
local Robux = require(script.Parent.Robux)
local Gift = require(script.Parent.Gift)
local LocalPlayer = Players.LocalPlayer
local t1 = {}
local Left, Right = Enum.TextXAlignment.Left, Enum.TextXAlignment.Right

local function giftButton(p1, p2, p3) -- line: 27
    -- upvalues: Kit (copy), Style (copy), Fx (copy), Gift (copy)
    if not Gift.available(p2) then
        return nil
    end

    p3.ZIndex = p3.ZIndex or 4

    local v1 = Kit.button(p1, "🎁 GIFT", Style.PURPLE, p3, function() -- line: 32
        -- upvalues: p2 (copy), Gift (copy)
        Gift.open(p2)
    end)

    v1.Label.ZIndex = p3.ZIndex + 2
    Style.dress(v1, 12)
    Fx.shine(v1, 4, 1.5, 0.35)

    return v1
end

local function chip(p4, p5, p6) -- line: 42
    -- upvalues: Kit (copy), Style (copy)
    local v2 = Kit.frame(p4, p6)

    v2.BackgroundTransparency = 1
    Style.text(v2, p5, {
        StrokeThickness = 4,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromScale(0.5, 0.5),
        Size = UDim2.fromScale(0.94, 0.8)
    })

    return v2
end

local function passCard(p7, p8, p9, p10, p11, p12, p13, p14, p15, p16, p17) -- line: 56
    -- upvalues: Kit (copy), Style (copy), Fx (copy), Robux (copy), Left (copy), Right (copy), giftButton (copy)
    local v3 = Style.card(p7, p11, {
        Name = p8,
        Position = UDim2.fromOffset(p9, 0),
        Size = UDim2.fromOffset(p10, 330)
    })

    Style.polish(v3)
    Fx.sparkles(v3, 4, Style.YELLOW, 24, 2)

    local v4 = Style.text(v3, p12, {
        StrokeThickness = 5,
        ZIndex = 3,
        Position = UDim2.fromOffset(26, 18),
        Size = UDim2.new(1, -230, 0, 66),
        TextXAlignment = Left
    })

    Style.gradient(v4, ColorSequence.new(Style.YELLOW, Color3.new(1, 1, 1)))

    local v5 = Style.tag(v3, "♾ FOREVER", Style.ABYSS, {
        Rotation = 4,
        AnchorPoint = Vector2.new(1, 0.5),
        Position = UDim2.new(1, -16, 0, 4),
        Size = UDim2.fromOffset(170, 46)
    })

    Fx.wiggle(v5, 5, 3.5, p9 / 300)

    local ImageLabel

    if p14:find("rbxasset") then
        ImageLabel = Instance.new("ImageLabel")
        ImageLabel.Image = p14
        ImageLabel.ScaleType = Enum.ScaleType.Fit
    else
        ImageLabel = Instance.new("TextLabel")
        ImageLabel.Text = p14
        ImageLabel.TextScaled = true
    end

    ImageLabel.BackgroundTransparency = 1
    ImageLabel.Position = UDim2.fromOffset(26, 96)
    ImageLabel.Size = UDim2.fromOffset(180, 180)
    ImageLabel.ZIndex = 2
    ImageLabel.Parent = v3
    Fx.rays(v3, 0.75, 116 / v3.Size.X.Offset, 0.5636363636363636, 1).ImageTransparency = 0.35
    Fx.bob(ImageLabel, 6, 2.2, p9)

    if p17 ~= "" then
        local v6 = Kit.text(v3, p17 or "2x", {
            ZIndex = 3,
            StrokeThickness = 6,
            Position = UDim2.fromOffset(16, 216),
            Size = UDim2.fromOffset(140, 96)
        })

        Style.gradient(v6, ColorSequence.new(Style.YELLOW, Style.GOLD))
    end

    Style.text(v3, p13, {
        StrokeThickness = 4,
        ZIndex = 3,
        AnchorPoint = Vector2.new(1, 0),
        Position = UDim2.new(1, -24, 0, 96),
        Size = UDim2.new(1, -250, 0, 80),
        TextXAlignment = Right
    })

    local v7 = Style.text(v3, "", {
        Name = "Preview",
        ZIndex = 3,
        AnchorPoint = Vector2.new(1, 0),
        Position = UDim2.new(1, -24, 0, 182),
        Size = UDim2.new(1, -250, 0, 34),
        TextXAlignment = Right,
        TextColor3 = Style.SAND
    })
    local v8 = Style.price(v3, p8, {
        AnchorPoint = Vector2.new(1, 1),
        Position = UDim2.new(1, -24, 1, -22),
        Size = UDim2.fromOffset(270, 76)
    })

    Fx.shine(v8, 3, p9 / 400)
    giftButton(v3, p8, {
        AnchorPoint = Vector2.new(1, 0),
        Position = UDim2.new(1, -24, 0, 34),
        Size = UDim2.fromOffset(160, 54)
    })
    p16(function() -- line: 122
        -- upvalues: p8 (copy), p15 (copy), v7 (copy), Robux (copy)
        v7.Text = if Robux.owns(p8) then "You have it! ✔" else p15()
    end)
end

local function trainingPreview() -- line: 127
    -- upvalues: Format (copy), LocalPlayer (copy)
    local v10 = LocalPlayer:GetAttribute("StrengthRate") or 0

    return (("+%* → <font color=\"#96FFAA\">+%*</font> a rep"):format(Format.short(v10), (Format.short(v10 * 2))))
end

local function autoTrainPreview() -- line: 132
    -- upvalues: Format (copy), Products (copy), LocalPlayer (copy)
    local v11 = LocalPlayer:GetAttribute("StrengthRate") or 0

    return (("<font color=\"#96FFAA\">+%* XP</font> a second, even while fishing"):format((Format.short(v11 * Products.AutoTrainRate))))
end

local function autoTrainCard(p18, p19, p20, p21) -- line: 137
    -- upvalues: Config (copy), Style (copy), passCard (copy), autoTrainPreview (copy)
    passCard(p18, "AutoTrain", p19, p20, Style.CORAL, "AUTO TRAIN", "Keep getting stronger while you fish!", Config.Icons.AutoTrain, autoTrainPreview, p21, "")
end

local function saleTag(p22, p23, p24, p25) -- line: 143
    -- upvalues: Products (copy), Style (copy), Fx (copy), Robux (copy)
    local v12 = Style.tag(p22, "", Style.CORAL, {
        Name = "Sale",
        Rotation = -3,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.new(p24.Position.X.Scale, p24.Position.X.Offset - p24.Size.X.Offset / 2, p24.Position.Y.Scale, p24.Position.Y.Offset - p24.Size.Y.Offset),
        Size = UDim2.fromOffset(p24.Size.X.Offset * 0.8, 50)
    })

    v12.ZIndex = 6

    local TextLabel = v12:FindFirstChildOfClass("TextLabel")

    TextLabel.RichText = true
    Fx.wiggle(v12, 4, 2.5)
    p25(function() -- line: 155
        -- upvalues: p23 (copy), v12 (copy), TextLabel (copy), Products (copy), Robux (copy)
        local v13 = if Robux.owns(p23) then nil else Products.saleOff(p23, Robux.price(p23))

        v12.Visible = v13 ~= nil

        if v13 then
            TextLabel.Text = ("%*%% OFF  <font color=\"#FFD9D0\"><s>%*</s></font>"):format(v13, Products.Passes[p23].WasPrice)
        end
    end)
end

local v15 = math.floor((Products.VipBonus - 1) * 100 + 0.5)
local t2 = {
    {
        "💰",
        (("+%*%% Cash"):format(v15))
    },
    {
        "🍀",
        (("+%*%% Luck"):format(v15))
    },
    {
        "💪",
        (("+%*%% Strength"):format(v15))
    },
    { "🌈", "RGB Rod + Aura" },
    { "💬", "[VIP] Chat Tag" },
    { "🎁", "Daily Cash Reward" }
}

local function perkBox(p26, p27, p28, p29) -- line: 175
    -- upvalues: Kit (copy), Style (copy)
    local v16 = Kit.frame(p26, {
        Name = "Perk",
        BackgroundTransparency = 1,
        ZIndex = 2,
        Position = UDim2.fromOffset(p28, p29),
        Size = UDim2.fromOffset(360, 52)
    })
    local TextLabel = Instance.new("TextLabel")

    TextLabel.BackgroundTransparency = 1
    TextLabel.Position = UDim2.fromOffset(10, 6)
    TextLabel.Size = UDim2.fromOffset(40, 40)
    TextLabel.TextScaled = true
    TextLabel.Text = p27[1]
    TextLabel.ZIndex = 3
    TextLabel.Parent = v16

    local v17 = Style.text(v16, p27[2], {
        TextScaled = false,
        TextSize = 30,
        ZIndex = 3,
        StrokeThickness = 4,
        Position = UDim2.fromOffset(58, 8),
        Size = UDim2.fromOffset(0, 36),
        AutomaticSize = Enum.AutomaticSize.X
    })

    Style.gradient(v17, Style.RAINBOW, 0)
end

local function vipRod(p30) -- line: 205
    -- upvalues: Config (copy), RodBuilder (copy), Viewport (copy)
    local ViewportFrame = Instance.new("ViewportFrame")

    ViewportFrame.Name = "Rod"
    ViewportFrame.BackgroundTransparency = 1
    ViewportFrame.Ambient = Color3.fromRGB(200, 200, 210)
    ViewportFrame.LightColor = Color3.new(1, 1, 1)
    ViewportFrame.LightDirection = Vector3.new(-1, -1, -1)
    ViewportFrame.AnchorPoint = Vector2.new(1, 0)
    ViewportFrame.Position = UDim2.new(1, -20, 0, 2)
    ViewportFrame.Size = UDim2.fromOffset(330, 226)
    ViewportFrame.ZIndex = 2
    ViewportFrame.Parent = p30

    local v18 = RodBuilder.build(#Config.Rods, true)

    v18:PivotTo(CFrame.Angles(0.6108652381980153, 0, 0) * v18:GetPivot())
    Viewport.show(ViewportFrame, v18, 90, 0.55)

    return ViewportFrame
end

local function passes(p31, p32, p33) -- line: 224
    -- upvalues: Config (copy), Format (copy), Products (copy), Style (copy), Fx (copy), LocalPlayer (copy), Left (copy), giftButton (copy), chip (copy), passCard (copy), trainingPreview (copy), autoTrainPreview (copy), saleTag (copy), t2 (copy), perkBox (copy), vipRod (copy)
    local v19 = Style.row(p31, 340, p32)
    local v20 = Style.card(v19, Style.GOLD, {
        Name = "VIP",
        Size = UDim2.fromScale(1, 1)
    })

    Style.polish(v20)
    v20.UIStroke.Thickness = 7
    Fx.turn(Style.gradient(v20.UIStroke, Style.RAINBOW, 0), 90)
    Fx.shine(v20, 4.5, 0, 0.3)
    Fx.sparkles(v20, 8, Color3.new(1, 1, 1), 28, 2)

    local v21 = Style.text(v20, "👑 V.I.P", {
        StrokeThickness = 6,
        Position = UDim2.fromOffset(30, 18),
        Size = UDim2.fromOffset(420, 80),
        TextXAlignment = Left
    })

    Style.gradient(v21, ColorSequence.new(Color3.new(1, 1, 1), Style.YELLOW))
    v21.ZIndex = 3
    chip(v20, `{#t2} PERKS · FOREVER`, {
        ZIndex = 3,
        Position = UDim2.fromOffset(330, 32),
        Size = UDim2.fromOffset(330, 56)
    })
    giftButton(v20, "VIP", {
        Position = UDim2.fromOffset(676, 28),
        Size = UDim2.fromOffset(170, 62)
    })

    for v22, v23 in t2 do
        local v24 = (v22 - 1) // 3
        local v25 = (v22 - 1) % 3

        perkBox(v20, v23, 30 + v24 * 380, 112 + v25 * 66)
    end

    Fx.rays(v20, 1.1, 1 - 185 / Style.WIDTH, 0.36, 1).ImageTransparency = 0.3
    Fx.sway(vipRod(v20), 25, 0.8)

    local v26 = Style.price(v20, "VIP", {
        AnchorPoint = Vector2.new(1, 1),
        Position = UDim2.new(1, -30, 1, -24),
        Size = UDim2.fromOffset(300, 84)
    })

    Fx.shine(v26, 2.6)
    Fx.ping(v26, Style.YELLOW, 1.8)
    Fx.breathe(v26, 0.04, 3)
    saleTag(v20, "VIP", v26, p33)

    local v27 = Style.row(p31, 330, p32 + 1)
    local v28 = Style.split(2)

    passCard(v27, "CashX2", 0, v28, Style.KELP, "2x CASH", "Earn double the cash from your animals!", Config.Icons.Cash, function() -- line: 256
        -- upvalues: Format (copy), LocalPlayer (copy)
        local v29 = LocalPlayer:GetAttribute("Income") or 0

        return (("%*/s → <font color=\"#96FFAA\">%*/s</font>"):format(Format.money(v29), (Format.money(v29 * 2))))
    end, p33)
    passCard(v27, "StrengthX2", v28 + Style.GAP, v28, Style.CORAL, "2x TRAINING", "Every rep gives double the strength!", Config.Icons.Strength, trainingPreview, p33)

    local v30 = Style.row(p31, 330, p32 + 2)

    passCard(v30, "LuckX2", 0, v28, Style.SEAFOAM, "2x LUCK", "Rarer animals on every single cast!", Config.Icons.Luck, function() -- line: 263
        -- upvalues: Format (copy), LocalPlayer (copy)
        local v31 = LocalPlayer:GetAttribute("LuckMult") or 1

        return (("Luck x%* → <font color=\"#96FFAA\">x%*</font>"):format(Format.short(v31), (Format.short(v31 * 2))))
    end, p33)
    passCard(v30, "AutoClicker", v28 + Style.GAP, v28, Style.ABYSS, "AUTO CLICKER", "Reels in every catch for you, 2x faster!", Config.Icons.AutoClicker, function() -- line: 267
        -- upvalues: Products (copy)
        return (("<font color=\"#96FFAA\">%* taps</font> a second, hands free"):format(Products.AutoClickerRate))
    end, p33)
    passCard(Style.row(p31, 330, p32 + 3), "AutoTrain", 0, v28 * 2 + Style.GAP, Style.CORAL, "AUTO TRAIN", "Keep getting stronger while you fish!", Config.Icons.AutoTrain, autoTrainPreview, p33, "")
end

local t3 = {
    Name = "ServerLuck",
    Title = "SERVER LUCK!",
    Color = Style.SEAFOAM,
    Glow = Style.MINT,
    Icon = Config.Icons.Luck,
    Ladder = Products.ServerLuck,
    Max = Products.ServerLuckMax,
    Time = Products.ServerLuckTime,
    Offer = Products.serverLuckOffer,
    Lines = {
        `+{ Products.ServerLuckTime // 60 } Minutes for EVERYONE`,
        "📣 The whole server sees your name!"
    },
    Now = function() -- Now | line: 286
        local v34 = (workspace:GetAttribute("ServerLuckUntil") or 0) - workspace:GetServerTimeNow()

        if v34 > 0 then
            return v34, workspace:GetAttribute("ServerLuckMult") or 1
        end

        return v34, 1
    end
}
local t4 = {
    Name = "StrengthBoost",
    Title = "STRENGTH BOOST!",
    Color = Style.CORAL,
    Glow = Color3.fromRGB(255, 215, 200),
    Icon = Config.Icons.Strength,
    Ladder = Products.StrengthBoost,
    Max = Products.StrengthBoostMax,
    Time = Products.StrengthBoostTime,
    Offer = Products.strengthBoostOffer,
    Lines = {
        `+{ Products.StrengthBoostTime // 60 } Minutes`,
        "💪 Train way faster!"
    },
    Now = function() -- Now | line: 302
        -- upvalues: Products (copy), LocalPlayer (copy)
        return Products.strengthBoostNow(LocalPlayer)
    end
}

local function ladderCard(p34, p35, p36, p37) -- line: 307
    -- upvalues: Style (copy), Fx (copy)
    local v35 = Style.row(p34, 280, p35)
    local v36 = Style.card(v35, p37.Color, {
        Name = p37.Name,
        Size = UDim2.fromScale(1, 1)
    })

    Style.polish(v36)
    Fx.sparkles(v36, 7, p37.Glow, 28, 2)
    Fx.rays(v36, 1.3, 140 / Style.WIDTH, 0.5, 1).ImageTransparency = 0.3

    local v37 = Style.bubble(v36, "", {
        ZIndex = 2,
        Position = UDim2.fromOffset(30, 30),
        Size = UDim2.fromOffset(220, 220)
    })

    Style.icon(v37, p37.Icon)
    Fx.wiggle(v37, 10, 2.4)
    Fx.bob(v37, 6, 2)

    local v38 = Style.text(v36, p37.Title, {
        StrokeThickness = 6,
        ZIndex = 3,
        Position = UDim2.fromOffset(290, 16),
        Size = UDim2.fromOffset(520, 66)
    })

    Style.gradient(v38, ColorSequence.new(Color3.new(1, 1, 1), p37.Glow))

    local v39 = Style.text(v36, "", {
        StrokeThickness = 6,
        Position = UDim2.fromOffset(290, 92),
        Size = UDim2.fromOffset(520, 96)
    })

    v39.Name = "Mult"
    Style.text(v36, p37.Lines[1], {
        ZIndex = 3,
        Position = UDim2.fromOffset(290, 190),
        Size = UDim2.fromOffset(520, 40)
    })
    Style.text(v36, p37.Lines[2], {
        ZIndex = 3,
        Position = UDim2.fromOffset(290, 232),
        Size = UDim2.fromOffset(520, 32),
        TextColor3 = Style.YELLOW
    })

    local v40 = Style.text(v36, "", {
        Name = "Timer",
        AnchorPoint = Vector2.new(1, 0),
        Position = UDim2.new(1, -30, 0, 46),
        Size = UDim2.fromOffset(300, 44),
        TextColor3 = Style.YELLOW
    })
    local t5 = {}

    for v41, v42 in p37.Ladder do
        t5[v41] = Style.price(v36, v42, {
            Visible = false,
            AnchorPoint = Vector2.new(1, 1),
            Position = UDim2.new(1, -30, 1, -40),
            Size = UDim2.fromOffset(300, 92)
        })
        Fx.shine(t5[v41], 2.4)
        Fx.ping(t5[v41], Style.YELLOW, 1.6)
    end

    p36(function() -- line: 360
        -- upvalues: p37 (copy), v39 (copy), v40 (copy), t5 (copy), Style (copy)
        local v43, v44 = p37.Now()
        local _, v45 = p37.Offer(v44)

        v40.Text = if v43 > 0 then "⏱ " .. Style.clock(v43) .. " left" else ""
        v39.Text = if p37.Max <= v44 then ("<font color=\"#FFE25A\">%*x</font>  MAX!"):format(v44) else ("%*x  ›  <font color=\"#FFE25A\">%*x</font>"):format(v44, v45)

        for v48, v49 in t5 do
            v49.Visible = v48 == v45
        end
    end)
end

local t6 = {
    Cash = Style.KELP,
    Strength = Style.CORAL
}

local function potionCard(p38, p39, p40, p41, p42, p43, p44) -- line: 376
    -- upvalues: Products (copy), Style (copy), Fx (copy), LocalPlayer (copy), Right (copy), t6 (copy)
    local v50 = Style.card(p38, t6[p39.Stat], {
        Name = p39.Key,
        Position = UDim2.fromOffset(p41, 0),
        Size = UDim2.fromOffset(p42, p43)
    })

    Style.polish(v50)
    Style.text(v50, `Lasts <font color="#FFE25A">{ Products.PotionTime // 60 }m</font>`, {
        StrokeThickness = 4,
        Position = UDim2.fromOffset(20, 16),
        Size = UDim2.new(1, -40, 0, 50)
    })
    Fx.rays(v50, 237.99999999999997 / p43, 0.5, 134 / p43, 1).ImageTransparency = 0.6

    local v51 = Style.bubble(v50, "", {
        ZIndex = 2,
        AnchorPoint = Vector2.new(0.5, 0),
        Position = UDim2.new(0.5, 0, 0, 66),
        Size = UDim2.fromOffset(136, 136)
    })

    Style.icon(v51, p39.Image)
    Fx.bob(v51, 6, 2.6, p40 * 1.5)
    Style.text(v50, ("<font color=\"#96FFAA\">x%*</font> %*"):format(Products.PotionMult, p39.Stat), {
        StrokeThickness = 4,
        Position = UDim2.fromOffset(20, 200),
        Size = UDim2.new(1, -40, 0, 50)
    })

    local v52 = Style.text(v50, "", {
        Name = "Timer",
        AnchorPoint = Vector2.new(1, 0),
        Position = UDim2.new(1, -16, 0, 72),
        Size = UDim2.fromOffset(110, 30),
        TextXAlignment = Right,
        TextColor3 = Style.YELLOW
    })

    Fx.shine(Style.price(v50, p39.Key, {
        AnchorPoint = Vector2.new(0.5, 1),
        Position = UDim2.new(0.5, 0, 1, -18),
        Size = UDim2.new(1, -60, 0, 66)
    }), 3, p40 * 0.6)
    p44(function() -- line: 406
        -- upvalues: p39 (copy), v52 (copy), Style (copy), LocalPlayer (copy)
        local Attribute = LocalPlayer:GetAttribute("Potion_" .. p39.Stat)

        v52.Text = if Attribute then "⏱ " .. Style.clock(Attribute) else ""
    end)
end

local function potions(p45, p46, p47) -- line: 412
    -- upvalues: Products (copy), Style (copy), potionCard (copy)
    local v54 = Style.row(p45, 340, p46)
    local v55 = Style.split(#Products.Potions)

    for v56, v57 in Products.Potions do
        potionCard(v54, v57, v56, (v56 - 1) * (v55 + Style.GAP), v55, 340, p47)
    end
end

function t1.buildTraining(p48, p49, p50) -- line: 421
    -- upvalues: Config (copy), Products (copy), Style (copy), passCard (copy), trainingPreview (copy), autoTrainPreview (copy), potionCard (copy)
    Style.title(p48, "TRAIN EVEN FASTER", Style.CORAL, p49)

    local v58 = Style.row(p48, 340, p49 + 1)
    local v59 = Style.split(3)

    passCard(v58, "StrengthX2", 0, v59 * 2 + Style.GAP, Style.CORAL, "2x TRAINING", "Every rep gives double the strength!", Config.Icons.Strength, trainingPreview, p50)

    for v60, v61 in Products.Potions do
        if v61.Stat == "Strength" then
            potionCard(v58, v61, v60, (v59 + Style.GAP) * 2, v59, 340, p50)
        end
    end

    passCard(Style.row(p48, 330, p49 + 2), "AutoTrain", 0, v59 * 3 + Style.GAP * 2, Style.CORAL, "AUTO TRAIN", "Keep getting stronger while you fish!", Config.Icons.AutoTrain, autoTrainPreview, p50, "")

    return p49 + 3
end

function t1.buildPasses(p51, p52, p53) -- line: 435
    -- upvalues: passes (copy)
    passes(p51, p52, p53)

    return p52 + 4
end

function t1.buildBoosts(p54, p55, p56) -- line: 440
    -- upvalues: Style (copy), t3 (copy), t4 (copy), ladderCard (copy), potions (copy)
    ladderCard(p54, p55, p56, t3)
    ladderCard(p54, p55 + 1, p56, t4)
    Style.title(p54, "POTIONS", Style.SEAFOAM, p55 + 2)
    potions(p54, p55 + 3, p56)

    return p55 + 4
end

return t1
