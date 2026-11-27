-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Config = require(ReplicatedStorage.Shared.Config)
local Format = require(ReplicatedStorage.Shared.Format)
local Remotes = require(ReplicatedStorage.Shared.Remotes)
local UIUtil = require(script.Parent.UIUtil)
local Viewport = require(script.Parent.Viewport)
local RarityText = require(script.Parent.RarityText)
local Style = require(script.Parent.Parent.Shop.Style)
local Lure = require(script.Parent.Parent.Fishing.Lure)
local LocalPlayer = Players.LocalPlayer
local t1 = {}
local v1
local t2 = {}
local t3 = {}
local v2 = {}
local v3 = Color3.fromRGB(110, 225, 60)
local v4 = Color3.fromRGB(225, 70, 70)
local v5 = Color3.fromRGB(140, 140, 150)

local function owned() -- line: 32
    -- upvalues: LocalPlayer (copy)
    local t4 = {}

    for match in string.gmatch(LocalPlayer:GetAttribute("BaitsOwned") or "", "[^,]+") do
        t4[match] = true
    end

    return t4
end

local function refresh() -- line: 40
    -- upvalues: Config (copy), Format (copy), LocalPlayer (copy), v1 (ref), t2 (copy), t3 (copy), v3 (copy), v4 (copy), v5 (copy), owned (copy)
    if not v1 then
        return
    end

    local v6 = owned()
    local v7 = LocalPlayer:GetAttribute("Bait") or ""
    local v8 = LocalPlayer:GetAttribute("Money") or 0

    for v9, v10 in t2 do
        local v11 = Config.BaitByKey[v9]
        local BuyButton = v10.BuyButton
        local v12 = t3[v9]
        local v13 = v6[v9] == true

        BuyButton.Visible = v13 or v12 == nil

        if v12 then
            v12.Visible = not v13
        end

        if v9 == v7 then
            BuyButton.Label.Text = "Equipped"
            BuyButton.BackgroundColor3 = v5
        elseif v13 then
            BuyButton.Label.Text = "Equip"
            BuyButton.BackgroundColor3 = v3
        elseif v11.Price then
            BuyButton.Label.Text = Format.money(v11.Price)

            if v11.Price <= v8 then
                BuyButton.BackgroundColor3 = v3
            else
                BuyButton.BackgroundColor3 = v4
            end
        end
    end
end

function t1.isOpen() -- line: 69
    -- upvalues: v1 (ref)
    return v1 ~= nil and v1.Enabled
end

local connection

function t1.open() -- line: 75
    -- upvalues: RunService (copy), UIUtil (copy), Lure (copy), t1 (copy), v1 (ref), v2 (ref), refresh (copy), connection (ref)
    if t1.isOpen() then
        return
    end

    refresh()
    UIUtil.openPanel(v1)

    if not connection and #v2 > 0 then
        connection = RunService.RenderStepped:Connect(function() -- line: 82
            -- upvalues: Lure (copy), v2 (ref)
            Lure.cycle(v2, os.clock())
        end)
    end
end

function t1.close() -- line: 88
    -- upvalues: UIUtil (copy), v1 (ref), connection (ref)
    if connection then
        connection:Disconnect()
        connection = nil
    end

    UIUtil.closePanel(v1)
end

function t1.init() -- line: 96
    -- upvalues: Config (copy), Remotes (copy), UIUtil (copy), Viewport (copy), RarityText (copy), Style (copy), Lure (copy), LocalPlayer (copy), t1 (copy), v1 (ref), t2 (copy), t3 (copy), v2 (ref), owned (copy), refresh (copy)
    v1 = UIUtil.gui("BaitShop")
    v1.Panel.Header.Title.Text = "Bait Shop"
    v1.Panel.Header.Reach.Visible = false

    local Cards = v1.Panel.Body.Cards
    local CardTemplate = Cards.CardTemplate

    for v14, v15 in Config.Baits do
        local v16 = Config.RarityByName[v15.Rarity]
        local clone = CardTemplate:Clone()

        clone.Name = v15.Key
        clone.LayoutOrder = v14
        clone.Visible = true
        clone.BackgroundColor3 = v16.Color
        clone.NameLabel.Text = v15.Name
        clone.RarityLabel.Text = v15.Rarity
        RarityText.apply(clone.RarityLabel, v16)
        clone.StatBar.StatText.RichText = true
        clone.StatBar.StatText.Text = ("<font color=\"#8CFF5A\">🍀x%*</font> Luck"):format(v15.Luck)

        if v15.RainbowMult then
            clone.RangeLabel.Visible = true
            clone.RangeLabel.Text = ("🌈 x%* Rainbow chance"):format(v15.RainbowMult)
        else
            clone.RangeLabel.Visible = false
        end

        local v17, v18 = Lure.build(v15)

        if #v18 > 0 then
            v2 = v18
        end

        v17:PivotTo(CFrame.Angles(-0.2617993877991494, -1.0471975511965976, 0))
        Viewport.show(clone.Viewport, v17, 90, 0.8)
        UIUtil.bindButton(clone.BuyButton, function() -- line: 126
            -- upvalues: v15 (copy), Remotes (copy), owned (copy)
            if owned()[v15.Key] then
                Remotes.EquipBait:FireServer(v15.Key)
            else
                Remotes.BuyBait:FireServer(v15.Key)
            end
        end)
        clone.Parent = Cards
        t2[v15.Key] = clone

        if v15.Product then
            local BuyButton = clone.BuyButton
            local v19 = Style.price(clone, v15.Product, {
                Name = "RobuxButton",
                AnchorPoint = BuyButton.AnchorPoint,
                Position = BuyButton.Position,
                Size = BuyButton.Size,
                BackgroundColor3 = Style.PURPLE
            })

            v19.UIStroke.Thickness = BuyButton.UIStroke.Thickness
            v19.UICorner.CornerRadius = BuyButton.UICorner.CornerRadius
            t3[v15.Key] = v19
        end
    end

    UIUtil.bindButton(v1.Panel.Header.Close, t1.close)

    for _, v20 in { "BaitsOwned", "Bait", "Money" } do
        LocalPlayer:GetAttributeChangedSignal(v20):Connect(refresh)
    end

    refresh()
end

return t1
