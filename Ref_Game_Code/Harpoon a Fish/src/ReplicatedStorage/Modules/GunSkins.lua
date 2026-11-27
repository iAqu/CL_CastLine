-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local t1 = {
    DEFAULT = "Classic",
    RARITIES = { "Rare", "Legendary", "Mythic" }
}

local function tex(p1) -- line: 20
    return "rbxassetid://" .. p1
end

t1.LIST = {
    {
        id = "Classic",
        name = "Classic",
        rarity = "Common"
    },
    {
        id = "WoodlandCamo",
        name = "Woodland Camo",
        rarity = "Rare",
        texture = "rbxassetid://" .. 138573040344912
    },
    {
        id = "ArcticCamo",
        name = "Arctic Camo",
        rarity = "Rare",
        texture = "rbxassetid://" .. 116972588179945
    },
    {
        id = "DigitalCamo",
        name = "Digital Camo",
        rarity = "Rare",
        texture = "rbxassetid://" .. 129323153257045
    },
    {
        id = "CarbonFiber",
        name = "Carbon Fiber",
        rarity = "Rare",
        texture = "rbxassetid://" .. 73291660988987
    },
    {
        id = "Graffiti",
        name = "Graffiti",
        rarity = "Rare",
        texture = "rbxassetid://" .. 104121364763878
    },
    {
        id = "TigerStripes",
        name = "Tiger Stripes",
        rarity = "Rare",
        texture = "rbxassetid://" .. 130284849897010
    },
    {
        id = "HazardStripes",
        name = "Hazard Stripes",
        rarity = "Rare",
        texture = "rbxassetid://" .. 74629969971171
    },
    {
        id = "CandyStripes",
        name = "Candy Stripes",
        rarity = "Rare",
        texture = "rbxassetid://" .. 122934075275404
    },
    {
        id = "Checkered",
        name = "Checkered",
        rarity = "Rare",
        texture = "rbxassetid://" .. 139546577187811
    },
    {
        id = "Lava",
        name = "Lava",
        rarity = "Rare",
        texture = "rbxassetid://" .. 133668763910488
    },
    {
        id = "Frost",
        name = "Frost",
        rarity = "Legendary",
        texture = "rbxassetid://" .. 130229186605264,
        addons = { "IceBarrel", "IceBase" }
    },
    {
        id = "Inferno",
        name = "Inferno",
        rarity = "Legendary",
        texture = "rbxassetid://" .. 74911744581268,
        addons = { "InfernoFlamesBarrel", "InfernoFlamesBase" }
    },
    {
        id = "RoyalGold",
        name = "Royal Gold",
        rarity = "Legendary",
        texture = "rbxassetid://" .. 114411473906237,
        addons = { "RoyalGemsBarrel", "RoyalCrownBase", "RoyalJewelsBase" }
    },
    {
        id = "Toxic",
        name = "Toxic",
        rarity = "Legendary",
        texture = "rbxassetid://" .. 129738063619831,
        addons = { "ToxicTanksBarrel", "ToxicStrapsBarrel", "ToxicGooBase" }
    },
    {
        id = "Galaxy",
        name = "Galaxy",
        rarity = "Legendary",
        texture = "rbxassetid://" .. 70983030730942,
        addons = { "GalaxyRingBarrel", "GalaxyStarsBase" }
    },
    {
        id = "Cyber",
        name = "Cyber",
        rarity = "Legendary",
        texture = "rbxassetid://" .. 70694630360877,
        addons = { "CyberFinsBarrel", "CyberRingBase" }
    },
    {
        id = "Obsidian",
        name = "Obsidian",
        rarity = "Legendary",
        texture = "rbxassetid://" .. 103238400182761,
        addons = { "ObsidianShardsBarrel", "ObsidianShardsBase", "ObsidianGlowBarrel", "ObsidianGlowBase" }
    },
    {
        id = "Stealth",
        name = "Stealth Harpoon",
        rarity = "Mythic",
        kit = "Stealth",
        paint = {
            Barrel = 34,
            BarrelUnderbody = 24,
            UpperBody = 30,
            Base = 24,
            Spool = 40,
            GearRotation = 46,
            Spikes = 22,
            Handle = 40,
            FloorAttatchment = 26,
            FloorAttatchmentSpike = 22
        }
    },
    {
        id = "PirateCannon",
        name = "Pirate Cannon",
        rarity = "Mythic",
        kit = "PirateCannon"
    },
    {
        id = "RPG",
        name = "RPG",
        rarity = "Mythic",
        kit = "RPG"
    },
    {
        id = "SciFiCannon",
        name = "Sci-Fi Cannon",
        rarity = "Mythic",
        kit = "SciFiCannon"
    },
    {
        id = "Slingshot",
        name = "Slingshot",
        rarity = "Mythic",
        kit = "Slingshot"
    },
    {
        id = "SharkBlaster",
        name = "Shark Blaster",
        rarity = "Mythic",
        kit = "SharkBlaster"
    },
    {
        id = "Ballista",
        name = "Ballista",
        rarity = "Mythic",
        kit = "Ballista"
    }
}

local t2 = {
    Classic = 84309628083698,
    WoodlandCamo = 104322818329768,
    ArcticCamo = 126224432267506,
    DigitalCamo = 91505271935647,
    CarbonFiber = 119467085847124,
    Graffiti = 73691319436576,
    TigerStripes = 110035626111796,
    HazardStripes = 99548416076145,
    CandyStripes = 128969755598308,
    Checkered = 107754911943122,
    Lava = 126762667665147,
    Frost = 129927707119435,
    Inferno = 108507232789848,
    RoyalGold = 73314838008703,
    Toxic = 85324950885670,
    Galaxy = 129134078853613,
    Cyber = 106046492202559,
    Obsidian = 83124128412650,
    Stealth = 76028507227776,
    PirateCannon = 80828571791933,
    RPG = 92372470391395,
    SciFiCannon = 128989570902876,
    Slingshot = 139975377679742,
    SharkBlaster = 91865560236663,
    Ballista = 81615175038057
}
local t3 = {}

for v1, v2 in ipairs(t1.LIST) do
    v2.order = v1
    v2.icon = t2[v2.id] and "rbxassetid://" .. t2[v2.id] or nil
    t3[v2.id] = v2
end

function t1.Get(p2) -- line: 79
    -- upvalues: t3 (copy)
    return if p2 then t3[p2] or nil else nil
end

function t1.OfRarity(p3) -- line: 82
    -- upvalues: t1 (copy)
    local t4 = {}

    for _, v4 in ipairs(t1.LIST) do
        if v4.rarity == p3 then
            t4[#t4 + 1] = v4
        end
    end

    return t4
end

return t1
