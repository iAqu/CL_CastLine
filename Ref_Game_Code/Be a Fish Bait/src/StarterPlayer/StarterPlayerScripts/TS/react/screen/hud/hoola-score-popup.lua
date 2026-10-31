-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local useBinding, useEffect, useRef = react.useBinding, react.useEffect, react.useRef
local useMotion = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "pretty-react-hooks", "out").useMotion
local default = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "brainrot-style", "popout-text-two").default
local flightGateFXConfig = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "flight-gate-fx-config").flightGateFXConfig

local function HoolaScorePopup(p1) -- line: 12
    -- upvalues: react (copy), useBinding (copy), useEffect (copy), useRef (copy), useMotion (copy), default (copy), flightGateFXConfig (copy)
    local onComplete, score, x, y = p1.onComplete, p1.score, p1.x, p1.y
    local rotation = p1.rotation
    local scorePopupVFX = flightGateFXConfig.scorePopupVFX
    local v1, v2 = useMotion(0)
    local v3, v4 = useMotion(1)
    local v5 = useBinding(rotation)
    local v6 = useRef(onComplete)

    v6.current = onComplete
    useEffect(function() -- line: 24
        -- upvalues: scorePopupVFX (copy), v2 (copy), v4 (copy), v6 (copy)
        local impact = scorePopupVFX.impact
        local totalDurationSeconds = impact.totalDurationSeconds
        local v7 = totalDurationSeconds * impact.movement.startFraction
        local v8 = totalDurationSeconds * (impact.movement.endFraction - impact.movement.startFraction)
        local v9 = totalDurationSeconds * impact.punch.startFraction
        local v10 = totalDurationSeconds * (impact.punch.endFraction - impact.punch.startFraction)
        local v11 = v10 * impact.punch.undershootFraction
        local v12 = v10 * impact.punch.overshootFraction
        local v13 = v10 * impact.punch.settleFraction
        local t1 = {}

        table.insert(t1, (task.delay(v7, function() -- line: 35
            -- upvalues: v8 (copy), v2 (copy)
            v2:tween(1, {
                time = v8,
                style = Enum.EasingStyle.Quad,
                direction = Enum.EasingDirection.Out
            })
        end)))
        table.insert(t1, (task.delay(v9, function() -- line: 43
            -- upvalues: impact (copy), v11 (copy), v12 (copy), v13 (copy), t1 (copy), v4 (copy)
            v4:tween(impact.punch.undershootScale, {
                time = v11,
                style = Enum.EasingStyle.Quad,
                direction = Enum.EasingDirection.In
            })
            table.insert(t1, (task.delay(v11, function() -- line: 49
                -- upvalues: impact (copy), v12 (copy), v4 (copy)
                v4:tween(impact.punch.overshootScale, {
                    time = v12,
                    style = Enum.EasingStyle.Linear
                })
            end)))
            table.insert(t1, (task.delay(v11 + v12, function() -- line: 56
                -- upvalues: v13 (copy), v4 (copy)
                v4:tween(1, {
                    time = v13,
                    style = Enum.EasingStyle.Quad,
                    direction = Enum.EasingDirection.Out
                })
            end)))
        end)))

        local v18 = task.delay(totalDurationSeconds, function() -- line: 66
            -- upvalues: v6 (copy)
            return v6.current()
        end)

        return function() -- line: 69
            -- upvalues: t1 (copy), v18 (copy)
            local function v19(p2) -- line: 71
                return task.cancel(p2)
            end

            for v20, v21 in t1 do
                local _ = v20 - 1

                task.cancel(v21)
            end

            task.cancel(v18)
        end
    end, {
        scorePopupVFX.impact,
        v6,
        v2,
        v4
    })

    local fade = scorePopupVFX.impact.fade
    local v22 = v1:map(function(p3) -- line: 82
        -- upvalues: fade (copy)
        return (math.clamp((p3 - fade.startFraction) / math.max(fade.endFraction - fade.startFraction, 0.001), 0, 1))
    end)

    return react.createElement("frame", {
        BackgroundTransparency = 1,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = v1:map(function(p4) -- line: 89
            -- upvalues: x (copy), y (copy), scorePopupVFX (copy)
            return UDim2.fromScale(x, y - scorePopupVFX.impact.movement.riseDistance * p4)
        end),
        Rotation = v5,
        Size = UDim2.fromScale(scorePopupVFX.size.X, scorePopupVFX.size.Y),
        ZIndex = scorePopupVFX.zIndex
    }, react.createElement("uiscale", {
        Scale = v3
    }), react.createElement(default, {
        color = scorePopupVFX.color,
        overrideProps = {
            TextScaled = true,
            Font = Enum.Font.GothamBlack,
            Size = UDim2.fromScale(1, 1),
            TextXAlignment = Enum.TextXAlignment.Center,
            ZIndex = scorePopupVFX.zIndex
        },
        popoutColor = scorePopupVFX.popoutColor,
        strokeProps = {
            Color = scorePopupVFX.strokeColor,
            Thickness = scorePopupVFX.strokeThickness
        },
        text = ("+%*%*"):format(score, scorePopupVFX.labelSuffix),
        textTransparency = v22
    }))
end

return {
    HoolaScorePopup = HoolaScorePopup,
    default = HoolaScorePopup
}
