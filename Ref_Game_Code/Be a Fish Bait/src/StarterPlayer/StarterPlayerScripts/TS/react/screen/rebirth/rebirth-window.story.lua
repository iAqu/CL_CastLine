-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local useState = react.useState
local default = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "transition", "window-transition").default
local default2 = RuntimeLib.import(script, script.Parent.Parent.Parent, "utils", "story-provider").default
local storyForScreenGui = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "story", "story-utils").storyForScreenGui
local localPlayerUserId = RuntimeLib.import(script, script.Parent.Parent.Parent.Parent, "utils").localPlayerUserId
local getRebirthEntry = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "data", "rebirth-utils").getRebirthEntry
local default3 = RuntimeLib.import(script, script.Parent, "rebirth-window").default

local function RebirthWindowShowcase() -- line: 12
    -- upvalues: react (copy), useState (copy), default (copy), default2 (copy), localPlayerUserId (copy), getRebirthEntry (copy), default3 (copy)
    local v1, v2 = useState(true)
    local v3, v4 = useState(0)
    local v5, v6 = useState(0)
    local v8 = math.floor(getRebirthEntry(v3).powerCost * v5)
    local v9 = ("%*-%*"):format(v3, v8)
    local createElement = react.createElement
    local t1 = {
        BackgroundTransparency = 1,
        Size = UDim2.fromScale(1, 1)
    }
    local v28 = react.createElement("frame", {
        BackgroundTransparency = 0.3,
        BorderSizePixel = 0,
        AnchorPoint = Vector2.new(0, 0),
        BackgroundColor3 = Color3.fromRGB(30, 30, 30),
        Position = UDim2.fromOffset(8, 8),
        Size = UDim2.fromOffset(260, 120)
    }, react.createElement("uicorner", {
        CornerRadius = UDim.new(0, 6)
    }), react.createElement("uilistlayout", {
        FillDirection = Enum.FillDirection.Vertical,
        Padding = UDim.new(0, 6),
        SortOrder = Enum.SortOrder.LayoutOrder,
        VerticalAlignment = Enum.VerticalAlignment.Top
    }), react.createElement("uipadding", {
        PaddingBottom = UDim.new(0, 8),
        PaddingLeft = UDim.new(0, 8),
        PaddingRight = UDim.new(0, 8),
        PaddingTop = UDim.new(0, 8)
    }), react.createElement("frame", {
        BackgroundTransparency = 1,
        LayoutOrder = 1,
        Size = UDim2.fromScale(1, 0)
    }, react.createElement("uilistlayout", {
        FillDirection = Enum.FillDirection.Horizontal,
        Padding = UDim.new(0, 6),
        SortOrder = Enum.SortOrder.LayoutOrder,
        VerticalAlignment = Enum.VerticalAlignment.Center
    }), react.createElement("uisizeconstraint", {
        MaxSize = Vector2.new(1e999, 24)
    }), react.createElement("textlabel", {
        BackgroundTransparency = 1,
        Font = "GothamBold",
        LayoutOrder = 1,
        TextScaled = true,
        Size = UDim2.fromOffset(120, 24),
        Text = ("Rebirth: %*"):format(v3),
        TextColor3 = Color3.new(1, 1, 1),
        TextXAlignment = Enum.TextXAlignment.Left
    }), react.createElement("textbutton", {
        BorderSizePixel = 0,
        Font = "GothamBold",
        LayoutOrder = 2,
        Text = "-",
        TextScaled = true,
        BackgroundColor3 = Color3.fromRGB(80, 80, 200),
        Event = {
            Activated = function() -- Activated | line: 65
                -- upvalues: v3 (copy), v4 (copy)
                return v4((math.max(0, v3 - 1)))
            end
        },
        Size = UDim2.fromOffset(28, 24),
        TextColor3 = Color3.new(1, 1, 1)
    }, react.createElement("uicorner", {
        CornerRadius = UDim.new(0, 4)
    })), react.createElement("textbutton", {
        BorderSizePixel = 0,
        Font = "GothamBold",
        LayoutOrder = 3,
        Text = "+",
        TextScaled = true,
        BackgroundColor3 = Color3.fromRGB(80, 80, 200),
        Event = {
            Activated = function() -- Activated | line: 81
                -- upvalues: v3 (copy), v4 (copy)
                return v4((math.min(9, v3 + 1)))
            end
        },
        Size = UDim2.fromOffset(28, 24),
        TextColor3 = Color3.new(1, 1, 1)
    }, react.createElement("uicorner", {
        CornerRadius = UDim.new(0, 4)
    }))), react.createElement("frame", {
        BackgroundTransparency = 1,
        LayoutOrder = 2,
        Size = UDim2.fromScale(1, 0)
    }, react.createElement("uilistlayout", {
        FillDirection = Enum.FillDirection.Horizontal,
        Padding = UDim.new(0, 6),
        SortOrder = Enum.SortOrder.LayoutOrder,
        VerticalAlignment = Enum.VerticalAlignment.Center
    }), react.createElement("uisizeconstraint", {
        MaxSize = Vector2.new(1e999, 24)
    }), react.createElement("textlabel", {
        BackgroundTransparency = 1,
        Font = "GothamBold",
        LayoutOrder = 1,
        TextScaled = true,
        Size = UDim2.fromOffset(120, 24),
        Text = ("Power: %*"):format(v8),
        TextColor3 = Color3.new(1, 1, 1),
        TextXAlignment = Enum.TextXAlignment.Left
    }), react.createElement("textbutton", {
        BorderSizePixel = 0,
        Font = "GothamBold",
        LayoutOrder = 2,
        Text = "-",
        TextScaled = true,
        BackgroundColor3 = Color3.fromRGB(80, 160, 80),
        Event = {
            Activated = function() -- Activated | line: 117
                -- upvalues: v5 (copy), v6 (copy)
                return v6((math.max(0, v5 - 0.1)))
            end
        },
        Size = UDim2.fromOffset(28, 24),
        TextColor3 = Color3.new(1, 1, 1)
    }, react.createElement("uicorner", {
        CornerRadius = UDim.new(0, 4)
    })), react.createElement("textbutton", {
        BorderSizePixel = 0,
        Font = "GothamBold",
        LayoutOrder = 3,
        Text = "+",
        TextScaled = true,
        BackgroundColor3 = Color3.fromRGB(80, 160, 80),
        Event = {
            Activated = function() -- Activated | line: 133
                -- upvalues: v5 (copy), v6 (copy)
                return v6((math.min(1, v5 + 0.1)))
            end
        },
        Size = UDim2.fromOffset(28, 24),
        TextColor3 = Color3.new(1, 1, 1)
    }, react.createElement("uicorner", {
        CornerRadius = UDim.new(0, 4)
    }))), react.createElement("frame", {
        BackgroundTransparency = 1,
        LayoutOrder = 3,
        Size = UDim2.fromScale(1, 0)
    }, react.createElement("uisizeconstraint", {
        MaxSize = Vector2.new(1e999, 24)
    }), react.createElement("textbutton", {
        BorderSizePixel = 0,
        Font = "GothamBold",
        Text = "Max Power",
        TextScaled = true,
        AnchorPoint = Vector2.new(0, 0),
        BackgroundColor3 = Color3.fromRGB(180, 120, 20),
        Event = {
            Activated = function() -- Activated | line: 156
                -- upvalues: v6 (copy)
                return v6(1)
            end
        },
        Position = UDim2.fromOffset(0, 0),
        Size = UDim2.fromOffset(120, 24),
        TextColor3 = Color3.new(1, 1, 1)
    }, react.createElement("uicorner", {
        CornerRadius = UDim.new(0, 4)
    }))))
    local createElement11 = react.createElement
    local t16 = {
        initialState = {
            playerData = {
                fishingContracts = {},
                materials = {},
                rodSkins = {},
                metadata = {},
                stats = {
                    [localPlayerUserId] = {
                        celebrationObbyRunsCompleted = 0,
                        celebrationReactionSticksCaught = 0,
                        celebrationRglRunsCompleted = 0,
                        highScoreDistance = 0,
                        highScorePosition = nil,
                        bonusChance = 0,
                        lifetimeCasts = 0,
                        money = 0,
                        skillcheckSpeedMultiplier = 1,
                        spinWheelSpins = 3,
                        rerolls = 0,
                        tickets = 0,
                        power = v8
                    }
                },
                inventory = {},
                rewards = {},
                plot = {},
                tutorialTracking = {},
                emotes = {},
                danceFloorAura = {},
                fishReelbackVfx = {},
                hallOfFame = {},
                gamepasses = {},
                purchaseHistory = {},
                bundlePurchaseHistory = {},
                aquarium = {},
                offlineEarnings = {},
                collectionIndex = {},
                rebirth = {
                    [localPlayerUserId] = {
                        currentBestZone = 0,
                        previousRebirthBestZone = 0,
                        rebirthCount = v3
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
        },
        key = v9
    }
    local v29 = not v1

    v29 = v29 and react.createElement("textbutton", {
        BorderSizePixel = 0,
        Font = "Arcade",
        Text = "Open Rebirth",
        TextScaled = true,
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = Color3.fromRGB(180, 50, 50),
        Event = {
            Activated = function() -- Activated | line: 252
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

    return createElement("frame", t1, v28, createElement11(default2, t16, v29, react.createElement(default, {
        enableCameraEffects = true,
        ["in"] = v1
    }, react.createElement(default3, {
        skipRobuxPrice = 99,
        onClose = function() -- onClose | line: 268
            -- upvalues: v2 (copy)
            return v2(false)
        end,
        onRebirth = function() -- onRebirth | line: 271
            return print("Rebirth clicked")
        end,
        onSkipRebirth = function() -- onSkipRebirth | line: 274
            return print("Skip rebirth clicked")
        end
    }))))
end

return storyForScreenGui(react.createElement(RebirthWindowShowcase))
