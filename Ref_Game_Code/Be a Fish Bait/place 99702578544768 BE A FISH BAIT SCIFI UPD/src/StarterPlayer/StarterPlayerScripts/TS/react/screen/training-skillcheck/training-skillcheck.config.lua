-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

return {
    getTrainingScale = function(p1) -- getTrainingScale | line: 3
        if p1 == "sm" then
            return 0.55
        end

        if p1 == "md" then
            return 0.8
        end

        return 1
    end,
    defaultTrainingTuning = {
        size = 120,
        approachRingWidth = 4,
        hitboxMultiplier = 1.4,
        approachScaleStart = 2.3,
        approachRingOuterPad = 10,
        approachRingOuterThickness = 3,
        approachRingArcThickness = 6,
        circleDurationMs = 1800,
        lateGraceMs = 200,
        baseSpawnDelayMs = 200,
        minSpawnDelayMs = 80,
        spawnAccelerationFactor = 0.8,
        boostGainPerHit = 0.12,
        frenzyDurationSeconds = 5,
        flashIntervalSeconds = 0.15,
        playAreaWidth = 750,
        playAreaHeight = 360,
        playAreaPadding = 80,
        barHeightPx = 12,
        barGapPx = 12,
        barCornerRadius = 3,
        thockyKeyboardVolume = 5,
        thockyKeyboardStartTime = 0.6,
        frenzyMaxIntervalSeconds = 0.6,
        frenzyPitch = 2,
        frenzyStopSoundLeadSeconds = 0.35,
        popSoundPitchWindowSeconds = 2,
        popSoundPitchStep = 0.1,
        popSoundBasePitch = 1,
        popSoundPitchCap = 10,
        popSoundVolume = 2
    },
    trainingDoubledGradient = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(180, 80, 255)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(130, 30, 210)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(90, 0, 160))
    }),
    boostBarGradient = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 160, 0)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 80, 10)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(200, 20, 20))
    })
}
