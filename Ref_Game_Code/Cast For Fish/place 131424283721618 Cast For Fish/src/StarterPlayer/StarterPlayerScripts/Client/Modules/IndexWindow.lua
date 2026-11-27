-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Shared = ReplicatedStorage:WaitForChild("Shared")
local Fish = require(Shared.Data.Fish)
local Zones = require(Shared.Data.Zones)
local Rarities = require(Shared.Data.Rarities)
local Variants = require(Shared.Data.Variants)
local Products = require(Shared.Data.Products)
local NumberFormat = require(Shared.NumberFormat)
local GameConfig = require(Shared.GameConfig)
local RunService = game:GetService("RunService")
local UIKit = require(script.Parent.UIKit)
local DataClient = require(script.Parent.DataClient)
local IndexIcons = require(script.Parent.IndexIcons)
local FishModels = require(Shared.FishModels)
local Colors = UIKit.Colors
local fromRGB = Color3.fromRGB
local v1 = Vector2.new(0.5, 0.5)
local Left = Enum.TextXAlignment.Left
local t2 = {}
local t3 = {}
local t4 = {}
local t5 = {}
local v2 = fromRGB(14, 18, 42)
local v3 = fromRGB(255, 214, 70)
local v4 = ColorSequence.new(fromRGB(160, 250, 80), fromRGB(40, 190, 40))
local v5 = ColorSequence.new(fromRGB(255, 236, 110), fromRGB(255, 160, 30))
local t6 = {
    1, 2, 6, 7, 3, 4, 5
}
local t1 = {}

t1.Found = 0
t1.VariantsFound = 0

local function limitText(p1, p2, p3) -- line: 45
    local UITextSizeConstraint = Instance.new("UITextSizeConstraint")

    UITextSizeConstraint.MaxTextSize = p2
    UITextSizeConstraint.MinTextSize = p3 or 8
    UITextSizeConstraint.Parent = p1
    p1.TextScaled = true
end

local function refresh(p4) -- line: 53
    -- upvalues: Fish (copy), Variants (copy), NumberFormat (copy), UIKit (copy), t1 (copy), Colors (copy), t2 (copy), t3 (copy), t4 (ref), t5 (copy), v2 (copy), v3 (copy), v4 (copy), v5 (copy), t6 (copy)
    p4 = p4 or {}

    local t7 = {}
    local n1 = 0
    local n2 = 0
    local n3 = 0
    local n4 = 0

    for _, v7 in ipairs(Fish.List) do
        n1 += 1

        local v8 = p4[v7.id]
        local v9 = t2[v7.id]

        if v8 then
            n2 += 1
            t7[v7.zone] = (t7[v7.zone] or 0) + 1
        end

        local v10

        if not (v9 and v9.noVariants) then
            n4 += #t6
            v10 = 0

            if v8 and v8.v then
                for _, v11 in ipairs(t6) do
                    if v8.v[tostring(v11)] then
                        v10 += 1
                    end
                end
            end
        else
            v10 = 0
        end

        n3 += v10

        if v9 then
            local found = v9.found

            v9.found = v8 ~= nil

            local name = v9.name

            if v8 then
                name.Text = v7.name
            else
                name.Text = "???"
            end

            if v9.icon then
                local icon = v9.icon

                if v8 then
                    icon.ImageColor3 = Color3.new(1, 1, 1)
                else
                    icon.ImageColor3 = Color3.new(0, 0, 0)
                end
            end

            v9.info.Text = v9.rarity.name .. "  -  " .. (if not v8 then "???" elseif v9.oddsText then v9.oddsText else NumberFormat.odds(v7.odds))
            v9.badge.Visible = v8 ~= nil

            local count = v9.count

            if v8 then
                count.Text = "x" .. NumberFormat.abbr(v8.n)
            else
                count.Text = ""
            end

            v9.lock.Visible = v8 == nil

            for _, v12 in ipairs(v9.twinkles) do
                v12.Visible = v8 ~= nil
            end

            v9.glow.ImageTransparency = v8 and 0.35 or 0.72

            local gradient = v9.gradient

            if v8 then
                gradient.Color = ColorSequence.new(v9.rarity.Color, v9.rarity.Color2)
            else
                gradient.Color = ColorSequence.new(v9.rarity.Color:Lerp(v2, 0.62), v9.rarity.Color2:Lerp(v2, 0.74))
            end

            for v13, v14 in ipairs(t6) do
                local v15 = v9.gems[v13]
                local v16 = v8 ~= nil and v8.v ~= nil and v8.v[tostring(v14)] == true

                if v16 then
                    v15.BackgroundColor3 = Variants.List[v14].Color
                else
                    v15.BackgroundColor3 = v2
                end

                v15.BackgroundTransparency = v16 and 0 or 0.35
            end

            local v17 = v10 == #t6
            local stroke = v9.stroke

            if v17 then
                stroke.Color = v3
            else
                stroke.Color = Colors.Outline
            end

            v9.star.Visible = v17

            if v9.found and found == false then
                UIKit.pop(v9.frame, 1.15)
            end
        end
    end

    for v18, v19 in pairs(t3) do
        local v20 = t7[v18] or 0
        local v21 = v19.total <= v20

        v19.label.Text = v20 .. "/" .. v19.total
        v19.fill.Size = UDim2.new(math.clamp(v20 / v19.total, 0, 1), 0, 1, 0)
        v19.fill.Visible = v20 > 0

        local gradient = v19.gradient

        if v21 then
            gradient.Color = v5
        else
            gradient.Color = v4
        end

        v19.trophy.Visible = v21
    end

    if t5.zoneId then
        local v23 = t7[t5.zoneId] or 0
        local total = t5.total

        t5.label.Text = v23 .. "/" .. total
        t5.fill.Size = UDim2.new(math.clamp(v23 / total, 0, 1), 0, 1, 0)
        t5.fill.Visible = v23 > 0

        local gradient = t5.gradient

        if total <= v23 then
            gradient.Color = v5
        else
            gradient.Color = v4
        end
    end

    t1.Found = n2
    t1.VariantsFound = n3

    if t4.label then
        local v25 = if n1 > 0 then n2 / n1 else 0

        t4.label.Text = n2 .. " / " .. n1 .. " fish"
        t4.fill.Size = UDim2.new(math.clamp(v25, 0, 1), 0, 1, 0)
        t4.fill.Visible = n2 > 0

        local gradient = t4.gradient

        if n1 <= n2 then
            gradient.Color = v5
        else
            gradient.Color = v4
        end

        t4.percent.Text = (if not (v25 > 0 and v25 < 0.01) then tostring((math.floor(v25 * 100))) else "<1") .. "%"
        t4.variants.Text = NumberFormat.abbr(n3) .. " / " .. NumberFormat.abbr(n4)
    end
end

local function artModel(p5, p6) -- line: 142
    -- upvalues: ReplicatedStorage (copy)
    local Assets = ReplicatedStorage:FindFirstChild("Assets")
    local v29 = Assets and Assets:FindFirstChild(p5)

    return v29 and v29:FindFirstChild(p6)
end

local function chip(p7, p8, p9, p10, p11, p12) -- line: 149
    -- upvalues: UIKit (copy), fromRGB (copy)
    local v31 = UIKit.frame(p7, {
        Transparency = 0.45,
        Name = p8,
        Size = p9,
        Position = p10,
        AnchorPoint = p11,
        Color = fromRGB(8, 10, 28),
        Corner = math.floor(p9.Y.Offset / 2),
        ZIndex = p12
    })

    return v31, (UIKit.text(v31, {
        Name = "Label",
        Text = "",
        Stroke = 3,
        Size = UDim2.new(1, -14, 1, -6),
        Position = UDim2.fromOffset(7, 3),
        ZIndex = p12 + 1
    }))
end

local function progressBar(p13, p14, p15, p16, p17, p18, p19) -- line: 156
    -- upvalues: UIKit (copy), Colors (copy), fromRGB (copy)
    local v32 = UIKit.frame(p13, {
        Corner = 12,
        Stroke = 4,
        Name = p14,
        Size = p15,
        Position = p16,
        AnchorPoint = p17,
        Color = fromRGB(12, 14, 36),
        ZIndex = p18
    })
    local v33 = UIKit.frame(v32, {
        Name = "Fill",
        Corner = 12,
        Size = UDim2.new(0, 0, 1, 0),
        Color = fromRGB(160, 250, 80),
        Color2 = fromRGB(40, 190, 40),
        ZIndex = p18
    })

    UIKit.frame(v33, {
        Name = "Shine",
        Transparency = 0.55,
        Corner = 3,
        Size = UDim2.new(1, -14, 0, 6),
        Position = UDim2.fromOffset(7, 4),
        Color = Colors.White,
        ZIndex = p18
    })

    return v32, v33, UIKit.text(v32, {
        Name = "Count",
        Text = "",
        Stroke = 4,
        TextSize = p19,
        ZIndex = p18 + 2
    }), v33:FindFirstChildOfClass("UIGradient")
end

local function fishCard(p20, p21, p22, p23, p24, p25, p26) -- line: 164
    -- upvalues: Rarities (copy), Variants (copy), UIKit (copy), Colors (copy), v1 (copy), t2 (copy), v2 (copy), v3 (copy), t6 (copy), chip (copy)
    local v34 = Rarities.ById[p21.rarity]
    local v35 = UIKit.frame(p20, {
        Corner = 16,
        Stroke = 5,
        ZIndex = 12,
        Name = p21.id,
        Size = UDim2.fromOffset(p24, 236),
        Position = UDim2.fromOffset(p22 + p24 / 2, p23 + 118),
        AnchorPoint = v1,
        Color = v34.Color,
        Color2 = v34.Color2
    })
    local v36 = UIKit.image(v35, "Glow", {
        Transparency = 0.35,
        ZIndex = 12,
        Size = UDim2.fromOffset(226.56, 226.56),
        Position = UDim2.new(0.5, 0, 0, 112),
        AnchorPoint = v1
    })
    local v37 = UIKit.frame(v35, {
        Name = "Bevel",
        Transparency = 1,
        Corner = 13,
        ZIndex = 12,
        Size = UDim2.new(1, -8, 1, -8),
        Position = UDim2.fromOffset(4, 4)
    })
    local UIStroke = Instance.new("UIStroke")

    UIStroke.Thickness = 2
    UIStroke.Color = Colors.White
    UIStroke.Transparency = 0.6
    UIStroke.Parent = v37
    UIKit.frame(v35, {
        Name = "Shine",
        Transparency = 0.62,
        Corner = 4,
        ZIndex = 12,
        Size = UDim2.new(1, -24, 0, 7),
        Position = UDim2.fromOffset(12, 8),
        Color = Colors.White
    })

    local v38 = UIKit.text(v35, {
        Name = "FishName",
        Text = "???",
        Stroke = 5,
        ZIndex = 15,
        Size = UDim2.new(1, -20, 0, 36),
        Position = UDim2.fromOffset(10, 15)
    })
    local UITextSizeConstraint = Instance.new("UITextSizeConstraint")

    UITextSizeConstraint.MaxTextSize = 32
    UITextSizeConstraint.MinTextSize = 12
    UITextSizeConstraint.Parent = v38
    v38.TextScaled = true

    local v39 = UIKit.frame(v35, {
        Name = "Picture",
        Transparency = 1,
        ZIndex = 13,
        Size = UDim2.new(1, -24, 0, 112),
        Position = UDim2.new(0.5, 0, 0, 112),
        AnchorPoint = v1
    })
    local v40, v41 = chip(v35, "Caught", UDim2.fromOffset(64, 28), UDim2.new(1, -9, 0, 52), Vector2.new(1, 0), 15)

    v41.TextSize = 20
    v41.TextScaled = false

    local v42 = UIKit.image(v35, "Lock", {
        ZIndex = 16,
        Rotation = 8,
        Size = UDim2.fromOffset(52, 52),
        Position = UDim2.new(1, -6, 0, 48),
        AnchorPoint = Vector2.new(1, 0)
    })
    local v43 = UIKit.image(v35, "Sparkle", {
        ZIndex = 17,
        Size = UDim2.fromOffset(44, 44),
        Position = UDim2.fromOffset(4, 2),
        AnchorPoint = v1,
        Color = v3
    })
    local t9 = {}

    if v34.order >= 5 then
        for v44, v45 in ipairs({
                { 0.14, 0.34, 26 },
                { 0.84, 0.62, 20 }
            }) do
            local v46 = UIKit.image(v35, "Sparkle", {
                ZIndex = 14,
                Size = UDim2.fromOffset(v45[3], v45[3]),
                Position = UDim2.fromScale(v45[1], v45[2]),
                AnchorPoint = v1,
                Rotation = v44 * 14
            })

            v46.Visible = false
            t9[v44] = v46
        end
    end

    local v47 = UIKit.frame(v35, {
        Name = "Variants",
        Transparency = 1,
        ZIndex = 14,
        Size = UDim2.new(1, 0, 0, 20),
        Position = UDim2.new(0, 0, 0, 174)
    })

    v47.Visible = not p26

    local t10 = {}

    for i = 1, #t6 do
        local v48 = UIKit.frame(v47, {
            Corner = 3,
            Stroke = 2,
            ZIndex = 14,
            Name = Variants.List[t6[i]].id,
            Size = UDim2.fromOffset(15, 15),
            Position = UDim2.new(0.5, (i - (#t6 + 1) / 2) * 25, 0.5, 0),
            AnchorPoint = v1,
            Color = v2
        })

        v48.Rotation = 45
        t10[i] = v48
    end

    local _, v49 = chip(v35, "Info", UDim2.new(1, -18, 0, 30), UDim2.new(0, 9, 1, -9), Vector2.new(0, 1), 14)
    local UITextSizeConstraint2 = Instance.new("UITextSizeConstraint")

    UITextSizeConstraint2.MaxTextSize = 19
    UITextSizeConstraint2.MinTextSize = 9
    UITextSizeConstraint2.Parent = v49
    v49.TextScaled = true

    local v50 = UIKit.scaleOf(v35)

    v35.MouseEnter:Connect(function() -- line: 213
        -- upvalues: v35 (copy), v50 (copy), UIKit (copy)
        v35.ZIndex = 13
        UIKit.tween(v50, 0.12, {
            Scale = 1.05
        })
    end)
    v35.MouseLeave:Connect(function() -- line: 217
        -- upvalues: v35 (copy), v50 (copy), UIKit (copy)
        v35.ZIndex = 12
        UIKit.tween(v50, 0.12, {
            Scale = 1
        })
    end)
    t2[p21.id] = {
        frame = v35,
        name = v38,
        holder = v39,
        info = v49,
        badge = v40,
        count = v41,
        lock = v42,
        star = v43,
        glow = v36,
        gems = t10,
        twinkles = t9,
        rarity = v34,
        oddsText = p25,
        noVariants = p26 == true,
        gradient = v35:FindFirstChildOfClass("UIGradient"),
        stroke = v35:FindFirstChildOfClass("UIStroke")
    }
end

local function place(p27, p28, p29, p30, p31) -- line: 228
    -- upvalues: v1 (copy)
    p27.Size = UDim2.fromOffset(p30, p31)
    p27.Position = UDim2.fromOffset(p28 + p30 / 2, p29 + p31 / 2)
    p27.AnchorPoint = v1
end

function t1.Init() -- line: 234
    -- upvalues: ReplicatedStorage (copy), Shared (copy), Fish (copy), Zones (copy), Products (copy), GameConfig (copy), RunService (copy), UIKit (copy), DataClient (copy), IndexIcons (copy), FishModels (copy), Colors (copy), fromRGB (copy), v1 (copy), Left (copy), t2 (copy), t3 (copy), t4 (ref), refresh (copy), chip (copy), progressBar (copy), fishCard (copy)
    IndexIcons.Preload()

    local Index = UIKit.Windows.Index
    local Content = Index.Content
    local v51 = Content.Size.X.Offset + Index.Frame.Size.X.Offset

    UIKit.icon(Index.Frame, "Index", {
        ZIndex = 14,
        Rotation = -8,
        Size = UDim2.fromOffset(92, 92),
        Position = UDim2.fromOffset(8, -12)
    })

    local Title = Index.Frame:FindFirstChild("Title")

    if Title then
        Title.Position = UDim2.fromOffset(104, 0)
    end

    local v52 = UIKit.frame(Content, {
        Name = "IndexBody",
        Transparency = 1,
        ZIndex = 11,
        Size = UDim2.fromScale(1, 1)
    })
    local UIScale = Instance.new("UIScale")

    UIScale.Name = "PhoneScale"
    UIScale.Parent = v52

    local v53 = UIKit.frame(v52, {
        Name = "Summary",
        Corner = 18,
        Stroke = 5,
        ZIndex = 12,
        Size = UDim2.new(1, 0, 0, 100),
        Color = fromRGB(84, 110, 220),
        Color2 = fromRGB(36, 42, 104)
    })

    UIKit.dress(v53, 18, fromRGB(190, 214, 255))
    UIKit.image(v53, "Glow", {
        Transparency = 0.45,
        ZIndex = 13,
        Size = UDim2.fromOffset(190, 190),
        Position = UDim2.new(0, 62, 0, 50),
        AnchorPoint = v1,
        Color = fromRGB(255, 240, 170)
    })
    UIKit.image(v53, "Trophy", {
        ZIndex = 14,
        Rotation = -6,
        Size = UDim2.fromOffset(96, 96),
        Position = UDim2.new(0, 62, 0, 50),
        AnchorPoint = v1
    })
    UIKit.text(v53, {
        Name = "Title",
        Text = "YOUR COLLECTION",
        TextSize = 24,
        Stroke = 3,
        ZIndex = 14,
        Size = UDim2.fromOffset(400, 28),
        Position = UDim2.fromOffset(128, 10),
        XAlign = Left,
        Color = fromRGB(190, 214, 255)
    })

    local v54, v55, v56, v57 = progressBar(v53, "Total", UDim2.new(1, -500, 0, 44), UDim2.fromOffset(128, 44), nil, 14, 28)
    local v58 = UIKit.frame(v53, {
        Name = "Percent",
        Transparency = 0.45,
        Corner = 16,
        Stroke = 3,
        ZIndex = 14,
        Size = UDim2.fromOffset(150, 72),
        Color = fromRGB(8, 10, 28),
        StrokeColor = fromRGB(150, 180, 255)
    })

    v58:FindFirstChildOfClass("UIStroke").Transparency = 0.6

    local v59 = UIKit.text(v58, {
        Name = "Value",
        Text = "0%",
        TextSize = 38,
        Stroke = 4,
        ZIndex = 15,
        Size = UDim2.new(1, 0, 0, 40),
        Position = UDim2.fromOffset(0, 4),
        Color = fromRGB(170, 255, 120)
    })

    UIKit.text(v58, {
        Name = "Caption",
        Text = "COMPLETE",
        TextSize = 16,
        Stroke = 3,
        ZIndex = 15,
        Size = UDim2.new(1, 0, 0, 20),
        Position = UDim2.new(0, 0, 1, -24),
        Color = fromRGB(190, 214, 255)
    })

    local v60 = UIKit.frame(v53, {
        Name = "Variants",
        Transparency = 0.45,
        Corner = 16,
        Stroke = 3,
        ZIndex = 14,
        Size = UDim2.fromOffset(180, 72),
        Color = fromRGB(8, 10, 28),
        StrokeColor = fromRGB(150, 180, 255)
    })

    v60:FindFirstChildOfClass("UIStroke").Transparency = 0.6

    local v61 = UIKit.text(v60, {
        Name = "Value",
        Text = "0",
        TextSize = 28,
        Stroke = 4,
        ZIndex = 15,
        Size = UDim2.new(1, -8, 0, 40),
        Position = UDim2.fromOffset(4, 4),
        Color = fromRGB(255, 226, 110)
    })
    local UITextSizeConstraint = Instance.new("UITextSizeConstraint")

    UITextSizeConstraint.MaxTextSize = 28
    UITextSizeConstraint.MinTextSize = 14
    UITextSizeConstraint.Parent = v61
    v61.TextScaled = true
    UIKit.text(v60, {
        Name = "Caption",
        Text = "VARIANTS",
        TextSize = 16,
        Stroke = 3,
        ZIndex = 15,
        Size = UDim2.new(1, 0, 0, 20),
        Position = UDim2.new(0, 0, 1, -24),
        Color = fromRGB(190, 214, 255)
    })
    t4 = {
        fill = v55,
        label = v56,
        gradient = v57,
        percent = v59,
        variants = v61
    }

    local ScrollingFrame = Instance.new("ScrollingFrame")

    ScrollingFrame.Name = "Zones"
    ScrollingFrame.BackgroundTransparency = 1
    ScrollingFrame.BorderSizePixel = 0
    ScrollingFrame.Size = UDim2.new(1, 0, 1, -112)
    ScrollingFrame.Position = UDim2.fromOffset(0, 112)
    ScrollingFrame.ScrollBarThickness = 10
    ScrollingFrame.ScrollBarImageColor3 = fromRGB(140, 170, 255)
    ScrollingFrame.ScrollingDirection = Enum.ScrollingDirection.Y
    ScrollingFrame.CanvasSize = UDim2.new()
    ScrollingFrame.ZIndex = 11
    ScrollingFrame.Parent = v52

    local t11 = {}

    for _, v62 in ipairs(Zones.List) do
        local t12 = {
            id = v62.id,
            name = v62.name,
            color = v62.Color,
            order = v62.index,
            tag = "ZONE " .. v62.index
        }
        local id = v62.id
        local Assets = ReplicatedStorage:FindFirstChild("Assets")
        local ZoneIcons = Assets and Assets:FindFirstChild("ZoneIcons")

        t12.art = ZoneIcons and ZoneIcons:FindFirstChild(id)
        t12.startDistance = v62.startDistance
        table.insert(t11, t12)
    end

    local v63 = Products.Crates[1]
    local t13 = {}

    for _, v64 in ipairs(v63.pool) do
        t13[v64.fish] = v64.chance .. "% Shop"
    end

    local t14 = {
        id = "spirit",
        tag = "SHOP",
        bySlot = true,
        zoom = 0.8,
        noVariants = true,
        name = v63.name,
        color = fromRGB(255, 110, 130),
        order = #Zones.List + 1
    }
    local Assets = ReplicatedStorage:FindFirstChild("Assets")
    local Shop = Assets and Assets:FindFirstChild("Shop")

    t14.art = Shop and Shop:FindFirstChild("SpiritLantern")
    t14.oddsText = t13
    table.insert(t11, t14)

    local v65

    for _, v66 in ipairs(Products.Crates) do
        if v66.key == "CosmicEgg" then
            v65 = v66
        end
    end

    if v65 then
        local t15 = {}

        for _, v67 in ipairs(v65.pool) do
            t15[v67.fish] = v67.chance .. "% Event"
        end

        local function v68() -- line: 302
            -- upvalues: Shared (copy)
            return require(Shared.EggModels).Build("CosmicEgg", CFrame.new())
        end

        local ok, result = pcall(v68)

        table.insert(t11, {
            id = "cosmic",
            tag = "EVENT",
            bySlot = true,
            zoom = 0.7,
            noVariants = true,
            name = v65.name,
            color = fromRGB(110, 90, 255),
            order = #Zones.List + 2,
            art = if not ok then nil else result,
            oddsText = t15
        })
    end

    local GoldenHarvest = Products.CrateByKey("GoldenHarvest")

    if GoldenHarvest then
        local t17 = {}

        for _, v69 in ipairs(GoldenHarvest.pool) do
            t17[v69.fish] = v69.chance .. "% Limited"
        end

        local t18 = {
            id = "harvest",
            tag = "LIMITED",
            bySlot = true,
            zoom = 0.75,
            noVariants = true,
            name = string.gsub(GoldenHarvest.name, " ", utf8.char(160)),
            color = fromRGB(235, 140, 40),
            order = #Zones.List + 3
        }
        local Assets = ReplicatedStorage:FindFirstChild("Assets")
        local Shop = Assets and Assets:FindFirstChild("Shop")

        t18.art = Shop and Shop:FindFirstChild("GoldenHarvest")
        t18.oddsText = t17
        table.insert(t11, t18)
    end

    local t19 = {}
    local v70
    local t20 = {}

    local function reached(p32) -- line: 322
        -- upvalues: GameConfig (copy), DataClient (copy)
        if p32.startDistance == nil or p32.startDistance <= 0 then
            return true
        end

        return (DataClient.Get("CastPower") or 0) >= GameConfig.powerForDistance(p32.startDistance)
    end

    for _, v71 in ipairs(t11) do
        local v72 = table.clone(Fish.ByZone[v71.id] or {})

        table.sort(v72, function(p33, p34) -- line: 332
            -- upvalues: v71 (copy)
            if v71.bySlot then
                return p33.slot < p34.slot
            end

            return p33.odds < p34.odds
        end)

        local v73 = UIKit.frame(ScrollingFrame, {
            Transparency = 1,
            ZIndex = 11,
            Name = v71.id,
            Size = UDim2.fromOffset(100, 300)
        })
        local v74 = UIKit.frame(v73, {
            Name = "ZoneTile",
            Corner = 18,
            Stroke = 5,
            ZIndex = 12,
            Size = UDim2.fromOffset(240, 300),
            Color = v71.color:Lerp(Colors.White, 0.18),
            Color2 = v71.color:Lerp(fromRGB(0, 0, 20), 0.5)
        })
        local v75 = UIKit.backdrop(v74, 18, 12)

        UIKit.image(v75, "Glow", {
            Transparency = 0.4,
            ZIndex = 12,
            Size = UDim2.fromOffset(320, 320),
            Position = UDim2.new(0.5, 0, 0.55, 0),
            AnchorPoint = v1
        })

        local _, v76 = chip(v74, "Tag", UDim2.fromOffset(112, 30), UDim2.new(0.5, 0, 0, 12), Vector2.new(0.5, 0), 14)

        v76.Text = v71.tag
        v76.TextSize = 19
        v76.TextScaled = false

        local v77 = UIKit.text(v74, {
            Name = "Name",
            Stroke = 6,
            ZIndex = 14,
            Text = v71.name,
            Size = UDim2.new(1, -16, 0, 62),
            Position = UDim2.fromOffset(8, 46)
        })

        v77.TextWrapped = true

        local UITextSizeConstraint = Instance.new("UITextSizeConstraint")

        UITextSizeConstraint.MaxTextSize = 40
        UITextSizeConstraint.MinTextSize = 16
        UITextSizeConstraint.Parent = v77
        v77.TextScaled = true

        local v78 = UIKit.frame(v74, {
            Name = "Art",
            Transparency = 1,
            ZIndex = 13,
            Size = UDim2.new(1, -8, 0, 126),
            Position = UDim2.new(0.5, 0, 0, 112),
            AnchorPoint = Vector2.new(0.5, 0)
        })
        local _, v79, v80, v81 = progressBar(v74, "Progress", UDim2.new(1, -24, 0, 40), UDim2.new(0, 12, 1, -12), Vector2.new(0, 1), 14, 26)
        local v82 = UIKit.image(v74, "Trophy", {
            ZIndex = 16,
            Rotation = 12,
            Size = UDim2.fromOffset(70, 70),
            Position = UDim2.new(1, 8, 0, -10),
            AnchorPoint = Vector2.new(1, 0)
        })

        v82.Visible = false

        local v83 = UIKit.frame(v74, {
            Name = "Locked",
            Transparency = 0.42,
            Corner = 18,
            ZIndex = 17,
            Color = fromRGB(6, 8, 20)
        })

        UIKit.image(v83, "Lock", {
            ZIndex = 18,
            Size = UDim2.fromOffset(64, 64),
            Position = UDim2.new(0.5, 0, 0.5, -6),
            AnchorPoint = v1
        })
        v83.Visible = false
        t3[v71.id] = {
            fill = v79,
            label = v80,
            gradient = v81,
            trophy = v82,
            total = math.max(#v72, 1)
        }
        table.insert(t19, {
            built = false,
            zone = v71,
            pool = v72,
            row = v73,
            tile = v74,
            art = v78,
            lock = v83,
            cards = {},
            artMade = v71.art == nil
        })
    end

    local function refreshLocks() -- line: 360
        -- upvalues: t19 (copy), GameConfig (copy), DataClient (copy)
        for _, v85 in ipairs(t19) do
            local lock, zone = v85.lock, v85.zone

            lock.Visible = not (zone.startDistance == nil or zone.startDistance <= 0 or (DataClient.Get("CastPower") or 0) >= GameConfig.powerForDistance(zone.startDistance))
        end
    end

    local function placeSection(p35) -- line: 366
        -- upvalues: v1 (copy)
        local layout = p35.layout

        if layout then
            for v86, v87 in ipairs(p35.cards) do
                local v88 = (v86 - 1) % layout.cols
                local v90 = math.floor((v86 - 1) / layout.cols)
                local v91 = layout.zoneW + 14 + v88 * (layout.tileW + 10)
                local v92 = v90 * 246
                local tileW = layout.tileW

                v87.Size = UDim2.fromOffset(tileW, 236)
                v87.Position = UDim2.fromOffset(v91 + tileW / 2, v92 + 118)
                v87.AnchorPoint = v1
            end
        end
    end

    local function layoutRows(p36) -- line: 377
        -- upvalues: ScrollingFrame (copy), t19 (copy), placeSection (copy)
        local v93 = p36 - 16 - 10
        local v94 = if v93 < 760 then 180 else 240
        local v95 = v93 - v94 - 14
        local v98 = math.clamp(math.floor((v95 + 10) / 210), 1, 4)
        local n6 = 8

        for _, v99 in ipairs(t19) do
            local v100 = #v99.pool
            local v101 = if v98 ~= 4 then v98
                elseif v100 % 4 == 0 then v98
                elseif v100 % 3 == 0 then 3
                else v98
            local v103 = math.floor((v95 - (v101 - 1) * 10) / v101)
            local v106 = math.max(1, (math.ceil(v100 / v101)))
            local v108 = math.max(v106 * 236 + (v106 - 1) * 10, 300)

            v99.row.Position = UDim2.fromOffset(8, n6)
            v99.row.Size = UDim2.fromOffset(v93, v108)
            v99.tile.Size = UDim2.fromOffset(v94, v108)
            v99.art.Size = UDim2.new(1, -8, 0, (math.clamp(v108 - 174, 60, 260)))
            v99.art.Position = UDim2.new(0.5, 0, 0, math.max(0, (v108 - 174 - 260) / 2) + 112)
            v99.layout = {
                zoneW = v94,
                tileW = v103,
                cols = v101
            }
            placeSection(v99)
            n6 += v108 + 20
        end

        ScrollingFrame.CanvasSize = UDim2.fromOffset(0, n6)
    end

    local v111 = false

    local function placeTop() -- line: 405
        -- upvalues: ScrollingFrame (copy), v111 (ref)
        local v112 = if v111 then 80 else 100

        ScrollingFrame.Position = UDim2.fromOffset(0, v112 + 12)
        ScrollingFrame.Size = UDim2.new(1, 0, 1, -(v112 + 12))
    end

    local function layoutSummary(p37) -- line: 411
        -- upvalues: v53 (copy), v54 (copy), v58 (copy), v60 (copy), ScrollingFrame (copy), v111 (ref)
        v111 = p37 < 900

        local Trophy = v53:FindFirstChild("Trophy")
        local Glow = v53:FindFirstChild("Glow")
        local Title = v53:FindFirstChild("Title")

        if v111 then
            v53.Size = UDim2.new(1, 0, 0, 80)

            if Title then
                Title.Visible = false
            end

            if Trophy then
                Trophy.Position = UDim2.new(0, 44, 0, 40)
                Trophy.Size = UDim2.fromOffset(64, 64)
            end

            if Glow then
                Glow.Position = UDim2.new(0, 44, 0, 40)
                Glow.Size = UDim2.fromOffset(120, 120)
            end

            v54.Size = UDim2.new(1, -390, 0, 44)
            v54.Position = UDim2.fromOffset(90, 18)
            v58.AnchorPoint = Vector2.new(1, 0.5)
            v58.Size = UDim2.fromOffset(120, 64)
            v58.Position = UDim2.new(1, -176, 0, 40)
            v60.AnchorPoint = Vector2.new(1, 0.5)
            v60.Size = UDim2.fromOffset(160, 64)
            v60.Position = UDim2.new(1, -8, 0, 40)
        else
            v53.Size = UDim2.new(1, 0, 0, 100)

            if Title then
                Title.Visible = true
            end

            if Trophy then
                Trophy.Position = UDim2.new(0, 62, 0, 50)
                Trophy.Size = UDim2.fromOffset(96, 96)
            end

            if Glow then
                Glow.Position = UDim2.new(0, 62, 0, 50)
                Glow.Size = UDim2.fromOffset(190, 190)
            end

            v54.Size = UDim2.new(1, -500, 0, 44)
            v54.Position = UDim2.fromOffset(128, 44)
            v58.AnchorPoint = Vector2.new(1, 0.5)
            v58.Size = UDim2.fromOffset(150, 72)
            v58.Position = UDim2.new(1, -206, 0, 50)
            v60.AnchorPoint = Vector2.new(1, 0.5)
            v60.Size = UDim2.fromOffset(180, 72)
            v60.Position = UDim2.new(1, -14, 0, 50)
        end

        local v113 = if v111 then 80 else 100

        ScrollingFrame.Position = UDim2.fromOffset(0, v113 + 12)
        ScrollingFrame.Size = UDim2.new(1, 0, 1, -(v113 + 12))
    end

    local function layout() -- line: 462
        -- upvalues: Index (copy), v51 (copy), v52 (copy), UIScale (copy), v70 (ref), layoutRows (copy), layoutSummary (copy)
        local ScreenGui = Index.Frame:FindFirstAncestorOfClass("ScreenGui")
        local FitScale = ScreenGui and ScreenGui:FindFirstChild("FitScale")
        local v114 = if FitScale then math.max(FitScale.Scale, 0.05) else 1
        local v115 = if require(script.Parent.HUD).IsTouch() then math.clamp(18 / (v114 * 22), 1, 2.5) else 1

        UIScale.Scale = v115
        v52.Size = UDim2.new(1 / v115, 0, 1 / v115, 0)

        local v118 = math.floor(v51 / v115)

        if v118 == v70 then
            return
        end

        v70 = v118
        layoutSummary(v118)
        layoutRows(v118)
    end

    local function buildSection(p38, p39) -- line: 479
        -- upvalues: t20 (copy), placeSection (copy), RunService (copy), DataClient (copy), IndexIcons (copy), t2 (copy), refresh (copy), fishCard (copy)
        if p38.built or p38.building then
            return
        end

        p38.building = true

        local v119 = p39

        for v120, v121 in ipairs(p38.pool) do
            if p38.rush then
                v119 = false
            end

            fishCard(p38.row, v121, 0, 0, 200, p38.zone.oddsText and p38.zone.oddsText[v121.id], p38.zone.noVariants)

            local v122 = t2[v121.id]

            if v122 then
                table.insert(p38.cards, v122.frame)

                if IndexIcons.Has(v121.id) then
                    v122.icon = IndexIcons.Picture(v122.holder, v121.id, true)
                else
                    table.insert(t20, v121.id)
                end
            end

            if v119 and v120 % 3 == 0 then
                RunService.Heartbeat:Wait()
            end
        end

        placeSection(p38)
        p38.built = true
        p38.building = false
        refresh(DataClient.Get("Index"))
    end

    local function near(p40, p41) -- line: 508
        -- upvalues: ScrollingFrame (copy)
        local v123 = ScrollingFrame.AbsolutePosition.Y - ScrollingFrame.AbsoluteSize.Y * p41
        local v124 = ScrollingFrame.AbsolutePosition.Y + ScrollingFrame.AbsoluteSize.Y * (p41 + 1)
        local Y = p40.AbsolutePosition.Y

        if v123 <= Y + p40.AbsoluteSize.Y then
            return Y <= v124
        end

        return false
    end

    local v125 = false

    local function fillVisible() -- line: 516
        -- upvalues: Index (copy), ScrollingFrame (copy), t19 (copy), t20 (copy), buildSection (copy), v125 (ref), RunService (copy), UIKit (copy), FishModels (copy), t2 (copy)
        if not v125 and Index.IsOpen then
            v125 = true
            task.spawn(function() -- line: 521
                -- upvalues: ScrollingFrame (copy), t19 (copy), t20 (copy), buildSection (copy), v125 (ref), RunService (copy), UIKit (copy), FishModels (copy), t2 (copy)
                for _, v127 in ipairs(t19) do
                    local row = v127.row
                    local v128 = ScrollingFrame.AbsolutePosition.Y - ScrollingFrame.AbsoluteSize.Y * 0.5
                    local v129 = ScrollingFrame.AbsolutePosition.Y + ScrollingFrame.AbsoluteSize.Y * 1.5
                    local Y = row.AbsolutePosition.Y

                    if v128 <= Y + row.AbsoluteSize.Y and Y <= v129 then
                        if not v127.built then
                            v127.rush = true
                            buildSection(v127, false)
                        end

                        if not v127.artMade then
                            v127.artMade = true
                            UIKit.viewModel(v127.art, v127.zone.art, {
                                ZIndex = 13,
                                Dir = Vector3.new(-0.62, 0.52, -1),
                                Zoom = v127.zone.zoom or 0.86
                            })
                            RunService.Heartbeat:Wait()
                        end
                    end
                end

                local n7 = 0
                local n8 = 1

                while n8 <= #t20 do
                    local v130 = t20[n8]
                    local v131 = t2[v130]

                    if not v131 or v131.icon then
                        table.remove(t20, n8)
                    else
                        local holder = v131.holder
                        local v134 = ScrollingFrame.AbsolutePosition.Y - ScrollingFrame.AbsoluteSize.Y * 0.5
                        local v135 = ScrollingFrame.AbsolutePosition.Y + ScrollingFrame.AbsoluteSize.Y * 1.5
                        local Y = holder.AbsolutePosition.Y
                        local v132 = v134 <= Y + holder.AbsoluteSize.Y and Y <= v135

                        if v132 then
                            v131.icon = FishModels.Picture(v131.holder, v130, 1, not v131.found)
                            table.remove(t20, n8)
                            n7 += 1

                            if n7 % 4 == 0 then
                                RunService.Heartbeat:Wait()
                            end
                        else
                            n8 += 1
                        end
                    end
                end

                v125 = false
            end)
        end
    end

    local function prebuild() -- line: 557
        -- upvalues: t19 (copy), buildSection (copy), DataClient (copy)
        while not DataClient.IsReady() do
            task.wait(1)
        end

        task.wait(2)

        for _, v136 in ipairs(t19) do
            if not v136.built then
                buildSection(v136, true)
                task.wait(0.05)
            end
        end
    end

    DataClient.Observe("Index", refresh)
    DataClient.Observe("CastPower", refreshLocks)
    layout()
    refreshLocks()
    task.spawn(prebuild)

    Index.OnOpen = function() -- line: 576
        -- upvalues: refreshLocks (copy), layout (copy), fillVisible (copy)
        layout()
        refreshLocks()
        task.defer(fillVisible)
    end

    ScrollingFrame:GetPropertyChangedSignal("CanvasPosition"):Connect(fillVisible)
    task.spawn(function() -- line: 582
        -- upvalues: Index (copy), ScrollingFrame (copy), t19 (copy), t20 (copy), buildSection (copy), v125 (ref), RunService (copy), UIKit (copy), FishModels (copy), t2 (copy)
        while true do
            task.wait(0.5)

            if Index.IsOpen and not v125 and Index.IsOpen then
                v125 = true
                task.spawn(function() -- line: 521
                    -- upvalues: ScrollingFrame (copy), t19 (copy), t20 (copy), buildSection (copy), v125 (ref), RunService (copy), UIKit (copy), FishModels (copy), t2 (copy)
                    for _, v137 in ipairs(t19) do
                        local row = v137.row
                        local v138 = ScrollingFrame.AbsolutePosition.Y - ScrollingFrame.AbsoluteSize.Y * 0.5
                        local v139 = ScrollingFrame.AbsolutePosition.Y + ScrollingFrame.AbsoluteSize.Y * 1.5
                        local Y = row.AbsolutePosition.Y

                        if v138 <= Y + row.AbsoluteSize.Y and Y <= v139 then
                            if not v137.built then
                                v137.rush = true
                                buildSection(v137, false)
                            end

                            if not v137.artMade then
                                v137.artMade = true
                                UIKit.viewModel(v137.art, v137.zone.art, {
                                    ZIndex = 13,
                                    Dir = Vector3.new(-0.62, 0.52, -1),
                                    Zoom = v137.zone.zoom or 0.86
                                })
                                RunService.Heartbeat:Wait()
                            end
                        end
                    end

                    local n9 = 0
                    local n10 = 1

                    while n10 <= #t20 do
                        local v140 = t20[n10]
                        local v141 = t2[v140]

                        if not v141 or v141.icon then
                            table.remove(t20, n10)
                        else
                            local holder = v141.holder
                            local v144 = ScrollingFrame.AbsolutePosition.Y - ScrollingFrame.AbsoluteSize.Y * 0.5
                            local v145 = ScrollingFrame.AbsolutePosition.Y + ScrollingFrame.AbsoluteSize.Y * 1.5
                            local Y = holder.AbsolutePosition.Y
                            local v142 = v144 <= Y + holder.AbsoluteSize.Y and Y <= v145

                            if v142 then
                                v141.icon = FishModels.Picture(v141.holder, v140, 1, not v141.found)
                                table.remove(t20, n10)
                                n9 += 1

                                if n9 % 4 == 0 then
                                    RunService.Heartbeat:Wait()
                                end
                            else
                                n10 += 1
                            end
                        end
                    end

                    v125 = false
                end)
            end
        end
    end)
    workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(function() -- line: 590
        -- upvalues: Index (copy), layout (copy)
        if Index.IsOpen then
            layout()
        end
    end)
end

return t1
