-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local t1 = {
    START = 1792256400
}

t1.END = t1.START + 1800
t1.CUTSCENE = 65
t1.GRACE = 3
t1.LIFT = 3

function t1.Hold(p1) -- line: 29
    -- upvalues: t1 (copy)
    p1 = p1 or t1.Since()

    if -t1.LIFT <= p1 then
        return p1 < t1.GRACE + 1
    end

    return false
end

t1.REVEAL_AFTER_BOOM = 3.5
t1.FOCUS = {
    { 0.05, "Z4_GrandCove1" },
    { 5.2, "Z5_GrandCove2" },
    { 12.6, (Vector3.new(58, -1800, 6)) },
    { 22.6, false }
}
t1.LINES = {
    {
        at = -300,
        text = "hi everyone :D",
        hold = 8
    },
    {
        at = -260,
        text = "this is my first admin abuse hope yall like it",
        hold = 10
    },
    {
        at = -220,
        text = "I'll give you guys some fat while we wait...",
        hold = 9
    },
    {
        at = -210.5,
        text = "good to be prepared 👀",
        hold = 7
    },
    {
        at = -180,
        text = "I added some new fish for this admin event only",
        hold = 10
    },
    {
        at = -140,
        text = "you guys better lock in these fish are NOT coming back",
        hold = 11
    },
    {
        at = -100,
        text = "I read every feedback btw so if you have any ideas for updates you want send them 🙂",
        hold = 12
    },
    {
        at = -60,
        text = "If this event lags you I'm sorry 😢",
        hold = 9
    },
    {
        at = -20,
        text = "alright let's get this party started 😈",
        hold = 9
    },
    {
        at = 62.5,
        text = "THE CHAOS IS STARTING!!",
        title = "ADMIN LEVEL 1",
        hold = 5
    },
    {
        at = 68.5,
        text = "watch out for those admin treasure chest's they might pop open with those new fish",
        hold = 6
    },
    {
        at = 75.5,
        text = "how about we make things a little BIGGER?",
        hold = 5
    },
    {
        at = 81.5,
        text = "I'll spice up the rolls too...",
        hold = 5
    },
    {
        at = 87.5,
        text = "then maybe you'll get something lucky...",
        hold = 4
    },
    {
        at = 98.5,
        text = "gotta start small you know?",
        hold = 4
    },
    {
        at = 105,
        text = "you're not ready for whats next...",
        hold = 5
    },
    {
        at = 110.3,
        text = "If the volume is too loud turn it down in settings!",
        hold = 4
    },
    {
        at = 114.6,
        text = "psst... the admin chests are in zones 4, 5 and 6 👀",
        hold = 5
    },
    {
        at = 121.8,
        text = "let's do it again shall we?",
        hold = 4
    },
    {
        at = 133,
        text = "did anyone get a secret yet??",
        hold = 4
    },
    {
        at = 139.5,
        text = "all the fish are 25% bigger right now btw 😈",
        hold = 5
    },
    {
        at = 146.1,
        text = "a third time can't hurt right?",
        hold = 5
    },
    {
        at = 152.1,
        text = "I'll make this one extra lucky though...",
        hold = 4
    },
    {
        at = 163.2,
        text = "actually you know what?",
        hold = 4
    },
    {
        at = 168.5,
        text = "This isn't good enough.",
        hold = 4
    },
    {
        at = 173.5,
        text = "Let's make this event really UNIQUE",
        hold = 5
    },
    {
        at = 179,
        text = "I present the very first FISH COSMETIC!",
        hold = 5
    },
    {
        at = 185.5,
        text = "You better catch as many as you can the crown hats are never coming back. EVER!",
        hold = 6
    },
    {
        at = 193,
        text = "I'll trigger more rolls too. Catching a secret with a crown would be crazy...",
        hold = 6
    },
    {
        at = 206,
        text = "I wonder if the crown fishes will do anything special later...",
        hold = 6
    },
    {
        at = 213.5,
        text = "your crowned fish keep their crowns in your aquarium too 👑",
        hold = 6
    },
    {
        at = 228,
        text = "the admin chests can still pop open with those event fish ⚡",
        hold = 6
    },
    {
        at = 241,
        text = "who's got the biggest crowned fish so far? 👀",
        hold = 5
    },
    {
        at = 252,
        text = "here comes another one 👀",
        hold = 5
    },
    {
        at = 267,
        text = "the crowns won't last forever... keep harpooning!",
        hold = 5
    },
    {
        at = 285,
        text = "the crabs are vibing 🦀",
        hold = 4
    },
    {
        at = 295,
        text = "this song is a banger btw",
        hold = 4
    },
    {
        at = 308,
        text = "This is a good start...",
        hold = 4
    },
    {
        at = 313,
        text = "but I think it's time to ramp things up",
        hold = 5
    },
    {
        at = 324,
        text = "I THINK A NEW MUTATION IS IN ORDER",
        title = "ADMIN LEVEL 2",
        hold = 5,
        red = true
    },
    {
        at = 330.5,
        text = "every harpoon hit now has a 1 in 4 chance to turn ADMIN 😈",
        hold = 6
    },
    {
        at = 343,
        text = "ADMIN fish are worth more than radioactive ones 👀",
        hold = 5
    },
    {
        at = 348.5,
        text = "this mutation is NEVER RETURNING",
        hold = 4.5,
        red = true
    },
    {
        at = 353.5,
        text = "better get to harpooning!",
        hold = 4.5
    },
    {
        at = 359,
        text = "I dropped a TRADER in the middle of the water 👀 trade your crowned fish for crowns!",
        hold = 7
    },
    {
        at = 372,
        text = "even the crabs got it 🦀",
        hold = 4
    },
    {
        at = 398,
        text = "imagine catching a crowned ADMIN secret... 🤯",
        hold = 5
    },
    {
        at = 423,
        text = "hmm...",
        hold = 3
    },
    {
        at = 427.5,
        text = "still not crazy enough",
        hold = 4
    },
    {
        at = 436.07,
        text = "MORE. MUTATION.",
        hold = 5,
        red = true
    },
    {
        at = 442.5,
        text = "1 in 2 hits now!! GO GO GO",
        hold = 5
    },
    {
        at = 480,
        text = "don't stop harpooning!!",
        hold = 4
    },
    {
        at = 512,
        text = "this lightning is getting out of hand ⚡",
        hold = 5
    },
    {
        at = 549,
        text = "still going 😈",
        hold = 4
    },
    {
        at = 585,
        text = "who's got the biggest ADMIN fish? 👀",
        hold = 5
    },
    {
        at = 625,
        text = "okay one more loop after this one... I'm feeling generous",
        hold = 6
    },
    {
        at = 660.5,
        text = "FINAL LOOP!! make it count",
        hold = 5,
        red = true
    },
    {
        at = 712.3,
        text = "1 minute left on the boosts!",
        hold = 5
    },
    {
        at = 730,
        text = "Use code ADMIN for a reward btw",
        hold = 6
    },
    {
        at = 742.3,
        text = "30 seconds left!!",
        hold = 4
    },
    {
        at = 762.3,
        text = "10 SECONDS!!",
        hold = 5,
        red = true
    },
    {
        at = 767.6,
        text = "If you don't have an exclusive yet you'll like this next part,",
        hold = 4.3
    },
    {
        at = 772.28,
        text = "LET LEVEL 3 BEGIN",
        title = "ADMIN LEVEL 3",
        hold = 4.5,
        red = true
    },
    {
        at = 781,
        text = "X10 SERVER LUCK for this whole level 🍀",
        hold = 6
    },
    {
        at = 788,
        text = "and the ADMIN mutation is back at 1 in 3 😈",
        hold = 5
    },
    {
        at = 843,
        text = "a roll every minute and a half now 😈",
        hold = 6
    },
    {
        at = 925,
        text = "another exclusive is coming in a bit 👀",
        hold = 5
    },
    {
        at = 947.5,
        text = "here it comes...",
        hold = 4
    },
    {
        at = 1000,
        text = "did anyone get one?? 👀",
        hold = 4
    },
    {
        at = 1056,
        text = "FINAL LOOP OF LEVEL 3!!",
        hold = 5,
        red = true
    },
    {
        at = 1145,
        text = "you thought that was crazy?",
        hold = 4.5
    },
    {
        at = 1150.04,
        text = "LEVEL 4. EVERYTHING AT ONCE 😈",
        title = "ADMIN LEVEL 4",
        hold = 5,
        red = true
    },
    {
        at = 1157,
        text = "ADMIN mutation is up to 1 in 2 and the fish are 50% BIGGER",
        hold = 7
    },
    {
        at = 1185,
        text = "the crabs came back for the finale 🦀",
        hold = 5
    },
    {
        at = 1225,
        text = "an exclusive chest every minute and a half now 👀",
        hold = 6
    },
    {
        at = 1290,
        text = "use code ADMIN if you haven't yet btw",
        hold = 5
    },
    {
        at = 1320,
        text = "trade your crowned fish at the TRADER in the middle of the water 👑",
        hold = 6
    },
    {
        at = 1380,
        text = "is your phone ok?? 😅",
        hold = 4
    },
    {
        at = 1410,
        text = "this is the craziest it gets... for now 😈",
        hold = 5
    },
    {
        at = 1500,
        text = "1 minute left on level 4!",
        hold = 5
    },
    {
        at = 1550,
        text = "10 SECONDS!!",
        hold = 5,
        red = true
    },
    {
        at = 1562,
        text = "take a breather... level 5 is coming 👀",
        hold = 6
    },
    {
        at = 1570,
        text = "have some X3 FAT while you wait 🍔",
        hold = 5
    },
    {
        at = 1610,
        text = "enjoy the calm while it lasts",
        hold = 5
    },
    {
        at = 1636,
        text = "this is the finale... 👑",
        hold = 5
    },
    {
        at = 1644.03,
        text = "THE FINALE",
        title = "ADMIN LEVEL 5",
        hold = 4,
        red = true
    },
    {
        at = 1740.3,
        text = "HERE IT COMES",
        hold = 3,
        red = true
    },
    {
        at = 1796.6,
        text = "GG 👑 thank you all for coming to the first admin abuse!",
        hold = 3.3
    },
    {
        at = 1800,
        text = "Hope you all had fun.. but now comes THE UPDATE!",
        hold = 6,
        red = true
    },
    {
        at = 1845,
        text = "How did you like it?",
        hold = 245,
        feedback = true
    }
}
t1.LEVEL1 = {
    at = 62.5,
    LUCK = 2,
    EVERY = 30
}
t1.LEVEL2 = {
    at = 324,
    loops = 4,
    moreLoop = 1,
    mutation = "Admin",
    CHANCE = 0.25,
    MORE_CHANCE = 0.5,
    LUCK = 4,
    song = {
        id = 1839246711,
        length = 112.07,
        volume = 0.45
    }
}
t1.LEVEL2.more = t1.LEVEL2.at + t1.LEVEL2.moreLoop * t1.LEVEL2.song.length
t1.LEVEL2.ends = t1.LEVEL2.at + t1.LEVEL2.loops * t1.LEVEL2.song.length
t1.LEVEL3 = {
    loops = 4,
    LUCK = 10,
    MUTATION = 0.3333333333333333,
    song = {
        id = 95131770144654,
        length = 94.44,
        volume = 0.9
    },
    EXCLUSIVES = { 3.5, 93.5, 183.5, 273.5 },
    ZONES = {
        { 4, 0.4 },
        { 5, 0.35 },
        { 6, 0.25 }
    }
}
t1.LEVEL3.at = t1.LEVEL2.ends
t1.LEVEL3.ends = t1.LEVEL3.at + t1.LEVEL3.loops * t1.LEVEL3.song.length
t1.LEVEL4 = {
    SIZE = 1.5,
    BPM = 124.7,
    FINALE = 5,
    LUCK = 20,
    song = {
        id = 74793860481732,
        length = 115.48,
        volume = 0.45
    },
    EXCLUSIVES = { 30, 120, 210, 300, 390 }
}
t1.LEVEL4.at = t1.LEVEL3.ends
t1.LEVEL4.ends = 1560
t1.BREATHER_FAT = 3
t1.LEVEL5 = {
    LUCK = 30,
    STAY = 15,
    CHEST_STAY = 15,
    MUTATION = 0.3333333333333333,
    RESERVE = 25,
    SECRET = 151.96,
    RELEASE = 4,
    song = {
        id = 1839900676,
        length = 155.97,
        volume = 1.5
    },
    ODDS_STOPS = {
        {
            0,
            {
                Legendary = 1,
                Mythic = 0,
                Exotic = 0
            }
        },
        {
            59.99,
            {
                Legendary = 0.6,
                Mythic = 0.4,
                Exotic = 0
            }
        },
        {
            60,
            {
                Legendary = 0,
                Mythic = 0.92,
                Exotic = 0.08
            }
        },
        {
            152.31,
            {
                Legendary = 0,
                Mythic = 0.7,
                Exotic = 0.3
            }
        }
    }
}
t1.LEVEL5.ends = t1.END - t1.START
t1.LEVEL5.at = t1.LEVEL5.ends - t1.LEVEL5.song.length
t1.TRADER = {
    at = 357,
    FALL = 6,
    SPOT = Vector3.new(50, 0, -30),
    AFTER = 86400,
    ADMIN_MUT = 3,
    VALUES = {
        Common = 1,
        Uncommon = 1,
        Rare = 1,
        Epic = 2,
        Legendary = 4,
        Mythic = 10,
        Exotic = 30,
        Secret = 100,
        Unknown = 100,
        Celestial = 100,
        Apex = 200
    },
    SHOP = {
        {
            key = "AdminHarpoon",
            kind = "harpoon",
            price = 900
        },
        {
            key = "Drillwyrm",
            kind = "fish",
            price = 300
        },
        {
            key = "Timefish",
            kind = "fish",
            price = 450
        },
        {
            key = "Kingwhale",
            kind = "fish",
            price = 600
        }
    }
}

function t1.CrownValue(p2, p3) -- line: 345
    -- upvalues: t1 (copy)
    local v2 = t1.TRADER.VALUES[p2]

    if not v2 then
        return nil
    end

    v2 = p3 == "Admin" and v2 * t1.TRADER.ADMIN_MUT or v2

    return v2
end

t1.SONG2 = {
    id = 5410086218,
    at = 159.7,
    length = 161.33,
    volume = 0.4
}
t1.CROWN_AT = 179
t1.ROLL_ZONES = 1
t1.ROLLS = {
    {
        at = 91.8,
        chest = true
    },
    {
        at = 126.1,
        chest = true
    },
    {
        at = 156.4,
        rare = "Exotic"
    },
    {
        at = 199.3,
        chest = true
    },
    {
        at = 259.3,
        chest = true
    },
    {
        at = 348.3,
        rare = true
    },
    {
        at = 375.8
    },
    {
        at = 403.3,
        rare = true
    },
    {
        at = 425.5
    },
    {
        at = 447.8,
        rare = true
    },
    {
        at = 482.5
    },
    {
        at = 517.3,
        rare = true
    },
    {
        at = 553.8
    },
    {
        at = 590.3,
        rare = true
    },
    {
        at = 628
    },
    {
        at = 665.8,
        rare = true
    },
    {
        at = 691.7
    },
    {
        at = 717.6,
        rare = true
    },
    {
        at = 850.3
    },
    {
        at = 940.3
    },
    {
        at = 1030.3
    },
    {
        at = 1120.3
    },
    {
        at = 1170
    },
    {
        at = 1215
    },
    {
        at = 1260
    },
    {
        at = 1305
    },
    {
        at = 1350
    },
    {
        at = 1395
    },
    {
        at = 1440
    },
    {
        at = 1485
    },
    {
        at = 1530
    }
}
t1.CHESTS_AT = 68.5
t1.CHEST_CHANCE = 0.3333333333333333
t1.EXCLUSIVES = { 140, 230, 380, 500, 620, 740 }
t1.CHEST_FISH = {
    [4] = "Drillwyrm",
    [5] = "Timefish",
    [6] = "Kingwhale"
}
t1.BOOST_AT = 76.5
t1.SIZE = 1.25
t1.FAT_AT = -219
t1.FAT = 2
t1.APPROACH = {
    CLOUDS = 300,
    MUSIC = 60,
    THUNDER = 120,
    THUNDER_GAP = { 14, 24 }
}
t1.UPDATE = {
    LOG = 7,
    ASK = 45,
    ASK_UNTIL = 290
}
t1.AFTER_LUCK = 1800

function t1.Now() -- line: 433
    return workspace:GetServerTimeNow() + (workspace:GetAttribute("AdminAbuseOffset") or 0)
end

function t1.FromServerTime(p4) -- line: 438
    return p4 + (workspace:GetAttribute("AdminAbuseOffset") or 0)
end

function t1.Since(p5) -- line: 443
    -- upvalues: t1 (copy)
    return (p5 or t1.Now()) - t1.START
end

function t1.Active(p6) -- line: 447
    -- upvalues: t1 (copy)
    p6 = p6 or t1.Now()

    if t1.START <= p6 then
        return p6 < t1.END
    end

    return false
end

local function within(p7, p8, p9) -- line: 453
    -- upvalues: t1 (copy)
    if p8 <= p7 and p7 < p9 then
        return p7 < t1.END - t1.START
    end

    return false
end

function t1.Boost(p10) -- line: 458
    -- upvalues: t1 (copy)
    local v4 = t1.Since(p10)
    local LEVEL2, LEVEL4, BOOST_AT = t1.LEVEL2, t1.LEVEL4, t1.BOOST_AT
    local ends = LEVEL2.ends

    if BOOST_AT <= v4 and v4 < ends and v4 < t1.END - t1.START then
        return t1.SIZE, t1.START + LEVEL2.ends
    end

    local at, ends2 = LEVEL4.at, LEVEL4.ends

    if at <= v4 and v4 < ends2 and v4 < t1.END - t1.START then
        return LEVEL4.SIZE, t1.START + LEVEL4.ends
    end

    return nil
end

function t1.BoostEnd(p11) -- line: 466
    -- upvalues: t1 (copy)
    local _, v5 = t1.Boost(p11)

    return v5 or t1.START
end

function t1.Boosted(p12) -- line: 470
    -- upvalues: t1 (copy)
    return t1.Boost(p12) ~= nil
end

function t1.SizeMul(p13) -- line: 471
    -- upvalues: t1 (copy)
    return t1.Boost(p13) or 1
end

function t1.Fattening(p14) -- line: 475
    -- upvalues: t1 (copy)
    local v6 = (p14 or t1.Now()) - t1.START

    if t1.FAT_AT <= v6 and v6 < 0 then
        return t1.FAT, t1.START
    end

    local ends = t1.LEVEL4.ends
    local at = t1.LEVEL5.at

    if ends <= v6 and v6 < at and v6 < t1.END - t1.START then
        return t1.BREATHER_FAT, t1.START + t1.LEVEL5.at
    end

    return nil
end

function t1.FatMul(p15) -- line: 483
    -- upvalues: t1 (copy)
    return t1.Fattening(p15) or 1
end

function t1.Crowning(p16) -- line: 486
    -- upvalues: t1 (copy)
    local v7 = t1.Since(p16)
    local CROWN_AT = t1.CROWN_AT
    local v8 = t1.END - t1.START

    if CROWN_AT <= v7 and v7 < v8 then
        return v7 < t1.END - t1.START
    end

    return false
end

local v9

function t1.LuckMul(p17) -- line: 493
    -- upvalues: t1 (copy), v9 (ref)
    v9 = v9 or {
        {
            t1.LEVEL1,
            t1.LEVEL2.at
        },
        {
            t1.LEVEL2,
            t1.LEVEL2.ends
        },
        {
            t1.LEVEL3,
            t1.LEVEL3.ends
        },
        {
            t1.LEVEL4,
            t1.LEVEL4.ends
        },
        {
            t1.LEVEL5,
            t1.LEVEL5.ends
        }
    }

    local v10 = t1.Since(p17)

    for _, v11 in ipairs(v9) do
        local at = v11[1].at
        local v12 = v11[2]

        if at <= v10 and v10 < v12 and v10 < t1.END - t1.START then
            return v11[1].LUCK, t1.START + v11[2]
        end
    end

    return nil
end

function t1.Finale(p18) -- line: 504
    -- upvalues: t1 (copy)
    local v13 = t1.Since(p18)
    local at, ends = t1.LEVEL5.at, t1.LEVEL5.ends

    if at <= v13 and v13 < ends then
        return v13 < t1.END - t1.START
    end

    return false
end

function t1.HitMutation(p19) -- line: 510
    -- upvalues: t1 (copy)
    local LEVEL2, LEVEL3, LEVEL4, LEVEL5 = t1.LEVEL2, t1.LEVEL3, t1.LEVEL4, t1.LEVEL5
    local v14 = t1.Since(p19)
    local START = t1.START
    local at, ends = LEVEL2.at, LEVEL2.ends

    if at <= v14 and v14 < ends and v14 < t1.END - t1.START then
        return LEVEL2.mutation, LEVEL2.more <= v14 and LEVEL2.MORE_CHANCE or LEVEL2.CHANCE, START + LEVEL2.ends
    end

    local at2, ends2 = LEVEL3.at, LEVEL3.ends

    if at2 <= v14 and v14 < ends2 and v14 < t1.END - t1.START then
        return LEVEL2.mutation, LEVEL3.MUTATION, START + LEVEL3.ends
    end

    local at3, ends3 = LEVEL4.at, LEVEL4.ends

    if at3 <= v14 and v14 < ends3 and v14 < t1.END - t1.START then
        return LEVEL2.mutation, LEVEL2.MORE_CHANCE, START + LEVEL4.ends
    end

    local at4, ends4 = LEVEL5.at, LEVEL5.ends

    if at4 <= v14 and v14 < ends4 and v14 < t1.END - t1.START then
        return LEVEL2.mutation, LEVEL5.MUTATION, START + LEVEL5.ends
    end

    return nil
end

function t1.ChestsOn(p20) -- line: 521
    -- upvalues: t1 (copy)
    p20 = p20 or t1.Now()

    if p20 - t1.START >= t1.CHESTS_AT then
        return p20 < t1.END
    end

    return false
end

function t1.ForceChest(p21) -- line: 528
    -- upvalues: t1 (copy)
    local v16 = workspace:FindFirstChild("ZoneJackpots") and workspace.ZoneJackpots:FindFirstChild("Zone" .. tostring(p21))

    if not v16 then
        return "no chest for zone " .. tostring(p21)
    end

    v16:SetAttribute("AdminCharge", true)

    return "zone " .. tostring(p21) .. "'s chest charged (" .. tostring(t1.CHEST_FISH[p21]) .. ")"
end

function t1.CrownNow() -- line: 537
    workspace:SetAttribute("AdminCrownNow", true)

    return "crowning every fish in the water"
end

function t1.RollNow(p22) -- line: 544
    workspace:SetAttribute("AdminRollNow", p22 and "rare" or "all")

    return "admin roll: all six zones" .. (if p22 then ", no Legendaries" else "")
end

function t1.Test(p23) -- line: 551
    -- upvalues: t1 (copy)
    if p23 == false then
        workspace:SetAttribute("AdminAbuseOffset", nil)

        return "admin abuse: real time"
    end

    local v19 = tonumber(p23) or 0

    workspace:SetAttribute("AdminAbuseOffset", t1.START - (workspace:GetServerTimeNow() + v19))

    return ("admin abuse starts in %.1f s"):format(v19)
end

function t1.TestUpdate(p24) -- line: 565
    -- upvalues: t1 (copy)
    local WeatherConfig = require(script.Parent.WeatherConfig)

    if p24 == false then
        t1.Test(false)
        WeatherConfig.Test(false)

        return "admin abuse + weather: real time"
    end

    local v20 = tonumber(p24) or 5
    local ServerTimeNow = workspace:GetServerTimeNow()

    workspace:SetAttribute("AdminAbuseOffset", t1.END - v20 - ServerTimeNow)
    workspace:SetAttribute("WeatherForce", nil)
    workspace:SetAttribute("WeatherReal", true)
    workspace:SetAttribute("WeatherOffset", WeatherConfig.STARTS - v20 - ServerTimeNow)

    return ("the admin abuse ends in %.1f s, the first storm %.1f s after"):format(v20, WeatherConfig.FIRST - WeatherConfig.STARTS)
end

return t1
