-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local aquariumCrateHardPity = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib")).import(script, game:GetService("ReplicatedStorage"), "TS", "data", "aquarium-crates").aquariumCrateHardPity

local function getLegendaryEntry(p1) -- line: 4
    local entries = p1.entries

    local function v1(p2) -- line: 7
        return p2.skin.rarity == "mythic"
    end

    local v2

    for v3, v4 in entries do
        local _ = v3 - 1

        if v1(v4) == true then
            v2 = v4
            break
        end

        v2 = nil
    end

    assert(v2 ~= nil, (("Aquarium crate series \"%*\" has no legendary entry"):format(p1.id)))

    return v2
end

local function rollWeightedEntry(p3, p4) -- line: 24
    local v7 = p4(1, 10000)
    local n1 = 0

    for _, v8 in p3.entries do
        n1 += v8.weightBasisPoints

        if v7 <= n1 then
            return v8
        end
    end

    return p3.entries[#p3.entries]
end

return {
    rollAquariumCrates = function(p5, p6, p7, p8) -- rollAquariumCrates | line: 37
        -- upvalues: aquariumCrateHardPity (copy), getLegendaryEntry (copy)
        local v9 = math.max(0, p6)
        local t1 = {}
        local v10 = getLegendaryEntry(p5)

        for _ = 0, p7 - 1 do
            local v11

            if aquariumCrateHardPity - 1 <= v9 then
                v11 = v10
            else
                local v12 = p8(1, 10000)
                local n2 = 0
                local v13 = false

                for _, v14 in p5.entries do
                    n2 += v14.weightBasisPoints

                    if v12 <= n2 then
                        v11 = v14
                        v13 = true
                        break
                    end
                end

                if not v13 then
                    v11 = p5.entries[#p5.entries]
                end
            end

            table.insert(t1, v11)

            if v11.skin.rarity == "mythic" then
                v9 = 0
            else
                v9 += 1
            end
        end

        return {
            pityCount = v9,
            rewards = t1
        }
    end
}
