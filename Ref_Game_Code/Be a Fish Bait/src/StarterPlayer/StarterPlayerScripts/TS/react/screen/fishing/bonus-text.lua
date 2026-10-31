-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local useEffect = react.useEffect
local useMotion = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "pretty-react-hooks", "out").useMotion
local default = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "brainrot-style", "popout-text-two").default
local useTheme = RuntimeLib.import(script, script.Parent.Parent.Parent, "hooks", "use-theme").useTheme
local t1 = {
    "BONUS",
    "⭐ BONUS x2 ⭐",
    "🌟 BONUS x3 🌟",
    "JACKPOT"
}
local t2 = {
    {
        baseH = 0.0375,
        baseW = 0.11,
        bounceChance = 0.2,
        bounceDuration = 0.43,
        bouncePeak = 1.22,
        normalDuration = 0.95,
        normalPeak = 1.07,
        pauseDuration = 0.55,
        strokeThickness = 0.075
    },
    {
        baseH = 0.044,
        baseW = 0.15,
        bounceChance = 0.25,
        bounceDuration = 0.38,
        bouncePeak = 1.3,
        normalDuration = 0.8,
        normalPeak = 1.11,
        pauseDuration = 0.44,
        strokeThickness = 0.09
    },
    {
        baseH = 0.0525,
        baseW = 0.2,
        bounceChance = 0.3,
        bounceDuration = 0.32,
        bouncePeak = 1.38,
        normalDuration = 0.65,
        normalPeak = 1.16,
        pauseDuration = 0.33,
        strokeThickness = 0.105
    },
    {
        baseH = 0.065,
        baseW = 0.26,
        bounceChance = 0.35,
        bounceDuration = 0.26,
        bouncePeak = 1.5,
        normalDuration = 0.5,
        normalPeak = 1.24,
        pauseDuration = 0.22,
        strokeThickness = 0.12
    }
}

return {
    default = function(p1) -- BonusText | line: 53
        -- upvalues: react (copy), useEffect (copy), useMotion (copy), default (copy), useTheme (copy), t1 (copy), t2 (copy)
        local animated = p1.animated
        local v1 = animated

        if animated == nil then
            v1 = true
        end

        local level, position = p1.level, p1.position

        if position == nil then
            position = UDim2.fromScale(0.5, 0.85)
        end

        local v2 = useTheme()
        local v3, v4 = useMotion(1)

        useEffect(function() -- line: 65
            -- upvalues: v1 (ref), level (copy), v4 (copy), t2 (copy)
            if level == 0 or not v1 then
                return nil
            end

            v4:set(1)

            local v5 = true
            local v6 = t2[level]
            local v7 = task.spawn(function() -- line: 72
                -- upvalues: v5 (ref), v6 (copy), v4 (copy)
                while v5 do
                    local v8, v9

                    if math.random() < v6.bounceChance then
                        v9 = v6.bouncePeak
                        v8 = v6.bounceDuration
                    else
                        v9 = v6.normalPeak
                        v8 = v6.normalDuration
                    end

                    local v10 = v8 * 0.3
                    local v11 = v8 * 0.7

                    v4:tween(v9, {
                        time = v10,
                        style = Enum.EasingStyle.Quad,
                        direction = Enum.EasingDirection.Out
                    })
                    task.wait(v10)

                    if v5 then
                        v4:tween(1, {
                            time = v11,
                            style = Enum.EasingStyle.Quad,
                            direction = Enum.EasingDirection.Out
                        })
                        task.wait(v11 + v6.pauseDuration)
                        continue
                    end

                    break
                end
            end)

            return function() -- line: 96
                -- upvalues: v5 (ref), v7 (copy)
                v5 = false
                task.cancel(v7)
            end
        end, { v1, level, v4 })

        if level == 0 then
            return nil
        end

        local v12 = t2[level]
        local t3 = {
            v2.colorSequences.yellowGradient,
            v2.colorSequences.orangeGradient,
            v2.colorSequences.redGradient,
            v2.colorSequences.blueGradient
        }
        local v13 = if v1 then 1 else 0.7
        local v14 = v12.baseW * v13
        local v15 = v12.baseH * v13
        local v16 = v3:map(function(p2) -- line: 109
            -- upvalues: v14 (copy), v15 (copy)
            return UDim2.fromScale(v14 * p2, v15 * p2)
        end)

        return react.createElement(default, {
            anchorPoint = Vector2.new(0.5, 0.5),
            color = t3[level],
            overrideProps = {
                TextScaled = true,
                ZIndex = 3,
                Font = v2.textFont,
                Size = v16
            },
            position = position,
            strokeProps = {
                Thickness = v12.strokeThickness
            },
            text = t1[level]
        })
    end
}
