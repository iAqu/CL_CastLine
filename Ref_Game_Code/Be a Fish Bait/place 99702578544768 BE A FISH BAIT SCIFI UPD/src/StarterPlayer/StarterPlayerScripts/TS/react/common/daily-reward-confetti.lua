-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local useEffect, useState = react.useEffect, react.useState
local useMotion = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "pretty-react-hooks", "out").useMotion
local subscribe = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "charm").subscribe
local dailyRewardConfettiTriggerAtom = RuntimeLib.import(script, script.Parent.Parent.Parent, "daily-reward-confetti-atom").dailyRewardConfettiTriggerAtom
local t1 = {
    {
        delay = 0,
        drift = 0.06,
        size = 22,
        spin = 540,
        startX = 0.05,
        color = Color3.fromRGB(255, 60, 80)
    },
    {
        delay = 0.1,
        drift = -0.07,
        size = 16,
        spin = -420,
        startX = 0.13,
        color = Color3.fromRGB(255, 210, 50)
    },
    {
        delay = 0.04,
        drift = 0.09,
        size = 26,
        spin = 600,
        startX = 0.21,
        color = Color3.fromRGB(80, 255, 120)
    },
    {
        delay = 0.18,
        drift = -0.05,
        size = 18,
        spin = -360,
        startX = 0.29,
        color = Color3.fromRGB(70, 190, 255)
    },
    {
        delay = 0.08,
        drift = 0.07,
        size = 24,
        spin = 480,
        startX = 0.37,
        color = Color3.fromRGB(210, 100, 255)
    },
    {
        delay = 0.14,
        drift = -0.08,
        size = 20,
        spin = -540,
        startX = 0.45,
        color = Color3.fromRGB(255, 150, 40)
    },
    {
        delay = 0.02,
        drift = 0.05,
        size = 28,
        spin = 420,
        startX = 0.53,
        color = Color3.fromRGB(110, 255, 210)
    },
    {
        delay = 0.22,
        drift = -0.06,
        size = 22,
        spin = -600,
        startX = 0.61,
        color = Color3.fromRGB(255, 95, 210)
    },
    {
        delay = 0.06,
        drift = 0.08,
        size = 18,
        spin = 360,
        startX = 0.69,
        color = Color3.fromRGB(150, 255, 75)
    },
    {
        delay = 0.16,
        drift = -0.09,
        size = 24,
        spin = -480,
        startX = 0.77,
        color = Color3.fromRGB(255, 245, 120)
    },
    {
        delay = 0.12,
        drift = 0.06,
        size = 20,
        spin = 540,
        startX = 0.85,
        color = Color3.fromRGB(70, 120, 255)
    },
    {
        delay = 0.2,
        drift = -0.07,
        size = 26,
        spin = -420,
        startX = 0.93,
        color = Color3.fromRGB(240, 90, 130)
    },
    {
        delay = 0.26,
        drift = 0.08,
        size = 18,
        spin = 480,
        startX = 0.09,
        color = Color3.fromRGB(255, 60, 80)
    },
    {
        delay = 0.32,
        drift = -0.05,
        size = 22,
        spin = -360,
        startX = 0.17,
        color = Color3.fromRGB(80, 255, 120)
    },
    {
        delay = 0.28,
        drift = 0.1,
        size = 16,
        spin = 600,
        startX = 0.25,
        color = Color3.fromRGB(255, 210, 50)
    },
    {
        delay = 0.36,
        drift = -0.08,
        size = 24,
        spin = -540,
        startX = 0.33,
        color = Color3.fromRGB(210, 100, 255)
    },
    {
        delay = 0.24,
        drift = 0.07,
        size = 20,
        spin = 420,
        startX = 0.41,
        color = Color3.fromRGB(70, 190, 255)
    },
    {
        delay = 0.4,
        drift = -0.06,
        size = 28,
        spin = -480,
        startX = 0.49,
        color = Color3.fromRGB(255, 150, 40)
    },
    {
        delay = 0.3,
        drift = 0.05,
        size = 18,
        spin = 540,
        startX = 0.57,
        color = Color3.fromRGB(110, 255, 210)
    },
    {
        delay = 0.44,
        drift = -0.09,
        size = 22,
        spin = -420,
        startX = 0.65,
        color = Color3.fromRGB(150, 255, 75)
    },
    {
        delay = 0.34,
        drift = 0.08,
        size = 26,
        spin = 600,
        startX = 0.73,
        color = Color3.fromRGB(255, 245, 120)
    },
    {
        delay = 0.48,
        drift = -0.07,
        size = 16,
        spin = -360,
        startX = 0.81,
        color = Color3.fromRGB(240, 90, 130)
    },
    {
        delay = 0.38,
        drift = 0.06,
        size = 20,
        spin = 480,
        startX = 0.89,
        color = Color3.fromRGB(255, 60, 80)
    },
    {
        delay = 0.52,
        drift = -0.05,
        size = 24,
        spin = -540,
        startX = 0.97,
        color = Color3.fromRGB(70, 120, 255)
    },
    {
        delay = 0.42,
        drift = 0.09,
        size = 18,
        spin = 420,
        startX = 0.03,
        color = Color3.fromRGB(80, 255, 120)
    },
    {
        delay = 0.56,
        drift = -0.08,
        size = 22,
        spin = -600,
        startX = 0.19,
        color = Color3.fromRGB(255, 95, 210)
    },
    {
        delay = 0.46,
        drift = 0.07,
        size = 26,
        spin = 540,
        startX = 0.35,
        color = Color3.fromRGB(255, 210, 50)
    },
    {
        delay = 0.6,
        drift = -0.06,
        size = 20,
        spin = -420,
        startX = 0.51,
        color = Color3.fromRGB(210, 100, 255)
    },
    {
        delay = 0.5,
        drift = 0.08,
        size = 16,
        spin = 480,
        startX = 0.67,
        color = Color3.fromRGB(70, 190, 255)
    },
    {
        delay = 0.64,
        drift = -0.1,
        size = 24,
        spin = -360,
        startX = 0.83,
        color = Color3.fromRGB(255, 150, 40)
    },
    {
        delay = 0.54,
        drift = 0.05,
        size = 28,
        spin = 600,
        startX = 0.11,
        color = Color3.fromRGB(110, 255, 210)
    },
    {
        delay = 0.68,
        drift = -0.07,
        size = 18,
        spin = -540,
        startX = 0.27,
        color = Color3.fromRGB(150, 255, 75)
    },
    {
        delay = 0.58,
        drift = 0.09,
        size = 22,
        spin = 420,
        startX = 0.43,
        color = Color3.fromRGB(240, 90, 130)
    },
    {
        delay = 0.72,
        drift = -0.06,
        size = 20,
        spin = -480,
        startX = 0.59,
        color = Color3.fromRGB(255, 60, 80)
    },
    {
        delay = 0.62,
        drift = 0.07,
        size = 26,
        spin = 540,
        startX = 0.75,
        color = Color3.fromRGB(70, 120, 255)
    },
    {
        delay = 0.76,
        drift = -0.08,
        size = 16,
        spin = -420,
        startX = 0.91,
        color = Color3.fromRGB(255, 245, 120)
    }
}

return {
    default = function(p1) -- DailyRewardConfetti | line: 273
        -- upvalues: react (copy), useEffect (copy), useState (copy), useMotion (copy), subscribe (copy), dailyRewardConfettiTriggerAtom (copy), t1 (copy)
        local zIndex = p1.zIndex
        local v1 = zIndex

        if zIndex == nil then
            v1 = 200
        end

        local v2, v3 = useState(0)
        local v4, v5 = useMotion(0)

        useEffect(function() -- line: 280
            -- upvalues: v3 (copy), subscribe (copy), dailyRewardConfettiTriggerAtom (copy)
            return subscribe(dailyRewardConfettiTriggerAtom, function(p2) -- line: 281
                -- upvalues: v3 (copy)
                if p2 == 0 then
                    return nil
                end

                v3(p2)
            end)
        end, {})
        useEffect(function() -- line: 288
            -- upvalues: v2 (copy), v5 (copy)
            if v2 == 0 then
                return nil
            end

            v5:immediate(0)
            v5:linear(1, {
                speed = 0.625
            })
        end, { v2, v5 })

        if v2 == 0 then
            return nil
        end

        local v6 = table.create(#t1)

        local function v7(p3, p4) -- line: 302
            -- upvalues: v1 (ref), v4 (copy), react (copy)
            local v8 = v4:map(function(p5) -- line: 303
                -- upvalues: p3 (copy)
                local v10 = math.clamp((p5 - p3.delay) / (1 - p3.delay), 0, 1)
                local v11 = v10 * v10
                local v13 = math.sin(v10 * 3.141592653589793 * 2) * p3.drift * 0.4

                return UDim2.fromScale(p3.startX + p3.drift * v11 + v13, v11 * 1.4 + -0.15)
            end)

            return react.createElement("frame", {
                BorderSizePixel = 0,
                AnchorPoint = Vector2.new(0.5, 0.5),
                BackgroundColor3 = p3.color,
                BackgroundTransparency = v4:map(function(p6) -- line: 312
                    -- upvalues: p3 (copy)
                    local v15 = math.clamp((p6 - p3.delay) / (1 - p3.delay), 0, 1)

                    if v15 > 0.85 then
                        return (v15 - 0.85) / 0.15
                    end

                    return 0
                end),
                Position = v8,
                Rotation = v4:map(function(p7) -- line: 318
                    -- upvalues: p3 (copy)
                    return p7 * p3.spin
                end),
                Size = UDim2.fromOffset(p3.size, (math.max(6, p3.size * 0.55))),
                ZIndex = v1,
                key = ("%*"):format(p4)
            }, react.createElement("uicorner", {
                CornerRadius = UDim.new(0, 3)
            }))
        end

        for v17, v18 in t1 do
            v6[v17] = v7(v18, v17 - 1, t1)
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
