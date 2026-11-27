-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local GuiService = game:GetService("GuiService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local Config = require(ReplicatedStorage.Shared.Config)
local Format = require(ReplicatedStorage.Shared.Format)
local Remotes = require(ReplicatedStorage.Shared.Remotes)
local RodBuilder = require(ReplicatedStorage.Shared.RodBuilder)
local UIUtil = require(script.Parent.UIUtil)
local Viewport = require(script.Parent.Viewport)
local RarityText = require(script.Parent.RarityText)
local Style = require(script.Parent.Parent.Shop.Style)
local LocalPlayer = Players.LocalPlayer
local t1 = {}
local v1
local t2 = {}
local t3 = {}
local ImageLabel
local v2 = Color3.fromRGB(110, 225, 60)
local v3 = Color3.fromRGB(225, 70, 70)
local v4 = Color3.fromRGB(140, 140, 150)
local v5 = Color3.fromRGB(85, 85, 95)

local function ownedSet() -- line: 32
    -- upvalues: LocalPlayer (copy)
    local t4 = {}
    local n1 = 1

    for match in string.gmatch(LocalPlayer:GetAttribute("RodsOwned") or "1", "%d+") do
        t4[tonumber(match)] = true
        n1 = math.max(n1, (tonumber(match)))
    end

    return t4, n1
end

local function refresh() -- line: 41
    -- upvalues: Config (copy), Format (copy), LocalPlayer (copy), v1 (ref), t2 (copy), t3 (copy), v2 (copy), v3 (copy), v4 (copy), v5 (copy), ownedSet (copy)
    if not v1 then
        return
    end

    local v7, v8 = ownedSet()
    local v9 = LocalPlayer:GetAttribute("RodTier") or 1
    local v10 = LocalPlayer:GetAttribute("Money") or 0

    for v11, v12 in t2 do
        local v13 = Config.rodPrice(v11, LocalPlayer:GetAttribute("LegacyPrices") == true)
        local BuyButton = v12.BuyButton

        if v11 == v9 then
            BuyButton.Label.Text = "Equipped"
            BuyButton.BackgroundColor3 = v4
        elseif v7[v11] then
            BuyButton.Label.Text = "Equip"
            BuyButton.BackgroundColor3 = v2
        elseif v11 == v8 + 1 then
            BuyButton.Label.Text = Format.money(v13)

            if v13 <= v10 then
                BuyButton.BackgroundColor3 = v2
            else
                BuyButton.BackgroundColor3 = v3
            end
        else
            BuyButton.Label.Text = "🔒 " .. Format.money(v13)
            BuyButton.BackgroundColor3 = v5
        end
    end

    for v14, v15 in t3 do
        local v16 = v14 == v8 + 1

        v15.Visible = v16

        local BuyButton = t2[v14].BuyButton
        local v17 = if v16 then UDim.new(0.58, -26) else UDim.new(1, -24)
        local X = BuyButton.AnchorPoint.X

        BuyButton.Size = UDim2.new(v17, UDim.new(0, BuyButton.Size.Y.Offset))
        BuyButton.Position = UDim2.new(UDim.new(v17.Scale * X, 12 + v17.Offset * X), BuyButton.Position.Y)
    end
end

local function onClick(p1) -- line: 78
    -- upvalues: Remotes (copy), ownedSet (copy)
    if ownedSet()[p1] then
        Remotes.EquipRod:FireServer(p1)
    else
        Remotes.BuyRod:FireServer(p1)
    end
end

function t1.isOpen() -- line: 87
    -- upvalues: v1 (ref)
    return v1 ~= nil and v1.Enabled
end

local function onPad() -- line: 91
    -- upvalues: UserInputService (copy)
    return UserInputService:GetLastInputType().Name:find("^Gamepad") ~= nil
end

local function inShop(p2) -- line: 95
    -- upvalues: v1 (ref)
    if p2 == nil or v1 == nil then
        return false
    end

    return (p2:IsDescendantOf(v1))
end

local function showPadGlyph() -- line: 100
    -- upvalues: GuiService (copy), UserInputService (copy), v1 (ref), ImageLabel (ref)
    local SelectedObject = GuiService.SelectedObject

    if not (SelectedObject ~= nil and v1 ~= nil and SelectedObject:IsDescendantOf(v1) and SelectedObject:IsA("GuiButton")) then
        ImageLabel.Parent = nil
    else
        ImageLabel.Image = UserInputService:GetImageForKeyCode(Enum.KeyCode.ButtonA)
        ImageLabel.Parent = SelectedObject
    end
end

function t1.open() -- line: 110
    -- upvalues: GuiService (copy), UserInputService (copy), UIUtil (copy), LocalPlayer (copy), t1 (copy), v1 (ref), t2 (copy), ownedSet (copy), refresh (copy)
    if t1.isOpen() then
        return
    end

    refresh()
    UIUtil.openPanel(v1)

    if UserInputService:GetLastInputType().Name:find("^Gamepad") ~= nil then
        local SelectedObject = GuiService.SelectedObject

        if SelectedObject == nil or v1 == nil or not SelectedObject:IsDescendantOf(v1) then
            local _, v18 = ownedSet()
            local v19 = t2[v18 + 1] or t2[LocalPlayer:GetAttribute("RodTier") or 1]

            if v19 then
                GuiService.SelectedObject = v19.BuyButton
            end
        end
    end
end

function t1.close() -- line: 125
    -- upvalues: GuiService (copy), UIUtil (copy), v1 (ref)
    local SelectedObject = GuiService.SelectedObject

    if SelectedObject ~= nil and v1 ~= nil and SelectedObject:IsDescendantOf(v1) then
        GuiService.SelectedObject = nil
    end

    UIUtil.closePanel(v1)
end

function t1.setForced(p3) -- line: 133
    -- upvalues: v1 (ref)
    if v1 then
        v1.Panel.Header.Close.Visible = not p3
    end
end

function t1.init() -- line: 139
    -- upvalues: GuiService (copy), Config (copy), Remotes (copy), RodBuilder (copy), UIUtil (copy), Viewport (copy), RarityText (copy), Style (copy), LocalPlayer (copy), t1 (copy), v1 (ref), t2 (copy), t3 (copy), ImageLabel (ref), ownedSet (copy), refresh (copy), showPadGlyph (copy)
    v1 = UIUtil.gui("RodShop")
    v1.Panel.Header.Reach.Visible = false

    local Cards = v1.Panel.Body.Cards
    local CardTemplate = Cards.CardTemplate

    for v20, v21 in Config.Rods do
        local v22 = Config.RarityByName[v21.Rarity]
        local clone = CardTemplate:Clone()

        clone.Name = "Rod" .. v20
        clone.LayoutOrder = v20
        clone.Visible = true
        clone.BackgroundColor3 = v22.Color
        clone.NameLabel.Text = v21.Name
        clone.RarityLabel.Text = v21.Rarity
        RarityText.apply(clone.RarityLabel, v22)
        clone.StatBar.StatText.Text = string.format("<font color=\"#5AC8FF\">🎣%d</font> Reel Power", v21.Reel)
        clone.RangeLabel.Visible = false

        local v23 = RodBuilder.build(v20)

        v23:PivotTo(CFrame.Angles(0.6108652381980153, 0, 0))
        Viewport.show(clone.Viewport, v23, 90, 0.75)
        UIUtil.bindButton(clone.BuyButton, function() -- line: 159
            -- upvalues: v20 (copy), Remotes (copy), ownedSet (copy)
            if ownedSet()[v20] then
                Remotes.EquipRod:FireServer(v20)
            else
                Remotes.BuyRod:FireServer(v20)
            end
        end)
        clone.Parent = Cards
        t2[v20] = clone

        if v20 > 1 then
            t3[v20] = Style.price(clone, "NextRod", {
                Name = "RobuxButton",
                Visible = false,
                AnchorPoint = Vector2.new(1, 1),
                Position = UDim2.new(1, -12, 1, -12),
                Size = UDim2.new(0.42, -6, 0, 54),
                BackgroundColor3 = Style.PURPLE
            })

            local BuyButton = clone.BuyButton

            t3[v20].Size = UDim2.new(0.42, -12, 0, BuyButton.Size.Y.Offset)
            t3[v20].Position = UDim2.new(1, -12, 1, BuyButton.Position.Y.Offset)
            t3[v20].UIStroke.Thickness = BuyButton.UIStroke.Thickness
            t3[v20].UICorner.CornerRadius = BuyButton.UICorner.CornerRadius
        end
    end

    UIUtil.bindButton(v1.Panel.Header.Close, t1.close)
    ImageLabel = Instance.new("ImageLabel")
    ImageLabel.Name = "PadGlyph"
    ImageLabel.BackgroundTransparency = 1
    ImageLabel.AnchorPoint = Vector2.new(0.5, 0)
    ImageLabel.Position = UDim2.new(0.5, 0, 1, 2)
    ImageLabel.Size = UDim2.fromOffset(36, 36)
    ImageLabel.ScaleType = Enum.ScaleType.Fit
    ImageLabel.ZIndex = 50
    GuiService:GetPropertyChangedSignal("SelectedObject"):Connect(showPadGlyph)

    for _, v24 in { "RodsOwned", "RodTier", "Money" } do
        LocalPlayer:GetAttributeChangedSignal(v24):Connect(refresh)
    end

    refresh()
end

return t1
