-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local useCallback, useEffect, useRef, useState = react.useCallback, react.useEffect, react.useRef, react.useState
local subscribe = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "charm").subscribe
local v1 = RuntimeLib.import(script, script.Parent.Parent.Parent.Parent, "fishing-phase-atom")
local fishingMovementLockedAtom, statDisplayHiddenAtom = v1.fishingMovementLockedAtom, v1.statDisplayHiddenAtom
local rglActiveAtom = RuntimeLib.import(script, script.Parent.Parent.Parent.Parent, "rgl-active-atom").rglActiveAtom
local catchSticksActiveAtom = RuntimeLib.import(script, script.Parent.Parent.Parent.Parent, "catch-sticks-active-atom").catchSticksActiveAtom
local default = RuntimeLib.import(script, script.Parent, "topbar-fishing").default
local default2 = RuntimeLib.import(script, script.Parent, "celebration-weather-timer").default
local default3 = RuntimeLib.import(script, script.Parent, "celebration-teleport-button").default
local v2 = RuntimeLib.import(script, script.Parent, "teleport-to-fomo-island-button")
local fomoIslandButtonLgPositionYScale, fomoIslandButtonLgPositionXScale, fomoIslandButtonWidthScale = v2.fomoIslandButtonLgPositionYScale, v2.fomoIslandButtonLgPositionXScale, v2.fomoIslandButtonWidthScale
local reflex = RuntimeLib.import(script, script.Parent.Parent.Parent, "hooks", "reflex")
local useRootSelector, useRootProducer = reflex.useRootSelector, reflex.useRootProducer
local selectCurrentWindow = RuntimeLib.import(script, script.Parent.Parent.Parent.Parent, "reflex", "slices", "selectors", "current-window.selectors").selectCurrentWindow
local v3 = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "slices", "player-config-snapshot.selectors")
local selectHoldSkillCheckEnabled, selectShouldAutoPromptDailyReward = v3.selectHoldSkillCheckEnabled, v3.selectShouldAutoPromptDailyReward
local selectors = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "slices", "player-data", "selectors")
local selectPlayerStat, selectEquippedInventoryItem, selectActiveRodPowerCap, selectDayLastClaimedDailyReward = selectors.selectPlayerStat, selectors.selectEquippedInventoryItem, selectors.selectActiveRodPowerCap, selectors.selectDayLastClaimedDailyReward
local selectPlayerRebirthCount, selectEquippedRodName = selectors.selectPlayerRebirthCount, selectors.selectEquippedRodName
local fishingRodsData = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "data", "fishing-rods").fishingRodsData
local dailyRewardCooldownSeconds = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "daily-rewards-utils").dailyRewardCooldownSeconds
local localPlayerUserId = RuntimeLib.import(script, script.Parent.Parent.Parent.Parent, "utils").localPlayerUserId
local default4 = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "transition", "window-transition").default
local default5 = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "transition", "transition").default
local useWindowCameraEffects = RuntimeLib.import(script, script.Parent.Parent.Parent, "hooks", "use-window-camera-effects").useWindowCameraEffects
local aquariumSkinPreviewNameAtom = RuntimeLib.import(script, script.Parent.Parent.Parent.Parent, "aquarium-skin-preview-atom").aquariumSkinPreviewNameAtom
local useScreenSizeState = RuntimeLib.import(script, script.Parent.Parent.Parent, "hooks", "use-screen-size").useScreenSizeState
local BackpackWindowManager, default6 = RuntimeLib.import(script, script.Parent.Parent, "toolbar", "toolbar-manager").BackpackWindowManager, RuntimeLib.import(script, script.Parent.Parent, "toolbar", "toolbar-manager").default
local default7 = RuntimeLib.import(script, script.Parent.Parent, "toolbar", "mount-icon").default
local v4 = RuntimeLib.import(script, script.Parent.Parent, "toolbar", "celebration-toolbar-manager")
local default8, CelebrationBackpackWindowManager = v4.default, v4.CelebrationBackpackWindowManager
local default9 = RuntimeLib.import(script, script.Parent, "hud-tutorial-section").default
local selectTutorialStep = RuntimeLib.import(script, script.Parent.Parent.Parent.Parent, "reflex", "slices", "tutorial.selectors").selectTutorialStep
local tutorialSteps = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "tutorial-utils").tutorialSteps
local default10 = RuntimeLib.import(script, script.Parent, "upgrade-ready-feedback").default
local default11 = RuntimeLib.import(script, script.Parent, "spin-ready-feedback").default
local default12 = RuntimeLib.import(script, script.Parent.Parent.Parent, "lucky-block", "lucky-block-announcement-banner").default
local default13 = RuntimeLib.import(script, script.Parent.Parent, "toolbar", "delete-confirmation-window").default
local default14 = RuntimeLib.import(script, script.Parent.Parent, "loading-screen", "loading-screen").default
local default15 = RuntimeLib.import(script, script.Parent.Parent, "event-loading-screen", "event-loading-screen").default
local default16 = RuntimeLib.import(script, script.Parent, "feedback-manager").default
local default17 = RuntimeLib.import(script, script.Parent, "weather-indicator").default
local default18 = RuntimeLib.import(script, script.Parent, "sidebar").default
local default19 = RuntimeLib.import(script, script.Parent, "featured-items-showcase").default
local default20 = RuntimeLib.import(script, script.Parent.Parent, "exclusive-shop-window-manager").default
local default21 = RuntimeLib.import(script, script.Parent.Parent, "daily-reward", "daily-reward-window-manager").default
local default22 = RuntimeLib.import(script, script.Parent.Parent, "bottom-bar", "bottom-bar").default
local default23 = RuntimeLib.import(script, script.Parent.Parent, "settings", "settings-window-manager").default
local default24 = RuntimeLib.import(script, script.Parent.Parent, "changelog", "changelog-window-manager").default
local default25 = RuntimeLib.import(script, script.Parent.Parent, "letter", "letter-window-manager").default
local default26 = RuntimeLib.import(script, script.Parent.Parent, "claim-code-window").default
local default27 = RuntimeLib.import(script, script.Parent.Parent, "index", "index-window-manager").default
local default28 = RuntimeLib.import(script, script.Parent.Parent, "weights-shop", "weights-shop-window-manager").default
local default29 = RuntimeLib.import(script, script.Parent.Parent, "rods-shop", "rods-shop-window-manager").default
local default30 = RuntimeLib.import(script, script.Parent.Parent, "rods-shop", "rod-skins-window-manager").default
local default31 = RuntimeLib.import(script, script.Parent.Parent, "rods-shop", "rod-shop-vfx-window-manager").default
local default32 = RuntimeLib.import(script, script.Parent.Parent, "sell-fish", "sell-fish-window-manager").default
local default33 = RuntimeLib.import(script, script.Parent.Parent.Parent, "free-reward", "free-reward-window-manager").default
local default34 = RuntimeLib.import(script, script.Parent.Parent, "community-reward", "community-reward-window-manager").default
local default35 = RuntimeLib.import(script, script.Parent.Parent, "discord-reward", "discord-reward-window-manager").default
local default36 = RuntimeLib.import(script, script.Parent, "set-power-window-manager").default
local default37 = RuntimeLib.import(script, script.Parent.Parent, "aquarium", "aquarium-window-manager").default
local AquariumSkinSource = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "data", "aquarium-skins").AquariumSkinSource
local default38 = RuntimeLib.import(script, script.Parent.Parent, "fish-display", "fish-display-window-manager").default
local default39 = RuntimeLib.import(script, script.Parent.Parent, "playtime-spin-wheel", "playtime-spin-wheel-reward-reveal-manager").default
local default40 = RuntimeLib.import(script, script.Parent.Parent, "playtime-spin-wheel", "playtime-spin-wheel-window-manager").default
local default41 = RuntimeLib.import(script, script.Parent.Parent, "offline-earnings", "offline-earnings-window-manager").default
local default42 = RuntimeLib.import(script, script.Parent.Parent, "leaving-popup", "leaving-popup-window-manager").default
local default43 = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "money-confetti").default
local default44 = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "daily-reward-confetti").default
local default45 = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "perfect-cast-confetti").default
local default46 = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "qte-confetti").default
local default47 = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "aquarium-confetti").default
local default48 = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "new-high-score-confetti").default
local GuiService = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services").GuiService
local default49 = RuntimeLib.import(script, script.Parent, "console-crosshair").default
local v5 = RuntimeLib.import(script, script.Parent.Parent, "rebirth", "rebirth-window-manager")
local default50, RebirthReadyNotifier, RebirthCelebrationOverlay = v5.default, v5.RebirthReadyNotifier, v5.RebirthCelebrationOverlay
local default51 = RuntimeLib.import(script, script.Parent.Parent, "fishing", "fish-screen").default
local default52 = RuntimeLib.import(script, script.Parent.Parent, "fishing", "cast-power-cap-bar").default
local default53 = RuntimeLib.import(script, script.Parent.Parent, "fishing", "catch-fade-overlay").default
local selectIsInFishingArea = RuntimeLib.import(script, script.Parent.Parent.Parent.Parent, "reflex", "slices", "selectors", "fishing-area-ui.selectors").selectIsInFishingArea
local selectIsNearBase = RuntimeLib.import(script, script.Parent.Parent.Parent.Parent, "reflex", "slices", "selectors", "near-base-ui.selectors").selectIsNearBase
local default54 = RuntimeLib.import(script, script.Parent.Parent, "offline-earnings", "offline-earnings-banner").default
local default55 = RuntimeLib.import(script, script.Parent, "weather-hud-banner").default
local default56 = RuntimeLib.import(script, script.Parent, "server-restart-banner").default
local default57 = RuntimeLib.import(script, script.Parent, "frostwyrm-announcement-banner").default
local default58 = RuntimeLib.import(script, script.Parent, "pinata-boss-death-banner").default
local default59 = RuntimeLib.import(script, script.Parent, "training-hud").default
local default60 = RuntimeLib.import(script, script.Parent, "power-feedback").default
local default61 = RuntimeLib.import(script, script.Parent.Parent, "bait-aura", "bait-aura-window-manager").default
local default62 = RuntimeLib.import(script, script.Parent.Parent, "charm-attributes", "charm-attributes-window-manager").default
local default63 = RuntimeLib.import(script, script.Parent.Parent, "celebration-event", "celebration-event-window-manager").default
local default64 = RuntimeLib.import(script, script.Parent.Parent, "celebration-event", "celebration-event-login-window-manager").default
local default65 = RuntimeLib.import(script, script.Parent.Parent, "celebration-event", "celebration-ticket-challenge-window-manager").default
local default66 = RuntimeLib.import(script, script.Parent.Parent, "celebration-event", "daily-ticket-caps-window-manager").default
local default67 = RuntimeLib.import(script, script.Parent.Parent, "celebration-event-shop", "celebration-event-shop-window-manager").default
local default68 = RuntimeLib.import(script, script.Parent.Parent, "celebration-farewell", "farewell-rod-skin-reward-manager").default
local default69 = RuntimeLib.import(script, script.Parent.Parent, "player-stats", "player-stats-window-manager").default
local selectPinataBossHp = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "slices", "pinata-boss.selectors").selectPinataBossHp
local default70 = RuntimeLib.import(script, script.Parent.Parent, "charm", "charm-window-manager").default
local default71 = RuntimeLib.import(script, script.Parent.Parent, "zone-gacha", "zone-gacha-window-manager").default
local default72 = RuntimeLib.import(script, script.Parent, "water-movement-hint").default
local default73 = RuntimeLib.import(script, script.Parent, "water-movement-touch-controls").default
local default74 = RuntimeLib.import(script, script.Parent, "hook-flight-steering-touch-controls").default
local default75 = RuntimeLib.import(script, script.Parent, "flight-trigger-gate-combo").default
local default76 = RuntimeLib.import(script, script.Parent, "hoola-pity-bar").default
local default77 = RuntimeLib.import(script, script.Parent, "hoola-score-popup-manager").default
local default78 = RuntimeLib.import(script, script.Parent.Parent, "aquarium-shop", "aquarium-shop-window-manager").default
local default79 = RuntimeLib.import(script, script.Parent.Parent.Parent, "lucky-block", "lucky-block-chances-window").default
local default80 = RuntimeLib.import(script, script.Parent.Parent, "zone-token-trader", "zone-token-trader-window-manager").default
local default81 = RuntimeLib.import(script, script.Parent.Parent, "fishing-contracts", "fishing-contracts-window-manager").default
local isFishingContractsEnabled = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "data", "fishing-contracts").isFishingContractsEnabled

local function TrainingPowerBar(p1) -- line: 134
    -- upvalues: react (copy), useRootSelector (copy), selectPlayerStat (copy), selectActiveRodPowerCap (copy), localPlayerUserId (copy), default52 (copy)
    local rebirthCount, rodImageId, visible = p1.rebirthCount, p1.rodImageId, p1.visible
    local v6 = useRootSelector(selectPlayerStat(localPlayerUserId, "power"))
    local v7 = useRootSelector(selectActiveRodPowerCap(localPlayerUserId))

    return react.createElement(default52, {
        forceVisible = true,
        powerCap = v7,
        rawPower = if v6 == nil then 1 else 1 + v6,
        rebirthCount = rebirthCount,
        rodImageId = rodImageId,
        visible = visible
    })
end

local v8 = fomoIslandButtonLgPositionXScale - fomoIslandButtonWidthScale - 0.02

return {
    default = function(p2) -- Hud | line: 176
        -- upvalues: react (copy), useCallback (copy), useEffect (copy), useRef (copy), useState (copy), subscribe (copy), fishingMovementLockedAtom (copy), statDisplayHiddenAtom (copy), rglActiveAtom (copy), catchSticksActiveAtom (copy), default (copy), default2 (copy), default3 (copy), fomoIslandButtonLgPositionYScale (copy), useRootSelector (copy), useRootProducer (copy), selectCurrentWindow (copy), selectHoldSkillCheckEnabled (copy), selectShouldAutoPromptDailyReward (copy), selectPlayerStat (copy), selectEquippedInventoryItem (copy), selectDayLastClaimedDailyReward (copy), selectPlayerRebirthCount (copy), selectEquippedRodName (copy), fishingRodsData (copy), dailyRewardCooldownSeconds (copy), localPlayerUserId (copy), default4 (copy), default5 (copy), useWindowCameraEffects (copy), aquariumSkinPreviewNameAtom (copy), useScreenSizeState (copy), BackpackWindowManager (copy), default6 (copy), default7 (copy), default8 (copy), CelebrationBackpackWindowManager (copy), default9 (copy), selectTutorialStep (copy), tutorialSteps (copy), default10 (copy), default11 (copy), default12 (copy), default13 (copy), default14 (copy), default15 (copy), default16 (copy), default17 (copy), default18 (copy), default19 (copy), default20 (copy), default21 (copy), default22 (copy), default23 (copy), default24 (copy), default25 (copy), default26 (copy), default27 (copy), default28 (copy), default29 (copy), default30 (copy), default31 (copy), default32 (copy), default33 (copy), default34 (copy), default35 (copy), default36 (copy), default37 (copy), AquariumSkinSource (copy), default38 (copy), default39 (copy), default40 (copy), default41 (copy), default42 (copy), default43 (copy), default44 (copy), default45 (copy), default46 (copy), default47 (copy), default48 (copy), GuiService (copy), default49 (copy), default50 (copy), RebirthReadyNotifier (copy), RebirthCelebrationOverlay (copy), default51 (copy), default53 (copy), selectIsInFishingArea (copy), selectIsNearBase (copy), default54 (copy), default55 (copy), default56 (copy), default57 (copy), default58 (copy), default59 (copy), default60 (copy), default61 (copy), default62 (copy), default63 (copy), default64 (copy), default65 (copy), default66 (copy), default67 (copy), default68 (copy), default69 (copy), selectPinataBossHp (copy), default70 (copy), default71 (copy), default72 (copy), default73 (copy), default74 (copy), default75 (copy), default76 (copy), default77 (copy), default78 (copy), default79 (copy), default80 (copy), default81 (copy), isFishingContractsEnabled (copy), TrainingPowerBar (copy), v8 (copy)
        local v9 = if p2 == nil then {} else p2
        local forceDiscordVisible, isCelebrationPlace = v9.forceDiscordVisible, v9.isCelebrationPlace

        if isCelebrationPlace == nil then
            isCelebrationPlace = false
        end

        local v10 = useRootProducer()
        local v11 = useScreenSizeState() == "lg"
        local v12 = useRootSelector(selectCurrentWindow)
        local v13, v14 = useState(aquariumSkinPreviewNameAtom())

        useEffect(function() -- line: 190
            -- upvalues: v14 (copy), subscribe (copy), aquariumSkinPreviewNameAtom (copy)
            return subscribe(aquariumSkinPreviewNameAtom, v14)
        end, {})

        local v15 = useRootSelector(selectIsInFishingArea)
        local isActive = useRootSelector(selectPinataBossHp).isActive
        local v16 = useRootSelector(selectTutorialStep)
        local v17 = useRootSelector(selectIsNearBase)
        local v18 = useRootSelector(selectPlayerRebirthCount(localPlayerUserId))
        local v19 = useRootSelector(selectEquippedInventoryItem(localPlayerUserId))
        local v20 = useRootSelector(selectEquippedRodName(localPlayerUserId))
        local v21

        if v20 ~= nil then
            v21 = fishingRodsData[v20]

            if v21 ~= nil then
                v21 = v21.imageId
            end
        end

        if v19 ~= nil then
            v19 = v19.itemType
        end

        local v22 = v19 == "trainingWeight"
        local v23 = useRootSelector(selectPlayerStat(localPlayerUserId, "spinWheelSpins"))

        if v23 == nil then
            v23 = 0
        end

        local v24 = useRootSelector(selectDayLastClaimedDailyReward(localPlayerUserId))

        useRootSelector(selectShouldAutoPromptDailyReward(localPlayerUserId))
        useRootSelector(selectHoldSkillCheckEnabled(localPlayerUserId))
        v24 = not v24 or v24.day == 0 or DateTime.now().UnixTimestamp - DateTime.fromUniversalTime(v24.year, v24.month, v24.day, 0, 0, 0).UnixTimestamp >= dailyRewardCooldownSeconds

        local v25 = v12 == "communityReward" or v12 == "communityRewardShop"
        local v26 = v12 == "celebrationEvent"
        local v27 = v12 == "celebrationLogin"
        local v28 = v12 == "celebrationTicketChallenge"
        local v29 = v12 == "celebrationEventShop"
        local v30 = v12 == "dailyTicketCaps"
        local v31 = v12 == "charm"
        local v32 = v12 == "freeReward"
        local v33 = v12 == "dailyReward"
        local v34 = v12 == "settings"
        local v35 = v12 == "changelog"
        local v36 = v12 == "letter"
        local v37 = v12 == "backpack"
        local v38 = v12 == "deleteConfirmation"
        local v39 = v12 == "loadingScreen"
        local v40 = v12 == "eventLoadingScreen"
        local v41 = v12 == "exclusiveShop"
        local v42 = v12 == "claimCode"
        local v43 = v12 == "baitAuras"
        local v44 = v12 == "charmAttributes"
        local v45 = v12 == "index"
        local v46 = v12 == "shop"
        local v47 = v12 == "weightsShop"
        local v48 = v12 == "rodsShop"
        local v49 = v12 == "rodSkins"
        local v50 = v12 == "rodShopVfx"
        local v51 = v12 == "sellShop"
        local v52 = v12 == "aquarium"
        local v53 = v12 == "aquariumShop"
        local v54 = v12 == "fishDisplayMenu"
        local v55 = v12 == "playtimeSpinWheel"
        local v56 = v12 == "rebirth"
        local v57 = v12 == "offlineEarnings"
        local v58 = v12 == "discordReward"
        local v59 = v12 == "setPower"
        local v60 = v12 == "playerStats"
        local v61 = v12 == "luckyBlockChances"
        local v62 = v12 == "zoneGacha"
        local v63 = v12 == "zoneTokenTrader"
        local v64 = isFishingContractsEnabled and v12 == "fishingContracts"
        local v65 = v12 == "none"
        local v66 = v45 or v41 or v31
        local v67 = GuiService:IsTenFootInterface()

        useWindowCameraEffects(v13 == nil and v12 ~= "none" and v12 ~= "backpack" and v12 ~= "loadingScreen" and v12 ~= "eventLoadingScreen" and v12 ~= "aquarium" and v12 ~= "baitAuras" and v12 ~= "charmAttributes" and v12 ~= "zoneGacha" and v12 ~= "fishingContracts")

        local v69 = useRef(false)
        local v70 = useRef(nil)
        local v71 = useRef(v12)

        useEffect(function() -- line: 272
            -- upvalues: v10 (copy), v12 (copy), v69 (copy), v71 (copy)
            if v69.current and v71.current ~= "none" and v12 == "none" then
                v69.current = false
                v10.windowOpened({
                    currentWindow = "aquarium"
                })
            end

            v71.current = v12
        end, { v12, v10 })

        local v72 = useCallback(function(p3) -- line: 281
            -- upvalues: v10 (copy), v69 (copy), v70 (copy), AquariumSkinSource (copy)
            local t2 = {
                [AquariumSkinSource.CelebrationEventShop] = "celebrationEventShop",
                [AquariumSkinSource.DailyReward] = "dailyReward",
                [AquariumSkinSource.ExclusiveShop] = "exclusiveShop",
                [AquariumSkinSource.SkinCrate] = "aquariumShop",
                [AquariumSkinSource.SpinWheel] = "playtimeSpinWheel",
                [AquariumSkinSource.Index] = "index"
            }

            v69.current = true
            v70.current = "skins"
            v10.windowOpened({
                aquariumShopSection = if p3 == AquariumSkinSource.SkinCrate then "crates" else nil,
                currentWindow = t2[p3]
            })
        end, { v10 })
        local v73, v74 = useState(false)
        local v75, v76 = useState(not v22)
        local v77, v78 = useState(false)
        local v79, v80 = useState(statDisplayHiddenAtom())

        useEffect(function() -- line: 301
            -- upvalues: v80 (copy), subscribe (copy), statDisplayHiddenAtom (copy)
            return subscribe(statDisplayHiddenAtom, function(p4) -- line: 302
                -- upvalues: v80 (copy)
                v80(p4)
            end)
        end, {})
        useEffect(function() -- line: 306
            -- upvalues: v15 (copy), v80 (copy)
            if not v15 then
                v80(false)
            end
        end, { v15 })
        useEffect(function() -- line: 313
            -- upvalues: v76 (copy), v78 (copy), v22 (copy)
            if v22 then
                v76(false)

                local v81 = task.delay(0.3, function() -- line: 316
                    -- upvalues: v78 (copy)
                    return v78(true)
                end)

                return function() -- line: 319
                    -- upvalues: v81 (copy)
                    return task.cancel(v81)
                end
            end

            v78(false)

            local v82 = task.delay(0.3, function() -- line: 324
                -- upvalues: v76 (copy), v22 (copy)
                return v76(not v22)
            end)

            return function() -- line: 327
                -- upvalues: v82 (copy)
                return task.cancel(v82)
            end
        end, { v22 })
        useEffect(function() -- line: 332
            -- upvalues: v74 (copy), subscribe (copy), fishingMovementLockedAtom (copy)
            return subscribe(fishingMovementLockedAtom, function(p5) -- line: 333
                -- upvalues: v74 (copy)
                v74(p5)
            end)
        end, {})

        local v83, v84 = useState(rglActiveAtom())
        local v85, v86 = useState(catchSticksActiveAtom())

        useEffect(function() -- line: 339
            -- upvalues: v84 (copy), subscribe (copy), rglActiveAtom (copy)
            return subscribe(rglActiveAtom, v84)
        end, {})
        useEffect(function() -- line: 342
            -- upvalues: v86 (copy), subscribe (copy), catchSticksActiveAtom (copy)
            return subscribe(catchSticksActiveAtom, v86)
        end, {})

        local v87 = useCallback(function() -- line: 345
            -- upvalues: v10 (copy)
            v10.windowToggled({
                currentWindow = "backpack"
            })
        end, { v10 })
        local v88 = useCallback(function() -- line: 350
            -- upvalues: v10 (copy)
            v10.windowToggled({
                currentWindow = "playtimeSpinWheel"
            })
        end, { v10 })

        useCallback(function() -- line: 355
            -- upvalues: v10 (copy)
            v10.windowToggled({
                currentWindow = "dailyReward"
            })
        end, { v10 })
        useCallback(function() -- line: 360
            -- upvalues: v10 (copy)
            v10.windowToggled({
                currentWindow = "discordReward"
            })
        end, { v10 })

        if v44 then
            return react.createElement("frame", {
                BackgroundTransparency = 1,
                Size = UDim2.fromScale(1, 1)
            }, react.createElement(default17), react.createElement(default4, {
                ["in"] = v44
            }, react.createElement(default62)), react.createElement(default16))
        end

        if v43 then
            return react.createElement("frame", {
                BackgroundTransparency = 1,
                Size = UDim2.fromScale(1, 1)
            }, react.createElement(default17), react.createElement(default4, {
                ["in"] = v43
            }, react.createElement(default61)), react.createElement(default16))
        end

        if v62 then
            return react.createElement("frame", {
                BackgroundTransparency = 1,
                Size = UDim2.fromScale(1, 1)
            }, react.createElement(default17), react.createElement(default4, {
                ["in"] = v62
            }, react.createElement(default71)), react.createElement(default16))
        end

        if v53 then
            return react.createElement("frame", {
                BackgroundTransparency = 1,
                Size = UDim2.fromScale(1, 1)
            }, react.createElement(default17), react.createElement(default4, {
                ["in"] = true
            }, react.createElement(default78)))
        end

        local createElement = react.createElement
        local t4 = {
            BackgroundTransparency = 1,
            Size = UDim2.fromScale(1, 1)
        }
        local v89 = react.createElement(default17, {
            visible = not v45 and not v26 and not v27 and not v28 and not v29 and not v73
        })
        local v90 = not v46
        local Fragment, Fragment2, v91, v93, v94, v95, v96, v97

        if v90 then
            v90 = not v52

            local createElement, v98

            if v90 then
                v90 = not v73

                if v90 then
                    createElement = react.createElement
                    Fragment = react.Fragment
                    v94 = react.createElement

                    if isCelebrationPlace then
                        v95 = default2
                        v98 = {}
                        v75 = v75 and not v66 and not v26 and not v27 and not v28 and not v29 and not isActive and not v83 and not v85
                    else
                        v95 = default
                        v98 = {}
                        v75 = v75 and not v66 and not v26 and not v27 and not v28 and not v29 and not isActive
                    end

                    v98.visible = v75
                    v94 = v94(v95, v98)
                    v95 = v22 and react.createElement(TrainingPowerBar, {
                        rebirthCount = v18,
                        rodImageId = v21,
                        visible = v77
                    })
                    v98 = not v15

                    if v98 then
                        v98 = not v22

                        if v98 then
                            v98 = not v26
                            v96 = v98 and react.createElement(react.Fragment, nil, react.createElement(default18, {
                                isCelebrationPlace = isCelebrationPlace
                            }), not v66 and not v27 and not v28 and not v29 and react.createElement(default19))
                        else
                            v96 = v98
                        end
                    else
                        v96 = v98
                    end

                    if v12 == "none" or v12 == "backpack" then
                        Fragment2 = react.createElement
                        v91 = {
                            forceDiscordVisible = forceDiscordVisible,
                            isCelebrationPlace = isCelebrationPlace,
                            onBackpackClick = v87
                        }

                        function v91.onDailyRewardsPress() -- line: 416
                            -- upvalues: v10 (copy)
                            return v10.windowToggled({
                                currentWindow = "dailyReward"
                            })
                        end

                        function v91.onDiscordPress() -- line: 421
                            -- upvalues: v10 (copy)
                            return v10.windowToggled({
                                currentWindow = "discordReward"
                            })
                        end

                        v91.onPlaytimeWheelPress = v88
                        v91.showDailyRewardNotification = v24
                        v91.spinCount = v23
                        Fragment2 = Fragment2(default22, v91)
                    else
                        Fragment2 = false
                    end

                    v93 = isCelebrationPlace and (v12 == "none" or v12 == "backpack") and react.createElement(default3)
                    v97 = createElement(Fragment, nil, v94, v95, v96, Fragment2, v93)
                else
                    v97 = v90
                end
            else
                v97 = v90
            end
        else
            v97 = v90
        end

        Fragment = react.createElement(default59)

        local v99, v100

        if v11 then
            local v101 = not v46

            if v101 then
                v101 = not v52

                if v101 then
                    v101 = not v73
                    v99 = v101 and (v12 == "none" or v12 == "backpack") and (if isCelebrationPlace then react.createElement(default8, {
                        onBackpackClick = v87
                    }) else react.createElement(default6, {
                        onBackpackClick = v87
                    }))
                else
                    v99 = v101
                end
            else
                v99 = v101
            end

            v94 = not v46

            if v94 then
                v94 = not v52

                if v94 then
                    v94 = not v73

                    if v94 then
                        v94 = not v22
                        v100 = v94 and (v12 == "none" or v12 == "backpack") and not isCelebrationPlace and react.createElement(default7, {
                            anchorPoint = Vector2.new(1, 1),
                            position = UDim2.fromScale(v8 - 0.02, fomoIslandButtonLgPositionYScale - 0.02)
                        })
                    else
                        v100 = v94
                    end
                else
                    v100 = v94
                end
            else
                v100 = v94
            end
        else
            v100 = v11
            v99 = v11
        end

        v95 = not v11

        local v102

        if v95 then
            v95 = not v46

            if v95 then
                v95 = not v52

                if v95 then
                    v95 = not v73

                    if v95 then
                        v95 = not v22
                        v102 = v95 and (v12 == "none" or v12 == "backpack") and not isCelebrationPlace and react.createElement(default7, {
                            anchorPoint = Vector2.new(1, 0.5),
                            position = UDim2.fromScale(0.851, 0.8069999999999999)
                        })
                    else
                        v102 = v95
                    end
                else
                    v102 = v95
                end
            else
                v102 = v95
            end
        else
            v102 = v95
        end

        v96 = not v46
        v96 = v96 and not v73 and not v79 and not v66 and not v26 and not v27 and not v28 and not v29 and react.createElement(default60, {
            isCelebrationPlace = isCelebrationPlace,
            isTraining = v22
        })
        Fragment2 = not v46

        if Fragment2 then
            Fragment2 = not v73

            if Fragment2 then
                Fragment2 = v12 == "none" and react.createElement(react.Fragment, nil, react.createElement(default72), react.createElement(default73))
            end
        end

        v93 = react.createElement(default74)
        v91 = react.createElement(default75)

        local v92 = react.createElement(default76)
        local v103 = react.createElement(default77)
        local v104 = react.createElement
        local v105 = {
            isTraining = v22
        }

        if v17 then
            v17 = v12 == "none" and not v73
        end

        v105.visible = v17
        v104 = v104(default54, v105)

        local v106 = react.createElement(default55, {
            isTraining = v22,
            visible = not isActive
        })

        v105 = react.createElement(default16)

        local v107 = not isCelebrationPlace
        local v108, v109

        if v107 then
            if not v79 or v16 == tutorialSteps.addFishToAquarium or v16 == tutorialSteps.walkToDock then
                v109 = react.createElement
                v108 = {}

                if v79 then
                    v79 = v16 ~= tutorialSteps.addFishToAquarium and v16 ~= tutorialSteps.walkToDock
                end

                v108.hideText = v79
                v109 = v109(default9, v108)
            else
                v109 = false
            end
        else
            v109 = v107
        end

        local v111 = react.createElement(default10)

        v108 = react.createElement(default11)

        local v112 = react.createElement(default12)
        local v113 = react.createElement(default4, {
            ["in"] = v25
        }, react.createElement(default34))
        local v114 = react.createElement(default5, {
            doEnterTransitionOnFirstMount = true,
            ["in"] = v26
        }, react.createElement(default63))
        local v115 = react.createElement(default4, {
            ["in"] = v27
        }, react.createElement(default64))
        local v116 = react.createElement(default4, {
            ["in"] = v28
        }, react.createElement(default65))
        local v117 = react.createElement(default4, {
            ["in"] = v29
        }, react.createElement(default67))
        local v118 = react.createElement(default4, {
            ["in"] = v30
        }, react.createElement(default66))
        local v119 = react.createElement(default4, {
            ["in"] = v31
        }, react.createElement(default70))
        local v120 = react.createElement(default4, {
            ["in"] = v58
        }, react.createElement(default35))
        local v121 = react.createElement(default4, {
            ["in"] = v32
        }, react.createElement(default33))
        local v122 = react.createElement(default4, {
            ["in"] = v41
        }, react.createElement(default20))
        local v123 = react.createElement(default4, {
            ["in"] = v33
        }, react.createElement(default21))
        local v124 = react.createElement(default4, {
            ["in"] = v34
        }, react.createElement(default23))
        local v125 = react.createElement(default4, {
            ["in"] = v35
        }, react.createElement(default24))
        local v126 = react.createElement(default4, {
            enableCameraEffects = true,
            ["in"] = v36
        }, react.createElement(default25))
        local v127 = react.createElement(default42)
        local v128 = react.createElement(default4, {
            ["in"] = v37
        }, if isCelebrationPlace then react.createElement(CelebrationBackpackWindowManager) else react.createElement(BackpackWindowManager))

        return createElement("frame", t4, v89, v97, Fragment, v99, v100, v102, v96, Fragment2, v93, v91, v92, v103, v104, v106, v105, v109, v111, v108, v112, v113, v114, v115, v116, v117, v118, v119, v120, v121, v122, v123, v124, v125, v126, v127, v128, react.createElement(default4, {
            ["in"] = v38
        }, react.createElement(default13)), react.createElement(default4, {
            ["in"] = v39
        }, react.createElement(default14)), v40 and react.createElement(default15), react.createElement(default4, {
            ["in"] = v42
        }, react.createElement(default26)), react.createElement(default4, {
            ["in"] = v43
        }, react.createElement(default61)), react.createElement(default4, {
            ["in"] = v45
        }, react.createElement(default27)), react.createElement(default4, {
            ["in"] = v59
        }, react.createElement(default36)), react.createElement(default4, {
            ["in"] = v60
        }, react.createElement(default69)), react.createElement(default4, {
            ["in"] = v61
        }, react.createElement(default79)), react.createElement(default4, {
            ["in"] = v47
        }, react.createElement(default28)), react.createElement(default4, {
            ["in"] = v48
        }, react.createElement(default29)), react.createElement(default4, {
            ["in"] = v49
        }, react.createElement(default30)), react.createElement(default4, {
            ["in"] = v50
        }, react.createElement(default31)), react.createElement(default4, {
            ["in"] = v51
        }, react.createElement(default32)), react.createElement(default4, {
            ["in"] = v63
        }, react.createElement(default80)), react.createElement(default4, {
            ["in"] = v64
        }, react.createElement(default81)), react.createElement(default4, {
            ["in"] = v52
        }, react.createElement(default37, {
            getInitialTab = function() -- getInitialTab | line: 515
                -- upvalues: v70 (copy)
                return v70.current
            end,
            onClearInitialTab = function() -- onClearInitialTab | line: 518
                -- upvalues: v70 (copy)
                v70.current = nil
            end,
            onOpenSourceWindow = v72
        })), react.createElement(default4, {
            ["in"] = v53
        }, react.createElement(default78)), react.createElement(default4, {
            ["in"] = v54
        }, react.createElement(default38)), react.createElement(default4, {
            ["in"] = v55
        }, react.createElement(default40)), react.createElement(default39), react.createElement(default68), react.createElement(RebirthReadyNotifier), react.createElement(default4, {
            ["in"] = v56
        }, react.createElement(default50)), react.createElement(default4, {
            ["in"] = v57
        }, react.createElement(default41)), v15 and not v22 and react.createElement(default51), react.createElement(default53), react.createElement(default43), react.createElement(default44), react.createElement(default45), react.createElement(default46), react.createElement(default47), react.createElement(default48), react.createElement(RebirthCelebrationOverlay), react.createElement(default56), react.createElement(default57), react.createElement(default58), react.createElement(default49, {
            visible = v65 and v67
        }))
    end
}
