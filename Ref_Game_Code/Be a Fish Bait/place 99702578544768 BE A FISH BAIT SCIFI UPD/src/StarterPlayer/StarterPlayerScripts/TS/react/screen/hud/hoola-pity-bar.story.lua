-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local useEffect, useState = react.useEffect, react.useState
local Players = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services").Players
local storyForScreenGui = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "story", "story-utils").storyForScreenGui
local default = RuntimeLib.import(script, script.Parent.Parent.Parent, "utils", "story-provider").default
local hookFlightSteeringActiveAtom = RuntimeLib.import(script, script.Parent.Parent.Parent.Parent, "hook-flight-steering-atom").hookFlightSteeringActiveAtom
local v1 = RuntimeLib.import(script, script.Parent.Parent.Parent.Parent, "flight-trigger-gate-score-atoms")
local flightTriggerGatePityScoreAtom, flightTriggerGatePityBaselineReadyAtom, flightTriggerGatePityThresholdAtom, flightTriggerGatePityTierAtom = v1.flightTriggerGatePityScoreAtom, v1.flightTriggerGatePityBaselineReadyAtom, v1.flightTriggerGatePityThresholdAtom, v1.flightTriggerGatePityTierAtom
local flightTriggerGateSurfScoreAtom = v1.flightTriggerGateSurfScoreAtom
local flightTriggerGateComboAtom = RuntimeLib.import(script, script.Parent.Parent.Parent.Parent, "flight-trigger-gate-combo-atom").flightTriggerGateComboAtom
local default2 = RuntimeLib.import(script, script.Parent, "hoola-pity-bar").default
local default3 = RuntimeLib.import(script, script.Parent, "flight-trigger-gate-combo").default
local t1 = {
    "hoola1",
    "hoola2",
    "hoola3"
}
local t2 = {
    0, 1, 3, 4, 6, 7, 10
}
local t3 = {
    fishingState = {
        [tostring(Players.LocalPlayer.UserId)] = {
            castTimestamp = nil,
            caughtFishName = nil,
            fishingState = nil,
            lastCastTimestamp = nil,
            pendingApexFishId = nil,
            pendingCaughtFishId = nil,
            castParams = {
                direction = Vector3.new(0, 0, 0),
                flightTriggerGateEligible = true,
                peakBias = 0,
                peakHeight = 0,
                power = 0,
                startPosition = Vector3.new(0, 0, 0)
            },
            caughtFishMutations = {}
        }
    }
}
local t4 = {
    0, 25, 50, 75, 100
}

local function StoryScene() -- line: 45
    -- upvalues: react (copy), useEffect (copy), useState (copy), hookFlightSteeringActiveAtom (copy), flightTriggerGatePityScoreAtom (copy), flightTriggerGatePityBaselineReadyAtom (copy), flightTriggerGatePityThresholdAtom (copy), flightTriggerGatePityTierAtom (copy), flightTriggerGateSurfScoreAtom (copy), flightTriggerGateComboAtom (copy), default2 (copy), default3 (copy), t1 (copy), t2 (copy), t4 (copy)
    local hoola1, hoola1_2 = useState("hoola1")
    local v2, v3 = useState(50)
    local v4, v5 = useState(0)

    useEffect(function() -- line: 49
        -- upvalues: hookFlightSteeringActiveAtom (copy), flightTriggerGatePityBaselineReadyAtom (copy), flightTriggerGatePityThresholdAtom (copy), flightTriggerGateSurfScoreAtom (copy)
        hookFlightSteeringActiveAtom(true)
        flightTriggerGatePityThresholdAtom(100)
        flightTriggerGateSurfScoreAtom(0)
        flightTriggerGatePityBaselineReadyAtom(true)

        return function() -- line: 54
            -- upvalues: hookFlightSteeringActiveAtom (copy), flightTriggerGatePityBaselineReadyAtom (copy)
            hookFlightSteeringActiveAtom(false)
            flightTriggerGatePityBaselineReadyAtom(false)
        end
    end, {})
    useEffect(function() -- line: 59
        -- upvalues: hoola1 (copy), flightTriggerGatePityTierAtom (copy)
        flightTriggerGatePityTierAtom(hoola1)
    end, { hoola1 })
    useEffect(function() -- line: 62
        -- upvalues: v2 (copy), flightTriggerGatePityScoreAtom (copy)
        flightTriggerGatePityScoreAtom(v2)
    end, { v2 })
    useEffect(function() -- line: 65
        -- upvalues: v4 (copy), flightTriggerGateComboAtom (copy)
        flightTriggerGateComboAtom(v4)

        return function() -- line: 67
            -- upvalues: flightTriggerGateComboAtom (copy)
            flightTriggerGateComboAtom(0)
        end
    end, { v4 })

    local v6 = react.createElement(default2)
    local v7 = react.createElement(default3)
    local v8 = react.createElement("uilistlayout", {
        FillDirection = Enum.FillDirection.Horizontal,
        HorizontalAlignment = Enum.HorizontalAlignment.Center,
        Padding = UDim.new(0, 8),
        SortOrder = Enum.SortOrder.LayoutOrder,
        VerticalAlignment = Enum.VerticalAlignment.Center
    })
    local v9 = table.create(#t1)

    local function v10(p1, p2) -- line: 82
        -- upvalues: hoola1 (copy), hoola1_2 (copy), react (copy)
        return react.createElement("textbutton", {
            BackgroundColor3 = if hoola1 == p1 then Color3.fromRGB(60, 180, 60) else Color3.fromRGB(80, 80, 80),
            Event = {
                MouseButton1Click = function() -- MouseButton1Click | line: 86
                    -- upvalues: p1 (copy), hoola1_2 (copy)
                    return hoola1_2(p1)
                end
            },
            LayoutOrder = p2,
            Size = UDim2.fromOffset(88, 32),
            Text = p1
        })
    end

    for v11, v12 in t1 do
        v9[v11] = v10(v12, v11 - 1, t1)
    end

    local v13 = react.createElement("frame", {
        AnchorPoint = Vector2.new(1, 0),
        BackgroundColor3 = Color3.fromRGB(40, 40, 40),
        Position = UDim2.fromScale(0.98, 0.05),
        Size = UDim2.fromOffset(280, 40)
    }, v8, v9)
    local v14 = react.createElement("uilistlayout", {
        FillDirection = Enum.FillDirection.Horizontal,
        HorizontalAlignment = Enum.HorizontalAlignment.Center,
        Padding = UDim.new(0, 8),
        SortOrder = Enum.SortOrder.LayoutOrder,
        VerticalAlignment = Enum.VerticalAlignment.Center
    })
    local v15 = table.create(#t4)

    local function v16(p3, p4) -- line: 114
        -- upvalues: v2 (copy), v3 (copy), react (copy)
        return react.createElement("textbutton", {
            BackgroundColor3 = if v2 == p3 then Color3.fromRGB(60, 180, 60) else Color3.fromRGB(80, 80, 80),
            Event = {
                MouseButton1Click = function() -- MouseButton1Click | line: 118
                    -- upvalues: p3 (copy), v3 (copy)
                    return v3(p3)
                end
            },
            LayoutOrder = p4,
            Size = UDim2.fromOffset(48, 32),
            Text = ("%*%%"):format(p3)
        })
    end

    for v17, v18 in t4 do
        v15[v17] = v16(v18, v17 - 1, t4)
    end

    local v19 = react.createElement("frame", {
        AnchorPoint = Vector2.new(1, 0),
        BackgroundColor3 = Color3.fromRGB(40, 40, 40),
        Position = UDim2.fromScale(0.98, 0.13),
        Size = UDim2.fromOffset(280, 40)
    }, v14, v15)
    local v20 = react.createElement("uilistlayout", {
        FillDirection = Enum.FillDirection.Horizontal,
        HorizontalAlignment = Enum.HorizontalAlignment.Center,
        Padding = UDim.new(0, 6),
        SortOrder = Enum.SortOrder.LayoutOrder,
        VerticalAlignment = Enum.VerticalAlignment.Center
    })
    local v21 = table.create(#t2)

    local function v22(p5, p6) -- line: 146
        -- upvalues: v4 (copy), v5 (copy), react (copy)
        return react.createElement("textbutton", {
            BackgroundColor3 = if v4 == p5 then Color3.fromRGB(60, 180, 60) else Color3.fromRGB(80, 80, 80),
            Event = {
                MouseButton1Click = function() -- MouseButton1Click | line: 150
                    -- upvalues: p5 (copy), v5 (copy)
                    return v5(p5)
                end
            },
            LayoutOrder = p6,
            Size = UDim2.fromOffset(34, 32),
            Text = tostring(p5)
        })
    end

    for v23, v24 in t2 do
        v21[v23] = v22(v24, v23 - 1, t2)
    end

    return react.createElement(react.Fragment, nil, v6, v7, v13, v19, react.createElement("frame", {
        AnchorPoint = Vector2.new(1, 0),
        BackgroundColor3 = Color3.fromRGB(40, 40, 40),
        Position = UDim2.fromScale(0.98, 0.21),
        Size = UDim2.fromOffset(280, 40)
    }, v20, v21))
end

return storyForScreenGui(react.createElement(default, {
    initialState = t3
}, react.createElement(StoryScene)))
