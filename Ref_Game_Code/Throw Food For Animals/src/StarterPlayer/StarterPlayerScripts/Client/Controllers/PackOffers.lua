-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local v1 = game:GetService("ReplicatedStorage")
local MonetizationConfig = require(v1.Config.MonetizationConfig)
local GameConfig = require(v1.Config.GameConfig)
local LevelConfig = require(v1.Config.LevelConfig)
local AreasConfig = require(v1.Config.AreasConfig)
local FoodsConfig = require(v1.Config.FoodsConfig)
local StandsConfig = require(v1.Config.StandsConfig)
local AnimalRoll = require(v1.Shared.AnimalRoll)
local NumberFormat = require(v1.Shared.NumberFormat)
local Remotes = require(v1.Shared.Remotes)

v1 = script.Parent

local DataController = require(v1.DataController)
local ShopUI = require(v1.ShopUI)
local UIScaler = require(v1.UIScaler)
local Sounds = require(v1.Sounds)
local ClientState = require(v1.ClientState)
local HUDController = require(v1.HUDController)
local RobuxPrices = require(v1.RobuxPrices)
local ExclusiveShopController = require(v1.ExclusiveShopController)
local ThrowController = require(v1.ThrowController)

v1 = {}

local LocalPlayer = Players.LocalPlayer
local PackOffers, Packs = MonetizationConfig.PackOffers, MonetizationConfig.Packs

local function rgb(p1, p2, p3) -- line: 98
    return Color3.fromRGB(p1, p2, p3)
end

local t1 = {
    Money = {
        Face = {
            Color3.fromRGB(132, 232, 92),
            rgb(34, 150, 58)
        },
        Edge = Color3.fromRGB(16, 88, 34),
        Text = {
            Color3.fromRGB(255, 255, 255),
            rgb(205, 255, 170)
        },
        Glow = Color3.fromRGB(225, 255, 175)
    },
    Power = {
        Face = {
            Color3.fromRGB(255, 204, 70),
            rgb(238, 116, 18)
        },
        Edge = Color3.fromRGB(136, 58, 6),
        Text = {
            Color3.fromRGB(255, 255, 255),
            rgb(255, 238, 170)
        },
        Glow = Color3.fromRGB(255, 238, 150)
    },
    Lucky = {
        Face = {
            Color3.fromRGB(206, 140, 255),
            rgb(122, 50, 216)
        },
        Edge = Color3.fromRGB(64, 20, 122),
        Text = {
            Color3.fromRGB(255, 255, 255),
            rgb(240, 214, 255)
        },
        Glow = Color3.fromRGB(244, 220, 255)
    }
}
local ScreenGui, v2, v3
local elapsed = os.clock()
local n1 = 0
local n2 = (-1e999)
local t3 = {
    Money = (-1e999),
    Power = (-1e999),
    Lucky = (-1e999)
}
local t4
local n3 = 1
local t5 = {}
local Busy
local elapsed2 = os.clock()
local n4 = 0
local v4
local elapsed3 = os.clock()
local n5 = 0
local n6 = 0
local t6

local function level() -- line: 142
    -- upvalues: DataController (copy)
    return DataController:Get("Level") or 1
end

local function lines() -- line: 147
    -- upvalues: AreasConfig (copy), AnimalRoll (copy)
    local t7 = {}
    local List = AreasConfig.List

    for v5, v6 in ipairs(List) do
        for i = 1, AreasConfig.SubAreas do
            if v5 ~= #List or i ~= AreasConfig.SubAreas then
                table.insert(t7, v6.StartDistance + v6.Length * i / AreasConfig.SubAreas)
            end
        end
    end

    for _, v8 in ipairs(AnimalRoll.Config.TipAnimals or {}) do
        local v9 = AreasConfig.ByKey[v8.Area]

        if v9 and AreasConfig.IsPlayable(v9) then
            table.insert(t7, v9.StartDistance + v9.Length * v8.From)
        end
    end

    table.sort(t7)

    return t7
end

local function goodReach(p4) -- line: 168
    -- upvalues: GameConfig (copy), LevelConfig (copy), PackOffers (copy)
    return LevelConfig.ThrowPowerForLevel(p4) + GameConfig.Throw.MeterBonusStuds * PackOffers.GoodMeter
end

local function crossAt(p5) -- line: 173
    -- upvalues: GameConfig (copy)
    return p5 - GameConfig.Throw.LineMargin + 0.01
end

local function levelsFor(p6, p7) -- line: 178
    -- upvalues: GameConfig (copy), LevelConfig (copy), PackOffers (copy)
    local v11 = p6 - GameConfig.Throw.LineMargin + 0.01 - (LevelConfig.ThrowPowerForLevel(p7) + GameConfig.Throw.MeterBonusStuds * PackOffers.GoodMeter)

    if v11 <= 0 then
        return 0
    end

    return (math.ceil(v11 / LevelConfig.PowerPerLevel))
end

local function trainSeconds(p8, p9, p10) -- line: 186
    -- upvalues: GameConfig (copy), LevelConfig (copy), StandsConfig (copy), DataController (copy), LocalPlayer (copy)
    local v14 = StandsConfig.Get((math.clamp(DataController:Get("Stand") or 0, 0, StandsConfig.Count())))

    if not v14 then
        return nil
    end

    local v15 = v14.XpPerRep * (LocalPlayer:GetAttribute("XpMultiplier") or 1) / GameConfig.Training.RepInterval
    local v16 = LevelConfig.XpForLevel(p9) - (p10 or 0)

    for i = p9 + 1, p9 + p8 - 1 do
        v16 += LevelConfig.XpForLevel(i)
    end

    return v16 / v15
end

local function powerPackFor(p11, p12) -- line: 198
    -- upvalues: MonetizationConfig (copy), LevelConfig (copy), Packs (copy)
    local v17 = LevelConfig.PowerRoom(p12)

    for _, v18 in ipairs(Packs.Power) do
        local Power = MonetizationConfig.Products[v18].Grant.Power

        if p11 * LevelConfig.PowerPerLevel <= Power and Power <= v17 then
            return v18
        end
    end

    return nil
end

local function powerOffer(p13) -- line: 209
    -- upvalues: GameConfig (copy), LevelConfig (copy), DataController (copy), PackOffers (copy), trainSeconds (copy), powerPackFor (copy)
    local v19 = DataController:Get("Level") or 1
    local v20 = p13 - GameConfig.Throw.LineMargin + 0.01 - (LevelConfig.ThrowPowerForLevel(v19) + GameConfig.Throw.MeterBonusStuds * PackOffers.GoodMeter)
    local v21 = if v20 <= 0 then 0 else math.ceil(v20 / LevelConfig.PowerPerLevel)

    if v21 <= 0 then
        return nil
    end

    local v23 = trainSeconds(v21, v19, DataController:Get("Xp") or 0)

    if not v23 or v23 < PackOffers.TrainSeconds then
        return nil
    end

    local v24 = powerPackFor(v21, v19)

    return if v24 then {
        Kind = "Power",
        Key = v24,
        Target = "Line" .. math.floor(p13 + 0.5),
        Line = p13
    } else nil
end

local function refreshReach() -- line: 221
    -- upvalues: GameConfig (copy), LevelConfig (copy), DataController (copy), PackOffers (copy), v4 (ref), elapsed3 (ref), n5 (ref), n6 (ref), lines (copy)
    local v26 = DataController:Get("Level") or 1
    local v27 = LevelConfig.ThrowPowerForLevel(v26) + GameConfig.Throw.MeterBonusStuds * PackOffers.GoodMeter
    local n7 = 0

    for _, v28 in ipairs((lines())) do
        if not (v28 - GameConfig.Throw.LineMargin + 0.01 <= v27) then
            break
        end

        n7 += 1
    end

    if v4 == nil or v4 < n7 then
        elapsed3 = os.clock()
        n5 = 0
        n6 = 0
    end

    v4 = n7
end

local function stuckOffer() -- line: 236
    -- upvalues: GameConfig (copy), LevelConfig (copy), DataController (copy), PackOffers (copy), elapsed3 (ref), n5 (ref), n6 (ref), lines (copy), powerOffer (copy)
    local v29 = not (os.clock() - elapsed3 < PackOffers.StuckMinutes * 60)

    if v29 then
        local v30 = n5
        local v31 = v30 < PackOffers.StuckThrows

        if v31 then
            local v32 = n6

            v31 = v32 < PackOffers.LongTraining
        end

        v29 = not v31
    end

    if v29 then
        local v33 = DataController:Get("Level") or 1
        local v34 = LevelConfig.ThrowPowerForLevel(v33) + GameConfig.Throw.MeterBonusStuds * PackOffers.GoodMeter

        for _, v35 in ipairs((lines())) do
            if v34 < v35 - GameConfig.Throw.LineMargin + 0.01 then
                return (powerOffer(v35))
            end
        end
    end

    return nil
end

local function shortOffer(p14) -- line: 247
    -- upvalues: AreasConfig (copy), PackOffers (copy), lines (copy), powerOffer (copy)
    local v36 = tonumber(p14.ForwardDistance)

    if not v36 then
        v36 = tonumber(p14.Distance)
    end

    if v36 then
        local v37 = AreasConfig.StartGap

        for _, v38 in ipairs((lines())) do
            if v36 < v38 then
                return if v38 - v36 <= PackOffers.CloseShare * (v38 - v37) then powerOffer(v38) else nil
            end

            v37 = v38
        end
    end

    return nil
end

local function bestOwnedFood() -- line: 265
    -- upvalues: FoodsConfig (copy), DataController (copy)
    local n8 = 0

    for i = 1, FoodsConfig.Count() do
        if DataController:GetPath("OwnedFoods." .. i) == true then
            n8 = i
        end
    end

    return n8
end

local function nextPurchase() -- line: 274
    -- upvalues: FoodsConfig (copy), StandsConfig (copy), DataController (copy), bestOwnedFood (copy)
    local v40 = FoodsConfig.Get(bestOwnedFood() + 1)
    local t9 = if v40 and v40.Price > 0 then {
        Key = "Food" .. v40.Index,
        Price = v40.Price
    } else nil
    local v41 = StandsConfig.Get((DataController:Get("Stand") or 0) + 1)
    local t10 = t9

    if v41 and (not t9 or v41.Price < t9.Price) then
        t10 = {
            Key = "Bar" .. v41.Index,
            Price = v41.Price
        }
    end

    return t10
end

local function refreshMoneyTarget() -- line: 284
    -- upvalues: DataController (copy), t6 (ref), nextPurchase (copy)
    local v43 = nextPurchase()

    if v43 and not ((DataController:Get("Money") or 0) >= v43.Price) then
        if not t6 or t6.Key ~= v43.Key then
            t6 = {
                Key = v43.Key,
                Price = v43.Price,
                Since = os.clock()
            }
        end

        return
    end

    t6 = nil
end

local function moneyOffer() -- line: 294
    -- upvalues: MonetizationConfig (copy), DataController (copy), LocalPlayer (copy), PackOffers (copy), Packs (copy), t6 (ref), refreshMoneyTarget (copy)
    refreshMoneyTarget()

    local t13 = t6

    if t13 and not (os.clock() - t13.Since < PackOffers.WaitMinutes * 60) then
        local v44 = t13.Price - (DataController:Get("Money") or 0)
        local v45 = LocalPlayer:GetAttribute("IncomeRate") or 0
        local v46 = v44 <= 0
        local v47 = if not v46 then v44 / math.max(v45, Packs.MinIncome or 0, 1E-09) / 60 < PackOffers.MinGapMinutes else nil

        if not (v46 or v47) then
            for _, v49 in ipairs(Packs.Money) do
                if v44 <= MonetizationConfig.PackMoney(v49, v45) then
                    return {
                        Kind = "Money",
                        Key = v49,
                        Target = t13.Key
                    }
                end
            end
        end
    end

    return nil
end

local function stillUseful(p15) -- line: 310
    -- upvalues: MonetizationConfig (copy), GameConfig (copy), LevelConfig (copy), DataController (copy), PackOffers (copy), t6 (ref), refreshMoneyTarget (copy)
    if p15.Test or p15.Kind == "Lucky" then
        return true
    end

    if p15.Kind == "Money" then
        refreshMoneyTarget()

        return t6 ~= nil and t6.Key == p15.Target
    end

    local v50 = DataController:Get("Level") or 1
    local v51 = p15.Line - GameConfig.Throw.LineMargin + 0.01 - (LevelConfig.ThrowPowerForLevel(v50) + GameConfig.Throw.MeterBonusStuds * PackOffers.GoodMeter)

    if (if v51 <= 0 then 0 else math.ceil(v51 / LevelConfig.PowerPerLevel)) > 0 then
        return LevelConfig.PowerRoom(v50) >= MonetizationConfig.Products[p15.Key].Grant.Power
    end

    return false
end

local function windowOpen() -- line: 324
    -- upvalues: ClientState (copy)
    return ClientState.ShopOpen
        or ClientState.SellOpen
        or ClientState.ExclusiveShopOpen
        or ClientState.IndexOpen
        or ClientState.AnimalsOpen
        or ClientState.ProtectedSellOpen
        or ClientState.InventoryOpen
        or ClientState.ReleaseShow
end

local function announcementShowing() -- line: 331
    -- upvalues: LocalPlayer (copy)
    local Announcements = LocalPlayer.PlayerGui:FindFirstChild("Announcements")

    if Announcements and Announcements.Enabled then
        for _, child in ipairs(Announcements:GetChildren()) do
            if child:IsA("GuiObject") and child.Visible then
                return true
            end
        end
    end

    return false
end

local function eligible() -- line: 341
    -- upvalues: DataController (copy), ClientState (copy), PackOffers (copy), elapsed (ref)
    if not DataController:IsReady() or ClientState.TutorialActive or os.clock() - elapsed < PackOffers.QuietAtStart then
        return false
    end

    return (DataController:Get("Throws") or 0) >= PackOffers.MinThrows
end

local function screenFree() -- line: 348
    -- upvalues: ClientState (copy), HUDController (copy), announcementShowing (copy)
    local v54 = not ClientState.Busy
    local ShopOpen, v55

    if v54 then
        local v56 = not ClientState.OfflineOpen

        if v56 then
            ShopOpen = ClientState.ShopOpen
                or ClientState.SellOpen
                or ClientState.ExclusiveShopOpen
                or ClientState.IndexOpen
                or ClientState.AnimalsOpen
                or ClientState.ProtectedSellOpen
                or ClientState.InventoryOpen
                or ClientState.ReleaseShow
            v55 = not ShopOpen and not announcementShowing() and not HUDController.IsGameplayHidden() and not ClientState.UpgradePopupShowing and not ClientState.UpgradeWaiting
        else
            v55 = v56
        end
    else
        v55 = v54
    end

    return v55
end

local function allowed(p16) -- line: 353
    -- upvalues: PackOffers (copy), n2 (ref), t3 (copy), n3 (ref), t5 (copy)
    if p16 and not ((t5[p16.Target] or 0) >= PackOffers.TargetRepeats) then
        local elapsed = os.clock()

        return elapsed - n2 >= math.min(PackOffers.GapAny * n3, PackOffers.GapMax) and elapsed - t3[p16.Kind] >= math.min(PackOffers.GapSameKind * n3, PackOffers.GapMax)
    end

    return false
end

local function amountText(p17) -- line: 364
    -- upvalues: MonetizationConfig (copy), NumberFormat (copy), LocalPlayer (copy)
    if p17.Kind == "Money" then
        return "+" .. NumberFormat.Money(MonetizationConfig.PackMoney(p17.Key, LocalPlayer:GetAttribute("IncomeRate")))
    end

    if p17.Kind == "Lucky" then
        return "+" .. NumberFormat.Abbreviate(MonetizationConfig.PackAmount(p17.Key)) .. " LUCKY THROWS"
    end

    return "+" .. NumberFormat.Abbreviate(MonetizationConfig.Products[p17.Key].Grant.Power) .. " POWER"
end

local function priceText(p18) -- line: 373
    -- upvalues: ShopUI (copy), RobuxPrices (copy)
    return ShopUI.FormatRobux(RobuxPrices.Get(p18.Id, Enum.InfoType.Product, p18.Price))
end

local function restingPosition() -- line: 377
    -- upvalues: UIScaler (copy)
    return UDim2.new(0.5, 0, 0, (math.round((UIScaler.Px(10)))))
end

local function hiddenPosition() -- line: 381
    return UDim2.new(0.5, 0, -0.3, 0)
end

local close

local function onClick() -- line: 387
    -- upvalues: Remotes (copy), Sounds (copy), ExclusiveShopController (copy), v2 (ref), close (ref)
    local v63 = v2

    if not v63 or v63.Closing then
        return
    end

    Sounds.Play("ButtonClick")
    Remotes.Event("Shop_PackOffer"):FireServer("Clicked", v63.Key)
    close("Clicked")
    ExclusiveShopController.Open("PacksTitle", v63.Key)
end

local function build(p19) -- line: 396
    -- upvalues: MonetizationConfig (copy), ShopUI (copy), UIScaler (copy), Sounds (copy), RobuxPrices (copy), PackOffers (copy), t1 (copy), ScreenGui (ref), amountText (copy), close (ref), onClick (copy)
    local v64 = MonetizationConfig.Products[p19.Key]
    local v65 = t1[p19.Kind]
    local v66 = UIScaler.TouchBoost()
    local v67 = ShopUI.Frame({
        Name = "PackOffer",
        Transparency = 1,
        ZIndex = 10,
        Parent = ScreenGui,
        Size = UDim2.fromScale(0.42 * v66, 0.175 * v66),
        Position = UDim2.new(0.5, 0, -0.3, 0),
        AnchorPoint = Vector2.new(0.5, 0)
    })

    v67.SizeConstraint = Enum.SizeConstraint.RelativeYY

    local v68 = ShopUI.Frame({
        Name = "Body",
        Transparency = 1,
        ZIndex = 10,
        Parent = v67
    })
    local UIScale = Instance.new("UIScale")

    UIScale.Name = "Breath"
    UIScale.Parent = v68
    ShopUI.Frame({
        Name = "Edge",
        Corner = 16,
        Stroke = 3,
        ZIndex = 11,
        Parent = v68,
        Size = UDim2.fromScale(1, 0.72),
        Position = UDim2.fromOffset(0, (math.round((UIScaler.Px(5))))),
        Color = v65.Edge
    })

    local v70 = ShopUI.Frame({
        Name = "Face",
        Corner = 16,
        ZIndex = 12,
        Parent = v68,
        Size = UDim2.fromScale(1, 0.72),
        Gradient = {
            v65.Face[1],
            v65.Face[2],
            90
        }
    })

    ShopUI.Stroke(v70, 3, Color3.new(1, 1, 1))
    ShopUI.Stripes(v70, 0.9, 16, 20).ZIndex = 12
    ShopUI.Frame({
        Name = "Shine",
        Transparency = 0.8,
        Corner = 12,
        ZIndex = 13,
        Parent = v70,
        Size = UDim2.new(1, -10, 0.4, 0),
        Position = UDim2.fromOffset(5, 3)
    })

    local v71 = ShopUI.Frame({
        Name = "Sweep",
        Corner = 16,
        ZIndex = 13,
        Parent = v70
    })
    local UIGradient = Instance.new("UIGradient")

    UIGradient.Rotation = 20
    UIGradient.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 1),
        NumberSequenceKeypoint.new(0.4, 1),
        NumberSequenceKeypoint.new(0.5, 0.5),
        NumberSequenceKeypoint.new(0.6, 1),
        NumberSequenceKeypoint.new(1, 1)
    })
    UIGradient.Offset = Vector2.new(-1, 0)
    UIGradient.Parent = v71
    ShopUI.Rays(v70, v65.Glow, {
        ZIndex = 13,
        Count = 7,
        Width = 0.13,
        Alpha = 0.45,
        Speed = 28,
        Size = UDim2.fromScale(1.8, 1.8),
        Position = UDim2.fromScale(0.17, 0.48)
    }).SizeConstraint = Enum.SizeConstraint.RelativeYY
    ShopUI.Image({
        Name = "Icon",
        ZIndex = 14,
        Parent = v70,
        Image = v64.Icon,
        Size = UDim2.fromScale(1.6, 1.6),
        Position = UDim2.fromScale(0.17, 0.45),
        AnchorPoint = Vector2.new(0.5, 0.5)
    }).SizeConstraint = Enum.SizeConstraint.RelativeYY

    local v72 = ShopUI.Text({
        Name = "Amount",
        ZIndex = 15,
        Stroke = 4,
        Parent = v70,
        Text = amountText(p19),
        Size = UDim2.fromScale(0.6, 0.6),
        Position = UDim2.fromScale(0.645, 0.52),
        AnchorPoint = Vector2.new(0.5, 0.5),
        Gradient = {
            v65.Text[1],
            v65.Text[2],
            90
        }
    })
    local v76 = ShopUI.Frame({
        Name = "TimeBack",
        Transparency = 0.45,
        Corner = 3,
        ZIndex = 15,
        Parent = v70,
        Size = UDim2.new(0.6, 0, 0, (math.max(3, (math.round((UIScaler.Px(4))))))),
        Position = UDim2.new(0.645, 0, 0, (math.round((UIScaler.Px(6))))),
        AnchorPoint = Vector2.new(0.5, 0),
        Color = Color3.fromRGB(20, 20, 26)
    })
    local v77 = ShopUI.Frame({
        Name = "Time",
        Corner = 3,
        ZIndex = 16,
        Parent = v76
    })
    local v78 = ShopUI.Frame({
        Name = "Price",
        Stroke = 3,
        ZIndex = 17,
        Parent = v68,
        Size = UDim2.fromScale(0.34, 0.34),
        Position = UDim2.fromScale(0.645, 0.62),
        AnchorPoint = Vector2.new(0.5, 0),
        Corner = UDim.new(0.5, 0),
        Gradient = {
            ShopUI.PillGradient[1],
            ShopUI.PillGradient[2],
            90
        }
    })
    local v79 = ShopUI.Frame({
        Name = "Content",
        Transparency = 1,
        ZIndex = 17,
        Parent = v78,
        Size = UDim2.fromScale(0.84, 0.72),
        Position = UDim2.fromScale(0.5, 0.5),
        AnchorPoint = Vector2.new(0.5, 0.5)
    })
    local UIListLayout = Instance.new("UIListLayout")

    UIListLayout.FillDirection = Enum.FillDirection.Horizontal
    UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    UIListLayout.Padding = UDim.new(0.05, 0)
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    UIListLayout.Parent = v79
    ShopUI.Image({
        Name = "RobuxIcon",
        Square = true,
        ZIndex = 17,
        Parent = v79,
        Image = ShopUI.RobuxIcon,
        Size = UDim2.fromScale(1, 0.95)
    }).LayoutOrder = 1

    local v80 = ShopUI.Text({
        Name = "PriceLabel",
        ZIndex = 17,
        Stroke = 3,
        Parent = v79,
        Text = ShopUI.FormatRobux(RobuxPrices.Get(v64.Id, Enum.InfoType.Product, v64.Price)),
        Size = UDim2.fromScale(0.5, 1),
        Gradient = {
            Color3.new(1, 1, 1),
            Color3.fromRGB(190, 255, 170),
            90
        }
    })

    v80.LayoutOrder = 2

    local TextButton = Instance.new("TextButton")

    TextButton.Name = "HitArea"
    TextButton.Text = ""
    TextButton.AutoButtonColor = false
    TextButton.BackgroundTransparency = 1
    TextButton.Size = UDim2.fromScale(1, 1)
    TextButton.ZIndex = 19
    TextButton.Parent = v67
    ShopUI.Button({
        Name = "Close",
        Text = "X",
        Color = "Red",
        Ratio = 1,
        ZIndex = 20,
        HoverScale = 1.12,
        Parent = v67,
        Size = UDim2.fromScale(0.13, 0.3),
        Position = UDim2.fromScale(1, 0),
        AnchorPoint = Vector2.new(0.6, 0.35),
        OnClick = function() -- OnClick | line: 461
            -- upvalues: close (ref)
            close("Closed")
        end
    })

    local t16 = {
        Hovered = false,
        NextText = 0,
        Key = p19.Key,
        Kind = p19.Kind,
        Target = p19.Target,
        Line = p19.Line,
        Test = p19.Test,
        Root = v67,
        Body = v68,
        Breath = UIScale,
        Bar = v77,
        Amount = v72,
        Price = v80,
        Product = v64,
        SweepGradient = UIGradient,
        Remaining = PackOffers.ShowTime,
        ShownAt = os.clock(),
        NextSweep = os.clock() + 0.5,
        NextWiggle = os.clock() + 3.6
    }

    TextButton.MouseEnter:Connect(function() -- line: 468
        -- upvalues: UIScale (copy), t16 (copy), ShopUI (copy), Sounds (copy)
        t16.Hovered = true
        ShopUI.Tween(UIScale, {
            Scale = 1.06
        }, 0.16, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
        Sounds.Play("ButtonHover")
    end)
    TextButton.MouseLeave:Connect(function() -- line: 473
        -- upvalues: UIScale (copy), t16 (copy), ShopUI (copy)
        t16.Hovered = false
        ShopUI.Tween(UIScale, {
            Scale = 1
        }, 0.18)
    end)
    TextButton.MouseButton1Down:Connect(function() -- line: 477
        -- upvalues: UIScale (copy), ShopUI (copy)
        ShopUI.Tween(UIScale, {
            Scale = 0.96
        }, 0.08)
    end)
    TextButton.Activated:Connect(onClick)

    return t16
end

local function show(p20) -- line: 484
    -- upvalues: TweenService (copy), Remotes (copy), UIScaler (copy), Sounds (copy), ClientState (copy), HUDController (copy), v2 (ref), n2 (ref), t3 (copy), t5 (copy), build (copy)
    t5[p20.Target] = (t5[p20.Target] or 0) + 1
    n2 = os.clock()
    t3[p20.Kind] = os.clock()
    v2 = build(p20)
    ClientState.PackOfferShowing = true

    local Root = v2.Root

    TweenService:Create(Root, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Position = UDim2.new(0.5, 0, 0, (math.round((UIScaler.Px(10)))))
    }):Play()

    local v83 = HUDController.GetGui()

    if v83 then
        local v84 = UIScaler.Px(10) + Root.AbsoluteSize.Y + UIScaler.Px(8)

        HUDController.SetToastOffset((math.max(0, v84 - v83.AbsoluteSize.Y * 0.08)))
    end

    Sounds.Play("Pop", {
        Volume = 0.4,
        Delay = 0.1
    })
    Remotes.Event("Shop_PackOffer"):FireServer("Shown", p20.Key)
end

function close(p21) -- line: 504
    -- upvalues: TweenService (copy), ClientState (copy), HUDController (copy), PackOffers (copy), v2 (ref), n1 (ref), n3 (ref), t5 (copy)
    local v86 = v2

    if not v86 or v86.Closing then
        return
    else
        v86.Closing = true
        v2 = nil
        ClientState.PackOfferShowing = false

        local v88 = os.clock() - v86.ShownAt

        if p21 == "Clicked" then
            n3 = 1
        elseif p21 == "Timeout" or p21 == "Closed" or p21 == "Interrupted" and v88 >= 5 then
            local v89 = n3

            n3 = math.min(v89 * PackOffers.Backoff, PackOffers.GapMax / PackOffers.GapAny)
        elseif p21 ~= "Done" and v88 < 5 then
            t5[v86.Target] = math.max(0, (t5[v86.Target] or 1) - 1)
        end
    end

    local v93 = n1

    n1 = math.max(v93, os.clock() + 1.5)
    HUDController.SetToastOffset(0)

    local tween = TweenService:Create(v86.Root, TweenInfo.new(0.28, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
        Position = UDim2.new(0.5, 0, -0.3, 0)
    })

    tween.Completed:Once(function() -- line: 522
        -- upvalues: v86 (copy)
        v86.Root:Destroy()
    end)
    tween:Play()
end

local function animate(p22, p23) -- line: 530
    -- upvalues: TweenService (copy), ShopUI (copy), RobuxPrices (copy), PackOffers (copy), amountText (copy)
    if not p22.Hovered then
        p22.Remaining -= p23
    end

    p22.Bar.Size = UDim2.fromScale(math.clamp(p22.Remaining / PackOffers.ShowTime, 0, 1), 1)

    local elapsed = os.clock()

    if p22.NextText <= elapsed then
        p22.NextText = elapsed + 0.5
        p22.Amount.Text = amountText(p22)

        local Price, Product = p22.Price, p22.Product

        Price.Text = ShopUI.FormatRobux(RobuxPrices.Get(Product.Id, Enum.InfoType.Product, Product.Price))
    end

    if p22.NextSweep <= elapsed then
        p22.NextSweep = elapsed + 2.8
        p22.SweepGradient.Offset = Vector2.new(-1, 0)
        TweenService:Create(p22.SweepGradient, TweenInfo.new(0.8, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {
            Offset = Vector2.new(1, 0)
        }):Play()
    end

    if not (p22.NextWiggle <= elapsed) or p22.Hovered then
        return
    end

    p22.NextWiggle = elapsed + 3.6

    local Body = p22.Body

    TweenService:Create(Body, TweenInfo.new(0.12, Enum.EasingStyle.Sine), {
        Rotation = 3
    }):Play()
    task.delay(0.12, function() -- line: 548
        -- upvalues: Body (copy), TweenService (copy)
        if Body.Parent then
            TweenService:Create(Body, TweenInfo.new(0.5, Enum.EasingStyle.Elastic), {
                Rotation = 0
            }):Play()
        end
    end)
end

local function step(p24) -- line: 554
    -- upvalues: DataController (copy), ClientState (copy), HUDController (copy), PackOffers (copy), Packs (copy), v2 (ref), v3 (ref), elapsed (ref), n1 (ref), t4 (ref), Busy (ref), elapsed2 (ref), n4 (ref), n6 (ref), stuckOffer (copy), moneyOffer (copy), stillUseful (copy), announcementShowing (copy), allowed (copy), close (ref), show (copy), animate (copy)
    local Busy2 = ClientState.Busy

    if Busy2 ~= Busy then
        if Busy == "Training" then
            local v96 = os.clock() - elapsed2

            n6 += v96

            if PackOffers.LongTraining <= v96 and not v3 and DataController:IsReady() and not (ClientState.TutorialActive or os.clock() - elapsed < PackOffers.QuietAtStart) and (DataController:Get("Throws") or 0) >= PackOffers.MinThrows then
                local v97 = stuckOffer()

                if v97 then
                    v97.Until = os.clock() + 30
                    v3 = v97
                end
            end
        end

        if Busy ~= nil and Busy2 == nil then
            local v98 = n1

            n1 = math.max(v98, os.clock() + 6.5)
        end

        Busy = Busy2
        elapsed2 = os.clock()
    end

    if v2 then
        if not v2.Test or Busy2 then
            if Busy2
                or ClientState.OfflineOpen
                or ClientState.TutorialActive
                or ClientState.ShopOpen
                or ClientState.SellOpen
                or ClientState.ExclusiveShopOpen
                or ClientState.IndexOpen
                or ClientState.AnimalsOpen
                or ClientState.ProtectedSellOpen
                or ClientState.InventoryOpen
                or ClientState.ReleaseShow
                or HUDController.IsGameplayHidden() then
                close("Interrupted")
            elseif ClientState.UpgradeWaiting then
                close("Yield")
            elseif not stillUseful(v2) then
                close("Done")
            else
                animate(v2, p24)

                if v2.Remaining <= 0 then
                    close("Timeout")
                end
            end
        else
            animate(v2, p24)

            if v2.Remaining <= 0 then
                close("Timeout")
            end
        end
    else
        if v3 and os.clock() > v3.Until then
            v3 = nil
        end

        if t4 and os.clock() > t4.Until then
            t4 = nil
        end

        local v100 = false
        local v101 = false
        local v102 = false
        local v103 = false

        if t4 then
            v100 = true
        else
            v103 = true
        end

        if v100 then
            if os.clock() >= n1 then
                v101 = true
            else
                v103 = true
            end
        end

        v100 = false

        if v101 then
            if DataController:IsReady() then
                v100 = true
            else
                v103 = true
            end
        end

        v101 = false

        if v100 then
            if ClientState.TutorialActive then
                v103 = true
            else
                v101 = true
            end
        end

        v100 = false

        local v104

        if v101 then
            local v105 = not ClientState.Busy

            if v105 then
                v100 = true
            else
                v104 = v105
                v103 = false
            end
        end

        v101 = false

        if v100 then
            local v106 = not ClientState.OfflineOpen

            if v106 then
                v101 = true
            else
                v104 = v106
                v103 = false
            end
        end

        v100 = false

        local v107

        if v101 then
            local ShopOpen = ClientState.ShopOpen

            if ShopOpen then
                v107 = ShopOpen
                v102 = true
            else
                v100 = true
            end
        end

        v101 = false

        if v100 then
            local SellOpen = ClientState.SellOpen

            if SellOpen then
                v107 = SellOpen
                v102 = true
            else
                v101 = true
            end
        end

        v100 = false

        if v101 then
            local ExclusiveShopOpen = ClientState.ExclusiveShopOpen

            if ExclusiveShopOpen then
                v107 = ExclusiveShopOpen
                v102 = true
            else
                v100 = true
            end
        end

        v101 = false

        if v100 then
            local IndexOpen = ClientState.IndexOpen

            if IndexOpen then
                v107 = IndexOpen
                v102 = true
            else
                v101 = true
            end
        end

        v100 = false

        if v101 then
            local AnimalsOpen = ClientState.AnimalsOpen

            if AnimalsOpen then
                v107 = AnimalsOpen
                v102 = true
            else
                v100 = true
            end
        end

        v101 = false

        if v100 then
            local ProtectedSellOpen = ClientState.ProtectedSellOpen

            if ProtectedSellOpen then
                v107 = ProtectedSellOpen
                v102 = true
            else
                v101 = true
            end
        end

        v100 = false

        if v101 then
            local InventoryOpen = ClientState.InventoryOpen

            if InventoryOpen then
                v107 = InventoryOpen
                v102 = true
            else
                v100 = true
            end
        end

        if v100 then
            v107 = ClientState.ReleaseShow
            v102 = true
        end

        v100 = false

        if v102 then
            local v108 = not v107

            if v108 then
                v100 = true
            else
                v104 = v108
                v103 = false
            end
        end

        v102 = false

        if v100 then
            local v109 = not announcementShowing()

            if v109 then
                v102 = true
            else
                v104 = v109
                v103 = false
            end
        end

        v100 = false

        if v102 then
            local v110 = not HUDController.IsGameplayHidden()

            if v110 then
                v100 = true
            else
                v104 = v110
                v103 = false
            end
        end

        v102 = false

        if v100 then
            local v111 = not ClientState.UpgradePopupShowing

            if v111 then
                v102 = true
            else
                v104 = v111
                v103 = false
            end
        end

        if v102 then
            v104 = not ClientState.UpgradeWaiting
            v103 = false
        end

        if not v103 and v104 then
            t4 = nil

            local v112 = Packs.Lucky and Packs.Lucky[1]

            if v112 then
                show({
                    Kind = "Lucky",
                    Key = v112,
                    Target = "LuckyAfterOne" .. os.clock()
                })

                return
            end
        end

        if not (os.clock() < n1) then
            local v113 = not not (DataController:IsReady() and not ClientState.TutorialActive and not (os.clock() - elapsed < PackOffers.QuietAtStart) and (DataController:Get("Throws") or 0) >= PackOffers.MinThrows)
            local v114 = false
            local v115 = false
            local v116 = false
            local v117 = false

            if v113 then
                v114 = true
            else
                v117 = true
            end

            local v118

            if v114 then
                local v119 = not ClientState.Busy

                if v119 then
                    v115 = true
                else
                    v118 = v119
                    v117 = false
                end
            end

            v114 = false

            if v115 then
                local v120 = not ClientState.OfflineOpen

                if v120 then
                    v114 = true
                else
                    v118 = v120
                    v117 = false
                end
            end

            v115 = false

            local v121

            if v114 then
                local ShopOpen = ClientState.ShopOpen

                if ShopOpen then
                    v121 = ShopOpen
                    v116 = true
                else
                    v115 = true
                end
            end

            v114 = false

            if v115 then
                local SellOpen = ClientState.SellOpen

                if SellOpen then
                    v121 = SellOpen
                    v116 = true
                else
                    v114 = true
                end
            end

            v115 = false

            if v114 then
                local ExclusiveShopOpen = ClientState.ExclusiveShopOpen

                if ExclusiveShopOpen then
                    v121 = ExclusiveShopOpen
                    v116 = true
                else
                    v115 = true
                end
            end

            v114 = false

            if v115 then
                local IndexOpen = ClientState.IndexOpen

                if IndexOpen then
                    v121 = IndexOpen
                    v116 = true
                else
                    v114 = true
                end
            end

            v115 = false

            if v114 then
                local AnimalsOpen = ClientState.AnimalsOpen

                if AnimalsOpen then
                    v121 = AnimalsOpen
                    v116 = true
                else
                    v115 = true
                end
            end

            v114 = false

            if v115 then
                local ProtectedSellOpen = ClientState.ProtectedSellOpen

                if ProtectedSellOpen then
                    v121 = ProtectedSellOpen
                    v116 = true
                else
                    v114 = true
                end
            end

            v115 = false

            if v114 then
                local InventoryOpen = ClientState.InventoryOpen

                if InventoryOpen then
                    v121 = InventoryOpen
                    v116 = true
                else
                    v115 = true
                end
            end

            if v115 then
                v121 = ClientState.ReleaseShow
                v116 = true
            end

            v115 = false

            if v116 then
                local v122 = not v121

                if v122 then
                    v115 = true
                else
                    v118 = v122
                    v117 = false
                end
            end

            v116 = false

            if v115 then
                local v123 = not announcementShowing()

                if v123 then
                    v116 = true
                else
                    v118 = v123
                    v117 = false
                end
            end

            v115 = false

            if v116 then
                local v124 = not HUDController.IsGameplayHidden()

                if v124 then
                    v115 = true
                else
                    v118 = v124
                    v117 = false
                end
            end

            v116 = false

            if v115 then
                local v125 = not ClientState.UpgradePopupShowing

                if v125 then
                    v116 = true
                else
                    v118 = v125
                    v117 = false
                end
            end

            if v116 then
                v118 = not ClientState.UpgradeWaiting
                v117 = false
            end

            if not v117 and v118 then
                if v3 then
                    local v126 = v3

                    if allowed(v126) and stillUseful(v126) then
                        v3 = nil
                        show(v126)

                        return
                    end
                end

                if os.clock() >= n4 then
                    n4 = os.clock() + 2

                    local v127 = moneyOffer()

                    if allowed(v127) then
                        show(v127)
                    end
                end
            end
        end
    end
end

local function onThrowFinished(p25) -- line: 622
    -- upvalues: DataController (copy), ClientState (copy), PackOffers (copy), v3 (ref), elapsed (ref), n5 (ref), stuckOffer (copy), shortOffer (copy)
    n5 += 1

    if type(p25) ~= "table" or not DataController:IsReady() or ClientState.TutorialActive or os.clock() - elapsed < PackOffers.QuietAtStart or not ((DataController:Get("Throws") or 0) >= PackOffers.MinThrows) then
        return
    end

    local v128 = shortOffer(p25) or stuckOffer()

    if v128 then
        v128.Until = os.clock() + 30
        v3 = v128
    end
end

function v1.IsShowing() -- line: 632
    -- upvalues: v2 (ref)
    return v2 ~= nil
end

function v1.Init() -- line: 636
    -- upvalues: RunService (copy), MonetizationConfig (copy), Remotes (copy), DataController (copy), ExclusiveShopController (copy), ThrowController (copy), LocalPlayer (copy), ScreenGui (ref), v2 (ref), elapsed (ref), n1 (ref), t4 (ref), refreshReach (copy), close (ref), show (copy), step (copy), onThrowFinished (copy)
    ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "PackOffer"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.IgnoreGuiInset = false
    ScreenGui.DisplayOrder = 144
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
    elapsed = os.clock()
    ThrowController.Finished:Connect(onThrowFinished)
    Remotes.Event("Throw_SuperGranted").OnClientEvent:Connect(function(p26) -- line: 647
        -- upvalues: n1 (ref), t4 (ref)
        if type(p26) ~= "table" or not p26.Single then
            return
        end

        t4 = {
            Until = os.clock() + 300
        }

        local v129 = n1

        n1 = math.max(v129, os.clock() + 6.5)
    end)
    task.spawn(function() -- line: 653
        -- upvalues: DataController (copy), refreshReach (copy)
        DataController:WaitForReady()
        DataController:Observe("Level", refreshReach)
        refreshReach()
    end)
    RunService.Heartbeat:Connect(step)

    if not RunService:IsStudio() then
        return
    end

    local BindableFunction = Instance.new("BindableFunction")

    BindableFunction.Name = "PackOfferTestHook"

    BindableFunction.OnInvoke = function(p27, p28) -- line: 663
        -- upvalues: MonetizationConfig (copy), ExclusiveShopController (copy), v2 (ref), close (ref), show (copy)
        local v131 = MonetizationConfig.PackKind(p28)

        if not v131 then
            return "unknown pack"
        end

        if p27 == "Offer" then
            if v2 then
                close("Done")
            end

            show({
                Line = 1e999,
                Test = true,
                Key = p28,
                Kind = v131,
                Target = "Test" .. os.clock()
            })

            return "shown"
        end

        if p27 == "Shop" then
            ExclusiveShopController.Open("PacksTitle", p28)

            return "opened"
        end

        if p27 ~= "CloseShop" then
            return "unknown action"
        end

        ExclusiveShopController.Close()

        return "closed"
    end

    BindableFunction.Parent = ScreenGui.Parent
end

return v1
