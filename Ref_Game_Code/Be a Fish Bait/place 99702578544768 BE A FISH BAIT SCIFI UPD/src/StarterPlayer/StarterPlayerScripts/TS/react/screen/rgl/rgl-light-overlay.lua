-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local useEffect, useState = react.useEffect, react.useState
local subscribe = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "charm").subscribe
local useMotion = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "pretty-react-hooks", "out").useMotion
local default = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "brainrot-style", "br-frame").default
local default2 = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "styled-text-label").default
local useTheme = RuntimeLib.import(script, script.Parent.Parent.Parent, "hooks", "use-theme").useTheme
local rglLightPresentationAtom = RuntimeLib.import(script, script.Parent.Parent.Parent.Parent, "rgl-light-presentation-atom").rglLightPresentationAtom
local rglConfig = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "rgl-config").rglConfig

local function RglLightDisplay(p1) -- line: 14
    -- upvalues: react (copy), useEffect (copy), useState (copy), useMotion (copy), default (copy), default2 (copy), useTheme (copy), rglConfig (copy)
    local presentation = p1.presentation
    local v1 = useTheme()
    local v2, v3 = useMotion(rglConfig.lightIndicatorEntranceScale)
    local v4, v5 = useMotion(0)
    local v6, v7 = useState(true)
    local v8, v9, v10, v11

    if presentation.light == "green" then
        v9 = rglConfig.greenLightFillColor
        v10 = rglConfig.greenLightStrokeColor
        v8 = rglConfig.greenLightFlashColor
        v11 = rglConfig.greenLightText
    else
        v9 = rglConfig.redLightFillColor
        v10 = rglConfig.redLightStrokeColor
        v8 = rglConfig.redLightFlashColor
        v11 = rglConfig.redLightText
    end

    useEffect(function() -- line: 25
        -- upvalues: v3 (copy), v5 (copy), v7 (copy), rglConfig (copy)
        v3:immediate(rglConfig.lightIndicatorEntranceScale)
        v3:tween(1, {
            direction = Enum.EasingDirection.Out,
            style = Enum.EasingStyle.Back,
            time = rglConfig.lightIndicatorEntranceSeconds
        })
        v5:immediate(0)
        v5:tween(rglConfig.lightFlashPeakOpacity, {
            direction = Enum.EasingDirection.Out,
            style = Enum.EasingStyle.Quad,
            time = rglConfig.lightFlashFadeInSeconds
        })

        local v12 = task.delay(rglConfig.lightFlashFadeInSeconds + rglConfig.lightFlashHoldSeconds, function() -- line: 38
            -- upvalues: v5 (copy), rglConfig (copy)
            v5:tween(0, {
                direction = Enum.EasingDirection.Out,
                style = Enum.EasingStyle.Quad,
                time = rglConfig.lightFlashFadeOutSeconds
            })
        end)
        local v13 = task.delay(rglConfig.lightFlashFadeInSeconds + rglConfig.lightFlashHoldSeconds + rglConfig.lightFlashFadeOutSeconds, function() -- line: 45
            -- upvalues: v7 (copy)
            return v7(false)
        end)

        return function() -- line: 48
            -- upvalues: v12 (copy), v13 (copy)
            task.cancel(v12)
            task.cancel(v13)
        end
    end, { v5, v3 })

    local createElement, Fragment = react.createElement, react.Fragment

    v6 = v6 and react.createElement("frame", {
        BorderSizePixel = 0,
        BackgroundColor3 = v8,
        BackgroundTransparency = v4:map(function(p2) -- line: 55
            return 1 - p2
        end),
        Size = UDim2.fromScale(1, 1),
        ZIndex = rglConfig.lightFlashZIndex
    })

    return createElement(Fragment, nil, v6, react.createElement(default, {
        anchorPoint = Vector2.new(0.5, 0.5),
        backgroundColor = v9,
        cornerRadius = rglConfig.lightIndicatorCornerRadius,
        position = UDim2.fromScale(rglConfig.lightIndicatorPosition.X, rglConfig.lightIndicatorPosition.Y),
        size = UDim2.fromScale(rglConfig.lightIndicatorSize.X, rglConfig.lightIndicatorSize.Y),
        strokeColor = v10,
        strokeThickness = rglConfig.lightIndicatorStrokeThickness,
        zIndex = rglConfig.lightIndicatorZIndex
    }, react.createElement("uiscale", {
        Scale = v2
    }), react.createElement(default2, {
        overrideProps = {
            TextScaled = true,
            Font = v1.textFont2,
            Size = UDim2.fromScale(1, 0.72),
            Position = UDim2.fromScale(0, 0.14),
            ZIndex = rglConfig.lightIndicatorZIndex + 1
        },
        strokeProps = {
            Color = rglConfig.lightIndicatorTextStrokeColor,
            StrokeSizingMode = Enum.StrokeSizingMode.ScaledSize,
            Thickness = rglConfig.lightIndicatorTextStrokeThickness
        },
        text = v11,
        textColor3 = rglConfig.lightIndicatorTextColor
    })))
end

return {
    RglLightDisplay = RglLightDisplay,
    default = function() -- RglLightOverlay | line: 89
        -- upvalues: react (copy), useEffect (copy), useState (copy), subscribe (copy), rglLightPresentationAtom (copy), RglLightDisplay (copy)
        local v14, v15 = useState(rglLightPresentationAtom())

        useEffect(function() -- line: 91
            -- upvalues: v15 (copy), subscribe (copy), rglLightPresentationAtom (copy)
            return subscribe(rglLightPresentationAtom, v15)
        end, {})

        if v14 then
            return (react.createElement(RglLightDisplay, {
                key = v14.sequence,
                presentation = v14
            }))
        end

        return (react.createElement(react.Fragment))
    end
}
