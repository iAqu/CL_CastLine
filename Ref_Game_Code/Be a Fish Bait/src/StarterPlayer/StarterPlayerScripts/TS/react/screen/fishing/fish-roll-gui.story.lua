-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local useState = react.useState
local storyForScreenGui = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "story", "story-utils").storyForScreenGui
local default = RuntimeLib.import(script, script.Parent.Parent.Parent, "utils", "story-provider").default
local default2 = RuntimeLib.import(script, script.Parent, "fish-roll-gui").default
local allFishData = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "data", "fish").allFishData
local Workspace = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services").Workspace

if #allFishData > 3 then
    allFishData = {
        allFishData[1],
        allFishData[2],
        allFishData[3]
    }
end

local t5 = {
    {
        label = "Reset",
        enabled = function() -- enabled | line: 14
            return true
        end,
        onPress = function(p1) -- onPress | line: 17
            return p1({
                bonusComboCount = 0,
                caughtFish = nil,
                apexCaught = false
            })
        end
    },
    {
        label = "Bonus +1",
        enabled = function(p2) -- enabled | line: 26
            if p2.bonusComboCount < 3 then
                return p2.caughtFish == nil
            end

            return false
        end,
        onPress = function(p3) -- onPress | line: 29
            return p3(function(p4) -- line: 30
                local v1 = table.clone(p4)

                setmetatable(v1, nil)
                v1.bonusComboCount = p4.bonusComboCount + 1

                return v1
            end)
        end
    },
    {
        label = "Apex",
        enabled = function(p5) -- enabled | line: 39
            if p5.bonusComboCount >= 3 then
                return not p5.apexCaught and p5.caughtFish == nil
            end

            return false
        end,
        onPress = function(p6) -- onPress | line: 42
            return p6(function(p7) -- line: 43
                local v2 = table.clone(p7)

                setmetatable(v2, nil)
                v2.apexCaught = true

                return v2
            end)
        end
    },
    {
        label = "Fish Caught",
        enabled = function(p8) -- enabled | line: 52
            return p8.caughtFish == nil
        end,
        onPress = function(p9) -- onPress | line: 55
            -- upvalues: allFishData (ref)
            return p9(function(p10) -- line: 56
                -- upvalues: allFishData (ref)
                local v3 = table.clone(p10)

                setmetatable(v3, nil)
                v3.caughtFish = allFishData[1]

                return v3
            end)
        end
    }
}

local function Story() -- line: 64
    -- upvalues: react (copy), useState (copy), default2 (copy), allFishData (ref), Workspace (copy), t5 (copy)
    local v4, v5 = useState({
        bonusComboCount = 0,
        caughtFish = nil,
        apexCaught = false
    })
    local v6 = Workspace:GetServerTimeNow() + 5
    local v7 = react.createElement(default2, {
        bonusComboCount = v4.bonusComboCount,
        caughtFish = v4.caughtFish,
        nibbleExpireTimestamp = v6,
        nibblingFish = allFishData
    })
    local v8 = react.createElement("uilistlayout", {
        FillDirection = "Horizontal",
        HorizontalAlignment = "Center",
        VerticalAlignment = "Center",
        Padding = UDim.new(0.01, 0)
    })
    local v9 = table.create(#t5)

    local function v10(p11) -- line: 86
        -- upvalues: v4 (copy), v5 (copy), react (copy)
        local v11 = p11.enabled(v4)

        return react.createElement("textbutton", {
            BorderSizePixel = 0,
            TextScaled = true,
            BackgroundColor3 = if v11 then Color3.fromRGB(50, 160, 80) else Color3.fromRGB(80, 80, 80),
            Event = {
                MouseButton1Down = if v11 then function() -- line: 92
                    -- upvalues: p11 (copy), v5 (copy)
                    return p11.onPress(v5)
                end else function() -- line: 94
                end
            },
            Size = UDim2.fromScale(0.25, 1),
            Text = p11.label,
            TextColor3 = if v11 then Color3.fromRGB(255, 255, 255) else Color3.fromRGB(150, 150, 150),
            key = p11.label
        })
    end

    for v12, v13 in t5 do
        v9[v12] = v10(v13, v12 - 1, t5)
    end

    return react.createElement("frame", {
        BackgroundTransparency = 1,
        Size = UDim2.fromScale(1, 1)
    }, v7, react.createElement("frame", {
        BackgroundTransparency = 1,
        AnchorPoint = Vector2.new(0.5, 1),
        Position = UDim2.fromScale(0.5, 0.97),
        Size = UDim2.fromScale(0.88, 0.04)
    }, v8, v9))
end

return storyForScreenGui(react.createElement(default, nil, react.createElement(Story)))
