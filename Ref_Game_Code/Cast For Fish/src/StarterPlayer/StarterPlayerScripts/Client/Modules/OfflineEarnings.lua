-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Shared = ReplicatedStorage:WaitForChild("Shared")
local GameConfig = require(Shared.GameConfig)
local NumberFormat = require(Shared.NumberFormat)
local UIKit = require(script.Parent.UIKit)
local Products = require(Shared.Data.Products)
local Toasts = require(script.Parent.Toasts)
local MarketplaceService = game:GetService("MarketplaceService")
local v1 = utf8.char(57346)
local fromRGB = Color3.fromRGB
local v2, v3, v4, v5, v6, v7, v8
local t1 = {}

t1.Doubled = 0

local function layout(p1) -- line: 20
    -- upvalues: v7 (ref), v8 (ref)
    v7.Visible = p1

    local v9 = v8

    v9.Position = UDim2.new(p1 and 0.27 or 0.5, 0, 1, -22)
end

function t1.Double() -- line: 25
    -- upvalues: Products (copy), Toasts (copy), MarketplaceService (copy)
    local id = Products.OfflineDouble.id

    if not id or id == 0 then
        Toasts.Show("info", "Not on sale yet!")
    else
        local function v10() -- line: 31
            -- upvalues: id (copy), MarketplaceService (copy)
            MarketplaceService:PromptProductPurchase(game:GetService("Players").LocalPlayer, id)
        end

        pcall(v10)
    end
end

t1.Shown = 0
t1.Last = nil
t1.Checked = false

function t1.Busy() -- line: 39
    -- upvalues: t1 (copy), v3 (ref)
    local v11 = not t1.Checked

    if not v11 then
        v11 = v3 ~= nil and v3.Visible
    end

    return v11
end

local function span(p2) -- line: 43
    local v13 = math.floor(p2 / 60 + 0.5)

    if v13 < 60 then
        return v13 .. (if v13 == 1 then " minute" else " minutes")
    end

    local v15 = math.floor(v13 / 60)
    local v16 = v13 % 60

    return v15 .. "h" .. (if v16 > 0 then " " .. v16 .. "m" else "")
end

function t1.Close() -- line: 52
    -- upvalues: v3 (ref)
    if v3 then
        v3.Visible = false
    end
end

function t1.Show(p3) -- line: 58
    -- upvalues: GameConfig (copy), NumberFormat (copy), UIKit (copy), t1 (copy), v3 (ref), v4 (ref), v5 (ref), v6 (ref), v7 (ref), v8 (ref)
    if type(p3) ~= "table" then
        return
    end

    if type(p3.amount) == "number" and not (p3.amount <= 0) then
        if p3.doubled then
            t1.Doubled += 1

            if t1.Last and v3.Visible then
                v5.Text = "+" .. NumberFormat.money(t1.Last.amount + p3.amount)
                v6.Text = "DOUBLED!"
                UIKit.pop(v5, 1.6)
                UIKit.sound("ZoneChange", 1.4)
            end

            v7.Visible = false
            v8.Position = UDim2.new(0.5, 0, 1, -22)
        else
            t1.Shown += 1
            t1.Last = p3

            local v19 = v4
            local v21 = math.floor((p3.away or p3.seconds or 0) / 60 + 0.5)
            local v22

            if v21 < 60 then
                v22 = v21 .. (if v21 == 1 then " minute" else " minutes")
            else
                local v24 = math.floor(v21 / 60)
                local v25 = v21 % 60

                v22 = v24 .. "h" .. (if v25 > 0 then " " .. v25 .. "m" else "")
            end

            v19.Text = "You were away for " .. v22 .. ". Your fish kept earning!"
            v5.Text = "+" .. NumberFormat.money(p3.amount)

            local v27 = p3.pro == true
            local v28 = GameConfig.OFFLINE_RATE * (if v27 then GameConfig.OFFLINE_PRO_MULT else 1)
            local v29 = if v27 then GameConfig.OFFLINE_PRO_MAX_HOURS else GameConfig.OFFLINE_MAX_HOURS

            v6.Text = ("%sFish earn %d%% of their income while you are away, for up to %d hours%s"):format(v27 and "OFFLINE PRO: " or "", v28 * 100, v29, p3.capped and "  (you hit the limit!)" or "")
            v7.Visible = true
            v8.Position = UDim2.new(0.27, 0, 1, -22)
            v3.Visible = true
            UIKit.pop(v3, 0.7)
            UIKit.pop(v5, 1.4)
            UIKit.sound("ZoneChange", 1.2)
        end
    end
end

function t1.Init() -- line: 88
    -- upvalues: ReplicatedStorage (copy), UIKit (copy), Products (copy), MarketplaceService (copy), v1 (copy), t1 (copy), fromRGB (copy), v2 (ref), v3 (ref), v4 (ref), v5 (ref), v6 (ref), v7 (ref), v8 (ref)
    v2 = UIKit.screenGui("OfflineEarnings", 20)
    v3 = UIKit.frame(v2, {
        Name = "Card",
        Corner = 26,
        Stroke = 6,
        Size = UDim2.fromOffset(620, 330),
        Position = UDim2.fromScale(0.5, 0.45),
        AnchorPoint = Vector2.new(0.5, 0.5),
        Color = fromRGB(30, 34, 50),
        StrokeColor = fromRGB(255, 215, 60)
    })
    UIKit.text(v3, {
        Name = "Title",
        Text = "WELCOME BACK!",
        TextSize = 46,
        Stroke = 5,
        ZIndex = 2,
        Size = UDim2.new(1, -40, 0, 54),
        Position = UDim2.fromOffset(20, 16),
        Color = fromRGB(255, 215, 60)
    })
    v4 = UIKit.text(v3, {
        Name = "Away",
        Text = "",
        TextSize = 24,
        Stroke = 4,
        ZIndex = 2,
        Size = UDim2.new(1, -40, 0, 30),
        Position = UDim2.fromOffset(20, 76)
    })
    v4.TextScaled = true
    v5 = UIKit.text(v3, {
        Name = "Amount",
        Text = "",
        TextSize = 64,
        Stroke = 6,
        ZIndex = 2,
        Size = UDim2.new(1, -40, 0, 76),
        Position = UDim2.fromOffset(20, 112),
        Color = fromRGB(120, 255, 150)
    })
    v5.TextScaled = true
    v6 = UIKit.text(v3, {
        Name = "Note",
        Text = "",
        TextSize = 18,
        Stroke = 3,
        ZIndex = 2,
        Size = UDim2.new(1, -40, 0, 24),
        Position = UDim2.fromOffset(20, 194),
        Color = fromRGB(190, 200, 225)
    })
    v6.TextScaled = true
    v8 = UIKit.button(v3, {
        Name = "Collect",
        Text = "COLLECT",
        Corner = 18,
        ZIndex = 2,
        Size = UDim2.fromOffset(270, 66),
        Position = UDim2.new(0.27, 0, 1, -22),
        AnchorPoint = Vector2.new(0.5, 1),
        OnClick = t1.Close
    })
    v7 = UIKit.button(v3, {
        Name = "Double",
        Corner = 18,
        ZIndex = 2,
        Text = "x2  " .. v1 .. " " .. Products.OfflineDouble.robux,
        Size = UDim2.fromOffset(270, 66),
        Position = UDim2.new(0.73, 0, 1, -22),
        AnchorPoint = Vector2.new(0.5, 1),
        Color = UIKit.Colors.Gold,
        Color2 = UIKit.Colors.GoldDark,
        OnClick = t1.Double
    })
    v3.Visible = false
    task.spawn(function() -- line: 101
        -- upvalues: Products (copy), MarketplaceService (copy), v1 (copy), v7 (ref)
        local id = Products.OfflineDouble.id

        if not id or id == 0 then
            return
        end

        local function v32() -- line: 104
            -- upvalues: id (copy), MarketplaceService (copy)
            return MarketplaceService:GetProductInfo(id, Enum.InfoType.Product)
        end

        local ok, result = pcall(v32)
        local v33 = v7:FindFirstChildWhichIsA("TextLabel", true)

        if ok and result and type(result.PriceInRobux) == "number" and v33 then
            v33.Text = "x2  " .. v1 .. " " .. result.PriceInRobux
        end
    end)
    ReplicatedStorage.Remotes.OfflineEarnings.OnClientEvent:Connect(t1.Show)
    task.spawn(function() -- line: 115
        -- upvalues: ReplicatedStorage (copy), t1 (copy)
        task.wait(2.5)

        local function v34() -- line: 117
            -- upvalues: ReplicatedStorage (copy)
            return ReplicatedStorage.Remotes.GetOffline:InvokeServer()
        end

        local ok, result = pcall(v34)

        if ok and result then
            t1.Show(result)
        end

        t1.Checked = true
    end)
end

return t1
