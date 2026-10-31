-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

return {
    flightGateFXConfig = {
        ringScaleLerpSpeed = 8,
        combo = {
            tierTwoCombo = 4,
            tierThreeCombo = 7,
            ringLerpSpeed = 7,
            passSfxMaxPitch = 1.2,
            passSfxPitchUpStep = 0.015,
            ringGradients = {
                tier1 = ColorSequence.new(Color3.fromRGB(230, 163, 84)),
                tier2 = ColorSequence.new({
                    ColorSequenceKeypoint.new(0, Color3.fromRGB(105, 255, 230)),
                    ColorSequenceKeypoint.new(1, Color3.fromRGB(51, 204, 252))
                }),
                tier3 = ColorSequence.new({
                    ColorSequenceKeypoint.new(0, Color3.fromRGB(245, 120, 255)),
                    ColorSequenceKeypoint.new(1, Color3.fromRGB(252, 87, 181))
                })
            },
            streakFailVFX = {
                ringResetSeconds = 0.15,
                comboFailSFX = "ComboFailSFX",
                shake = {
                    durationSeconds = 0.3,
                    amplitude = 5,
                    frequency = 0.1,
                    positionInfluence = Vector3.new(0.12, 0.12, 0.12),
                    rotationInfluence = Vector3.new(0.08, 0.08, 0.08)
                }
            },
            tierSFX = {
                tier2 = "ComboTierSFX1",
                tier3 = "ComboTierSFX2"
            }
        },
        vignetteVFX = {
            assetFolderName = "SubwaySurf",
            decalName = "Vignette",
            activeTransparency = 0.2,
            appearSeconds = 0.35,
            colorLerpSeconds = 0.35,
            fadeOutSeconds = 0.2,
            pityGradientRotationSpeed = 90,
            zIndex = 998,
            tier2Color = Color3.fromRGB(51, 204, 252),
            tier3Color = Color3.fromRGB(252, 87, 181),
            comboBreakColor = Color3.fromRGB(255, 0, 0),
            pityGradient = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 196, 46)),
                ColorSequenceKeypoint.new(0.25, Color3.fromRGB(255, 255, 210)),
                ColorSequenceKeypoint.new(0.5, Color3.fromRGB(76, 255, 226)),
                ColorSequenceKeypoint.new(0.75, Color3.fromRGB(255, 102, 219)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 196, 46))
            })
        },
        barVFX = {
            length = 0.4,
            width = 0.06,
            cornerRadius = 0.12,
            tweenSeconds = 0.2,
            offsetFromCenter = Vector2.new(0.05, 0.24),
            instructionPosition = Vector2.new(0.5, 0.195),
            mutationLabelPosition = Vector2.new(0.75, 0.6),
            trackColor = Color3.fromRGB(20, 25, 35),
            fillGradient = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 238, 92)),
                ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 180, 38)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(238, 102, 18))
            }),
            strokeColor = Color3.fromRGB(255, 171, 46),
            strokeFlash = {
                brightenFactor = 0.85
            },
            fullFlash = {
                enabled = true,
                intervalSeconds = 0.15
            },
            impact = {
                totalDurationSeconds = 0.4,
                foresight = {
                    enabled = true
                },
                fillLerp = {
                    startFraction = 0,
                    endFraction = 0.324
                },
                punch = {
                    startFraction = 0,
                    endFraction = 1,
                    undershootScale = 0.8,
                    undershootFraction = 0.2,
                    overshootScale = 1.2,
                    overshootFraction = 0.2,
                    settleFraction = 0.6
                },
                comboMultiplier = {
                    startCombo = 1,
                    maxCombo = 10,
                    maxMultiplier = 2
                },
                tremble = {
                    startFraction = 0.2,
                    endFraction = 0.7,
                    frequency = 95,
                    positionAmplitudePx = 5,
                    rotationAmplitudeDegrees = 2.5
                }
            }
        },
        scorePopupVFX = {
            labelSuffix = " Hoola Luck",
            strokeThickness = 0.06,
            zIndex = 45,
            spawnXRange = Vector2.new(0.25, 0.82),
            spawnYRange = Vector2.new(0.7, 0.82),
            tiltRange = Vector2.new(15, 30),
            size = Vector2.new(0.16, 0.075),
            impact = {
                totalDurationSeconds = 0.75,
                movement = {
                    riseDistance = 0.12,
                    startFraction = 0,
                    endFraction = 1
                },
                fade = {
                    startFraction = 0.45,
                    endFraction = 1
                },
                punch = {
                    startFraction = 0,
                    endFraction = 0.4,
                    undershootScale = 0.8,
                    undershootFraction = 0.2,
                    overshootScale = 1.35,
                    overshootFraction = 0.08,
                    settleFraction = 0.72
                }
            },
            color = Color3.fromRGB(255, 239, 115),
            popoutColor = Color3.fromRGB(75, 35, 0),
            strokeColor = Color3.fromRGB(0, 0, 0)
        },
        comboTextVFX = {
            sizeMultiplier = 0.9,
            sizeGrowthPerCombo = 0.1,
            sizeGrowthScaleCap = 1.7715610000000008,
            offsetFromCenter = Vector2.new(0, 0.19),
            gradient = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 238, 92)),
                ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 200, 40)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 238, 92))
            }),
            strokeColor = Color3.fromRGB(0, 0, 0),
            impact = {
                totalDurationSeconds = 0.3,
                punch = {
                    startFraction = 0,
                    endFraction = 1,
                    undershootScale = 0.9,
                    undershootFraction = 0.1,
                    overshootScale = 1.1,
                    overshootFraction = 0.2,
                    settleFraction = 0.4
                },
                comboMultiplier = {
                    startCombo = 1,
                    maxCombo = 10,
                    maxMultiplier = 4
                }
            },
            pulse = {
                baseIntervalSeconds = 1.1,
                minIntervalSeconds = 0.35,
                maxCombo = 10,
                intervalSecondsCap = 0.6000000000000001,
                peakScale = 1.08
            },
            shine = {
                speed = 1.4
            }
        }
    }
}
