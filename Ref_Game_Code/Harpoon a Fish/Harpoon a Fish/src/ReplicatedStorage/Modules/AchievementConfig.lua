-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local t1 = {
    ORDER = { "Completionist", "Deadeye", "Thief", "Caretaker", "Glutton", "Extinctionist", "HighRoller" },
    COMPLETIONIST_ZONES = 10,
    TRACKS = {
        Deadeye = {
            name = "Deadeye",
            color = Color3.fromRGB(235, 20, 20),
            tiers = {
                3, 10, 25, 50, 100, 200, 400, 750,
                1500, 3000
            }
        },
        Thief = {
            name = "Thief",
            color = Color3.fromRGB(32, 32, 36),
            tiers = {
                1, 3, 5, 10, 20, 40, 75, 125,
                250, 500
            }
        },
        Caretaker = {
            name = "Caretaker",
            color = Color3.fromRGB(25, 200, 50),
            tiers = {
                1, 3, 5, 10, 20, 35, 50, 100,
                175, 250
            }
        },
        Completionist = {
            name = "Completionist",
            perZone = true,
            color = Color3.fromRGB(20, 115, 255)
        },
        Glutton = {
            name = "Glutton",
            color = Color3.fromRGB(255, 125, 0),
            tiers = {
                300, 900, 1800, 3600, 7200, 14400, 21600, 36000,
                57600, 86400
            }
        },
        Extinctionist = {
            name = "Extinctionist",
            color = Color3.fromRGB(145, 40, 255),
            tiers = {
                15, 35, 75, 150, 300, 500, 1000, 2500,
                5000, 10000
            }
        },
        HighRoller = {
            name = "High Roller",
            color = Color3.fromRGB(18, 125, 52),
            tiers = {
                1, 100, 300, 500, 1000, 1500, 2500, 5000,
                10000, 25000
            }
        }
    },
    DEADEYE_MIN_BEATS = 3,
    PERKS = {
        Deadeye = {
            text = "HIT ZONE +%s%% A HIT",
            zero = "HIT ZONE STOPS SHRINKING",
            shortZero = "NO SHRINK",
            list = {
                0, 0.5, 1, 1.5, 2, 2.5, 3, 3.5,
                4, 5
            }
        },
        Thief = {
            text = "+%s%% SECOND CHANCE IN VS",
            list = {
                2, 4, 7, 10, 14, 19, 25, 32,
                40, 50
            }
        },
        Caretaker = {
            text = "+%s%% GROW SPEED",
            list = {
                1, 2.5, 5, 8, 12, 17, 23, 31,
                40, 50
            }
        },
        Completionist = {
            per = 1,
            text = "+%s BAG SLOTS",
            one = "+1 BAG SLOT",
            short = "+%s BAGS",
            shortOne = "+1 BAG"
        },
        Glutton = {
            text = "+%s%% FAT",
            list = {
                1, 2.5, 5, 8, 12, 17, 23, 31,
                40, 50
            }
        },
        Extinctionist = {
            text = "+%s%% MUTATION CHANCE",
            list = {
                1, 2.5, 5, 8, 12, 17, 23, 31,
                40, 50
            }
        },
        HighRoller = {
            text = "%sx MONEY",
            short = "%sx",
            list = {
                1.1, 1.2, 1.4, 1.6, 2, 2.5, 3, 3.5,
                4, 5
            }
        }
    }
}

function t1.Bonus(p1, p2) -- line: 82
    -- upvalues: t1 (copy)
    local v1 = t1.PERKS[p1]

    if not v1 or p2 <= 0 then
        return 0
    end

    if not v1.list then
        return v1.per * p2
    end

    return v1.list[math.min(p2, #v1.list)]
end

function t1.BonusText(p3, p4) -- line: 89
    -- upvalues: t1 (copy)
    local v3 = t1.PERKS[p3]

    if not v3 then
        return ""
    end

    local v4 = t1.Bonus(p3, (math.max(p4, 1)))

    if v3.one and v4 == 1 then
        return v3.one
    end

    if not v3.zero or v4 ~= 0 then
        return string.format(v3.text, t1.Num(v4))
    end

    return v3.zero
end

function t1.Num(p5) -- line: 98
    if math.abs(p5 - math.round(p5)) < 1E-06 then
        return (tostring((math.round(p5))))
    end

    return (string.format("%.2f", p5):gsub("0+$", ""))
end

function t1.BonusShort(p6, p7) -- line: 104
    -- upvalues: t1 (copy)
    local v7 = t1.PERKS[p6]

    if not v7 then
        return ""
    end

    local v8 = t1.Bonus(p6, (math.max(p7, 1)))

    if v7.shortOne and v8 == 1 then
        return v7.shortOne
    end

    if not v7.shortZero or v8 ~= 0 then
        return string.format(v7.short or "+%s%%", t1.Num(v8))
    end

    return v7.shortZero
end

t1.TRUE = {
    key = "TrueHarpooner",
    name = "True Harpooner",
    rainbow = true,
    fish = "Rainbowborous",
    needs = { "Deadeye", "Thief", "Caretaker", "Completionist", "Glutton", "Extinctionist" }
}
t1.NUMERALS = {
    "I",
    "II",
    "III",
    "IV",
    "V",
    "VI",
    "VII",
    "VIII",
    "IX",
    "X"
}
t1.TITLE_RAINBOW = {
    Color3.fromRGB(255, 70, 70),
    Color3.fromRGB(255, 170, 40),
    Color3.fromRGB(255, 235, 60),
    Color3.fromRGB(70, 220, 110),
    Color3.fromRGB(60, 150, 255),
    Color3.fromRGB(175, 90, 255)
}

local function hex(p8) -- line: 128
    return string.format("#%02X%02X%02X", math.round(p8.R * 255), math.round(p8.G * 255), (math.round(p8.B * 255)))
end

function t1.TitleText(p9, p10) -- line: 132
    -- upvalues: t1 (copy)
    if p9 == t1.TRUE.key then
        return string.upper(t1.TRUE.name)
    end

    local v14 = t1.TRACKS[p9]
    local v15, v16

    if v14 and type(p10) == "number" and not (p10 <= 0) then
        v15 = string.upper(v14.name)
        v16 = t1.NUMERALS[p10] or tostring(p10)

        return v15 .. " " .. v16
    end

    return nil
end

function t1.TitleRich(p11, p12, p13) -- line: 138
    -- upvalues: t1 (copy)
    local v17 = t1.TitleText(p11, p12)

    if not v17 then
        return nil
    end

    local v18 = "[" .. v17 .. "]"

    if p11 == t1.TRUE.key then
        local t2 = {}
        local TITLE_RAINBOW = t1.TITLE_RAINBOW
        local n1 = 0

        for match in v18:gmatch(".") do
            if match == " " then
                table.insert(t2, match)
            else
                n1 += 1

                local format = string.format
                local v19 = TITLE_RAINBOW[(n1 - 1) % #TITLE_RAINBOW + 1]

                table.insert(t2, format("<font color=\"%s\">%s</font>", string.format("#%02X%02X%02X", math.round(v19.R * 255), math.round(v19.G * 255), (math.round(v19.B * 255))), match))
            end
        end

        return table.concat(t2)
    end

    local color = t1.TRACKS[p11].color

    if p13 and 0.299 * color.R + 0.587 * color.G + 0.114 * color.B < 0.2 then
        color = color:Lerp(Color3.new(1, 1, 1), 0.5)
    end

    return string.format("<font color=\"%s\">%s</font>", string.format("#%02X%02X%02X", math.round(color.R * 255), math.round(color.G * 255), (math.round(color.B * 255))), v18)
end

function t1.Tiers(p14) -- line: 160
    -- upvalues: t1 (copy)
    local v31 = t1.TRACKS[p14]

    if not (v31 and v31.perZone) then
        local tiers = if v31 then v31.tiers else nil

        if not v31 or not tiers then
            tiers = {}
        end

        return tiers
    end

    local t3 = {}

    for i = 1, t1.COMPLETIONIST_ZONES do
        t3[i] = i
    end

    return t3
end

function t1.TierOf(p15, p16) -- line: 171
    -- upvalues: t1 (copy)
    local n2 = 0

    for v32, v33 in ipairs(t1.Tiers(p15)) do
        if not (v33 <= p16) then
            break
        end

        n2 = v32
    end

    return n2
end

function t1.MaxTier(p17) -- line: 179
    -- upvalues: t1 (copy)
    return #t1.Tiers(p17)
end

return t1
