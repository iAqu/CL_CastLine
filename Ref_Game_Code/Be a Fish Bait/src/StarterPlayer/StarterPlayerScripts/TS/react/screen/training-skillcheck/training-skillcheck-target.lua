-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local useBinding, useEffect, useRef, useState = react.useBinding, react.useEffect, react.useRef, react.useState
local RunService = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services").RunService
local images = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "images").images
local default = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "circular-progress").default
local default2 = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "brainrot-style", "popout-text-two").default
local default3 = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "qte-key-image").default
local useIsUsingGamepad = RuntimeLib.import(script, script.Parent.Parent.Parent, "hooks", "use-is-using-gamepad").useIsUsingGamepad
local useQteConsoleKey = RuntimeLib.import(script, script.Parent.Parent.Parent, "hooks", "use-qte-console-key").useQteConsoleKey
local defaultTrainingTuning = RuntimeLib.import(script, script.Parent, "training-skillcheck.config").defaultTrainingTuning
local v1 = Color3.fromRGB(120, 50, 200)
local v2 = Color3.fromRGB(220, 50, 50)

return {
    default = function(p1) -- TrainingTargetCircle | line: 19
        -- upvalues: react (copy), useBinding (copy), useEffect (copy), useRef (copy), useState (copy), RunService (copy), images (copy), default (copy), default2 (copy), default3 (copy), useIsUsingGamepad (copy), useQteConsoleKey (copy), defaultTrainingTuning (copy), v1 (copy), v2 (copy)
        local approachRingProgress, onTap, size = p1.approachRingProgress, p1.onTap, p1.size

        if size == nil then
            size = defaultTrainingTuning.size
        end

        local targetPos = p1.targetPos
        local v3 = size * defaultTrainingTuning.hitboxMultiplier
        local v4 = size + defaultTrainingTuning.approachRingOuterPad * 2
        local v5 = useQteConsoleKey(onTap)
        local v6 = useIsUsingGamepad()
        local v7, v8 = useState(false)
        local v9, v10 = useState(100)
        local v11 = useRef(false)
        local v12 = useRef(100)
        local v13, v14 = useBinding(0)

        useEffect(function() -- line: 39
            -- upvalues: approachRingProgress (copy), v8 (copy), v10 (copy), v11 (copy), v12 (copy), v14 (copy), RunService (copy)
            local n1 = 0
            local connection = RunService.Heartbeat:Connect(function(p2) -- line: 41
                -- upvalues: n1 (ref), approachRingProgress (copy), v8 (copy), v10 (copy), v11 (copy), v12 (copy), v14 (copy)
                n1 += p2
                v14(math.sin(n1 * 12) * 8)

                local v16 = approachRingProgress:getValue()
                local v17 = v16 >= 0.75

                if v17 ~= v11.current then
                    v11.current = v17
                    v8(v17)
                end

                local v20 = math.round(math.max(1 - v16, 0) * 50) * 2

                if v20 ~= v12.current then
                    v12.current = v20
                    v10(v20)
                end
            end)

            return function() -- line: 58
                -- upvalues: connection (copy)
                return connection:Disconnect()
            end
        end, { approachRingProgress, v14 })

        local v21 = if v7 then v2 else v1

        return react.createElement("frame", {
            Active = false,
            BackgroundTransparency = 1,
            ZIndex = 3,
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.fromOffset(targetPos.x, targetPos.y),
            Size = UDim2.fromOffset(v4, v4)
        }, react.createElement(default, {
            direction = "Left",
            missingPartType = "TransAndColor",
            starterPoint = "Up",
            transOfMissingPart = 1,
            transOfPercentPart = 0,
            anchorPoint = Vector2.new(0.5, 0.5),
            colorOfMissingPart = Color3.fromRGB(0, 0, 0),
            colorOfPercentPart = v21,
            position = UDim2.fromScale(0.5, 0.5),
            progress = v9,
            size = UDim2.fromScale(1, 1)
        }), react.createElement("frame", {
            Active = false,
            BackgroundTransparency = 0.1,
            BorderSizePixel = 0,
            ZIndex = 5,
            AnchorPoint = Vector2.new(0.5, 0.5),
            BackgroundColor3 = v1,
            Position = UDim2.fromScale(0.5, 0.5),
            Size = UDim2.fromOffset(size * 0.7, size * 0.7)
        }, react.createElement("uicorner", {
            CornerRadius = UDim.new(0.5, 0)
        }), react.createElement("uistroke", {
            Thickness = 3,
            Color = Color3.fromRGB(150, 80, 220)
        }), react.createElement("imagelabel", {
            BackgroundTransparency = 1,
            ZIndex = 6,
            AnchorPoint = Vector2.new(0.5, 0.5),
            Image = images.pointIcon,
            Position = UDim2.fromScale(0.5, 0.5),
            Size = UDim2.fromOffset(size * 0.5, size * 0.5)
        }), react.createElement("frame", {
            BackgroundTransparency = 1,
            ZIndex = 15,
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.fromScale(0.9, 0.9),
            Rotation = v13,
            Size = UDim2.fromOffset(size * 0.3, size * 0.24)
        }, react.createElement(default2, {
            text = "x2",
            color = Color3.fromRGB(255, 255, 255),
            overrideProps = {
                TextScaled = true,
                ZIndex = 15,
                Font = Enum.Font.GothamBlack,
                Size = UDim2.fromScale(1, 1)
            },
            popoutColor = Color3.fromRGB(80, 30, 130),
            strokeProps = {
                Color = Color3.fromRGB(80, 30, 130)
            }
        }))), react.createElement("textbutton", {
            BackgroundTransparency = 1,
            Text = "",
            ZIndex = 10,
            AnchorPoint = Vector2.new(0.5, 0.5),
            Event = {
                Activated = onTap
            },
            Position = UDim2.fromScale(0.5, 0.5),
            Size = UDim2.fromOffset(v3, v3)
        }, react.createElement("uicorner", {
            CornerRadius = UDim.new(0.5, 0)
        })), v6 and react.createElement(default3, {
            keyCode = v5,
            radius = v4 / 2,
            size = size * 0.4
        }))
    end
}
