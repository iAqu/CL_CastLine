-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local t = require(ReplicatedStorage.Packages.t)
local v1 = table.freeze({
    table.freeze({ "Spike", 39 }),
    table.freeze({ "Manta Ray", 24 }),
    table.freeze({ "Megalodon", 18 }),
    table.freeze({ "Electric Eel", 11 }),
    table.freeze({ "Terra Snapper", 6.5 }),
    table.freeze({ "Cthulhu", 0.5 })
})
local v2 = table.freeze({
    table.freeze({ "Depths Spike", 39 }),
    table.freeze({ "Depths Manta Ray", 24 }),
    table.freeze({ "Depths Megalodon", 18 }),
    table.freeze({ "Depths Electric Eel", 11 }),
    table.freeze({ "Depths Terra Snapper", 6.5 }),
    table.freeze({ "Depths Cthulhu", 0.5 })
})

assert(#v1 == 6, "Luminous egg presentation requires exactly six drop entries")
assert(#v2 == 6, "Luminous egg presentation requires exactly six mecha drop entries")

local function buildEntries(p1) -- line: 42
    -- upvalues: t (copy)
    local t1 = {}

    for v5, v6 in ipairs(p1) do
        local v7 = v6[1]
        local v8 = v6[2]

        t.strict(t.string)(v7)
        t.strict(t.number)(v8)
        assert(v8 > 0, (("Luminous egg drop entry %* requires positive weight"):format(v5)))
        table.insert(t1, table.freeze({
            AssetId = v7,
            Weight = v8
        }))
    end

    return table.freeze(t1)
end

return (table.freeze({
    DisplayName = "Luminous Egg",
    BackgroundImage = "rbxassetid://108209625322017",
    DropTable = v1,
    Entries = buildEntries(v1),
    MechaEntries = buildEntries(v2)
}))
