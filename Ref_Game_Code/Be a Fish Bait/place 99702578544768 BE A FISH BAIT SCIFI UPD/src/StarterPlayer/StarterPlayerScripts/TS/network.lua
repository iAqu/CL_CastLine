-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local t = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "t", "lib", "ts").t
local network = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "network")
local globalEvents, globalFunctions = network.globalEvents, network.globalFunctions

return {
    events = globalEvents:createClient({}, {
        incomingIds = {
            "abortGiantRigCutscene",
            "aquariumCrateRevealReady",
            "apexFishCaught",
            "celebrationChallengeTicketsUpdated",
            "celebrationEventRegisteredCountUpdated",
            "celebrationFarewellTestRequested",
            "celebrationMinigameRewardGranted",
            "celebrationRewardGranted",
            "disableMovement",
            "dispatchReflexActions",
            "displayFeedbackMessage",
            "displaySystemMessage",
            "enableMovement",
            "fishLanded",
            "fishingSessionEnded",
            "frostwyrmCaught",
            "giantRigCutscenePreparationCancelled",
            "giantRigCutsceneTeleportFailed",
            "hookQteMutationRolled",
            "hookSpawned",
            "hoolaRunResolved",
            "hoolaPityStateUpdated",
            "openCommunityRewardWindow",
            "openDiscordRewardWindow",
            "previewAquariumSkin",
            "otherPlayerStartedFishing",
            "otherPlayerStoppedFishing",
            "pinataBossDied",
            "pinataBossHit",
            "pinataBossRewardGranted",
            "shardRewardGranted",
            "pinataBossSlapHitResult",
            "playSoundForPlayer",
            "prepareGiantRigCutscene",
            "reelStarted",
            "requestClientStateSnapshot",
            "serverRestartScheduled",
            "showPurchaseErrorRejoin",
            "spawnAquariumCoins",
            "spawnCoin",
            "rglQueueUpdated",
            "rglPublicDollTransition",
            "rglSessionStarted",
            "rglSessionPhaseChanged",
            "rglSessionRosterChanged",
            "rglSessionEnded",
            "rglCountdown",
            "rglEliminated",
            "rglObstacleRemoved",
            "rglObstacleSpawned",
            "rglObstaclesCleared",
            "rglPlayerWon",
            "rglRewardGranted",
            "startGiantRigCutscene",
            "giftRecipientOwnershipUpdated",
            "podiumFreePurchaseGranted"
        },
        incoming = {
            abortGiantRigCutscene = {
                { t.string },
                nil
            },
            aquariumCrateRevealReady = {
                {
                    t.interface({
                        createdAt = t.number,
                        pityAfter = t.number,
                        pityBefore = t.number,
                        productId = t.number,
                        purchaseId = t.string,
                        rewards = t.array(t.interface({
                            duplicateShardsAwarded = t.optional(t.number),
                            isLegendary = t.boolean,
                            rarity = t.literal("common", "uncommon", "rare", "epic", "legendary", "mythic", "godly", "secret", "hacked", "cosmic", "extinct", "kaijuwu", "scifi", "exclusive"),
                            skinName = t.string,
                            wasAlreadyOwned = t.boolean
                        })),
                        seriesId = t.string
                    })
                },
                nil
            },
            apexFishCaught = {
                {
                    t.string,
                    t.number,
                    t.string,
                    t.string,
                    t.number,
                    t.array(t.string),
                    t.literal("skillCheck", "autokill")
                },
                nil
            },
            celebrationChallengeTicketsUpdated = {
                { t.number },
                nil
            },
            celebrationEventRegisteredCountUpdated = {
                { t.number },
                nil
            },
            celebrationFarewellTestRequested = {
                {},
                nil
            },
            celebrationMinigameRewardGranted = {
                {
                    t.interface({
                        amount = t.number,
                        source = t.literal("catchSticks", "obby")
                    })
                },
                nil
            },
            celebrationRewardGranted = {
                {
                    t.interface({
                        amount = t.number,
                        kind = t.literal("tickets")
                    })
                },
                nil
            },
            disableMovement = {
                {},
                nil
            },
            dispatchReflexActions = {
                {
                    t.array(t.interface({
                        name = t.string,
                        arguments = t.array(t.union(t.any, t.none))
                    }))
                },
                nil
            },
            displayFeedbackMessage = {
                {
                    t.string,
                    t.literal("success", "error", "neutral"),
                    t.optional(t.number)
                },
                nil
            },
            displaySystemMessage = {
                { t.string },
                nil
            },
            enableMovement = {
                {},
                nil
            },
            fishLanded = {
                {},
                nil
            },
            fishingSessionEnded = {
                { t.number },
                nil
            },
            frostwyrmCaught = {
                {
                    t.string,
                    t.optional(t.number)
                },
                nil
            },
            giantRigCutscenePreparationCancelled = {
                { t.string },
                nil
            },
            giantRigCutsceneTeleportFailed = {
                { t.string },
                nil
            },
            hookQteMutationRolled = {
                { t.optional(t.literal("hoola1", "hoola2", "hoola3", "Gold", "Diamond", "Plasma", "Molten", "Radioactive", "Glitched", "Champion", "Delulu")) },
                nil
            },
            hookSpawned = {
                { t.string },
                nil
            },
            hoolaRunResolved = {
                {
                    t.number,
                    t.number,
                    t.optional(t.literal("hoola1", "hoola2", "hoola3", "Gold", "Diamond", "Plasma", "Molten", "Radioactive", "Glitched", "Champion", "Delulu")),
                    t.optional(t.literal("hoola1", "hoola2", "hoola3", "Gold", "Diamond", "Plasma", "Molten", "Radioactive", "Glitched", "Champion", "Delulu")),
                    t.optional(t.number)
                },
                nil
            },
            hoolaPityStateUpdated = {
                {
                    t.number,
                    t.literal("hoola1", "hoola2", "hoola3", "Gold", "Diamond", "Plasma", "Molten", "Radioactive", "Glitched", "Champion", "Delulu"),
                    t.number
                },
                nil
            },
            openCommunityRewardWindow = {
                {},
                nil
            },
            openDiscordRewardWindow = {
                {},
                nil
            },
            previewAquariumSkin = {
                {
                    t.string,
                    t.number
                },
                nil
            },
            otherPlayerStartedFishing = {
                {
                    t.string,
                    t.interface({
                        direction = t.Vector3,
                        flightTriggerGateEligible = t.optional(t.boolean),
                        peakBias = t.number,
                        peakHeight = t.number,
                        power = t.number,
                        startPosition = t.Vector3
                    }),
                    t.number
                },
                nil
            },
            otherPlayerStoppedFishing = {
                { t.string },
                nil
            },
            pinataBossDied = {
                {},
                nil
            },
            pinataBossHit = {
                {},
                nil
            },
            pinataBossRewardGranted = {
                {
                    t.interface({
                        amount = t.number,
                        kind = t.literal("tickets")
                    })
                },
                nil
            },
            shardRewardGranted = {
                {
                    t.literal("universalShard", "mythicShard", "legendaryShard", "epicShard", "rareShard"),
                    t.number
                },
                nil
            },
            pinataBossSlapHitResult = {
                {
                    t.number,
                    t.Vector3
                },
                nil
            },
            playSoundForPlayer = {
                {
                    t.literal("Rebirth", "ButtonClick", "ButtonHover", "Mining", "Mined", "Crumble", "MoneyPickup", "MoneyPickup2", "PhysicalButtonClick", "Lobby", "Lobby1", "Lobby2", "GemObtained1", "GemObtained2", "PlaceGem", "RemoveGem", "OreLevelUp", "LavaBucketLevelUp", "PourLava1", "PourLava2", "Abyss", "Fahhh", "WowAnime", "BonusUpgrade", "FishSwimWaterSound", "ZoneChange", "DivingIntoWater", "WaterSkip", "ComboTierSFX1", "ComboTierSFX2", "ComboFailSFX", "PurchaseSuccess", "LandingImpact", "JackpotLandingImpact", "FallingSound", "Heartbeat", "3-2-1Countdown", "FishNibble", "WindSFX", "LifeInAnElevator", "EventIslandMusic", "CastComplete", "AuraFarm", "WLSScream", "BarbellSound", "PopSound", "CrateTapSound", "CuteLevelUp", "ButtonSuccess", "FrenzyMusic", "TickSound", "HeavyMetalSound", "ThockyKeyboard", "LeavingNotif", "OpenExclusiveShop", "PartyPopper", "PartyBlower", "RiftPortalEnter", "RareFishEncounter", "FrostwyrmMinigame", "Slap", "KeycapSound", "FishTakeoutSound", "FishingRodTakeoutSound", "WeightTakeoutSound"),
                    t.optional(t.number)
                },
                nil
            },
            prepareGiantRigCutscene = {
                {
                    t.string,
                    t.array(t.number)
                },
                nil
            },
            reelStarted = {
                {
                    t.Vector3,
                    t.Vector3,
                    t.Vector3,
                    t.number,
                    t.number,
                    t.string,
                    t.string
                },
                nil
            },
            requestClientStateSnapshot = {
                { t.string },
                nil
            },
            serverRestartScheduled = {
                {
                    t.number,
                    t.number,
                    t.optional(t.string)
                },
                nil
            },
            showPurchaseErrorRejoin = {
                {},
                nil
            },
            spawnAquariumCoins = {
                {
                    t.string,
                    t.number
                },
                nil
            },
            spawnCoin = {
                {
                    t.string,
                    t.Vector3,
                    t.optional(t.boolean),
                    t.optional(t.boolean)
                },
                nil
            },
            rglQueueUpdated = {
                {
                    t.number,
                    t.optional(t.number),
                    t.boolean
                },
                nil
            },
            rglPublicDollTransition = {
                {
                    t.optional(t.interface({
                        startYawDegrees = t.number,
                        targetYawDegrees = t.number,
                        startsAt = t.number,
                        endsAt = t.number
                    }))
                },
                nil
            },
            rglSessionStarted = {
                {
                    t.interface({
                        sessionId = t.string,
                        participantUserIds = t.array(t.number),
                        phase = t.literal("starting", "go", "stopWarning", "stop", "postStopBuffer", "finished", "expired", "ended"),
                        phaseEndsAt = t.number,
                        roundEndsAt = t.number,
                        dollTransition = t.interface({
                            startYawDegrees = t.number,
                            targetYawDegrees = t.number,
                            startsAt = t.number,
                            endsAt = t.number
                        }),
                        dollAnchorCFrame = t.optional(t.CFrame)
                    })
                },
                nil
            },
            rglSessionPhaseChanged = {
                {
                    t.string,
                    t.literal("starting", "go", "stopWarning", "stop", "postStopBuffer", "finished", "expired", "ended"),
                    t.number,
                    t.number,
                    t.interface({
                        startYawDegrees = t.number,
                        targetYawDegrees = t.number,
                        startsAt = t.number,
                        endsAt = t.number
                    })
                },
                nil
            },
            rglSessionRosterChanged = {
                {
                    t.string,
                    t.array(t.number)
                },
                nil
            },
            rglSessionEnded = {
                { t.string },
                nil
            },
            rglCountdown = {
                { t.string },
                nil
            },
            rglEliminated = {
                { t.literal("movement", "timeout") },
                nil
            },
            rglObstacleRemoved = {
                {
                    t.string,
                    t.string
                },
                nil
            },
            rglObstacleSpawned = {
                {
                    t.interface({
                        blinkingStartsAt = t.number,
                        boundsCFrameOffset = t.CFrame,
                        boundsSize = t.Vector3,
                        expiresAt = t.number,
                        fallsAt = t.number,
                        fishId = t.string,
                        landingCFrame = t.CFrame,
                        landsAt = t.number,
                        obstacleId = t.string,
                        sessionId = t.string,
                        skyCFrame = t.CFrame,
                        spawnedAt = t.number,
                        warningAppearsAt = t.number,
                        warningCFrame = t.CFrame
                    })
                },
                nil
            },
            rglObstaclesCleared = {
                { t.string },
                nil
            },
            rglPlayerWon = {
                {},
                nil
            },
            rglRewardGranted = {
                {
                    t.interface({
                        amount = t.number,
                        tier = t.literal("eliminated", "slowFinish", "fastFinish")
                    })
                },
                nil
            },
            startGiantRigCutscene = {
                {
                    t.string,
                    t.array(t.number),
                    t.number
                },
                nil
            },
            giftRecipientOwnershipUpdated = {
                {
                    t.optional(t.interface({
                        ownedAquariumSkins = t.array(t.string),
                        ownedBundleNames = t.array(t.string),
                        ownedGamepassNames = t.array(t.string),
                        ownedMountNames = t.array(t.string)
                    }))
                },
                nil
            },
            podiumFreePurchaseGranted = {
                {
                    t.number,
                    t.union(t.interface({
                        exclusiveFishReward = t.optional(t.interface({
                            exclusiveIndex = t.number,
                            fishName = t.string,
                            totalStock = t.number
                        })),
                        kind = t.literal("success"),
                        titleReward = t.optional(t.literal("freshBait", "maxedAquarium", "rageBait", "blessedBait", "baitAgain", "hooked", "vip", "devourer", "mjfish", "bassRod", "excalibur", "judgement", "billionaire", "gymBait", "jebaiter", "marathon", "quack", "certifiedBait", "baller", "monarch", "frozenOne", "icyFingers", "markOfTheOg", "ogPrime", "finalBoss", "developer"))
                    }), t.interface({
                        kind = t.literal("error"),
                        reason = t.literal("gamepassAlreadyOwned", "bundleAlreadyPurchased", "serverLuckDuplicate", "recipientNotFound", "unknown", "charmAlreadyOwned")
                    }))
                },
                nil
            }
        },
        incomingUnreliable = {},
        outgoingIds = {
            "storeGiftModeStarted",
            "storeGiftModeStopped",
            "analyticsApexHoldDragSuccess",
            "analyticsApexSkillCheckPassed",
            "analyticsApexSlapSuccess",
            "analyticsAquariumShopWindowOpened",
            "analyticsAquariumWindowOpened",
            "analyticsAquariumWindowOpenedAfterMoney",
            "analyticsAuraWindowOpened",
            "analyticsCharmPodiumViewed",
            "analyticsCharmObservatoryEntered",
            "analyticsCastAttempted",
            "analyticsCastCutsceneStarted",
            "analyticsEventShopOpened",
            "analyticsExitedPowerTraining",
            "analyticsFrostwyrmChallengeStarted",
            "analyticsFrostwyrmNearTablet",
            "analyticsHoldAndDragShown",
            "analyticsHookBounce",
            "analyticsJackpotCutsceneStarted",
            "analyticsLeaderboardOpened",
            "analyticsLuckyBlockNear",
            "analyticsLuckyBlockProximityPromptStarted",
            "analyticsRareFishCountdownStarted",
            "analyticsRareSkillCheckButtonShown",
            "analyticsRareSkillCheckStarted",
            "analyticsReachedBase",
            "analyticsSecondReachedBase",
            "analyticsSecondWalkedToDock",
            "analyticsSpinWheelUIOpened",
            "analyticsWeightShopOpened",
            "apexCutsceneFinished",
            "apexSkillCheckFailed",
            "cameraReturnedToPier",
            "castCutsceneRigSuspendRequested",
            "castFishingHook",
            "catchSticksGameStarted",
            "celebrationChallengeWindowClosed",
            "celebrationChallengeWindowOpened",
            "celebrationEventWindowClosed",
            "celebrationEventWindowOpened",
            "deluluRiftEntered",
            "giantRigCutsceneFinished",
            "giantRigCutscenePrepared",
            "hookLanded",
            "hookQteTapResult",
            "hoolaRunCompleted",
            "instantCapturePurchased",
            "socialEventRsvpPrompted",
            "playerBossAreaChanged",
            "reelAnimComplete",
            "requestAfkTeleport",
            "saveClientStateSnapshot",
            "snapshotOfflineEarningsForPurchase",
            "spawnTutorialGemNode",
            "startReflexBroadcaster",
            "stopFishing",
            "trainingFrenzyStarted",
            "rglRequestExit"
        },
        outgoingUnreliable = {},
        namespaceIds = {},
        namespaces = {}
    }),
    functions = globalFunctions:createClient({}, {
        incomingIds = {},
        incoming = {},
        outgoingIds = {
            "acceptGiftRequest",
            "acknowledgeAquariumCrateReveal",
            "addFishToAquarium",
            "cancelExclusiveFishReservation",
            "claimCelebrationReward",
            "claimCelebrationWelcomeReward",
            "beginCelebrationFarewell",
            "claimChallengeTier",
            "claimCommunityReward",
            "claimDailyReward",
            "claimFarewellRodSkinReward",
            "claimFreeReward",
            "claimFrostwyrmTitle",
            "claimIndexReward",
            "claimFishingContractMilestone",
            "claimLuckyBlockDrop",
            "claimOfflineEarnings",
            "claimPlaytimeReward",
            "claimPreLogoutBuff",
            "claimRewardCode",
            "collectCoin",
            "collectPlotMoney",
            "collectTicket",
            "completeCelebrationFarewell",
            "confirmAquariumUpgrade",
            "craftAquariumSkinShards",
            "deleteInventoryItems",
            "equipAquariumSkin",
            "exchangeAquariumSkinForShards",
            "exchangeAquariumSkinShards",
            "exchangeFishForTokens",
            "equipBaitAura",
            "equipBestAquariumFish",
            "equipEmote",
            "swapEmoteWithBackpack",
            "equipHologramSkin",
            "equipCharm",
            "startCharmRoll",
            "resolveCharmCandidate",
            "equipInventoryItem",
            "equipMount",
            "equipZoneGachaSkin",
            "equipZoneGachaBuff",
            "equipTitle",
            "getCanReachUncommonZone",
            "getGiftRecipientsOwnership",
            "levelUpAquariumFish",
            "likeCommunityMember",
            "likeHallOfFameMessage",
            "likePlot",
            "logCommunityRewardFunnelStep",
            "logDailyRewardFunnelStep",
            "logFreeRewardFunnelStep",
            "logOnboardingFunnelStep",
            "logPlaytimeRewardVisibilityFunnelStep",
            "logTutorialFunnelStep",
            "markAquariumSkinSeen",
            "markChangelogRead",
            "markFishCollectionSeen",
            "markTitlesSeen",
            "performRebirth",
            "pickaxeUsed",
            "processGiftPurchase",
            "processIndividualPurchase",
            "requestFreeTestPurchase",
            "purchaseAquariumSkin",
            "purchaseCelebrationTimeSkip",
            "purchaseCelebrationCosmetic",
            "purchaseCelebrationAuraReroll",
            "purchaseCelebrationTitle",
            "purchaseFomoAquariumSkin",
            "purchaseFomoOrbit",
            "purchaseFishReelbackVfx",
            "purchaseFishingRodSkin",
            "purchaseFishingContractLicense",
            "purchaseEmote",
            "purchaseShopItem",
            "rearrangeFishInToolbar",
            "registerForCelebrationEvent",
            "rejectGiftRequest",
            "requestGiftItem",
            "requestLeaderboardEntries",
            "rerollFishingContract",
            "reserveExclusiveFishPurchase",
            "rollBaitAura",
            "rollZoneGacha",
            "selectDisplayFish",
            "sellFishItems",
            "submitFishingContract",
            "setAudioVolume",
            "setCameraShakeEnabled",
            "setBossAutokillEnabled",
            "purchaseBossAutokillForTesting",
            "setEquipmentInToolbar",
            "setFishingRodSkin",
            "setFishReelbackVfx",
            "setHapticsEnabled",
            "setPickaxeInToolbar",
            "setShowcaseFish",
            "skipRebirth",
            "slapUsed",
            "spinPlaytimeWheel",
            "submitCatchSticksResult",
            "teleportToCelebrationPlace",
            "teleportToMainGame",
            "toggleMount",
            "trainingSkillcheckBonus",
            "trainingTick",
            "unequipAquariumFish",
            "unequipEmote",
            "unequipCharm",
            "unequipInventoryItem",
            "updateTutorialStep",
            "upgradeAquarium",
            "verifyDiscordAndClaimMJFish"
        },
        outgoing = {
            acceptGiftRequest = t.boolean,
            acknowledgeAquariumCrateReveal = t.boolean,
            addFishToAquarium = t.boolean,
            cancelExclusiveFishReservation = t.boolean,
            claimCelebrationReward = t.union(t.boolean, t.number),
            claimCelebrationWelcomeReward = t.boolean,
            beginCelebrationFarewell = t.boolean,
            claimChallengeTier = t.literal(false, "alreadyClaimed", "claimed", "notReached"),
            claimCommunityReward = t.boolean,
            claimDailyReward = t.union(t.boolean, t.number, t.literal("backpackFull")),
            claimFarewellRodSkinReward = t.boolean,
            claimFreeReward = t.boolean,
            claimFrostwyrmTitle = t.boolean,
            claimIndexReward = t.boolean,
            claimFishingContractMilestone = t.boolean,
            claimLuckyBlockDrop = t.literal(false, "mythicShard", "legendaryShard", "epicShard", "rareShard", "moneyBoost", "strengthBoost", "wheelSpin"),
            claimOfflineEarnings = t.union(t.number, t.literal(false)),
            claimPlaytimeReward = t.boolean,
            claimPreLogoutBuff = t.union(t.interface({
                buffKind = t.literal("money", "mutationLuck", "power"),
                expiresAt = t.number,
                forecastEarnings = t.number
            }), t.literal(false)),
            claimRewardCode = t.union(t.interface({
                data = t.interface({
                    expiresAt = t.optional(t.number),
                    liveAt = t.optional(t.number),
                    rewardAmount = t.number,
                    rewardBuffDurationSeconds = t.optional(t.number),
                    rewardBuffKind = t.optional(t.literal("money", "mutationLuck", "power")),
                    rewardGemName = t.optional(t.string),
                    rewardGemNodeRarity = t.optional(t.literal("common", "rare", "epic", "legendary", "mythic")),
                    rewardId = t.string,
                    rewardMinimumCash = t.optional(t.number),
                    rewardShardRarity = t.optional(t.literal("rare", "epic", "legendary", "mythic")),
                    rewardTitleId = t.optional(t.string),
                    rewardType = t.literal("money", "gemSpawns", "gem", "gemNode", "rerolls", "spinWheelSpins", "timedBuff", "tickets", "title", "lavaBucket", "timeSkip", "aquariumShard")
                }),
                kind = t.literal("success")
            }), t.interface({
                kind = t.literal("error"),
                reason = t.literal("invalidCode", "alreadyClaimed", "unknownError", "serverOutdated")
            })),
            collectCoin = t.union(t.number, t.literal(false)),
            collectPlotMoney = t.boolean,
            collectTicket = t.union(t.number, t.literal(false)),
            completeCelebrationFarewell = t.boolean,
            confirmAquariumUpgrade = t.boolean,
            craftAquariumSkinShards = t.boolean,
            deleteInventoryItems = t.boolean,
            equipAquariumSkin = t.boolean,
            exchangeAquariumSkinForShards = t.boolean,
            exchangeAquariumSkinShards = t.boolean,
            exchangeFishForTokens = t.union(t.number, t.literal(false)),
            equipBaitAura = t.boolean,
            equipBestAquariumFish = t.boolean,
            equipEmote = t.boolean,
            swapEmoteWithBackpack = t.boolean,
            equipHologramSkin = t.boolean,
            equipCharm = t.boolean,
            startCharmRoll = t.union(t.interface({
                candidate = t.interface({
                    resonanceGuaranteeUsed = t.boolean,
                    affixes = t.array(t.interface({
                        attributeId = t.literal("mutationLuck", "aquariumIncome", "shopDiscount", "bonusLuck", "weatherMutationLuck", "championMutationChance", "baitHopDistance", "bossFishDamage", "bossFishQteSize"),
                        quality = t.literal("standard", "good", "great", "perfect"),
                        value = t.number
                    })),
                    overallPercentile = t.number,
                    rolledAt = t.number,
                    tierId = t.literal(1, 2, 3, 5, 4),
                    trainingPower = t.number
                }),
                cost = t.number,
                isFree = t.boolean,
                kind = t.literal("success")
            }), t.interface({
                kind = t.literal("error"),
                reason = t.literal("invalidTier", "playerDataUnavailable", "rebirthRequired", "pendingCandidate", "insufficientCash")
            })),
            resolveCharmCandidate = t.union(t.interface({
                kind = t.literal("success")
            }), t.interface({
                kind = t.literal("error"),
                reason = t.literal("playerDataUnavailable", "invalidDecision", "noPendingCandidate")
            })),
            equipInventoryItem = t.boolean,
            equipMount = t.boolean,
            equipZoneGachaSkin = t.boolean,
            equipZoneGachaBuff = t.boolean,
            equipTitle = t.boolean,
            getCanReachUncommonZone = t.boolean,
            getGiftRecipientsOwnership = t.map(t.string, t.boolean),
            levelUpAquariumFish = t.boolean,
            likeCommunityMember = t.boolean,
            likeHallOfFameMessage = t.boolean,
            likePlot = t.boolean,
            logCommunityRewardFunnelStep = t.none,
            logDailyRewardFunnelStep = t.none,
            logFreeRewardFunnelStep = t.none,
            logOnboardingFunnelStep = t.none,
            logPlaytimeRewardVisibilityFunnelStep = t.none,
            logTutorialFunnelStep = t.none,
            markAquariumSkinSeen = t.none,
            markChangelogRead = t.none,
            markFishCollectionSeen = t.none,
            markTitlesSeen = t.none,
            performRebirth = t.boolean,
            pickaxeUsed = t.boolean,
            processGiftPurchase = t.union(t.interface({
                exclusiveFishReward = t.optional(t.interface({
                    exclusiveIndex = t.number,
                    fishName = t.string,
                    totalStock = t.number
                })),
                kind = t.literal("success"),
                titleReward = t.optional(t.literal("freshBait", "maxedAquarium", "rageBait", "blessedBait", "baitAgain", "hooked", "vip", "devourer", "mjfish", "bassRod", "excalibur", "judgement", "billionaire", "gymBait", "jebaiter", "marathon", "quack", "certifiedBait", "baller", "monarch", "frozenOne", "icyFingers", "markOfTheOg", "ogPrime", "finalBoss", "developer"))
            }), t.interface({
                kind = t.literal("error"),
                reason = t.literal("gamepassAlreadyOwned", "bundleAlreadyPurchased", "serverLuckDuplicate", "recipientNotFound", "unknown", "charmAlreadyOwned")
            })),
            processIndividualPurchase = t.union(t.interface({
                exclusiveFishReward = t.optional(t.interface({
                    exclusiveIndex = t.number,
                    fishName = t.string,
                    totalStock = t.number
                })),
                kind = t.literal("success"),
                titleReward = t.optional(t.literal("freshBait", "maxedAquarium", "rageBait", "blessedBait", "baitAgain", "hooked", "vip", "devourer", "mjfish", "bassRod", "excalibur", "judgement", "billionaire", "gymBait", "jebaiter", "marathon", "quack", "certifiedBait", "baller", "monarch", "frozenOne", "icyFingers", "markOfTheOg", "ogPrime", "finalBoss", "developer"))
            }), t.interface({
                kind = t.literal("error"),
                reason = t.literal("gamepassAlreadyOwned", "bundleAlreadyPurchased", "serverLuckDuplicate", "recipientNotFound", "unknown", "charmAlreadyOwned")
            })),
            requestFreeTestPurchase = t.union(t.interface({
                exclusiveFishReward = t.optional(t.interface({
                    exclusiveIndex = t.number,
                    fishName = t.string,
                    totalStock = t.number
                })),
                kind = t.literal("success"),
                titleReward = t.optional(t.literal("freshBait", "maxedAquarium", "rageBait", "blessedBait", "baitAgain", "hooked", "vip", "devourer", "mjfish", "bassRod", "excalibur", "judgement", "billionaire", "gymBait", "jebaiter", "marathon", "quack", "certifiedBait", "baller", "monarch", "frozenOne", "icyFingers", "markOfTheOg", "ogPrime", "finalBoss", "developer"))
            }), t.interface({
                kind = t.literal("error"),
                reason = t.literal("gamepassAlreadyOwned", "bundleAlreadyPurchased", "serverLuckDuplicate", "recipientNotFound", "unknown", "charmAlreadyOwned")
            }), t.interface({
                kind = t.literal("not_eligible")
            })),
            purchaseAquariumSkin = t.boolean,
            purchaseCelebrationTimeSkip = t.literal("outOfStock", "insufficientFunds", "invalidItem", "purchased"),
            purchaseCelebrationCosmetic = t.literal("insufficientFunds", "invalidItem", "owned", "purchased"),
            purchaseCelebrationAuraReroll = t.literal("insufficientFunds", "invalidItem", "owned", "purchased"),
            purchaseCelebrationTitle = t.literal("insufficientFunds", "invalidItem", "owned", "purchased"),
            purchaseFomoAquariumSkin = t.literal("insufficientFunds", "owned", "purchased"),
            purchaseFomoOrbit = t.literal("outOfStock", "insufficientFunds", "purchased"),
            purchaseFishReelbackVfx = t.boolean,
            purchaseFishingRodSkin = t.boolean,
            purchaseFishingContractLicense = t.boolean,
            purchaseEmote = t.literal("insufficientFunds", "invalidItem", "owned", "purchased"),
            purchaseShopItem = t.boolean,
            rearrangeFishInToolbar = t.boolean,
            registerForCelebrationEvent = t.union(t.number, t.literal(false)),
            rejectGiftRequest = t.boolean,
            requestGiftItem = t.boolean,
            requestLeaderboardEntries = t.interface({
                entries = t.array(t.interface({
                    countryCode = t.optional(t.string),
                    exclusiveIndices = t.optional(t.array(t.number)),
                    playerName = t.string,
                    userId = t.number,
                    value = t.number
                })),
                totalCount = t.number
            }),
            rerollFishingContract = t.boolean,
            reserveExclusiveFishPurchase = t.union(t.interface({
                exclusiveIndex = t.number,
                kind = t.literal("success"),
                remainingStock = t.number,
                totalStock = t.number
            }), t.interface({
                kind = t.literal("error"),
                reason = t.literal("outOfStock", "unknown")
            })),
            rollBaitAura = t.union(t.interface({
                auraName = t.string,
                displayName = t.string,
                rarity = t.literal("common", "uncommon", "rare", "epic", "legendary", "mythic")
            }), t.literal(false)),
            rollZoneGacha = t.union(t.interface({
                displayName = t.string,
                id = t.string,
                rarity = t.literal("common", "uncommon", "rare", "epic", "legendary", "mythic", "godly", "secret", "hacked", "cosmic", "extinct", "kaijuwu", "scifi", "exclusive")
            }), t.literal(false)),
            selectDisplayFish = t.boolean,
            sellFishItems = t.union(t.number, t.literal(false)),
            submitFishingContract = t.union(t.number, t.literal(false)),
            setAudioVolume = t.boolean,
            setCameraShakeEnabled = t.boolean,
            setBossAutokillEnabled = t.boolean,
            purchaseBossAutokillForTesting = t.boolean,
            setEquipmentInToolbar = t.boolean,
            setFishingRodSkin = t.boolean,
            setFishReelbackVfx = t.boolean,
            setHapticsEnabled = t.boolean,
            setPickaxeInToolbar = t.boolean,
            setShowcaseFish = t.boolean,
            skipRebirth = t.boolean,
            slapUsed = t.boolean,
            spinPlaytimeWheel = t.union(t.interface({
                cashAmount = t.optional(t.number),
                fishName = t.optional(t.string),
                replacementTimeSkipSeconds = t.optional(t.number),
                segmentId = t.string,
                skinName = t.optional(t.string),
                titleId = t.optional(t.literal("freshBait", "maxedAquarium", "rageBait", "blessedBait", "baitAgain", "hooked", "vip", "devourer", "mjfish", "bassRod", "excalibur", "judgement", "billionaire", "gymBait", "jebaiter", "marathon", "quack", "certifiedBait", "baller", "monarch", "frozenOne", "icyFingers", "markOfTheOg", "ogPrime", "finalBoss", "developer"))
            }), t.literal(false)),
            submitCatchSticksResult = t.union(t.number, t.literal(false)),
            teleportToCelebrationPlace = t.boolean,
            teleportToMainGame = t.boolean,
            toggleMount = t.boolean,
            trainingSkillcheckBonus = t.union(t.number, t.literal(false)),
            trainingTick = t.union(t.number, t.literal(false)),
            unequipAquariumFish = t.boolean,
            unequipEmote = t.boolean,
            unequipCharm = t.boolean,
            unequipInventoryItem = t.boolean,
            updateTutorialStep = t.none,
            upgradeAquarium = t.boolean,
            verifyDiscordAndClaimMJFish = t.boolean
        },
        namespaceIds = {},
        namespaces = {}
    })
}
