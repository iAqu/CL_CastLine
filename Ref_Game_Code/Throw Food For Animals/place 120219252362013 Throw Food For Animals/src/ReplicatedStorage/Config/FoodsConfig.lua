-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local FoodsData = require(game:GetService("ReplicatedStorage"):WaitForChild("FoodsData"))
local ReleaseConfig = require(script.Parent.ReleaseConfig)
local t2 = {
    {
        Tier = 1,
        Bait = 1,
        Price = 0,
        Rarity = "Common"
    },
    {
        Tier = 1,
        Bait = 2,
        Price = 30,
        Rarity = "Common"
    },
    {
        Tier = 1,
        Bait = 3,
        Price = 150,
        Rarity = "Common"
    },
    {
        Tier = 2,
        Bait = 4,
        Price = 4000,
        Rarity = "Uncommon"
    },
    {
        Tier = 2,
        Bait = 5,
        Price = 20000,
        Rarity = "Uncommon"
    },
    {
        Tier = 3,
        Bait = 6,
        Price = 2E+05,
        Rarity = "Uncommon"
    },
    {
        Tier = 3,
        Bait = 7,
        Price = 1E+06,
        Rarity = "Rare"
    },
    {
        Tier = 4,
        Bait = 8,
        Price = 1.2E+07,
        Rarity = "Rare"
    },
    {
        Tier = 4,
        Bait = 9,
        Price = 6E+07,
        Rarity = "Rare"
    },
    {
        Tier = 5,
        Bait = 10,
        Price = 6.5E+08,
        Rarity = "Epic"
    },
    {
        Tier = 5,
        Bait = 11,
        Price = 3.2E+09,
        Rarity = "Epic"
    },
    {
        Tier = 6,
        Bait = 12,
        Price = 3E+10,
        Rarity = "Epic"
    },
    {
        Tier = 6,
        Bait = 13,
        Price = 1.5E+11,
        Rarity = "Legendary"
    },
    {
        Tier = 7,
        Bait = 14,
        Price = 1.3E+12,
        Rarity = "Legendary"
    },
    {
        Tier = 7,
        Bait = 15,
        Price = 6.8E+12,
        Rarity = "Legendary"
    },
    {
        Tier = 8,
        Bait = 16,
        Price = 5.7E+13,
        Rarity = "Mythic"
    },
    {
        Tier = 8,
        Bait = 17,
        Price = 1.5E+15,
        Rarity = "Mythic"
    },
    {
        Tier = 9,
        Bait = 18,
        Price = 5E+16,
        Rarity = "Mythic"
    },
    {
        Tier = 9,
        Bait = 19,
        Price = 1.2E+17,
        Rarity = "Secret"
    },
    {
        Tier = 10,
        Bait = 20,
        Price = 4E+18,
        Rarity = "Secret"
    },
    {
        Tier = 10,
        Bait = 21,
        Price = 1.8E+19,
        Rarity = "Secret"
    },
    {
        Tier = 11,
        Bait = 22,
        Price = 1.2E+20,
        Rarity = "Divine"
    },
    {
        Tier = 11,
        Bait = 23,
        Price = 7E+20,
        Rarity = "Divine"
    },
    {
        Tier = 12,
        Bait = 24,
        Price = 4E+21,
        Rarity = "Divine"
    },
    {
        Tier = 12,
        Bait = 25,
        Price = 2.7E+22,
        Rarity = "Celestial"
    },
    {
        Tier = 13,
        Bait = 25.3,
        Price = 1.8E+23,
        Rarity = "Celestial"
    },
    {
        Tier = 13,
        Bait = 26,
        Price = 4.5E+23,
        Rarity = "Celestial"
    },
    {
        Tier = 13,
        Bait = 27,
        Price = 1.3999999999999998E+24,
        Rarity = "Celestial"
    },
    {
        Tier = 13,
        Bait = 28,
        Price = 3.5E+24,
        Rarity = "Celestial"
    },
    {
        Tier = 14,
        Bait = 29,
        Price = 2.5E+27,
        Rarity = "Eternal",
        Release = "ShadowRealm"
    },
    {
        Tier = 14,
        Bait = 30,
        Price = 2.8E+28,
        Rarity = "Eternal",
        Release = "ShadowRealm"
    },
    {
        Tier = 14,
        Bait = 31,
        Price = 2.5E+29,
        Rarity = "Eternal",
        Release = "ShadowRealm"
    },
    {
        Tier = 15,
        Bait = 32,
        Price = 7.5E+32,
        Rarity = "Eternal",
        Release = "HarvestHarbor"
    },
    {
        Tier = 15,
        Bait = 33,
        Price = 8.5E+33,
        Rarity = "Eternal",
        Release = "HarvestHarbor"
    },
    {
        Tier = 15,
        Bait = 34,
        Price = 7.5E+34,
        Rarity = "Eternal",
        Release = "HarvestHarbor"
    },
    {
        Tier = 16,
        Bait = 35,
        Price = 1.8E+37,
        Rarity = "Cosmic",
        Release = "HarvestHarbor"
    },
    {
        Tier = 16,
        Bait = 36,
        Price = 2E+38,
        Rarity = "Cosmic",
        Release = "HarvestHarbor"
    },
    {
        Tier = 16,
        Bait = 37,
        Price = 1.8E+39,
        Rarity = "Cosmic",
        Release = "HarvestHarbor"
    }
}
local t1 = {}

t1.All = ReleaseConfig.Filter(t2)

for v1, v2 in ipairs(t1.All) do
    local v3 = FoodsData[v1]

    v2.Index = v1
    v2.ModelName = v3 and v3.ModelName or "Food" .. v1
    v2.Name = v3 and v3.Name or "Food " .. v1
    v2.Rest = v3 and v3.Rest or nil
end

t1.List = {}

local function refresh() -- line: 143
    -- upvalues: ReleaseConfig (copy), t1 (copy)
    ReleaseConfig.FillUnlocked(t1.List, t1.All)
end

ReleaseConfig.FillUnlocked(t1.List, t1.All)
ReleaseConfig.OnChanged(refresh)

function t1.Get(p1) -- line: 149
    -- upvalues: t1 (copy)
    return t1.List[p1]
end

function t1.Count() -- line: 153
    -- upvalues: t1 (copy)
    return #t1.List
end

function t1.GetAny(p2) -- line: 158
    -- upvalues: t1 (copy)
    return t1.All[p2]
end

function t1.CountAll() -- line: 162
    -- upvalues: t1 (copy)
    return #t1.All
end

function t1.IsLocked(p3) -- line: 167
    -- upvalues: t1 (copy)
    return t1.All[p3] ~= nil and t1.List[p3] == nil
end

return t1
