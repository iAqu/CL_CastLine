-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterGui = game:GetService("StarterGui")
local TweenService = game:GetService("TweenService")
local UITheme = require(ReplicatedStorage.Config.UITheme)
local GameConfig = require(ReplicatedStorage.Config.GameConfig)
local LevelConfig = require(ReplicatedStorage.Config.LevelConfig)
local MonetizationConfig = require(ReplicatedStorage.Config.MonetizationConfig)
local NumberFormat = require(ReplicatedStorage.Shared.NumberFormat)
local Remotes = require(ReplicatedStorage.Shared.Remotes)
local Signal = require(ReplicatedStorage.Shared.Signal)
local Parent = script.Parent
local DataController = require(Parent.DataController)
local UIKit = require(Parent.UIKit)
local Sounds = require(Parent.Sounds)
local UIScaler = require(Parent.UIScaler)
local t1 = {
    IndexRequested = Signal.new(),
    ShopRequested = Signal.new(),
    AnimalsRequested = Signal.new(),
    PowerSettingsRequested = Signal.new(),
    StatsReady = Signal.new(),
    TopOffsetChanged = Signal.new()
}
local Colors = UITheme.Colors
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local t2 = {
    ScreenFX = true,
    ThrowSequence = true,
    TrainingSequence = true,
    GiftRequest = true,
    EggHatch = true,
    UpgradePopup = true,
    Tutorial = true,
    Announcements = true,
    LuckyCatch = true,
    ReleaseShow = true
}
local _ = {
    Index = "rbxassetid://72945207836197",
    Shop = "rbxassetid://15985638648",
    Animals = "rbxassetid://105642295248032"
}
local v1 = Color3.fromRGB(34, 38, 46)
local v2, ValueLabel, ValueLabel2, v3, v4, v5, Container, t3, v6, v7
local n1 = 0

function t1.SetToastOffset(p1) -- line: 88
    -- upvalues: TweenService (copy), t1 (copy), v7 (ref), n1 (ref)
    n1 = p1 or 0
    t1.TopOffsetChanged:Fire(n1)

    if v7 then
        TweenService:Create(v7, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Position = UDim2.new(0.5, 0, 0.08, p1 or 0)
        }):Play()
    end
end

function t1.GetTopOffset() -- line: 95
    -- upvalues: n1 (ref)
    return n1
end

function t1.Notify(p2, p3, p4) -- line: 100
    -- upvalues: UITheme (copy), UIKit (copy), Sounds (copy), UIScaler (copy), Colors (copy), v7 (ref)
    if not v7 then
        return
    end

    local t4 = {
        Colors.RedA,
        Colors.RedB
    }

    if p3 == "Info" then
        t4 = {
            Colors.BlueA,
            Colors.BlueB
        }
    elseif p3 == "Success" then
        t4 = {
            Colors.GreenA,
            Colors.GreenB
        }
    end

    local v10 = UIKit.Frame({
        Stroke = 3,
        ZIndex = 20,
        Parent = v7,
        Size = UDim2.new(1, 0, 0, (math.round((UIScaler.Px(44))))),
        Color = t4[1],
        Corner = UITheme.Corner.Button,
        Gradient = {
            t4[1],
            t4[2],
            90
        }
    })

    UIKit.Text({
        ZIndex = 21,
        Parent = v10,
        Text = p2,
        Size = UDim2.fromScale(0.92, 0.7),
        Position = UDim2.fromScale(0.5, 0.5),
        AnchorPoint = Vector2.new(0.5, 0.5)
    })
    UIKit.PopIn(v10, 0.35, 0.4)

    if p3 == "Error" or p3 == nil then
        Sounds.Play("PurchaseFail", {
            Volume = 0.4
        })
    else
        Sounds.Play("Pop")
    end

    task.delay(p4 or 2.6, function() -- line: 108
        -- upvalues: v10 (copy), UIKit (copy)
        UIKit.PopOut(v10, 0.25).Completed:Once(function() -- line: 109
            -- upvalues: v10 (copy)
            v10:Destroy()
        end)
    end)
end

local function buildHud() -- line: 117
    -- upvalues: TweenService (copy), UITheme (copy), GameConfig (copy), UIKit (copy), UIScaler (copy), t1 (copy), Colors (copy), v1 (copy), v2 (ref), v3 (ref), v4 (ref), v5 (ref), v7 (ref)
    v2 = UIKit.ScreenGui("HUD", 3, false)

    local v11 = UIKit.Frame({
        Name = "LevelPill",
        Stroke = 4,
        ZIndex = 5,
        Parent = v2,
        Size = UDim2.fromScale(0.16, 0.075),
        Position = UDim2.fromScale(0.015, 0.02),
        Color = Colors.Panel,
        Corner = UITheme.Corner.Card,
        StrokeColor = Colors.PanelStroke,
        Gradient = {
            Colors.PanelGradientA,
            Colors.PanelGradientB,
            90
        }
    })
    local UIAspectRatioConstraint = Instance.new("UIAspectRatioConstraint")

    UIAspectRatioConstraint.AspectRatio = 4.2
    UIAspectRatioConstraint.Parent = v11
    v3 = UIKit.Text({
        Text = "Level 1",
        ZIndex = 6,
        Parent = v11,
        Size = UDim2.fromScale(0.62, 0.55),
        Position = UDim2.fromScale(0.05, 0.08),
        XAlign = Enum.TextXAlignment.Left
    })
    v5 = UIKit.Text({
        Text = "",
        ZIndex = 6,
        Stroke = 2,
        Parent = v11,
        Size = UDim2.fromScale(0.38, 0.45),
        Position = UDim2.fromScale(0.95, 0.12),
        AnchorPoint = Vector2.new(1, 0),
        XAlign = Enum.TextXAlignment.Right,
        Color = Colors.Money
    })

    local v12 = UIKit.Frame({
        Name = "XpBar",
        Corner = 6,
        Stroke = 2,
        ZIndex = 6,
        Parent = v11,
        Size = UDim2.fromScale(0.9, 0.22),
        Position = UDim2.fromScale(0.5, 0.86),
        AnchorPoint = Vector2.new(0.5, 1),
        Color = Colors.XpOuter
    })

    v4 = UIKit.Frame({
        Name = "Fill",
        Corner = 6,
        ZIndex = 7,
        Parent = v12,
        Size = UDim2.fromScale(0, 1),
        Color = Colors.XpTrack,
        Gradient = {
            Colors.BlueA,
            Colors.BlueB,
            90
        }
    })

    local v13 = v4

    v13.BackgroundColor3 = Colors.BlueA
    v11.Visible = GameConfig.HUD.ShowLevelPill

    local v14 = UIKit.Frame({
        Name = "SideButtons",
        Transparency = 1,
        ZIndex = 5,
        Parent = v2,
        Size = UDim2.fromScale(0.2, 0.33),
        Position = UDim2.fromScale(0.012, 0.47),
        AnchorPoint = Vector2.new(0, 0.5)
    })
    local UIListLayout = Instance.new("UIListLayout")

    UIListLayout.FillDirection = Enum.FillDirection.Vertical
    UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
    UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    UIListLayout.Padding = UDim.new(0.12, 0)
    UIListLayout.Parent = v14

    local function roundCorners(p5, p6) -- line: 143
        local UICorner = Instance.new("UICorner")

        UICorner.CornerRadius = UDim.new(p6, 0)
        UICorner.Parent = p5
    end

    local v15 = UIKit.Frame({
        Name = "RightSideButtons",
        Transparency = 1,
        ZIndex = 5,
        Parent = v2,
        Size = UDim2.fromScale(0.2, 0.33),
        Position = UDim2.fromScale(0.988, 0.47),
        AnchorPoint = Vector2.new(1, 0.5)
    })
    local clone = UIListLayout:Clone()

    clone.HorizontalAlignment = Enum.HorizontalAlignment.Right
    clone.Parent = v15

    local function sideTile(p7, p8, p9, p10, p11, p12, p13) -- line: 155
        -- upvalues: v14 (copy), TweenService (copy), UIKit (copy), v1 (copy)
        local TextButton = Instance.new("TextButton")

        TextButton.Name = p7
        TextButton.Text = ""
        TextButton.AutoButtonColor = false
        TextButton.Size = UDim2.fromScale(0.4, 0.4)
        TextButton.SizeConstraint = Enum.SizeConstraint.RelativeYY
        TextButton.BackgroundColor3 = v1
        TextButton.BackgroundTransparency = 0.12
        TextButton.BorderSizePixel = 0
        TextButton.LayoutOrder = p10
        TextButton.ZIndex = 5

        local UICorner = Instance.new("UICorner")

        UICorner.CornerRadius = UDim.new(0.2, 0)
        UICorner.Parent = TextButton

        local UIStroke = Instance.new("UIStroke")

        UIStroke.Thickness = 3
        UIStroke.Color = Color3.fromRGB(12, 14, 18)
        UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        UIStroke.Parent = TextButton
        UIKit.Gradient(TextButton, Color3.fromRGB(255, 255, 255), Color3.fromRGB(165, 165, 170), 90)

        local Frame = Instance.new("Frame")

        Frame.Name = "InnerBorder"
        Frame.Size = UDim2.fromScale(0.86, 0.86)
        Frame.Position = UDim2.fromScale(0.5, 0.5)
        Frame.AnchorPoint = Vector2.new(0.5, 0.5)
        Frame.BackgroundTransparency = 1
        Frame.ZIndex = 6

        local UICorner2 = Instance.new("UICorner")

        UICorner2.CornerRadius = UDim.new(0.16, 0)
        UICorner2.Parent = Frame

        local UIStroke2 = Instance.new("UIStroke")

        UIStroke2.Thickness = 2
        UIStroke2.Color = Color3.fromRGB(235, 240, 245)
        UIStroke2.Transparency = 0.5
        UIStroke2.Parent = Frame
        Frame.Parent = TextButton

        local Frame2 = Instance.new("Frame")

        Frame2.Name = "Shine"
        Frame2.Size = UDim2.fromScale(1, 1)
        Frame2.BackgroundColor3 = Color3.new(1, 1, 1)
        Frame2.BackgroundTransparency = 0
        Frame2.BorderSizePixel = 0
        Frame2.ZIndex = 6

        local UICorner3 = Instance.new("UICorner")

        UICorner3.CornerRadius = UDim.new(0.2, 0)
        UICorner3.Parent = Frame2

        local UIGradient = Instance.new("UIGradient")

        UIGradient.Rotation = 25
        UIGradient.Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 1),
            NumberSequenceKeypoint.new(0.42, 1),
            NumberSequenceKeypoint.new(0.5, 0.72),
            NumberSequenceKeypoint.new(0.58, 1),
            NumberSequenceKeypoint.new(1, 1)
        })
        UIGradient.Offset = Vector2.new(-1, 0)
        UIGradient.Parent = Frame2
        Frame2.Parent = TextButton

        local ImageLabel = Instance.new("ImageLabel")

        ImageLabel.Name = "Icon"
        ImageLabel.BackgroundTransparency = 1
        ImageLabel.Image = p9
        ImageLabel.ScaleType = Enum.ScaleType.Fit
        ImageLabel.Size = UDim2.fromScale(0.8, 0.8)
        ImageLabel.Position = UDim2.fromScale(0.5, 0.44)
        ImageLabel.AnchorPoint = Vector2.new(0.5, 0.5)
        ImageLabel.ZIndex = 7
        ImageLabel.Parent = TextButton

        local v16 = UIKit.Text({
            Name = "Label",
            ZIndex = 8,
            Stroke = 3,
            Parent = TextButton,
            Text = p8,
            Size = UDim2.fromScale(1.12, 0.34),
            Position = UDim2.fromScale(0.5, 0.96),
            AnchorPoint = Vector2.new(0.5, 0.5)
        })

        if p11 then
            v16.TextColor3 = Color3.new(1, 1, 1)
            UIKit.Gradient(v16, p11[1], p11[2], 90)
        end

        UIKit.AddJuice(TextButton, {
            HoverScale = 1.1,
            PressScale = 0.92
        })
        TextButton.MouseEnter:Connect(function() -- line: 231
            -- upvalues: UIStroke2 (copy), ImageLabel (copy), TweenService (copy)
            TweenService:Create(ImageLabel, TweenInfo.new(0.2, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                Rotation = -8,
                Size = UDim2.fromScale(0.88, 0.88)
            }):Play()
            TweenService:Create(UIStroke2, TweenInfo.new(0.15), {
                Transparency = 0.15
            }):Play()
        end)
        TextButton.MouseLeave:Connect(function() -- line: 235
            -- upvalues: UIStroke2 (copy), ImageLabel (copy), TweenService (copy)
            TweenService:Create(ImageLabel, TweenInfo.new(0.25, Enum.EasingStyle.Quad), {
                Rotation = 0,
                Size = UDim2.fromScale(0.8, 0.8)
            }):Play()
            TweenService:Create(UIStroke2, TweenInfo.new(0.2), {
                Transparency = 0.5
            }):Play()
        end)
        TextButton.Activated:Connect(function() -- line: 239
            -- upvalues: p12 (copy), ImageLabel (copy), TweenService (copy)
            ImageLabel.Position = UDim2.fromScale(0.5, 0.36)
            TweenService:Create(ImageLabel, TweenInfo.new(0.45, Enum.EasingStyle.Bounce, Enum.EasingDirection.Out), {
                Position = UDim2.fromScale(0.5, 0.44)
            }):Play()
            p12()
        end)
        TextButton.Parent = p13 or v14

        return TextButton, UIGradient
    end

    local v17 = sideTile("IndexButton", "Index", "rbxassetid://72945207836197", 1, nil, function() -- line: 249
        -- upvalues: t1 (copy)
        t1.IndexRequested:Fire()
    end)

    v17.Visible = GameConfig.HUD.ShowIndexButton
    t1.IndexButton = v17

    local v18, v19 = sideTile("ShopButton", "Shop", "rbxassetid://15985638648", 2, {
        Color3.fromRGB(255, 240, 120),
        Color3.fromRGB(255, 168, 28)
    }, function() -- line: 255
        -- upvalues: t1 (copy)
        t1.ShopRequested:Fire()
    end)

    t1.ShopButton = v18
    t1.AnimalsButton = sideTile("AnimalsButton", "Animals", "rbxassetid://105642295248032", 1, {
        Color3.fromRGB(255, 225, 160),
        Color3.fromRGB(255, 150, 60)
    }, function() -- line: 259
        -- upvalues: t1 (copy)
        t1.AnimalsRequested:Fire()
    end, v15)

    local v21 = UIScaler.TouchBoost()

    if v21 > 1 then
        for _, v22 in ipairs({ v14, v15 }) do
            local UIScale = Instance.new("UIScale")

            UIScale.Name = "TouchScale"
            UIScale.Scale = v21
            UIScale.Parent = v22
        end
    end

    t1.SideColumns = {
        {
            Frame = v14,
            Shown = v14.Position,
            Hidden = UDim2.new(-0.25, 0, v14.Position.Y.Scale, 0)
        },
        {
            Frame = v15,
            Shown = v15.Position,
            Hidden = UDim2.new(1.25, 0, v15.Position.Y.Scale, 0)
        }
    }
    task.spawn(function() -- line: 277
        -- upvalues: v18 (copy), v19 (copy), TweenService (copy)
        while v18.Parent do
            v19.Offset = Vector2.new(-1, 0)
            TweenService:Create(v19, TweenInfo.new(0.8, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {
                Offset = Vector2.new(1, 0)
            }):Play()
            task.wait(3.5)
        end
    end)
    v7 = UIKit.Frame({
        Name = "Toasts",
        Transparency = 1,
        ZIndex = 20,
        Parent = v2,
        Size = UDim2.fromScale(math.min(0.5, 0.3 * UIScaler.TouchBoost() ^ 2), 0.3),
        Position = UDim2.fromScale(0.5, 0.08),
        AnchorPoint = Vector2.new(0.5, 0)
    })

    local UIListLayout2 = Instance.new("UIListLayout")

    UIListLayout2.Padding = UDim.new(0, (math.round((UIScaler.Px(6)))))
    UIListLayout2.HorizontalAlignment = Enum.HorizontalAlignment.Center
    UIListLayout2.SortOrder = Enum.SortOrder.LayoutOrder
    UIListLayout2.Parent = v7
end

local v25 = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 20, 20)),
    ColorSequenceKeypoint.new(0.17, Color3.fromRGB(255, 138, 0)),
    ColorSequenceKeypoint.new(0.33, Color3.fromRGB(255, 230, 0)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(30, 224, 30)),
    ColorSequenceKeypoint.new(0.67, Color3.fromRGB(0, 178, 255)),
    ColorSequenceKeypoint.new(0.83, Color3.fromRGB(40, 70, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(163, 20, 255))
})
local clone, v26

local function buildSavedThrows(p14) -- line: 309
    -- upvalues: MonetizationConfig (copy), NumberFormat (copy), DataController (copy), UIKit (copy), Sounds (copy), v25 (copy), clone (ref)
    local ThrowPowerDisplay = p14:FindFirstChild("ThrowPowerDisplay")
    local SuperThrow = MonetizationConfig.SuperThrow

    if ThrowPowerDisplay and SuperThrow and not p14:FindFirstChild("LuckyThrowsDisplay") then
        local clone2 = ThrowPowerDisplay:Clone()

        for _, child in ipairs(clone2:GetChildren()) do
            if child.Name ~= "Icon" and child.Name ~= "ValueLabel" and not child:IsA("UIComponent") then
                child:Destroy()
            end
        end

        clone2.Name = "LuckyThrowsDisplay"
        clone2.LayoutOrder = 0
        clone2.Visible = false

        local Icon = clone2:FindFirstChild("Icon")

        if Icon and Icon:IsA("ImageLabel") then
            Icon.Image = SuperThrow.Icon
            Icon.ScaleType = Enum.ScaleType.Fit
            Icon.Size = UDim2.fromScale(1.4, 1.4)
        end

        local ValueLabel = clone2:FindFirstChild("ValueLabel")

        if not ValueLabel then
            clone2:Destroy()

            return
        end

        ValueLabel.TextColor3 = Color3.new(1, 1, 1)

        local UIGradient = Instance.new("UIGradient")

        UIGradient.Color = v25
        UIGradient.Rotation = 90
        UIGradient.Parent = ValueLabel
        clone2.Parent = p14
        clone = clone2

        local v27

        DataController:Observe("SuperThrows", function(p15) -- line: 339
            -- upvalues: clone2 (copy), ValueLabel (copy), v27 (ref), NumberFormat (copy), UIKit (copy), Sounds (copy)
            local v30 = math.max(0, (math.floor(tonumber(p15) or 0)))

            ValueLabel.Text = NumberFormat.Abbreviate(v30)

            if not (v30 > 0) or clone2.Visible then
                if v30 <= 0 then
                    clone2.Visible = false
                elseif v27 and v27 < v30 then
                    UIKit.Punch(clone2, 0.2, 0.5)
                    Sounds.Play("Pop")
                end
            else
                clone2.Visible = true

                if v27 ~= nil then
                    UIKit.PopIn(clone2, 0.45, 0.25)
                    Sounds.Play("Pop")
                end
            end

            v27 = v30
        end)
    end
end

function t1.PunchSavedThrows() -- line: 359
    -- upvalues: UIKit (copy), Sounds (copy), clone (ref)
    if clone and clone.Visible then
        UIKit.Punch(clone, 0.22, 0.5)
        Sounds.Play("Pop")
    end
end

local function hookStats() -- line: 366
    -- upvalues: TweenService (copy), LevelConfig (copy), NumberFormat (copy), DataController (copy), UIKit (copy), Sounds (copy), UIScaler (copy), t1 (copy), LocalPlayer (copy), PlayerGui (copy), ValueLabel (ref), ValueLabel2 (ref), v3 (ref), v4 (ref), v5 (ref), Container (ref), v6 (ref), v26 (ref), buildSavedThrows (copy)
    local v31 = PlayerGui:WaitForChild("StatsGui", 10)

    if not v31 then
        return
    end

    local Container2 = v31:WaitForChild("Container")

    Container = Container2

    if UIScaler.TouchBoost() > 1 and not Container2:FindFirstChild("TouchScale") then
        local UIScale = Instance.new("UIScale")

        UIScale.Name = "TouchScale"
        UIScale.Scale = UIScaler.TouchBoost()
        UIScale.Parent = Container2
    end

    ValueLabel = Container2.MoneyDisplay.ValueLabel
    ValueLabel2 = Container2.ThrowPowerDisplay.ValueLabel
    ValueLabel.Text = "$0"
    ValueLabel2.Text = "0"
    buildSavedThrows(Container2)
    DataController:Observe("Money", function(p16) -- line: 383
        -- upvalues: Container2 (copy), NumberFormat (copy), UIKit (copy), LocalPlayer (copy), ValueLabel (ref), v6 (ref)
        if v6 ~= nil then
            local v32 = p16 - v6

            v6 = p16
            UIKit.CountTo(ValueLabel, p16, 0.6, NumberFormat.Money)

            local v33 = (LocalPlayer:GetAttribute("QuietUntil") or 0) > workspace:GetServerTimeNow()

            if math.abs(v32) > 0 and not v33 and ((LocalPlayer:GetAttribute("IncomeRate") or 0) * 1.5 + 0.01 < v32 or v32 < 0) then
                UIKit.Punch(Container2.MoneyDisplay, 0.18, 0.4)
            end
        else
            v6 = p16
            ValueLabel.Text = NumberFormat.Money(p16)
        end
    end)

    local function refreshLevel() -- line: 403
        -- upvalues: TweenService (copy), LevelConfig (copy), DataController (copy), ValueLabel2 (ref), v3 (ref), v4 (ref)
        local v34 = DataController:Get("Level") or 1
        local v35 = DataController:Get("Xp") or 0
        local v36 = LevelConfig.XpForLevel(v34)

        v3.Text = "Level " .. v34

        local v38 = LevelConfig.ThrowPowerForLevel(v34)
        local v39 = LevelConfig.EffectiveThrowPower(v34, DataController:Get("ThrowPower"))

        ValueLabel2.Text = v39 < v38 and v39 .. "/" .. v38 or tostring(v38)
        TweenService:Create(v4, TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Size = UDim2.fromScale(math.clamp(v35 / v36, 0, 1), 1)
        }):Play()
    end

    local v43

    DataController:Observe("Level", function(p17) -- line: 415
        -- upvalues: Container2 (copy), refreshLevel (copy), v43 (ref), UIKit (copy), LocalPlayer (copy), v3 (ref)
        local v44 = (LocalPlayer:GetAttribute("QuietUntil") or 0) > workspace:GetServerTimeNow()

        if v43 and v43 < p17 and not v44 then
            UIKit.Punch(v3.Parent, 0.2, 0.5)
            UIKit.Punch(Container2.ThrowPowerDisplay, 0.2, 0.5)
        end

        v43 = p17
        refreshLevel()
    end)
    DataController:Observe("Xp", refreshLevel)
    DataController:Observe("ThrowPower", refreshLevel)

    local ThrowPowerDisplay = Container2.ThrowPowerDisplay
    local ImageButton = Instance.new("ImageButton")

    ImageButton.Name = "PowerCog"
    ImageButton.BackgroundTransparency = 1
    ImageButton.Image = "rbxassetid://111162659278869"
    ImageButton.ScaleType = Enum.ScaleType.Fit
    ImageButton.Size = UDim2.fromScale(0.62, 0.62)
    ImageButton.SizeConstraint = Enum.SizeConstraint.RelativeYY
    ImageButton.AnchorPoint = Vector2.new(0, 0.5)
    ImageButton.ZIndex = (ValueLabel2.ZIndex or 2) + 1
    ImageButton.Parent = ThrowPowerDisplay

    local UIScale = Instance.new("UIScale")

    UIScale.Parent = ImageButton

    local function placeCog() -- line: 441
        -- upvalues: ThrowPowerDisplay (copy), ImageButton (copy), ValueLabel2 (ref)
        local v45 = math.max(ThrowPowerDisplay.AbsoluteSize.X, 1)

        ImageButton.Position = UDim2.new(ValueLabel2.Position.X.Scale + (ValueLabel2.TextBounds.X + 8) / v45, 0, 0.5, 0)
    end

    ValueLabel2:GetPropertyChangedSignal("TextBounds"):Connect(placeCog)
    ThrowPowerDisplay:GetPropertyChangedSignal("AbsoluteSize"):Connect(placeCog)

    local v46 = math.max(ThrowPowerDisplay.AbsoluteSize.X, 1)

    ImageButton.Position = UDim2.new(ValueLabel2.Position.X.Scale + (ValueLabel2.TextBounds.X + 8) / v46, 0, 0.5, 0)
    ImageButton.MouseEnter:Connect(function() -- line: 448
        -- upvalues: ImageButton (copy), UIScale (copy), TweenService (copy), Sounds (copy)
        TweenService:Create(UIScale, TweenInfo.new(0.15, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
            Scale = 1.18
        }):Play()
        TweenService:Create(ImageButton, TweenInfo.new(0.35, Enum.EasingStyle.Quad), {
            Rotation = 60
        }):Play()
        Sounds.Play("ButtonHover")
    end)
    ImageButton.MouseLeave:Connect(function() -- line: 453
        -- upvalues: ImageButton (copy), UIScale (copy), TweenService (copy)
        TweenService:Create(UIScale, TweenInfo.new(0.15, Enum.EasingStyle.Quad), {
            Scale = 1
        }):Play()
        TweenService:Create(ImageButton, TweenInfo.new(0.35, Enum.EasingStyle.Quad), {
            Rotation = 0
        }):Play()
    end)
    ImageButton.MouseButton1Down:Connect(function() -- line: 457
        -- upvalues: UIScale (copy), TweenService (copy)
        TweenService:Create(UIScale, TweenInfo.new(0.08), {
            Scale = 0.9
        }):Play()
    end)
    ImageButton.Activated:Connect(function() -- line: 460
        -- upvalues: ImageButton (copy), UIScale (copy), TweenService (copy), Sounds (copy), t1 (copy)
        Sounds.Play("ButtonClick")
        TweenService:Create(UIScale, TweenInfo.new(0.2, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
            Scale = 1.1
        }):Play()
        ImageButton.Rotation = 0
        TweenService:Create(ImageButton, TweenInfo.new(0.45, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
            Rotation = 180
        }):Play()
        t1.PowerSettingsRequested:Fire()
    end)
    t1.PowerCog = ImageButton

    local function refreshIncome() -- line: 469
        -- upvalues: NumberFormat (copy), LocalPlayer (copy), v5 (ref)
        local v47 = LocalPlayer:GetAttribute("IncomeRate") or 0

        v5.Text = v47 > 0 and "+" .. NumberFormat.PerSecond(v47) or ""
    end

    LocalPlayer:GetAttributeChangedSignal("IncomeRate"):Connect(refreshIncome)

    local v49 = LocalPlayer:GetAttribute("IncomeRate") or 0

    v5.Text = v49 > 0 and "+" .. NumberFormat.PerSecond(v49) or ""

    local function boostBadge(p18, p19, p20, p21, p22, p23) -- line: 477
        -- upvalues: TweenService (copy), UIKit (copy), Sounds (copy), LocalPlayer (copy)
        local ValueLabel = p18:FindFirstChild("ValueLabel")
        local v51 = UIKit.Frame({
            Name = "BoostBadge",
            Corner = 8,
            Stroke = 3,
            Parent = p18,
            Size = UDim2.fromScale(1, 0.58),
            AnchorPoint = Vector2.new(0, 0.5),
            Color = p20,
            Gradient = { p20, p21, 90 },
            ZIndex = (ValueLabel and ValueLabel.ZIndex or 2) + 1
        })
        local UIAspectRatioConstraint = Instance.new("UIAspectRatioConstraint")

        UIAspectRatioConstraint.AspectRatio = #p19 > 3 and 2.3 or 1.45
        UIAspectRatioConstraint.Parent = v51
        v51.Rotation = -8
        UIKit.Text({
            Stroke = 2,
            Parent = v51,
            Text = p19,
            Size = UDim2.fromScale(0.84, 0.76),
            Position = UDim2.fromScale(0.5, 0.5),
            AnchorPoint = Vector2.new(0.5, 0.5),
            ZIndex = v51.ZIndex + 1
        })

        local function place() -- line: 486
            -- upvalues: p18 (copy), p23 (copy), ValueLabel (copy), v51 (copy)
            if not ValueLabel then
                return
            end

            local v52 = math.max(p18.AbsoluteSize.X, 1)
            local v53 = p23 and p23.AbsoluteSize.X + 8 or 0

            v51.Position = UDim2.new(ValueLabel.Position.X.Scale + (ValueLabel.TextBounds.X + 10 + v53) / v52, 0, 0.5, 0)
        end

        if ValueLabel then
            ValueLabel:GetPropertyChangedSignal("TextBounds"):Connect(place)
        end

        p18:GetPropertyChangedSignal("AbsoluteSize"):Connect(place)
        place()

        local function refresh(p24) -- line: 498
            -- upvalues: p22 (copy), v51 (copy), place (copy), UIKit (copy), Sounds (copy), LocalPlayer (copy)
            local v54 = (LocalPlayer:GetAttribute(p22) or 1) > 1

            if not v54 or v51.Visible then
                if not v54 then
                    v51.Visible = false
                end
            else
                v51.Visible = true
                place()

                if p24 then
                    UIKit.PopIn(v51, 0.5, 0.2)
                    Sounds.Play("Pop")
                end
            end
        end

        v51.Visible = false

        local v55 = (LocalPlayer:GetAttribute(p22) or 1) > 1

        if not v55 or v51.Visible then
            if not v55 then
                v51.Visible = false
            end
        else
            v51.Visible = true
            place()
        end

        LocalPlayer:GetAttributeChangedSignal(p22):Connect(function() -- line: 513
            -- upvalues: refresh (copy)
            refresh(true)
        end)
        task.spawn(function() -- line: 515
            -- upvalues: v51 (copy), TweenService (copy)
            while v51.Parent do
                task.wait(4)

                if v51.Visible then
                    TweenService:Create(v51, TweenInfo.new(0.12, Enum.EasingStyle.Sine), {
                        Rotation = 4
                    }):Play()
                    task.wait(0.12)
                    TweenService:Create(v51, TweenInfo.new(0.35, Enum.EasingStyle.Elastic), {
                        Rotation = -8
                    }):Play()
                end
            end
        end)

        return v51
    end

    boostBadge(Container2.MoneyDisplay, "x2", Color3.fromRGB(255, 226, 90), Color3.fromRGB(255, 150, 20), "CashMultiplier")
    boostBadge(Container2.ThrowPowerDisplay, "x2 XP", Color3.fromRGB(110, 215, 255), Color3.fromRGB(40, 130, 240), "XpMultiplier", ImageButton)
    v26(v31)
    t1.StatsReady:Fire(Container2)
end

local v56 = false

function t1.SetSideButtonsHidden(p25) -- line: 536
    -- upvalues: TweenService (copy), t1 (copy), v56 (ref)
    if p25 == v56 or not t1.SideColumns then
        return
    end

    v56 = p25

    for _, v57 in ipairs(t1.SideColumns) do
        local v58 = p25 and TweenInfo.new(0.22, Enum.EasingStyle.Quad, Enum.EasingDirection.In) or TweenInfo.new(0.35, Enum.EasingStyle.Back, Enum.EasingDirection.Out)

        TweenService:Create(v57.Frame, v58, {
            Position = p25 and v57.Hidden or v57.Shown
        }):Play()
    end
end

local n2 = 0

local function fitSideButtons(p26) -- line: 557
    -- upvalues: TweenService (copy), UIScaler (copy), t1 (copy), v2 (ref), Container (ref), clone (ref), v56 (ref), n2 (ref)
    local v59 = t1.SideColumns and t1.SideColumns[1]

    if not (v59 and v2 and Container and v2.Enabled and p26.Enabled) then
        return
    end

    local Frame = v59.Frame
    local ThrowPowerDisplay = Container:FindFirstChild("ThrowPowerDisplay")
    local MoneyDisplay = Container:FindFirstChild("MoneyDisplay")
    local v60 = 0

    if clone and clone.Visible and ThrowPowerDisplay and MoneyDisplay then
        local Y = ThrowPowerDisplay.AbsoluteSize.Y
        local v61 = MoneyDisplay.AbsolutePosition.Y - ThrowPowerDisplay.AbsolutePosition.Y
        local v62 = ThrowPowerDisplay.AbsolutePosition.Y - v61 - Y * 0.3999999999999999 / 2
        local Offset = Frame.Position.Y.Offset
        local v63, v64

        for _, v65 in ipairs({
                t1.IndexButton,
                t1.ShopButton
            }) do
            if v65 and v65.Visible then
                local v66 = v65.AbsolutePosition.Y - Offset
                local v67 = v66 + v65.AbsoluteSize.Y * 1.13

                v63 = v63 and math.min(v63, v66) or v66
                v64 = v64 and math.max(v64, v67) or v67
            end
        end

        if v64 and v61 > 0 then
            local v68 = v64 + UIScaler.Px(6) - v62
            local v69 = v63 - v2.AbsoluteSize.Y * 0.06

            v60 = math.clamp(math.ceil(v68), 0, (math.max(0, (math.floor(v69)))))
        end
    end

    if v60 ~= n2 then
        n2 = v60
        v59.Shown = UDim2.new(v59.Shown.X.Scale, v59.Shown.X.Offset, v59.Shown.Y.Scale, -v60)
        v59.Hidden = UDim2.new(v59.Hidden.X.Scale, v59.Hidden.X.Offset, v59.Hidden.Y.Scale, -v60)
        TweenService:Create(Frame, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Position = v56 and v59.Hidden or v59.Shown
        }):Play()
    end
end

v26 = function(p27) -- line: 598
    -- upvalues: t1 (copy), v2 (ref), Container (ref), clone (ref), fitSideButtons (copy)
    local v74 = false

    local function queue() -- line: 600
        -- upvalues: p27 (copy), v74 (ref), fitSideButtons (copy)
        if not v74 then
            v74 = true
            task.delay(0.1, function() -- line: 603
                -- upvalues: p27 (copy), v74 (ref), fitSideButtons (copy)
                v74 = false
                fitSideButtons(p27)
            end)
        end
    end

    if clone then
        clone:GetPropertyChangedSignal("Visible"):Connect(queue)
    end

    Container:GetPropertyChangedSignal("AbsoluteSize"):Connect(queue)
    Container:GetPropertyChangedSignal("AbsolutePosition"):Connect(queue)
    v2:GetPropertyChangedSignal("AbsoluteSize"):Connect(queue)
    v2:GetPropertyChangedSignal("Enabled"):Connect(queue)
    p27:GetPropertyChangedSignal("Enabled"):Connect(queue)

    if t1.IndexButton then
        t1.IndexButton:GetPropertyChangedSignal("Visible"):Connect(queue)
    end

    if v74 then
        return
    end

    v74 = true
    task.delay(0.1, function() -- line: 603
        -- upvalues: p27 (copy), v74 (ref), fitSideButtons (copy)
        v74 = false
        fitSideButtons(p27)
    end)
end

function t1.GetStatsContainer() -- line: 619
    -- upvalues: Container (ref)
    return Container
end

function t1.SetGameplayVisible(p28, p29) -- line: 629
    -- upvalues: StarterGui (copy), PlayerGui (copy), t2 (copy), t3 (ref)
    if p28 then
        if t3 then
            for v75 in pairs(t3) do
                if v75.Parent then
                    v75.Enabled = true
                end
            end

            t3 = nil

            local function v76() -- line: 651
                -- upvalues: StarterGui (copy)
                StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.PlayerList, true)
            end

            pcall(v76)
        end
    elseif not t3 then
        t3 = {}

        for _, child in ipairs(PlayerGui:GetChildren()) do
            if child:IsA("ScreenGui") and not t2[child.Name] and child.Enabled then
                t3[child] = true

                if not p29 or not p29[child.Name] then
                    child.Enabled = false
                end
            end
        end

        local function v77() -- line: 641
            -- upvalues: StarterGui (copy)
            StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.PlayerList, false)
        end

        pcall(v77)
    end
end

function t1.HideKept(p30) -- line: 659
    -- upvalues: t3 (ref)
    if not t3 then
        return
    end

    for v78 in pairs(t3) do
        if v78.Name == p30 and v78.Parent then
            v78.Enabled = false
        end
    end
end

function t1.IsGameplayHidden() -- line: 666
    -- upvalues: t3 (ref)
    return t3 ~= nil
end

function t1.GetGui() -- line: 670
    -- upvalues: v2 (ref)
    return v2
end

function t1.Init() -- line: 674
    -- upvalues: Remotes (copy), t1 (copy), buildHud (copy), hookStats (copy)
    buildHud()
    task.spawn(hookStats)
    Remotes.Event("Notify").OnClientEvent:Connect(function(p31, p32) -- line: 677
        -- upvalues: t1 (copy)
        t1.Notify(p31, p32)
    end)
end

return t1
