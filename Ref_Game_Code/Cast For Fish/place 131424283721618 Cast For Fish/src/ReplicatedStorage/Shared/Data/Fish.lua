-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local t1 = {
    {
        id = "minnow",
        name = "Minnow",
        zone = "shallows",
        rarity = "Common",
        odds = 1,
        income = 3,
        kg = { 0.1, 0.4 }
    },
    {
        id = "clownfish",
        name = "Clownfish",
        zone = "shallows",
        rarity = "Common",
        odds = 2,
        income = 5,
        kg = { 0.2, 0.6 }
    },
    {
        id = "bluegill",
        name = "Bluegill",
        zone = "shallows",
        rarity = "Uncommon",
        odds = 4,
        income = 9,
        kg = { 0.3, 1.2 }
    },
    {
        id = "pufferfish",
        name = "Pufferfish",
        zone = "shallows",
        rarity = "Uncommon",
        odds = 8,
        income = 15,
        kg = { 0.5, 2 }
    },
    {
        id = "seahorse",
        name = "Seahorse",
        zone = "shallows",
        rarity = "Rare",
        odds = 20,
        income = 30,
        kg = { 0.1, 0.5 }
    },
    {
        id = "flounder",
        name = "Flounder",
        zone = "shallows",
        rarity = "Rare",
        odds = 60,
        income = 70,
        kg = { 1, 6 }
    },
    {
        id = "stingray",
        name = "Stingray",
        zone = "shallows",
        rarity = "Epic",
        odds = 250,
        income = 250,
        kg = { 8, 40 }
    },
    {
        id = "barracuda",
        name = "Barracuda",
        zone = "shallows",
        rarity = "Legendary",
        odds = 1500,
        income = 1200,
        kg = { 10, 45 }
    },
    {
        id = "butterflyfish",
        name = "Butterflyfish",
        zone = "coral_reef",
        rarity = "Uncommon",
        odds = 1,
        income = 400,
        kg = { 0.2, 0.8 }
    },
    {
        id = "angelfish",
        name = "Angelfish",
        zone = "coral_reef",
        rarity = "Rare",
        odds = 4,
        income = 900,
        kg = { 0.5, 1.6 }
    },
    {
        id = "lionfish",
        name = "Lionfish",
        zone = "coral_reef",
        rarity = "Rare",
        odds = 12,
        income = 2000,
        kg = { 0.5, 1.4 }
    },
    {
        id = "moray_eel",
        name = "Moray Eel",
        zone = "coral_reef",
        rarity = "Epic",
        odds = 40,
        income = 6000,
        kg = { 5, 30 }
    },
    {
        id = "parrotfish",
        name = "Parrotfish",
        zone = "coral_reef",
        rarity = "Epic",
        odds = 150,
        income = 18000,
        kg = { 3, 20 }
    },
    {
        id = "swordfish",
        name = "Swordfish",
        zone = "coral_reef",
        rarity = "Legendary",
        odds = 600,
        income = 60000,
        kg = { 90, 500 }
    },
    {
        id = "hammerhead",
        name = "Hammerhead",
        zone = "coral_reef",
        rarity = "Mythic",
        odds = 4000,
        income = 4E+05,
        kg = { 150, 450 }
    },
    {
        id = "sea_dragon",
        name = "Sea Dragon",
        zone = "coral_reef",
        rarity = "Secret",
        odds = 30000,
        income = 2500000,
        kg = { 60, 300 }
    },
    {
        id = "lanternfish",
        name = "Lanternfish",
        zone = "deep_sea",
        rarity = "Rare",
        odds = 1,
        income = 1E+06,
        kg = { 0.1, 0.5 }
    },
    {
        id = "viperfish",
        name = "Viperfish",
        zone = "deep_sea",
        rarity = "Epic",
        odds = 6,
        income = 3E+06,
        kg = { 0.3, 1.5 }
    },
    {
        id = "anglerfish",
        name = "Anglerfish",
        zone = "deep_sea",
        rarity = "Legendary",
        odds = 25,
        income = 1.2E+07,
        kg = { 5, 45 }
    },
    {
        id = "gulper_eel",
        name = "Gulper Eel",
        zone = "deep_sea",
        rarity = "Legendary",
        odds = 100,
        income = 4E+07,
        kg = { 4, 20 }
    },
    {
        id = "giant_squid",
        name = "Giant Squid",
        zone = "deep_sea",
        rarity = "Mythic",
        odds = 500,
        income = 1.5E+08,
        kg = { 150, 900 }
    },
    {
        id = "goblin_shark",
        name = "Goblin Shark",
        zone = "deep_sea",
        rarity = "Secret",
        odds = 3000,
        income = 9E+08,
        kg = { 120, 600 }
    },
    {
        id = "kraken",
        name = "Kraken",
        zone = "deep_sea",
        rarity = "Divine",
        odds = 25000,
        income = 8E+09,
        kg = { 2000, 9000 }
    },
    {
        id = "leviathan",
        name = "Leviathan",
        zone = "deep_sea",
        rarity = "Celestial",
        odds = 250000,
        income = 9E+10,
        kg = { 20000, 90000 }
    }
}
local t2 = {
    "Common",
    "Uncommon",
    "Rare",
    "Epic",
    "Legendary",
    "Mythic",
    "Secret",
    "Divine",
    "Celestial",
    "Eternal",
    "Cosmic",
    "Supreme",
    "Sovereign",
    "Ascended",
    "Primordial",
    "Omega",
    "Transcendent",
    "Apex",
    "Absolute"
}
local t3 = {
    1, 3, 10, 30, 100, 600, 3000, 15000
}
local t4 = {
    0, 2, 6, 20, 80, 300, 850, 2500
}
local t5 = {
    kelp_forest = {
        { "urchin_knight", "Urchin Knight", 2, 9 },
        { "grove_manatee", "Grove Manatee", 200, 900 }
    },
    mangrove_swamp = {
        { "firefly_jelly", "Firefly Jelly", 3, 14 },
        { "venus_maw", "Venus Maw", 400, 1800 }
    },
    frozen_fjord = {
        { "torpedo_penguin", "Torpedo Penguin", 12, 40 },
        { "tusk_walrus", "Tusk Walrus", 900, 3500 }
    },
    sunken_ruins = {
        { "amphora_crab", "Amphora Crab", 15, 60 },
        { "trojan_seahorse", "Trojan Seahorse", 1500, 6000 }
    },
    volcanic_vents = {
        { "brimstone_batfish", "Brimstone Batfish", 18, 70 },
        { "phoenix_ray", "Phoenix Ray", 2000, 9000 }
    },
    crystal_caverns = {
        { "gem_snail", "Gem Snail", 40, 160 },
        { "chandelier_jelly", "Chandelier Jelly", 2500, 11000 }
    },
    shipwreck_graveyard = {
        { "treasure_mimic", "Treasure Mimic", 60, 250 },
        { "helmet_octopus", "Helmet Octopus", 4000, 16000 }
    },
    abyssal_trench = {
        { "skull_isopod", "Skull Isopod", 90, 380 },
        { "stilt_horror", "Stilt Horror", 6000, 26000 }
    },
    storm_sea = {
        { "gale_nautilus", "Gale Nautilus", 120, 500 },
        { "tsunami_whale", "Tsunami Whale", 30000, 120000 }
    },
    celestial_ocean = {
        { "saturn_puffer", "Saturn Puffer", 200, 800 },
        { "eclipse_manta", "Eclipse Manta", 50000, 2E+05 }
    }
}
local t6 = {
    [4] = 8.5,
    [5] = 11,
    [6] = 14,
    [7] = 18,
    [8] = 23,
    [9] = 29,
    [10] = 36,
    [11] = 45,
    [12] = 56,
    [13] = 70,
    [14] = 90,
    [15] = 112,
    [16] = 140,
    [17] = 175,
    [18] = 220,
    [19] = 275,
    [20] = 345
}

local function zoneBaseIncome(p1) -- line: 66
    return 200 ^ (p1 - 4) * 5E+08
end

local function zoneLuck(p2) -- line: 69
    -- upvalues: t6 (copy)
    return ((p2 - 0.5) ^ 2 * 4 + 1) * t6[p2]
end

local t7 = {
    {
        4,
        "kelp_forest",
        {
            { "leafback_cod", "Leafback Cod", 1, 5 },
            { "kelp_weaver", "Kelp Weaver Eel", 3, 14 },
            { "moss_ray", "Moss Ray", 10, 60 },
            { "thornpike", "Thornpike", 20, 90 },
            { "frond_stag", "Frond Stag", 150, 600 },
            { "tidewood_ancient", "Tidewood Ancient", 900, 4000 }
        }
    },
    {
        5,
        "mangrove_swamp",
        {
            { "mudskipper", "Mudskipper", 0.2, 1 },
            { "rootsnapper", "Rootsnapper", 4, 20 },
            { "lily_toadfish", "Lily Toadfish", 6, 30 },
            { "swamp_gar", "Swamp Gar", 40, 160 },
            { "bog_titan", "Bog Titan", 300, 1200 },
            { "mangrove_hydra", "Mangrove Hydra", 2000, 9000 }
        }
    },
    {
        6,
        "frozen_fjord",
        {
            { "icefin", "Icefin", 0.5, 3 },
            { "frost_eel", "Frost Eel", 5, 25 },
            { "snow_skate", "Snow Skate", 15, 80 },
            { "glacier_pike", "Glacier Pike", 60, 240 },
            { "narwhal", "Rime Narwhal", 800, 1900 },
            { "glacier_mammoth", "Glacier Mammoth", 5000, 22000 }
        }
    },
    {
        7,
        "sunken_ruins",
        {
            { "coin_guppy", "Coin Guppy", 0.1, 0.6 },
            { "statue_eel", "Statue Eel", 8, 40 },
            { "gilded_ray", "Gilded Ray", 30, 150 },
            { "marble_shark", "Marble Shark", 200, 800 },
            { "temple_guardian", "Temple Guardian", 1500, 5000 },
            { "sunken_sphinx", "Sunken Sphinx", 9000, 40000 }
        }
    },
    {
        8,
        "volcanic_vents",
        {
            { "ember_tetra", "Ember Tetra", 0.2, 1.2 },
            { "magma_eel", "Magma Eel", 10, 50 },
            { "cinder_crab", "Cinder Crab", 20, 110 },
            { "obsidian_shark", "Obsidian Shark", 300, 1100 },
            { "lava_colossus", "Lava Colossus", 2500, 8000 },
            { "inferno_drake", "Inferno Drake", 15000, 60000 }
        }
    },
    {
        9,
        "crystal_caverns",
        {
            { "shardfin", "Shardfin", 0.5, 2.5 },
            { "quartz_eel", "Quartz Eel", 12, 55 },
            { "geode_puffer", "Geode Puffer", 25, 120 },
            { "amethyst_shark", "Amethyst Shark", 400, 1400 },
            { "prism_whale", "Prism Whale", 6000, 20000 },
            { "geode_golem", "Geode Golem", 25000, 90000 }
        }
    },
    {
        10,
        "shipwreck_graveyard",
        {
            { "barnacle_bass", "Barnacle Bass", 1, 6 },
            { "anchor_eel", "Anchor Eel", 15, 70 },
            { "ghost_ray", "Ghost Ray", 40, 200 },
            { "rustjaw", "Rustjaw", 500, 1800 },
            { "cannon_whale", "Cannon Whale", 9000, 30000 },
            { "ghost_galleon", "Ghost Galleon", 40000, 150000 }
        }
    },
    {
        11,
        "abyssal_trench",
        {
            { "voidling", "Voidling", 0.3, 2 },
            { "hollow_eel", "Hollow Eel", 20, 90 },
            { "dread_squid", "Dread Squid", 300, 1500 },
            { "trench_stalker", "Trench Stalker", 700, 2500 },
            { "abyss_angler", "Abyss Angler", 12000, 40000 },
            { "abyssal_maw", "Abyssal Maw", 60000, 250000 }
        }
    },
    {
        12,
        "storm_sea",
        {
            { "sparkfin", "Sparkfin", 0.5, 3 },
            { "thunder_eel", "Thunder Eel", 25, 110 },
            { "squall_ray", "Squall Ray", 60, 300 },
            { "tempest_shark", "Tempest Shark", 900, 3200 },
            { "cyclone_squid", "Cyclone Squid", 15000, 50000 },
            { "maelstrom", "Maelstrom", 90000, 4E+05 }
        }
    },
    {
        13,
        "celestial_ocean",
        {
            { "starlet", "Starlet", 0.1, 1 },
            { "comet_eel", "Comet Eel", 30, 130 },
            { "nebula_ray", "Nebula Ray", 80, 400 },
            { "solar_shark", "Solar Shark", 1200, 4000 },
            { "lunar_whale", "Lunar Whale", 20000, 70000 },
            { "galaxy_moth", "Galaxy Moth", 150000, 9E+05 }
        }
    }
}

local function roundNice(p3) -- line: 84
    local v2 = 10 ^ math.floor((math.log10(p3)))

    return math.floor(p3 / v2 * 10 + 0.5) / 10 * v2
end

for _, v4 in ipairs(t7) do
    local v5 = v4[1]
    local v6 = v4[2]
    local v7 = v4[3]
    local v8 = t5[v6]
    local t8 = {
        v7[1],
        v7[2],
        v7[3],
        v8[1],
        v7[4],
        v7[5],
        v8[2],
        v7[6]
    }
    local v10 = math.floor((v5 - 4) / 2) + 4

    for v11, v12 in ipairs(t8) do
        local t9 = {
            id = v12[1],
            name = v12[2],
            zone = v6,
            slot = v11,
            rarity = t2[math.min(13, v10 + v11 - 1)]
        }

        if v11 == 1 then
            t9.odds = 1
        else
            local v14 = ((v5 - 0.5) ^ 2 * 4 + 1) * t6[v5] * t4[v11]
            local v16 = 10 ^ math.floor((math.log10(v14)))

            t9.odds = math.max(2, (math.floor(math.floor(v14 / v16 * 10 + 0.5) / 10 * v16 + 0.5)))
        end

        local v20 = 5E+08 * 200 ^ (v5 - 4) * t3[v11]
        local v22 = 10 ^ math.floor((math.log10(v20)))

        t9.income = math.floor(v20 / v22 * 10 + 0.5) / 10 * v22
        t9.kg = {
            v12[3],
            v12[4]
        }
        table.insert(t1, t9)
    end
end

local t10 = {
    1, 3, 10, 30, 100, 150, 250, 400,
    700, 2000, 6000, 25000
}
local t11 = {
    0, 1.5, 3, 5, 8, 11, 24, 50,
    110, 300, 850, 2500
}
local t12 = {
    {
        14,
        "toxic_lagoon",
        8,
        {
            { "sludge_guppy", "Sludge Guppy", 1, 6 },
            { "barrel_crab", "Barrel Crab", 20, 90 },
            { "gasmask_puffer", "Gasmask Puffer", 40, 180 },
            { "three_eyed_carp", "Three-Eyed Carp", 120, 500 },
            { "ooze_eel", "Ooze Eel", 400, 1600 },
            { "hazmat_ray", "Hazmat Ray", 2000, 8000 },
            { "mutant_gator", "Mutant Gator", 20000, 80000 },
            { "meltdown_toad", "Meltdown Toad", 2E+05, 1E+06 }
        }
    },
    {
        15,
        "clockwork_depths",
        9,
        {
            { "cog_minnow", "Cog Minnow", 2, 8 },
            { "windup_tuna", "Wind-Up Tuna", 30, 120 },
            { "piston_shrimp", "Piston Shrimp", 50, 220 },
            { "pocketwatch_turtle", "Pocketwatch Turtle", 200, 800 },
            { "periscope_pike", "Periscope Pike", 600, 2400 },
            { "pendulum_ray", "Pendulum Ray", 3000, 12000 },
            { "gearjaw_shark", "Gearjaw Shark", 30000, 110000 },
            { "chrono_colossus", "Chrono Colossus", 3E+05, 1400000 }
        }
    },
    {
        16,
        "neon_reef",
        10,
        {
            { "led_tetra", "LED Tetra", 1, 5 },
            { "boombox_crab", "Boombox Crab", 40, 160 },
            { "laser_marlin", "Laser Marlin", 300, 1200 },
            { "holo_jelly", "Holo Jelly", 100, 400 },
            { "arcade_puffer", "Arcade Puffer", 900, 3600 },
            { "drone_ray", "Drone Ray", 4000, 16000 },
            { "mecha_shark", "Mecha Shark", 40000, 150000 },
            { "neon_kirin", "Neon Kirin", 4E+05, 1800000 }
        }
    },
    {
        17,
        "primeval_sea",
        11,
        {
            { "trilobite", "Trilobite", 2, 9 },
            { "ammonite", "Ammonite", 30, 130 },
            { "coelacanth", "Coelacanth", 80, 300 },
            { "anomalocaris", "Anomalocaris", 150, 600 },
            { "sea_scorpion", "Sea Scorpion", 400, 1500 },
            { "buzzsaw_shark", "Buzzsaw Shark", 1500, 6000 },
            { "archelon", "Archelon", 4000, 15000 },
            { "dunkleosteus", "Dunkleosteus", 12000, 45000 },
            { "plesiosaur", "Plesiosaur", 40000, 150000 },
            { "spinosaur", "Spinosaur", 120000, 450000 },
            { "mosasaur", "Mosasaur", 4E+05, 1500000 },
            { "megalodon", "Megalodon", 1200000, 5E+06 }
        }
    },
    {
        18,
        "nightmare_sea",
        11,
        {
            { "eyeball_fry", "Eyeball Fry", 1, 4 },
            { "gnasher", "Gnasher", 40, 150 },
            { "handcrab", "Handcrab", 60, 250 },
            { "stitch_eel", "Stitch Eel", 200, 800 },
            { "mask_ray", "Mask Ray", 500, 2000 },
            { "widow_squid", "Widow Squid", 2000, 8000 },
            { "ribcage_shark", "Ribcage Shark", 6000, 22000 },
            { "puppeteer", "Puppeteer", 15000, 60000 },
            { "coffin_whale", "Coffin Whale", 60000, 220000 },
            { "argus", "Argus", 150000, 6E+05 },
            { "reaper_marlin", "Reaper Marlin", 5E+05, 2E+06 },
            { "the_sleepless", "The Sleepless", 2E+06, 8E+06 }
        }
    },
    {
        19,
        "glitch_rift",
        11,
        {
            { "pixel_guppy", "Pixel Guppy", 1, 3 },
            { "missing_texture", "Missing Texture", 50, 200 },
            { "wireframe_eel", "Wireframe Eel", 80, 320 },
            { "error_crab", "Error Crab", 250, 1000 },
            { "lag_ray", "Lag Ray", 700, 2800 },
            { "polygon_puffer", "Polygon Puffer", 2500, 10000 },
            { "cursor_shark", "Cursor Shark", 8000, 30000 },
            { "loading_whale", "Loading Whale", 25000, 1E+05 },
            { "rgb_axolotl", "RGB Axolotl", 80000, 3E+05 },
            { "corrupt_kraken", "Corrupt Kraken", 250000, 9E+05 },
            { "bluescreen_titan", "Bluescreen Titan", 8E+05, 3E+06 },
            { "null_entity", "NULL", 3E+06, 1.2E+07 }
        }
    },
    {
        20,
        "divine_throne",
        11,
        {
            { "cherub_koi", "Cherub Koi", 2, 8 },
            { "laurel_seahorse", "Laurel Seahorse", 60, 240 },
            { "trident_marlin", "Trident Marlin", 400, 1600 },
            { "lyre_ray", "Lyre Ray", 900, 3600 },
            { "pegafin", "Pegafin", 2500, 10000 },
            { "medusa_jelly", "Medusa Jelly", 6000, 24000 },
            { "cerberus_shark", "Cerberus Shark", 20000, 80000 },
            { "helios_wheel", "Helios Wheel", 60000, 240000 },
            { "brazen_bull", "Brazen Bull", 2E+05, 8E+05 },
            { "atlas_whale", "Atlas Whale", 7E+05, 2800000 },
            { "storm_sovereign", "Storm Sovereign", 2E+06, 8E+06 },
            { "tidefather", "The Tidefather", 6E+06, 2.5E+07 }
        }
    }
}

for _, v24 in ipairs(t12) do
    local v25 = v24[1]
    local v26 = v24[2]
    local v27 = v24[3]
    local v28 = v24[4]
    local v29 = #v28 == 12
    local t13 = if v29 then t11 else t4
    local t14 = if v29 then t10 else t3

    for v30, v31 in ipairs(v28) do
        local v32 = if v29 then math.floor((v30 - 1) * 8 / 11 + 0.5) else v30 - 1
        local t15 = {
            id = v31[1],
            name = v31[2],
            zone = v26,
            slot = v30,
            rarity = t2[math.min(#t2, v27 + v32)]
        }

        if v30 == 1 then
            t15.odds = 1
        else
            local v36 = ((v25 - 0.5) ^ 2 * 4 + 1) * t6[v25] * t13[v30]
            local v38 = 10 ^ math.floor((math.log10(v36)))

            t15.odds = math.max(2, (math.floor(math.floor(v36 / v38 * 10 + 0.5) / 10 * v38 + 0.5)))
        end

        local v42 = 5E+08 * 200 ^ (v25 - 4) * t14[v30]
        local v44 = 10 ^ math.floor((math.log10(v42)))

        t15.income = math.floor(v42 / v44 * 10 + 0.5) / 10 * v44
        t15.kg = {
            v31[3],
            v31[4]
        }
        table.insert(t1, t15)
    end
end

local v46 = t1[#t1]

assert(v46.id == "tidefather")
v46.endgame = 1

local t16 = {
    { "seraphion", "Seraphion", "Exalted", 4E+09, 4, 1.2E+07, 5E+07 },
    { "charybdis", "Charybdis", "Paradox", 1.2E+10, 16, 2.5E+07, 1E+08 },
    { "kronos", "Kronos", "Genesis", 3.6E+10, 64, 5E+07, 2E+08 },
    { "khaos", "Khaos", "Singularity", 1.1E+11, 256, 1E+08, 4E+08 }
}

for v48, v49 in ipairs(t16) do
    local t17 = {
        zone = "divine_throne",
        id = v49[1],
        name = v49[2],
        slot = 12 + v48,
        rarity = v49[3],
        odds = v49[4]
    }
    local v50 = v46.income * v49[5]
    local v52 = 10 ^ math.floor((math.log10(v50)))

    t17.income = math.floor(v50 / v52 * 10 + 0.5) / 10 * v52
    t17.kg = {
        v49[6],
        v49[7]
    }
    t17.endgame = v48 + 1
    table.insert(t1, t17)
end

local t18 = {
    { "gumdrop_guppy", "Gumdrop Guppy", "Supreme", 1, 6.6E+47, 1, 4 },
    { "sprinkle_koi", "Sprinkle Koi", "Sovereign", 1100000, 2E+48, 40, 160 },
    { "cotton_candy_jelly", "Cotton Candy Jelly", "Sovereign", 2200000, 6.6E+48, 60, 240 },
    { "candy_cane_seahorse", "Candy Cane Seahorse", "Ascended", 3600000, 2E+49, 150, 600 },
    { "lollipop_ray", "Lollipop Ray", "Ascended", 5800000, 6.6E+49, 500, 2000 },
    { "mantis_shrimp", "Mantis Shrimp", "Primordial", 8E+06, 9.8E+49, 800, 3200 },
    { "strawberry_squid", "Strawberry Squid", "Primordial", 1.2E+07, 1.3E+50, 1500, 6000 },
    { "coconut_octopus", "Coconut Octopus", "Omega", 1.7E+07, 1.6E+50, 2500, 10000 },
    { "seadragon", "Seadragon", "Omega", 2.5E+07, 2.2E+50, 5000, 20000 },
    { "macaron_turtle", "Macaron Turtle", "Transcendent", 4E+07, 2.9E+50, 12000, 45000 },
    { "angel_shark", "Angel Shark", "Transcendent", 6.1E+07, 3.9E+50, 25000, 1E+05 },
    { "peppermint_spider_crab", "Peppermint Spider Crab", "Apex", 1E+08, 5.9E+50, 60000, 240000 },
    { "ribbon_candy_serpent", "Ribbon Candy Serpent", "Apex", 2.2E+08, 1.3E+51, 2E+05, 8E+05 },
    { "rock_candy_wyrm", "Rock Candy Wyrm", "Absolute", 6.1E+08, 3.9E+51, 7E+05, 2800000 },
    { "mosasaurus", "Mosasaurus", "Absolute", 1.8E+09, 1.6E+52, 6E+06, 2.5E+07 },
    { "sugarwarden", "Sugarwarden", "Arcane", 1.5E+11, 4.1E+54, 2E+08, 8E+08, 6 }
}

for v54, v55 in ipairs(t18) do
    table.insert(t1, {
        zone = "candy_cove",
        id = v55[1],
        name = v55[2],
        slot = v54,
        rarity = v55[3],
        odds = v55[4],
        income = v55[5],
        kg = {
            v55[6],
            v55[7]
        },
        endgame = v55[8]
    })
end

local t20 = {
    { "daruma_puffer", "Daruma Puffer", 400, 1600 },
    { "shogun_koi", "Shogun Koi", 900, 3600 },
    { "origami_ray", "Origami Ray", 2000, 8000 },
    { "raijin_catfish", "Raijin Catfish", 9000, 36000 },
    { "kitsune", "Nine-Tail Kitsune", 30000, 120000 },
    { "floating_shrine", "The Floating Shrine", 5E+06, 2E+07 }
}

for v56, v57 in ipairs(t20) do
    table.insert(t1, {
        zone = "spirit",
        rarity = "Spirit",
        income = 0,
        exclusive = true,
        id = v57[1],
        name = v57[2],
        slot = v56,
        odds = v56,
        kg = {
            v57[3],
            v57[4]
        }
    })
end

local t22 = {
    { "stardust_guppy", "Stardust Guppy", 300, 1200 },
    { "astro_axolotl", "Astro Axolotl", 1500, 6000 },
    { "saucer_flounder", "Saucer Flounder", 4000, 16000 },
    { "galaxy_angler", "Galaxy Angler", 25000, 1E+05 }
}

for v58, v59 in ipairs(t22) do
    table.insert(t1, {
        zone = "cosmic",
        rarity = "Astral",
        income = 0,
        exclusive = true,
        id = v59[1],
        name = v59[2],
        slot = v58,
        odds = v58,
        kg = {
            v59[3],
            v59[4]
        }
    })
end

local t24 = {
    { "turkey_trout", "Turkey Trout", 400, 1600 },
    { "cranberry_koi", "Cranberry Koi", 900, 3600 },
    { "stuffing_snapper", "Stuffing Snapper", 2000, 8000 },
    { "pumpkin_pike", "Pumpkin Pike", 9000, 36000 },
    { "gravy_grouper", "Gravy Grouper", 30000, 120000 },
    { "golden_gobbler", "Golden Gobbler", 5E+06, 2E+07 }
}

for v60, v61 in ipairs(t24) do
    table.insert(t1, {
        zone = "harvest",
        rarity = "Harvest",
        income = 0,
        exclusive = true,
        id = v61[1],
        name = v61[2],
        slot = v60,
        odds = v60,
        kg = {
            v61[3],
            v61[4]
        }
    })
end

local t26 = {
    { "butterball_blowfish", "Butterball Blowfish", 1200, 4800 },
    { "pumpkin_pufferfish", "Pumpkin Pufferfish", 6000, 24000 },
    { "cran_bass", "Cran-Bass", 40000, 160000 },
    { "golden_gobbler_marlin", "Golden Gobbler", 9E+06, 3.6E+07 }
}

for v62, v63 in ipairs(t26) do
    table.insert(t1, {
        zone = "ladder",
        rarity = "Harvest",
        income = 0,
        exclusive = true,
        id = v63[1],
        name = v63[2],
        slot = v62,
        odds = v62,
        kg = {
            v63[3],
            v63[4]
        }
    })
end

local t28 = {}
local t29 = {}

for v64, v65 in ipairs(t1) do
    v65.order = v64
    t28[v65.id] = v65
    t29[v65.zone] = t29[v65.zone] or {}
    table.insert(t29[v65.zone], v65)
end

for _, v67 in pairs(t29) do
    table.sort(v67, function(p4, p5) -- line: 241
        return p4.odds > p5.odds
    end)
end

return {
    List = t1,
    ById = t28,
    ByZone = t29
}
