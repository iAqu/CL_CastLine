-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Shared = ReplicatedStorage:WaitForChild("Shared")
local Remotes = ReplicatedStorage:WaitForChild("Remotes")
local GameConfig = require(Shared.GameConfig)
local Fish = require(Shared.Data.Fish)
local Rarities = require(Shared.Data.Rarities)
local Variants = require(Shared.Data.Variants)
local Sizes = require(Shared.Data.Sizes)
local Events = require(Shared.Data.Events)
local Roll = require(Shared.Roll)
local NumberFormat = require(Shared.NumberFormat)
local UIKit = require(script.Parent.UIKit)
local FishIcons = require(script.Parent.FishIcons)
local SellDialog = require(script.Parent.SellDialog)
local DataClient = require(script.Parent.DataClient)
local t1 = {}
local Colors = UIKit.Colors
local Left = Enum.TextXAlignment.Left

local function hex(p1) -- line: 27
    return string.format("#%02X%02X%02X", math.floor(p1.R * 255 + 0.5), math.floor(p1.G * 255 + 0.5), (math.floor(p1.B * 255 + 0.5)))
end

local function call(p2, ...) -- line: 31
    -- upvalues: Remotes (copy)
    local v6 = table.pack(...)

    task.spawn(function() -- line: 33
        -- upvalues: p2 (copy), v6 (copy), Remotes (copy)
        local function v7() -- line: 34
            -- upvalues: p2 (copy), v6 (copy), Remotes (copy)
            return Remotes[p2]:InvokeServer(table.unpack(v6, 1, v6.n))
        end

        local ok, result = pcall(v7)

        if not ok then
            warn("[FishWindows] " .. p2 .. ": " .. tostring(result))
        end
    end)
end

local function capacity() -- line: 43
    -- upvalues: GameConfig (copy), DataClient (copy)
    return GameConfig.CAPACITY_LEVELS[DataClient.Get("CapacityLevel") or 1] or GameConfig.CAPACITY_LEVELS[1]
end

local function scroller(p3, p4, p5) -- line: 47
    -- upvalues: Colors (copy)
    local ScrollingFrame = Instance.new("ScrollingFrame")

    ScrollingFrame.Name = "List"
    ScrollingFrame.BackgroundTransparency = 1
    ScrollingFrame.BorderSizePixel = 0
    ScrollingFrame.Size = p4
    ScrollingFrame.Position = p5 or UDim2.new()
    ScrollingFrame.ScrollBarThickness = 8
    ScrollingFrame.ScrollBarImageColor3 = Colors.Grey
    ScrollingFrame.ScrollingDirection = Enum.ScrollingDirection.Y
    ScrollingFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
    ScrollingFrame.CanvasSize = UDim2.new()
    ScrollingFrame.ZIndex = 11
    ScrollingFrame.Parent = p3

    local UIListLayout = Instance.new("UIListLayout")

    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    UIListLayout.Padding = UDim.new(0, 8)
    UIListLayout.Parent = ScrollingFrame

    local UIPadding = Instance.new("UIPadding")

    UIPadding.PaddingTop = UDim.new(0, 4)
    UIPadding.PaddingLeft = UDim.new(0, 4)
    UIPadding.PaddingBottom = UDim.new(0, 6)
    UIPadding.Parent = ScrollingFrame

    return ScrollingFrame
end

local function shrinkToFit(p6, p7, p8) -- line: 76
    p6.TextScaled = true

    local UITextSizeConstraint = Instance.new("UITextSizeConstraint")

    UITextSizeConstraint.MaxTextSize = p7
    UITextSizeConstraint.MinTextSize = p8
    UITextSizeConstraint.Parent = p6
end

local function fishRow(p9, p10, p11, p12, p13) -- line: 84
    -- upvalues: Fish (copy), Rarities (copy), Variants (copy), Sizes (copy), Events (copy), Roll (copy), NumberFormat (copy), UIKit (copy), FishIcons (copy), SellDialog (copy), Colors (copy), Left (copy)
    local v9 = Fish.ById[p10.id]
    local v10 = Rarities.ById[v9.rarity]
    local v11 = Variants.List[p10.v] or Variants.List[1]
    local v12 = Sizes.List[p10.s] or Sizes.List[Sizes.NORMAL_INDEX]
    local v13 = UIKit.frame(p9, {
        Corner = 16,
        Stroke = 4,
        ZIndex = 12,
        Name = "Fish" .. p10.uid,
        Size = UDim2.fromOffset(p11, 96),
        Color = v10.Color:Lerp(Color3.fromRGB(30, 34, 70), 0.72),
        Color2 = v10.Color:Lerp(Color3.fromRGB(14, 16, 34), 0.86)
    })

    UIKit.dress(v13, 16, v10.Color:Lerp(Colors.White, 0.4))

    local v14 = UIKit.frame(v13, {
        Name = "Tile",
        Corner = 12,
        Stroke = 3,
        ZIndex = 13,
        Size = UDim2.fromOffset(80, 80),
        Position = UDim2.fromOffset(8, 8),
        Color = v10.Color,
        Color2 = v10.Color2
    })

    UIKit.image(v14, "Glow", {
        Transparency = 0.45,
        ZIndex = 13,
        Size = UDim2.fromScale(1.1, 1.1),
        Position = UDim2.fromScale(0.5, 0.55),
        AnchorPoint = Vector2.new(0.5, 0.5),
        Color = Colors.White
    })
    UIKit.frame(v14, {
        Name = "Shine",
        Transparency = 0.6,
        Corner = 6,
        ZIndex = 13,
        Size = UDim2.new(1, -12, 0, 12),
        Position = UDim2.fromOffset(6, 4),
        Color = Colors.White
    })

    local v15 = UIKit.frame(v14, {
        Name = "Picture",
        Transparency = 1,
        ZIndex = 13,
        Size = UDim2.new(1, -6, 1, -6),
        Position = UDim2.fromOffset(3, 3)
    })

    FishIcons.Picture(v15, p10.id, p10.v, 1.1)
    v13:SetAttribute("E", p10.e or "")

    local t2 = {}
    local v16 = p10.e and Events.ById[p10.e]

    if v16 then
        local Color = v16.Color

        table.insert(t2, ("<font color=\"%s\">%s x%d</font>"):format(string.format("#%02X%02X%02X", math.floor(Color.R * 255 + 0.5), math.floor(Color.G * 255 + 0.5), (math.floor(Color.B * 255 + 0.5))), string.upper(v16.mutation), v16.mult))
    end

    if v11.index >= 2 then
        local Color = v11.Color

        table.insert(t2, ("<font color=\"%s\">%s</font>"):format(string.format("#%02X%02X%02X", math.floor(Color.R * 255 + 0.5), math.floor(Color.G * 255 + 0.5), (math.floor(Color.B * 255 + 0.5))), string.upper(v11.id)))
    end

    if v12.index ~= Sizes.NORMAL_INDEX then
        local Color = v12.Color

        table.insert(t2, ("<font color=\"%s\">%s</font>"):format(string.format("#%02X%02X%02X", math.floor(Color.R * 255 + 0.5), math.floor(Color.G * 255 + 0.5), (math.floor(Color.B * 255 + 0.5))), string.upper(v12.id)))
    end

    local v36 = p11 - 100 - (if p12 then 380 else #p13 * 112 + 12)
    local v37 = #t2 > 0
    local _, _, v38 = v10.Color:ToHSV()
    local v39 = v10.Color:Lerp(Colors.White, if v38 < 0.6 then 0.75 else 0.35)

    if v37 then
        local v40 = UIKit.text(v13, {
            Name = "Tags",
            TextSize = 18,
            Stroke = 3,
            ZIndex = 13,
            Text = table.concat(t2, " "),
            Size = UDim2.fromOffset(v36, 20),
            Position = UDim2.fromOffset(100, 9),
            XAlign = Left,
            Color = Colors.Gold
        })

        v40.RichText = true
        v40.TextScaled = true

        local UITextSizeConstraint = Instance.new("UITextSizeConstraint")

        UITextSizeConstraint.MaxTextSize = 18
        UITextSizeConstraint.MinTextSize = 11
        UITextSizeConstraint.Parent = v40
    end

    local v41 = UIKit.text(v13, {
        Name = "FishName",
        TextSize = 28,
        Stroke = 3,
        ZIndex = 13,
        Text = v9.name,
        Size = UDim2.fromOffset(v36, 32),
        Position = UDim2.fromOffset(100, v37 and 28 or 18),
        XAlign = Left,
        Color = v39
    })

    v41.TextScaled = true

    local UITextSizeConstraint = Instance.new("UITextSizeConstraint")

    UITextSizeConstraint.MaxTextSize = 28
    UITextSizeConstraint.MinTextSize = 16
    UITextSizeConstraint.Parent = v41
    v41.TextTruncate = Enum.TextTruncate.AtEnd
    UIKit.text(v13, {
        Name = "Rate",
        TextSize = 24,
        Stroke = 3,
        ZIndex = 13,
        Text = NumberFormat.rate(Roll.incomeOf(p10)),
        Size = UDim2.fromOffset(v36, 26),
        Position = UDim2.fromOffset(100, v37 and 60 or 54),
        XAlign = Left,
        Color = Colors.Cash,
        StrokeColor = Colors.CashStroke
    })

    if p12 then
        UIKit.text(v13, {
            Name = "ValueLabel",
            Text = "SELLS FOR",
            TextSize = 18,
            Stroke = 3,
            ZIndex = 13,
            Size = UDim2.fromOffset(180, 20),
            Position = UDim2.new(1, -370, 0, 20),
            XAlign = Left,
            Color = Colors.Grey
        })
        UIKit.text(v13, {
            Name = "Value",
            TextSize = 32,
            Stroke = 4,
            ZIndex = 13,
            Text = NumberFormat.money(Roll.sellOf(p10)),
            Size = UDim2.fromOffset(190, 36),
            Position = UDim2.new(1, -370, 0, 42),
            XAlign = Left,
            Color = Colors.Cash,
            StrokeColor = Colors.CashStroke
        })

        local v42 = p13[1]

        UIKit.button(v13, {
            ZIndex = 13,
            Name = v42[1],
            Text = v42[1],
            Size = UDim2.fromOffset(160, 64),
            Position = UDim2.new(1, -14, 0.5, 0),
            AnchorPoint = Vector2.new(1, 0.5),
            Color = v42[2],
            Color2 = v42[3],
            OnClick = v42[4]
        })
    else
        for v43, v44 in ipairs(p13) do
            UIKit.button(v13, {
                Corner = 9,
                Stroke = 3,
                ZIndex = 13,
                Name = v44[1],
                Text = v44[1],
                Size = UDim2.fromOffset(106, 80),
                Position = UDim2.new(1, -8 - (#p13 - v43) * 112, 0, 8),
                AnchorPoint = Vector2.new(1, 0),
                Color = v44[2],
                Color2 = v44[3],
                OnClick = if v44[5] then function() -- line: 137
                    -- upvalues: p10 (copy), v44 (copy), SellDialog (copy)
                    SellDialog.Shared:Ask(p10, v44[4])
                end else v44[4]
            })
        end
    end

    return v13
end

local function rowSet(p14, p15, p16, p17) -- line: 146
    -- upvalues: Roll (copy), fishRow (copy)
    local t6 = {}

    return function(p18, p19) -- line: 148
        -- upvalues: p14 (copy), p15 (copy), p16 (copy), p17 (copy), t6 (copy), Roll (copy), fishRow (copy)
        local v45 = table.clone(p18 or {})

        table.sort(v45, function(p20, p21) -- line: 150
            -- upvalues: Roll (copy)
            local v46 = Roll.incomeOf(p20)
            local v47 = Roll.incomeOf(p21)

            if v46 == v47 then
                return p20.uid < p21.uid
            end

            return v47 < v46
        end)

        local t7 = {}

        for v48, v49 in ipairs(v45) do
            t7[v49.uid] = true

            local v50 = t6[v49.uid]

            if v50 and v50:GetAttribute("E") ~= (v49.e or "") then
                v50:Destroy()
                v50 = nil
            end

            if not v50 then
                v50 = fishRow(p14, v49, p15, p16, p17(v49))
                t6[v49.uid] = v50
            end

            v50.LayoutOrder = p19 + v48
        end

        for v51, v52 in pairs(t6) do
            if not t7[v51] then
                t6[v51] = nil
                v52:Destroy()
            end
        end

        return #v45
    end
end

local function sectionLabel(p22, p23, p24) -- line: 181
    -- upvalues: UIKit (copy), Left (copy)
    local v53 = UIKit.text(p22, {
        Name = "Section",
        Text = "",
        TextSize = 22,
        Stroke = 3,
        ZIndex = 12,
        Size = UDim2.fromOffset(p23, 26),
        XAlign = Left
    })

    v53.RichText = true
    v53.LayoutOrder = p24

    return v53
end

local function initMyFish() -- line: 189
    -- upvalues: Players (copy), GameConfig (copy), Roll (copy), UIKit (copy), DataClient (copy), Colors (copy), Left (copy), call (copy), scroller (copy), fishRow (copy), sectionLabel (copy)
    local MyFish = UIKit.Windows.MyFish
    local Content = MyFish.Content
    local v54 = Content.Size.X.Offset + MyFish.Frame.Size.X.Offset
    local FramePosition = MyFish.Frame.Position

    MyFish.FitPosition = function(p25) -- line: 194
        -- upvalues: FramePosition (copy), Players (copy)
        if not require(script.Parent.HUD).IsTouch() then
            return nil
        end

        local TouchGui = Players.LocalPlayer.PlayerGui:FindFirstChild("TouchGui")

        TouchGui = TouchGui and TouchGui.Enabled and TouchGui:FindFirstChild("JumpButton", true)

        if TouchGui and TouchGui.Visible then
            local v55 = workspace.CurrentCamera.ViewportSize.X - TouchGui.AbsolutePosition.X + 10

            return UDim2.new(FramePosition.X.Scale, math.min(FramePosition.X.Offset, -v55 / p25), FramePosition.Y.Scale, FramePosition.Y.Offset)
        end

        return nil
    end

    local v57 = UIKit.frame(MyFish.Frame, {
        Name = "Capacity",
        Corner = 12,
        Stroke = 4,
        ZIndex = 13,
        Size = UDim2.fromOffset(124, 46),
        Position = UDim2.new(1, -78, 0, 14),
        AnchorPoint = Vector2.new(1, 0),
        Color = Colors.Dark
    })

    UIKit.icon(v57, "Fish", {
        ZIndex = 14,
        Size = UDim2.fromOffset(40, 40),
        Position = UDim2.new(0, 4, 0.5, 0),
        AnchorPoint = Vector2.new(0, 0.5)
    })

    local v58 = UIKit.text(v57, {
        Name = "Count",
        Text = "0/10",
        TextSize = 26,
        Stroke = 3,
        ZIndex = 14,
        Size = UDim2.new(1, -48, 1, 0),
        Position = UDim2.fromOffset(44, 0)
    })
    local v59 = scroller(Content, UDim2.new(1, 0, 1, -86))
    local v60 = v54 - 22
    local v61 = sectionLabel(v59, v60, 0)
    local v62 = sectionLabel(v59, v60, 10000)
    local v63 = UIKit.text(v59, {
        Name = "Hint",
        Text = "Cast from the dock to catch fish,\nthen walk into your pond to place them!",
        TextSize = 24,
        Stroke = 3,
        ZIndex = 12,
        Size = UDim2.fromOffset(v60, 120),
        Color = Colors.Grey
    })

    v63.LayoutOrder = 30000
    v63.TextWrapped = true

    local function v64(p26) -- line: 220
        -- upvalues: Colors (copy), call (copy)
        return {
            {
                "PICK UP",
                Colors.Blue,
                Colors.BlueDark,
                function() -- line: 222
                    -- upvalues: p26 (copy), call (copy)
                    call("PickUpFish", p26.uid)
                end
            },
            {
                "SELL",
                Colors.Red,
                Colors.RedDark,
                function() -- line: 225
                    -- upvalues: p26 (copy), call (copy)
                    call("SellFish", p26.uid)
                end,
                true
            }
        }
    end

    local t8 = {}
    local v65 = false

    local function v66(p27, p28) -- line: 148
        -- upvalues: v59 (copy), v60 (copy), v64 (copy), t8 (copy), v65 (copy), Roll (copy), fishRow (copy)
        local v67 = table.clone(p27 or {})

        table.sort(v67, function(p29, p30) -- line: 150
            -- upvalues: Roll (copy)
            local v68 = Roll.incomeOf(p29)
            local v69 = Roll.incomeOf(p30)

            if v68 == v69 then
                return p29.uid < p30.uid
            end

            return v69 < v68
        end)

        local t9 = {}

        for v70, v71 in ipairs(v67) do
            t9[v71.uid] = true

            local v72 = t8[v71.uid]

            if v72 and v72:GetAttribute("E") ~= (v71.e or "") then
                v72:Destroy()
                v72 = nil
            end

            if not v72 then
                v72 = fishRow(v59, v71, v60, v65, v64(v71))
                t8[v71.uid] = v72
            end

            v72.LayoutOrder = p28 + v70
        end

        for v73, v74 in pairs(t8) do
            if not t9[v73] then
                t8[v73] = nil
                v74:Destroy()
            end
        end

        return #v67
    end

    local function v75(p31) -- line: 230
        -- upvalues: Colors (copy), call (copy)
        return {
            {
                "PLACE",
                Colors.Green,
                Colors.GreenDark,
                function() -- line: 232
                    -- upvalues: p31 (copy), call (copy)
                    call("PlaceFish", p31.uid)
                end
            },
            {
                "TANK",
                Colors.Blue,
                Colors.BlueDark,
                function() -- line: 235
                    -- upvalues: p31 (copy), call (copy)
                    call("AquariumAdd", p31.uid)
                end
            },
            {
                "SELL",
                Colors.Red,
                Colors.RedDark,
                function() -- line: 238
                    -- upvalues: p31 (copy), call (copy)
                    call("SellFish", p31.uid)
                end,
                true
            }
        }
    end

    local t10 = {}
    local v76 = false

    local function v77(p32, p33) -- line: 148
        -- upvalues: v59 (copy), v60 (copy), v75 (copy), t10 (copy), v76 (copy), Roll (copy), fishRow (copy)
        local v78 = table.clone(p32 or {})

        table.sort(v78, function(p34, p35) -- line: 150
            -- upvalues: Roll (copy)
            local v79 = Roll.incomeOf(p34)
            local v80 = Roll.incomeOf(p35)

            if v79 == v80 then
                return p34.uid < p35.uid
            end

            return v80 < v79
        end)

        local t11 = {}

        for v81, v82 in ipairs(v78) do
            t11[v82.uid] = true

            local v83 = t10[v82.uid]

            if v83 and v83:GetAttribute("E") ~= (v82.e or "") then
                v83:Destroy()
                v83 = nil
            end

            if not v83 then
                v83 = fishRow(v59, v82, v60, v76, v75(v82))
                t10[v82.uid] = v83
            end

            v83.LayoutOrder = p33 + v81
        end

        for v84, v85 in pairs(t10) do
            if not t11[v84] then
                t10[v84] = nil
                v85:Destroy()
            end
        end

        return #v78
    end

    local t12 = {}

    for v86, v87 in ipairs(require(game:GetService("ReplicatedStorage").Shared.Data.Products).Crates) do
        local v88 = UIKit.frame(v59, {
            Corner = 14,
            Stroke = 4,
            ZIndex = 12,
            Name = "Egg" .. v87.key,
            Size = UDim2.fromOffset(v60, 84),
            Color = Colors.Panel,
            StrokeColor = Colors.Gold
        })

        v88.LayoutOrder = -100 + v86

        local v89 = UIKit.frame(v88, {
            Name = "Tile",
            Corner = 10,
            Stroke = 3,
            ZIndex = 13,
            Size = UDim2.fromOffset(68, 68),
            Position = UDim2.new(0, 8, 0.5, 0),
            AnchorPoint = Vector2.new(0, 0.5),
            Color = Color3.fromRGB(255, 214, 90),
            Color2 = Color3.fromRGB(230, 140, 30)
        })

        task.defer(function() -- line: 251
            -- upvalues: v87 (copy), v89 (copy), UIKit (copy)
            UIKit.eggPicture(v89, v87.key, {
                ZIndex = 14,
                Size = UDim2.fromScale(1.15, 1.15)
            })
        end)

        local v90 = UIKit.text(v88, {
            Name = "Title",
            TextSize = 28,
            Stroke = 3,
            ZIndex = 13,
            Text = v87.name,
            Size = UDim2.new(1, -250, 0, 32),
            Position = UDim2.fromOffset(88, 10),
            XAlign = Left,
            Color = Colors.Gold
        })
        local v91 = UIKit.text(v88, {
            Name = "Sub",
            Text = "",
            TextSize = 19,
            Stroke = 3,
            ZIndex = 13,
            Size = UDim2.new(1, -250, 0, 24),
            Position = UDim2.fromOffset(88, 46),
            XAlign = Left,
            Color = Colors.Grey
        })

        v91.TextScaled = true

        local UITextSizeConstraint = Instance.new("UITextSizeConstraint")

        UITextSizeConstraint.MaxTextSize = 19
        UITextSizeConstraint.MinTextSize = 12
        UITextSizeConstraint.Parent = v91

        local v92 = UIKit.button(v88, {
            Name = "Place",
            Text = "PLACE",
            Corner = 10,
            Stroke = 3,
            ZIndex = 13,
            Size = UDim2.fromOffset(136, 64),
            Position = UDim2.new(1, -10, 0.5, 0),
            AnchorPoint = Vector2.new(1, 0.5),
            Color = Colors.Green,
            Color2 = Colors.GreenDark,
            OnClick = function() -- OnClick | line: 257
                -- upvalues: v87 (copy), call (copy)
                call("PlaceEgg", v87.key)
            end
        })

        t12[v87.key] = {
            row = v88,
            title = v90,
            sub = v91,
            button = v92,
            name = v87.name
        }
    end

    local function refreshEggs() -- line: 262
        -- upvalues: t12 (copy), DataClient (copy)
        local v93 = DataClient.Get("Eggs") or {}

        DataClient.Get("EggPlaced")

        for v94, v95 in pairs(t12) do
            local n1 = 0

            for _, v96 in ipairs(v93) do
                if v96 == v94 then
                    n1 += 1
                end
            end

            v95.row.Visible = n1 > 0
            v95.title.Text = v95.name .. (if n1 > 0 then "  x" .. n1 else "")
            v95.sub.Text = "Tap it in your hotbar, then tap your pond. PLACE drops one in"
            v95.button.Visible = n1 > 0
        end
    end

    DataClient.Observe("Eggs", refreshEggs)
    DataClient.Observe("EggPlaced", refreshEggs)
    task.defer(refreshEggs)

    local v97 = sectionLabel(v59, v60, 20000)

    local function v98(p36) -- line: 282
        -- upvalues: Colors (copy), call (copy)
        return {
            {
                "TAKE",
                Colors.Blue,
                Colors.BlueDark,
                function() -- line: 284
                    -- upvalues: p36 (copy), call (copy)
                    call("AquariumRemove", p36.uid)
                end
            }
        }
    end

    local t14 = {}
    local v99 = false

    local function v100(p37, p38) -- line: 148
        -- upvalues: v59 (copy), v60 (copy), v98 (copy), t14 (copy), v99 (copy), Roll (copy), fishRow (copy)
        local v101 = table.clone(p37 or {})

        table.sort(v101, function(p39, p40) -- line: 150
            -- upvalues: Roll (copy)
            local v102 = Roll.incomeOf(p39)
            local v103 = Roll.incomeOf(p40)

            if v102 == v103 then
                return p39.uid < p40.uid
            end

            return v103 < v102
        end)

        local t15 = {}

        for v104, v105 in ipairs(v101) do
            t15[v105.uid] = true

            local v106 = t14[v105.uid]

            if v106 and v106:GetAttribute("E") ~= (v105.e or "") then
                v106:Destroy()
                v106 = nil
            end

            if not v106 then
                v106 = fishRow(v59, v105, v60, v99, v98(v105))
                t14[v105.uid] = v106
            end

            v106.LayoutOrder = p38 + v104
        end

        for v107, v108 in pairs(t14) do
            if not t15[v107] then
                t14[v107] = nil
                v108:Destroy()
            end
        end

        return #v101
    end

    UIKit.button(Content, {
        Name = "EquipBest",
        Text = "EQUIP BEST",
        Corner = 14,
        Stroke = 5,
        TextStroke = 4,
        ZIndex = 12,
        Size = UDim2.new(1, 0, 0, 72),
        Position = UDim2.fromScale(0, 1),
        AnchorPoint = Vector2.new(0, 1),
        Color = Colors.Orange,
        Color2 = Colors.OrangeDark,
        OnClick = function() -- OnClick | line: 290
            -- upvalues: call (copy)
            call("EquipBest")
        end
    })

    local v109 = true

    local function refresh() -- line: 295
        -- upvalues: MyFish (copy), v58 (copy), v61 (copy), v62 (copy), v63 (copy), v66 (copy), v77 (copy), v97 (copy), v100 (copy), v109 (ref), GameConfig (copy), DataClient (copy), Colors (copy)
        local v110 = GameConfig.CAPACITY_LEVELS[DataClient.Get("CapacityLevel") or 1] or GameConfig.CAPACITY_LEVELS[1]
        local v111 = DataClient.Get("Placed") or {}
        local v112 = DataClient.Get("Backpack") or {}
        local v113 = DataClient.Get("Aquarium") or {}

        v58.Text = #v111 .. "/" .. v110

        if not MyFish.IsOpen then
            v109 = true

            return
        end

        v109 = false
        v66(v111, 0)
        v77(v112, 10000)

        local Gold = Colors.Gold

        v61.Text = ("ON YOUR PLOT  <font color=\"%s\">%d/%d</font>"):format(string.format("#%02X%02X%02X", math.floor(Gold.R * 255 + 0.5), math.floor(Gold.G * 255 + 0.5), (math.floor(Gold.B * 255 + 0.5))), #v111, v110)

        local Gold2 = Colors.Gold

        v62.Text = ("IN BACKPACK  <font color=\"%s\">%d</font>"):format(string.format("#%02X%02X%02X", math.floor(Gold2.R * 255 + 0.5), math.floor(Gold2.G * 255 + 0.5), (math.floor(Gold2.B * 255 + 0.5))), #v112)
        v62.Visible = #v112 > 0
        v100(v113, 20000)

        local Gold3 = Colors.Gold

        v97.Text = ("IN AQUARIUM  <font color=\"%s\">%d/%d</font>  (for show: earns nothing)"):format(string.format("#%02X%02X%02X", math.floor(Gold3.R * 255 + 0.5), math.floor(Gold3.G * 255 + 0.5), (math.floor(Gold3.B * 255 + 0.5))), #v113, GameConfig.AQUARIUM_LIMIT)
        v97.Visible = #v113 > 0
        v63.Visible = #v111 == 0 and #v112 == 0 and #v113 == 0
    end

    MyFish.OnOpen = function() -- line: 315
        -- upvalues: refresh (copy)
        task.defer(refresh)
    end

    DataClient.Observe("Placed", refresh)
    DataClient.Observe("Backpack", refresh)
    DataClient.Observe("Aquarium", refresh)
    DataClient.Observe("CapacityLevel", refresh)
end

local function initSell() -- line: 325
    -- upvalues: Players (copy), RunService (copy), Roll (copy), NumberFormat (copy), UIKit (copy), DataClient (copy), Colors (copy), Left (copy), call (copy), scroller (copy), fishRow (copy)
    local Sell = UIKit.Windows.Sell
    local Content = Sell.Content
    local v130 = Content.Size.X.Offset + Sell.Frame.Size.X.Offset
    local v131 = UIKit.frame(Content, {
        Name = "Value",
        Corner = 14,
        Stroke = 4,
        ZIndex = 12,
        Size = UDim2.new(1, 0, 0, 118),
        Color = Colors.Panel
    })

    UIKit.text(v131, {
        Name = "Label",
        Text = "BACKPACK VALUE",
        TextSize = 28,
        Stroke = 4,
        ZIndex = 13,
        Size = UDim2.fromOffset(400, 32),
        Position = UDim2.fromOffset(26, 16),
        XAlign = Left
    })
    UIKit.icon(v131, "Cash", {
        ZIndex = 13,
        Size = UDim2.fromOffset(60, 60),
        Position = UDim2.fromOffset(20, 52)
    })

    local v132 = UIKit.text(v131, {
        Name = "Amount",
        Text = "$0",
        TextSize = 46,
        Stroke = 5,
        ZIndex = 13,
        Size = UDim2.fromOffset(380, 52),
        Position = UDim2.fromOffset(86, 56),
        XAlign = Left,
        Color = Colors.Cash,
        StrokeColor = Colors.CashStroke
    })
    local v133 = UIKit.button(v131, {
        Name = "SellAll",
        Text = "SELL ALL",
        Corner = 14,
        Stroke = 5,
        TextStroke = 4,
        ZIndex = 13,
        Size = UDim2.fromOffset(380, 86),
        Position = UDim2.new(1, -16, 0.5, 0),
        AnchorPoint = Vector2.new(1, 0.5),
        Color = Colors.Grey,
        Color2 = Colors.GreyDark,
        OnClick = function() -- OnClick | line: 334
            -- upvalues: DataClient (copy), call (copy)
            if #(DataClient.Get("Backpack") or {}) > 0 then
                call("SellAll")
            end
        end
    })
    local v135 = scroller(Content, UDim2.new(1, 0, 1, -132), UDim2.fromOffset(0, 132))
    local v136 = UIKit.text(Content, {
        Name = "Empty",
        Text = "NO FISH IN BACKPACK",
        TextSize = 46,
        Stroke = 5,
        ZIndex = 12,
        Size = UDim2.new(1, 0, 0, 60),
        Position = UDim2.new(0, 0, 0.5, 30),
        AnchorPoint = Vector2.new(0, 0.5),
        Color = Color3.fromRGB(225, 225, 235)
    })
    local v137 = v130 - 22

    local function v138(p41) -- line: 342
        -- upvalues: Colors (copy), call (copy)
        return {
            {
                "SELL",
                Colors.Red,
                Colors.RedDark,
                function() -- line: 343
                    -- upvalues: p41 (copy), call (copy)
                    call("SellFish", p41.uid)
                end
            }
        }
    end

    local t16 = {}
    local v139 = true

    local function v140(p42, p43) -- line: 148
        -- upvalues: v135 (copy), v137 (copy), v138 (copy), t16 (copy), v139 (copy), Roll (copy), fishRow (copy)
        local v141 = table.clone(p42 or {})

        table.sort(v141, function(p44, p45) -- line: 150
            -- upvalues: Roll (copy)
            local v142 = Roll.incomeOf(p44)
            local v143 = Roll.incomeOf(p45)

            if v142 == v143 then
                return p44.uid < p45.uid
            end

            return v143 < v142
        end)

        local t17 = {}

        for v144, v145 in ipairs(v141) do
            t17[v145.uid] = true

            local v146 = t16[v145.uid]

            if v146 and v146:GetAttribute("E") ~= (v145.e or "") then
                v146:Destroy()
                v146 = nil
            end

            if not v146 then
                v146 = fishRow(v135, v145, v137, v139, v138(v145))
                t16[v145.uid] = v146
            end

            v146.LayoutOrder = p43 + v144
        end

        for v147, v148 in pairs(t16) do
            if not t17[v147] then
                t16[v147] = nil
                v148:Destroy()
            end
        end

        return #v141
    end

    local function refresh() -- line: 348
        -- upvalues: Sell (copy), v132 (copy), v133 (copy), v136 (copy), v140 (copy), Roll (copy), NumberFormat (copy), UIKit (copy), DataClient (copy), Colors (copy)
        local v149 = DataClient.Get("Backpack") or {}
        local Products = require(game:GetService("ReplicatedStorage").Shared.Data.Products)
        local n2 = 0
        local n3 = 0

        for _, v150 in ipairs(v149) do
            if not Products.IsCrateFish(v150) then
                n2 += Roll.sellOf(v150)
                n3 += 1
            end
        end

        v132.Text = NumberFormat.money(n2)
        UIKit.setButtonColor(v133, if n3 > 0 then Colors.Green else Colors.Grey, if n3 > 0 then Colors.GreenDark else Colors.GreyDark)
        v136.Visible = #v149 == 0

        if Sell.IsOpen then
            v140(v149, 0)
        end
    end

    Sell.OnOpen = function() -- line: 365
        -- upvalues: refresh (copy)
        task.defer(refresh)
    end

    DataClient.Observe("Backpack", refresh)

    local v153 = false
    local n4 = 0

    RunService.Heartbeat:Connect(function(p46) -- line: 373
        -- upvalues: Sell (copy), v153 (ref), n4 (ref), Players (copy)
        n4 += p46

        if n4 < 0.15 then
            return
        end

        n4 = 0

        local Character = Players.LocalPlayer.Character
        local HumanoidRootPart = Character and Character:FindFirstChild("HumanoidRootPart")
        local World = workspace:FindFirstChild("World")

        World = World and World:FindFirstChild("Stalls") and World.Stalls:FindFirstChild("SellStall")

        local SellPad = World and World:FindFirstChild("SellPad")
        local v154 = false

        if HumanoidRootPart and SellPad then
            local v155 = HumanoidRootPart.Position - SellPad.Position

            if Vector2.new(v155.X, v155.Z).Magnitude < 4.8 then
                v154 = math.abs(v155.Y) < 9
            end
        end

        if not v154 or v153 then
            if not v154 and v153 then
                v153 = false
                Sell.Close()
            end
        else
            v153 = true
            Sell.Open()
        end
    end)
end

function t1.Init() -- line: 399
    -- upvalues: initMyFish (copy), initSell (copy)
    initMyFish()
    initSell()
end

return t1
