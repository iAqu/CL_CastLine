-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local t1 = {}

local function ink(p1, p2) -- line: 22
    return {
        rot = 90,
        stroke = p1,
        grad = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.new(1, 1, 1)),
            ColorSequenceKeypoint.new(0.4, Color3.new(1, 1, 1)),
            ColorSequenceKeypoint.new(1, p2)
        })
    }
end

t1.INK = {
    Blue = ink(Color3.fromRGB(5, 54, 94), Color3.fromRGB(205, 241, 255)),
    Green = ink(Color3.fromRGB(26, 70, 28), Color3.fromRGB(205, 255, 205)),
    Purple = ink(Color3.fromRGB(58, 12, 96), Color3.fromRGB(235, 210, 255)),
    Red = ink(Color3.fromRGB(95, 10, 20), Color3.fromRGB(255, 205, 205)),
    Orange = ink(Color3.fromRGB(110, 45, 0), Color3.fromRGB(255, 225, 185)),
    Pink = ink(Color3.fromRGB(105, 10, 60), Color3.fromRGB(255, 205, 235)),
    Black = ink(Color3.fromRGB(20, 20, 24), Color3.fromRGB(215, 215, 222)),
    Rainbow = {
        rot = 0,
        stroke = Color3.fromRGB(45, 20, 90),
        grad = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 200, 200)),
            ColorSequenceKeypoint.new(0.25, Color3.fromRGB(255, 240, 185)),
            ColorSequenceKeypoint.new(0.5, Color3.fromRGB(205, 255, 205)),
            ColorSequenceKeypoint.new(0.75, Color3.fromRGB(195, 230, 255)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(240, 205, 255))
        })
    }
}
t1.STARTER = {
    {
        product = 3716067772,
        xp = 5000,
        price = 9,
        was = 109,
        ink = "Blue",
        panel = { "rbxassetid://105874440205412", 8, 26, 1010, 339 },
        keys = {
            { "Gold", 5 },
            { "Stone", 5 }
        }
    },
    {
        product = 3716067798,
        xp = 40000,
        price = 24,
        was = 579,
        ink = "Green",
        panel = { "rbxassetid://108724446754717", 8, 26, 1010, 342 },
        keys = {
            { "Ruby", 10 },
            { "Gold", 5 }
        }
    },
    {
        product = 3716067816,
        xp = 1E+05,
        price = 79,
        was = 1159,
        ink = "Purple",
        panel = { "rbxassetid://70372185033487", 7, 25, 1011, 341 },
        keys = {
            { "Ruby", 20 },
            { "Gold", 10 }
        }
    },
    {
        product = 3716067857,
        xp = 2E+05,
        price = 195,
        was = 1849,
        ink = "Red",
        panel = { "rbxassetid://121381740299266", 7, 24, 1011, 341 },
        keys = {
            { "Diamond", 10 },
            { "Ruby", 15 }
        }
    },
    {
        product = 3716067890,
        xp = 4E+05,
        price = 495,
        was = 3929,
        ink = "Orange",
        panel = { "rbxassetid://129465379089416", 5, 22, 1014, 341 },
        keys = {
            { "Secret", 3 },
            { "Diamond", 20 },
            { "Ruby", 25 }
        }
    },
    {
        product = 3716103186,
        xp = 1E+06,
        price = 799,
        was = 5349,
        ink = "Pink",
        panel = { "rbxassetid://128907275477899", 7, 24, 1013, 342 },
        keys = {
            { "Secret", 15 },
            { "Diamond", 20 },
            { "Ruby", 15 }
        }
    },
    {
        product = 3716103560,
        xp = 2E+06,
        price = 1245,
        was = 7989,
        ink = "Black",
        panel = { "rbxassetid://81955356954703", 8, 26, 1007, 341 },
        keys = {
            { "Secret", 30 },
            { "Diamond", 20 },
            { "Ruby", 20 }
        }
    }
}

function t1.Starter(p3) -- line: 47
    -- upvalues: t1 (copy)
    local v1 = t1.STARTER[p3]

    return if v1 and v1.xp then v1 else nil
end

t1.PASSES = {
    {
        key = "VIP",
        card = "VIPBanner",
        pass = 2006000582,
        gift = 3716175603,
        title = "VIP",
        price = 299,
        retired = true,
        perks = {
            cash = 1.5,
            bag = 5,
            grow = 0.8,
            tag = true
        }
    },
    {
        key = "Grow2x",
        card = "Grow2x",
        pass = 2005196559,
        gift = 3716175616,
        title = "-50% GROW TIME",
        price = 499,
        perks = {
            grow = 0.5
        }
    },
    {
        key = "Cash2x",
        card = "Cash2x",
        pass = 2006630611,
        gift = 3716175633,
        title = "2X CASH",
        price = 349,
        perks = {
            cash = 2
        }
    },
    {
        key = "Luck2x",
        card = "Luck2x",
        pass = 2005772603,
        gift = 3716175645,
        title = "2X LUCK",
        price = 299,
        perks = {
            luck = 2
        }
    },
    {
        key = "XP2x",
        card = "XP2x",
        pass = 2006606595,
        gift = 3716175656,
        title = "2X XP",
        price = 79,
        retired = true,
        perks = {
            xp = 2
        }
    },
    {
        key = "Bag2x",
        card = "Bag2x",
        pass = 2007626598,
        gift = 3716175665,
        title = "+10 BAG",
        price = 149,
        perks = {
            bag = 10
        }
    },
    {
        key = "Fat2x",
        card = "FatDouble",
        pass = 2034398282,
        gift = 3718295196,
        title = "2X FAT",
        price = 249,
        perks = {
            fat = 2
        }
    },
    {
        key = "Heart",
        card = "Heart",
        pass = 2036199877,
        gift = 3719580268,
        title = "EXTRA HEART",
        price = 449,
        perks = {
            hearts = 1
        }
    },
    {
        key = "Feed2x",
        card = "Feed2x",
        pass = 2039883702,
        gift = 3719585228,
        title = "X2 FEED VALUE",
        price = 299,
        perks = {
            feed = 2
        }
    }
}
t1.KEYS = {
    {
        key = "Wood",
        card = "Key_Wood",
        product = 3716068665,
        count = 5,
        price = 9
    },
    {
        key = "Stone",
        card = "Key_Stone",
        product = 3716068739,
        count = 5,
        price = 29
    },
    {
        key = "Gold",
        card = "Key_Gold",
        product = 3716068777,
        count = 5,
        price = 79
    },
    {
        key = "Ruby",
        card = "Key_Ruby",
        product = 3716068814,
        count = 5,
        price = 249
    },
    {
        key = "Diamond",
        card = "Key_Diamond",
        product = 3716068852,
        count = 5,
        price = 549
    },
    {
        key = "Secret",
        card = "Key_Secret",
        product = 3716068883,
        count = 5,
        price = 799
    }
}
t1.TOKENS = {
    {
        card = "Token_1",
        tokens = 50,
        product = 3732471715,
        price = 29
    },
    {
        card = "Token_2",
        tokens = 150,
        product = 3732471724,
        price = 79
    },
    {
        card = "Token_3",
        tokens = 400,
        product = 3732471730,
        price = 199
    },
    {
        card = "Token_4",
        tokens = 1000,
        product = 3732471734,
        price = 449
    },
    {
        card = "Token_5",
        tokens = 2500,
        product = 3732471741,
        price = 999
    },
    {
        card = "Token_6",
        tokens = 6000,
        product = 3732471746,
        price = 1999
    }
}
t1.TOKEN_ICON = "rbxassetid://73921713030923"
t1.CRATES = {
    {
        crate = "Wood",
        product = 3716078980,
        price = 3
    },
    {
        crate = "Stone",
        product = 3716079042,
        price = 9
    },
    {
        crate = "Gold",
        product = 3716079101,
        price = 24
    },
    {
        crate = "Ruby",
        product = 3716079159,
        price = 79
    },
    {
        crate = "Diamond",
        product = 3716079241,
        price = 145
    },
    {
        crate = "Secret",
        product = 3716079346,
        price = 245
    }
}
t1.FAT_LADDER = {
    {
        mult = 2,
        label = "x2",
        price = 3,
        product = 3716099632
    },
    {
        mult = 4,
        label = "x4",
        price = 9,
        product = 3716100100
    },
    {
        mult = 8,
        label = "x8",
        price = 24,
        product = 3716100146
    },
    {
        mult = 16,
        label = "x16",
        price = 39,
        product = 3716100337
    },
    {
        mult = 32,
        label = "x32",
        price = 79,
        product = 3716100394
    },
    {
        mult = 64,
        label = "x64",
        price = 99,
        product = 3716100493
    },
    {
        mult = 128,
        label = "x128",
        price = 199,
        product = 3716100544
    },
    {
        mult = 256,
        label = "x256",
        price = 299,
        product = 3716100700
    },
    {
        mult = 512,
        label = "x512",
        price = 499,
        product = 3716100832
    },
    {
        mult = 1000,
        label = "x1K",
        price = 649,
        product = 3716100944
    },
    {
        mult = 2000,
        label = "x2K",
        price = 949,
        product = 3716101012
    },
    {
        mult = 4000,
        label = "x4K",
        price = 1375,
        product = 3716101048
    }
}

function t1.FatRung(p4) -- line: 152
    -- upvalues: t1 (copy)
    local n1 = 0

    for v2, v3 in ipairs(t1.FAT_LADDER) do
        if v3.mult <= (p4 or 1) then
            n1 = v2
        end
    end

    return n1, t1.FAT_LADDER[n1 + 1]
end

function t1.FatLabel(p5) -- line: 158
    -- upvalues: t1 (copy)
    local v4 = t1.FatRung(p5)

    return v4 > 0 and t1.FAT_LADDER[v4].label or "x1"
end

t1.FAT_TIME = {
    {
        card = "Fat_1",
        secs = 180,
        label = "3min",
        product = 3716108183,
        price = 9
    },
    {
        card = "Fat_2",
        secs = 900,
        label = "15min",
        product = 3716108254,
        price = 29
    },
    {
        card = "Fat_3",
        secs = 3600,
        label = "1h",
        product = 3716108452,
        price = 99
    },
    {
        card = "Fat_4",
        secs = 10800,
        label = "3h",
        product = 3716108486,
        price = 249
    },
    {
        card = "Fat_5",
        secs = 28800,
        label = "8h",
        product = 3716108512,
        price = 499
    },
    {
        card = "Fat_6",
        secs = 86400,
        label = "24h",
        product = 3716108530,
        price = 999
    },
    {
        card = "Fat_7",
        secs = 259200,
        label = "3d",
        product = 3719598098,
        price = 1499,
        big = true
    },
    {
        card = "Fat_8",
        secs = 864000,
        label = "10d",
        product = 3719598119,
        price = 2999,
        big = true
    }
}
t1.CASH_TIME = {
    {
        card = "Cash_1",
        secs = 300,
        label = "5min",
        product = 3716108562,
        price = 9
    },
    {
        card = "Cash_2",
        secs = 1800,
        label = "30min",
        product = 3716108580,
        price = 29
    },
    {
        card = "Cash_3",
        secs = 3600,
        label = "1h",
        product = 3716108594,
        price = 49
    },
    {
        card = "Cash_4",
        secs = 28800,
        label = "8h",
        product = 3716108617,
        price = 249
    },
    {
        card = "Cash_5",
        secs = 86400,
        label = "24h",
        product = 3716108630,
        price = 499
    },
    {
        card = "Cash_6",
        secs = 259200,
        label = "3d",
        product = 3716108658,
        price = 999
    }
}

local TableConfig = require(script.Parent:WaitForChild("TableConfig"))

function t1.FatFor(p6, p7, p8) -- line: 194
    -- upvalues: TableConfig (copy)
    return (math.floor(TableConfig.FatPerBite(p7) * (p8 or 1) * TableConfig.BITES_PER_SECOND * p6.secs))
end

function t1.CashFor(p9, p10) -- line: 198
    return (math.floor((p10 or 0) * p9.secs))
end

t1.ZONE_RUSH = {
    mult = 1.5,
    show = 10,
    into = 0.29,
    floor = {
        [2] = 39,
        [3] = 79,
        [4] = 199,
        [5] = 499,
        [6] = 949,
        [7] = 1375,
        [9] = 1375,
        [10] = 1375
    },
    rarities = {
        Mythic = true,
        Exotic = true,
        Secret = true,
        Celestial = true,
        Apex = true
    },
    jurassicRarities = {
        Exotic = true,
        Secret = true,
        Celestial = true,
        Apex = true
    },
    tiers = {
        {
            product = 3718791621,
            price = 39
        },
        {
            product = 3718791623,
            price = 79
        },
        {
            product = 3718791626,
            price = 129
        },
        {
            product = 3718791627,
            price = 199
        },
        {
            product = 3718791630,
            price = 299
        },
        {
            product = 3718791631,
            price = 499
        },
        {
            product = 3718791633,
            price = 649
        },
        {
            product = 3718791635,
            price = 949
        },
        {
            product = 3718791637,
            price = 1375
        }
    }
}

local function packCurve(p11) -- line: 239
    -- upvalues: t1 (copy)
    local t2 = {}

    for _, v7 in ipairs(t1.FAT_TIME) do
        if not v7.big then
            t2[#t2 + 1] = v7
        end
    end

    if p11 <= t2[1].secs then
        return t2[1].price * p11 / t2[1].secs
    end

    for i = 1, #t2 - 1 do
        local v8 = t2[i]
        local v9 = t2[i + 1]

        if p11 <= v9.secs then
            local v13 = math.log(p11 / v8.secs) / math.log(v9.secs / v8.secs)

            return (math.exp(math.log(v8.price) + v13 * (math.log(v9.price) - math.log(v8.price))))
        end
    end

    local v17 = t2[#t2]

    return v17.price * p11 / v17.secs
end

function t1.ZoneRushTier(p12, p13, p14, p15) -- line: 256
    -- upvalues: t1 (copy), TableConfig (copy), packCurve (copy)
    local ZONE_RUSH = t1.ZONE_RUSH
    local v18 = TableConfig.FatPerBite(p13 or 1) * (p14 or 1) * TableConfig.BITES_PER_SECOND
    local v21 = math.max(ZONE_RUSH.floor[p15] or 0, packCurve(p12 / math.max(v18, 1E-06)) * ZONE_RUSH.mult)

    for v22, v23 in ipairs(ZONE_RUSH.tiers) do
        if v21 <= v23.price then
            return v23, v22
        end
    end

    return ZONE_RUSH.tiers[#ZONE_RUSH.tiers], #ZONE_RUSH.tiers
end

t1.CAP = {
    Common = {
        product = 3716119932,
        price = 79
    },
    Uncommon = {
        product = 3716120038,
        price = 149
    },
    Rare = {
        product = 3716120095,
        price = 199
    },
    Epic = {
        product = 3716120177,
        price = 249
    },
    Legendary = {
        product = 3716120259,
        price = 299
    },
    Mythic = {
        product = 3716120338,
        price = 349
    },
    Exotic = {
        product = 3716120418,
        price = 399
    },
    Secret = {
        product = 3716120500,
        price = 449
    },
    Unknown = {
        product = 3717069957,
        price = 499
    },
    Celestial = {
        product = 3720141377,
        price = 549
    },
    Apex = {
        product = 3729857038,
        price = 649
    },
    Exclusive = {
        product = 3716121306,
        price = 499
    }
}
t1.TABLES = {
    [2] = {
        product = 3716130990,
        price = 3
    },
    [3] = {
        product = 3716131001,
        price = 9
    },
    [4] = {
        product = 3716131018,
        price = 19
    },
    [5] = {
        product = 3716131034,
        price = 39
    },
    [6] = {
        product = 3716131043,
        price = 69
    },
    [7] = {
        product = 3716131060,
        price = 99
    },
    [8] = {
        product = 3716131074,
        price = 149
    },
    [9] = {
        product = 3716131089,
        price = 199
    },
    [10] = {
        product = 3716131104,
        price = 299
    },
    [11] = {
        product = 3718300416,
        price = 449
    },
    [12] = {
        product = 3718300422,
        price = 649
    },
    [13] = {
        product = 3718300427,
        price = 899
    },
    [14] = {
        product = 3718300431,
        price = 1199
    },
    [15] = {
        product = 3718300438,
        price = 1599
    },
    [16] = {
        product = 3727439869,
        price = 1999
    },
    [17] = {
        product = 3727439907,
        price = 2499
    },
    [18] = {
        product = 3727439953,
        price = 2999
    }
}
t1.AQUARIUM = {
    [2] = {
        product = 3716133181,
        price = 19
    },
    [3] = {
        product = 3716133193,
        price = 39
    },
    [4] = {
        product = 3716133204,
        price = 69
    },
    [5] = {
        product = 3716133217,
        price = 119
    },
    [6] = {
        product = 3716133232,
        price = 199
    },
    [7] = {
        product = 3716133245,
        price = 299
    },
    [8] = {
        product = 3716133254,
        price = 499
    },
    [9] = {
        product = 3716133279,
        price = 799
    },
    [10] = {
        product = 3716133286,
        price = 1299
    },
    [11] = {
        product = 3716133298,
        price = 1999
    }
}
t1.SKIP = {
    {
        secs = 300,
        product = 3716128508,
        price = 9
    },
    {
        secs = 900,
        product = 3716128544,
        price = 19
    },
    {
        secs = 1800,
        product = 3716128566,
        price = 39
    },
    {
        secs = 3600,
        product = 3716128591,
        price = 49
    },
    {
        secs = 10800,
        product = 3716128633,
        price = 79
    },
    {
        secs = 21600,
        product = 3716128658,
        price = 99
    },
    {
        secs = 43200,
        product = 3716128681,
        price = 149
    },
    {
        secs = 86400,
        product = 3716128710,
        price = 199
    },
    {
        secs = 259200,
        product = 3716128751,
        price = 299
    },
    {
        secs = 604800,
        product = 3716128793,
        price = 499
    }
}
t1.ORO_SKIP = {
    {
        secs = 86400,
        product = 3719235651,
        price = 399,
        inf = true
    },
    {
        secs = 259200,
        product = 3719235662,
        price = 699,
        inf = true
    },
    {
        secs = 604800,
        product = 3719235678,
        price = 999,
        inf = true
    }
}

function t1.SkipTier(p16, p17) -- line: 365
    -- upvalues: t1 (copy)
    for v24, v25 in ipairs(p17 and t1.ORO_SKIP or t1.SKIP) do
        if p16 <= v25.secs then
            return v24, v25
        end
    end

    return nil
end

t1.OFFLINE_X10 = {
    {
        secs = 900,
        product = 3716217846,
        price = 79
    },
    {
        secs = 1800,
        product = 3716217850,
        price = 79
    },
    {
        secs = 3600,
        product = 3716217854,
        price = 79
    },
    {
        secs = 7200,
        product = 3716217864,
        price = 79
    },
    {
        secs = 14400,
        product = 3716217876,
        price = 79
    },
    {
        secs = 28800,
        product = 3716217884,
        price = 79
    },
    {
        secs = 43200,
        product = 3716217889,
        price = 79
    },
    {
        secs = 86400,
        product = 3716217898,
        price = 79
    },
    {
        secs = 172800,
        product = 3716217909,
        price = 79
    },
    {
        secs = 259200,
        product = 3716217922,
        price = 79
    },
    {
        secs = 1e999,
        product = 3716217935,
        price = 79
    }
}

function t1.OfflineTier(p18) -- line: 391
    -- upvalues: t1 (copy)
    for v26, v27 in ipairs(t1.OFFLINE_X10) do
        if p18 <= v27.secs then
            return v26, v27
        end
    end

    return #t1.OFFLINE_X10, t1.OFFLINE_X10[#t1.OFFLINE_X10]
end

t1.SERVER_LUCK = {
    card = "ServerLuck",
    product = 3716179612,
    secs = 1200,
    price = 299
}
t1.ZEUS = {
    key = "ZeusBolt",
    card = "ZeusBolt",
    harpoon = "ZeusBolt",
    title = "Zeus's Lightning Bolt",
    product = 3716310568,
    price = 2499,
    was = 1499,
    stock = 777,
    equipQuip = "Instant Catch and +75% Mutation Chance!",
    perks = {
        luck = 1.75,
        instant = true
    }
}
t1.GHOST_MEG = {
    key = "GhostMegalodon",
    card = "GhostMegalodon",
    fish = "GhostMegalodon",
    title = "Ghost Megalodon",
    product = 3718281440,
    price = 549,
    stock = 300,
    stage = 4,
    word = "EXCLUSIVE",
    image = "rbxassetid://95986407466942",
    owners = true
}
t1.GHOST_MEG.maxKg = 3.52E+08
t1.OWNERS_ONLY = {
    {
        key = "Rainbowborous",
        fish = "Rainbowborous",
        owners = true
    },
    {
        key = "IdeaFish",
        fish = "IdeaFish",
        owners = true,
        give = {
            [7280175027] = true,
            [98694561] = true,
            [8010728992] = true
        }
    }
}
t1.DEVILSHARK = {
    key = "Devilshark",
    card = "Devilshark",
    fish = "Devilshark",
    title = "Devilshark",
    product = 3719174130,
    price = 99,
    stock = 2500,
    stage = 1,
    rate = 30000,
    word = "EXCLUSIVE",
    image = "rbxassetid://116053600024645"
}
t1.DEVILSHARK.maxKg = 6.4E+07
t1.DEVILSHARK.ends = 1793466000
t1.DEVILSHARK.ends = nil

local DEVILSHARK, DEVILSHARK2 = t1.DEVILSHARK, t1.DEVILSHARK

DEVILSHARK.rotation = true
DEVILSHARK2.repeatable = true
t1.ICICLE = {
    key = "Icicle",
    card = "Icicle",
    harpoon = "Icicle",
    title = "Icicle",
    product = 3718629977,
    price = 449,
    stock = 1E+09,
    unlimited = true,
    retired = true,
    equipQuip = "50% Slower Minigame and +50% Mutation Chance!",
    perks = {
        luck = 1.5,
        reel = 0.5
    }
}
t1.OWNER = {
    key = "OwnersHarpoon",
    card = "OwnersHarpoon",
    harpoon = "OwnersHarpoon",
    title = "Owner's Harpoon",
    product = 3719157059,
    price = 799,
    stock = 1000,
    ends = 1792861200,
    retired = true,
    equipQuip = "-2 Hits and +65% Mutation Chance!",
    perks = {
        luck = 1.65,
        hits = 2
    }
}
t1.TEALEAF = {
    key = "Tealeaf",
    card = "Tealeaf",
    harpoon = "Tealeaf",
    title = "Nature Harpoon",
    product = 3719184806,
    price = 99,
    stock = 1E+09,
    unlimited = true,
    harpoonRotation = true,
    equipQuip = "15% Slower Minigame and +30% Mutation Chance!",
    perks = {
        luck = 1.3,
        reel = 0.85
    }
}
t1.POOLNOODLE = {
    key = "PoolNoodle",
    card = "PoolNoodle",
    harpoon = "PoolNoodle",
    title = "Pool Noodle",
    product = 3721801444,
    price = 99,
    stock = 1E+09,
    unlimited = true,
    harpoonRotation = true
}
t1.KATANA = {
    key = "Katana",
    card = "Katana",
    harpoon = "Katana",
    title = "Katana",
    product = 3721801505,
    price = 599,
    stock = 1E+09,
    unlimited = true,
    harpoonRotation = true
}
t1.STICKYHAND = {
    key = "StickyHand",
    card = "StickyHand",
    harpoon = "StickyHand",
    title = "Sticky Hand",
    product = 3721801559,
    price = 599,
    stock = 1E+09,
    unlimited = true,
    harpoonRotation = true
}
t1.WITCHBROOM = {
    key = "WitchBroom",
    card = "WitchBroom",
    harpoon = "WitchBroom",
    title = "Witch's Broom",
    product = 3721801595,
    price = 1249,
    stock = 1E+09,
    unlimited = true,
    harpoonRotation = true
}
t1.PLASMASABER = {
    key = "PlasmaSaber",
    card = "PlasmaSaber",
    harpoon = "PlasmaSaber",
    title = "Plasma Saber",
    product = 3721801610,
    price = 1249,
    stock = 1E+09,
    unlimited = true,
    harpoonRotation = true
}
t1.DRUMSTICK = {
    key = "Drumstick",
    card = "Drumstick",
    harpoon = "Drumstick",
    title = "Dino Drumstick",
    product = 3729422404,
    price = 99,
    stock = 1E+09,
    unlimited = true,
    harpoonRotation = true
}
t1.METEORITESPEAR = {
    key = "MeteoriteSpear",
    card = "MeteoriteSpear",
    harpoon = "MeteoriteSpear",
    title = "Godly Meteorite Spear",
    product = 3729433836,
    price = 1249,
    stock = 1E+09,
    unlimited = true,
    harpoonRotation = true
}
t1.OROBORUS = {
    key = "Oroborus",
    card = "Oroborus",
    fish = "Oroborus",
    title = "Oroborus",
    product = 3719232216,
    price = 10000,
    stock = 1E+09,
    unlimited = true,
    stage = 1,
    rate = 2600000,
    word = "EXCLUSIVE",
    image = "rbxassetid://130237570057640",
    owners = true
}
t1.MIME = {
    key = "Mimefish",
    card = "Mimefish",
    fish = "Mimefish",
    title = "Mimefish",
    product = 3719603422,
    price = 499,
    stock = 1E+09,
    unlimited = true,
    plus = true,
    word = "EXCLUSIVE",
    image = "rbxassetid://80932932381159",
    rotation = true,
    repeatable = true
}
t1.HOTDOG = {
    key = "MrHotdog",
    card = "MrHotdog",
    fish = "MrHotdog",
    title = "Mr Hotdog",
    product = 3719625581,
    price = 649,
    stock = 1E+09,
    unlimited = true,
    stage = 1,
    rate = 350000,
    word = "EXCLUSIVE",
    image = "rbxassetid://100755929441297",
    rotation = true,
    repeatable = true
}
t1.JESTER = {
    key = "Jestershark",
    card = "Jestershark",
    fish = "Jestershark",
    title = "Jestershark",
    product = 3720422322,
    price = 799,
    stock = 1E+09,
    unlimited = true,
    plus = true,
    word = "EXCLUSIVE",
    image = "rbxassetid://111626850855271"
}
t1.WRAITH = {
    key = "Jesterwraith",
    card = "Jesterwraith",
    fish = "Jesterwraith",
    title = "Jesterwraith",
    product = 3720431689,
    price = 799,
    stock = 500,
    plus = true,
    word = "EXCLUSIVE",
    image = "rbxassetid://91760288448840",
    rotation = true,
    repeatable = true,
    plainProduct = 3721769446,
    plainPrice = 699
}
t1.MUMMY = {
    key = "MummifiedMosasaur",
    card = "MummifiedMosasaur",
    fish = "MummifiedMosasaur",
    title = "Mummified Mosasaur",
    product = 3721769458,
    price = 1349,
    stock = 250,
    plus = true,
    word = "EXCLUSIVE",
    image = "rbxassetid://80118881710186",
    rotation = true,
    repeatable = true,
    plainProduct = 3721769464,
    plainPrice = 1149
}
t1.BONED = {
    key = "BonedMosasaur",
    card = "BonedMosasaur",
    fish = "BonedMosasaur",
    title = "Boned Mosasaur",
    product = 3729119835,
    price = 799,
    stock = 200,
    plus = true,
    word = "EXCLUSIVE",
    image = "rbxassetid://90900252354287",
    rotation = true,
    repeatable = true,
    plainProduct = 3729119844,
    plainPrice = 699
}
t1.DREAD = {
    key = "Dreadsaber",
    card = "Dreadsaber",
    fish = "Dreadsaber",
    title = "Dreadsaber",
    product = 3729119856,
    price = 1349,
    stock = 150,
    plus = true,
    word = "EXCLUSIVE",
    image = "rbxassetid://71332454530237",
    rotation = true,
    repeatable = true,
    plainProduct = 3729119864,
    plainPrice = 1149
}
t1.MAW = {
    key = "AbominatedMaw",
    card = "AbominatedMaw",
    fish = "AbominatedMaw",
    title = "Abominated Maw",
    product = 3729119875,
    price = 399,
    stock = 200,
    plus = true,
    word = "EXCLUSIVE",
    image = "rbxassetid://119480128021384",
    rotation = true,
    repeatable = true,
    plainProduct = 3729119881,
    plainPrice = 299
}
t1.MAW.price = 449
t1.STRANGE = {
    key = "StrangewaterTylosaurus",
    card = "StrangewaterTylosaurus",
    fish = "StrangewaterTylosaurus",
    title = "Strangewater Tylosaurus",
    product = 3729119889,
    price = 299,
    stock = 1E+09,
    unlimited = true,
    stage = 1,
    rate = 7E+06,
    word = "EXCLUSIVE",
    image = "rbxassetid://100311657251813",
    rotation = true,
    repeatable = true
}
t1.STRANGE.price = 349
t1.HYDRAX = {
    key = "Hydrax",
    card = "Hydrax",
    fish = "Hydrax",
    title = "Hydrax",
    product = 3729129261,
    price = 1349,
    stock = 100,
    stage = 8,
    word = "EXCLUSIVE",
    image = "rbxassetid://77362605796391",
    rotation = true,
    repeatable = true,
    plainProduct = 3729129282,
    plainPrice = 1149
}
t1.TRICERO = {
    key = "Tricerosaurus",
    card = "Tricerosaurus",
    fish = "Tricerosaurus",
    title = "Tricerosaurus",
    product = 3729129296,
    price = 799,
    stock = 100,
    stage = 8,
    word = "EXCLUSIVE",
    image = "rbxassetid://112329012410950",
    rotation = true,
    repeatable = true,
    plainProduct = 3729129306,
    plainPrice = 699
}
t1.FOSSIL = {
    key = "Fossilshark",
    card = "Fossilshark",
    fish = "Fossilshark",
    title = "Fossilshark",
    product = 3729129333,
    price = 399,
    stock = 100,
    plus = true,
    word = "EXCLUSIVE",
    image = "rbxassetid://101744739142894",
    rotation = true,
    repeatable = true,
    plainProduct = 3729129343,
    plainPrice = 299
}
t1.WISHBONE = {
    key = "WishboneWyrm",
    card = "WishboneWyrm",
    fish = "WishboneWyrm",
    title = "Wishbone Wyrm",
    product = 3734019408,
    price = 1350,
    stock = 300,
    stage = 8,
    word = "EXCLUSIVE",
    image = "rbxassetid://134824918232100",
    rotation = true,
    repeatable = true,
    plainProduct = 3734019421,
    plainPrice = 1149
}
t1.PECAN = {
    key = "PecanPike",
    card = "PecanPike",
    fish = "PecanPike",
    title = "Pecan Pike",
    product = 3734019430,
    price = 499,
    stock = 600,
    plus = true,
    word = "EXCLUSIVE",
    image = "rbxassetid://130646450387687",
    rotation = true,
    repeatable = true,
    plainProduct = 3734019438,
    plainPrice = 399
}
t1.TURKEYGUPPY = {
    key = "TurkeyGuppy",
    card = "TurkeyGuppy",
    fish = "TurkeyGuppy",
    title = "Turkey Guppy",
    product = 3734204387,
    price = 349,
    stock = 1000,
    stage = 1,
    rate = 1E+07,
    word = "EXCLUSIVE",
    image = "rbxassetid://74537744822388",
    rotation = true,
    repeatable = true,
    isSerial = true
}

function t1.OnSale(p19, p20) -- line: 679
    -- upvalues: t1 (copy)
    if p19.rotation then
        return t1.Phase(p19, p20) ~= nil
    end

    if p19.harpoonRotation then
        return t1.HarpoonOnSale(p19, p20)
    end

    if p19.retired then
        return false
    end

    return not p19.ends or (p20 or workspace:GetServerTimeNow()) < p19.ends
end

t1.LIMITED = {
    t1.ZEUS,
    t1.GHOST_MEG,
    t1.ICICLE,
    t1.OWNER,
    t1.DEVILSHARK,
    t1.TEALEAF,
    t1.OROBORUS,
    t1.MIME,
    t1.HOTDOG,
    t1.JESTER,
    t1.WRAITH,
    t1.MUMMY,
    t1.POOLNOODLE,
    t1.KATANA,
    t1.STICKYHAND,
    t1.WITCHBROOM,
    t1.PLASMASABER,
    t1.MAW,
    t1.BONED,
    t1.DREAD,
    t1.STRANGE,
    t1.FOSSIL,
    t1.TRICERO,
    t1.HYDRAX,
    t1.DRUMSTICK,
    t1.METEORITESPEAR,
    t1.TURKEYGUPPY,
    t1.PECAN,
    t1.WISHBONE
}

function t1.LimitedAttr(p21) -- line: 698
    return "Limited" .. p21
end

t1.LAST_CHANCE = 50

function t1.Capacity(p22) -- line: 704
    -- upvalues: t1 (copy)
    if p22.rotation and (p22.plainProduct or p22.isSerial) then
        return p22.stock + t1.LAST_CHANCE
    end

    return p22.stock
end

t1.ROTATION = {
    start = 1792864800,
    WEEK = 604800,
    SLOTS = 3,
    serial = {
        {
            key = "Jesterwraith",
            week = 0
        },
        {
            key = "MummifiedMosasaur",
            week = 0
        },
        {
            key = "BonedMosasaur",
            week = 2
        },
        {
            key = "Dreadsaber",
            week = 2
        },
        {
            key = "AbominatedMaw",
            week = 2
        },
        {
            key = "Hydrax",
            week = 3
        },
        {
            key = "Tricerosaurus",
            week = 3
        },
        {
            key = "Fossilshark",
            week = 3
        },
        {
            key = "WishboneWyrm",
            week = 4,
            weeks = 2
        },
        {
            key = "PecanPike",
            week = 4,
            weeks = 2
        },
        {
            key = "TurkeyGuppy",
            week = 4,
            weeks = 2
        }
    },
    pool = { "Devilshark", "Mimefish", "MrHotdog", "StrangewaterTylosaurus" },
    joins = {
        StrangewaterTylosaurus = 2
    }
}

function t1.Week(p23) -- line: 749
    -- upvalues: t1 (copy)
    local ROTATION = t1.ROTATION
    local v29 = math.floor(tonumber(workspace:GetAttribute("ShopWeekShift")) or 0)
    local v32 = math.max(0, (math.floor(((p23 or workspace:GetServerTimeNow()) - ROTATION.start) / ROTATION.WEEK)))

    if v32 + v29 < 0 then
        return nil
    end

    return v32 + v29, ROTATION.start + (v32 + 1) * ROTATION.WEEK
end

function t1.RegularOf(p24) -- line: 760
    -- upvalues: t1 (copy)
    local ROTATION = t1.ROTATION
    local t3 = {}

    for _, v33 in ipairs(ROTATION.pool) do
        if (ROTATION.joins and ROTATION.joins[v33] or 0) <= p24 then
            t3[#t3 + 1] = v33
        end
    end

    if #t3 <= ROTATION.SLOTS then
        return t3
    end

    local t4 = {}
    local v34 = p24 * ROTATION.SLOTS % #t3

    for i = 0, ROTATION.SLOTS - 1 do
        t4[#t4 + 1] = t3[(v34 + i) % #t3 + 1]
    end

    return t4
end

function t1.Phase(p25, p26) -- line: 773
    -- upvalues: t1 (copy)
    local v35, v36 = t1.Week(p26)

    if not v35 then
        return nil
    end

    for _, v37 in ipairs(t1.ROTATION.serial) do
        local v38 = v37.week + (v37.weeks or 1) - 1

        if v37.key == p25.key and v37.week <= v35 and v35 <= v38 then
            return "serial", v36 + (v38 - v35) * t1.ROTATION.WEEK
        end
    end

    if table.find(t1.RegularOf(v35), p25.key) then
        return "pool", v36
    end

    return nil, v36
end

t1.HARPOON_ROTATION = {
    { "Drumstick", "Tealeaf" },
    { "Katana", "StickyHand" },
    { "MeteoriteSpear", "PlasmaSaber" }
}

function t1.HarpoonsOf(p27) -- line: 801
    -- upvalues: t1 (copy)
    if not p27 then
        return {}
    end

    local t5 = {}

    for _, v39 in ipairs(t1.HARPOON_ROTATION) do
        t5[#t5 + 1] = v39[p27 % #v39 + 1]
    end

    return t5
end

function t1.HarpoonOnSale(p28, p29) -- line: 807
    -- upvalues: t1 (copy)
    return table.find(t1.HarpoonsOf((t1.Week(p29))), p28.key) ~= nil
end

function t1.ProductNow(p30, p31) -- line: 812
    -- upvalues: t1 (copy)
    if not p30.plainProduct or t1.Phase(p30, p31) == "serial" then
        return p30.product, p30.price
    end

    return p30.plainProduct, p30.plainPrice
end

t1.FREE = {
    {
        key = "Wood",
        count = 5
    },
    {
        key = "Gold",
        count = 1
    }
}
t1.HYDRA = {
    product = 3717476263,
    price = 9,
    was = 299,
    fish = "GreenlandHydra",
    stage = 6,
    title = "Greenland Hydra"
}
t1.HYDRA_UPS = {
    {
        product = 3717485503,
        price = 79,
        was = 799,
        mutation = "Molten",
        word = "MOLTEN",
        image = "rbxassetid://137468056894130",
        title = "Molten Greenland Hydra"
    },
    {
        product = 3717486323,
        price = 249,
        was = 1499,
        mutation = "Shadow",
        word = "SHADOW",
        image = "rbxassetid://120290970325285",
        title = "Shadow Greenland Hydra"
    }
}
t1.POTION_PACK = {
    {
        product = 3719187550,
        price = 79,
        count = 3
    }
}
t1.POTION_PACK_POTIONS = { "T2", "B3" }

function t1.PotionPackNext(_) -- line: 857
    -- upvalues: t1 (copy)
    return t1.POTION_PACK[1], 1
end

t1.BONE_PACK = {
    {
        product = 3719452161,
        price = 39,
        title = "Bone Starter Pack",
        fish = "DeathGuppy",
        stage = 1,
        rate = 10000,
        harpoon = "BoneHarpoon",
        xp = 10000
    },
    {
        product = 3719452178,
        price = 79,
        title = "Bone Starter Pack 2",
        mutation = "Rainbow",
        mult = 32,
        harpoon = "Boneknife",
        from = "BoneHarpoon",
        xp = 30000,
        image = "rbxassetid://119165572603620"
    },
    {
        product = 3719452199,
        price = 349,
        title = "Bone Starter Pack 3",
        harpoon = "DeathScythe",
        from = "Boneknife",
        xp = 60000,
        equipQuip = "+50% Mutation Chance and 33% Extra Life Chance!",
        perks = {
            luck = 1.5,
            life = 0.33
        }
    }
}
t1.BONE_PACK[2].fish = t1.BONE_PACK[1].fish

function t1.BonePackNext(p33) -- line: 896
    -- upvalues: t1 (copy)
    local v40 = (p33 or 0) + 1

    return t1.BONE_PACK[v40], v40
end

t1.ULTIMATE = {
    product = 3718662360,
    price = 249,
    was = 799,
    title = "Ultimate Bundle",
    cash = 2.5E+07,
    cashSecs = 900,
    fatSecs = 1800,
    floaty = "Unicorn",
    image = "rbxassetid://82153343893566",
    key = "Secret",
    keys = 1,
    xp = 20000,
    passes = { "VIP", "XP2x" }
}

function t1.UltimateCash(p34) -- line: 920
    -- upvalues: t1 (copy)
    return (math.max(t1.ULTIMATE.cash, (math.floor((p34 or 0) * t1.ULTIMATE.cashSecs))))
end

function t1.UltimateFat(p35, p36) -- line: 925
    -- upvalues: t1 (copy)
    return t1.FatFor({
        secs = t1.ULTIMATE.fatSecs
    }, p35, p36)
end

t1.HYDRA.image = "rbxassetid://79995788231246"
t1.HYDRA.word = "EXCLUSIVE"

for _, v43 in ipairs(t1.HYDRA_UPS) do
    v43.fish = t1.HYDRA.fish
end

function t1.HydraNext(p37, p38) -- line: 932
    -- upvalues: t1 (copy)
    if not p37 then
        return t1.HYDRA, 0
    end

    local v44 = (p38 or 0) + 1

    return t1.HYDRA_UPS[v44], v44
end

t1.HYDRA_OFFER_SECS = 172800

function t1.HydraExpired(p39, p40) -- line: 944
    if type(p39) == "number" then
        return p39 <= p40
    end

    return false
end

t1.HELL_EGG = {
    {
        product = 3717498340,
        price = 3499,
        count = 50,
        was = 5959,
        button = "Buy50"
    },
    {
        product = 3717498260,
        price = 799,
        count = 10,
        button = "Buy10"
    },
    {
        product = 3717498187,
        price = 249,
        count = 3,
        button = "Buy3"
    },
    {
        product = 3717498136,
        price = 99,
        count = 1,
        button = "Buy1"
    }
}
t1.HELL_EGG_FISH = {
    {
        fish = "HellfireAngler",
        odds = 24,
        rate = 19100
    },
    {
        fish = "HellfireStingray",
        odds = 22.5,
        rate = 20600
    },
    {
        fish = "HellfireLionfish",
        odds = 20,
        rate = 30200
    },
    {
        fish = "HellfireMarlin",
        odds = 17.5,
        rate = 31500
    },
    {
        fish = "BucktoothedDemocrocodon",
        odds = 10,
        rate = 34300
    },
    {
        fish = "Hellshark",
        odds = 5,
        rate = 54900
    },
    {
        fish = "HellHydra",
        odds = 1,
        rate = 4E+06
    }
}
t1.VOID_EGG_ENDS = 1793466000
t1.VOID_EGG = {
    {
        product = 3718523421,
        price = 1799,
        count = 10,
        was = 2990,
        button = "Buy10"
    },
    {
        product = 3718523415,
        price = 649,
        count = 3,
        was = 897,
        button = "Buy3"
    },
    {
        product = 3718523411,
        price = 299,
        count = 1,
        button = "Buy1"
    },
    {
        product = 3718523428,
        price = 7999,
        count = 50,
        was = 14950,
        button = "Buy50"
    }
}
t1.VOID_EGG_FISH = {
    {
        fish = "VoidsparkAngelfish",
        odds = 60,
        rate = 43200
    },
    {
        fish = "VoidsparkAngler",
        odds = 28,
        rate = 66300
    },
    {
        fish = "VoidsparkSwordfish",
        odds = 10,
        rate = 95700
    },
    {
        fish = "Jawspark",
        odds = 1.5,
        rate = 1.5E+07
    },
    {
        fish = "Dreadspark",
        odds = 0.5,
        rate = 3E+07
    }
}
t1.AURORA_EGG_ENDS = 1795888800
t1.AURORA_EGG = {
    {
        product = 3731013856,
        price = 7999,
        count = 50,
        was = 14950,
        button = "Buy50"
    },
    {
        product = 3731013840,
        price = 1799,
        count = 10,
        was = 2990,
        button = "Buy10"
    },
    {
        product = 3731013822,
        price = 649,
        count = 3,
        was = 897,
        button = "Buy3"
    },
    {
        product = 3731013808,
        price = 299,
        count = 1,
        button = "Buy1"
    }
}
t1.AURORA_EGG_FISH = {
    {
        fish = "AuroraAngler",
        odds = 55,
        rate = 3125000
    },
    {
        fish = "AuroraSwordfish",
        odds = 30,
        rate = 7500000
    },
    {
        fish = "Dawnwhale",
        odds = 11.5,
        rate = 2.5E+07
    },
    {
        fish = "BorealMeg",
        odds = 3,
        rate = 2.5E+08
    },
    {
        fish = "Dreammaw",
        odds = 0.5,
        rate = 7.5E+08
    }
}
t1.EGGS = {
    HellEgg = {
        name = "Hell Egg",
        buys = t1.HELL_EGG,
        fish = t1.HELL_EGG_FISH
    },
    VoidEgg = {
        name = "Voidspark Egg",
        buys = t1.VOID_EGG,
        fish = t1.VOID_EGG_FISH
    },
    AuroraEgg = {
        name = "Aurora Egg",
        buys = t1.AURORA_EGG,
        fish = t1.AURORA_EGG_FISH
    }
}
t1.MASSIVE_EGG_RARITY = {
    {
        rarity = "Secret",
        odds = 0.1
    },
    {
        rarity = "Exotic",
        odds = 1
    },
    {
        rarity = "Mythic",
        odds = 4
    },
    {
        rarity = "Legendary",
        odds = 5
    },
    {
        rarity = "Epic",
        odds = 20
    },
    {
        rarity = "Rare",
        odds = 30
    },
    {
        rarity = "Common",
        odds = 39.9
    }
}
t1.MASSIVE_EGG = {
    {
        product = 3718531933,
        price = 49,
        count = 1,
        button = "Buy1"
    },
    {
        product = 3718531937,
        price = 149,
        count = 3,
        button = "Buy3"
    },
    {
        product = 3718531940,
        price = 399,
        count = 10,
        button = "Buy10"
    },
    {
        product = 3718531944,
        price = 1499,
        count = 50,
        button = "Buy50"
    }
}
t1.MASSIVE_EGG_SIZE = {
    {
        chance = 85,
        min = 2.5,
        max = 3
    },
    {
        chance = 11,
        min = 3,
        max = 3.5
    },
    {
        chance = 3,
        min = 3.5,
        max = 4
    },
    {
        chance = 0.9,
        min = 4,
        max = 4.5
    },
    {
        chance = 0.1,
        min = 4.5,
        max = 5
    }
}
t1.EGGS.MassiveEgg = {
    grown = true,
    name = "MASSIVE Fish Egg",
    buys = t1.MASSIVE_EGG,
    rarity = t1.MASSIVE_EGG_RARITY,
    size = t1.MASSIVE_EGG_SIZE
}
t1.EGG_BUNDLE = {
    product = 3718781515,
    price = 249,
    title = "Egg Bundle",
    eggs = { "MassiveEgg", "HellEgg", "VoidEgg" }
}

function t1.PassAttr(p41) -- line: 1106
    return "Pass" .. p41
end

t1.CASH4 = {
    key = "Cash4x",
    product = 3717993304,
    price = 349,
    title = "4X CASH",
    image = "rbxassetid://129156943051821"
}
t1.RECOVER = {
    Legendary = {
        product = 3717556466,
        price = 19
    },
    Mythic = {
        product = 3717555855,
        price = 39
    },
    Exotic = {
        product = 3717555874,
        price = 79
    },
    Secret = {
        product = 3717555917,
        price = 199
    },
    Unknown = {
        product = 3717555959,
        price = 149
    },
    Celestial = {
        product = 3720141167,
        price = 299
    },
    Apex = {
        product = 3729857037,
        price = 499
    },
    Exclusive = {
        product = 3719154150,
        price = 119
    },
    Titan = {
        product = 3723133129,
        price = 270
    }
}
t1.MUTATION_UPGRADE = {
    product = 3718494347,
    price = 79,
    weights = nil,
    rarities = {
        Mythic = true,
        Exotic = true,
        Secret = true,
        Unknown = true,
        Celestial = true,
        Apex = true
    }
}
t1.ADMIN_FISH = {
    {
        fish = "Kingwhale",
        product = 3719151794,
        price = 799,
        title = "Kingwhale"
    },
    {
        fish = "Timefish",
        product = 3719151803,
        price = 599,
        title = "Timefish"
    },
    {
        fish = "Drillwyrm",
        product = 3719151813,
        price = 449,
        title = "Drillwyrm"
    }
}
t1.DONATE_ICON = "rbxassetid://88438073340289"
t1.DONATIONS = {
    {
        product = 3719162391,
        price = 10,
        card = "Donate_10"
    },
    {
        product = 3719162402,
        price = 25,
        card = "Donate_25"
    },
    {
        product = 3719162412,
        price = 100,
        card = "Donate_100"
    },
    {
        product = 3719162427,
        price = 250,
        card = "Donate_250"
    },
    {
        product = 3719162436,
        price = 500,
        card = "Donate_500"
    },
    {
        product = 3719162447,
        price = 1000,
        card = "Donate_1000"
    },
    {
        product = 3719162451,
        price = 2500,
        card = "Donate_2500"
    },
    {
        product = 3719162457,
        price = 10000,
        card = "Donate_10000"
    },
    {
        product = 3719162469,
        price = 1E+05,
        card = "Donate_100000"
    }
}
t1.COMPACTOR_RUSH = {
    product = 3731893136,
    price = 49
}

function t1.FindProduct(p42) -- line: 1188
    -- upvalues: t1 (copy)
    if p42 == t1.SERVER_LUCK.product then
        return "ServerLuck", 1, t1.SERVER_LUCK
    end

    if p42 ~= 0 and p42 == t1.COMPACTOR_RUSH.product then
        return "CompactorRush", 1, t1.COMPACTOR_RUSH
    end

    local v45 = require(script.Parent:WaitForChild("PumpkinShopConfig")).ByProduct(p42)

    if v45 then
        return "Pumpkin", 1, v45
    end

    local v46 = require(script.Parent:WaitForChild("TurkeyShopConfig")).ByProduct(p42)

    if v46 then
        return "Turkey", 1, v46
    end

    for v47, v48 in ipairs(t1.DONATIONS) do
        if v48.product == p42 then
            return "Donation", v47, v48
        end
    end

    for v49, v50 in ipairs(t1.ADMIN_FISH) do
        if v50.product == p42 then
            return "AdminFish", v49, v50
        end
    end

    if p42 == t1.HYDRA.product then
        return "Hydra", 1, t1.HYDRA
    end

    if p42 == t1.ULTIMATE.product then
        return "Ultimate", 1, t1.ULTIMATE
    end

    if p42 == t1.EGG_BUNDLE.product then
        return "EggBundle", 1, t1.EGG_BUNDLE
    end

    for v51, v52 in ipairs(t1.ZONE_RUSH.tiers) do
        if v52.product == p42 then
            return "ZoneRush", v51, v52
        end
    end

    if p42 == t1.CASH4.product then
        return "Cash4x", 1, t1.CASH4
    end

    for v53, v54 in ipairs(t1.HYDRA_UPS) do
        if v54.product == p42 then
            return "HydraUp", v53, v54
        end
    end

    for v55, v56 in ipairs(t1.POTION_PACK) do
        if v56.product == p42 then
            return "PotionPack", v55, v56
        end
    end

    for v57, v58 in ipairs(t1.BONE_PACK) do
        if v58.product ~= 0 and v58.product == p42 then
            return "BonePack", v57, v58
        end
    end

    for v59, v60 in ipairs(t1.HELL_EGG) do
        if v60.product == p42 then
            return "HellEgg", v59, v60
        end
    end

    for v61, v62 in ipairs(t1.VOID_EGG) do
        if v62.product == p42 then
            return "VoidEgg", v61, v62
        end
    end

    for v63, v64 in ipairs(t1.AURORA_EGG) do
        if v64.product == p42 then
            return "AuroraEgg", v63, v64
        end
    end

    for v65, v66 in ipairs(t1.MASSIVE_EGG) do
        if v66.product == p42 then
            return "MassiveEgg", v65, v66
        end
    end

    for v67, v68 in ipairs(t1.LIMITED) do
        if v68.product == p42 or v68.plainProduct and v68.plainProduct == p42 then
            return "Limited", v67, v68
        end
    end

    for v69, v70 in ipairs(t1.OFFLINE_X10) do
        if v70.product == p42 then
            return "OfflineX10", v69, v70
        end
    end

    for v71, v72 in ipairs(t1.PASSES) do
        if v72.gift == p42 then
            return "GiftPass", v71, v72
        end
    end

    for v73, v74 in ipairs(t1.STARTER) do
        if v74.product == p42 and t1.Starter(v73) then
            return "Starter", v73, v74
        end
    end

    for v75, v76 in ipairs(t1.KEYS) do
        if v76.product == p42 then
            return "Keys", v75, v76
        end
    end

    for v77, v78 in ipairs(t1.TOKENS) do
        if v78.product and v78.product == p42 then
            return "Tokens", v77, v78
        end
    end

    for v79, v80 in ipairs(t1.CRATES) do
        if v80.product == p42 then
            return "Crate", v79, v80
        end
    end

    for v81, v82 in ipairs(t1.FAT_LADDER) do
        if v82.product == p42 then
            return "Fat", v81, v82
        end
    end

    for v83, v84 in ipairs(t1.FAT_TIME) do
        if v84.product == p42 then
            return "FatTime", v83, v84
        end
    end

    for v85, v86 in ipairs(t1.CASH_TIME) do
        if v86.product == p42 then
            return "CashTime", v85, v86
        end
    end

    for v87, v88 in pairs(t1.CAP) do
        if v88.product == p42 then
            return "Cap", v87, v88
        end
    end

    for v89, v90 in ipairs(t1.SKIP) do
        if v90.product == p42 then
            return "Skip", v89, v90
        end
    end

    for v91, v92 in ipairs(t1.ORO_SKIP) do
        if v92.product == p42 then
            return "Skip", v91, v92
        end
    end

    for v93, v94 in pairs(t1.TABLES) do
        if v94.product == p42 then
            return "Table", v93, v94
        end
    end

    for v95, v96 in pairs(t1.AQUARIUM) do
        if v96.product == p42 then
            return "Aquarium", v95, v96
        end
    end

    for v97, v98 in pairs(t1.RECOVER) do
        if v98.product == p42 then
            return "Recover", v97, v98
        end
    end

    if p42 ~= 0 and p42 == t1.MUTATION_UPGRADE.product then
        return "MutationUpgrade", 1, t1.MUTATION_UPGRADE
    end

    for v99, v100 in ipairs(t1.BAIT_BUNDLES) do
        if v100.product == p42 then
            return "BaitBundle", v99, v100
        end
    end

    local BaitConfig = require(script.Parent:WaitForChild("BaitConfig"))

    for _, v101 in ipairs({
            BaitConfig.ALWAYS,
            BaitConfig.POOL,
            BaitConfig.UNKNOWN
        }) do
        for _, v102 in ipairs(v101) do
            if v102.product == p42 then
                return "Bait", v102.id, v102
            end
        end
    end

    return nil
end

t1.BAIT_BUNDLES = {
    {
        card = "BaitBundle1",
        title = "Bait Bundle",
        product = 3721745051,
        price = 599,
        was = 922,
        off = 35,
        baits = {
            { "Kraken", 1 },
            { "Crocodon", 1 },
            { "Megalodon", 1 },
            { "PoisonedHexjaw", 1 }
        }
    },
    {
        card = "BaitBundle2",
        title = "Mega Bait Bundle",
        product = 3721745054,
        price = 2999,
        was = 4999,
        off = 40,
        baits = {
            { "VikingSwordfish", 1 },
            { "CrownedMosasaur", 1 },
            { "HazmatHammerhead", 1 },
            { "Copshark", 1 },
            { "Gravedigger", 1 },
            { "CrownedParasite", 1 },
            { "WizardSquid", 1 },
            { "Nightcrawler", 1 },
            { "Godsaw", 1 },
            { "Voidspine", 1 },
            { "EclipsedLeviathan", 1 }
        }
    },
    {
        card = "BaitBundle3",
        title = "Ultimate Bait Bundle",
        product = 3721745055,
        price = 5999,
        was = 12000,
        off = 50,
        baits = {
            { "Kraken", 2 },
            { "Crocodon", 2 },
            { "Megalodon", 2 },
            { "PoisonedHexjaw", 2 },
            { "Nightcrawler", 2 },
            { "Godsaw", 2 },
            { "Voidspine", 2 },
            { "EclipsedLeviathan", 2 },
            { "VikingSwordfish", 2 },
            { "CrownedMosasaur", 2 },
            { "HazmatHammerhead", 2 },
            { "Copshark", 2 },
            { "Gravedigger", 2 },
            { "CrownedParasite", 2 },
            { "WizardSquid", 2 }
        }
    }
}
t1.BAIT_BUNDLE_RATES = {
    Kraken = 75000,
    Crocodon = 1E+05,
    Megalodon = 125000,
    PoisonedHexjaw = 150000,
    Nightcrawler = 4E+05,
    Godsaw = 1600000,
    Voidspine = 4800000,
    EclipsedLeviathan = 1.4E+07,
    VikingSwordfish = 90000,
    CrownedMosasaur = 135000,
    HazmatHammerhead = 165000,
    Copshark = 9E+05,
    Gravedigger = 1500000,
    CrownedParasite = 6250000,
    WizardSquid = 9E+06
}

function t1.FindPass(p43) -- line: 1266
    -- upvalues: t1 (copy)
    for _, v103 in ipairs(t1.PASSES) do
        if v103.pass == p43 then
            return v103
        end
    end

    return nil
end

function t1.CrateRow(p44) -- line: 1271
    -- upvalues: t1 (copy)
    for _, v104 in ipairs(t1.CRATES) do
        if v104.crate == p44 then
            return v104
        end
    end

    return nil
end

t1.VIGNETTE = "rbxassetid://99960700414194"
t1.ZEUS.off = 0
t1.HYDRA.off = 80

local t6 = {
    Molten = 70,
    Shadow = 60
}

for _, v105 in ipairs(t1.HYDRA_UPS) do
    v105.off = t6[v105.mutation]
end

local t7 = {
    75, 75, 70, 70, 60, 60, 50, 50
}

for v106, v107 in ipairs(t1.STARTER) do
    v107.off = t7[v106]
end

t1.HELL_EGG[1].off = 40
t1.VOID_EGG[1].off = 35
t1.VOID_EGG[2].off = 25
t1.VOID_EGG[4].off = 60
t1.AURORA_EGG[1].off = 60
t1.AURORA_EGG[2].off = 35
t1.AURORA_EGG[3].off = 25

for v108, v109 in ipairs({
        { 55, 25 },
        { 129, 35 },
        { 249, 50 }
    }) do
    local v110 = t1.BONE_PACK[v108]
    local v111 = t1.BONE_PACK[v108]
    local v112 = v109[1]
    local v113 = v109[2]

    v110.was = v112
    v111.off = v113
end

function t1.OffOf(p45, p46) -- line: 1315
    if not p45 or not p45.was or not (p45.was > 0) or type(p46) ~= "number" then
        return 0
    end

    local v115 = math.floor((1 - p46 / p45.was) * 100)

    if not p45.off then
        return (math.max(0, v115))
    end

    return (math.max(0, (math.min(p45.off, v115))))
end

return t1
