-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local useBinding, useEffect, useRef, useState = react.useBinding, react.useEffect, react.useRef, react.useState
local events = RuntimeLib.import(script, script.Parent.Parent.Parent.Parent.Parent, "network").events
local out = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "pretty-react-hooks", "out")
local useBindingState, useMotion, useViewport = out.useBindingState, out.useMotion, out.useViewport
local services = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services")
local MarketplaceService, Players, RunService, UserInputService = services.MarketplaceService, services.Players, services.RunService, services.UserInputService
local playClonedSound = RuntimeLib.import(script, script.Parent.Parent.Parent.Parent.Parent, "vfx").playClonedSound
local haptics = RuntimeLib.import(script, script.Parent.Parent.Parent.Parent.Parent, "haptics")
local hapticDrag, hapticPerfectHit = haptics.hapticDrag, haptics.hapticPerfectHit
local v1 = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "store-utils")
local instantCaptureProductId, instantCaptureFrostwyrmProductId, instantCaptureUncThuluProductId = v1.instantCaptureProductId, v1.instantCaptureFrostwyrmProductId, v1.instantCaptureUncThuluProductId
local default = RuntimeLib.import(script, script.Parent, "boss-instant-capture-offer").default
local useConfig = RuntimeLib.import(script, script.Parent.Parent.Parent.Parent, "context", "config-context").useConfig
local default2 = RuntimeLib.import(script, script.Parent.Parent.Parent.Parent, "common", "brainrot-style", "popout-text-two").default
local default3 = RuntimeLib.import(script, script.Parent.Parent.Parent.Parent, "common", "reward-screen").default
local getExclusiveFishConfigByFishName = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "data", "exclusive-fish").getExclusiveFishConfigByFishName
local images = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "images").images
local useRootSelector = RuntimeLib.import(script, script.Parent.Parent.Parent.Parent, "hooks", "reflex").useRootSelector
local localPlayerUserId = RuntimeLib.import(script, script.Parent.Parent.Parent.Parent.Parent, "utils").localPlayerUserId
local selectPlayerBuffBonuses = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "slices", "player-data", "selectors").selectPlayerBuffBonuses
local getChampionMutationChance = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "mutation-roll-utils").getChampionMutationChance
local v2 = RuntimeLib.import(script, script.Parent.Parent.Parent.Parent.Parent, "fishing-phase-atom")
local bossActivePromptAtom, bossScreenBorderAtom, bossWeakSpotsAtom = v2.bossActivePromptAtom, v2.bossScreenBorderAtom, v2.bossWeakSpotsAtom
local v3 = RuntimeLib.import(script, script.Parent.Parent, "cast-grade-text")
local castGradeGradients, gradeConfigs = v3.castGradeGradients, v3.gradeConfigs
local v4 = RuntimeLib.import(script, script.Parent.Parent, "rare-fish-skillcheck.config")
local computeBarFillGradient, defaultColors, getImpactConfig, hitRatingToGrade = v4.computeBarFillGradient, v4.defaultColors, v4.getImpactConfig, v4.hitRatingToGrade
local resolveRareFishColors = v4.resolveRareFishColors
local default4 = RuntimeLib.import(script, script.Parent.Parent, "rare-fish-skillcheck-countdown").default
local default5 = RuntimeLib.import(script, script.Parent.Parent, "rare-fish-skillcheck-feedback-layer").default
local default6 = RuntimeLib.import(script, script.Parent.Parent, "rare-fish-skillcheck-progress-bar").default
local v5 = RuntimeLib.import(script, script.Parent, "boss-prompt")
local BossTapPrompt, BossSlidePrompt = v5.BossTapPrompt, v5.BossSlidePrompt
local v6 = RuntimeLib.import(script, script.Parent, "boss-config")
local allWeakSpotIds, bossIntroTapCount, bossPhasePacing, bossTuning = v6.allWeakSpotIds, v6.bossIntroTapCount, v6.bossPhasePacing, v6.bossTuning
local getBossPhase, pickBossAction = v6.getBossPhase, v6.pickBossAction
local v7 = RuntimeLib.import(script, script.Parent, "boss-sfx")
local playRareFishBossSfxCue, tapSfxCueForRating = v7.playRareFishBossSfxCue, v7.tapSfxCueForRating

local function isEasyBossQteVariant(p1) -- line: 69
    if p1 == "aEasy" then
        return true
    end

    return p1 == "bEasy"
end

local function shouldEnableBossQteSlides(p2, p3) -- line: 72
    if p2 == "aHard" or p2 == "superBoss" then
        return p3
    end

    return false
end

local function getInstantCaptureOffer(p4) -- line: 85
    -- upvalues: instantCaptureProductId (copy), instantCaptureFrostwyrmProductId (copy), instantCaptureUncThuluProductId (copy)
    if (if p4 == nil then p4 else p4.name) == "Frostwyrm" then
        return {
            priceRobux = 299,
            productId = instantCaptureFrostwyrmProductId
        }
    end

    if (if p4 == nil then p4 else p4.name) == "UncThulu" then
        return {
            priceRobux = 29,
            productId = instantCaptureUncThuluProductId
        }
    end

    return {
        priceRobux = 29,
        productId = instantCaptureProductId
    }
end

local t1 = {
    "3",
    "2",
    "1",
    "GO!"
}
local t2 = {
    onScreen = false,
    x = 640,
    y = 360
}
local t3 = {
    "tap",
    "multiTap",
    "slide"
}
local t4 = {
    "common",
    "uncommon",
    "rare",
    "epic",
    "legendary",
    "mythic",
    "godly",
    "secret",
    "hacked",
    "cosmic",
    "extinct",
    "kaijuwu"
}

local function getOddsBannerText(p5, p6, p7) -- line: 138
    -- upvalues: getChampionMutationChance (copy)
    if p5 == "Goatzilla" then
        return "Goatzilla Encountered! (1 in 3)"
    end

    return if p6 then ("CHAMPION MUTATED (1 in %*)"):format((math.round(1 / getChampionMutationChance(p7)))) else nil
end

local function makeBossDifficulty(p8) -- line: 147
    return {
        drainMultiplier = 1 + 0.65 * p8,
        grabWindowMultiplier = 0.95 - 0.3 * p8,
        missPenaltyMultiplier = 1 + 0.75 * p8,
        pathToleranceMultiplier = 1 - 0.3 * p8,
        rewardMultiplier = 1 - 0.22 * p8,
        slideChanceBonus = 0.22 * p8,
        slideWindowMultiplier = 0.93 - 0.28 * p8,
        spawnDelayMultiplier = 0.95 - 0.27 * p8,
        tapDurationMultiplier = 0.92 - 0.3 * p8,
        timingWindowMultiplier = 0.92 - 0.34 * p8
    }
end

local t5 = {}
local v9 = #t4 - 1

for v10, v11 in t4 do
    t5[v11] = makeBossDifficulty((v10 - 1) / v9)
end

local function RareFishSuccessCutscene(p9) -- line: 174
    -- upvalues: react (copy), useEffect (copy), useState (copy), playClonedSound (copy), default3 (copy)
    local fish, mutations, uiScale = p9.fish, p9.mutations, p9.uiScale
    local v12, v13 = useState(false)

    useEffect(function() -- line: 179
        -- upvalues: v13 (copy)
        local v14 = task.delay(1.75, function() -- line: 180
            -- upvalues: v13 (copy)
            return v13(true)
        end)

        return function() -- line: 183
            -- upvalues: v14 (copy)
            task.cancel(v14)
        end
    end, {})

    return react.createElement("frame", {
        Active = false,
        BorderSizePixel = 0,
        ZIndex = 50,
        BackgroundColor3 = Color3.fromRGB(0, 0, 0),
        BackgroundTransparency = v12 and 0 or 1,
        Size = UDim2.fromScale(1, 1)
    }, react.createElement(default3, {
        revealDelaySec = 2.55,
        title = "BOSS FISH!",
        zIndex = 50,
        fish = fish,
        mutations = mutations,
        onReveal = function() -- onReveal | line: 197
            -- upvalues: playClonedSound (copy)
            return playClonedSound("SkillCheckSuccess")
        end,
        uiScale = uiScale
    }))
end

local function RareFishFailureCutscene(p10) -- line: 206
    -- upvalues: react (copy), useEffect (copy), useMotion (copy), playClonedSound (copy), default2 (copy)
    local uiScale = p10.uiScale
    local v15, v16 = useMotion(0)
    local v17, v18 = useMotion(0)

    useEffect(function() -- line: 210
        -- upvalues: v16 (copy), v18 (copy), playClonedSound (copy)
        playClonedSound("RareFishFail")
        v16:linear(1, {
            speed = 0.6896551724137931
        })
        v18:spring(1, {
            damping = 0.38,
            frequency = 0.55
        })
    end, { v18, v16 })

    local v19 = v15:map(function(p11) -- line: 220
        if p11 < 0.12 then
            return 1 - p11 / 0.12
        end

        if p11 > 0.86 then
            return (p11 - 0.86) / 0.14
        end

        return 0
    end)
    local v20 = v15:map(function(p12) -- line: 229
        if p12 <= 0.52 then
            return 0
        end

        return (math.clamp((p12 - 0.52) / 0.2, 0, 1))
    end)
    local v22 = v15:map(function(p13) -- line: 235
        return math.sin(p13 * 3.141592653589793 * 5) * (1 - p13) * 8
    end)

    return react.createElement("frame", {
        Active = false,
        BorderSizePixel = 0,
        ZIndex = 50,
        BackgroundColor3 = Color3.fromRGB(0, 0, 0),
        BackgroundTransparency = v19:map(function(p14) -- line: 241
            return 0.12 + p14 * 0.88
        end),
        Size = UDim2.fromScale(1, 1)
    }, react.createElement(default2, {
        text = "FAIL",
        anchorPoint = Vector2.new(0.5, 0.5),
        color = Color3.fromRGB(255, 35, 35),
        overrideProps = {
            TextScaled = true,
            ZIndex = 60,
            Rotation = v22,
            Size = v17:map(function(p15) -- line: 252
                -- upvalues: uiScale (copy)
                return UDim2.fromOffset(760 * uiScale * p15, 190 * uiScale * p15)
            end),
            TextTransparency = v20
        },
        position = UDim2.fromScale(0.5, 0.42),
        strokeProps = {
            Thickness = 0.095
        }
    }), react.createElement("textlabel", {
        BackgroundTransparency = 1,
        Text = "THE BOSS FISH ESCAPED",
        TextScaled = true,
        ZIndex = 60,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Font = Enum.Font.GothamBlack,
        Position = UDim2.fromScale(0.5, 0.58),
        Size = UDim2.fromOffset(700 * uiScale, 64 * uiScale),
        TextColor3 = Color3.fromRGB(255, 210, 210),
        TextTransparency = v20
    }, react.createElement("uistroke", {
        Color = Color3.fromRGB(0, 0, 0),
        Thickness = math.max(1.5, 3 * uiScale),
        Transparency = v20
    })))
end

local function RareFishSimpleFailureCutscene(p16) -- line: 281
    -- upvalues: react (copy), useEffect (copy), useMotion (copy), default2 (copy)
    local message, uiScale = p16.message, p16.uiScale
    local v26, v27 = useMotion(0)

    useEffect(function() -- line: 285
        -- upvalues: v27 (copy)
        v27:linear(1, {
            speed = 0.6896551724137931
        })
    end, { v27 })

    local v28 = v26:map(function(p17) -- line: 290
        if p17 < 0.12 then
            return 1 - p17 / 0.12
        end

        if not (p17 > 0.78) then
            return 0
        end

        return (math.clamp((p17 - 0.78) / 0.22, 0, 1))
    end)

    return react.createElement("frame", {
        Active = false,
        BorderSizePixel = 0,
        ZIndex = 50,
        BackgroundColor3 = Color3.fromRGB(0, 0, 0),
        Size = UDim2.fromScale(1, 1)
    }, react.createElement(default2, {
        anchorPoint = Vector2.new(0.5, 0.5),
        color = Color3.fromRGB(185, 245, 255),
        overrideProps = {
            TextScaled = true,
            ZIndex = 60,
            Size = UDim2.fromOffset(700 * uiScale, 110 * uiScale),
            TextTransparency = v28
        },
        position = UDim2.fromScale(0.5, 0.48),
        strokeProps = {
            Thickness = 0.08,
            Color = Color3.fromRGB(0, 0, 0)
        },
        text = message
    }))
end

return {
    activeRareFishBossQteVariant = "aHard",
    isEasyBossQteVariant = isEasyBossQteVariant,
    shouldEnableBossQteSlides = shouldEnableBossQteSlides,
    default = function(p18) -- RareFishBossSkillCheck | line: 322
        -- upvalues: react (copy), useBinding (copy), useEffect (copy), useRef (copy), useState (copy), events (copy), useBindingState (copy), useMotion (copy), useViewport (copy), MarketplaceService (copy), Players (copy), RunService (copy), UserInputService (copy), hapticDrag (copy), hapticPerfectHit (copy), default (copy), useConfig (copy), default2 (copy), getExclusiveFishConfigByFishName (copy), images (copy), useRootSelector (copy), localPlayerUserId (copy), selectPlayerBuffBonuses (copy), bossActivePromptAtom (copy), bossScreenBorderAtom (copy), bossWeakSpotsAtom (copy), castGradeGradients (copy), gradeConfigs (copy), computeBarFillGradient (copy), defaultColors (copy), getImpactConfig (copy), hitRatingToGrade (copy), resolveRareFishColors (copy), default4 (copy), default5 (copy), default6 (copy), BossTapPrompt (copy), BossSlidePrompt (copy), allWeakSpotIds (copy), bossIntroTapCount (copy), bossPhasePacing (copy), bossTuning (copy), getBossPhase (copy), pickBossAction (copy), playRareFishBossSfxCue (copy), tapSfxCueForRating (copy), getInstantCaptureOffer (copy), t1 (copy), t2 (copy), t3 (copy), getOddsBannerText (copy), t5 (copy), RareFishSuccessCutscene (copy), RareFishFailureCutscene (copy), RareFishSimpleFailureCutscene (copy)
        local currentFish, difficultyMultiplier = p18.currentFish, p18.difficultyMultiplier

        if difficultyMultiplier == nil then
            difficultyMultiplier = 1
        end

        local easyMode = p18.easyMode

        if easyMode == nil then
            easyMode = false
        end

        local failureMessage = p18.failureMessage

        if failureMessage == nil then
            failureMessage = "Better luck next time..."
        end

        local fishId, instantCaptureEnabled = p18.fishId, p18.instantCaptureEnabled
        local v30 = instantCaptureEnabled

        if instantCaptureEnabled == nil then
            v30 = true
        end

        local multiTapProgressMultiplier = p18.multiTapProgressMultiplier
        local v31 = multiTapProgressMultiplier

        if multiTapProgressMultiplier == nil then
            v31 = 0.3
        end

        local mutations = p18.mutations

        if mutations == nil then
            mutations = {}
        end

        local onComplete, onFailed, onHit, onPhaseChanged = p18.onComplete, p18.onFailed, p18.onHit, p18.onPhaseChanged
        local onSuccessCutscene, onTelegraph, progressIconImage, progressIconText = p18.onSuccessCutscene, p18.onTelegraph, p18.progressIconImage, p18.progressIconText
        local v32 = p18.showCountdown

        if v32 == nil then
            v32 = true
        end

        local slidePromptsEnabled = p18.slidePromptsEnabled
        local v33 = slidePromptsEnabled

        if slidePromptsEnabled == nil then
            v33 = true
        end

        local skipSuccessRewardScreen = p18.skipSuccessRewardScreen
        local v34 = skipSuccessRewardScreen

        if skipSuccessRewardScreen == nil then
            v34 = false
        end

        local qteVariant = p18.qteVariant

        if qteVariant == nil then
            qteVariant = "aHard"
        end

        local randomScreenPromptPositions = p18.randomScreenPromptPositions
        local v35 = randomScreenPromptPositions

        if randomScreenPromptPositions == nil then
            v35 = false
        end

        local randomPromptScreenInsetScale = p18.randomPromptScreenInsetScale
        local v36 = randomPromptScreenInsetScale

        if randomPromptScreenInsetScale == nil then
            v36 = 0
        end

        local simpleFailureCutscene = p18.simpleFailureCutscene

        if simpleFailureCutscene == nil then
            simpleFailureCutscene = false
        end

        local startDelayMs = p18.startDelayMs
        local v37 = startDelayMs

        if startDelayMs == nil then
            v37 = 0
            startDelayMs = 0
        end

        local v38 = resolveRareFishColors(nil)
        local v39 = currentFish ~= nil

        if v39 then
            v39 = getExclusiveFishConfigByFishName(currentFish.name)

            if v39 ~= nil then
                v39 = v39.bossFight
            end
        end

        local v40

        if v39 then
            v40 = "cosmic"
        else
            v40 = if currentFish ~= nil then currentFish.rarity else currentFish

            if v40 == nil then
                v40 = "rare"
            end
        end

        local v41 = getInstantCaptureOffer(currentFish)

        v39 = t5[v40] or t5.rare

        if easyMode then
            v39 = {
                drainMultiplier = 1 + (v39.drainMultiplier - 1) * 0.5,
                grabWindowMultiplier = 1 - (1 - v39.grabWindowMultiplier) * 0.5,
                missPenaltyMultiplier = 1 + (v39.missPenaltyMultiplier - 1) * 0.5,
                pathToleranceMultiplier = 1 - (1 - v39.pathToleranceMultiplier) * 0.5,
                rewardMultiplier = 1 - (1 - v39.rewardMultiplier) * 0.5,
                slideChanceBonus = v39.slideChanceBonus * 0.5,
                slideWindowMultiplier = 1 - (1 - v39.slideWindowMultiplier) * 0.5,
                spawnDelayMultiplier = 1 - (1 - v39.spawnDelayMultiplier) * 0.5,
                tapDurationMultiplier = 1 - (1 - v39.tapDurationMultiplier) * 0.5,
                timingWindowMultiplier = 1 - (1 - v39.timingWindowMultiplier) * 0.5
            }
        end

        local t12 = {
            drainMultiplier = v39.drainMultiplier * difficultyMultiplier,
            grabWindowMultiplier = v39.grabWindowMultiplier / difficultyMultiplier,
            missPenaltyMultiplier = v39.missPenaltyMultiplier * difficultyMultiplier,
            pathToleranceMultiplier = v39.pathToleranceMultiplier / difficultyMultiplier,
            rewardMultiplier = v39.rewardMultiplier / difficultyMultiplier,
            slideChanceBonus = v39.slideChanceBonus * difficultyMultiplier,
            slideWindowMultiplier = v39.slideWindowMultiplier / difficultyMultiplier,
            spawnDelayMultiplier = v39.spawnDelayMultiplier / difficultyMultiplier,
            tapDurationMultiplier = v39.tapDurationMultiplier / difficultyMultiplier,
            timingWindowMultiplier = v39.timingWindowMultiplier / difficultyMultiplier
        }

        print((("[BossSkillCheck] easyMode: %*, qteVariant: %*"):format(easyMode, qteVariant)))

        local v42 = useBindingState(useViewport())
        local v43 = v42.X / 1050
        local v44 = v42.Y / 700
        local v45
        local v46 = math.clamp(math.min(v43, v44), 0.55, 1)
        local v47 = useRef(v46)

        v47.current = v46

        local v48 = useRootSelector(selectPlayerBuffBonuses(localPlayerUserId))

        useEffect(function() -- line: 445
            -- upvalues: events (copy)
            events.analyticsRareSkillCheckStarted:fire()
        end, {})
        v45 = if v32 then "countdown" else "playing"
        v32 = if startDelayMs > 0 then "idle" else v45

        local v49, v50 = useState(v32)

        useEffect(function() -- line: 452
            -- upvalues: v49 (copy), events (copy)
            if v49 == "countdown" then
                events.analyticsRareFishCountdownStarted:fire()
            end
        end, { v49 })

        local v51, v52 = useState(false)
        local v53, v54 = useState(false)
        local tap, tap2 = useState("tap")
        local v55, v56 = useState({})
        local v57, v58 = useState(0)
        local v59, v60 = useState(nil)
        local v61, v62 = useState({})
        local v63, v64 = useBinding(UDim2.fromOffset(0, 0))
        local v65, v66 = useBinding(UDim2.fromOffset(0, 0))
        local v67, v68 = useBinding(1)
        local v69, v70 = useBinding(false)
        local v71, v72 = useBinding(UDim2.fromOffset(0, 0))
        local v73, v74 = useBinding(UDim2.fromOffset(0, 0))
        local v75, v76 = useBinding(0)
        local v77, v78 = useBinding(0)
        local v79, v80 = useBinding(0)
        local v81, v82 = useBinding(false)
        local v83, v84 = useBinding(bossTuning.initialProgress / bossTuning.maxProgress)
        local v85, v86 = useBinding(UDim2.fromScale(0, 0))
        local v87 = useRef(true)
        local v88 = useRef(v32)
        local v89 = useRef(bossTuning.initialProgress)
        local v90 = useRef(nil)
        local v91 = useRef({})
        local v92 = useRef(0)
        local v93 = useRef(nil)
        local v94 = useRef(nil)
        local v95 = useRef(nil)
        local intro = useRef("intro")
        local v96 = useRef(0)
        local v97 = useRef(nil)
        local v98 = useRef(0)
        local v99 = useRef(nil)
        local v100 = useRef(nil)
        local v101 = useRef(nil)
        local v102 = useRef(0)
        local v103 = useRef(nil)
        local v104 = useRef(0)
        local v105 = useRef(false)
        local v106 = qteVariant == "bEasy"
        local v107 = qteVariant == "bHard" or qteVariant == "superBoss"
        local v108 = qteVariant == "superBoss"
        local v109 = useRef(onComplete)
        local v110 = useRef(onFailed)
        local v111 = useRef(onHit)
        local v112 = useRef(onPhaseChanged)
        local v113 = useRef(onSuccessCutscene)
        local v114 = useRef(onTelegraph)

        v109.current = onComplete
        v110.current = onFailed
        v111.current = onHit
        v112.current = onPhaseChanged
        v113.current = onSuccessCutscene
        v114.current = onTelegraph

        local getSound = useConfig().getSound
        local v115 = useRef(nil)
        local v116, v117 = useBinding(0.45)
        local v118, v119 = useBinding(0)
        local v120 = useRef(0)
        local v121 = useRef(os.clock())
        local v122, v123 = useMotion(0)
        local v124, v125 = useMotion(1)
        local v126, v127 = useBinding({
            bobY = 0,
            rotation = 0,
            fillRatio = bossTuning.initialProgress / bossTuning.maxProgress
        })

        useEffect(function() -- line: 530
            -- upvalues: v49 (copy), v88 (copy)
            v88.current = v49
        end, { v49 })
        useEffect(function() -- line: 533
            -- upvalues: v87 (copy), v97 (copy), v99 (copy), v100 (copy), v101 (copy)
            return function() -- line: 534
                -- upvalues: v87 (copy), v97 (copy), v99 (copy), v100 (copy), v101 (copy)
                v87.current = false

                if v97.current ~= nil then
                    task.cancel(v97.current)
                end

                if v99.current ~= nil then
                    task.cancel(v99.current)
                end

                if v100.current ~= nil then
                    task.cancel(v100.current)
                end

                if v101.current ~= nil then
                    task.cancel(v101.current)
                end
            end
        end, {})
        useEffect(function() -- line: 551
            -- upvalues: v37 (ref), v50 (copy), v87 (copy), v45 (ref)
            if v37 <= 0 then
                return nil
            end

            local v128 = task.delay(v37 / 1000, function() -- line: 555
                -- upvalues: v50 (copy), v87 (copy), v45 (ref)
                if not v87.current then
                    return nil
                end

                v50(v45)
            end)

            return function() -- line: 561
                -- upvalues: v128 (copy)
                return task.cancel(v128)
            end
        end, {})

        local v129 = v83:map(function(p19) -- line: 566
            return UDim2.fromScale(math.clamp(p19, 0, 1), 1.1)
        end)
        local v130 = v83:map(function(p20) -- line: 569
            -- upvalues: bossTuning (copy)
            return (("%*%%"):format((math.floor(p20 * bossTuning.maxProgress))))
        end)
        local v132 = v83:map(function(p21) -- line: 572
            -- upvalues: computeBarFillGradient (copy)
            return computeBarFillGradient(p21)
        end)
        local v133 = v83:map(function(_) -- line: 575
            return Color3.fromRGB(0, 0, 0)
        end)
        local v134 = v69:map(function(p23) -- line: 578
            if p23 then
                return (Color3.fromRGB(125, 255, 80))
            end

            return (Color3.fromRGB(255, 255, 255))
        end)
        local v135 = v69:map(function(p24) -- line: 581
            if p24 then
                return (Color3.fromRGB(65, 255, 115))
            end

            return (Color3.fromRGB(124, 128, 134))
        end)
        local v136 = v69:map(function(p25) -- line: 584
            if p25 then
                return 0.65
            end

            return 0.35
        end)
        local v137 = v69:map(function(p26) -- line: 587
            -- upvalues: v38 (copy)
            if p26 then
                return v38.innerPerfectBorder
            end

            return v38.innerBorder
        end)
        local v138 = v122:map(function(p27) -- line: 590
            -- upvalues: v46 (copy)
            return UDim2.fromOffset(v46 * 220 * p27, v46 * 54 * p27)
        end)

        v122 = 1 + v48.bossQteSize

        local v139 = 1 + v48.bossDamage
        local v140 = bossTuning.tap.size * v46 * v122
        local v142 = math.max(3, bossTuning.tap.approachRingWidth * v46)
        local v144 = math.max(2, bossTuning.tap.innerBorderWidth * v46)
        local v145 = bossTuning.tap.size * bossTuning.tap.hitboxMultiplier * v46 * v122
        local v146 = bossTuning.slide.startSize * v46 * v122
        local v147 = bossTuning.slide.endSize * v46 * v122
        local v149 = math.max(16, bossTuning.slide.pathWidth * v46)
        local v150 = v46 * 132
        local v151 = v46 * 660
        local v153 = math.max(2, v46 * 4)
        local v154 = v46 * 62
        local v156 = math.max(38, v46 * 72)
        local v157 = v126:map(function(p28) -- line: 609
            -- upvalues: v151 (copy), v153 (copy), v154 (copy), v156 (copy)
            return UDim2.new(0.5, math.floor(-v151 / 2 + v153 + math.clamp(p28.fillRatio, 0, 1) * (v151 - v153 * 2) + 4), 1, (math.floor(-v156 - v154 / 2 + p28.bobY * 1.65)))
        end)
        local v155 = v126:map(function(p29) -- line: 612
            return p29.rotation
        end)

        local function projectionFor(p30) -- line: 616
            -- upvalues: v35 (ref), v93 (copy), bossWeakSpotsAtom (copy), t2 (copy)
            local current = v93.current

            if v35 and current ~= nil then
                return {
                    onScreen = true,
                    x = current.x,
                    y = current.y
                }
            end

            local v162 = bossWeakSpotsAtom()[p30]

            if v162 == nil then
                return t2
            end

            return v162
        end

        local function randomScreenPoint(p31) -- line: 633
            -- upvalues: v36 (ref), v42 (copy), v47 (copy), v154 (copy), v156 (copy)
            local v165 = math.max(18 * v47.current, p31 + 10 * v47.current)
            local v167 = math.max(v165, v42.X * v36)
            local v169 = math.max(v165, v42.Y * v36)
            local v172 = math.max(v165, v156 + v154 + 28 * v47.current, v42.Y * v36)
            local v174 = math.max(v167, v42.X - v167)
            local v176 = math.max(v169, v42.Y - v172)

            return {
                x = math.random(math.floor(v167), (math.floor(v174))),
                y = math.random(math.floor(v169), (math.floor(v176)))
            }
        end

        local function clampScreenPoint(p32, p33) -- line: 645
            -- upvalues: v42 (copy), v47 (copy), v154 (copy), v156 (copy)
            local v179 = math.max(18 * v47.current, p33 + 10 * v47.current)
            local v180 = v156 + v154 + 28 * v47.current

            return {
                x = math.clamp(p32.x, v179, (math.max(v179, v42.X - v179))),
                y = math.clamp(p32.y, v179, (math.max(v179, v42.Y - v180)))
            }
        end

        local function clampSlideSegment(p34, p35) -- line: 653
            -- upvalues: v42 (copy), v47 (copy), v146 (copy), v147 (copy), v149 (copy), v154 (copy), v156 (copy), clampScreenPoint (copy)
            local v185 = math.max(v146, v147) * 0.5 + v149 * 0.5
            local t14 = {
                x = p34.x + p35.X,
                y = p34.y + p35.Y
            }
            local v188 = math.max(18 * v47.current, v185 + 10 * v47.current)
            local v190 = math.max(v188, v42.X - v188)
            local v192 = math.max(v188, v42.Y - (v156 + v154 + 28 * v47.current))
            local x = p34.x
            local x2 = t14.x
            local v193 = if math.min(x, x2) < v188 then v188 - math.min(p34.x, t14.x) elseif v190 < math.max(p34.x, t14.x) then v190 - math.max(p34.x, t14.x) else 0
            local y = p34.y
            local y2 = t14.y
            local v194 = if math.min(y, y2) < v188 then v188 - math.min(p34.y, t14.y) elseif v192 < math.max(p34.y, t14.y) then v192 - math.max(p34.y, t14.y) else 0
            local t15 = {
                x = p34.x + v193,
                y = p34.y + v194
            }

            return {
                ["end"] = clampScreenPoint({
                    x = t14.x + v193,
                    y = t14.y + v194
                }, v185),
                start = clampScreenPoint(t15, v185)
            }
        end

        local function onScreenSpots() -- line: 689
            -- upvalues: v35 (ref), bossWeakSpotsAtom (copy), allWeakSpotIds (copy)
            if v35 then
                return allWeakSpotIds
            end

            local v195 = bossWeakSpotsAtom()
            local t17 = {}

            for _, v196 in allWeakSpotIds do
                local v197 = v195[v196]

                if v197 ~= nil and v197.onScreen then
                    table.insert(t17, v196)
                end
            end

            return t17
        end

        local function applyProgressDelta(p36) -- line: 703
            -- upvalues: v84 (copy), v89 (copy), bossTuning (copy)
            local v199 = math.clamp(v89.current + p36, 0, bossTuning.maxProgress)

            v89.current = v199
            v84(v199 / bossTuning.maxProgress)

            return v199
        end

        local function spawnScreenImpact(p37, _, p39) -- line: 710
            -- upvalues: v62 (copy), v87 (copy), v96 (copy)
            if not v87.current then
                return nil
            end

            v96.current += 1
            v62(function(p40) -- line: 715
                -- upvalues: p37 (copy), p39 (copy), v96 (copy)
                local t18 = {}
                local v200 = #t18
                local v201 = #p40

                table.move(p40, 1, v201, v200 + 1, t18)
                t18[v200 + v201 + 1] = {
                    actionType = "pull",
                    id = v96.current,
                    pos = p39,
                    rating = p37
                }

                return t18
            end)
        end

        local function removeImpact(p41) -- line: 730
            -- upvalues: v62 (copy), v87 (copy)
            if not v87.current then
                return nil
            end

            v62(function(p42) -- line: 734
                -- upvalues: p41 (copy)
                local t19 = {}
                local n1 = 0

                for v202, v203 in p42 do
                    local _ = v202 - 1

                    if v203.id ~= p41 == true then
                        n1 += 1
                        t19[n1] = v203
                    end
                end

                return t19
            end)
        end

        local function pulseProgressBar(p43, p44) -- line: 751
            -- upvalues: v125 (copy)
            v125:set(p44)
            v125:tween(1, {
                time = 0.22,
                direction = Enum.EasingDirection.Out,
                style = if p43 == "miss" then Enum.EasingStyle.Quad else Enum.EasingStyle.Back
            })
        end

        local function showFeedback(p45, p46) -- line: 759
            -- upvalues: v60 (copy), v87 (copy), v90 (copy), v97 (copy), v123 (copy), castGradeGradients (copy), gradeConfigs (copy), defaultColors (copy), hitRatingToGrade (copy)
            if not v87.current then
                return nil
            end

            if v97.current ~= nil then
                task.cancel(v97.current)
            end

            local v204 = hitRatingToGrade[p45]
            local _ = v90.current

            v60({
                color = if v204 == nil then defaultColors.ratingMiss else Color3.fromRGB(255, 255, 255),
                gradient = if v204 == nil then nil else castGradeGradients[v204],
                pos = p46,
                text = if v204 == nil then "MISS" else gradeConfigs[v204].text
            })
            v123:set(0)
            v123:tween(1, {
                time = 0.12,
                direction = Enum.EasingDirection.Out,
                style = Enum.EasingStyle.Back
            })
            v97.current = task.delay(0.75, function() -- line: 780
                -- upvalues: v60 (copy), v87 (copy), v97 (copy)
                if not v87.current then
                    return nil
                end

                v60(nil)
                v97.current = nil
            end)
        end

        local projForScreen

        local function spawnNextPrompt() -- line: 790
            -- upvalues: v33 (ref), v35 (ref), t12 (copy), v47 (copy), v54 (copy), tap2 (copy), v56 (copy), v66 (copy), v68 (copy), v70 (copy), v76 (copy), v78 (copy), v82 (copy), v87 (copy), v88 (copy), v89 (copy), v90 (copy), v91 (copy), v92 (copy), v93 (copy), v94 (copy), v95 (copy), intro (copy), v100 (copy), v112 (copy), v114 (copy), v140 (copy), randomScreenPoint (copy), clampScreenPoint (copy), onScreenSpots (copy), projForScreen (ref), v108 (copy), v106 (copy), v107 (copy), react (copy), bossActivePromptAtom (copy), bossIntroTapCount (copy), bossPhasePacing (copy), bossTuning (copy), getBossPhase (copy), pickBossAction (copy), playRareFishBossSfxCue (copy), t3 (copy)
            if not v87.current or v88.current ~= "playing" then
                return nil
            end

            local v206 = getBossPhase(v89.current / bossTuning.maxProgress)

            if v206 ~= intro.current then
                intro.current = v206

                local current = v112.current

                if current ~= nil then
                    current(v206)
                end
            end

            local v207 = bossPhasePacing[v206]
            local v209 = math.clamp(v207.slideChance + t12.slideChanceBonus, 0, 0.75)
            local current = v92.current

            v92.current = current + 1

            local v210 = onScreenSpots()
            local enableSlidePrompts

            if v33 == true then
                if not v107 or v108 then
                    enableSlidePrompts = bossTuning.enableSlidePrompts

                    if enableSlidePrompts then
                        enableSlidePrompts = #v210 >= 1 and bossIntroTapCount <= current
                    end
                else
                    enableSlidePrompts = v108
                end
            else
                enableSlidePrompts = false
            end

            local v212 = v107

            if v107 then
                v212 = v94.current ~= "multiTap" and #v210 >= 2 and bossIntroTapCount <= current
            end

            local v213 = enableSlidePrompts and math.random() < v209
            local v214 = v212 and math.random() < 0.5
            local v215, v216

            if v108 and bossIntroTapCount <= current then
                local v217 = t3[(current - bossIntroTapCount) % #t3 + 1]

                if v217 ~= "slide" or not enableSlidePrompts then
                    if v217 ~= "multiTap" or not v212 then
                        v215 = "tap"
                        v216 = "tap"
                    else
                        v215 = "multiTap"
                        v216 = "multiTap"
                    end
                else
                    v215 = "slide"
                    v216 = "slide"
                end
            elseif v212 then
                if v214 then
                    v215 = "multiTap"
                    v216 = "multiTap"
                else
                    v215 = "tap"
                    v216 = "tap"
                end
            elseif v213 then
                v215 = "slide"
                v216 = "slide"
            else
                v215 = "tap"
                v216 = "tap"
            end

            v94.current = v216

            local v218 = if v106 then 1.15 else 1

            if not (#v210 > 0) then
                v210 = { "body" }
            end

            local v219 = v210[math.random(0, #v210 - 1) + 1]

            if #v210 > 1 and v219 == v95.current then
                v219 = v210[((table.find(v210, v219) or 0) - 1 + 1) % #v210 + 1]
            end

            v95.current = v219
            v93.current = if v35 then randomScreenPoint(v140 * 1.15) else nil

            local v221 = Vector2.new(0, 0)

            if v216 == "slide" then
                local t22 = {
                    0, 30, -30, 150, 210, 180
                }
                local v223 = math.rad(t22[math.random(0, #t22 - 1) + 1])

                v221 = Vector2.new(math.cos(v223), (math.sin(v223))) * (bossTuning.slide.spanDistance * v47.current)
            end

            local v224 = pickBossAction(v216, v206 == "rage")
            local t23 = {
                slideGrabbed = false,
                slideGrabRating = "miss",
                slideStartTime = 0,
                action = v224,
                durationMs = v207.tapDurationMs * t12.tapDurationMultiplier * v218,
                grabWindowMs = v207.tapDurationMs * t12.tapDurationMultiplier * v218,
                promptType = v216,
                slidePointerStart = Vector2.new(0, 0),
                slideSpan = v221,
                spawnTime = os.clock(),
                startSpot = v219
            }

            tap2(v216)
            v76(0)
            v78(0)
            v82(false)
            v68(1)
            v70(false)
            v66(UDim2.fromOffset(0, 0))

            local function v225() -- line: 871
                -- upvalues: current (copy), v210 (ref), v215 (ref), v219 (ref), t23 (copy), v54 (copy), v56 (copy), v87 (copy), v88 (copy), v90 (copy), v91 (copy), v140 (copy), clampScreenPoint (copy), projForScreen (ref), react (copy), bossActivePromptAtom (copy), playRareFishBossSfxCue (copy)
                if not v87.current or v88.current ~= "playing" then
                    return nil
                end

                t23.spawnTime = os.clock()

                if v215 == "multiTap" then
                    local t24 = {}
                    local elapsed = os.clock()
                    local v227 = math.pow(v140 * 1.22, 2)
                    local t25 = {}

                    for i = 0, #v210 - 1 do
                        local v228 = v219
                        local v229 = v210[((table.find(v210, v228) or 0) - 1 + i) % #v210 + 1]

                        table.insert(t25, {
                            pos = projForScreen(v229),
                            spot = v229
                        })
                    end

                    local v230 = projForScreen(v219)
                    local v231 = v140 * 2.15

                    for i = 0, 7 do
                        local v232 = i / 8 * 3.141592653589793 * 2 + 0.39269908169872414

                        table.insert(t25, {
                            pos = clampScreenPoint({
                                x = v230.x + math.cos(v232) * v231,
                                y = v230.y + math.sin(v232) * v231
                            }, v140),
                            spot = v219
                        })
                    end

                    for _, v233 in t25 do
                        if #t24 >= 8 then
                            break
                        end

                        local pos, spot = v233.pos, v233.spot;

                        ({})[1] = pos;
                        ({})[1] = v227

                        local v234 = false

                        for v235, v236 in t24 do
                            local _ = v235 - 1
                            local v237 = v236.screenPos.x - pos.x
                            local v238 = v236.screenPos.y - pos.y

                            if v237 * v237 + v238 * v238 < v227 then
                                v234 = true
                                break
                            end
                        end

                        if not v234 then
                            local v239 = #t24
                            local v240, v241 = react.createBinding(100)
                            local v242 = table.clone(t23)

                            setmetatable(v242, nil)
                            v242.durationMs = 6000
                            v242.id = current * 10 + v239
                            v242.order = v239
                            v242.promptType = "multiTap"
                            v242.revealed = v239 == 0
                            v242.revealTime = elapsed + v239 * 0.075
                            v242.resolved = false
                            v242.screenPos = pos
                            v242.setTimerProgress = v241

                            if v239 == 0 then
                                v242.spawnTime = elapsed
                            else
                                v242.spawnTime = 0
                            end

                            v242.startSpot = spot
                            v242.timerProgress = v240
                            table.insert(t24, v242)
                        end
                    end

                    v90.current = nil
                    v91.current = t24
                    v56(t24)
                else
                    v90.current = t23
                    v91.current = {}
                    v56({})
                end

                v54(true)
                bossActivePromptAtom({
                    weakSpotId = v219
                })
                playRareFishBossSfxCue("promptSpawn")
            end

            if v224 ~= "counter" or v215 ~= "tap" then
                v225()

                return
            end

            v90.current = nil
            v54(false)
            bossActivePromptAtom(nil)

            local current2 = v114.current

            if current2 ~= nil then
                current2({
                    action = v224,
                    promptType = v215,
                    weakSpotId = v219
                })
            end

            if v100.current ~= nil then
                task.cancel(v100.current)
            end

            v100.current = task.delay(0.36, function() -- line: 978
                -- upvalues: v225 (copy), v100 (copy)
                v100.current = nil
                v225()
            end)
        end

        local function queueNextPrompt(p47) -- line: 986
            -- upvalues: t12 (copy), intro (copy), v98 (copy), v99 (copy), v100 (copy), spawnNextPrompt (copy), v106 (copy), v107 (copy), bossPhasePacing (copy)
            local current = intro.current
            local v243 = if v106 then 1.15 elseif v107 then 1.35 else 1
            local v244 = (bossPhasePacing[current].spawnDelayMs * t12.spawnDelayMultiplier + p47) * v243 / 1000

            if p47 > 0 then
                v98.current = os.clock() + p47 / 1000
            end

            if v99.current ~= nil then
                task.cancel(v99.current)
            end

            if v100.current ~= nil then
                task.cancel(v100.current)
                v100.current = nil
            end

            v99.current = task.delay(v244, function() -- line: 1000
                -- upvalues: v99 (copy), spawnNextPrompt (copy)
                v99.current = nil
                spawnNextPrompt()
            end)
        end

        local function teardownActivePrompt() -- line: 1007
            -- upvalues: v54 (copy), v56 (copy), v90 (copy), v91 (copy), v99 (copy), v100 (copy), bossActivePromptAtom (copy)
            v90.current = nil
            v91.current = {}
            v54(false)
            v56({})
            bossActivePromptAtom(nil)

            if v99.current ~= nil then
                task.cancel(v99.current)
                v99.current = nil
            end

            if v100.current ~= nil then
                task.cancel(v100.current)
                v100.current = nil
            end
        end

        local function finishWithSuccess() -- line: 1024
            -- upvalues: v34 (ref), v50 (copy), v87 (copy), v88 (copy), v89 (copy), v101 (copy), v102 (copy), v109 (copy), v113 (copy), bossScreenBorderAtom (copy), playRareFishBossSfxCue (copy)
            if v34 then
                v102.current += 1
                bossScreenBorderAtom({
                    color = Color3.fromRGB(80, 255, 120),
                    nonce = v102.current
                })
                playRareFishBossSfxCue("successSurge")

                local current = v113.current

                if current ~= nil then
                    current()
                end

                local current2 = v109.current

                if current2 ~= nil then
                    current2({
                        success = true,
                        finalProgress = v89.current
                    })
                end

                return nil
            end

            v88.current = "success"
            v50("success")
            v102.current += 1
            bossScreenBorderAtom({
                color = Color3.fromRGB(80, 255, 120),
                nonce = v102.current
            })
            playRareFishBossSfxCue("successSurge")

            local current = v113.current

            if current ~= nil then
                current()
            end

            v101.current = task.delay(4.9, function() -- line: 1057
                -- upvalues: v87 (copy), v89 (copy), v101 (copy), v109 (copy)
                v101.current = nil

                if not v87.current then
                    return nil
                end

                local current = v109.current

                if current ~= nil then
                    current({
                        success = true,
                        finalProgress = v89.current
                    })
                end
            end)
        end

        local function commitFailure() -- line: 1072
            -- upvalues: v50 (copy), v87 (copy), v88 (copy), v89 (copy), v101 (copy), v102 (copy), v109 (copy), v110 (copy), bossScreenBorderAtom (copy), playRareFishBossSfxCue (copy)
            local current = v110.current

            if current ~= nil then
                current()
            end

            v88.current = "failed"
            v50("failed")
            v102.current += 1
            bossScreenBorderAtom({
                color = Color3.fromRGB(255, 50, 50),
                nonce = v102.current
            })
            playRareFishBossSfxCue("failureEscape")
            v101.current = task.delay(1.45, function() -- line: 1085
                -- upvalues: v87 (copy), v89 (copy), v101 (copy), v109 (copy)
                v101.current = nil

                if not v87.current then
                    return nil
                end

                local current = v109.current

                if current ~= nil then
                    current({
                        success = false,
                        finalProgress = v89.current
                    })
                end
            end)
        end

        local function endGame(p48) -- line: 1099
            -- upvalues: v30 (ref), v50 (copy), v88 (copy), teardownActivePrompt (copy), finishWithSuccess (copy), commitFailure (copy)
            if v88.current ~= "playing" then
                return nil
            end

            teardownActivePrompt()

            if p48 then
                finishWithSuccess()
            elseif v30 then
                v88.current = "offer"
                v50("offer")
            else
                commitFailure()
            end
        end

        local function handleInstantCaptureBuy() -- line: 1116
            -- upvalues: v41 (copy), v52 (copy), v88 (copy), MarketplaceService (copy), Players (copy)
            if v88.current ~= "offer" then
                return nil
            end

            if v41.productId <= 0 then
                warn("[RareFish] Instant Capture product id not configured; cannot prompt purchase")

                return nil
            end

            v52(true)
            MarketplaceService:PromptProductPurchase(Players.LocalPlayer, v41.productId)
        end

        local function handleInstantCaptureDecline() -- line: 1128
            -- upvalues: v52 (copy), v88 (copy), commitFailure (copy)
            if v88.current ~= "offer" then
                return nil
            end

            v52(false)
            commitFailure()
        end

        local function handleInstantCapturePurchased() -- line: 1135
            -- upvalues: fishId (copy), v84 (copy), v88 (copy), v89 (copy), finishWithSuccess (copy), events (copy), bossTuning (copy)
            if v88.current ~= "offer" then
                return nil
            end

            if fishId ~= nil then
                events.instantCapturePurchased(fishId)
            end

            v89.current = bossTuning.maxProgress
            v84(1)
            finishWithSuccess()
        end

        local function resolveHit(p49, p50, p51) -- line: 1147
            -- upvalues: v30 (ref), t12 (copy), v50 (copy), v54 (copy), v56 (copy), v62 (copy), v68 (copy), v70 (copy), v82 (copy), v84 (copy), v87 (copy), v88 (copy), v89 (copy), v90 (copy), v91 (copy), v96 (copy), v103 (copy), v104 (copy), v105 (copy), v111 (copy), v139 (copy), pulseProgressBar (copy), showFeedback (copy), queueNextPrompt (copy), teardownActivePrompt (copy), finishWithSuccess (copy), commitFailure (copy), events (copy), hapticPerfectHit (copy), bossActivePromptAtom (copy), getImpactConfig (copy), bossTuning (copy), playRareFishBossSfxCue (copy), tapSfxCueForRating (copy)
            local v245

            if p49 == "perfect" then
                if p50.promptType == "slide" then
                    v105.current = true
                else
                    hapticPerfectHit()
                end

                v245 = bossTuning.perfectProgressGain * t12.rewardMultiplier * v139
            else
                v245 = if p49 == "great" then bossTuning.greatProgressGain * t12.rewardMultiplier * v139 elseif p49 == "okay" then bossTuning.okayProgressGain * t12.rewardMultiplier * v139 else -bossTuning.missProgressPenalty * t12.missPenaltyMultiplier
            end

            if p49 ~= "miss" and p50.promptType == "slide" then
                v245 += bossTuning.slideProgressBonus * t12.rewardMultiplier * v139
            end

            local v247 = math.clamp(v89.current + v245, 0, bossTuning.maxProgress)

            v89.current = v247
            v84(v247 / bossTuning.maxProgress)

            local v248 = getImpactConfig(p49, 1)
            local _ = p50.action

            if v87.current then
                v96.current += 1
                v62(function(p52) -- line: 715
                    -- upvalues: p49 (copy), p51 (copy), v96 (copy)
                    local t28 = {}
                    local v249 = #t28
                    local v250 = #p52

                    table.move(p52, 1, v250, v249 + 1, t28)
                    t28[v249 + v250 + 1] = {
                        actionType = "pull",
                        id = v96.current,
                        pos = p51,
                        rating = p49
                    }

                    return t28
                end)
            end

            pulseProgressBar(p49, v248.progressPulseScale)
            showFeedback(p49, p51)

            if p49 == v103.current then
                v104.current += 1
            else
                v103.current = p49
                v104.current = 1
            end

            local v251 = if p49 == "perfect" or p49 == "great" then (v104.current - 1) % 4 * 0.045 else 0

            playRareFishBossSfxCue(tapSfxCueForRating(p49), 1 + v251)

            local current = v111.current

            if current ~= nil then
                current({
                    action = p50.action,
                    promptType = p50.promptType,
                    rating = p49,
                    weakSpotId = p50.startSpot
                })
            end

            if p49 ~= "miss" then
                if p50.promptType == "tap" then
                    events.analyticsApexSlapSuccess:fire()
                elseif p50.promptType == "slide" then
                    events.analyticsApexHoldDragSuccess:fire()
                end
            end

            v90.current = nil
            v91.current = {}
            v54(false)
            v56({})
            v70(false)
            v82(false)
            v68(1)
            bossActivePromptAtom(nil)

            if bossTuning.maxProgress <= v247 then
                if v88.current == "playing" then
                    teardownActivePrompt()
                    finishWithSuccess()
                end
            elseif v247 <= 0 then
                if v88.current == "playing" then
                    teardownActivePrompt()

                    if v30 then
                        v88.current = "offer"
                        v50("offer")
                    else
                        commitFailure()
                    end
                end
            elseif v88.current == "playing" then
                queueNextPrompt(v248.hitstopMs)
            end
        end

        local function handleTapClick() -- line: 1215
            -- upvalues: t12 (copy), v87 (copy), v88 (copy), v90 (copy), projForScreen (ref), resolveHit (copy), bossTuning (copy)
            local current = v90.current

            if not v87.current or v88.current ~= "playing" then
                return nil
            end

            local tap, v252, v253, v254

            if current ~= nil then
                if current.promptType == "tap" then
                    tap = bossTuning.tap
                    v252 = (os.clock() - current.spawnTime) * 1000
                    v253 = current.durationMs <= v252
                    v254 = false
                else
                    v254 = true
                end
            else
                v254 = true
            end

            if v254 then
                return nil
            end

            local v256 = math.abs(v252 - current.durationMs)
            local timingWindowMultiplier = t12.timingWindowMultiplier
            local v257 = "okay"

            if v256 <= tap.perfectWindowMs * timingWindowMultiplier then
                v257 = "perfect"
            elseif v256 <= tap.greatWindowMs * timingWindowMultiplier then
                v257 = "great"
            elseif v253 or not (v256 <= tap.okayWindowMs * timingWindowMultiplier) then
                local v258 = if v253 then v256 <= tap.lateOkayWindowMs * timingWindowMultiplier else nil

                v257 = if not v253 or not v258 then "miss" else "okay"
            end

            resolveHit(v257, current, projForScreen(current.startSpot))
        end

        local function rateTapPrompt(p53) -- line: 1242
            -- upvalues: t12 (copy), bossTuning (copy)
            local tap = bossTuning.tap
            local v259 = (os.clock() - p53.spawnTime) * 1000
            local v260 = p53.durationMs <= v259
            local v262 = math.abs(v259 - p53.durationMs)
            local timingWindowMultiplier = t12.timingWindowMultiplier

            if v262 <= tap.perfectWindowMs * timingWindowMultiplier then
                return "perfect"
            end

            if v262 <= tap.greatWindowMs * timingWindowMultiplier then
                return "great"
            end

            if v260 or not (v262 <= tap.okayWindowMs * timingWindowMultiplier) then
                local v263 = if v260 then v262 <= tap.lateOkayWindowMs * timingWindowMultiplier else nil

                if not v260 or not v263 then
                    return "miss"
                end
            end

            return "okay"
        end

        local function rateMultiTapPrompt(p54) -- line: 1262
            if not p54.revealed then
                return "miss"
            end

            local v264 = p54.durationMs - (os.clock() - p54.spawnTime) * 1000

            if v264 >= 4500 then
                return "perfect"
            end

            if v264 >= 2500 then
                return "great"
            end

            if v264 > 0 then
                return "okay"
            end

            return "miss"
        end

        local function resolveMultiTapPrompt(p55, p56) -- line: 1278
            -- upvalues: v30 (ref), v31 (ref), t12 (copy), v50 (copy), v54 (copy), v56 (copy), v62 (copy), v84 (copy), v87 (copy), v88 (copy), v89 (copy), v91 (copy), v96 (copy), v111 (copy), v139 (copy), pulseProgressBar (copy), showFeedback (copy), queueNextPrompt (copy), teardownActivePrompt (copy), finishWithSuccess (copy), commitFailure (copy), events (copy), hapticPerfectHit (copy), bossActivePromptAtom (copy), getImpactConfig (copy), bossTuning (copy), playRareFishBossSfxCue (copy), tapSfxCueForRating (copy)
            if not v87.current or v88.current ~= "playing" or p55.resolved then
                return nil
            end

            local current = v91.current
            local v265 = table.create(#current)

            for v266, v267 in current do
                local _ = v266 - 1
                local v268 = v267

                if v267.id == p55.id then
                    v268 = table.clone(v267)
                    setmetatable(v268, nil)
                    v268.resolved = true
                end

                v265[v266] = v268
            end

            v91.current = v265
            v56(v265)

            local v269 = table.clone(p55)

            setmetatable(v269, nil)
            v269.promptType = "tap"

            local v270

            if p56 == "perfect" then
                hapticPerfectHit()
                v270 = bossTuning.perfectProgressGain * t12.rewardMultiplier * v31 * v139
            else
                v270 = if p56 == "great" then bossTuning.greatProgressGain * t12.rewardMultiplier * v31 * v139 elseif p56 == "okay" then bossTuning.okayProgressGain * t12.rewardMultiplier * v31 * v139 else -bossTuning.missProgressPenalty * t12.missPenaltyMultiplier
            end

            local v272 = math.clamp(v89.current + v270, 0, bossTuning.maxProgress)

            v89.current = v272
            v84(v272 / bossTuning.maxProgress)

            local v273 = getImpactConfig(p56, 1)
            local _ = v269.action
            local screenPos = p55.screenPos

            if v87.current then
                v96.current += 1
                v62(function(p57) -- line: 715
                    -- upvalues: p56 (copy), screenPos (copy), v96 (copy)
                    local t29 = {}
                    local v274 = #t29
                    local v275 = #p57

                    table.move(p57, 1, v275, v274 + 1, t29)
                    t29[v274 + v275 + 1] = {
                        actionType = "pull",
                        id = v96.current,
                        pos = screenPos,
                        rating = p56
                    }

                    return t29
                end)
            end

            pulseProgressBar(p56, v273.progressPulseScale)
            showFeedback(p56, p55.screenPos)
            playRareFishBossSfxCue(tapSfxCueForRating(p56))

            local current2 = v111.current

            if current2 ~= nil then
                current2({
                    promptType = "tap",
                    action = v269.action,
                    rating = p56,
                    weakSpotId = v269.startSpot
                })
            end

            if p56 ~= "miss" then
                events.analyticsApexSlapSuccess:fire()
            end

            if bossTuning.maxProgress <= v272 then
                if v88.current == "playing" then
                    teardownActivePrompt()
                    finishWithSuccess()
                end

                return nil
            end

            if v272 <= 0 then
                if v88.current == "playing" then
                    teardownActivePrompt()

                    if v30 then
                        v88.current = "offer"
                        v50("offer")
                    else
                        commitFailure()
                    end
                end

                return nil
            end

            local function v276(p58) -- line: 1347
                return p58.resolved
            end

            local v277 = true

            for v278, v279 in v265 do
                local _ = v278 - 1

                if not v279.resolved then
                    v277 = false
                    break
                end
            end

            if not v277 then
                return
            end

            v91.current = {}
            v56({})
            v54(false)
            bossActivePromptAtom(nil)
            queueNextPrompt(v273.hitstopMs)
        end

        function projForScreen(p59) -- line: 1365
            -- upvalues: v35 (ref), v93 (copy), v140 (copy), clampScreenPoint (copy), bossWeakSpotsAtom (copy), t2 (copy)
            local current = v93.current
            local v280 = v35
            local v281

            if not v280 or current == nil then
                v281 = bossWeakSpotsAtom()[p59]

                if v281 == nil then
                    v281 = t2
                end
            else
                v281 = {
                    onScreen = true,
                    x = current.x,
                    y = current.y
                }
            end

            return (clampScreenPoint({
                x = v281.x,
                y = v281.y
            }, v140 * 0.5))
        end

        local function handleSlideGrab() -- line: 1373
            -- upvalues: v35 (ref), t12 (copy), v76 (copy), v82 (copy), v87 (copy), v88 (copy), v90 (copy), v93 (copy), v146 (copy), clampSlideSegment (copy), resolveHit (copy), UserInputService (copy), bossWeakSpotsAtom (copy), bossTuning (copy), playRareFishBossSfxCue (copy), t2 (copy)
            local current = v90.current

            if not v87.current or v88.current ~= "playing" then
                return nil
            end

            local slide, elapsed, grabWindowMs, v282, v283, MouseLocation, clampSlideSegment2, t30, v284, v285

            if current ~= nil then
                if current.promptType ~= "slide" or current.slideGrabbed then
                    v285 = true
                else
                    slide = bossTuning.slide
                    elapsed = os.clock()
                    grabWindowMs = current.grabWindowMs
                    v282 = (elapsed - current.spawnTime) * 1000
                    v283 = math.abs(v282 - grabWindowMs)
                    MouseLocation = UserInputService:GetMouseLocation()
                    clampSlideSegment2 = clampSlideSegment
                    t30 = {}

                    local startSpot = current.startSpot
                    local current2 = v93.current

                    if not v35 or current2 == nil then
                        v284 = bossWeakSpotsAtom()[startSpot]

                        if v284 == nil then
                            v284 = t2
                        end
                    else
                        v284 = {
                            onScreen = true,
                            x = current2.x,
                            y = current2.y
                        }
                    end

                    v285 = false
                end
            else
                v285 = true
            end

            if v285 then
                return nil
            end

            t30.x = v284.x

            local startSpot = current.startSpot
            local current2 = v93.current
            local v287 = v35
            local v288

            if not v287 or current2 == nil then
                v288 = bossWeakSpotsAtom()[startSpot]

                if v288 == nil then
                    v288 = t2
                end
            else
                v288 = {
                    onScreen = true,
                    x = current2.x,
                    y = current2.y
                }
            end

            t30.y = v288.y

            local v289 = clampSlideSegment2(t30, current.slideSpan)
            local v290 = MouseLocation.X - v289.start.x
            local v291 = MouseLocation.Y - v289.start.y
            local v294 = math.max(v146 * 0.75, slide.pathTolerance * 0.55)

            if v290 * v290 + v291 * v291 > v294 * v294 then
                resolveHit("miss", current, v289.start)

                return nil
            end

            local v295 = "okay"

            if v283 <= bossTuning.tap.perfectWindowMs * t12.timingWindowMultiplier then
                v295 = "perfect"
            elseif v283 <= bossTuning.tap.greatWindowMs * t12.timingWindowMultiplier then
                v295 = "great"
            elseif not (v282 < grabWindowMs and v283 <= bossTuning.tap.okayWindowMs * t12.timingWindowMultiplier) and not (grabWindowMs <= v282 and v283 <= bossTuning.tap.lateOkayWindowMs * t12.timingWindowMultiplier) then
                resolveHit("miss", current, v289.start)

                return nil
            end

            current.slideGrabbed = true
            current.slideGrabRating = v295
            current.slideStartTime = elapsed
            current.slidePointerStart = MouseLocation
            v76(0)
            v82(true)
            playRareFishBossSfxCue("slideStart")
        end

        useEffect(function() -- line: 1423
            -- upvalues: v49 (copy), v90 (copy), v105 (copy), projForScreen (ref), resolveHit (copy), handleSlideGrab (copy), UserInputService (copy), hapticDrag (copy)
            if v49 ~= "playing" then
                return nil
            end

            local connection = UserInputService.InputBegan:Connect(function(p60) -- line: 1427
                -- upvalues: v90 (copy), handleSlideGrab (copy)
                if p60.UserInputType == Enum.UserInputType.MouseButton1 or p60.UserInputType == Enum.UserInputType.Touch then
                    local current = v90.current

                    if current ~= nil and current.promptType == "slide" and not current.slideGrabbed then
                        handleSlideGrab()

                        return
                    end
                end

                return nil
            end)
            local connection2 = UserInputService.InputEnded:Connect(function(p61) -- line: 1437
                -- upvalues: v90 (copy), v105 (copy), projForScreen (ref), resolveHit (copy), hapticDrag (copy)
                if p61.UserInputType == Enum.UserInputType.MouseButton1 or p61.UserInputType == Enum.UserInputType.Touch then
                    if v105.current then
                        v105.current = false
                        hapticDrag()
                    else
                        local current = v90.current

                        if current ~= nil and current.promptType == "slide" and current.slideGrabbed then
                            resolveHit("miss", current, projForScreen(current.startSpot))

                            return
                        end
                    end
                end

                return nil
            end)

            return function() -- line: 1452
                -- upvalues: connection (copy), connection2 (copy)
                connection:Disconnect()
                connection2:Disconnect()
            end
        end, { v49 })
        useEffect(function() -- line: 1458
            -- upvalues: fishId (copy), v41 (copy), v49 (copy), v52 (copy), v84 (copy), v87 (copy), v88 (copy), v89 (copy), finishWithSuccess (copy), events (copy), MarketplaceService (copy), bossTuning (copy)
            if v49 ~= "offer" then
                return nil
            end

            local connection = MarketplaceService.PromptProductPurchaseFinished:Connect(function(_, p63, p64) -- line: 1462
                -- upvalues: fishId (copy), v41 (copy), v52 (copy), v84 (copy), v87 (copy), v88 (copy), v89 (copy), finishWithSuccess (copy), events (copy), bossTuning (copy)
                if p63 ~= v41.productId or not v87.current or v88.current ~= "offer" then
                    return nil
                end

                if not p64 then
                    v52(false)

                    return
                end

                if v88.current == "offer" then
                    if fishId ~= nil then
                        events.instantCapturePurchased(fishId)
                    end

                    v89.current = bossTuning.maxProgress
                    v84(1)
                    finishWithSuccess()
                end
            end)

            return function() -- line: 1475
                -- upvalues: connection (copy)
                return connection:Disconnect()
            end
        end, { v49 })
        useEffect(function() -- line: 1480
            -- upvalues: v49 (copy), v50 (copy), v58 (copy), v87 (copy), v88 (copy), getSound (copy), v115 (copy), v117 (copy), v119 (copy), v120 (copy), v121 (copy), RunService (copy), t1 (copy)
            if v49 ~= "countdown" then
                return nil
            end

            v120.current = 0
            v121.current = os.clock()
            v58(0)
            v117(0.45)
            v119(0)

            local function v296() -- line: 1489
                -- upvalues: getSound (copy), v115 (copy)
                local v297 = getSound("3-2-1Countdown")

                v115.current = v297
                v297.TimePosition = 0
                v297:Play()
            end

            pcall(v296)

            local connection

            connection = RunService.Heartbeat:Connect(function() -- line: 1496
                -- upvalues: connection (ref), v50 (copy), v58 (copy), v87 (copy), v88 (copy), v117 (copy), v119 (copy), v120 (copy), v121 (copy), t1 (copy)
                if not v87.current or v88.current ~= "countdown" then
                    connection:Disconnect()

                    return nil
                end

                local current = v120.current
                local v298 = current == #t1 - 1
                local v299 = 1000 / 1000
                local v301 = math.min((os.clock() - v121.current) / v299, 1)
                local v303 = 1 - math.pow(1 - v301, 3)

                v117(((v298 and 2.5 or 1.55) - 0.45) * v303 + 0.45)
                v119(if v301 >= 0.8 then (v301 - 0.8) / 0.2 else 0)

                if v301 >= 1 then
                    local v306 = current + 1

                    if #t1 <= v306 then
                        connection:Disconnect()

                        if not v87.current then
                            return nil
                        end

                        v88.current = "playing"
                        v50("playing")
                    else
                        v120.current = v306
                        v121.current = os.clock()
                        v58(v306)
                        v117(0.45)
                        v119(0)
                    end
                end
            end)

            return function() -- line: 1528
                -- upvalues: connection (ref), v115 (copy)
                connection:Disconnect()

                local current = v115.current

                if current ~= nil then
                    current:Stop()
                end

                v115.current = nil
            end
        end, { v49 })
        useEffect(function() -- line: 1538
            -- upvalues: v30 (ref), v35 (ref), t12 (copy), v47 (copy), v49 (copy), v50 (copy), v56 (copy), v64 (copy), v66 (copy), v68 (copy), v70 (copy), v72 (copy), v74 (copy), v76 (copy), v78 (copy), v80 (copy), v84 (copy), v86 (copy), v88 (copy), v89 (copy), v90 (copy), v91 (copy), v93 (copy), intro (copy), v98 (copy), v127 (copy), v140 (copy), clampScreenPoint (copy), clampSlideSegment (copy), spawnNextPrompt (copy), teardownActivePrompt (copy), commitFailure (copy), resolveHit (copy), resolveMultiTapPrompt (copy), RunService (copy), UserInputService (copy), bossWeakSpotsAtom (copy), bossTuning (copy), getBossPhase (copy), t2 (copy)
            if v49 ~= "playing" then
                return nil
            end

            v89.current = bossTuning.initialProgress
            v98.current = 0
            intro.current = getBossPhase(bossTuning.initialProgress / bossTuning.maxProgress)
            v84(bossTuning.initialProgress / bossTuning.maxProgress)
            spawnNextPrompt()

            local connection

            connection = RunService.Heartbeat:Connect(function(p65) -- line: 1548
                -- upvalues: connection (ref), v30 (ref), v35 (ref), t12 (copy), v47 (copy), v50 (copy), v56 (copy), v64 (copy), v66 (copy), v68 (copy), v70 (copy), v72 (copy), v74 (copy), v76 (copy), v78 (copy), v80 (copy), v84 (copy), v86 (copy), v88 (copy), v89 (copy), v90 (copy), v91 (copy), v93 (copy), v98 (copy), v127 (copy), v140 (copy), clampScreenPoint (copy), clampSlideSegment (copy), teardownActivePrompt (copy), commitFailure (copy), resolveHit (copy), resolveMultiTapPrompt (copy), UserInputService (copy), bossWeakSpotsAtom (copy), bossTuning (copy), t2 (copy)
                if v88.current ~= "playing" then
                    connection:Disconnect()

                    return nil
                end

                if not (os.clock() < v98.current) then
                    local v307 = -bossTuning.drainPerSecond * t12.drainMultiplier * p65
                    local v309 = math.clamp(v89.current + v307, 0, bossTuning.maxProgress)

                    v89.current = v309
                    v84(v309 / bossTuning.maxProgress)

                    if v309 <= 0 then
                        connection:Disconnect()

                        if v88.current == "playing" then
                            teardownActivePrompt()

                            if v30 then
                                v88.current = "offer"
                                v50("offer")
                            else
                                commitFailure()
                            end
                        end

                        return nil
                    end
                end

                local v310 = v89.current / bossTuning.maxProgress
                local v311 = v310 <= 0.25
                local elapsed = os.clock()

                v80(elapsed * 0.85 % 1)
                v86(UDim2.fromScale(-(elapsed * 0.25 % 1), 0))
                v127({
                    bobY = math.sin(elapsed * (if v311 then 3.5 else 1.8)) * (v311 and 4 or 2.5),
                    fillRatio = v310,
                    rotation = math.sin(elapsed * (if v311 then 4 else 2)) * (v311 and 12 or 6)
                })

                local current = v90.current

                if #v91.current > 0 then
                    local v316 = elapsed * 1000
                    local v317 = false
                    local current = v91.current
                    local v318 = table.create(#current)

                    local function v319(p66) -- line: 1580
                        -- upvalues: elapsed (copy), v316 (copy), v317 (ref), resolveMultiTapPrompt (copy)
                        if p66.revealed then
                            local v320 = v316 - p66.spawnTime * 1000
                            local v323 = math.max(0, (math.min(1 - v320 / p66.durationMs, 1)))

                            p66.setTimerProgress(v323 * 100)

                            if p66.resolved or not (p66.durationMs <= v320) then
                                return p66
                            end

                            v317 = true
                            resolveMultiTapPrompt(p66, "miss")
                            p66.setTimerProgress(0)

                            local v324 = table.clone(p66)

                            setmetatable(v324, nil)
                            v324.resolved = true

                            return v324
                        end

                        if elapsed >= p66.revealTime then
                            v317 = true
                            p66.setTimerProgress(100)

                            local v325 = table.clone(p66)

                            setmetatable(v325, nil)
                            v325.revealed = true
                            v325.spawnTime = elapsed

                            return v325
                        end

                        p66.setTimerProgress(100)

                        return p66
                    end

                    for v326, v327 in current do
                        v318[v326] = v319(v327, v326 - 1, current)
                    end

                    v91.current = v318

                    if v317 then
                        v56(v318)
                    end
                end

                if current ~= nil then
                    local startSpot = current.startSpot
                    local current2 = v93.current
                    local v328 = v35
                    local v329

                    if not v328 or current2 == nil then
                        v329 = bossWeakSpotsAtom()[startSpot]

                        if v329 == nil then
                            v329 = t2
                        end
                    else
                        v329 = {
                            onScreen = true,
                            x = current2.x,
                            y = current2.y
                        }
                    end

                    local v330 = clampScreenPoint({
                        x = v329.x,
                        y = v329.y
                    }, v140 * 1.15)
                    local v331 = clampSlideSegment({
                        x = v329.x,
                        y = v329.y
                    }, current.slideSpan)

                    v64(UDim2.fromOffset(v330.x, v330.y))
                    v72(UDim2.fromOffset(v331.start.x, v331.start.y))

                    local x, y = v331["end"].x, v331["end"].y

                    v74(UDim2.fromOffset(x, y))

                    if current.promptType == "tap" then
                        local v332 = elapsed - current.spawnTime
                        local v335 = math.max(2.3 - math.max(v332 / (current.durationMs / 1000), 0) * 1.3, 0.1)

                        v66(UDim2.fromOffset(bossTuning.tap.size * v47.current * v335, bossTuning.tap.size * v47.current * v335))

                        local v337 = math.abs(v332 * 1000 - current.durationMs) <= bossTuning.tap.perfectWindowMs * t12.timingWindowMultiplier

                        v70(v337)
                        v68(v337 and 0.55 or 1)

                        if (current.durationMs + bossTuning.tap.lateGraceMs * t12.timingWindowMultiplier) / 1000 <= v332 then
                            resolveHit("miss", current, v330)
                        end
                    else
                        local _ = bossTuning.slide

                        if current.slideGrabbed then
                            local MouseLocation = UserInputService:GetMouseLocation()
                            local v338 = x - v331.start.x
                            local v339 = y - v331.start.y
                            local v341 = math.max(v338 * v338 + v339 * v339, 1)
                            local v342 = MouseLocation.X - v331.start.x
                            local v343 = MouseLocation.Y - v331.start.y
                            local v345 = math.clamp((v342 * v338 + v343 * v339) / v341, 0, 1)

                            v76(v345)

                            if v345 >= 1 then
                                resolveHit(current.slideGrabRating, current, {
                                    x = x,
                                    y = y
                                })

                                return nil
                            end

                            return
                        end

                        local v346 = (elapsed - current.spawnTime) * 1000
                        local grabWindowMs = current.grabWindowMs

                        v78((math.clamp(v346 / grabWindowMs, 0, 1)))

                        if grabWindowMs + bossTuning.tap.lateOkayWindowMs * t12.timingWindowMultiplier <= v346 then
                            resolveHit("miss", current, v331.start)
                        end
                    end
                end

                return nil
            end)

            return function() -- line: 1686
                -- upvalues: connection (ref)
                return connection:Disconnect()
            end
        end, { v49 })

        local v348 = v49 == "countdown"
        local v349 = v49 == "playing"
        local v350 = t1[v57 + 1]

        if v350 == nil then
            v350 = ""
        end

        local v351 = v57 == #t1 - 1
        local v352 = v116:map(function(p67) -- line: 1700
            -- upvalues: v46 (copy)
            return p67 * v46
        end)

        v116 = if currentFish ~= nil then currentFish.name else currentFish

        local v353 = getOddsBannerText(v116, table.find(mutations, "Champion") ~= nil, v48.championMutationChance)
        local createElement

        if v348 then
            v348 = react.createElement(react.Fragment, nil, v353 ~= nil and react.createElement(default2, {
                anchorPoint = Vector2.new(0.5, 0.5),
                color = ColorSequence.new({
                    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 245, 120)),
                    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 190, 45)),
                    ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255))
                }),
                overrideProps = {
                    TextScaled = true,
                    ZIndex = 12,
                    Font = Enum.Font.GothamBlack,
                    Size = UDim2.fromOffset(v46 * 520, v46 * 74)
                },
                position = UDim2.fromScale(0.5, 0.34),
                strokeProps = {
                    Thickness = 0.075,
                    Color = Color3.fromRGB(0, 0, 0)
                },
                text = v353
            }), react.createElement(default4, {
                fade = v118,
                isGo = v351,
                scale = v352,
                text = v350
            }))
        end

        v352 = v49 == "success" and react.createElement(RareFishSuccessCutscene, {
            fish = currentFish,
            mutations = mutations,
            uiScale = v46
        })

        local v354 = v49 == "failed" and (if simpleFailureCutscene then react.createElement(RareFishSimpleFailureCutscene, {
            message = failureMessage,
            uiScale = v46
        }) else react.createElement(RareFishFailureCutscene, {
            uiScale = v46
        }))

        v350 = v49 == "offer" and react.createElement(default, {
            durationSec = 6,
            fish = currentFish,
            onBuy = handleInstantCaptureBuy,
            onCancel = handleInstantCaptureDecline,
            paused = v51,
            priceRobux = v41.priceRobux,
            productId = v41.productId,
            uiScale = v46
        })

        local v355, v356

        if v349 then
            v356 = v53 and tap == "tap" and react.createElement(BossTapPrompt, {
                approachRingColor = v134,
                approachRingWidth = v142,
                glowColor = v38.innerPerfectGlow,
                glowTransparency = v67,
                hitboxSize = v145,
                innerBorderColor = v137,
                innerBorderWidth = v144,
                innerFillColor = v135,
                innerFillTransparency = v136,
                onActivated = handleTapClick,
                position = v63,
                ringSize = v65,
                size = v140
            })
            v355 = v53 and tap == "multiTap"
        else
            v355 = v349
            v356 = v349
        end

        if v355 then
            local t32 = {}

            local function v357(p68) -- line: 1769
                return p68.revealed and not p68.resolved
            end

            v137 = 0

            for v358, v359 in v55 do
                if v357(v359, v358 - 1, v55) == true then
                    v137 += 1
                    t32[v137] = v359
                end
            end

            v355 = table.create(#t32)

            v137 = function(p69) -- line: 1782
                -- upvalues: v38 (copy), v134 (copy), v140 (copy), v142 (copy), v144 (copy), v145 (copy), resolveMultiTapPrompt (copy), react (copy), BossTapPrompt (copy)
                local v360 = p69.timerProgress:map(function(p70) -- line: 1783
                    return p70 >= 75
                end)
                local v361 = UDim2.fromOffset(p69.screenPos.x, p69.screenPos.y)
                local v362 = UDim2.fromOffset(v140, v140)

                return react.createElement(BossTapPrompt, {
                    variant = "multiTap",
                    approachRingColor = v134,
                    approachRingWidth = v142,
                    glowColor = v38.innerPerfectGlow,
                    glowTransparency = v360:map(function(p71) -- line: 1792
                        if p71 then
                            return 0.55
                        end

                        return 1
                    end),
                    hitboxSize = v145,
                    innerBorderColor = v360:map(function(p72) -- line: 1796
                        -- upvalues: v38 (copy)
                        if p72 then
                            return v38.innerPerfectBorder
                        end

                        return v38.innerBorder
                    end),
                    innerBorderWidth = v144,
                    innerFillColor = v360:map(function(p73) -- line: 1800
                        if p73 then
                            return (Color3.fromRGB(65, 255, 115))
                        end

                        return (Color3.fromRGB(124, 128, 134))
                    end),
                    innerFillTransparency = v360:map(function(p74) -- line: 1803
                        if p74 then
                            return 0.65
                        end

                        return 0.35
                    end),
                    key = ("multi-tap-%*"):format(p69.id),
                    onActivated = function() -- onActivated | line: 1807
                        -- upvalues: p69 (copy), resolveMultiTapPrompt (copy)
                        local v363

                        if p69.revealed then
                            local v364 = p69.durationMs - (os.clock() - p69.spawnTime) * 1000

                            v363 = if v364 >= 4500 then "perfect"
                                elseif v364 >= 2500 then "great"
                                elseif v364 > 0 then "okay"
                                else "miss"
                        else
                            v363 = "miss"
                        end

                        return resolveMultiTapPrompt(p69, v363)
                    end,
                    position = v361,
                    ringSize = v362,
                    size = v140,
                    timerProgress = p69.timerProgress
                })
            end

            for v365, v366 in t32 do
                v355[v365] = v137(v366, v365 - 1, t32)
            end
        end

        if v349 then
            if v53 then
                v53 = tap == "slide" and react.createElement(BossSlidePrompt, {
                    arrowPhase = v79,
                    dragProgress = v75,
                    endPosition = v73,
                    endSize = v147,
                    grabbed = v81,
                    onGrab = handleSlideGrab,
                    pathWidth = v149,
                    startApproach = v77,
                    startPosition = v71,
                    startSize = v146
                })
            end

            v135 = react.createElement(default5, {
                impacts = v61,
                onImpactDone = removeImpact
            })
        else
            v135 = v349
            v53 = v349
        end

        local t34, v367

        if v59 ~= nil then
            createElement = react.createElement
            t34 = {
                anchorPoint = Vector2.new(0.5, 1)
            }
            t34.color = v59.gradient or v59.color
            t34.overrideProps = {
                TextScaled = true,
                ZIndex = 6,
                Size = v138
            }
            t34.position = UDim2.fromOffset(v59.pos.x, v59.pos.y - v140 * 0.65)
            t34.strokeProps = {
                Thickness = 0.085
            }
            t34.text = v59.text
            v367 = createElement(default2, t34)
        else
            v367 = false
        end

        if v349 then
            v118 = react.createElement(default6, {
                barCornerRadius = 10,
                showProgressPercent = true,
                barBorderColor = v133,
                barBorderThickness = v153,
                barBottomOffset = v156,
                barFillGradient = v132,
                barFillScale = v129,
                barHeight = v154,
                barTrack = v38.barTrack,
                barWidth = v151,
                progressText = v130,
                pulseScale = v124,
                texturePos = v85
            })
            v133 = progressIconText == nil and (currentFish ~= nil or progressIconImage ~= nil)
        else
            v133 = v349
            v118 = v349
        end

        if v133 then
            v129 = {
                BackgroundTransparency = 1,
                BorderSizePixel = 0,
                AnchorPoint = Vector2.new(0.5, 0.5)
            }

            if progressIconImage ~= nil then
                v129.Image = progressIconImage
            else
                local v368 = if currentFish == nil then currentFish else currentFish.imageId

                if v368 ~= nil then
                    v129.Image = v368
                else
                    v129.Image = images.fishIcon
                end
            end

            v129.Position = v157
            v129.Rotation = v155
            v129.Size = UDim2.fromOffset(v150, v150)
            v129.ZIndex = 8
            v133 = react.createElement("imagelabel", v129)
        end

        createElement = react.createElement
        t34 = {
            Active = false,
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            ZIndex = 1,
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.fromScale(0.5, 0.5),
            Size = UDim2.fromScale(1, 1)
        }

        if v349 then
            v349 = progressIconText ~= nil and react.createElement("textlabel", {
                BackgroundTransparency = 1,
                BorderSizePixel = 0,
                TextScaled = true,
                ZIndex = 8,
                AnchorPoint = Vector2.new(0.5, 0.5),
                Font = Enum.Font.GothamBlack,
                Position = v157,
                Rotation = v155,
                Size = UDim2.fromOffset(v150, v150),
                Text = progressIconText,
                TextColor3 = Color3.fromRGB(230, 250, 255)
            }, react.createElement("uistroke", {
                Thickness = 4,
                Color = Color3.fromRGB(15, 35, 55)
            }))
        end

        return createElement("frame", t34, v348, v352, v354, v350, v356, v355, v53, v135, v367, v118, v133, v349)
    end
}
