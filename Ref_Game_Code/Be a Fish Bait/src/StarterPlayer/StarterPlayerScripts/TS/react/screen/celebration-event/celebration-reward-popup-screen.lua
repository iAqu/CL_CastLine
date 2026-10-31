-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local useEffect, useState = react.useEffect, react.useState
local useMotion = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "pretty-react-hooks", "out").useMotion
local default = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "brainrot-style", "popout-text-two").default
local default2 = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "brainrot-style", "popout-text-button").default
local images = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "images").images
local t1 = {
    {
        delay = 0,
        endX = 0.26,
        endY = 0.2,
        size = 16,
        color = Color3.fromRGB(255, 60, 80)
    },
    {
        delay = 0.02,
        endX = 0.18,
        endY = 0.31,
        size = 10,
        color = Color3.fromRGB(255, 150, 40)
    },
    {
        delay = 0.04,
        endX = 0.36,
        endY = 0.34,
        size = 12,
        color = Color3.fromRGB(255, 210, 50)
    },
    {
        delay = 0.06,
        endX = 0.46,
        endY = 0.23,
        size = 9,
        color = Color3.fromRGB(255, 245, 120)
    },
    {
        delay = 0.08,
        endX = 0.31,
        endY = 0.55,
        size = 18,
        color = Color3.fromRGB(80, 255, 120)
    },
    {
        delay = 0.1,
        endX = 0.22,
        endY = 0.66,
        size = 13,
        color = Color3.fromRGB(110, 255, 210)
    },
    {
        delay = 0.12,
        endX = 0.42,
        endY = 0.68,
        size = 14,
        color = Color3.fromRGB(70, 190, 255)
    },
    {
        delay = 0.14,
        endX = 0.52,
        endY = 0.48,
        size = 11,
        color = Color3.fromRGB(70, 120, 255)
    },
    {
        delay = 0.16,
        endX = 0.2,
        endY = 0.45,
        size = 11,
        color = Color3.fromRGB(210, 100, 255)
    },
    {
        delay = 0.18,
        endX = 0.34,
        endY = 0.78,
        size = 15,
        color = Color3.fromRGB(255, 95, 210)
    },
    {
        delay = 0.2,
        endX = 0.38,
        endY = 0.16,
        size = 15,
        color = Color3.fromRGB(255, 120, 40)
    },
    {
        delay = 0.22,
        endX = 0.48,
        endY = 0.6,
        size = 8,
        color = Color3.fromRGB(255, 255, 255)
    },
    {
        delay = 0.24,
        endX = 0.14,
        endY = 0.18,
        size = 12,
        color = Color3.fromRGB(150, 255, 75)
    },
    {
        delay = 0.26,
        endX = 0.28,
        endY = 0.82,
        size = 9,
        color = Color3.fromRGB(120, 230, 255)
    },
    {
        delay = 0.28,
        endX = 0.55,
        endY = 0.32,
        size = 13,
        color = Color3.fromRGB(240, 90, 130)
    },
    {
        delay = 0.3,
        endX = 0.44,
        endY = 0.84,
        size = 10,
        color = Color3.fromRGB(255, 225, 80)
    }
}
local v1 = Color3.fromRGB(255, 232, 82)
local v2 = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(106, 250, 11)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(8, 193, 8))
})

return {
    default = function(p1) -- CelebrationRewardPopupScreen | line: 115
        -- upvalues: react (copy), useEffect (copy), useState (copy), useMotion (copy), default (copy), default2 (copy), images (copy), t1 (copy), v1 (copy), v2 (copy)
        local v3, v4 = useState(false)
        local v5, v6 = useState(false)
        local v7, v8 = useMotion(0)
        local v9, v10 = useMotion(0)
        local v11, v12 = useMotion(0)
        local zIndex = p1.zIndex

        if zIndex == nil then
            zIndex = 50
        end

        local revealDelaySec = p1.revealDelaySec

        if revealDelaySec == nil then
            revealDelaySec = 0
        end

        local ticketAmount = p1.ticketAmount

        if ticketAmount == nil then
            ticketAmount = 20
        end

        useEffect(function() -- line: 138
            -- upvalues: v12 (copy)
            v12:linear(360, {
                speed = 24
            })

            local v13 = v12:onComplete(function() -- line: 145
                -- upvalues: v12 (copy)
                v12:immediate(0)
                v12:linear(360, {
                    speed = 24
                })
            end)

            return function() -- line: 149
                -- upvalues: v13 (copy)
                return v13()
            end
        end, { v12 })
        useEffect(function() -- line: 153
            -- upvalues: v4 (copy), v6 (copy), v8 (copy), v10 (copy), revealDelaySec (ref)
            local v14 = task.delay(revealDelaySec, function() -- line: 154
                -- upvalues: v4 (copy), v8 (copy), v10 (copy)
                v4(true)
                v8:linear(1, {
                    speed = 0.425531914893617
                })
                v10:spring(1, {
                    damping = 0.45,
                    frequency = 0.55
                })
            end)
            local v15 = task.delay(revealDelaySec + 2.45, function() -- line: 166
                -- upvalues: v6 (copy)
                v6(true)
            end)

            return function() -- line: 169
                -- upvalues: v14 (copy), v15 (copy)
                task.cancel(v14)
                task.cancel(v15)
            end
        end, { v10, v8 })

        local v16 = v7:map(function(p2) -- line: 175
            -- upvalues: v3 (copy)
            if not v3 then
                return 1
            end

            if p2 < 0.12 then
                return 1 - p2 / 0.12
            end

            return 0
        end)

        local function v17(p3) -- line: 184
            -- upvalues: v7 (copy), zIndex (ref), react (copy), t1 (copy)
            local v18 = table.create(#t1)

            local function v19(p4, p5) -- line: 187
                -- upvalues: p3 (copy), v7 (copy), zIndex (ref), react (copy)
                local v20 = if p3 == "left" then 1 else -1
                local v21 = if p3 == "left" then -0.08 else 1.08
                local v22 = if p3 == "left" then p4.endX else 1 - p4.endX
                local v23 = v7:map(function(p6) -- line: 191
                    -- upvalues: p4 (copy), v22 (copy), v21 (copy)
                    local v25 = math.clamp((p6 - p4.delay) / 0.58, 0, 1)
                    local v27 = 1 - math.pow(1 - v25, 3)
                    local v29 = math.sin(v25 * 3.141592653589793) * 0.18

                    return UDim2.fromScale(v21 + (v22 - v21) * v27, 0.62 + (p4.endY - 0.62) * v27 - v29)
                end)

                return react.createElement("frame", {
                    BorderSizePixel = 0,
                    AnchorPoint = Vector2.new(0.5, 0.5),
                    BackgroundColor3 = p4.color,
                    BackgroundTransparency = v7:map(function(p7) -- line: 200
                        -- upvalues: p4 (copy)
                        if math.clamp((p7 - p4.delay) / 0.58, 0, 1) >= 0.98 then
                            return 1
                        end

                        return 0
                    end),
                    Position = v23,
                    Rotation = v7:map(function(p8) -- line: 206
                        -- upvalues: p5 (copy), v20 (copy)
                        return v20 * (p8 * 720 + p5 * 28)
                    end),
                    Size = UDim2.fromOffset(p4.size, (math.max(6, p4.size * 0.55))),
                    ZIndex = zIndex + 5,
                    key = ("%*-%*"):format(p3, p5)
                }, react.createElement("uicorner", {
                    CornerRadius = UDim.new(0, 3)
                }))
            end

            for v32, v33 in t1 do
                v18[v32] = v19(v33, v32 - 1, t1)
            end

            return v18
        end

        local createElement = react.createElement
        local t3 = {
            Active = false,
            BorderSizePixel = 0,
            Rotation = 0,
            AnchorPoint = Vector2.new(0, 0),
            BackgroundColor3 = Color3.fromRGB(0, 0, 0),
            BackgroundTransparency = v16:map(function(p9) -- line: 226
                return 0.28 + p9 * 0.72
            end),
            Position = UDim2.fromScale(0, 0),
            Size = UDim2.fromScale(1, 1),
            ZIndex = zIndex
        }

        if not v3 then
            return createElement("frame", t3, v3)
        end

        local createElement2, Fragment = react.createElement, react.Fragment
        local left = v17("left")
        local right = v17("right")
        local v35 = react.createElement(default, {
            text = "Thanks for playing!",
            anchorPoint = Vector2.new(0.5, 0.5),
            color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 80, 80)),
                ColorSequenceKeypoint.new(0.22, Color3.fromRGB(255, 230, 70)),
                ColorSequenceKeypoint.new(0.45, Color3.fromRGB(90, 255, 120)),
                ColorSequenceKeypoint.new(0.7, Color3.fromRGB(80, 190, 255)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(220, 100, 255))
            }),
            overrideProps = {
                TextScaled = true,
                Size = UDim2.fromOffset(720 * p1.uiScale, 110 * p1.uiScale),
                ZIndex = zIndex + 10
            },
            position = UDim2.fromScale(0.5, 0.125),
            strokeProps = {
                Thickness = 0.08
            }
        })
        local v36 = react.createElement("frame", {
            BackgroundTransparency = 1,
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.fromScale(0.5, 0.5),
            Size = v9:map(function(p10) -- line: 251
                -- upvalues: p1 (copy)
                return UDim2.fromScale(0.34 * p1.uiScale * p10, 0.46 * p1.uiScale * p10)
            end),
            ZIndex = zIndex + 8
        }, react.createElement("imagelabel", {
            BackgroundTransparency = 1,
            ImageTransparency = 0.18,
            AnchorPoint = Vector2.new(0.5, 0.5),
            Image = images.shineBackground,
            ImageColor3 = v1,
            Position = UDim2.fromScale(0.5, 0.44),
            Rotation = v11,
            ScaleType = Enum.ScaleType.Fit,
            Size = UDim2.fromScale(1.28, 1.28),
            ZIndex = zIndex + 7
        }, react.createElement("uiaspectratioconstraint", {
            AspectRatio = 1
        })), react.createElement("imagelabel", {
            BackgroundTransparency = 1,
            AnchorPoint = Vector2.new(0.5, 0.5),
            Image = images.celebrationTicket,
            Position = UDim2.fromScale(0.5, 0.42),
            ScaleType = Enum.ScaleType.Fit,
            Size = UDim2.fromScale(0.54, 0.54),
            ZIndex = zIndex + 9
        }), react.createElement(default, {
            anchorPoint = Vector2.new(0.5, 0.5),
            color = Color3.fromRGB(255, 255, 255),
            overrideProps = {
                TextScaled = true,
                Size = UDim2.fromScale(1.1, 0.22),
                ZIndex = zIndex + 10
            },
            position = UDim2.fromScale(0.5, 0.8),
            strokeProps = {
                Thickness = 0.08
            },
            text = ("x%* Tickets"):format(ticketAmount)
        }), react.createElement(default, {
            text = "Join the fun at Fomo party island! Enjoy the event :-)",
            anchorPoint = Vector2.new(0.5, 0.5),
            color = Color3.fromRGB(255, 255, 255),
            overrideProps = {
                TextScaled = true,
                TextWrapped = true,
                Size = UDim2.fromScale(1.7, 0.13),
                ZIndex = zIndex + 10
            },
            position = UDim2.fromScale(0.5, 1.1),
            strokeProps = {
                Thickness = 0.05
            }
        }))

        v5 = v5 and react.createElement(default2, {
            cornerRadius = 0.25,
            label = "Claim",
            shadowYScale = 0.06,
            anchorPoint = Vector2.new(0.5, 1),
            color = v2,
            frameSize = UDim2.fromScale(0.24 * p1.uiScale, 0.075 * p1.uiScale),
            onClick = function() -- onClick | line: 309
                -- upvalues: p1 (copy)
                local onClaim = p1.onClaim

                if onClaim ~= nil then
                    onClaim = onClaim()
                end

                return onClaim
            end,
            popoutColor = Color3.fromRGB(10, 120, 10),
            position = UDim2.fromScale(0.5, 0.93),
            zIndex = zIndex + 10
        })

        return createElement("frame", t3, (createElement2(Fragment, nil, left, right, v35, v36, v5)))
    end
}
