-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Flamework = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Flamework
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local useEffect, useRef, useState = react.useEffect, react.useRef, react.useState
local RunService = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services").RunService
local default = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "circular-progress").default
local default2 = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "qte-key-image").default
local useIsUsingGamepad = RuntimeLib.import(script, script.Parent.Parent.Parent, "hooks", "use-is-using-gamepad").useIsUsingGamepad
local useQteConsoleKey = RuntimeLib.import(script, script.Parent.Parent.Parent, "hooks", "use-qte-console-key").useQteConsoleKey
local images = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "images").images
local hapticCircleClick = RuntimeLib.import(script, script.Parent.Parent.Parent.Parent, "haptics").hapticCircleClick
local v1 = Color3.fromRGB(255, 255, 255)
local v2 = Color3.fromRGB(255, 105, 220)

return {
    default = function(p1) -- DeluluQteTarget | line: 22
        -- upvalues: Flamework (copy), react (copy), useEffect (copy), useRef (copy), useState (copy), RunService (copy), default (copy), default2 (copy), useIsUsingGamepad (copy), useQteConsoleKey (copy), images (copy), hapticCircleClick (copy), v1 (copy), v2 (copy)
        local onMiss, onTap = p1.onMiss, p1.onTap
        local v3 = useRef(os.clock())
        local v4 = useRef(false)
        local v5 = useRef(onTap)

        v5.current = onTap

        local v6 = useRef(onMiss)

        v6.current = onMiss

        local v7 = useState(-0.2 + math.random() * 0.4)
        local v8 = useState(-0.2 + math.random() * 0.4)
        local v9, v10 = useState(100)
        local v11 = useRef(100)

        useEffect(function() -- line: 35
            -- upvalues: v3 (copy), v4 (copy), v6 (copy), v10 (copy), v11 (copy), RunService (copy)
            local connection = RunService.Heartbeat:Connect(function() -- line: 36
                -- upvalues: v3 (copy), v4 (copy), v6 (copy), v10 (copy), v11 (copy)
                if v4.current then
                    return nil
                end

                local v13 = math.min((os.clock() - v3.current) / 1, 1)
                local v16 = math.round(math.max(1 - v13, 0) * 50) * 2

                if v16 ~= v11.current then
                    v11.current = v16
                    v10(v16)
                end

                if v13 >= 1 then
                    v4.current = true
                    v6.current()
                end
            end)

            return function() -- line: 52
                -- upvalues: connection (copy)
                return connection:Disconnect()
            end
        end, {})

        local function v17() -- line: 56
            -- upvalues: v4 (copy), v5 (copy), Flamework (copy), hapticCircleClick (copy)
            if v4.current then
                return nil
            end

            v4.current = true
            hapticCircleClick()
            Flamework.resolveDependency("client/controllers/sound-controller@SoundController"):playSoundPolyphonic("PopSound", 1, 2)
            Flamework.resolveDependency("client/controllers/sound-controller@SoundController"):playSoundPolyphonic("ThockyKeyboard", 1, 5, 0.6)
            v5.current()
        end

        local v18 = useQteConsoleKey(v17)
        local v19 = useIsUsingGamepad()

        return react.createElement("frame", {
            BackgroundTransparency = 1,
            ZIndex = 20,
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.fromScale(0.5 + v8, 0.5 + v7),
            Size = UDim2.fromOffset(140, 140)
        }, react.createElement(default, {
            direction = "Left",
            missingPartType = "TransAndColor",
            starterPoint = "Up",
            transOfMissingPart = 1,
            transOfPercentPart = 0,
            anchorPoint = Vector2.new(0.5, 0.5),
            colorOfMissingPart = Color3.fromRGB(0, 0, 0),
            colorOfPercentPart = v1,
            position = UDim2.fromScale(0.5, 0.5),
            progress = v9,
            size = UDim2.fromScale(1, 1)
        }), react.createElement("frame", {
            BackgroundTransparency = 0,
            BorderSizePixel = 0,
            ZIndex = 22,
            AnchorPoint = Vector2.new(0.5, 0.5),
            BackgroundColor3 = v2,
            Position = UDim2.fromScale(0.5, 0.5),
            Size = UDim2.fromOffset(84, 84)
        }, react.createElement("uicorner", {
            CornerRadius = UDim.new(0.5, 0)
        }), react.createElement("uistroke", {
            Thickness = 3,
            Color = Color3.fromRGB(255, 255, 255)
        }), react.createElement("imagelabel", {
            BackgroundTransparency = 1,
            ZIndex = 23,
            AnchorPoint = Vector2.new(0.5, 0.5),
            Image = images.pointIcon,
            Position = UDim2.fromScale(0.5, 0.5),
            Size = UDim2.fromOffset(46.2, 46.2)
        })), react.createElement("textbutton", {
            BackgroundTransparency = 1,
            Text = "",
            ZIndex = 25,
            AnchorPoint = Vector2.new(0.5, 0.5),
            Event = {
                Activated = v17
            },
            Position = UDim2.fromScale(0.5, 0.5),
            Size = UDim2.fromOffset(168, 168)
        }, react.createElement("uicorner", {
            CornerRadius = UDim.new(0.5, 0)
        })), v19 and react.createElement(default2, {
            radius = 70,
            size = 48,
            keyCode = v18
        }))
    end
}
