-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local images = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "images").images
local t1 = {
    {
        arcHeight = 0.48,
        fallDistance = 0.12,
        horizontalDistance = 0.3,
        originX = 0.28,
        originY = 0.62,
        phase = 0,
        rotationSpeed = 260,
        sparkle = false,
        wobble = 0.035,
        xDirection = -1,
        color = Color3.fromRGB(255, 235, 70)
    },
    {
        arcHeight = 0.36,
        fallDistance = 0.08,
        horizontalDistance = 0.24,
        originX = 0.42,
        originY = 0.52,
        phase = 0.13,
        rotationSpeed = 190,
        sparkle = true,
        wobble = 0.055,
        xDirection = 1,
        color = Color3.fromRGB(255, 65, 195)
    },
    {
        arcHeight = 0.58,
        fallDistance = 0.16,
        horizontalDistance = 0.38,
        originX = 0.58,
        originY = 0.68,
        phase = 0.26,
        rotationSpeed = 340,
        sparkle = false,
        wobble = 0.025,
        xDirection = 1,
        color = Color3.fromRGB(70, 240, 255)
    },
    {
        arcHeight = 0.4,
        fallDistance = 0.1,
        horizontalDistance = 0.28,
        originX = 0.7,
        originY = 0.48,
        phase = 0.39,
        rotationSpeed = 220,
        sparkle = true,
        wobble = 0.045,
        xDirection = -1,
        color = Color3.fromRGB(190, 95, 255)
    },
    {
        arcHeight = 0.52,
        fallDistance = 0.18,
        horizontalDistance = 0.34,
        originX = 0.34,
        originY = 0.72,
        phase = 0.52,
        rotationSpeed = 390,
        sparkle = false,
        wobble = 0.06,
        xDirection = 1,
        color = Color3.fromRGB(255, 255, 235)
    },
    {
        arcHeight = 0.32,
        fallDistance = 0.07,
        horizontalDistance = 0.22,
        originX = 0.62,
        originY = 0.56,
        phase = 0.65,
        rotationSpeed = 170,
        sparkle = true,
        wobble = 0.03,
        xDirection = 1,
        color = Color3.fromRGB(255, 170, 55)
    },
    {
        arcHeight = 0.6,
        fallDistance = 0.14,
        horizontalDistance = 0.4,
        originX = 0.5,
        originY = 0.66,
        phase = 0.78,
        rotationSpeed = 420,
        sparkle = false,
        wobble = 0.04,
        xDirection = -1,
        color = Color3.fromRGB(255, 80, 145)
    },
    {
        arcHeight = 0.44,
        fallDistance = 0.09,
        horizontalDistance = 0.26,
        originX = 0.76,
        originY = 0.6,
        phase = 0.91,
        rotationSpeed = 300,
        sparkle = false,
        wobble = 0.05,
        xDirection = 1,
        color = Color3.fromRGB(90, 255, 135)
    }
}

return {
    default = function(p1) -- OgPrimeTitleEffects | line: 103
        -- upvalues: react (copy), images (copy), t1 (copy)
        local animationProgress, zIndex = p1.animationProgress, p1.zIndex
        local v1 = zIndex

        if zIndex == nil then
            v1 = 8
        end

        local v2 = table.create(#t1)

        local function v3(p2, p3) -- line: 111
            -- upvalues: animationProgress (copy), v1 (ref), react (copy), images (copy)
            local v4 = animationProgress:map(function(p4) -- line: 112
                -- upvalues: p2 (copy)
                return (p4 / 360 + p2.phase) % 1
            end)
            local v5 = v4:map(function(p5) -- line: 115
                -- upvalues: p2 (copy)
                local v7 = math.sin(p5 * 3.141592653589793)
                local v9 = math.sin(p5 * 3.141592653589793 * 2 + p2.phase * 3.141592653589793 * 2) * p2.wobble

                return UDim2.fromScale(p2.originX + p2.xDirection * p5 * p2.horizontalDistance + v9, p2.originY - v7 * p2.arcHeight + p5 * p2.fallDistance)
            end)
            local v10 = v4:map(function(p6) -- line: 120
                -- upvalues: p2 (copy)
                return p6 * p2.rotationSpeed * p2.xDirection
            end)
            local v11 = v4:map(function(p7) -- line: 123
                return (math.clamp(math.abs(p7 - 0.5) * 0.9 + 0.04, 0.04, 0.56))
            end)

            if p2.sparkle then
                return (react.createElement("imagelabel", {
                    BackgroundTransparency = 1,
                    AnchorPoint = Vector2.new(0.5, 0.5),
                    Image = images.sparkleIcon,
                    ImageColor3 = p2.color,
                    ImageTransparency = v11,
                    key = ("og-prime-sparkle-%*"):format(p3),
                    Position = v5,
                    Rotation = v10,
                    ScaleType = Enum.ScaleType.Fit,
                    Size = UDim2.fromScale(0.065, 0.28),
                    ZIndex = v1
                }))
            end

            return (react.createElement("frame", {
                BorderSizePixel = 0,
                AnchorPoint = Vector2.new(0.5, 0.5),
                BackgroundColor3 = p2.color,
                BackgroundTransparency = v11,
                key = ("og-prime-confetti-%*"):format(p3),
                Position = v5,
                Rotation = v10,
                Size = UDim2.fromScale(0.026, 0.14),
                ZIndex = v1
            }, react.createElement("uicorner", {
                CornerRadius = UDim.new(0.25, 0)
            }), react.createElement("uistroke", {
                Thickness = 1,
                Transparency = 0.15,
                Color = Color3.new(1, 1, 1)
            })))
        end

        for v14, v15 in t1 do
            v2[v14] = v3(v15, v14 - 1, t1)
        end

        return react.createElement("frame", {
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            Size = UDim2.fromScale(1, 1),
            ZIndex = v1
        }, v2)
    end
}
