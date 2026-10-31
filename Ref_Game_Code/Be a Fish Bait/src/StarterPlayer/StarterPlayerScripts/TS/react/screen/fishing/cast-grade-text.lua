-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local useEffect = react.useEffect
local useMotion = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "pretty-react-hooks", "out").useMotion
local default = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "brainrot-style", "popout-text-two").default
local useTheme = RuntimeLib.import(script, script.Parent.Parent.Parent, "hooks", "use-theme").useTheme
local useSound = RuntimeLib.import(script, script.Parent.Parent.Parent, "hooks", "use-sound").useSound
local perfectCastStrengthThreshold = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "fishing-hook-utils").perfectCastStrengthThreshold

local function getGradeFromStrength(p1) -- line: 11
    -- upvalues: perfectCastStrengthThreshold (copy)
    if perfectCastStrengthThreshold <= p1 then
        return "perfect"
    end

    if p1 >= 85 then
        return "excellent"
    end

    if p1 >= 70 then
        return "great"
    end

    if p1 >= 50 then
        return "good"
    end

    return "poor"
end

local v1 = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 60, 60)),
    ColorSequenceKeypoint.new(0.17, Color3.fromRGB(255, 60, 60)),
    ColorSequenceKeypoint.new(0.314, Color3.fromRGB(255, 165, 0)),
    ColorSequenceKeypoint.new(0.458, Color3.fromRGB(255, 240, 0)),
    ColorSequenceKeypoint.new(0.602, Color3.fromRGB(0, 210, 60)),
    ColorSequenceKeypoint.new(0.746, Color3.fromRGB(0, 120, 255)),
    ColorSequenceKeypoint.new(0.89, Color3.fromRGB(180, 0, 220)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(180, 0, 220))
})
local v2 = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 130, 210)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(220, 50, 160))
})
local v3 = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 208, 42)),
    ColorSequenceKeypoint.new(0.393782, Color3.fromRGB(123, 255, 87)),
    ColorSequenceKeypoint.new(0.571675, Color3.fromRGB(148, 255, 152)),
    ColorSequenceKeypoint.new(0.80829, Color3.fromRGB(23, 255, 31)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(26, 255, 0))
})
local v4 = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(100, 255, 70)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(40, 200, 30))
})
local v5 = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(190, 190, 190)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(115, 115, 115))
})
local t1 = {
    perfect = {
        text = "PERFECT!",
        baseW = 0.35,
        baseH = 0.09,
        strokeThickness = 0.1
    },
    excellent = {
        text = "EXCELLENT!",
        baseW = 0.32,
        baseH = 0.085,
        strokeThickness = 0.095
    },
    great = {
        text = "GREAT!",
        baseW = 0.28,
        baseH = 0.08,
        strokeThickness = 0.09
    },
    good = {
        text = "GOOD",
        baseW = 0.22,
        baseH = 0.075,
        strokeThickness = 0.085
    },
    poor = {
        text = "POOR",
        baseW = 0.18,
        baseH = 0.065,
        strokeThickness = 0.075
    }
}
local t2 = {
    excellent = v2,
    good = v4,
    great = v3,
    perfect = v1,
    poor = v5
}

return {
    getGradeFromStrength = getGradeFromStrength,
    default = function(p2) -- CastGradeText | line: 71
        -- upvalues: react (copy), useEffect (copy), useMotion (copy), default (copy), useTheme (copy), useSound (copy), t1 (copy), t2 (copy)
        local grade, position = p2.grade, p2.position

        if position == nil then
            position = UDim2.fromScale(0.5, 0.2)
        end

        local v6 = useTheme()
        local v7, v8 = useMotion(1)
        local playSound = useSound("WowAnime").playSound
        local playSound2 = useSound("Fahhh").playSound

        useEffect(function() -- line: 83
            -- upvalues: grade (copy), playSound (copy), playSound2 (copy)
            if grade == "perfect" then
                playSound()
            elseif grade == "poor" then
                playSound2()
            end
        end, { grade, playSound, playSound2 })
        useEffect(function() -- line: 90
            -- upvalues: grade (copy), v8 (copy)
            if grade ~= "perfect" and grade ~= "excellent" and grade ~= "great" then
                return nil
            end

            v8:tween(if grade == "perfect" then 1.5 elseif grade == "excellent" then 1.4 else 1.3, {
                time = 0.075,
                style = Enum.EasingStyle.Quad,
                direction = Enum.EasingDirection.Out
            })

            local v10 = task.delay(0.075, function() -- line: 102
                -- upvalues: v8 (copy)
                v8:tween(1, {
                    time = 0.175,
                    style = Enum.EasingStyle.Quad,
                    direction = Enum.EasingDirection.Out
                })
            end)

            return function() -- line: 109
                -- upvalues: v10 (copy)
                return task.cancel(v10)
            end
        end, { grade, v8 })

        local v11 = t1[grade]
        local v12 = v7:map(function(p3) -- line: 114
            -- upvalues: v11 (copy)
            return UDim2.fromScale(v11.baseW * p3, v11.baseH * p3)
        end)
        local t3 = {
            perfect = 0,
            excellent = 90,
            great = 90,
            good = 90,
            poor = 90
        }

        return react.createElement(default, {
            anchorPoint = Vector2.new(0.5, 0.5),
            color = t2[grade],
            gradientRotation = t3[grade],
            overrideProps = {
                TextScaled = true,
                ZIndex = 3,
                Font = v6.textFont,
                Size = v12
            },
            position = position,
            strokeProps = {
                Thickness = v11.strokeThickness
            },
            text = v11.text
        })
    end,
    gradeConfigs = t1,
    castGradeGradients = t2
}
