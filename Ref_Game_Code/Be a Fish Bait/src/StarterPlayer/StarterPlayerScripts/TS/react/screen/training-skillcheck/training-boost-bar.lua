-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local useEffect, useRef = react.useEffect, react.useRef
local useBinding = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react").useBinding
local RunService = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services").RunService
local subscribe = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "charm").subscribe
local v1 = RuntimeLib.import(script, script.Parent.Parent.Parent.Parent, "training-boost-atom")
local trainingBoostFillAtom, trainingIsFrenzyAtom = v1.trainingBoostFillAtom, v1.trainingIsFrenzyAtom
local useScreenSizeState = RuntimeLib.import(script, script.Parent.Parent.Parent, "hooks", "use-screen-size").useScreenSizeState
local v2 = RuntimeLib.import(script, script.Parent, "training-skillcheck.config")
local boostBarGradient, defaultTrainingTuning, getTrainingScale = v2.boostBarGradient, v2.defaultTrainingTuning, v2.getTrainingScale

return {
    default = function(p1) -- TrainingBoostBar | line: 18
        -- upvalues: react (copy), useEffect (copy), useRef (copy), useBinding (copy), RunService (copy), subscribe (copy), trainingBoostFillAtom (copy), trainingIsFrenzyAtom (copy), useScreenSizeState (copy), boostBarGradient (copy), defaultTrainingTuning (copy), getTrainingScale (copy)
        local widthScale = p1.widthScale

        if widthScale == nil then
            widthScale = 0.55
        end

        local barHeightPx = p1.barHeightPx

        if barHeightPx == nil then
            barHeightPx = defaultTrainingTuning.barHeightPx
        end

        local barGapPx = p1.barGapPx

        if barGapPx == nil then
            barGapPx = defaultTrainingTuning.barGapPx
        end

        local cornerRadius = p1.cornerRadius

        if cornerRadius == nil then
            cornerRadius = defaultTrainingTuning.barCornerRadius
        end

        local v3 = useScreenSizeState()
        local v4 = getTrainingScale(v3)
        local v5 = barHeightPx * v4
        local v6 = barGapPx * v4
        local v7 = v3 == "sm" or v3 == "md"
        local v8 = if v7 then 1.25 else 1
        local v9, v10 = useBinding(0)
        local v11, v12 = useBinding(1)
        local v13 = useRef(0)
        local v14 = useRef(0)
        local v15 = useRef(false)
        local v16 = useRef(0)

        useEffect(function() -- line: 47
            -- upvalues: v10 (copy), v12 (copy), v13 (copy), v14 (copy), v15 (copy), v16 (copy), RunService (copy), subscribe (copy), trainingBoostFillAtom (copy), trainingIsFrenzyAtom (copy), defaultTrainingTuning (copy)
            local v17 = subscribe(trainingBoostFillAtom, function(p2) -- line: 48
                -- upvalues: v13 (copy)
                v13.current = p2
            end)
            local v18 = subscribe(trainingIsFrenzyAtom, function(p3) -- line: 51
                -- upvalues: v12 (copy), v15 (copy), v16 (copy)
                v15.current = p3

                if not p3 then
                    v12(1)
                    v16.current = 0
                end
            end)
            local connection = RunService.Heartbeat:Connect(function(p4) -- line: 58
                -- upvalues: v10 (copy), v12 (copy), v13 (copy), v14 (copy), v15 (copy), v16 (copy), defaultTrainingTuning (copy)
                local v19 = math.clamp(v13.current, 0, 1)

                if v19 ~= v14.current then
                    v14.current = v19
                    v10(v19)
                end

                if v15.current then
                    v16.current += p4

                    local v20 = v16.current / defaultTrainingTuning.flashIntervalSeconds % 2

                    if not (v20 <= 1) then
                        v20 = 2 - v20
                    end

                    v12(v20)
                end
            end)

            return function() -- line: 73
                -- upvalues: v17 (copy), v18 (copy), connection (copy)
                connection:Disconnect()
                v17()
                v18()
            end
        end, {})

        local v21 = if v7 then 0.04 else 0.026
        local v22 = 0.97 - v8 * 0.089 - v21
        local v23 = if v7 then 0.025 else 0
        local v24 = v22 - v6 / 600 - v23

        return react.createElement("frame", {
            BackgroundTransparency = 1,
            ZIndex = 5,
            AnchorPoint = Vector2.new(0.5, 1),
            Position = UDim2.new(0.5, 0, v24, 0),
            Size = UDim2.new(widthScale, 0, 0, v5)
        }, react.createElement("frame", {
            BackgroundTransparency = 0.3,
            BorderSizePixel = 0,
            ZIndex = 1,
            AnchorPoint = Vector2.new(0, 0),
            BackgroundColor3 = Color3.fromRGB(30, 20, 10),
            Position = UDim2.fromScale(0, 0),
            Size = UDim2.fromScale(1, 1)
        }, react.createElement("uicorner", {
            CornerRadius = UDim.new(0, cornerRadius)
        })), react.createElement("frame", {
            BackgroundTransparency = 0,
            BorderSizePixel = 0,
            ClipsDescendants = true,
            ZIndex = 2,
            AnchorPoint = Vector2.new(0, 0),
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
            Position = UDim2.fromScale(0, 0),
            Size = v9:map(function(p5) -- line: 108
                return UDim2.fromScale(p5, 1)
            end)
        }, react.createElement("uicorner", {
            CornerRadius = UDim.new(0, cornerRadius)
        }), react.createElement("uigradient", {
            Rotation = 0,
            Color = boostBarGradient
        }), react.createElement("frame", {
            BorderSizePixel = 0,
            ZIndex = 1,
            AnchorPoint = Vector2.new(0, 0),
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
            BackgroundTransparency = v11,
            Position = UDim2.fromScale(0, 0),
            Size = UDim2.fromScale(1, 1)
        }, react.createElement("uicorner", {
            CornerRadius = UDim.new(0, cornerRadius)
        }))))
    end
}
