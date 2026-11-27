-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local fromRGB = Color3.fromRGB
local t1 = {
    FIRST_DELAY = { 180, 300 },
    GAP = { 360, 600 },
    TICK = 10,
    List = {
        {
            id = "rain",
            name = "Rain",
            icon = "🌧️",
            mutation = "Soaked",
            mult = 2,
            weight = 40,
            chance = 0.008,
            duration = 120,
            Color = fromRGB(110, 180, 255),
            fx = {
                fall = "rain",
                brightness = -0.03,
                saturation = -0.2,
                tint = fromRGB(200, 212, 232)
            }
        },
        {
            id = "snow",
            name = "Snowfall",
            icon = "❄️",
            mutation = "Frozen",
            mult = 3,
            weight = 26,
            chance = 0.008,
            duration = 120,
            Color = fromRGB(200, 240, 255),
            fx = {
                fall = "snow",
                brightness = 0.02,
                saturation = -0.2,
                tint = fromRGB(225, 240, 255)
            }
        },
        {
            id = "storm",
            name = "Thunderstorm",
            icon = "⚡",
            mutation = "Shocked",
            mult = 5,
            weight = 15,
            chance = 0.007,
            duration = 120,
            Color = fromRGB(255, 235, 90),
            fx = {
                fall = "rain",
                brightness = -0.08,
                saturation = -0.3,
                flashes = true,
                tint = fromRGB(176, 184, 206)
            }
        },
        {
            id = "aurora",
            name = "Aurora",
            icon = "🌌",
            mutation = "Radiant",
            mult = 10,
            weight = 9,
            chance = 0.006,
            duration = 150,
            Color = fromRGB(120, 255, 190),
            fx = {
                fall = "sparkle",
                brightness = 0,
                tint = fromRGB(205, 255, 235)
            }
        },
        {
            id = "meteor",
            name = "Meteor Shower",
            icon = "☄️",
            mutation = "Meteoric",
            mult = 25,
            weight = 5.5,
            chance = 0.006,
            duration = 150,
            Color = fromRGB(255, 150, 70),
            fx = {
                fall = "meteor",
                brightness = -0.04,
                tint = fromRGB(255, 218, 190)
            }
        },
        {
            id = "bloodmoon",
            name = "Blood Moon",
            icon = "🌕",
            mutation = "Cursed",
            mult = 60,
            weight = 3,
            chance = 0.005,
            duration = 180,
            Color = fromRGB(255, 70, 80),
            fx = {
                fall = "ember",
                brightness = -0.05,
                saturation = 0.1,
                tint = fromRGB(255, 160, 160)
            }
        },
        {
            id = "eclipse",
            name = "Solar Eclipse",
            icon = "🌑",
            mutation = "Eclipsed",
            mult = 150,
            weight = 1.5,
            chance = 0.005,
            duration = 180,
            Color = fromRGB(190, 120, 255),
            fx = {
                fall = "sparkle",
                brightness = -0.04,
                saturation = -0.1,
                tint = fromRGB(190, 170, 235)
            }
        },
        {
            id = "cosmic",
            name = "Cosmic Storm",
            icon = "💫",
            mutation = "Cosmic",
            mult = 300,
            weight = 0,
            chance = 0,
            duration = 0,
            special = true,
            Color = fromRGB(150, 200, 255),
            fx = {
                fall = "sparkle",
                brightness = 0,
                tint = fromRGB(210, 200, 255)
            }
        },
        {
            id = "meteorstrike",
            name = "Meteor Strike",
            icon = "☄️",
            mutation = "Meteoric",
            mult = 100,
            weight = 0,
            admin = true,
            chance = 0.005,
            duration = 180,
            Color = fromRGB(255, 180, 60),
            panel = {
                top = fromRGB(70, 42, 20),
                bottom = fromRGB(32, 18, 8),
                title = fromRGB(255, 186, 64)
            },
            fx = {
                kit = "MeteorAdminAbuse"
            }
        },
        {
            id = "lightningrodeo",
            name = "Lightning Rodeo",
            icon = "⚡",
            mutation = "Charged",
            mult = 80,
            weight = 0,
            admin = true,
            chance = 0.005,
            duration = 180,
            Color = fromRGB(255, 228, 60),
            panel = {
                top = fromRGB(52, 60, 74),
                bottom = fromRGB(22, 26, 34),
                title = fromRGB(255, 228, 50)
            },
            fx = {
                kit = "LightningAdminAbuse",
                strikes = { 7, 9 }
            }
        }
    },
    ById = {}
}
local n1 = 0
local n2 = 0

for v1, v2 in ipairs(t1.List) do
    v2.index = v1
    t1.ById[v2.id] = v2

    if not v2.special then
        n2 += v2.weight
        n1 = n2
    end
end

t1.TotalWeight = n2

function t1.Pick(p1) -- line: 57
    -- upvalues: t1 (copy), n1 (ref)
    local v4 = p1:NextNumber() * n1

    for _, v5 in ipairs(t1.List) do
        if not v5.special and v5.weight > 0 then
            v4 -= v5.weight

            if v4 <= 0 then
                return v5
            end
        end
    end

    return t1.List[1]
end

return t1
