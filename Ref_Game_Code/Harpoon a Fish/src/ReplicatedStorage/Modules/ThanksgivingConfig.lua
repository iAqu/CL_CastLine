-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local t1 = {
    STARTS = 1795284000,
    ENDS = 1796544000,
    GRACE_ENDS = 1796630400,
    MUTATION = "Thanksgiving",
    hitMutation = {
        name = "Thanksgiving",
        chance = 0.05,
        pity = 30
    },
    TICKET = "Thanksgiving",
    ICON = "rbxassetid://104956517754676",
    ORANGE = Color3.fromRGB(230, 130, 45),
    FEAST_LOOK = {
        fogStart = 30,
        fogEnd = 260,
        waterTransparency = 0.12,
        saturation = 0.1,
        contrast = 0.12,
        fogColor = Color3.fromRGB(118, 66, 30),
        waterColor = Color3.fromRGB(136, 80, 34),
        tintColor = Color3.fromRGB(255, 236, 210),
        ambient = Color3.fromRGB(226, 186, 140),
        outdoorAmbient = Color3.fromRGB(226, 186, 140)
    },
    TURKEY = {
        AHEAD = 45,
        DOWN = 4
    },
    RUN = {
        FEAST_MUSIC = 137625798392455,
        CATCH_MUSIC = 122681644942798,
        DIP = 0.35,
        BONZO_AT = 0.8,
        LINE = 3.2,
        BONZO_OUT = 0.4,
        GAP = 0.5,
        SETTLE = 1.6,
        BUILD = 3.2,
        CATCH = 30,
        BONZO = { "WOAHH YOU FOUND A TURKEY!!!", "I've heard wondrous sea creatures live inside it!", "Once it pops, you better catch it!" }
    },
    ROUNDS = 10,
    CLOSE_AFTER = 1.6,
    THROW_LEAD = 0.6,
    THROW_FLY = 1.4,
    THROW_WAIT = 12,
    FAIL_OUT = 2.2,
    TIERS = { "Legendary", "Mythic", "Exotic", "Secret", "Celestial", "Exclusive" },
    FISH = {
        Legendary = { "Blobtato", "Gobblefish", "CornOnTheCod" },
        Mythic = { "Pieranha", "Stingravy", "Yamprey" },
        Exotic = { "GobblinShark", "HamMerhead", "Paradeluga", "Krakenucopia" },
        Secret = { "Pilgrimosaur", "Gobbleviathan" },
        Celestial = { "Mayflounder", "MapleSeadragon" },
        Exclusive = { "FeastedLeviathan" }
    },
    KEEP_MAX = {
        FeastedLeviathan = 3
    },
    STEP = { 0.85, 1.15 },
    LUCK_MAX = 9
}

function t1.LuckOdds(p1) -- line: 102
    -- upvalues: t1 (copy)
    local TIERS = t1.TIERS
    local v2 = math.clamp(p1 or 0, 0, t1.LUCK_MAX) * (#TIERS - 1) / t1.LUCK_MAX
    local v4 = math.floor(v2 + 1E-09)
    local v5 = v2 - v4
    local t2 = {
        [TIERS[v4 + 1]] = (1 - v5) * 100
    }

    if v5 > 1E-06 then
        t2[TIERS[v4 + 2]] = v5 * 100
    end

    return t2
end

t1.VALUES = {
    {
        Legendary = 1700,
        Mythic = 4560,
        Exotic = 12100,
        Secret = 36200,
        Celestial = 119000
    },
    {
        Legendary = 2870,
        Mythic = 8780,
        Exotic = 18300,
        Secret = 54900,
        Celestial = 181000
    },
    {
        Legendary = 6200,
        Mythic = 14600,
        Exotic = 29700,
        Secret = 89000,
        Celestial = 294000
    },
    {
        Legendary = 18300,
        Mythic = 48800,
        Exotic = 91200,
        Secret = 288000,
        Celestial = 950000
    },
    {
        Legendary = 63600,
        Mythic = 183000,
        Exotic = 294000,
        Secret = 1010000,
        Celestial = 3320000
    },
    {
        Legendary = 196000,
        Mythic = 507000,
        Exotic = 882000,
        Secret = 3130000,
        Celestial = 10300000
    },
    {
        Legendary = 627000,
        Mythic = 1450000,
        Exotic = 3120000,
        Secret = 9380000,
        Celestial = 3.3E+07
    },
    {
        Legendary = 1830000,
        Mythic = 4680000,
        Exotic = 9E+06,
        Secret = 2.7E+07,
        Celestial = 9E+07
    },
    {
        Legendary = 5660000,
        Mythic = 13800000,
        Exotic = 28100000,
        Secret = 82500000,
        Celestial = 2.72E+08
    },
    {
        Legendary = 16600000,
        Mythic = 42300000,
        Exotic = 84200000,
        Secret = 2.59E+08,
        Celestial = 8.14E+08
    }
}
t1.ZONE_FAT = {
    850, 54000, 550000, 4E+06, 9600000, 5.6E+07, 2.5E+08, 1.125E+09,
    5.06E+09
}

function t1.ZoneOf(p2) -- line: 129
    -- upvalues: t1 (copy)
    local n1 = 1

    for v6, v7 in ipairs(t1.ZONE_FAT) do
        if v7 <= (p2 or 0) then
            n1 = v6 + 1
        end
    end

    return n1
end

function t1.BaseRate(p3, p4) -- line: 137
    -- upvalues: t1 (copy)
    for _, v8 in ipairs(t1.TIERS) do
        local v9 = t1.FISH[v8]
        local v10 = table.find(v9, p3)

        if v10 then
            local v12 = t1.VALUES[math.clamp(p4, 1, #t1.VALUES)][v8]

            if not v12 then
                return nil
            end

            local STEP = t1.STEP

            return v12 * (#v9 > 1 and STEP[1] + (STEP[2] - STEP[1]) * (v10 - 1) / (#v9 - 1) or 1)
        end
    end

    return nil
end

t1.EASE = 2
t1.BAR_MOBILE = {
    {
        sweep = 0.8,
        green = 0.2033,
        yellow = 0.4873,
        ease = 1.5
    },
    {
        sweep = 0.72,
        green = 0.1925,
        yellow = 0.4651,
        ease = 1.5
    },
    {
        sweep = 0.648,
        green = 0.1821,
        yellow = 0.4437,
        ease = 1.5
    },
    {
        sweep = 0.583,
        green = 0.1723,
        yellow = 0.4232,
        ease = 1.5
    },
    {
        sweep = 0.525,
        green = 0.163,
        yellow = 0.4035,
        ease = 1.5
    },
    {
        sweep = 0.472,
        green = 0.1543,
        yellow = 0.3846,
        ease = 1.5
    },
    {
        sweep = 0.425,
        green = 0.1459,
        yellow = 0.3664,
        ease = 1.5
    },
    {
        sweep = 0.383,
        green = 0.1379,
        yellow = 0.3491,
        ease = 1.5
    },
    {
        sweep = 0.344,
        green = 0.1305,
        yellow = 0.3325,
        ease = 1.5
    }
}
t1.BAR = {
    {
        sweep = 0.8,
        green = 0.1639,
        yellow = 0.3986,
        ease = 1.5
    },
    {
        sweep = 0.72,
        green = 0.1551,
        yellow = 0.3799,
        ease = 1.5
    },
    {
        sweep = 0.648,
        green = 0.1467,
        yellow = 0.362,
        ease = 1.5
    },
    {
        sweep = 0.583,
        green = 0.1387,
        yellow = 0.3448,
        ease = 1.5
    },
    {
        sweep = 0.525,
        green = 0.1312,
        yellow = 0.3284,
        ease = 1.5
    },
    {
        sweep = 0.472,
        green = 0.1241,
        yellow = 0.3127,
        ease = 1.5
    },
    {
        sweep = 0.425,
        green = 0.1173,
        yellow = 0.2976,
        ease = 1.5
    },
    {
        sweep = 0.383,
        green = 0.1109,
        yellow = 0.2833,
        ease = 1.5
    },
    {
        sweep = 0.344,
        green = 0.1049,
        yellow = 0.2696,
        ease = 1.5
    }
}

function t1.Bar(p5, p6) -- line: 198
    -- upvalues: t1 (copy)
    local BAR_MOBILE = p6 and t1.BAR_MOBILE or t1.BAR

    return BAR_MOBILE[math.clamp(p5, 1, #BAR_MOBILE)]
end

function t1.Ticker(p7, p8, p9) -- line: 202
    -- upvalues: t1 (copy)
    local v14 = t1.Bar(p7, p9)
    local v15 = math.max(p8, 0) / v14.sweep % 2

    if v15 > 1 then
        v15 = 2 - v15
    end

    local v16 = v14.ease or t1.EASE

    return (v15 < 0.5 and 0.5 * (2 * v15) ^ v16 or 1 - 0.5 * (2 - 2 * v15) ^ v16) * 2 - 1
end

function t1.Judge(p10, p11, p12) -- line: 211
    -- upvalues: t1 (copy)
    local v17 = t1.Bar(p10, p12)
    local v18 = math.abs(p11)

    if v18 <= v17.green then
        return 3
    end

    if v18 <= v17.yellow then
        return 1
    end

    return 0
end

t1.SWIM = {
    turn = 12,
    bank = 0.4,
    display = true,
    BAND = 22,
    speed = { 33, 39 },
    radius = { 34, 26 },
    charge = { 5, 8 },
    RISE = {
        inside = 6,
        high = 10,
        time = 0.35,
        lean = 0.12
    }
}

function t1.Times(p13, p14) -- line: 224
    -- upvalues: t1 (copy)
    local RUN = t1.RUN
    local t3 = {
        t0 = p13
    }

    if p14 then
        t3.bonzoAt = p13 + RUN.BONZO_AT
        t3.bonzoEnd = t3.bonzoAt + #RUN.BONZO * RUN.LINE
        t3.leaveAt = t3.bonzoEnd
        t3.openAt = t3.bonzoEnd + RUN.BONZO_OUT + RUN.GAP
    else
        t3.leaveAt = p13
        t3.openAt = p13 + RUN.SETTLE
    end

    t3.popAt = t3.openAt + RUN.BUILD
    t3.catchEnd = t3.popAt + RUN.CATCH

    return t3
end

t1.HAT = "Turkey"
t1.HAT_CHANCE = 0.06666666666666667

function t1.HatChance(p15) -- line: 248
    -- upvalues: t1 (copy)
    return t1.On(p15) and t1.HAT_CHANCE or 0
end

function t1.HatPart(p16) -- line: 250
    -- upvalues: t1 (copy)
    local v19 = game:GetService("ReplicatedStorage"):FindFirstChild(if p16 == t1.HAT then "ThanksgivingProps" else "HalloweenProps")

    if not v19 then
        return v19
    end

    return (v19:FindFirstChild(if p16 == t1.HAT then "TurkeyHat" else "WitchHat"))
end

function t1.HatIcon(p17) -- line: 256
    -- upvalues: t1 (copy)
    local v20 = t1.HatPart(p17)

    return v20 and v20:GetAttribute("Icon") or ""
end

function t1.Now() -- line: 262
    return workspace:GetServerTimeNow()
end

function t1.Phase(p18) -- line: 267
    -- upvalues: t1 (copy)
    local ThanksgivingTest = workspace:GetAttribute("ThanksgivingTest")

    if ThanksgivingTest == true then
        return "on"
    end

    if ThanksgivingTest ~= "grace" then
        if ThanksgivingTest == "over" then
            return nil
        end

        local v21 = p18 or t1.Now()

        if t1.STARTS <= v21 and v21 < t1.ENDS then
            return "on"
        end

        if not (t1.ENDS <= v21 and v21 < t1.GRACE_ENDS) then
            return nil
        end
    end

    return "grace"
end

function t1.On(p19) -- line: 279
    -- upvalues: t1 (copy)
    return t1.Phase(p19) == "on"
end

function t1.TicketsLive(p20) -- line: 281
    -- upvalues: t1 (copy)
    return t1.Phase(p20) ~= nil
end

function t1.Expired(p21) -- line: 283
    -- upvalues: t1 (copy)
    local ThanksgivingTest = workspace:GetAttribute("ThanksgivingTest")

    if ThanksgivingTest == "over" then
        return true
    end

    return ThanksgivingTest == nil and (p21 or t1.Now()) >= t1.GRACE_ENDS
end

function t1.Left(p22) -- line: 291
    -- upvalues: t1 (copy)
    p22 = p22 or t1.Now()

    local v23 = t1.Phase(p22)
    local v24, v25

    if v23 == "on" then
        local ENDS = t1.ENDS

        if ENDS then
            v24 = ENDS
            v25 = true
        elseif v23 == "grace" then
            local GRACE_ENDS = t1.GRACE_ENDS

            if GRACE_ENDS then
                v24 = GRACE_ENDS
                v25 = true
            else
                v25 = false
            end
        else
            v25 = false
        end
    elseif v23 == "grace" then
        local GRACE_ENDS = t1.GRACE_ENDS

        if GRACE_ENDS then
            v24 = GRACE_ENDS
            v25 = true
        else
            v25 = false
        end
    else
        v25 = false
    end

    if not v25 then
        v24 = nil
    end

    if not v24 then
        return 0
    end

    local v26 = v24 - p22

    if v26 <= 0 then
        v26 = 86400
    end

    return v26
end

return t1
