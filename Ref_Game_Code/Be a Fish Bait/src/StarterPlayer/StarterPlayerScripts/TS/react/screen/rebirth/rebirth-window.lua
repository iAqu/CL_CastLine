-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local useEffect = react.useEffect
local useMotion = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "pretty-react-hooks", "out").useMotion
local GuiService = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services").GuiService
local default = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "brainrot-style", "br-window").default
local default2 = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "brainrot-style", "br-frame").default
local default3 = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "brainrot-style", "shiny-overlay").default
local default4 = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "brainrot-style", "popout-text-two").default
local default5 = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "brainrot-style", "popout-text-button").default
local useRootSelector = RuntimeLib.import(script, script.Parent.Parent.Parent, "hooks", "reflex").useRootSelector
local useTheme = RuntimeLib.import(script, script.Parent.Parent.Parent, "hooks", "use-theme").useTheme
local localPlayerUserId = RuntimeLib.import(script, script.Parent.Parent.Parent.Parent, "utils").localPlayerUserId
local selectors = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "slices", "player-data", "selectors")
local selectPlayerStat, selectPlayerRebirthCount = selectors.selectPlayerStat, selectors.selectPlayerRebirthCount
local images = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "images").images
local v1 = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "data", "rebirth-utils")
local getRebirthEntry, formatMultiplier, isMaxRebirth = v1.getRebirthEntry, v1.formatMultiplier, v1.isMaxRebirth
local abbreviate = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "abbreviate").abbreviate
local v2 = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(220, 40, 40)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(180, 20, 20)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(220, 40, 40))
})
local v3 = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(80, 220, 50)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(20, 175, 20))
})
local v4 = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(171, 171, 171)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(148, 148, 148))
})
local v5 = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(180, 70, 220)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(120, 30, 170))
})
local v6 = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 120, 0)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(200, 60, 0))
})
local v7 = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(220, 40, 40)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(160, 10, 10))
})
local v8 = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(74, 207, 46)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(20, 175, 20))
})
local v9 = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 220, 40)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(230, 170, 0))
})
local v10 = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(80, 255, 120)),
    ColorSequenceKeypoint.new(0.35, Color3.fromRGB(120, 255, 80)),
    ColorSequenceKeypoint.new(0.7, Color3.fromRGB(255, 230, 60)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(80, 220, 255))
})
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
        delay = 0.08,
        drift = -0.07,
        size = 18,
        spin = -420,
        startX = 0.14,
        color = Color3.fromRGB(255, 210, 50)
    },
    {
        delay = 0.04,
        drift = 0.09,
        size = 24,
        spin = 600,
        startX = 0.23,
        color = Color3.fromRGB(80, 255, 120)
    },
    {
        delay = 0.16,
        drift = -0.05,
        size = 20,
        spin = -360,
        startX = 0.32,
        color = Color3.fromRGB(70, 190, 255)
    },
    {
        delay = 0.06,
        drift = 0.07,
        size = 16,
        spin = 480,
        startX = 0.41,
        color = Color3.fromRGB(210, 100, 255)
    },
    {
        delay = 0.12,
        drift = -0.08,
        size = 26,
        spin = -540,
        startX = 0.5,
        color = Color3.fromRGB(255, 150, 40)
    },
    {
        delay = 0.02,
        drift = 0.05,
        size = 22,
        spin = 420,
        startX = 0.59,
        color = Color3.fromRGB(110, 255, 210)
    },
    {
        delay = 0.18,
        drift = -0.06,
        size = 18,
        spin = -600,
        startX = 0.68,
        color = Color3.fromRGB(255, 95, 210)
    },
    {
        delay = 0.1,
        drift = 0.08,
        size = 20,
        spin = 360,
        startX = 0.77,
        color = Color3.fromRGB(150, 255, 75)
    },
    {
        delay = 0.14,
        drift = -0.09,
        size = 24,
        spin = -480,
        startX = 0.86,
        color = Color3.fromRGB(255, 245, 120)
    },
    {
        delay = 0.2,
        drift = 0.06,
        size = 16,
        spin = 540,
        startX = 0.95,
        color = Color3.fromRGB(70, 120, 255)
    },
    {
        delay = 0.24,
        drift = -0.07,
        size = 22,
        spin = -420,
        startX = 0.08,
        color = Color3.fromRGB(240, 90, 130)
    }
}
local t2 = {
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

local function RebirthSuccessCelebration(p1) -- line: 219
    -- upvalues: react (copy), useEffect (copy), useMotion (copy), GuiService (copy), default4 (copy), v10 (copy), t1 (copy), t2 (copy)
    local onDone = p1.onDone
    local v11, v12 = useMotion(0)
    local v13, v14 = useMotion(0)

    useEffect(function() -- line: 223
        -- upvalues: onDone (copy), v12 (copy), v14 (copy)
        v12:linear(1, {
            speed = 0.35714285714285715
        })
        v14:spring(1, {
            damping = 0.45,
            frequency = 0.55
        })

        local v15 = task.delay(2.8, function() -- line: 231
            -- upvalues: onDone (copy)
            return onDone()
        end)

        return function() -- line: 234
            -- upvalues: v15 (copy)
            return task.cancel(v15)
        end
    end, { onDone, v12, v14 })

    local function v16(p2) -- line: 238
        -- upvalues: v11 (copy), react (copy), t2 (copy)
        local v17 = table.create(#t2)

        local function v18(p3, p4) -- line: 241
            -- upvalues: p2 (copy), v11 (copy), react (copy)
            local v19 = if p2 == "left" then 1 else -1
            local v20 = if p2 == "left" then -0.08 else 1.08
            local v21 = if p2 == "left" then p3.endX else 1 - p3.endX
            local v22 = v11:map(function(p5) -- line: 245
                -- upvalues: p3 (copy), v21 (copy), v20 (copy)
                local v24 = math.clamp((p5 - p3.delay) / 0.58, 0, 1)
                local v26 = 1 - math.pow(1 - v24, 3)
                local v28 = math.sin(v24 * 3.141592653589793) * 0.18

                return UDim2.fromScale(v20 + (v21 - v20) * v26, 0.62 + (p3.endY - 0.62) * v26 - v28)
            end)
            local v29 = v11:map(function(p6) -- line: 251
                -- upvalues: p3 (copy)
                if math.clamp((p6 - p3.delay) / 0.58, 0, 1) >= 0.98 then
                    return 1
                end

                return 0
            end)

            return react.createElement("frame", {
                BorderSizePixel = 0,
                ZIndex = 200,
                AnchorPoint = Vector2.new(0.5, 0.5),
                BackgroundColor3 = p3.color,
                BackgroundTransparency = v29,
                Position = v22,
                Rotation = v11:map(function(p7) -- line: 261
                    -- upvalues: p4 (copy), v19 (copy)
                    return v19 * (p7 * 720 + p4 * 28)
                end),
                Size = UDim2.fromOffset(p3.size, (math.max(6, p3.size * 0.55))),
                key = ("%*-%*"):format(p2, p4)
            }, react.createElement("uicorner", {
                CornerRadius = UDim.new(0, 3)
            }))
        end

        for v32, v33 in t2 do
            v17[v32] = v18(v33, v32 - 1, t2)
        end

        return v17
    end

    local v34 = v11:map(function(p8) -- line: 277
        if p8 > 0.78 then
            return (p8 - 0.78) / 0.22
        end

        return 0
    end)
    local v35 = table.create(#t1)

    local function v36(p9, p10) -- line: 282
        -- upvalues: v11 (copy), react (copy)
        local v37 = v11:map(function(p11) -- line: 283
            -- upvalues: p9 (copy)
            local v39 = math.clamp((p11 - p9.delay) / (1 - p9.delay), 0, 1)
            local v40 = v39 * v39
            local v42 = math.sin(v39 * 3.141592653589793 * 2) * p9.drift * 0.4

            return UDim2.fromScale(p9.startX + p9.drift * v40 + v42, v40 * 1.3 + -0.1)
        end)

        return react.createElement("frame", {
            BorderSizePixel = 0,
            ZIndex = 195,
            AnchorPoint = Vector2.new(0.5, 0.5),
            BackgroundColor3 = p9.color,
            BackgroundTransparency = v11:map(function(p12) -- line: 292
                -- upvalues: p9 (copy)
                local v44 = math.clamp((p12 - p9.delay) / (1 - p9.delay), 0, 1)

                if v44 > 0.85 then
                    return (v44 - 0.85) / 0.15
                end

                return 0
            end),
            Position = v37,
            Rotation = v11:map(function(p13) -- line: 298
                -- upvalues: p9 (copy)
                return p13 * p9.spin
            end),
            Size = UDim2.fromOffset(p9.size, (math.max(6, p9.size * 0.55))),
            key = ("top-%*"):format(p10)
        }, react.createElement("uicorner", {
            CornerRadius = UDim.new(0, 3)
        }))
    end

    for v46, v47 in t1 do
        v35[v46] = v36(v47, v46 - 1, t1)
    end

    local left = v16("left")
    local right = v16("right")
    local t5 = {
        anchorPoint = Vector2.new(0.5, 0.5),
        color = v10
    }

    t5.overrideProps = {
        TextScaled = true,
        ZIndex = 210,
        Size = v13:map(function(p14) -- line: 321
            return UDim2.fromScale(0.55 * p14, 0.09 * p14)
        end),
        TextTransparency = v34,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromScale(0.5, 0.13) + UDim2.fromOffset(0, GuiService:GetGuiInset().Y)
    }
    t5.strokeProps = {
        Thickness = 0.08
    }
    t5.text = "You have rebirthed!"

    return react.createElement("frame", {
        Active = false,
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ZIndex = 190,
        Size = UDim2.fromScale(1, 1)
    }, v35, left, right, react.createElement(default4, t5))
end

local function RebirthCard(p15) -- line: 346
    -- upvalues: react (copy), default2 (copy), default3 (copy), default4 (copy), images (copy), formatMultiplier (copy), v6 (copy)
    local label, multiplier, theme, zBase = p15.label, p15.multiplier, p15.theme, p15.zBase

    return react.createElement("frame", {
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Size = UDim2.fromScale(1, 0.8),
        ZIndex = zBase
    }, react.createElement(default4, {
        color = Color3.new(1, 1, 1),
        overrideProps = {
            TextScaled = true,
            Font = theme.textFont2,
            Size = UDim2.fromScale(1, 0.2),
            TextXAlignment = Enum.TextXAlignment.Center,
            ZIndex = zBase,
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.fromScale(0.5, 0.35)
        },
        text = label
    }), react.createElement(default2, {
        cornerRadius = 0.04,
        isStudded = true,
        strokeThickness = 0.05,
        transparency = 0,
        anchorPoint = Vector2.new(0.5, 1),
        backgroundColor = v6,
        position = UDim2.fromScale(0.5, 1),
        size = UDim2.fromScale(1, 0.5),
        strokeColor = Color3.fromRGB(71, 48, 26),
        zIndex = zBase + 1
    }, react.createElement(default3, {
        zIndex = zBase + 2
    }), react.createElement("imagelabel", {
        BackgroundTransparency = 1,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Image = images.strongArmIcon,
        Position = UDim2.fromScale(0.025, 0.5),
        ScaleType = Enum.ScaleType.Fit,
        Size = UDim2.fromScale(1, 1),
        ZIndex = zBase + 4
    }, react.createElement("uiaspectratioconstraint", {
        AspectRatio = 1
    })), react.createElement(default4, {
        color = Color3.new(1, 1, 1),
        overrideProps = {
            TextScaled = true,
            TextWrapped = false,
            Font = theme.textFont2,
            Size = UDim2.fromScale(0.8, 0.8),
            TextXAlignment = Enum.TextXAlignment.Center,
            ZIndex = zBase + 2,
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.fromScale(0.575, 0.5)
        },
        text = if multiplier == nil then "-" else ("%* Power"):format((formatMultiplier(multiplier)))
    })))
end

return {
    rebirthTextDelaySec = 0.25,
    RebirthSuccessCelebration = RebirthSuccessCelebration,
    default = function(p16) -- RebirthWindow | line: 406
        -- upvalues: react (copy), default (copy), default2 (copy), default3 (copy), default4 (copy), default5 (copy), useRootSelector (copy), useTheme (copy), localPlayerUserId (copy), selectPlayerStat (copy), selectPlayerRebirthCount (copy), images (copy), getRebirthEntry (copy), isMaxRebirth (copy), abbreviate (copy), v2 (copy), v3 (copy), v4 (copy), v5 (copy), v6 (copy), v7 (copy), v8 (copy), v9 (copy), RebirthCard (copy)
        local v51 = useTheme()
        local v52 = useRootSelector(selectPlayerStat(localPlayerUserId, "power"))

        if v52 == nil then
            v52 = 0
        end

        local v53 = useRootSelector(selectPlayerRebirthCount(localPlayerUserId))
        local v54 = isMaxRebirth(v53)
        local v55 = getRebirthEntry(v53)
        local v56 = getRebirthEntry(v53 + 1)
        local powerCost = v55.powerCost
        local v57 = not v54 and powerCost <= v52
        local v58 = if v54 then 1 else math.min(v52 / powerCost, 1)
        local v60 = if v57 then v3 else v4
        local v61 = if v57 then Color3.fromRGB(10, 120, 10) else Color3.fromRGB(40, 40, 40)
        local v62 = if v54 then v7 elseif v57 then v8 else v6
        local v63 = react.createElement("frame", {
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            ZIndex = 21,
            AnchorPoint = Vector2.new(0, 0.5),
            Position = UDim2.fromScale(0.04, 0.5),
            Size = UDim2.fromScale(0.83, 0.72)
        }, react.createElement("uilistlayout", {
            FillDirection = Enum.FillDirection.Horizontal,
            HorizontalAlignment = Enum.HorizontalAlignment.Left,
            Padding = UDim.new(0.01, 0),
            SortOrder = Enum.SortOrder.LayoutOrder,
            VerticalAlignment = Enum.VerticalAlignment.Center
        }), react.createElement("frame", {
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            LayoutOrder = 1,
            ZIndex = 21,
            Size = UDim2.fromScale(0.55, 1)
        }, react.createElement(default4, {
            text = "Rebirth:",
            color = Color3.new(1, 1, 1),
            overrideProps = {
                TextScaled = true,
                ZIndex = 21,
                Font = v51.textFont2,
                Size = UDim2.fromScale(1, 1),
                TextXAlignment = Enum.TextXAlignment.Left
            }
        })), react.createElement("frame", {
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            LayoutOrder = 2,
            ZIndex = 21,
            Size = UDim2.fromScale(0.4, 1)
        }, react.createElement(default4, {
            color = v9,
            overrideProps = {
                TextScaled = true,
                ZIndex = 21,
                Font = v51.textFont2,
                Size = UDim2.fromScale(1, 1),
                TextXAlignment = Enum.TextXAlignment.Left,
                AnchorPoint = Vector2.new(0.5, 0.5),
                Position = UDim2.fromScale(-0.08, 0.525)
            },
            text = tostring(v53)
        })))
        local createElement = react.createElement
        local t10 = {
            aspectRatio = 1.35,
            title = "Rebirth:",
            bodyBg = Color3.fromRGB(0, 0, 0),
            headerBg = v2,
            headerNode = v63,
            onClose = p16.onClose,
            size = UDim2.fromScale(0.55, 0.6)
        }
        local createElement2 = react.createElement
        local t11 = {
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            ZIndex = 3,
            AnchorPoint = Vector2.new(0.5, 0),
            Position = UDim2.fromScale(0.5, 0.115),
            Size = UDim2.fromScale(0.8, 0.28)
        }
        local v64 = react.createElement("uilistlayout", {
            FillDirection = Enum.FillDirection.Horizontal,
            HorizontalAlignment = Enum.HorizontalAlignment.Center,
            Padding = UDim.new(0.01, 0),
            SortOrder = Enum.SortOrder.LayoutOrder,
            VerticalAlignment = Enum.VerticalAlignment.Center
        })
        local v65 = react.createElement("frame", {
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            LayoutOrder = 1,
            ZIndex = 3,
            Size = UDim2.fromScale(0.4, 1)
        }, react.createElement(RebirthCard, {
            zBase = 3,
            label = ("Rebirth %*"):format(v53),
            multiplier = v55.powerMultiplier,
            theme = v51
        }))
        local v66 = react.createElement("frame", {
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            LayoutOrder = 2,
            ZIndex = 3,
            Size = UDim2.fromScale(0.18, 1)
        }, react.createElement("imagelabel", {
            BackgroundTransparency = 1,
            Rotation = 90,
            ZIndex = 3,
            AnchorPoint = Vector2.new(0.5, 0.5),
            Image = images.arrowBeam,
            Position = UDim2.fromScale(0.45, 0.6),
            ScaleType = Enum.ScaleType.Fit,
            Size = UDim2.fromScale(0.6, 0.6)
        }, react.createElement("uiaspectratioconstraint", {
            AspectRatio = 1
        })))
        local createElement3 = react.createElement
        local t12 = {
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            LayoutOrder = 3,
            ZIndex = 3,
            Size = UDim2.fromScale(0.4, 1)
        }
        local createElement4 = react.createElement
        local t13 = {
            zBase = 3
        }

        if v54 then
            t13.label = "-"
            t13.multiplier = nil
        else
            t13.label = `Rebirth { v53 + 1 }`
            t13.multiplier = v56.powerMultiplier
        end

        t13.theme = v51

        local v67 = createElement2("frame", t11, v64, v65, v66, createElement3("frame", t12, createElement4(RebirthCard, t13)))
        local v68 = react.createElement(default4, {
            text = "Rebirth only resets power!",
            anchorPoint = Vector2.new(0.5, 0.5),
            color = Color3.fromRGB(255, 80, 80),
            overrideProps = {
                TextScaled = true,
                ZIndex = 3,
                Font = v51.textFont,
                Size = UDim2.fromScale(0.9, 0.08),
                TextXAlignment = Enum.TextXAlignment.Center
            },
            position = UDim2.fromScale(0.5, 0.45),
            strokeProps = {
                Thickness = 0.07,
                Color = Color3.fromRGB(107, 0, 0),
                StrokeSizingMode = Enum.StrokeSizingMode.ScaledSize
            }
        })
        local v70 = react.createElement(default2, {
            clipsDescendants = false,
            cornerRadius = 0.025,
            isStudded = true,
            isStuddedTransparency = 0.4,
            strokeThickness = 0.06,
            textureTransparency = 0.8,
            transparency = 0,
            zIndex = 3,
            anchorPoint = Vector2.new(0.5, 0),
            backgroundColor = Color3.fromRGB(0, 0, 0),
            position = UDim2.fromScale(0.5, 0.545),
            size = UDim2.fromScale(0.88, 0.12),
            strokeColor = Color3.fromRGB(217, 122, 0)
        }, react.createElement(default2, {
            cornerRadius = 0.025,
            isStudded = true,
            transparency = 0,
            zIndex = 4,
            anchorPoint = Vector2.new(0, 0.5),
            backgroundColor = v62,
            position = UDim2.fromScale(0, 0.5),
            size = UDim2.new(v58, 0, 1, 0)
        }, react.createElement(default3, {
            zIndex = 5
        })), react.createElement(default4, {
            color = Color3.new(1, 1, 1),
            overrideProps = {
                TextScaled = true,
                ZIndex = 6,
                TextWrapped = false,
                Font = v51.textFont2,
                Size = UDim2.fromScale(0.9, 0.75),
                TextXAlignment = Enum.TextXAlignment.Center,
                AnchorPoint = Vector2.new(0.5, 0.5),
                Position = UDim2.fromScale(0.5, 0.5)
            },
            text = if v54 then "MAX REBIRTH REACHED" else ("Power: %*/%*"):format(abbreviate((math.min(v52, powerCost))), (abbreviate(powerCost)))
        }))
        local createElement7 = react.createElement
        local t16 = {
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            ZIndex = 3,
            AnchorPoint = Vector2.new(0.5, 1),
            Position = UDim2.fromScale(0.5, 0.93),
            Size = UDim2.fromScale(0.88, 0.21)
        }
        local v71 = react.createElement("uilistlayout", {
            FillDirection = Enum.FillDirection.Horizontal,
            HorizontalAlignment = Enum.HorizontalAlignment.Center,
            Padding = UDim.new(0.04, 0),
            SortOrder = Enum.SortOrder.LayoutOrder,
            VerticalAlignment = Enum.VerticalAlignment.Bottom
        })
        local v72 = react.createElement(default5, {
            layoutOrder = 1,
            zIndex = 4,
            color = v60,
            frameSize = UDim2.fromScale(0.41, 0.78),
            label = v54 and "Maxed!" or "Rebirth!",
            onClick = function() -- onClick | line: 604
                -- upvalues: p16 (copy), v57 (copy)
                if v57 then
                    p16.onRebirth()
                else
                    local onRebirthFailed = p16.onRebirthFailed

                    if onRebirthFailed ~= nil then
                        onRebirthFailed()
                    end
                end
            end,
            popoutColor = v61
        }, react.createElement(default4, {
            anchorPoint = Vector2.new(0.5, 0.5),
            color = Color3.new(1, 1, 1),
            overrideProps = {
                TextScaled = true,
                ZIndex = 8,
                AnchorPoint = Vector2.new(0.5, 0.5),
                Position = UDim2.fromScale(0.5, 0.475),
                Size = UDim2.fromScale(0.9, 0.7)
            },
            popoutColor = if v57 then Color3.new(0, 0, 0) else Color3.new(0.35, 0.35, 0.35),
            position = UDim2.fromScale(0.5, 0.475),
            strokeProps = {
                Thickness = 0.05,
                Color = if v57 then Color3.new(0, 0, 0) else Color3.new(0.43, 0.43, 0.43)
            },
            text = if v54 then "Maxed!" elseif v57 then "Rebirth!" else "Rebirth"
        }))
        local v73 = not v54

        v73 = v73 and react.createElement("frame", {
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            LayoutOrder = 2,
            ZIndex = 4,
            Size = UDim2.fromScale(0.41, 0.78)
        }, react.createElement(default5, {
            label = "Skip Rebirth",
            zIndex = 4,
            color = v5,
            frameSize = UDim2.fromScale(1, 1),
            onClick = p16.onSkipRebirth,
            popoutColor = Color3.fromRGB(80, 20, 130),
            position = UDim2.fromScale(0.5, 0.5)
        }, react.createElement("frame", {
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            ZIndex = 8,
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.fromScale(0.5, 0.5),
            Size = UDim2.fromScale(0.9, 0.62)
        }, react.createElement(default4, {
            text = "Skip Rebirth",
            anchorPoint = Vector2.new(0.5, 0.5),
            color = Color3.new(1, 1, 1),
            overrideProps = {
                TextScaled = true,
                ZIndex = 9,
                AnchorPoint = Vector2.new(0.5, 0.5),
                Position = UDim2.fromScale(0.5, 0.5),
                Size = UDim2.fromScale(1, 1),
                TextXAlignment = Enum.TextXAlignment.Center
            },
            popoutColor = Color3.new(0.34, 0.02, 0.36),
            strokeProps = {
                Color = Color3.new(0.34, 0.02, 0.36)
            }
        }))), react.createElement("frame", {
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            ZIndex = 12,
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.fromScale(0.5, 0.03),
            Size = UDim2.fromScale(0.66, 0.42)
        }, react.createElement("uilistlayout", {
            FillDirection = Enum.FillDirection.Horizontal,
            HorizontalAlignment = Enum.HorizontalAlignment.Center,
            Padding = UDim.new(0.035, 0),
            VerticalAlignment = Enum.VerticalAlignment.Center
        }), react.createElement("imagelabel", {
            BackgroundTransparency = 1,
            LayoutOrder = 1,
            ZIndex = 13,
            Image = images.robuxIcon,
            ScaleType = Enum.ScaleType.Fit,
            Size = UDim2.fromScale(0.36, 1)
        }, react.createElement("uiaspectratioconstraint", {
            AspectRatio = 1
        })), react.createElement(default4, {
            color = Color3.fromRGB(80, 230, 95),
            overrideProps = {
                TextScaled = true,
                ZIndex = 13,
                Font = v51.textFont2,
                Size = UDim2.fromScale(0.48, 1),
                TextXAlignment = Enum.TextXAlignment.Left
            },
            strokeProps = {
                Thickness = 0.06
            },
            text = tostring(p16.skipRobuxPrice)
        })))

        return createElement(default, t10, v67, v68, v70, createElement7("frame", t16, v71, v72, v73))
    end
}
