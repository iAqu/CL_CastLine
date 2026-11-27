-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local WeatherConfig = require(script.Parent:WaitForChild("WeatherConfig"))
local t1 = {
    START = 1793466000
}

t1.END = t1.START + 2175
t1.COUNTDOWN = 1800
t1.BONUS_AT = 31
t1.FAT = 3
t1.LUCK = 2
t1.CHESTS = {
    FROM = 55,
    EVERY = 30,
    TO = 325
}
t1.RISES = { 460, 905, 1350 }
t1.PICKS = { "Charybdis", "Aspidochelone", "Karkinos" }
t1.HOUR_PINS = {
    [1794076200] = {
        titan = "Umibozu",
        shiny = true
    },
    [1794681000] = {
        titan = "Charybdis",
        shiny = true
    },
    [1795285800] = {
        titan = "Karkinos",
        shiny = true
    },
    [1795890600] = {
        titan = "Charybdis",
        shiny = true
    },
    [1795894200] = {
        titan = "TitanJormungandr",
        shiny = true
    }
}
t1.LUCK_ICON = "rbxassetid://17368085294"
t1.LINES = {
    {
        at = -480,
        text = "the TITAN UPDATE is out!! the event starts in 8 minutes, stay here 👀",
        hold = 9
    },
    {
        at = -360,
        text = "waiting for everyone to join... invite your friends!",
        hold = 8
    },
    {
        at = -240,
        text = "something HUGE is waking up under the Cosmic zone... 😈",
        hold = 8
    },
    {
        at = -120,
        text = "2 minutes until the TITAN UPDATE event!",
        hold = 8
    },
    {
        at = -45,
        text = "almost time... 👀",
        hold = 6
    },
    {
        at = 0,
        text = "hi everyone :D",
        hold = 7
    },
    {
        at = 9,
        text = "welcome to the TITAN UPDATE event!! 🎉",
        hold = 8
    },
    {
        at = 19,
        text = "this is NOT an admin abuse, just a chill party for the new update",
        hold = 10
    },
    {
        at = 31,
        text = "here's X3 FAT and X2 MUTATION LUCK for the whole event 🍔🍀",
        hold = 10
    },
    {
        at = 43,
        text = "and it's Halloween... so let's pop some PUMPKIN CHESTS 🎃",
        hold = 9
    },
    {
        at = 57,
        text = "a pumpkin chest opens every 30 seconds for the next 5 minutes!",
        hold = 9
    },
    {
        at = 75,
        text = "still waiting for people to join, the first TITAN rises in about 6 minutes 👀",
        hold = 9
    },
    {
        at = 120,
        text = "dive down and grab those Halloween fish!",
        hold = 7
    },
    {
        at = 140,
        text = "invite your friends, you don't want them to miss the TITANS 😈",
        hold = 8
    },
    {
        at = 170,
        text = "have you seen what's moving under the Cosmic zone's boards? 👀",
        hold = 8
    },
    {
        at = 210,
        text = "who got a Halloween fish? 👀",
        hold = 7
    },
    {
        at = 235,
        text = "the first TITAN rises in about 4 minutes... get ready 😈",
        hold = 8
    },
    {
        at = 265,
        text = "5 giant TITANS... which one will you capture? 👀",
        hold = 8
    },
    {
        at = 300,
        text = "last pumpkin coming up...",
        hold = 6
    },
    {
        at = 330,
        text = "that was the last pumpkin chest! 🎃",
        hold = 7
    },
    {
        at = 339,
        text = "now... let's wake up the TITANS 😈",
        hold = 8,
        red = true
    },
    {
        at = 349,
        text = "TITANS will keep rising one after another until the end of the event!",
        hold = 10
    },
    {
        at = 362,
        text = "harpoon it as it rises through your zone and hold on!",
        hold = 8
    },
    {
        at = 373,
        text = "first one to fill their bar captures it!",
        hold = 8
    },
    {
        at = 420,
        text = "TITAN #1 INCOMING! 👀",
        hold = 7,
        red = true
    },
    {
        at = 429,
        text = "WHEN YOU SEE IT SHOOT IT! DON'T MISS IT!",
        hold = 8,
        red = true
    },
    {
        at = 802,
        text = "GG!! next TITAN coming up 👀",
        hold = 8
    },
    {
        at = 840,
        text = "get back on your harpoons!",
        hold = 7
    },
    {
        at = 868,
        text = "TITAN #2 INCOMING!",
        hold = 7,
        red = true
    },
    {
        at = 1247,
        text = "GG!! another one is already on its way 😈",
        hold = 8
    },
    {
        at = 1285,
        text = "the X3 FAT and X2 MUTATION LUCK are still on!",
        hold = 8
    },
    {
        at = 1313,
        text = "TITAN #3 INCOMING!",
        hold = 7,
        red = true
    },
    {
        at = 1692,
        text = "GG!! one more TITAN for the event 👀",
        hold = 9
    },
    {
        at = 1740,
        text = "last Titan of the event, make it count!",
        hold = 8,
        red = true
    },
    {
        at = 2140,
        text = "GG everyone!! thank you for playing the TITAN UPDATE ❤️",
        hold = 9
    },
    {
        at = 2152,
        text = "a TITAN rises every hour, good luck capturing one!",
        hold = 9
    },
    {
        at = 2164,
        text = "the event's over, have fun :D",
        hold = 8
    }
}

function t1.Now() -- line: 116
    -- upvalues: WeatherConfig (copy)
    return WeatherConfig.Now()
end

function t1.Since(p1) -- line: 120
    -- upvalues: WeatherConfig (copy), t1 (copy)
    return (p1 or WeatherConfig.Now()) - t1.START
end

function t1.Bonus(p2) -- line: 124
    -- upvalues: WeatherConfig (copy), t1 (copy)
    p2 = p2 or WeatherConfig.Now()

    if t1.START + t1.BONUS_AT <= p2 then
        return p2 < t1.END
    end

    return false
end

function t1.FatMul(p3) -- line: 128
    -- upvalues: t1 (copy)
    return t1.Bonus(p3) and t1.FAT or 1
end

function t1.LuckMul(p4) -- line: 129
    -- upvalues: t1 (copy)
    return t1.Bonus(p4) and t1.LUCK or 1
end

local t2 = {}

for v2, v3 in ipairs(t1.RISES) do
    t2[v2] = t1.START + v3
end

function t1.Rises() -- line: 133
    -- upvalues: t2 (copy)
    return t2
end

local t3 = {}

for v4, v5 in ipairs(t1.RISES) do
    t3[t1.START + v5] = t1.PICKS[v4]
end

function t1.PickOf(p5) -- line: 139
    -- upvalues: t1 (copy), t3 (copy)
    local v6 = t1.HOUR_PINS[p5]

    return t3[p5] or v6 and v6.titan
end

function t1.ShinyOf(p6) -- line: 144
    -- upvalues: t1 (copy)
    local v7 = t1.HOUR_PINS[p6]

    return if v7 and v7.shiny ~= nil then v7.shiny == true else nil
end

function t1.Test(p7) -- line: 152
    -- upvalues: WeatherConfig (copy), t1 (copy)
    if p7 == false then
        return WeatherConfig.Test(false)
    end

    local v9 = tonumber(p7) or 0

    workspace:SetAttribute("WeatherForce", nil)
    workspace:SetAttribute("WeatherReal", nil)
    workspace:SetAttribute("HalloweenTest", nil)
    workspace:SetAttribute("WeatherOffset", t1.START - v9 - workspace:GetServerTimeNow())

    return ("titan event: START in %d s on this server"):format(v9)
end

return t1
