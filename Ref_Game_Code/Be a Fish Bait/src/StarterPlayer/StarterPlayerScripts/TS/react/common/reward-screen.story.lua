-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local useState = react.useState
local storyForScreenGui = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "story", "story-utils").storyForScreenGui
local default = RuntimeLib.import(script, script.Parent.Parent, "utils", "story-provider").default
local default2 = RuntimeLib.import(script, script.Parent, "reward-screen").default
local allFishData = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "data", "fish").allFishData
local getTitleData = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "data", "titles").getTitleData
local images = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "images").images
local rarityColors = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "rarity-utils").rarityColors
local v1 = if #allFishData > 0 then allFishData[1] else nil
local icyFingers = getTitleData("icyFingers")
local t1 = {
    label = "Coin Reward",
    props = {
        rewardText = "1,000 Coins",
        title = "YOU WON!"
    }
}
local t2 = {
    label = "Icon Reward",
    props = {
        rewardRarity = "rare",
        rewardText = "Mystery Bundle",
        title = "RARE REWARD!",
        iconImage = images.coinBundle,
        rewardRayColor = rarityColors.rare
    }
}
local t3 = {
    label = "Duplicate Conversion",
    props = {
        rewardRarity = "rare",
        rewardText = "Soccer Stadium",
        title = "DUPLICATE SKIN!",
        iconImage = images.giftBox,
        rewardRayColor = rarityColors.rare,
        secondaryReward = {
            rewardText = "+1 WILD SHARD",
            title = "DUPLICATE CONVERTED!",
            transitionText = "DUPLICATE → WILD SHARD",
            iconImage = images.universalShard,
            rewardRayColor = Color3.fromRGB(255, 232, 82)
        }
    }
}
local t4 = {
    label = "Fish Reward"
}
local t5 = {
    fish = v1
}

t5.rewardText = if v1 ~= nil then v1.displayName else v1
t5.title = "YOU CAUGHT!"
t4.props = t5

local t6 = {
    label = "Timeskip Reward",
    props = {
        title = "YOU WON!",
        timeSkipReward = {
            cashAmount = 120000,
            minutes = 2
        }
    }
}
local t7 = {
    label = "Title Reward"
}
local t8 = {
    showIcon = false,
    title = "PLAYER TITLE!"
}
local t9 = {}
local v2 = if icyFingers == nil then icyFingers else icyFingers.animatedColor

if v2 == nil then
    local v3 = if icyFingers == nil then icyFingers else icyFingers.color

    t9.color = if v3 == nil then Color3.fromRGB(255, 255, 255) else v3
else
    t9.color = v2
end

local v4 = if icyFingers == nil then icyFingers else icyFingers.displayName

t9.displayName = if v4 == nil then "Icy Fingers" else v4
t9.perkDescription = if icyFingers ~= nil then icyFingers.perkDescription else icyFingers
t8.titleReward = t9
t8.titleRewardTextOnly = true
t7.props = t8

local t10 = {
    t1,
    t2,
    t3,
    t4,
    t6,
    t7
}

local function Story() -- line: 121
    -- upvalues: react (copy), useState (copy), default2 (copy), t10 (copy)
    local v5, v6 = useState(0)
    local v7, v8 = useState(0)
    local v9 = t10[v5 + 1]
    local v10 = react.createElement(default2, {
        uiScale = 1,
        zIndex = 50,
        fish = v9.props.fish,
        iconImage = v9.props.iconImage,
        key = ("%*-%*"):format(v5, v7),
        rewardRarity = v9.props.rewardRarity,
        rewardRayColor = v9.props.rewardRayColor,
        rewardText = v9.props.rewardText,
        secondaryReward = v9.props.secondaryReward,
        showIcon = v9.props.showIcon,
        showWhiteRewardRay = v9.props.rewardRarity ~= nil,
        timeSkipReward = v9.props.timeSkipReward,
        title = v9.props.title,
        titleReward = v9.props.titleReward,
        titleRewardTextOnly = v9.props.titleRewardTextOnly
    })
    local v11 = react.createElement("uilistlayout", {
        FillDirection = "Horizontal",
        HorizontalAlignment = "Center",
        VerticalAlignment = "Center",
        Padding = UDim.new(0.01, 0)
    })
    local v12 = table.create(#t10)

    local function v13(p1, p2) -- line: 151
        -- upvalues: v5 (copy), v6 (copy), v8 (copy), react (copy), t10 (copy)
        local v14 = p2 == v5

        return react.createElement("textbutton", {
            BorderSizePixel = 0,
            TextScaled = true,
            ZIndex = 300,
            BackgroundColor3 = if v14 then Color3.fromRGB(50, 160, 80) else Color3.fromRGB(80, 80, 80),
            Event = {
                MouseButton1Down = function() -- MouseButton1Down | line: 157
                    -- upvalues: p2 (copy), v6 (copy), v8 (copy)
                    v6(p2)
                    v8(function(p3) -- line: 159
                        return p3 + 1
                    end)
                end
            },
            Size = UDim2.fromScale(1 / (#t10 + 1), 1),
            Text = p1.label,
            TextColor3 = Color3.fromRGB(255, 255, 255),
            key = p1.label
        })
    end

    for v15, v16 in t10 do
        v12[v15] = v13(v16, v15 - 1, t10)
    end

    return react.createElement("frame", {
        BackgroundTransparency = 0,
        BorderSizePixel = 0,
        BackgroundColor3 = Color3.new(0.12, 0.12, 0.14),
        Size = UDim2.fromScale(1, 1)
    }, v10, react.createElement("frame", {
        BackgroundTransparency = 1,
        ZIndex = 300,
        AnchorPoint = Vector2.new(0.5, 1),
        Position = UDim2.fromScale(0.5, 0.97),
        Size = UDim2.fromScale(0.88, 0.05)
    }, v11, v12, react.createElement("textbutton", {
        BorderSizePixel = 0,
        Text = "Replay",
        TextScaled = true,
        ZIndex = 300,
        BackgroundColor3 = Color3.fromRGB(60, 110, 200),
        Event = {
            MouseButton1Down = function() -- MouseButton1Down | line: 191
                -- upvalues: v8 (copy)
                return v8(function(p4) -- line: 192
                    return p4 + 1
                end)
            end
        },
        Size = UDim2.fromScale(1 / (#t10 + 1), 1),
        TextColor3 = Color3.fromRGB(255, 255, 255)
    })))
end

return storyForScreenGui(react.createElement(default, nil, react.createElement(Story)))
