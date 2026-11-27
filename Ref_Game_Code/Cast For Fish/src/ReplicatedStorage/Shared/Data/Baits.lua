-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local t1 = {
    {
        id = "worm",
        name = "Worm",
        rarity = "Common",
        tier = 1,
        price = 0,
        luck = 1
    },
    {
        id = "bread",
        name = "Bread Ball",
        rarity = "Common",
        tier = 1,
        price = 30,
        luck = 1.15
    },
    {
        id = "shrimp",
        name = "Shrimp",
        rarity = "Common",
        tier = 1,
        price = 150,
        luck = 1.3
    },
    {
        id = "cricket",
        name = "Cricket",
        rarity = "Uncommon",
        tier = 2,
        price = 1200,
        luck = 1.5
    },
    {
        id = "minnow_bait",
        name = "Live Minnow",
        rarity = "Uncommon",
        tier = 2,
        price = 9000,
        luck = 1.8
    },
    {
        id = "squid_strip",
        name = "Squid Strip",
        rarity = "Rare",
        tier = 3,
        price = 60000,
        luck = 2.2
    },
    {
        id = "crab_meat",
        name = "Crab Meat",
        rarity = "Rare",
        tier = 3,
        price = 450000,
        luck = 2.7
    },
    {
        id = "glow_grub",
        name = "Glow Grub",
        rarity = "Epic",
        tier = 4,
        price = 4E+06,
        luck = 3.3
    },
    {
        id = "golden_lure",
        name = "Golden Lure",
        rarity = "Legendary",
        tier = 5,
        price = 4E+07,
        luck = 4
    },
    {
        id = "mythic_roe",
        name = "Mythic Roe",
        rarity = "Mythic",
        tier = 6,
        price = 5E+08,
        luck = 5
    },
    {
        id = "void_leech",
        name = "Void Leech",
        rarity = "Secret",
        tier = 7,
        price = 8E+09,
        luck = 6.5
    },
    {
        id = "star_bait",
        name = "Star Bait",
        rarity = "Divine",
        tier = 8,
        price = 1.5E+11,
        luck = 8.5
    },
    {
        id = "sea_grape",
        name = "Sea Grape",
        rarity = "Celestial",
        tier = 9,
        price = 6.3E+11,
        luck = 9.3
    },
    {
        id = "leaf_wriggler",
        name = "Leaf Wriggler",
        rarity = "Celestial",
        tier = 10,
        price = 2.1E+12,
        luck = 10.1
    },
    {
        id = "kelp_knot",
        name = "Kelp Knot",
        rarity = "Celestial",
        tier = 11,
        price = 7.5E+12,
        luck = 11
    },
    {
        id = "mud_worm",
        name = "Mud Worm",
        rarity = "Celestial",
        tier = 12,
        price = 1.3E+14,
        luck = 11.9
    },
    {
        id = "lily_bud",
        name = "Lily Bud",
        rarity = "Celestial",
        tier = 13,
        price = 4.3E+14,
        luck = 12.9
    },
    {
        id = "swamp_firefly",
        name = "Swamp Firefly",
        rarity = "Celestial",
        tier = 14,
        price = 1.5E+15,
        luck = 14
    },
    {
        id = "snow_flea",
        name = "Snow Flea",
        rarity = "Eternal",
        tier = 15,
        price = 2.5E+16,
        luck = 15.2
    },
    {
        id = "frost_krill",
        name = "Frost Krill",
        rarity = "Eternal",
        tier = 16,
        price = 8.6E+16,
        luck = 16.6
    },
    {
        id = "ice_shrimp",
        name = "Ice Shrimp",
        rarity = "Eternal",
        tier = 17,
        price = 3E+17,
        luck = 18
    },
    {
        id = "clay_bead",
        name = "Clay Bead",
        rarity = "Eternal",
        tier = 18,
        price = 5E+18,
        luck = 19.5
    },
    {
        id = "bronze_ring",
        name = "Bronze Ring",
        rarity = "Eternal",
        tier = 19,
        price = 1.7E+19,
        luck = 21
    },
    {
        id = "ancient_coin",
        name = "Ancient Coin",
        rarity = "Eternal",
        tier = 20,
        price = 6E+19,
        luck = 23
    },
    {
        id = "ash_mite",
        name = "Ash Mite",
        rarity = "Cosmic",
        tier = 21,
        price = 1E+21,
        luck = 25
    },
    {
        id = "ember_worm",
        name = "Ember Worm",
        rarity = "Cosmic",
        tier = 22,
        price = 3.4E+21,
        luck = 27
    },
    {
        id = "magma_grub",
        name = "Magma Grub",
        rarity = "Cosmic",
        tier = 23,
        price = 1.2E+22,
        luck = 29
    },
    {
        id = "quartz_chip",
        name = "Quartz Chip",
        rarity = "Cosmic",
        tier = 24,
        price = 2E+23,
        luck = 31
    },
    {
        id = "geode_larva",
        name = "Geode Larva",
        rarity = "Cosmic",
        tier = 25,
        price = 6.9E+23,
        luck = 33
    },
    {
        id = "crystal_shard",
        name = "Crystal Shard",
        rarity = "Cosmic",
        tier = 26,
        price = 2.4E+24,
        luck = 36
    },
    {
        id = "rusty_nail",
        name = "Rusty Nail",
        rarity = "Supreme",
        tier = 27,
        price = 1.1E+26,
        luck = 39
    },
    {
        id = "rum_cork",
        name = "Rum Cork",
        rarity = "Supreme",
        tier = 28,
        price = 3.7E+26,
        luck = 42
    },
    {
        id = "cursed_doubloon",
        name = "Cursed Doubloon",
        rarity = "Supreme",
        tier = 29,
        price = 1.3E+27,
        luck = 45
    },
    {
        id = "shadow_worm",
        name = "Shadow Worm",
        rarity = "Supreme",
        tier = 30,
        price = 2.2E+28,
        luck = 48
    },
    {
        id = "abyss_pearl",
        name = "Abyss Pearl",
        rarity = "Supreme",
        tier = 31,
        price = 7.4E+28,
        luck = 52
    },
    {
        id = "void_eye",
        name = "Void Eye",
        rarity = "Supreme",
        tier = 32,
        price = 2.6E+29,
        luck = 56
    },
    {
        id = "rain_drop",
        name = "Rain Drop",
        rarity = "Sovereign",
        tier = 33,
        price = 4.3E+30,
        luck = 60
    },
    {
        id = "thunder_moth",
        name = "Thunder Moth",
        rarity = "Sovereign",
        tier = 34,
        price = 1.5E+31,
        luck = 65
    },
    {
        id = "storm_spark",
        name = "Storm Spark",
        rarity = "Sovereign",
        tier = 35,
        price = 5.1E+31,
        luck = 70
    },
    {
        id = "moon_crumb",
        name = "Moon Crumb",
        rarity = "Sovereign",
        tier = 36,
        price = 8.3E+32,
        luck = 76
    },
    {
        id = "comet_tail",
        name = "Comet Tail",
        rarity = "Sovereign",
        tier = 37,
        price = 2.9E+33,
        luck = 83
    },
    {
        id = "stardust",
        name = "Stardust",
        rarity = "Sovereign",
        tier = 38,
        price = 1E+34,
        luck = 90
    },
    {
        id = "slime_blob",
        name = "Slime Blob",
        rarity = "Ascended",
        tier = 39,
        price = 1.7E+35,
        luck = 97
    },
    {
        id = "acid_gnat",
        name = "Acid Gnat",
        rarity = "Ascended",
        tier = 40,
        price = 5.7E+35,
        luck = 104
    },
    {
        id = "toxic_slug",
        name = "Toxic Slug",
        rarity = "Ascended",
        tier = 41,
        price = 2E+36,
        luck = 112
    },
    {
        id = "tiny_gear",
        name = "Tiny Gear",
        rarity = "Ascended",
        tier = 42,
        price = 3.4E+37,
        luck = 121
    },
    {
        id = "brass_spring",
        name = "Brass Spring",
        rarity = "Ascended",
        tier = 43,
        price = 1.2E+38,
        luck = 130
    },
    {
        id = "windup_bug",
        name = "Wind-Up Bug",
        rarity = "Ascended",
        tier = 44,
        price = 4.1E+38,
        luck = 140
    },
    {
        id = "pixel_bit",
        name = "Pixel Bit",
        rarity = "Primordial",
        tier = 45,
        price = 6.8E+39,
        luck = 151
    },
    {
        id = "laser_worm",
        name = "Laser Worm",
        rarity = "Primordial",
        tier = 46,
        price = 2.3E+40,
        luck = 162
    },
    {
        id = "neon_chip",
        name = "Neon Chip",
        rarity = "Primordial",
        tier = 47,
        price = 8.2E+40,
        luck = 175
    },
    {
        id = "fern_sprout",
        name = "Fern Sprout",
        rarity = "Primordial",
        tier = 48,
        price = 1.3E+42,
        luck = 189
    },
    {
        id = "fossil_grub",
        name = "Fossil Grub",
        rarity = "Primordial",
        tier = 49,
        price = 4.6E+42,
        luck = 204
    },
    {
        id = "amber_fly",
        name = "Amber Fly",
        rarity = "Primordial",
        tier = 50,
        price = 1.6E+43,
        luck = 220
    },
    {
        id = "bad_dream",
        name = "Bad Dream",
        rarity = "Omega",
        tier = 51,
        price = 2.8E+44,
        luck = 237
    },
    {
        id = "creeping_eye",
        name = "Creeping Eye",
        rarity = "Omega",
        tier = 52,
        price = 9.4E+44,
        luck = 255
    },
    {
        id = "nightmare_tooth",
        name = "Nightmare Tooth",
        rarity = "Omega",
        tier = 53,
        price = 3.3E+45,
        luck = 275
    },
    {
        id = "lost_byte",
        name = "Lost Byte",
        rarity = "Transcendent",
        tier = 54,
        price = 5.5E+46,
        luck = 297
    },
    {
        id = "error_worm",
        name = "Error Worm",
        rarity = "Transcendent",
        tier = 55,
        price = 1.9E+47,
        luck = 320
    },
    {
        id = "glitch_cube",
        name = "Glitch Cube",
        rarity = "Transcendent",
        tier = 56,
        price = 6.6E+47,
        luck = 345
    },
    {
        id = "halo_crumb",
        name = "Halo Crumb",
        rarity = "Absolute",
        tier = 57,
        price = 1.1E+49,
        luck = 371
    },
    {
        id = "golden_nectar",
        name = "Golden Nectar",
        rarity = "Absolute",
        tier = 58,
        price = 3.7E+49,
        luck = 400
    },
    {
        id = "ambrosia",
        name = "Ambrosia",
        rarity = "Absolute",
        tier = 59,
        price = 1.3E+50,
        luck = 430
    }
}
local t2 = {}

for v1, v2 in ipairs(t1) do
    v2.order = v1
    t2[v2.id] = v2
end

local t3 = {
    {
        id = "feast_bait",
        name = "Feast Bait",
        rarity = "Harvest",
        exclusive = true,
        boost = 1.25,
        tier = 0,
        price = 0,
        luck = 1,
        source = "Thanksgiving Pack"
    }
}

for v3, v4 in ipairs(t3) do
    v4.order = -v3
    t2[v4.id] = v4
end

return {
    List = t1,
    ById = t2,
    Exclusive = t3,
    LuckOf = function(p1, p2) -- LuckOf | line: 98
        -- upvalues: t1 (copy), t2 (copy)
        local v5 = p1 and t2[p1]

        if not v5 then
            return t1[1].luck
        end

        if not v5.boost then
            return v5.luck
        end

        local luck = t1[1].luck

        for _, v6 in ipairs(t1) do
            if p2 and p2[v6.id] and luck < v6.luck then
                luck = v6.luck
            end
        end

        return luck * v5.boost
    end
}
