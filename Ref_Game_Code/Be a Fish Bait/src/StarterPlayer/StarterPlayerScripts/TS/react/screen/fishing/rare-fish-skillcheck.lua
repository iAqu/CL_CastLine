-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local useBinding, useEffect, useRef, useState = react.useBinding, react.useEffect, react.useRef, react.useState
local hapticPerfectHit = RuntimeLib.import(script, script.Parent.Parent.Parent.Parent, "haptics").hapticPerfectHit
local useMotion = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "pretty-react-hooks", "out").useMotion
local RunService = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services").RunService
local useConfig = RuntimeLib.import(script, script.Parent.Parent.Parent, "context", "config-context").useConfig
local default = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "brainrot-style", "popout-text-two").default
local getRarityBorderColor = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "rarity-utils").getRarityBorderColor
local v1 = RuntimeLib.import(script, script.Parent, "cast-grade-text")
local castGradeGradients, gradeConfigs = v1.castGradeGradients, v1.gradeConfigs
local v2 = RuntimeLib.import(script, script.Parent, "rare-fish-skillcheck.config")
local approachScaleStart, computeBarFillGradient, getImpactConfig, hitRatingToGrade = v2.approachScaleStart, v2.computeBarFillGradient, v2.getImpactConfig, v2.hitRatingToGrade
local pickRareFishTimingProfile, randomPosInArea, rareFishTimingProfiles, ratingScoreValues = v2.pickRareFishTimingProfile, v2.randomPosInArea, v2.rareFishTimingProfiles, v2.ratingScoreValues
local resolveRareFishColors, defaultTuning = v2.resolveRareFishColors, v2.defaultTuning
local v3 = RuntimeLib.import(script, script.Parent, "rare-fish-skillcheck-sfx")
local describeRareFishFeedback, impactSfxCueForRating, playRareFishSfxCue = v3.describeRareFishFeedback, v3.impactSfxCueForRating, v3.playRareFishSfxCue
local default2 = RuntimeLib.import(script, script.Parent, "rare-fish-skillcheck-countdown").default
local default3 = RuntimeLib.import(script, script.Parent, "rare-fish-skillcheck-feedback-layer").default
local default4 = RuntimeLib.import(script, script.Parent, "rare-fish-skillcheck-progress-bar").default
local default5 = RuntimeLib.import(script, script.Parent, "rare-fish-skillcheck-target").default

return {
    default = function(p1) -- RareFishSkillCheck | line: 39
        -- upvalues: react (copy), useBinding (copy), useEffect (copy), useRef (copy), useState (copy), hapticPerfectHit (copy), useMotion (copy), RunService (copy), useConfig (copy), default (copy), getRarityBorderColor (copy), castGradeGradients (copy), gradeConfigs (copy), approachScaleStart (copy), computeBarFillGradient (copy), getImpactConfig (copy), hitRatingToGrade (copy), pickRareFishTimingProfile (copy), randomPosInArea (copy), rareFishTimingProfiles (copy), ratingScoreValues (copy), resolveRareFishColors (copy), defaultTuning (copy), describeRareFishFeedback (copy), impactSfxCueForRating (copy), playRareFishSfxCue (copy), default2 (copy), default3 (copy), default4 (copy), default5 (copy)
        local animateFishIcon = p1.animateFishIcon

        if animateFishIcon == nil then
            animateFishIcon = true
        end

        local approachRingWidth = p1.approachRingWidth

        if approachRingWidth == nil then
            approachRingWidth = defaultTuning.approachRingWidth
        end

        local autoStart = p1.autoStart
        local v4 = autoStart

        if autoStart == nil then
            v4 = true
            autoStart = true
        end

        local barBorderThickness = p1.barBorderThickness
        local barBorderThickness2 = barBorderThickness

        if barBorderThickness == nil then
            barBorderThickness2 = defaultTuning.barBorderThickness
        end

        local barBottomOffset = p1.barBottomOffset
        local barBottomOffset2 = barBottomOffset

        if barBottomOffset == nil then
            barBottomOffset2 = defaultTuning.barBottomOffset
        end

        local barCornerRadius = p1.barCornerRadius

        if barCornerRadius == nil then
            barCornerRadius = defaultTuning.barCornerRadius
        end

        local barHeight = p1.barHeight
        local barHeight2 = barHeight

        if barHeight == nil then
            barHeight2 = defaultTuning.barHeight
        end

        local barTextureSpeed = p1.barTextureSpeed

        if barTextureSpeed == nil then
            barTextureSpeed = defaultTuning.barTextureSpeed
        end

        local barWidth = p1.barWidth
        local barWidth2 = barWidth

        if barWidth == nil then
            barWidth2 = defaultTuning.barWidth
        end

        local v5, countdownEndScale = p1.colors, p1.countdownEndScale

        if countdownEndScale == nil then
            countdownEndScale = defaultTuning.countdownEndScale
        end

        local countdownGoEndScale = p1.countdownGoEndScale

        if countdownGoEndScale == nil then
            countdownGoEndScale = defaultTuning.countdownGoEndScale
        end

        local countdownGoMs = p1.countdownGoMs

        if countdownGoMs == nil then
            countdownGoMs = defaultTuning.countdownGoMs
        end

        local countdownStartScale = p1.countdownStartScale

        if countdownStartScale == nil then
            countdownStartScale = defaultTuning.countdownStartScale
        end

        local countdownStepMs = p1.countdownStepMs

        if countdownStepMs == nil then
            countdownStepMs = defaultTuning.countdownStepMs
        end

        local countdownSteps = p1.countdownSteps

        if countdownSteps == nil then
            countdownSteps = { "3", "2", "1", "GO!" }
        end

        local currentFish, drainPerSecond = p1.currentFish, p1.drainPerSecond

        if drainPerSecond == nil then
            drainPerSecond = defaultTuning.drainPerSecond
        end

        local v6 = p1.enableHitstop

        if v6 == nil then
            v6 = true
        end

        local enableProgressPulse = p1.enableProgressPulse

        if enableProgressPulse == nil then
            enableProgressPulse = true
        end

        local enableScreenImpact = p1.enableScreenImpact

        if enableScreenImpact == nil then
            enableScreenImpact = true
        end

        local fishIconLeadOffset = p1.fishIconLeadOffset
        local fishIconLeadOffset2 = fishIconLeadOffset

        if fishIconLeadOffset == nil then
            fishIconLeadOffset2 = defaultTuning.fishIconLeadOffset
        end

        local fishIconSize = p1.fishIconSize

        if fishIconSize == nil then
            fishIconSize = defaultTuning.fishIconSize
        end

        local greatProgressGain = p1.greatProgressGain

        if greatProgressGain == nil then
            greatProgressGain = defaultTuning.greatProgressGain
        end

        local greatWindowMs = p1.greatWindowMs

        if greatWindowMs == nil then
            greatWindowMs = defaultTuning.greatWindowMs
        end

        local hitboxMultiplier = p1.hitboxMultiplier

        if hitboxMultiplier == nil then
            hitboxMultiplier = defaultTuning.hitboxMultiplier
        end

        local impactIntensityMultiplier = p1.impactIntensityMultiplier

        if impactIntensityMultiplier == nil then
            impactIntensityMultiplier = 1
        end

        local initialProgress = p1.initialProgress

        if initialProgress == nil then
            initialProgress = defaultTuning.initialProgress
        end

        local innerBorderWidth = p1.innerBorderWidth

        if innerBorderWidth == nil then
            innerBorderWidth = defaultTuning.innerBorderWidth
        end

        local lateGraceMs = p1.lateGraceMs

        if lateGraceMs == nil then
            lateGraceMs = defaultTuning.lateGraceMs
        end

        local lateOkayWindowMs = p1.lateOkayWindowMs

        if lateOkayWindowMs == nil then
            lateOkayWindowMs = defaultTuning.lateOkayWindowMs
        end

        local maxProgress = p1.maxProgress

        if maxProgress == nil then
            maxProgress = defaultTuning.maxProgress
        end

        local missProgressPenalty = p1.missProgressPenalty

        if missProgressPenalty == nil then
            missProgressPenalty = defaultTuning.missProgressPenalty
        end

        local okayProgressGain = p1.okayProgressGain

        if okayProgressGain == nil then
            okayProgressGain = defaultTuning.okayProgressGain
        end

        local okayWindowMs = p1.okayWindowMs

        if okayWindowMs == nil then
            okayWindowMs = defaultTuning.okayWindowMs
        end

        local onActionTargetSpawn, onComplete, onCountdownComplete, onFeedbackCue = p1.onActionTargetSpawn, p1.onComplete, p1.onCountdownComplete, p1.onFeedbackCue
        local onHit, perfectProgressGain = p1.onHit, p1.perfectProgressGain

        if perfectProgressGain == nil then
            perfectProgressGain = defaultTuning.perfectProgressGain
        end

        local perfectWindowMs = p1.perfectWindowMs

        if perfectWindowMs == nil then
            perfectWindowMs = defaultTuning.perfectWindowMs
        end

        local playAreaHeight = p1.playAreaHeight
        local playAreaHeight2 = playAreaHeight

        if playAreaHeight == nil then
            playAreaHeight2 = defaultTuning.playAreaHeight
        end

        local playAreaPadding, playAreaWidth = p1.playAreaPadding, p1.playAreaWidth
        local playAreaWidth2 = playAreaWidth

        if playAreaWidth == nil then
            playAreaWidth2 = defaultTuning.playAreaWidth
        end

        local showActionLabels = p1.showActionLabels

        if showActionLabels == nil then
            showActionLabels = true
        end

        local v7 = p1.showCountdown

        if v7 == nil then
            v7 = true
        end

        local showFishIconOnBar = p1.showFishIconOnBar

        if showFishIconOnBar == nil then
            showFishIconOnBar = true
        end

        local showPerfectTimingColor = p1.showPerfectTimingColor

        if showPerfectTimingColor == nil then
            showPerfectTimingColor = true
        end

        local showPlayAreaBounds = p1.showPlayAreaBounds

        if showPlayAreaBounds == nil then
            showPlayAreaBounds = false
        end

        local showProgressPercent = p1.showProgressPercent

        if showProgressPercent == nil then
            showProgressPercent = true
        end

        local size = p1.size

        if size == nil then
            size = defaultTuning.size
        end

        local spawnDelayMs = p1.spawnDelayMs

        if spawnDelayMs == nil then
            spawnDelayMs = defaultTuning.spawnDelayMs
        end

        local startDelayMs = p1.startDelayMs
        local v8 = startDelayMs

        if startDelayMs == nil then
            v8 = 0
            startDelayMs = 0
        end

        local targetDurationMs = p1.targetDurationMs

        if targetDurationMs == nil then
            targetDurationMs = defaultTuning.targetDurationMs
        end

        local timeoutProgressPenalty = p1.timeoutProgressPenalty

        if timeoutProgressPenalty == nil then
            timeoutProgressPenalty = defaultTuning.timeoutProgressPenalty
        end

        local variableTimingEnabled = p1.variableTimingEnabled

        if variableTimingEnabled == nil then
            variableTimingEnabled = true
        end

        local v9 = resolveRareFishColors(v5)

        if playAreaPadding == nil then
            playAreaPadding = size * 0.75
        end

        v5 = if v7 then "countdown" else "playing"
        v7 = if not autoStart or startDelayMs > 0 then "idle" else v5

        local v10, v11 = useState(v7)
        local v12, v13 = useState(false)
        local v14, v15 = useState(0)
        local v16, v17 = useState(0)
        local pull, pull2 = useState("pull")
        local v18, v19 = useState(function() -- line: 258
            -- upvalues: playAreaHeight2 (ref), playAreaPadding (ref), playAreaWidth2 (ref), size (ref), randomPosInArea (copy)
            return randomPosInArea(playAreaWidth2, playAreaHeight2, playAreaPadding, size)
        end)
        local v20, v21 = useState(nil)
        local v22, v23 = useState({})
        local v24, v25 = useBinding(0)
        local v26, v27 = useBinding(initialProgress / maxProgress)
        local v28 = useRef(v7)
        local v29 = useRef(initialProgress)
        local v30 = useRef(false)
        local v31 = useRef(os.clock())
        local v32 = useRef(os.clock())
        local v33 = useRef(0)
        local v34 = useRef({
            x = playAreaWidth2 * 0.5,
            y = playAreaHeight2 * 0.5
        })
        local v35 = useRef(true)
        local v36 = useRef(nil)
        local v37 = useRef(0)
        local v38 = useRef(0)
        local v39 = useRef({
            greats = 0,
            hits = 0,
            misses = 0,
            okays = 0,
            perfects = 0,
            score = 0
        })
        local v40 = useRef({
            actionType = "pull",
            greatWindowMs = greatWindowMs,
            lateOkayWindowMs = lateOkayWindowMs,
            okayWindowMs = okayWindowMs,
            perfectWindowMs = perfectWindowMs,
            spawnDelayMs = spawnDelayMs,
            targetDurationMs = targetDurationMs
        })

        useEffect(function() -- line: 300
            -- upvalues: v4 (ref), v8 (ref), v11 (copy), v31 (copy), v32 (copy), v35 (copy), v5 (ref)
            local v41 = v4

            if not v41 or v8 <= 0 then
                return nil
            end

            local v42 = task.delay(v8 / 1000, function() -- line: 304
                -- upvalues: v11 (copy), v31 (copy), v32 (copy), v35 (copy), v5 (ref)
                if not v35.current then
                    return nil
                end

                v31.current = os.clock()
                v32.current = os.clock()
                v11(v5)
            end)

            return function() -- line: 312
                -- upvalues: v42 (copy)
                return task.cancel(v42)
            end
        end, {})

        local v43 = useRef(onComplete)
        local v44 = useRef(onCountdownComplete)
        local v45 = useRef(onHit)
        local v46 = useRef(onFeedbackCue)
        local v47 = useRef(onActionTargetSpawn)

        v43.current = onComplete
        v44.current = onCountdownComplete
        v45.current = onHit
        v46.current = onFeedbackCue
        v47.current = onActionTargetSpawn

        local v48, v49 = useBinding(countdownStartScale)
        local v50, v51 = useBinding(0)
        local v52 = useRef(v49)
        local v53 = useRef(v51)

        v52.current = v49
        v53.current = v51

        local v54 = useRef(0)
        local v55 = useRef(os.clock())
        local getSound = useConfig().getSound
        local v56 = useRef(nil)
        local v57 = useRef({
            animateFishIcon = animateFishIcon,
            barTextureSpeed = barTextureSpeed,
            countdownEndScale = countdownEndScale,
            countdownGoEndScale = countdownGoEndScale,
            countdownGoMs = countdownGoMs,
            countdownStartScale = countdownStartScale,
            countdownStepMs = countdownStepMs,
            countdownSteps = countdownSteps,
            drainPerSecond = drainPerSecond,
            enableHitstop = v6,
            enableProgressPulse = enableProgressPulse,
            enableScreenImpact = enableScreenImpact,
            greatProgressGain = greatProgressGain,
            greatWindowMs = greatWindowMs,
            hitboxMultiplier = hitboxMultiplier,
            impactIntensityMultiplier = impactIntensityMultiplier,
            initialProgress = initialProgress,
            lateGraceMs = lateGraceMs,
            lateOkayWindowMs = lateOkayWindowMs,
            maxProgress = maxProgress,
            missProgressPenalty = missProgressPenalty,
            okayProgressGain = okayProgressGain,
            okayWindowMs = okayWindowMs,
            pad = playAreaPadding,
            perfectProgressGain = perfectProgressGain,
            perfectWindowMs = perfectWindowMs,
            playAreaHeight = playAreaHeight2,
            playAreaWidth = playAreaWidth2,
            showActionLabels = showActionLabels,
            showFishIconOnBar = showFishIconOnBar,
            showPerfectTimingColor = showPerfectTimingColor,
            size = size,
            spawnDelayMs = spawnDelayMs,
            targetDurationMs = targetDurationMs,
            timeoutProgressPenalty = timeoutProgressPenalty,
            variableTimingEnabled = variableTimingEnabled
        })

        v57.current = {
            animateFishIcon = animateFishIcon,
            barTextureSpeed = barTextureSpeed,
            countdownEndScale = countdownEndScale,
            countdownGoEndScale = countdownGoEndScale,
            countdownGoMs = countdownGoMs,
            countdownStartScale = countdownStartScale,
            countdownStepMs = countdownStepMs,
            countdownSteps = countdownSteps,
            drainPerSecond = drainPerSecond,
            enableHitstop = v6,
            enableProgressPulse = enableProgressPulse,
            enableScreenImpact = enableScreenImpact,
            greatProgressGain = greatProgressGain,
            greatWindowMs = greatWindowMs,
            hitboxMultiplier = hitboxMultiplier,
            impactIntensityMultiplier = impactIntensityMultiplier,
            initialProgress = initialProgress,
            lateGraceMs = lateGraceMs,
            lateOkayWindowMs = lateOkayWindowMs,
            maxProgress = maxProgress,
            missProgressPenalty = missProgressPenalty,
            okayProgressGain = okayProgressGain,
            okayWindowMs = okayWindowMs,
            pad = playAreaPadding,
            perfectProgressGain = perfectProgressGain,
            perfectWindowMs = perfectWindowMs,
            playAreaHeight = playAreaHeight2,
            playAreaWidth = playAreaWidth2,
            showActionLabels = showActionLabels,
            showFishIconOnBar = showFishIconOnBar,
            showPerfectTimingColor = showPerfectTimingColor,
            size = size,
            spawnDelayMs = spawnDelayMs,
            targetDurationMs = targetDurationMs,
            timeoutProgressPenalty = timeoutProgressPenalty,
            variableTimingEnabled = variableTimingEnabled
        }

        local v58 = useRef(function() -- line: 416
        end)
        local v59 = useRef(function() -- line: 417
        end)
        local v60 = useRef(function() -- line: 418
        end)
        local v61 = useRef(function() -- line: 419
        end)
        local v62 = useRef(function() -- line: 420
        end)
        local v63 = useRef(function() -- line: 421
            return {
                actualDelta = 0,
                newProgress = 0
            }
        end)
        local v64 = useRef(v25)
        local v65 = useRef(v27)

        v64.current = v25
        v65.current = v27

        local v66 = useRef(currentFish)

        v66.current = currentFish

        local v67, v68 = useBinding({
            bobY = 0,
            rotation = 0,
            fillRatio = initialProgress / maxProgress
        })
        local v69 = useRef(v68)

        v69.current = v68

        local v70, v71 = useBinding(0)
        local v72 = useRef(v71)

        v72.current = v71
        v71 = v70:map(function(p2) -- line: 443
            return UDim2.fromScale(-p2, 0)
        end)

        local v73, v74 = useBinding(false)
        local v75 = useRef(v74)

        v75.current = v74

        local v76, v77 = useMotion(0)
        local v78 = useRef(v77)

        v78.current = v77

        local v79, v80 = useMotion(0)
        local v81 = useRef(v80)

        v81.current = v80

        local v82, v83 = useMotion(1)
        local v84 = useRef(v83)

        v84.current = v83
        useEffect(function() -- line: 460
            -- upvalues: v10 (copy), v28 (copy)
            v28.current = v10
        end, { v10 })
        useEffect(function() -- line: 463
            -- upvalues: v35 (copy)
            return function() -- line: 464
                -- upvalues: v35 (copy)
                v35.current = false
            end
        end, {})
        v83 = v24:map(function(p3) -- line: 469
            -- upvalues: size (ref), approachScaleStart (copy)
            local v86 = math.max(approachScaleStart - (approachScaleStart - 1) * p3, 0.1)

            return UDim2.fromOffset(size * v86, size * v86)
        end)

        local v87 = v26:map(function(p4) -- line: 473
            return UDim2.fromScale(math.clamp(p4, 0, 1), 1.1)
        end)
        local v88 = v26:map(function(p5) -- line: 476
            -- upvalues: maxProgress (ref)
            return (("%*%%"):format((math.floor(p5 * maxProgress))))
        end)
        local v90 = v26:map(function(p6) -- line: 479
            -- upvalues: computeBarFillGradient (copy)
            return computeBarFillGradient(p6)
        end)
        local v91 = v26:map(function(_) -- line: 482
            return Color3.fromRGB(0, 0, 0)
        end)
        local v92 = v73:map(function(p8) -- line: 485
            -- upvalues: v9 (copy)
            if p8 then
                return v9.innerPerfectFill
            end

            return v9.innerFill
        end)
        local v93 = v73:map(function(p9) -- line: 488
            if p9 then
                return 0.65
            end

            return 0.35
        end)
        local v94 = v73:map(function(p10) -- line: 491
            -- upvalues: v9 (copy)
            if p10 then
                return v9.innerPerfectBorder
            end

            return v9.innerBorder
        end)
        local v95 = v73:map(function(p11) -- line: 494
            if p11 then
                return 0.55
            end

            return 1
        end)
        local v96 = UDim2.fromOffset(size + 18, size + 18)
        local v97 = v76:map(function(p12) -- line: 498
            return UDim2.fromOffset(220 * p12, 54 * p12)
        end)
        local v98 = v67:map(function(p13) -- line: 501
            -- upvalues: barBorderThickness2 (ref), barBottomOffset2 (ref), barHeight2 (ref), barWidth2 (ref), fishIconLeadOffset2 (ref)
            return UDim2.new(0.5, math.floor(-barWidth2 / 2 + barBorderThickness2 + math.clamp(p13.fillRatio, 0, 1) * (barWidth2 - barBorderThickness2 * 2) + fishIconLeadOffset2), 1, (math.floor(-barBottomOffset2 - barHeight2 / 2 + p13.bobY)))
        end)
        local v103 = v67:map(function(p14) -- line: 504
            return p14.rotation
        end)

        v6 = if currentFish ~= nil then getRarityBorderColor(currentFish.rarity) else Color3.fromRGB(255, 255, 255)

        local v104 = v67:map(function(p15) -- line: 508
            if p15.fillRatio <= 0.5 then
                return 3
            end

            return 2
        end)

        function v63.current(p16) -- line: 512
            -- upvalues: v27 (copy), v29 (copy), v57 (copy)
            local current = v57.current
            local current2 = v29.current
            local v106 = math.clamp(current2 + p16, 0, current.maxProgress)

            v29.current = v106
            v27(v106 / current.maxProgress)

            return {
                actualDelta = v106 - current2,
                newProgress = v106
            }
        end

        local function removeImpact(p17) -- line: 524
            -- upvalues: v23 (copy), v35 (copy)
            if not v35.current then
                return nil
            end

            v23(function(p18) -- line: 528
                -- upvalues: p17 (copy)
                local t1 = {}
                local n1 = 0

                for v107, v108 in p18 do
                    local _ = v107 - 1

                    if v108.id ~= p17 == true then
                        n1 += 1
                        t1[n1] = v108
                    end
                end

                return t1
            end)
        end

        local function spawnScreenImpact(p19, p20, p21) -- line: 545
            -- upvalues: v23 (copy), v35 (copy), v38 (copy)
            if not v35.current then
                return nil
            end

            v38.current += 1

            local current = v38.current

            v23(function(p22) -- line: 551
                -- upvalues: p19 (copy), p20 (copy), p21 (copy), current (copy)
                local t2 = {}
                local v109 = #t2
                local v110 = #p22

                table.move(p22, 1, v110, v109 + 1, t2)
                t2[v109 + v110 + 1] = {
                    actionType = p20,
                    id = current,
                    pos = p21,
                    rating = p19
                }

                return t2
            end)
        end

        local function pulseProgressBar(p23, p24) -- line: 566
            -- upvalues: v84 (copy)
            v84.current:set(p24)
            v84.current:tween(1, {
                time = 0.22,
                direction = Enum.EasingDirection.Out,
                style = if p23 == "miss" then Enum.EasingStyle.Quad else Enum.EasingStyle.Back
            })
        end

        local function playFeedback(p25, p26, p27) -- line: 576
            -- upvalues: v23 (copy), v35 (copy), v38 (copy), v46 (copy), v57 (copy), pulseProgressBar (copy), getImpactConfig (copy), describeRareFishFeedback (copy), impactSfxCueForRating (copy), playRareFishSfxCue (copy)
            local current = v57.current
            local v111 = getImpactConfig(p25, current.impactIntensityMultiplier)
            local v112 = impactSfxCueForRating(p25)
            local v113 = describeRareFishFeedback(p25, p26)

            print((("[RareFishSC] %* → VFX: %* | %*"):format(p25, v113.vfxDescription, v113.sfxDescription)))

            if current.enableScreenImpact and v35.current then
                v38.current += 1

                local current = v38.current

                v23(function(p28) -- line: 551
                    -- upvalues: p25 (copy), p26 (copy), p27 (copy), current (copy)
                    local t4 = {}
                    local v114 = #t4
                    local v115 = #p28

                    table.move(p28, 1, v115, v114 + 1, t4)
                    t4[v114 + v115 + 1] = {
                        actionType = p26,
                        id = current,
                        pos = p27,
                        rating = p25
                    }

                    return t4
                end)
            end

            if current.enableProgressPulse then
                pulseProgressBar(p25, v111.progressPulseScale)
            end

            playRareFishSfxCue(v112, {
                actionType = p26,
                rating = p25,
                screenPosition = p27
            })

            local current2 = v46.current

            if current2 ~= nil then
                current2({
                    actionType = p26,
                    impact = v111,
                    rating = p25,
                    sfxCue = v112
                })
            end
        end

        local function showFeedback(p29, p30) -- line: 605
            -- upvalues: v9 (copy), v21 (copy), v35 (copy), v36 (copy), v78 (copy), castGradeGradients (copy), gradeConfigs (copy), hitRatingToGrade (copy)
            if not v35.current then
                return nil
            end

            if v36.current ~= nil then
                task.cancel(v36.current)
            end

            local v116 = hitRatingToGrade[p29]

            v21({
                color = if v116 == nil then v9.ratingMiss else Color3.fromRGB(255, 255, 255),
                gradient = if v116 == nil then nil else castGradeGradients[v116],
                pos = p30,
                text = if v116 == nil then "MISS" else gradeConfigs[v116].text
            })
            v78.current:set(0)
            v78.current:tween(1, {
                time = 0.12,
                direction = Enum.EasingDirection.Out,
                style = Enum.EasingStyle.Back
            })
            v36.current = task.delay(0.75, function() -- line: 625
                -- upvalues: v21 (copy), v35 (copy), v36 (copy)
                if not v35.current then
                    return nil
                end

                v21(nil)
                v36.current = nil
            end)
        end

        v62.current = showFeedback

        local function buildResult(p31) -- line: 634
            -- upvalues: v29 (copy), v32 (copy), v39 (copy)
            local current = v39.current

            return {
                durationMs = (os.clock() - v32.current) * 1000,
                finalProgress = v29.current,
                greats = current.greats,
                hits = current.hits,
                misses = current.misses,
                okays = current.okays,
                perfects = current.perfects,
                score = current.score,
                success = p31
            }
        end

        local function handleSuccess() -- line: 648
            -- upvalues: v11 (copy), v13 (copy), v28 (copy), v30 (copy), v43 (copy), buildResult (copy), playRareFishSfxCue (copy)
            if v28.current ~= "playing" then
                return nil
            end

            v28.current = "success"
            v11("success")
            v30.current = false
            v13(false)
            playRareFishSfxCue("finalSurge")
            playRareFishSfxCue("skillCheckSuccess")

            local current = v43.current

            if current ~= nil then
                current((buildResult(true)))
            end
        end

        v61.current = handleSuccess

        local function handleFail() -- line: 666
            -- upvalues: v11 (copy), v13 (copy), v28 (copy), v30 (copy), v43 (copy), v81 (copy), buildResult (copy), playRareFishSfxCue (copy)
            if v28.current ~= "playing" then
                return nil
            end

            v28.current = "failed"
            v11("failed")
            v30.current = false
            v13(false)
            v81.current:set(0)
            v81.current:tween(1, {
                time = 0.35,
                direction = Enum.EasingDirection.Out,
                style = Enum.EasingStyle.Back
            })
            playRareFishSfxCue("skillCheckFail")

            local current = v43.current

            if current ~= nil then
                current((buildResult(false)))
            end
        end

        v60.current = handleFail

        local function processHit(p32, p33, p34) -- line: 688
            -- upvalues: v27 (copy), v29 (copy), v33 (copy), v39 (copy), v40 (copy), v45 (copy), v57 (copy), playFeedback (copy), showFeedback (copy), handleSuccess (copy), handleFail (copy), hapticPerfectHit (copy), ratingScoreValues (copy)
            local current = v57.current
            local current2 = v39.current
            local actionType = v40.current.actionType
            local perfectProgressGain

            if p32 == "perfect" then
                hapticPerfectHit()
                perfectProgressGain = current.perfectProgressGain
                current2.perfects += 1
                current2.score += ratingScoreValues.perfect
            elseif p32 == "great" then
                perfectProgressGain = current.greatProgressGain
                current2.greats += 1
                current2.score += ratingScoreValues.great
            elseif p32 == "okay" then
                perfectProgressGain = current.okayProgressGain
                current2.okays += 1
                current2.score += ratingScoreValues.okay
            else
                perfectProgressGain = -current.missProgressPenalty
                current2.misses += 1
            end

            if p32 ~= "miss" then
                current2.hits += 1
            end

            local current3 = v57.current
            local current4 = v29.current
            local v118 = math.clamp(current4 + perfectProgressGain, 0, current3.maxProgress)

            v29.current = v118
            v27(v118 / current3.maxProgress)

            local t6 = {
                actualDelta = v118 - current4,
                newProgress = v118
            }
            local actualDelta, newProgress = t6.actualDelta, t6.newProgress
            local current5 = v45.current

            if current5 ~= nil then
                current5({
                    index = v33.current,
                    progressAfter = newProgress,
                    progressDelta = actualDelta,
                    rating = p32,
                    timingErrorMs = p33
                })
            end

            showFeedback(p32, p34)
            playFeedback(p32, actionType, p34)

            if current.maxProgress <= newProgress then
                handleSuccess()
            elseif newProgress <= 0 then
                handleFail()
            end
        end

        local function prepareTiming() -- line: 735
            -- upvalues: pull2 (copy), v29 (copy), v33 (copy), v40 (copy), v47 (copy), v57 (copy), pickRareFishTimingProfile (copy), rareFishTimingProfiles (copy), playRareFishSfxCue (copy)
            local current = v57.current

            if current.variableTimingEnabled then
                local v120 = pickRareFishTimingProfile(v29.current / current.maxProgress, rareFishTimingProfiles)

                v40.current = {
                    actionType = v120.actionType,
                    greatWindowMs = v120.greatWindowMs,
                    lateOkayWindowMs = v120.lateOkayWindowMs,
                    okayWindowMs = v120.okayWindowMs,
                    perfectWindowMs = v120.perfectWindowMs,
                    spawnDelayMs = v120.spawnDelayMs,
                    targetDurationMs = v120.targetDurationMs
                }
            else
                v40.current = {
                    actionType = "pull",
                    greatWindowMs = current.greatWindowMs,
                    lateOkayWindowMs = current.lateOkayWindowMs,
                    okayWindowMs = current.okayWindowMs,
                    perfectWindowMs = current.perfectWindowMs,
                    spawnDelayMs = current.spawnDelayMs,
                    targetDurationMs = current.targetDurationMs
                }
            end

            pull2(v40.current.actionType)

            local current2 = v47.current

            if current2 ~= nil then
                current2({
                    actionType = v40.current.actionType,
                    index = v33.current,
                    targetDurationMs = v40.current.targetDurationMs,
                    timingProfileId = current.variableTimingEnabled and "variable" or "static"
                })
            end

            playRareFishSfxCue("circleSpawn", {
                actionType = v40.current.actionType
            })
        end

        function v59.current() -- line: 775
            -- upvalues: v13 (copy), v17 (copy), v19 (copy), v25 (copy), v28 (copy), v30 (copy), v31 (copy), v33 (copy), v34 (copy), v35 (copy), v57 (copy), prepareTiming (copy), randomPosInArea (copy)
            if not v35.current or v28.current ~= "playing" then
                return nil
            end

            local current = v57.current
            local v121 = randomPosInArea(current.playAreaWidth, current.playAreaHeight, current.pad, current.size, v34.current)

            v34.current = v121

            local v122 = v33.current + 1

            v33.current = v122
            prepareTiming()
            v31.current = os.clock()
            v25(0)
            v19(v121)
            v17(v122)
            v30.current = true
            v13(true)
        end

        local function queueNextCircle(p35) -- line: 796
            -- upvalues: v37 (copy), v40 (copy), v57 (copy), v59 (copy)
            local current = v57.current
            local v123 = (v40.current.spawnDelayMs + p35) / 1000

            if current.enableHitstop and p35 > 0 then
                v37.current = os.clock() + v123
            end

            task.delay(v123, function() -- line: 803
                -- upvalues: v59 (copy)
                return v59.current()
            end)
        end

        local function handleAttempt() -- line: 807
            -- upvalues: v13 (copy), v25 (copy), v28 (copy), v30 (copy), v31 (copy), v34 (copy), v40 (copy), v57 (copy), v75 (copy), processHit (copy), queueNextCircle (copy), getImpactConfig (copy)
            if v28.current ~= "playing" or not v30.current then
                return nil
            end

            local current = v57.current
            local current2 = v40.current
            local v124 = (os.clock() - v31.current) * 1000
            local v125 = current2.targetDurationMs - v124
            local v126 = v124 - current2.targetDurationMs
            local v127

            if current2.targetDurationMs <= v124 then
                v127 = if v126 <= current2.perfectWindowMs then "perfect"
                    elseif v126 <= current2.greatWindowMs then "great"
                    elseif v126 <= current2.lateOkayWindowMs then "okay"
                    else "miss"
            else
                v126 = v125
                v127 = if v125 <= current2.perfectWindowMs then "perfect"
                    elseif v125 <= current2.greatWindowMs then "great"
                    elseif v125 <= current2.okayWindowMs then "okay"
                    else "miss"
            end

            local current3 = v34.current

            v30.current = false
            v13(false)
            v25(0)
            v75.current(false)
            processHit(v127, v126, current3)

            if v28.current == "playing" then
                queueNextCircle(getImpactConfig(v127, current.impactIntensityMultiplier).hitstopMs)
            end
        end

        v58.current = handleAttempt
        useEffect(function() -- line: 856
            -- upvalues: v10 (copy), v11 (copy), v15 (copy), v28 (copy), v35 (copy), v44 (copy), v52 (copy), v53 (copy), v54 (copy), v55 (copy), getSound (copy), v56 (copy), v57 (copy), RunService (copy)
            if v10 ~= "countdown" then
                return nil
            end

            local current = v57.current

            v54.current = 0
            v55.current = os.clock()
            v15(0)
            v52.current(current.countdownStartScale)
            v53.current(0)

            local function v129() -- line: 866
                -- upvalues: getSound (copy), v56 (copy)
                local v130 = getSound("3-2-1Countdown")

                v56.current = v130
                v130.TimePosition = 0
                v130:Play()
            end

            pcall(v129)

            local connection

            connection = RunService.Heartbeat:Connect(function() -- line: 873
                -- upvalues: connection (ref), v11 (copy), v15 (copy), v28 (copy), v35 (copy), v44 (copy), v52 (copy), v53 (copy), v54 (copy), v55 (copy), v57 (copy)
                if not v35.current or v28.current ~= "countdown" then
                    connection:Disconnect()

                    return nil
                end

                local current = v57.current
                local current2 = v54.current
                local v131 = current2 == #current.countdownSteps - 1
                local v132 = (if v131 then current.countdownGoMs else current.countdownStepMs) / 1000
                local v134 = math.min((os.clock() - v55.current) / v132, 1)
                local v136 = 1 - math.pow(1 - v134, 3)
                local v137 = if v131 then current.countdownGoEndScale else current.countdownEndScale
                local v138 = current.countdownStartScale + (v137 - current.countdownStartScale) * v136
                local v139 = if v134 >= 0.8 then (v134 - 0.8) / 0.2 else 0

                v52.current(v138)
                v53.current(v139)

                if v134 >= 1 then
                    local v140 = current2 + 1

                    if #current.countdownSteps <= v140 then
                        connection:Disconnect()

                        if not v35.current then
                            return nil
                        end

                        v28.current = "playing"
                        v11("playing")

                        local current = v44.current

                        if current ~= nil then
                            current()
                        end
                    else
                        v54.current = v140
                        v55.current = os.clock()
                        v15(v140)
                        v52.current(current.countdownStartScale)
                        v53.current(0)
                    end
                end
            end)

            return function() -- line: 912
                -- upvalues: connection (ref), v56 (copy)
                connection:Disconnect()

                local current = v56.current

                if current ~= nil then
                    current:Stop()
                end

                v56.current = nil
            end
        end, { v10 })
        useEffect(function() -- line: 922
            -- upvalues: v10 (copy), v13 (copy), v28 (copy), v29 (copy), v30 (copy), v31 (copy), v32 (copy), v33 (copy), v34 (copy), v37 (copy), v39 (copy), v40 (copy), v45 (copy), v57 (copy), v60 (copy), v61 (copy), v62 (copy), v63 (copy), v64 (copy), v65 (copy), v66 (copy), v69 (copy), v72 (copy), v75 (copy), playFeedback (copy), prepareTiming (copy), queueNextCircle (copy), RunService (copy)
            if v10 ~= "playing" then
                return nil
            end

            local current = v57.current

            v32.current = os.clock()
            v31.current = os.clock()
            v29.current = current.initialProgress
            v39.current = {
                greats = 0,
                hits = 0,
                misses = 0,
                okays = 0,
                perfects = 0,
                score = 0
            }
            v37.current = 0
            v65.current(current.initialProgress / current.maxProgress)
            prepareTiming()
            v30.current = true
            v13(true)

            local connection

            connection = RunService.Heartbeat:Connect(function(p36) -- line: 944
                -- upvalues: connection (ref), v13 (copy), v28 (copy), v29 (copy), v30 (copy), v31 (copy), v33 (copy), v34 (copy), v37 (copy), v39 (copy), v40 (copy), v45 (copy), v57 (copy), v60 (copy), v61 (copy), v62 (copy), v63 (copy), v64 (copy), v66 (copy), v69 (copy), v72 (copy), v75 (copy), playFeedback (copy), queueNextCircle (copy)
                if v28.current ~= "playing" then
                    connection:Disconnect()

                    return nil
                end

                local current = v57.current

                if not (os.clock() < v37.current) then
                    local newProgress = v63.current(-current.drainPerSecond * p36).newProgress

                    if newProgress <= 0 then
                        connection:Disconnect()
                        v60.current()

                        return nil
                    end

                    if current.maxProgress <= newProgress then
                        connection:Disconnect()
                        v61.current()

                        return nil
                    end
                end

                local current2 = v29.current
                local v141, v142

                if current.showFishIconOnBar and v66.current ~= nil then
                    v141 = current2 / current.maxProgress
                    v142 = v141 <= 0.25

                    local elapsed = os.clock()

                    if current.animateFishIcon then
                        local v143, v144, v145, v146

                        if v142 then
                            v144 = 3.5
                            v145 = 4
                            v146 = 4
                            v143 = 12
                        else
                            v144 = 1.8
                            v145 = 2
                            v146 = 2.5
                            v143 = 6
                        end

                        v69.current({
                            bobY = math.sin(elapsed * v144) * v146,
                            fillRatio = v141,
                            rotation = math.sin(elapsed * v145) * v143
                        })
                    else
                        v69.current({
                            bobY = 0,
                            rotation = 0,
                            fillRatio = v141
                        })
                    end
                end

                if not v30.current then
                    return nil
                end

                local current3 = v40.current
                local v149 = os.clock() - v31.current
                local v151 = math.max(v149 / (current3.targetDurationMs / 1000), 0)

                v64.current(v151)
                v72.current(os.clock() * current.barTextureSpeed % 1)

                local v153 = math.abs(v149 * 1000 - current3.targetDurationMs)

                v75.current(current.showPerfectTimingColor and v153 <= current3.perfectWindowMs)

                if v149 < (current3.targetDurationMs + current.lateGraceMs) / 1000 then
                    return nil
                end

                v30.current = false
                v13(false)
                v64.current(0)
                v75.current(false)

                local current4 = v34.current
                local v154 = v63.current(-current.timeoutProgressPenalty)
                local actualDelta, newProgress = v154.actualDelta, v154.newProgress

                v39.current.misses += 1

                local current5 = v45.current

                if current5 ~= nil then
                    current5({
                        rating = "miss",
                        timingErrorMs = nil,
                        index = v33.current,
                        progressAfter = newProgress,
                        progressDelta = actualDelta
                    })
                end

                v62.current("miss", current4)
                playFeedback("miss", current3.actionType, current4)

                if newProgress <= 0 then
                    connection:Disconnect()
                    v60.current()

                    return nil
                end

                queueNextCircle(0)
            end)

            return function() -- line: 1032
                -- upvalues: connection (ref)
                return connection:Disconnect()
            end
        end, { v10 })
        useEffect(function() -- line: 1037
            -- upvalues: v36 (copy)
            return function() -- line: 1038
                -- upvalues: v36 (copy)
                if v36.current ~= nil then
                    task.cancel(v36.current)
                end
            end
        end, {})
        variableTimingEnabled = size * approachScaleStart

        local v155 = size * hitboxMultiplier

        hitboxMultiplier = v10 == "playing"

        local v156 = v10 == "success" or v10 == "failed"
        local v157 = v10 == "countdown"
        local v158 = countdownSteps[v14 + 1]

        if v158 == nil then
            v158 = ""
        end

        local v159 = v14 == #countdownSteps - 1
        local createElement = react.createElement
        local t9 = {
            Active = false,
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            ZIndex = 1,
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.fromScale(0.5, 0.5),
            Size = UDim2.fromScale(1, 1)
        }
        local v160 = v157 and react.createElement(default2, {
            fade = v50,
            isGo = v159,
            scale = v48,
            text = v158
        })
        local v161, v162

        if v10 == "failed" then
            v162 = react.createElement
            v161 = {
                BackgroundTransparency = 1,
                Text = "Fish Escaped! :(",
                TextScaled = true,
                ZIndex = 100,
                AnchorPoint = Vector2.new(0.5, 0.5),
                Font = Enum.Font.GothamBlack,
                Position = UDim2.fromScale(0.5, 0.44)
            }
            v161.Size = v79:map(function(p37) -- line: 1074
                return UDim2.fromOffset(1000 * p37, 180 * p37)
            end)
            v161.TextColor3 = Color3.fromRGB(255, 60, 60)
            v162 = v162("textlabel", v161, react.createElement("uistroke", {
                Thickness = 4,
                Color = Color3.fromRGB(0, 0, 0)
            }))
        else
            v162 = false
        end

        local v163

        if hitboxMultiplier or v156 then
            local createElement = react.createElement
            local t10 = {
                Active = false,
                BorderSizePixel = 0,
                ClipsDescendants = false,
                ZIndex = 12,
                AnchorPoint = Vector2.new(0.5, 0.5),
                BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                BackgroundTransparency = if showPlayAreaBounds then 0.8 else 1,
                Position = UDim2.fromScale(0.5, 0.44),
                Size = UDim2.fromOffset(playAreaWidth2, playAreaHeight2)
            }
            local v164 = showPlayAreaBounds and react.createElement("uistroke", {
                Thickness = 1,
                Transparency = 0.75,
                Color = Color3.fromRGB(255, 255, 255)
            })
            local v165 = showPlayAreaBounds and react.createElement("uicorner", {
                CornerRadius = UDim.new(0, 16)
            })

            if hitboxMultiplier then
                v12 = v12 and react.createElement(default5, {
                    actionType = pull,
                    approachRingColor = v9.approachRing,
                    approachRingWidth = approachRingWidth,
                    circleNumber = v16,
                    containerPad = variableTimingEnabled,
                    glowColor = v9.innerPerfectGlow,
                    glowSize = v96,
                    glowTransparency = v95,
                    hitboxSize = v155,
                    innerBorderColor = v94,
                    innerBorderWidth = innerBorderWidth,
                    innerFillColor = v92,
                    innerFillTransparency = v93,
                    onAttempt = function() -- onAttempt | line: 1114
                        -- upvalues: handleAttempt (copy)
                        return handleAttempt()
                    end,
                    ringSize = v83,
                    showActionLabels = showActionLabels,
                    size = size,
                    targetPos = v18
                })
            else
                v12 = hitboxMultiplier
            end

            v163 = createElement("frame", t10, v164, v165, v12, react.createElement(default3, {
                impacts = v22,
                onImpactDone = removeImpact
            }), v20 ~= nil and react.createElement(default, {
                anchorPoint = Vector2.new(0.5, 1),
                color = v20.gradient or v20.color,
                overrideProps = {
                    TextScaled = true,
                    ZIndex = 6,
                    Size = v97
                },
                position = UDim2.fromOffset(v20.pos.x, v20.pos.y - size * 0.65),
                strokeProps = {
                    Thickness = 0.085
                },
                text = v20.text
            }))
        else
            v163 = v156
        end

        v161 = if hitboxMultiplier or v156 then react.createElement(default4, {
            barBorderColor = v91,
            barBorderThickness = barBorderThickness2,
            barBottomOffset = barBottomOffset2,
            barCornerRadius = barCornerRadius,
            barFillGradient = v90,
            barFillScale = v87,
            barHeight = barHeight2,
            barTrack = v9.barTrack,
            barWidth = barWidth2,
            progressText = v88,
            pulseScale = v82,
            showProgressPercent = showProgressPercent,
            texturePos = v71
        }) else v156

        if hitboxMultiplier or v156 then
            if showFishIconOnBar then
                showFishIconOnBar = currentFish ~= nil and react.createElement("imagelabel", {
                    BackgroundTransparency = 1,
                    BorderSizePixel = 0,
                    ZIndex = 8,
                    AnchorPoint = Vector2.new(0.5, 0.5),
                    Image = currentFish.imageId,
                    Position = v98,
                    Rotation = v103,
                    Size = UDim2.fromOffset(fishIconSize, fishIconSize)
                }, react.createElement("uicorner", {
                    CornerRadius = UDim.new(0.5, 0)
                }), react.createElement("uistroke", {
                    Transparency = 0,
                    Color = v6,
                    Thickness = v104
                }))
            end
        else
            showFishIconOnBar = v156
        end

        return createElement("frame", t9, v160, v162, v163, v161, showFishIconOnBar)
    end
}
