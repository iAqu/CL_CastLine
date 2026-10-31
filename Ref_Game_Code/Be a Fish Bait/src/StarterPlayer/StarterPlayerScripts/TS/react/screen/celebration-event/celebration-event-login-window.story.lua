-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local useState = react.useState
local storyForScreenGui = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "story", "story-utils").storyForScreenGui
local default = RuntimeLib.import(script, script.Parent.Parent.Parent, "utils", "story-provider").default
local default2 = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "transition", "window-transition").default
local default3 = RuntimeLib.import(script, script.Parent, "celebration-event-login-window").default
local localPlayerUserId = RuntimeLib.import(script, script.Parent.Parent.Parent.Parent, "utils").localPlayerUserId
local celebrationRewardLoopStartDay = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "celebration-reward-utils").celebrationRewardLoopStartDay
local t1 = {
    ["celebration-1"] = true
}

local function CelebrationEventLoginShowcase() -- line: 16
    -- upvalues: react (copy), useState (copy), default2 (copy), default3 (copy), celebrationRewardLoopStartDay (copy), t1 (copy)
    local v1, v2 = useState(true)
    local v3, v4 = useState(2)
    local createElement = react.createElement
    local t2 = {
        BackgroundTransparency = 1,
        Size = UDim2.fromScale(1, 1)
    }
    local v5 = not v1

    v5 = v5 and react.createElement("textbutton", {
        BorderSizePixel = 0,
        Font = "Arcade",
        Text = "Open Daily Login",
        TextScaled = true,
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = Color3.fromRGB(40, 100, 200),
        Event = {
            Activated = function() -- Activated | line: 27
                -- upvalues: v2 (copy)
                return v2(true)
            end
        },
        Position = UDim2.fromScale(0.5, 0.5),
        Size = UDim2.fromOffset(260, 50),
        TextColor3 = Color3.new(1, 1, 1)
    }, react.createElement("uicorner", {
        CornerRadius = UDim.new(0.1, 0)
    }))

    return createElement("frame", t2, v5, react.createElement("frame", {
        BackgroundTransparency = 1,
        ZIndex = 10,
        AnchorPoint = Vector2.new(0, 0),
        Position = UDim2.fromOffset(12, 12),
        Size = UDim2.fromOffset(360, 44)
    }, react.createElement("uilistlayout", {
        FillDirection = Enum.FillDirection.Horizontal,
        Padding = UDim.new(0, 8),
        SortOrder = Enum.SortOrder.LayoutOrder,
        VerticalAlignment = Enum.VerticalAlignment.Center
    }), react.createElement("textbutton", {
        BorderSizePixel = 0,
        Font = "Arcade",
        LayoutOrder = 1,
        Text = "Story: Day 1-7",
        TextScaled = true,
        BackgroundColor3 = if v3 < celebrationRewardLoopStartDay then Color3.fromRGB(255, 170, 40) else Color3.fromRGB(70, 70, 80),
        Event = {
            Activated = function() -- Activated | line: 54
                -- upvalues: v4 (copy)
                return v4(2)
            end
        },
        Size = UDim2.fromOffset(170, 44),
        TextColor3 = Color3.new(1, 1, 1)
    }, react.createElement("uicorner", {
        CornerRadius = UDim.new(0.15, 0)
    })), react.createElement("textbutton", {
        BorderSizePixel = 0,
        Font = "Arcade",
        LayoutOrder = 2,
        Text = "Story: Day 8-14",
        TextScaled = true,
        BackgroundColor3 = if celebrationRewardLoopStartDay <= v3 then Color3.fromRGB(255, 170, 40) else Color3.fromRGB(70, 70, 80),
        Event = {
            Activated = function() -- Activated | line: 70
                -- upvalues: v4 (copy), celebrationRewardLoopStartDay (copy)
                return v4(celebrationRewardLoopStartDay)
            end
        },
        Size = UDim2.fromOffset(170, 44),
        TextColor3 = Color3.new(1, 1, 1)
    }, react.createElement("uicorner", {
        CornerRadius = UDim.new(0.15, 0)
    }))), react.createElement(default2, {
        enableCameraEffects = false,
        ["in"] = v1
    }, react.createElement(default3, {
        canClaim = true,
        claimableDayIndex = v3,
        claimedRewards = t1,
        onClaim = function(p1) -- onClaim | line: 89
            return print((("Claim clicked: day %*"):format(p1)))
        end,
        onClose = function() -- onClose | line: 92
            -- upvalues: v2 (copy)
            return v2(false)
        end
    })))
end

return storyForScreenGui(react.createElement(default, {
    initialState = {
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
            metadata = {},
            stats = {},
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
                    moneyPerSecond = 5000,
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
                    discoveredFish = {},
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
            titles = {},
            baitAuras = {},
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
        }
    }
}, react.createElement(CelebrationEventLoginShowcase)))
