-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local storyForScreenGui = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "story", "story-utils").storyForScreenGui
local default = RuntimeLib.import(script, script.Parent.Parent.Parent, "utils", "story-provider").default
local localPlayerUserId = RuntimeLib.import(script, script.Parent.Parent.Parent.Parent, "utils").localPlayerUserId
local default2 = RuntimeLib.import(script, script.Parent, "celebration-hud").default

return storyForScreenGui(react.createElement(default, {
    initialState = {
        currentWindow = {
            currentWindow = "none",
            currentShopId = nil,
            openShopPrompt = nil
        },
        playerData = {
            fishingContracts = {},
            materials = {},
            rodSkins = {},
            tutorialTracking = {},
            emotes = {},
            danceFloorAura = {},
            fishReelbackVfx = {},
            hallOfFame = {},
            inventory = {
                [localPlayerUserId] = {}
            },
            metadata = {
                [localPlayerUserId] = {
                    backpackUpgradeCount = 0,
                    bossAutokillEnabled = true,
                    audioSettings = {
                        cameraShakeEnabled = true,
                        hapticsEnabled = true,
                        musicVolume = 0.5,
                        sfxVolume = 0.5
                    },
                    claimedChallengeTierIds = {},
                    eventShopDailyStockDayKey = "",
                    eventShopPurchasesToday = {},
                    hasClaimedCelebrationWelcomeReward = false,
                    hasRegisteredForCelebrationEvent = false,
                    hasSeenCelebrationFarewell = false,
                    hasVisitedCelebrationIsland = false,
                    promptedSocialEventIds = {},
                    userId = localPlayerUserId,
                    isFirstTime = false,
                    timeFirstJoined = 0,
                    timeJoined = 0,
                    timeLastLeft = 0,
                    timeLastSaved = 0,
                    savingServerJobId = "",
                    savedTimeForPlaytimeReward = 0,
                    playtime = 0,
                    dayLastClaimedDailyReward = {
                        dailyRewardIndex = "0",
                        day = 0,
                        month = 0,
                        year = 0
                    },
                    dayLastClaimedCelebrationReward = {
                        dailyRewardIndex = "0",
                        day = 0,
                        month = 0,
                        year = 0
                    },
                    likedCommunityMembers = {},
                    playTimeRewardStartTime = 0,
                    powerBoostBonusMultiplier = 0,
                    recentlyLikedPlots = {},
                    ticketCapProgress = {},
                    totalFishCaught = 0,
                    totalRobuxSpent = 0,
                    spinWheelDayKey = "",
                    spinWheelSavedPlaytime = 0,
                    spinWheelSpinsGrantedToday = 0,
                    spinWheelStartTime = 0,
                    preLogoutBuff = {}
                }
            },
            stats = {
                [localPlayerUserId] = {
                    celebrationObbyRunsCompleted = 0,
                    celebrationReactionSticksCaught = 0,
                    celebrationRglRunsCompleted = 0,
                    highScoreDistance = 0,
                    highScorePosition = nil,
                    bonusChance = 0,
                    lifetimeCasts = 0,
                    money = 12345,
                    power = 2041483,
                    skillcheckSpeedMultiplier = 1,
                    spinWheelSpins = 3,
                    rerolls = 1,
                    tickets = 42
                }
            },
            rewards = {},
            plot = {},
            gamepasses = {
                [localPlayerUserId] = {}
            },
            purchaseHistory = {
                [localPlayerUserId] = {}
            },
            bundlePurchaseHistory = {
                [localPlayerUserId] = {}
            },
            aquarium = {
                [localPlayerUserId] = {
                    aquariumLevel = 1,
                    cratePityCount = 0,
                    universalSkinShards = 0,
                    moneyPerSecond = 0,
                    uncollectedMoney = 0,
                    aquariumUpgradeCompleteTimestamp = nil,
                    aquariumUpgradeStartedTimestamp = nil,
                    equippedSkin = "Default",
                    skinShardBalances = {
                        rare = 0,
                        epic = 0,
                        legendary = 0,
                        mythic = 0
                    },
                    fishItems = {},
                    ownedSkins = { "Default" },
                    pendingCrateReveals = {},
                    resolvedCrateReveals = {},
                    seenSkins = {}
                }
            },
            offlineEarnings = {},
            collectionIndex = {
                [localPlayerUserId] = {
                    discoveredFish = {
                        Salmon = { "Normal" }
                    },
                    seenFishes = {}
                }
            },
            rebirth = {
                [localPlayerUserId] = {
                    rebirthCount = 0,
                    currentBestZone = 0,
                    previousRebirthBestZone = 0
                }
            },
            titles = {
                [localPlayerUserId] = {
                    equippedTitle = nil,
                    seenTitleIds = {},
                    unlockedTitles = {}
                }
            },
            baitAuras = {
                [localPlayerUserId] = {
                    equippedSlotIndex = 0,
                    slots = { "", "", "" },
                    unlockedSlots = { true, false, false }
                }
            },
            charms = {
                [localPlayerUserId] = {
                    equippedCharmId = nil,
                    charmCoresByTier = {},
                    ownedCharmIds = {}
                }
            },
            mounts = {
                [localPlayerUserId] = {
                    activeMountName = nil,
                    isMounted = false,
                    ownedMountNames = {}
                }
            },
            zoneGacha = {
                [localPlayerUserId] = {
                    eyesEquippedBuffId = nil,
                    eyesEquippedSkinId = nil,
                    headEquippedBuffId = nil,
                    headEquippedSkinId = nil,
                    legendaryEquippedBuffId = nil,
                    legendaryEquippedSkinId = nil,
                    tokenA = 0,
                    tokenB = 0,
                    tokenC = 0,
                    ownedItemIds = {}
                }
            },
            fishDisplay = {}
        },
        currentWeathers = {},
        activeSpecialEvents = {
            TicketRain = {
                endTimestamp = os.time() + 45,
                startTimestamp = os.time() - 15
            }
        }
    }
}, react.createElement(default2)))
