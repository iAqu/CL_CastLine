-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Animals = require(ReplicatedStorage.Shared.Animals)
local Format = require(ReplicatedStorage.Shared.Format)
local Products = require(ReplicatedStorage.Shared.Products)
local Config = require(ReplicatedStorage.Shared.Config)
local UIUtil = require(script.Parent.Parent.UI.UIUtil)
local Kit = require(script.Parent.Parent.MiniGames.Kit)
local Robux = require(script.Parent.Robux)
local Style = require(script.Parent.Style)
local Fx = require(script.Parent.Fx)
local StarterPack = require(script.Parent.StarterPack)
local LocalPlayer = Players.LocalPlayer
local t1 = {}
local Left = Enum.TextXAlignment.Left

local function minutes(p1) -- line: 24
    if p1 >= 3600 then
        return (`{ p1 / 3600 }h`)
    end

    return (`{ p1 // 60 }m`)
end

local function potionText(p2) -- line: 29
    -- upvalues: Products (copy)
    local t2 = {}

    for _, v1 in Products.PackPotions do
        local v2 = p2[v1.Stat]

        if v2 then
            t2[v2] = t2[v2] or {}
            table.insert(t2[v2], v1.Stat)
        end
    end

    local t3 = {}

    for v4, v5 in t2 do
        table.insert(t3, (("2x %* · %*"):format(table.concat(v5, ", "), if v4 >= 3600 then ("%*h"):format(v4 / 3600) else ("%*m"):format(v4 // 60))))
    end

    return table.concat(t3, " / ")
end

local function exclusiveName(p3) -- line: 45
    -- upvalues: Animals (copy)
    return Animals.displayName({
        Id = p3.Id
    })
end

local function exclusiveByKey(p4) -- line: 49
    -- upvalues: Products (copy)
    for _, v7 in Products.Exclusives do
        if v7.Key == p4 then
            return v7
        end
    end

    return nil
end

local function bought(p5) -- line: 59
    -- upvalues: LocalPlayer (copy)
    return table.find(string.split(LocalPlayer:GetAttribute("PacksBought") or "", ","), p5) ~= nil
end

local function worth(p6, p7, p8) -- line: 65
    -- upvalues: Products (copy), Robux (copy)
    local v8 = p7[1]

    for _, v9 in p7 do
        if Products.scaled(p8, v9.Minutes, v9.Min) <= p6 then
            v8 = v9
        end
    end

    return p6 / math.max(Products.scaled(p8, v8.Minutes, v8.Min), 1) * Robux.price(v8.Key)
end

local function packWorth(p9) -- line: 76
    -- upvalues: Products (copy), Robux (copy), LocalPlayer (copy), worth (copy)
    local v11 = LocalPlayer:GetAttribute("Income") or 0
    local v12 = LocalPlayer:GetAttribute("StrengthRate") or 0
    local v13 = worth(Products.packCash(p9, v11), Products.CashPacks, v11) + worth(Products.packStrength(p9, v12), Products.StrengthPacks, v12)

    for _, v14 in Products.Potions do
        local v15 = p9.Potions[v14.Stat]

        if v15 then
            v13 += v15 / Products.PotionTime * Robux.price(v14.Key)
        end
    end

    if p9.Exclusive and not Robux.soldOut(p9.Exclusive) then
        v13 += Robux.price(p9.Exclusive)
    end

    return v13
end

local function times(p10) -- line: 93
    if p10 >= 3 then
        return (("x%*"):format((math.floor(p10))))
    end

    return (`x{ math.floor(p10 * 10) / 10 }`)
end

local function recommended() -- line: 99
    -- upvalues: Products (copy), LocalPlayer (copy)
    local v17 = LocalPlayer:GetAttribute("Income") or 0

    for v18, v19 in Products.Packs do
        local Key = v19.Key

        if table.find(string.split(LocalPlayer:GetAttribute("PacksBought") or "", ","), Key) == nil and (not v19.Cash or v19.Cash >= v17 * 600) then
            return v18
        end
    end

    return nil
end

local t4 = {
    StarterPack = Style.SEAFOAM,
    MediumPack = Style.TEAL,
    ProPack = Style.ABYSS
}

local function animalText(p11) -- line: 114
    -- upvalues: Animals (copy), Config (copy)
    local v20 = Animals.get(p11)

    if v20.Exclusive then
        return (("%* <font color=\"#FFE25A\">(%*x your best!)</font>"):format(v20.Name, v20.Mult))
    end

    local v21 = Config.RarityByName[v20.Rarity]

    return (("%* <font color=\"#%*\">(%*)</font>"):format(v20.Name, v21.Color:ToHex(), v20.Rarity))
end

local function chip(p12, p13, p14, p15, p16) -- line: 124
    -- upvalues: Kit (copy), Style (copy), Left (copy)
    local v22 = (p13 - 1) % 2
    local v23 = (p13 - 1) // 2
    local v24 = Kit.frame(p12, {
        Name = "Item",
        BackgroundTransparency = 1,
        ZIndex = 3,
        Position = UDim2.fromOffset(v22 * 386 + 406, v23 * 62 + 134),
        Size = UDim2.fromOffset(374, 54)
    })
    local ImageLabel

    if p16:find("rbxasset") then
        ImageLabel = Instance.new("ImageLabel")
        ImageLabel.Image = p16
        ImageLabel.ScaleType = Enum.ScaleType.Fit
    else
        ImageLabel = Instance.new("TextLabel")
        ImageLabel.Text = p16
        ImageLabel.TextScaled = true
    end

    ImageLabel.BackgroundTransparency = 1
    ImageLabel.Position = UDim2.fromOffset(8, 5)
    ImageLabel.Size = UDim2.fromOffset(44, 44)
    ImageLabel.ZIndex = 4
    ImageLabel.Parent = v24

    return (Style.text(v24, p14, {
        ZIndex = 4,
        StrokeThickness = 4,
        Position = UDim2.fromOffset(60, 9),
        Size = UDim2.new(1, -70, 0, 36),
        TextXAlignment = Left,
        TextColor3 = p15
    }))
end

function t1.build(p17, p18, p19) -- line: 160
    -- upvalues: Animals (copy), Format (copy), Products (copy), Config (copy), UIUtil (copy), Kit (copy), Robux (copy), Style (copy), Fx (copy), StarterPack (copy), LocalPlayer (copy), Left (copy), potionText (copy), packWorth (copy), recommended (copy), t4 (copy), chip (copy)
    local v25 = Style.row(p17, 410, p18)
    local t5 = {}
    local n1 = 0
    local v26 = false

    for v27, v28 in Products.Packs do
        local v29 = t4[v28.Key] or Style.TEAL
        local v30 = Style.card(v25, v29, {
            Visible = false,
            Name = v28.Key,
            Size = UDim2.fromScale(1, 1)
        })

        Style.polish(v30)

        if v28.Key == "ProPack" then
            v30.UIStroke.Thickness = 6
            Fx.turn(Style.gradient(v30.UIStroke, Style.RAINBOW, 0), 90)
        end

        Fx.sparkles(v30, 7, Color3.new(1, 1, 1), 26, 2)

        local v31, v32 = StarterPack.bundle(v30, 370, v28.Key)

        v31.Position = UDim2.fromOffset(14, 20)

        local v33 = Style.seal(v30, "", "VALUE", {
            Name = "Value",
            ZIndex = 8,
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.fromOffset(308, 74),
            Size = UDim2.fromOffset(128, 128)
        })

        Fx.wiggle(v33, 8, 2.8, v27)

        local v34 = Style.tag(v30, "ONE TIME ONLY!", Style.CORAL, {
            Rotation = -6,
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.fromOffset(132, 16),
            Size = UDim2.fromOffset(220, 50)
        })

        Fx.wiggle(v34, 5, 3.4, v27 * 0.7)

        local v35 = Style.text(v30, string.upper(v28.Name), {
            StrokeThickness = 6,
            ZIndex = 3,
            Position = UDim2.fromOffset(404, 18),
            Size = UDim2.fromOffset(560, 72),
            TextXAlignment = Left
        })

        if v28.Key == "ProPack" then
            Style.gradient(v35, Style.RAINBOW, 0)
        else
            Style.gradient(v35, ColorSequence.new(Style.YELLOW, Style.GOLD))
        end

        local v36 = Style.text(v30, "", {
            Name = "Worth",
            ZIndex = 3,
            Position = UDim2.fromOffset(406, 90),
            Size = UDim2.fromOffset(740, 34),
            TextXAlignment = Left,
            TextColor3 = Style.SAND
        })
        local v37 = chip(v30, 1, "", Style.MINT, Config.Icons.Cash)
        local v38 = chip(v30, 2, "", Style.SAND, Config.Icons.Strength)

        chip(v30, 3, potionText(v28.Potions), Color3.fromRGB(215, 180, 255), Products.Potions[1].Image)

        local Animal = v28.Animal
        local v39 = Animals.get(Animal)
        local v40

        if v39.Exclusive then
            v40 = ("%* <font color=\"#FFE25A\">(%*x your best!)</font>"):format(v39.Name, v39.Mult)
        else
            local v41 = Config.RarityByName[v39.Rarity]

            v40 = ("%* <font color=\"#%*\">(%*)</font>"):format(v39.Name, v41.Color:ToHex(), v39.Rarity)
        end

        chip(v30, 4, v40, Color3.new(1, 1, 1), "🐟")

        local Exclusive = v28.Exclusive
        local v42

        if Exclusive then
            local Exclusive = v28.Exclusive
            local v43 = false

            for _, v44 in Products.Exclusives do
                if v44.Key == Exclusive then
                    v42 = v44
                    v43 = true
                    break
                end
            end

            if not v43 then
                v42 = nil
            end
        else
            v42 = Exclusive
        end

        if v42 then
            local v45 = chip(v30, 5, Animals.displayName({
                Id = v42.Id
            }) .. " <font color=\"#FFE25A\">(Limited)</font>", Style.YELLOW, "🐉")
            local v46 = v42

            local function check() -- line: 234
                -- upvalues: v45 (copy), v46 (copy), Robux (copy)
                v45.Parent.Visible = not Robux.soldOut(v46.Key)
            end

            workspace:GetAttributeChangedSignal("Left_" .. v42.Key):Connect(check)
            v45.Parent.Visible = not Robux.soldOut(v42.Key)
        end

        local v47 = Style.price(v30, v28.Key, {
            ZIndex = 4,
            AnchorPoint = Vector2.new(0, 1),
            Position = UDim2.new(0, 406, 1, -22),
            Size = UDim2.fromOffset(420, 88)
        })

        Fx.shine(v47, 2.6, v27 * 0.4)
        Fx.ping(v47, Style.YELLOW, 1.8)
        Fx.breathe(v47, 0.04, 3.2)

        local v48 = Kit.text(v30, "OWNED ✔", {
            Name = "Owned",
            ZIndex = 4,
            Visible = false,
            AnchorPoint = Vector2.new(0, 1),
            Position = UDim2.new(0, 406, 1, -30),
            Size = UDim2.fromOffset(420, 66),
            TextColor3 = Style.MINT
        })
        local v49 = Kit.frame(v30, {
            Name = "Nav",
            BackgroundTransparency = 1,
            ZIndex = 4,
            AnchorPoint = Vector2.new(1, 1),
            Position = UDim2.new(1, -24, 1, -30),
            Size = UDim2.fromOffset(300, 70)
        })

        for v50, v51 in {
                [-1] = -1,
                [1] = 1
            } do
            local v53 = Kit.button(v49, if v51 < 0 then "<" else ">", Style.DEEP, {
                ZIndex = 5,
                Name = v51 < 0 and "Back" or "Next",
                AnchorPoint = Vector2.new(0.5, 0.5),
                Position = UDim2.new(v50 < 0 and 0 or 1, v50 < 0 and 35 or -35, 0.5, 0),
                Size = UDim2.fromOffset(66, 66)
            }, function() -- line: 274
                -- upvalues: t5 (copy), n1 (ref), v26 (ref), v51 (copy), UIUtil (copy)
                v26 = true

                local v54 = (n1 + v51 - 1) % #t5 + 1

                if v54 == n1 then
                    return
                end

                n1 = v54

                for v55, v56 in t5 do
                    v56.Visible = v55 == v54
                end

                UIUtil.pop(t5[v54], 0.9)
            end)

            v53.Label.ZIndex = 6
            v53.UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        end

        for i = 1, #Products.Packs do
            local v57 = Kit.frame(v49, {
                ZIndex = 5,
                AnchorPoint = Vector2.new(0.5, 0.5),
                Position = UDim2.new(0.5, (i - (#Products.Packs + 1) / 2) * 34, 0.5, 0),
                Size = UDim2.fromOffset(i == v27 and 26 or 18, i == v27 and 26 or 18),
                BackgroundColor3 = if i == v27 then Style.YELLOW else Color3.new(1, 1, 1),
                BackgroundTransparency = i == v27 and 0 or 0.5
            })

            Kit.corner(v57, 13)
            Kit.stroke(v57, 3)
        end

        t5[v27] = v30
        p19(function() -- line: 294
            -- upvalues: v28 (copy), v32 (copy), v33 (copy), v34 (copy), v36 (copy), v37 (copy), v38 (copy), v47 (copy), v48 (copy), Format (copy), Products (copy), Robux (copy), LocalPlayer (copy), packWorth (copy)
            local v58 = LocalPlayer:GetAttribute("Income") or 0
            local v59 = LocalPlayer:GetAttribute("StrengthRate") or 0

            v37.Text = Format.money(Products.packCash(v28, v58)) .. " Cash"
            v38.Text = Format.short(Products.packStrength(v28, v59)) .. " XP"
            v32()

            local v60 = packWorth(v28)
            local v61 = v60 / Robux.price(v28.Key)

            v33.Visible = v61 >= 1.3

            local Top = v33.Top

            if v61 >= 3 then
                Top.Text = ("x%*"):format((math.floor(v61)))
            else
                Top.Text = `x{ math.floor(v61 * 10) / 10 }`
            end

            v36.Text = ("Worth <font color=\"#FFE25A\">%* Robux</font> if you bought it all separately!"):format((Format.short((math.floor(v60)))))

            local Key = v28.Key
            local v63 = table.find(string.split(LocalPlayer:GetAttribute("PacksBought") or "", ","), Key) ~= nil

            v47.Visible = not v63
            v48.Visible = v63
            v34.Visible = not v63
        end)
    end

    p19(function() -- line: 311
        -- upvalues: t5 (copy), n1 (ref), v26 (ref), recommended (copy)
        if v26 then
            return
        end

        local v64 = ((recommended() or #t5) - 1) % #t5 + 1

        if v64 == n1 then
            return
        end

        n1 = v64

        for v65, v66 in t5 do
            v66.Visible = v65 == v64
        end
    end)
end

return t1
