-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local useEffect, useRef, useState = react.useEffect, react.useRef, react.useState
local storyForScreenGui = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "story", "story-utils").storyForScreenGui
local default = RuntimeLib.import(script, script.Parent.Parent.Parent, "utils", "story-provider").default
local subscribe = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "charm").subscribe
local RunService = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services").RunService
local default2 = RuntimeLib.import(script, script.Parent, "training-skillcheck").default
local default3 = RuntimeLib.import(script, script.Parent, "training-boost-bar").default
local PowerFlyItem = RuntimeLib.import(script, script.Parent.Parent, "hud", "stat-display").PowerFlyItem
local v1 = RuntimeLib.import(script, script.Parent.Parent.Parent.Parent, "training-boost-atom")
local trainingIsFrenzyAtom, latestTrainingPowerFlyIdAtom = v1.trainingIsFrenzyAtom, v1.latestTrainingPowerFlyIdAtom
local defaultTrainingTuning = RuntimeLib.import(script, script.Parent, "training-skillcheck.config").defaultTrainingTuning
local default4 = RuntimeLib.import(script, script.Parent.Parent, "toolbar", "toolbar").default
local default5 = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "brainrot-style", "popout-text-button").default
local default6 = RuntimeLib.import(script, script.Parent.Parent.Parent, "tutorial", "pointer").default
local useScreenSizeState = RuntimeLib.import(script, script.Parent.Parent.Parent, "hooks", "use-screen-size").useScreenSizeState
local n1 = 0

local function StoryExitTrainingButton(p1) -- line: 47
    -- upvalues: react (copy), default5 (copy), useScreenSizeState (copy)
    local onPress = p1.onPress
    local v2 = useScreenSizeState() == "lg"
    local v4 = if v2 then 1 else 1.25
    local v3 = if v2 then 9 else 5
    local v5 = v3 * 0.061111111111111116 * v4 / 2
    local v6 = v4 * 0.064
    local v7 = if v2 then 1 else 0.8
    local v8 = v6 * v7
    local v9 = v7 * 0.04
    local v10 = (if v2 then 0.01 else v5 + 0.5 + v9) + (v8 * 4 + v9 * 3) / 3.5
    local v11 = v8 * 1.275
    local v12 = v8 * 0.25

    return react.createElement(default5, {
        cornerRadius = 0.3,
        label = "Exit Training",
        zIndex = 20,
        anchorPoint = Vector2.new(0.5, 1),
        color = Color3.fromRGB(200, 30, 30),
        frameSize = UDim2.new(0.108, 0, v11 * 0.8, 0),
        onClick = onPress,
        position = UDim2.new(v10, 0, 0.98 - v11 - v12, 0)
    })
end

local function StoryTutorialOverlay() -- line: 77
    -- upvalues: react (copy), default6 (copy), useScreenSizeState (copy)
    local v13 = useScreenSizeState() == "lg"
    local v15 = if v13 then 1 else 1.25
    local v14 = if v13 then 9 else 5
    local v16 = v14 * 0.061111111111111116 * v15 / 2
    local v17 = v15 * 0.064
    local v18 = if v13 then 1 else 0.8
    local v19 = v17 * v18
    local v20 = v18 * 0.04
    local v21 = (if v13 then 0.01 else v16 + 0.5 + v20) + (v19 * 4 + v20 * 3) / 3.5
    local v22 = v19 * 1.275 * 0.8
    local v23 = v19 * 0.25
    local v24 = 0.98 - v19 * 1.275 - v23
    local v25 = v24 - v22
    local v26 = v21 - 0.054 - 0.01
    local v27 = v21 + 0.054 + 0.01
    local v28 = v25 - 0.01
    local v29 = v24 + 0.01

    return react.createElement(react.Fragment, nil, react.createElement("frame", {
        Active = false,
        BackgroundTransparency = 0.45,
        BorderSizePixel = 0,
        ZIndex = 200,
        BackgroundColor3 = Color3.fromRGB(0, 0, 0),
        Position = UDim2.fromScale(0, 0),
        Size = UDim2.fromScale(1, v28)
    }), react.createElement("frame", {
        Active = false,
        BackgroundTransparency = 0.45,
        BorderSizePixel = 0,
        ZIndex = 200,
        BackgroundColor3 = Color3.fromRGB(0, 0, 0),
        Position = UDim2.fromScale(0, v29),
        Size = UDim2.fromScale(1, 1 - v29)
    }), react.createElement("frame", {
        Active = false,
        BackgroundTransparency = 0.45,
        BorderSizePixel = 0,
        ZIndex = 200,
        BackgroundColor3 = Color3.fromRGB(0, 0, 0),
        Position = UDim2.fromScale(0, v28),
        Size = UDim2.fromScale(v26, v29 - v28)
    }), react.createElement("frame", {
        Active = false,
        BackgroundTransparency = 0.45,
        BorderSizePixel = 0,
        ZIndex = 200,
        BackgroundColor3 = Color3.fromRGB(0, 0, 0),
        Position = UDim2.fromScale(v27, v28),
        Size = UDim2.fromScale(1 - v27, v29 - v28)
    }), react.createElement("frame", {
        Active = false,
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ZIndex = 202,
        AnchorPoint = Vector2.new(0.5, 1),
        Position = UDim2.fromScale(v21 - 0.0225, v28 - 0.025),
        Size = UDim2.fromScale(0.07, 0.1)
    }, react.createElement(default6, {
        direction = "down",
        size = UDim2.fromScale(1.5, 1.5)
    })))
end

local function StoryScene() -- line: 147
    -- upvalues: react (copy), useEffect (copy), useRef (copy), useState (copy), subscribe (copy), RunService (copy), default2 (copy), default3 (copy), PowerFlyItem (copy), trainingIsFrenzyAtom (copy), latestTrainingPowerFlyIdAtom (copy), defaultTrainingTuning (copy), default4 (copy), n1 (ref), StoryExitTrainingButton (copy), StoryTutorialOverlay (copy)
    local v30, v31 = useState(false)
    local v32, v33 = useState(false)
    local v34, v35 = useState(false)
    local v36, v37 = useState({})
    local v38, v39 = useState(0)
    local v40 = useRef(false)
    local v41 = useRef(false)

    useEffect(function() -- line: 155
        -- upvalues: v30 (copy), v40 (copy)
        v40.current = v30
    end, { v30 })
    useEffect(function() -- line: 158
        -- upvalues: v33 (copy), v41 (copy), subscribe (copy), trainingIsFrenzyAtom (copy)
        return subscribe(trainingIsFrenzyAtom, function(p2) -- line: 159
            -- upvalues: v33 (copy), v41 (copy)
            v41.current = p2
            v33(p2)
        end)
    end, {})
    useEffect(function() -- line: 164
        -- upvalues: v30 (copy), v37 (copy), v40 (copy), v41 (copy), RunService (copy), latestTrainingPowerFlyIdAtom (copy), n1 (ref)
        if not v30 then
            return nil
        end

        local n2 = 0
        local connection = RunService.Heartbeat:Connect(function(p3) -- line: 169
            -- upvalues: n2 (ref), v37 (copy), v40 (copy), v41 (copy), latestTrainingPowerFlyIdAtom (copy), n1 (ref)
            if not v40.current then
                return nil
            end

            n2 += p3

            if not (n2 >= 0.5) then
                return
            end

            n2 = 0

            local v42 = n1

            n1 += 1
            latestTrainingPowerFlyIdAtom(v42)
            v37(function(p4) -- line: 180
                -- upvalues: v42 (copy), v41 (copy)
                local t1 = {}
                local v43 = #t1
                local v44 = #p4

                table.move(p4, 1, v44, v43 + 1, t1)
                t1[v43 + v44 + 1] = {
                    amount = 10,
                    id = v42,
                    isFrenzy = v41.current
                }

                return t1
            end)
        end)

        return function() -- line: 195
            -- upvalues: connection (copy)
            return connection:Disconnect()
        end
    end, { v30 })

    local function v45(p5) -- line: 199
        -- upvalues: v37 (copy)
        v37(function(p6) -- line: 200
            -- upvalues: p5 (copy)
            local t2 = {}
            local n3 = 0

            for v46, v47 in p6 do
                local _ = v46 - 1

                if v47.id ~= p5 == true then
                    n3 += 1
                    t2[n3] = v47
                end
            end

            return t2
        end)
    end

    local v48 = react.createElement("textbutton", {
        BorderSizePixel = 0,
        TextScaled = true,
        ZIndex = 20,
        AnchorPoint = Vector2.new(0.5, 0),
        BackgroundColor3 = if v30 then Color3.fromRGB(60, 160, 60) else Color3.fromRGB(160, 60, 60),
        Event = {
            Activated = function() -- Activated | line: 222
                -- upvalues: v31 (copy)
                return v31(function(p7) -- line: 223
                    return not p7
                end)
            end
        },
        Font = Enum.Font.GothamBold,
        Position = UDim2.fromScale(0.5, 0.02),
        Size = UDim2.fromOffset(200, 40),
        Text = v30 and "TRAINING (click to stop)" or "START TRAINING",
        TextColor3 = Color3.fromRGB(255, 255, 255)
    }, react.createElement("uicorner", {
        CornerRadius = UDim.new(0, 8)
    }))
    local v49 = react.createElement("textbutton", {
        BorderSizePixel = 0,
        TextScaled = true,
        ZIndex = 20,
        AnchorPoint = Vector2.new(0.5, 0),
        BackgroundColor3 = if v34 then Color3.fromRGB(200, 140, 0) else Color3.fromRGB(60, 100, 200),
        Event = {
            Activated = function() -- Activated | line: 243
                -- upvalues: v35 (copy)
                return v35(function(p8) -- line: 244
                    return not p8
                end)
            end
        },
        Font = Enum.Font.GothamBold,
        Position = UDim2.fromScale(0.5, 0.1),
        Size = UDim2.fromOffset(260, 40),
        Text = v34 and "Hide Tutorial Overlay" or "Show Tutorial Overlay",
        TextColor3 = Color3.fromRGB(255, 255, 255)
    }, react.createElement("uicorner", {
        CornerRadius = UDim.new(0, 8)
    }))
    local v50 = v32 and react.createElement("textlabel", {
        BackgroundTransparency = 1,
        Text = "FRENZY!",
        TextScaled = true,
        ZIndex = 20,
        AnchorPoint = Vector2.new(0.5, 0),
        Font = Enum.Font.GothamBlack,
        Position = UDim2.fromScale(0.5, 0.19),
        Size = UDim2.fromOffset(300, 40),
        TextColor3 = Color3.fromRGB(255, 80, 0)
    }, react.createElement("uistroke", {
        Thickness = 2,
        Color = Color3.fromRGB(0, 0, 0)
    }))
    local v51 = react.createElement(default2, {
        baseSpawnDelayMs = defaultTrainingTuning.baseSpawnDelayMs,
        boostGainPerHit = defaultTrainingTuning.boostGainPerHit,
        circleDurationMs = defaultTrainingTuning.circleDurationMs,
        frenzyDurationSeconds = defaultTrainingTuning.frenzyDurationSeconds,
        isActive = v30,
        spawnAccelerationFactor = defaultTrainingTuning.spawnAccelerationFactor
    })
    local v52 = react.createElement(default3)
    local v53 = react.createElement(default4, {
        activeItems = {}
    })
    local v54 = react.createElement(StoryExitTrainingButton, {
        onPress = function() -- onPress | line: 286
            -- upvalues: v31 (copy)
            return v31(false)
        end
    })
    local v55 = v34 and react.createElement(StoryTutorialOverlay)
    local v56 = table.create(#v36)

    local function v57(p9) -- line: 293
        -- upvalues: v39 (copy), v45 (copy), react (copy), PowerFlyItem (copy)
        return react.createElement(PowerFlyItem, {
            amount = p9.amount,
            id = p9.id,
            isFrenzy = p9.isFrenzy,
            key = tostring(p9.id),
            onArrive = function() -- onArrive | line: 299
                -- upvalues: v39 (copy)
                return v39(function(p10) -- line: 300
                    return p10 + 1
                end)
            end,
            onRemove = function() -- onRemove | line: 304
                -- upvalues: p9 (copy), v45 (copy)
                return v45(p9.id)
            end
        })
    end

    for v58, v59 in v36 do
        v56[v58] = v57(v59, v58 - 1, v36)
    end

    return react.createElement("frame", {
        BackgroundTransparency = 1,
        Size = UDim2.fromScale(1, 1)
    }, v48, v49, v50, v51, v52, v53, v54, v55, v56, react.createElement("textlabel", {
        BackgroundTransparency = 1,
        TextScaled = true,
        ZIndex = 5,
        AnchorPoint = Vector2.new(0, 0.5),
        Font = Enum.Font.GothamBold,
        Position = UDim2.fromScale(0.03, 0.62),
        Size = UDim2.fromOffset(200, 30),
        Text = `Power stat: { v38 * 10 }`,
        TextColor3 = Color3.fromRGB(255, 180, 60)
    }, react.createElement("uistroke", {
        Thickness = 1.5,
        Color = Color3.fromRGB(0, 0, 0)
    })))
end

return storyForScreenGui(react.createElement(default, nil, react.createElement(StoryScene)))
