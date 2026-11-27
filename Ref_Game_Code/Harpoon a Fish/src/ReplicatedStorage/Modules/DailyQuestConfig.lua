-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local TableConfig = require(script.Parent:WaitForChild("TableConfig"))
local t1 = {
    DAY = 86400,
    WEEK = 604800,
    WEEK_ANCHOR = DateTime.fromUniversalTime(2026, 10, 31, 18).UnixTimestamp,
    BITES_PER_MIN = TableConfig.BITES_PER_SECOND * 60,
    DAILY = {
        {
            {
                kind = "zone",
                need = 20
            },
            {
                kind = "rarity",
                need = 1,
                rarity = "Epic"
            }
        },
        {
            {
                kind = "eat",
                need = 5
            }
        },
        {
            {
                kind = "feed",
                need = 3
            },
            {
                kind = "grow",
                need = 3
            }
        }
    },
    DAILY_SECS = 90,
    BONUS = {
        egg = "MassiveEgg"
    },
    WEEKLY = {
        {
            kind = "eat",
            need = 30,
            reward = {
                fat = 1200
            }
        },
        {
            kind = "catch",
            need = 150,
            reward = {
                key = "Secret"
            }
        },
        {
            kind = "dailies",
            need = 10,
            reward = {
                egg = "VoidEgg"
            }
        }
    }
}

function t1.Day(p1) -- line: 41
    -- upvalues: t1 (copy)
    return (math.floor(p1 / t1.DAY))
end

function t1.Week(p2) -- line: 42
    -- upvalues: t1 (copy)
    return (math.floor((p2 - t1.WEEK_ANCHOR) / t1.WEEK))
end

function t1.DayEnds(p3) -- line: 43
    -- upvalues: t1 (copy)
    return (p3 + 1) * t1.DAY
end

function t1.WeekEnds(p4) -- line: 44
    -- upvalues: t1 (copy)
    return t1.WEEK_ANCHOR + (p4 + 1) * t1.WEEK
end

function t1.Needed(p5, p6) -- line: 46
    -- upvalues: t1 (copy)
    return p5 == "eat" and p6 * t1.BITES_PER_MIN or p6
end

function t1.Shown(p7, p8) -- line: 48
    -- upvalues: t1 (copy)
    if p7 ~= "eat" then
        return p8
    end

    return math.floor(p8 / t1.BITES_PER_MIN) or p8
end

return t1
