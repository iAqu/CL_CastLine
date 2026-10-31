-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UITheme = require(ReplicatedStorage.Config.UITheme)
local FoodsConfig = require(ReplicatedStorage.Config.FoodsConfig)
local StandsConfig = require(ReplicatedStorage.Config.StandsConfig)
local RarityConfig = require(ReplicatedStorage.Config.RarityConfig)
local AnimalUtil = require(ReplicatedStorage.Shared.AnimalUtil)
local NumberFormat = require(ReplicatedStorage.Shared.NumberFormat)
local Boosts = require(ReplicatedStorage.Shared.Boosts)
local Parent = script.Parent
local DataController = require(Parent.DataController)
local UIKit = require(Parent.UIKit)
local Sounds = require(Parent.Sounds)
local ClientState = require(Parent.ClientState)
local HUDController = require(Parent.HUDController)
local ShopController = require(Parent.ShopController)
local TrainingController = require(Parent.TrainingController)
local PlotController = require(Parent.PlotController)
local t1 = {}
local Colors = UITheme.Colors
local LocalPlayer = Players.LocalPlayer
local v1
local t2 = {
    Food = {
        [2] = true
    },
    Stand = {
        true
    }
}
local v2 = os.clock() + 6
local v3 = nil
local Busy

local function bestOwnedFood() -- line: 80
    -- upvalues: FoodsConfig (copy), DataController (copy)
    local n1 = 0

    for i = 1, FoodsConfig.Count() do
        if DataController:GetPath("OwnedFoods." .. i) == true then
            n1 = i
        end
    end

    return n1
end

local function bestAffordableFood(p1) -- line: 90
    -- upvalues: FoodsConfig (copy), bestOwnedFood (copy)
    local v5 = bestOwnedFood()

    for i = FoodsConfig.Count(), v5 + 1, -1 do
        local v6 = FoodsConfig.Get(i)

        if v6.Price > 0 and v6.Price <= p1 then
            return v6
        end
    end

    return nil
end

local function nextStand() -- line: 99
    -- upvalues: StandsConfig (copy), DataController (copy)
    return StandsConfig.Get((DataController:Get("Stand") or 0) + 1)
end

local function pending() -- line: 104
    -- upvalues: StandsConfig (copy), DataController (copy), t2 (copy), bestAffordableFood (copy)
    local v7 = DataController:Get("Money") or 0
    local v8 = bestAffordableFood(v7)

    if v8 and not t2.Food[v8.Index] then
        return "Food", v8
    end

    local v9 = StandsConfig.Get((DataController:Get("Stand") or 0) + 1)

    if v9 and not t2.Stand[v9.Index] and v9.Price <= v7 then
        return "Stand", v9
    end

    return nil
end

local function windowOpen() -- line: 117
    -- upvalues: ClientState (copy)
    return ClientState.ShopOpen
        or ClientState.SellOpen
        or ClientState.ExclusiveShopOpen
        or ClientState.IndexOpen
        or ClientState.AnimalsOpen
        or ClientState.ReleaseShow
end

local function announcementShowing() -- line: 123
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

local function canShow() -- line: 132
    -- upvalues: DataController (copy), ClientState (copy), v2 (ref), announcementShowing (copy)
    if ClientState.TutorialActive or ClientState.OfflineOpen then
        return false
    end

    local Busy = ClientState.Busy

    if Busy and Busy ~= "Training"
        or ClientState.ShopOpen
        or ClientState.SellOpen
        or ClientState.ExclusiveShopOpen
        or ClientState.IndexOpen
        or ClientState.AnimalsOpen
        or ClientState.ReleaseShow
        or announcementShowing()
        or ClientState.PackOfferShowing
        or os.clock() < v2 then
        return false
    end

    return DataController:IsReady()
end

local function previewModel(p2, p3) -- line: 146
    -- upvalues: ReplicatedStorage (copy), AnimalUtil (copy)
    if p2 == "Food" then
        return AnimalUtil.CreateFood(p3.ModelName)
    end

    local PullUpStands = ReplicatedStorage:FindFirstChild("PullUpStands")

    PullUpStands = PullUpStands and (PullUpStands:FindFirstChild((tostring(p3.Index))) or PullUpStands:FindFirstChild("1"))

    return PullUpStands and PullUpStands:Clone() or nil
end

local UIScaler = require(script.Parent.UIScaler)

local function restingPosition() -- line: 158
    -- upvalues: UIScaler (copy)
    return UDim2.new(0.5, 0, 0, (math.round((UIScaler.Px(10)))))
end

local function hiddenPosition() -- line: 162
    return UDim2.new(0.5, 0, -0.32, 0)
end

local closePopup

local function onAction(p4, p5) -- line: 168
    -- upvalues: ClientState (copy), ShopController (copy), TrainingController (copy), PlotController (copy), closePopup (ref)
    closePopup("Action")
    task.spawn(function() -- line: 170
        -- upvalues: p4 (copy), p5 (copy), ClientState (copy), ShopController (copy), TrainingController (copy), PlotController (copy)
        if TrainingController.IsRunning() then
            TrainingController.Stop()

            local elapsed = os.clock()

            while TrainingController.IsRunning() and os.clock() - elapsed < 5 do
                task.wait()
            end

            task.wait(0.35)
        end

        if not ClientState.Busy then
            if p4 == "Food" then
                if PlotController.TeleportToShop() then
                    task.wait(0.1)

                    if not ShopController.IsOpen() then
                        ShopController.Open(p5.Index)
                    end

                    ShopController.Focus(p5.Index)
                end
            else
                PlotController.TeleportToStand()
            end
        end
    end)
end

local function build(p6, p7) -- line: 190
    -- upvalues: RarityConfig (copy), NumberFormat (copy), Boosts (copy), UIKit (copy), ClientState (copy), ShopController (copy), TrainingController (copy), PlotController (copy), Colors (copy), LocalPlayer (copy), v1 (ref), previewModel (copy), UIScaler (copy), closePopup (ref)
    local v11 = p6 == "Food"
    local v12 = UIScaler.TouchBoost()
    local v13 = UIKit.Frame({
        Name = "Popup",
        Transparency = 1,
        ZIndex = 10,
        Parent = v1,
        Size = UDim2.fromScale(0.62 * v12, 0.24 * v12),
        Position = UDim2.new(0.5, 0, -0.32, 0),
        AnchorPoint = Vector2.new(0.5, 0)
    })

    v13.SizeConstraint = Enum.SizeConstraint.RelativeYY

    local UIScale = Instance.new("UIScale")

    UIScale.Parent = v13
    UIKit.Shadow(v13, 6, 18)

    local v14 = UIKit.Frame({
        Name = "Body",
        Corner = 16,
        Stroke = 4,
        ZIndex = 11,
        Parent = v13,
        Color = Colors.Panel,
        StrokeColor = Colors.PanelStroke,
        Gradient = {
            Colors.PanelGradientA,
            Colors.PanelGradientB,
            90
        }
    })

    v14.ClipsDescendants = false

    local TextButton = Instance.new("TextButton")

    TextButton.Name = "InputSink"
    TextButton.Text = ""
    TextButton.AutoButtonColor = false
    TextButton.BackgroundTransparency = 1
    TextButton.Size = UDim2.fromScale(1, 1)
    TextButton.ZIndex = 11
    TextButton.Parent = v14

    local v15 = v11 and {
        Colors.HeaderA,
        Colors.HeaderB
    } or {
        Colors.BlueA,
        Colors.BlueB
    }
    local v16 = UIKit.Frame({
        Name = "Header",
        Corner = 16,
        ZIndex = 12,
        Parent = v14,
        Size = UDim2.fromScale(1, 0.27),
        Color = v15[1],
        Gradient = {
            v15[1],
            v15[2],
            0
        }
    })

    UIKit.Frame({
        Name = "Patch",
        ZIndex = 12,
        Parent = v16,
        Size = UDim2.fromScale(1, 0.5),
        Position = UDim2.fromScale(0, 1),
        AnchorPoint = Vector2.new(0, 1),
        Color = v15[1],
        Gradient = {
            v15[1],
            v15[2],
            0
        }
    })
    UIKit.Stripes(v16, 20, 0.88, 16)
    UIKit.Frame({
        Name = "Line",
        ZIndex = 14,
        Parent = v16,
        Size = UDim2.new(1, 0, 0, 4),
        Position = UDim2.fromScale(0, 1),
        AnchorPoint = Vector2.new(0, 1),
        Color = Colors.PanelStroke
    })
    UIKit.Text({
        Name = "Title",
        ZIndex = 15,
        Stroke = 4,
        Parent = v16,
        Text = v11 and "NEW FOOD UNLOCKED!" or "NEW EQUIPMENT!",
        Size = UDim2.fromScale(0.72, 0.68),
        Position = UDim2.fromScale(0.035, 0.5),
        AnchorPoint = Vector2.new(0, 0.5),
        XAlign = Enum.TextXAlignment.Left
    })
    UIKit.Button({
        Name = "Close",
        Text = "X",
        Ratio = 1,
        ZIndex = 16,
        Parent = v16,
        Size = UDim2.fromScale(0.09, 0.74),
        Position = UDim2.fromScale(0.975, 0.5),
        AnchorPoint = Vector2.new(1, 0.5),
        Colors = {
            Colors.RedA,
            Colors.RedB
        },
        OnClick = function() -- OnClick | line: 217
            -- upvalues: closePopup (ref)
            closePopup("Close")
        end
    })

    local Rarity = v11 and p7.Rarity or nil
    local v17 = UIKit.Card({
        Name = "Preview",
        Ratio = 1,
        ZIndex = 13,
        Parent = v14,
        Size = UDim2.fromScale(0.27, 0.62),
        Position = UDim2.fromScale(0.035, 0.32),
        Rarity = Rarity
    })

    if not v11 then
        local UIGradient = v17:FindFirstChildOfClass("UIGradient")

        if UIGradient then
            UIGradient.Color = ColorSequence.new(Colors.BlueA, Colors.BlueB)
        end
    end

    local v18 = UIKit.Frame({
        Name = "Glow",
        Transparency = 0.55,
        ZIndex = 14,
        Parent = v17,
        Size = UDim2.fromScale(0.9, 0.9),
        Position = UDim2.fromScale(0.5, 0.5),
        AnchorPoint = Vector2.new(0.5, 0.5),
        Color = Color3.new(1, 1, 1)
    })
    local UICorner = Instance.new("UICorner")

    UICorner.CornerRadius = UDim.new(0.5, 0)
    UICorner.Parent = v18

    local UIGradient = Instance.new("UIGradient")

    UIGradient.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0.1),
        NumberSequenceKeypoint.new(1, 1)
    })
    UIGradient.Parent = v18

    local v19 = UIKit.Viewport({
        Rotate = true,
        Pitch = -0.3839724354387525,
        ZIndex = 15,
        Parent = v17,
        Size = UDim2.fromScale(0.95, 0.95),
        Position = UDim2.fromScale(0.5, 0.5),
        AnchorPoint = Vector2.new(0.5, 0.5),
        Padding = v11 and 1.05 or 1.15
    })
    local v20 = previewModel(p6, p7)

    if v20 then
        v19:SetModel(v20)
    end

    UIKit.Text({
        Name = "Lead",
        Text = "YOU CAN NOW BUY",
        ZIndex = 14,
        Stroke = 2,
        Parent = v14,
        Size = UDim2.fromScale(0.62, 0.12),
        Position = UDim2.fromScale(0.34, 0.33),
        XAlign = Enum.TextXAlignment.Left,
        Color = Color3.fromRGB(205, 210, 225)
    })

    local v21 = UIKit.Text({
        Name = "ItemName",
        ZIndex = 14,
        Stroke = 4,
        Parent = v14,
        Text = string.upper(p7.Name),
        Size = UDim2.fromScale(0.62, 0.22),
        Position = UDim2.fromScale(0.34, 0.45),
        XAlign = Enum.TextXAlignment.Left
    })

    v21.TextColor3 = Color3.new(1, 1, 1)

    if v11 then
        UIKit.Gradient(v21, RarityConfig.Get(p7.Rarity).Gradient, 90)
    else
        UIKit.Gradient(v21, Color3.fromRGB(255, 255, 255), Color3.fromRGB(170, 225, 255), 90)
    end

    local v22 = NumberFormat.Money(p7.Price)
    local v23 = v11 and "<font color=\"#8CFF3C\">" .. v22 .. "</font>" or "<font color=\"#8CFF3C\">" .. v22 .. "</font>  " .. Boosts.XpText(p7.XpPerRep, LocalPlayer, " XP / rep")

    UIKit.Text({
        Name = "Price",
        ZIndex = 14,
        Stroke = 3,
        Rich = true,
        Parent = v14,
        Text = v23,
        Size = UDim2.fromScale(0.34, 0.15),
        Position = UDim2.fromScale(0.34, 0.69),
        XAlign = Enum.TextXAlignment.Left,
        Color = Colors.Xp
    })

    local v24 = UIKit.Button({
        Name = "Action",
        ZIndex = 15,
        Parent = v14,
        Text = v11 and "SHOP" or "UPGRADE",
        Size = UDim2.fromScale(0.27, 0.23),
        Position = UDim2.fromScale(0.965, 0.9),
        AnchorPoint = Vector2.new(1, 1),
        Colors = {
            Colors.GreenA,
            Colors.GreenB
        },
        Juice = {
            HoverScale = 1.08
        },
        OnClick = function() -- OnClick | line: 254
            -- upvalues: p6 (copy), p7 (copy), ClientState (copy), ShopController (copy), TrainingController (copy), PlotController (copy), closePopup (ref)
            closePopup("Action")
            task.spawn(function() -- line: 170
                -- upvalues: p6 (copy), p7 (copy), ClientState (copy), ShopController (copy), TrainingController (copy), PlotController (copy)
                if TrainingController.IsRunning() then
                    TrainingController.Stop()

                    local elapsed = os.clock()

                    while TrainingController.IsRunning() and os.clock() - elapsed < 5 do
                        task.wait()
                    end

                    task.wait(0.35)
                end

                if not ClientState.Busy then
                    if p6 == "Food" then
                        if PlotController.TeleportToShop() then
                            task.wait(0.1)

                            if not ShopController.IsOpen() then
                                ShopController.Open(p7.Index)
                            end

                            ShopController.Focus(p7.Index)
                        end
                    else
                        PlotController.TeleportToStand()
                    end
                end
            end)
        end
    })
    local v25 = UIKit.Frame({
        Name = "TimerBack",
        ZIndex = 14,
        Parent = v14,
        Size = UDim2.new(0.92, 0, 0, 5),
        Position = UDim2.new(0.5, 0, 1, -7),
        AnchorPoint = Vector2.new(0.5, 1),
        Color = Color3.fromRGB(28, 28, 34)
    })

    UIKit.Corner(v25, 3)

    local v26 = UIKit.Frame({
        Name = "Timer",
        ZIndex = 15,
        Parent = v25,
        Size = UDim2.fromScale(1, 1),
        Color = Colors.YellowA,
        Gradient = {
            Colors.YellowA,
            Colors.YellowB,
            0
        }
    })

    UIKit.Corner(v26, 3)

    local v27 = UIKit.Frame({
        Name = "Shine",
        Corner = 16,
        ZIndex = 17,
        Parent = v14,
        Color = Color3.new(1, 1, 1)
    })

    v27.BackgroundTransparency = 0

    local UIGradient2 = Instance.new("UIGradient")

    UIGradient2.Rotation = 25
    UIGradient2.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 1),
        NumberSequenceKeypoint.new(0.44, 1),
        NumberSequenceKeypoint.new(0.5, 0.75),
        NumberSequenceKeypoint.new(0.56, 1),
        NumberSequenceKeypoint.new(1, 1)
    })
    UIGradient2.Offset = Vector2.new(-1, 0)
    UIGradient2.Parent = v27

    local t6 = {
        Remaining = 7,
        Hovered = false,
        Kind = p6,
        Item = p7,
        Root = v13,
        Scale = UIScale,
        ShownAt = os.clock(),
        Bar = v26,
        Button = v24,
        Glow = v18,
        ShineGradient = UIGradient2
    }

    v14.MouseEnter:Connect(function() -- line: 277
        -- upvalues: t6 (copy)
        t6.Hovered = true
    end)
    v14.MouseLeave:Connect(function() -- line: 278
        -- upvalues: t6 (copy)
        t6.Hovered = false
    end)

    return t6
end

function closePopup(p8) -- line: 282
    -- upvalues: TweenService (copy), Sounds (copy), ClientState (copy), HUDController (copy), t2 (copy), v2 (ref), v3 (ref)
    local v28 = v3

    if not v28 or v28.Closing then
        return
    else
        v28.Closing = true
        v3 = nil
        ClientState.UpgradePopupShowing = false

        if p8 == "Interrupted" and os.clock() - v28.ShownAt < 2 then
            t2[v28.Kind][v28.Item.Index] = nil
        end
    end

    local v30 = v2

    v2 = math.max(v30, os.clock() + 1.5)

    if p8 ~= "Action" then
        Sounds.Play("Slide", {
            Volume = 0.2
        })
    end

    HUDController.SetToastOffset(0)

    local tween = TweenService:Create(v28.Root, TweenInfo.new(0.28, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
        Position = UDim2.new(0.5, 0, -0.32, 0)
    })

    tween.Completed:Once(function() -- line: 297
        -- upvalues: v28 (copy)
        v28.Root:Destroy()
    end)
    tween:Play()
end

local function show(p9, p10) -- line: 301
    -- upvalues: TweenService (copy), UIKit (copy), Sounds (copy), ClientState (copy), HUDController (copy), t2 (copy), v3 (ref), UIScaler (copy), build (copy)
    t2[p9][p10.Index] = true
    v3 = build(p9, p10)
    ClientState.UpgradePopupShowing = true

    local v32 = v3

    v32.Root.Position = UDim2.new(0.5, 0, -0.32, 0)
    TweenService:Create(v32.Root, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Position = UDim2.new(0.5, 0, 0, (math.round((UIScaler.Px(10)))))
    }):Play()

    local v35 = HUDController.GetGui()

    if v35 then
        local v36 = UIScaler.Px(10) + v32.Root.AbsoluteSize.Y + UIScaler.Px(8)

        HUDController.SetToastOffset((math.max(0, v36 - v35.AbsoluteSize.Y * 0.08)))
    end

    Sounds.Play("RewardShine", {
        Volume = 0.55,
        Pitch = 1.25
    })
    Sounds.Play("Pop", {
        Volume = 0.4,
        Delay = 0.15
    })
    task.delay(0.45, function() -- line: 317
        -- upvalues: v32 (copy), TweenService (copy), UIKit (copy), v3 (ref)
        if v3 == v32 then
            TweenService:Create(v32.ShineGradient, TweenInfo.new(0.7, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {
                Offset = Vector2.new(1, 0)
            }):Play()
            UIKit.Punch(v32.Button, 0.15, 0.5)
        end
    end)
end

local function step(p11) -- line: 329
    -- upvalues: DataController (copy), ClientState (copy), v2 (ref), v3 (ref), Busy (ref), bestOwnedFood (copy), pending (copy), canShow (copy), closePopup (ref), show (copy)
    local Busy2 = ClientState.Busy

    if Busy ~= Busy2 then
        if (Busy == "Throw" or Busy == "Hatch") and Busy2 == nil then
            local v38 = v2

            v2 = math.max(v38, os.clock() + 5)
        end

        Busy = Busy2
    end

    if v3 and (ClientState.TutorialActive or ClientState.OfflineOpen) then
        closePopup("Interrupted")
    elseif v3 then
        local v40 = if Busy2 then Busy2 == "Training" else nil

        if (not Busy2 or v40) and not (ClientState.ShopOpen
            or ClientState.SellOpen
            or ClientState.ExclusiveShopOpen
            or ClientState.IndexOpen
            or ClientState.AnimalsOpen
            or ClientState.ReleaseShow) then
            if (v3.Kind ~= "Food" or not (bestOwnedFood() >= v3.Item.Index)) and (v3.Kind ~= "Stand" or not ((DataController:Get("Stand") or 0) >= v3.Item.Index)) then
                if not v3.Hovered then
                    v3.Remaining -= p11
                end

                v3.Bar.Size = UDim2.fromScale(math.clamp(v3.Remaining / 7, 0, 1), 1)
                v3.Glow.Rotation += p11 * 40
                v3.Glow.BackgroundTransparency = math.sin(os.clock() * 3) * 0.12 + 0.5

                if v3.Remaining <= 0 then
                    closePopup("Timeout")
                end
            else
                closePopup("Done")
            end
        else
            closePopup("Interrupted")
        end
    elseif canShow() then
        ClientState.UpgradeWaiting = false

        local v44, v45 = pending()

        if v44 then
            show(v44, v45)
        end
    else
        ClientState.UpgradeWaiting = ClientState.PackOfferShowing and pending() ~= nil
    end
end

function t1.Init() -- line: 375
    -- upvalues: RunService (copy), UIKit (copy), ShopController (copy), v1 (ref), v2 (ref), step (copy)
    v1 = UIKit.ScreenGui("UpgradePopup", 145, false)
    ShopController.Closed:Connect(function() -- line: 377
        -- upvalues: v2 (ref)
        local v46 = v2

        v2 = math.max(v46, os.clock() + 1)
    end)
    RunService.Heartbeat:Connect(step)
end

return t1
