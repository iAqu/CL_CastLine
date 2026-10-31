-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local useState = react.useState
local storyForScreenGui = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "story", "story-utils").storyForScreenGui
local default = RuntimeLib.import(script, script.Parent.Parent.Parent, "utils", "story-provider").default
local default2 = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "transition", "window-transition").default
local default3 = RuntimeLib.import(script, script.Parent, "community-reward-window").default
local default4 = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "reward-screen").default
local fish = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "data", "fish")
local fishDataByName, isFishData = fish.fishDataByName, fish.isFishData
local v1 = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "community-rewards-utils")
local communityRewardDisplayName = v1.communityRewardDisplayName
local v2 = fishDataByName[v1.communityRewardFishName]

if v2 == nil or not isFishData(v2) then
    v2 = nil
end

local function CommunityRewardShowcase() -- line: 19
    -- upvalues: react (copy), useState (copy), default2 (copy), default3 (copy), default4 (copy), communityRewardDisplayName (copy), v2 (ref)
    local v3, v4 = useState(true)
    local v5, v6 = useState(false)
    local v7, v8 = useState(nil)
    local v9, v10 = useState({
        likeConfirmed = false,
        favoriteConfirmed = false,
        communityJoined = false
    })

    local function v11(p1) -- line: 28
        -- upvalues: v10 (copy)
        v10(function(p2) -- line: 29
            -- upvalues: p1 (copy)
            local v12 = table.clone(p2)

            setmetatable(v12, nil)
            v12[p1] = not p2[p1]

            return v12
        end)
    end

    local function v13(p3) -- line: 36
        if p3 then
            return (Color3.fromRGB(40, 160, 60))
        end

        return (Color3.fromRGB(80, 80, 80))
    end

    local v14 = react.createElement("uilistlayout", {
        FillDirection = Enum.FillDirection.Vertical,
        Padding = UDim.new(0, 6),
        SortOrder = Enum.SortOrder.LayoutOrder
    })
    local t1 = {
        {
            label = "Toggle Window",
            key = nil
        },
        {
            label = "Like ✓",
            key = "likeConfirmed"
        },
        {
            label = "Favorite ✓",
            key = "favoriteConfirmed"
        },
        {
            label = "Community ✓",
            key = "communityJoined"
        },
        {
            label = "Mark Claimed",
            key = nil
        },
        {
            label = "Show Reward",
            key = nil
        }
    }
    local v15 = table.create(#t1)

    local function v16(p4, p5) -- line: 65
        -- upvalues: v4 (copy), v6 (copy), v8 (copy), v9 (copy), v10 (copy), react (copy)
        return react.createElement("textbutton", {
            BorderSizePixel = 0,
            TextScaled = true,
            BackgroundColor3 = if p4.key == nil then Color3.fromRGB(40, 100, 200) elseif v9[p4.key] then Color3.fromRGB(40, 160, 60) else Color3.fromRGB(80, 80, 80),
            Event = {
                Activated = function() -- Activated | line: 70
                    -- upvalues: p4 (copy), v4 (copy), v6 (copy), v8 (copy), v10 (copy)
                    if p4.key ~= nil then
                        local key = p4.key

                        v10(function(p9) -- line: 29
                            -- upvalues: key (copy)
                            local v17 = table.clone(p9)

                            setmetatable(v17, nil)
                            v17[key] = not p9[key]

                            return v17
                        end)
                    elseif p4.label == "Toggle Window" then
                        v4(function(p6) -- line: 74
                            return not p6
                        end)
                    elseif p4.label == "Show Reward" then
                        v8(function(p7) -- line: 78
                            return (if p7 == nil then 0 else p7) + 1
                        end)
                    else
                        v6(function(p8) -- line: 86
                            return not p8
                        end)
                    end
                end
            },
            Font = Enum.Font.GothamBold,
            LayoutOrder = p5,
            Size = UDim2.fromOffset(210, 34),
            Text = p4.label,
            TextColor3 = Color3.new(1, 1, 1),
            key = tostring(p5)
        }, react.createElement("uicorner", {
            CornerRadius = UDim.new(0.12, 0)
        }))
    end

    for v18, v19 in t1 do
        v15[v18] = v16(v19, v18 - 1, t1)
    end

    return react.createElement("frame", {
        BackgroundTransparency = 1,
        Size = UDim2.fromScale(1, 1)
    }, react.createElement("frame", {
        BackgroundTransparency = 1,
        AnchorPoint = Vector2.new(0, 0),
        Position = UDim2.fromOffset(12, 12),
        Size = UDim2.fromOffset(220, 200)
    }, v14, v15), react.createElement(default2, {
        enableCameraEffects = false,
        ["in"] = v3
    }, react.createElement(default3, {
        isExpired = false,
        isClaimed = v5,
        onClaim = function() -- onClaim | line: 121
            -- upvalues: v6 (copy), v8 (copy)
            print("[Story] Claim clicked")
            v6(true)
            v8(function(p10) -- line: 124
                return (if p10 == nil then 0 else p10) + 1
            end)
        end,
        onClose = function() -- onClose | line: 132
            -- upvalues: v4 (copy)
            return v4(false)
        end,
        onConfirmFavorite = function() -- onConfirmFavorite | line: 135
            -- upvalues: v11 (copy)
            return v11("favoriteConfirmed")
        end,
        onConfirmLike = function() -- onConfirmLike | line: 138
            -- upvalues: v11 (copy)
            return v11("likeConfirmed")
        end,
        onJoinCommunity = function() -- onJoinCommunity | line: 141
            -- upvalues: v11 (copy)
            return v11("communityJoined")
        end,
        taskState = v9
    })), v7 ~= nil and react.createElement(default4, {
        title = "YOU UNLOCKED!",
        uiScale = 1,
        zIndex = 200,
        fish = v2,
        key = ("reward-%*"):format(v7),
        rewardText = if v2 == nil then communityRewardDisplayName else nil
    }))
end

return storyForScreenGui(react.createElement(default, nil, react.createElement(CommunityRewardShowcase)))
