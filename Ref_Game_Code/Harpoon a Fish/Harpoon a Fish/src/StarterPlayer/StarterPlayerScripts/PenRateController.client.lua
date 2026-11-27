-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local PenRate = PlayerGui:WaitForChild("HUD"):WaitForChild("PenRate")
local Format = require(ReplicatedStorage:WaitForChild("Modules"):WaitForChild("Format"))
local PassPerks = require(ReplicatedStorage:WaitForChild("Modules"):WaitForChild("PassPerks"))
local ShopConfig = require(ReplicatedStorage:WaitForChild("Modules"):WaitForChild("ShopConfig"))
local GrowthDisplay = require(ReplicatedStorage:WaitForChild("Modules"):WaitForChild("GrowthDisplay"))
local Loc = require(ReplicatedStorage:WaitForChild("Modules"):WaitForChild("Loc"))
local v2 = "Fish grow " .. math.floor((GrowthDisplay.ONLINE_SPEED - 1) * 100 + 0.5) .. "% faster while <font color=\"#78FF50\">ONLINE!</font>"
local VIP_GRADIENT = PassPerks.VIP_GRADIENT
local Plots = workspace:WaitForChild("Plots")
local PurchaseFX = require(ReplicatedStorage:WaitForChild("Modules"):WaitForChild("PurchaseFX"))
local ButtonHover = require(ReplicatedStorage:WaitForChild("Modules"):WaitForChild("ButtonHover"))
local v3, v4

for _, v5 in ipairs(ShopConfig.PASSES) do
    if v5.key == "Cash2x" then
        v4 = v5
        v3 = v5
    end
end

local v6 = v4 and v4.price
local v7 = ShopConfig.CASH4.price
local v8, v9

for _, v10 in ipairs(ShopConfig.PASSES) do
    if v10.key == "Grow2x" then
        v9 = v10
        v8 = v10
    end
end

local v11 = v9 and v9.price
local v12, v13

for _, v14 in ipairs(ShopConfig.PASSES) do
    if v14.key == "Feed2x" then
        v13 = v14
        v12 = v14
    end
end

local v15 = v13 and v13.price
local new = ColorSequenceKeypoint.new
local t1 = {
    title = "QUADRUPLE YOUR $/sec",
    card = {
        "rbxassetid://108767694400147",
        Vector2.new(9, 15),
        Vector2.new(1003, 683)
    },
    burst = Color3.fromRGB(255, 250, 220),
    grad = ColorSequence.new({
        new(0, Color3.fromRGB(253, 250, 75)),
        new(0.5, Color3.fromRGB(253, 215, 20)),
        new(1, Color3.fromRGB(240, 165, 0))
    }),
    stroke = Color3.fromRGB(90, 40, 0)
}
local _ = {
    MOVE = 20,
    TIME = 0.6
}
local Cubic = Enum.EasingStyle.Cubic
local _ = {
    SCALE = 1.08,
    TIME = 0.3
}

local function commas(p1) -- line: 114
    local v17 = tostring(p1)

    repeat
        local v18

        v17, v18 = v17:gsub("^(%d+)(%d%d%d)", "%1,%2")
    until v18 == 0

    return v17
end

local t2 = {}
local v19

local function dressCash(p2) -- line: 124
    -- upvalues: LocalPlayer (copy), PassPerks (copy), ShopConfig (copy), Loc (copy), v3 (ref), v6 (ref), v7 (ref), v8 (ref), v11 (ref), v12 (ref), v15 (ref), t1 (copy)
    if p2.card then
        local Cash2x = PassPerks.Owns(LocalPlayer, "Cash2x")
        local card, cash2 = p2.card, p2.cash2
        local v20, v21

        if p2.owner ~= LocalPlayer or v3 == nil then
            v21 = false
        else
            v20 = Cash2x and LocalPlayer:GetAttribute("Cash4x") == true
            v21 = not v20
        end

        card.Visible = v21
        card.Icon.Image = Cash2x and ShopConfig.CASH4.image or cash2.icon

        local Badge = card.Badge

        if Cash2x then
            Badge.Text = "x4"
        else
            Badge.Text = cash2.badge
        end

        card.Badge.UIGradient.Color = Cash2x and t1.grad or cash2.badgeGrad
        card.Badge.UIStroke.Color = Cash2x and t1.stroke or cash2.badgeStroke
        card.Badge.TextColor3 = Cash2x and Color3.new(1, 1, 1) or cash2.badgeColor
        card.Image = Cash2x and t1.card[1] or cash2.card[1]
        card.ImageRectOffset = Cash2x and t1.card[2] or cash2.card[2]
        card.ImageRectSize = Cash2x and t1.card[3] or cash2.card[3]
        card.Burst.ImageColor3 = Cash2x and t1.burst or cash2.burst
        card.Title.Text = Cash2x and Loc.T(t1.title) or cash2.title
        card.Title.UIGradient.Color = Cash2x and t1.grad or cash2.grad
        card.Title.UIStroke.Color = Cash2x and t1.stroke or cash2.stroke

        local Buy, Buy4 = card.Buy, card.Buy4

        Buy.Visible = not Cash2x
        Buy4.Visible = Cash2x
        card.Buy.Text.Text = utf8.char(57346) .. " " .. tostring(v6 or "?")
        card.Buy4.Price.Text = utf8.char(57346) .. " " .. tostring(v7 or "?")

        local grow, feed = p2.grow, p2.feed

        if grow then
            if p2.owner ~= LocalPlayer or v8 == nil then
                grow.Visible = false
            else
                grow.Visible = not PassPerks.Owns(LocalPlayer, "Grow2x")
            end

            grow.Buy.Price.Text = utf8.char(57346) .. " " .. tostring(v11 or "?")
        end

        if feed then
            if p2.owner ~= LocalPlayer or v12 == nil then
                feed.Visible = false
            else
                feed.Visible = not PassPerks.Owns(LocalPlayer, "Feed2x")
            end

            feed.Buy.Price.Text = utf8.char(57346) .. " " .. tostring(v15 or "?")
        end

        local StackBottomY = p2.gui:GetAttribute("StackBottomY")
        local StackPitch = p2.gui:GetAttribute("StackPitch")

        if StackBottomY and StackPitch then
            for _, v30 in ipairs({ grow, feed, card }) do
                if v30 and v30.Visible then
                    v30.Position = UDim2.fromScale(v30.Position.X.Scale, StackBottomY)
                    StackBottomY -= StackPitch
                end
            end
        end
    end
end

local function writeBoost(p3, p4) -- line: 166
    -- upvalues: TweenService (copy), PassPerks (copy), VIP_GRADIENT (copy), v19 (ref), dressCash (copy)
    dressCash(p3)

    local PenBoost = p3.owner and p3.owner:GetAttribute("PenBoost") or 0
    local v31 = "(+" .. string.format("%.1f", PenBoost):gsub("%.0$", "") .. "%)"

    p3.boost.Visible = PenBoost >= 0.05

    local v32 = p3.owner and PassPerks.CashMul(p3.owner) or 1
    local v33 = "(x" .. string.format("%.2f", v32):gsub("0+$", ""):gsub("%.$", "") .. ")"

    p3.mult.Visible = v32 > 1.001

    local UIGradient = p3.mult:FindFirstChildOfClass("UIGradient")

    if UIGradient then
        UIGradient.Color = p3.owner and PassPerks.Owns(p3.owner, "VIP") and VIP_GRADIENT or p3.moneyGrad
    end

    local v34 = v31 ~= p3.boost.Text or v33 ~= p3.mult.Text
    local boost, mult = p3.boost, p3.mult

    boost.Text = v31
    mult.Text = v33
    v19(p3)

    if v34 and p4 then
        for _, v35 in ipairs({
                p3.boost,
                p3.mult
            }) do
            v35.Pop.Scale = 1.08
            TweenService:Create(v35.Pop, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                Scale = 1
            }):Play()
        end
    end
end

v19 = function(p5) -- line: 190
    local AbsoluteSize = p5.row.AbsoluteSize

    if AbsoluteSize.X <= 0 then
        return
    end

    local v36 = AbsoluteSize.Y / AbsoluteSize.X
    local v37 = p5.amount.TextBounds.X / AbsoluteSize.X
    local v38 = 0.5 + (v36 + 0.012) / 2

    p5.amount.Position = UDim2.fromScale(v38, 0.5)
    p5.icon.Position = UDim2.fromScale(v38 - v37 / 2 - 0.012, 0.5)

    local Y = p5.gui.CanvasSize.Y
    local v39 = (p5.row.Position.Y.Scale - p5.row.AnchorPoint.Y * p5.row.Size.Y.Scale) * Y
    local v40 = v39 + p5.row.Size.Y.Scale * Y / 2 + p5.amount.TextBounds.Y / 2
    local v41 = p5.row.Position.X.Scale - p5.row.AnchorPoint.X * p5.row.Size.X.Scale

    p5.boost.Position = UDim2.fromScale(v41 + v38 * p5.row.Size.X.Scale, (v40 - 0.05 * p5.amount.TextBounds.Y) / Y)

    if p5.rank then
        local v42 = v39 + p5.row.Size.Y.Scale * Y / 2 - p5.amount.TextBounds.Y / 2

        p5.rank.Position = UDim2.fromScale(v41 + v38 * p5.row.Size.X.Scale, (v42 + -0.1 * p5.amount.TextBounds.Y) / Y)
    end

    local X = p5.gui.CanvasSize.X

    if not (X > 0) then
        return
    end

    local Scale = p5.boost.Position.X.Scale
    local Scale2 = p5.boost.Position.Y.Scale

    if p5.boost.Visible then
        p5.mult.AnchorPoint = Vector2.new(0, p5.boost.AnchorPoint.Y)
        p5.mult.TextXAlignment = Enum.TextXAlignment.Left
        p5.mult.Position = UDim2.fromScale(Scale + 0.5 * p5.boost.TextBounds.X / X + 0.012, Scale2)
    else
        p5.mult.AnchorPoint = p5.boost.AnchorPoint
        p5.mult.TextXAlignment = p5.boost.TextXAlignment
        p5.mult.Position = p5.boost.Position
    end
end

local function write(p6, p7) -- line: 228
    -- upvalues: Format (copy), v19 (ref)
    p6.shown = p7
    p6.amount.Text = Format.money(p7) .. "/sec"
    v19(p6)
end

local function countTo(p8, p9) -- line: 234
    -- upvalues: TweenService (copy)
    if p9 == p8.to then
        return
    end

    local shown = p8.shown
    local elapsed = os.clock()

    p8.from = shown
    p8.to = p9
    p8.t0 = elapsed

    local Pop = p8.row:FindFirstChild("Pop")

    if Pop then
        Pop.Scale = 1.08
        TweenService:Create(Pop, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
            Scale = 1
        }):Play()
    end
end

local function writeRank(p10, p11) -- line: 245
    p10.rankShown = p11

    local Number = p10.rank.Number
    local v45 = tostring((math.floor(p11 + 0.5)))

    repeat
        local v46

        v45, v46 = v45:gsub("^(%d+)(%d%d%d)", "%1,%2")
    until v46 == 0

    Number.Text = "#" .. v45
end

local function setRank(p12, p13, p14) -- line: 249
    -- upvalues: TweenService (copy)
    if p12.rank then
        if type(p13) == "number" then
            if p13 ~= p12.rankTo then
                local Pop = p12.rank.Pop

                if not (p14 and p12.rankTo) then
                    p12.rankTo = p13
                    p12.rankT0 = nil
                    p12.rankShown = p13

                    local Number = p12.rank.Number
                    local v49 = tostring((math.floor(p13 + 0.5)))

                    repeat
                        local v50

                        v49, v50 = v49:gsub("^(%d+)(%d%d%d)", "%1,%2")
                    until v50 == 0

                    Number.Text = "#" .. v49
                else
                    local rankShown = p12.rankShown
                    local elapsed = os.clock()

                    p12.rankFrom = rankShown
                    p12.rankTo = p13
                    p12.rankT0 = elapsed
                end

                p12.rank.Visible = true

                if p14 then
                    Pop.Scale = 1.08
                    TweenService:Create(Pop, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                        Scale = 1
                    }):Play()
                end
            end
        else
            p12.rank.Visible = false
            p12.rankTo = nil
            p12.rankT0 = nil
        end
    end
end

local function boardOf(p15) -- line: 270
    -- upvalues: LocalPlayer (copy), PlayerGui (copy), PenRate (copy), PassPerks (copy), ShopConfig (copy), Loc (copy), v2 (copy), PurchaseFX (copy), ButtonHover (copy), v3 (ref), v8 (ref), v12 (ref), t2 (copy), v19 (ref), dressCash (copy)
    local v51 = t2[p15]

    if v51 then
        return v51
    end

    local clone = PenRate:Clone()

    clone.Name = "PenRate_" .. p15.Name
    clone.Enabled = false
    clone.Parent = PlayerGui

    local t3 = {
        shown = 0,
        to = 0,
        gui = clone,
        row = clone.Row,
        icon = clone.Row.Icon,
        amount = clone.Row.Amount,
        boost = clone.Boost,
        mult = clone.Boost:Clone()
    }

    t3.mult.Name = "Mult"
    t3.mult.Visible = false
    t3.mult.Parent = clone

    local UIGradient = t3.mult:FindFirstChildOfClass("UIGradient")

    t3.moneyGrad = UIGradient and UIGradient.Color
    t3.boost:GetPropertyChangedSignal("TextBounds"):Connect(function() -- line: 284
        -- upvalues: t3 (copy), v19 (ref)
        v19(t3)
    end)
    t3.amount:GetPropertyChangedSignal("TextBounds"):Connect(function() -- line: 285
        -- upvalues: t3 (copy), v19 (ref)
        v19(t3)
    end)
    t3.row:GetPropertyChangedSignal("AbsoluteSize"):Connect(function() -- line: 286
        -- upvalues: t3 (copy), v19 (ref)
        v19(t3)
    end)
    t3.rank = clone:FindFirstChild("Rank")

    if t3.rank then
        t3.rank.Label.Text = Loc.T(t3.rank.Label.Text)
    end

    local Online = clone:FindFirstChild("Online")

    if Online then
        Online.Text.Text = v2

        local function placeOnline() -- line: 293
            -- upvalues: Online (copy)
            local X = Online.AbsoluteSize.X

            if X > 0 then
                Online.Icon.Position = UDim2.fromScale(1 - Online.Text.TextBounds.X / X - 0.008, 0.5)
            end
        end

        Online.Text:GetPropertyChangedSignal("TextBounds"):Connect(placeOnline)
        Online:GetPropertyChangedSignal("AbsoluteSize"):Connect(placeOnline)

        local X = Online.AbsoluteSize.X

        if X > 0 then
            Online.Icon.Position = UDim2.fromScale(1 - Online.Text.TextBounds.X / X - 0.008, 0.5)
        end
    end

    t3.card = clone:FindFirstChild("CashCard")

    if t3.card then
        local card = t3.card

        t3.cash2 = {
            icon = card.Icon.Image,
            badge = card.Badge.Text,
            card = {
                card.Image,
                card.ImageRectOffset,
                card.ImageRectSize
            },
            burst = card.Burst.ImageColor3,
            title = card.Title.Text,
            grad = card.Title.UIGradient.Color,
            stroke = card.Title.UIStroke.Color,
            badgeGrad = card.Badge.UIGradient.Color,
            badgeStroke = card.Badge.UIStroke.Color,
            badgeColor = card.Badge.TextColor3
        }
        card.Title.AutoLocalize = false
        t3.cash2.title = Loc.T(t3.cash2.title)
        card.Buy.Text.AutoLocalize = false
        ButtonHover.Attach(card.Buy, {
            shine = false,
            tile = 1,
            highlight = true,
            highlightFade = 0.8,
            highlightCorner = 0.25,
            corner = 0.25
        })
        ButtonHover.Attach(card.Buy4, {
            shine = false,
            tile = 1,
            iconTilt = -20,
            highlight = true,
            highlightCorner = 0.3,
            highlightFade = 0.75,
            icon = card.Buy4:FindFirstChild("Icon")
        })

        local t5 = {}

        local function isPress(p16) -- line: 315
            if p16.UserInputType == Enum.UserInputType.MouseButton1 then
                return true
            end

            return p16.UserInputType == Enum.UserInputType.Touch
        end

        local function holdingFish() -- line: 321
            -- upvalues: LocalPlayer (copy)
            local v52 = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildWhichIsA("Tool")

            return v52 ~= nil and v52:GetAttribute("BagId") ~= nil
        end

        local function wireTap(p17, p18, p19) -- line: 326
            -- upvalues: t5 (copy), LocalPlayer (copy)
            for _, v53 in ipairs(p18) do
                v53.InputBegan:Connect(function(p20) -- line: 328
                    -- upvalues: t5 (copy), LocalPlayer (copy)
                    if p20.UserInputType == Enum.UserInputType.MouseButton1 or p20.UserInputType == Enum.UserInputType.Touch then
                        local v54 = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildWhichIsA("Tool")

                        if v54 == nil or v54:GetAttribute("BagId") == nil then
                            t5[p20] = {
                                pos = p20.Position,
                                t = os.clock()
                            }
                        end
                    end
                end)
                v53.InputEnded:Connect(function(p21) -- line: 331
                    -- upvalues: p17 (copy), p19 (copy), t5 (copy)
                    local v55 = t5[p21]

                    t5[p21] = nil

                    if v55 and (p21.UserInputType == Enum.UserInputType.MouseButton1 or p21.UserInputType == Enum.UserInputType.Touch) and not ((p21.Position - v55.pos).Magnitude > 20 or os.clock() - v55.t > 0.6) and p17.Visible then
                        p19()
                    end
                end)
            end
        end

        wireTap(card, {
            card,
            card.Buy,
            card.Buy4
        }, function() -- line: 341
            -- upvalues: card (copy), LocalPlayer (copy), PassPerks (copy), ShopConfig (copy), PurchaseFX (copy), ButtonHover (copy), v3 (ref)
            ButtonHover.Press(card.Buy4.Visible and card.Buy4 or card.Buy)

            if PassPerks.Owns(LocalPlayer, "Cash2x") then
                PurchaseFX.Buy(ShopConfig.CASH4.product)
            else
                PurchaseFX.BuyPass(v3.pass)
            end
        end)
        t3.grow = clone:FindFirstChild("GrowCard")

        if t3.grow and v8 then
            local grow = t3.grow

            grow.Title.AutoLocalize = false
            grow.Title.Text = Loc.T(grow.Title.Text)
            grow.Buy.Price.AutoLocalize = false
            ButtonHover.Attach(grow.Buy, {
                shine = false,
                tile = 1,
                iconTilt = -20,
                highlight = true,
                highlightCorner = 0.3,
                highlightFade = 0.75,
                icon = grow.Buy:FindFirstChild("Icon")
            })
            wireTap(grow, {
                grow,
                grow.Buy
            }, function() -- line: 353
                -- upvalues: grow (copy), PurchaseFX (copy), ButtonHover (copy), v8 (ref)
                ButtonHover.Press(grow.Buy)
                PurchaseFX.BuyPass(v8.pass)
            end)
        end

        t3.feed = clone:FindFirstChild("FeedCard")

        if t3.feed and v12 then
            local feed = t3.feed

            feed.Title.AutoLocalize = false
            feed.Title.Text = Loc.T(feed.Title.Text)
            feed.Buy.Price.AutoLocalize = false
            ButtonHover.Attach(feed.Buy, {
                shine = false,
                tile = 1,
                iconTilt = -20,
                highlight = true,
                highlightCorner = 0.3,
                highlightFade = 0.75,
                icon = feed.Buy:FindFirstChild("Icon")
            })
            wireTap(feed, {
                feed,
                feed.Buy
            }, function() -- line: 366
                -- upvalues: feed (copy), PurchaseFX (copy), ButtonHover (copy), v12 (ref)
                ButtonHover.Press(feed.Buy)
                PurchaseFX.BuyPass(v12.pass)
            end)
        end

        dressCash(t3)
    end

    t2[p15] = t3

    return t3
end

local function scan() -- line: 381
    -- upvalues: Players (copy), Format (copy), ShopConfig (copy), Plots (copy), v19 (ref), writeBoost (copy), countTo (copy), setRank (copy), boardOf (copy)
    for _, child in ipairs(Plots:GetChildren()) do
        local v56 = boardOf(child)
        local Aquarium = child:FindFirstChild("Aquarium")
        local GlassFront = Aquarium and Aquarium:FindFirstChild("GlassFront")

        if v56.gui.Adornee ~= GlassFront then
            v56.gui.Adornee = GlassFront
        end

        local PlayerByUserId = Players:GetPlayerByUserId(child:GetAttribute("OwnerUserId") or 0)

        if PlayerByUserId ~= v56.owner then
            if v56.conn then
                v56.conn:Disconnect()
            end

            if v56.boostConn then
                v56.boostConn:Disconnect()
            end

            if v56.rankConn then
                v56.rankConn:Disconnect()
            end

            for _, v57 in ipairs(v56.passConns or {}) do
                v57:Disconnect()
            end

            local t9 = {}

            v56.owner = PlayerByUserId
            v56.conn = nil
            v56.boostConn = nil
            v56.rankConn = nil
            v56.t0 = nil
            v56.passConns = t9
            writeBoost(v56, false)
            v56.rankTo = nil

            local MoneyRank = PlayerByUserId and PlayerByUserId:GetAttribute("MoneyRank")

            if v56.rank then
                if type(MoneyRank) == "number" then
                    if MoneyRank ~= v56.rankTo then
                        local _ = v56.rank.Pop

                        v56.rankTo = MoneyRank
                        v56.rankT0 = nil
                        v56.rankShown = MoneyRank

                        local Number = v56.rank.Number
                        local v60 = tostring((math.floor(MoneyRank + 0.5)))

                        repeat
                            local v61

                            v60, v61 = v60:gsub("^(%d+)(%d%d%d)", "%1,%2")
                        until v61 == 0

                        Number.Text = "#" .. v60
                        v56.rank.Visible = true
                    end
                else
                    v56.rank.Visible = false
                    v56.rankTo = nil
                    v56.rankT0 = nil
                end
            end

            if PlayerByUserId then
                v56.to = PlayerByUserId:GetAttribute("PenRate") or 0

                local to = v56.to

                v56.shown = to
                v56.amount.Text = Format.money(to) .. "/sec"
                v19(v56)
                v56.conn = PlayerByUserId:GetAttributeChangedSignal("PenRate"):Connect(function() -- line: 400
                    -- upvalues: v56 (copy), PlayerByUserId (copy), countTo (copy)
                    countTo(v56, PlayerByUserId:GetAttribute("PenRate") or 0)
                end)
                v56.boostConn = PlayerByUserId:GetAttributeChangedSignal("PenBoost"):Connect(function() -- line: 403
                    -- upvalues: v56 (copy), writeBoost (copy)
                    writeBoost(v56, true)
                end)
                v56.rankConn = PlayerByUserId:GetAttributeChangedSignal("MoneyRank"):Connect(function() -- line: 404
                    -- upvalues: v56 (copy), PlayerByUserId (copy), setRank (copy)
                    setRank(v56, PlayerByUserId:GetAttribute("MoneyRank"), true)
                end)

                for _, v62 in ipairs(ShopConfig.PASSES) do
                    table.insert(v56.passConns, PlayerByUserId:GetAttributeChangedSignal(ShopConfig.PassAttr(v62.key)):Connect(function() -- line: 408
                        -- upvalues: v56 (copy), writeBoost (copy)
                        writeBoost(v56, true)
                    end))
                end

                table.insert(v56.passConns, PlayerByUserId:GetAttributeChangedSignal("Cash4x"):Connect(function() -- line: 411
                    -- upvalues: v56 (copy), writeBoost (copy)
                    writeBoost(v56, true)
                end))
                table.insert(v56.passConns, PlayerByUserId:GetAttributeChangedSignal("TitanMoney"):Connect(function() -- line: 413
                    -- upvalues: v56 (copy), writeBoost (copy)
                    writeBoost(v56, true)
                end))
            end
        end

        local gui = v56.gui

        if PlayerByUserId ~= nil then
            gui.Enabled = GlassFront ~= nil
        else
            gui.Enabled = false
        end
    end
end

task.spawn(function() -- line: 420
    -- upvalues: ShopConfig (copy), v3 (ref), v6 (ref), v7 (ref), v8 (ref), v11 (ref), v12 (ref), v15 (ref), t2 (copy), dressCash (copy)
    if not (v3 and v3.pass) then
        return
    end

    local GetProductInfo = game:GetService("MarketplaceService").GetProductInfo
    local MarketplaceService = game:GetService("MarketplaceService")
    local pass = v3.pass
    local GamePass = Enum.InfoType.GamePass
    local ok, result = pcall(GetProductInfo, MarketplaceService, pass, GamePass)

    if ok and type(result) == "table" and type(result.PriceInRobux) == "number" then
        v6 = result.PriceInRobux
    end

    if v8 and v8.pass then
        local GetProductInfo = game:GetService("MarketplaceService").GetProductInfo
        local MarketplaceService = game:GetService("MarketplaceService")
        local pass = v8.pass
        local GamePass = Enum.InfoType.GamePass
        local ok, result = pcall(GetProductInfo, MarketplaceService, pass, GamePass)

        if ok and type(result) == "table" and type(result.PriceInRobux) == "number" then
            v11 = result.PriceInRobux
        end
    end

    if v12 and v12.pass then
        local GetProductInfo = game:GetService("MarketplaceService").GetProductInfo
        local MarketplaceService = game:GetService("MarketplaceService")
        local pass = v12.pass
        local GamePass = Enum.InfoType.GamePass
        local ok, result = pcall(GetProductInfo, MarketplaceService, pass, GamePass)

        if ok and type(result) == "table" and type(result.PriceInRobux) == "number" then
            v15 = result.PriceInRobux
        end
    end

    local GetProductInfo2 = game:GetService("MarketplaceService").GetProductInfo
    local MarketplaceService2 = game:GetService("MarketplaceService")
    local product = ShopConfig.CASH4.product
    local Product = Enum.InfoType.Product
    local ok2, result2 = pcall(GetProductInfo2, MarketplaceService2, product, Product)

    if ok2 and type(result2) == "table" and type(result2.PriceInRobux) == "number" then
        v7 = result2.PriceInRobux
    end

    for _, v66 in pairs(t2) do
        dressCash(v66)
    end
end)

local n1 = 1

local function watchPlot(p22) -- line: 438
    -- upvalues: scan (copy)
    p22.ChildAdded:Connect(function(p23) -- line: 439
        -- upvalues: scan (copy)
        if p23.Name == "Aquarium" then
            if p23:FindFirstChild("GlassFront") then
                scan()
            else
                task.spawn(function() -- line: 444
                    -- upvalues: p23 (copy), scan (copy)
                    if p23:WaitForChild("GlassFront", 5) then
                        scan()
                    end
                end)
            end
        end
    end)
end

for _, child in ipairs(Plots:GetChildren()) do
    child.ChildAdded:Connect(function(p24) -- line: 439
        -- upvalues: scan (copy)
        if p24.Name == "Aquarium" then
            if p24:FindFirstChild("GlassFront") then
                scan()
            else
                task.spawn(function() -- line: 444
                    -- upvalues: scan (copy), p24 (copy)
                    if p24:WaitForChild("GlassFront", 5) then
                        scan()
                    end
                end)
            end
        end
    end)
end

Plots.ChildAdded:Connect(watchPlot)
RunService.Heartbeat:Connect(function(p25) -- line: 450
    -- upvalues: TweenService (copy), Format (copy), Cubic (copy), t2 (copy), v19 (ref), scan (copy), n1 (ref)
    n1 += p25

    if n1 >= 1 then
        n1 = 0
        scan()
    end

    local elapsed = os.clock()

    for _, v67 in pairs(t2) do
        if v67.t0 then
            local v69 = math.min(1, (elapsed - v67.t0) / 1.5)
            local v70 = v67.from + (v67.to - v67.from) * TweenService:GetValue(v69, Cubic, Enum.EasingDirection.Out)

            v67.shown = v70
            v67.amount.Text = Format.money(v70) .. "/sec"
            v19(v67)

            if v69 >= 1 then
                v67.t0 = nil
            end
        end

        if v67.rankT0 then
            local v72 = math.min(1, (elapsed - v67.rankT0) / 1.5)
            local v73 = v67.rankFrom + (v67.rankTo - v67.rankFrom) * TweenService:GetValue(v72, Cubic, Enum.EasingDirection.Out)

            v67.rankShown = v73

            local Number = v67.rank.Number
            local v76 = tostring((math.floor(v73 + 0.5)))

            repeat
                local v77

                v76, v77 = v76:gsub("^(%d+)(%d%d%d)", "%1,%2")
            until v77 == 0

            Number.Text = "#" .. v76

            if v72 >= 1 then
                v67.rankT0 = nil
            end
        end
    end
end)
