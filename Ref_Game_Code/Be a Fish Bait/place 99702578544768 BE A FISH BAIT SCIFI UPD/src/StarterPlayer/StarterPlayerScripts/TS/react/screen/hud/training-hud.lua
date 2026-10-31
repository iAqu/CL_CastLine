-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local useBinding, useEffect, useRef, useState = react.useBinding, react.useEffect, react.useRef, react.useState
local useMotion = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "pretty-react-hooks", "out").useMotion
local RunService = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services").RunService
local subscribe = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "charm").subscribe
local images = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "images").images
local fishingMovementLockedAtom = RuntimeLib.import(script, script.Parent.Parent.Parent.Parent, "fishing-phase-atom").fishingMovementLockedAtom
local trainingIsFrenzyAtom = RuntimeLib.import(script, script.Parent.Parent.Parent.Parent, "training-boost-atom").trainingIsFrenzyAtom
local isInVipTrainingAreaAtom = RuntimeLib.import(script, script.Parent.Parent.Parent.Parent, "vip-training-atom").isInVipTrainingAreaAtom
local functions = RuntimeLib.import(script, script.Parent.Parent.Parent.Parent, "network").functions
local useRootSelector = RuntimeLib.import(script, script.Parent.Parent.Parent, "hooks", "reflex").useRootSelector
local selectCurrentWindow = RuntimeLib.import(script, script.Parent.Parent.Parent.Parent, "reflex", "slices", "selectors", "current-window.selectors").selectCurrentWindow
local selectors = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "slices", "player-data", "selectors")
local selectEquippedInventoryItem, selectPlayerOwnsGamepass = selectors.selectEquippedInventoryItem, selectors.selectPlayerOwnsGamepass
local vipGamepassName = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "gamepass-utils").vipGamepassName
local selectTutorialStep = RuntimeLib.import(script, script.Parent.Parent.Parent.Parent, "reflex", "slices", "tutorial.selectors").selectTutorialStep
local tutorialSteps = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "tutorial-utils").tutorialSteps
local localPlayerUserId = RuntimeLib.import(script, script.Parent.Parent.Parent.Parent, "utils").localPlayerUserId
local default = RuntimeLib.import(script, script.Parent.Parent, "training-skillcheck", "training-skillcheck").default
local default2 = RuntimeLib.import(script, script.Parent.Parent, "training-skillcheck", "training-boost-bar").default
local TrainingFrenzyCameraFov = RuntimeLib.import(script, script.Parent.Parent, "training-skillcheck", "training-frenzy-camera-fov").TrainingFrenzyCameraFov
local TrainingSpeedlines = RuntimeLib.import(script, script.Parent.Parent, "training-skillcheck", "training-speedlines").TrainingSpeedlines
local v1 = RuntimeLib.import(script, script.Parent.Parent, "training-skillcheck", "training-skillcheck.config")
local defaultTrainingTuning, getTrainingScale = v1.defaultTrainingTuning, v1.getTrainingScale
local default3 = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "brainrot-style", "popout-text-two").default
local default4 = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "brainrot-style", "popout-text-button").default
local useScreenSizeState = RuntimeLib.import(script, script.Parent.Parent.Parent, "hooks", "use-screen-size").useScreenSizeState
local default5 = RuntimeLib.import(script, script.Parent.Parent.Parent, "tutorial", "pointer").default

local function EndWeightTrainingOverlay() -- line: 38
    -- upvalues: react (copy), useScreenSizeState (copy), default5 (copy)
    local v2 = useScreenSizeState() == "lg"
    local v4 = if v2 then 1 else 1.25
    local v3 = if v2 then 9 else 5
    local v5 = v3 * 0.061111111111111116 * v4 / 2
    local v6 = v4 * 0.064
    local v7 = if v2 then 1 else 0.8
    local v8 = v6 * v7
    local v9 = v7 * 0.04
    local v10 = (if v2 then 0.01 else v5 + 0.5 + v9) + (v8 * 4 + v9 * 3) / 3.5
    local v11 = v8 * 1.275 * 0.8
    local v12 = v8 * 0.25
    local v13 = 0.98 - v8 * 1.275 - v12
    local v14 = v13 - v11
    local v15 = v10 - 0.054 - 0.01
    local v16 = v10 + 0.054 + 0.01
    local v17 = v14 - 0.01
    local v18 = v13 + 0.01

    return react.createElement(react.Fragment, nil, react.createElement("frame", {
        Active = false,
        BackgroundTransparency = 0.45,
        BorderSizePixel = 0,
        ZIndex = 200,
        BackgroundColor3 = Color3.fromRGB(0, 0, 0),
        Position = UDim2.fromScale(0, 0),
        Size = UDim2.fromScale(1, v17)
    }), react.createElement("frame", {
        Active = false,
        BackgroundTransparency = 0.45,
        BorderSizePixel = 0,
        ZIndex = 200,
        BackgroundColor3 = Color3.fromRGB(0, 0, 0),
        Position = UDim2.fromScale(0, v18),
        Size = UDim2.fromScale(1, 1 - v18)
    }), react.createElement("frame", {
        Active = false,
        BackgroundTransparency = 0.45,
        BorderSizePixel = 0,
        ZIndex = 200,
        BackgroundColor3 = Color3.fromRGB(0, 0, 0),
        Position = UDim2.fromScale(0, v17),
        Size = UDim2.fromScale(v15, v18 - v17)
    }), react.createElement("frame", {
        Active = false,
        BackgroundTransparency = 0.45,
        BorderSizePixel = 0,
        ZIndex = 200,
        BackgroundColor3 = Color3.fromRGB(0, 0, 0),
        Position = UDim2.fromScale(v16, v17),
        Size = UDim2.fromScale(1 - v16, v18 - v17)
    }), react.createElement("frame", {
        Active = false,
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ZIndex = 202,
        AnchorPoint = Vector2.new(0.5, 1),
        Position = UDim2.fromScale(v10 - 0.0225, v17 - 0.025),
        Size = UDim2.fromScale(0.07, 0.1)
    }, react.createElement(default5, {
        direction = "down",
        zIndex = 202,
        size = UDim2.fromScale(1.5, 1.5)
    })))
end

local function ExitTrainingButton(p1) -- line: 112
    -- upvalues: react (copy), default4 (copy), useScreenSizeState (copy)
    local onPress = p1.onPress
    local v19 = useScreenSizeState() == "lg"
    local v21 = if v19 then 1 else 1.25
    local v20 = if v19 then 9 else 5
    local v22 = v20 * 0.061111111111111116 * v21 / 2
    local v23 = v21 * 0.064
    local v24 = if v19 then 1 else 0.8
    local v25 = v23 * v24
    local v26 = v24 * 0.04
    local v27 = (if v19 then 0.01 else v22 + 0.5 + v26) + (v25 * 4 + v26 * 3) / 3.5
    local v28 = v25 * 1.275
    local v29 = v25 * 0.25

    return react.createElement(default4, {
        cornerRadius = 0.3,
        label = "Exit Training",
        zIndex = 20,
        anchorPoint = Vector2.new(0.5, 1),
        color = Color3.fromRGB(200, 30, 30),
        frameSize = UDim2.new(0.108, 0, v28 * 0.8, 0),
        onClick = onPress,
        position = UDim2.new(v27, 0, 0.98 - v28 - v29, 0)
    })
end

local v30 = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 240, 0)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 200, 0))
})
local v31 = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 221, 90)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 170, 0))
})

local function VipTrainingBanner() -- line: 148
    -- upvalues: react (copy), defaultTrainingTuning (copy), getTrainingScale (copy), default3 (copy), useScreenSizeState (copy), v31 (copy)
    local v32 = useScreenSizeState()
    local v33 = v32 == "sm" or v32 == "md"
    local v34 = if v33 then 1.25 else 1
    local v35 = getTrainingScale(v32)
    local v36 = defaultTrainingTuning.barHeightPx * v35 / 600
    local v37 = defaultTrainingTuning.barGapPx * v35 / 600
    local v38 = if v33 then 0.04 else 0.026
    local v39 = 0.97 - v34 * 0.089 - v38
    local v40 = if v33 then 0.025 else 0
    local v41 = v39 - v37 - v40
    local v42 = 4 * v35 / 600
    local v43 = 16 * v35 / 600

    return react.createElement("frame", {
        BackgroundTransparency = 1,
        ZIndex = 50,
        AnchorPoint = Vector2.new(0.5, 1),
        Position = UDim2.fromScale(0.5, v41 - v36 - v42 - 0.02),
        Size = UDim2.fromScale(0.32, v43 * 2)
    }, react.createElement(default3, {
        text = "1.5x Training Speed Active!",
        color = v31,
        overrideProps = {
            TextScaled = true,
            ZIndex = 50,
            Size = UDim2.fromScale(1, 1)
        },
        strokeProps = {
            Thickness = 0.06,
            Color = Color3.fromRGB(140, 90, 0)
        }
    }))
end

local function FrenzyLabel(p2) -- line: 182
    -- upvalues: react (copy), useBinding (copy), useEffect (copy), useRef (copy), RunService (copy), default3 (copy), v30 (copy)
    local onDone = p2.onDone
    local v44, v45 = useBinding(1)
    local v46, v47 = useBinding(0)
    local v48 = useRef(onDone)

    v48.current = onDone
    useEffect(function() -- line: 188
        -- upvalues: v45 (copy), v47 (copy), v48 (copy), RunService (copy)
        local v49 = os.clock() + 2
        local connection

        connection = RunService.Heartbeat:Connect(function(_) -- line: 191
            -- upvalues: v49 (copy), connection (ref), v45 (copy), v47 (copy), v48 (copy)
            local elapsed = os.clock()
            local v50 = v49 - elapsed

            if v50 <= 0 then
                v47(1)
                v45(1)
                connection:Disconnect()
                v48.current()

                return nil
            end

            if v50 <= 1 then
                v47((1 - math.sin(1.5707963267948966 + (1 - v50 / 1) * 3.141592653589793)) * 0.4 + 0.2)
                v45(1)

                return nil
            end

            local v53 = math.cos(elapsed % 1 * 3.141592653589793 * 2)

            v45((1 - v53) * 0.1 + 1)
            v47((1 - v53) * 0.15 + 0.2)
        end)

        return function() -- line: 214
            -- upvalues: connection (ref)
            return connection:Disconnect()
        end
    end, { v45, v47 })

    return react.createElement("frame", {
        BackgroundTransparency = 1,
        ZIndex = 50,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromScale(0.5, 0.5),
        Size = UDim2.fromScale(0.45, 0.12)
    }, react.createElement("uiscale", {
        Scale = v44
    }), react.createElement(default3, {
        text = "FRENZY",
        color = v30,
        overrideProps = {
            TextScaled = true,
            ZIndex = 50,
            Size = UDim2.fromScale(1, 1)
        },
        strokeProps = {
            Color = Color3.fromRGB(255, 120, 0)
        },
        textTransparency = v46
    }))
end

return {
    default = function() -- TrainingHud | line: 242
        -- upvalues: react (copy), useEffect (copy), useRef (copy), useState (copy), useMotion (copy), subscribe (copy), images (copy), fishingMovementLockedAtom (copy), trainingIsFrenzyAtom (copy), isInVipTrainingAreaAtom (copy), functions (copy), useRootSelector (copy), selectCurrentWindow (copy), selectEquippedInventoryItem (copy), selectPlayerOwnsGamepass (copy), vipGamepassName (copy), selectTutorialStep (copy), tutorialSteps (copy), localPlayerUserId (copy), default (copy), default2 (copy), TrainingFrenzyCameraFov (copy), TrainingSpeedlines (copy), EndWeightTrainingOverlay (copy), ExitTrainingButton (copy), VipTrainingBanner (copy), FrenzyLabel (copy)
        local v54 = useRootSelector(selectCurrentWindow)
        local v55 = useRootSelector(selectTutorialStep)
        local v56 = useRootSelector(selectEquippedInventoryItem(localPlayerUserId))
        local v57 = (if v56 == nil then v56 else v56.itemType) == "trainingWeight"
        local v58 = useRootSelector(selectPlayerOwnsGamepass(localPlayerUserId, vipGamepassName))
        local v59, v60 = useState(false)

        useEffect(function() -- line: 253
            -- upvalues: v60 (copy), subscribe (copy), fishingMovementLockedAtom (copy)
            return subscribe(fishingMovementLockedAtom, function(p4) -- line: 254
                -- upvalues: v60 (copy)
                v60(p4)
            end)
        end, {})

        local v61, v62 = useState(isInVipTrainingAreaAtom())

        useEffect(function() -- line: 259
            -- upvalues: v62 (copy), subscribe (copy), isInVipTrainingAreaAtom (copy)
            return subscribe(isInVipTrainingAreaAtom, function(p5) -- line: 260
                -- upvalues: v62 (copy)
                v62(p5)
            end)
        end, {})

        local v63, v64 = useState({})
        local v65 = useRef(0)
        local v66, v67 = useMotion(1)

        useEffect(function() -- line: 267
            -- upvalues: v64 (copy), v65 (copy), v67 (copy), subscribe (copy), trainingIsFrenzyAtom (copy)
            return subscribe(trainingIsFrenzyAtom, function(p6) -- line: 268
                -- upvalues: v64 (copy), v65 (copy), v67 (copy)
                if not p6 then
                    v67:tween(1, {
                        time = 0.5,
                        style = Enum.EasingStyle.Quad,
                        direction = Enum.EasingDirection.Out
                    })

                    return
                end

                local current = v65.current

                v65.current += 1
                v64(function(p7) -- line: 273
                    -- upvalues: current (copy)
                    local t1 = {}
                    local v68 = #t1
                    local v69 = #p7

                    table.move(p7, 1, v69, v68 + 1, t1)
                    t1[v68 + v69 + 1] = current

                    return t1
                end)
                v67:tween(0.2, {
                    time = 0.35,
                    style = Enum.EasingStyle.Quad,
                    direction = Enum.EasingDirection.Out
                })
            end)
        end, { v67 })

        local v70 = v54 == "shop"
        local v71 = v54 == "aquarium"
        local v72 = not v70 and not v71 and not v59 and v57

        v72 = v72 and react.createElement(react.Fragment, nil, react.createElement(default, {
            isActive = true
        }), react.createElement(default2), react.createElement(TrainingFrenzyCameraFov, {
            isActive = true
        }), react.createElement(TrainingSpeedlines, {
            isActive = true
        }), v58 and v61 and react.createElement(VipTrainingBanner), react.createElement(ExitTrainingButton, {
            onPress = function() -- onPress | line: 306
                -- upvalues: v56 (copy), functions (copy)
                if v56 then
                    functions.unequipInventoryItem(v56.itemId)
                end
            end
        }), v55 == tutorialSteps.endWeightTraining and react.createElement(EndWeightTrainingOverlay))

        if v57 then
            v57 = table.create(#v63)

            local function v78(p8) -- line: 316
                -- upvalues: v64 (copy), react (copy), FrenzyLabel (copy)
                return react.createElement(FrenzyLabel, {
                    key = tostring(p8),
                    onDone = function() -- onDone | line: 319
                        -- upvalues: p8 (copy), v64 (copy)
                        return v64(function(p9) -- line: 320
                            -- upvalues: p8 (copy)
                            local t4 = {}
                            local n1 = 0

                            for v79, v80 in p9 do
                                local _ = v79 - 1

                                if v80 ~= p8 == true then
                                    n1 += 1
                                    t4[n1] = v80
                                end
                            end

                            return t4
                        end)
                    end
                })
            end

            for v81, v82 in v63 do
                v57[v81] = v78(v82, v81 - 1, v63)
            end
        end

        return react.createElement(react.Fragment, nil, v72, v57, react.createElement("imagelabel", {
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            ZIndex = 100,
            AnchorPoint = Vector2.new(0.5, 0.5),
            Image = images.screenBorder,
            ImageColor3 = Color3.fromRGB(255, 210, 0),
            ImageTransparency = v66,
            Position = UDim2.fromScale(0.5, 0.5),
            ScaleType = Enum.ScaleType.Stretch,
            Size = UDim2.fromScale(1, 1)
        }))
    end
}
