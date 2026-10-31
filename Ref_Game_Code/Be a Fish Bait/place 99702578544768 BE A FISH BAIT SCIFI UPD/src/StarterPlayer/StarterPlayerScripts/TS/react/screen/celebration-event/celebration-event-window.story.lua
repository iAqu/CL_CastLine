-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local useState = react.useState
local default = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "transition", "window-transition").default
local default2 = RuntimeLib.import(script, script.Parent.Parent.Parent, "utils", "story-provider").default
local storyForScreenGui = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "story", "story-utils").storyForScreenGui
local default3 = RuntimeLib.import(script, script.Parent, "celebration-event-window").default
local localPlayerUserId = RuntimeLib.import(script, script.Parent.Parent.Parent.Parent, "utils").localPlayerUserId

local function CelebrationEventWindowShowcase() -- line: 13
    -- upvalues: react (copy), useState (copy), default (copy), default3 (copy)
    local v1, v2 = useState(true)
    local v3, v4 = useState(10000)
    local v5, v6 = useState(6E+08)
    local createElement = react.createElement
    local t1 = {
        BackgroundTransparency = 1,
        Size = UDim2.fromScale(1, 1)
    }
    local v7 = not v1

    v7 = v7 and react.createElement("textbutton", {
        BorderSizePixel = 0,
        Font = "Arcade",
        Text = "Open Celebration Event",
        TextScaled = true,
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = Color3.new(0.2, 0.7, 0.3),
        Event = {
            Activated = function() -- Activated | line: 25
                -- upvalues: v2 (copy)
                return v2(true)
            end
        },
        Position = UDim2.fromScale(0.5, 0.5),
        Size = UDim2.fromOffset(220, 50),
        TextColor3 = Color3.new(1, 1, 1)
    }, react.createElement("uicorner", {
        CornerRadius = UDim.new(0.1, 0)
    }))

    return createElement("frame", t1, v7, react.createElement("frame", {
        BackgroundTransparency = 1,
        ZIndex = 1000,
        AnchorPoint = Vector2.new(1, 1),
        Position = UDim2.new(1, -12, 1, -12),
        Size = UDim2.fromOffset(220, 90)
    }, react.createElement("uilistlayout", {
        FillDirection = Enum.FillDirection.Vertical,
        Padding = UDim.new(0, 8),
        SortOrder = Enum.SortOrder.LayoutOrder,
        VerticalAlignment = Enum.VerticalAlignment.Bottom
    }), react.createElement("textbutton", {
        BorderSizePixel = 0,
        Font = "Arcade",
        LayoutOrder = 1,
        Text = "+50 Tickets",
        TextScaled = true,
        ZIndex = 1000,
        BackgroundColor3 = Color3.fromRGB(255, 170, 0),
        Event = {
            Activated = function() -- Activated | line: 52
                -- upvalues: v4 (copy)
                return v4(function(p1) -- line: 53
                    return p1 + 50
                end)
            end
        },
        Size = UDim2.fromOffset(220, 40),
        TextColor3 = Color3.new(1, 1, 1)
    }, react.createElement("uicorner", {
        CornerRadius = UDim.new(0.12, 0)
    })), react.createElement("textbutton", {
        BorderSizePixel = 0,
        Font = "Arcade",
        LayoutOrder = 2,
        Text = "+50M Global Tickets",
        TextScaled = true,
        ZIndex = 1000,
        BackgroundColor3 = Color3.fromRGB(0, 170, 255),
        Event = {
            Activated = function() -- Activated | line: 71
                -- upvalues: v6 (copy)
                return v6(function(p2) -- line: 72
                    return p2 + 5E+07
                end)
            end
        },
        Size = UDim2.fromOffset(220, 40),
        TextColor3 = Color3.new(1, 1, 1)
    }, react.createElement("uicorner", {
        CornerRadius = UDim.new(0.12, 0)
    }))), react.createElement(default, {
        enableCameraEffects = true,
        ["in"] = v1
    }, react.createElement(default3, {
        isCelebrationPlace = true,
        globalTicketCount = v5,
        onClose = function() -- onClose | line: 92
            -- upvalues: v2 (copy)
            return v2(false)
        end,
        onOpenStore = function() -- onOpenStore | line: 95
            return print("Open event store clicked")
        end,
        onTeleport = function() -- onTeleport | line: 98
            return print("Teleport clicked")
        end,
        onViewChallenge = function() -- onViewChallenge | line: 101
            return print("View challenge clicked")
        end,
        ticketCount = v3
    })))
end

return storyForScreenGui(react.createElement(default2, {
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
            fishDisplay = {},
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
            }
        }
    }
}, react.createElement(CelebrationEventWindowShowcase)))
