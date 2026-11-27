-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Shared = ReplicatedStorage:WaitForChild("Shared")
local Parent = script.Parent
local Products = require(Shared.Data.Products)
local Baits = require(Shared.Data.Baits)
local Fish = require(Shared.Data.Fish)
local Sizes = require(Shared.Data.Sizes)
local NumberFormat = require(Shared.NumberFormat)
local UIKit = require(Parent.UIKit)
local FishIcons = require(Parent.FishIcons)
local DataClient = require(Parent.DataClient)
local fromRGB = Color3.fromRGB
local Left, Right = Enum.TextXAlignment.Left, Enum.TextXAlignment.Right
local v1 = Vector2.new(0.5, 0.5)
local LocalPlayer = Players.LocalPlayer
local v2 = fromRGB(255, 255, 255)
local Outline = UIKit.Colors.Outline
local v3 = fromRGB(225, 230, 244)
local v4 = fromRGB(255, 210, 60)
local v5 = fromRGB(255, 226, 110)
local v6 = fromRGB(240, 160, 30)
local v7 = fromRGB(100, 245, 225)
local v8 = fromRGB(16, 18, 30)
local v9 = UDim2.fromOffset(240, 84)
local t1 = {
    glow_grub = "rbxassetid://115455647749484",
    golden_lure = "rbxassetid://123954429252001"
}
local _ = {
    StarterHero = "rbxassetid://136661090877816",
    Cash = "rbxassetid://73042781292442",
    Power = "rbxassetid://83731838257861",
    CoinPile = "rbxassetid://82001651296436"
}
local v10 = fromRGB(150, 90, 235)
local v11 = fromRGB(40, 22, 96)
local t2 = {
    Title = "Starter Pack",
    Subtitle = "Your first big splash!",
    Top = fromRGB(65, 220, 205),
    Bottom = fromRGB(20, 125, 165),
    Rim = fromRGB(150, 255, 235),
    Pill = {
        fromRGB(80, 120, 245),
        fromRGB(50, 80, 220)
    },
    PillText = v2
}
local t3 = {
    Title = "Pro Pack",
    Subtitle = "A giant boost for every rebirth!",
    Top = fromRGB(65, 85, 185),
    Bottom = fromRGB(30, 35, 90),
    Rim = v4,
    Pill = { v5, v4 },
    PillText = Outline
}

local function capText(p1, p2) -- line: 107
    local UITextSizeConstraint = Instance.new("UITextSizeConstraint")

    UITextSizeConstraint.MaxTextSize = p2
    UITextSizeConstraint.Parent = p1
end

local function baitPicture(p3, p4, p5) -- line: 113
    -- upvalues: ReplicatedStorage (copy), UIKit (copy), v1 (copy), t1 (copy)
    local v12 = t1[p4]

    if v12 then
        UIKit.image(p3, v12, {
            Size = UDim2.fromScale(1.45, 1.45),
            Position = UDim2.fromScale(0.5, 0.62),
            AnchorPoint = v1,
            ZIndex = p5
        })
    else
        task.spawn(function() -- line: 119
            -- upvalues: p3 (copy), p4 (copy), p5 (copy), ReplicatedStorage (copy), UIKit (copy)
            local v13 = ReplicatedStorage:WaitForChild("Assets", 30)
            local v14 = v13 and v13:WaitForChild("Baits", 30)
            local v15 = v14 and v14:WaitForChild(p4, 30)

            if v15 and v15:IsA("Model") and p3.Parent then
                UIKit.viewModel(p3, v15, {
                    Name = "BaitModel",
                    Zoom = 0.75,
                    Dir = Vector3.new(0.5, 0.3, -1),
                    ZIndex = p5
                })
            end
        end)
    end
end

local function imageArt(p6) -- line: 129
    -- upvalues: UIKit (copy), v1 (copy)
    return function(p7) -- line: 130
        -- upvalues: p6 (copy), UIKit (copy), v1 (copy)
        UIKit.image(p7, p6, {
            Size = UDim2.fromScale(1.6, 1.6),
            Position = UDim2.fromScale(0.5, 0.52),
            AnchorPoint = v1,
            ZIndex = p7.ZIndex + 1
        })
    end
end

local function baitArt(p8) -- line: 135
    -- upvalues: baitPicture (copy)
    return function(p9) -- line: 136
        -- upvalues: p8 (copy), baitPicture (copy)
        baitPicture(p9, p8, p9.ZIndex + 1)
    end
end

local function luckBadge(p10) -- line: 141
    -- upvalues: Baits (copy)
    local v16 = Baits.ById[p10]

    return if v16 then "x" .. tostring(v16.luck) else nil
end

local function pill(p11, p12, p13, p14, p15) -- line: 146
    -- upvalues: UIKit (copy), Outline (copy)
    local v17 = UIKit.frame(p11, {
        Name = "OneTime",
        Corner = 20,
        Stroke = 4,
        Size = UDim2.fromOffset(196, 40),
        Position = p14,
        Color = p13.Pill[1],
        Color2 = p13.Pill[2],
        ZIndex = p15
    })

    UIKit.text(v17, {
        Name = "Label",
        TextSize = 22,
        Text = p12,
        Color = p13.PillText,
        Stroke = p13.PillText == Outline and 0 or 3,
        ZIndex = p15 + 1
    })

    return v17
end

local function heading(p16, p17, p18, p19) -- line: 152
    -- upvalues: UIKit (copy), Left (copy), Right (copy), v1 (copy), v3 (copy)
    local v18 = UIKit.frame(p16.Scroll, {
        Transparency = 1,
        ZIndex = 12,
        Name = p17,
        Size = UDim2.fromOffset(p16.Width, 66)
    })

    v18.LayoutOrder = p16.NextOrder()
    UIKit.image(v18, p19, {
        ZIndex = 13,
        Rotation = -8,
        Size = UDim2.fromOffset(70, 70),
        Position = UDim2.new(0, 40, 0.5, 0),
        AnchorPoint = v1
    })
    UIKit.text(v18, {
        Name = "Title",
        TextSize = 46,
        Stroke = 5,
        ZIndex = 13,
        Text = p18.Title,
        Size = UDim2.new(0.5, -84, 1, 0),
        Position = UDim2.fromOffset(86, 0),
        XAlign = Left
    })
    UIKit.text(v18, {
        Name = "Subtitle",
        TextSize = 28,
        Stroke = 4,
        ZIndex = 13,
        Text = p18.Subtitle,
        Size = UDim2.new(0.5, -20, 1, 0),
        Position = UDim2.new(1, -12, 0, 4),
        AnchorPoint = Vector2.new(1, 0),
        XAlign = Right,
        Color = v3
    })

    return v18
end

local function card(p20, p21, p22, p23) -- line: 161
    -- upvalues: UIKit (copy)
    local v19 = UIKit.frame(p20.Scroll, {
        GradientRotation = 100,
        Corner = 20,
        Stroke = 6,
        ZIndex = 12,
        Name = p21,
        Size = UDim2.fromOffset(p20.Width, p22),
        Color = p23.Top,
        Color2 = p23.Bottom
    })

    v19.LayoutOrder = p20.NextOrder()

    local v20 = UIKit.frame(v19, {
        Name = "Rim",
        Transparency = 1,
        Corner = 16,
        ZIndex = 12,
        Size = UDim2.new(1, -10, 1, -10),
        Position = UDim2.fromOffset(5, 5)
    })

    UIKit.stroke(v20, 3, p23.Rim)
    p20.Gleam(v19, {
        Corner = 20,
        ZIndex = 13,
        Period = 7,
        Sweep = 1.1,
        Strength = 0.22,
        Width = 0.15
    })

    return v19
end

local function plusSign(p24, p25, p26) -- line: 170
    -- upvalues: UIKit (copy), v1 (copy), v4 (copy)
    return (UIKit.text(p24, {
        Name = "Plus",
        Text = "+",
        TextSize = 44,
        Stroke = 5,
        Size = UDim2.fromOffset(44, 44),
        Position = p25,
        AnchorPoint = v1,
        Color = v4,
        ZIndex = p26
    }))
end

local function tileRow(p27, p28, p29) -- line: 175
    -- upvalues: UIKit (copy), Right (copy), v4 (copy), v8 (copy), plusSign (copy)
    local t5 = {}

    for v21, v22 in p28 do
        local v23 = (v21 - 1) * 158

        if v21 > 1 then
            plusSign(p27, p29 + UDim2.fromOffset(v23 - 15, 52), 18)
        end

        local v24 = UIKit.frame(p27, {
            Transparency = 0.35,
            Corner = 14,
            Stroke = 3,
            ZIndex = 14,
            Name = "Item" .. v21,
            Size = UDim2.fromOffset(128, 104),
            Position = p29 + UDim2.fromOffset(v23, 0),
            Color = v8
        })
        local v25 = UIKit.frame(v24, {
            Name = "Art",
            Transparency = 1,
            ZIndex = 15,
            Size = UDim2.fromOffset(70, 70),
            Position = UDim2.new(0.5, 0, 0, 3),
            AnchorPoint = Vector2.new(0.5, 0)
        })

        v22.Art(v25)

        local v26 = UIKit.text(v24, {
            Name = "Amount",
            Stroke = 3,
            ZIndex = 17,
            Text = v22.Text,
            Size = UDim2.new(1, -12, 0, 30),
            Position = UDim2.new(0.5, 0, 1, -6),
            AnchorPoint = Vector2.new(0.5, 1)
        })
        local UITextSizeConstraint = Instance.new("UITextSizeConstraint")

        UITextSizeConstraint.MaxTextSize = 26
        UITextSizeConstraint.Parent = v26

        if v22.Badge then
            UIKit.text(v24, {
                Name = "Badge",
                TextSize = 18,
                Stroke = 3,
                ZIndex = 18,
                Text = v22.Badge,
                Size = UDim2.fromOffset(60, 22),
                Position = UDim2.new(1, -6, 0, 4),
                AnchorPoint = Vector2.new(1, 0),
                XAlign = Right,
                Color = v4
            })
        end

        t5[v21] = v26
    end

    return t5
end

local t6 = {}

function t6.StarterArt(p30, p31) -- line: 197
    -- upvalues: UIKit (copy), v1 (copy)
    local v27 = UIKit.image(p30, "rbxassetid://136661090877816", {
        Size = UDim2.fromScale(1, 1),
        Position = UDim2.fromScale(0.5, 0.5),
        AnchorPoint = v1,
        ZIndex = p31
    })

    v27.Name = "StarterArt"

    return v27
end

function t6.BuildStarter(p32) -- line: 203
    -- upvalues: Products (copy), Baits (copy), NumberFormat (copy), UIKit (copy), DataClient (copy), fromRGB (copy), Left (copy), v1 (copy), v4 (copy), v7 (copy), v9 (copy), t2 (copy), baitPicture (copy), pill (copy), heading (copy), card (copy), tileRow (copy), t6 (copy)
    local StarterPack = Products.StarterPack
    local v28 = Baits.ById[StarterPack.bait]
    local Gift = heading(p32, "StarterHeading", t2, "Gift")
    local v29 = card(p32, "StarterPack", 214, t2)

    p32.SparkleBack(v29, 20, Vector2.new(150, 107), 460, v4, {
        { 34, 30, 22 },
        { 262, 40, 18, v4 },
        { 40, 184, 18 },
        { 270, 176, 24, v4 },
        {
            p32.Width - 300,
            30, 20
        }
    })
    UIKit.image(v29, "Glow", {
        Transparency = 0.35,
        ZIndex = 13,
        Size = UDim2.fromOffset(250, 250),
        Position = UDim2.fromOffset(150, 110),
        AnchorPoint = v1,
        Color = v7
    })

    local v30 = UIKit.frame(v29, {
        Name = "Art",
        Transparency = 1,
        ZIndex = 14,
        Size = UDim2.fromOffset(300, 300),
        Position = UDim2.fromOffset(150, 100),
        AnchorPoint = v1
    })

    t6.StarterArt(v30, 14)
    p32.Bob(v30, 2, 2.0943951023931953)
    UIKit.text(v29, {
        Name = "Title",
        Text = "STARTER PACK",
        TextSize = 46,
        Stroke = 5,
        ZIndex = 15,
        Size = UDim2.fromOffset(310, 56),
        Position = UDim2.fromOffset(300, 14),
        XAlign = Left,
        Color = fromRGB(255, 246, 130)
    })
    pill(v29, "ONE-TIME PACK", t2, UDim2.fromOffset(618, 22), 15)

    local v31 = "rbxassetid://83731838257861"
    local t8 = {
        Art = function(p33) -- line: 130
            -- upvalues: v31 (copy), UIKit (copy), v1 (copy)
            UIKit.image(p33, v31, {
                Size = UDim2.fromScale(1.6, 1.6),
                Position = UDim2.fromScale(0.5, 0.52),
                AnchorPoint = v1,
                ZIndex = p33.ZIndex + 1
            })
        end,
        Text = "+" .. NumberFormat.commas(StarterPack.power) .. " Power"
    }
    local v32 = "rbxassetid://73042781292442"
    local t9 = {
        Art = function(p34) -- line: 130
            -- upvalues: v32 (copy), UIKit (copy), v1 (copy)
            UIKit.image(p34, v32, {
                Size = UDim2.fromScale(1.6, 1.6),
                Position = UDim2.fromScale(0.5, 0.52),
                AnchorPoint = v1,
                ZIndex = p34.ZIndex + 1
            })
        end,
        Text = "+" .. NumberFormat.money(StarterPack.cash)
    }
    local bait = StarterPack.bait
    local t10 = {}

    t10.Art = function(p35) -- line: 136
        -- upvalues: bait (copy), baitPicture (copy)
        baitPicture(p35, bait, p35.ZIndex + 1)
    end

    t10.Text = if v28 then v28.name else "Bait"

    local bait2 = StarterPack.bait
    local v33 = Baits.ById[bait2]

    t10.Badge = if v33 then "x" .. tostring(v33.luck) else nil
    tileRow(v29, {
        t8,
        t9,
        t10
    }, UDim2.fromOffset(300, 92))

    local v34 = p32.RobuxButton(v29, StarterPack, v9, UDim2.new(1, -26, 0.5, 6), Vector2.new(1, 0.5))

    p32.GlowBehind(v34, fromRGB(255, 245, 160), 1.05)
    DataClient.Observe("StarterPack", function(p36) -- line: 222
        -- upvalues: Gift (copy), v29 (copy)
        Gift.Visible = p36 ~= true
        v29.Visible = p36 ~= true
    end)
end

function t6.BuildPro(p37) -- line: 228
    -- upvalues: Products (copy), Baits (copy), Fish (copy), Sizes (copy), NumberFormat (copy), UIKit (copy), FishIcons (copy), DataClient (copy), fromRGB (copy), Left (copy), v1 (copy), LocalPlayer (copy), v2 (copy), Outline (copy), v4 (copy), v5 (copy), v6 (copy), v9 (copy), t1 (copy), v10 (copy), v11 (copy), t3 (copy), baitPicture (copy), pill (copy), heading (copy), card (copy), plusSign (copy), tileRow (copy)
    local ProPack = Products.ProPack
    local v35 = Fish.ById[ProPack.fish]
    local v36 = Sizes.List[ProPack.s] or Sizes.List[Sizes.NORMAL_INDEX]
    local _, v37 = Products.SpiritEntry(ProPack.fish)
    local v38 = if v37 then v37.pct else 0
    local Trophy = heading(p37, "ProHeading", t3, "Trophy")
    local v39 = card(p37, "ProPack", 272, t3)

    p37.SparkleBack(v39, 20, Vector2.new(150, 146), 560, fromRGB(255, 220, 140), {
        { 36, 40, 22, v4 },
        { 266, 52, 18 },
        { 40, 236, 20 },
        { 268, 230, 26, v4 },
        {
            p37.Width - 300,
            34, 22,
            v4
        }
    })

    local v40 = UIKit.frame(v39, {
        Name = "Portrait",
        Corner = 107,
        ZIndex = 14,
        Size = UDim2.fromOffset(214, 214),
        Position = UDim2.fromOffset(150, 146),
        AnchorPoint = v1,
        Color = v10,
        Color2 = v11
    })

    p37.Rainbow(UIKit.stroke(v40, 6, v2))
    UIKit.image(v40, "Glow", {
        Transparency = 0.45,
        ZIndex = 14,
        Size = UDim2.fromScale(0.95, 0.95),
        Position = UDim2.fromScale(0.5, 0.5),
        AnchorPoint = v1,
        Color = fromRGB(255, 200, 240)
    })

    local v41 = UIKit.frame(v40, {
        Name = "Fish",
        Transparency = 1,
        ZIndex = 15,
        Size = UDim2.fromScale(1.22, 1.22),
        Position = UDim2.fromScale(0.5, 0.46),
        AnchorPoint = v1
    })

    FishIcons.Picture(v41, ProPack.fish, ProPack.v)
    p37.Bob(v40, 2, 2.0943951023931953)
    UIKit.image(v39, "rbxassetid://82001651296436", {
        ZIndex = 18,
        Size = UDim2.fromOffset(140, 140),
        Position = UDim2.fromOffset(74, 214),
        AnchorPoint = v1
    })
    UIKit.image(v39, t1[ProPack.bait] or "rbxassetid://82001651296436", {
        Rotation = 18,
        ZIndex = 18,
        Size = UDim2.fromOffset(106, 106),
        Position = UDim2.fromOffset(222, 218),
        AnchorPoint = v1
    })

    local v42 = UIKit.frame(v39, {
        Name = "Ribbon",
        Corner = 14,
        Stroke = 4,
        ZIndex = 30,
        Size = UDim2.fromOffset(276, 46),
        Position = UDim2.fromOffset(-10, -16),
        Color = v5,
        Color2 = v6
    })

    v42.Rotation = -5
    UIKit.text(v42, {
        Name = "Label",
        TextSize = 26,
        Stroke = 0,
        ZIndex = 31,
        Text = "GUARANTEED " .. string.upper(if v35 then v35.rarity else "Spirit"),
        Color = Outline
    })
    p37.Sway(v42, 2, 2.4)

    local v43 = UIKit.text(v39, {
        Name = "Title",
        Text = "PRO PACK",
        TextSize = 50,
        Stroke = 6,
        ZIndex = 15,
        Size = UDim2.fromOffset(250, 58),
        Position = UDim2.fromOffset(300, 10),
        XAlign = Left
    })

    UIKit.gradient(v43, v2, v4)
    pill(v39, "ONE-TIME PACK", t3, UDim2.fromOffset(558, 20), 15)
    UIKit.text(v39, {
        Name = "FishName",
        TextSize = 30,
        Stroke = 4,
        ZIndex = 15,
        Text = ("<font color=\"#%s\">%s</font> %s"):format(v36.Color:ToHex(), string.upper(v36.id), string.upper(if v35 then v35.name else ProPack.fish)),
        Size = UDim2.fromOffset(450, 34),
        Position = UDim2.fromOffset(300, 70),
        XAlign = Left
    }).RichText = true
    UIKit.text(v39, {
        Name = "Earns",
        TextSize = 22,
        Stroke = 3,
        ZIndex = 15,
        Text = ("Earns %d%% of your best fish, forever"):format(v38),
        Size = UDim2.fromOffset(450, 26),
        Position = UDim2.fromOffset(300, 106),
        XAlign = Left,
        Color = v4
    })

    local v44 = "rbxassetid://83731838257861"
    local t14 = {
        Art = function(p38) -- line: 130
            -- upvalues: v44 (copy), UIKit (copy), v1 (copy)
            UIKit.image(p38, v44, {
                Size = UDim2.fromScale(1.6, 1.6),
                Position = UDim2.fromScale(0.5, 0.52),
                AnchorPoint = v1,
                ZIndex = p38.ZIndex + 1
            })
        end,
        Text = "+" .. NumberFormat.commas(ProPack.power) .. " Power"
    }
    local v45 = "rbxassetid://73042781292442"
    local t15 = {
        Art = function(p39) -- line: 130
            -- upvalues: v45 (copy), UIKit (copy), v1 (copy)
            UIKit.image(p39, v45, {
                Size = UDim2.fromScale(1.6, 1.6),
                Position = UDim2.fromScale(0.5, 0.52),
                AnchorPoint = v1,
                ZIndex = p39.ZIndex + 1
            })
        end,
        Text = "+" .. NumberFormat.money(ProPack.min),
        Badge = tostring(ProPack.minutes // 60) .. "H"
    }
    local bait = ProPack.bait
    local t16 = {}

    t16.Art = function(p40) -- line: 136
        -- upvalues: bait (copy), baitPicture (copy)
        baitPicture(p40, bait, p40.ZIndex + 1)
    end

    t16.Text = if Baits.ById[ProPack.bait] then Baits.ById[ProPack.bait].name else "Bait"

    local bait2 = ProPack.bait
    local v47 = Baits.ById[bait2]

    t16.Badge = if v47 then "x" .. tostring(v47.luck) else nil

    local v48 = tileRow(v39, {
        t14,
        t15,
        t16
    }, UDim2.fromOffset(300, 148))

    plusSign(v39, UDim2.fromOffset(278, 200), 18)

    local v49 = v48[2]

    local function refreshCash() -- line: 262
        -- upvalues: ProPack (copy), v49 (copy), Products (copy), NumberFormat (copy), LocalPlayer (copy)
        v49.Text = "+" .. NumberFormat.money(Products.CashFor(ProPack, LocalPlayer:GetAttribute("IncomePerSecond") or 0))
    end

    LocalPlayer:GetAttributeChangedSignal("IncomePerSecond"):Connect(refreshCash)
    v49.Text = "+" .. NumberFormat.money(Products.CashFor(ProPack, LocalPlayer:GetAttribute("IncomePerSecond") or 0))

    local v50 = p37.RobuxButton(v39, ProPack, v9, UDim2.new(1, -26, 0.5, 10), Vector2.new(1, 0.5))

    p37.GlowBehind(v50, fromRGB(255, 230, 140), 1.05)
    DataClient.Observe("ProPack", function(p41) -- line: 269
        -- upvalues: Trophy (copy), v39 (copy)
        Trophy.Visible = p41 ~= true
        v39.Visible = p41 ~= true
    end)
end

function t6.Build(p42) -- line: 275
    -- upvalues: t6 (copy)
    t6.BuildStarter(p42)
    t6.BuildPro(p42)
end

return t6
