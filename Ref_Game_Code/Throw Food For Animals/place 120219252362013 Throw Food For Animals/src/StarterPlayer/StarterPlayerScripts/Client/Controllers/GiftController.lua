-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ContentProvider = game:GetService("ContentProvider")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local MonetizationConfig = require(ReplicatedStorage.Config.MonetizationConfig)
local ReleaseConfig = require(ReplicatedStorage.Config.ReleaseConfig)
local EggsConfig = require(ReplicatedStorage.Config.EggsConfig)
local AnimalEconomy = require(ReplicatedStorage.Config.AnimalEconomy)
local NumberFormat = require(ReplicatedStorage.Shared.NumberFormat)
local Remotes = require(ReplicatedStorage.Shared.Remotes)
local AnimalsData = require(ReplicatedStorage.AnimalsData)
local Parent = script.Parent
local ShopUI = require(Parent.ShopUI)
local Sounds = require(Parent.Sounds)
local RobuxPrices = require(Parent.RobuxPrices)
local ExclusiveShopController = require(Parent.ExclusiveShopController)
local ClientState = require(Parent.ClientState)
local t1 = {}
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

local function rgb(p1, p2, p3) -- line: 55
    return Color3.fromRGB(p1, p2, p3)
end

local t2 = {}

for _, v1 in pairs(AnimalsData) do
    for _, v2 in ipairs(v1) do
        t2[v2.ModelName] = v2.Name
    end
end

local ScreenGui, ScreenGui2, t3
local t4 = {}
local t5 = {}
local t6
local t7 = nil

local function now() -- line: 69
    return workspace:GetServerTimeNow()
end

local function newGui(p4, p5) -- line: 73
    -- upvalues: PlayerGui (copy)
    local ScreenGui = Instance.new("ScreenGui")

    ScreenGui.Name = p4
    ScreenGui.ResetOnSpawn = false
    ScreenGui.IgnoreGuiInset = true
    ScreenGui.DisplayOrder = p5
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.Parent = PlayerGui

    return ScreenGui
end

local function headshot(p6) -- line: 84
    -- upvalues: Players (copy), t5 (copy)
    if t5[p6] then
        return t5[p6]
    end

    local GetUserThumbnailAsync = Players.GetUserThumbnailAsync
    local HeadShot = Enum.ThumbnailType.HeadShot
    local Size150x150 = Enum.ThumbnailSize.Size150x150
    local ok, result = pcall(GetUserThumbnailAsync, Players, p6, HeadShot, Size150x150)

    if ok then
        t5[p6] = result
    end

    if not ok or not result then
        result = ""
    end

    return result
end

local function avatar(p7, p8, p9) -- line: 91
    -- upvalues: Players (copy), ShopUI (copy), t5 (copy)
    local v3 = ShopUI.Frame({
        Name = "Avatar",
        Stroke = 3,
        Ratio = 1,
        Parent = p7,
        Size = p9.Size,
        Position = p9.Position,
        AnchorPoint = p9.AnchorPoint,
        Color = Color3.fromRGB(70, 82, 110),
        Corner = UDim.new(0.5, 0),
        ZIndex = p9.ZIndex
    })
    local ImageLabel = Instance.new("ImageLabel")

    ImageLabel.Name = "Image"
    ImageLabel.BackgroundTransparency = 1
    ImageLabel.Size = UDim2.fromScale(1, 1)
    ImageLabel.ZIndex = p9.ZIndex
    ShopUI.Corner(ImageLabel, UDim.new(0.5, 0))
    ImageLabel.Parent = v3
    task.spawn(function() -- line: 100
        -- upvalues: p8 (copy), ImageLabel (copy), Players (copy), t5 (copy)
        local result

        if t5[p8] then
            result = t5[p8]
        else
            local GetUserThumbnailAsync = Players.GetUserThumbnailAsync
            local HeadShot = Enum.ThumbnailType.HeadShot
            local Size150x150 = Enum.ThumbnailSize.Size150x150
            local ok

            ok, result = pcall(GetUserThumbnailAsync, Players, p8, HeadShot, Size150x150)

            if ok then
                t5[p8] = result
            end

            if not ok or not result then
                result = ""
            end
        end

        ImageLabel.Image = result
    end)

    return v3
end

local function livePrice(p10) -- line: 106
    -- upvalues: RobuxPrices (copy)
    return RobuxPrices.Get(p10.Id, Enum.InfoType.Product, p10.Price)
end

local function giftsForFree() -- line: 111
    -- upvalues: MonetizationConfig (copy), ReleaseConfig (copy), LocalPlayer (copy)
    if MonetizationConfig.Gift.FreeForDevelopers == true then
        return (ReleaseConfig.IsDeveloper(LocalPlayer))
    end

    return false
end

local function describe(p11, p12) -- line: 117
    -- upvalues: MonetizationConfig (copy), EggsConfig (copy), AnimalEconomy (copy), NumberFormat (copy), ShopUI (copy), LocalPlayer (copy), t2 (copy)
    if p11.Pass then
        local v4 = MonetizationConfig.Passes[p11.Pass]
        local v5 = MonetizationConfig.Products[v4.GiftProduct]

        return {
            Key = p11.Pass,
            Name = v4.Name,
            Product = v5,
            Line = p11.Pass == "DoubleCash" and "Double cash from every animal" or "Double XP on every pull up",
            Image = p11.Pass == "DoubleCash" and ShopUI.Icons.Cash or ShopUI.Icons.Power,
            Pass = p11.Pass
        }
    end

    local v6 = MonetizationConfig.Products[p11.Product]
    local t9 = {
        Key = p11.Product,
        Name = v6.Name,
        Product = v6
    }
    local Grant = v6.Grant

    if Grant.Eggs then
        for v7 in pairs(Grant.Eggs) do
            t9.Model = {
                Egg = v7
            }
            t9.Line = EggsConfig.Get(v7).Tagline or "Hatches a random animal!"
        end
    elseif Grant.Money then
        t9.Image = ShopUI.Icons.Cash

        local t10 = {}

        for _, v8 in ipairs(Grant.Animals or {}) do
            table.insert(t10, t2[v8] or v8)
        end

        t9.Line = NumberFormat.Money(Grant.Money) .. " + " .. table.concat(t10, " + ")
    elseif Grant.Animals then
        local v10 = Grant.Animals[1]

        t9.Model = {
            Animal = v10
        }

        local v11 = AnimalEconomy.Get(v10)

        t9.Line = if Grant.OfBest then MonetizationConfig.FormatOfBest(Grant.OfBest) .. " of your best animal" else "Limited animal  |  " .. NumberFormat.PerSecond(v11 and v11.Income or 0)
    elseif Grant.MoneyMinutes then
        t9.Image = v6.Icon or ShopUI.Icons.Cash

        local v12 = p12 or LocalPlayer

        t9.Line = "+" .. NumberFormat.Money(MonetizationConfig.PackMoney(p11.Product, v12:GetAttribute("IncomeRate")))
    elseif Grant.Power then
        t9.Image = v6.Icon or ShopUI.Icons.Power
        t9.Line = "+" .. NumberFormat.Abbreviate(Grant.Power) .. " throw power"
    elseif Grant.SuperThrow then
        t9.Image = v6.Icon
        t9.Line = "100x luck on each throw"
    end

    return t9
end

local v13, v14

local function clearPage() -- line: 170
    -- upvalues: t3 (ref)
    if not (t3 and t3.Page) then
        return
    end

    t3.Page:Destroy()
    t3.Page = nil
end

local function newPage() -- line: 177
    -- upvalues: ShopUI (copy), t3 (ref)
    if t3 and t3.Page then
        t3.Page:Destroy()
        t3.Page = nil
    end

    local v15 = ShopUI.Frame({
        Name = "Page",
        Transparency = 1,
        ZIndex = 3,
        Parent = t3.Panel.Content
    })

    t3.Page = v15

    local UIScale = Instance.new("UIScale")

    UIScale.Scale = 0.94
    UIScale.Parent = v15
    ShopUI.Tween(UIScale, {
        Scale = 1
    }, 0.25, Enum.EasingStyle.Back, Enum.EasingDirection.Out)

    return v15
end

local function list(p13, p14) -- line: 188
    local ScrollingFrame = Instance.new("ScrollingFrame")

    ScrollingFrame.Name = "List"
    ScrollingFrame.Size = p14.Size
    ScrollingFrame.Position = p14.Position
    ScrollingFrame.AnchorPoint = p14.AnchorPoint or Vector2.zero
    ScrollingFrame.BackgroundTransparency = 1
    ScrollingFrame.BorderSizePixel = 0
    ScrollingFrame.ScrollBarThickness = 6
    ScrollingFrame.ScrollBarImageColor3 = Color3.fromRGB(200, 210, 230)
    ScrollingFrame.ScrollingDirection = Enum.ScrollingDirection.Y
    ScrollingFrame.AutomaticCanvasSize = Enum.AutomaticSize.None
    ScrollingFrame.CanvasSize = UDim2.new()
    ScrollingFrame.ZIndex = 3
    ScrollingFrame.Parent = p13

    local UIListLayout = Instance.new("UIListLayout")

    UIListLayout.Padding = UDim.new(0, 8)
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    UIListLayout.Parent = ScrollingFrame

    local UIPadding = Instance.new("UIPadding")

    UIPadding.PaddingTop = UDim.new(0, 6)
    UIPadding.PaddingBottom = UDim.new(0, 10)
    UIPadding.Parent = ScrollingFrame

    local function fitCanvas() -- line: 215
        -- upvalues: ScrollingFrame (copy), UIListLayout (copy)
        local Y = ScrollingFrame.AbsoluteSize.Y

        if Y <= 0 then
            return
        end

        local v16 = UIListLayout.AbsoluteContentSize.Y + Y * 0.08

        ScrollingFrame.CanvasSize = UDim2.new(0, 0, math.max(v16 / Y, 0), 0)
    end

    UIListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(fitCanvas)
    ScrollingFrame:GetPropertyChangedSignal("AbsoluteSize"):Connect(fitCanvas)
    task.defer(fitCanvas)

    return ScrollingFrame
end

local function row(p15, p16, p17) -- line: 228
    -- upvalues: ShopUI (copy)
    local v18 = ShopUI.Frame({
        Transparency = 0.2,
        Corner = 14,
        Stroke = 3,
        ZIndex = 3,
        Parent = p15,
        Name = "Row" .. p16,
        Size = UDim2.fromScale(0.95, 0),
        Color = Color3.fromRGB(28, 32, 44),
        Ratio = p17 or 6
    })

    v18.LayoutOrder = p16
    ShopUI.Frame({
        Name = "Shine",
        Transparency = 0.93,
        Corner = 10,
        ZIndex = 3,
        Parent = v18,
        Size = UDim2.new(1, -10, 0.38, 0),
        Position = UDim2.fromOffset(5, 4)
    })

    local UIScale = Instance.new("UIScale")

    UIScale.Scale = 0.8
    UIScale.Parent = v18
    task.delay(0.03 * p16, function() -- line: 235
        -- upvalues: UIScale (copy), ShopUI (copy)
        ShopUI.Tween(UIScale, {
            Scale = 1
        }, 0.28, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
    end)

    return v18
end

local function closeMenu() -- line: 241
    -- upvalues: ShopUI (copy), Sounds (copy), t3 (ref)
    if not t3 then
        return
    end

    local t11 = t3

    t3 = nil
    Sounds.Play("ShopClose")
    ShopUI.Tween(t11.Dim, {
        BackgroundTransparency = 1
    }, 0.2)
    ShopUI.PopOut(t11.Panel.Root, 0.2, 0.7)
    task.delay(0.22, function() -- line: 248
        -- upvalues: t11 (copy)
        t11.Holder:Destroy()
    end)
end

local function openMenu() -- line: 251
    -- upvalues: ShopUI (copy), Sounds (copy), ScreenGui (ref), t3 (ref), t6 (ref), closeMenu (copy)
    if t3 then
        return
    end

    local Frame = Instance.new("Frame")

    Frame.Name = "GiftMenu"
    Frame.Size = UDim2.fromScale(1, 1)
    Frame.BackgroundTransparency = 1
    Frame.Parent = ScreenGui

    local v19 = ShopUI.Dim(Frame, 1, 0.35)
    local v20 = ShopUI.Panel({
        Name = "GiftPanel",
        Ratio = 1.05,
        Title = "Gift",
        Color = "Blue",
        HeaderHeight = 0.13,
        ZIndex = 2,
        Transparency = 0.06,
        Parent = Frame,
        Size = UDim2.fromScale(0.46, 0.72),
        Position = UDim2.fromScale(0.5, 0.52),
        TitleIcon = ShopUI.Icons.Gift,
        OnClose = function() -- OnClose | line: 259
            -- upvalues: t6 (ref), closeMenu (copy)
            if not t6 then
                closeMenu()
            end
        end
    })

    t3 = {
        Holder = Frame,
        Dim = v19,
        Panel = v20
    }
    v19.Activated:Connect(function() -- line: 264
        -- upvalues: t6 (ref), closeMenu (copy)
        if not t6 then
            closeMenu()
        end
    end)
    ShopUI.PopIn(v20.Root, 0.4, 0.65)
    Sounds.Play("ShopOpen")
end

local function v21() -- line: 271
    -- upvalues: Players (copy), ShopUI (copy), LocalPlayer (copy), t3 (ref), t4 (copy), avatar (copy), v13 (ref), newPage (copy), list (copy), row (copy)
    if not t3 then
        return
    end

    t3.Panel.Title.Text = "Gift"

    local v22 = newPage()

    ShopUI.Text({
        Text = "Who do you want to gift?",
        ZIndex = 3,
        Stroke = 3,
        Parent = v22,
        Size = UDim2.fromScale(0.9, 0.08),
        Position = UDim2.fromScale(0.5, 0.06),
        AnchorPoint = Vector2.new(0.5, 0.5)
    })

    local v23 = list(v22, {
        Size = UDim2.fromScale(0.96, 0.84),
        Position = UDim2.fromScale(0.5, 0.12),
        AnchorPoint = Vector2.new(0.5, 0)
    })
    local t12 = {}

    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            table.insert(t12, player)
        end
    end

    table.sort(t12, function(p18, p19) -- line: 281
        return p18.DisplayName:lower() < p19.DisplayName:lower()
    end)

    if #t12 == 0 then
        local v24 = ShopUI.Frame({
            Name = "Empty",
            Transparency = 1,
            ZIndex = 3,
            Parent = v22,
            Size = UDim2.fromScale(0.8, 0.4),
            Position = UDim2.fromScale(0.5, 0.5),
            AnchorPoint = Vector2.new(0.5, 0.5)
        })
        local ImageLabel = Instance.new("ImageLabel")

        ImageLabel.BackgroundTransparency = 1
        ImageLabel.Image = ShopUI.Icons.Gift
        ImageLabel.ImageTransparency = 0.3
        ImageLabel.Size = UDim2.fromScale(0.5, 0.5)
        ImageLabel.SizeConstraint = Enum.SizeConstraint.RelativeYY
        ImageLabel.AnchorPoint = Vector2.new(0.5, 0)
        ImageLabel.Position = UDim2.fromScale(0.5, 0)
        ImageLabel.ZIndex = 3
        ImageLabel.Parent = v24
        ShopUI.Text({
            Text = "No other players here yet!",
            ZIndex = 3,
            Stroke = 3,
            Parent = v24,
            Size = UDim2.fromScale(1, 0.2),
            Position = UDim2.fromScale(0.5, 0.62),
            AnchorPoint = Vector2.new(0.5, 0)
        })
        ShopUI.Text({
            Text = "Gifts can be sent to players in your server.",
            ZIndex = 3,
            Stroke = 2,
            TextTransparency = 0.2,
            Parent = v24,
            Size = UDim2.fromScale(1, 0.12),
            Position = UDim2.fromScale(0.5, 0.84),
            AnchorPoint = Vector2.new(0.5, 0)
        })
    else
        for v25, v26 in ipairs(t12) do
            local v27 = row(v23, v25, 5.2)

            avatar(v27, v26.UserId, {
                ZIndex = 4,
                Size = UDim2.fromScale(0, 0.78),
                Position = UDim2.fromScale(0.02, 0.5),
                AnchorPoint = Vector2.new(0, 0.5)
            }).Size = UDim2.fromScale(0.15, 0.78)
            v27:FindFirstChild("Avatar"):FindFirstChildOfClass("UIAspectRatioConstraint").DominantAxis = Enum.DominantAxis.Height
            ShopUI.Text({
                ZIndex = 4,
                Stroke = 3,
                Parent = v27,
                Text = v26.DisplayName,
                Size = UDim2.fromScale(0.5, 0.42),
                Position = UDim2.fromScale(0.21, 0.32),
                AnchorPoint = Vector2.new(0, 0.5),
                XAlign = Enum.TextXAlignment.Left
            })
            ShopUI.Text({
                ZIndex = 4,
                Stroke = 2,
                Parent = v27,
                Text = "@" .. v26.Name,
                Size = UDim2.fromScale(0.5, 0.26),
                Position = UDim2.fromScale(0.21, 0.7),
                AnchorPoint = Vector2.new(0, 0.5),
                XAlign = Enum.TextXAlignment.Left,
                Color = Color3.fromRGB(190, 200, 220)
            })

            local v28 = t4[tostring(v26.UserId)]

            if v28 and workspace:GetServerTimeNow() < v28 then
                local v29, v30 = ShopUI.Pill({
                    ZIndex = 4,
                    Parent = v27,
                    Text = "WAIT " .. ShopUI.FormatTime(v28 - workspace:GetServerTimeNow()),
                    Size = UDim2.fromScale(0.26, 0.5),
                    Position = UDim2.fromScale(0.97, 0.5),
                    AnchorPoint = Vector2.new(1, 0.5),
                    Gradient = {
                        Color3.fromRGB(120, 60, 60),
                        Color3.fromRGB(80, 36, 36),
                        90
                    }
                })

                task.spawn(function() -- line: 308
                    -- upvalues: v28 (copy), v29 (copy), v30 (copy), ShopUI (copy)
                    while v29.Parent and v28 > workspace:GetServerTimeNow() do
                        v30.Text = "WAIT " .. ShopUI.FormatTime(v28 - workspace:GetServerTimeNow())
                        task.wait(0.5)
                    end
                end)
            else
                ShopUI.Button({
                    Name = "Pick",
                    Text = "GIFT",
                    Color = "Blue",
                    ZIndex = 4,
                    Parent = v27,
                    Size = UDim2.fromScale(0.24, 0.62),
                    Position = UDim2.fromScale(0.97, 0.47),
                    AnchorPoint = Vector2.new(1, 0.5),
                    OnClick = function() -- OnClick | line: 315
                        -- upvalues: v26 (copy), v13 (ref)
                        v13(v26)
                    end
                })
            end
        end
    end
end

local function sendRequest(p20, p21) -- line: 322
    -- upvalues: Remotes (copy), Parent (copy), Sounds (copy), t4 (copy), t6 (ref), v14 (ref)
    if t6 then
        return
    end

    local v31 = Remotes.Invoke("Gift_Request", p20.UserId, p21.Key)

    if v31.Ok then
        t6 = {
            Id = v31.RequestId,
            Target = p20,
            Info = p21,
            Expires = v31.Expires,
            Free = v31.Free == true
        }
        v14()
    else
        Sounds.Play("PurchaseFail", {
            Volume = 0.45
        })

        local t14 = {
            Busy = "You already have a gift waiting!",
            Cooldown = "Slow down a little!",
            DevServer = "Gifts are off in the dev server.",
            Owned = p20.DisplayName .. " already owns " .. p21.Name .. "!",
            Blocked = p20.DisplayName .. " doesn't want gifts from you right now.",
            ReceiverBusy = p20.DisplayName .. " is answering another gift, try again in a moment.",
            NoPlayer = p20.DisplayName .. " left the server.",
            Maxed = p20.DisplayName .. "'s throw power is almost maxed!"
        }

        if v31.Reason == "Blocked" and v31.BlockEnds then
            t4[tostring(p20.UserId)] = v31.BlockEnds
        end

        local _require = require
        local HUDController = Parent.HUDController
        local ok, result = pcall(_require, HUDController)

        if ok then
            result.Notify(t14[v31.Reason] or "Could not send the gift.", "Error")
        end
    end
end

v13 = function(p22) -- line: 348
    -- upvalues: MonetizationConfig (copy), ReleaseConfig (copy), ShopUI (copy), RobuxPrices (copy), LocalPlayer (copy), t3 (ref), avatar (copy), livePrice (copy), describe (copy), newPage (copy), list (copy), row (copy), v21 (copy), sendRequest (copy)
    if not t3 then
        return
    end

    local v32 = newPage()

    ShopUI.Button({
        Name = "Back",
        Text = "<",
        Color = "Gray",
        Ratio = 1,
        ZIndex = 4,
        Parent = v32,
        Size = UDim2.fromScale(0.1, 0.1),
        Position = UDim2.fromScale(0.03, 0.065),
        AnchorPoint = Vector2.new(0, 0.5),
        OnClick = function() -- OnClick | line: 352
            -- upvalues: v21 (copy)
            v21()
        end
    })
    avatar(v32, p22.UserId, {
        ZIndex = 4,
        Size = UDim2.fromScale(0.1, 0.1),
        Position = UDim2.fromScale(0.16, 0.065),
        AnchorPoint = Vector2.new(0, 0.5)
    })
    ShopUI.Text({
        Rich = true,
        ZIndex = 4,
        Stroke = 3,
        Parent = v32,
        Text = "Gift to <font color=\"#7FD8FF\">" .. p22.DisplayName .. "</font>",
        Size = UDim2.fromScale(0.66, 0.08),
        Position = UDim2.fromScale(0.29, 0.065),
        AnchorPoint = Vector2.new(0, 0.5),
        XAlign = Enum.TextXAlignment.Left
    })

    local v33 = list(v32, {
        Size = UDim2.fromScale(0.96, 0.84),
        Position = UDim2.fromScale(0.5, 0.14),
        AnchorPoint = Vector2.new(0.5, 0)
    })
    local v34 = MonetizationConfig.Gift.FreeForDevelopers == true and ReleaseConfig.IsDeveloper(LocalPlayer)

    for v35, v36 in ipairs(MonetizationConfig.Gift.Items) do
        local v37 = describe(v36, p22)
        local v38 = row(v33, v35, 4.6)
        local v39 = ShopUI.Frame({
            Name = "Well",
            Transparency = 0.3,
            Corner = 12,
            Stroke = 2,
            ZIndex = 4,
            Parent = v38,
            Size = UDim2.fromScale(0.17, 0.82),
            Position = UDim2.fromScale(0.02, 0.5),
            AnchorPoint = Vector2.new(0, 0.5),
            Color = Color3.fromRGB(60, 70, 96)
        })

        if v37.Model then
            ShopUI.Viewport({
                ZIndex = 5,
                Pad = 1,
                Parent = v39,
                Size = UDim2.fromScale(0.94, 0.94),
                Position = UDim2.fromScale(0.5, 0.5),
                AnchorPoint = Vector2.new(0.5, 0.5),
                Model = ShopUI.ItemModel(v37.Model),
                Spin = if v37.Model.Egg then 0.8 else nil
            })
        elseif v37.Image then
            local ImageLabel = Instance.new("ImageLabel")

            ImageLabel.BackgroundTransparency = 1
            ImageLabel.Image = v37.Image
            ImageLabel.ScaleType = Enum.ScaleType.Fit
            ImageLabel.Size = UDim2.fromScale(0.8, 0.8)
            ImageLabel.Position = UDim2.fromScale(0.5, 0.5)
            ImageLabel.AnchorPoint = Vector2.new(0.5, 0.5)
            ImageLabel.ZIndex = 5
            ImageLabel.Parent = v39
        end

        ShopUI.Text({
            ZIndex = 4,
            Stroke = 3,
            Parent = v38,
            Text = v37.Name,
            Size = UDim2.fromScale(0.48, 0.4),
            Position = UDim2.fromScale(0.22, 0.33),
            AnchorPoint = Vector2.new(0, 0.5),
            XAlign = Enum.TextXAlignment.Left
        })
        ShopUI.Text({
            ZIndex = 4,
            Stroke = 2,
            Parent = v38,
            Text = v37.Line or "",
            Size = UDim2.fromScale(0.48, 0.24),
            Position = UDim2.fromScale(0.22, 0.7),
            AnchorPoint = Vector2.new(0, 0.5),
            XAlign = Enum.TextXAlignment.Left,
            Color = Color3.fromRGB(200, 212, 232)
        })

        if v37.Pass and p22:GetAttribute("Pass_" .. v37.Pass) == true then
            ShopUI.Pill({
                Text = "OWNED",
                ZIndex = 4,
                Parent = v38,
                Size = UDim2.fromScale(0.25, 0.46),
                Position = UDim2.fromScale(0.975, 0.5),
                AnchorPoint = Vector2.new(1, 0.5)
            })
        elseif v34 then
            ShopUI.Button({
                Name = "Buy",
                Text = "FREE",
                Color = "Green",
                ZIndex = 4,
                Parent = v38,
                Size = UDim2.fromScale(0.25, 0.6),
                Position = UDim2.fromScale(0.975, 0.47),
                AnchorPoint = Vector2.new(1, 0.5),
                OnClick = function() -- OnClick | line: 382
                    -- upvalues: p22 (copy), v37 (copy), sendRequest (copy)
                    sendRequest(p22, v37)
                end
            })
        else
            local Button = ShopUI.Button
            local t17 = {
                Name = "Buy",
                Color = "Green",
                ZIndex = 4,
                Parent = v38
            }
            local Product = v37.Product

            t17.Price = RobuxPrices.Get(Product.Id, Enum.InfoType.Product, Product.Price)
            t17.Size = UDim2.fromScale(0.25, 0.6)
            t17.Position = UDim2.fromScale(0.975, 0.47)
            t17.AnchorPoint = Vector2.new(1, 0.5)

            function t17.OnClick() -- line: 386
                -- upvalues: p22 (copy), v37 (copy), sendRequest (copy)
                sendRequest(p22, v37)
            end

            local v40 = Button(t17)

            task.delay(1, function() -- line: 390
                -- upvalues: v37 (copy), v40 (copy), livePrice (copy)
                if v40.Label.Parent then
                    v40.Label.Text = tostring(livePrice(v37.Product))
                end
            end)
        end
    end
end

local t18 = nil

v14 = function() -- line: 399
    -- upvalues: RunService (copy), Remotes (copy), ShopUI (copy), t3 (ref), t6 (ref), avatar (copy), v13 (ref), newPage (copy), t18 (ref)
    if t3 and t6 then
        local v41 = newPage()
        local Target, Info = t6.Target, t6.Info

        avatar(v41, Target.UserId, {
            ZIndex = 4,
            Size = UDim2.fromScale(0.26, 0.26),
            Position = UDim2.fromScale(0.34, 0.22),
            AnchorPoint = Vector2.new(0.5, 0.5)
        })

        local v42 = ShopUI.Text({
            Text = ">",
            ZIndex = 4,
            Stroke = 3,
            Parent = v41,
            Size = UDim2.fromScale(0.1, 0.1),
            Position = UDim2.fromScale(0.5, 0.22),
            AnchorPoint = Vector2.new(0.5, 0.5)
        })
        local v43 = ShopUI.Frame({
            Name = "Item",
            Transparency = 0.3,
            Corner = 16,
            Stroke = 3,
            ZIndex = 4,
            Ratio = 1,
            Parent = v41,
            Size = UDim2.fromScale(0.26, 0.26),
            Position = UDim2.fromScale(0.66, 0.22),
            AnchorPoint = Vector2.new(0.5, 0.5),
            Color = Color3.fromRGB(60, 70, 96)
        })

        if Info.Model then
            ShopUI.Viewport({
                ZIndex = 5,
                Spin = 0.9,
                Parent = v43,
                Size = UDim2.fromScale(0.94, 0.94),
                Position = UDim2.fromScale(0.5, 0.5),
                AnchorPoint = Vector2.new(0.5, 0.5),
                Model = ShopUI.ItemModel(Info.Model)
            })
        elseif Info.Image then
            local ImageLabel = Instance.new("ImageLabel")

            ImageLabel.BackgroundTransparency = 1
            ImageLabel.Image = Info.Image
            ImageLabel.ScaleType = Enum.ScaleType.Fit
            ImageLabel.Size = UDim2.fromScale(0.8, 0.8)
            ImageLabel.Position = UDim2.fromScale(0.5, 0.5)
            ImageLabel.AnchorPoint = Vector2.new(0.5, 0.5)
            ImageLabel.ZIndex = 5
            ImageLabel.Parent = v43
        end

        local Free = t6.Free
        local v44 = Free and "Sending to <font color=\"#7FD8FF\">" .. Target.DisplayName .. "</font>..." or "Waiting for <font color=\"#7FD8FF\">" .. Target.DisplayName .. "</font> to accept..."
        local v45 = ShopUI.Text({
            Rich = true,
            ZIndex = 4,
            Stroke = 3,
            Parent = v41,
            Text = v44,
            Size = UDim2.fromScale(0.9, 0.08),
            Position = UDim2.fromScale(0.5, 0.45),
            AnchorPoint = Vector2.new(0.5, 0.5)
        })
        local v46 = ShopUI.Text({
            ZIndex = 4,
            Stroke = 2,
            Parent = v41,
            Text = Info.Name .. (Free and "  |  free gift" or "  |  you only pay if they accept"),
            Size = UDim2.fromScale(0.8, 0.05),
            Position = UDim2.fromScale(0.5, 0.53),
            AnchorPoint = Vector2.new(0.5, 0.5),
            Color = Color3.fromRGB(200, 212, 232)
        })
        local v47 = ShopUI.Spinner(v41, {
            ZIndex = 4,
            Size = UDim2.fromScale(0.12, 0.12),
            Position = UDim2.fromScale(0.5, 0.66),
            Color = Color3.fromRGB(127, 216, 255)
        })
        local v48 = ShopUI.Frame({
            Name = "TimerBar",
            Stroke = 2,
            ZIndex = 4,
            Parent = v41,
            Size = UDim2.fromScale(0.7, 0.03),
            Position = UDim2.fromScale(0.5, 0.78),
            AnchorPoint = Vector2.new(0.5, 0.5),
            Color = Color3.fromRGB(30, 34, 46),
            Corner = UDim.new(0.5, 0)
        })
        local v49 = ShopUI.Frame({
            Name = "Fill",
            ZIndex = 4,
            Parent = v48,
            Color = Color3.new(1, 1, 1),
            Corner = UDim.new(0.5, 0),
            Gradient = {
                Color3.fromRGB(127, 216, 255),
                Color3.fromRGB(40, 130, 240),
                0
            }
        })
        local v50 = ShopUI.Button({
            Name = "Cancel",
            Text = "CANCEL",
            Color = "Red",
            ZIndex = 4,
            Parent = v41,
            Size = UDim2.fromScale(0.34, 0.1),
            Position = UDim2.fromScale(0.5, 0.91),
            AnchorPoint = Vector2.new(0.5, 0.5),
            OnClick = function() -- OnClick | line: 427
                -- upvalues: Target (copy), Remotes (copy), t6 (ref), v13 (ref)
                if t6 then
                    Remotes.Invoke("Gift_Cancel", t6.Id)
                    t6 = nil
                    v13(Target)
                end
            end
        })

        if Free then
            v50.Holder.Visible = false
        end

        t18 = {
            Page = v41,
            Status = v45,
            Sub = v46,
            Spinner = v47,
            Bar = v48,
            Fill = v49,
            Cancel = v50,
            Arrow = v42
        }

        local v52 = math.max(t6.Expires - workspace:GetServerTimeNow(), 1)

        task.spawn(function() -- line: 436
            -- upvalues: v41 (copy), v42 (copy), v49 (copy), v52 (copy), RunService (copy), t6 (ref), t18 (ref)
            while t18 and t18.Page == v41 and v41.Parent do
                if t6 and t6.Expires then
                    local v54 = math.max(0, t6.Expires - workspace:GetServerTimeNow())

                    v49.Size = UDim2.fromScale(math.clamp(v54 / v52, 0, 1), 1)
                end

                v42.Position = UDim2.fromScale(math.sin(os.clock() * 5) * 0.01 + 0.5, 0.22)
                RunService.RenderStepped:Wait()
            end
        end)
    end
end

local function finishWaiting(p23, p24, p25, p26) -- line: 449
    -- upvalues: ShopUI (copy), ScreenGui (ref), t3 (ref), v13 (ref), closeMenu (copy), v21 (copy), t18 (ref)
    local t21 = t18

    if not (t21 and t21.Page.Parent) then
        return
    end

    if t21.Spinner then
        t21.Spinner:Destroy()
    end

    t21.Bar.Visible = false
    t21.Cancel.Holder.Visible = false
    t21.Status.Text = p23
    t21.Status.TextColor3 = p24 or Color3.new(1, 1, 1)
    ShopUI.Punch(t21.Status, 0.3, 0.5)

    if p26 then
        local AbsoluteSize = ScreenGui.AbsoluteSize

        ShopUI.Confetti(ScreenGui, Vector2.new(AbsoluteSize.X * 0.5, AbsoluteSize.Y * 0.5), 60, {
            ZIndex = 30
        })
    end

    task.delay(p25 or 2.5, function() -- line: 462
        -- upvalues: p26 (copy), t21 (copy), t3 (ref), v13 (ref), closeMenu (copy), v21 (copy), t18 (ref)
        if t18 == t21 then
            t18 = nil

            if t3 then
                if p26 then
                    closeMenu()
                elseif t21.Target then
                    v13(t21.Target)
                else
                    v21()
                end
            end
        end
    end)
end

local function onSenderUpdate(p27) -- line: 476
    -- upvalues: ShopUI (copy), Sounds (copy), rgb (copy), t4 (copy), t6 (ref), t18 (ref), finishWaiting (copy)
    if not t6 or p27.RequestId ~= t6.Id then
        return
    end

    local Target = t6.Target

    if t18 then
        t18.Target = Target
    end

    if p27.Type == "Accepted" then
        t6.Expires = nil
        Sounds.Play("GiftChime")

        if t18 then
            t18.Status.Text = "<font color=\"#8CFF6A\">" .. Target.DisplayName .. " accepted!</font> Complete the purchase"
            ShopUI.Punch(t18.Status, 0.25, 0.5)
            t18.Bar.Visible = false
            t18.Cancel.Holder.Visible = false
            t18.Sub.Text = "the Robux prompt is open"
        end
    elseif p27.Type == "Denied" then
        t6 = nil
        Sounds.Play("Deny")

        if not (p27.Blocked and p27.BlockEnds) then
            finishWaiting(Target.DisplayName .. " said no to the gift.", rgb(255, 120, 120))
        else
            t4[tostring(Target.UserId)] = p27.BlockEnds
            finishWaiting(Target.DisplayName .. " said no. You can gift them again in " .. ShopUI.FormatTime(p27.BlockEnds - workspace:GetServerTimeNow()) .. ".", Color3.fromRGB(255, 120, 120), 3.5)
        end
    elseif p27.Type == "Expired" then
        t6 = nil
        Sounds.Play("Deny")
        finishWaiting(Target.DisplayName .. " didn't answer.", rgb(255, 200, 120))
    elseif p27.Type == "Cancelled" then
        t6 = nil

        local v57 = if p27.By == "Payment" then "Purchase cancelled - nothing was paid." else Target.DisplayName .. " left the server."

        if p27.By == "Timeout" then
            v57 = "The gift timed out."
        end

        if p27.By == "Error" then
            v57 = "Could not send the gift."
        end

        Sounds.Play("Deny")
        finishWaiting(v57, rgb(255, 200, 120))
    elseif p27.Type == "Delivered" then
        t6 = nil
        Sounds.Play("GiftSent")
        Sounds.Play("LevelUp", {
            Volume = 0.5,
            Pitch = 1.2
        })
        finishWaiting("GIFT SENT TO " .. string.upper(Target.DisplayName) .. "!", Color3.fromRGB(140, 255, 110), 2.6, true)
    end
end

function t1.Open() -- line: 518
    -- upvalues: t3 (ref), t6 (ref), v14 (ref), openMenu (copy), v21 (copy)
    if not (t6 and t3) then
        openMenu()

        if t6 then
            v14()
        else
            v21()
        end
    end
end

local function showIncoming(p28) -- line: 539
    -- upvalues: Players (copy), RunService (copy), MonetizationConfig (copy), Remotes (copy), ShopUI (copy), Sounds (copy), LocalPlayer (copy), ScreenGui2 (ref), t7 (ref), avatar (copy), describe (copy)
    if t7 then
        local t22 = t7

        if t22 then
            t7 = nil
            task.delay(0, function() -- line: 532
                -- upvalues: t22 (copy), ShopUI (copy)
                ShopUI.Tween(t22.Dim, {
                    BackgroundTransparency = 1
                }, 0.25)
                ShopUI.PopOut(t22.Panel.Root, 0.22, 0.6)
                task.delay(0.25, function() -- line: 535
                    -- upvalues: t22 (copy)
                    t22.Holder:Destroy()
                end)
            end)
        end
    end

    local Frame = Instance.new("Frame")

    Frame.Name = "GiftRequest"
    Frame.Size = UDim2.fromScale(1, 1)
    Frame.BackgroundTransparency = 1
    Frame.Parent = ScreenGui2

    local v58 = ShopUI.Dim(Frame, 1, 0.3)
    local v59 = ShopUI.Panel({
        Name = "RequestPanel",
        Ratio = 1,
        Title = "Gift!",
        Color = "Pink",
        HeaderHeight = 0.12,
        ZIndex = 2,
        Transparency = 0.06,
        Parent = Frame,
        Size = UDim2.fromScale(0.4, 0.66),
        Position = UDim2.fromScale(0.5, 0.5),
        TitleIcon = ShopUI.Icons.Gift
    })
    local Content = v59.Content
    local t23 = {
        Holder = Frame,
        Dim = v58,
        Panel = v59,
        Id = p28.RequestId,
        Info = p28
    }

    t7 = t23
    Players:GetPlayerByUserId(p28.SenderUserId)
    avatar(Content, p28.SenderUserId, {
        ZIndex = 3,
        Size = UDim2.fromScale(0.18, 0.18),
        Position = UDim2.fromScale(0.5, 0.12),
        AnchorPoint = Vector2.new(0.5, 0.5)
    })
    ShopUI.Text({
        Rich = true,
        ZIndex = 3,
        Stroke = 3,
        Parent = Content,
        Text = "<font color=\"#FFB8E6\">" .. string.upper(p28.SenderName or "SOMEONE") .. "</font> WANTS TO GIFT YOU",
        Size = UDim2.fromScale(0.92, 0.07),
        Position = UDim2.fromScale(0.5, 0.265),
        AnchorPoint = Vector2.new(0.5, 0.5)
    })

    local v60 = MonetizationConfig.GetGiftItem(p28.ItemKey)
    local v61 = v60 and describe(v60, LocalPlayer) or {
        Name = p28.ItemName
    }
    local v62 = ShopUI.Frame({
        Name = "Item",
        Transparency = 0.3,
        Corner = 16,
        Stroke = 3,
        ZIndex = 3,
        Ratio = 1,
        Parent = Content,
        Size = UDim2.fromScale(0.28, 0.28),
        Position = UDim2.fromScale(0.5, 0.47),
        AnchorPoint = Vector2.new(0.5, 0.5),
        Color = Color3.fromRGB(60, 70, 96)
    })

    ShopUI.Rays(v62, Color3.fromRGB(255, 180, 230), {
        ZIndex = 2,
        Count = 7,
        Alpha = 0.6,
        Speed = 30,
        Size = UDim2.fromScale(1.8, 1.8)
    })

    if v61.Model then
        ShopUI.Viewport({
            ZIndex = 4,
            Spin = 0.9,
            Parent = v62,
            Size = UDim2.fromScale(0.94, 0.94),
            Position = UDim2.fromScale(0.5, 0.5),
            AnchorPoint = Vector2.new(0.5, 0.5),
            Model = ShopUI.ItemModel(v61.Model)
        })
    elseif v61.Image then
        local ImageLabel = Instance.new("ImageLabel")

        ImageLabel.BackgroundTransparency = 1
        ImageLabel.Image = v61.Image
        ImageLabel.ScaleType = Enum.ScaleType.Fit
        ImageLabel.Size = UDim2.fromScale(0.8, 0.8)
        ImageLabel.Position = UDim2.fromScale(0.5, 0.5)
        ImageLabel.AnchorPoint = Vector2.new(0.5, 0.5)
        ImageLabel.ZIndex = 4
        ImageLabel.Parent = v62
    end

    ShopUI.Text({
        ZIndex = 3,
        Stroke = 4,
        Parent = Content,
        Text = string.upper(p28.ItemName or v61.Name or "A GIFT"),
        Size = UDim2.fromScale(0.9, 0.085),
        Position = UDim2.fromScale(0.5, 0.665),
        AnchorPoint = Vector2.new(0.5, 0.5),
        Gradient = {
            Color3.fromRGB(255, 255, 255),
            Color3.fromRGB(255, 214, 240),
            90
        }
    })

    local v63 = ShopUI.Frame({
        Name = "Price",
        Transparency = 1,
        ZIndex = 3,
        Parent = Content,
        Size = UDim2.fromScale(0.6, 0.055),
        Position = UDim2.fromScale(0.5, 0.74),
        AnchorPoint = Vector2.new(0.5, 0.5)
    })
    local UIListLayout = Instance.new("UIListLayout")

    UIListLayout.FillDirection = Enum.FillDirection.Horizontal
    UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    UIListLayout.Padding = UDim.new(0.02, 0)
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    UIListLayout.Parent = v63
    ShopUI.Text({
        Text = "FOR",
        ZIndex = 3,
        Stroke = 2,
        Parent = v63,
        Size = UDim2.fromScale(0.12, 1)
    }).LayoutOrder = 1

    local ImageLabel = Instance.new("ImageLabel")

    ImageLabel.BackgroundTransparency = 1
    ImageLabel.Image = ShopUI.RobuxIcon
    ImageLabel.Size = UDim2.fromScale(1, 1)
    ImageLabel.SizeConstraint = Enum.SizeConstraint.RelativeYY
    ImageLabel.ZIndex = 3
    ImageLabel.LayoutOrder = 2
    ImageLabel.Parent = v63
    ShopUI.Text({
        ZIndex = 3,
        Stroke = 2,
        Parent = v63,
        Text = tostring(p28.Price or 0) .. " ROBUX",
        Size = UDim2.fromScale(0.36, 1),
        Color = Color3.fromRGB(140, 255, 110)
    }).LayoutOrder = 3

    local v65 = ShopUI.Frame({
        Name = "TimerBar",
        Stroke = 2,
        ZIndex = 3,
        Parent = Content,
        Size = UDim2.fromScale(0.8, 0.024),
        Position = UDim2.fromScale(0.5, 0.8),
        AnchorPoint = Vector2.new(0.5, 0.5),
        Color = Color3.fromRGB(30, 34, 46),
        Corner = UDim.new(0.5, 0)
    })
    local v66 = ShopUI.Frame({
        Name = "Fill",
        ZIndex = 3,
        Parent = v65,
        Corner = UDim.new(0.5, 0),
        Gradient = {
            Color3.fromRGB(255, 150, 215),
            Color3.fromRGB(214, 60, 150),
            0
        }
    })
    local v68 = math.max((p28.Expires or workspace:GetServerTimeNow() + 30) - workspace:GetServerTimeNow(), 1)

    task.spawn(function() -- line: 597
        -- upvalues: p28 (copy), t23 (copy), v66 (copy), v68 (copy), RunService (copy), ShopUI (copy), t7 (ref)
        while true do
            if t7 == t23 and v66.Parent then
                local v69 = (p28.Expires or 0) - workspace:GetServerTimeNow()
                local v70 = math.max(0, v69)

                v66.Size = UDim2.fromScale(math.clamp(v70 / v68, 0, 1), 1)

                if not (v69 < -2) or t23.Waiting then
                    RunService.RenderStepped:Wait()
                    continue
                end

                local t26 = t7

                if t26 then
                    t7 = nil
                    task.delay(0, function() -- line: 532
                        -- upvalues: t26 (copy), ShopUI (copy)
                        ShopUI.Tween(t26.Dim, {
                            BackgroundTransparency = 1
                        }, 0.25)
                        ShopUI.PopOut(t26.Panel.Root, 0.22, 0.6)
                        task.delay(0.25, function() -- line: 535
                            -- upvalues: t26 (copy)
                            t26.Holder:Destroy()
                        end)
                    end)
                end

                return
            end

            break
        end
    end)

    local t27 = {}

    local function setButtonsVisible(p29) -- line: 612
        -- upvalues: t27 (ref)
        for _, v72 in ipairs(t27) do
            v72.Holder.Visible = p29
        end
    end

    local function waitingForPayment() -- line: 615
        -- upvalues: p28 (copy), Content (copy), t23 (copy), v63 (copy), v65 (copy), t27 (ref), ShopUI (copy)
        for _, v73 in ipairs(t27) do
            v73.Holder.Visible = false
        end

        v65.Visible = false
        v63.Visible = false
        t23.Waiting = ShopUI.Text({
            Rich = true,
            ZIndex = 3,
            Stroke = 2,
            Parent = Content,
            Text = "Waiting for <font color=\"#FFB8E6\">" .. (p28.SenderName or "them") .. "</font> to pay...",
            Size = UDim2.fromScale(0.86, 0.06),
            Position = UDim2.fromScale(0.5, 0.77),
            AnchorPoint = Vector2.new(0.5, 0.5)
        })
        ShopUI.Spinner(Content, {
            ZIndex = 3,
            Size = UDim2.fromScale(0.09, 0.09),
            Position = UDim2.fromScale(0.5, 0.89),
            Color = Color3.fromRGB(255, 180, 230)
        })
    end

    local v75

    t27 = {
        ShopUI.Button({
            Name = "Deny",
            Text = "DENY",
            Color = "Red",
            ZIndex = 3,
            Parent = Content,
            Size = UDim2.fromScale(0.38, 0.1),
            Position = UDim2.fromScale(0.27, 0.9),
            AnchorPoint = Vector2.new(0.5, 0.5),
            OnClick = function() -- OnClick | line: 624
                -- upvalues: p28 (copy), Content (copy), t23 (copy), v75 (ref), Remotes (copy), ShopUI (copy), Sounds (copy), t7 (ref)
                if v75 then
                    return
                end

                v75 = ShopUI.Frame({
                    Name = "Confirm",
                    Transparency = 0.05,
                    Corner = 16,
                    Stroke = 4,
                    ZIndex = 10,
                    Parent = Content,
                    Size = UDim2.fromScale(0.86, 0.4),
                    Position = UDim2.fromScale(0.5, 0.62),
                    AnchorPoint = Vector2.new(0.5, 0.5),
                    Color = Color3.fromRGB(28, 32, 44)
                })
                ShopUI.Text({
                    Text = "Are you sure?",
                    ZIndex = 11,
                    Stroke = 3,
                    Parent = v75,
                    Size = UDim2.fromScale(0.9, 0.22),
                    Position = UDim2.fromScale(0.5, 0.2),
                    AnchorPoint = Vector2.new(0.5, 0.5)
                })
                ShopUI.Text({
                    Rich = true,
                    ZIndex = 11,
                    Stroke = 2,
                    Wrap = true,
                    Parent = v75,
                    Text = "You will not get this gift from <font color=\"#FFB8E6\">" .. (p28.SenderName or "them") .. "</font>.",
                    Size = UDim2.fromScale(0.9, 0.14),
                    Position = UDim2.fromScale(0.5, 0.43),
                    AnchorPoint = Vector2.new(0.5, 0.5)
                })
                ShopUI.Button({
                    Name = "Yes",
                    Text = "YES, DENY",
                    Color = "Red",
                    ZIndex = 11,
                    Parent = v75,
                    Size = UDim2.fromScale(0.42, 0.26),
                    Position = UDim2.fromScale(0.27, 0.76),
                    AnchorPoint = Vector2.new(0.5, 0.5),
                    OnClick = function() -- OnClick | line: 630
                        -- upvalues: t23 (copy), Remotes (copy), ShopUI (copy), Sounds (copy), t7 (ref)
                        Remotes.Invoke("Gift_Respond", t23.Id, false)
                        Sounds.Play("Deny")

                        local t29 = t7

                        if not t29 then
                            return
                        end

                        t7 = nil
                        task.delay(0, function() -- line: 532
                            -- upvalues: t29 (copy), ShopUI (copy)
                            ShopUI.Tween(t29.Dim, {
                                BackgroundTransparency = 1
                            }, 0.25)
                            ShopUI.PopOut(t29.Panel.Root, 0.22, 0.6)
                            task.delay(0.25, function() -- line: 535
                                -- upvalues: t29 (copy)
                                t29.Holder:Destroy()
                            end)
                        end)
                    end
                })
                ShopUI.Button({
                    Name = "No",
                    Text = "NO",
                    Color = "Gray",
                    ZIndex = 11,
                    Parent = v75,
                    Size = UDim2.fromScale(0.42, 0.26),
                    Position = UDim2.fromScale(0.73, 0.76),
                    AnchorPoint = Vector2.new(0.5, 0.5),
                    OnClick = function() -- OnClick | line: 635
                        -- upvalues: v75 (ref)
                        if v75 then
                            v75:Destroy()
                            v75 = nil
                        end
                    end
                })
                ShopUI.PopIn(v75, 0.3, 0.7)
            end
        }),
        (ShopUI.Button({
            Name = "Accept",
            Text = "ACCEPT",
            Color = "Green",
            ZIndex = 3,
            Parent = Content,
            Size = UDim2.fromScale(0.38, 0.1),
            Position = UDim2.fromScale(0.73, 0.9),
            AnchorPoint = Vector2.new(0.5, 0.5),
            OnClick = function() -- OnClick | line: 640
                -- upvalues: t23 (copy), waitingForPayment (copy), v75 (ref), Remotes (copy), ShopUI (copy), Sounds (copy), t7 (ref)
                if not v75 then
                    if Remotes.Invoke("Gift_Respond", t23.Id, true).Ok then
                        Sounds.Play("GiftChime")
                        waitingForPayment()
                    else
                        local t31 = t7

                        if t31 then
                            t7 = nil
                            task.delay(0, function() -- line: 532
                                -- upvalues: t31 (copy), ShopUI (copy)
                                ShopUI.Tween(t31.Dim, {
                                    BackgroundTransparency = 1
                                }, 0.25)
                                ShopUI.PopOut(t31.Panel.Root, 0.22, 0.6)
                                task.delay(0.25, function() -- line: 535
                                    -- upvalues: t31 (copy)
                                    t31.Holder:Destroy()
                                end)
                            end)
                        end
                    end
                end
            end
        }))
    }
    t23.OnPaying = waitingForPayment
    ShopUI.PopIn(v59.Root, 0.5, 0.4)
    Sounds.Play("GiftChime")
    Sounds.Play("Pop", {
        Delay = 0.1
    })
    task.spawn(function() -- line: 657
        -- upvalues: v59 (copy), t23 (copy), ShopUI (copy), t7 (ref)
        local TitleIcon = v59.Header:FindFirstChild("TitleIcon")

        while t7 == t23 and TitleIcon and TitleIcon.Parent do
            ShopUI.Tween(TitleIcon, {
                Rotation = 12
            }, 0.1)
            task.wait(0.1)
            ShopUI.Tween(TitleIcon, {
                Rotation = -12
            }, 0.1)
            task.wait(0.1)
            ShopUI.Tween(TitleIcon, {
                Rotation = 0
            }, 0.3, Enum.EasingStyle.Elastic)
            task.wait(1.6)
        end
    end)
end

local function onReceiverUpdate(p30) -- line: 670
    -- upvalues: ShopUI (copy), ClientState (copy), t7 (ref), showIncoming (copy)
    if p30.Type == "Incoming" then
        if ClientState.OfflineOpen then
            task.spawn(function() -- line: 674
                -- upvalues: p30 (copy), ClientState (copy), showIncoming (copy)
                while ClientState.OfflineOpen do
                    task.wait(0.25)
                end

                if (p30.Expires or 0) - workspace:GetServerTimeNow() > 1 then
                    showIncoming(p30)
                end
            end)
        else
            showIncoming(p30)
        end
    else
        local t32 = t7

        if t32 and t32.Id == p30.RequestId then
            if p30.Type == "Paying" then
                if t32.OnPaying and not t32.Waiting then
                    t32.OnPaying()
                end
            elseif p30.Type == "Expired" or p30.Type == "Closed" then
                local t33 = t7

                if t33 then
                    t7 = nil
                    task.delay(0, function() -- line: 532
                        -- upvalues: t33 (copy), ShopUI (copy)
                        ShopUI.Tween(t33.Dim, {
                            BackgroundTransparency = 1
                        }, 0.25)
                        ShopUI.PopOut(t33.Panel.Root, 0.22, 0.6)
                        task.delay(0.25, function() -- line: 535
                            -- upvalues: t33 (copy)
                            t33.Holder:Destroy()
                        end)
                    end)
                end
            elseif p30.Type == "Cancelled" then
                if t32.Waiting then
                    t32.Waiting.Text = (p30.SenderName or t32.Info.SenderName or "They") .. " cancelled the gift."

                    local t34 = t7

                    if t34 then
                        t7 = nil
                        task.delay(1.6, function() -- line: 532
                            -- upvalues: t34 (copy), ShopUI (copy)
                            ShopUI.Tween(t34.Dim, {
                                BackgroundTransparency = 1
                            }, 0.25)
                            ShopUI.PopOut(t34.Panel.Root, 0.22, 0.6)
                            task.delay(0.25, function() -- line: 535
                                -- upvalues: t34 (copy)
                                t34.Holder:Destroy()
                            end)
                        end)
                    end
                else
                    local t35 = t7

                    if not t35 then
                        return
                    end

                    t7 = nil
                    task.delay(0, function() -- line: 532
                        -- upvalues: t35 (copy), ShopUI (copy)
                        ShopUI.Tween(t35.Dim, {
                            BackgroundTransparency = 1
                        }, 0.25)
                        ShopUI.PopOut(t35.Panel.Root, 0.22, 0.6)
                        task.delay(0.25, function() -- line: 535
                            -- upvalues: t35 (copy)
                            t35.Holder:Destroy()
                        end)
                    end)
                end
            end
        end
    end
end

function t1.Init() -- line: 703
    -- upvalues: Players (copy), RunService (copy), ContentProvider (copy), Remotes (copy), ShopUI (copy), ExclusiveShopController (copy), t1 (copy), LocalPlayer (copy), PlayerGui (copy), ScreenGui (ref), ScreenGui2 (ref), t3 (ref), t4 (copy), t5 (copy), t6 (ref), t7 (ref), closeMenu (copy), v21 (copy), onSenderUpdate (copy), onReceiverUpdate (copy)
    local ScreenGui3 = Instance.new("ScreenGui")

    ScreenGui3.Name = "GiftMenu"
    ScreenGui3.ResetOnSpawn = false
    ScreenGui3.IgnoreGuiInset = true
    ScreenGui3.DisplayOrder = 20
    ScreenGui3.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui3.Parent = PlayerGui
    ScreenGui = ScreenGui3

    local ScreenGui4 = Instance.new("ScreenGui")

    ScreenGui4.Name = "GiftRequest"
    ScreenGui4.ResetOnSpawn = false
    ScreenGui4.IgnoreGuiInset = true
    ScreenGui4.DisplayOrder = 55
    ScreenGui4.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui4.Parent = PlayerGui
    ScreenGui2 = ScreenGui4
    ExclusiveShopController.GiftRequested:Connect(t1.Open)
    Remotes.Event("Gift_Update").OnClientEvent:Connect(function(p31) -- line: 707
        -- upvalues: t4 (copy), onSenderUpdate (copy), onReceiverUpdate (copy)
        if type(p31) ~= "table" then
            return
        end

        if p31.Type ~= "Blocks" then
            onSenderUpdate(p31)
            onReceiverUpdate(p31)

            return
        end

        for v77, v78 in pairs(p31.Blocks or {}) do
            t4[tostring(v77)] = v78
        end
    end)
    Remotes.Event("Shop_Reward").OnClientEvent:Connect(function(p32) -- line: 717
        -- upvalues: ShopUI (copy), t7 (ref)
        if type(p32) ~= "table" or not p32.GiftFrom or not t7 then
            return
        end

        local t36 = t7

        if not t36 then
            return
        end

        t7 = nil
        task.delay(0, function() -- line: 532
            -- upvalues: t36 (copy), ShopUI (copy)
            ShopUI.Tween(t36.Dim, {
                BackgroundTransparency = 1
            }, 0.25)
            ShopUI.PopOut(t36.Panel.Root, 0.22, 0.6)
            task.delay(0.25, function() -- line: 535
                -- upvalues: t36 (copy)
                t36.Holder:Destroy()
            end)
        end)
    end)
    RunService.Heartbeat:Connect(function() -- line: 723
        -- upvalues: ExclusiveShopController (copy), t3 (ref), t6 (ref), closeMenu (copy)
        if t3 and not t6 and not ExclusiveShopController.IsOpen() then
            closeMenu()
        end
    end)

    local function warmHeadshot(p33) -- line: 727
        -- upvalues: Players (copy), ContentProvider (copy), LocalPlayer (copy), t5 (copy)
        if p33 ~= LocalPlayer then
            task.spawn(function() -- line: 729
                -- upvalues: p33 (copy), Players (copy), ContentProvider (copy), t5 (copy)
                local UserId = p33.UserId
                local result

                if t5[UserId] then
                    result = t5[UserId]
                else
                    local GetUserThumbnailAsync = Players.GetUserThumbnailAsync
                    local HeadShot = Enum.ThumbnailType.HeadShot
                    local Size150x150 = Enum.ThumbnailSize.Size150x150
                    local ok

                    ok, result = pcall(GetUserThumbnailAsync, Players, UserId, HeadShot, Size150x150)

                    if ok then
                        t5[UserId] = result
                    end

                    if not ok or not result then
                        result = ""
                    end
                end

                if result == "" then
                    return
                end

                local function v79() -- line: 732
                    -- upvalues: result (ref), ContentProvider (copy)
                    ContentProvider:PreloadAsync({
                        result
                    })
                end

                pcall(v79)
            end)
        end
    end

    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            task.spawn(function() -- line: 729
                -- upvalues: player (copy), Players (copy), ContentProvider (copy), t5 (copy)
                local UserId = player.UserId
                local result

                if t5[UserId] then
                    result = t5[UserId]
                else
                    local GetUserThumbnailAsync = Players.GetUserThumbnailAsync
                    local HeadShot = Enum.ThumbnailType.HeadShot
                    local Size150x150 = Enum.ThumbnailSize.Size150x150
                    local ok

                    ok, result = pcall(GetUserThumbnailAsync, Players, UserId, HeadShot, Size150x150)

                    if ok then
                        t5[UserId] = result
                    end

                    if not ok or not result then
                        result = ""
                    end
                end

                if result == "" then
                    return
                end

                local function v80() -- line: 732
                    -- upvalues: ContentProvider (copy), result (ref)
                    ContentProvider:PreloadAsync({
                        result
                    })
                end

                pcall(v80)
            end)
        end
    end

    Players.PlayerAdded:Connect(warmHeadshot)
    Players.PlayerRemoving:Connect(function(_) -- line: 738
        -- upvalues: t3 (ref), t6 (ref), v21 (copy)
        if t3 and t3.Page and not t6 and t3.Panel.Title.Text == "Gift" and t3.Page:FindFirstChild("List") and not t3.Page:FindFirstChild("Back") then
            task.defer(v21)
        end
    end)
end

return t1
