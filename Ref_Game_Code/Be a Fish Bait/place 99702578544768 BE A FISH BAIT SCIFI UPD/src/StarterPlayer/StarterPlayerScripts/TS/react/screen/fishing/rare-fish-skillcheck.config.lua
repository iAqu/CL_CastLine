-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local t1 = {
    approachRingWidth = 6,
    hitboxMultiplier = 1.25,
    innerBorderWidth = 4,
    size = 126,
    targetDurationMs = 700,
    spawnDelayMs = 100,
    lateGraceMs = 230,
    perfectWindowMs = 80,
    greatWindowMs = 160,
    okayWindowMs = 270,
    lateOkayWindowMs = 170,
    initialProgress = 35,
    maxProgress = 100,
    drainPerSecond = 10.5,
    perfectProgressGain = 12,
    greatProgressGain = 9,
    okayProgressGain = 5,
    missProgressPenalty = 12,
    timeoutProgressPenalty = 14,
    playAreaWidth = 720,
    playAreaHeight = 420,
    countdownEndScale = 1.55,
    countdownGoEndScale = 2.5,
    countdownGoMs = 1000,
    countdownStartScale = 0.45,
    countdownStepMs = 1000,
    barBorderThickness = 4,
    fishIconLeadOffset = 4,
    fishIconSize = 56,
    barBottomOffset = 72,
    barCornerRadius = 10,
    barHeight = 62,
    barTextureSpeed = 0.25,
    barWidth = 660
}
local t2 = {
    approachRing = Color3.fromRGB(255, 255, 255),
    innerBorder = Color3.fromRGB(20, 15, 10),
    innerFill = Color3.fromRGB(90, 70, 50),
    innerPerfectBorder = Color3.fromRGB(0, 0, 0),
    innerPerfectFill = Color3.fromRGB(0, 255, 97),
    innerPerfectGlow = Color3.fromRGB(10, 255, 94),
    barTrack = Color3.fromRGB(20, 20, 20),
    barFillDangerDark = Color3.fromRGB(170, 25, 25),
    barFillDangerLight = Color3.fromRGB(255, 60, 60),
    barFillDangerDarkEnd = Color3.fromRGB(170, 70, 15),
    barFillDangerLightEnd = Color3.fromRGB(255, 130, 35),
    barFillMidDark = Color3.fromRGB(0, 110, 170),
    barFillMidLight = Color3.fromRGB(25, 195, 245),
    barFillHighDark = Color3.fromRGB(0, 120, 155),
    barFillHighLight = Color3.fromRGB(20, 195, 250),
    barFillHighDarkEnd = Color3.fromRGB(0, 155, 40),
    barFillHighLightEnd = Color3.fromRGB(90, 255, 100),
    barLabelPlaying = Color3.fromRGB(240, 220, 160),
    barLabelSuccess = Color3.fromRGB(80, 255, 110),
    barLabelFail = Color3.fromRGB(255, 80, 80),
    ratingMiss = Color3.fromRGB(255, 60, 60)
}
local t3 = {
    great = "great",
    okay = "good",
    perfect = "perfect"
}
local t4 = {
    great = 75,
    miss = 0,
    okay = 40,
    perfect = 100
}
local t5 = {
    brace = "BRACE",
    counter = "COUNTER",
    pull = "PULL",
    strike = "STRIKE",
    surge = "SURGE"
}

local function getActionLabel(p1) -- line: 86
    -- upvalues: t5 (copy)
    return t5[p1]
end

local t6 = {
    {
        actionType = "pull",
        greatWindowMs = 205,
        id = "heavy-pull",
        lateOkayWindowMs = 360,
        maxProgress = 65,
        okayWindowMs = 325,
        perfectWindowMs = 95,
        spawnDelayMs = 120,
        targetDurationMs = 1180,
        weight = 3
    },
    {
        actionType = "counter",
        greatWindowMs = 150,
        id = "quick-counter",
        lateOkayWindowMs = 300,
        okayWindowMs = 245,
        perfectWindowMs = 75,
        spawnDelayMs = 95,
        targetDurationMs = 820,
        weight = 3
    },
    {
        actionType = "brace",
        greatWindowMs = 180,
        id = "brace-thrash",
        lateOkayWindowMs = 340,
        okayWindowMs = 290,
        perfectWindowMs = 85,
        spawnDelayMs = 100,
        targetDurationMs = 1020,
        weight = 3
    },
    {
        actionType = "strike",
        greatWindowMs = 145,
        id = "precision-strike",
        lateOkayWindowMs = 285,
        okayWindowMs = 235,
        perfectWindowMs = 70,
        spawnDelayMs = 90,
        targetDurationMs = 880,
        weight = 2
    },
    {
        actionType = "surge",
        greatWindowMs = 125,
        id = "apex-surge",
        lateOkayWindowMs = 250,
        minProgress = 70,
        okayWindowMs = 205,
        perfectWindowMs = 60,
        spawnDelayMs = 70,
        targetDurationMs = 680,
        weight = 2
    }
}
local t7 = {
    great = {
        cameraShakeDuration = 0.12,
        cameraShakeMagnitude = 0.28,
        fishJoltMagnitude = 0.22,
        fovKick = 3,
        hitstopMs = 35,
        progressPulseScale = 1.05
    },
    miss = {
        cameraShakeDuration = 0.2,
        cameraShakeMagnitude = 0.35,
        fishJoltMagnitude = -0.25,
        fovKick = -2,
        hitstopMs = 0,
        progressPulseScale = 0.98
    },
    okay = {
        cameraShakeDuration = 0.08,
        cameraShakeMagnitude = 0.12,
        fishJoltMagnitude = 0.1,
        fovKick = 1.5,
        hitstopMs = 15,
        progressPulseScale = 1.025
    },
    perfect = {
        cameraShakeDuration = 0.18,
        cameraShakeMagnitude = 0.45,
        fishJoltMagnitude = 0.35,
        fovKick = 5,
        hitstopMs = 60,
        progressPulseScale = 1.08
    }
}

return {
    approachScaleStart = 2.3,
    minDistanceMultiplier = 1.75,
    getActionLabel = getActionLabel,
    getImpactConfig = function(p2, p3) -- getImpactConfig | line: 178
        -- upvalues: t7 (copy)
        local v1 = t7[p2]
        local v2 = math.max(p3, 0)

        return {
            cameraShakeDuration = v1.cameraShakeDuration,
            cameraShakeMagnitude = v1.cameraShakeMagnitude * v2,
            fishJoltMagnitude = v1.fishJoltMagnitude * v2,
            fovKick = v1.fovKick * v2,
            hitstopMs = v1.hitstopMs,
            progressPulseScale = 1 + (v1.progressPulseScale - 1) * v2
        }
    end,
    clamp01 = function(p4) -- clamp01 | line: 191
        return (math.clamp(p4, 0, 1))
    end,
    getRareFishIntensityPhase = function(p5) -- getRareFishIntensityPhase | line: 194
        if p5 >= 0.7 then
            return "apex"
        end

        if p5 >= 0.35 then
            return "struggle"
        end

        return "control"
    end,
    pickRareFishTimingProfile = function(p6, p7) -- pickRareFishTimingProfile | line: 210
        local v3 = p6 * 100
        local t8 = {}
        local n1 = 0

        for _, v4 in p7 do
            if (v4.minProgress == nil or not (v3 < v4.minProgress)) and (v4.maxProgress == nil or not (v4.maxProgress < v3)) then
                table.insert(t8, v4)
                n1 += v4.weight
            end
        end

        if #t8 == 0 or n1 <= 0 then
            return p7[math.random(0, #p7 - 1) + 1]
        end

        local v5 = math.random() * n1

        for _, v6 in t8 do
            v5 -= v6.weight

            if v5 <= 0 then
                return v6
            end
        end

        return t8[#t8]
    end,
    computeBarFillGradient = function(p8) -- computeBarFillGradient | line: 236
        -- upvalues: t2 (copy)
        local v7, v8

        if p8 <= 0.25 then
            local v9 = p8 / 0.25

            v7 = t2.barFillDangerDark:Lerp(t2.barFillDangerDarkEnd, v9)
            v8 = t2.barFillDangerLight:Lerp(t2.barFillDangerLightEnd, v9)
        elseif p8 >= 0.85 then
            local v10 = (p8 - 0.85) / 0.15

            v7 = t2.barFillHighDark:Lerp(t2.barFillHighDarkEnd, v10)
            v8 = t2.barFillHighLight:Lerp(t2.barFillHighLightEnd, v10)
        else
            v7 = t2.barFillMidDark
            v8 = t2.barFillMidLight
        end

        return ColorSequence.new({
            ColorSequenceKeypoint.new(0, v7),
            ColorSequenceKeypoint.new(0.25, v8),
            ColorSequenceKeypoint.new(0.5, v7),
            ColorSequenceKeypoint.new(0.75, v8),
            ColorSequenceKeypoint.new(1, v7)
        })
    end,
    randomPosInArea = function(p9, p10, p11, p12, p13) -- randomPosInArea | line: 253
        local v11 = p9 - p11
        local v12 = p10 - p11
        local v13 = p12 * 1.75
        local v14 = v13 * v13
        local n2 = 0
        local v15, v16

        while true do
            v15 = p11 + math.random() * (v11 - p11)
            v16 = p11 + math.random() * (v12 - p11)
            n2 += 1

            if p13 ~= nil and not (n2 >= 20) then
                local v17 = v15 - p13.x
                local v18 = v16 - p13.y

                if not (v14 <= v17 * v17 + v18 * v18) and n2 < 20 then
                    continue
                end
            end

            break
        end

        return {
            x = v15,
            y = v16
        }
    end,
    resolveRareFishColors = function(p14) -- resolveRareFishColors | line: 283
        -- upvalues: t2 (copy)
        local v19 = if p14 == nil then p14 else p14.approachRing

        if v19 == nil then
            v19 = t2.approachRing
        end

        local t9 = {
            approachRing = v19
        }
        local v20 = if p14 == nil then p14 else p14.barLabelFail

        t9.barLabelFail = if v20 == nil then t2.barLabelFail else v20

        local v21 = if p14 == nil then p14 else p14.barLabelPlaying

        t9.barLabelPlaying = if v21 == nil then t2.barLabelPlaying else v21

        local v22 = if p14 == nil then p14 else p14.barLabelSuccess

        t9.barLabelSuccess = if v22 == nil then t2.barLabelSuccess else v22

        local v23 = if p14 == nil then p14 else p14.barTrack

        t9.barTrack = if v23 == nil then t2.barTrack else v23

        local v24 = if p14 == nil then p14 else p14.innerBorder

        t9.innerBorder = if v24 == nil then t2.innerBorder else v24

        local v25 = if p14 == nil then p14 else p14.innerFill

        t9.innerFill = if v25 == nil then t2.innerFill else v25

        local v26 = if p14 == nil then p14 else p14.innerPerfectBorder

        t9.innerPerfectBorder = if v26 == nil then t2.innerPerfectBorder else v26

        local v27 = if p14 == nil then p14 else p14.innerPerfectFill

        t9.innerPerfectFill = if v27 == nil then t2.innerPerfectFill else v27

        local v28 = if p14 == nil then p14 else p14.innerPerfectGlow

        t9.innerPerfectGlow = if v28 == nil then t2.innerPerfectGlow else v28

        local v29 = if p14 == nil then p14 else p14.ratingMiss

        t9.ratingMiss = if v29 == nil then t2.ratingMiss else v29

        return t9
    end,
    defaultTuning = t1,
    defaultColors = t2,
    hitRatingToGrade = t3,
    ratingScoreValues = t4,
    rareFishActionLabels = t5,
    rareFishTimingProfiles = t6,
    impactConfigByRating = t7
}
