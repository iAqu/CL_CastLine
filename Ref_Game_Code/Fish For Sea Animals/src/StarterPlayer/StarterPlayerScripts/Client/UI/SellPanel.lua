-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Config = require(ReplicatedStorage.Shared.Config)
local Animals = require(ReplicatedStorage.Shared.Animals)
local AnimalModel = require(ReplicatedStorage.Shared.AnimalModel)
local Format = require(ReplicatedStorage.Shared.Format)
local Remotes = require(ReplicatedStorage.Shared.Remotes)
local UIUtil = require(script.Parent.UIUtil)
local Tooltip = require(script.Parent.Tooltip)
local Viewport = require(script.Parent.Viewport)
local RarityText = require(script.Parent.RarityText)
local t1 = {
    items = {},
    placed = {}
}
local v1, Grid, CardTemplate
local v2 = Color3.fromRGB(255, 196, 40)
local v3 = Color3.fromRGB(130, 130, 140)

local function sortByValue(p1) -- line: 24
    -- upvalues: Animals (copy)
    local v4 = table.clone(p1)

    table.sort(v4, function(p2, p3) -- line: 26
        -- upvalues: Animals (copy)
        local v5 = Animals.income(p2)
        local v6 = Animals.income(p3)

        if v5 == v6 then
            return p2.Uid < p3.Uid
        end

        return v6 < v5
    end)

    return v4
end

local function makeCard(p4, p5) -- line: 36
    -- upvalues: Config (copy), Animals (copy), AnimalModel (copy), Format (copy), Remotes (copy), UIUtil (copy), Tooltip (copy), Viewport (copy), RarityText (copy), Grid (ref), CardTemplate (ref), v2 (copy)
    local v7 = Animals.get(p4.Id)
    local v8 = Config.RarityByName[v7.Rarity]
    local clone = CardTemplate:Clone()

    clone.Name = p4.Uid
    clone.LayoutOrder = p5
    clone.Visible = true
    clone.BackgroundColor3 = v8.Color
    clone.NameLabel.Text = Animals.displayName(p4)
    clone.RarityLabel.Text = Animals.rarityText(v7)
    RarityText.apply(clone.RarityLabel, v8)
    clone.IncomeLabel.Text = Format.money(Animals.income(p4)) .. "/s"
    clone.PlacedTag.Visible = false

    local v9 = AnimalModel.clone(v7.Id, 4, p4.Mutation)

    if v9 then
        Viewport.show(clone.Viewport, v9, 50, 0.85)
    end

    Tooltip.bind(clone, function() -- line: 53
        -- upvalues: p4 (copy)
        return p4
    end)

    local ActionButton = clone.ActionButton

    ActionButton.Label.Text = "Sell " .. Format.money(Animals.sellPrice(p4))
    ActionButton.BackgroundColor3 = v2
    UIUtil.bindButton(ActionButton, function() -- line: 59
        -- upvalues: p4 (copy), Remotes (copy)
        Remotes.SellAnimal:FireServer(p4.Uid)
    end)
    clone.Parent = Grid
end

function t1.render() -- line: 65
    -- upvalues: Players (copy), Config (copy), Animals (copy), Format (copy), t1 (copy), v1 (ref), Grid (ref), CardTemplate (ref), v2 (copy), v3 (copy), makeCard (copy)
    for _, child in Grid:GetChildren() do
        if child:IsA("Frame") and child ~= CardTemplate then
            child:Destroy()
        end
    end

    local v10 = Config.playerWorld(Players.LocalPlayer)
    local t2 = {}

    for _, v11 in t1.items do
        if Animals.inWorld(v11, v10) then
            table.insert(t2, v11)
        end
    end

    local v12 = table.clone(t2)

    table.sort(v12, function(p6, p7) -- line: 26
        -- upvalues: Animals (copy)
        local v13 = Animals.income(p6)
        local v14 = Animals.income(p7)

        if v13 == v14 then
            return p6.Uid < p7.Uid
        end

        return v14 < v13
    end)

    local n1 = 0

    for v15, v16 in v12 do
        makeCard(v16, v15)

        if not Animals.isPaid(v16) then
            n1 += Animals.sellPrice(v16)
        end
    end

    local Panel = v1.Panel
    local n2 = 0

    for _, v17 in t1.placed do
        if Animals.inWorld(v17, v10) then
            n2 += 1
        end
    end

    Panel.Header.Counts.Text = ("🎒 %*   🏡 %*/%*"):format(#t2, n2, Players.LocalPlayer:GetAttribute("PenCapacity") or Config.penCapacity(1))
    Panel.Body.Empty.Visible = #t2 == 0

    local SellAllButton = Panel.Footer.SellAllButton

    SellAllButton.Visible = true
    SellAllButton.Label.Text = "SELL ALL  " .. Format.money(n1)

    if n1 > 0 then
        SellAllButton.BackgroundColor3 = v2
    else
        SellAllButton.BackgroundColor3 = v3
    end
end

function t1.isOpen() -- line: 101
    -- upvalues: v1 (ref)
    return v1 ~= nil and v1.Enabled
end

function t1.open() -- line: 105
    -- upvalues: UIUtil (copy), t1 (copy), v1 (ref)
    t1.render()

    if not v1.Enabled then
        UIUtil.openPanel(v1)
    end
end

function t1.close() -- line: 112
    -- upvalues: UIUtil (copy), v1 (ref)
    UIUtil.closePanel(v1)
end

function t1.init() -- line: 116
    -- upvalues: Remotes (copy), UIUtil (copy), t1 (copy), v1 (ref), Grid (ref), CardTemplate (ref)
    v1 = UIUtil.gui("SellPanel")
    Grid = v1.Panel.Body.Grid
    CardTemplate = Grid.CardTemplate
    v1.Panel.Header.Title.Text = "Sell Animals"
    v1.Panel.Footer.Tip.Text = "Selling gives you cash right away!"
    UIUtil.bindButton(v1.Panel.Header.Close, t1.close)
    UIUtil.bindButton(v1.Panel.Footer.SellAllButton, function() -- line: 124
        -- upvalues: Remotes (copy), t1 (copy)
        if #t1.items > 0 then
            Remotes.SellAll:FireServer()
        end
    end)
    Remotes.Inventory.OnClientEvent:Connect(function(p8, p9) -- line: 130
        -- upvalues: t1 (copy)
        t1.items = p8
        t1.placed = p9

        if t1.isOpen() then
            t1.render()
        end
    end)
end

return t1
