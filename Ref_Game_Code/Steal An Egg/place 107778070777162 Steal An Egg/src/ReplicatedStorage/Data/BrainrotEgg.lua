-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local t = require(ReplicatedStorage.Packages.t)
local v1 = table.freeze({
    table.freeze({ "Tung Tung Sahur", 39 }),
    table.freeze({ "Bananita Dolphinita", 25 }),
    table.freeze({ "Belula Beluga", 20 }),
    table.freeze({ "Mangolini Parrochini", 10 }),
    table.freeze({ "Bomboclat Crocolat", 5 }),
    table.freeze({ "Strawberry Elephant", 1 })
})

assert(#v1 == 6, "Brainrot egg presentation requires exactly six drop entries")

local t1 = {}

for v3, v4 in ipairs(v1) do
    local v5 = v4[1]
    local v6 = v4[2]

    t.strict(t.string)(v5)
    t.strict(t.number)(v6)
    assert(v6 > 0, (("Brainrot egg drop entry %* requires positive weight"):format(v3)))
    table.insert(t1, table.freeze({
        AssetId = v5,
        Weight = v6
    }))
end

return (table.freeze({
    DisplayName = "Brainrot Egg",
    BackgroundImage = "rbxassetid://70476079280223",
    DropTable = v1,
    Entries = table.freeze(t1)
}))
