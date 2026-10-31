-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local useEffect, useRef = react.useEffect, react.useRef
local useMotion = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "pretty-react-hooks", "out").useMotion
local UserInputService = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services").UserInputService
local default = RuntimeLib.import(script, script.Parent.Parent, "common", "circular-progress").default
local default2 = RuntimeLib.import(script, script.Parent.Parent, "common", "qte-key-image").default
local useIsUsingGamepad = RuntimeLib.import(script, script.Parent.Parent, "hooks", "use-is-using-gamepad").useIsUsingGamepad
local defaultTuning = RuntimeLib.import(script, script.Parent.Parent, "screen", "fishing", "rare-fish-skillcheck.config").defaultTuning
local size = defaultTuning.size
local v1 = size + 20
local v2 = size * defaultTuning.hitboxMultiplier
local v3 = Color3.fromRGB(255, 214, 66)
local v4 = Color3.fromRGB(120, 78, 0)
local v5 = Color3.fromRGB(230, 55, 55)
local v6 = Color3.fromRGB(110, 12, 12)
local v7 = Color3.fromRGB(70, 205, 95)
local v8 = Color3.fromRGB(20, 90, 35)
local v9 = Color3.fromRGB(74, 219, 41)

return {
    default = function(p1) -- CatchSticksButton | line: 34
        -- upvalues: react (copy), useEffect (copy), useRef (copy), useMotion (copy), UserInputService (copy), default (copy), default2 (copy), useIsUsingGamepad (copy), defaultTuning (copy), size (copy), v1 (copy), v2 (copy), v3 (copy), v4 (copy), v5 (copy), v6 (copy), v7 (copy), v8 (copy), v9 (copy)
        local consoleKeyCode, position, windowSec, missed = p1.consoleKeyCode, p1.position, p1.windowSec, p1.missed

        if missed == nil then
            missed = false
        end

        local caught = p1.caught

        if caught == nil then
            caught = false
        end

        local onCatch = p1.onCatch
        local v10, v11 = useMotion(100)
        local v12 = useIsUsingGamepad()
        local v13 = useRef(onCatch)

        v13.current = onCatch
        useEffect(function() -- line: 51
            -- upvalues: windowSec (copy), v11 (copy)
            v11:tween(0, {
                direction = Enum.EasingDirection.In,
                style = Enum.EasingStyle.Linear,
                time = math.max(windowSec - 0.1, 0.1)
            })
        end, { v11, windowSec })
        useEffect(function() -- line: 58
            -- upvalues: consoleKeyCode (copy), v13 (copy), UserInputService (copy)
            local connection = UserInputService.InputBegan:Connect(function(p2, p3) -- line: 59
                -- upvalues: consoleKeyCode (copy), v13 (copy)
                if p3 or p2.KeyCode ~= consoleKeyCode then
                    return nil
                end

                v13.current()
            end)

            return function() -- line: 68
                -- upvalues: connection (copy)
                return connection:Disconnect()
            end
        end, { consoleKeyCode })

        local v15 = caught or missed
        local v16, v17, v18

        if caught then
            v16 = v7
            v17 = v8
            v18 = "NICE!"
        else
            v16 = if missed then v5 else v3
            v17 = if missed then v6 else v4
            v18 = if missed then "MISS!" else "CATCH"
        end

        return react.createElement("frame", {
            Active = false,
            BackgroundTransparency = 1,
            ZIndex = 960,
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = position,
            Size = UDim2.fromOffset(v1, v1)
        }, not v15 and react.createElement(default, {
            direction = "Left",
            missingPartType = "TransAndColor",
            starterPoint = "Up",
            transOfMissingPart = 1,
            transOfPercentPart = 0,
            zIndex = 961,
            anchorPoint = Vector2.new(0.5, 0.5),
            colorOfMissingPart = Color3.fromRGB(0, 0, 0),
            colorOfPercentPart = v9,
            position = UDim2.fromScale(0.5, 0.5),
            progress = v10,
            size = UDim2.fromScale(1.35, 1.35)
        }), react.createElement("frame", {
            Active = false,
            BackgroundTransparency = 0.1,
            BorderSizePixel = 0,
            ZIndex = 962,
            AnchorPoint = Vector2.new(0.5, 0.5),
            BackgroundColor3 = v16,
            Position = UDim2.fromScale(0.5, 0.5),
            Size = UDim2.fromOffset(size, size)
        }, react.createElement("uicorner", {
            CornerRadius = UDim.new(0.5, 0)
        }), react.createElement("uistroke", {
            Color = v17,
            Thickness = defaultTuning.innerBorderWidth
        }), react.createElement("textlabel", {
            BackgroundTransparency = 1,
            TextScaled = true,
            ZIndex = 963,
            AnchorPoint = Vector2.new(0.5, 0.5),
            Font = Enum.Font.FredokaOne,
            Position = UDim2.fromScale(0.5, 0.5),
            Size = UDim2.fromScale(0.85, 0.4),
            Text = v18,
            TextColor3 = Color3.fromRGB(255, 255, 255)
        }, react.createElement("uistroke", {
            Thickness = 2,
            Color = v17
        }))), not v15 and react.createElement("textbutton", {
            BackgroundTransparency = 1,
            Text = "",
            ZIndex = 965,
            AnchorPoint = Vector2.new(0.5, 0.5),
            Event = {
                Activated = onCatch
            },
            Position = UDim2.fromScale(0.5, 0.5),
            Size = UDim2.fromOffset(v2, v2)
        }, react.createElement("uicorner", {
            CornerRadius = UDim.new(0.5, 0)
        })), v12 and not v15 and react.createElement(default2, {
            keyCode = consoleKeyCode,
            radius = v1 / 2,
            size = size * 0.4
        }))
    end
}
