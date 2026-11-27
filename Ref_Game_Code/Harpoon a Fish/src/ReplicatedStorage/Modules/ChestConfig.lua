-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local t1 = {
    DURATION = 120,
    OPEN_TIME = 0.22,
    OPEN_ANGLE = 105,
    POP_AT = 0.18,
    RISE_TIME = 0.35,
    HOVER_TIME = 1,
    FLY_TIME = 0.45,
    CLOSE_TIME = 0.18
}

t1.FLY_AT = t1.POP_AT + t1.RISE_TIME + t1.HOVER_TIME
t1.TOTAL = t1.FLY_AT + t1.FLY_TIME
t1.RISE = 3.2
t1.ICON_SIZE = 2.6

local KeyConfig = require(script.Parent:WaitForChild("KeyConfig"))

t1.REWARDS = {
    {
        id = "Wood",
        chance = 15,
        key = true
    },
    {
        id = "Stone",
        chance = 5,
        key = true
    },
    {
        id = "Gold",
        chance = 2.5,
        key = true
    },
    {
        id = "Ruby",
        chance = 1,
        key = true
    },
    {
        id = "Diamond",
        chance = 1,
        key = true
    },
    {
        id = "Secret",
        chance = 0.5,
        key = true
    },
    {
        id = "T1",
        chance = 3,
        potion = true,
        rect = { 312, 150, 711, 875 }
    },
    {
        id = "T2",
        chance = 1,
        potion = true,
        rect = { 194, 164, 821, 861 }
    },
    {
        id = "B1",
        chance = 2,
        potion = true,
        rect = { 194, 164, 821, 861 }
    },
    {
        id = "B2",
        chance = 0.5,
        potion = true,
        rect = { 114, 32, 911, 991 }
    },
    {
        id = "XP",
        chance = 68.5,
        xp = 50,
        image = "rbxassetid://137513422393347",
        rect = { 61, 85, 963, 929 }
    }
}
t1.FIRST = "Stone"
t1.BY_ID = {}

local PotionConfig = require(script.Parent:WaitForChild("PotionConfig"))

for _, v1 in ipairs(t1.REWARDS) do
    if v1.key then
        local image, rect = KeyConfig.KEYS[v1.id].image, KeyConfig.KEYS[v1.id].rect

        v1.image = image
        v1.rect = rect
    end

    if v1.potion then
        v1.image = PotionConfig.Get(v1.id).icon
    end

    t1.BY_ID[v1.id] = v1
end

t1.OFFER_AT = 4
t1.OFFER_WINDOW = 604800
t1.BY_ID.Ultimate = {
    id = "Ultimate",
    offer = true,
    image = "rbxassetid://82153343893566",
    rect = { 0, 0, 0, 0 }
}

function t1.Roll(p1) -- line: 70
    -- upvalues: t1 (copy)
    local v2 = p1:NextNumber(0, 100)

    for _, v3 in ipairs(t1.REWARDS) do
        v2 -= v3.chance

        if v2 < 0 then
            return v3
        end
    end

    return t1.REWARDS[#t1.REWARDS]
end

t1.TEASE = {
    BREATH = 1,
    KICK_MIN = 2,
    KICK_MAX = 10,
    ROCK = 0.3,
    HARD = 1.6,
    CRACK_FULL = 8,
    CRACK_LIGHT = 1.2,
    DECAY = 9,
    FREQ = 22,
    GAP_CURVE = 2,
    SPRING_FREQ = 22,
    SPRING_DAMP = 0.5,
    KNOCK_1 = "rbxassetid://78520741568129",
    KNOCK_2 = "rbxassetid://109462965921403",
    KNOCK_3 = "rbxassetid://128614947180643",
    WINDOW = t1.DURATION,
    GLINTS = { 2, 6 },
    GAP = { 9, 0.35 },
    VOL = { 0.2, 0.9 }
}
t1.SOUNDS = {
    Open = "rbxassetid://116841971399984",
    Pop = "rbxassetid://873617644",
    Close = "rbxassetid://79297483068780"
}

return t1
