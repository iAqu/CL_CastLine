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
local v1, List, RowTemplate
local Uid = nil

local function thisWorld(p1) -- line: 25
    -- upvalues: Players (copy), Config (copy), Animals (copy)
    local v2 = Config.playerWorld(Players.LocalPlayer)
    local t2 = {}

    for _, v3 in p1 do
        if Animals.inWorld(v3, v2) then
            table.insert(t2, v3)
        end
    end

    return t2
end

local function sortByIncome(p2) -- line: 35
    -- upvalues: Animals (copy)
    local v4 = table.clone(p2)

    table.sort(v4, function(p3, p4) -- line: 37
        -- upvalues: Animals (copy)
        local v5 = Animals.income(p3)
        local v6 = Animals.income(p4)

        if v5 == v6 then
            return p3.Uid < p4.Uid
        end

        return v6 < v5
    end)

    return v4
end

local function makeRow(p5, p6) -- line: 47
    -- upvalues: Config (copy), Animals (copy), AnimalModel (copy), Format (copy), Remotes (copy), UIUtil (copy), Tooltip (copy), Viewport (copy), RarityText (copy), List (ref), RowTemplate (ref), Uid (ref)
    local v7 = Animals.get(p5.Id)
    local v8 = Config.RarityByName[v7.Rarity]
    local clone = RowTemplate:Clone()

    clone.Name = p5.Uid
    clone.LayoutOrder = p6
    clone.Visible = true
    clone.Icon.BackgroundColor3 = v8.Color
    clone.RarityLabel.Text = string.upper(Animals.rarityText(v7))
    RarityText.apply(clone.RarityLabel, v8)
    clone.NameLabel.Text = Animals.displayName(p5)
    clone.IncomeLabel.Text = Format.money(Animals.income(p5)) .. "/s"

    local v9 = AnimalModel.clone(v7.Id, 4, p5.Mutation)

    if v9 then
        Viewport.show(clone.Icon.Viewport, v9, 50, 0.85)
    end

    Tooltip.bind(clone, function() -- line: 63
        -- upvalues: p5 (copy)
        return p5
    end)
    UIUtil.bindButton(clone.PickUp, function() -- line: 66
        -- upvalues: p5 (copy), Remotes (copy)
        Remotes.PickupAnimal:FireServer(p5.Uid)
    end)

    local Sell = clone.Sell

    UIUtil.bindButton(Sell, function() -- line: 70
        -- upvalues: p5 (copy), Sell (copy), Animals (copy), Format (copy), Remotes (copy), Uid (ref)
        if Uid == p5.Uid then
            Uid = nil
            Remotes.SellPlaced:FireServer(p5.Uid)
        else
            Uid = p5.Uid
            Sell.Label.Text = Format.money(Animals.sellPrice(p5)) .. "?"
            task.delay(2.5, function() -- line: 78
                -- upvalues: p5 (copy), Sell (copy), Uid (ref)
                if Uid == p5.Uid then
                    Uid = nil
                    Sell.Label.Text = "SELL"
                end
            end)
        end
    end)
    clone.Parent = List
end

function t1.render() -- line: 88
    -- upvalues: Players (copy), Config (copy), Animals (copy), t1 (copy), v1 (ref), List (ref), RowTemplate (ref), Uid (ref), thisWorld (copy), makeRow (copy)
    for _, child in List:GetChildren() do
        if child:IsA("Frame") and child ~= RowTemplate then
            child:Destroy()
        end
    end

    Uid = nil

    local v10 = thisWorld(t1.placed)
    local v11 = table.clone(v10)

    table.sort(v11, function(p7, p8) -- line: 37
        -- upvalues: Animals (copy)
        local v12 = Animals.income(p7)
        local v13 = Animals.income(p8)

        if v12 == v13 then
            return p7.Uid < p8.Uid
        end

        return v13 < v12
    end)

    for v14, v15 in v11 do
        makeRow(v15, v14)
    end

    local v16 = ("%*/%*"):format(#v10, Players.LocalPlayer:GetAttribute("PenCapacity") or Config.penCapacity(1))

    v1.Panel.Header.Count.Label.Text = "🐾 " .. v16
    List.Section.Text = ("ON YOUR PLOT  <font color=\"#8CFF5A\">%*</font>"):format(v16)
    v1.Panel.Body.Empty.Visible = #v10 == 0
end

function t1.isOpen() -- line: 107
    -- upvalues: v1 (ref)
    return v1 ~= nil and v1.Enabled
end

function t1.open() -- line: 111
    -- upvalues: UIUtil (copy), t1 (copy), v1 (ref)
    t1.render()

    if not v1.Enabled then
        UIUtil.openPanel(v1)
    end
end

function t1.close() -- line: 118
    -- upvalues: UIUtil (copy), v1 (ref)
    UIUtil.closePanel(v1)
end

function t1.init() -- line: 122
    -- upvalues: Players (copy), Remotes (copy), UIUtil (copy), t1 (copy), v1 (ref), List (ref), RowTemplate (ref)
    v1 = UIUtil.gui("AnimalsPanel")
    v1:WaitForChild("Panel"):SetAttribute("FullHeight", true)
    v1.Panel.Position = UDim2.new(1, -16, 0.5, 0)
    List = v1.Panel.Body.List
    RowTemplate = List.RowTemplate
    RowTemplate.Visible = false
    UIUtil.bindButton(v1.Panel.Header.Close, t1.close)
    UIUtil.bindButton(v1.Panel.Footer.EquipBest, function() -- line: 133
        -- upvalues: Remotes (copy)
        Remotes.EquipBest:FireServer()
    end)
    Remotes.Inventory.OnClientEvent:Connect(function(p9, p10) -- line: 137
        -- upvalues: t1 (copy)
        t1.items = p9
        t1.placed = p10

        if t1.isOpen() then
            t1.render()
        end
    end)
    Players.LocalPlayer:GetAttributeChangedSignal("World"):Connect(function() -- line: 143
        -- upvalues: t1 (copy)
        if t1.isOpen() then
            t1.render()
        end
    end)
end

return t1
