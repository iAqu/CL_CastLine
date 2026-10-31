-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local useEffect, useState = react.useEffect, react.useState
local useMotion = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "pretty-react-hooks", "out").useMotion
local subscribe = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "charm").subscribe
local images = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "images").images
local moneyConfettiTriggerAtom = RuntimeLib.import(script, script.Parent.Parent.Parent, "money-confetti-atom").moneyConfettiTriggerAtom
local t1 = {
    {
        delay = 0,
        drift = 0.08,
        size = 64,
        spin = 540,
        startX = 0.08
    },
    {
        delay = 0.12,
        drift = -0.06,
        size = 52,
        spin = -420,
        startX = 0.18
    },
    {
        delay = 0.04,
        drift = 0.1,
        size = 72,
        spin = 600,
        startX = 0.27
    },
    {
        delay = 0.2,
        drift = -0.04,
        size = 48,
        spin = -360,
        startX = 0.36
    },
    {
        delay = 0.08,
        drift = 0.05,
        size = 60,
        spin = 480,
        startX = 0.45
    },
    {
        delay = 0.16,
        drift = -0.09,
        size = 68,
        spin = -540,
        startX = 0.54
    },
    {
        delay = 0.02,
        drift = 0.07,
        size = 56,
        spin = 420,
        startX = 0.63
    },
    {
        delay = 0.24,
        drift = -0.05,
        size = 64,
        spin = -600,
        startX = 0.72
    },
    {
        delay = 0.1,
        drift = 0.09,
        size = 50,
        spin = 360,
        startX = 0.81
    },
    {
        delay = 0.18,
        drift = -0.08,
        size = 70,
        spin = -480,
        startX = 0.9
    },
    {
        delay = 0.06,
        drift = 0.04,
        size = 58,
        spin = 540,
        startX = 0.13
    },
    {
        delay = 0.22,
        drift = -0.07,
        size = 62,
        spin = -420,
        startX = 0.31
    },
    {
        delay = 0.14,
        drift = 0.06,
        size = 54,
        spin = 480,
        startX = 0.49
    },
    {
        delay = 0,
        drift = -0.1,
        size = 66,
        spin = -540,
        startX = 0.67
    },
    {
        delay = 0.2,
        drift = 0.08,
        size = 60,
        spin = 420,
        startX = 0.86
    },
    {
        delay = 0.1,
        drift = -0.06,
        size = 56,
        spin = -360,
        startX = 0.95
    },
    {
        delay = 0.3,
        drift = 0.06,
        size = 58,
        spin = 480,
        startX = 0.04
    },
    {
        delay = 0.36,
        drift = -0.08,
        size = 50,
        spin = -540,
        startX = 0.22
    },
    {
        delay = 0.28,
        drift = 0.1,
        size = 70,
        spin = 600,
        startX = 0.4
    },
    {
        delay = 0.44,
        drift = -0.05,
        size = 46,
        spin = -360,
        startX = 0.58
    },
    {
        delay = 0.32,
        drift = 0.07,
        size = 64,
        spin = 420,
        startX = 0.76
    },
    {
        delay = 0.4,
        drift = -0.09,
        size = 56,
        spin = -480,
        startX = 0.92
    },
    {
        delay = 0.26,
        drift = 0.05,
        size = 60,
        spin = 540,
        startX = 0.16
    },
    {
        delay = 0.48,
        drift = -0.07,
        size = 52,
        spin = -420,
        startX = 0.34
    },
    {
        delay = 0.34,
        drift = 0.09,
        size = 68,
        spin = 600,
        startX = 0.52
    },
    {
        delay = 0.42,
        drift = -0.04,
        size = 48,
        spin = -360,
        startX = 0.7
    },
    {
        delay = 0.3,
        drift = 0.08,
        size = 62,
        spin = 480,
        startX = 0.88
    },
    {
        delay = 0.5,
        drift = -0.1,
        size = 54,
        spin = -540,
        startX = 0.1
    },
    {
        delay = 0.38,
        drift = 0.06,
        size = 66,
        spin = 420,
        startX = 0.28
    },
    {
        delay = 0.46,
        drift = -0.06,
        size = 50,
        spin = -480,
        startX = 0.46
    },
    {
        delay = 0.52,
        drift = 0.1,
        size = 58,
        spin = 600,
        startX = 0.64
    },
    {
        delay = 0.4,
        drift = -0.08,
        size = 60,
        spin = -420,
        startX = 0.82
    },
    {
        delay = 0.56,
        drift = 0.05,
        size = 64,
        spin = 540,
        startX = 0.06
    },
    {
        delay = 0.6,
        drift = -0.07,
        size = 52,
        spin = -360,
        startX = 0.24
    },
    {
        delay = 0.54,
        drift = 0.09,
        size = 70,
        spin = 480,
        startX = 0.42
    },
    {
        delay = 0.64,
        drift = -0.05,
        size = 48,
        spin = -540,
        startX = 0.6
    },
    {
        delay = 0.58,
        drift = 0.07,
        size = 62,
        spin = 420,
        startX = 0.78
    },
    {
        delay = 0.66,
        drift = -0.09,
        size = 56,
        spin = -600,
        startX = 0.96
    }
}

return {
    default = function(p1) -- MoneyConfetti | line: 250
        -- upvalues: react (copy), useEffect (copy), useState (copy), useMotion (copy), subscribe (copy), images (copy), moneyConfettiTriggerAtom (copy), t1 (copy)
        local zIndex = p1.zIndex
        local v1 = zIndex

        if zIndex == nil then
            v1 = 200
        end

        local v2, v3 = useState(0)
        local v4, v5 = useMotion(0)

        useEffect(function() -- line: 257
            -- upvalues: v3 (copy), subscribe (copy), moneyConfettiTriggerAtom (copy)
            return subscribe(moneyConfettiTriggerAtom, function(p2) -- line: 258
                -- upvalues: v3 (copy)
                if p2 == 0 then
                    return nil
                end

                v3(p2)
            end)
        end, {})
        useEffect(function() -- line: 265
            -- upvalues: v2 (copy), v5 (copy)
            if v2 == 0 then
                return nil
            end

            v5:immediate(0)
            v5:linear(1, {
                speed = 0.7142857142857143
            })
        end, { v2, v5 })

        if v2 == 0 then
            return nil
        end

        local v6 = table.create(#t1)

        local function v7(p3, p4) -- line: 279
            -- upvalues: v1 (ref), v4 (copy), react (copy), images (copy)
            local v8 = v4:map(function(p5) -- line: 280
                -- upvalues: p3 (copy)
                local v10 = math.clamp((p5 - p3.delay) / (1 - p3.delay), 0, 1)
                local v11 = v10 * v10
                local v13 = math.sin(v10 * 3.141592653589793 * 2) * p3.drift * 0.4

                return UDim2.fromScale(p3.startX + p3.drift * v11 + v13, v11 * 1.4 + -0.15)
            end)

            return react.createElement("imagelabel", {
                BackgroundTransparency = 1,
                AnchorPoint = Vector2.new(0.5, 0.5),
                Image = images.moneyConfetti,
                ImageTransparency = v4:map(function(p6) -- line: 290
                    -- upvalues: p3 (copy)
                    local v15 = math.clamp((p6 - p3.delay) / (1 - p3.delay), 0, 1)

                    if v15 > 0.85 then
                        return (v15 - 0.85) / 0.15
                    end

                    return 0
                end),
                Position = v8,
                Rotation = v4:map(function(p7) -- line: 295
                    -- upvalues: p3 (copy)
                    return p7 * p3.spin
                end),
                ScaleType = Enum.ScaleType.Fit,
                Size = UDim2.fromOffset(p3.size, p3.size),
                ZIndex = v1,
                key = ("%*"):format(p4)
            })
        end

        for v16, v17 in t1 do
            v6[v16] = v7(v17, v16 - 1, t1)
        end

        return react.createElement("frame", {
            Active = false,
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            AnchorPoint = Vector2.new(0, 0),
            Position = UDim2.fromScale(0, 0),
            Size = UDim2.fromScale(1, 1),
            ZIndex = v1
        }, v6)
    end
}
