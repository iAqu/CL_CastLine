-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local GameConfig = require(ReplicatedStorage.Config.GameConfig)
local UITheme = require(ReplicatedStorage.Config.UITheme)
local NumberFormat = require(ReplicatedStorage.Shared.NumberFormat)
local Remotes = require(ReplicatedStorage.Shared.Remotes)
local Parent = script.Parent
local DataController = require(Parent.DataController)
local UIKit = require(Parent.UIKit)
local Sounds = require(Parent.Sounds)
local ClientState = require(Parent.ClientState)
local Movement = require(Parent.Movement)
local HUDController = require(Parent.HUDController)
local UIScaler = require(Parent.UIScaler)
local t1 = {}
local Colors = UITheme.Colors
local Offline = GameConfig.Offline
local LocalPlayer = Players.LocalPlayer
local Money = UITheme.Icons.Money

local function multiplier() -- line: 55
    -- upvalues: LocalPlayer (copy)
    return LocalPlayer:GetAttribute("CashMultiplier") or 1
end

local function pendingBase() -- line: 59
    -- upvalues: DataController (copy)
    return tonumber(DataController:GetPath("OfflinePending.Base")) or 0
end

local function pendingSeconds() -- line: 63
    -- upvalues: DataController (copy)
    return tonumber(DataController:GetPath("OfflinePending.Seconds")) or 0
end

local function formatAway(p1) -- line: 67
    local v2 = math.max(0, (math.floor(p1)))
    local v4 = math.floor(v2 / 3600)
    local v6 = math.floor(v2 % 3600 / 60)

    if v4 > 0 then
        return string.format("%dh %dm", v4, v6)
    end

    return string.format("%dm", (math.max(1, v6)))
end

local function closeOtherWindows() -- line: 75
    -- upvalues: Parent (copy)
    for _, v7 in ipairs({ "ShopController", "IndexController", "ExclusiveShopController", "AnimalsPanel", "SellShop", "Inventory" }) do
        local v8 = Parent:FindFirstChild(v7)

        if v8 then
            local _require = require
            local ok, result = pcall(_require, v8)

            if ok and type(result) == "table" and result.Close then
                local Close = result.Close

                pcall(Close)
            end
        end
    end
end

local t2
local v9 = false
local v10 = false
local n1 = 0
local n2 = 1e999

local function buildModal() -- line: 95
    -- upvalues: UITheme (copy), UIKit (copy), UIScaler (copy), t1 (copy), Colors (copy), Money (copy), t2 (ref)
    local v11 = UIKit.ScreenGui("OfflineEarnings", 190, true)

    v11.ScreenInsets = Enum.ScreenInsets.None
    v11.ClipToDeviceSafeArea = false
    v11.Enabled = false

    local TextButton = Instance.new("TextButton")

    TextButton.Name = "Dim"
    TextButton.Text = ""
    TextButton.AutoButtonColor = false
    TextButton.Selectable = false
    TextButton.Size = UDim2.fromScale(1, 1)
    TextButton.BackgroundColor3 = Color3.new(0, 0, 0)
    TextButton.BackgroundTransparency = 1
    TextButton.BorderSizePixel = 0
    TextButton.ZIndex = 1
    TextButton.Parent = v11
    UIScaler.CoverScreen(TextButton)

    local v12 = UIKit.Panel({
        Name = "WelcomeBack",
        Ratio = 1.32,
        Title = "Welcome Back!",
        HeaderHeight = 0.19,
        ZIndex = 5,
        Parent = v11,
        Size = UDim2.fromScale(0.5, 0.62)
    })

    v12.Title.Size = UDim2.fromScale(0.95, 0.7)
    v12.Title.Position = UDim2.fromScale(0.5, 0.5)
    v12.Title.AnchorPoint = Vector2.new(0.5, 0.5)
    v12.Title.TextXAlignment = Enum.TextXAlignment.Center

    local Content = v12.Content
    local ZIndex = Content.ZIndex

    UIKit.Text({
        Name = "Lead",
        Text = "While you were away your animals earned",
        Stroke = 2,
        Parent = Content,
        Size = UDim2.fromScale(0.9, 0.12),
        Position = UDim2.fromScale(0.5, 0.07),
        AnchorPoint = Vector2.new(0.5, 0),
        Color = Color3.fromRGB(205, 210, 225),
        ZIndex = ZIndex + 2
    })

    local v13 = UIKit.Frame({
        Name = "Glow",
        Transparency = 0,
        Parent = Content,
        Size = UDim2.fromScale(0.96, 0.3),
        Position = UDim2.fromScale(0.5, 0.38),
        AnchorPoint = Vector2.new(0.5, 0.5),
        Color = Color3.fromRGB(130, 255, 90),
        ZIndex = ZIndex + 1
    })
    local UICorner = Instance.new("UICorner")

    UICorner.CornerRadius = UDim.new(0.5, 0)
    UICorner.Parent = v13

    local UIGradient = Instance.new("UIGradient")

    UIGradient.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 1),
        NumberSequenceKeypoint.new(0.5, 0.86),
        NumberSequenceKeypoint.new(1, 1)
    })
    UIGradient.Parent = v13

    local v14 = UIKit.Text({
        Name = "Amount",
        Text = "$0",
        Stroke = 4,
        Parent = Content,
        Size = UDim2.fromScale(0.7, 0.26),
        Position = UDim2.fromScale(0.56, 0.38),
        AnchorPoint = Vector2.new(0.5, 0.5),
        Color = Color3.new(1, 1, 1),
        ZIndex = ZIndex + 3
    })

    UIKit.Gradient(v14, Color3.fromRGB(190, 255, 120), Color3.fromRGB(90, 210, 40), 90)

    local ImageLabel = Instance.new("ImageLabel")

    ImageLabel.Name = "MoneyIcon"
    ImageLabel.BackgroundTransparency = 1
    ImageLabel.Image = Money
    ImageLabel.ScaleType = Enum.ScaleType.Fit
    ImageLabel.Size = UDim2.fromScale(0.25, 0.25)
    ImageLabel.SizeConstraint = Enum.SizeConstraint.RelativeYY
    ImageLabel.AnchorPoint = Vector2.new(1, 0.5)
    ImageLabel.Position = UDim2.fromScale(0.2, 0.38)
    ImageLabel.ZIndex = ZIndex + 3
    ImageLabel.Parent = Content

    local v15 = UIKit.Text({
        Name = "Away",
        Text = "",
        Stroke = 2,
        Rich = true,
        Parent = Content,
        Size = UDim2.fromScale(0.9, 0.09),
        Position = UDim2.fromScale(0.5, 0.56),
        AnchorPoint = Vector2.new(0.5, 0),
        Color = Color3.fromRGB(205, 210, 225),
        ZIndex = ZIndex + 2
    })
    local v16 = UIKit.Button({
        Name = "Claim",
        Text = "CLAIM",
        TextStroke = 4,
        Parent = Content,
        Size = UDim2.fromScale(0.5, 0.22),
        Position = UDim2.fromScale(0.5, 0.93),
        AnchorPoint = Vector2.new(0.5, 1),
        Colors = {
            Colors.GreenA,
            Colors.GreenB
        },
        ZIndex = ZIndex + 4,
        Juice = {
            HoverScale = 1.07
        }
    })
    local v17 = UIKit.Frame({
        Name = "Shine",
        Parent = v16,
        Color = Color3.new(1, 1, 1),
        Corner = UITheme.Corner.Button,
        ZIndex = v16.ZIndex + 2
    })
    local UIGradient2 = Instance.new("UIGradient")

    UIGradient2.Rotation = 20
    UIGradient2.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 1),
        NumberSequenceKeypoint.new(0.42, 1),
        NumberSequenceKeypoint.new(0.5, 0.55),
        NumberSequenceKeypoint.new(0.58, 1),
        NumberSequenceKeypoint.new(1, 1)
    })
    UIGradient2.Offset = Vector2.new(-1, 0)
    UIGradient2.Parent = v17
    t2 = {
        Gui = v11,
        Dim = TextButton,
        Card = v12.Root,
        Content = Content,
        Amount = v14,
        Icon = ImageLabel,
        Away = v15,
        Button = v16,
        Glow = v13,
        Shine = UIGradient2
    }
    v16.Activated:Connect(function() -- line: 162
        -- upvalues: t1 (copy)
        t1.Claim()
    end)
end

local function placeIcon() -- line: 166
    -- upvalues: t2 (ref)
    if not t2 then
        return
    end

    local Amount, Icon, Content = t2.Amount, t2.Icon, t2.Content
    local v18 = math.max(Content.AbsoluteSize.X, 1)
    local v19 = Amount.AbsolutePosition.X + Amount.AbsoluteSize.X / 2 - Amount.TextBounds.X / 2

    Icon.Position = UDim2.new((v19 - Content.AbsolutePosition.X - 6) / v18, 0, 0.38, 0)
end

local function refreshTexts(p2) -- line: 174
    -- upvalues: NumberFormat (copy), DataController (copy), UIKit (copy), Offline (copy), LocalPlayer (copy), formatAway (copy), t2 (ref), n1 (ref)
    if not t2 then
        return
    end

    local v20 = (tonumber(DataController:GetPath("OfflinePending.Base")) or 0) * (LocalPlayer:GetAttribute("CashMultiplier") or 1)

    if p2 then
        UIKit.CountTo(t2.Amount, 0, 0, NumberFormat.Money)
        UIKit.CountTo(t2.Amount, v20, 1.1, NumberFormat.Money)
    elseif math.abs(v20 - n1) > 1E-06 then
        UIKit.CountTo(t2.Amount, v20, 0.4, NumberFormat.Money)
    end

    n1 = v20

    local v22 = "Away for " .. formatAway(tonumber(DataController:GetPath("OfflinePending.Seconds")) or 0)

    if (tonumber(DataController:GetPath("OfflinePending.Seconds")) or 0) >= Offline.MaxHours * 3600 then
        v22 ..= " (max " .. Offline.MaxHours .. "h)"
    end

    if (LocalPlayer:GetAttribute("CashMultiplier") or 1) > 1 then
        v22 ..= "   <font color=\"#FFD84A\">x" .. (LocalPlayer:GetAttribute("CashMultiplier") or 1) .. " Cash!</font>"
    end

    t2.Away.Text = v22
end

local function showModal() -- line: 194
    -- upvalues: TweenService (copy), UIKit (copy), Sounds (copy), ClientState (copy), Movement (copy), closeOtherWindows (copy), t2 (ref), v9 (ref), v10 (ref), buildModal (copy), refreshTexts (copy)
    if v9 then
        return
    end

    if not t2 then
        buildModal()
    end

    v9 = true
    v10 = false
    ClientState.OfflineOpen = true
    closeOtherWindows()
    Movement.Lock()
    t2.Gui.Enabled = true
    t2.Button.Label.Text = "CLAIM"
    t2.Dim.BackgroundTransparency = 1
    TweenService:Create(t2.Dim, TweenInfo.new(0.35), {
        BackgroundTransparency = 0.45
    }):Play()
    UIKit.PopIn(t2.Card, 0.5, 0.55)
    Sounds.Play("RewardShine", {
        Volume = 0.6
    })
    Sounds.Play("Pop", {
        Volume = 0.5,
        Delay = 0.12
    })
    refreshTexts(true)
end

local function coinBurst() -- line: 214
    -- upvalues: TweenService (copy), UIKit (copy), HUDController (copy), Money (copy), t2 (ref)
    local v23 = t2 and t2.Gui
    local v24 = HUDController.GetStatsContainer()
    local MoneyDisplay = v24 and v24:FindFirstChild("MoneyDisplay")

    if not v23 or not MoneyDisplay then
        return
    end

    local v25 = MoneyDisplay:FindFirstChild("Icon") or MoneyDisplay
    local AbsolutePosition = v23.AbsolutePosition
    local v26 = t2.Button.AbsolutePosition + t2.Button.AbsoluteSize / 2 - AbsolutePosition
    local v27 = v25.AbsolutePosition + v25.AbsoluteSize / 2 - AbsolutePosition
    local v29 = math.max(18, v23.AbsoluteSize.Y * 0.055)

    for i = 1, 12 do
        local ImageLabel = Instance.new("ImageLabel")

        ImageLabel.BackgroundTransparency = 1
        ImageLabel.Image = Money
        ImageLabel.ScaleType = Enum.ScaleType.Fit
        ImageLabel.Size = UDim2.fromOffset(v29, v29)
        ImageLabel.AnchorPoint = Vector2.new(0.5, 0.5)
        ImageLabel.Position = UDim2.fromOffset(v26.X, v26.Y)
        ImageLabel.ZIndex = 50
        ImageLabel.Parent = v23

        local v30 = v26 + Vector2.new(math.random(-90, 90), math.random(-70, 20)) * (v29 / 30)
        local tween = TweenService:Create(ImageLabel, TweenInfo.new(0.22, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Position = UDim2.fromOffset(v30.X, v30.Y)
        })

        task.delay((i - 1) * 0.035, function() -- line: 237
            -- upvalues: v27 (copy), v29 (copy), ImageLabel (copy), tween (copy), i (copy), MoneyDisplay (copy), TweenService (copy), UIKit (copy)
            tween:Play()
            tween.Completed:Wait()

            local tween2 = TweenService:Create(ImageLabel, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
                Position = UDim2.fromOffset(v27.X, v27.Y),
                Size = UDim2.fromOffset(v29 * 0.6, v29 * 0.6)
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

local function hideModal(p3) -- line: 249
    -- upvalues: TweenService (copy), UIKit (copy), ClientState (copy), Movement (copy), t1 (copy), Offline (copy), t2 (ref), v9 (ref), coinBurst (copy)
    if not v9 then
        return
    end

    v9 = false

    local Gui = t2.Gui

    TweenService:Create(t2.Dim, TweenInfo.new(0.3), {
        BackgroundTransparency = 1
    }):Play()
    UIKit.PopOut(t2.Card, 0.22, 0.75)

    if p3 then
        coinBurst()
    end

    ClientState.OfflineOpen = false
    Movement.Unlock()
    t1.ScheduleReminder(Offline.ReminderFirst)
    task.delay(p3 and 1.3 or 0.35, function() -- line: 259
        -- upvalues: Gui (copy), v9 (ref)
        if not v9 then
            Gui.Enabled = false
        end
    end)
end

function t1.Claim() -- line: 264
    -- upvalues: Remotes (copy), Sounds (copy), t2 (ref), v9 (ref), v10 (ref), hideModal (copy)
    if not v9 or v10 then
        return
    end

    v10 = true
    t2.Button.Label.Text = "..."

    local Offline_Claim = Remotes.Invoke("Offline_Claim")

    if Offline_Claim.Ok then
        Sounds.Play("MoneyReward")
        Sounds.Play("CoinBurst", {
            Volume = 0.6
        })
        hideModal(true)
    elseif Offline_Claim.Reason == "Nothing" then
        hideModal(false)
    else
        Sounds.Play("PurchaseFail", {
            Volume = 0.4
        })
        task.wait(0.8)
        v10 = false

        if v9 then
            t2.Button.Label.Text = "CLAIM"
        end
    end
end

function t1.IsOpen() -- line: 284
    -- upvalues: v9 (ref)
    return v9
end

local v32, v33, UIScale
local n3 = 0
local v34, v35
local v36 = string.format("DON'T FORGET TO <font color=\"%s\">LIKE</font> THE GAME 👍", "#8CFF3C")
local v37
local v38 = false

function t1.ScheduleReminder(p4) -- line: 302
    -- upvalues: v34 (ref)
    v34 = os.clock() + p4
end

local function reminderAmount() -- line: 306
    -- upvalues: Offline (copy), LocalPlayer (copy)
    return (LocalPlayer:GetAttribute("IncomeRate") or 0) * Offline.ReminderHours * Offline.MinutesPerHour * 60
end

local function bigWindowOpen() -- line: 312
    -- upvalues: ClientState (copy)
    return ClientState.ShopOpen or ClientState.SellOpen or ClientState.IndexOpen or ClientState.ExclusiveShopOpen or ClientState.AnimalsOpen
end

local function canRemind() -- line: 316
    -- upvalues: ClientState (copy), HUDController (copy), Offline (copy), LocalPlayer (copy)
    local v39 = not ClientState.Busy
    local ShopOpen, v40

    if v39 then
        local v41 = not ClientState.TutorialActive

        if v41 then
            local v42 = not ClientState.OfflineOpen

            if v42 then
                ShopOpen = ClientState.ShopOpen or ClientState.SellOpen or ClientState.IndexOpen or ClientState.ExclusiveShopOpen or ClientState.AnimalsOpen
                v40 = not ShopOpen and not HUDController.IsGameplayHidden() and (LocalPlayer:GetAttribute("IncomeRate") or 0) * Offline.ReminderHours * Offline.MinutesPerHour * 60 > 0
            else
                v40 = v42
            end
        else
            v40 = v41
        end
    else
        v40 = v39
    end

    return v40
end

local function placeReminder(p5) -- line: 321
    -- upvalues: TweenService (copy), v32 (ref), v33 (ref)
    if not v33 then
        return
    end

    local Y = v32.AbsoluteSize.Y
    local v43, v44

    if p5 and p5 > 0 then
        local v45 = p5 + Y * 0.068

        if v45 then
            v43 = v45
            v44 = true
        else
            v44 = false
        end
    else
        v44 = false
    end

    if not v44 then
        v43 = 0
    end

    TweenService:Create(v33, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Position = UDim2.new(0.5, 0, 0.012, v43)
    }):Play()
end

local function buildReminder() -- line: 329
    -- upvalues: UIKit (copy), HUDController (copy), UIScaler (copy), v32 (ref), v33 (ref), UIScale (ref), placeReminder (copy)
    v32 = UIKit.ScreenGui("OfflineReminder", 144, false)

    local v46 = UIScaler.TouchBoost()

    v33 = UIKit.Text({
        Name = "Reminder",
        Text = "",
        Rich = true,
        Stroke = 3,
        ZIndex = 5,
        Parent = v32,
        Size = UDim2.fromScale(math.min(0.9, 0.62 * v46), 0.062 * v46),
        Position = UDim2.fromScale(0.5, 0.012),
        AnchorPoint = Vector2.new(0.5, 0)
    })
    v33.Visible = false
    UIScale = Instance.new("UIScale")
    UIScale.Parent = v33
    HUDController.TopOffsetChanged:Connect(placeReminder)
end

local function popReminder(p6) -- line: 340
    -- upvalues: TweenService (copy), Sounds (copy), HUDController (copy), Offline (copy), v33 (ref), UIScale (ref), v35 (ref), placeReminder (copy)
    v33.Text = p6
    v33.TextTransparency = 0

    local TextStroke = v33:FindFirstChild("TextStroke")

    if TextStroke then
        TextStroke.Transparency = 0
    end

    placeReminder(HUDController.GetTopOffset())
    v33.Visible = true
    UIScale.Scale = 0.5
    TweenService:Create(UIScale, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Scale = 1
    }):Play()
    Sounds.Play("Pop", {
        Volume = 0.35
    })
    v35 = os.clock() + Offline.ReminderShowTime
end

local function showReminder() -- line: 353
    -- upvalues: NumberFormat (copy), Offline (copy), LocalPlayer (copy), n3 (ref), v34 (ref), v37 (ref), v38 (ref), popReminder (copy)
    popReminder(string.format("Your animals earn <font color=\"%s\">%s</font> offline! 🤑", "#8CFF3C", NumberFormat.Money((LocalPlayer:GetAttribute("IncomeRate") or 0) * Offline.ReminderHours * Offline.MinutesPerHour * 60)))
    n3 += 1

    local v48 = n3
    local ReminderLater = v48 >= Offline.ReminderSlowAfter and Offline.ReminderLater or Offline.ReminderInterval

    v34 = os.clock() + ReminderLater

    if n3 == 2 and not v38 then
        v37 = os.clock() + ReminderLater / 2
    end
end

local function showLike() -- line: 363
    -- upvalues: Offline (copy), v34 (ref), v36 (copy), v37 (ref), v38 (ref), popReminder (copy)
    v38 = true
    v37 = nil
    popReminder(v36)
    v34 = math.max(v34 or 0, os.clock() + Offline.ReminderInterval / 2)
end

local function hideReminder(p7) -- line: 371
    -- upvalues: TweenService (copy), v33 (ref), v35 (ref)
    v35 = nil

    if v33.Visible then
        local v51 = if p7 then 0.12 else 0.4

        TweenService:Create(v33, TweenInfo.new(v51), {
            TextTransparency = 1
        }):Play()

        local TextStroke = v33:FindFirstChild("TextStroke")

        if TextStroke then
            TweenService:Create(TextStroke, TweenInfo.new(v51), {
                Transparency = 1
            }):Play()
        end

        task.delay(v51, function() -- line: 378
            -- upvalues: v33 (ref), v35 (ref)
            if not v35 then
                v33.Visible = false
            end
        end)
    end
end

local function step() -- line: 387
    -- upvalues: DataController (copy), ClientState (copy), HUDController (copy), Offline (copy), LocalPlayer (copy), t2 (ref), v9 (ref), n2 (ref), placeIcon (copy), showModal (copy), v34 (ref), v35 (ref), v36 (copy), v37 (ref), v38 (ref), popReminder (copy), showReminder (copy), hideReminder (copy)
    if not DataController:IsReady() then
        return
    end

    local elapsed = os.clock()

    if not v9 and (tonumber(DataController:GetPath("OfflinePending.Base")) or 0) > 0 and n2 <= elapsed and not ClientState.Busy and LocalPlayer.Character then
        showModal()
    end

    if v9 then
        placeIcon()
        t2.Glow.BackgroundTransparency = math.sin(os.clock() * 2.4) * 0.25 + 0.25

        if v35 then
            hideReminder(true)
        end
    elseif v35 then
        if ClientState.Busy or ClientState.OfflineOpen then
            hideReminder(true)
        elseif v35 <= elapsed then
            hideReminder(false)
        end
    else
        if v37 and v37 <= elapsed then
            local v53 = not ClientState.Busy

            if v53 then
                v53 = not ClientState.TutorialActive

                if v53 then
                    v53 = not ClientState.OfflineOpen

                    if v53 then
                        local ShopOpen = ClientState.ShopOpen

                        if ShopOpen then
                            v53 = not ShopOpen
                        else
                            ShopOpen = ClientState.SellOpen

                            if ShopOpen then
                                v53 = not ShopOpen
                            else
                                ShopOpen = ClientState.IndexOpen

                                if ShopOpen then
                                    v53 = not ShopOpen
                                else
                                    ShopOpen = ClientState.ExclusiveShopOpen
                                    v53 = if ShopOpen then not ShopOpen else not ClientState.AnimalsOpen and not HUDController.IsGameplayHidden() and (LocalPlayer:GetAttribute("IncomeRate") or 0) * Offline.ReminderHours * Offline.MinutesPerHour * 60 > 0
                                end
                            end
                        end
                    end
                end
            end

            if v53 then
                v38 = true
                v37 = nil
                popReminder(v36)
                v34 = math.max(v34 or 0, os.clock() + Offline.ReminderInterval / 2)

                return
            end
        end

        if v34 and v34 <= elapsed then
            local v56 = not ClientState.Busy

            if v56 then
                v56 = not ClientState.TutorialActive

                if v56 then
                    v56 = not ClientState.OfflineOpen

                    if v56 then
                        local ShopOpen = ClientState.ShopOpen

                        if ShopOpen then
                            v56 = not ShopOpen
                        else
                            ShopOpen = ClientState.SellOpen

                            if ShopOpen then
                                v56 = not ShopOpen
                            else
                                ShopOpen = ClientState.IndexOpen

                                if ShopOpen then
                                    v56 = not ShopOpen
                                else
                                    ShopOpen = ClientState.ExclusiveShopOpen
                                    v56 = if ShopOpen then not ShopOpen else not ClientState.AnimalsOpen and not HUDController.IsGameplayHidden() and (LocalPlayer:GetAttribute("IncomeRate") or 0) * Offline.ReminderHours * Offline.MinutesPerHour * 60 > 0
                                end
                            end
                        end
                    end
                end
            end

            if v56 then
                showReminder()
            end
        end
    end
end

function t1.Init() -- line: 414
    -- upvalues: RunService (copy), TweenService (copy), DataController (copy), UIKit (copy), t1 (copy), Offline (copy), LocalPlayer (copy), t2 (ref), v9 (ref), n2 (ref), refreshTexts (copy), buildReminder (copy), step (copy)
    buildReminder()
    DataController.Ready:Connect(function() -- line: 416
        -- upvalues: n2 (ref)
        n2 = os.clock() + 1.5
    end)

    if DataController:IsReady() then
        n2 = os.clock() + 1.5
    end

    t1.ScheduleReminder(Offline.ReminderFirst)
    LocalPlayer:GetAttributeChangedSignal("CashMultiplier"):Connect(function() -- line: 422
        -- upvalues: v9 (ref), refreshTexts (copy)
        if v9 then
            refreshTexts(false)
        end
    end)
    RunService.Heartbeat:Connect(step)
    task.spawn(function() -- line: 427
        -- upvalues: TweenService (copy), UIKit (copy), t2 (ref), v9 (ref)
        while true do
            task.wait(2.2)

            if v9 and t2 then
                t2.Shine.Offset = Vector2.new(-1, 0)
                TweenService:Create(t2.Shine, TweenInfo.new(0.7, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {
                    Offset = Vector2.new(1, 0)
                }):Play()
                UIKit.Punch(t2.Button, 0.06, 0.4)
            end
        end
    end)
end

return t1
