-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ContentProvider = game:GetService("ContentProvider")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Animals = require(ReplicatedStorage.Shared.Animals)
local AnimalModel = require(ReplicatedStorage.Shared.AnimalModel)
local Format = require(ReplicatedStorage.Shared.Format)
local Products = require(ReplicatedStorage.Shared.Products)
local Remotes = require(ReplicatedStorage.Shared.Remotes)
local Viewport = require(script.Parent.Parent.UI.Viewport)
local Kit = require(script.Parent.Parent.MiniGames.Kit)
local Style = require(script.Parent.Style)
local Fx = require(script.Parent.Fx)
local Packs = require(script.Parent.Packs)
local Robux = require(script.Parent.Robux)
local LocalPlayer = Players.LocalPlayer
local t1 = {}
local Left = Enum.TextXAlignment.Left

local function viewport(p1, p2) -- line: 26
    -- upvalues: Kit (copy)
    local ViewportFrame = Instance.new("ViewportFrame")

    ViewportFrame.BackgroundTransparency = 1
    ViewportFrame.Ambient = Color3.fromRGB(190, 190, 200)
    ViewportFrame.LightColor = Color3.new(1, 1, 1)
    ViewportFrame.LightDirection = Vector3.new(-1, -1, -1)
    ViewportFrame.ZIndex = 2

    for v1, v2 in p2 do
        ViewportFrame[v1] = v2
    end

    Kit.corner(ViewportFrame, 14)
    ViewportFrame.Parent = p1

    return ViewportFrame
end

local function showAnimal(p3, p4, p5) -- line: 43
    -- upvalues: ContentProvider (copy), AnimalModel (copy), Viewport (copy)
    local v3 = AnimalModel.clone(p4, 6)

    if not v3 then
        return
    end

    Viewport.show(p3, v3, 60, p5 or 0.9)
    task.spawn(function() -- line: 49
        -- upvalues: p3 (copy), p4 (copy), p5 (copy), v3 (copy), ContentProvider (copy), AnimalModel (copy), Viewport (copy)
        ContentProvider:PreloadAsync({
            v3
        })

        if v3.Parent == p3 then
            Viewport.show(p3, AnimalModel.clone(p4, 6), 60, p5 or 0.9)
        end
    end)
end

local t2 = {
    Kraken = {
        title = "THE KRAKEN",
        tag = "LIMITED!",
        padding = 0.75,
        card = ColorSequence.new(Color3.fromRGB(150, 28, 44), Color3.fromRGB(40, 10, 60)),
        titleColor = ColorSequence.new(Style.YELLOW, Style.GOLD),
        sparkle = Color3.fromRGB(60, 255, 215)
    },
    Mermaid = {
        title = "THE MERMAID",
        tag = "NEW!",
        padding = 0.8,
        card = ColorSequence.new(Color3.fromRGB(20, 150, 190), Color3.fromRGB(120, 30, 120)),
        titleColor = ColorSequence.new(Color3.fromRGB(255, 240, 250), Color3.fromRGB(255, 130, 215)),
        sparkle = Color3.fromRGB(255, 150, 225)
    }
}

local function hero(p6, p7, p8) -- line: 79
    -- upvalues: Animals (copy), Format (copy), Kit (copy), Style (copy), Fx (copy), LocalPlayer (copy), Left (copy), viewport (copy), showAnimal (copy), t2 (copy)
    local v4 = t2[p8.Key]
    local Mult = Animals.get(p8.Id).Mult
    local v5 = Style.row(p6, 340, p7)
    local v6 = Style.card(v5, Style.ABYSS, {
        Name = p8.Key,
        Size = UDim2.fromScale(1, 1)
    })

    v6.UIGradient.Color = v4.card
    v6.UIGradient.Rotation = 0
    v6.UIStroke.Thickness = 7
    Fx.turn(Style.gradient(v6.UIStroke, Style.RAINBOW, 0), 90)
    Style.polish(v6)
    Fx.shine(v6, 5, 1, 0.3)

    local v7 = Style.text(v6, v4.title, {
        StrokeThickness = 6,
        ZIndex = 3,
        Position = UDim2.fromOffset(32, 20),
        Size = UDim2.fromOffset(560, 76),
        TextXAlignment = Left
    })

    Style.gradient(v7, v4.titleColor)
    Style.text(v6, `Always earns <font color="#FFE25A">{ Mult * 100 }%</font> of your best animal!`, {
        ZIndex = 3,
        Position = UDim2.fromOffset(32, 98),
        Size = UDim2.fromOffset(660, 40),
        TextXAlignment = Left
    })

    local v8 = Style.stock(v6, p8.Key, {
        StrokeThickness = 5,
        ZIndex = 3,
        Position = UDim2.fromOffset(32, 144),
        Size = UDim2.fromOffset(640, 40),
        TextXAlignment = Left
    })

    Fx.breathe(v8, 0.04, 2)

    local v9 = Style.text(v6, "", {
        Name = "Income",
        ZIndex = 3,
        Position = UDim2.fromOffset(32, 196),
        Size = UDim2.fromOffset(640, 38),
        TextXAlignment = Left
    })
    local v10 = Style.price(v6, p8.Key, {
        Position = UDim2.fromOffset(32, 250),
        Size = UDim2.fromOffset(300, 70)
    })

    Fx.shine(v10, 3, 0.8)
    Fx.breathe(v10, 0.04, 3)
    Fx.ping(v10, Style.YELLOW, 1.8)

    local v11 = Kit.frame(v6, {
        Name = "Stage",
        BackgroundTransparency = 1,
        ZIndex = 2,
        AnchorPoint = Vector2.new(1, 0.5),
        Position = UDim2.new(1, -30, 0.5, 0),
        Size = UDim2.fromOffset(380, 320)
    })

    Fx.rays(v6, 1.3, 1 - 220 / Style.WIDTH, 0.5, 1).ImageTransparency = 0.3

    local v12 = viewport(v11, {
        ZIndex = 3,
        Size = UDim2.fromScale(1, 1)
    })

    Fx.sway(v12, 30, 1.1)
    Fx.bob(v12, 7, 2.2)
    Fx.sparkles(v11, 5, v4.sparkle, 30, 4)

    local v13 = Style.seal(v6, ("x%*"):format(Mult), "INCOME", {
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.new(1, -400, 1, -70),
        Size = UDim2.fromOffset(120, 120)
    })

    Fx.wiggle(v13, 8, 3)

    local v14 = Style.tag(v6, v4.tag, Style.CORAL, {
        AnchorPoint = Vector2.new(1, 0),
        Position = UDim2.new(1, -16, 0, -14),
        Size = UDim2.fromOffset(170, 52)
    })

    Fx.wiggle(v14, 6, 2.6)
    showAnimal(v12, p8.Id, v4.padding)

    local function refresh() -- line: 157
        -- upvalues: p8 (copy), v9 (copy), Animals (copy), Format (copy)
        local megaBase = Animals.megaBase

        v9.Text = ("Best: %*/s  →  <font color=\"#96FFAA\">%*/s</font>"):format(Format.money(megaBase), (Format.money(Animals.income({
            Id = p8.Id
        }, megaBase))))
    end

    LocalPlayer:GetAttributeChangedSignal("MegaBase"):Connect(refresh)
    refresh()
end

local function exclusivePack(p9, p10, p11) -- line: 171
    -- upvalues: Animals (copy), Format (copy), Products (copy), Kit (copy), Style (copy), Fx (copy), Robux (copy), LocalPlayer (copy), Left (copy), viewport (copy), showAnimal (copy)
    local ExclusivePack = Products.ExclusivePack
    local v15 = Style.row(p9, 470, p10)
    local v16 = Style.card(v15, Style.ABYSS, {
        Name = ExclusivePack.Key,
        Size = UDim2.fromScale(1, 1)
    })

    v16.UIGradient.Color = ColorSequence.new(Color3.fromRGB(18, 120, 170), Color3.fromRGB(70, 30, 150))
    v16.UIGradient.Rotation = 20
    v16.UIStroke.Thickness = 7
    Fx.turn(Style.gradient(v16.UIStroke, Style.RAINBOW, 0), 80)
    Style.polish(v16)
    Fx.shine(v16, 5, 2, 0.3)
    Fx.sparkles(v16, 8, Style.YELLOW, 26, 2)

    local v17 = Style.text(v16, string.upper(ExclusivePack.Name), {
        StrokeThickness = 6,
        ZIndex = 3,
        Position = UDim2.fromOffset(32, 18),
        Size = UDim2.fromOffset(760, 72),
        TextXAlignment = Left
    })

    Style.gradient(v17, Style.RAINBOW, 0)
    Style.text(v16, "All <font color=\"#FFE25A\">3</font> shop-only animals, together for one price!", {
        ZIndex = 3,
        Position = UDim2.fromOffset(34, 88),
        Size = UDim2.fromOffset(760, 36),
        TextXAlignment = Left,
        TextColor3 = Style.SAND
    })

    local v18 = Style.tag(v16, "3 IN 1!", Style.CORAL, {
        AnchorPoint = Vector2.new(1, 0),
        Position = UDim2.new(1, -16, 0, -14),
        Size = UDim2.fromOffset(170, 52)
    })

    Fx.wiggle(v18, 6, 2.6)

    for v19, v20 in ExclusivePack.Animals do
        local v21 = 32 + (v19 - 1) * 270
        local v22 = Kit.frame(v16, {
            ClipsDescendants = true,
            ZIndex = 2,
            Name = v20,
            Position = UDim2.fromOffset(v21, 136),
            Size = UDim2.fromOffset(236, 236),
            BackgroundColor3 = Style.DEEP
        })

        v22.BackgroundTransparency = 0.5
        Kit.corner(v22, 16)
        Kit.stroke(v22, 4)
        Fx.rays(v22, 1.7, 0.5, 0.45, 2)

        local v23 = viewport(v22, {
            ZIndex = 3,
            Size = UDim2.new(1, 0, 1, -40)
        })

        showAnimal(v23, v20, 0.7)
        Fx.sway(v23, 35, 0.9 + v19 * 0.1)
        Fx.bob(v23, 5, 2, v19)
        Style.text(v22, Animals.displayName({
            Id = v20
        }), {
            StrokeThickness = 4,
            ZIndex = 4,
            AnchorPoint = Vector2.new(0.5, 1),
            Position = UDim2.new(0.5, 0, 1, -8),
            Size = UDim2.new(1, -16, 0, 32)
        })

        local v24 = Style.text(v22, ("x%*"):format(Animals.get(v20).Mult), {
            StrokeThickness = 4,
            ZIndex = 4,
            Position = UDim2.fromOffset(10, 6),
            Size = UDim2.fromOffset(80, 40),
            TextXAlignment = Left
        })

        Style.gradient(v24, ColorSequence.new(Color3.new(1, 1, 1), Style.YELLOW))

        if v19 < #ExclusivePack.Animals then
            local v25 = Style.text(v16, "+", {
                StrokeThickness = 5,
                ZIndex = 4,
                AnchorPoint = Vector2.new(0.5, 0.5),
                Position = UDim2.fromOffset(v21 + 236 + 17, 254),
                Size = UDim2.fromOffset(54, 60)
            })

            Style.gradient(v25, ColorSequence.new(Color3.new(1, 1, 1), Style.YELLOW))
            Fx.breathe(v25, 0.12, 2.5)
        end
    end

    local v26 = Style.text(v16, "", {
        Name = "Income",
        ZIndex = 3,
        Position = UDim2.fromOffset(34, 388),
        Size = UDim2.fromOffset(780, 38),
        TextXAlignment = Left
    })

    local function earns() -- line: 257
        -- upvalues: ExclusivePack (copy), v26 (copy), Animals (copy), Format (copy)
        local n1 = 0

        for _, v27 in ExclusivePack.Animals do
            n1 += Animals.income({
                Id = v27
            }, Animals.megaBase)
        end

        v26.Text = ("Together they earn <font color=\"#96FFAA\">%*/s</font> on your plot!"):format((Format.money(n1)))
    end

    LocalPlayer:GetAttributeChangedSignal("MegaBase"):Connect(earns)
    earns()

    local v28 = Kit.frame(v16, {
        Name = "Deal",
        BackgroundTransparency = 1,
        ZIndex = 3,
        AnchorPoint = Vector2.new(1, 0),
        Position = UDim2.new(1, -28, 0, 110),
        Size = UDim2.fromOffset(318, 340)
    })
    local v29 = Style.seal(v28, "", "OFF", {
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromScale(0.5, 0.2),
        Size = UDim2.fromOffset(140, 140)
    })

    Fx.wiggle(v29, 8, 2.8)

    local v30 = Style.text(v28, "", {
        StrokeThickness = 4,
        ZIndex = 4,
        AnchorPoint = Vector2.new(0.5, 0),
        Position = UDim2.new(0.5, 0, 0, 132),
        Size = UDim2.new(1, 0, 0, 38),
        TextColor3 = Style.SAND
    })

    Style.stock(v28, ExclusivePack.Key, {
        StrokeThickness = 4,
        ZIndex = 4,
        AnchorPoint = Vector2.new(0.5, 0),
        Position = UDim2.new(0.5, 0, 0, 176),
        Size = UDim2.new(1, 0, 0, 34)
    })

    local v31 = Style.price(v28, ExclusivePack.Key, {
        AnchorPoint = Vector2.new(0.5, 1),
        Position = UDim2.new(0.5, 0, 1, -6),
        Size = UDim2.new(1, 0, 0, 84)
    })

    Fx.shine(v31, 2.6, 0.4)
    Fx.ping(v31, Style.YELLOW, 1.8)
    Fx.breathe(v31, 0.04, 3.2)
    p11(function() -- line: 305
        -- upvalues: ExclusivePack (copy), v29 (copy), v30 (copy), Robux (copy)
        local v33 = math.floor((1 - Robux.price(ExclusivePack.Key) / ExclusivePack.Worth) * 100 + 0.5)

        v29.Visible = v33 >= 10
        v29.Top.Text = ("-%*%%"):format(v33)
        v30.Text = ("Worth <font color=\"#FF5A5A\"><s>%*</s></font> Robux!"):format(ExclusivePack.Worth)
    end)
end

local function gift(p12, p13, p14) -- line: 316
    -- upvalues: Format (copy), Products (copy), Remotes (copy), Kit (copy), Style (copy), Fx (copy), LocalPlayer (copy), Left (copy)
    local FreeGift = Products.FreeGift
    local v34 = Style.row(p12, 150, p13)
    local v35 = Style.card(v34, Style.SEAFOAM, {
        Name = "FreeGift",
        Size = UDim2.fromScale(1, 1)
    })

    Style.polish(v35)
    v35.UIStroke.Thickness = 6
    Fx.turn(Style.gradient(v35.UIStroke, ColorSequence.new(Style.YELLOW, Color3.new(1, 1, 1)), 0), 120)
    Fx.sparkles(v35, 6, Style.YELLOW, 26, 2)

    local v36 = Style.bubble(v35, "🎁", {
        ZIndex = 3,
        Position = UDim2.fromOffset(20, 15),
        Size = UDim2.fromOffset(120, 120)
    })

    Fx.wiggle(v36, 10, 1.8)

    local v37 = Style.text(v35, "YOUR FREE GIFT IS READY!", {
        StrokeThickness = 5,
        ZIndex = 3,
        Position = UDim2.fromOffset(156, 18),
        Size = UDim2.fromOffset(640, 62),
        TextXAlignment = Left
    })

    Style.gradient(v37, ColorSequence.new(Style.YELLOW, Style.GOLD))

    local v38 = Style.text(v35, "", {
        ZIndex = 3,
        Position = UDim2.fromOffset(158, 88),
        Size = UDim2.fromOffset(640, 40),
        TextXAlignment = Left
    })
    local v39 = Kit.button(v35, "CLAIM!", Style.BUY, {
        Name = "Claim",
        ZIndex = 3,
        AnchorPoint = Vector2.new(1, 0.5),
        Position = UDim2.new(1, -32, 0.5, 0),
        Size = UDim2.fromOffset(300, 92)
    }, function() -- line: 346
        -- upvalues: Remotes (copy)
        Remotes.ClaimFreeGift:FireServer()
    end)

    v39.Label.ZIndex = 5
    Style.dress(v39, 12)
    Fx.shine(v39, 2)
    Fx.ping(v39, Style.YELLOW, 1.3)
    Fx.breathe(v39, 0.05, 4)
    p14(function() -- line: 354
        -- upvalues: FreeGift (copy), v34 (copy), v38 (copy), Format (copy), Products (copy), LocalPlayer (copy)
        local v40 = Products.scaled(LocalPlayer:GetAttribute("Income") or 0, FreeGift.CashMinutes, FreeGift.CashMin)

        v38.Text = ("<font color=\"#96FFAA\">%* Cash</font>"):format((Format.money(v40)))
        v34.Visible = workspace:GetServerTimeNow() >= (LocalPlayer:GetAttribute("FreeGiftReady") or 1e999)
    end)
end

function t1.build(p15, p16, p17) -- line: 362
    -- upvalues: Products (copy), Style (copy), Packs (copy), hero (copy), exclusivePack (copy), gift (copy)
    gift(p15, p16, p17)
    Packs.build(p15, p16 + 1, p17)
    Style.title(p15, "LIMITED ANIMALS", Style.CORAL, p16 + 2)
    hero(p15, p16 + 3, Products.Mermaid)
    hero(p15, p16 + 4, Products.Kraken)
    exclusivePack(p15, p16 + 5, p17)

    return p16 + 6
end

return t1
