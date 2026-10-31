-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local t1 = {
    "tokenA",
    "tokenB",
    "tokenC"
}
local t2 = {
    tokenA = "Token A",
    tokenB = "Token B",
    tokenC = "Token C"
}
local t3 = {
    tokenA = Color3.fromRGB(210, 210, 215),
    tokenB = Color3.fromRGB(255, 190, 60),
    tokenC = Color3.fromRGB(230, 60, 60)
}
local t4 = {
    epic = 1,
    legendary = 2,
    mythic = 3,
    godly = 1,
    secret = 2,
    hacked = 3,
    cosmic = 1,
    extinct = 2,
    kaijuwu = 3
}
local t5 = {
    epic = "tokenA",
    legendary = "tokenA",
    mythic = "tokenA",
    godly = "tokenB",
    secret = "tokenB",
    hacked = "tokenB",
    cosmic = "tokenC",
    extinct = "tokenC",
    kaijuwu = "tokenC"
}

return {
    getTokenTypeForRarity = function(p1) -- getTokenTypeForRarity | line: 51
        -- upvalues: t5 (copy)
        return t5[p1]
    end,
    getMutationTokenMultiplier = function(p2) -- getMutationTokenMultiplier | line: 55
        return p2 + 1
    end,
    getTokensForFish = function(p3, p4) -- getTokensForFish | line: 59
        -- upvalues: t4 (copy)
        local v1 = t4[p3]

        if v1 == nil then
            return 0
        end

        return v1 * (p4 + 1)
    end,
    zoneTokenOrder = t1,
    zoneTokenDisplayNames = t2,
    zoneTokenBadgeColors = t3
}
