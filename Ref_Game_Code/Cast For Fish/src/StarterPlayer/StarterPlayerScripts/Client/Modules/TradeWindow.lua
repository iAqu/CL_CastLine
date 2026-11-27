-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Shared = ReplicatedStorage:WaitForChild("Shared")
local Trade = require(Shared.Data.Trade)
local Fish = require(Shared.Data.Fish)
local Variants = require(Shared.Data.Variants)
local Sizes = require(Shared.Data.Sizes)
local Events = require(Shared.Data.Events)
local Rarities = require(Shared.Data.Rarities)
local Products = require(Shared.Data.Products)
local NumberFormat = require(Shared.NumberFormat)
local FishModels = require(Shared.FishModels)
local UIKit = require(script.Parent.UIKit)
local Toasts = require(script.Parent.Toasts)
local DataClient = require(script.Parent.DataClient)
local TopBar = require(script.Parent.TopBar)
local HeldFish = require(script.Parent.HeldFish)

require(script.Parent.Pad)

local HUD = require(script.Parent.HUD)
local t1 = {
    State = nil,
    Incoming = nil,
    Outgoing = nil,
    Notes = {},
    Done = 0,
    Flashes = 0
}
local LocalPlayer = Players.LocalPlayer
local fromRGB = Color3.fromRGB
local Left = Enum.TextXAlignment.Left
local v1 = Font.fromEnum(Enum.Font.LuckiestGuy)
local v2 = fromRGB(110, 230, 90)
local v3 = fromRGB(40, 160, 50)
local v4 = fromRGB(84, 90, 120)
local v5 = fromRGB(50, 54, 80)
local v6 = fromRGB(26, 32, 66)
local v7 = fromRGB(14, 16, 38)
local Trade2, v8, t2, v9
local t3 = {}
local v10 = false
local t4
local v11 = true

local function now() -- line: 55
    return workspace:GetServerTimeNow()
end

local function note(p1, p2) -- line: 59
    -- upvalues: Toasts (copy), t1 (copy)
    table.insert(t1.Notes, p1)
    Toasts.Show(p2 or "info", p1)
end

local function fishName(p3) -- line: 65
    -- upvalues: Fish (copy), Variants (copy), Sizes (copy)
    local v12 = Fish.ById[p3.id]
    local v13 = Variants.List[p3.v or 1] or Variants.List[1]
    local v14 = Sizes.List[p3.s or Sizes.NORMAL_INDEX] or Sizes.List[Sizes.NORMAL_INDEX]
    local v15 = if v13.index and v13.index >= 2 then v13.id .. " " else ""

    if v14.index ~= Sizes.NORMAL_INDEX then
        v15 ..= v14.id .. " "
    end

    return v15 .. (if v12 then v12.name else tostring(p3.id))
end

local function crateOf(p4) -- line: 79
    -- upvalues: Products (copy)
    for _, v17 in ipairs(Products.Crates or {}) do
        if v17.key == p4 then
            return v17
        end
    end

    return nil
end

local function rarityOf(p5) -- line: 88
    -- upvalues: Fish (copy), Rarities (copy), fromRGB (copy)
    if p5.kind == "egg" then
        return {
            Color = fromRGB(205, 160, 255),
            Color2 = fromRGB(120, 70, 220)
        }
    end

    local v18 = Fish.ById[p5.id]

    return v18 and Rarities.ById[v18.rarity] or Rarities.List[1]
end

local function worth(p6) -- line: 97
    -- upvalues: NumberFormat (copy)
    if p6.kind == "egg" then
        return "Unopened"
    end

    if p6.pct then
        return p6.pct .. "% of best"
    end

    return NumberFormat.rate(p6.income or 0)
end

local function asItem(p7) -- line: 108
    -- upvalues: Shared (copy), Products (copy)
    local v19, v20 = Products.SpiritEntry(p7.id)
    local Roll = require(Shared.Roll)

    return {
        kind = "fish",
        uid = p7.uid,
        id = p7.id,
        v = p7.v or 1,
        s = p7.s or 1,
        e = p7.e,
        income = Roll.incomeOf(p7),
        pct = if not v19 or not v20 then nil else v20.pct
    }
end

local function tile(_, p9, p10, p11, p12, p13) -- line: 119
    -- upvalues: Events (copy), NumberFormat (copy), FishModels (copy), UIKit (copy), fromRGB (copy), fishName (copy), crateOf (copy), rarityOf (copy)
    local v21 = rarityOf(p9)
    local TextButton = Instance.new("TextButton")

    TextButton.Name = "Tile"
    TextButton.Text = ""
    TextButton.AutoButtonColor = false
    TextButton.Size = UDim2.fromOffset(p10, p11)
    TextButton.BackgroundColor3 = fromRGB(255, 255, 255)
    TextButton.ZIndex = p12
    UIKit.corner(TextButton, 14)

    local v22 = UIKit.stroke(TextButton, 4, v21.Color2)

    v22.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    UIKit.gradient(TextButton, v21.Color:Lerp(fromRGB(30, 28, 60), 0.5), fromRGB(18, 18, 38))

    local v23 = UIKit.frame(TextButton, {
        Name = "Pic",
        Transparency = 1,
        Size = UDim2.new(1, -10, 1, -44),
        Position = UDim2.fromOffset(5, 3),
        ZIndex = p12 + 1
    })

    if p9.kind == "fish" then
        local Picture = FishModels.Picture
        local id, v = p9.id, p9.v

        pcall(Picture, v23, id, v)
    else
        local eggPicture = UIKit.eggPicture
        local key = p9.key
        local t6 = {
            Size = UDim2.fromScale(1, 1),
            Position = UDim2.fromScale(0.5, 0.5),
            ZIndex = p12 + 2
        }

        pcall(eggPicture, v23, key, t6)
    end

    local v24 = UIKit.text(TextButton, {
        Name = "Name",
        Stroke = 2,
        Text = if p9.kind == "fish" then fishName(p9) else (crateOf(p9.key) or {}).name or p9.key,
        Size = UDim2.new(1, -8, 0, 20),
        Position = UDim2.new(0, 4, 1, -42),
        ZIndex = p12 + 3
    })
    local UITextSizeConstraint = Instance.new("UITextSizeConstraint")

    UITextSizeConstraint.MaxTextSize = 16
    UITextSizeConstraint.Parent = v24

    local v25 = UIKit.text(TextButton, {
        Name = "Worth",
        TextSize = 15,
        Stroke = 2,
        Text = if p9.kind == "egg" then "Unopened" elseif p9.pct then p9.pct .. "% of best" else NumberFormat.rate(p9.income or 0),
        Size = UDim2.new(1, -8, 0, 18),
        Position = UDim2.new(0, 4, 1, -21),
        Color = if p9.kind == "egg" then fromRGB(225, 205, 255) elseif p9.pct then fromRGB(255, 180, 210) else fromRGB(150, 255, 140),
        ZIndex = p12 + 3
    })
    local v26 = p9.e and Events.ById[p9.e]

    if v26 then
        local v29 = UIKit.frame(TextButton, {
            Name = "Mutation",
            Corner = 10,
            Stroke = 2,
            Size = UDim2.fromOffset(math.min(p10 - 10, #v26.mutation * 8 + 18), 20),
            Position = UDim2.fromOffset(5, 5),
            Color = v26.Color,
            ZIndex = p12 + 4
        })

        UIKit.text(v29, {
            TextSize = 13,
            Stroke = 2,
            Text = string.upper(v26.mutation),
            ZIndex = p12 + 5
        })
    end

    if p13 then
        UIKit.bindPress(TextButton, p13)
    else
        TextButton.Selectable = false
    end

    return TextButton, {
        name = v24,
        value = v25,
        stroke = v22
    }
end

local function emptySlot(p14, p15) -- line: 157
    -- upvalues: UIKit (copy), fromRGB (copy)
    local v30 = UIKit.frame(p14, {
        Name = "Empty",
        Transparency = 0.93,
        Corner = 14,
        Color = fromRGB(255, 255, 255),
        ZIndex = p15
    })

    UIKit.stroke(v30, 2, fromRGB(150, 160, 220)).Transparency = 0.6

    return v30
end

local function badge(p16, p17, p18, p19, p20) -- line: 165
    -- upvalues: UIKit (copy)
    local frame = UIKit.frame
    local t10 = {
        Name = "Badge",
        Corner = 11,
        Stroke = 2,
        Size = UDim2.fromOffset(86, 22)
    }

    if p20 then
        t10.Position = UDim2.new(1, -4, 0, 4)
        t10.AnchorPoint = Vector2.new(1, 0)
    else
        t10.Position = UDim2.new(0.5, 0, 0.42, 0)
        t10.AnchorPoint = Vector2.new(0.5, 0.5)
    end

    t10.Color = p18
    t10.ZIndex = p19

    local v31 = frame(p16, t10)

    UIKit.text(v31, {
        TextSize = 14,
        Stroke = 2,
        Text = p17,
        ZIndex = p19 + 1
    })

    return v31
end

local function offerPanel(p21, p22, p23) -- line: 172
    -- upvalues: UIKit (copy), Left (copy), v1 (copy), v4 (copy), v5 (copy), v6 (copy), v7 (copy)
    local v32 = UIKit.frame(p21, {
        Corner = 20,
        Stroke = 4,
        ZIndex = 12,
        Name = p23,
        Size = UDim2.fromOffset(536, 300),
        Position = UDim2.fromOffset(p22, 0),
        Color = v6,
        Color2 = v7
    })
    local v33 = UIKit.text(v32, {
        Name = "Who",
        TextSize = 28,
        Stroke = 4,
        ZIndex = 13,
        Text = p23,
        Size = UDim2.new(1, -200, 0, 40),
        Position = UDim2.fromOffset(16, 6),
        XAlign = Left
    })

    v33.FontFace = v1

    local v34 = UIKit.frame(v32, {
        Name = "Ready",
        Corner = 17,
        Stroke = 3,
        ZIndex = 13,
        Size = UDim2.fromOffset(170, 34),
        Position = UDim2.new(1, -14, 0, 9),
        AnchorPoint = Vector2.new(1, 0),
        Color = v4,
        Color2 = v5
    })
    local v35 = UIKit.text(v34, {
        Name = "Text",
        Text = "NOT READY",
        TextSize = 19,
        Stroke = 3,
        ZIndex = 14
    })
    local v36 = UIKit.frame(v32, {
        Name = "Grid",
        Transparency = 1,
        ZIndex = 13,
        Size = UDim2.fromOffset(510, 246),
        Position = UDim2.fromOffset(13, 48)
    })
    local UIGridLayout = Instance.new("UIGridLayout")

    UIGridLayout.CellSize = UDim2.fromOffset(120, 118)
    UIGridLayout.CellPadding = UDim2.fromOffset(10, 10)
    UIGridLayout.SortOrder = Enum.SortOrder.LayoutOrder
    UIGridLayout.Parent = v36

    return {
        root = v32,
        who = v33,
        pill = v34,
        pillText = v35,
        grid = v36,
        stroke = v32:FindFirstChildOfClass("UIStroke")
    }
end

local function setPill(p24, p25) -- line: 188
    -- upvalues: v2 (copy), v3 (copy), v4 (copy), v5 (copy)
    p24.pillText.Text = p25 and "READY!" or "NOT READY"

    local UIGradient = p24.pill:FindFirstChildOfClass("UIGradient")

    if UIGradient then
        if p25 then
            UIGradient.Color = ColorSequence.new(v2, v3)
        else
            UIGradient.Color = ColorSequence.new(v4, v5)
        end
    end
end

local function fillOffer(p26, p27, p28) -- line: 196
    -- upvalues: Trade (copy), Trade2 (ref), tile (copy), emptySlot (copy)
    for _, child in ipairs(p26.grid:GetChildren()) do
        if child:IsA("GuiObject") then
            child:Destroy()
        end
    end

    for v37, v38 in ipairs(p27) do
        local grid = p26.grid
        local v39

        if p28 then
            v39 = function() -- line: 203
                -- upvalues: v38 (copy), Trade2 (ref)
                Trade2:FireServer("remove", v38.kind, if v38.kind == "fish" then v38.uid else v38.key)
            end
        end

        local v40 = tile(grid, v38, 120, 118, 14, v39)

        v40.LayoutOrder = v37
        v40.Parent = p26.grid
    end

    for i = #p27 + 1, Trade.MAX_ITEMS do
        emptySlot(p26.grid, 14).LayoutOrder = i
    end
end

local function signature(p29) -- line: 216
    local t11 = {}

    for _, v41 in ipairs(p29) do
        table.insert(t11, if v41.kind == "fish" then "f" .. tostring(v41.uid) else "e" .. tostring(v41.key))
    end

    table.sort(t11)

    return table.concat(t11, ",")
end

local t12 = {}

local function inTradeCounts() -- line: 227
    -- upvalues: t1 (copy)
    local State = t1.State
    local t13 = {}
    local t14 = {}

    if State then
        for _, v43 in ipairs(State.you.items) do
            if v43.kind == "fish" then
                t13[v43.uid] = true
            else
                t14[v43.key] = (t14[v43.key] or 0) + 1
            end
        end
    end

    return t13, t14
end

local function markInventory() -- line: 242
    -- upvalues: HeldFish (copy), fromRGB (copy), badge (copy), t12 (copy), inTradeCounts (copy)
    local v44, v45 = inTradeCounts()

    for _, v46 in pairs(t12) do
        local Badge = v46.button:FindFirstChild("Badge")

        if Badge then
            Badge:Destroy()
        end

        local v47

        if v46.kind == "fish" then
            if v44[v46.value] then
                v47 = true
                badge(v46.button, "IN TRADE", fromRGB(60, 170, 255), 18)
            else
                if HeldFish.Uid == v46.value then
                    badge(v46.button, "IN HAND", fromRGB(120, 120, 140), 18)
                end

                v47 = false
            end
        else
            local v48 = v46.count - (v45[v46.value] or 0)

            badge(v46.button, "x" .. v48, if v48 > 0 then fromRGB(150, 90, 230) else fromRGB(120, 120, 140), 18, true)
            v47 = v48 <= 0
        end

        v46.button.BackgroundTransparency = v47 and 0.55 or 0
    end
end

local function buildInventory() -- line: 266
    -- upvalues: DataClient (copy), HeldFish (copy), Trade2 (ref), t3 (copy), v11 (ref), asItem (copy), tile (copy), t12 (copy), inTradeCounts (copy), markInventory (copy)
    v11 = false

    for _, v51 in pairs(t12) do
        v51.button:Destroy()
    end

    table.clear(t12)

    local invScroll = t3.invScroll
    local t15 = {}

    for _, v52 in ipairs(DataClient.Get("Backpack") or {}) do
        table.insert(t15, (asItem(v52)))
    end

    table.sort(t15, function(p30, p31) -- line: 279
        return (p30.income or 0) > (p31.income or 0)
    end)

    local n1 = 0

    for _, v54 in ipairs(t15) do
        n1 += 1

        local v55 = "f" .. tostring(v54.uid)
        local v56 = tile(invScroll, v54, 110, 116, 14, function() -- line: 285
            -- upvalues: v54 (copy), HeldFish (copy), Trade2 (ref), inTradeCounts (copy)
            if inTradeCounts()[v54.uid] then
                local Trade = Trade2

                Trade:FireServer("remove", "fish", v54.uid)
            elseif HeldFish.Uid == v54.uid then
                HeldFish.Drop()

                local Trade = Trade2

                Trade:FireServer("add", "fish", v54.uid)
            else
                local Trade = Trade2

                Trade:FireServer("add", "fish", v54.uid)
            end
        end)

        v56.LayoutOrder = n1
        v56.Parent = invScroll
        t12[v55] = {
            kind = "fish",
            button = v56,
            value = v54.uid
        }
    end

    local t16 = {}
    local t17 = {}

    for _, v57 in ipairs(DataClient.Get("Eggs") or {}) do
        if type(v57) == "string" then
            if not t16[v57] then
                table.insert(t17, v57)
            end

            t16[v57] = (t16[v57] or 0) + 1
        end
    end

    for _, v58 in ipairs(t17) do
        n1 += 1

        local v59 = tile(invScroll, {
            kind = "egg",
            key = v58
        }, 110, 116, 14, function() -- line: 312
            -- upvalues: t16 (copy), v58 (copy), Trade2 (ref), inTradeCounts (copy)
            local _, v60 = inTradeCounts()

            if (v60[v58] or 0) < t16[v58] then
                Trade2:FireServer("add", "egg", v58)
            else
                Trade2:FireServer("remove", "egg", v58)
            end
        end)

        v59.LayoutOrder = n1
        v59.Parent = invScroll
        t12["e" .. v58] = {
            kind = "egg",
            button = v59,
            value = v58,
            count = t16[v58]
        }
    end

    t3.invEmpty.Visible = n1 == 0
    markInventory()
end

local function buildWindow() -- line: 328
    -- upvalues: RunService (copy), UIKit (copy), DataClient (copy), t1 (copy), LocalPlayer (copy), fromRGB (copy), Left (copy), v1 (copy), v2 (copy), v3 (copy), v6 (copy), v7 (copy), Trade2 (ref), v8 (ref), t3 (copy), v10 (ref), t4 (ref), v11 (ref), offerPanel (copy), buildInventory (copy)
    local Windows = LocalPlayer.PlayerGui:WaitForChild("Windows")

    v8 = UIKit.window(Windows, {
        Name = "Trade",
        Title = "Trade",
        Size = UDim2.fromOffset(1120, 720),
        HeaderColor = fromRGB(90, 200, 255),
        HeaderColor2 = fromRGB(40, 110, 230)
    })

    local Content = v8.Content

    t3.you = offerPanel(Content, 0, "YOUR OFFER")
    t3.them = offerPanel(Content, 556, "THEIR OFFER")

    local v61 = UIKit.frame(Content, {
        Name = "Inventory",
        Corner = 20,
        Stroke = 4,
        ZIndex = 12,
        Size = UDim2.fromOffset(760, 304),
        Position = UDim2.fromOffset(0, 314),
        Color = v6,
        Color2 = v7
    })

    UIKit.text(v61, {
        Name = "Title",
        Text = "YOUR BACKPACK  -  tap a fish or egg to put it in the trade",
        TextSize = 21,
        Stroke = 3,
        ZIndex = 13,
        Size = UDim2.new(1, -28, 0, 30),
        Position = UDim2.fromOffset(16, 6),
        XAlign = Left,
        Color = fromRGB(205, 215, 255)
    })

    local ScrollingFrame = Instance.new("ScrollingFrame")

    ScrollingFrame.Name = "List"
    ScrollingFrame.BackgroundTransparency = 1
    ScrollingFrame.BorderSizePixel = 0
    ScrollingFrame.Size = UDim2.new(1, -20, 1, -46)
    ScrollingFrame.Position = UDim2.fromOffset(12, 40)
    ScrollingFrame.ScrollBarThickness = 10
    ScrollingFrame.ScrollingDirection = Enum.ScrollingDirection.Y
    ScrollingFrame.CanvasSize = UDim2.new()
    ScrollingFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
    ScrollingFrame.ZIndex = 13

    local UIGridLayout = Instance.new("UIGridLayout")

    UIGridLayout.CellSize = UDim2.fromOffset(110, 116)
    UIGridLayout.CellPadding = UDim2.fromOffset(8, 8)
    UIGridLayout.SortOrder = Enum.SortOrder.LayoutOrder
    UIGridLayout.Parent = ScrollingFrame

    local UIPadding = Instance.new("UIPadding")

    UIPadding.PaddingTop = UDim.new(0, 4)
    UIPadding.PaddingLeft = UDim.new(0, 4)
    UIPadding.Parent = ScrollingFrame
    ScrollingFrame.Parent = v61
    t3.invScroll = ScrollingFrame
    t3.invEmpty = UIKit.text(v61, {
        Name = "Empty",
        Text = "Nothing to trade yet - catch some fish!\n(Only fish in your backpack can be traded: pick them up from your pen first.)",
        TextSize = 22,
        Stroke = 3,
        ZIndex = 14,
        Size = UDim2.new(1, -40, 0, 90),
        Position = UDim2.new(0, 20, 0.5, 0),
        AnchorPoint = Vector2.new(0, 0.5),
        Color = fromRGB(190, 195, 230)
    })
    t3.invEmpty.TextWrapped = true
    t3.invEmpty.Visible = false

    local v62 = UIKit.frame(Content, {
        Name = "Controls",
        Corner = 20,
        Stroke = 4,
        ZIndex = 12,
        Size = UDim2.fromOffset(316, 304),
        Position = UDim2.fromOffset(776, 314),
        Color = v6,
        Color2 = v7
    })

    t3.status = UIKit.text(v62, {
        Name = "Status",
        Text = "",
        TextSize = 21,
        Stroke = 3,
        ZIndex = 13,
        Size = UDim2.new(1, -24, 0, 100),
        Position = UDim2.fromOffset(12, 10)
    })
    t3.status.TextWrapped = true
    t3.status.RichText = true
    t3.countdown = UIKit.text(v62, {
        Name = "Countdown",
        Text = "",
        TextSize = 40,
        Stroke = 5,
        ZIndex = 13,
        Size = UDim2.new(1, -24, 0, 48),
        Position = UDim2.fromOffset(12, 112),
        Color = fromRGB(170, 255, 150)
    })
    t3.countdown.FontFace = v1

    local v63, v64 = UIKit.button(v62, {
        Name = "Ready",
        Text = "READY",
        Corner = 20,
        Stroke = 5,
        TextStroke = 4,
        ZIndex = 13,
        Size = UDim2.new(1, -24, 0, 74),
        Position = UDim2.fromOffset(12, 166),
        Color = v2,
        Color2 = v3,
        OnClick = function() -- OnClick | line: 369
            -- upvalues: t1 (copy), Trade2 (ref)
            local State = t1.State

            if State then
                local Trade = Trade2

                Trade:FireServer("ready", not State.you.ready)
            end
        end
    })

    v64.FontFace = v1
    t3.ready = v63
    t3.readyLabel = v64

    local _, v65 = UIKit.button(v62, {
        Name = "Cancel",
        Text = "CANCEL TRADE",
        Corner = 16,
        Stroke = 4,
        TextStroke = 3,
        ZIndex = 13,
        Size = UDim2.new(1, -24, 0, 46),
        Position = UDim2.fromOffset(12, 248),
        Color = UIKit.Colors.Red,
        Color2 = UIKit.Colors.RedDark,
        OnClick = function() -- OnClick | line: 377
            -- upvalues: v8 (ref)
            v8.Close()
        end
    })

    v65.TextSize = 24

    local v66 = v8

    v66.OnClose = function() -- line: 383
        -- upvalues: t1 (copy), Trade2 (ref), v10 (ref), t4 (ref)
        if t1.State and not v10 then
            Trade2:FireServer("cancel")
        end

        t1.State = nil
        t4 = nil
    end

    RunService.RenderStepped:Connect(function() -- line: 392
        -- upvalues: UIKit (copy), t1 (copy), fromRGB (copy), v2 (copy), v8 (ref), t3 (copy)
        local State = t1.State

        if State and v8.IsOpen then
            if State.confirmAt then
                local v68 = math.max(0, State.confirmAt - workspace:GetServerTimeNow())
                local countdown = t3.countdown

                if v68 > 0 then
                    countdown.Text = ("TRADING IN %d"):format((math.ceil(v68)))
                else
                    countdown.Text = "TRADING..."
                end

                local v70 = math.sin(os.clock() * 8) * 0.5 + 0.5

                for _, v71 in ipairs({
                        t3.you,
                        t3.them
                    }) do
                    if v71.stroke then
                        v71.stroke.Color = fromRGB(20, 20, 30):Lerp(v2, v70)
                    end
                end
            else
                t3.countdown.Text = ""

                for _, v72 in ipairs({
                        t3.you,
                        t3.them
                    }) do
                    if v72.stroke and v72.stroke.Color ~= UIKit.Colors.Outline then
                        v72.stroke.Color = UIKit.Colors.Outline
                    end
                end
            end
        end
    end)
    DataClient.Observe("Backpack", function() -- line: 415
        -- upvalues: v8 (ref), v11 (ref), buildInventory (copy)
        v11 = true

        if v8.IsOpen then
            buildInventory()
        end
    end)
    DataClient.Observe("Eggs", function() -- line: 421
        -- upvalues: v8 (ref), v11 (ref), buildInventory (copy)
        v11 = true

        if v8.IsOpen then
            buildInventory()
        end
    end)
end

local function flashThem() -- line: 430
    -- upvalues: TweenService (copy), UIKit (copy), t1 (copy), fromRGB (copy), t3 (copy)
    t1.Flashes += 1

    local root = t3.them.root
    local v73 = UIKit.frame(root, {
        Name = "Flash",
        Transparency = 0.35,
        Corner = 20,
        ZIndex = 20,
        Color = fromRGB(255, 230, 120)
    })

    TweenService:Create(v73, TweenInfo.new(0.7), {
        BackgroundTransparency = 1
    }):Play()
    task.delay(0.75, function() -- line: 435
        -- upvalues: v73 (copy)
        v73:Destroy()
    end)
    UIKit.sound("Twinkle")
end

local function render(p32) -- line: 441
    -- upvalues: Trade (copy), UIKit (copy), t1 (copy), v2 (copy), v3 (copy), v4 (copy), v5 (copy), v8 (ref), t3 (copy), t4 (ref), v11 (ref), setPill (copy), fillOffer (copy), signature (copy), markInventory (copy), buildInventory (copy), flashThem (copy)
    local v74 = not t4 or t4.id ~= p32.id

    t1.State = p32

    if v74 then
        t4 = {
            id = p32.id,
            themSig = signature(p32.them.items)
        }
    end

    if not v8.IsOpen then
        UIKit.closeAllWindows()
        v8.Open()
        v11 = true
    end

    if v11 then
        buildInventory()
    end

    t3.them.who.Text = string.upper(p32.them.name) .. "'S OFFER"
    fillOffer(t3.you, p32.you.items, true)
    fillOffer(t3.them, p32.them.items, false)
    setPill(t3.you, p32.you.ready)
    setPill(t3.them, p32.them.ready)
    markInventory()

    local v75 = signature(p32.them.items)
    local v76 = not v74 and v75 ~= t4.themSig

    t4.themSig = v75

    if v76 then
        flashThem()
    end

    t3.readyLabel.Text = p32.you.ready and "UNREADY" or "READY"
    UIKit.setButtonColor(t3.ready, if p32.you.ready then v4 else v2, if p32.you.ready then v5 else v3)

    local name = p32.them.name
    local v77 = if p32.msg then "<font color=\"#FFD27A\">" .. p32.msg .. "</font>"
        elseif v76 then "<font color=\"#FFD27A\">" .. name .. " changed their offer - check it again!</font>"
        elseif p32.confirmAt then "Both ready! Last chance to check everything."
        elseif p32.you.ready then "Waiting for " .. name .. " to press READY..."
        elseif p32.them.ready then name .. " is ready! Check their offer, then press READY."
        else "Put in up to " .. Trade.MAX_ITEMS .. " fish or eggs, then press READY."

    t3.status.Text = v77
end

local function headshot(p33, p34) -- line: 491
    -- upvalues: Players (copy)
    if not (p34 <= 0) then
        task.spawn(function() -- line: 495
            -- upvalues: p33 (copy), p34 (copy), Players (copy)
            local function v78() -- line: 496
                -- upvalues: p34 (copy), Players (copy)
                return Players:GetUserThumbnailAsync(p34, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size100x100)
            end

            local ok, result = pcall(v78)

            if ok and p33.Parent then
                p33.Image = result
            end
        end)
    end
end

local function buildPopups() -- line: 505
    -- upvalues: RunService (copy), Trade (copy), UIKit (copy), t1 (copy), fromRGB (copy), Left (copy), v1 (copy), v2 (copy), v3 (copy), Trade2 (ref), v9 (ref), t3 (copy)
    v9 = UIKit.screenGui("TradePopups", 8)

    local v79 = UIKit.frame(v9, {
        Name = "Incoming",
        Corner = 22,
        Stroke = 5,
        Size = UDim2.fromOffset(420, 172),
        Position = UDim2.new(1, -24, 0.3, 0),
        AnchorPoint = Vector2.new(1, 0.5),
        Color = fromRGB(40, 110, 220),
        Color2 = fromRGB(18, 34, 90)
    })

    UIKit.dress(v79, 22, fromRGB(170, 220, 255))

    local ImageLabel = Instance.new("ImageLabel")

    ImageLabel.Name = "Avatar"
    ImageLabel.BackgroundColor3 = fromRGB(20, 26, 50)
    ImageLabel.Size = UDim2.fromOffset(76, 76)
    ImageLabel.Position = UDim2.fromOffset(16, 14)
    ImageLabel.ZIndex = 2
    UIKit.corner(ImageLabel, 38)
    ImageLabel.Parent = v79

    local v80 = UIKit.text(v79, {
        Name = "Title",
        Text = "",
        TextSize = 26,
        Stroke = 4,
        ZIndex = 2,
        Size = UDim2.new(1, -116, 0, 34),
        Position = UDim2.fromOffset(104, 14),
        XAlign = Left
    })

    v80.FontFace = v1
    UIKit.text(v79, {
        Name = "Sub",
        Text = "wants to trade with you!",
        TextSize = 20,
        Stroke = 3,
        ZIndex = 2,
        Size = UDim2.new(1, -116, 0, 26),
        Position = UDim2.fromOffset(104, 48),
        XAlign = Left,
        Color = fromRGB(210, 230, 255)
    })

    local v81 = UIKit.frame(v79, {
        Name = "Time",
        Corner = 5,
        ZIndex = 2,
        Size = UDim2.new(1, -120, 0, 10),
        Position = UDim2.fromOffset(104, 80),
        Color = fromRGB(14, 18, 40)
    })
    local v82 = UIKit.frame(v81, {
        Name = "Fill",
        Corner = 5,
        ZIndex = 3,
        Size = UDim2.fromScale(1, 1),
        Color = fromRGB(140, 220, 255)
    })
    local v83 = UIKit.button(v79, {
        Name = "Accept",
        Text = "ACCEPT",
        Corner = 16,
        Stroke = 4,
        TextStroke = 3,
        ZIndex = 2,
        Size = UDim2.new(0.5, -22, 0, 54),
        Position = UDim2.new(0, 16, 1, -66),
        Color = v2,
        Color2 = v3,
        OnClick = function() -- OnClick | line: 523
            -- upvalues: t1 (copy), Trade2 (ref)
            local Incoming = t1.Incoming

            if Incoming then
                local Trade = Trade2

                Trade:FireServer("respond", Incoming.userId, true)
            end
        end
    })
    local v84 = UIKit.button(v79, {
        Name = "Decline",
        Text = "DECLINE",
        Corner = 16,
        Stroke = 4,
        TextStroke = 3,
        ZIndex = 2,
        Size = UDim2.new(0.5, -22, 0, 54),
        Position = UDim2.new(0.5, 6, 1, -66),
        Color = UIKit.Colors.Red,
        Color2 = UIKit.Colors.RedDark,
        OnClick = function() -- OnClick | line: 529
            -- upvalues: t1 (copy), Trade2 (ref)
            local Incoming = t1.Incoming

            if Incoming then
                local Trade = Trade2

                Trade:FireServer("respond", Incoming.userId, false)
            end
        end
    })

    v79.Visible = false
    t3.inc = {
        root = v79,
        pic = ImageLabel,
        title = v80,
        bar = v82,
        accept = v83,
        decline = v84
    }

    local v85 = UIKit.frame(v9, {
        Name = "Outgoing",
        Corner = 20,
        Stroke = 4,
        Size = UDim2.fromOffset(520, 70),
        Position = UDim2.new(0.5, 0, 1, -150),
        AnchorPoint = Vector2.new(0.5, 1),
        Color = fromRGB(30, 40, 80),
        Color2 = fromRGB(16, 18, 44)
    })
    local v86 = UIKit.text(v85, {
        Name = "Text",
        Text = "",
        TextSize = 21,
        Stroke = 3,
        ZIndex = 2,
        Size = UDim2.new(1, -170, 0, 40),
        Position = UDim2.fromOffset(18, 6),
        XAlign = Left
    })
    local v87 = UIKit.frame(v85, {
        Name = "Time",
        Corner = 4,
        ZIndex = 2,
        Size = UDim2.new(1, -170, 0, 8),
        Position = UDim2.fromOffset(18, 50),
        Color = fromRGB(10, 12, 30)
    })
    local v88 = UIKit.frame(v87, {
        Name = "Fill",
        Corner = 4,
        ZIndex = 3,
        Size = UDim2.fromScale(1, 1),
        Color = fromRGB(140, 220, 255)
    })

    UIKit.button(v85, {
        Name = "Withdraw",
        Text = "CANCEL",
        Corner = 14,
        Stroke = 4,
        TextStroke = 3,
        ZIndex = 2,
        Size = UDim2.fromOffset(130, 48),
        Position = UDim2.new(1, -12, 0.5, 0),
        AnchorPoint = Vector2.new(1, 0.5),
        Color = UIKit.Colors.Red,
        Color2 = UIKit.Colors.RedDark,
        OnClick = function() -- OnClick | line: 542
            -- upvalues: Trade2 (ref)
            Trade2:FireServer("withdraw")
        end
    })
    v85.Visible = false
    t3.out = {
        root = v85,
        text = v86,
        bar = v88
    }
    RunService.Heartbeat:Connect(function() -- line: 548
        -- upvalues: v79 (copy), v82 (copy), v85 (copy), v88 (copy), Trade (copy), t1 (copy)
        local Incoming = t1.Incoming

        if Incoming then
            local v89 = Incoming.expires - workspace:GetServerTimeNow()

            if v89 <= 0 then
                t1.Incoming = nil
                v79.Visible = false
            else
                v82.Size = UDim2.fromScale(math.clamp(v89 / Trade.REQUEST_TIME, 0, 1), 1)
            end
        end

        local Outgoing = t1.Outgoing

        if not Outgoing then
            return
        end

        local v91 = Outgoing.expires - workspace:GetServerTimeNow()

        if v91 <= 0 then
            t1.Outgoing = nil
            v85.Visible = false
        else
            v88.Size = UDim2.fromScale(math.clamp(v91 / Trade.REQUEST_TIME, 0, 1), 1)
        end
    end)
end

function t1.Request(p35) -- line: 573
    -- upvalues: LocalPlayer (copy), Trade2 (ref)
    if p35 and p35 ~= LocalPlayer then
        Trade2:FireServer("request", p35.UserId)
    end
end

local function refreshPicker() -- line: 580
    -- upvalues: Players (copy), UIKit (copy), t1 (copy), LocalPlayer (copy), fromRGB (copy), Left (copy), v6 (copy), v7 (copy), t2 (ref)
    local list = t2.list

    for _, child in ipairs(list:GetChildren()) do
        if child:IsA("GuiObject") then
            child:Destroy()
        end
    end

    local t19 = {}

    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            table.insert(t19, player)
        end
    end

    table.sort(t19, function(p36, p37) -- line: 593
        return p36.DisplayName:lower() < p37.DisplayName:lower()
    end)

    for v93, v94 in ipairs(t19) do
        local v95 = UIKit.frame(list, {
            Corner = 18,
            Stroke = 3,
            ZIndex = 12,
            Name = v94.Name,
            Size = UDim2.new(1, -16, 0, 84),
            Color = v6,
            Color2 = v7
        })

        v95.LayoutOrder = v93

        local ImageLabel = Instance.new("ImageLabel")

        ImageLabel.BackgroundColor3 = fromRGB(20, 26, 50)
        ImageLabel.Size = UDim2.fromOffset(64, 64)
        ImageLabel.Position = UDim2.fromOffset(10, 10)
        ImageLabel.ZIndex = 13
        UIKit.corner(ImageLabel, 32)
        ImageLabel.Parent = v95

        local UserId = v94.UserId

        if not (UserId <= 0) then
            task.spawn(function() -- line: 495
                -- upvalues: ImageLabel (copy), UserId (copy), Players (copy)
                local function v96() -- line: 496
                    -- upvalues: UserId (copy), Players (copy)
                    return Players:GetUserThumbnailAsync(UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size100x100)
                end

                local ok, result = pcall(v96)

                if ok and ImageLabel.Parent then
                    ImageLabel.Image = result
                end
            end)
        end

        UIKit.text(v95, {
            Name = "Name",
            TextSize = 26,
            Stroke = 3,
            ZIndex = 13,
            Text = v94.DisplayName,
            Size = UDim2.new(1, -260, 0, 34),
            Position = UDim2.fromOffset(86, 12),
            XAlign = Left
        })
        UIKit.text(v95, {
            Name = "User",
            TextSize = 18,
            Stroke = 2,
            ZIndex = 13,
            Text = "@" .. v94.Name,
            Size = UDim2.new(1, -260, 0, 24),
            Position = UDim2.fromOffset(86, 46),
            XAlign = Left,
            Color = fromRGB(170, 180, 220)
        })
        UIKit.button(v95, {
            Name = "Trade",
            Text = "TRADE",
            Corner = 16,
            Stroke = 4,
            TextStroke = 3,
            ZIndex = 13,
            Size = UDim2.fromOffset(150, 58),
            Position = UDim2.new(1, -12, 0.5, 0),
            AnchorPoint = Vector2.new(1, 0.5),
            Color = fromRGB(90, 200, 255),
            Color2 = fromRGB(40, 110, 230),
            OnClick = function() -- OnClick | line: 609
                -- upvalues: v94 (copy), t1 (copy), t2 (ref)
                t1.Request(v94)
                t2.win.Close()
            end
        })
    end

    t2.empty.Visible = #t19 == 0
end

local function buildPicker() -- line: 617
    -- upvalues: Players (copy), UIKit (copy), TopBar (copy), LocalPlayer (copy), fromRGB (copy), Left (copy), t2 (ref), refreshPicker (copy)
    local Windows = LocalPlayer.PlayerGui:WaitForChild("Windows")
    local v97 = UIKit.window(Windows, {
        Name = "TradePlayers",
        Title = "Trade",
        Size = UDim2.fromOffset(640, 560),
        HeaderColor = fromRGB(90, 200, 255),
        HeaderColor2 = fromRGB(40, 110, 230)
    })
    local Content = v97.Content

    UIKit.text(Content, {
        Name = "Hint",
        Text = "Pick someone to trade with (or walk up to them and press T)",
        TextSize = 20,
        Stroke = 3,
        ZIndex = 12,
        Size = UDim2.new(1, -10, 0, 28),
        Position = UDim2.fromOffset(6, 0),
        XAlign = Left,
        Color = fromRGB(200, 210, 255)
    })

    local ScrollingFrame = Instance.new("ScrollingFrame")

    ScrollingFrame.Name = "List"
    ScrollingFrame.BackgroundTransparency = 1
    ScrollingFrame.BorderSizePixel = 0
    ScrollingFrame.Size = UDim2.new(1, 0, 1, -38)
    ScrollingFrame.Position = UDim2.fromOffset(0, 36)
    ScrollingFrame.ScrollBarThickness = 10
    ScrollingFrame.CanvasSize = UDim2.new()
    ScrollingFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
    ScrollingFrame.ZIndex = 12

    local UIListLayout = Instance.new("UIListLayout")

    UIListLayout.Padding = UDim.new(0, 10)
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    UIListLayout.Parent = ScrollingFrame

    local UIPadding = Instance.new("UIPadding")

    UIPadding.PaddingTop = UDim.new(0, 4)
    UIPadding.PaddingLeft = UDim.new(0, 6)
    UIPadding.Parent = ScrollingFrame
    ScrollingFrame.Parent = Content

    local v98 = UIKit.text(Content, {
        Name = "Empty",
        Text = "Nobody else is in this server right now.",
        TextSize = 24,
        Stroke = 3,
        ZIndex = 13,
        Size = UDim2.new(1, -40, 0, 60),
        Position = UDim2.new(0, 20, 0.45, 0),
        Color = fromRGB(190, 195, 230)
    })

    v98.Visible = false
    t2 = {
        win = v97,
        list = ScrollingFrame,
        empty = v98
    }
    v97.OnOpen = refreshPicker
    Players.PlayerAdded:Connect(function() -- line: 645
        -- upvalues: v97 (copy), refreshPicker (copy)
        if v97.IsOpen then
            refreshPicker()
        end
    end)
    Players.PlayerRemoving:Connect(function() -- line: 650
        -- upvalues: v97 (copy), refreshPicker (copy)
        if v97.IsOpen then
            task.defer(refreshPicker)
        end
    end)

    local v99 = TopBar.RoundButton("Trade", 35)
    local ImageLabel = Instance.new("ImageLabel")

    ImageLabel.Name = "Icon"
    ImageLabel.BackgroundTransparency = 1
    ImageLabel.Image = "rbxassetid://114322362924633"
    ImageLabel.ScaleType = Enum.ScaleType.Fit
    ImageLabel.Size = UDim2.fromOffset(32, 32)
    ImageLabel.Position = UDim2.fromScale(0.5, 0.5)
    ImageLabel.AnchorPoint = Vector2.new(0.5, 0.5)
    ImageLabel.ZIndex = 2
    ImageLabel.Parent = v99
    UIKit.bindPress(v99, function() -- line: 667
        -- upvalues: v97 (copy)
        v97.Toggle()
    end)
    t2.button = v99
end

local t21 = {}
local t22 = {}

t22.__index = t22
t22.BUSY_MODES = {
    cast = true,
    cutscene = true
}

function t22.new() -- line: 680
    -- upvalues: t22 (copy)
    local self = setmetatable({}, t22)

    self.Busy = false

    return self
end

function t22:Step(p39) -- line: 686
    -- upvalues: HUD (copy), t1 (copy), t2 (ref)
    local v101 = self.BUSY_MODES[HUD.GetMode()] == true

    if v101 == self.Busy then
        return
    end

    self.Busy = v101

    if t2 and t2.button then
        t2.button.Visible = not v101
    end

    p39(t1.State == nil)

    if v101 and self.OnBusy then
        self.OnBusy()
    end
end

local v102 = t22.new()

t1.Gate = v102

local t24 = {}

t24.__index = t24
t24.RANGE = 10
t24.EVERY = 0.1

function t24.new() -- line: 709
    -- upvalues: t24 (copy)
    return (setmetatable({
        Wanted = true,
        Next = 0
    }, t24))
end

function t24.InRange(_, p41) -- line: 713
    -- upvalues: LocalPlayer (copy), t24 (copy)
    local Character = LocalPlayer.Character
    local HumanoidRootPart = Character and Character:FindFirstChild("HumanoidRootPart")
    local Parent = p41.Parent

    if not (HumanoidRootPart and Parent and Parent:IsA("BasePart")) then
        return false
    end

    return (HumanoidRootPart.Position - Parent.Position).Magnitude <= t24.RANGE
end

local v103 = t24.new()

local function promptFor(p42, p43) -- line: 725
    -- upvalues: t1 (copy), t21 (copy), v102 (copy), t24 (copy), v103 (copy)
    local v104 = p43:WaitForChild("HumanoidRootPart", 10)

    if v104 and (not t21[p42] or t21[p42].Parent ~= v104) then
        local ProximityPrompt = Instance.new("ProximityPrompt")

        ProximityPrompt.Name = "TradePrompt"
        ProximityPrompt.ActionText = "Trade"
        ProximityPrompt.ObjectText = p42.DisplayName
        ProximityPrompt.KeyboardKeyCode = Enum.KeyCode.T
        ProximityPrompt.GamepadKeyCode = Enum.KeyCode.ButtonY
        ProximityPrompt.HoldDuration = 0.25
        ProximityPrompt.MaxActivationDistance = t24.RANGE
        ProximityPrompt.RequiresLineOfSight = false

        if t1.State ~= nil then
            ProximityPrompt.Enabled = false
        else
            ProximityPrompt.Enabled = not v102.Busy and v103:InRange(ProximityPrompt)
        end

        ProximityPrompt.Triggered:Connect(function() -- line: 740
            -- upvalues: p42 (copy), t1 (copy)
            t1.Request(p42)
        end)
        ProximityPrompt.Parent = v104
        t21[p42] = ProximityPrompt
    end
end

local function watchPlayer(p44) -- line: 746
    -- upvalues: LocalPlayer (copy), promptFor (copy)
    if p44 == LocalPlayer then
        return
    end

    p44.CharacterAdded:Connect(function(p45) -- line: 750
        -- upvalues: p44 (copy), promptFor (copy)
        promptFor(p44, p45)
    end)

    if p44.Character then
        task.spawn(promptFor, p44, p44.Character)
    end
end

local function setPrompts(p46) -- line: 757
    -- upvalues: t21 (copy), v102 (copy), v103 (copy)
    v103.Wanted = p46

    for _, v105 in pairs(t21) do
        if v105.Parent then
            v105.Enabled = p46 and not v102.Busy and v103:InRange(v105)
        end
    end
end

function t24.Step(p47) -- line: 766
    -- upvalues: t24 (copy), setPrompts (copy)
    local elapsed = os.clock()

    if not (elapsed < p47.Next) then
        p47.Next = elapsed + t24.EVERY
        setPrompts(p47.Wanted)
    end
end

local function onEvent(p48, p49) -- line: 776
    -- upvalues: Players (copy), UIKit (copy), Toasts (copy), t1 (copy), LocalPlayer (copy), fromRGB (copy), v1 (copy), Trade2 (ref), v8 (ref), v9 (ref), t3 (copy), v10 (ref), tile (copy), render (copy), t21 (copy), v102 (copy), v103 (copy)
    if v102.Busy and p48 == "incoming" and type(p49) == "table" then
        Trade2:FireServer("respond", p49.userId, false)
    elseif v102.Busy and p48 == "state" then
        Trade2:FireServer("cancel")
    elseif p48 == "incoming" and type(p49) == "table" then
        t1.Incoming = p49
        t3.inc.title.Text = tostring(p49.name)
        t3.inc.pic.Image = ""

        local pic = t3.inc.pic
        local userId = p49.userId

        if not (userId <= 0) then
            task.spawn(function() -- line: 495
                -- upvalues: pic (copy), userId (copy), Players (copy)
                local function v106() -- line: 496
                    -- upvalues: userId (copy), Players (copy)
                    return Players:GetUserThumbnailAsync(userId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size100x100)
                end

                local ok, result = pcall(v106)

                if ok and pic.Parent then
                    pic.Image = result
                end
            end)
        end

        t3.inc.root.Visible = true
        UIKit.pop(t3.inc.root, 0.7)
        UIKit.sound("ToastGold")
    elseif p48 == "sent" and type(p49) == "table" then
        t1.Outgoing = p49
        t3.out.text.Text = "Trade request sent to " .. tostring(p49.name)

        local Held = LocalPlayer.PlayerGui:FindFirstChild("Held")
        local Panel = Held and Held:FindFirstChild("Panel")

        t3.out.root.Position = UDim2.new(0.5, 0, 1, not (Panel and Panel.Visible) and -150 or -360)
        t3.out.root.Visible = true
        UIKit.pop(t3.out.root, 0.8)
    elseif p48 == "requestOver" then
        if t1.Incoming and (p49 == nil or t1.Incoming.userId == p49) then
            t1.Incoming = nil
            t3.inc.root.Visible = false
        end

        if t1.Outgoing and (p49 == nil or t1.Outgoing.userId == p49) then
            t1.Outgoing = nil
            t3.out.root.Visible = false
        end
    elseif p48 == "state" and type(p49) == "table" then
        t1.Incoming = nil
        t1.Outgoing = nil
        t3.inc.root.Visible = false
        t3.out.root.Visible = false
        v103.Wanted = false

        for _, v107 in pairs(t21) do
            if v107.Parent then
                v107.Enabled = false
            end
        end

        render(p49)
    elseif p48 == "closed" then
        t1.State = nil
        v103.Wanted = true

        for _, v108 in pairs(t21) do
            if v108.Parent then
                v108.Enabled = not v102.Busy and v103:InRange(v108)
            end
        end

        if v8.IsOpen then
            v10 = true
            v8.Close()
            v10 = false
        end

        local v109 = if type(p49) == "string" then p49 else "The trade was cancelled"

        table.insert(t1.Notes, v109)
        Toasts.Show("info", v109)
    elseif p48 ~= "done" or type(p49) ~= "table" then
        if p48 == "note" and type(p49) == "string" then
            table.insert(t1.Notes, p49)
            Toasts.Show("info", p49)
        end
    else
        t1.Done += 1
        t1.State = nil
        v103.Wanted = true

        for _, v110 in pairs(t21) do
            if v110.Parent then
                v110.Enabled = not v102.Busy and v103:InRange(v110)
            end
        end

        if v8.IsOpen then
            v10 = true
            v8.Close()
            v10 = false
        end

        UIKit.sound("RevealGood")
        UIKit.sound("Coins")

        local v111 = if type(p49.got) == "table" then #p49.got else 0
        local v112 = ("Trade with %s complete! You got %d %s."):format(tostring(p49.name), v111, if v111 == 1 then "thing" else "things")

        table.insert(t1.Notes, v112)
        Toasts.Show("success", v112)

        if v111 > 0 then
            local v116 = UIKit.frame(v9, {
                Name = "Got",
                Corner = 24,
                Stroke = 5,
                ZIndex = 20,
                Size = UDim2.fromOffset(math.min(v111, 4) * 130 + 40, math.ceil(v111 / 4) * 128 + 80),
                Position = UDim2.fromScale(0.5, 0.5),
                AnchorPoint = Vector2.new(0.5, 0.5),
                Color = fromRGB(40, 110, 220),
                Color2 = fromRGB(18, 34, 90)
            })

            UIKit.dress(v116, 24, fromRGB(170, 220, 255), 20)

            local v117 = UIKit.text(v116, {
                Name = "Title",
                Text = "TRADE COMPLETE!",
                TextSize = 36,
                Stroke = 4,
                ZIndex = 21,
                Size = UDim2.new(1, -20, 0, 50),
                Position = UDim2.fromOffset(10, 8)
            })

            v117.FontFace = v1
            UIKit.gradient(v117, fromRGB(255, 255, 255), fromRGB(170, 255, 150))

            for v118, v119 in ipairs(p49.got) do
                if v118 > 8 then
                    break
                end

                local v120 = tile(v116, v119, 120, 118, 22, nil)

                v120.Position = UDim2.fromOffset(20 + (v118 - 1) % 4 * 130, math.floor((v118 - 1) / 4) * 128 + 62)
                v120.Parent = v116
            end

            UIKit.pop(v116, 0.6)
            task.delay(3.2, function() -- line: 854
                -- upvalues: v116 (copy), UIKit (copy)
                UIKit.tween(UIKit.scaleOf(v116), 0.2, {
                    Scale = 0
                }, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
                task.delay(0.25, function() -- line: 856
                    -- upvalues: v116 (copy)
                    v116:Destroy()
                end)
            end)
        end
    end
end

function t1.Init() -- line: 866
    -- upvalues: Players (copy), RunService (copy), ReplicatedStorage (copy), t1 (copy), LocalPlayer (copy), Trade2 (ref), v8 (ref), buildWindow (copy), buildPopups (copy), buildPicker (copy), t21 (copy), v102 (copy), v103 (copy), promptFor (copy), watchPlayer (copy), setPrompts (copy), onEvent (copy)
    Trade2 = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("Trade")
    buildWindow()
    buildPopups()
    buildPicker()
    Trade2.OnClientEvent:Connect(function(p50, p51) -- line: 871
        -- upvalues: onEvent (copy)
        local ok, result = pcall(onEvent, p50, p51)

        if not ok then
            warn("[TradeWindow] " .. tostring(result))
        end
    end)

    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            player.CharacterAdded:Connect(function(p52) -- line: 750
                -- upvalues: player (copy), promptFor (copy)
                promptFor(player, p52)
            end)

            if player.Character then
                task.spawn(promptFor, player, player.Character)
            end
        end
    end

    v102.OnBusy = function() -- line: 880
        -- upvalues: t1 (copy), Trade2 (ref), v8 (ref)
        if t1.Incoming then
            Trade2:FireServer("respond", t1.Incoming.userId, false)
        end

        if t1.State and v8.IsOpen then
            v8.Close()
        end
    end

    RunService.Heartbeat:Connect(function() -- line: 888
        -- upvalues: v102 (copy), v103 (copy), setPrompts (copy)
        v102:Step(setPrompts)
        v103:Step()
    end)
    Players.PlayerAdded:Connect(watchPlayer)
    Players.PlayerRemoving:Connect(function(p53) -- line: 893
        -- upvalues: t21 (copy)
        local v123 = t21[p53]

        if v123 then
            v123:Destroy()
        end

        t21[p53] = nil
    end)
end

function t1.Describe() -- line: 903
    -- upvalues: t1 (copy), v8 (ref), t3 (copy)
    local State = t1.State
    local t27 = {
        "open=" .. tostring(v8 and v8.IsOpen)
    }

    if State then
        table.insert(t27, ("you=%d(%s) them=%d(%s) confirm=%s"):format(#State.you.items, tostring(State.you.ready), #State.them.items, tostring(State.them.ready), (tostring(State.confirmAt ~= nil))))
        table.insert(t27, "status=" .. t3.status.Text)
    end

    table.insert(t27, "incoming=" .. tostring(t1.Incoming and t1.Incoming.name))
    table.insert(t27, "outgoing=" .. tostring(t1.Outgoing and t1.Outgoing.name))
    table.insert(t27, "done=" .. t1.Done .. " flashes=" .. t1.Flashes)
    table.insert(t27, "lastNote=" .. tostring(t1.Notes[#t1.Notes]))

    return table.concat(t27, " | ")
end

function t1.Test(p54, p55) -- line: 918
    -- upvalues: DataClient (copy), HeldFish (copy), t1 (copy), Trade2 (ref), v8 (ref), t2 (ref), inTradeCounts (copy)
    if p54 == "addFish" then
        local v139 = inTradeCounts()

        for _, v140 in ipairs(DataClient.Get("Backpack") or {}) do
            if not v139[v140.uid] and v140.uid ~= HeldFish.Uid then
                Trade2:FireServer("add", "fish", v140.uid)

                return v140.id
            end
        end

        return "none"
    end

    if p54 == "removeFirst" then
        local State = t1.State
        local v141 = State and State.you.items[1]

        if v141 then
            Trade2:FireServer("remove", v141.kind, if v141.kind == "fish" then v141.uid else v141.key)
        end
    elseif p54 == "ready" then
        Trade2:FireServer("ready", p55 ~= false)
    elseif p54 == "accept" or p54 == "decline" then
        local Incoming = t1.Incoming

        if Incoming then
            Trade2:FireServer("respond", Incoming.userId, p54 == "accept")
        end
    elseif p54 == "close" then
        if v8.IsOpen then
            v8.Close()
        end
    elseif p54 == "picker" then
        t2.win.Open()
    end

    return "ok"
end

return t1
