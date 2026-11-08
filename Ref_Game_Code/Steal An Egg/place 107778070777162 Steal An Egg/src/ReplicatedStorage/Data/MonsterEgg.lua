-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local t = require(ReplicatedStorage.Packages.t)
local v1 = table.freeze({
    table.freeze({ "Scorpio", 39 }),
    table.freeze({ "Froggo", 24 }),
    table.freeze({ "Crawler", 18 }),
    table.freeze({ "Crocodon", 11 }),
    table.freeze({ "Krakenoid", 6.5 }),
    table.freeze({ "Dreadscale", 0.5 })
})
local v2 = table.freeze({
    table.freeze({ "Mecha Scorpio", 40 }),
    table.freeze({ "Mecha Froggo", 24 }),
    table.freeze({ "Mecha Crawler", 18 }),
    table.freeze({ "Mecha Crocodon", 11 }),
    table.freeze({ "Mecha Krakenoid", 6.5 }),
    table.freeze({ "Mecha Dreadscale", 0.5 })
})

assert(#v1 == 6, "Monster egg presentation requires exactly six drop entries")
assert(#v2 == 6, "Monster egg presentation requires exactly six mecha drop entries")

local function buildEntries(p1) -- line: 42
    -- upvalues: t (copy)
    local t1 = {}

    for v5, v6 in ipairs(p1) do
        local v7 = v6[1]
        local v8 = v6[2]

        t.strict(t.string)(v7)
        t.strict(t.number)(v8)
        assert(v8 > 0, (("Monster egg drop entry %* requires positive weight"):format(v5)))
        table.insert(t1, table.freeze({
            AssetId = v7,
            Weight = v8
        }))
    end

    return table.freeze(t1)
end

return (table.freeze({
    DisplayName = "Monster Egg",
    BackgroundImage = "rbxassetid://97929357121314",
    DropTable = v1,
    Entries = buildEntries(v1),
    MechaEntries = buildEntries(v2)
}))
