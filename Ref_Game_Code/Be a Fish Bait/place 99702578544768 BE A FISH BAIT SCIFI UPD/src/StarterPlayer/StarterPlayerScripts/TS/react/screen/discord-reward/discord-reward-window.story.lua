-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local useState = react.useState
local storyForScreenGui = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "story", "story-utils").storyForScreenGui
local default = RuntimeLib.import(script, script.Parent.Parent.Parent, "utils", "story-provider").default
local default2 = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "transition", "window-transition").default
local default3 = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "reward-screen").default
local default4 = RuntimeLib.import(script, script.Parent, "discord-reward-window").default
local fish = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "data", "fish")
local fishDataByName, isFishData = fish.fishDataByName, fish.isFishData
local v1 = fishDataByName[RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "community-rewards-utils").discordRewardFishName]

if v1 == nil or not isFishData(v1) then
    v1 = nil
end

local function DiscordRewardShowcase() -- line: 18
    -- upvalues: react (copy), useState (copy), default2 (copy), default3 (copy), default4 (copy), v1 (ref)
    local v2, v3 = useState(true)
    local v4, v5 = useState(false)
    local v6, v7 = useState(false)
    local v8, v9 = useState(0)

    local function v10() -- line: 23
        -- upvalues: v7 (copy), v9 (copy)
        v7(true)
        v9(function(p1) -- line: 25
            return p1 + 1
        end)
        task.delay(4.5, function() -- line: 28
            -- upvalues: v7 (copy)
            return v7(false)
        end)
    end

    local v11 = react.createElement("uilistlayout", {
        FillDirection = Enum.FillDirection.Vertical,
        Padding = UDim.new(0, 6),
        SortOrder = Enum.SortOrder.LayoutOrder
    })
    local t1 = {
        {
            label = "Toggle Window"
        },
        {
            label = "Toggle Claimed"
        },
        {
            label = "Show Reward Screen"
        }
    }
    local v12 = table.create(#t1)

    local function v13(p2, p3) -- line: 46
        -- upvalues: v3 (copy), v5 (copy), v10 (copy), react (copy)
        return react.createElement("textbutton", {
            BorderSizePixel = 0,
            TextScaled = true,
            BackgroundColor3 = Color3.fromRGB(40, 100, 200),
            Event = {
                Activated = function() -- Activated | line: 51
                    -- upvalues: p2 (copy), v3 (copy), v5 (copy), v10 (copy)
                    if p2.label == "Toggle Window" then
                        v3(function(p4) -- line: 53
                            return not p4
                        end)
                    elseif p2.label == "Toggle Claimed" then
                        v5(function(p5) -- line: 57
                            return not p5
                        end)
                    else
                        v10()
                    end
                end
            },
            Font = Enum.Font.GothamBold,
            LayoutOrder = p3,
            Size = UDim2.fromOffset(190, 34),
            Text = p2.label,
            TextColor3 = Color3.new(1, 1, 1),
            key = tostring(p3)
        }, react.createElement("uicorner", {
            CornerRadius = UDim.new(0.12, 0)
        }))
    end

    for v14, v15 in t1 do
        v12[v14] = v13(v15, v14 - 1, t1)
    end

    return react.createElement("frame", {
        BackgroundTransparency = 1,
        Size = UDim2.fromScale(1, 1)
    }, react.createElement("frame", {
        BackgroundTransparency = 1,
        AnchorPoint = Vector2.new(0, 0),
        Position = UDim2.fromOffset(12, 12),
        Size = UDim2.fromOffset(200, 130)
    }, v11, v12), react.createElement(default2, {
        enableCameraEffects = false,
        ["in"] = v2
    }, react.createElement(default4, {
        isClaimed = v4,
        onClose = function() -- onClose | line: 93
            -- upvalues: v3 (copy)
            return v3(false)
        end,
        onVerify = function(p6) -- onVerify | line: 96
            -- upvalues: v5 (copy), v10 (copy)
            print((("[Story] Verify clicked with username: %*"):format(p6)))
            v5(true)
            v10()
        end
    })), v6 and react.createElement(default3, {
        title = "YOU UNLOCKED!",
        uiScale = 1,
        zIndex = 200,
        fish = v1,
        key = tostring(v8)
    }))
end

return storyForScreenGui(react.createElement(default, nil, react.createElement(DiscordRewardShowcase)))
