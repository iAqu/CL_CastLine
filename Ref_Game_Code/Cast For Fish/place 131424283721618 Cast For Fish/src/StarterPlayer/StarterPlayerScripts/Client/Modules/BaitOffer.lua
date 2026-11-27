-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Shared = ReplicatedStorage:WaitForChild("Shared")
local Baits = require(Shared.Data.Baits)
local NumberFormat = require(Shared.NumberFormat)
local UIKit = require(script.Parent.UIKit)
local DataClient = require(script.Parent.DataClient)
local HUD = require(script.Parent.HUD)
local Notifications = require(script.Parent.Notifications)
local fromRGB = Color3.fromRGB
local v1, v2, v3, v4, v5, v6, v7
local v8 = false
local v9
local t1 = {}

t1.Offered = nil
t1.SHOW_TIME = 8
t1.DotVisible = false

local v10 = nil
local v11, v12

local function best() -- line: 27
    -- upvalues: Baits (copy), DataClient (copy)
    local v13 = DataClient.Get("BaitsOwned") or {}
    local v14 = DataClient.Get("Cash") or 0
    local n1 = 0

    for v15 in pairs(v13) do
        local v16 = Baits.ById[v15]

        if v16 and n1 < v16.order then
            n1 = v16.order
        end
    end

    local v17

    for _, v18 in ipairs(Baits.List) do
        if n1 < v18.order and v18.price > 0 and v18.price <= v14 then
            v17 = v18
        end
    end

    return v17
end

function t1.Buy() -- line: 46
    -- upvalues: ReplicatedStorage (copy), v7 (ref), v8 (ref)
    if not v7 or v8 then
        return
    end

    v8 = true

    local id = v7.id

    task.spawn(function() -- line: 52
        -- upvalues: id (copy), ReplicatedStorage (copy), v8 (ref)
        local function v20() -- line: 53
            -- upvalues: id (copy), ReplicatedStorage (copy)
            ReplicatedStorage.Remotes.BuyBait:InvokeServer(id)
        end

        pcall(v20)
        v8 = false
    end)
end

local function setDot(p1) -- line: 60
    -- upvalues: UIKit (copy), t1 (copy), v11 (ref), v12 (ref)
    v12 = p1
    t1.DotVisible = p1 ~= nil

    if not v11 then
        return
    end

    local v21 = v11

    v21.Visible = p1 ~= nil

    if p1 then
        UIKit.pop(v11, 1.4)
    end
end

function t1.Close() -- line: 85
    -- upvalues: UIKit (copy), t1 (copy), v2 (ref), v7 (ref), v9 (ref), v10 (ref), v11 (ref), v12 (ref)
    v9 = v7 and v7.id or nil

    if v2 then
        v2.Visible = false
    end

    if v10 then
        local v22 = v10

        v10 = nil
        v22:Done()
    end

    if not v7 then
        return
    end

    local id = v7.id

    v12 = id
    t1.DotVisible = id ~= nil

    if not v11 then
        return
    end

    v11.Visible = id ~= nil

    if id then
        UIKit.pop(v11, 1.4)
    end
end

function t1.IsVisible() -- line: 90
    -- upvalues: v2 (ref)
    return v2 ~= nil and v2.Visible
end

local function present(p2) -- line: 94
    -- upvalues: UIKit (copy), HUD (copy), t1 (copy), v2 (ref), v6 (ref), v7 (ref), v9 (ref), v10 (ref), v11 (ref), v12 (ref)
    if v10 == p2 and v7 and v7.id ~= v9 and HUD.GetMode() == "normal" then
        local id = v7.id

        v2.Visible = true
        UIKit.pop(v2, 0.6)
        UIKit.pop(v6, 1.35)
        UIKit.sound("ZoneChange", 1.1)
        task.delay(t1.SHOW_TIME, function() -- line: 107
            -- upvalues: p2 (copy), id (copy), UIKit (copy), t1 (copy), v2 (ref), v7 (ref), v10 (ref), v11 (ref), v12 (ref)
            if v10 ~= p2 then
                return
            end

            local v25 = v7 ~= nil and v7.id == id

            if v2 then
                v2.Visible = false
            end

            if v10 then
                local v26 = v10

                v10 = nil
                v26:Done()
            end

            if not (v25 and v7) then
                return
            end

            local id2 = v7.id

            v12 = id2
            t1.DotVisible = id2 ~= nil

            if v11 then
                v11.Visible = id2 ~= nil

                if id2 then
                    UIKit.pop(v11, 1.4)
                end
            end
        end)
    else
        if v10 == p2 then
            v10 = nil
        end

        p2:Done()
    end
end

local function refresh() -- line: 114
    -- upvalues: NumberFormat (copy), Notifications (copy), t1 (copy), v2 (ref), v3 (ref), v4 (ref), v5 (ref), v7 (ref), v9 (ref), v10 (ref), v11 (ref), v12 (ref), best (copy), present (copy)
    local v29 = best()

    if v29 == v7 then
        return
    end

    if v10 then
        if v2 then
            v2.Visible = false
        end

        if v10 then
            local v31 = v10

            v10 = nil
            v31:Done()
        end
    end

    v7 = v29
    t1.Offered = v29 and v29.id or nil

    if v12 and (not v29 or v29.id ~= v12) then
        v12 = nil
        t1.DotVisible = false

        if v11 then
            v11.Visible = false
        end
    end

    if not v29 then
        return
    end

    v3.Text = v29.name
    v4.Text = "x" .. tostring(v29.luck) .. " Luck"
    t1.ShowPicture(v29.id)
    v5.Text = "BUY  " .. NumberFormat.money(v29.price)

    if v29.id ~= v9 then
        v10 = Notifications.Shared:Push({
            priority = Notifications.EQUIPMENT,
            key = "bait:" .. v29.id,
            show = present
        })

        if v10.State == "dropped" then
            v10 = nil
            v7 = nil
            t1.Offered = nil
        end
    end
end

function t1.ShowPicture(p3) -- line: 146
    -- upvalues: ReplicatedStorage (copy), UIKit (copy), v6 (ref)
    if not v6 then
        return
    end

    for _, child in ipairs(v6:GetChildren()) do
        if child:IsA("ViewportFrame") then
            child:Destroy()
        end
    end

    local Assets = ReplicatedStorage:FindFirstChild("Assets")
    local Baits = Assets and Assets:FindFirstChild("Baits")
    local v35 = Baits and Baits:FindFirstChild(p3)

    if v35 and v35:IsA("Model") then
        UIKit.viewModel(v6, v35, {
            Name = "Bait",
            ZIndex = 4,
            Spin = 45,
            Zoom = 0.85,
            Size = UDim2.new(1, -12, 1, -12),
            Position = UDim2.fromScale(0.5, 0.5),
            AnchorPoint = Vector2.new(0.5, 0.5)
        })
    end
end

local function buildDot() -- line: 163
    -- upvalues: UIKit (copy), HUD (copy), fromRGB (copy), v11 (ref), v12 (ref)
    local ShopButton = HUD.ShopButton

    if not ShopButton then
        return
    end

    v11 = UIKit.frame(ShopButton, {
        Name = "BaitDot",
        Corner = 20,
        Stroke = 4,
        ZIndex = 20,
        Size = UDim2.fromOffset(40, 40),
        Position = UDim2.new(1, -4, 0, 4),
        AnchorPoint = Vector2.new(0.5, 0.5),
        Color = fromRGB(255, 50, 60),
        Color2 = fromRGB(200, 20, 35)
    })

    local v36 = v11

    v36.Visible = v12 ~= nil
end

function t1.Init() -- line: 172
    -- upvalues: RunService (copy), UIKit (copy), DataClient (copy), HUD (copy), t1 (copy), fromRGB (copy), v1 (ref), v2 (ref), v3 (ref), v4 (ref), v5 (ref), v6 (ref), v7 (ref), v10 (ref), v11 (ref), v12 (ref), refresh (copy), buildDot (copy)
    v1 = UIKit.screenGui("BaitOffer", 5)
    v2 = UIKit.frame(v1, {
        Name = "Bar",
        Corner = 24,
        Stroke = 5,
        Size = UDim2.fromOffset(700, 150),
        Position = UDim2.new(0.5, 0, 0, 24),
        AnchorPoint = Vector2.new(0.5, 0),
        Color = fromRGB(30, 34, 50),
        Color2 = fromRGB(20, 22, 34),
        StrokeColor = fromRGB(255, 215, 60)
    })
    v6 = UIKit.frame(v2, {
        Name = "Picture",
        Corner = 20,
        Stroke = 4,
        ZIndex = 2,
        Size = UDim2.fromOffset(124, 124),
        Position = UDim2.new(0, 13, 0.5, 0),
        AnchorPoint = Vector2.new(0, 0.5),
        Color = fromRGB(255, 205, 70),
        Color2 = fromRGB(255, 140, 30)
    })
    UIKit.frame(v6, {
        Name = "Shine",
        Transparency = 0.75,
        Corner = 14,
        ZIndex = 3,
        Size = UDim2.new(1, -16, 0.4, 0),
        Position = UDim2.fromOffset(8, 6),
        Color = fromRGB(255, 255, 255)
    })
    UIKit.text(v2, {
        Name = "Tag",
        Text = "NEW BEST BAIT!",
        TextSize = 28,
        Stroke = 4,
        ZIndex = 2,
        Size = UDim2.new(1, -420, 0, 32),
        Position = UDim2.fromOffset(152, 14),
        XAlign = Enum.TextXAlignment.Left,
        Color = fromRGB(255, 215, 60)
    }).Rotation = -2
    v3 = UIKit.text(v2, {
        Name = "Name",
        Text = "",
        TextSize = 48,
        Stroke = 5,
        ZIndex = 2,
        Size = UDim2.new(1, -420, 0, 54),
        Position = UDim2.fromOffset(152, 46),
        XAlign = Enum.TextXAlignment.Left
    })
    v3.TextScaled = true

    local UITextSizeConstraint = Instance.new("UITextSizeConstraint")

    UITextSizeConstraint.MaxTextSize = 48
    UITextSizeConstraint.Parent = v3
    v4 = UIKit.text(v2, {
        Name = "Luck",
        Text = "",
        TextSize = 30,
        Stroke = 4,
        ZIndex = 2,
        Size = UDim2.new(1, -420, 0, 34),
        Position = UDim2.fromOffset(152, 100),
        XAlign = Enum.TextXAlignment.Left,
        Color = fromRGB(120, 255, 150)
    })

    local _, v37 = UIKit.button(v2, {
        Name = "Buy",
        Text = "BUY",
        Corner = 18,
        ZIndex = 2,
        Size = UDim2.fromOffset(240, 80),
        Position = UDim2.new(1, -18, 0.5, 0),
        AnchorPoint = Vector2.new(1, 0.5),
        OnClick = t1.Buy
    })

    v5 = v37
    v5.TextScaled = true
    UIKit.button(v2, {
        Name = "Close",
        Text = "X",
        Corner = 12,
        Stroke = 4,
        ZIndex = 4,
        Size = UDim2.fromOffset(40, 40),
        Position = UDim2.new(1, 14, 0, -14),
        AnchorPoint = Vector2.new(1, 0),
        Color = fromRGB(255, 90, 100),
        Color2 = fromRGB(200, 40, 60),
        OnClick = t1.Close
    })
    v2.Visible = false
    require(script.Parent.BannerDodge).new(v2, {
        { "EventHUD", "Banner" },
        { "CosmicEvent", "Banner" },
        { "Popups", "Unlock" }
    })
    buildDot()
    DataClient.Observe("Cash", refresh)
    DataClient.Observe("BaitsOwned", refresh)
    RunService.Heartbeat:Connect(function() -- line: 194
        -- upvalues: UIKit (copy), HUD (copy), t1 (copy), v2 (ref), v7 (ref), v10 (ref), v11 (ref), v12 (ref)
        if v2.Visible and (HUD.GetMode() ~= "normal" or not v7) then
            local v38 = v7 ~= nil

            if v2 then
                v2.Visible = false
            end

            if v10 then
                local v39 = v10

                v10 = nil
                v39:Done()
            end

            if v38 and v7 then
                local id = v7.id

                v12 = id
                t1.DotVisible = id ~= nil

                if v11 then
                    v11.Visible = id ~= nil

                    if id then
                        UIKit.pop(v11, 1.4)
                    end
                end
            end
        end

        local v42 = true

        if v12 then
            local Shop, BaitShop = UIKit.Windows.Shop, UIKit.Windows.BaitShop

            v42 = (not Shop or not Shop.IsOpen) and (not BaitShop or not BaitShop.IsOpen)
        end

        if v42 then
            return
        end

        v12 = nil
        t1.DotVisible = false

        if v11 then
            v11.Visible = false
        end
    end)
    task.defer(refresh)
end

return t1
