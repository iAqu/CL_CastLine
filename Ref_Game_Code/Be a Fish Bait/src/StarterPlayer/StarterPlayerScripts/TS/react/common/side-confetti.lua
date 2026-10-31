-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local useEffect = react.useEffect
local useMotion = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "pretty-react-hooks", "out").useMotion
local t1 = {
    {
        delay = 0,
        endX = 0.26,
        endY = 0.2,
        size = 28,
        color = Color3.fromRGB(255, 60, 80)
    },
    {
        delay = 0.02,
        endX = 0.18,
        endY = 0.31,
        size = 18,
        color = Color3.fromRGB(255, 150, 40)
    },
    {
        delay = 0.04,
        endX = 0.36,
        endY = 0.34,
        size = 22,
        color = Color3.fromRGB(255, 210, 50)
    },
    {
        delay = 0.06,
        endX = 0.46,
        endY = 0.23,
        size = 16,
        color = Color3.fromRGB(255, 245, 120)
    },
    {
        delay = 0.08,
        endX = 0.31,
        endY = 0.55,
        size = 32,
        color = Color3.fromRGB(80, 255, 120)
    },
    {
        delay = 0.1,
        endX = 0.22,
        endY = 0.66,
        size = 24,
        color = Color3.fromRGB(110, 255, 210)
    },
    {
        delay = 0.12,
        endX = 0.42,
        endY = 0.68,
        size = 26,
        color = Color3.fromRGB(70, 190, 255)
    },
    {
        delay = 0.14,
        endX = 0.52,
        endY = 0.48,
        size = 20,
        color = Color3.fromRGB(70, 120, 255)
    },
    {
        delay = 0.16,
        endX = 0.2,
        endY = 0.45,
        size = 20,
        color = Color3.fromRGB(210, 100, 255)
    },
    {
        delay = 0.18,
        endX = 0.34,
        endY = 0.78,
        size = 27,
        color = Color3.fromRGB(255, 95, 210)
    },
    {
        delay = 0.2,
        endX = 0.38,
        endY = 0.16,
        size = 27,
        color = Color3.fromRGB(255, 120, 40)
    },
    {
        delay = 0.22,
        endX = 0.48,
        endY = 0.6,
        size = 15,
        color = Color3.fromRGB(255, 255, 255)
    },
    {
        delay = 0.24,
        endX = 0.14,
        endY = 0.18,
        size = 22,
        color = Color3.fromRGB(150, 255, 75)
    },
    {
        delay = 0.26,
        endX = 0.28,
        endY = 0.82,
        size = 16,
        color = Color3.fromRGB(120, 230, 255)
    },
    {
        delay = 0.28,
        endX = 0.55,
        endY = 0.32,
        size = 24,
        color = Color3.fromRGB(240, 90, 130)
    },
    {
        delay = 0.3,
        endX = 0.44,
        endY = 0.84,
        size = 18,
        color = Color3.fromRGB(255, 225, 80)
    },
    {
        delay = 0.05,
        endX = 0.4,
        endY = 0.5,
        size = 26,
        color = Color3.fromRGB(255, 60, 80)
    },
    {
        delay = 0.09,
        endX = 0.16,
        endY = 0.4,
        size = 19,
        color = Color3.fromRGB(80, 255, 120)
    },
    {
        delay = 0.13,
        endX = 0.5,
        endY = 0.74,
        size = 23,
        color = Color3.fromRGB(70, 190, 255)
    },
    {
        delay = 0.17,
        endX = 0.24,
        endY = 0.28,
        size = 21,
        color = Color3.fromRGB(255, 210, 50)
    },
    {
        delay = 0.21,
        endX = 0.46,
        endY = 0.42,
        size = 25,
        color = Color3.fromRGB(210, 100, 255)
    },
    {
        delay = 0.25,
        endX = 0.3,
        endY = 0.66,
        size = 18,
        color = Color3.fromRGB(255, 95, 210)
    },
    {
        delay = 0.29,
        endX = 0.52,
        endY = 0.22,
        size = 22,
        color = Color3.fromRGB(150, 255, 75)
    },
    {
        delay = 0.33,
        endX = 0.2,
        endY = 0.6,
        size = 20,
        color = Color3.fromRGB(255, 150, 40)
    },
    {
        delay = 0.07,
        endX = 0.42,
        endY = 0.26,
        size = 24,
        color = Color3.fromRGB(110, 255, 210)
    },
    {
        delay = 0.11,
        endX = 0.34,
        endY = 0.88,
        size = 21,
        color = Color3.fromRGB(70, 120, 255)
    },
    {
        delay = 0.15,
        endX = 0.12,
        endY = 0.52,
        size = 16,
        color = Color3.fromRGB(255, 245, 120)
    },
    {
        delay = 0.19,
        endX = 0.48,
        endY = 0.36,
        size = 26,
        color = Color3.fromRGB(240, 90, 130)
    }
}

return {
    default = function(p1) -- SideConfetti | line: 179
        -- upvalues: react (copy), useEffect (copy), useMotion (copy), t1 (copy)
        local active, zIndex = p1.active, p1.zIndex
        local v1 = zIndex

        if zIndex == nil then
            v1 = 60
        end

        local v2, v3 = useMotion(0)

        useEffect(function() -- line: 186
            -- upvalues: active (copy), v3 (copy)
            if active then
                v3:immediate(0)
                v3:linear(1, {
                    speed = 0.425531914893617
                })
            else
                v3:immediate(0)
            end
        end, { active, v3 })

        if not active then
            return nil
        end

        local function v4(p2) -- line: 199
            -- upvalues: v1 (ref), v2 (copy), react (copy), t1 (copy)
            local v5 = table.create(#t1)

            local function v6(p3, p4) -- line: 202
                -- upvalues: p2 (copy), v1 (ref), v2 (copy), react (copy)
                local v7 = if p2 == "left" then 1 else -1
                local v8 = if p2 == "left" then -0.08 else 1.08
                local v9 = if p2 == "left" then p3.endX else 1 - p3.endX
                local v10 = v2:map(function(p5) -- line: 206
                    -- upvalues: p3 (copy), v9 (copy), v8 (copy)
                    local v12 = math.clamp((p5 - p3.delay) / 0.58, 0, 1)
                    local v14 = 1 - math.pow(1 - v12, 3)
                    local v16 = math.sin(v12 * 3.141592653589793) * 0.18

                    return UDim2.fromScale(v8 + (v9 - v8) * v14, 0.62 + (p3.endY - 0.62) * v14 - v16)
                end)

                return react.createElement("frame", {
                    BorderSizePixel = 0,
                    AnchorPoint = Vector2.new(0.5, 0.5),
                    BackgroundColor3 = p3.color,
                    BackgroundTransparency = v2:map(function(p6) -- line: 215
                        -- upvalues: p3 (copy)
                        if math.clamp((p6 - p3.delay) / 0.58, 0, 1) >= 0.98 then
                            return 1
                        end

                        return 0
                    end),
                    Position = v10,
                    Rotation = v2:map(function(p7) -- line: 221
                        -- upvalues: p4 (copy), v7 (copy)
                        return v7 * (p7 * 720 + p4 * 28)
                    end),
                    Size = UDim2.fromOffset(p3.size, (math.max(6, p3.size * 0.55))),
                    ZIndex = v1,
                    key = ("%*-%*"):format(p2, p4)
                }, react.createElement("uicorner", {
                    CornerRadius = UDim.new(0, 3)
                }))
            end

            for v19, v20 in t1 do
                v5[v19] = v6(v20, v19 - 1, t1)
            end

            return v5
        end

        return react.createElement("frame", {
            Active = false,
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            Position = UDim2.fromScale(0, 0),
            Size = UDim2.fromScale(1, 1),
            ZIndex = v1
        }, v4("left"), (v4("right")))
    end
}
