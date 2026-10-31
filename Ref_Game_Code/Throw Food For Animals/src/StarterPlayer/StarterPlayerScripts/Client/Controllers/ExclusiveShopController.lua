-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ContentProvider = game:GetService("ContentProvider")
local CollectionService = game:GetService("CollectionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local MonetizationConfig = require(ReplicatedStorage.Config.MonetizationConfig)
local LevelConfig = require(ReplicatedStorage.Config.LevelConfig)
local NumberFormat = require(ReplicatedStorage.Shared.NumberFormat)
local EggsConfig = require(ReplicatedStorage.Config.EggsConfig)
local RarityConfig = require(ReplicatedStorage.Config.RarityConfig)
local UITheme = require(ReplicatedStorage.Config.UITheme)
local AnimalsData = require(ReplicatedStorage.AnimalsData)
local AnimationLibrary = require(ReplicatedStorage.Shared.AnimationLibrary)
local Remotes = require(ReplicatedStorage.Shared.Remotes)
local Signal = require(ReplicatedStorage.Shared.Signal)
local Parent = script.Parent
local DataController = require(Parent.DataController)

require(Parent.UIKit)

local ShopUI = require(Parent.ShopUI)
local UIScaler = require(Parent.UIScaler)
local Sounds = require(Parent.Sounds)
local ClientState = require(Parent.ClientState)
local RobuxPrices = require(Parent.RobuxPrices)
local HUDController = require(Parent.HUDController)
local t1 = {
    GiftRequested = Signal.new()
}
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local v1, Main, Panel, Scroll, v2
local v3 = nil
local v4 = false
local t2 = {}
local t3 = {}
local t4 = {}
local t5 = {}
local v5
local t6 = {}
local t7 = {}
local t8, playAnimals, highlightPack
local v6 = Color3.fromRGB(255, 208, 60)
local t9
local n1 = 0
local v7, v8, UIScale

local function find(p1, p2) -- line: 130
    for match in string.gmatch(p2, "[^%.]+") do
        p1 = p1 and p1:FindFirstChild(match)
    end

    return p1
end

local function priceSource(p3) -- line: 139
    -- upvalues: MonetizationConfig (copy)
    if p3 == "ServerLuck" then
        local Tiers = MonetizationConfig.ServerLuck.Tiers
        local v14 = math.clamp(math.floor(math.log(workspace:GetAttribute("ServerLuck") or 1, 2) + 0.5) + 1, 1, #Tiers)
        local v15 = MonetizationConfig.Products[Tiers[v14]]

        return v15.Id, Enum.InfoType.Product, v15.Price
    end

    local v16 = MonetizationConfig.Passes[p3]

    if v16 then
        return v16.Id, Enum.InfoType.GamePass, v16.Price
    end

    local v17 = MonetizationConfig.Products[p3]

    if v17 then
        return v17.Id, Enum.InfoType.Product, v17.Price
    end

    return nil
end

local function formatRobux(p4) -- line: 154
    return (tostring((math.floor(p4))):reverse():gsub("(%d%d%d)", "%1,"):reverse():gsub("^,", ""))
end

function t1.RefreshPrices() -- line: 164
    -- upvalues: RobuxPrices (copy), t2 (copy), priceSource (copy)
    for _, v19 in ipairs(t2) do
        if v19.PriceLabel and not v19.Owned then
            local v20, v21, v22 = priceSource(v19.Item)

            if v20 then
                v19.PriceLabel.Text = tostring((math.floor((RobuxPrices.Get(v20, v21, v22))))):reverse():gsub("(%d%d%d)", "%1,"):reverse():gsub("^,", "")
            end
        end
    end
end

local function refreshOwned() -- line: 175
    -- upvalues: MonetizationConfig (copy), ShopUI (copy), t1 (copy), LocalPlayer (copy), t2 (copy)
    for _, v25 in ipairs(t2) do
        if MonetizationConfig.Passes[v25.Item] then
            local v26 = LocalPlayer:GetAttribute("Pass_" .. v25.Item) == true

            v25.Owned = v26

            if v26 then
                ShopUI.SetButtonColor(v25.Holder, "Gray")

                if v25.RobuxIcon then
                    v25.RobuxIcon.Visible = false
                end

                if v25.PriceLabel then
                    v25.PriceLabel.Text = "OWNED"
                end

                v25.Juice:SetEnabled(false)
            else
                ShopUI.SetButtonColor(v25.Holder, "Green")

                if v25.RobuxIcon then
                    v25.RobuxIcon.Visible = true
                end

                v25.Juice:SetEnabled(true)
            end
        end
    end

    t1.RefreshPrices()
end

local function refreshFree() -- line: 196
    -- upvalues: DataController (copy), Scroll (ref), find (copy)
    local v27 = find(Scroll, "FreeAnimal.FreeCard.Card")

    if not v27 then
        return
    end

    local v28 = DataController:Get("FreeAnimalClaimed") == true
    local ClaimButton = v27:FindFirstChild("ClaimButton")
    local OwnedLabel = v27:FindFirstChild("OwnedLabel")

    if ClaimButton then
        ClaimButton.Visible = not v28
    end

    if OwnedLabel then
        OwnedLabel.Visible = v28
        OwnedLabel.Text = "Claimed!"
    end
end

local t10

local function refreshLuck() -- line: 211
    -- upvalues: MonetizationConfig (copy), ShopUI (copy), v5 (ref), t10 (ref)
    if not v5 then
        return
    end

    local ServerLuck = MonetizationConfig.ServerLuck
    local v29 = workspace:GetAttribute("ServerLuck") or 1
    local v30 = (workspace:GetAttribute("ServerLuckEnd") or 0) - workspace:GetServerTimeNow()

    if v29 > 1 and v30 <= 0 then
        v29 = 1
    end

    local v31 = ServerLuck.MaxMultiplier <= v29
    local v32, v33

    if v31 then
        local ExtendDuration = ServerLuck.ExtendDuration

        if ExtendDuration then
            v32 = ExtendDuration
            v33 = true
        else
            local Duration = ServerLuck.Duration

            if Duration then
                v32 = Duration
                v33 = true
            else
                v33 = false
            end
        end
    else
        v33 = false
    end

    if not v33 then
        v32 = ServerLuck.Duration
    end

    local v35 = math.floor(v32 / 60 + 0.5)
    local Title = v5:FindFirstChild("Title")
    local Description = v5:FindFirstChild("Description")

    if not t10 then
        t10 = {
            Title = Title and Title.Text,
            Description = Description and Description.Text
        }
    end

    if Title then
        local v36

        if v31 then
            v36 = "Extend " .. v29 .. "x Luck"

            if not v36 then
                local t12 = t10

                v36 = t12.Title
            end
        else
            local t13 = t10

            v36 = t13.Title
        end

        Title.Text = v36
    end

    if Description then
        local v37

        if v31 then
            v37 = "Keep " .. v29 .. "x luck going for everyone in the server!"

            if not v37 then
                local t14 = t10

                v37 = t14.Description
            end
        else
            local t15 = t10

            v37 = t15.Description
        end

        Description.Text = v37
    end

    local Boost = v5:FindFirstChild("Boost")

    if Boost then
        Boost.From.Text = v29 .. "x"
        Boost.To.Text = v31 and "+" .. v35 .. " MIN" or v29 * 2 .. "x"
    end

    local DurationPill = v5:FindFirstChild("DurationPill")
    local Label = DurationPill and DurationPill:FindFirstChild("Label")

    if Label then
        if v29 > 1 then
            Label.Text = "+" .. v35 .. " Min  |  " .. ShopUI.FormatTime(v30) .. " left"
        else
            Label.Text = "+" .. v35 .. " Minutes"
        end
    end
end

local function mainScale() -- line: 250
    -- upvalues: Main (ref)
    local OpenScale = Main:FindFirstChild("OpenScale")

    if not OpenScale then
        OpenScale = Instance.new("UIScale")
        OpenScale.Name = "OpenScale"
        OpenScale.Parent = Main
    end

    return OpenScale
end

function t1.ScrollTo(p5, p6) -- line: 262
    -- upvalues: Main (ref), Scroll (ref)
    local v38 = if typeof(p5) ~= "Instance" or not p5 then Scroll and Scroll:FindFirstChild(p5) else p5

    if v38 and Scroll then
        local OpenScale = Main:FindFirstChild("OpenScale")

        if not OpenScale then
            OpenScale = Instance.new("UIScale")
            OpenScale.Name = "OpenScale"
            OpenScale.Parent = Main
        end

        local Scale = OpenScale.Scale

        if not (Scale > 0.01) or not Scale then
            Scale = 1
        end

        local v39 = Scroll.CanvasPosition.Y + (v38.AbsolutePosition.Y - Scroll.AbsolutePosition.Y) / Scale - (p6 or 12)
        local v41 = math.max(0, Scroll.AbsoluteCanvasSize.Y / Scale - Scroll.AbsoluteWindowSize.Y / Scale)

        Scroll.CanvasPosition = Vector2.new(0, (math.clamp(v39, 0, v41)))
    end
end

function t1.Open(p7, p8) -- line: 274
    -- upvalues: Parent (copy), ShopUI (copy), Sounds (copy), ClientState (copy), RobuxPrices (copy), t1 (copy), v1 (ref), Main (ref), Scroll (ref), v2 (ref), v4 (ref), t4 (copy), playAnimals (ref), highlightPack (ref), refreshOwned (copy), refreshFree (copy), refreshLuck (copy)
    if v1 then
        if v4 then
            if p7 then
                t1.ScrollTo(p7)
            end

            if p8 then
                highlightPack(p8, true)
            end
        elseif not (ClientState.Busy or ClientState.OfflineOpen) then
            if ClientState.IndexOpen then
                local _require = require
                local IndexController = Parent.IndexController
                local ok, result = pcall(_require, IndexController)

                if ok and result.Close then
                    result.Close()
                end
            end

            if ClientState.ShopOpen then
                local _require = require
                local ShopController = Parent.ShopController
                local ok, result = pcall(_require, ShopController)

                if ok and result.Close then
                    result.Close()
                end
            end

            if ClientState.AnimalsOpen then
                local _require = require
                local AnimalsPanel = script.Parent.AnimalsPanel
                local ok, result = pcall(_require, AnimalsPanel)

                if ok then
                    result.Close()
                end
            end

            v4 = true
            ClientState.ExclusiveShopOpen = true
            v1.Enabled = true

            if v2 then
                v2:Destroy()
            end

            v2 = ShopUI.Dim(v1, 0, 0.25)
            Main.Visible = true

            local OpenScale = Main:FindFirstChild("OpenScale")

            if not OpenScale then
                OpenScale = Instance.new("UIScale")
                OpenScale.Name = "OpenScale"
                OpenScale.Parent = Main
            end

            OpenScale.Scale = 0.72
            ShopUI.Tween(OpenScale, {
                Scale = 1
            }, 0.42, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
            Sounds.Play("ShopOpen")
            RobuxPrices.RefreshNow()
            refreshOwned()
            refreshFree()
            refreshLuck()
            Scroll.CanvasPosition = Vector2.zero

            if p7 then
                task.delay(0.05, function() -- line: 314
                    -- upvalues: p7 (copy), t1 (copy)
                    t1.ScrollTo(p7)
                end)
            end

            if p8 then
                task.delay(0.45, function() -- line: 317
                    -- upvalues: p8 (copy), v4 (ref), highlightPack (ref)
                    if v4 then
                        highlightPack(p8, true)
                    end
                end)
            end

            for v42, v43 in ipairs(t4) do
                local StaggerScale = v43:FindFirstChild("StaggerScale")

                if StaggerScale then
                    StaggerScale.Scale = 0.82
                    task.delay(0.06 + 0.045 * (v42 - 1), function() -- line: 326
                        -- upvalues: StaggerScale (copy), v42 (copy), ShopUI (copy), Sounds (copy), v4 (ref)
                        if v4 then
                            ShopUI.Tween(StaggerScale, {
                                Scale = 1
                            }, 0.32, Enum.EasingStyle.Back, Enum.EasingDirection.Out)

                            if v42 <= 6 then
                                Sounds.Play("CardPop")
                            end
                        else
                            StaggerScale.Scale = 1
                        end
                    end)
                end
            end

            playAnimals(true)
        end
    end
end

function t1.Close() -- line: 337
    -- upvalues: ShopUI (copy), Sounds (copy), ClientState (copy), t1 (copy), v1 (ref), Main (ref), v2 (ref), v3 (ref), v4 (ref), playAnimals (ref)
    if not v4 then
        return
    end

    v4 = false
    ClientState.ExclusiveShopOpen = false
    Sounds.Play("ShopClose")
    t1.Disarm()

    if v3 then
        v3:Destroy()
        v3 = nil
    end

    if v2 then
        local v45 = v2

        v2 = nil
        ShopUI.Tween(v45, {
            BackgroundTransparency = 1
        }, 0.2).Completed:Once(function() -- line: 347
            -- upvalues: v45 (copy)
            v45:Destroy()
        end)
    end

    local Tween = ShopUI.Tween
    local OpenScale = Main:FindFirstChild("OpenScale")

    if not OpenScale then
        OpenScale = Instance.new("UIScale")
        OpenScale.Name = "OpenScale"
        OpenScale.Parent = Main
    end

    Tween(OpenScale, {
        Scale = 0.75
    }, 0.2, Enum.EasingStyle.Back, Enum.EasingDirection.In).Completed:Once(function() -- line: 350
        -- upvalues: v1 (ref), Main (ref), v4 (ref), playAnimals (ref)
        if v4 then
            return
        end

        v1.Enabled = false

        local OpenScale = Main:FindFirstChild("OpenScale")

        if not OpenScale then
            OpenScale = Instance.new("UIScale")
            OpenScale.Name = "OpenScale"
            OpenScale.Parent = Main
        end

        OpenScale.Scale = 1
        playAnimals(false)
    end)
end

function t1.Toggle() -- line: 359
    -- upvalues: t1 (copy), v4 (ref)
    if v4 then
        t1.Close()
    else
        t1.Open()
    end
end

function t1.IsOpen() -- line: 363
    -- upvalues: v4 (ref)
    return v4
end

function t1.GetGui() -- line: 367
    -- upvalues: v1 (ref)
    return v1
end

local function showLuckInfo() -- line: 375
    -- upvalues: MonetizationConfig (copy), ShopUI (copy), Sounds (copy), v1 (ref), v3 (ref)
    if v3 then
        v3:Destroy()
    end

    local Frame = Instance.new("Frame")

    Frame.Name = "LuckInfo"
    Frame.Size = UDim2.fromScale(1, 1)
    Frame.BackgroundTransparency = 1
    Frame.ZIndex = 50
    Frame.Parent = v1
    v3 = Frame

    local v46 = ShopUI.Dim(Frame, 50, 0.35)
    local ServerLuck = MonetizationConfig.ServerLuck

    local function close() -- line: 386
        -- upvalues: Frame (copy), v46 (copy), ShopUI (copy), Sounds (copy), v3 (ref)
        if v3 ~= Frame then
            return
        end

        v3 = nil
        Sounds.Play("ShopClose")
        ShopUI.Tween(v46, {
            BackgroundTransparency = 1
        }, 0.18)

        local LuckInfoPanel = Frame:FindFirstChild("LuckInfoPanel")

        if LuckInfoPanel then
            ShopUI.PopOut(LuckInfoPanel, 0.18, 0.7)
        end

        task.delay(0.2, function() -- line: 393
            -- upvalues: Frame (copy)
            Frame:Destroy()
        end)
    end

    v46.Activated:Connect(close)

    local v47 = ShopUI.Panel({
        Name = "LuckInfoPanel",
        Ratio = 1.05,
        Title = "Server Luck",
        Color = "Clover",
        HeaderHeight = 0.14,
        ZIndex = 51,
        Transparency = 0.06,
        Parent = Frame,
        Size = UDim2.fromScale(0.42, 0.66),
        TitleIcon = ShopUI.Icons.Clover,
        OnClose = close
    })
    local Content = v47.Content
    local t16 = {
        {
            "<font color=\"#8CFF6A\">Luck</font> makes new animals get better <font color=\"#FFD84A\">mutations</font> and <font color=\"#FF9CE6\">sizes</font>.",
            0.16
        },
        {
            "With <font color=\"#8CFF6A\">4x</font> luck every animal rolls its mutation and size <font color=\"#8CFF6A\">4 times</font> - the best roll wins!",
            0.16
        },
        {
            "Every purchase <font color=\"#FFD84A\">doubles</font> it: 2x, 4x, 8x, up to <font color=\"#FFD84A\">" .. ServerLuck.MaxMultiplier .. "x</font>, and adds <font color=\"#FFD84A\">" .. math.floor(ServerLuck.Duration / 60) .. " minutes</font>. At " .. ServerLuck.MaxMultiplier .. "x anyone can <font color=\"#FFD84A\">extend</font> it (+" .. math.floor((ServerLuck.ExtendDuration or ServerLuck.Duration) / 60) .. " min).",
            0.2
        },
        {
            "It works for <font color=\"#8CFF6A\">everyone</font> in the server - every throw!",
            0.14
        }
    }
    local n2 = 0.04

    for v51, v52 in ipairs(t16) do
        local v53 = ShopUI.Frame({
            Transparency = 1,
            ZIndex = 52,
            Parent = Content,
            Name = "Line" .. v51,
            Size = UDim2.fromScale(0.9, v52[2]),
            Position = UDim2.fromScale(0.5, n2),
            AnchorPoint = Vector2.new(0.5, 0)
        })

        ShopUI.Frame({
            Name = "Bullet",
            Stroke = 2,
            ZIndex = 52,
            Ratio = 1,
            Parent = v53,
            Size = UDim2.fromScale(0, 0.34),
            Position = UDim2.fromScale(0, 0.5),
            AnchorPoint = Vector2.new(0, 0.5),
            Color = Color3.fromRGB(120, 235, 110),
            Corner = UDim.new(0.5, 0)
        }).Size = UDim2.fromScale(0.06, 0.34)

        local v54 = ShopUI.Text({
            Rich = true,
            Wrap = true,
            ZIndex = 52,
            Stroke = 2,
            Parent = v53,
            Text = v52[1],
            Size = UDim2.fromScale(0.9, 1),
            Position = UDim2.fromScale(0.1, 0),
            XAlign = Enum.TextXAlignment.Left
        })
        local UITextSizeConstraint = Instance.new("UITextSizeConstraint")

        UITextSizeConstraint.MaxTextSize = 30
        UITextSizeConstraint.Parent = v54
        n2 += v52[2] + 0.025
    end

    ShopUI.Button({
        Name = "GotIt",
        Text = "GOT IT!",
        Color = "Green",
        ZIndex = 53,
        Parent = Content,
        Size = UDim2.fromScale(0.4, 0.12),
        Position = UDim2.fromScale(0.5, 0.95),
        AnchorPoint = Vector2.new(0.5, 1),
        OnClick = close
    })
    ShopUI.PopIn(v47.Root, 0.4, 0.6)
    Sounds.Play("Pop")
end

local function promptItem(p9) -- line: 425
    -- upvalues: Remotes (copy), Sounds (copy), v4 (ref)
    if not v4 or p9.Owned or p9.Busy then
        return
    end

    p9.Busy = true

    local v55 = Remotes.Invoke("Shop_Prompt", p9.Item)

    task.delay(0.6, function() -- line: 429
        -- upvalues: p9 (copy)
        p9.Busy = false
    end)

    if not v55.Ok and v55.Reason ~= "Cooldown" then
        Sounds.Play("PurchaseFail", {
            Volume = 0.4
        })
    end
end

local function wireButton(p10, p11) -- line: 435
    -- upvalues: ShopUI (copy), t2 (copy), promptItem (copy)
    local Button = p10 and p10:FindFirstChild("Button")

    if not Button then
        return
    end

    local Content = Button:FindFirstChild("Content")
    local t21 = {
        Holder = p10,
        Button = Button,
        Item = p11,
        PriceLabel = Content and Content:FindFirstChild("PriceLabel"),
        RobuxIcon = Content and Content:FindFirstChild("RobuxIcon"),
        Juice = ShopUI.Juice(p10, Button)
    }

    t21.Use = function() -- line: 447
        -- upvalues: t21 (copy), promptItem (copy)
        promptItem(t21)
    end

    Button.Activated:Connect(t21.Use)
    table.insert(t2, t21)

    return t21
end

local function hoverLift(p12) -- line: 456
    -- upvalues: ShopUI (copy), UIScaler (copy), Scroll (ref), t3 (copy)
    if not p12 then
        return
    end

    local v56 = p12:FindFirstChild("Card") or p12
    local t22 = {
        p12
    }

    if p12.Parent == Scroll or p12:FindFirstChild("StaggerScale") then
        t22 = {
            v56
        }

        local Shadow = p12:FindFirstChild("Shadow")

        if Shadow then
            table.insert(t22, Shadow)
        end
    end

    local t23 = {}

    for _, v57 in ipairs(t22) do
        local UIScale = Instance.new("UIScale")

        UIScale.Name = "HoverScale"
        UIScale.Parent = v57
        table.insert(t23, UIScale)
    end

    local UIStroke = v56:FindFirstChildOfClass("UIStroke")
    local Thickness = UIStroke and UIScaler.Base(UIStroke, "Thickness") or 3

    v56.MouseEnter:Connect(function() -- line: 474
        -- upvalues: t23 (copy), UIStroke (copy), Thickness (copy), ShopUI (copy)
        for _, v58 in ipairs(t23) do
            ShopUI.Tween(v58, {
                Scale = 1.018
            }, 0.18, Enum.EasingStyle.Quad)
        end

        if UIStroke then
            ShopUI.Tween(UIStroke, {
                Thickness = Thickness + 1
            }, 0.18)
        end
    end)
    v56.MouseLeave:Connect(function() -- line: 478
        -- upvalues: t23 (copy), UIStroke (copy), Thickness (copy), ShopUI (copy)
        for _, v59 in ipairs(t23) do
            ShopUI.Tween(v59, {
                Scale = 1
            }, 0.2, Enum.EasingStyle.Quad)
        end

        if UIStroke then
            ShopUI.Tween(UIStroke, {
                Thickness = Thickness
            }, 0.2)
        end
    end)
    table.insert(t3, p12)
end

function t1.Disarm() -- line: 489
    -- upvalues: ShopUI (copy), t9 (ref), v7 (ref), UIScale (ref)
    if not t9 then
        return
    end

    local t24 = t9

    t9 = nil

    if t24.Stroke then
        ShopUI.Tween(t24.Stroke, {
            Color = t24.Color
        }, 0.2)
    end

    if v7 and v7.Visible then
        ShopUI.Tween(UIScale, {
            Scale = 0
        }, 0.12, Enum.EasingStyle.Back, Enum.EasingDirection.In)
        task.delay(0.13, function() -- line: 496
            -- upvalues: t9 (ref), v7 (ref)
            if not t9 then
                v7.Visible = false
            end
        end)
    end
end

local function pulseButton(p13) -- line: 503
    -- upvalues: ShopUI (copy)
    local JuiceScale = p13 and p13:FindFirstChild("JuiceScale")

    if JuiceScale then
        JuiceScale.Scale = 1.15
        ShopUI.Tween(JuiceScale, {
            Scale = 1
        }, 0.5, Enum.EasingStyle.Elastic, Enum.EasingDirection.Out)
    end
end

local function arm(p14, p15, p16) -- line: 510
    -- upvalues: ShopUI (copy), Sounds (copy), t1 (copy), v1 (ref), v6 (copy), t9 (ref), n1 (ref), v7 (ref), v8 (ref), UIScale (ref)
    t1.Disarm()
    n1 += 1

    local v60 = n1
    local UIStroke = p14:FindFirstChildOfClass("UIStroke")

    t9 = {
        Card = p14,
        Stroke = UIStroke,
        Color = UIStroke and UIStroke.Color
    }

    if UIStroke then
        ShopUI.Tween(UIStroke, {
            Color = v6
        }, 0.15)
    end

    if v7 then
        v8.Text = p15

        local AbsolutePosition = v1.AbsolutePosition
        local v61 = v7

        v61.Position = UDim2.fromOffset(p16.X - AbsolutePosition.X, p16.Y - AbsolutePosition.Y - 10)
        v7.Visible = true
        UIScale.Scale = 0.3
        ShopUI.Tween(UIScale, {
            Scale = 1
        }, 0.28, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
    end

    Sounds.Play("ButtonClick")
    task.delay(3, function() -- line: 526
        -- upvalues: p14 (copy), v60 (copy), t1 (copy), t9 (ref), n1 (ref)
        if n1 == v60 and t9 and t9.Card == p14 then
            t1.Disarm()
        end
    end)
end

local function wireCard(p17, p18, p19) -- line: 534
    -- upvalues: t1 (copy), v4 (ref), t9 (ref), pulseButton (copy), arm (copy)
    local v62 = p19

    if not (p17 and p18) then
        return
    end

    v62 = p19 or {}

    local TextButton = Instance.new("TextButton")

    TextButton.Name = "ClickArea"
    TextButton.Text = ""
    TextButton.AutoButtonColor = false
    TextButton.Selectable = false
    TextButton.BackgroundTransparency = 1
    TextButton.Size = UDim2.fromScale(1, 1)
    TextButton.ZIndex = 0
    TextButton.Parent = p17
    TextButton.Activated:Connect(function(p20) -- line: 546
        -- upvalues: v62 (ref), p17 (copy), p18 (copy), t1 (copy), v4 (ref), t9 (ref), pulseButton (copy), arm (copy)
        if not v4 or v62.CanUse and not v62.CanUse() then
            return
        end

        if not t9 or t9.Card ~= p17 then
            local v63 = if p20 and (p20.UserInputType == Enum.UserInputType.MouseButton1 or p20.UserInputType == Enum.UserInputType.Touch) then Vector2.new(p20.Position.X, p20.Position.Y) else p17.AbsolutePosition + p17.AbsoluteSize / 2

            arm(p17, v62.Hint or "CLICK AGAIN TO BUY!", v63)
        else
            t1.Disarm()
            pulseButton(p18.Holder)
            p18.Use()
        end
    end)
end

local function rgb(p21, p22, p23) -- line: 569
    return Color3.fromRGB(p21, p22, p23)
end

local Money = UITheme.Icons.Money
local Clover = ShopUI.Icons.Clover
local t26 = {
    Pumpkin = {
        Color3.fromRGB(255, 200, 80),
        Color3.fromRGB(255, 118, 22),
        rgb(146, 40, 164)
    },
    Egg = {
        Color3.fromRGB(200, 130, 255),
        Color3.fromRGB(126, 56, 210),
        rgb(64, 22, 116)
    },
    Squid = {
        Color3.fromRGB(118, 214, 255),
        Color3.fromRGB(48, 118, 230),
        rgb(86, 46, 186)
    },
    Mammoth = {
        Color3.fromRGB(255, 214, 150),
        Color3.fromRGB(224, 146, 70),
        rgb(150, 84, 44)
    }
}
local t27 = {
    Gold = {
        Color3.fromRGB(255, 227, 92),
        rgb(255, 165, 30)
    },
    Green = {
        Color3.fromRGB(139, 232, 107),
        rgb(47, 168, 74)
    },
    Purple = {
        Color3.fromRGB(205, 150, 255),
        rgb(130, 70, 230)
    },
    Blue = {
        Color3.fromRGB(120, 214, 255),
        rgb(36, 128, 236)
    }
}
local t28 = {
    Color3.fromRGB(24, 9, 48),
    rgb(82, 30, 108)
}
local t29 = {
    Color3.fromRGB(205, 255, 140),
    rgb(98, 216, 46)
}
local t30 = {
    Color3.fromRGB(86, 204, 72),
    rgb(34, 128, 42)
}
local t31 = {
    Color3.fromRGB(255, 255, 255),
    rgb(255, 228, 186)
}
local t32 = {
    "Rare",
    "Epic",
    "Legendary",
    "Mythic",
    "Celestial",
    "Divine"
}
local t33 = {
    Width = 0.46,
    PillGradient = {
        Color3.fromRGB(78, 30, 112),
        rgb(40, 14, 64)
    },
    PillStroke = Color3.fromRGB(255, 140, 40),
    TextGradient = {
        Color3.fromRGB(255, 232, 110),
        rgb(255, 122, 24)
    },
    LineColor = Color3.fromRGB(255, 150, 60)
}
local t34 = {}

for _, v64 in pairs(AnimalsData) do
    for _, v65 in ipairs(v64) do
        t34[v65.ModelName] = v65.Name
    end
end

local function active() -- line: 615
    -- upvalues: v4 (ref)
    return v4
end

local function wpos(p24, p25) -- line: 618
    return UDim2.fromScale(p24, p25 / 0.9246732026143792)
end

local function wsize(p26, p27, p28) -- line: 623
    p26.SizeConstraint = Enum.SizeConstraint.RelativeXX
    p26.Size = UDim2.fromScale(p27, p28)
end

local function card(p29, p30, p31) -- line: 630
    -- upvalues: ShopUI (copy)
    ShopUI.Frame({
        Name = "Shadow",
        Transparency = 0.72,
        Corner = 16,
        ZIndex = 1,
        Parent = p29,
        Position = UDim2.fromOffset(0, 5),
        Color = Color3.new(0, 0, 0)
    })

    local v66 = ShopUI.Frame({
        Name = "Card",
        Corner = 16,
        Stroke = 3,
        ZIndex = 2,
        Parent = p29
    })

    ShopUI.Gradient(v66, ShopUI.Sequence(p30), nil, p31 or 20)
    ShopUI.Stripes(v66, 0.94, 16, 25).ZIndex = 2

    local v67 = ShopUI.Frame({
        Name = "Shine",
        Corner = 16,
        ZIndex = 2,
        Parent = v66,
        Size = UDim2.fromScale(1, 0.5)
    })
    local UIGradient = Instance.new("UIGradient")

    UIGradient.Rotation = 90
    UIGradient.Transparency = NumberSequence.new(0.72, 1)
    UIGradient.Parent = v67

    return v66
end

local function tag(p32, p33, p34, p35) -- line: 644
    -- upvalues: ShopUI (copy)
    return ShopUI.Pill({
        Name = "DealTag",
        Parent = p32,
        Text = p33,
        Size = p35.Size,
        Position = p35.Position,
        AnchorPoint = p35.AnchorPoint,
        Rotation = p35.Rotation or -4,
        ZIndex = p35.ZIndex or 8,
        Gradient = {
            p34[1],
            p34[2],
            90
        }
    })
end

local function glowRings(p36, p37, p38, p39) -- line: 649
    -- upvalues: ShopUI (copy)
    local v68 = ShopUI.Frame({
        Name = "IconGlow",
        Transparency = 1,
        Parent = p36,
        Size = p38,
        Position = p37,
        AnchorPoint = Vector2.new(0.5, 0.5),
        ZIndex = p39 or 3
    })

    Instance.new("UIAspectRatioConstraint").Parent = v68

    for v69, v70 in ipairs({
            { 1, 0.84 },
            { 0.8, 0.76 },
            { 0.6, 0.66 }
        }) do
        ShopUI.Frame({
            Parent = v68,
            Name = "Ring" .. v69,
            Size = UDim2.fromScale(v70[1], v70[1]),
            Position = UDim2.fromScale(0.5, 0.5),
            AnchorPoint = Vector2.new(0.5, 0.5),
            Transparency = v70[2],
            Corner = UDim.new(0.5, 0),
            ZIndex = v68.ZIndex
        })
    end

    return v68
end

local function well(p40, p41) -- line: 660
    -- upvalues: ShopUI (copy)
    local v71 = ShopUI.Frame({
        Corner = 12,
        Parent = p40,
        Name = p41.Name or "Well",
        Size = p41.Size,
        Position = p41.Position,
        AnchorPoint = p41.AnchorPoint,
        Color = p41.Gold and Color3.fromRGB(255, 244, 194) or p41.Color or Color3.new(1, 1, 1),
        Transparency = if p41.Gold then 0.3 elseif p41.Color then 0.4 else 0.55,
        ZIndex = p41.ZIndex or 3
    })

    ShopUI.Stroke(v71, p41.Gold and 3 or 2, p41.Gold and Color3.fromRGB(255, 216, 74) or Color3.new(1, 1, 1), p41.Gold and 0 or 0.35)

    return v71
end

local function iconValue(p42) -- line: 670
    -- upvalues: ShopUI (copy), Money (copy)
    local v72 = ShopUI.Frame({
        Transparency = 1,
        Parent = p42.Parent,
        Name = p42.Name or "Value",
        Size = p42.Size,
        Position = p42.Position,
        AnchorPoint = p42.AnchorPoint,
        ZIndex = p42.ZIndex or 5
    })
    local UIListLayout = Instance.new("UIListLayout")

    UIListLayout.FillDirection = Enum.FillDirection.Horizontal
    UIListLayout.HorizontalAlignment = p42.Align == "Left" and Enum.HorizontalAlignment.Left or Enum.HorizontalAlignment.Center
    UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    UIListLayout.Padding = UDim.new(0.02, 0)
    UIListLayout.Parent = v72

    local v73 = ShopUI.Image({
        Name = "Icon",
        Square = true,
        Parent = v72,
        Image = p42.Icon or Money,
        Size = UDim2.fromScale(p42.IconScale or 1, p42.IconScale or 1),
        ZIndex = v72.ZIndex
    })

    v73.LayoutOrder = 1

    local v74 = ShopUI.Text({
        Name = "Label",
        Parent = v72,
        Text = p42.Text,
        Size = UDim2.fromScale(0, 1),
        ZIndex = v72.ZIndex,
        Stroke = p42.Stroke or 4,
        Gradient = p42.Colors and {
            p42.Colors[1],
            p42.Colors[2],
            90
        } or nil
    })

    v74.TextScaled = false
    v74.AutomaticSize = Enum.AutomaticSize.X
    v74.LayoutOrder = 2

    local function fit() -- line: 686
        -- upvalues: v72 (copy), v73 (copy), v74 (copy)
        local Y, X = v72.AbsoluteSize.Y, v72.AbsoluteSize.X

        if Y <= 0 then
            return
        end

        local v76 = math.floor(Y * 0.98)

        v74.TextSize = v76

        local v77 = X - v73.AbsoluteSize.X - X * 0.02

        if not (v77 < v74.TextBounds.X and v74.TextBounds.X > 0) then
            return
        end

        v74.TextSize = math.max(8, (math.floor(v76 * v77 / v74.TextBounds.X)))
    end

    v72:GetPropertyChangedSignal("AbsoluteSize"):Connect(fit)
    v74:GetPropertyChangedSignal("Text"):Connect(fit)
    fit()
    task.defer(fit)

    return v72, v74, v73
end

local function ofBestBlock(p43, p44, p45) -- line: 704
    -- upvalues: MonetizationConfig (copy), ShopUI (copy), t29 (copy), iconValue (copy)
    local v80 = ShopUI.Frame({
        Name = "OfBest",
        Transparency = 1,
        Parent = p43,
        Size = p45.Size,
        Position = p45.Position,
        AnchorPoint = p45.AnchorPoint,
        ZIndex = p45.ZIndex or 5
    })

    if p45.Box then
        local v81 = ShopUI.Frame({
            Name = "Plate",
            Transparency = 0.5,
            Corner = 14,
            Parent = v80,
            Color = Color3.fromRGB(24, 8, 34),
            ZIndex = v80.ZIndex
        })

        ShopUI.Stroke(v81, 2, Color3.new(1, 1, 1), 0.6)
    end

    local v82 = if p45.Box then 0.06 else 0

    iconValue({
        Name = "Percent",
        Stroke = 4,
        Parent = v80,
        Text = MonetizationConfig.FormatOfBest(p44),
        Colors = t29,
        Align = p45.Align,
        Size = UDim2.fromScale(1 - v82 * 2, p45.ValueHeight or 0.66),
        Position = UDim2.fromScale(v82, p45.Box and 0.04 or 0),
        ZIndex = v80.ZIndex + 1
    })
    ShopUI.Text({
        Name = "Caption",
        Text = "OF YOUR BEST ANIMAL",
        Stroke = 2.5,
        Parent = v80,
        Size = UDim2.fromScale(1 - v82 * 2, p45.CaptionHeight or 0.26),
        Position = UDim2.fromScale(v82, p45.Box and 0.69 or 0.72),
        XAlign = p45.Align == "Left" and Enum.TextXAlignment.Left or Enum.TextXAlignment.Center,
        ZIndex = v80.ZIndex + 1
    })

    return v80
end

local function moneyTag(p46, p47, p48) -- line: 720
    -- upvalues: MonetizationConfig (copy), ShopUI (copy), t30 (copy), iconValue (copy)
    local v83 = ShopUI.Frame({
        Name = "MoneyTag",
        Stroke = 2,
        Parent = p46,
        Size = p48.Size,
        Position = p48.Position,
        AnchorPoint = p48.AnchorPoint,
        Corner = UDim.new(0.5, 0),
        ZIndex = p48.ZIndex or 6,
        Gradient = {
            t30[1],
            t30[2],
            90
        }
    })

    iconValue({
        Name = "Value",
        Stroke = 2,
        IconScale = 1.15,
        Parent = v83,
        Text = MonetizationConfig.FormatOfBest(p47),
        Size = UDim2.fromScale(0.9, 0.8),
        Position = UDim2.fromScale(0.5, 0.5),
        AnchorPoint = Vector2.new(0.5, 0.5),
        ZIndex = v83.ZIndex + 1
    })

    return v83
end

local function animalViewport(p49, p50, p51) -- line: 728
    -- upvalues: ShopUI (copy), t6 (copy), active (copy)
    p51.Parent = p49
    p51.Active = active
    p51.Pad = p51.Pad or 1

    local v84 = ShopUI.Viewport(p51)
    local v85 = ShopUI.ItemModel({
        Animal = p50
    })

    if v85 then
        v84:SetModel(v85)

        if not p51.Still then
            table.insert(t6, {
                Model = v85,
                Clip = p51.Clip
            })
        end
    end

    return v84
end

local function eggViewport(p52, p53, p54) -- line: 741
    -- upvalues: ShopUI (copy), active (copy)
    p54.Parent = p52
    p54.Active = active

    local v86 = ShopUI.Viewport(p54)
    local v87 = ShopUI.ItemModel({
        Egg = p53
    })

    if v87 then
        v86:SetModel(v87)
    end

    return v86
end

local function buyButton(p55, p56, p57) -- line: 752
    -- upvalues: ShopUI (copy), RobuxPrices (copy), t2 (copy), priceSource (copy), promptItem (copy)
    local t41 = {
        Item = p56
    }
    local v88, v89, v90 = priceSource(p56)

    p57.Parent = p55
    p57.Name = p57.Name or "BuyButton"
    p57.Price = tostring((math.floor((RobuxPrices.Get(v88, v89, v90))))):reverse():gsub("(%d%d%d)", "%1,"):reverse():gsub("^,", "")
    p57.FitPrice = true
    p57.ZIndex = p57.ZIndex or 6

    p57.OnClick = function() -- line: 760
        -- upvalues: t41 (copy)
        t41.Use()
    end

    local v93 = ShopUI.Button(p57)
    local Holder, Button, Label, Icon = v93.Holder, v93.Button, v93.Label, v93.Icon
    local Juice = v93.Juice

    t41.Holder = Holder
    t41.Button = Button
    t41.PriceLabel = Label
    t41.RobuxIcon = Icon
    t41.Juice = Juice

    t41.Use = function() -- line: 763
        -- upvalues: t41 (copy), promptItem (copy)
        promptItem(t41)
    end

    table.insert(t2, t41)

    return t41
end

local function eggButtons(p58, p59, p60) -- line: 769
    -- upvalues: ShopUI (copy), buyButton (copy)
    ShopUI.Text({
        Name = "Caption1",
        Text = "Buy 1",
        ZIndex = 5,
        Stroke = 2.5,
        Parent = p58,
        Size = UDim2.fromScale(0.215, 0.09),
        Position = UDim2.fromScale(0.765, 0.075)
    })

    local v94 = buyButton(p58, p59, {
        Name = "Buy1",
        Size = UDim2.fromScale(0.215, 0.27),
        Position = UDim2.fromScale(0.765, 0.18)
    })

    ShopUI.Text({
        Name = "Caption3",
        Text = "Buy 3",
        ZIndex = 5,
        Stroke = 2.5,
        Parent = p58,
        Size = UDim2.fromScale(0.215, 0.09),
        Position = UDim2.fromScale(0.765, 0.52)
    })
    buyButton(p58, p60, {
        Name = "Buy3",
        Size = UDim2.fromScale(0.215, 0.27),
        Position = UDim2.fromScale(0.765, 0.625)
    })

    return v94
end

local function buildNight(p61) -- line: 781
    -- upvalues: ShopUI (copy), t8 (ref)
    local v95 = ShopUI.Frame({
        Name = "Night",
        Transparency = 1,
        ZIndex = 2,
        Parent = p61
    })

    v95.ClipsDescendants = true

    local t42 = {
        Frame = v95,
        Stars = {},
        Bats = {},
        Embers = {}
    }
    local v96 = ShopUI.Frame({
        Name = "Horizon",
        Corner = 18,
        ZIndex = 2,
        Parent = v95,
        Size = UDim2.fromScale(1, 0.4),
        Position = UDim2.fromScale(0, 1),
        AnchorPoint = Vector2.new(0, 1),
        Color = Color3.fromRGB(255, 128, 30)
    })
    local UIGradient = Instance.new("UIGradient")

    UIGradient.Rotation = 90
    UIGradient.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 1),
        NumberSequenceKeypoint.new(1, 0.5)
    })
    UIGradient.Parent = v96

    local v97 = Random.new(31)

    for i = 1, 34 do
        local v98 = if i <= 12 then "Top"
            elseif i <= 20 then "Gap"
            elseif i % 2 == 0 then "Left"
            else "Right"
        local t43 = {
            Band = v98,
            U = v97:NextNumber(),
            V = v97:NextNumber(0.15, 0.85),
            Size = v97:NextNumber(0.6, 1),
            Phase = v97:NextNumber(0, 6.28),
            Speed = v97:NextNumber(1.2, 3),
            Frame = ShopUI.Frame({
                Name = "Star",
                ZIndex = 3,
                Parent = v95,
                AnchorPoint = Vector2.new(0.5, 0.5),
                Corner = UDim.new(0.5, 0)
            })
        }
        local Frame = t43.Frame
        local v99 = 0.0055 * t43.Size
        local v100 = 0.0055 * t43.Size

        Frame.SizeConstraint = Enum.SizeConstraint.RelativeXX
        Frame.Size = UDim2.fromScale(v99, v100)

        local v101, v102

        if v98 == "Top" then
            v101 = 0.035 + t43.U * 0.9299999999999999
            v102 = t43.V * 0.064
        elseif v98 == "Gap" then
            v101 = 0.035 + t43.U * 0.9299999999999999
            v102 = 0.42478431372549025 + t43.V * 0.046
        else
            v101 = if v98 == "Left" then t43.V * 0.04 else 1 - t43.V * 0.04
            v102 = 0.035 + t43.U * 0.9246732026143792 * 0.6
        end

        t43.Frame.Position = UDim2.fromScale(v101, v102 / 0.9246732026143792)
        table.insert(t42.Stars, t43)
    end

    t42.MoonGlow = ShopUI.Frame({
        Name = "MoonGlow",
        ZIndex = 3,
        Parent = v95,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Color = Color3.fromRGB(255, 236, 170),
        Corner = UDim.new(0.5, 0)
    })

    local MoonGlow = t42.MoonGlow

    MoonGlow.SizeConstraint = Enum.SizeConstraint.RelativeXX
    MoonGlow.Size = UDim2.fromScale(0.132096, 0.132096)
    t42.MoonGlow.Position = UDim2.fromScale(0.915968, 0.03460682099310832)

    local UIGradient2 = Instance.new("UIGradient")

    UIGradient2.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 1),
        NumberSequenceKeypoint.new(0.5, 0.5),
        NumberSequenceKeypoint.new(1, 1)
    })
    UIGradient2.Parent = t42.MoonGlow
    t42.Moon = ShopUI.Image({
        Name = "Moon",
        Image = "rbxassetid://137521571459207",
        ZIndex = 4,
        Parent = v95,
        AnchorPoint = Vector2.new(0.5, 0.5)
    })

    local Moon = t42.Moon

    Moon.SizeConstraint = Enum.SizeConstraint.RelativeXX
    Moon.Size = UDim2.fromScale(0.05504, 0.05504)
    t42.Moon.Position = UDim2.fromScale(0.915968, 0.03460682099310832)

    local t44 = {
        Top = 0.032,
        Gap = 0.44778431372549027
    }

    for v103, v104 in ipairs({
            {
                Lane = "Gap",
                Offset = 0.1,
                Speed = 0.06,
                Size = 1
            },
            {
                Lane = "Gap",
                Offset = 0.75,
                Speed = 0.045,
                Size = 0.75
            },
            {
                Lane = "Top",
                Offset = 0.4,
                Speed = 0.05,
                Size = 0.8
            }
        }) do
        v104.Frame = ShopUI.Image({
            Name = "Bat",
            Image = "rbxassetid://88939072892399",
            ZIndex = 5,
            Parent = v95,
            Color = Color3.fromRGB(14, 6, 22),
            AnchorPoint = Vector2.new(0.5, 0.5)
        })
        v104.Frame.ScaleType = Enum.ScaleType.Stretch
        v104.Frame.SizeConstraint = Enum.SizeConstraint.RelativeXX
        v104.Y = t44[v104.Lane]
        v104.Phase = v103 * 1.7
        table.insert(t42.Bats, v104)
    end

    for _ = 1, 14 do
        local v105 = ShopUI.Frame({
            Name = "Ember",
            ZIndex = 4,
            Parent = v95,
            AnchorPoint = Vector2.new(0.5, 0.5),
            Color = Color3.fromRGB(255, 170, 60),
            Corner = UDim.new(0.5, 0)
        })

        v105.SizeConstraint = Enum.SizeConstraint.RelativeXX
        v105.Size = UDim2.fromScale(0.005, 0.005)
        table.insert(t42.Embers, {
            Frame = v105,
            X = v97:NextNumber(0.03, 0.97),
            Age = v97:NextNumber(0, 4),
            Life = v97:NextNumber(3, 5),
            Drift = v97:NextNumber(-0.02, 0.02)
        })
    end

    t8 = t42

    return v95
end

local function animateNight(p62) -- line: 843
    -- upvalues: t8 (ref)
    local t46 = t8

    if not t46 then
        return
    end

    local elapsed = os.clock()

    for _, v106 in ipairs(t46.Stars) do
        v106.Frame.BackgroundTransparency = (math.sin(elapsed * v106.Speed + v106.Phase) * 0.5 + 0.5) * 0.75 + 0.1
    end

    for _, v108 in ipairs(t46.Bats) do
        local v109 = (elapsed * v108.Speed + v108.Offset) % 1.3 - 0.15
        local v111 = v108.Y + math.sin(elapsed * 1.6 + v108.Phase) * 0.05 * 0.18
        local v114 = math.abs((math.sin(elapsed * 7 + v108.Phase))) * 0.55 + 0.45
        local v115 = 0.05 * v108.Size

        v108.Frame.Size = UDim2.fromScale(v115, v115 / 1.6 * v114)
        v108.Frame.Position = UDim2.fromScale(v109, v111 / 0.9246732026143792)
        v108.Frame.Rotation = math.sin(elapsed * 2 + v108.Phase) * 8
    end

    for _, v117 in ipairs(t46.Embers) do
        v117.Age += p62

        if v117.Age >= v117.Life then
            v117.Age = 0
            v117.X = math.random() * 0.94 + 0.03
        end

        local v118 = v117.Age / v117.Life

        v117.Frame.Position = UDim2.fromScale(v117.X + math.sin(v118 * 6 + v117.Life) * 0.01 + v117.Drift * v118, 1.02 - v118 * 0.65)
        v117.Frame.BackgroundTransparency = 0.2 + v118 * 0.8
    end

    t46.MoonGlow.BackgroundTransparency = math.sin(elapsed * 1.4) * 0.2 + 0.3
    t46.Moon.Rotation = math.sin(elapsed * 0.7) * 4
end

local function boxHolder(p63, p64, p65, p66) -- line: 875
    -- upvalues: ShopUI (copy), t7 (copy)
    local v122 = ShopUI.Frame({
        Transparency = 1,
        ZIndex = 2,
        Parent = p63,
        Name = p64,
        Size = UDim2.fromScale(0.92, p66 / 0.9246732026143792),
        Position = UDim2.fromScale(0.04, p65 / 0.9246732026143792)
    })
    local UIScale = Instance.new("UIScale")

    UIScale.Name = "StaggerScale"
    UIScale.Parent = v122
    table.insert(t7, v122)

    return v122
end

local function buildPumpkin(p67) -- line: 884
    -- upvalues: MonetizationConfig (copy), ShopUI (copy), hoverLift (copy), wireCard (copy), t26 (copy), t27 (copy), t31 (copy), active (copy), card (copy), tag (copy), glowRings (copy), ofBestBlock (copy), animalViewport (copy), buyButton (copy), boxHolder (copy)
    local PumpkinMonster = MonetizationConfig.Products.PumpkinMonster
    local v123 = boxHolder(p67, "PumpkinMonster", 0.064, 0.36078431372549025)
    local v124 = card(v123, t26.Pumpkin, 20)

    ShopUI.Rays(v124, Color3.fromRGB(255, 236, 150), {
        ZIndex = 3,
        Count = 9,
        Alpha = 0.5,
        Speed = 18,
        Size = UDim2.fromScale(0.42, 0.96),
        Position = UDim2.fromScale(0.215, 0.5),
        Active = active
    })
    glowRings(v124, UDim2.fromScale(0.215, 0.5), UDim2.fromScale(0.36, 0.84), 3)
    animalViewport(v124, PumpkinMonster.Grant.Animals[1], {
        Name = "Monster",
        ZIndex = 4,
        Yaw = -0.4886921905584123,
        Pitch = 0.13962634015954636,
        Pad = 0.95,
        Sway = 0.17453292519943295,
        Clip = "Walk",
        Size = UDim2.fromScale(0.43, 1.02),
        Position = UDim2.fromScale(0.215, 0.49),
        AnchorPoint = Vector2.new(0.5, 0.5)
    })
    tag(v124, "BEST VALUE!", t27.Gold, {
        Size = UDim2.fromScale(0.2, 0.13),
        Position = UDim2.fromScale(0.015, 0.035)
    })
    ShopUI.Text({
        Name = "Name",
        ZIndex = 5,
        Stroke = 4,
        Parent = v124,
        Text = PumpkinMonster.Name,
        Size = UDim2.fromScale(0.54, 0.19),
        Position = UDim2.fromScale(0.44, 0.055),
        XAlign = Enum.TextXAlignment.Left,
        Gradient = {
            t31[1],
            t31[2],
            90
        }
    })
    ofBestBlock(v124, PumpkinMonster.Grant.OfBest, {
        Box = true,
        ValueHeight = 0.6,
        CaptionHeight = 0.24,
        ZIndex = 5,
        Size = UDim2.fromScale(0.54, 0.4),
        Position = UDim2.fromScale(0.44, 0.275)
    })
    wireCard(v124, (buyButton(v124, "PumpkinMonster", {
        Size = UDim2.fromScale(0.54, 0.22),
        Position = UDim2.fromScale(0.44, 0.72)
    })))
    hoverLift(v123)

    return v123
end

local function showChances() -- line: 902
    -- upvalues: EggsConfig (copy), RarityConfig (copy), ShopUI (copy), Sounds (copy), v1 (ref), v3 (ref), Clover (copy), t32 (copy), t34 (copy), well (copy), iconValue (copy), animalViewport (copy)
    if v3 then
        v3:Destroy()
    end

    local v125 = ShopUI.Frame({
        Name = "ChancesInfo",
        Transparency = 1,
        ZIndex = 50,
        Parent = v1
    })

    v3 = v125

    local v126 = ShopUI.Dim(v125, 50, 0.35)

    local function close() -- line: 907
        -- upvalues: v125 (copy), v126 (copy), ShopUI (copy), Sounds (copy), v3 (ref)
        if v3 ~= v125 then
            return
        end

        v3 = nil
        Sounds.Play("ShopClose")
        ShopUI.Tween(v126, {
            BackgroundTransparency = 1
        }, 0.18)

        local ChancesPanel = v125:FindFirstChild("ChancesPanel")

        if ChancesPanel then
            ShopUI.PopOut(ChancesPanel, 0.18, 0.7)
        end

        task.delay(0.2, function() -- line: 914
            -- upvalues: v125 (copy)
            v125:Destroy()
        end)
    end

    v126.Activated:Connect(close)

    local v127 = ShopUI.Panel({
        Name = "ChancesPanel",
        Ratio = 0.82,
        Title = "Chances",
        Color = "Pumpkin",
        HeaderHeight = 0.115,
        ZIndex = 51,
        Transparency = 0.06,
        Parent = v125,
        Size = UDim2.fromScale(0.4, 0.8),
        TitleIcon = Clover,
        OnClose = close
    })

    ShopUI.InputSink(v127.Root)

    local Content = v127.Content
    local v128 = EggsConfig.Odds("Halloween") or {}
    local v129 = ShopUI.Frame({
        Name = "Rows",
        Transparency = 1,
        ZIndex = 52,
        Parent = Content,
        Size = UDim2.fromScale(0.92, 0.76),
        Position = UDim2.fromScale(0.5, 0.035),
        AnchorPoint = Vector2.new(0.5, 0)
    })
    local UIListLayout = Instance.new("UIListLayout")

    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    UIListLayout.Padding = UDim.new(0.025, 0)
    UIListLayout.Parent = v129

    for v130, v131 in ipairs(v128) do
        local v132 = v130 == #v128
        local v133 = RarityConfig.Get(t32[v130] or "Common")
        local v134 = ShopUI.Frame({
            Transparency = 0.1,
            Corner = 12,
            ZIndex = 52,
            Parent = v129,
            Name = "Row" .. v130,
            Size = UDim2.fromScale(1, 0.145),
            Color = Color3.fromRGB(36, 36, 46)
        })

        v134.LayoutOrder = v130

        local Stroke = ShopUI.Stroke
        local v136 = if v132 then 3 else 2
        local v135 = if v132 then Color3.fromRGB(255, 216, 74) or ShopUI.Outline else ShopUI.Outline

        Stroke(v134, v136, v135)

        local v137 = well(v134, {
            ZIndex = 53,
            Size = UDim2.fromScale(0.9, 0.9),
            Position = UDim2.fromScale(0.012, 0.5),
            AnchorPoint = Vector2.new(0, 0.5),
            Gold = v132,
            Color = v133.Gradient.Keypoints[1].Value
        })

        v137.SizeConstraint = Enum.SizeConstraint.RelativeYY
        animalViewport(v137, v131.Animal, {
            ZIndex = 54,
            Yaw = -0.5235987755982988,
            Pitch = 0.17453292519943295,
            Still = true,
            Size = UDim2.fromScale(0.94, 0.94),
            Position = UDim2.fromScale(0.5, 0.5),
            AnchorPoint = Vector2.new(0.5, 0.5)
        })
        ShopUI.Text({
            Name = "Name",
            ZIndex = 54,
            Stroke = 3,
            Parent = v134,
            Text = t34[v131.Animal] or v131.Animal,
            Size = UDim2.fromScale(0.4, 0.5),
            Position = UDim2.fromScale(0.15, 0.5),
            AnchorPoint = Vector2.new(0, 0.5),
            XAlign = Enum.TextXAlignment.Left,
            Gradient = { v133.Gradient }
        })

        local v138 = ShopUI.Frame({
            Name = "Chance",
            Stroke = 2,
            ZIndex = 54,
            Parent = v134,
            Size = UDim2.fromScale(0.39, 0.56),
            Position = UDim2.fromScale(0.975, 0.5),
            AnchorPoint = Vector2.new(1, 0.5),
            Color = Color3.fromRGB(20, 20, 26),
            Corner = UDim.new(0.5, 0)
        })
        local CanvasGroup = Instance.new("CanvasGroup")

        CanvasGroup.Name = "Track"
        CanvasGroup.Size = UDim2.fromScale(1, 1)
        CanvasGroup.BackgroundTransparency = 1
        CanvasGroup.ZIndex = 55
        ShopUI.Corner(CanvasGroup, UDim.new(0.5, 0))
        CanvasGroup.Parent = v138

        local v139 = ShopUI.Frame({
            Name = "Fill",
            ZIndex = 55,
            Parent = CanvasGroup,
            Size = UDim2.fromScale(math.max(v131.Chance, 0.02), 1)
        })

        ShopUI.Gradient(v139, v133.Gradient, nil, 90)
        iconValue({
            Name = "Value",
            Stroke = 2.5,
            ZIndex = 56,
            Parent = v138,
            Icon = Clover,
            Text = EggsConfig.FormatChance(v131.Chance),
            Size = UDim2.fromScale(0.9, 0.86),
            Position = UDim2.fromScale(0.5, 0.5),
            AnchorPoint = Vector2.new(0.5, 0.5)
        })
    end

    ShopUI.Button({
        Name = "GotIt",
        Text = "GOT IT!",
        Color = "Green",
        ZIndex = 53,
        Parent = Content,
        Size = UDim2.fromScale(0.42, 0.11),
        Position = UDim2.fromScale(0.5, 0.965),
        AnchorPoint = Vector2.new(0.5, 1),
        OnClick = close
    })
    ShopUI.PopIn(v127.Root, 0.4, 0.6)
    Sounds.Play("Pop")
end

local function buildHalloweenEgg(p68) -- line: 956
    -- upvalues: MonetizationConfig (copy), EggsConfig (copy), ShopUI (copy), v4 (ref), hoverLift (copy), wireCard (copy), t26 (copy), t31 (copy), card (copy), glowRings (copy), well (copy), moneyTag (copy), animalViewport (copy), eggViewport (copy), eggButtons (copy), boxHolder (copy), showChances (copy)
    local Halloween = EggsConfig.Get("Halloween")
    local v140 = boxHolder(p68, "HalloweenEgg", 0.47078431372549023, 0.4088888888888889)
    local v141 = card(v140, t26.Egg, 20)

    glowRings(v141, UDim2.fromScale(0.135, 0.53), UDim2.fromScale(0.24, 0.7), 3)
    eggViewport(v141, "Halloween", {
        Name = "Egg",
        ZIndex = 4,
        Yaw = 0,
        Pitch = 0.17453292519943295,
        Pad = 1.25,
        Spin = 0.9,
        Bob = 0.15,
        Size = UDim2.fromScale(0.25, 0.78),
        Position = UDim2.fromScale(0.135, 0.53),
        AnchorPoint = Vector2.new(0.5, 0.5)
    })

    local TextButton = Instance.new("TextButton")

    TextButton.Name = "InfoButton"
    TextButton.Text = ""
    TextButton.AutoButtonColor = false
    TextButton.Size = UDim2.fromScale(0.07, 0.15)
    TextButton.Position = UDim2.fromScale(0.014, 0.04)
    TextButton.BackgroundColor3 = Color3.new(1, 1, 1)
    TextButton.BorderSizePixel = 0
    TextButton.ZIndex = 8
    ShopUI.Corner(TextButton, UDim.new(0.5, 0))
    ShopUI.Stroke(TextButton, 2)
    ShopUI.Gradient(TextButton, Color3.fromRGB(127, 212, 255), Color3.fromRGB(44, 140, 235), 90)
    Instance.new("UIAspectRatioConstraint").Parent = TextButton
    ShopUI.Text({
        Name = "Label",
        Text = "i",
        ZIndex = 9,
        Stroke = 2,
        Parent = TextButton,
        Size = UDim2.fromScale(0.7, 0.72),
        Position = UDim2.fromScale(0.5, 0.5),
        AnchorPoint = Vector2.new(0.5, 0.5)
    })
    TextButton.Parent = v141
    ShopUI.Juice(TextButton, TextButton, {
        HoverScale = 1.15
    })
    TextButton.Activated:Connect(function() -- line: 981
        -- upvalues: v4 (ref), showChances (copy)
        if v4 then
            showChances()
        end
    end)
    ShopUI.Text({
        Name = "Title",
        ZIndex = 5,
        Stroke = 4,
        Parent = v141,
        Text = Halloween.Name,
        Size = UDim2.fromScale(0.47, 0.15),
        Position = UDim2.fromScale(0.272, 0.045),
        XAlign = Enum.TextXAlignment.Left,
        Gradient = {
            t31[1],
            t31[2],
            90
        }
    })

    local n3 = 0

    for _, v142 in ipairs(Halloween.Pool) do
        n3 = math.max(n3, v142.OfBest or 0)
    end

    ShopUI.Text({
        Name = "UpTo",
        Rich = true,
        ZIndex = 5,
        Stroke = 2.5,
        Parent = v141,
        Text = "Up to <font color=\"#A8FF5E\">" .. MonetizationConfig.FormatOfBest(n3) .. "</font> of your best animal!",
        Size = UDim2.fromScale(0.47, 0.085),
        Position = UDim2.fromScale(0.272, 0.2),
        XAlign = Enum.TextXAlignment.Left
    })

    local v144 = ShopUI.Frame({
        Name = "Monsters",
        Transparency = 1,
        ZIndex = 4,
        Parent = v141,
        Size = UDim2.fromScale(0.475, 0.655),
        Position = UDim2.fromScale(0.272, 0.31)
    })

    for v145, v146 in ipairs(Halloween.Pool) do
        local v147 = (v145 - 1) % 3
        local v149 = math.floor((v145 - 1) / 3)
        local v150 = v145 == #Halloween.Pool
        local v151 = ShopUI.Frame({
            Transparency = 1,
            ZIndex = 4,
            Parent = v144,
            Name = "Monster" .. v145,
            Size = UDim2.fromScale(0.315, 0.47),
            Position = UDim2.fromScale(v147 * 0.3425, v149 * 0.53)
        })

        animalViewport(well(v151, {
            ZIndex = 4,
            Size = UDim2.fromScale(1, 0.84),
            Gold = v150
        }), v146.Animal, {
            ZIndex = 5,
            Yaw = -0.5235987755982988,
            Pitch = 0.17453292519943295,
            Pad = 0.98,
            Size = UDim2.fromScale(0.96, 0.96),
            Position = UDim2.fromScale(0.5, 0.5),
            AnchorPoint = Vector2.new(0.5, 0.5)
        })
        moneyTag(v151, v146.OfBest, {
            ZIndex = 6,
            Size = UDim2.fromScale(0.86, 0.32),
            Position = UDim2.fromScale(0.5, 1),
            AnchorPoint = Vector2.new(0.5, 1)
        })
    end

    wireCard(v141, (eggButtons(v141, "HalloweenEgg1", "HalloweenEgg3")))
    hoverLift(v140)

    return v140
end

local function buildHalloween() -- line: 1007
    -- upvalues: ShopUI (copy), Scroll (ref), rgb (copy), t28 (copy), t33 (copy), buildNight (copy), buildPumpkin (copy), buildHalloweenEgg (copy)
    local t49 = {
        Name = "HalloweenTitle",
        Text = "Halloween Limited",
        LayoutOrder = -2,
        Parent = Scroll
    }

    for v153, v154 in pairs(t33) do
        t49[v153] = v154
    end

    ShopUI.SectionTitle(t49)

    local v155 = ShopUI.Frame({
        Name = "Halloween",
        Corner = 18,
        Ratio = 1.0814631560346348,
        Parent = Scroll,
        Size = UDim2.new(1, 0, 0, 1E+05),
        Color = Color3.new(1, 1, 1)
    })

    v155.LayoutOrder = -1
    ShopUI.Gradient(v155, t28[1], t28[2], 90)
    ShopUI.Stroke(v155, 3, rgb(255, 140, 40))
    buildNight(v155)

    local v156 = ShopUI.Frame({
        Name = "Content",
        Transparency = 1,
        ZIndex = 3,
        Parent = v155
    })

    buildPumpkin(v156)
    buildHalloweenEgg(v156)
end

local function animalCard(p69, p70, p71, p72, p73, p74) -- line: 1023
    -- upvalues: MonetizationConfig (copy), ShopUI (copy), hoverLift (copy), wireCard (copy), t31 (copy), card (copy), tag (copy), well (copy), ofBestBlock (copy), animalViewport (copy), buyButton (copy)
    local v157 = MonetizationConfig.Products[p70]
    local v158 = ShopUI.Frame({
        Transparency = 1,
        ZIndex = 2,
        Parent = p69,
        Name = p70,
        Size = UDim2.fromScale(0.485, 1),
        Position = UDim2.fromScale(p74 and 0 or 1, 0),
        AnchorPoint = Vector2.new(p74 and 0 or 1, 0)
    })
    local v159 = card(v158, p71, 25)

    animalViewport(well(v159, {
        ZIndex = 3,
        Size = UDim2.fromScale(0.43, 0.86),
        Position = UDim2.fromScale(0.53, 0.07)
    }), v157.Grant.Animals[1], {
        ZIndex = 4,
        Yaw = -0.5585053606381855,
        Pitch = 0.17453292519943295,
        Sway = 0.24434609527920614,
        Clip = "Walk",
        Size = UDim2.fromScale(0.96, 0.96),
        Position = UDim2.fromScale(0.5, 0.5),
        AnchorPoint = Vector2.new(0.5, 0.5),
        Phase = p74 and 0 or 2
    })
    tag(v159, p72, p73, {
        Rotation = -3,
        Size = UDim2.fromScale(0.38, 0.13),
        Position = UDim2.fromScale(0.04, 0.055)
    })
    ShopUI.Text({
        Name = "Name",
        ZIndex = 5,
        Stroke = 3.5,
        Parent = v159,
        Text = v157.Name,
        Size = UDim2.fromScale(0.47, 0.15),
        Position = UDim2.fromScale(0.045, 0.215),
        XAlign = Enum.TextXAlignment.Left,
        Gradient = {
            t31[1],
            t31[2],
            90
        }
    })
    ofBestBlock(v159, v157.Grant.OfBest, {
        Align = "Left",
        ValueHeight = 0.66,
        CaptionHeight = 0.27,
        ZIndex = 5,
        Size = UDim2.fromScale(0.47, 0.27),
        Position = UDim2.fromScale(0.045, 0.385)
    })
    wireCard(v159, (buyButton(v159, p70, {
        Size = UDim2.fromScale(0.45, 0.22),
        Position = UDim2.fromScale(0.045, 0.7)
    })))
    hoverLift(v158)

    return v158
end

local function buildFeaturedAnimals(p75) -- line: 1039
    -- upvalues: ShopUI (copy), Scroll (ref), t26 (copy), t27 (copy), animalCard (copy)
    local v162 = ShopUI.Frame({
        Name = "Animals",
        Transparency = 1,
        Ratio = 3.1,
        Parent = Scroll,
        Size = UDim2.fromScale(1, 0)
    })

    v162.LayoutOrder = p75
    animalCard(v162, "GiantSquid", t26.Squid, "SUPER DEAL!", t27.Purple, true)
    animalCard(v162, "WoollyMammoth", t26.Mammoth, "CHEAP!", t27.Green, false)
end

local Power = ShopUI.Icons.Power
local Icon = MonetizationConfig.SuperThrow and MonetizationConfig.SuperThrow.Icon or Clover
local t52 = {
    "Money",
    "Power",
    "Lucky"
}
local t53 = {
    Money = {
        Color3.fromRGB(150, 236, 104),
        Color3.fromRGB(62, 182, 72),
        rgb(26, 112, 64)
    },
    Power = {
        Color3.fromRGB(255, 232, 110),
        Color3.fromRGB(255, 176, 34),
        rgb(230, 108, 20)
    },
    Lucky = {
        Color3.fromRGB(214, 160, 255),
        Color3.fromRGB(140, 70, 236),
        rgb(78, 30, 146)
    }
}
local t54 = {
    nil,
    t27.Green,
    t27.Purple,
    t27.Gold
}
local t55 = {
    Lucky = {
        t27.Green,
        t27.Blue,
        t27.Gold,
        t27.Gold
    }
}
local t56 = {
    nil,
    nil,
    Color3.fromRGB(255, 255, 255),
    rgb(255, 236, 150)
}
local v163 = Color3.fromRGB(255, 255, 255)
local v164 = #t52 * 0.2865853658536585 + 0.026 + (#t52 - 1) * 0.05 + 0.014
local t57 = {}
local t58 = {}

local function basePrice(p76) -- line: 1077
    -- upvalues: RobuxPrices (copy)
    return RobuxPrices.GetBase(p76.Id, Enum.InfoType.Product, p76.Price)
end

local function packAmountText(p77) -- line: 1083
    -- upvalues: MonetizationConfig (copy), NumberFormat (copy), LocalPlayer (copy), t57 (copy)
    if t57[p77].Kind == "Money" then
        return "+" .. NumberFormat.Money(MonetizationConfig.PackMoney(p77, LocalPlayer:GetAttribute("IncomeRate")))
    end

    return "+" .. NumberFormat.Abbreviate(MonetizationConfig.PackAmount(p77))
end

local function refreshPacks() -- line: 1093
    -- upvalues: MonetizationConfig (copy), LevelConfig (copy), DataController (copy), ShopUI (copy), t1 (copy), t57 (copy), basePrice (copy), packAmountText (copy)
    local v165 = LevelConfig.PowerRoom(DataController:Get("Level") or 1)

    for v166, v167 in pairs(t57) do
        v167.Amount.Text = packAmountText(v166)

        if v167.Tag then
            local v168 = MonetizationConfig.PackBonus(v166, basePrice)

            v167.Tag.Visible = v168 > 0
            v167.TagLabel.Text = "+" .. v168 .. "% VALUE"
        end

        if v167.Kind == "Power" then
            local Entry = v167.Entry
            local v169 = v165 < v167.Product.Grant.Power

            if v169 ~= (Entry.Owned == true) then
                Entry.Owned = v169
                ShopUI.SetButtonColor(Entry.Holder, v169 and "Gray" or "Green")

                if Entry.RobuxIcon then
                    Entry.RobuxIcon.Visible = not v169
                end

                Entry.Juice:SetEnabled(not v169)

                if not v169 then
                    t1.RefreshPrices()
                end
            end

            if v169 and Entry.PriceLabel then
                Entry.PriceLabel.Text = "MAX"
            end
        end
    end
end

local function packCard(p78, p79, p80, p81, p82, p83) -- line: 1117
    -- upvalues: MonetizationConfig (copy), ShopUI (copy), hoverLift (copy), wireCard (copy), Money (copy), t31 (copy), active (copy), card (copy), tag (copy), glowRings (copy), iconValue (copy), buyButton (copy), Power (copy), Icon (copy), t53 (copy), t54 (copy), t55 (copy), t56 (copy), v164 (copy), t57 (copy), t58 (copy)
    local v170 = MonetizationConfig.Products[p79]
    local v171 = ShopUI.Frame({
        Transparency = 1,
        ZIndex = 2,
        Parent = p78,
        Name = p79,
        Size = UDim2.fromScale(0.235, 0.2865853658536585 / v164),
        Position = UDim2.fromScale(p82, p83 / v164)
    })
    local UIScale = Instance.new("UIScale")

    UIScale.Name = "StaggerScale"
    UIScale.Parent = v171
    table.insert(t58, v171)

    local v172 = card(v171, t53[p80], 20)

    if t56[p81] then
        ShopUI.Rays(v172, t56[p81], {
            ZIndex = 3,
            Count = 9,
            Speed = 18,
            Size = UDim2.fromScale(0.95, 0.66),
            Position = UDim2.fromScale(0.5, 0.38),
            Alpha = p81 == 4 and 0.5 or 0.62,
            Active = active
        })
    end

    glowRings(v172, UDim2.fromScale(0.5, 0.38), UDim2.fromScale(0.86, 0.56), 3)
    ShopUI.Image({
        Name = "Icon",
        ZIndex = 4,
        Parent = v172,
        Image = v170.Icon,
        Size = UDim2.fromScale(0.96, 0.6),
        Position = UDim2.fromScale(0.5, 0.38),
        AnchorPoint = Vector2.new(0.5, 0.5)
    })

    local t60 = {
        Name = "Amount",
        Text = "",
        Stroke = 3.5,
        ZIndex = 5,
        Parent = v172
    }
    local v174 = if p80 == "Money" and Money then Money elseif p80 == "Lucky" and Icon then Icon else Power

    t60.Icon = v174
    t60.Colors = t31
    t60.IconScale = if p80 == "Lucky" then 1.5 else nil
    t60.Size = UDim2.fromScale(0.9, 0.12)
    t60.Position = UDim2.fromScale(0.5, 0.735)
    t60.AnchorPoint = Vector2.new(0.5, 0.5)

    local _, v175 = iconValue(t60)
    local v176 = buyButton(v172, p79, {
        Size = UDim2.fromScale(0.84, 0.15),
        Position = UDim2.fromScale(0.5, 0.815),
        AnchorPoint = Vector2.new(0.5, 0)
    })
    local t61 = {
        Kind = p80,
        Product = v170,
        Entry = v176,
        Card = v172,
        Holder = v171,
        Amount = v175
    }
    local v177 = (t55[p80] or t54)[p81]

    if v177 then
        local v178, v179 = tag(v172, "", v177, {
            Rotation = -3,
            ZIndex = 8,
            Size = UDim2.fromScale(0.88, 0.1),
            Position = UDim2.fromScale(0.5, 0.01),
            AnchorPoint = Vector2.new(0.5, 0.5)
        })

        t61.Tag = v178
        t61.TagLabel = v179
    end

    t57[p79] = t61
    wireCard(v172, v176, {
        CanUse = function() -- CanUse | line: 1142
            -- upvalues: v176 (copy)
            return not v176.Owned
        end
    })
    hoverLift(v171)

    return v171
end

local function buildPacks(p84) -- line: 1148
    -- upvalues: MonetizationConfig (copy), ShopUI (copy), Scroll (ref), t52 (copy), v164 (copy), refreshPacks (copy), packCard (copy)
    ShopUI.SectionTitle({
        Name = "PacksTitle",
        Text = "Packs",
        Parent = Scroll,
        LayoutOrder = p84
    })

    local v180 = ShopUI.Frame({
        Name = "Packs",
        Transparency = 1,
        Parent = Scroll,
        Size = UDim2.new(1, 0, 0, 1E+05),
        Ratio = 1 / v164
    })

    v180.LayoutOrder = p84 + 1

    for v181, v182 in ipairs(t52) do
        local v183 = 0.026 + (v181 - 1) * 0.3365853658536585

        for v184, v185 in ipairs(MonetizationConfig.Packs[v182]) do
            packCard(v180, v185, v182, v184, (v184 - 1) * 0.255, v183)
        end
    end

    refreshPacks()
end

function highlightPack(p85, p86) -- line: 1166
    -- upvalues: ShopUI (copy), UIScaler (copy), t1 (copy), v4 (ref), t9 (ref), v163 (copy), t57 (copy)
    local v186 = t57[p85]

    if not v186 then
        return
    end

    if p86 then
        if v186.Kind == "Money" then
            t1.ScrollTo("PacksTitle")
        else
            t1.ScrollTo(v186.Holder, 30)
        end
    end

    local UIStroke = v186.Card:FindFirstChildOfClass("UIStroke")

    ShopUI.Punch(v186.Holder, 0.12, 0.6)

    if not UIStroke then
        return
    end

    local Color = UIStroke.Color
    local v187 = UIScaler.Base(UIStroke, "Thickness") or 3

    task.spawn(function() -- line: 1181
        -- upvalues: v186 (copy), UIStroke (copy), Color (copy), v187 (copy), ShopUI (copy), v4 (ref), t9 (ref), v163 (copy)
        for _ = 1, 3 do
            if not v4 then
                break
            end

            ShopUI.Tween(UIStroke, {
                Color = v163,
                Thickness = v187 * 2
            }, 0.18)
            task.wait(0.42)
            ShopUI.Tween(UIStroke, {
                Color = Color,
                Thickness = v187
            }, 0.18)
            task.wait(0.3)
        end

        if not t9 or t9.Card ~= v186.Card then
            ShopUI.Tween(UIStroke, {
                Color = Color,
                Thickness = v187
            }, 0.2)
        end
    end)
end

local function animateAnimal(p87, p88) -- line: 1198
    -- upvalues: AnimationLibrary (copy), v4 (ref)
    local Model = p87.Model

    if Model.Parent then
        if p88 then
            task.spawn(function() -- line: 1205
                -- upvalues: p87 (copy), Model (copy), AnimationLibrary (copy), v4 (ref)
                local function v188() -- line: 1206
                    -- upvalues: p87 (copy), Model (copy), AnimationLibrary (copy), v4 (ref)
                    AnimationLibrary.EnsureAnimalClips(Model:GetAttribute("AnimalName") or Model.Name)

                    if v4 and Model.Parent then
                        AnimationLibrary.PlayAnimal(Model, p87.Clip or "Idle")
                    end
                end

                pcall(v188)
            end)
        else
            local StopAll = AnimationLibrary.StopAll

            pcall(StopAll, Model, 0)
        end
    end
end

function playAnimals(p89) -- line: 1213
    -- upvalues: t6 (copy), animateAnimal (copy)
    for _, v189 in ipairs(t6) do
        animateAnimal(v189, p89)
    end
end

local function setupEggIcon(p90, p91) -- line: 1219
    -- upvalues: CollectionService (copy), EggsConfig (copy), t5 (copy)
    local Icon = p90 and p90:FindFirstChild("Icon")
    local WorldModel = Icon and Icon:FindFirstChildOfClass("WorldModel")
    local Model = WorldModel and WorldModel:FindFirstChildOfClass("Model") or Icon and Icon:FindFirstChildOfClass("Model")

    if not Model then
        return
    end

    local BoundingBox = Model:GetBoundingBox()
    local v190 = EggsConfig.Get(p91)

    if v190 and (v190.ScrollSpeed or 0) > 0 then
        for _, descendant in ipairs(Model:GetDescendants()) do
            if descendant:IsA("Texture") then
                descendant:SetAttribute("ScrollV", descendant.StudsPerTileV * v190.ScrollSpeed)
                CollectionService:AddTag(descendant, "ScrollingTexture")
            end
        end
    end

    table.insert(t5, {
        Model = Model,
        Center = BoundingBox.Position,
        BasePivot = Model:GetPivot(),
        Phase = #t5 * 1.3,
        Size = Model:GetExtentsSize().Y
    })
end

local function restoreCameras() -- line: 1237
    -- upvalues: ShopUI (copy), v1 (ref)
    for _, descendant in ipairs(v1:GetDescendants()) do
        if descendant:IsA("ViewportFrame") and not descendant:FindFirstChildOfClass("WorldModel") then
            local WorldModel = Instance.new("WorldModel")

            for _, child in ipairs(descendant:GetChildren()) do
                if child:IsA("Model") then
                    child.Parent = WorldModel
                end
            end

            WorldModel.Parent = descendant
        end

        if descendant:IsA("ViewportFrame") and not descendant.CurrentCamera then
            local v191 = descendant:FindFirstChildOfClass("Camera") or Instance.new("Camera")

            v191.FieldOfView = descendant:GetAttribute("CamFov") or 30
            v191.Parent = descendant
            descendant.CurrentCamera = v191

            local CamCFrame = descendant:GetAttribute("CamCFrame")
            local WorldModel = descendant:FindFirstChildOfClass("WorldModel")
            local Model = WorldModel and WorldModel:FindFirstChildOfClass("Model") or descendant:FindFirstChildOfClass("Model")

            if CamCFrame then
                v191.CFrame = CamCFrame
            elseif Model then
                local function fit() -- line: 1257
                    -- upvalues: descendant (copy), Model (copy), ShopUI (copy)
                    ShopUI.FitCamera(descendant, Model, math.rad(descendant:GetAttribute("Yaw") or -30), math.rad(descendant:GetAttribute("Pitch") or 12), descendant:GetAttribute("Pad") or 1)
                end

                fit()
                descendant:GetPropertyChangedSignal("AbsoluteSize"):Connect(fit)
            end
        end
    end
end

local function preloadContent() -- line: 1270
    -- upvalues: ContentProvider (copy), ShopUI (copy), v1 (ref)
    local elapsed = os.clock()
    local t64 = {
        v1,
        ShopUI.RobuxIcon
    }

    for _, v195 in pairs(ShopUI.Icons) do
        if type(v195) == "string" and v195 ~= "" then
            table.insert(t64, v195)
        end
    end

    local function v196() -- line: 1276
        -- upvalues: t64 (copy), ContentProvider (copy)
        ContentProvider:PreloadAsync(t64)
    end

    pcall(v196)
    v1:SetAttribute("PreloadSeconds", math.floor((os.clock() - elapsed) * 100 + 0.5) / 100)
end

local function build() -- line: 1280
    -- upvalues: MonetizationConfig (copy), Remotes (copy), DataController (copy), ShopUI (copy), UIScaler (copy), Sounds (copy), t1 (copy), LocalPlayer (copy), v1 (ref), Main (ref), Panel (ref), Scroll (ref), v4 (ref), t4 (copy), v5 (ref), t7 (copy), v7 (ref), v8 (ref), UIScale (ref), find (copy), refreshOwned (copy), refreshFree (copy), refreshLuck (copy), showLuckInfo (copy), wireButton (copy), hoverLift (copy), wireCard (copy), buildHalloween (copy), buildFeaturedAnimals (copy), t58 (copy), buildPacks (copy), setupEggIcon (copy), restoreCameras (copy)
    v1.DisplayOrder = 15
    restoreCameras()
    Main = v1:WaitForChild("Main")
    UIScaler.FitWindow(Main)
    Panel = Main:WaitForChild("Panel")
    Scroll = Panel:WaitForChild("Body"):WaitForChild("Scroll")
    Main.ZIndex = 2

    local TextButton = Instance.new("TextButton")

    TextButton.Name = "InputSink"
    TextButton.Text = ""
    TextButton.AutoButtonColor = false
    TextButton.Selectable = false
    TextButton.BackgroundTransparency = 1
    TextButton.Size = UDim2.fromScale(1, 1)
    TextButton.ZIndex = 0
    TextButton.Parent = Main
    v7, v8 = ShopUI.Pill({
        Name = "ClickAgainHint",
        Text = "CLICK AGAIN TO BUY!",
        ZIndex = 40,
        Stroke = 3,
        Parent = v1,
        Size = UDim2.fromScale(0.36, 0.066),
        AnchorPoint = Vector2.new(0.5, 1),
        Gradient = {
            Color3.fromRGB(255, 218, 80),
            Color3.fromRGB(255, 150, 30),
            90
        }
    })
    v7.Visible = false

    local UIAspectRatioConstraint = Instance.new("UIAspectRatioConstraint")

    UIAspectRatioConstraint.AspectRatio = 5.2
    UIAspectRatioConstraint.Parent = v7
    UIScale = Instance.new("UIScale")
    UIScale.Name = "HintScale"
    UIScale.Parent = v7

    local v199 = find(Panel, "Header.CloseButton")

    if v199 then
        ShopUI.Juice(v199, v199:FindFirstChild("Button"))
        v199.Button.Activated:Connect(function() -- line: 1314
            -- upvalues: t1 (copy)
            t1.Close()
        end)
    end

    buildHalloween()

    local v200 = find(Scroll, "RainbowEgg.Card")
    local RainbowEgg1 = wireButton(find(v200, "Buy1.BuyButton"), "RainbowEgg1")

    wireButton(find(v200, "Buy3.BuyButton"), "RainbowEgg3")
    wireCard(v200, RainbowEgg1)
    setupEggIcon(v200, "Rainbow")
    v5 = find(Scroll, "ServerLuck.Card")
    wireCard(v5, wireButton(find(v5, "BuyButton"), "ServerLuck"))

    local InfoButton = v5 and v5:FindFirstChild("InfoButton")

    if InfoButton then
        ShopUI.Juice(InfoButton, InfoButton, {
            HoverScale = 1.15
        })
        InfoButton.Activated:Connect(showLuckInfo)
    end

    workspace:GetAttributeChangedSignal("ServerLuck"):Connect(function() -- line: 1335
        -- upvalues: ShopUI (copy), t1 (copy), v4 (ref), v5 (ref), refreshLuck (copy)
        refreshLuck()
        t1.RefreshPrices()

        if not (v4 and v5) then
            return
        end

        ShopUI.Punch(v5:FindFirstChild("Boost") or v5, 0.25, 0.5)
    end)
    workspace:GetAttributeChangedSignal("ServerLuckEnd"):Connect(refreshLuck)
    buildPacks((Scroll:FindFirstChild("ServerLuck") and Scroll.ServerLuck.LayoutOrder or 4) + 1)

    for v201, v202 in pairs({
            DoubleCash = "DoubleCash",
            DoubleThrow = "DoubleXp"
        }) do
        local v203 = wireButton(find(Scroll, "Gamepasses." .. v201 .. ".Card.BuyButton"), v202)

        wireCard(find(Scroll, "Gamepasses." .. v201 .. ".Card"), v203, {
            CanUse = function() -- CanUse | line: 1349
                -- upvalues: v203 (copy)
                return v203 ~= nil and not v203.Owned
            end
        })
    end

    for v205 in pairs(MonetizationConfig.Passes) do
        LocalPlayer:GetAttributeChangedSignal("Pass_" .. v205):Connect(refreshOwned)
    end

    local AnimalsTitle = Scroll:FindFirstChild("AnimalsTitle")

    buildFeaturedAnimals((AnimalsTitle and AnimalsTitle.LayoutOrder or 8) + 1)

    local v206 = find(Scroll, "FreeAnimal.FreeCard.Card")
    local ClaimButton = v206 and v206:FindFirstChild("ClaimButton")

    if ClaimButton then
        ShopUI.Juice(ClaimButton, ClaimButton:FindFirstChild("Button"))

        local v207 = false

        local function claimFree() -- line: 1366
            -- upvalues: v207 (ref), Remotes (copy), Sounds (copy), v4 (ref), refreshFree (copy)
            if v4 and not v207 then
                v207 = true

                local Shop_ClaimFree = Remotes.Invoke("Shop_ClaimFree")

                v207 = false

                if not Shop_ClaimFree.Ok then
                    Sounds.Play("PurchaseFail", {
                        Volume = 0.4
                    })
                end

                refreshFree()
            end
        end

        ClaimButton.Button.Activated:Connect(claimFree)
        wireCard(v206, {
            Holder = ClaimButton,
            Use = claimFree
        }, {
            Hint = "CLICK AGAIN TO CLAIM!",
            CanUse = function() -- CanUse | line: 1379
                -- upvalues: DataController (copy)
                return DataController:Get("FreeAnimalClaimed") ~= true
            end
        })
    end

    DataController:Observe("FreeAnimalClaimed", refreshFree)

    local GiftButton = Main:FindFirstChild("GiftButton")

    if GiftButton then
        ShopUI.Juice(GiftButton, GiftButton:FindFirstChild("Button"), {
            HoverScale = 1.06
        })
        GiftButton.Button.Activated:Connect(function() -- line: 1388
            -- upvalues: t1 (copy), v4 (ref)
            if v4 then
                t1.GiftRequested:Fire()
            end
        end)
    end

    for _, v208 in ipairs({ "RainbowEgg", "ServerLuck" }) do
        hoverLift(Scroll:FindFirstChild(v208))
    end

    local Gamepasses = Scroll:FindFirstChild("Gamepasses")

    if Gamepasses then
        for _, child in ipairs(Gamepasses:GetChildren()) do
            if child:IsA("Frame") then
                hoverLift(child)
            end
        end
    end

    hoverLift((find(Scroll, "FreeAnimal.FreeCard")))

    local t66 = {}

    for _, child in ipairs(Scroll:GetChildren()) do
        if child:IsA("GuiObject") and child.Name ~= "BottomSpacer" then
            table.insert(t66, child)
        end
    end

    table.sort(t66, function(p92, p93) -- line: 1410
        return p92.LayoutOrder < p93.LayoutOrder
    end)

    for _, v209 in ipairs(t66) do
        local UIScale = Instance.new("UIScale")

        UIScale.Name = "StaggerScale"
        UIScale.Parent = v209
        table.insert(t4, v209)

        if v209.Name == "Halloween" then
            for _, v210 in ipairs(t7) do
                table.insert(t4, v210)
            end
        elseif v209.Name == "Packs" then
            for _, v211 in ipairs(t58) do
                table.insert(t4, v211)
            end
        end
    end

    refreshOwned()
    refreshFree()
    refreshLuck()
end

local function setupFreeTag() -- line: 1435
    -- upvalues: RunService (copy), MonetizationConfig (copy), DataController (copy), ShopUI (copy), Sounds (copy), ClientState (copy), HUDController (copy)
    local ShopButton = HUDController.ShopButton

    if not ShopButton then
        return
    end

    local v212 = MonetizationConfig.FreeAnimalTag or {
        AfterThrows = 4,
        Delay = 10
    }
    local v213 = Color3.fromRGB(20, 20, 26)
    local Frame = Instance.new("Frame")

    Frame.Name = "FreeTag"
    Frame.Size = UDim2.fromScale(0.66, 0.26)
    Frame.Position = UDim2.fromScale(0.86, 0.05)
    Frame.AnchorPoint = Vector2.new(0.5, 0.5)
    Frame.Rotation = 10
    Frame.BackgroundColor3 = Color3.new(1, 1, 1)
    Frame.BorderSizePixel = 0
    Frame.ZIndex = 10
    Frame.Visible = false

    local UICorner = Instance.new("UICorner")

    UICorner.CornerRadius = UDim.new(0.5, 0)
    UICorner.Parent = Frame

    local UIStroke = Instance.new("UIStroke")

    UIStroke.Thickness = 2
    UIStroke.Color = v213
    UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    UIStroke.Parent = Frame

    local UIGradient = Instance.new("UIGradient")

    UIGradient.Color = ColorSequence.new(Color3.fromRGB(152, 246, 72), Color3.fromRGB(98, 204, 34))
    UIGradient.Rotation = 90
    UIGradient.Parent = Frame

    local UIAspectRatioConstraint = Instance.new("UIAspectRatioConstraint")

    UIAspectRatioConstraint.AspectRatio = 2.5
    UIAspectRatioConstraint.Parent = Frame

    local TextLabel = Instance.new("TextLabel")

    TextLabel.Name = "Label"
    TextLabel.BackgroundTransparency = 1
    TextLabel.Size = UDim2.fromScale(0.8, 0.74)
    TextLabel.Position = UDim2.fromScale(0.5, 0.5)
    TextLabel.AnchorPoint = Vector2.new(0.5, 0.5)
    TextLabel.FontFace = Font.new("rbxasset://fonts/families/FredokaOne.json")
    TextLabel.Text = "FREE"
    TextLabel.TextScaled = true
    TextLabel.TextColor3 = Color3.new(1, 1, 1)
    TextLabel.ZIndex = 11

    local UIStroke2 = Instance.new("UIStroke")

    UIStroke2.Thickness = 2
    UIStroke2.Color = v213
    UIStroke2.Parent = TextLabel
    TextLabel.Parent = Frame

    local UIScale = Instance.new("UIScale")

    UIScale.Parent = Frame
    Frame.Parent = ShopButton

    local v214
    local v215 = true

    DataController:Observe("Throws", function(p94) -- line: 1491
        -- upvalues: v214 (ref), v215 (ref), v212 (copy)
        if not v214 and (tonumber(p94) or 0) >= v212.AfterThrows then
            local v216 = v215 and os.clock() or os.clock() + v212.Delay

            v214 = v216
        end

        v215 = false
    end)

    local v217 = false

    RunService.Heartbeat:Connect(function() -- line: 1499
        -- upvalues: Frame (copy), UIScale (copy), v214 (ref), v217 (ref), DataController (copy), ShopUI (copy), Sounds (copy), ClientState (copy), HUDController (copy)
        local v218 = v214 ~= nil and os.clock() >= v214 and DataController:Get("FreeAnimalClaimed") ~= true

        if v218 ~= v217 then
            if v218 then
                if not (ClientState.Busy or HUDController.IsGameplayHidden()) then
                    v217 = true
                    Frame.Visible = true
                    UIScale.Scale = 0.2
                    ShopUI.Tween(UIScale, {
                        Scale = 1
                    }, 0.45, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
                    Sounds.Play("Pop", {
                        Volume = 0.45
                    })
                end
            else
                v217 = false
                ShopUI.Tween(UIScale, {
                    Scale = 0
                }, 0.2, Enum.EasingStyle.Back, Enum.EasingDirection.In).Completed:Once(function() -- line: 1512
                    -- upvalues: Frame (copy), v217 (ref)
                    if not v217 then
                        Frame.Visible = false
                    end
                end)
            end
        end
    end)
    task.spawn(function() -- line: 1519
        -- upvalues: Frame (copy), v217 (ref), ShopUI (copy)
        while Frame.Parent do
            task.wait(2.6)

            if v217 then
                ShopUI.Tween(Frame, {
                    Rotation = 18
                }, 0.09, Enum.EasingStyle.Sine)
                task.wait(0.09)
                ShopUI.Tween(Frame, {
                    Rotation = 10
                }, 0.5, Enum.EasingStyle.Elastic)
            end
        end
    end)
end

local function animate(p95) -- line: 1532
    -- upvalues: v4 (ref), t5 (copy), animateNight (copy)
    if v4 then
        animateNight(p95)

        local elapsed = os.clock()

        for _, v219 in ipairs(t5) do
            if v219.Model.Parent then
                local v220 = elapsed * 0.9 + v219.Phase
                local v222 = math.sin(elapsed * 2 + v219.Phase) * v219.Size * 0.025
                local Center = v219.Center

                v219.Model:PivotTo(CFrame.new(Center + Vector3.new(0, v222, 0)) * CFrame.Angles(0, v220, 0) * CFrame.new(-Center) * v219.BasePivot)
            end
        end
    end
end

function t1.Init() -- line: 1546
    -- upvalues: RunService (copy), DataController (copy), ShopUI (copy), ClientState (copy), RobuxPrices (copy), HUDController (copy), t1 (copy), LocalPlayer (copy), PlayerGui (copy), v1 (ref), Scroll (ref), v4 (ref), refreshLuck (copy), refreshPacks (copy), preloadContent (copy), build (copy), setupFreeTag (copy), animate (copy)
    task.spawn(function() -- line: 1547
        -- upvalues: DataController (copy), ShopUI (copy), RobuxPrices (copy), t1 (copy), LocalPlayer (copy), PlayerGui (copy), v1 (ref), Scroll (ref), v4 (ref), refreshPacks (copy), preloadContent (copy), build (copy)
        v1 = PlayerGui:WaitForChild("ExclusiveShop", 30)

        if not v1 then
            warn("[ExclusiveShopController] ExclusiveShop gui missing")

            return
        end

        v1.Enabled = false
        build()
        task.spawn(preloadContent)
        RobuxPrices.Changed:Connect(t1.RefreshPrices)
        RobuxPrices.Changed:Connect(refreshPacks)
        LocalPlayer:GetAttributeChangedSignal("IncomeRate"):Connect(refreshPacks)
        DataController:Observe("Level", refreshPacks)
        task.spawn(function() -- line: 1562
            -- upvalues: ShopUI (copy), v1 (ref), Scroll (ref), v4 (ref)
            local t67 = {}

            for _, descendant in ipairs(Scroll:GetDescendants()) do
                if descendant.Name == "LimitedTag" or descendant.Name == "ValueTag" or descendant.Name == "DealTag" or descendant.Name == "OpTag" then
                    table.insert(t67, {
                        Frame = descendant,
                        Rotation = descendant.Rotation
                    })
                end
            end

            while v1.Parent do
                task.wait(2.6)

                if v4 then
                    for v223, v224 in ipairs(t67) do
                        task.delay(v223 * 0.05, function() -- line: 1573
                            -- upvalues: v224 (copy), ShopUI (copy)
                            ShopUI.Tween(v224.Frame, {
                                Rotation = v224.Rotation + 6
                            }, 0.09, Enum.EasingStyle.Sine)
                            task.wait(0.09)
                            ShopUI.Tween(v224.Frame, {
                                Rotation = v224.Rotation
                            }, 0.5, Enum.EasingStyle.Elastic)
                        end)
                    end
                end
            end
        end)
    end)
    HUDController.ShopRequested:Connect(t1.Toggle)
    setupFreeTag()
    RunService.RenderStepped:Connect(animate)

    local n4 = 0

    RunService.Heartbeat:Connect(function(p96) -- line: 1588
        -- upvalues: n4 (ref), ClientState (copy), t1 (copy), v4 (ref), refreshLuck (copy)
        if v4 and ClientState.Busy then
            t1.Close()
        end

        n4 += p96

        if n4 >= 0.5 then
            n4 = 0

            if v4 then
                refreshLuck()
            end
        end
    end)
end

return t1
