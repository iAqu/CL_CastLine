-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local useState = react.useState
local HttpService = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services").HttpService
local default = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "transition", "window-transition").default
local default2 = RuntimeLib.import(script, script.Parent.Parent.Parent, "utils", "story-provider").default
local localPlayerUserId = RuntimeLib.import(script, script.Parent.Parent.Parent.Parent, "utils").localPlayerUserId
local storyForScreenGui = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "story", "story-utils").storyForScreenGui
local default3 = RuntimeLib.import(script, script.Parent, "sell-fish-window").default
local t1 = {
    {
        name = "FishFlops",
        level = 1,
        mutations = {}
    },
    {
        name = "Catfish",
        level = 3,
        mutations = {}
    },
    {
        name = "Dolphin",
        level = 5,
        mutations = { "Gold" }
    },
    {
        name = "Blade",
        level = 8,
        mutations = {}
    },
    {
        name = "Berrypla",
        level = 10,
        mutations = { "Diamond" }
    },
    {
        name = "Berrywhal",
        level = 12,
        mutations = {}
    },
    {
        name = "FrostTooth",
        level = 15,
        mutations = { "Plasma" }
    },
    {
        name = "AbyssWhale",
        level = 20,
        mutations = {}
    },
    {
        name = "DevilFlare",
        level = 25,
        mutations = { "Molten" }
    }
}
local t2 = {}

for i = 0, #t1 - 1 do
    local v1 = t1[i + 1]
    local v2 = HttpService:GenerateGUID(false)

    t2[v2] = {
        isEquipped = false,
        itemType = "fish",
        fishObtainedTimestamp = i,
        itemId = v2,
        itemName = v1.name,
        level = v1.level,
        mutations = v1.mutations,
        timeStampAdded = i
    }
end

local function SellFishShowcase() -- line: 65
    -- upvalues: react (copy), useState (copy), default (copy), default3 (copy)
    local v3, v4 = useState(true)
    local createElement = react.createElement
    local t3 = {
        BackgroundTransparency = 1,
        Size = UDim2.fromScale(1, 1)
    }
    local v5 = not v3

    v5 = v5 and react.createElement("textbutton", {
        BorderSizePixel = 0,
        Font = "Arcade",
        Text = "Open Sell Fish",
        TextScaled = true,
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = Color3.fromRGB(200, 40, 80),
        Event = {
            Activated = function() -- Activated | line: 75
                -- upvalues: v4 (copy)
                return v4(true)
            end
        },
        Position = UDim2.fromScale(0.5, 0.5),
        Size = UDim2.fromOffset(220, 50),
        TextColor3 = Color3.new(1, 1, 1)
    }, react.createElement("uicorner", {
        CornerRadius = UDim.new(0.1, 0)
    }))

    return createElement("frame", t3, v5, react.createElement(default, {
        enableCameraEffects = false,
        ["in"] = v3
    }, react.createElement(default3, {
        onClose = function() -- onClose | line: 91
            -- upvalues: v4 (copy)
            return v4(false)
        end
    })))
end

return storyForScreenGui(react.createElement(default2, {
    initialState = {
        playerData = {
            fishingContracts = {},
            materials = {},
            rodSkins = {},
            aquarium = {},
            bundlePurchaseHistory = {},
            collectionIndex = {},
            gamepasses = {},
            inventory = {
                [localPlayerUserId] = t2
            },
            metadata = {},
            offlineEarnings = {},
            plot = {},
            purchaseHistory = {},
            rebirth = {},
            titles = {},
            rewards = {},
            stats = {},
            tutorialTracking = {},
            emotes = {},
            danceFloorAura = {},
            fishReelbackVfx = {},
            hallOfFame = {},
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
}, react.createElement(SellFishShowcase)))
