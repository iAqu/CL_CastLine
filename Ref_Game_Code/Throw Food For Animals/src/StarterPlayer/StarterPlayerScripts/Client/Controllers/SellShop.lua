-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

require(ReplicatedStorage.Config.GameConfig)

local UITheme = require(ReplicatedStorage.Config.UITheme)
local RarityConfig = require(ReplicatedStorage.Config.RarityConfig)
local AnimalEconomy = require(ReplicatedStorage.Config.AnimalEconomy)
local AnimalsData = require(ReplicatedStorage.AnimalsData)
local AnimalUtil = require(ReplicatedStorage.Shared.AnimalUtil)
local AnimalTemplates = require(ReplicatedStorage.Shared.AnimalTemplates)
local Mutations = require(ReplicatedStorage.Shared.Mutations)
local NumberFormat = require(ReplicatedStorage.Shared.NumberFormat)
local Remotes = require(ReplicatedStorage.Shared.Remotes)
local Boosts = require(ReplicatedStorage.Shared.Boosts)
local Parent = script.Parent
local DataController = require(Parent.DataController)
local UIKit = require(Parent.UIKit)
local Sounds = require(Parent.Sounds)
local HUDController = require(Parent.HUDController)
local ClientState = require(Parent.ClientState)
local UIScaler = require(Parent.UIScaler)
local t1 = {}
local Colors = UITheme.Colors
local LocalPlayer = Players.LocalPlayer
local Money = UITheme.Icons.Money
local t2 = {
    Color3.fromRGB(255, 84, 84),
    Color3.fromRGB(255, 138, 66)
}
local t3 = {}

for _, v1 in pairs(AnimalsData) do
    for _, v2 in ipairs(v1) do
        t3[v2.ModelName] = v2.Name
    end
end

local v3, v4, v5, ScrollingFrame, v6, ImageLabel, v7, v8, v9, TextButton, v10, t4
local t5 = {}
local v11 = false
local v12 = false
local v13 = false
local v14
local v15 = false
local n1 = 0
local n2 = 0
local n3 = 0

local function best() -- line: 83
    -- upvalues: LocalPlayer (copy)
    return LocalPlayer:GetAttribute("BestIncome") or 0
end

local function priceOf(p1) -- line: 87
    -- upvalues: Mutations (copy), LocalPlayer (copy)
    return Mutations.SellPrice(p1, LocalPlayer:GetAttribute("BestIncome") or 0)
end

local function rowHeight() -- line: 95
    -- upvalues: ScrollingFrame (ref)
    return (math.max(56, (math.floor((ScrollingFrame.AbsoluteSize.X - ScrollingFrame.ScrollBarThickness) * 0.165))))
end

local function layoutRow(p2, p3) -- line: 100
    p2.Frame.Size = UDim2.new(1, -10, 0, p3)
    p2.Stack.Position = UDim2.new(0.025, math.floor(p3 * 0.86) + 12, 0.5, 0)
end

local function sectionHeader(p4, p5) -- line: 105
    -- upvalues: UIKit (copy), UIScaler (copy), ScrollingFrame (ref)
    local v20 = UIKit.Frame({
        Transparency = 1,
        ZIndex = 6,
        Parent = ScrollingFrame,
        Name = p4,
        Size = UDim2.new(1, -10, 0, (math.round((UIScaler.Px(28)))))
    })

    v20.LayoutOrder = p5

    return v20, (UIKit.Text({
        Name = "Label",
        Text = "",
        ZIndex = 7,
        Stroke = 3,
        Rich = true,
        Parent = v20,
        Size = UDim2.fromScale(1, 0.9),
        Position = UDim2.fromScale(0, 0.5),
        AnchorPoint = Vector2.new(0, 0.5),
        XAlign = Enum.TextXAlignment.Left
    }))
end

local function flyCoins(p6, p7) -- line: 113
    -- upvalues: TweenService (copy), UIKit (copy), HUDController (copy), Money (copy), v3 (ref)
    local v21 = HUDController.GetStatsContainer()
    local MoneyDisplay = v21 and v21:FindFirstChild("MoneyDisplay")

    if not (v3 and MoneyDisplay and p6) then
        return
    end

    local v22 = MoneyDisplay:FindFirstChild("Icon") or MoneyDisplay
    local AbsolutePosition = v3.AbsolutePosition
    local v23 = p6.AbsolutePosition + p6.AbsoluteSize / 2 - AbsolutePosition
    local v24 = v22.AbsolutePosition + v22.AbsoluteSize / 2 - AbsolutePosition
    local v26 = math.max(18, v3.AbsoluteSize.Y * 0.05)

    for i = 1, p7 do
        local ImageLabel = Instance.new("ImageLabel")

        ImageLabel.Name = "Coin"
        ImageLabel.BackgroundTransparency = 1
        ImageLabel.Image = Money
        ImageLabel.ScaleType = Enum.ScaleType.Fit
        ImageLabel.Size = UDim2.fromOffset(v26, v26)
        ImageLabel.AnchorPoint = Vector2.new(0.5, 0.5)
        ImageLabel.Position = UDim2.fromOffset(v23.X, v23.Y)
        ImageLabel.ZIndex = 60
        ImageLabel.Parent = v3

        local v27 = v23 + Vector2.new(math.random(-80, 80), math.random(-60, 20)) * (v26 / 30)
        local tween = TweenService:Create(ImageLabel, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Position = UDim2.fromOffset(v27.X, v27.Y)
        })

        task.delay((i - 1) * 0.035, function() -- line: 135
            -- upvalues: v24 (copy), v26 (copy), ImageLabel (copy), tween (copy), i (copy), MoneyDisplay (copy), TweenService (copy), UIKit (copy)
            tween:Play()
            tween.Completed:Wait()

            local tween2 = TweenService:Create(ImageLabel, TweenInfo.new(0.45, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
                Position = UDim2.fromOffset(v24.X, v24.Y),
                Size = UDim2.fromOffset(v26 * 0.6, v26 * 0.6)
            })

            tween2:Play()
            tween2.Completed:Wait()
            ImageLabel:Destroy()

            if i % 3 == 0 then
                UIKit.Punch(MoneyDisplay, 0.12, 0.3)
            end
        end)
    end
end

local function setPlaced(p8) -- line: 151
    local v28 = p8.Entry.Placed == true
    local RowStroke = p8.Frame:FindFirstChild("RowStroke")

    if not RowStroke then
        return
    end

    RowStroke.Color = v28 and Color3.new(1, 1, 1) or Color3.new(0, 0, 0)
    RowStroke.Thickness = v28 and 3.5 or 3
end

local function showRowConfirm(p9, p10) -- line: 161
    -- upvalues: UIKit (copy), showRowConfirm (copy)
    p9.Confirming = p10
    p9.Side.Visible = not p10
    p9.Confirm.Visible = p10

    if not p10 then
        return
    end

    UIKit.PopIn(p9.Confirm, 0.22, 0.7)

    local t7 = {}

    p9.ConfirmToken = t7
    task.delay(4, function() -- line: 169
        -- upvalues: p9 (copy), t7 (copy), showRowConfirm (copy)
        if p9.ConfirmToken == t7 and p9.Confirming and p9.Frame.Parent then
            showRowConfirm(p9, false)
        end
    end)
end

local function sellOne(p11) -- line: 175
    -- upvalues: NumberFormat (copy), Remotes (copy), Sounds (copy), HUDController (copy), v12 (ref), flyCoins (copy)
    if v12 then
        return
    end

    v12 = true

    local v29 = Remotes.Invoke("Plot_SellAnimal", p11.Id)

    v12 = false

    if v29.Ok then
        Sounds.Play("MoneyReward")
        flyCoins(p11.Confirm, 6)
        HUDController.Notify("Sold for " .. NumberFormat.Money(v29.Money or 0) .. "!", "Success")
    else
        Sounds.Play("PurchaseFail", {
            Volume = 0.4
        })
        p11.Confirming = false
        p11.Side.Visible = true
        p11.Confirm.Visible = false
    end
end

local function makeRow(p12, p13) -- line: 191
    -- upvalues: TweenService (copy), RarityConfig (copy), AnimalEconomy (copy), AnimalUtil (copy), AnimalTemplates (copy), Mutations (copy), NumberFormat (copy), Boosts (copy), Parent (copy), UIKit (copy), Colors (copy), LocalPlayer (copy), t3 (copy), ScrollingFrame (ref), setPlaced (copy), showRowConfirm (copy), sellOne (copy)
    local ModelName = p13.ModelName
    local v30 = AnimalEconomy.Get(ModelName) or {
        Income = 0,
        Rarity = "Common"
    }
    local v31 = RarityConfig.Get(v30.Rarity)
    local t8 = {
        Id = p12,
        Entry = p13
    }
    local v32 = UIKit.Frame({
        Corner = 12,
        ZIndex = 6,
        Parent = ScrollingFrame,
        Name = "Row_" .. p12,
        Size = UDim2.new(1, -10, 0, 60),
        Color = Colors.PanelGradientA,
        Gradient = {
            Color3.fromRGB(70, 70, 82),
            Color3.fromRGB(46, 46, 54),
            90
        }
    })

    UIKit.Stroke(v32, 3, Color3.new(0, 0, 0)).Name = "RowStroke"

    local UIScale = Instance.new("UIScale")

    UIScale.Parent = v32
    t8.Frame = v32
    t8.Version = AnimalTemplates.Version()

    local v33 = UIKit.Card({
        Name = "Preview",
        ZIndex = 7,
        Parent = v32,
        Size = UDim2.fromScale(0.86, 0.86),
        Position = UDim2.fromScale(0.025, 0.5),
        AnchorPoint = Vector2.new(0, 0.5),
        Rarity = v30.Rarity
    })

    v33.SizeConstraint = Enum.SizeConstraint.RelativeYY

    local v34 = UIKit.Viewport({
        ZIndex = 9,
        Yaw = -0.6108652381980153,
        Pitch = -0.20943951023931956,
        Padding = 1.05,
        Parent = v33,
        Size = UDim2.fromScale(0.94, 0.94),
        Position = UDim2.fromScale(0.5, 0.5),
        AnchorPoint = Vector2.new(0.5, 0.5)
    })
    local v35 = AnimalUtil.Create(ModelName)

    if v35 then
        Mutations.Apply(v35, p13.Mutation, {
            Particles = false
        })
        v34:SetModel(v35)
    end

    local v36 = UIKit.Frame({
        Name = "Info",
        Transparency = 1,
        ZIndex = 7,
        Parent = v32,
        Size = UDim2.fromScale(0.44, 0.9),
        AnchorPoint = Vector2.new(0, 0.5)
    })

    t8.Stack = v36

    local UIListLayout = Instance.new("UIListLayout")

    UIListLayout.FillDirection = Enum.FillDirection.Vertical
    UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    UIListLayout.Parent = v36

    local function line(p14, p15, p16, p17) -- line: 223
        -- upvalues: v36 (copy), UIKit (copy)
        local v37 = UIKit.Text({
            ZIndex = 8,
            Parent = v36,
            Text = p14,
            Size = UDim2.fromScale(1, p15),
            XAlign = Enum.TextXAlignment.Left,
            Stroke = p17 or 2
        })

        v37.LayoutOrder = p16

        return v37
    end

    local v38 = Mutations.NameGradient(p13.Mutation)

    if v38 then
        local v39 = line(string.upper(p13.Mutation), 0.19, 1, 2)

        UIKit.Gradient(v39, v38, 90)
    end

    local v40 = line(t3[ModelName] or ModelName, 0.3, 2, 3)

    UIKit.Gradient(v40, v31.Gradient, 90)

    local v41, v42 = Mutations.SizeTitle(p13.Size)

    if v41 then
        line(v41, 0.21, 3, 2).TextColor3 = v42 or Color3.new(1, 1, 1)
    end

    local v43 = Mutations.IncomeOf(p13, LocalPlayer:GetAttribute("BestIncome") or 0)
    local v44 = line(Boosts.AnimalIncomeText(v43, LocalPlayer, p13.OfBest), 0.25, 4, 3)

    v44.RichText = true
    v44.TextColor3 = Colors.Money
    t8.Income = v43
    t8.Price = Mutations.SellPrice(p13, LocalPlayer:GetAttribute("BestIncome") or 0)

    local v45 = UIKit.Frame({
        Name = "Side",
        Transparency = 1,
        ZIndex = 8,
        Parent = v32,
        Size = UDim2.fromScale(0.25, 0.84),
        Position = UDim2.fromScale(0.975, 0.5),
        AnchorPoint = Vector2.new(1, 0.5)
    })

    t8.Side = v45

    local v46 = UIKit.Text({
        Name = "Price",
        ZIndex = 9,
        Stroke = 3,
        Parent = v45,
        Text = NumberFormat.Money(t8.Price),
        Size = UDim2.fromScale(1, 0.4),
        Color = Color3.new(1, 1, 1)
    })

    UIKit.Gradient(v46, Color3.fromRGB(190, 255, 120), Color3.fromRGB(90, 210, 40), 90)
    UIKit.Button({
        Name = "Sell",
        Text = "SELL",
        ZIndex = 9,
        Parent = v45,
        Size = UDim2.fromScale(1, 0.55),
        Position = UDim2.fromScale(0.5, 1),
        AnchorPoint = Vector2.new(0.5, 1),
        Colors = {
            Colors.RedA,
            Colors.RedB
        },
        Juice = {
            HoverScale = 1.05
        },
        OnClick = function() -- OnClick | line: 252
            -- upvalues: t8 (copy), Parent (copy), showRowConfirm (copy)
            if not t8.Entry.Bought then
                showRowConfirm(t8, true)

                return
            end

            local _require = require
            local ProtectedSell = Parent.ProtectedSell
            local ok, result = pcall(_require, ProtectedSell)

            if ok then
                result.Open(t8.Id)
            end
        end
    })

    local v47 = UIKit.Frame({
        Name = "Confirm",
        Transparency = 1,
        ZIndex = 10,
        Parent = v32,
        Size = UDim2.fromScale(0.32, 0.84),
        Position = UDim2.fromScale(0.975, 0.5),
        AnchorPoint = Vector2.new(1, 0.5)
    })

    v47.Visible = false
    UIKit.Text({
        Name = "Ask",
        Rich = true,
        ZIndex = 11,
        Stroke = 2,
        Parent = v47,
        Text = "Sell for <font color=\"" .. "#8CFF3C" .. "\">" .. NumberFormat.Money(t8.Price) .. "</font>?",
        Size = UDim2.fromScale(1, 0.4)
    })
    UIKit.Button({
        Name = "Yes",
        Text = "YES",
        ZIndex = 11,
        Parent = v47,
        Size = UDim2.fromScale(0.48, 0.52),
        Position = UDim2.fromScale(0, 1),
        AnchorPoint = Vector2.new(0, 1),
        Colors = {
            Colors.GreenA,
            Colors.GreenB
        },
        OnClick = function() -- OnClick | line: 266
            -- upvalues: t8 (copy), sellOne (copy)
            sellOne(t8)
        end
    })
    UIKit.Button({
        Name = "No",
        Text = "NO",
        ZIndex = 11,
        Parent = v47,
        Size = UDim2.fromScale(0.48, 0.52),
        Position = UDim2.fromScale(1, 1),
        AnchorPoint = Vector2.new(1, 1),
        Colors = {
            Colors.GrayA,
            Colors.GrayB
        },
        OnClick = function() -- OnClick | line: 269
            -- upvalues: t8 (copy)
            t8.Confirming = false
            t8.Side.Visible = true
            t8.Confirm.Visible = false
        end
    })
    t8.Confirm = v47
    v32.MouseEnter:Connect(function() -- line: 275
        -- upvalues: UIScale (copy), TweenService (copy)
        TweenService:Create(UIScale, TweenInfo.new(0.15, Enum.EasingStyle.Quad), {
            Scale = 1.02
        }):Play()
    end)
    v32.MouseLeave:Connect(function() -- line: 278
        -- upvalues: UIScale (copy), TweenService (copy)
        TweenService:Create(UIScale, TweenInfo.new(0.15, Enum.EasingStyle.Quad), {
            Scale = 1
        }):Play()
    end)
    setPlaced(t8)

    local v50 = math.max(56, (math.floor((ScrollingFrame.AbsoluteSize.X - ScrollingFrame.ScrollBarThickness) * 0.165)))

    t8.Frame.Size = UDim2.new(1, -10, 0, v50)
    t8.Stack.Position = UDim2.new(0.025, math.floor(v50 * 0.86) + 12, 0.5, 0)

    return t8
end

local function setSellAllEnabled(p18) -- line: 290
    -- upvalues: UIKit (copy), Colors (copy), v7 (ref)
    local SetButtonColors = UIKit.SetButtonColors
    local v52 = v7

    SetButtonColors(v52, p18 and {
        Colors.GreenA,
        Colors.GreenB
    } or {
        Colors.GrayA,
        Colors.GrayB
    })
end

local function refresh() -- line: 294
    -- upvalues: AnimalTemplates (copy), NumberFormat (copy), DataController (copy), UIKit (copy), v3 (ref), v6 (ref), v8 (ref), v9 (ref), TextButton (ref), t4 (ref), t5 (copy), v11 (ref), v13 (ref), n1 (ref), n2 (ref), n3 (ref), makeRow (copy), setSellAllEnabled (copy)
    v13 = false

    if not v3 then
        return
    end

    local v53 = DataController:Get("Animals") or {}

    for v54, v55 in pairs(t5) do
        local v56 = v53[v54]

        if not v56 or v56.Placed then
            v55.Frame:Destroy()
            t5[v54] = nil
        elseif v56.ModelName ~= v55.Entry.ModelName or v56.Mutation ~= v55.Entry.Mutation or v56.Size ~= v55.Entry.Size or v55.Version ~= AnimalTemplates.Version() then
            v55.Frame:Destroy()
            t5[v54] = nil
        end
    end

    local t12 = {}

    for v57, v58 in pairs(v53) do
        if not v58.Placed then
            local v59 = t5[v57]

            if v59 then
                v59.Entry = v58
            else
                v59 = makeRow(v57, v58)
                t5[v57] = v59
            end

            table.insert(t12, v59)
        end
    end

    local function byPrice(p19, p20) -- line: 321
        if p19.Price == p20.Price then
            return p19.Id < p20.Id
        end

        return p19.Price > p20.Price
    end

    table.sort(t12, byPrice)
    t4.Frame.LayoutOrder = 0
    t4.Label.Text = "BACKPACK  <font color=\"#FFD84A\">" .. #t12 .. "</font>"
    t4.Frame.Visible = #t12 > 0
    n2 = 0
    n1 = 0
    n3 = 0

    for v60, v61 in ipairs(t12) do
        v61.Frame.LayoutOrder = v60

        if v61.Entry.Bought then
            n3 += 1
        else
            local v62 = n2

            n2 = v62 + v61.Price
            n1 += 1
        end
    end

    local CountTo = UIKit.CountTo
    local v63 = v6
    local v64 = n2

    CountTo(v63, v64, v11 and 0.35 or 0, NumberFormat.Money)

    local v65 = v8

    v65.Text = n1 > 0 and "SELL ALL  <font color=\"#FFF3A0\">(" .. n1 .. ")</font>" or "SELL ALL"
    setSellAllEnabled(n1 > 0)

    local v66 = v9

    v66.Visible = #t12 == 0

    if n1 == 0 and TextButton.Visible then
        TextButton.Visible = false
    end
end

local function queueRefresh() -- line: 348
    -- upvalues: v13 (ref), refresh (copy)
    if not v13 then
        v13 = true
        task.defer(refresh)
    end
end

local function resizeRows() -- line: 354
    -- upvalues: ScrollingFrame (ref), t5 (copy)
    if not ScrollingFrame then
        return
    end

    local v69 = math.max(56, (math.floor((ScrollingFrame.AbsoluteSize.X - ScrollingFrame.ScrollBarThickness) * 0.165)))

    for _, v70 in pairs(t5) do
        v70.Frame.Size = UDim2.new(1, -10, 0, v69)
        v70.Stack.Position = UDim2.new(0.025, math.floor(v69 * 0.86) + 12, 0.5, 0)
    end
end

local function layoutSummary() -- line: 361
    -- upvalues: v5 (ref), v6 (ref), ImageLabel (ref)
    if not v5 then
        return
    end

    local X = ImageLabel.AbsoluteSize.X

    v6.Position = UDim2.new(0.035, X + 8, 0.66, 0)
end

local function hideConfirm() -- line: 371
    -- upvalues: TextButton (ref)
    if TextButton then
        TextButton.Visible = false
    end
end

local function askSellAll() -- line: 375
    -- upvalues: NumberFormat (copy), UIKit (copy), Sounds (copy), HUDController (copy), v7 (ref), TextButton (ref), v10 (ref), v12 (ref), n1 (ref), n2 (ref), n3 (ref)
    if v12 then
        return
    end

    if n1 == 0 then
        Sounds.Play("PurchaseFail", {
            Volume = 0.4
        })
        UIKit.Punch(v7, 0.1, 0.3)
        HUDController.Notify(n3 > 0 and "Bought animals are never in SELL ALL!" or "No animals in your backpack!", "Info")
    else
        local v73 = v10
        local v74 = n1

        v73.Text = "Sell <font color=\"#FFD84A\">" .. v74 .. "</font> animal" .. (n1 == 1 and "" or "s") .. " for <font color=\"" .. "#8CFF3C" .. "\">" .. NumberFormat.Money(n2) .. "</font>?"
        TextButton.Visible = true
        UIKit.PopIn(TextButton.Box, 0.25, 0.7)
    end
end

local function sellAll() -- line: 389
    -- upvalues: NumberFormat (copy), Remotes (copy), UIKit (copy), Sounds (copy), HUDController (copy), v5 (ref), v7 (ref), TextButton (ref), v12 (ref), flyCoins (copy)
    if v12 then
        return
    end

    v12 = true

    local Plot_SellAll = Remotes.Invoke("Plot_SellAll")

    v12 = false

    if TextButton then
        TextButton.Visible = false
    end

    if Plot_SellAll.Ok then
        Sounds.Play("MoneyReward")
        Sounds.Play("CoinBurst", {
            Volume = 0.6
        })
        flyCoins(v7, 12)
        UIKit.Punch(v5, 0.05, 0.4)

        local v75 = Plot_SellAll.Count or 0

        HUDController.Notify("Sold " .. v75 .. " animal" .. (v75 == 1 and "" or "s") .. " for " .. NumberFormat.Money(Plot_SellAll.Money or 0) .. "!", "Success")
    elseif Plot_SellAll.Reason == "Nothing" then
        HUDController.Notify("No animals in your backpack!", "Info")
    else
        Sounds.Play("PurchaseFail", {
            Volume = 0.4
        })
    end
end

local t13 = {
    { "ShopController", "ShopOpen" },
    { "IndexController", "IndexOpen" },
    { "ExclusiveShopController", "ExclusiveShopOpen" },
    { "AnimalsPanel", "AnimalsOpen" }
}

local function otherWindowOpen() -- line: 420
    -- upvalues: ClientState (copy)
    return ClientState.ShopOpen or ClientState.IndexOpen or ClientState.ExclusiveShopOpen or ClientState.AnimalsOpen or ClientState.OfflineOpen
end

local function closeOtherWindows() -- line: 425
    -- upvalues: Parent (copy), ClientState (copy), t13 (copy)
    for _, v76 in ipairs(t13) do
        if ClientState[v76[2]] then
            local _require = require
            local v77 = Parent[v76[1]]
            local ok, result = pcall(_require, v77)

            if ok and result.Close then
                result.Close()
            end
        end
    end
end

function t1.Open() -- line: 434
    -- upvalues: UIKit (copy), Sounds (copy), ClientState (copy), v3 (ref), v4 (ref), ScrollingFrame (ref), TextButton (ref), v11 (ref), refresh (copy), resizeRows (copy), layoutSummary (copy), closeOtherWindows (copy)
    local v78 = false

    if v11 then
        v78 = true
    elseif not v3 or ClientState.Busy or ClientState.OfflineOpen then
        v78 = true
    else
        closeOtherWindows()
        v11 = true
        ClientState.SellOpen = true
        v3.Enabled = true

        if TextButton then
            TextButton.Visible = false
        end
    end

    if v78 then
        return false
    end

    refresh()
    resizeRows()
    ScrollingFrame.CanvasPosition = Vector2.zero
    UIKit.PopIn(v4.Root, 0.35, 0.75)
    Sounds.Play("Slide")
    task.defer(layoutSummary)

    return true
end

function t1.Close() -- line: 451
    -- upvalues: UIKit (copy), Sounds (copy), ClientState (copy), v3 (ref), v4 (ref), TextButton (ref), v11 (ref), v15 (ref)
    if not v11 then
        return
    end

    v11 = false
    v15 = true
    ClientState.SellOpen = false

    if TextButton then
        TextButton.Visible = false
    end

    Sounds.Play("Slide", {
        Volume = 0.2
    })
    UIKit.PopOut(v4.Root, 0.2, 0.8).Completed:Once(function() -- line: 458
        -- upvalues: v3 (ref), v4 (ref), v11 (ref)
        if not v11 then
            v3.Enabled = false
        end

        v4.Root.Visible = true
    end)
end

function t1.IsOpen() -- line: 464
    -- upvalues: v11 (ref)
    return v11
end

local function build() -- line: 472
    -- upvalues: TweenService (copy), UITheme (copy), UIKit (copy), UIScaler (copy), t1 (copy), Colors (copy), Money (copy), t2 (copy), v3 (ref), v4 (ref), v5 (ref), ScrollingFrame (ref), v6 (ref), ImageLabel (ref), v7 (ref), v8 (ref), v9 (ref), TextButton (ref), v10 (ref), t4 (ref), v11 (ref), n1 (ref), sectionHeader (copy), resizeRows (copy), layoutSummary (copy), hideConfirm (copy), askSellAll (copy), sellAll (copy)
    v3 = UIKit.ScreenGui("SellShop", 12, true)
    v3.Enabled = false
    v4 = UIKit.Panel({
        Name = "SellPanel",
        Ratio = 1.18,
        Title = "Sell Animals",
        HeaderHeight = 0.11,
        Parent = v3,
        Size = UDim2.fromScale(0.52, 0.8),
        Position = UDim2.fromScale(0.5, 0.5),
        OnClose = function() -- OnClose | line: 475
            -- upvalues: t1 (copy)
            t1.Close()
        end,
        HeaderColors = t2
    })

    local Content = v4.Content
    local ZIndex = Content.ZIndex

    v5 = UIKit.Frame({
        Name = "Summary",
        Corner = 12,
        Stroke = 3,
        Parent = Content,
        Size = UDim2.fromScale(0.94, 0.17),
        Position = UDim2.fromScale(0.5, 0.025),
        AnchorPoint = Vector2.new(0.5, 0),
        Color = Color3.fromRGB(36, 36, 44),
        StrokeColor = Color3.new(0, 0, 0),
        ZIndex = ZIndex + 1
    })
    UIKit.Text({
        Name = "Caption",
        Text = "BACKPACK VALUE",
        Stroke = 2,
        Parent = v5,
        Size = UDim2.fromScale(0.5, 0.3),
        Position = UDim2.fromScale(0.035, 0.1),
        XAlign = Enum.TextXAlignment.Left,
        Color = Color3.fromRGB(205, 210, 225),
        ZIndex = ZIndex + 2
    })
    ImageLabel = Instance.new("ImageLabel")
    ImageLabel.Name = "MoneyIcon"
    ImageLabel.BackgroundTransparency = 1
    ImageLabel.Image = Money

    local ImageLabel2 = ImageLabel

    ImageLabel2.ScaleType = Enum.ScaleType.Fit

    local ImageLabel3 = ImageLabel

    ImageLabel3.Size = UDim2.fromScale(0.5, 0.5)

    local ImageLabel4 = ImageLabel

    ImageLabel4.SizeConstraint = Enum.SizeConstraint.RelativeYY

    local ImageLabel5 = ImageLabel

    ImageLabel5.AnchorPoint = Vector2.new(0, 0.5)

    local ImageLabel6 = ImageLabel

    ImageLabel6.Position = UDim2.fromScale(0.035, 0.66)

    local ImageLabel7 = ImageLabel

    ImageLabel7.ZIndex = ZIndex + 2
    ImageLabel.Parent = v5
    v6 = UIKit.Text({
        Name = "Total",
        Text = "$0",
        Stroke = 3,
        Parent = v5,
        Size = UDim2.fromScale(0.38, 0.5),
        Position = UDim2.fromScale(0.1, 0.66),
        AnchorPoint = Vector2.new(0, 0.5),
        XAlign = Enum.TextXAlignment.Left,
        Color = Color3.new(1, 1, 1),
        ZIndex = ZIndex + 2
    })
    UIKit.Gradient(v6, Color3.fromRGB(190, 255, 120), Color3.fromRGB(90, 210, 40), 90)
    v7, v8 = UIKit.Button({
        Name = "SellAll",
        Text = "SELL ALL",
        Rich = true,
        Parent = v5,
        Size = UDim2.fromScale(0.44, 0.72),
        Position = UDim2.fromScale(0.975, 0.5),
        AnchorPoint = Vector2.new(1, 0.5),
        Colors = {
            Colors.GreenA,
            Colors.GreenB
        },
        ZIndex = ZIndex + 3,
        Juice = {
            HoverScale = 1.05
        },
        OnClick = askSellAll
    })

    local v79 = UIKit.Frame({
        Name = "Shine",
        Parent = v7,
        Color = Color3.new(1, 1, 1),
        Corner = UITheme.Corner.Button,
        ZIndex = v7.ZIndex + 2
    })
    local UIGradient = Instance.new("UIGradient")

    UIGradient.Rotation = 20
    UIGradient.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 1),
        NumberSequenceKeypoint.new(0.44, 1),
        NumberSequenceKeypoint.new(0.5, 0.6),
        NumberSequenceKeypoint.new(0.56, 1),
        NumberSequenceKeypoint.new(1, 1)
    })
    UIGradient.Offset = Vector2.new(-1, 0)
    UIGradient.Parent = v79
    task.spawn(function() -- line: 506
        -- upvalues: UIGradient (copy), TweenService (copy), v7 (ref), v11 (ref), n1 (ref)
        while v7.Parent do
            if v11 and n1 > 0 then
                UIGradient.Offset = Vector2.new(-1, 0)
                TweenService:Create(UIGradient, TweenInfo.new(0.8, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {
                    Offset = Vector2.new(1, 0)
                }):Play()
            end

            task.wait(3)
        end
    end)
    v5:GetPropertyChangedSignal("AbsoluteSize"):Connect(layoutSummary)
    ScrollingFrame = Instance.new("ScrollingFrame")
    ScrollingFrame.Name = "List"

    local ScrollingFrame2 = ScrollingFrame

    ScrollingFrame2.Size = UDim2.fromScale(0.94, 0.765)

    local ScrollingFrame3 = ScrollingFrame

    ScrollingFrame3.Position = UDim2.fromScale(0.5, 0.215)

    local ScrollingFrame4 = ScrollingFrame

    ScrollingFrame4.AnchorPoint = Vector2.new(0.5, 0)
    ScrollingFrame.BackgroundTransparency = 1
    ScrollingFrame.BorderSizePixel = 0
    ScrollingFrame.ScrollBarThickness = 6

    local ScrollingFrame5 = ScrollingFrame

    ScrollingFrame5.ScrollBarImageColor3 = Color3.fromRGB(200, 200, 210)

    local ScrollingFrame6 = ScrollingFrame

    ScrollingFrame6.VerticalScrollBarInset = Enum.ScrollBarInset.Always

    local ScrollingFrame7 = ScrollingFrame

    ScrollingFrame7.ScrollingDirection = Enum.ScrollingDirection.Y

    local ScrollingFrame8 = ScrollingFrame

    ScrollingFrame8.CanvasSize = UDim2.new(0, 0, 0, 0)

    local ScrollingFrame9 = ScrollingFrame

    ScrollingFrame9.AutomaticCanvasSize = Enum.AutomaticSize.Y

    local ScrollingFrame10 = ScrollingFrame

    ScrollingFrame10.ZIndex = ZIndex + 1
    ScrollingFrame.Parent = Content

    local UIListLayout = Instance.new("UIListLayout")

    UIListLayout.Padding = UDim.new(0, (math.round((UIScaler.Px(8)))))
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    UIListLayout.Parent = ScrollingFrame

    local UIPadding = Instance.new("UIPadding")

    UIPadding.PaddingTop = UDim.new(0, (math.round((UIScaler.Px(6)))))
    UIPadding.PaddingBottom = UDim.new(0, (math.round((UIScaler.Px(10)))))
    UIPadding.Parent = ScrollingFrame
    t4 = {}

    local t14 = t4
    local t15 = t4
    local v83, v84 = sectionHeader("BagHeader", 0)

    t14.Frame = v83
    t15.Label = v84
    v9 = UIKit.Text({
        Name = "Empty",
        Text = "NO ANIMALS IN BACKPACK",
        Stroke = 3,
        Parent = Content,
        Size = UDim2.fromScale(0.85, 0.2),
        Position = UDim2.fromScale(0.5, 0.55),
        AnchorPoint = Vector2.new(0.5, 0.5),
        ZIndex = ZIndex + 2,
        Color = Color3.fromRGB(210, 214, 228)
    })
    ScrollingFrame:GetPropertyChangedSignal("AbsoluteSize"):Connect(resizeRows)
    TextButton = Instance.new("TextButton")
    TextButton.Name = "SellAllConfirm"
    TextButton.Text = ""
    TextButton.AutoButtonColor = false
    TextButton.Selectable = false

    local TextButton2 = TextButton

    TextButton2.Size = UDim2.fromScale(1, 1)

    local TextButton3 = TextButton

    TextButton3.BackgroundColor3 = Color3.new(0, 0, 0)
    TextButton.BackgroundTransparency = 0.4
    TextButton.BorderSizePixel = 0

    local TextButton4 = TextButton

    TextButton4.ZIndex = ZIndex + 20
    TextButton.Visible = false
    UIKit.Corner(TextButton, UITheme.Corner.Panel)
    TextButton.Parent = Content

    local v85 = UIKit.Frame({
        Name = "Box",
        Corner = 14,
        Stroke = 4,
        Parent = TextButton,
        Size = UDim2.fromScale(0.72, 0.44),
        Position = UDim2.fromScale(0.5, 0.45),
        AnchorPoint = Vector2.new(0.5, 0.5),
        Color = Colors.Panel,
        StrokeColor = Colors.PanelStroke,
        Gradient = {
            Colors.PanelGradientA,
            Colors.PanelGradientB,
            90
        },
        ZIndex = ZIndex + 21
    })

    v10 = UIKit.Text({
        Name = "Text",
        Text = "",
        Rich = true,
        Stroke = 3,
        Parent = v85,
        Size = UDim2.fromScale(0.9, 0.34),
        Position = UDim2.fromScale(0.5, 0.08),
        AnchorPoint = Vector2.new(0.5, 0),
        ZIndex = ZIndex + 22
    })
    UIKit.Text({
        Name = "Note",
        Text = "Animals on your plot are kept.",
        Stroke = 2,
        Parent = v85,
        Size = UDim2.fromScale(0.9, 0.14),
        Position = UDim2.fromScale(0.5, 0.45),
        AnchorPoint = Vector2.new(0.5, 0),
        Color = Color3.fromRGB(205, 210, 225),
        ZIndex = ZIndex + 22
    })
    UIKit.Button({
        Name = "Yes",
        Text = "SELL",
        Parent = v85,
        Size = UDim2.fromScale(0.42, 0.27),
        Position = UDim2.fromScale(0.27, 0.9),
        AnchorPoint = Vector2.new(0.5, 1),
        Colors = {
            Colors.GreenA,
            Colors.GreenB
        },
        ZIndex = ZIndex + 22,
        OnClick = sellAll
    })
    UIKit.Button({
        Name = "No",
        Text = "CANCEL",
        Parent = v85,
        Size = UDim2.fromScale(0.42, 0.27),
        Position = UDim2.fromScale(0.73, 0.9),
        AnchorPoint = Vector2.new(0.5, 1),
        Colors = {
            Colors.GrayA,
            Colors.GrayB
        },
        ZIndex = ZIndex + 22,
        OnClick = hideConfirm
    })
end

local function bindCircle() -- line: 572
    -- upvalues: TweenService (copy), t1 (copy), LocalPlayer (copy), v14 (ref), v15 (ref)
    local v86 = workspace:WaitForChild("SellPlace", 30)
    local v87 = v86 and v86:WaitForChild("ActivationCircle", 10)

    if not v87 then
        warn("[SellShop] Workspace.SellPlace.ActivationCircle missing")

        return
    end

    v14 = v87
    v87.Touched:Connect(function(p21) -- line: 580
        -- upvalues: t1 (copy), LocalPlayer (copy), v15 (ref)
        local Character = LocalPlayer.Character

        if Character and p21:IsDescendantOf(Character) and not v15 then
            t1.Open()
        end
    end)

    local v88 = TweenInfo.new(1.2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)

    while v87.Parent do
        TweenService:Create(v87, v88, {
            Transparency = 0.55
        }):Play()
        task.wait(1.2)
        TweenService:Create(v87, v88, {
            Transparency = 0.85
        }):Play()
        task.wait(1.2)
    end
end

local function step() -- line: 598
    -- upvalues: ClientState (copy), t1 (copy), LocalPlayer (copy), v11 (ref), v14 (ref), v15 (ref)
    if not v14 then
        return
    end

    local Character = LocalPlayer.Character
    local HumanoidRootPart = Character and Character:FindFirstChild("HumanoidRootPart")

    if HumanoidRootPart then
        local Magnitude = Vector3.new(HumanoidRootPart.Position.X - v14.Position.X, 0, HumanoidRootPart.Position.Z - v14.Position.Z).Magnitude
        local v91 = HumanoidRootPart.Position.Y - v14.Position.Y
        local v92 = math.max(v14.Size.Y, v14.Size.Z) / 2
        local v93 = math.min(v14.Size.Y, v14.Size.Z) / 2

        if v11 then
            if v92 + 3 < Magnitude
                or ClientState.Busy
                or ClientState.ShopOpen
                or ClientState.IndexOpen
                or ClientState.ExclusiveShopOpen
                or ClientState.AnimalsOpen
                or ClientState.OfflineOpen then
                t1.Close()
            end
        elseif v15 then
            if v92 + 1.5 < Magnitude then
                v15 = false
            end
        elseif Magnitude <= v93 and v91 > -3 and v91 < 9 then
            t1.Open()
        end
    elseif v11 then
        t1.Close()
    end
end

function t1.Init() -- line: 620
    -- upvalues: RunService (copy), DataController (copy), LocalPlayer (copy), t5 (copy), v11 (ref), v13 (ref), refresh (copy), build (copy), bindCircle (copy), step (copy)
    build()
    task.spawn(bindCircle)
    DataController:ObserveTable("Animals", function() -- line: 623
        -- upvalues: v11 (ref), v13 (ref), refresh (copy)
        if not v11 or v13 then
            return
        end

        v13 = true
        task.defer(refresh)
    end)
    LocalPlayer:GetAttributeChangedSignal("CashMultiplier"):Connect(function() -- line: 624
        -- upvalues: t5 (copy), v11 (ref), v13 (ref), refresh (copy)
        for v94, v95 in pairs(t5) do
            v95.Frame:Destroy()
            t5[v94] = nil
        end

        if not v11 or v13 then
            return
        end

        v13 = true
        task.defer(refresh)
    end)
    LocalPlayer:GetAttributeChangedSignal("BestIncome"):Connect(function() -- line: 630
        -- upvalues: t5 (copy), v11 (ref), v13 (ref), refresh (copy)
        for v96, v97 in pairs(t5) do
            if v97.Entry.OfBest then
                v97.Frame:Destroy()
                t5[v96] = nil
            end
        end

        if not v11 or v13 then
            return
        end

        v13 = true
        task.defer(refresh)
    end)
    RunService.Heartbeat:Connect(step)
end

return t1
