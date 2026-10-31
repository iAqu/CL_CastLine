-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local useState = react.useState
local default = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "transition", "window-transition").default
local default2 = RuntimeLib.import(script, script.Parent.Parent.Parent, "utils", "story-provider").default
local localPlayerUserId = RuntimeLib.import(script, script.Parent.Parent.Parent.Parent, "utils").localPlayerUserId
local storyForScreenGui = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "story", "story-utils").storyForScreenGui
local default3 = RuntimeLib.import(script, script.Parent, "set-power-modal").default

local function SetPowerModalShowcase() -- line: 11
    -- upvalues: react (copy), useState (copy), default (copy), default3 (copy)
    local v1, v2 = useState(true)
    local v3, v4 = useState(1000)

    return react.createElement("frame", {
        BackgroundTransparency = 1,
        Size = UDim2.fromScale(1, 1)
    }, react.createElement("frame", {
        BackgroundTransparency = 0.3,
        BorderSizePixel = 0,
        AnchorPoint = Vector2.new(0, 0),
        BackgroundColor3 = Color3.fromRGB(30, 30, 30),
        Position = UDim2.fromOffset(12, 12),
        Size = UDim2.fromOffset(300, 94)
    }, react.createElement("uicorner", {
        CornerRadius = UDim.new(0, 6)
    }), react.createElement("uilistlayout", {
        FillDirection = Enum.FillDirection.Vertical,
        Padding = UDim.new(0, 8),
        SortOrder = Enum.SortOrder.LayoutOrder,
        VerticalAlignment = Enum.VerticalAlignment.Top
    }), react.createElement("uipadding", {
        PaddingBottom = UDim.new(0, 8),
        PaddingLeft = UDim.new(0, 8),
        PaddingRight = UDim.new(0, 8),
        PaddingTop = UDim.new(0, 8)
    }), react.createElement("textbutton", {
        BorderSizePixel = 0,
        Font = "Arcade",
        LayoutOrder = 1,
        TextScaled = true,
        BackgroundColor3 = if v1 then Color3.fromRGB(180, 60, 60) else Color3.fromRGB(60, 140, 80),
        Event = {
            Activated = function() -- Activated | line: 40
                -- upvalues: v2 (copy)
                return v2(function(p1) -- line: 41
                    return not p1
                end)
            end
        },
        Size = UDim2.fromOffset(150, 34),
        Text = v1 and "Close Modal" or "Open Modal",
        TextColor3 = Color3.new(1, 1, 1)
    }, react.createElement("uicorner", {
        CornerRadius = UDim.new(0.15, 0)
    })), react.createElement("frame", {
        BackgroundTransparency = 1,
        LayoutOrder = 2,
        Size = UDim2.fromOffset(284, 34)
    }, react.createElement("uilistlayout", {
        FillDirection = Enum.FillDirection.Horizontal,
        Padding = UDim.new(0, 8),
        SortOrder = Enum.SortOrder.LayoutOrder,
        VerticalAlignment = Enum.VerticalAlignment.Center
    }), react.createElement("textlabel", {
        BackgroundTransparency = 1,
        Font = "GothamBold",
        LayoutOrder = 1,
        TextScaled = true,
        Size = UDim2.fromOffset(140, 34),
        Text = ("Max: %*"):format(v3),
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
            Activated = function() -- Activated | line: 76
                -- upvalues: v3 (copy), v4 (copy)
                return v4((math.max(100, v3 - 500)))
            end
        },
        Size = UDim2.fromOffset(34, 30),
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
            Activated = function() -- Activated | line: 92
                -- upvalues: v3 (copy), v4 (copy)
                return v4(v3 + 500)
            end
        },
        Size = UDim2.fromOffset(34, 30),
        TextColor3 = Color3.new(1, 1, 1)
    }, react.createElement("uicorner", {
        CornerRadius = UDim.new(0, 4)
    })))), react.createElement(default, {
        enableCameraEffects = false,
        ["in"] = v1
    }, react.createElement(default3, {
        maxPower = v3,
        onClose = function() -- onClose | line: 109
            -- upvalues: v2 (copy)
            return v2(false)
        end
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
            inventory = {},
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
                    power = 1000,
                    skillcheckSpeedMultiplier = 1,
                    spinWheelSpins = 0,
                    rerolls = 0,
                    tickets = 0
                }
            },
            rewards = {},
            plot = {},
            gamepasses = {},
            purchaseHistory = {},
            bundlePurchaseHistory = {},
            aquarium = {},
            offlineEarnings = {},
            collectionIndex = {},
            rebirth = {},
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
}, react.createElement(SetPowerModalShowcase)))
