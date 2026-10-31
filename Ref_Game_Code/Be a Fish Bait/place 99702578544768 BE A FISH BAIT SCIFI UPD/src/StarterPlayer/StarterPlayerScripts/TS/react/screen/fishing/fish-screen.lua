-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local useBinding, useEffect, useRef, useState = react.useBinding, react.useEffect, react.useRef, react.useState
local subscribe = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "charm").subscribe
local utilizedPowerFractionAtom = RuntimeLib.import(script, script.Parent.Parent.Parent.Parent, "utilized-power-atom").utilizedPowerFractionAtom
local perfectConfettiTriggerAtom = RuntimeLib.import(script, script.Parent.Parent.Parent.Parent, "perfect-confetti-atom").perfectConfettiTriggerAtom
local qteConfettiTriggerAtom = RuntimeLib.import(script, script.Parent.Parent.Parent.Parent, "qte-confetti-atom").qteConfettiTriggerAtom
local services = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services")
local CollectionService, Debris, HttpService, Players = services.CollectionService, services.Debris, services.HttpService, services.Players
local RunService, UserInputService, Workspace = services.RunService, services.UserInputService, services.Workspace
local useIsUsingGamepad = RuntimeLib.import(script, script.Parent.Parent.Parent, "hooks", "use-is-using-gamepad").useIsUsingGamepad
local orientToFishingArea = RuntimeLib.import(script, script.Parent.Parent.Parent.Parent, "character-utils").orientToFishingArea
local v1 = RuntimeLib.import(script, script.Parent.Parent.Parent.Parent, "fishing-phase-atom")
local apexAfterRareFishCutsceneAtom, apexSkillCheckAtom, castIsPerfectAtom, fishingMovementLockedAtom = v1.apexAfterRareFishCutsceneAtom, v1.apexSkillCheckAtom, v1.castIsPerfectAtom, v1.fishingMovementLockedAtom
local hookCastDistanceAtom, hookHrpAtom, hookLandedPositionAtom, hookZoneProgressAtom = v1.hookCastDistanceAtom, v1.hookHrpAtom, v1.hookLandedPositionAtom, v1.hookZoneProgressAtom
local powerValueHiddenAtom, rareFishTransitionDurationSec, statDisplayHiddenAtom = v1.powerValueHiddenAtom, v1.rareFishTransitionDurationSec, v1.statDisplayHiddenAtom
local default = RuntimeLib.import(script, script.Parent, "cast-skillcheck-bar").default
local default2 = RuntimeLib.import(script, script.Parent, "fish-button").default
local network = RuntimeLib.import(script, script.Parent.Parent.Parent.Parent, "network")
local events, functions = network.events, network.functions
local v2 = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "fishing-hook-utils")
local bounceCount, bounceInitialDistanceFromSpeed, castCutScene, castDistanceFromPower = v2.bounceCount, v2.bounceInitialDistanceFromSpeed, v2.castCutScene, v2.castDistanceFromPower
local castEndYFromPower, castLaunchSpeedFromPower, computeArcOffset, computeBounceDistances = v2.castEndYFromPower, v2.castLaunchSpeedFromPower, v2.computeArcOffset, v2.computeBounceDistances
local defaultBounceDiminishFactor, defaultBounceInitialHeight, defaultPeakBias, drag = v2.defaultBounceDiminishFactor, v2.defaultBounceInitialHeight, v2.defaultPeakBias, v2.drag
local findVisualTWater, perfectCastBounceMultiplier, waterSurfaceY = v2.findVisualTWater, v2.perfectCastBounceMultiplier, v2.waterSurfaceY
local selectPlayerBuffBonuses = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "slices", "player-data", "selectors").selectPlayerBuffBonuses
local default3 = RuntimeLib.import(script, script.Parent.Parent, "progress-bar", "progress-bar").default
local default4 = RuntimeLib.import(script, script.Parent.Parent.Parent, "fishing-zone", "fish-nibble-billboard").default
local fish = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "data", "fish")
local fishDataByName, isFishData = fish.fishDataByName, fish.isFishData
local reflex = RuntimeLib.import(script, script.Parent.Parent.Parent, "hooks", "reflex")
local useRootProducer, useRootSelector, useRootSelectorCreator = reflex.useRootProducer, reflex.useRootSelector, reflex.useRootSelectorCreator
local selectCastCutsceneAnimationEnded = RuntimeLib.import(script, script.Parent.Parent.Parent.Parent, "reflex", "slices", "cast-cutscene.selectors").selectCastCutsceneAnimationEnded
local v3 = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "slices", "fishing-hooks.selectors")
local selectLocalPlayerBonusComboCount, selectLocalPlayerBonusFishInPool, selectLocalPlayerHook, selectLocalPlayerNibbleFish = v3.selectLocalPlayerBonusComboCount, v3.selectLocalPlayerBonusFishInPool, v3.selectLocalPlayerHook, v3.selectLocalPlayerNibbleFish
local selectLocalPlayerNibbleExpireTimestamp = v3.selectLocalPlayerNibbleExpireTimestamp
local v4 = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "slices", "fishing-state.selectors")
local selectPlayerCastParams, selectPlayerFishingCaughtFishName, selectPlayerFishingCaughtFishMutations = v4.selectPlayerCastParams, v4.selectPlayerFishingCaughtFishName, v4.selectPlayerFishingCaughtFishMutations
local selectors = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "slices", "player-data", "selectors")
local selectPlayerBackpackUpgradeCount, selectPlayerStat, selectPlayerInventory = selectors.selectPlayerBackpackUpgradeCount, selectors.selectPlayerStat, selectors.selectPlayerInventory
local v5 = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "slices", "player-config-snapshot.selectors")
local selectBossFightEasy, selectHoldSkillCheckEnabled, selectRareFishExperiment = v5.selectBossFightEasy, v5.selectHoldSkillCheckEnabled, v5.selectRareFishExperiment
local v6 = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "inventory-utils")
local getBackpackCapacity, hasSpaceInBackpack = v6.getBackpackCapacity, v6.hasSpaceInBackpack
local v7 = RuntimeLib.import(script, script.Parent, "cast-grade-text")
local default5, getGradeFromStrength = v7.default, v7.getGradeFromStrength
local default6 = RuntimeLib.import(script, script.Parent, "apex-reveal-overlay").default
local v8 = RuntimeLib.import(script, script.Parent, "rare-fish-boss", "boss-skillcheck")
local default7, isEasyBossQteVariant, shouldEnableBossQteSlides = v8.default, v8.isEasyBossQteVariant, v8.shouldEnableBossQteSlides
local default8 = RuntimeLib.import(script, script.Parent, "rare-fish-boss", "boss-autokill-sequence").default
local frostwyrmWildGamepadSkillCheckTuning = RuntimeLib.import(script, script.Parent.Parent.Parent, "secret-frostwyrm", "frostwyrm-skillcheck-config").frostwyrmWildGamepadSkillCheckTuning
local t1 = {
    AEasy = "aEasy",
    AHard = "aHard",
    BEasy = "bEasy",
    BHard = "bHard"
}
local default9 = RuntimeLib.import(script, script.Parent, "rare-fish-boss", "boss-screenborder").default
local selectTutorialStep = RuntimeLib.import(script, script.Parent.Parent.Parent.Parent, "reflex", "slices", "tutorial.selectors").selectTutorialStep
local tutorialSteps = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "tutorial-utils").tutorialSteps
local default10 = RuntimeLib.import(script, script.Parent.Parent.Parent, "tutorial", "pointer").default
local default11 = RuntimeLib.import(script, script.Parent, "rare-fish-transition").default
local NibbleCameraFov = RuntimeLib.import(script, script.Parent.Parent.Parent, "fishing", "nibble-camera-fov").NibbleCameraFov
local default12 = RuntimeLib.import(script, script.Parent, "fish-nibble-screen").default
local useConfig = RuntimeLib.import(script, script.Parent.Parent.Parent, "context", "config-context").useConfig
local default13 = RuntimeLib.import(script, script.Parent, "bonus-slots-hud").default
local default14 = RuntimeLib.import(script, script.Parent, "mutation-luck-boost-text").default
local default15 = RuntimeLib.import(script, script.Parent, "mutation-qte-target").default
local default16 = RuntimeLib.import(script, script.Parent, "delulu-qte-target").default
local selectCurrentWeathers = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "slices", "current-weather.selectors").selectCurrentWeathers
local selectDeluluRigForced = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "slices", "delulu-rig.selectors").selectDeluluRigForced
local selectHoopTestingEnabled = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "slices", "hoop-testing.selectors").selectHoopTestingEnabled
local weathers = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "data", "weathers").weathers
local deluluRiftFlashAtom = RuntimeLib.import(script, script.Parent.Parent.Parent.Parent, "delulu-rift-flash-atom").deluluRiftFlashAtom
local deluluRiftScreenFlashAtom = RuntimeLib.import(script, script.Parent.Parent.Parent.Parent, "delulu-rift-screen-flash-atom").deluluRiftScreenFlashAtom
local deluluRiftSkyAtom = RuntimeLib.import(script, script.Parent.Parent.Parent.Parent, "delulu-rift-sky-atom").deluluRiftSkyAtom
local deluluRiftMusicAtom = RuntimeLib.import(script, script.Parent.Parent.Parent.Parent, "delulu-rift-music-atom").deluluRiftMusicAtom
local deluluRiftCameraPunchAtom = RuntimeLib.import(script, script.Parent.Parent.Parent.Parent, "delulu-rift-camera-punch-atom").deluluRiftCameraPunchAtom
local v9 = tostring(Players.LocalPlayer.UserId)

local function setOtherPlayersVisible(p1) -- line: 139
    -- upvalues: Players (copy), Workspace (copy)
    for _, player in Players:GetPlayers() do
        if player ~= Players.LocalPlayer then
            local Character = player.Character

            if Character then
                if p1 then
                    Character.Parent = Workspace
                else
                    Character.Parent = nil
                end
            end
        end
    end
end

local function deluluRiftSpawnTimeFromDistance(p2) -- line: 164
    return math.log((math.max(1, p2))) * 0.1359967306704936 + 0.4533402425039581
end

local function deluluRiftFlightPathY(p3, p4, p5, p6) -- line: 172
    -- upvalues: bounceCount (copy), bounceInitialDistanceFromSpeed (copy), castDistanceFromPower (copy), castEndYFromPower (copy), castLaunchSpeedFromPower (copy), computeArcOffset (copy), computeBounceDistances (copy), defaultBounceDiminishFactor (copy), defaultBounceInitialHeight (copy), drag (copy), findVisualTWater (copy), perfectCastBounceMultiplier (copy), waterSurfaceY (copy)
    local peakBias, peakHeight, power, startPosition = p3.peakBias, p3.peakHeight, p3.power, p3.startPosition
    local v11 = castEndYFromPower(power)
    local v12 = castDistanceFromPower(power)
    local v13 = castLaunchSpeedFromPower(power)
    local v14 = findVisualTWater(startPosition.Y, v11, waterSurfaceY, drag, peakHeight, peakBias)
    local v15 = v14 + (1 - v14) / math.max(drag, 0.001)
    local v16 = v12 / v15
    local v17 = (v11 - startPosition.Y) / v15
    local v18 = v16 * v14
    local v20 = computeBounceDistances(bounceInitialDistanceFromSpeed(v13) * (if p4 then perfectCastBounceMultiplier else 1) * (1 + p5), bounceCount, defaultBounceDiminishFactor)

    local function v21(p7, p8) -- line: 191
        return p7 + p8
    end

    local n1 = 0

    for i = 1, #v20 do
        local v23 = v20[i]
        local _ = i - 1

        n1 += v23
    end

    if p6 <= v18 then
        local v24 = p6 / v16

        return startPosition.Y + v17 * v24 + computeArcOffset(v24 / v15, peakHeight, peakBias)
    end

    if p6 <= v18 + n1 then
        local v25 = bounceCount - 1
        local n2 = 0

        for i = 0, v25 do
            if p6 <= v18 + v20[i + 1] then
                n2 = i
                break
            end

            v18 += v20[i + 1]
        end

        local v26 = (p6 - v18) / v20[n2 + 1]

        return waterSurfaceY + defaultBounceInitialHeight * defaultBounceDiminishFactor ^ n2 * 4 * v26 * (1 - v26)
    end

    local v28 = v20[bounceCount]
    local v30 = math.clamp((p6 - (v18 + n1)) / v28, 0, 1)

    return waterSurfaceY + (v11 - waterSurfaceY) * v30
end

local function spawnDeluluRiftNearMiss(p9, p10, p11) -- line: 232
    -- upvalues: Debris (copy), Workspace (copy), hookCastDistanceAtom (copy), castLaunchSpeedFromPower (copy), weathers (copy), deluluRiftFlightPathY (copy)
    local Delulu = weathers.Delulu

    if Delulu ~= nil then
        Delulu = Delulu.deluluRift
    end

    if Delulu == nil then
        return nil
    end

    local direction, power, startPosition = p9.direction, p9.power, p9.startPosition
    local Unit = (direction * Vector3.new(1, 0, 1)).Unit
    local v32 = Vector3.new(-Unit.Z, 0, Unit.X)
    local v33 = castLaunchSpeedFromPower(power)
    local v34 = 2 + math.random() * 1
    local v35 = hookCastDistanceAtom() + v33 * v34
    local v36 = deluluRiftFlightPathY(p9, p10, p11, v35)
    local v37 = (45 + math.random() * 35) * (if math.random() < 0.5 then -1 else 1)
    local v38 = startPosition * Vector3.new(1, 0, 1)
    local v39 = Unit * v35
    local v40 = v32 * v37
    local v41 = Vector3.new(0, v36, 0)
    local v42 = v38 + v39 + v40 + v41
    local clone = Delulu:Clone()

    clone.Position = v42
    clone.Anchored = true
    clone.CanCollide = false
    clone.Parent = Workspace
    Debris:AddItem(clone, 3)
end

local function spawnDeluluRift(p12, p13, p14, p15) -- line: 267
    -- upvalues: Debris (copy), Workspace (copy), hookCastDistanceAtom (copy), castDistanceFromPower (copy), castLaunchSpeedFromPower (copy), weathers (copy), deluluRiftFlashAtom (copy), deluluRiftScreenFlashAtom (copy), deluluRiftSkyAtom (copy), deluluRiftMusicAtom (copy), deluluRiftCameraPunchAtom (copy), deluluRiftFlightPathY (copy)
    local Delulu = weathers.Delulu

    if Delulu ~= nil then
        Delulu = Delulu.deluluRift
    end

    if Delulu == nil then
        return nil
    end

    local direction, power, startPosition = p12.direction, p12.power, p12.startPosition
    local Unit = (direction * Vector3.new(1, 0, 1)).Unit
    local v43 = castLaunchSpeedFromPower(power)
    local v44 = castDistanceFromPower(power)
    local v47 = hookCastDistanceAtom() + v43 * (math.log((math.max(1, v44))) * 0.1359967306704936 + 0.4533402425039581)
    local v48 = deluluRiftFlightPathY(p12, p13, p14, v47)
    local v49 = startPosition * Vector3.new(1, 0, 1)
    local v50 = Unit * v47
    local v51 = Vector3.new(0, v48, 0)
    local v52 = v49 + v50 + v51
    local clone = Delulu:Clone()

    clone.Position = v52
    clone.Anchored = true
    clone.CanCollide = false
    clone.Parent = Workspace
    Debris:AddItem(clone, 3)

    local v54 = math.log((math.max(1, v44))) * 0.1359967306704936 + 0.4533402425039581

    task.delay(math.max(0, v54 - 1.35), function() -- line: 305
        -- upvalues: deluluRiftFlashAtom (copy)
        deluluRiftFlashAtom(false)
        deluluRiftFlashAtom(true)
    end)
    task.delay(math.max(0, v54 - 0.24999999999999997), function() -- line: 312
        -- upvalues: deluluRiftCameraPunchAtom (copy)
        deluluRiftCameraPunchAtom(false)
        deluluRiftCameraPunchAtom(true)
    end)
    task.delay(math.max(0, v54 - 0.35), function() -- line: 316
        -- upvalues: p15 (copy), deluluRiftScreenFlashAtom (copy), deluluRiftSkyAtom (copy), deluluRiftMusicAtom (copy)
        deluluRiftScreenFlashAtom(false)
        deluluRiftScreenFlashAtom(true)
        deluluRiftSkyAtom(true)
        deluluRiftMusicAtom(false)
        deluluRiftMusicAtom(true)
        p15("RiftPortalEnter"):Play()
    end)
end

return {
    default = function(p16) -- FishScreen | line: 325
        -- upvalues: react (copy), useBinding (copy), useEffect (copy), useRef (copy), useState (copy), subscribe (copy), utilizedPowerFractionAtom (copy), perfectConfettiTriggerAtom (copy), qteConfettiTriggerAtom (copy), CollectionService (copy), HttpService (copy), Players (copy), RunService (copy), UserInputService (copy), Workspace (copy), useIsUsingGamepad (copy), orientToFishingArea (copy), apexAfterRareFishCutsceneAtom (copy), apexSkillCheckAtom (copy), castIsPerfectAtom (copy), fishingMovementLockedAtom (copy), hookCastDistanceAtom (copy), hookHrpAtom (copy), hookLandedPositionAtom (copy), hookZoneProgressAtom (copy), powerValueHiddenAtom (copy), rareFishTransitionDurationSec (copy), statDisplayHiddenAtom (copy), default (copy), default2 (copy), events (copy), functions (copy), castCutScene (copy), defaultPeakBias (copy), selectPlayerBuffBonuses (copy), default3 (copy), default4 (copy), fishDataByName (copy), isFishData (copy), useRootProducer (copy), useRootSelector (copy), useRootSelectorCreator (copy), selectCastCutsceneAnimationEnded (copy), selectLocalPlayerBonusComboCount (copy), selectLocalPlayerBonusFishInPool (copy), selectLocalPlayerHook (copy), selectLocalPlayerNibbleFish (copy), selectLocalPlayerNibbleExpireTimestamp (copy), selectPlayerCastParams (copy), selectPlayerFishingCaughtFishName (copy), selectPlayerFishingCaughtFishMutations (copy), selectPlayerBackpackUpgradeCount (copy), selectPlayerStat (copy), selectPlayerInventory (copy), selectBossFightEasy (copy), selectHoldSkillCheckEnabled (copy), selectRareFishExperiment (copy), getBackpackCapacity (copy), hasSpaceInBackpack (copy), default5 (copy), getGradeFromStrength (copy), default6 (copy), default7 (copy), isEasyBossQteVariant (copy), shouldEnableBossQteSlides (copy), default8 (copy), frostwyrmWildGamepadSkillCheckTuning (copy), t1 (copy), default9 (copy), selectTutorialStep (copy), tutorialSteps (copy), default10 (copy), default11 (copy), NibbleCameraFov (copy), default12 (copy), useConfig (copy), default13 (copy), default14 (copy), default15 (copy), default16 (copy), selectCurrentWeathers (copy), selectDeluluRigForced (copy), selectHoopTestingEnabled (copy), deluluRiftSkyAtom (copy), v9 (copy), setOtherPlayersVisible (copy), spawnDeluluRiftNearMiss (copy), spawnDeluluRift (copy)
        local onCastBegin = p16.onCastBegin
        local v58, v59 = useState(false)
        local v60, v61 = useState(false)
        local v62, v63 = useState(false)
        local v64, v65 = useState(false)
        local v66, v67 = useState(false)
        local v68, v69 = useState(false)
        local v70, v71 = useState(nil)
        local v72, v73 = useState(nil)
        local v74, v75 = useState(apexSkillCheckAtom())
        local v76, v77 = useState(apexAfterRareFishCutsceneAtom())
        local v78 = useRootProducer()
        local getSound = useConfig().getSound
        local v79 = useRootSelector(selectTutorialStep)
        local v80 = useRootSelectorCreator(selectLocalPlayerNibbleFish, v9)
        local v81 = useRootSelectorCreator(selectLocalPlayerNibbleExpireTimestamp, v9)
        local v82 = useRootSelector(selectPlayerStat(v9, "skillcheckSpeedMultiplier"))

        if v82 == nil then
            v82 = 1
        end

        local v83 = useRootSelectorCreator(selectPlayerInventory, v9)
        local v84 = getBackpackCapacity(useRootSelectorCreator(selectPlayerBackpackUpgradeCount, v9))
        local v85 = useRef()
        local v86, v87 = useBinding(0)
        local v88, v89 = useBinding(0)
        local v90 = useRef(false)
        local v91 = useRef(false)
        local v92 = useRef()
        local v93 = useRef(0)
        local v94 = useRef(0)
        local v95 = useRef(0)
        local v96, v97 = useState(nil)
        local v98 = useRef(nil)
        local v99 = useRef(false)
        local v100, v101 = useState(false)
        local v102, v103 = useState(nil)
        local v104, v105 = useState(false)
        local v106 = useRootSelector(selectCurrentWeathers)
        local v107 = useRootSelectorCreator(selectDeluluRigForced, v9)
        local v108 = v106.Delulu ~= nil or v107
        local v109 = useRootSelectorCreator(selectHoopTestingEnabled, v9)
        local v110 = useRootSelector(selectBossFightEasy(v9))
        local v111 = useRootSelector(selectHoldSkillCheckEnabled(v9))
        local v112 = useRootSelector(selectRareFishExperiment(v9))
        local v113 = useIsUsingGamepad()
        local v114 = if v113 then "aEasy" else t1[v112]
        local v115 = useRootSelector(selectCastCutsceneAnimationEnded)
        local v116 = useRootSelectorCreator(selectPlayerCastParams, v9)
        local hopDistance = useRootSelector(selectPlayerBuffBonuses(v9)).hopDistance
        local v117 = useRef(v116)

        v117.current = v116

        local v118 = useRef(hopDistance)

        v118.current = hopDistance
        useEffect(function() -- line: 388
            -- upvalues: v64 (copy), v65 (copy), v67 (copy), v87 (copy), v89 (copy), v90 (copy), v97 (copy), v98 (copy), v99 (copy), v101 (copy), v105 (copy), RunService (copy), hookCastDistanceAtom (copy), hookLandedPositionAtom (copy), hookZoneProgressAtom (copy), events (copy)
            if not v64 then
                return nil
            end

            v90.current = false

            local connection = RunService.Heartbeat:Connect(function() -- line: 393
                -- upvalues: v65 (copy), v67 (copy), v87 (copy), v89 (copy), v90 (copy), v97 (copy), v98 (copy), v99 (copy), v101 (copy), v105 (copy), hookCastDistanceAtom (copy), hookLandedPositionAtom (copy), hookZoneProgressAtom (copy), events (copy)
                v87(hookZoneProgressAtom())
                v89(hookCastDistanceAtom())

                if not v90.current and hookLandedPositionAtom() ~= nil then
                    v90.current = true
                    task.delay(0.5, function() -- line: 398
                        -- upvalues: v65 (copy), v67 (copy), v97 (copy), v98 (copy), v99 (copy), v101 (copy), v105 (copy), events (copy)
                        if v98.current ~= nil and not v99.current then
                            events.hookQteTapResult:fire(false)
                        end

                        v97(nil)
                        v98.current = nil
                        v101(false)
                        v105(false)
                        v65(false)
                        v67(true)
                    end)
                end
            end)

            return function() -- line: 412
                -- upvalues: connection (copy)
                return connection:Disconnect()
            end
        end, { v64, v87, v89 })

        local v119

        useEffect(function() -- line: 417
            -- upvalues: v119 (ref), events (copy)
            local v120 = events.apexFishCaught:connect(function() -- line: 419
                -- upvalues: v119 (ref)
                return v119(true)
            end)

            return function() -- line: 422
                -- upvalues: v120 (copy)
                return v120:Disconnect()
            end
        end, {})
        useEffect(function() -- line: 426
            -- upvalues: v97 (copy), v98 (copy), v99 (copy), v101 (copy), v105 (copy), v107 (copy), v117 (copy), v118 (copy), v108 (copy), castIsPerfectAtom (copy), events (copy), functions (copy), spawnDeluluRiftNearMiss (copy)
            local v121 = events.hookQteMutationRolled:connect(function(p17) -- line: 427
                -- upvalues: v97 (copy), v98 (copy), v99 (copy), v101 (copy), v105 (copy), v107 (copy), v117 (copy), v118 (copy), v108 (copy), castIsPerfectAtom (copy), functions (copy), spawnDeluluRiftNearMiss (copy)
                v98.current = p17
                v99.current = false
                v97(p17)
                v101(false)
                functions.getCanReachUncommonZone():andThen(function(p18) -- line: 437
                    -- upvalues: v105 (copy), v107 (copy), v117 (copy), v118 (copy), v108 (copy), castIsPerfectAtom (copy), spawnDeluluRiftNearMiss (copy)
                    if v108 and p18 then
                        if v117.current ~= nil then
                            spawnDeluluRiftNearMiss(v117.current, castIsPerfectAtom(), v118.current)
                        end

                        if v107 or math.random() < 0.5 then
                            v105(true)
                        end
                    end
                end)
            end)

            return function() -- line: 451
                -- upvalues: v121 (copy)
                return v121:Disconnect()
            end
        end, { v108, v107 })
        useEffect(function() -- line: 456
            -- upvalues: v96 (copy), v101 (copy)
            if v96 == nil then
                return nil
            end

            local v122 = 1 + math.random() * 1
            local v123 = task.delay(v122, function() -- line: 461
                -- upvalues: v101 (copy)
                return v101(true)
            end)

            return function() -- line: 464
                -- upvalues: v123 (copy)
                return task.cancel(v123)
            end
        end, { v96 })

        local v124, v125

        useEffect(function() -- line: 469
            -- upvalues: v124 (ref), v125 (ref)
            if v124.current >= 3 then
                v125(true)
            end
        end, { v81 })
        useEffect(function() -- line: 475
            -- upvalues: v67 (copy), v71 (copy), v103 (copy), events (copy), fishDataByName (copy), isFishData (copy), deluluRiftSkyAtom (copy)
            local v126 = events.reelStarted:connect(function(_, _, _, _, _, _, p25) -- line: 477
                -- upvalues: v67 (copy), v71 (copy), v103 (copy), fishDataByName (copy), isFishData (copy), deluluRiftSkyAtom (copy)
                v67(false)

                local v127 = fishDataByName[p25]

                if v127 ~= nil and isFishData(v127) then
                    v71(v127)
                end

                v103(nil)
                deluluRiftSkyAtom(false)
            end)

            return function() -- line: 487
                -- upvalues: v126 (copy)
                return v126:Disconnect()
            end
        end, {})

        local v128 = useRootSelectorCreator(selectPlayerFishingCaughtFishName, v9)
        local v129 = useRootSelectorCreator(selectPlayerFishingCaughtFishMutations, v9)

        useEffect(function() -- line: 493
            -- upvalues: v71 (copy), v128 (copy), fishDataByName (copy), isFishData (copy)
            if v128 == nil then
                return nil
            end

            local v130 = fishDataByName[v128]

            if v130 ~= nil and isFishData(v130) then
                v71(v130)
            end
        end, { v128 })
        useEffect(function() -- line: 502
            -- upvalues: v75 (copy), subscribe (copy), apexSkillCheckAtom (copy)
            return subscribe(apexSkillCheckAtom, function(p26) -- line: 503
                -- upvalues: v75 (copy)
                return v75(p26)
            end)
        end, {})
        useEffect(function() -- line: 507
            -- upvalues: v77 (copy), subscribe (copy), apexAfterRareFishCutsceneAtom (copy)
            return subscribe(apexAfterRareFishCutsceneAtom, v77)
        end, {})
        useEffect(function() -- line: 510
            -- upvalues: v65 (copy), v92 (copy), v93 (copy), v95 (copy), v115 (copy), utilizedPowerFractionAtom (copy), Players (copy), Workspace (copy), events (copy), defaultPeakBias (copy)
            if not v115 then
                return nil
            end

            local current = v92.current

            if current == nil then
                print("[CastDebug] cutsceneAnimationEnded effect bailed — cutsceneCloneRef.current is undefined")

                return nil
            end

            local Character = Players.LocalPlayer.Character

            if Character ~= nil then
                Character = Character:FindFirstChild("HumanoidRootPart")
            end

            if Character == nil then
                print("[CastDebug] cutsceneAnimationEnded effect bailed — no HumanoidRootPart found on character")

                return nil
            end

            local ServerTimeNow = Workspace:GetServerTimeNow()

            print((("[CastDebug] t=%* cutscene ended — firing castFishingHook and starting hook flight immediately, startPosition=%*"):format(ServerTimeNow, Character.Position)))

            local v131 = utilizedPowerFractionAtom()

            v95.current = v131
            events.castFishingHook:fire({
                direction = Character.CFrame.LookVector,
                peakBias = defaultPeakBias,
                skillCheckStrength = v93.current,
                startPosition = Character.Position,
                utilizedPowerFraction = v131
            })
            print((("[CastDebug] t=%* setIsHookFlying(true) — no round-trip wait"):format(ServerTimeNow)))
            v65(true)
            task.delay(1, function() -- line: 542
                -- upvalues: current (copy), v92 (copy)
                current:Destroy()
                v92.current = nil
            end)
        end, { v115 })
        useEffect(function() -- line: 549
            -- upvalues: v92 (copy), v116 (copy)
            if not v116 then
                return nil
            end

            local current = v92.current

            if current == nil then
                return nil
            end

            current:RemoveTag("CastCutScene")
        end, { v116 })
        useEffect(function() -- line: 559
            -- upvalues: v66 (copy), v69 (copy)
            if v66 then
                local v132 = task.delay(1, function() -- line: 564
                    -- upvalues: v69 (copy)
                    return v69(true)
                end)

                return function() -- line: 567
                    -- upvalues: v132 (copy)
                    return task.cancel(v132)
                end
            end

            v69(false)

            return nil
        end, { v66 })
        useEffect(function() -- line: 571
            -- upvalues: fishingMovementLockedAtom (copy), powerValueHiddenAtom (copy), statDisplayHiddenAtom (copy)
            return function() -- line: 572
                -- upvalues: fishingMovementLockedAtom (copy), powerValueHiddenAtom (copy), statDisplayHiddenAtom (copy)
                fishingMovementLockedAtom(false)
                powerValueHiddenAtom(false)
                statDisplayHiddenAtom(false)
            end
        end, {})

        local v133

        useEffect(function() -- line: 582
            -- upvalues: v59 (copy), v61 (copy), v63 (copy), v65 (copy), v67 (copy), v69 (copy), v71 (copy), v73 (copy), v90 (copy), v91 (copy), v92 (copy), v97 (copy), v98 (copy), v99 (copy), v101 (copy), v103 (copy), v105 (copy), v119 (ref), v125 (ref), v133 (ref), subscribe (copy), Players (copy), Workspace (copy), fishingMovementLockedAtom (copy), setOtherPlayersVisible (copy)
            return subscribe(fishingMovementLockedAtom, function(p27) -- line: 583
                -- upvalues: v59 (copy), v61 (copy), v63 (copy), v65 (copy), v67 (copy), v69 (copy), v71 (copy), v73 (copy), v90 (copy), v91 (copy), v92 (copy), v97 (copy), v98 (copy), v99 (copy), v101 (copy), v103 (copy), v105 (copy), v119 (ref), v125 (ref), v133 (ref), Players (copy), Workspace (copy), setOtherPlayersVisible (copy)
                if p27 then
                    return
                end

                if Players.LocalPlayer.Character then
                    Players.LocalPlayer.Character.Parent = Workspace
                end

                setOtherPlayersVisible(true)

                local current = v92.current

                if current ~= nil then
                    current:Destroy()
                end

                v92.current = nil
                v63(false)
                v59(false)
                v61(false)
                v65(false)
                v67(false)
                v69(false)
                v71(nil)
                v73(nil)
                v119(false)
                v125(false)
                v133(0)
                v97(nil)
                v98.current = nil
                v99.current = false
                v101(false)
                v103(nil)
                v105(false)
                v90.current = false
                v91.current = false
            end)
        end, {})
        useEffect(function() -- line: 617
            -- upvalues: statDisplayHiddenAtom (copy)
            statDisplayHiddenAtom(true)
        end, {})

        local function v134() -- line: 626
            -- upvalues: onCastBegin (copy), v63 (copy), v65 (copy), v91 (copy), v93 (copy), v95 (copy), utilizedPowerFractionAtom (copy), perfectConfettiTriggerAtom (copy), Players (copy), orientToFishingArea (copy), castIsPerfectAtom (copy), events (copy), defaultPeakBias (copy)
            if v91.current then
                return nil
            end

            v91.current = true
            orientToFishingArea()
            castIsPerfectAtom(true)
            perfectConfettiTriggerAtom(perfectConfettiTriggerAtom() + 1)

            if onCastBegin ~= nil then
                onCastBegin()
            end

            local Character = Players.LocalPlayer.Character

            if Character ~= nil then
                Character = Character:FindFirstChild("HumanoidRootPart")
            end

            if Character == nil then
                v91.current = false

                return nil
            end

            local v135 = Vector3.new(Character.Position.X, Character.Position.Y, -786.1)
            local LookVector = Character.CFrame.LookVector

            Character.CFrame = CFrame.new(v135, v135 + LookVector)
            v93.current = 100

            local v136 = utilizedPowerFractionAtom()

            v95.current = v136
            events.castFishingHook:fire({
                skillCheckStrength = 100,
                direction = Character.CFrame.LookVector,
                peakBias = defaultPeakBias,
                startPosition = Character.Position,
                utilizedPowerFraction = v136
            })
            v63(true)
            v65(true)
        end

        local function v137() -- line: 664
            -- upvalues: onCastBegin (copy), v59 (copy), v61 (copy), v63 (copy), v73 (copy), v78 (copy), getSound (copy), v85 (copy), v91 (copy), v92 (copy), v93 (copy), perfectConfettiTriggerAtom (copy), CollectionService (copy), Players (copy), Workspace (copy), orientToFishingArea (copy), castIsPerfectAtom (copy), events (copy), castCutScene (copy), getGradeFromStrength (copy), setOtherPlayersVisible (copy)
            if v91.current then
                return nil
            end

            v91.current = true
            getSound("CastComplete"):Play()

            local current = v85.current

            if current == nil then
                return nil
            end

            current:freeze()

            local v138 = current:getStrength()

            v61(true)

            local v139 = getGradeFromStrength(v138)

            print((("[CastDebug] handleCastClick grade=%* strength=%* settingIsPerfect=%*"):format(v139, v138, v139 == "perfect")))
            v73(v139)
            castIsPerfectAtom(v139 == "perfect")

            if v139 == "perfect" then
                perfectConfettiTriggerAtom(perfectConfettiTriggerAtom() + 1)
            end

            if onCastBegin ~= nil then
                onCastBegin()
            end

            orientToFishingArea()

            local Character = Players.LocalPlayer.Character

            if Character ~= nil then
                Character = Character:FindFirstChild("HumanoidRootPart")
            end

            if Character ~= nil then
                local LookVector = Character.CFrame.LookVector
                local v140 = Vector3.new(Character.Position.X, Character.Position.Y, -786.1)

                Character.CFrame = CFrame.new(v140, v140 + LookVector)
            end

            v93.current = v138
            events.analyticsCastCutsceneStarted:fire()
            v78.castCutsceneIsPerfectSet({})
            print((`[CastDebug] cloning castCutScene template (found={ castCutScene ~= nil })`))

            local clone = castCutScene:Clone()

            print((("[CastDebug] cloned cutSceneClone=%*"):format((clone:GetFullName()))))
            clone:SetAttribute("IsPerfect", v139 == "perfect")

            if Character ~= nil then
                local PlayerRigR15 = clone:FindFirstChild("PlayerRigR15")

                if PlayerRigR15 ~= nil then
                    PlayerRigR15 = PlayerRigR15:FindFirstChild("HumanoidRootPart")
                end

                if PlayerRigR15 ~= nil then
                    local v142 = Vector3.new(Character.Position.X - PlayerRigR15.Position.X, 0, 0)

                    for _, descendant in clone:GetDescendants() do
                        if descendant:IsA("BasePart") then
                            descendant.CFrame += v142
                        else
                            local Attachment = descendant:IsA("Attachment")

                            if Attachment then
                                Attachment = descendant.Parent

                                if Attachment ~= nil then
                                    Attachment = Attachment:IsA("Folder")
                                end
                            end

                            if Attachment then
                                descendant.CFrame += v142
                            end
                        end
                    end
                end
            end

            CollectionService:AddTag(clone, "CastCutScene")
            print((("[CastDebug] tagged cutSceneClone with CastCutScene (hasTag=%*)"):format((CollectionService:HasTag(clone, "CastCutScene")))))
            v92.current = clone
            events.castCutsceneRigSuspendRequested:fire()

            if Players.LocalPlayer.Character then
                Players.LocalPlayer.Character.Parent = nil
            end

            setOtherPlayersVisible(false)
            clone.Parent = Workspace
            print((("[CastDebug] cutSceneClone parented to Workspace, parent=%*"):format(clone.Parent)))
            task.delay(1, function() -- line: 751
                -- upvalues: v59 (copy), v61 (copy), v63 (copy), v73 (copy)
                v59(false)
                v61(false)
                v63(true)
                v73(nil)
            end)
        end

        useEffect(function() -- line: 758
            -- upvalues: v58 (copy), v60 (copy), v137 (copy), UserInputService (copy)
            if not v58 or v60 then
                return nil
            end

            local connection = UserInputService.InputBegan:Connect(function(p28, p29) -- line: 762
                -- upvalues: v137 (copy)
                if p29 or p28.KeyCode ~= Enum.KeyCode.ButtonR2 then
                    return nil
                end

                v137()
            end)

            return function() -- line: 771
                -- upvalues: connection (copy)
                return connection:Disconnect()
            end
        end, { v58, v60 })

        local v143 = useRootSelectorCreator(selectLocalPlayerBonusFishInPool, v9)
        local v144 = useRootSelectorCreator(selectLocalPlayerHook, v9)

        if v144 ~= nil then
            v144 = v144.phase
        end

        local v145 = v144 == "bonusWaveIntermission"
        local v146 = useRootSelectorCreator(selectLocalPlayerBonusComboCount, v9)

        v124 = useRef(0)
        v124.current = v146

        local v147 = { useState(0) }
        local v148 = v147[1]

        v133 = v147[2]
        useEffect(function() -- line: 790
            -- upvalues: v81 (copy), v133 (ref), v146 (copy)
            if v81 == nil then
                return nil
            end

            v133(v146)
        end, { v81 })
        v147 = { useState(false) }

        local v149 = v147[1]

        v119 = v147[2]
        v147 = { useState(false) }

        local v150 = v147[1]

        v125 = v147[2]

        local v151, v152, v153

        if v80 ~= nil then
            local t2 = {}

            local function v154(p30) -- line: 809
                -- upvalues: fishDataByName (copy), isFishData (copy)
                local v155 = fishDataByName[p30.fishName]

                return if v155 ~= nil and isFishData(v155) then {
                    entry = p30,
                    data = v155
                } else nil
            end

            v152 = 0

            for v156, v157 in v80 do
                v153 = v156 - 1
                v153 = v157.fishName
                v151 = fishDataByName[v153]

                local t3 = if v151 ~= nil and isFishData(v151) then {
                    entry = v157,
                    data = v151
                } else nil

                if t3 ~= nil then
                    v152 += 1
                    t2[v152] = t3
                end
            end

            v80 = t2
        end

        local v158

        if v80 ~= nil then
            v152 = table.create(#v80)

            v158 = function(p31) -- line: 833
                return p31.data
            end

            for v159, v160 in v80 do
                v151 = v159 - 1
                v152[v159] = v160.data
            end
        else
            v152 = v80
        end

        if v80 ~= nil then
            v158 = table.create(#v80)

            local function v161(p32) -- line: 847
                return p32.entry
            end

            for v162, v163 in v80 do
                v151 = v162 - 1
                v158[v162] = v163.entry
            end

            v80 = v158
        end

        local v164, v165 = useState(hookHrpAtom)

        useEffect(function() -- line: 858
            -- upvalues: v165 (copy), subscribe (copy), hookHrpAtom (copy)
            return subscribe(hookHrpAtom, v165)
        end, {})
        v147 = if v74 ~= nil then v74.fishData.name else v74

        local v166 = v147 == "Frostwyrm"

        v147 = if v74 ~= nil then v74.fishData.name else v74

        local v167 = v147 == "UncThulu"

        v147 = v166 or v167
        v167 = if not v166 or not v113 then nil else frostwyrmWildGamepadSkillCheckTuning

        if v147 then
            v114 = "superBoss"
        end

        local v168 = not v147 and (v110 or isEasyBossQteVariant(v114))

        v147 = if v166 then true else shouldEnableBossQteSlides(v114, v111)

        local v169

        v153, v169 = useState(nil)
        useEffect(function() -- line: 879
            -- upvalues: v164 (copy), v169 (ref), RunService (copy), Workspace (copy)
            if v164 == nil then
                v169(nil)

                return nil
            end

            local Part = Instance.new("Part")

            Part.Anchored = true
            Part.CanCollide = false
            Part.CanQuery = false
            Part.CanTouch = false
            Part.Size = Vector3.new(0.1, 0.1, 0.1)
            Part.Transparency = 1
            Part.CFrame = CFrame.new(v164.Position)
            Part.Parent = Workspace
            v169(Part)

            local connection = RunService.Heartbeat:Connect(function() -- line: 894
                -- upvalues: Part (copy), v164 (copy)
                if v164.Parent ~= nil then
                    Part.CFrame = CFrame.new(v164.Position)
                end
            end)

            return function() -- line: 899
                -- upvalues: Part (copy), connection (copy), v169 (ref)
                connection:Disconnect()
                Part:Destroy()
                v169(nil)
            end
        end, { v164 })

        local createElement, v170, v171, v172, v173, v174, v175

        if v62 then
            v111 = v64 and react.createElement(default3, {
                anchorPoint = Vector2.new(0.5, 0),
                position = UDim2.fromScale(0.5, 0.05),
                progress = v86,
                studsOverride = v88
            })

            if v64 then
                if v96 ~= nil then
                    if v100 then
                        createElement = react.createElement
                        v170 = {
                            mutation = v96
                        }

                        function v170.onMiss() -- line: 914
                            -- upvalues: v97 (copy), v98 (copy), v101 (copy), events (copy)
                            v97(nil)
                            v98.current = nil
                            v101(false)
                            events.hookQteTapResult:fire(false)
                        end

                        function v170.onTap() -- line: 920
                            -- upvalues: getSound (copy), v96 (copy), v97 (copy), v98 (copy), v99 (copy), v101 (copy), v103 (copy), qteConfettiTriggerAtom (copy), events (copy)
                            v99.current = true
                            getSound("CastComplete"):Play()
                            qteConfettiTriggerAtom(qteConfettiTriggerAtom() + 1)
                            v103(v96)
                            v97(nil)
                            v98.current = nil
                            v101(false)
                            events.hookQteTapResult:fire(true)
                        end

                        v100 = createElement(default15, v170)
                    end
                else
                    v100 = false
                end
            else
                v100 = v64
            end

            if v64 then
                if v104 then
                    createElement = react.createElement
                    v170 = {}

                    function v170.onMiss() -- line: 932
                        -- upvalues: v105 (copy)
                        return v105(false)
                    end

                    function v170.onTap() -- line: 935
                        -- upvalues: getSound (copy), v105 (copy), v116 (copy), hopDistance (copy), castIsPerfectAtom (copy), events (copy), spawnDeluluRift (copy)
                        v105(false)
                        events.deluluRiftEntered:fire()

                        if v116 ~= nil then
                            spawnDeluluRift(v116, castIsPerfectAtom(), hopDistance, getSound)
                        end
                    end

                    v104 = createElement(default16, v170)
                end
            else
                v104 = v64
            end

            local v176 = v102 ~= nil and v74 == nil and react.createElement(default14, {
                mutationName = v102
            })

            v170 = react.createElement(default9)

            local v177 = v74 ~= nil
            local v178 = false
            local v179 = false
            local v180 = false
            local v181 = false
            local v182 = false
            local v183 = false

            if v177 then
                v178 = true
            else
                v174 = v177
                v183 = true
            end

            if v178 then
                if v74.route == "autokill" then
                    v180 = true
                else
                    v179 = true
                end
            end

            v178 = false

            local v184

            if v179 then
                v171 = {
                    currentFish = v74.fishData
                }

                if v167 ~= nil then
                    v178 = true
                else
                    v184 = v167
                    v181 = true
                end
            end

            v179 = false

            if v178 then
                v184 = v167.difficultyMultiplier
                v181 = true
            end

            v178 = false

            local v185

            if v181 then
                if v184 ~= nil then
                    v185 = v184
                    v179 = true
                else
                    v178 = true
                end
            end

            v181 = false

            if v178 then
                if v166 then
                    v182 = true
                else
                    v181 = true
                end
            end

            if v181 then
                v185 = nil
                v179 = true
            end

            v181 = false

            if v182 then
                v185 = 1.08
                v179 = true
            end

            v182 = false

            local v186

            if v179 then
                v171.difficultyMultiplier = v185
                v171.easyMode = v168
                v171.fishId = v74.fishId

                if v167 ~= nil then
                    v182 = true
                else
                    v186 = v167
                    v181 = true
                end
            end

            v179 = false

            if v182 then
                v186 = v167.multiTapProgressMultiplier
                v181 = true
            end

            v182 = false

            local v187

            if v181 then
                v171.multiTapProgressMultiplier = v186
                v171.mutations = v74.mutations

                v171.onComplete = function(p33) -- line: 986
                    -- upvalues: v74 (copy)
                    return v74.onComplete(p33.success)
                end

                v171.onFailed = function() -- line: 989
                    -- upvalues: v74 (copy)
                    local onFailed = v74.onFailed

                    if onFailed ~= nil then
                        onFailed = onFailed()
                    end

                    return onFailed
                end

                v171.onHit = function(p34) -- line: 996
                    -- upvalues: v74 (copy)
                    return v74.onHit(p34)
                end

                v171.onPhaseChanged = function(p35) -- line: 999
                    -- upvalues: v74 (copy)
                    local onPhaseChanged = v74.onPhaseChanged

                    if onPhaseChanged ~= nil then
                        onPhaseChanged = onPhaseChanged(p35)
                    end

                    return onPhaseChanged
                end

                v171.onSuccessCutscene = function() -- line: 1006
                    -- upvalues: v74 (copy)
                    local onSuccessCutscene = v74.onSuccessCutscene

                    if onSuccessCutscene ~= nil then
                        onSuccessCutscene = onSuccessCutscene()
                    end

                    return onSuccessCutscene
                end

                v171.onTelegraph = function(p36) -- line: 1013
                    -- upvalues: v74 (copy)
                    local onTelegraph = v74.onTelegraph

                    if onTelegraph ~= nil then
                        onTelegraph = onTelegraph(p36)
                    end

                    return onTelegraph
                end

                if v167 ~= nil then
                    v182 = true
                else
                    v187 = v167
                    v179 = true
                end
            end

            v181 = false

            if v182 then
                v187 = v167.qteVariant
                v179 = true
            end

            v182 = false

            if v179 then
                if v187 ~= nil then
                    v172 = v187
                    v181 = true
                else
                    v182 = true
                end
            end

            v179 = false

            if v182 then
                v172 = v114
                v181 = true
            end

            v182 = false

            local v188

            if v181 then
                v171.qteVariant = v172

                if v167 ~= nil then
                    v182 = true
                else
                    v188 = v167
                    v179 = true
                end
            end

            v181 = false

            if v182 then
                v188 = v167.randomPromptScreenInsetScale
                v179 = true
            end

            v182 = false

            local v189

            if v179 then
                v171.randomPromptScreenInsetScale = v188

                if v167 ~= nil then
                    v182 = true
                else
                    v189 = v167
                    v181 = true
                end
            end

            v179 = false

            if v182 then
                v189 = v167.randomScreenPromptPositions
                v181 = true
            end

            v182 = false

            local v190

            if v181 then
                v171.randomScreenPromptPositions = v189
                v171.showCountdown = true

                if v167 ~= nil then
                    v182 = true
                else
                    v190 = v167
                    v179 = true
                end
            end

            v181 = false

            if v182 then
                v190 = v167.slidePromptsEnabled
                v179 = true
            end

            v182 = false

            local v191

            if v179 then
                if v190 ~= nil then
                    v191 = v190
                    v181 = true
                else
                    v182 = true
                end
            end

            if v182 then
                v191 = v147
                v181 = true
            end

            if v181 then
                v171.slidePromptsEnabled = v191
                v171.startDelayMs = rareFishTransitionDurationSec * 1000
                v173 = react.createElement(default7, v171)
                v183 = false
            end

            if v180 then
                v171 = react.createElement
                v187 = {}

                function v187.onComplete() -- line: 952
                    -- upvalues: v74 (copy)
                    return v74.onComplete(true)
                end

                function v187.onSuccessCutscene() -- line: 955
                    -- upvalues: v74 (copy)
                    local onSuccessCutscene = v74.onSuccessCutscene

                    if onSuccessCutscene ~= nil then
                        onSuccessCutscene = onSuccessCutscene()
                    end

                    return onSuccessCutscene
                end

                v187.getVfxCFrame = v74.getBossFishPivot
                v187.startDelayMs = rareFishTransitionDurationSec * 1000
                v173 = v171(default8, v187)
                v183 = false
            end

            if not v183 then
                v174 = v173
            end

            v173 = react.createElement
            v172 = {
                BackgroundTransparency = 1,
                Size = UDim2.fromScale(1, 1)
            }

            local createElement2, v192, v193, v194, v195

            if v66 then
                if v74 ~= nil then
                    v175 = false
                    v195 = true
                else
                    local v196 = not v76

                    if v196 then
                        createElement2 = react.createElement
                        v192 = NibbleCameraFov
                        v193 = {
                            active = v66,
                            bonusComboCount = v146
                        }
                        v194 = v70 ~= nil
                        v195 = false
                    else
                        v175 = v196
                        v195 = true
                    end
                end
            elseif v70 ~= nil then
                if v74 ~= nil then
                    v175 = false
                    v195 = true
                else
                    local v197 = not v76

                    if v197 then
                        createElement2 = react.createElement
                        v192 = NibbleCameraFov
                        v193 = {
                            active = v66,
                            bonusComboCount = v146
                        }
                        v194 = v70 ~= nil
                        v195 = false
                    else
                        v175 = v197
                        v195 = true
                    end
                end
            else
                v175 = false
                v195 = true
            end

            if not v195 then
                v193.isFishCaught = v194
                v193.nibbleExpireTimestamp = v81
                v175 = createElement2(v192, v193)
            end

            v192 = v153 ~= nil and v68 and v74 == nil and not v76 and react.createElement(default4, {
                adornee = v153,
                bonusChosen = v145,
                bonusFishInPool = v143,
                caughtFish = v70,
                caughtFishMutations = v129,
                keepObscured = v149 or v150,
                nibbleExpireTimestamp = v81,
                nibblingFish = v152,
                nibblingFishEntries = v80
            })
            v193 = if (v68 or v70 ~= nil) and v74 == nil then not v76 and react.createElement(default12, {
                bonusComboCount = v146,
                caughtFish = v70
            }) else false

            if v148 > 0 then
                if v68 then
                    v68 = v74 == nil and not v76 and react.createElement(default13, {
                        bonusComboCount = v148
                    })
                end
            else
                v68 = false
            end

            return v173("frame", v172, v111, v100, v104, v176, v170, v174, v175, v192, v193, v68, react.createElement(default6), react.createElement(default11))
        end

        v153 = v79 == tutorialSteps.catchAFish and not v58
        createElement = react.createElement
        v170 = {
            BackgroundTransparency = 1,
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.fromScale(0.5, 0.5),
            Size = UDim2.fromScale(1, 1)
        }
        v174 = not v58

        if v174 then
            if v79 == tutorialSteps.addFishToAquarium then
                v174 = false
            else
                v174 = react.createElement
                v171 = {}

                function v171.onClick() -- line: 1086
                    -- upvalues: v59 (copy), v78 (copy), v83 (copy), v84 (copy), v94 (copy), v109 (copy), v134 (copy), HttpService (copy), fishingMovementLockedAtom (copy), events (copy), hasSpaceInBackpack (copy)
                    local elapsed = os.clock()

                    if not (elapsed < v94.current) then
                        v94.current = elapsed + 0.5

                        if hasSpaceInBackpack(v83, v84) then
                            fishingMovementLockedAtom(true)
                            events.analyticsCastAttempted:fire()

                            if v109 then
                                v134()

                                return nil
                            end

                            v59(true)

                            return
                        end

                        v78.onScreenFeedbackAdded({
                            message = "Backpack is full! Sell your fish first.",
                            type = "error",
                            id = HttpService:GenerateGUID(false)
                        })
                    end

                    return nil
                end

                v174 = v174(default2, v171)
            end
        end

        v173 = v153 and react.createElement(react.Fragment, nil, react.createElement("frame", {
            Active = false,
            BackgroundTransparency = 0.45,
            BorderSizePixel = 0,
            ZIndex = 200,
            AnchorPoint = Vector2.new(0, 0),
            BackgroundColor3 = Color3.fromRGB(0, 0, 0),
            Position = UDim2.fromScale(0, 0),
            Size = UDim2.fromScale(1, 0.675)
        }), react.createElement("frame", {
            Active = false,
            BackgroundTransparency = 0.45,
            BorderSizePixel = 0,
            ZIndex = 200,
            AnchorPoint = Vector2.new(0, 0),
            BackgroundColor3 = Color3.fromRGB(0, 0, 0),
            Position = UDim2.fromScale(0, 0.825),
            Size = UDim2.fromScale(1, 0.175)
        }), react.createElement("frame", {
            Active = false,
            BackgroundTransparency = 0.45,
            BorderSizePixel = 0,
            ZIndex = 200,
            AnchorPoint = Vector2.new(0, 0),
            BackgroundColor3 = Color3.fromRGB(0, 0, 0),
            Position = UDim2.fromScale(0, 0.675),
            Size = UDim2.fromScale(0.375, 0.15)
        }), react.createElement("frame", {
            Active = false,
            BackgroundTransparency = 0.45,
            BorderSizePixel = 0,
            ZIndex = 200,
            AnchorPoint = Vector2.new(0, 0),
            BackgroundColor3 = Color3.fromRGB(0, 0, 0),
            Position = UDim2.fromScale(0.625, 0.675),
            Size = UDim2.fromScale(0.375, 0.15)
        }), react.createElement("frame", {
            Active = false,
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            ZIndex = 202,
            AnchorPoint = Vector2.new(0.5, 1),
            Position = UDim2.fromScale(0.475, 0.663),
            Size = UDim2.fromScale(0.07, 0.1)
        }, react.createElement(default10, {
            direction = "down",
            zIndex = 202,
            size = UDim2.fromScale(1.5, 1.5)
        })))

        if not v58 then
            v171 = v58

            return createElement("frame", v170, v174, v173, v171)
        end

        v171 = react.createElement
        v172 = react.Fragment

        local v198 = react.createElement(default, {
            isGamepadEnabled = v113,
            ref = v85,
            speedMultiplier = v82
        })
        local v199 = v72 ~= nil and react.createElement(default5, {
            grade = v72
        })
        local createElement2 = not v60

        if createElement2 then
            createElement2 = react.createElement

            local t4 = {
                BackgroundTransparency = 1,
                Text = "",
                ZIndex = 100
            }

            v175 = {}

            function v175.MouseButton1Down() -- line: 1166
                -- upvalues: v137 (copy)
                return v137()
            end

            t4.Event = v175
            t4.Size = UDim2.fromScale(1, 1)
            createElement2 = createElement2("textbutton", t4)
        end

        v171 = v171(v172, nil, v198, v199, createElement2)

        return createElement("frame", v170, v174, v173, v171)
    end
}
