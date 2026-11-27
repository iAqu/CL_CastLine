-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Config = require(ReplicatedStorage.Shared.Config)
local Animals = require(ReplicatedStorage.Shared.Animals)
local Format = require(ReplicatedStorage.Shared.Format)
local AnimalModel = require(ReplicatedStorage.Shared.AnimalModel)
local Remotes = require(ReplicatedStorage.Shared.Remotes)
local UIUtil = require(script.Parent.UIUtil)
local Viewport = require(script.Parent.Viewport)
local RarityText = require(script.Parent.RarityText)
local AnimalsPanel = require(script.Parent.AnimalsPanel)
local Kit = require(script.Parent.Parent.MiniGames.Kit)
local Style = require(script.Parent.Parent.Shop.Style)
local LocalPlayer = Players.LocalPlayer
local t1 = {}
local ScreenGui, v1, v2, v3, ScrollingFrame, v4, v5, v6, v7, v8, ScrollingFrame2, v9, v10, v11
local t2 = {}

local function clearChildren(p1, p2) -- line: 39
    for _, child in p1:GetChildren() do
        if child:IsA("GuiObject") and child.Name ~= p2 then
            child:Destroy()
        end
    end
end

local function tile(p3, p4, p5, p6) -- line: 48
    -- upvalues: Config (copy), Animals (copy), Format (copy), AnimalModel (copy), UIUtil (copy), Viewport (copy), RarityText (copy), Kit (copy), Style (copy)
    local v12 = Animals.get(p4.Id)
    local v13 = v12 and Config.RarityByName[v12.Rarity]
    local v14 = Style.card(p3, if v13 then v13.Color else Style.GREY, {
        Name = p4.Uid,
        LayoutOrder = p5,
        Size = UDim2.fromOffset(116, 136)
    })
    local ViewportFrame = Instance.new("ViewportFrame")

    ViewportFrame.BackgroundTransparency = 1
    ViewportFrame.Position = UDim2.fromOffset(8, 6)
    ViewportFrame.Size = UDim2.new(1, -16, 0, 86)
    ViewportFrame.ZIndex = 2
    ViewportFrame.Parent = v14

    local v15 = v12 and AnimalModel.clone(p4.Id, 4, p4.Mutation)

    if v15 then
        Viewport.show(ViewportFrame, v15, 50, 0.85)
    end

    local v16 = Kit.text(v14, Animals.displayName(p4), {
        Name = "AnimalName",
        ZIndex = 3,
        StrokeThickness = 2,
        AnchorPoint = Vector2.new(0.5, 1),
        Position = UDim2.new(0.5, 0, 1, -6),
        Size = UDim2.new(1, -10, 0, 38)
    })

    if v13 then
        RarityText.apply(v16, v13)
    end

    Kit.text(v14, Format.money(Animals.income(p4)) .. "/s", {
        Name = "Rate",
        ZIndex = 4,
        StrokeThickness = 2,
        AnchorPoint = Vector2.new(0.5, 0),
        Position = UDim2.new(0.5, 0, 0, 4),
        Size = UDim2.new(1, -10, 0, 26),
        TextColor3 = Color3.fromRGB(120, 255, 90)
    })

    if p6 then
        local TextButton = Instance.new("TextButton")

        TextButton.Name = "Hit"
        TextButton.BackgroundTransparency = 1
        TextButton.Text = ""
        TextButton.Size = UDim2.fromScale(1, 1)
        TextButton.ZIndex = 5
        TextButton.Parent = v14
        UIUtil.bindButton(TextButton, p6, v14)
    end

    return v14
end

local function grid(p7, p8) -- line: 96
    -- upvalues: Kit (copy)
    local v17 = Kit.frame(p7, p8)

    v17.BackgroundTransparency = 1

    local UIGridLayout = Instance.new("UIGridLayout")

    UIGridLayout.CellSize = UDim2.fromOffset(116, 136)
    UIGridLayout.CellPadding = UDim2.fromOffset(10, 10)
    UIGridLayout.SortOrder = Enum.SortOrder.LayoutOrder
    UIGridLayout.Parent = v17

    return v17
end

local function sendOffer() -- line: 107
    -- upvalues: Remotes (copy), t2 (ref)
    local Trade = Remotes.Trade

    Trade:FireServer("Offer", t2)
end

local t4 = {}
local v18

local function toggle(p9) -- line: 114
    -- upvalues: Animals (copy), Remotes (copy), UIUtil (copy), t1 (copy), t2 (ref)
    if not Animals.isTradeable(p9) then
        UIUtil.toast("Shop animals can't be traded! (Limited ones can)", "error")

        return
    end

    local v19 = table.find(t2, p9.Uid)

    if v19 then
        table.remove(t2, v19)
    else
        if #t2 >= 8 then
            UIUtil.toast(`Up to {8} animals per trade!`, "error")

            return
        end

        local t5 = t2

        table.insert(t5, p9.Uid)
    end

    UIUtil.sound("Click", 0.5)

    local Trade = Remotes.Trade

    Trade:FireServer("Offer", t2)
    t1.renderBag()
end

function t1.renderBag() -- line: 133
    -- upvalues: Animals (copy), AnimalsPanel (copy), Kit (copy), Style (copy), ScrollingFrame2 (ref), t2 (ref), tile (copy), t4 (copy), v18 (ref), toggle (copy)
    local v20 = table.clone(AnimalsPanel.items or {})

    for _, v21 in AnimalsPanel.placed or {} do
        table.insert(v20, v21)
    end

    table.sort(v20, function(p10, p11) -- line: 139
        -- upvalues: Animals (copy)
        local v22 = Animals.income(p10)
        local v23 = Animals.income(p11)

        if v22 == v23 then
            return p10.Uid < p11.Uid
        end

        return v23 < v22
    end)

    local t7 = {}

    for v24, v25 in v20 do
        t7[v25.Uid] = true

        local v26 = t4[v25.Uid]

        if not v26 then
            local v27 = tile(ScrollingFrame2, v25, v24, function() -- line: 148
                -- upvalues: v25 (copy), toggle (copy)
                toggle(v25)
            end)

            v26 = {
                card = v27,
                mark = Kit.text(v27, "", {
                    Name = "Mark",
                    ZIndex = 4,
                    StrokeThickness = 4,
                    AnchorPoint = Vector2.new(0.5, 0.5),
                    Position = UDim2.fromScale(0.5, 0.4),
                    Size = UDim2.fromOffset(80, 50)
                })
            }
            t4[v25.Uid] = v26
        end

        local v28 = not Animals.isTradeable(v25)
        local v29 = Animals.isLimitedTradeable(v25)
        local v30 = table.find(t2, v25.Uid) ~= nil

        v26.card.LayoutOrder = v24
        v26.card.BackgroundTransparency = (v30 or v28) and 0.5 or 0

        local mark = v26.mark

        if v28 then
            mark.Text = "SHOP"
        elseif v30 then
            mark.Text = "✔"
        elseif v29 then
            mark.Text = "LIMITED"
        else
            mark.Text = ""
        end

        local mark2 = v26.mark

        if v28 then
            mark2.TextColor3 = Style.SAND
        elseif v30 then
            mark2.TextColor3 = Style.MINT
        else
            mark2.TextColor3 = Style.YELLOW
        end
    end

    for v31, v32 in t4 do
        if not t7[v31] then
            v32.card:Destroy()
            t4[v31] = nil
        end
    end

    v18.Visible = #v20 == 0
end

local renderBag = t1.renderBag

local function renderTrade() -- line: 180
    -- upvalues: Style (copy), ScreenGui (ref), v1 (ref), v5 (ref), v6 (ref), v7 (ref), v8 (ref), v9 (ref), v10 (ref), v11 (ref), clearChildren (copy), tile (copy), renderBag (copy)
    if not v11 then
        return
    end

    local v34 = v1

    v34.Text = ("TRADING WITH %*"):format((string.upper(v11.OtherName)))
    clearChildren(v5)
    clearChildren(v6)

    for v35, v36 in v11.Mine do
        tile(v5, v36, v35)
    end

    for v37, v38 in v11.Theirs do
        tile(v6, v38, v37)
    end

    local v39 = v7

    v39.Text = ("YOU GIVE%*"):format(v11.MyReady and "  <font color=\"#96FFAA\">READY ✔</font>" or "")

    local v40 = v8

    v40.Text = ("%* GIVES%*"):format(string.upper(v11.OtherName), v11.TheirReady and "  <font color=\"#96FFAA\">READY ✔</font>" or "")
    v10.Label.Text = v11.MyReady and "NOT READY" or "READY"

    local v41 = v10

    if v11.MyReady then
        v41.BackgroundColor3 = Style.GREY
    else
        v41.BackgroundColor3 = Style.BUY
    end

    if v11.SwapAt then
        task.spawn(function() -- line: 198
            -- upvalues: ScreenGui (ref), v9 (ref), v11 (ref)
            local SwapAt = v11.SwapAt

            while v11 and v11.SwapAt == SwapAt and ScreenGui.Enabled do
                local v44 = math.max(0, (math.ceil(SwapAt - workspace:GetServerTimeNow())))

                v9.Text = ("Swapping in <font color=\"#FFE15A\">%*</font>..."):format(v44)
                task.wait(0.1)
            end
        end)
    elseif v11.MyReady then
        local v46 = v9

        v46.Text = ("Waiting for %*..."):format(v11.OtherName)
    else
        local v47 = v9

        v47.Text = #v11.Mine == 0 and "Tap your animals below to offer them (or give nothing: a gift!)" or "Happy with it? Hit READY!"
    end

    renderBag()
end

local function renderPick() -- line: 214
    -- upvalues: Players (copy), Remotes (copy), Kit (copy), Style (copy), LocalPlayer (copy), ScrollingFrame (ref), v4 (ref), clearChildren (copy)
    clearChildren(ScrollingFrame)

    local t8 = {}

    for _, player in Players:GetPlayers() do
        if player ~= LocalPlayer then
            table.insert(t8, player)
        end
    end

    local v48 = v4

    v48.Visible = #t8 == 0

    for v49, v50 in t8 do
        local v51 = Style.card(ScrollingFrame, Style.OCEAN, {
            Name = tostring(v50.UserId),
            LayoutOrder = v49,
            Size = UDim2.new(1, -16, 0, 96)
        })
        local ImageLabel = Instance.new("ImageLabel")

        ImageLabel.BackgroundTransparency = 1
        ImageLabel.Position = UDim2.fromOffset(12, 8)
        ImageLabel.Size = UDim2.fromOffset(80, 80)
        ImageLabel.ZIndex = 2
        ImageLabel.Parent = v51
        task.spawn(function() -- line: 231
            -- upvalues: v50 (copy), ImageLabel (copy), Players (copy)
            local GetUserThumbnailAsync = Players.GetUserThumbnailAsync
            local UserId = v50.UserId
            local HeadShot = Enum.ThumbnailType.HeadShot
            local Size100x100 = Enum.ThumbnailSize.Size100x100
            local ok, result = pcall(GetUserThumbnailAsync, Players, UserId, HeadShot, Size100x100)

            if ok then
                ImageLabel.Image = result
            end
        end)
        Style.text(v51, v50.DisplayName, {
            ZIndex = 2,
            StrokeThickness = 4,
            Position = UDim2.fromOffset(108, 14),
            Size = UDim2.new(1, -340, 0, 40),
            TextXAlignment = Enum.TextXAlignment.Left
        })
        Style.text(v51, "@" .. v50.Name, {
            ZIndex = 2,
            Position = UDim2.fromOffset(108, 54),
            Size = UDim2.new(1, -340, 0, 28),
            TextXAlignment = Enum.TextXAlignment.Left,
            TextColor3 = Color3.fromRGB(200, 210, 230)
        })
        Kit.button(v51, "TRADE", Style.BUY, {
            ZIndex = 3,
            AnchorPoint = Vector2.new(1, 0.5),
            Position = UDim2.new(1, -16, 0.5, 0),
            Size = UDim2.fromOffset(190, 66)
        }, function() -- line: 256
            -- upvalues: v50 (copy), Remotes (copy)
            Remotes.Trade:FireServer("Request", v50.UserId)
        end).Label.ZIndex = 4
    end
end

local function showPage(p12) -- line: 263
    -- upvalues: v1 (ref), v2 (ref), v3 (ref), renderTrade (copy), renderPick (copy)
    local v52 = v2

    v52.Visible = not p12
    v3.Visible = p12

    if p12 then
        renderTrade()
    else
        v1.Text = "TRADE"
        renderPick()
    end
end

local function build() -- line: 274
    -- upvalues: Remotes (copy), Kit (copy), Style (copy), LocalPlayer (copy), t1 (copy), ScreenGui (ref), v1 (ref), v2 (ref), v3 (ref), ScrollingFrame (ref), v4 (ref), v5 (ref), v6 (ref), v7 (ref), v8 (ref), ScrollingFrame2 (ref), v9 (ref), v10 (ref), v11 (ref), grid (copy), v18 (ref)
    ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "TradePanel"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.IgnoreGuiInset = true

    local ScreenGui2 = ScreenGui

    ScreenGui2.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.DisplayOrder = 6
    ScreenGui.Enabled = false

    local v53 = Kit.frame(ScreenGui, {
        Name = "Panel",
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromScale(0.5, 0.5),
        Size = UDim2.fromOffset(1080, 820),
        BackgroundColor3 = Color3.new(1, 1, 1)
    })

    Kit.corner(v53, 24)
    Kit.stroke(v53, 6)
    Style.gradient(v53, ColorSequence.new(Style.NAVY, Style.DEEP))
    Kit.studs(v53, 0.75, 44, 24)

    local UIScale = Instance.new("UIScale")

    UIScale.Name = "Scale"
    UIScale.Parent = v53

    local v54 = Kit.frame(v53, {
        Name = "Header",
        ZIndex = 2,
        BackgroundColor3 = Color3.new(1, 1, 1),
        Size = UDim2.new(1, 0, 0, 118)
    })

    Kit.corner(v54, 22)
    Kit.stroke(v54, 5)
    Style.gradient(v54, ColorSequence.new(Style.SEAFOAM, Style.TEAL), 0)
    Kit.studs(v54, 0.5, 48, 22)
    Style.bubble(v54, "🤝", {
        ZIndex = 3,
        Position = UDim2.fromOffset(16, 10),
        Size = UDim2.fromOffset(98, 98)
    })
    v1 = Kit.text(v54, "TRADE", {
        ZIndex = 3,
        StrokeThickness = 6,
        Position = UDim2.fromOffset(126, 24),
        Size = UDim2.new(1, -260, 0, 70),
        TextXAlignment = Enum.TextXAlignment.Left
    })
    Style.gradient(v1, ColorSequence.new(Color3.new(1, 1, 1), Style.YELLOW))
    Kit.button(v54, "X", Color3.fromRGB(235, 70, 70), {
        Name = "Close",
        ZIndex = 3,
        AnchorPoint = Vector2.new(1, 0.5),
        Position = UDim2.new(1, -18, 0.5, 0),
        Size = UDim2.fromOffset(86, 86)
    }, function() -- line: 299
        -- upvalues: t1 (copy)
        task.spawn(t1.close)
    end).Label.ZIndex = 4

    local t10 = {
        BackgroundTransparency = 1,
        Position = UDim2.fromOffset(24, 142),
        Size = UDim2.new(1, -48, 1, -166)
    }

    v2 = Kit.frame(v53, t10)
    v2.Name = "Pick"
    Style.text(v2, "Who do you want to trade with?", {
        Size = UDim2.new(1, 0, 0, 40),
        TextColor3 = Style.SAND
    })
    ScrollingFrame = Instance.new("ScrollingFrame")
    ScrollingFrame.Name = "Players"
    ScrollingFrame.BackgroundTransparency = 1
    ScrollingFrame.BorderSizePixel = 0

    local ScrollingFrame3 = ScrollingFrame

    ScrollingFrame3.Position = UDim2.fromOffset(0, 54)

    local ScrollingFrame4 = ScrollingFrame

    ScrollingFrame4.Size = UDim2.new(1, 0, 1, -54)

    local ScrollingFrame5 = ScrollingFrame

    ScrollingFrame5.AutomaticCanvasSize = Enum.AutomaticSize.Y

    local ScrollingFrame6 = ScrollingFrame

    ScrollingFrame6.CanvasSize = UDim2.new()
    ScrollingFrame.ScrollBarThickness = 10

    local ScrollingFrame7 = ScrollingFrame

    ScrollingFrame7.ScrollBarImageColor3 = Style.YELLOW
    ScrollingFrame.Parent = v2

    local UIListLayout = Instance.new("UIListLayout")

    UIListLayout.Padding = UDim.new(0, 10)
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    UIListLayout.Parent = ScrollingFrame
    v4 = Style.text(v2, "Nobody else is here yet!\nInvite a friend to trade with 🤝", {
        Visible = false,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromScale(0.5, 0.5),
        Size = UDim2.new(1, -120, 0, 120),
        TextColor3 = Style.SAND
    })
    v3 = Kit.frame(v53, t10)
    v3.Name = "Trade"
    v3.Visible = false
    v7 = Style.text(v3, "", {
        StrokeThickness = 4,
        Size = UDim2.fromOffset(506, 36)
    })
    v8 = Style.text(v3, "", {
        StrokeThickness = 4,
        Position = UDim2.fromOffset(526, 0),
        Size = UDim2.fromOffset(506, 36)
    })
    v5 = grid(v3, {
        Name = "Mine",
        Position = UDim2.fromOffset(0, 44),
        Size = UDim2.fromOffset(506, 298)
    })
    v6 = grid(v3, {
        Name = "Theirs",
        Position = UDim2.fromOffset(526, 44),
        Size = UDim2.fromOffset(506, 298)
    })
    Kit.frame(v3, {
        Name = "Divider",
        BackgroundTransparency = 0.6,
        BackgroundColor3 = Style.YELLOW,
        Position = UDim2.fromOffset(514, 0),
        Size = UDim2.fromOffset(4, 322)
    })
    v9 = Style.text(v3, "", {
        Position = UDim2.fromOffset(0, 332),
        Size = UDim2.new(1, -440, 0, 34),
        TextXAlignment = Enum.TextXAlignment.Left,
        TextColor3 = Style.SAND
    })
    v10 = Kit.button(v3, "READY", Style.BUY, {
        Name = "Ready",
        AnchorPoint = Vector2.new(1, 0),
        Position = UDim2.new(1, -220, 0, 320),
        Size = UDim2.fromOffset(200, 60)
    }, function() -- line: 337
        -- upvalues: Remotes (copy), v11 (ref)
        Remotes.Trade:FireServer("Ready", not (v11 and v11.MyReady))
    end)
    Kit.button(v3, "CANCEL", Color3.fromRGB(235, 70, 70), {
        Name = "Cancel",
        AnchorPoint = Vector2.new(1, 0),
        Position = UDim2.new(1, 0, 0, 320),
        Size = UDim2.fromOffset(200, 60)
    }, function() -- line: 340
        -- upvalues: t1 (copy)
        task.spawn(t1.close)
    end)
    Style.text(v3, "YOUR ANIMALS", {
        StrokeThickness = 4,
        Position = UDim2.fromOffset(0, 390),
        Size = UDim2.new(1, 0, 0, 32),
        TextXAlignment = Enum.TextXAlignment.Left
    })
    ScrollingFrame2 = Instance.new("ScrollingFrame")
    ScrollingFrame2.Name = "Bag"
    ScrollingFrame2.BackgroundTransparency = 1
    ScrollingFrame2.BorderSizePixel = 0

    local ScrollingFrame8 = ScrollingFrame2

    ScrollingFrame8.Position = UDim2.fromOffset(0, 428)

    local ScrollingFrame9 = ScrollingFrame2

    ScrollingFrame9.Size = UDim2.new(1, 0, 1, -428)

    local ScrollingFrame10 = ScrollingFrame2

    ScrollingFrame10.AutomaticCanvasSize = Enum.AutomaticSize.Y

    local ScrollingFrame11 = ScrollingFrame2

    ScrollingFrame11.CanvasSize = UDim2.new()
    ScrollingFrame2.ScrollBarThickness = 10

    local ScrollingFrame12 = ScrollingFrame2

    ScrollingFrame12.ScrollBarImageColor3 = Style.YELLOW
    ScrollingFrame2.Parent = v3

    local UIGridLayout = Instance.new("UIGridLayout")

    UIGridLayout.CellSize = UDim2.fromOffset(116, 136)
    UIGridLayout.CellPadding = UDim2.fromOffset(10, 10)
    UIGridLayout.SortOrder = Enum.SortOrder.LayoutOrder
    UIGridLayout.Parent = ScrollingFrame2
    v18 = Style.text(v3, "You don't have any animals to trade yet. Go catch some!", {
        Visible = false,
        Position = UDim2.fromOffset(0, 438),
        Size = UDim2.new(1, 0, 0, 40),
        TextColor3 = Style.SAND
    })

    local ScreenGui3 = ScreenGui

    ScreenGui3.Parent = LocalPlayer:WaitForChild("PlayerGui")
end

local function onServer(p13, p14) -- line: 369
    -- upvalues: UIUtil (copy), t1 (copy), ScreenGui (ref), v2 (ref), v3 (ref), v11 (ref), t2 (ref), renderTrade (copy)
    if type(p14) ~= "table" then
        return
    end

    if p13 == "State" then
        local v55 = v11 == nil

        v11 = p14
        t2 = {}

        for _, v56 in p14.Mine do
            local t11 = t2

            table.insert(t11, v56.Uid)
        end

        if v55 then
            t1.onOpen()
            UIUtil.sound("ShopBell", 0.6)
        end

        v2.Visible = false
        v3.Visible = true
        renderTrade()
    elseif p13 == "Closed" then
        v11 = nil
        t2 = {}

        if p14.Reason == "Done" then
            UIUtil.sound("LevelUp", 0.6)
        end

        if ScreenGui.Enabled then
            UIUtil.closePanel(ScreenGui)
        end
    elseif p13 == "Declined" then
        UIUtil.toast(("%* said no to trading."):format(p14.Name), "error")
    end
end

t1.onOpen = function() -- line: 401
end

function t1.isOpen() -- line: 403
    -- upvalues: ScreenGui (ref)
    return ScreenGui ~= nil and ScreenGui.Enabled
end

function t1.isTrading() -- line: 407
    -- upvalues: v11 (ref)
    return v11 ~= nil
end

function t1.open() -- line: 411
    -- upvalues: UIUtil (copy), ScreenGui (ref), v1 (ref), v2 (ref), v3 (ref), v11 (ref), renderTrade (copy), renderPick (copy)
    local v57 = v11 ~= nil

    v2.Visible = not v57
    v3.Visible = v57

    if v57 then
        renderTrade()
    else
        v1.Text = "TRADE"
        renderPick()
    end

    if not ScreenGui.Enabled then
        UIUtil.openPanel(ScreenGui)
    end
end

function t1.close() -- line: 418
    -- upvalues: Remotes (copy), UIUtil (copy), ScreenGui (ref), v11 (ref)
    if v11 then
        Remotes.Trade:FireServer("Cancel")
    end

    UIUtil.closePanel(ScreenGui)
end

function t1.init() -- line: 426
    -- upvalues: Players (copy), Remotes (copy), ScreenGui (ref), v11 (ref), renderBag (copy), renderPick (copy), build (copy), onServer (copy)
    build()
    Remotes.Trade.OnClientEvent:Connect(onServer)
    Remotes.Inventory.OnClientEvent:Connect(function() -- line: 429
        -- upvalues: ScreenGui (ref), v11 (ref), renderBag (copy)
        if v11 and ScreenGui.Enabled then
            task.defer(renderBag)
        end
    end)
    Players.PlayerAdded:Connect(function() -- line: 435
        -- upvalues: ScreenGui (ref), v11 (ref), renderPick (copy)
        if ScreenGui.Enabled and not v11 then
            renderPick()
        end
    end)
    Players.PlayerRemoving:Connect(function() -- line: 440
        -- upvalues: ScreenGui (ref), v11 (ref), renderPick (copy)
        if ScreenGui.Enabled and not v11 then
            task.defer(renderPick)
        end
    end)
end

return t1
