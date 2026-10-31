-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local GameConfig = require(ReplicatedStorage.Config.GameConfig)
local UITheme = require(ReplicatedStorage.Config.UITheme)
local RarityConfig = require(ReplicatedStorage.Config.RarityConfig)
local AnimalEconomy = require(ReplicatedStorage.Config.AnimalEconomy)
local FenceConfig = require(ReplicatedStorage.Config.FenceConfig)
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
local t2 = {}

for _, v1 in pairs(AnimalsData) do
    for _, v2 in ipairs(v1) do
        t2[v2.ModelName] = v2.Name
    end
end

local v3, v4, ScrollingFrame, v5, v6, v7, v8, t3, t4
local v9 = false
local t5 = {}
local v10 = false
local v11 = false

local function capacity() -- line: 70
    -- upvalues: FenceConfig (copy), DataController (copy)
    return FenceConfig.SlotsFor(DataController:Get("FenceLevel") or 0)
end

local function rowHeight() -- line: 79
    -- upvalues: ScrollingFrame (ref)
    return (math.max(60, (math.floor((ScrollingFrame.AbsoluteSize.X - ScrollingFrame.ScrollBarThickness) * 0.29))))
end

local function sectionHeader(p1, p2) -- line: 83
    -- upvalues: UIKit (copy), UIScaler (copy), ScrollingFrame (ref)
    local v15 = UIKit.Frame({
        Transparency = 1,
        ZIndex = 6,
        Parent = ScrollingFrame,
        Name = p1,
        Size = UDim2.new(1, -10, 0, (math.round((UIScaler.Px(28)))))
    })

    v15.LayoutOrder = p2

    return v15, (UIKit.Text({
        Name = "Label",
        Text = "",
        ZIndex = 7,
        Stroke = 3,
        Rich = true,
        Parent = v15,
        Size = UDim2.fromScale(1, 0.9),
        Position = UDim2.fromScale(0, 0.5),
        AnchorPoint = Vector2.new(0, 0.5),
        XAlign = Enum.TextXAlignment.Left
    }))
end

local function setButtons(p3) -- line: 90
    -- upvalues: UIKit (copy), Colors (copy)
    local v16 = p3.Entry.Placed == true

    p3.Primary.Label.Text = v16 and "PICK UP" or "EQUIP"
    UIKit.SetButtonColors(p3.Primary, v16 and {
        Colors.BlueA,
        Colors.BlueB
    } or {
        Colors.GreenA,
        Colors.GreenB
    })

    local RowStroke = p3.Frame:FindFirstChild("RowStroke")

    if not RowStroke then
        return
    end

    RowStroke.Color = v16 and Color3.new(1, 1, 1) or Color3.new(0, 0, 0)
    RowStroke.Thickness = v16 and 3.5 or 3
end

local function showConfirm(p4, p5) -- line: 102
    -- upvalues: UIKit (copy), showConfirm (copy)
    p4.Confirming = p5
    p4.Buttons.Visible = not p5
    p4.Confirm.Visible = p5

    if not p5 then
        return
    end

    UIKit.PopIn(p4.Confirm, 0.22, 0.7)

    local t7 = {}

    p4.ConfirmToken = t7
    task.delay(4, function() -- line: 110
        -- upvalues: p4 (copy), t7 (copy), showConfirm (copy)
        if p4.ConfirmToken == t7 and p4.Confirming and p4.Frame.Parent then
            showConfirm(p4, false)
        end
    end)
end

local function makeRow(p6, p7) -- line: 116
    -- upvalues: TweenService (copy), GameConfig (copy), RarityConfig (copy), AnimalEconomy (copy), AnimalUtil (copy), AnimalTemplates (copy), Mutations (copy), NumberFormat (copy), Remotes (copy), Boosts (copy), Parent (copy), UIKit (copy), Sounds (copy), HUDController (copy), Colors (copy), LocalPlayer (copy), t2 (copy), ScrollingFrame (ref), v11 (ref), setButtons (copy), showConfirm (copy)
    local ModelName = p7.ModelName
    local v17 = AnimalEconomy.Get(ModelName) or {
        Income = 0,
        Rarity = "Common"
    }
    local v18 = RarityConfig.Get(v17.Rarity)
    local t8 = {
        Id = p6,
        Entry = p7
    }
    local v21 = UIKit.Frame({
        Corner = 12,
        ZIndex = 6,
        Parent = ScrollingFrame,
        Name = "Row_" .. p6,
        Size = UDim2.new(1, -10, 0, (math.max(60, (math.floor((ScrollingFrame.AbsoluteSize.X - ScrollingFrame.ScrollBarThickness) * 0.29))))),
        Color = Colors.PanelGradientA,
        Gradient = {
            Color3.fromRGB(70, 70, 82),
            Color3.fromRGB(46, 46, 54),
            90
        }
    })

    UIKit.Stroke(v21, 3, Color3.new(0, 0, 0)).Name = "RowStroke"

    local UIScale = Instance.new("UIScale")

    UIScale.Parent = v21
    t8.Frame = v21
    t8.Version = AnimalTemplates.Version()

    local v22 = UIKit.Card({
        Name = "Preview",
        ZIndex = 7,
        Parent = v21,
        Size = UDim2.fromScale(0.86, 0.86),
        Position = UDim2.fromScale(0.025, 0.5),
        AnchorPoint = Vector2.new(0, 0.5),
        Rarity = v17.Rarity
    })

    v22.SizeConstraint = Enum.SizeConstraint.RelativeYY

    local v23 = UIKit.Viewport({
        ZIndex = 9,
        Yaw = -0.6108652381980153,
        Pitch = -0.20943951023931956,
        Padding = 1.05,
        Parent = v22,
        Size = UDim2.fromScale(0.94, 0.94),
        Position = UDim2.fromScale(0.5, 0.5),
        AnchorPoint = Vector2.new(0.5, 0.5)
    })
    local v24 = AnimalUtil.Create(ModelName)

    if v24 then
        Mutations.Apply(v24, p7.Mutation, {
            Particles = false
        })
        v23:SetModel(v24)
    end

    local v25 = UIKit.Frame({
        Name = "Info",
        Transparency = 1,
        ZIndex = 7,
        Parent = v21,
        Size = UDim2.fromScale(0.42, 0.9),
        Position = UDim2.fromScale(0.3, 0.5),
        AnchorPoint = Vector2.new(0, 0.5)
    })
    local UIListLayout = Instance.new("UIListLayout")

    UIListLayout.FillDirection = Enum.FillDirection.Vertical
    UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    UIListLayout.Parent = v25

    local function line(p8, p9, p10, p11) -- line: 146
        -- upvalues: v25 (copy), UIKit (copy)
        local v26 = UIKit.Text({
            ZIndex = 8,
            Parent = v25,
            Text = p8,
            Size = UDim2.fromScale(1, p9),
            XAlign = Enum.TextXAlignment.Left,
            Stroke = p11 or 2
        })

        v26.LayoutOrder = p10

        return v26
    end

    local v27 = Mutations.NameGradient(p7.Mutation)

    if v27 then
        local v28 = line(string.upper(p7.Mutation), 0.19, 1, 2)

        UIKit.Gradient(v28, v27, 90)
    end

    local v29 = line(t2[ModelName] or ModelName, 0.3, 2, 3)

    UIKit.Gradient(v29, v18.Gradient, 90)

    local v30, v31 = Mutations.SizeTitle(p7.Size)

    if v30 then
        line(v30, 0.21, 3, 2).TextColor3 = v31 or Color3.new(1, 1, 1)
    end

    local v32 = Mutations.IncomeOf(p7, LocalPlayer:GetAttribute("BestIncome") or 0)
    local v33 = line(Boosts.AnimalIncomeText(v32, LocalPlayer, p7.OfBest, true), 0.25, 4, 3)

    v33.RichText = true
    v33.TextColor3 = Colors.Money
    t8.Income = v32

    local v34 = UIKit.Frame({
        Name = "Buttons",
        Transparency = 1,
        ZIndex = 8,
        Parent = v21,
        Size = UDim2.fromScale(0.25, 0.84),
        Position = UDim2.fromScale(0.975, 0.5),
        AnchorPoint = Vector2.new(1, 0.5)
    })

    t8.Buttons = v34
    t8.Primary = UIKit.Button({
        Name = "Primary",
        Text = "EQUIP",
        ZIndex = 9,
        Parent = v34,
        Size = UDim2.fromScale(1, 0.46),
        Position = UDim2.fromScale(0.5, 0),
        AnchorPoint = Vector2.new(0.5, 0),
        Juice = {
            HoverScale = 1.05
        },
        OnClick = function() -- OnClick | line: 172
            -- upvalues: p6 (copy), t8 (copy), v21 (copy), Remotes (copy), UIKit (copy), Sounds (copy), v11 (ref)
            if v11 then
                return
            end

            v11 = true

            local v35

            if t8.Entry.Placed then
                v35 = Remotes.Invoke("Plot_PickUpAnimal", p6, true)

                if v35.Ok then
                    Sounds.Play("Pop")
                end
            else
                v35 = Remotes.Invoke("Plot_EquipAnimal", p6)

                if v35.Ok then
                    Sounds.Play("Pop", {
                        Volume = 0.6
                    })
                    Sounds.Play("GroundSmash", {
                        Volume = 0.2,
                        Pitch = 1.5
                    })
                end
            end

            v11 = false

            if v35.Ok then
                UIKit.Punch(v21, 0.05, 0.35)
            end
        end
    })
    UIKit.Button({
        Name = "Sell",
        Text = "SELL",
        ZIndex = 9,
        Parent = v34,
        Size = UDim2.fromScale(1, 0.46),
        Position = UDim2.fromScale(0.5, 1),
        AnchorPoint = Vector2.new(0.5, 1),
        Colors = {
            Colors.RedA,
            Colors.RedB
        },
        Juice = {
            HoverScale = 1.05
        },
        OnClick = function() -- OnClick | line: 189
            -- upvalues: p6 (copy), t8 (copy), Parent (copy), showConfirm (copy)
            if not t8.Entry.Bought then
                showConfirm(t8, true)

                return
            end

            local _require = require
            local ProtectedSell = Parent.ProtectedSell
            local ok, result = pcall(_require, ProtectedSell)

            if ok then
                result.Open(p6)
            end
        end
    })

    local v36 = UIKit.Frame({
        Name = "Confirm",
        Transparency = 1,
        ZIndex = 10,
        Parent = v21,
        Size = UDim2.fromScale(0.3, 0.84),
        Position = UDim2.fromScale(0.975, 0.5),
        AnchorPoint = Vector2.new(1, 0.5)
    })

    v36.Visible = false

    local v37 = v32 * GameConfig.Economy.SellMultiplier

    UIKit.Text({
        Name = "Ask",
        Rich = true,
        ZIndex = 11,
        Stroke = 2,
        Parent = v36,
        Text = "Sell for <font color=\"#8CFF3C\">" .. NumberFormat.Money(v37) .. "</font>?",
        Size = UDim2.fromScale(1, 0.4)
    })
    UIKit.Button({
        Name = "Yes",
        Text = "YES",
        ZIndex = 11,
        Parent = v36,
        Size = UDim2.fromScale(0.48, 0.5),
        Position = UDim2.fromScale(0, 1),
        AnchorPoint = Vector2.new(0, 1),
        Colors = {
            Colors.GreenA,
            Colors.GreenB
        },
        OnClick = function() -- OnClick | line: 203
            -- upvalues: p6 (copy), t8 (copy), NumberFormat (copy), Remotes (copy), Sounds (copy), HUDController (copy), v11 (ref)
            if v11 then
                return
            end

            v11 = true

            local v38 = Remotes.Invoke("Plot_SellAnimal", p6)

            v11 = false

            if v38.Ok then
                Sounds.Play("MoneyReward")
                HUDController.Notify("Sold for " .. NumberFormat.Money(v38.Money or 0) .. "!", "Success")
            else
                t8.Confirming = false
                t8.Buttons.Visible = true
                t8.Confirm.Visible = false
            end
        end
    })
    UIKit.Button({
        Name = "No",
        Text = "NO",
        ZIndex = 11,
        Parent = v36,
        Size = UDim2.fromScale(0.48, 0.5),
        Position = UDim2.fromScale(1, 1),
        AnchorPoint = Vector2.new(1, 1),
        Colors = {
            Colors.GrayA,
            Colors.GrayB
        },
        OnClick = function() -- OnClick | line: 215
            -- upvalues: t8 (copy)
            t8.Confirming = false
            t8.Buttons.Visible = true
            t8.Confirm.Visible = false
        end
    })
    t8.Confirm = v36
    v21.MouseEnter:Connect(function() -- line: 221
        -- upvalues: UIScale (copy), TweenService (copy)
        TweenService:Create(UIScale, TweenInfo.new(0.15, Enum.EasingStyle.Quad), {
            Scale = 1.02
        }):Play()
    end)
    v21.MouseLeave:Connect(function() -- line: 224
        -- upvalues: UIScale (copy), TweenService (copy)
        TweenService:Create(UIScale, TweenInfo.new(0.15, Enum.EasingStyle.Quad), {
            Scale = 1
        }):Play()
    end)
    setButtons(t8)

    return t8
end

local function refresh() -- line: 235
    -- upvalues: FenceConfig (copy), AnimalTemplates (copy), DataController (copy), Colors (copy), v3 (ref), v5 (ref), v6 (ref), v7 (ref), t3 (ref), t4 (ref), t5 (copy), v10 (ref), setButtons (copy), makeRow (copy)
    v10 = false

    if not v3 then
        return
    end

    local v39 = DataController:Get("Animals") or {}

    for v40, v41 in pairs(t5) do
        local v42 = v39[v40]

        if not v42 or v42.ModelName ~= v41.Entry.ModelName or v42.Mutation ~= v41.Entry.Mutation or v42.Size ~= v41.Entry.Size or v41.Version ~= AnimalTemplates.Version() then
            v41.Frame:Destroy()
            t5[v40] = nil
        end
    end

    local t14 = {}
    local t15 = {}

    for v43, v44 in pairs(v39) do
        local v45 = t5[v43]

        if v45 then
            v45.Entry = v44
            setButtons(v45)
        else
            v45 = makeRow(v43, v44)
            t5[v43] = v45
        end

        table.insert(v44.Placed and t14 or t15, v45)
    end

    local function byIncome(p12, p13) -- line: 260
        if p12.Income == p13.Income then
            return p12.Id < p13.Id
        end

        return p12.Income > p13.Income
    end

    table.sort(t14, byIncome)
    table.sort(t15, byIncome)

    local v47 = FenceConfig.SlotsFor(DataController:Get("FenceLevel") or 0)

    t3.LayoutOrder = 0
    t3.Label.Text = "ON YOUR PLOT  <font color=\"#8CFF3C\">" .. #t14 .. "/" .. v47 .. "</font>"

    local t16 = t3

    t16.Visible = #t14 > 0

    for v48, v49 in ipairs(t14) do
        v49.Frame.LayoutOrder = v48
    end

    t4.LayoutOrder = 10000
    t4.Label.Text = "BACKPACK  <font color=\"#FFD84A\">" .. #t15 .. "</font>"

    local t17 = t4

    t17.Visible = #t15 > 0

    for v50, v51 in ipairs(t15) do
        v51.Frame.LayoutOrder = 10000 + v50
    end

    local v52 = v6

    v52.Text = #t14 .. "/" .. v47

    local v53 = v47 <= #t14
    local UIGradient = v5:FindFirstChildOfClass("UIGradient")

    if UIGradient then
        UIGradient.Color = v53 and ColorSequence.new(Colors.YellowA, Colors.YellowB) or ColorSequence.new(Colors.GreenA, Colors.GreenB)
    end

    local v54 = v7

    v54.Visible = #t14 + #t15 == 0
end

local function queueRefresh() -- line: 282
    -- upvalues: v10 (ref), refresh (copy)
    if not v10 then
        v10 = true
        task.defer(refresh)
    end
end

local function resizeRows() -- line: 288
    -- upvalues: ScrollingFrame (ref), t5 (copy)
    local v57 = math.max(60, (math.floor((ScrollingFrame.AbsoluteSize.X - ScrollingFrame.ScrollBarThickness) * 0.29)))

    for _, v58 in pairs(t5) do
        v58.Frame.Size = UDim2.new(1, -10, 0, v57)
    end
end

local function placePanel() -- line: 301
    -- upvalues: UIScaler (copy), v4 (ref)
    UIScaler.Refit(v4.Root, UDim2.fromScale(0.985, 0.5))
end

function t1.Open() -- line: 305
    -- upvalues: Parent (copy), UIKit (copy), Sounds (copy), ClientState (copy), UIScaler (copy), v3 (ref), v4 (ref), v9 (ref), refresh (copy), resizeRows (copy)
    local v59 = true

    if v9 or ClientState.Busy or ClientState.OfflineOpen then
    elseif v3 then
        if ClientState.IndexOpen then
            local _require = require
            local IndexController = Parent.IndexController
            local ok, result = pcall(_require, IndexController)

            if ok then
                result.Close()
            end
        end

        v59 = false
    end

    if v59 then
        return
    end

    if ClientState.ExclusiveShopOpen then
        local _require = require
        local ExclusiveShopController = Parent.ExclusiveShopController
        local ok, result = pcall(_require, ExclusiveShopController)

        if ok then
            result.Close()
        end
    end

    if ClientState.ShopOpen then
        local _require = require
        local ShopController = Parent.ShopController
        local ok, result = pcall(_require, ShopController)

        if ok then
            result.Close()
        end
    end

    v9 = true
    ClientState.AnimalsOpen = true
    v3.Enabled = true
    UIScaler.Refit(v4.Root, UDim2.fromScale(0.985, 0.5))
    refresh()
    resizeRows()
    UIKit.PopIn(v4.Root, 0.35, 0.75)
    Sounds.Play("Slide")
end

function t1.Close() -- line: 330
    -- upvalues: UIKit (copy), Sounds (copy), ClientState (copy), v3 (ref), v4 (ref), v9 (ref)
    if not v9 then
        return
    end

    v9 = false
    ClientState.AnimalsOpen = false
    Sounds.Play("Slide", {
        Volume = 0.2
    })
    UIKit.PopOut(v4.Root, 0.2, 0.8).Completed:Once(function() -- line: 335
        -- upvalues: v3 (ref), v4 (ref), v9 (ref)
        if not v9 then
            v3.Enabled = false
        end

        v4.Root.Visible = true
    end)
end

function t1.IsOpen() -- line: 341
    -- upvalues: v9 (ref)
    return v9
end

local function build() -- line: 345
    -- upvalues: TweenService (copy), UITheme (copy), Remotes (copy), UIKit (copy), Sounds (copy), HUDController (copy), UIScaler (copy), t1 (copy), Colors (copy), v3 (ref), v4 (ref), ScrollingFrame (ref), v5 (ref), v6 (ref), v7 (ref), v8 (ref), t3 (ref), t4 (ref), v9 (ref), v11 (ref), sectionHeader (copy), resizeRows (copy)
    v3 = UIKit.ScreenGui("AnimalsPanelGui", 12, true)
    v3.Enabled = false
    v4 = UIKit.Panel({
        Name = "AnimalsPanel",
        Ratio = 0.6,
        PhoneRatio = 0.78,
        Title = "My Animals",
        HeaderHeight = 0.09,
        Parent = v3,
        Size = UDim2.fromScale(0.34, 0.84),
        Position = UDim2.fromScale(0.985, 0.5),
        AnchorPoint = Vector2.new(1, 0.5),
        OnClose = function() -- OnClose | line: 348
            -- upvalues: t1 (copy)
            t1.Close()
        end
    })
    v4.Title.Size = UDim2.fromScale(0.55, 0.66)
    v5 = UIKit.Frame({
        Name = "Count",
        Corner = 10,
        Stroke = 3,
        Parent = v4.Header,
        Size = UDim2.fromScale(0.27, 0.62),
        Position = UDim2.fromScale(0.86, 0.5),
        AnchorPoint = Vector2.new(1, 0.5),
        Color = Colors.GreenA,
        Gradient = {
            Colors.GreenA,
            Colors.GreenB,
            90
        },
        ZIndex = v4.Header.ZIndex + 3
    })

    local ImageLabel = Instance.new("ImageLabel")

    ImageLabel.BackgroundTransparency = 1
    ImageLabel.Image = "rbxassetid://105642295248032"
    ImageLabel.ScaleType = Enum.ScaleType.Fit
    ImageLabel.Size = UDim2.fromScale(0.95, 0.95)
    ImageLabel.SizeConstraint = Enum.SizeConstraint.RelativeYY
    ImageLabel.Position = UDim2.fromScale(0.04, 0.5)
    ImageLabel.AnchorPoint = Vector2.new(0, 0.5)
    ImageLabel.ZIndex = v5.ZIndex + 1
    ImageLabel.Parent = v5
    v6 = UIKit.Text({
        Name = "Text",
        Text = "0/10",
        Stroke = 3,
        Parent = v5,
        Size = UDim2.fromScale(0.6, 0.8),
        Position = UDim2.fromScale(0.95, 0.5),
        AnchorPoint = Vector2.new(1, 0.5),
        XAlign = Enum.TextXAlignment.Right,
        ZIndex = v5.ZIndex + 1
    })

    local Content = v4.Content

    ScrollingFrame = Instance.new("ScrollingFrame")
    ScrollingFrame.Name = "List"

    local ScrollingFrame2 = ScrollingFrame

    ScrollingFrame2.Size = UDim2.fromScale(0.94, 0.81)

    local ScrollingFrame3 = ScrollingFrame

    ScrollingFrame3.Position = UDim2.fromScale(0.5, 0.015)

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
    ScrollingFrame.ZIndex = 5
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
    t3 = {}

    local t18 = t3
    local t19 = t3
    local v63, v64 = sectionHeader("PlotHeader", 0)

    t18.Frame = v63
    t19.Label = v64
    t4 = {}

    local t20 = t4
    local t21 = t4
    local v65, v66 = sectionHeader("BagHeader", 10000)

    t20.Frame = v65
    t21.Label = v66

    local t22 = t3

    setmetatable(t22, {
        __newindex = function(p14, p15, p16) -- __newindex | line: 393
            p14.Frame[p15] = p16
        end
    })

    local t24 = t4

    setmetatable(t24, {
        __newindex = function(p17, p18, p19) -- __newindex | line: 394
            p17.Frame[p18] = p19
        end
    })
    v7 = UIKit.Text({
        Name = "Empty",
        Text = "No animals yet!\nThrow food past the line to catch some.",
        ZIndex = 6,
        Stroke = 3,
        Parent = Content,
        Size = UDim2.fromScale(0.85, 0.2),
        Position = UDim2.fromScale(0.5, 0.35),
        AnchorPoint = Vector2.new(0.5, 0.5),
        Color = Color3.fromRGB(210, 214, 228)
    })
    v8 = UIKit.Button({
        Name = "EquipBest",
        Text = "EQUIP BEST",
        ZIndex = 8,
        Parent = Content,
        Size = UDim2.fromScale(0.9, 0.12),
        Position = UDim2.fromScale(0.5, 0.975),
        AnchorPoint = Vector2.new(0.5, 1),
        Colors = {
            Colors.YellowA,
            Colors.YellowB
        },
        Juice = {
            HoverScale = 1.04
        },
        OnClick = function() -- OnClick | line: 397
            -- upvalues: Remotes (copy), UIKit (copy), Sounds (copy), HUDController (copy), v8 (ref), v11 (ref)
            if v11 then
                return
            end

            v11 = true

            local Plot_EquipBest = Remotes.Invoke("Plot_EquipBest")

            v11 = false

            if Plot_EquipBest.Ok then
                UIKit.Punch(v8, 0.12, 0.4)

                if (Plot_EquipBest.Placed or 0) ~= 0 or (Plot_EquipBest.Removed or 0) ~= 0 then
                    Sounds.Play("LevelUp", {
                        Volume = 0.45,
                        Pitch = 1.3
                    })
                    HUDController.Notify("Your best " .. (Plot_EquipBest.Count or 0) .. " animals are on your plot!", "Success")
                else
                    HUDController.Notify("Your best animals are already on your plot!", "Info")
                end
            else
                Sounds.Play("PurchaseFail", {
                    Volume = 0.4
                })
            end
        end
    })

    local v67 = UIKit.Frame({
        Name = "Shine",
        Parent = v8,
        Color = Color3.new(1, 1, 1),
        Corner = UITheme.Corner.Button,
        ZIndex = v8.ZIndex + 2
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
    UIGradient.Parent = v67
    task.spawn(function() -- line: 424
        -- upvalues: UIGradient (copy), TweenService (copy), v8 (ref), v9 (ref)
        while v8.Parent do
            if v9 then
                UIGradient.Offset = Vector2.new(-1, 0)
                TweenService:Create(UIGradient, TweenInfo.new(0.8, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {
                    Offset = Vector2.new(1, 0)
                }):Play()
            end

            task.wait(3)
        end
    end)
    ScrollingFrame:GetPropertyChangedSignal("AbsoluteSize"):Connect(resizeRows)
end

function t1.Init() -- line: 436
    -- upvalues: RunService (copy), DataController (copy), HUDController (copy), ClientState (copy), t1 (copy), LocalPlayer (copy), v9 (ref), t5 (copy), v10 (ref), refresh (copy), build (copy)
    build()
    HUDController.AnimalsRequested:Connect(function() -- line: 438
        -- upvalues: t1 (copy), v9 (ref)
        if v9 then
            t1.Close()
        else
            t1.Open()
        end
    end)
    DataController:ObserveTable("Animals", function() -- line: 441
        -- upvalues: v9 (ref), v10 (ref), refresh (copy)
        if not v9 or v10 then
            return
        end

        v10 = true
        task.defer(refresh)
    end)
    DataController:Observe("FenceLevel", function() -- line: 442
        -- upvalues: v9 (ref), v10 (ref), refresh (copy)
        if not v9 or v10 then
            return
        end

        v10 = true
        task.defer(refresh)
    end)
    LocalPlayer:GetAttributeChangedSignal("CashMultiplier"):Connect(function() -- line: 443
        -- upvalues: v9 (ref), t5 (copy), v10 (ref), refresh (copy)
        for v68, v69 in pairs(t5) do
            v69.Frame:Destroy()
            t5[v68] = nil
        end

        if not v9 or v10 then
            return
        end

        v10 = true
        task.defer(refresh)
    end)
    LocalPlayer:GetAttributeChangedSignal("BestIncome"):Connect(function() -- line: 449
        -- upvalues: v9 (ref), t5 (copy), v10 (ref), refresh (copy)
        for v70, v71 in pairs(t5) do
            if v71.Entry.OfBest then
                v71.Frame:Destroy()
                t5[v70] = nil
            end
        end

        if not v9 or v10 then
            return
        end

        v10 = true
        task.defer(refresh)
    end)
    RunService.Heartbeat:Connect(function() -- line: 458
        -- upvalues: ClientState (copy), t1 (copy), v9 (ref)
        if v9 and ClientState.Busy then
            t1.Close()
        end
    end)
end

return t1
