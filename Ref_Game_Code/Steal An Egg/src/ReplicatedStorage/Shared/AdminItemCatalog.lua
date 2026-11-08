-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Gears = require(ReplicatedStorage.Data.Gears)
local t1 = {}

for v1, v2 in Gears.Directory do
    if v1 ~= "Bat" then
        t1[v1] = table.freeze({
            Kind = "Gear",
            DisplayName = v2.DisplayName,
            MaxPerRun = if v2.OneTime then 1 else math.min(v2.MaxShopStockQuantity or 1000, 1000)
        })
    end
end

t1.MonsterChest = table.freeze({
    Kind = "MonsterChest",
    DisplayName = "Monster Chest",
    MaxPerRun = 25
})
t1.MutationConsumable = table.freeze({
    Kind = "MutationConsumable",
    DisplayName = "Fractured Crystal",
    MaxPerRun = 1000
})

local t3 = {}
local t4 = {}

local function addChoice(p1, p2) -- line: 42
    -- upvalues: t3 (copy), t4 (copy)
    if t4[p1] == nil then
        t4[p1] = p2
        table.insert(t3, p1)
    end
end

for v4 in t1 do
    if t4[v4] == nil then
        t4[v4] = v4
        table.insert(t3, v4)
    end
end

for v5, v6 in t1 do
    local DisplayName = v6.DisplayName

    if t4[DisplayName] == nil then
        t4[DisplayName] = v5
        table.insert(t3, DisplayName)
    end
end

for _, v7 in { "Bee Gun", "BeeGun", "Bee Launcher" } do
    if t4[v7] == nil then
        t4[v7] = "BeeLauncher"
        table.insert(t3, v7)
    end
end

for _, v8 in { "Fractured Crystals", "FracturedCrystal", "FracturedCrystals", "Mutation Consumable" } do
    if t4[v8] == nil then
        t4[v8] = "MutationConsumable"
        table.insert(t3, v8)
    end
end

table.sort(t3)

return table.freeze({
    Directory = table.freeze(t1),
    Choices = table.freeze(t3),
    IdByChoice = table.freeze(t4)
})
