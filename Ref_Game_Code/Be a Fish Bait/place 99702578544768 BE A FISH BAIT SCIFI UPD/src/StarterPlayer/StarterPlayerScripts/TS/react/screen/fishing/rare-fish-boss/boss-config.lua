-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local t1 = {
    initialProgress = 55,
    maxProgress = 100,
    drainPerSecond = 7,
    perfectProgressGain = 20,
    greatProgressGain = 15,
    okayProgressGain = 10,
    missProgressPenalty = 4,
    timeoutProgressPenalty = 4,
    slideProgressBonus = 4,
    enableSlidePrompts = true,
    tap = {
        size = 120,
        approachRingWidth = 6,
        innerBorderWidth = 4,
        hitboxMultiplier = 1.8,
        lateGraceMs = 420,
        perfectWindowMs = 150,
        greatWindowMs = 300,
        okayWindowMs = 480,
        lateOkayWindowMs = 340
    },
    slide = {
        startSize = 124,
        endSize = 104,
        pathWidth = 76,
        pathTolerance = 120,
        spanDistance = 250,
        completeWindowMs = 1100,
        perfectFraction = 0.55,
        greatFraction = 0.8,
        grabWindowMs = 1500,
        approachRingWidth = 6
    }
}
local t2 = {
    countdownStepMs = 1000,
    goDurationMs = 500,
    flipDurationSec = 1.75,
    vfxDurationSec = 0.5,
    vfxName = "AutokillSmiteVFX",
    sfxCue = "Smite",
    countdownSteps = { "3", "2", "1", "GO!" }
}
local t3 = {
    struggle = 0.35,
    rage = 0.75
}

local function getBossPhase(p1) -- line: 52
    -- upvalues: t3 (copy)
    if t3.rage <= p1 then
        return "rage"
    end

    if t3.struggle <= p1 then
        return "struggle"
    end

    return "intro"
end

local t4 = {
    intro = {
        slideChance = 0,
        spawnDelayMs = 360,
        tapDurationMs = 1050
    },
    struggle = {
        slideChance = 0.25,
        spawnDelayMs = 280,
        tapDurationMs = 900
    },
    rage = {
        slideChance = 0.35,
        spawnDelayMs = 220,
        tapDurationMs = 760
    }
}
local t5 = {
    brace = "BRACE",
    counter = "COUNTER",
    punch = "PUNCH",
    slap = "SLAP",
    surge = "SURGE",
    yank = "YANK"
}
local t6 = {
    "punch",
    "slap",
    "counter"
}
local t7 = {
    "yank",
    "surge"
}

local function pickBossAction(p2, p3) -- line: 98
    -- upvalues: t6 (copy), t7 (copy)
    local v1 = if p2 == "slide" then t7 else t6

    if p3 and p2 == "tap" and math.random() < 0.25 then
        return "brace"
    end

    return v1[math.random(0, #v1 - 1) + 1]
end

local t8 = {
    {
        id = "mouth",
        x = 0,
        y = -0.1,
        z = -0.78
    },
    {
        id = "body",
        x = 0,
        y = 0,
        z = 0
    },
    {
        id = "left",
        x = -0.7,
        y = 0,
        z = 0.1
    },
    {
        id = "right",
        x = 0.7,
        y = 0,
        z = 0.1
    },
    {
        id = "upper",
        x = 0,
        y = 0.7,
        z = -0.1
    },
    {
        id = "tail",
        x = 0,
        y = 0.05,
        z = 0.78
    }
}
local v2 = table.create(#t8)

local function v3(p4) -- line: 144
    return p4.id
end

for v4, v5 in t8 do
    local _ = v4 - 1

    v2[v4] = v5.id
end

return {
    bossIntroTapCount = 2,
    getBossPhase = getBossPhase,
    pickBossAction = pickBossAction,
    bossTuning = t1,
    bossAutokillTuning = t2,
    bossPhaseThresholds = t3,
    bossPhasePacing = t4,
    bossActionLabels = t5,
    tapActions = t6,
    slideActions = t7,
    weakSpotOffsets = t8,
    allWeakSpotIds = v2
}
