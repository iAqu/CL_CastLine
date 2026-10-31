-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UITheme = require(ReplicatedStorage.Config.UITheme)
local FoodsConfig = require(ReplicatedStorage.Config.FoodsConfig)
local ReleaseConfig = require(ReplicatedStorage.Config.ReleaseConfig)
local RarityConfig = require(ReplicatedStorage.Config.RarityConfig)
local AnimalUtil = require(ReplicatedStorage.Shared.AnimalUtil)
local NumberFormat = require(ReplicatedStorage.Shared.NumberFormat)
local Remotes = require(ReplicatedStorage.Shared.Remotes)
local Signal = require(ReplicatedStorage.Shared.Signal)
local Parent = script.Parent
local DataController = require(Parent.DataController)
local UIKit = require(Parent.UIKit)
local Sounds = require(Parent.Sounds)
local ClientState = require(Parent.ClientState)
local CameraRig = require(Parent.CameraRig)
local UIScaler = require(Parent.UIScaler)
local t1 = {
    Opened = Signal.new(),
    Closed = Signal.new()
}
local Colors = UITheme.Colors
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local v1, Main
local t2 = {}

t2[1] = nil

local FoodCard
local t3 = {}
local v2 = false
local v3, v4
local v5 = false

local function styleCard(p1, p2) -- line: 61
    -- upvalues: RarityConfig (copy), AnimalUtil (copy), UIKit (copy)
    local v6 = RarityConfig.Get(p2.Rarity)
    local UIGradient = p1:FindFirstChildOfClass("UIGradient")

    if UIGradient then
        UIGradient.Color = v6.Gradient
    end

    p1.NameLabel.Text = p2.Name
    p1.RarityLabel.Text = p2.Rarity
    p1.RarityLabel.TextColor3 = Color3.new(1, 1, 1)

    local MultiplierFrame = p1:FindFirstChild("MultiplierFrame")

    if MultiplierFrame then
        MultiplierFrame.MultiplierLabel.Text = "<font color=\"#8CFF3C\">Tier " .. p2.Tier .. "</font>"
    end

    local Icon = p1:FindFirstChild("Icon")

    if not Icon then
        return nil
    end

    local v7 = UIKit.Viewport({
        Rotate = true,
        Pitch = -0.4363323129985824,
        Padding = 1.02,
        Parent = p1,
        Size = Icon.Size,
        Position = Icon.Position,
        AnchorPoint = Icon.AnchorPoint,
        ZIndex = Icon.ZIndex
    })
    local v8 = AnimalUtil.GetFoodTemplate(p2.ModelName) and AnimalUtil.CreateFood(p2.ModelName)

    if v8 then
        v7:SetModel(v8)
    end

    Icon:Destroy()

    return v7
end

local function setRevealed(p3, p4) -- line: 88
    -- upvalues: AnimalUtil (copy)
    p3.Card.NameLabel.Text = p4 and p3.Food.Name or "???"

    local MultiplierFrame = p3.Card:FindFirstChild("MultiplierFrame")

    if MultiplierFrame then
        MultiplierFrame.Visible = p4
    end

    p3.Button.Visible = p4

    if p3.Viewport then
        local v9 = AnimalUtil.GetFoodTemplate(p3.Food.ModelName) and AnimalUtil.CreateFood(p3.Food.ModelName)

        p3.Viewport:SetModel(v9 or nil, not p4)
    end
end

local function refreshCard(p5) -- line: 100
    -- upvalues: NumberFormat (copy), DataController (copy), UIKit (copy), Colors (copy)
    local Food = p5.Food

    if p5.Cover then
        p5.Button.Label.Text = "SOON"
        UIKit.SetButtonColors(p5.Button, {
            Colors.GrayA,
            Colors.GrayB
        })
    else
        local v10 = DataController:GetPath("OwnedFoods." .. Food.Index) == true
        local v11 = DataController:Get("EquippedFood") == Food.Index
        local v12 = DataController:Get("Money") or 0
        local Button = p5.Button
        local Label = Button.Label

        if v11 then
            Label.Text = "EQUIPPED"
            UIKit.SetButtonColors(Button, {
                Colors.GrayA,
                Colors.GrayB
            })
        elseif v10 then
            Label.Text = "EQUIP"
            UIKit.SetButtonColors(Button, {
                Colors.GreenA,
                Colors.GreenB
            })
        else
            Label.Text = NumberFormat.Money(Food.Price)

            if Food.Price <= v12 then
                UIKit.SetButtonColors(Button, {
                    Colors.YellowA,
                    Colors.YellowB
                })
            else
                UIKit.SetButtonColors(Button, {
                    Colors.RedA,
                    Colors.RedB
                })
            end
        end

        local UIStroke = p5.Card:FindFirstChildOfClass("UIStroke")

        if UIStroke then
            UIStroke.Color = v11 and Color3.fromRGB(140, 255, 90) or Color3.new(0, 0, 0)
            UIStroke.Thickness = v11 and 5 or 3
        end
    end
end

local function refreshAll() -- line: 134
    -- upvalues: t3 (copy), refreshCard (copy)
    for _, v13 in ipairs(t3) do
        refreshCard(v13)
    end
end

local function topZ(p6) -- line: 144
    local ZIndex = p6.ZIndex

    for _, descendant in ipairs(p6:GetDescendants()) do
        if descendant:IsA("GuiObject") and ZIndex < descendant.ZIndex then
            ZIndex = descendant.ZIndex
        end
    end

    return ZIndex
end

local function updateCovers() -- line: 152
    -- upvalues: ReleaseConfig (copy), t3 (copy)
    for _, v14 in ipairs(t3) do
        if v14.Cover then
            local v15 = ReleaseConfig.TimeLeft(v14.Food.Release)

            v14.CoverTime.Text = v15 and ReleaseConfig.FormatTime(v15) or "SOON"
        end
    end
end

local function syncCovers() -- line: 164
    -- upvalues: FoodsConfig (copy), UIKit (copy), t3 (copy), setRevealed (copy), refreshCard (copy), topZ (copy), updateCovers (copy)
    local t4 = {}

    for _, v16 in ipairs(t3) do
        if FoodsConfig.IsLocked(v16.Food.Index) then
            table.insert(t4, v16)
        elseif v16.Cover then
            v16.Cover:Destroy()
            v16.Cover = nil
            v16.CoverTime = nil
            setRevealed(v16, true)
        end
    end

    local v17 = #t4

    for v18, v19 in ipairs(t4) do
        if not v19.Cover then
            local Card = v19.Card
            local v20 = topZ(Card) + 1
            local TextButton = Instance.new("TextButton")

            TextButton.Name = "ReleaseCover"
            TextButton.Text = ""
            TextButton.AutoButtonColor = false
            TextButton.BackgroundColor3 = Color3.new(0, 0, 0)
            TextButton.BackgroundTransparency = 0
            TextButton.BorderSizePixel = 0
            TextButton.AnchorPoint = Vector2.new(0.5, 0.5)
            TextButton.Position = UDim2.fromScale(0.5, 0.5)
            TextButton.Size = UDim2.new(1, 6, 1, 6)
            TextButton.ZIndex = v20
            TextButton.Parent = Card

            local UICorner = Card:FindFirstChildOfClass("UICorner")

            if UICorner then
                UICorner:Clone().Parent = TextButton
            end

            Instance.new("UIGradient").Parent = TextButton
            UIKit.Text({
                Name = "Lead",
                Text = "NEW MAP IN",
                Stroke = 3,
                Parent = TextButton,
                Size = UDim2.fromScale(0.84, 0.09),
                Position = UDim2.fromScale(0.5, 0.71),
                AnchorPoint = Vector2.new(0.5, 0.5),
                ZIndex = v20 + 1,
                Color = Color3.fromRGB(215, 205, 235)
            })
            v19.CoverTime = UIKit.Text({
                Name = "Time",
                Text = "",
                Stroke = 3,
                Parent = TextButton,
                Size = UDim2.fromScale(0.84, 0.14),
                Position = UDim2.fromScale(0.5, 0.83),
                AnchorPoint = Vector2.new(0.5, 0.5),
                ZIndex = v20 + 1
            })
            v19.Cover = TextButton
            setRevealed(v19, false)
        end

        local v21 = 0.45 + -0.30000000000000004 * (v18 - 1) / v17
        local v22 = 0.45 + -0.30000000000000004 * v18 / v17

        v19.Cover:FindFirstChildOfClass("UIGradient").Transparency = NumberSequence.new(v21, v22)
    end

    updateCovers()

    for _, v23 in ipairs(t3) do
        refreshCard(v23)
    end
end

local function buildCards() -- line: 211
    -- upvalues: FoodsConfig (copy), Remotes (copy), DataController (copy), UIKit (copy), Sounds (copy), CameraRig (copy), Colors (copy), v1 (ref), t2 (copy), FoodCard (ref), t3 (copy), styleCard (copy), syncCovers (copy)
    for i = 1, FoodsConfig.CountAll() do
        local v24 = FoodsConfig.GetAny(i)
        local clone = FoodCard:Clone()

        clone.Name = "Food" .. i
        clone.LayoutOrder = i
        clone.Visible = true

        local v25 = styleCard(clone, v24)
        local ActionButton = clone.ActionButton

        ActionButton.AutoButtonColor = false
        UIKit.AddJuice(ActionButton)

        local t5 = {
            Card = clone,
            Food = v24,
            Button = ActionButton,
            Viewport = v25
        }

        ActionButton.Activated:Connect(function() -- line: 224
            -- upvalues: i (copy), v24 (copy), clone (copy), ActionButton (copy), t5 (copy), Remotes (copy), DataController (copy), UIKit (copy), Sounds (copy), CameraRig (copy), Colors (copy), v1 (ref)
            if t5.Cover then
                return
            end

            local v26 = DataController:GetPath("OwnedFoods." .. v24.Index) == true
            local Ok

            if v26 then
                Ok = Remotes.Invoke("Shop_Equip", i).Ok
            else
                if Remotes.Invoke("Shop_Buy", i).Ok then
                    Sounds.Play("PurchaseSuccess")
                    UIKit.Punch(clone, 0.15, 0.5)
                    CameraRig.PunchFOV(4, 0.05, 0.35)
                    UIKit.Popup(v1, "Bought " .. v24.Name .. "!", {
                        Duration = 1.2,
                        Position = UDim2.fromScale(0.5, 0.3),
                        Size = UDim2.fromScale(0.4, 0.08),
                        Color = Colors.YellowA
                    })

                    return
                end

                Sounds.Play("PurchaseFail")
                UIKit.Punch(ActionButton, 0.12, 0.35)
            end

            if (not v26 or Ok) and v26 then
                Sounds.Play("Pop")
                UIKit.Punch(clone, 0.08, 0.4)
            end
        end)
        clone.Parent = t2[1]
        table.insert(t3, t5)
    end

    t2[1].AutomaticCanvasSize = Enum.AutomaticSize.None
    t2[1].ScrollingDirection = Enum.ScrollingDirection.X
    t2[1].ScrollBarThickness = 8

    local UIListLayout = t2[1]:FindFirstChildOfClass("UIListLayout")
    local UIPadding = t2[1]:FindFirstChildOfClass("UIPadding")

    local function fitCanvas() -- line: 255
        -- upvalues: UIListLayout (copy), UIPadding (copy), t2 (copy), t3 (copy)
        if not UIListLayout then
            return
        end

        local v30 = t3[1] and t3[1].Card
        local X = v30 and v30.AbsoluteSize.X or 0

        if X > 0 then
            local v32 = math.round(X * 0.07)

            UIListLayout.Padding = UDim.new(0, v32)

            if UIPadding then
                UIPadding.PaddingLeft = UDim.new(0, v32)
                UIPadding.PaddingRight = UDim.new(0, v32)
            end
        end

        local X2 = UIListLayout.AbsoluteContentSize.X

        if UIPadding then
            local X = t2[1].AbsoluteSize.X

            X2 += UIPadding.PaddingLeft.Scale * X + UIPadding.PaddingLeft.Offset + UIPadding.PaddingRight.Scale * X + UIPadding.PaddingRight.Offset
        end

        t2[1].CanvasSize = UDim2.new(0, X2 + 8, 0, 0)
    end

    if UIListLayout then
        UIListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(fitCanvas)
    end

    t2[1]:GetPropertyChangedSignal("AbsoluteSize"):Connect(fitCanvas)
    task.defer(fitCanvas)
    syncCovers()
end

function t1.Open(p7) -- line: 285
    -- upvalues: RunService (copy), DataController (copy), UIKit (copy), Sounds (copy), ClientState (copy), t1 (copy), v1 (ref), Main (ref), t3 (copy), v2 (ref), v3 (ref), refreshCard (copy)
    local v34 = true

    if v2 or ClientState.Busy or ClientState.OfflineOpen or ClientState.IndexOpen or ClientState.ExclusiveShopOpen then
    elseif v1 then
        if ClientState.AnimalsOpen then
            local _require = require
            local AnimalsPanel = script.Parent.AnimalsPanel
            local ok, result = pcall(_require, AnimalsPanel)

            if ok then
                result.Close()
            end
        end

        v34 = false
    end

    if v34 then
        return false
    end

    v2 = true
    ClientState.ShopOpen = true
    v1.Enabled = true
    UIKit.PopIn(Main, 0.35, 0.75)
    Sounds.Play("Slide")

    for _, v35 in ipairs(t3) do
        refreshCard(v35)
    end

    for v36, v37 in ipairs(t3) do
        local v38 = v37.Card:FindFirstChildOfClass("UIScale") or Instance.new("UIScale", v37.Card)

        v38.Scale = 0.7
        task.delay(math.min(v36, 8) * 0.03, function() -- line: 302
            -- upvalues: v38 (copy), UIKit (copy)
            UIKit.Tween(v38, {
                Scale = 1
            }, 0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
        end)
    end

    v3 = p7 or DataController:Get("EquippedFood") or 1

    local elapsed = os.clock()
    local connection

    connection = RunService.RenderStepped:Connect(function() -- line: 312
        -- upvalues: elapsed (copy), connection (ref), t1 (copy), v2 (ref), v3 (ref)
        if not v2 or os.clock() - elapsed > 0.9 then
            connection:Disconnect()
        else
            t1.CenterOn(v3)
        end
    end)
    t1.Opened:Fire()

    return true
end

function t1.Focus(p8) -- line: 325
    -- upvalues: UIKit (copy), Sounds (copy), t1 (copy), t2 (copy), v2 (ref), v3 (ref)
    v3 = p8

    if not v2 then
        return
    end

    t1.CenterOn(p8)
    task.delay(0.8, function() -- line: 329
        -- upvalues: p8 (copy), UIKit (copy), Sounds (copy), t1 (copy), t2 (copy), v2 (ref)
        local v41 = t2[1] and t2[1]:FindFirstChild("Food" .. p8)

        if not (v2 and v41) then
            return
        end

        t1.CenterOn(p8)
        UIKit.Punch(v41, 0.12, 0.5)
        Sounds.Play("Pop", {
            Volume = 0.35
        })
    end)
end

function t1.IsOpen() -- line: 339
    -- upvalues: v2 (ref)
    return v2
end

function t1.GetVisibleButton(p9) -- line: 345
    -- upvalues: t2 (copy), t3 (copy), v2 (ref)
    if not (v2 and t2[1]) then
        return nil
    end

    local v42 = t3[p9]

    if not v42 then
        return nil
    end

    local Card = v42.Card
    local v43 = Card.AbsolutePosition.X + Card.AbsoluteSize.X / 2
    local X = t2[1].AbsolutePosition.X

    return if not (v43 < X) and not (X + t2[1].AbsoluteWindowSize.X < v43) then v42.Button else nil
end

function t1.GetCloseButton() -- line: 357
    -- upvalues: Main (ref), v2 (ref)
    if v2 and Main then
        return Main.Panel.Header:FindFirstChild("CloseButton")
    end

    return nil
end

function t1.CenterOn(p10) -- line: 364
    -- upvalues: Main (ref), t2 (copy)
    local v45 = t2[1] and t2[1]:FindFirstChild("Food" .. p10)

    if not v45 then
        return
    end

    local UIScale = Main:FindFirstChildOfClass("UIScale")
    local v46, v47

    if UIScale and UIScale.Scale > 0.01 then
        local Scale = UIScale.Scale

        if Scale then
            v46 = Scale
            v47 = true
        else
            v47 = false
        end
    else
        v47 = false
    end

    if not v47 then
        v46 = 1
    end

    local v48 = t2[1].CanvasPosition.X + (v45.AbsolutePosition.X - t2[1].AbsolutePosition.X) / v46
    local v49 = t2[1].AbsoluteWindowSize.X / v46
    local v50 = v48 - (v49 - v45.AbsoluteSize.X / v46) / 2
    local v52 = math.max(0, t2[1].CanvasSize.X.Offset - v49)

    t2[1].CanvasPosition = Vector2.new(math.clamp(v50, 0, v52), 0)
end

function t1.Close() -- line: 377
    -- upvalues: UIKit (copy), Sounds (copy), ClientState (copy), t1 (copy), v1 (ref), Main (ref), v2 (ref), v5 (ref)
    if not v2 then
        return
    end

    v2 = false
    v5 = true
    ClientState.ShopOpen = false
    t1.Closed:Fire()
    Sounds.Play("Slide", {
        Volume = 0.2
    })
    UIKit.PopOut(Main, 0.2, 0.8).Completed:Once(function() -- line: 384
        -- upvalues: v1 (ref), Main (ref), v2 (ref)
        if not v2 then
            v1.Enabled = false
        end

        Main.Visible = true
    end)
end

function t1.BindCircle(p11) -- line: 390
    -- upvalues: t1 (copy), LocalPlayer (copy), v4 (ref), v5 (ref)
    v4 = p11
    p11.CanTouch = true
    p11.Touched:Connect(function(p12) -- line: 393
        -- upvalues: t1 (copy), LocalPlayer (copy), v5 (ref)
        local Character = LocalPlayer.Character

        if Character and p12:IsDescendantOf(Character) and not v5 then
            t1.Open()
        end
    end)
end

function t1.Init() -- line: 401
    -- upvalues: RunService (copy), ReleaseConfig (copy), DataController (copy), UIKit (copy), ClientState (copy), UIScaler (copy), t1 (copy), LocalPlayer (copy), PlayerGui (copy), v1 (ref), Main (ref), t2 (copy), FoodCard (ref), t3 (copy), v2 (ref), v4 (ref), v5 (ref), refreshCard (copy), refreshAll (copy), updateCovers (copy), syncCovers (copy), buildCards (copy)
    task.spawn(function() -- line: 405
        -- upvalues: RunService (copy), ReleaseConfig (copy), DataController (copy), UIKit (copy), UIScaler (copy), t1 (copy), PlayerGui (copy), v1 (ref), Main (ref), t2 (copy), FoodCard (ref), t3 (copy), v2 (ref), refreshCard (copy), refreshAll (copy), updateCovers (copy), syncCovers (copy), buildCards (copy)
        v1 = PlayerGui:WaitForChild("FoodShop", 30)

        if not v1 then
            warn("[ShopController] FoodShop gui missing")

            return
        end

        v1.Enabled = false
        Main = v1:WaitForChild("Main")
        UIScaler.FitWindow(Main)
        t2[1] = Main.Panel.Body.CardsScroll
        FoodCard = v1.Templates.FoodCard

        local CloseButton = Main.Panel.Header.CloseButton

        CloseButton.AutoButtonColor = false
        UIKit.AddJuice(CloseButton)
        CloseButton.Activated:Connect(t1.Close)
        buildCards()
        DataController:Observe("Money", function() -- line: 421
            -- upvalues: t3 (copy), v2 (ref), refreshCard (copy)
            if not v2 then
                return
            end

            for _, v54 in ipairs(t3) do
                refreshCard(v54)
            end
        end)
        DataController:Observe("EquippedFood", refreshAll)
        DataController:ObserveTable("OwnedFoods", refreshAll)
        ReleaseConfig.OnChanged(syncCovers)

        local n1 = 0

        RunService.Heartbeat:Connect(function() -- line: 428
            -- upvalues: n1 (ref), v2 (ref), updateCovers (copy)
            if v2 and not (os.clock() - n1 < 0.25) then
                n1 = os.clock()
                updateCovers()
            end
        end)
    end)
    RunService.Heartbeat:Connect(function() -- line: 437
        -- upvalues: ClientState (copy), t1 (copy), LocalPlayer (copy), v2 (ref), v4 (ref), v5 (ref)
        if not (v4 and (v2 or v5)) then
            return
        end

        local Character = LocalPlayer.Character
        local HumanoidRootPart = Character and Character:FindFirstChild("HumanoidRootPart")

        if not HumanoidRootPart then
            t1.Close()

            return
        end

        local Magnitude = (Vector3.new(HumanoidRootPart.Position.X, 0, HumanoidRootPart.Position.Z) - Vector3.new(v4.Position.X, 0, v4.Position.Z)).Magnitude

        if v2 then
            if Magnitude > 7 or ClientState.Busy then
                t1.Close()
            end
        elseif math.max(v4.Size.Y, v4.Size.Z) / 2 + 1.5 < Magnitude then
            v5 = false
        end
    end)
end

return t1
