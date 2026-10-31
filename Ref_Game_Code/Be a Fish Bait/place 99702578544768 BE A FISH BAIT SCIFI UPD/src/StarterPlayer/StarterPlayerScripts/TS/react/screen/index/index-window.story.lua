-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local useState = react.useState
local default = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "transition", "window-transition").default
local default2 = RuntimeLib.import(script, script.Parent.Parent.Parent, "utils", "story-provider").default
local localPlayerUserId = RuntimeLib.import(script, script.Parent.Parent.Parent.Parent, "utils").localPlayerUserId
local storyForScreenGui = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "story", "story-utils").storyForScreenGui
local default3 = RuntimeLib.import(script, script.Parent, "index-window").default
local indexRewardMilestones = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "index-rewards-utils").indexRewardMilestones
local t1 = {
    discoveredFish = {
        FishFlops = { "Normal", "Gold", "hoola1", "hoola2", "hoola3" },
        Catfish = { "Normal", "Gold", "Diamond", "hoola3" },
        CardboardEel = { "Normal", "Glitched", "hoola1" }
    },
    seenFishes = {}
}
local t2 = {
    playerData = {
        fishingContracts = {},
        collectionIndex = {
            [localPlayerUserId] = t1
        },
        titles = {
            [localPlayerUserId] = {
                equippedTitle = "quack",
                unlockedTitles = { "quack", "rageBait", "billionaire" }
            }
        }
    }
}

local function IndexShowcase() -- line: 34
    -- upvalues: react (copy), useState (copy), default (copy), default3 (copy), indexRewardMilestones (copy)
    local v1, v2 = useState(true)
    local v3, v4 = useState(false)
    local v5, v6 = useState(0)
    local v7, v8 = useState({})
    local t3 = {
        label = "Default",
        discovered = 3,
        total = 50,
        claimed = {}
    }
    local t4 = {
        label = "Claim 25%",
        discovered = 13,
        total = 50,
        claimed = {}
    }
    local t5 = {
        label = "Claim 50%",
        discovered = 25,
        total = 50,
        claimed = { indexRewardMilestones[1].rewardId }
    }
    local t6 = {
        label = "Claim 75%",
        discovered = 38,
        total = 50,
        claimed = {
            indexRewardMilestones[1].rewardId,
            indexRewardMilestones[2].rewardId
        }
    }
    local t7 = {
        label = "Claim 100%",
        discovered = 50,
        total = 50,
        claimed = {
            indexRewardMilestones[1].rewardId,
            indexRewardMilestones[2].rewardId,
            indexRewardMilestones[3].rewardId
        }
    }
    local t8 = {
        label = "Claimed All",
        discovered = 50,
        total = 50
    }
    local v9 = table.create(#indexRewardMilestones)

    local function v10(p1) -- line: 77
        return p1.rewardId
    end

    for v11, v12 in indexRewardMilestones do
        local _ = v11 - 1

        v9[v11] = v12.rewardId
    end

    t8.claimed = v9

    local t9 = {
        t3,
        t4,
        t5,
        t6,
        t7,
        t8
    }
    local v13 = t9[v5 + 1]
    local t10 = {}

    for _, v14 in v13.claimed do
        t10[v14] = true
    end

    for v15 in v7 do
        t10[v15] = true
    end

    local function v16() -- line: 94
        -- upvalues: v6 (copy), v8 (copy), t9 (copy)
        v6(function(p2) -- line: 95
            -- upvalues: t9 (copy)
            return (p2 + 1) % #t9
        end)
        v8({})
    end

    local function v17(p3) -- line: 100
        -- upvalues: v8 (copy)
        v8(function(p4) -- line: 101
            -- upvalues: p3 (copy)
            local t11 = {}

            for v18 in p4 do
                t11[v18] = true
            end

            t11[p3.rewardId] = true

            return t11
        end)

        return true
    end

    local createElement = react.createElement
    local t12 = {
        BackgroundTransparency = 1,
        Size = UDim2.fromScale(1, 1)
    }
    local v21 = react.createElement("frame", {
        ZIndex = 100,
        AnchorPoint = Vector2.new(0.5, 0),
        Position = UDim2.fromScale(0.5, 0.04),
        Size = UDim2.fromOffset(540, 46)
    }, react.createElement("uilistlayout", {
        FillDirection = Enum.FillDirection.Horizontal,
        HorizontalAlignment = Enum.HorizontalAlignment.Center,
        Padding = UDim.new(0, 12),
        SortOrder = Enum.SortOrder.LayoutOrder,
        VerticalAlignment = Enum.VerticalAlignment.Center
    }), react.createElement("textbutton", {
        BorderSizePixel = 0,
        Font = "Arcade",
        TextScaled = true,
        ZIndex = 100,
        BackgroundColor3 = Color3.fromRGB(45, 45, 55),
        Event = {
            Activated = v16
        },
        Size = UDim2.fromOffset(300, 46),
        Text = ("%* (%*/%*)"):format(v13.label, v13.discovered, v13.total),
        TextColor3 = Color3.new(1, 1, 1)
    }, react.createElement("uicorner", {
        CornerRadius = UDim.new(0.12, 0)
    }), react.createElement("uistroke", {
        Thickness = 2,
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
        Color = Color3.fromRGB(0, 0, 0)
    })), react.createElement("textbutton", {
        BorderSizePixel = 0,
        Font = "Arcade",
        TextScaled = true,
        ZIndex = 100,
        BackgroundColor3 = if v3 then Color3.fromRGB(215, 55, 55) else Color3.fromRGB(45, 45, 55),
        Event = {
            Activated = function() -- Activated | line: 148
                -- upvalues: v4 (copy)
                return v4(function(p5) -- line: 149
                    return not p5
                end)
            end
        },
        Size = UDim2.fromOffset(190, 46),
        Text = v3 and "Title Badge" or "No Title Badge",
        TextColor3 = Color3.new(1, 1, 1)
    }, react.createElement("uicorner", {
        CornerRadius = UDim.new(0.12, 0)
    }), react.createElement("uistroke", {
        Thickness = 2,
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
        Color = Color3.fromRGB(0, 0, 0)
    })))
    local v22 = not v1

    v22 = v22 and react.createElement("textbutton", {
        BorderSizePixel = 0,
        Font = "Arcade",
        Text = "Open Index",
        TextScaled = true,
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = Color3.fromRGB(45, 165, 245),
        Event = {
            Activated = function() -- Activated | line: 171
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

    return createElement("frame", t12, v21, v22, react.createElement(default, {
        enableCameraEffects = true,
        ["in"] = v1
    }, react.createElement(default3, {
        onClose = function() -- onClose | line: 187
            -- upvalues: v2 (copy)
            return v2(false)
        end,
        previewClaimIndexReward = v17,
        previewDiscoveredFishCount = v13.discovered,
        previewHasNewTitlesBadge = v3,
        previewRewards = t10,
        previewTotalFishCount = v13.total
    })))
end

return storyForScreenGui(react.createElement(default2, {
    initialState = t2
}, react.createElement(IndexShowcase)))
