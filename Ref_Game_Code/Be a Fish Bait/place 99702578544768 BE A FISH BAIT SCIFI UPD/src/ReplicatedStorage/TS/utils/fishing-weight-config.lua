-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local fishDataByRarity = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib")).import(script, game:GetService("ReplicatedStorage"), "TS", "data", "fish").fishDataByRarity
local t1 = {
    common = {
        common = 75,
        uncommon = 5,
        rare = 1,
        epic = 0,
        legendary = 0,
        mythic = 0,
        godly = 0,
        secret = 0,
        hacked = 0,
        cosmic = 0,
        extinct = 0,
        kaijuwu = 0,
        scifi = 0,
        exclusive = 0
    },
    uncommon = {
        common = 0,
        uncommon = 55,
        rare = 3,
        epic = 1,
        legendary = 0,
        mythic = 0,
        godly = 0,
        secret = 0,
        hacked = 0,
        cosmic = 0,
        extinct = 0,
        kaijuwu = 0,
        scifi = 0,
        exclusive = 0
    },
    rare = {
        common = 0,
        uncommon = 0,
        rare = 55,
        epic = 5,
        legendary = 1,
        mythic = 0,
        godly = 0,
        secret = 0,
        hacked = 0,
        cosmic = 0,
        extinct = 0,
        kaijuwu = 0,
        scifi = 0,
        exclusive = 0
    },
    epic = {
        common = 0,
        uncommon = 0,
        rare = 0,
        epic = 55,
        legendary = 5,
        mythic = 1,
        godly = 0,
        secret = 0,
        hacked = 0,
        cosmic = 0,
        extinct = 0,
        kaijuwu = 0,
        scifi = 0,
        exclusive = 0
    },
    legendary = {
        common = 0,
        uncommon = 0,
        rare = 0,
        epic = 0,
        legendary = 85,
        mythic = 15,
        godly = 0,
        secret = 0,
        hacked = 0,
        cosmic = 0,
        extinct = 0,
        kaijuwu = 0,
        scifi = 0,
        exclusive = 0
    },
    mythic = {
        common = 0,
        uncommon = 0,
        rare = 0,
        epic = 0,
        legendary = 0,
        mythic = 85,
        godly = 15,
        secret = 0,
        hacked = 0,
        cosmic = 0,
        extinct = 0,
        kaijuwu = 0,
        scifi = 0,
        exclusive = 0
    },
    godly = {
        common = 0,
        uncommon = 0,
        rare = 0,
        epic = 0,
        legendary = 0,
        mythic = 0,
        godly = 85,
        secret = 15,
        hacked = 0,
        cosmic = 0,
        extinct = 0,
        kaijuwu = 0,
        scifi = 0,
        exclusive = 0
    },
    secret = {
        common = 0,
        uncommon = 0,
        rare = 0,
        epic = 0,
        legendary = 0,
        mythic = 0,
        godly = 0,
        secret = 85,
        hacked = 15,
        cosmic = 0,
        extinct = 0,
        kaijuwu = 0,
        scifi = 0,
        exclusive = 0
    },
    hacked = {
        common = 0,
        uncommon = 0,
        rare = 0,
        epic = 0,
        legendary = 0,
        mythic = 0,
        godly = 0,
        secret = 0,
        hacked = 85,
        cosmic = 15,
        extinct = 0,
        kaijuwu = 0,
        scifi = 0,
        exclusive = 0
    },
    cosmic = {
        common = 0,
        uncommon = 0,
        rare = 0,
        epic = 0,
        legendary = 0,
        mythic = 0,
        godly = 0,
        secret = 0,
        hacked = 0,
        cosmic = 85,
        extinct = 15,
        kaijuwu = 0,
        scifi = 0,
        exclusive = 0
    },
    extinct = {
        common = 0,
        uncommon = 0,
        rare = 0,
        epic = 0,
        legendary = 0,
        mythic = 0,
        godly = 0,
        secret = 0,
        hacked = 0,
        cosmic = 0,
        extinct = 100,
        kaijuwu = 0,
        scifi = 0,
        exclusive = 0
    },
    kaijuwu = {
        common = 0,
        uncommon = 0,
        rare = 0,
        epic = 0,
        legendary = 0,
        mythic = 0,
        godly = 0,
        secret = 0,
        hacked = 0,
        cosmic = 0,
        extinct = 100,
        kaijuwu = 0,
        scifi = 0,
        exclusive = 0
    },
    scifi = {
        common = 0,
        uncommon = 0,
        rare = 0,
        epic = 0,
        legendary = 0,
        mythic = 0,
        godly = 0,
        secret = 0,
        hacked = 0,
        cosmic = 0,
        extinct = 0,
        kaijuwu = 0,
        scifi = 100,
        exclusive = 0
    }
}

local function pickWeightedRarity(p1) -- line: 236
    -- upvalues: t1 (copy)
    local v1 = t1[p1]
    local t2 = {}
    local n1 = 0

    for v2, v3 in pairs(v1) do
        if not (v3 <= 0) then
            n1 += v3
            table.insert(t2, {
                rarity = v2,
                ceiling = n1
            })
        end
    end

    if n1 == 0 then
        return nil
    end

    local v4 = math.random() * n1

    for _, v5 in t2 do
        if v4 < v5.ceiling then
            return v5.rarity
        end
    end

    local v6 = t2[#t2]

    if v6 ~= nil then
        v6 = v6.rarity
    end

    return v6
end

return {
    pickWeightedRarity = pickWeightedRarity,
    pickWeightedFish = function(p2) -- pickWeightedFish | line: 286
        -- upvalues: fishDataByRarity (copy), pickWeightedRarity (copy)
        local v7 = pickWeightedRarity(p2)

        if v7 == nil then
            return nil
        end

        local v8 = fishDataByRarity[v7]

        return if v8 ~= nil and #v8 ~= 0 then v8[math.random(0, #v8 - 1) + 1] else nil
    end,
    zoneBiteWeightMatrix = t1
}
