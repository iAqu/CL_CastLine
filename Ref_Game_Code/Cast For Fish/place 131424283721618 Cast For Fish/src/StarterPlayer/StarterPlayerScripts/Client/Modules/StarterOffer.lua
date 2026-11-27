-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local MarketplaceService = game:GetService("MarketplaceService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local Shared = ReplicatedStorage:WaitForChild("Shared")
local Parent = script.Parent
local Products = require(Shared.Data.Products)
local UIKit = require(Parent.UIKit)
local DataClient = require(Parent.DataClient)
local HUD = require(Parent.HUD)
local Toasts = require(Parent.Toasts)
local OfferGate = require(Parent.OfferGate)
local PackCards = require(Parent.PackCards)
local fromRGB = Color3.fromRGB
local v1 = Vector2.new(0.5, 0.5)
local v2 = utf8.char(57346)
local LocalPlayer = Players.LocalPlayer
local StarterPack = Products.StarterPack
local v3 = UDim2.fromOffset(75, 98)
local v4 = fromRGB(100, 245, 225)
local v5 = fromRGB(255, 210, 60)
local v6 = fromRGB(150, 250, 70)
local t1 = {
    normal = true,
    training = true
}
local v7 = TweenInfo.new(0.38, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
local v8 = TweenInfo.new(0.38, Enum.EasingStyle.Back, Enum.EasingDirection.In)
local Frame, Frame2, TextButton
local v9 = true
local v10 = false
local elapsed

local function countdown(p1) -- line: 58
    local v12 = math.max(0, (math.ceil(p1)))

    return string.format("Hides in %d:%02d", v12 // 60, v12 % 60)
end

local function secondsLeft() -- line: 63
    -- upvalues: elapsed (ref)
    if elapsed then
        return 600 - (os.clock() - elapsed)
    end

    return 600
end

local function shouldShow() -- line: 67
    -- upvalues: DataClient (copy), HUD (copy), OfferGate (copy), t1 (copy), v10 (ref), elapsed (ref)
    local v13 = not v10
    local v14

    if v13 then
        if (if elapsed then 600 - (os.clock() - elapsed) else 600) > 0 then
            v14 = OfferGate.Shared:Allowed()

            if v14 then
                v14 = DataClient.IsReady()

                if v14 then
                    v14 = DataClient.Get("StarterPack") ~= true and t1[HUD.GetMode()] == true
                end
            end
        else
            v14 = false
        end
    else
        v14 = v13
    end

    return v14
end

local function place(p2, p3) -- line: 76
    -- upvalues: HUD (copy)
    local v15 = 150 * (HUD.BUTTON_SCALE or 1)

    if p3 then
        p2.AnchorPoint = Vector2.new(1, 0.5)
        p2.Position = UDim2.new(1, -18 - v15 - 14, 0.5, 6)
    else
        p2.AnchorPoint = Vector2.new(1, 0)
        p2.Position = UDim2.new(1, -18, 0.5, 6 + v15 / 2 + 14)
    end
end

local function fetchPrice(p4) -- line: 87
    -- upvalues: MarketplaceService (copy), v2 (copy), StarterPack (copy)
    if StarterPack.id ~= 0 then
        task.spawn(function() -- line: 91
            -- upvalues: p4 (copy), MarketplaceService (copy), v2 (copy), StarterPack (copy)
            local function v16() -- line: 92
                -- upvalues: MarketplaceService (copy), StarterPack (copy)
                return MarketplaceService:GetProductInfoAsync(StarterPack.id, Enum.InfoType.Product)
            end

            local ok, result = pcall(v16)

            if ok and type(result) == "table" and type(result.PriceInRobux) == "number" then
                p4.Text = v2 .. " " .. result.PriceInRobux
            end
        end)
    end
end

local function wiggle(p5) -- line: 101
    local v17 = p5 % 8

    if v17 >= 0.6 then
        return 0
    end

    local v18 = v17 / 0.6

    return math.sin(v18 * 3.141592653589793 * 3) * 4 * (1 - v18)
end

local t2 = {
    Prompts = 0,
    Mute = false
}

function t2.Buy() -- line: 114
    -- upvalues: MarketplaceService (copy), Toasts (copy), LocalPlayer (copy), StarterPack (copy), t2 (copy)
    if StarterPack.id == 0 then
        Toasts.Show("info", "Not on sale yet!")
    else
        t2.Prompts += 1

        if not t2.Mute then
            local function v20() -- line: 123
                -- upvalues: MarketplaceService (copy), LocalPlayer (copy), StarterPack (copy)
                MarketplaceService:PromptProductPurchase(LocalPlayer, StarterPack.id)
            end

            pcall(v20)
        end
    end
end

function t2.Close() -- line: 128
    -- upvalues: Frame (ref), v10 (ref)
    v10 = true

    if Frame then
        Frame.Visible = false
    end
end

local function drawerSpots() -- line: 135
    return UDim2.fromOffset(24, 20), (UDim2.fromOffset(202, 20))
end

local function placeDrawer(p6) -- line: 141
    -- upvalues: TweenService (copy), v7 (copy), v8 (copy), Frame2 (ref), TextButton (ref), v9 (ref)
    if Frame2 and TextButton then
        local v21 = UDim2.fromOffset(24, 20)
        local v22 = UDim2.fromOffset(202, 20)

        if not v9 then
            v21 = v22
        end

        local v23 = if v9 then UDim2.fromOffset(-18, 98) else UDim2.fromOffset(130, 98)
        local v24 = if v9 then 0 else 180

        if p6 then
            local Frame = Frame2

            TweenService:Create(Frame, if v9 then v7 else v8, {
                Position = v21
            }):Play()
            TweenService:Create(TextButton, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                Position = v23,
                Rotation = v24
            }):Play()
        else
            Frame2.Position = v21
            TextButton.Position = v23
            TextButton.Rotation = v24
        end
    end
end

function t2.Toggle() -- line: 159
    -- upvalues: v9 (ref), placeDrawer (copy)
    v9 = not v9
    placeDrawer(true)
end

function t2.IsOpen() -- line: 164
    -- upvalues: v9 (ref)
    return v9
end

function t2.Frame() -- line: 168
    -- upvalues: Frame (ref)
    return Frame
end

function t2.IsVisible() -- line: 172
    -- upvalues: Frame (ref)
    return Frame ~= nil and Frame.Visible
end

function t2.SecondsLeft() -- line: 176
    -- upvalues: elapsed (ref)
    if elapsed then
        return 600 - (os.clock() - elapsed)
    end

    return 600
end

function t2.Init() -- line: 180
    -- upvalues: RunService (copy), MarketplaceService (copy), UIKit (copy), HUD (copy), PackCards (copy), fromRGB (copy), v1 (copy), v2 (copy), StarterPack (copy), v3 (copy), v4 (copy), v5 (copy), v6 (copy), Frame (ref), Frame2 (ref), TextButton (ref), v9 (ref), elapsed (ref), shouldShow (copy), place (copy), t2 (copy)
    local v26 = UIKit.screenGui("StarterOffer", 5)
    local Frame3 = Instance.new("Frame")

    Frame3.Name = "Holder"
    Frame3.BackgroundTransparency = 1
    Frame3.Size = UDim2.fromOffset(150, 196)
    Frame3.Visible = false
    Frame3.Parent = v26
    Frame = Frame3
    place(Frame3, if HUD.IsTouch then HUD.IsTouch() else false)

    if HUD.TouchChanged then
        HUD.TouchChanged:Connect(function(p7) -- line: 191
            -- upvalues: Frame3 (copy), place (copy)
            place(Frame3, p7)
        end)
    end

    local Frame4 = Instance.new("Frame")

    Frame4.Name = "Clip"
    Frame4.BackgroundTransparency = 1
    Frame4.ClipsDescendants = true
    Frame4.Size = UDim2.fromOffset(198, 236)
    Frame4.Position = UDim2.fromOffset(-24, -20)
    Frame4.Parent = Frame3

    local Frame5 = Instance.new("Frame")

    Frame5.Name = "Drawer"
    Frame5.BackgroundTransparency = 1
    Frame5.Size = UDim2.fromOffset(150, 196)
    Frame5.Parent = Frame4
    Frame2 = Frame5

    local TextButton2 = Instance.new("TextButton")

    TextButton2.Name = "Toggle"
    TextButton2.Text = ">"
    TextButton2.Font = Enum.Font.FredokaOne
    TextButton2.TextSize = 58
    TextButton2.TextColor3 = fromRGB(255, 214, 40)
    TextButton2.BackgroundTransparency = 1
    TextButton2.Size = UDim2.fromOffset(40, 64)
    TextButton2.AnchorPoint = v1
    TextButton2.ZIndex = 12

    local UIStroke = Instance.new("UIStroke")

    UIStroke.Thickness = 5
    UIStroke.Color = fromRGB(40, 26, 6)
    UIStroke.Parent = TextButton2
    TextButton2.Parent = Frame3
    UIKit.bindPress(TextButton2, t2.Toggle)
    TextButton = TextButton2

    if Frame2 and TextButton then
        local v28 = UDim2.fromOffset(24, 20)
        local v29 = UDim2.fromOffset(202, 20)

        if not v9 then
            v28 = v29
        end

        local v30 = if v9 then UDim2.fromOffset(-18, 98) else UDim2.fromOffset(130, 98)
        local v31 = if v9 then 0 else 180

        Frame2.Position = v28
        TextButton.Position = v30
        TextButton.Rotation = v31
    end

    UIKit.rays(Frame5, {
        Transparency = 0.45,
        ZIndex = 1,
        Speed = 15,
        Size = UDim2.fromOffset(190, 190),
        Position = v3,
        AnchorPoint = v1,
        Color = v5
    })
    UIKit.image(Frame5, "Glow", {
        Transparency = 0.2,
        ZIndex = 2,
        Size = UDim2.fromOffset(170, 170),
        Position = v3,
        AnchorPoint = v1,
        Color = v4
    })

    local TextButton3 = Instance.new("TextButton")

    TextButton3.Name = "Offer"
    TextButton3.Text = ""
    TextButton3.BackgroundTransparency = 1
    TextButton3.Size = UDim2.fromScale(1, 1)
    TextButton3.ZIndex = 3
    TextButton3.Parent = Frame5
    UIKit.bindPress(TextButton3, t2.Buy)

    local v32 = UIKit.frame(TextButton3, {
        Name = "Art",
        Transparency = 1,
        ZIndex = 4,
        Size = UDim2.fromOffset(156, 156),
        Position = v3,
        AnchorPoint = v1
    })

    PackCards.StarterArt(v32, 4)

    local v33 = UIKit.text(TextButton3, {
        Name = "Timer",
        TextSize = 22,
        Stroke = 4,
        ZIndex = 9,
        Text = string.format("Hides in %d:%02d", 10, 0),
        Size = UDim2.fromOffset(176, 28),
        Position = UDim2.fromOffset(75, 16),
        AnchorPoint = v1,
        Color = v5
    })
    local v34 = UIKit.text(TextButton3, {
        Name = "Price",
        TextSize = 32,
        Stroke = 4,
        ZIndex = 9,
        Text = v2 .. " " .. StarterPack.robux,
        Size = UDim2.fromOffset(176, 36),
        Position = UDim2.fromOffset(75, 178),
        AnchorPoint = v1,
        Color = v6
    })

    if StarterPack.id ~= 0 then
        task.spawn(function() -- line: 91
            -- upvalues: v34 (copy), MarketplaceService (copy), v2 (copy), StarterPack (copy)
            local function v35() -- line: 92
                -- upvalues: MarketplaceService (copy), StarterPack (copy)
                return MarketplaceService:GetProductInfoAsync(StarterPack.id, Enum.InfoType.Product)
            end

            local ok, result = pcall(v35)

            if ok and type(result) == "table" and type(result.PriceInRobux) == "number" then
                v34.Text = v2 .. " " .. result.PriceInRobux
            end
        end)
    end

    RunService.Heartbeat:Connect(function() -- line: 249
        -- upvalues: Frame3 (copy), v33 (copy), elapsed (ref), shouldShow (copy)
        local v36 = shouldShow()

        if v36 and not elapsed then
            elapsed = os.clock()
        end

        if Frame3.Visible ~= v36 then
            Frame3.Visible = v36
        end

        if not v36 then
            return
        end

        local v39 = math.max(0, (math.ceil(if elapsed then 600 - (os.clock() - elapsed) else 600)))
        local v40 = string.format("Hides in %d:%02d", v39 // 60, v39 % 60)

        if v33.Text ~= v40 then
            v33.Text = v40
        end
    end)
    RunService.RenderStepped:Connect(function() -- line: 265
        -- upvalues: Frame3 (copy), v32 (copy), v3 (copy)
        if Frame3.Visible then
            local elapsed = os.clock()

            v32.Position = v3 + UDim2.fromOffset(0, math.sin(elapsed * 3.141592653589793 * 2 / 2.4) * 3)

            local v42 = elapsed % 8
            local v43

            if v42 >= 0.6 then
                v43 = 0
            else
                local v44 = v42 / 0.6

                v43 = math.sin(v44 * 3.141592653589793 * 3) * 4 * (1 - v44)
            end

            v32.Rotation = v43
        end
    end)
end

return t2
