-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReleaseConfig = require(script.Parent.ReleaseConfig)
local t2 = {
    {
        Name = "Wooden Bar",
        XpPerRep = 1,
        Price = 1
    },
    {
        Name = "Steel Bar",
        XpPerRep = 2,
        Price = 50
    },
    {
        Name = "Gold Bar",
        XpPerRep = 4,
        Price = 2000
    },
    {
        Name = "Cyan Bar",
        XpPerRep = 8,
        Price = 12000
    },
    {
        Name = "Violet Bar",
        XpPerRep = 16,
        Price = 1E+05
    },
    {
        Name = "Ruby Bar",
        XpPerRep = 32,
        Price = 6E+05
    },
    {
        Name = "Amber Bar",
        XpPerRep = 64,
        Price = 6E+06
    },
    {
        Name = "Chrome Bar",
        XpPerRep = 128,
        Price = 3.8E+07
    },
    {
        Name = "Obsidian Bar",
        XpPerRep = 256,
        Price = 3.2E+08
    },
    {
        Name = "Aqua Neon Bar",
        XpPerRep = 512,
        Price = 2E+09
    },
    {
        Name = "Pink Neon Bar",
        XpPerRep = 1024,
        Price = 1.5E+10
    },
    {
        Name = "Lime Neon Bar",
        XpPerRep = 2048,
        Price = 9E+10
    },
    {
        Name = "Solar Bar",
        XpPerRep = 4096,
        Price = 6.8E+11
    },
    {
        Name = "Frost Bar",
        XpPerRep = 8192,
        Price = 4.2E+12
    },
    {
        Name = "Magenta Bar",
        XpPerRep = 16384,
        Price = 2.8E+13
    },
    {
        Name = "Crimson Bar",
        XpPerRep = 32768,
        Price = 1.7E+14
    },
    {
        Name = "Emerald Bar",
        XpPerRep = 65536,
        Price = 1.2E+15
    },
    {
        Name = "Sapphire Bar",
        XpPerRep = 131072,
        Price = 7E+15
    },
    {
        Name = "Amethyst Bar",
        XpPerRep = 262144,
        Price = 5E+16
    },
    {
        Name = "Inferno Bar",
        XpPerRep = 524288,
        Price = 3E+17
    },
    {
        Name = "Blue Flame Bar",
        XpPerRep = 1048576,
        Price = 2E+18
    },
    {
        Name = "Holy Bar",
        XpPerRep = 2097152,
        Price = 1.2E+19
    },
    {
        Name = "Celestial Bar",
        XpPerRep = 4194304,
        Price = 8E+19
    },
    {
        Name = "Void Bar",
        XpPerRep = 8388608,
        Price = 5E+20
    },
    {
        Name = "Dragon Bar",
        XpPerRep = 16777216,
        Price = 3E+21
    },
    {
        Name = "Aurora Bar",
        XpPerRep = 33554432,
        Price = 1.8E+22
    },
    {
        Name = "Galaxy Bar",
        XpPerRep = 67108864,
        Price = 1.2E+23
    },
    {
        Name = "Infinity Bar",
        XpPerRep = 134217728,
        Price = 7E+23
    },
    {
        Name = "Eclipse Bar",
        XpPerRep = 268435456,
        Price = 3E+24
    },
    {
        Name = "Omega Bar",
        XpPerRep = 536870912,
        Price = 3E+26,
        Release = "ShadowRealm"
    },
    {
        Name = "Phantom Bar",
        XpPerRep = 1073741824,
        Price = 6.000000000000001E+27,
        Release = "ShadowRealm"
    },
    {
        Name = "Nightfall Bar",
        XpPerRep = 2147483648,
        Price = 6E+28,
        Release = "ShadowRealm"
    },
    {
        Name = "Eternal Bar",
        XpPerRep = 4294967296,
        Price = 5E+29,
        Release = "ShadowRealm"
    },
    {
        Name = "Abyss Bar",
        XpPerRep = 8589934592,
        Price = 2.5E+30,
        Release = "ShadowRealm"
    },
    {
        Name = "Scarecrow Bar",
        XpPerRep = 17179869184,
        Price = 9.000000000000001E+31,
        Release = "HarvestHarbor"
    },
    {
        Name = "Pumpkin Bar",
        XpPerRep = 34359738368,
        Price = 1.7999999999999998E+33,
        Release = "HarvestHarbor"
    },
    {
        Name = "Harvest Moon Bar",
        XpPerRep = 68719476736,
        Price = 1.8E+34,
        Release = "HarvestHarbor"
    },
    {
        Name = "Anchor Bar",
        XpPerRep = 137438953472,
        Price = 2.2000000000000003E+36,
        Release = "HarvestHarbor"
    },
    {
        Name = "Ghost Ship Bar",
        XpPerRep = 274877906944,
        Price = 4.500000000000001E+37,
        Release = "HarvestHarbor"
    },
    {
        Name = "Lighthouse Bar",
        XpPerRep = 549755813888,
        Price = 4.5000000000000006E+38,
        Release = "HarvestHarbor"
    }
}
local t1 = {}

t1.All = ReleaseConfig.Filter(t2)

for v1, v2 in ipairs(t1.All) do
    v2.Index = v1
end

t1.List = {}

local function refresh() -- line: 86
    -- upvalues: ReleaseConfig (copy), t1 (copy)
    ReleaseConfig.FillUnlocked(t1.List, t1.All)
end

ReleaseConfig.FillUnlocked(t1.List, t1.All)
ReleaseConfig.OnChanged(refresh)

function t1.Get(p1) -- line: 92
    -- upvalues: t1 (copy)
    return t1.List[p1]
end

function t1.Count() -- line: 96
    -- upvalues: t1 (copy)
    return #t1.List
end

function t1.GetAny(p2) -- line: 101
    -- upvalues: t1 (copy)
    return t1.All[p2]
end

return t1
