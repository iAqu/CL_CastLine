-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local useEffect, useState = react.useEffect, react.useState
local subscribe = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "charm").subscribe
local useMotion = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "pretty-react-hooks", "out").useMotion
local default = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "styled-text-label").default
local useTheme = RuntimeLib.import(script, script.Parent.Parent.Parent, "hooks", "use-theme").useTheme
local rglCountdownPulseAtom = RuntimeLib.import(script, script.Parent.Parent.Parent.Parent, "rgl-countdown-atom").rglCountdownPulseAtom
local rglConfig = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "rgl-config").rglConfig

local function RglCountdownDisplay(p1) -- line: 13
    -- upvalues: react (copy), useEffect (copy), useState (copy), useMotion (copy), default (copy), useTheme (copy), rglConfig (copy)
    local pulse = p1.pulse
    local v1 = useTheme()
    local v2, v3 = useState(true)
    local v4, v5 = useMotion(rglConfig.countdownInitialScale)
    local v6, v7 = useMotion(1)
    local v8 = pulse.value == "GO"

    useEffect(function() -- line: 20
        -- upvalues: v3 (copy), v5 (copy), v7 (copy), rglConfig (copy)
        v3(true)
        v5:set(rglConfig.countdownInitialScale)
        v7:set(1)
        v5:tween(rglConfig.countdownFadeInScale, {
            direction = Enum.EasingDirection.Out,
            style = Enum.EasingStyle.Back,
            time = rglConfig.countdownFadeInSeconds
        })
        v7:tween(0, {
            direction = Enum.EasingDirection.Out,
            style = Enum.EasingStyle.Quad,
            time = rglConfig.countdownFadeInSeconds
        })

        local v9 = task.delay(rglConfig.countdownFadeInSeconds, function() -- line: 34
            -- upvalues: v5 (copy), v7 (copy), rglConfig (copy)
            v5:tween(rglConfig.countdownFadeOutScale, {
                direction = Enum.EasingDirection.Out,
                style = Enum.EasingStyle.Quad,
                time = rglConfig.countdownFadeOutSeconds
            })
            v7:tween(1, {
                direction = Enum.EasingDirection.In,
                style = Enum.EasingStyle.Quad,
                time = rglConfig.countdownFadeOutSeconds
            })
        end)
        local v10 = task.delay(rglConfig.countdownFadeInSeconds + rglConfig.countdownFadeOutSeconds, function() -- line: 46
            -- upvalues: v3 (copy)
            return v3(false)
        end)

        return function() -- line: 49
            -- upvalues: v9 (copy), v10 (copy)
            task.cancel(v9)
            task.cancel(v10)
        end
    end, {
        pulse.sequence,
        v5,
        v7
    })

    if not v2 then
        return react.createElement(react.Fragment)
    end

    local createElement = react.createElement
    local t1 = {
        BackgroundTransparency = 1,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromScale(rglConfig.countdownPosition.X, rglConfig.countdownPosition.Y)
    }
    local fromScale = UDim2.fromScale
    local X = if v8 then rglConfig.countdownGoSize.X else rglConfig.countdownNumberSize.X
    local Y = if v8 then rglConfig.countdownGoSize.Y else rglConfig.countdownNumberSize.Y

    t1.Size = fromScale(X, Y)
    t1.ZIndex = rglConfig.countdownZIndex

    return createElement("frame", t1, react.createElement("uiscale", {
        Scale = v4
    }), react.createElement(default, {
        color = if v8 then rglConfig.countdownGoFillColor else rglConfig.countdownNumberFillColor,
        overrideProps = {
            TextScaled = true,
            Font = v1.textFont2,
            Size = UDim2.fromScale(1, 1),
            ZIndex = rglConfig.countdownZIndex + 1
        },
        strokeProps = {
            Color = rglConfig.countdownStrokeColor,
            StrokeSizingMode = Enum.StrokeSizingMode.ScaledSize,
            Thickness = rglConfig.countdownStrokeThickness
        },
        text = if v8 then "GO!" else pulse.value,
        textTransparency = v6
    }))
end

return {
    RglCountdownDisplay = RglCountdownDisplay,
    default = function() -- RglCountdownOverlay | line: 82
        -- upvalues: react (copy), useEffect (copy), useState (copy), subscribe (copy), rglCountdownPulseAtom (copy), RglCountdownDisplay (copy)
        local v12, v13 = useState(rglCountdownPulseAtom())

        useEffect(function() -- line: 84
            -- upvalues: v13 (copy), subscribe (copy), rglCountdownPulseAtom (copy)
            return subscribe(rglCountdownPulseAtom, v13)
        end, {})

        if v12 then
            return (react.createElement(RglCountdownDisplay, {
                pulse = v12
            }))
        end

        return (react.createElement(react.Fragment))
    end
}
