-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local HarpoonSkins = require(script.Parent:WaitForChild("HarpoonSkins"))
local t1 = {}

t1.PLACEHOLDER_ICON = "rbxassetid://138818103926341"
t1.BURST_AT = 2.5

local t2 = {
    "Common",
    "Uncommon",
    "Rare",
    "Epic",
    "Legendary",
    "Mythic",
    "Exotic",
    "Secret"
}

local function withRest(p1, p2) -- line: 28
    -- upvalues: HarpoonSkins (copy), t2 (copy)
    local n1 = 0

    for _, v1 in ipairs(p2) do
        n1 += v1.chance
    end

    local v2 = 100 - n1

    if not (v2 <= 0) then
        local v3 = HarpoonSkins.CRATE_MIX[p1] or {}
        local t3 = {}
        local t4 = {}
        local n2 = 0

        for _, v4 in ipairs(HarpoonSkins.LIST) do
            if v4.crate == p1 and v3[v4.rarity] then
                if not t3[v4.rarity] then
                    local rarity, rarity2 = v4.rarity, v4.rarity

                    t3[rarity] = {}
                    t4[rarity2] = 0
                    n2 += v3[v4.rarity]
                end

                table.insert(t3[v4.rarity], v4)
                t4[v4.rarity] += v4.weight or 1
            end
        end

        if n2 == 0 then
            table.insert(p2, {
                placeholder = true,
                rarity = "Common",
                chance = v2
            })
        else
            local n3 = 0

            for _, v6 in ipairs(t2) do
                local v7 = n3

                for _, v8 in ipairs(t3[v6] or {}) do
                    local v10 = math.round(v2 * v3[v6] / n2 * (v8.weight or 1) / t4[v6] * 100) / 100

                    v7 += v10
                    n3 = v7
                    table.insert(p2, {
                        harpoon = v8.id,
                        chance = v10,
                        rarity = v8.rarity
                    })
                end
            end

            p2[#p2].chance = math.round((p2[#p2].chance + v2 - n3) * 100) / 100
        end
    end

    return p2
end

t1.DROPS = {
    Wood = withRest("Wood", {
        {
            key = "Stone",
            chance = 20,
            rarity = "Uncommon"
        }
    }),
    Stone = withRest("Stone", {
        {
            key = "Gold",
            chance = 15,
            rarity = "Rare"
        }
    }),
    Gold = withRest("Gold", {
        {
            key = "Ruby",
            chance = 10,
            rarity = "Epic"
        }
    }),
    Ruby = withRest("Ruby", {
        {
            key = "Diamond",
            chance = 5,
            rarity = "Legendary"
        }
    }),
    Diamond = withRest("Diamond", {
        {
            key = "Secret",
            chance = 2.5,
            rarity = "Mythic"
        }
    }),
    Secret = withRest("Secret", {})
}

function t1.Title(p3) -- line: 72
    -- upvalues: HarpoonSkins (copy)
    if p3.key then
        return p3.key .. " Key"
    end

    local v13 = p3.harpoon and HarpoonSkins.Get(p3.harpoon)

    if v13 then
        return v13.name
    end

    return "???"
end

function t1.ChanceText(p4) -- line: 80
    return string.format("%g%%", p4.chance)
end

function t1.Roll(p5, p6) -- line: 85
    -- upvalues: t1 (copy)
    local v14 = t1.DROPS[p5]

    if not v14 then
        return nil
    end

    local v15 = (p6 and p6:NextNumber() or math.random()) * 100

    for v16, v17 in ipairs(v14) do
        v15 -= v17.chance

        if v15 < 0 then
            return v17, v16
        end
    end

    return v14[#v14], #v14
end

return t1
