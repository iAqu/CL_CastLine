-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local useEffect, useState = react.useEffect, react.useState
local useMotion = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "pretty-react-hooks", "out").useMotion
local default = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "brainrot-style", "br-frame").default
local default2 = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "brainrot-style", "popout-text-two").default
local default3 = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "brainrot-style", "shiny-overlay").default
local default4 = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "faded-background").default
local useTheme = RuntimeLib.import(script, script.Parent.Parent.Parent, "hooks", "use-theme").useTheme
local v1 = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "daily-rewards-utils")
local getDailyRewardDisplayText, formatDurationSeconds = v1.getDailyRewardDisplayText, v1.formatDurationSeconds
local v2 = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "rarity-utils")
local getRarityBorderColor, getRarityColor = v2.getRarityBorderColor, v2.getRarityColor
local images = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "images").images
local v3 = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(38, 38, 38)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(72, 72, 72))
})
local v4 = Color3.fromRGB(50, 50, 50)
local v5 = Color3.fromRGB(0, 0, 0)
local v6 = Color3.fromRGB(78, 254, 86)
local v7 = Color3.fromRGB(0, 100, 10)
local v8 = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(240, 240, 245)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(215, 215, 225))
})
local v9 = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 245, 120)),
    ColorSequenceKeypoint.new(0.35, Color3.fromRGB(60, 255, 240)),
    ColorSequenceKeypoint.new(0.7, Color3.fromRGB(255, 90, 220)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 245, 120))
})
local v10 = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 180, 180)),
    ColorSequenceKeypoint.new(0.17, Color3.fromRGB(255, 210, 170)),
    ColorSequenceKeypoint.new(0.33, Color3.fromRGB(255, 255, 180)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(180, 255, 190)),
    ColorSequenceKeypoint.new(0.67, Color3.fromRGB(180, 210, 255)),
    ColorSequenceKeypoint.new(0.83, Color3.fromRGB(210, 180, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 180, 230))
})
local v11 = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 70, 100)),
    ColorSequenceKeypoint.new(0.17, Color3.fromRGB(255, 220, 70)),
    ColorSequenceKeypoint.new(0.34, Color3.fromRGB(80, 255, 120)),
    ColorSequenceKeypoint.new(0.51, Color3.fromRGB(80, 220, 255)),
    ColorSequenceKeypoint.new(0.68, Color3.fromRGB(120, 110, 255)),
    ColorSequenceKeypoint.new(0.85, Color3.fromRGB(255, 90, 230)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 70, 100))
})
local v12 = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 240, 80)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 200, 20))
})
local v13 = Color3.fromRGB(180, 80, 0)
local v14 = Color3.fromRGB(220, 100, 0)
local v15 = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(220, 80, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(160, 40, 220))
})
local v16 = Color3.fromRGB(80, 0, 140)

Color3.fromRGB(120, 0, 180)

local t1 = {
    {
        delay = 0,
        endX = 0.15,
        endY = -0.25,
        size = 7,
        color = Color3.fromRGB(255, 60, 80)
    },
    {
        delay = 0.03,
        endX = 0.5,
        endY = -0.3,
        size = 6,
        color = Color3.fromRGB(255, 210, 50)
    },
    {
        delay = 0.06,
        endX = 0.85,
        endY = -0.22,
        size = 8,
        color = Color3.fromRGB(80, 255, 120)
    },
    {
        delay = 0.09,
        endX = 0.25,
        endY = -0.15,
        size = 5,
        color = Color3.fromRGB(70, 190, 255)
    },
    {
        delay = 0.12,
        endX = 0.75,
        endY = -0.18,
        size = 6,
        color = Color3.fromRGB(210, 100, 255)
    },
    {
        delay = 0.05,
        endX = 0.6,
        endY = -0.28,
        size = 7,
        color = Color3.fromRGB(255, 150, 40)
    },
    {
        delay = 0.08,
        endX = 0.4,
        endY = -0.2,
        size = 5,
        color = Color3.fromRGB(255, 255, 255)
    },
    {
        delay = 0.11,
        endX = 0.9,
        endY = -0.12,
        size = 6,
        color = Color3.fromRGB(255, 95, 210)
    }
}

return {
    default = function(p1) -- DailyRewardItem | line: 86
        -- upvalues: react (copy), useEffect (copy), useState (copy), useMotion (copy), default (copy), default2 (copy), default3 (copy), default4 (copy), useTheme (copy), getDailyRewardDisplayText (copy), formatDurationSeconds (copy), getRarityBorderColor (copy), getRarityColor (copy), images (copy), v3 (copy), v4 (copy), v5 (copy), v6 (copy), v7 (copy), v8 (copy), v9 (copy), v10 (copy), v11 (copy), v12 (copy), v13 (copy), v14 (copy), v15 (copy), v16 (copy), t1 (copy)
        local dailyReward, dayNumber, isClaimable, isClaimed = p1.dailyReward, p1.dayNumber, p1.isClaimable, p1.isClaimed
        local justClaimed = p1.justClaimed
        local v17 = justClaimed

        if justClaimed == nil then
            v17 = false
        end

        local moneyPerSecond, onClaim, bottomLabelAnchor = p1.moneyPerSecond, p1.onClaim, p1.bottomLabelAnchor

        if bottomLabelAnchor == nil then
            bottomLabelAnchor = Vector2.new(0.5, 1)
        end

        local bottomLabelPosition = p1.bottomLabelPosition

        if bottomLabelPosition == nil then
            bottomLabelPosition = UDim2.fromScale(0.5, 0.98)
        end

        if p1.bottomLabelSizeScale == nil then
            Vector2.new(0.92, 0)
        end

        local claimDayIndex = p1.claimDayIndex
        local v18 = claimDayIndex

        if claimDayIndex == nil then
            v18 = dayNumber
        end

        local v19 = useTheme()
        local v20 = dailyReward.rewardId == "daily-7"
        local v21 = v20 or dailyReward.rewardId == "daily-14"
        local v22 = dailyReward.rewardType == "money"
        local v23, v24 = useMotion(0)
        local v25 = if not v22 or dailyReward.rewardMoneyDurationSeconds == nil then getDailyRewardDisplayText(dailyReward, moneyPerSecond) else formatDurationSeconds(dailyReward.rewardMoneyDurationSeconds)
        local v26 = if v22 then getDailyRewardDisplayText(dailyReward, moneyPerSecond) else nil
        local v27 = dailyReward.rewardType == "fish"
        local rewardFishRarity = dailyReward.rewardFishRarity
        local v28 = if not v27 or rewardFishRarity == nil then Color3.new(1, 1, 1) else getRarityColor(rewardFishRarity)
        local v29 = if not v27 or rewardFishRarity == nil then nil else getRarityBorderColor(rewardFishRarity)
        local v30 = if v21 then 0.1 else 0.25
        local v31, v32 = useMotion(0)
        local v33, v34 = useMotion(0)
        local v35, v36 = useMotion(1)
        local v37, v38 = useMotion(0)
        local v39, v40 = useState(false)

        useEffect(function() -- line: 131
            -- upvalues: v34 (copy)
            v34:linear(360, {
                speed = 24
            })

            local v41 = v34:onComplete(function() -- line: 138
                -- upvalues: v34 (copy)
                v34:immediate(0)
                v34:linear(360, {
                    speed = 24
                })
            end)

            return function() -- line: 142
                -- upvalues: v41 (copy)
                return v41()
            end
        end, { v34 })
        useEffect(function() -- line: 146
            -- upvalues: v24 (copy), v21 (copy)
            if not v21 then
                return nil
            end

            v24:linear(360, {
                speed = 90
            })

            local v42 = v24:onComplete(function() -- line: 156
                -- upvalues: v24 (copy)
                v24:immediate(0)
                v24:linear(360, {
                    speed = 90
                })
            end)

            return function() -- line: 160
                -- upvalues: v42 (copy)
                return v42()
            end
        end, { v21, v24 })
        useEffect(function() -- line: 164
            -- upvalues: isClaimable (copy), isClaimed (copy), v32 (copy)
            if not isClaimable or isClaimed then
                v32:immediate(0)

                return nil
            end

            local t2 = {}
            local v43

            v43 = function(p2) -- line: 172
                -- upvalues: v43 (ref), t2 (copy), v32 (copy)
                v32:tween(p2 and 5 or -5, {
                    time = 0.3,
                    style = Enum.EasingStyle.Sine
                })
                table.insert(t2, (task.delay(0.3, function() -- line: 177
                    -- upvalues: p2 (copy), v43 (ref)
                    return v43(not p2)
                end)))
            end

            v43(true)

            return function() -- line: 183
                -- upvalues: t2 (copy), v32 (copy)
                local function v46(p3) -- line: 185
                    return task.cancel(p3)
                end

                for v47, v48 in t2 do
                    local _ = v47 - 1

                    task.cancel(v48)
                end

                v32:immediate(0)
            end
        end, { isClaimable, isClaimed, v32 })
        useEffect(function() -- line: 195
            -- upvalues: v17 (ref), v36 (copy), v38 (copy), v40 (copy)
            if not v17 then
                return nil
            end

            v40(true)
            v36:spring(1.1, {
                damping = 0.3,
                frequency = 3.5
            })

            local v49 = task.delay(0.18, function() -- line: 204
                -- upvalues: v36 (copy)
                v36:spring(1, {
                    damping = 0.55,
                    frequency = 4
                })
            end)

            v38:linear(1, {
                speed = 1.4285714285714286
            })

            local v50 = task.delay(1.2, function() -- line: 213
                -- upvalues: v38 (copy), v40 (copy)
                v40(false)
                v38:impulse(0)
            end)

            return function() -- line: 217
                -- upvalues: v49 (copy), v50 (copy)
                task.cancel(v49)
                task.cancel(v50)
            end
        end, { v17, v36, v38 })

        local v51 = not v21 and react.createElement("uiaspectratioconstraint", {
            AspectRatio = 1
        })
        local v52 = react.createElement("uiscale", {
            Scale = v35
        })
        local v53 = v21 and react.createElement("frame", {
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            ZIndex = 0,
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.fromScale(0.5, 0.5),
            Size = UDim2.fromScale(1.02, 1.012)
        }, react.createElement("uicorner", {
            CornerRadius = UDim.new(0.025, 0)
        }), react.createElement("uistroke", {
            Thickness = 0.018,
            ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
            Color = Color3.fromRGB(255, 255, 255),
            StrokeSizingMode = Enum.StrokeSizingMode.ScaledSize
        }, react.createElement("uigradient", {
            Color = v11,
            Rotation = v23
        })))
        local createElement = react.createElement
        local t3 = {
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            ClipsDescendants = true,
            ZIndex = 1,
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.fromScale(0.5, 0.5),
            Size = UDim2.fromScale(1, 1)
        }
        local v54 = react.createElement("uicorner", {
            CornerRadius = UDim.new(0.025, 0)
        })
        local v55 = react.createElement("uistroke", {
            Thickness = 0.005,
            ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
            Color = Color3.fromRGB(0, 0, 0),
            StrokeSizingMode = Enum.StrokeSizingMode.ScaledSize
        })
        local v56 = react.createElement("frame", {
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            ZIndex = 1,
            AnchorPoint = Vector2.new(0.5, 0),
            Position = UDim2.fromScale(0.5, 0),
            Size = UDim2.fromScale(1, v30)
        })
        local createElement2 = react.createElement
        local t4 = {
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            ClipsDescendants = true,
            ZIndex = 1,
            AnchorPoint = Vector2.new(0.5, 1),
            Position = UDim2.fromScale(0.5, 1),
            Size = UDim2.new(1, 0, 1 - v30 + 0.01, 0)
        }
        local createElement3 = react.createElement
        local t5 = {
            cornerRadius = 0.025,
            isStudded = true,
            strokeThickness = 0.008,
            textureTransparency = 0.85,
            transparency = 0,
            zIndex = 2,
            anchorPoint = Vector2.new(0.5, 0.5),
            backgroundColor = Color3.fromRGB(230, 230, 235),
            position = UDim2.fromScale(0.5, 0.45),
            size = UDim2.fromScale(1, 1.1),
            strokeColor = v5
        }
        local v57 = react.createElement("uigradient", {
            Color = if v21 then v10 else v8,
            Rotation = v21 and 45 or 90
        })
        local v58 = (dayNumber == 2 or dayNumber == 4 or dayNumber == 6 or dayNumber == 7) and react.createElement("imagelabel", {
            BackgroundTransparency = 1,
            ImageTransparency = 0.38,
            ZIndex = 2,
            AnchorPoint = Vector2.new(0.5, 0.5),
            Image = images.shineBackground,
            ImageColor3 = Color3.fromRGB(255, 255, 255),
            Position = UDim2.fromScale(0.5, 0.45),
            Rotation = v33,
            ScaleType = Enum.ScaleType.Fit,
            Size = UDim2.fromScale(1.1, 1.1)
        }, react.createElement("uiaspectratioconstraint", {
            AspectRatio = 1
        }))
        local v59 = react.createElement("imagelabel", {
            BackgroundTransparency = 1,
            ImageTransparency = 0,
            ZIndex = 3,
            AnchorPoint = Vector2.new(0.5, 0.5),
            Image = images.screenBorder,
            ImageColor3 = Color3.fromRGB(0, 0, 0),
            Position = UDim2.fromScale(0.5, 0.5),
            ScaleType = Enum.ScaleType.Stretch,
            Size = UDim2.fromScale(1, 1)
        })
        local v60 = react.createElement("imagelabel", {
            BackgroundTransparency = 1,
            ZIndex = 3,
            AnchorPoint = Vector2.new(0.5, 0.5),
            Image = dailyReward.rewardIcon,
            Position = UDim2.fromScale(0.5, 0.45),
            Rotation = v31,
            ScaleType = Enum.ScaleType.Fit,
            Size = UDim2.fromScale(0.8, 0.8)
        })
        local v61 = not isClaimed and not isClaimable and dailyReward.rewardType == "aquariumSkin" and react.createElement("textlabel", {
            BackgroundTransparency = 1,
            Text = "+3% money",
            TextScaled = true,
            TextStrokeTransparency = 0,
            ZIndex = 5,
            AnchorPoint = Vector2.new(0.5, 1),
            Font = v19.textFont,
            Position = UDim2.fromScale(0.5, 0.76),
            Size = UDim2.fromScale(0.75, 0.14),
            TextColor3 = Color3.fromRGB(100, 255, 100),
            TextStrokeColor3 = Color3.fromRGB(0, 80, 0)
        })

        v20 = v20 and not isClaimed and not isClaimable and react.createElement(default2, {
            shadowYScale = 0.12,
            text = "125% stronger",
            color = v9,
            gradientRotation = v23,
            overrideProps = {
                TextScaled = true,
                ZIndex = 5,
                AnchorPoint = Vector2.new(0.5, 1),
                Font = v19.textFont,
                Position = UDim2.fromScale(0.5, 0.715),
                Size = UDim2.fromScale(0.85, 0.07),
                TextXAlignment = Enum.TextXAlignment.Center
            },
            popoutColor = Color3.fromRGB(120, 60, 0),
            strokeProps = {
                Color = Color3.fromRGB(80, 40, 0)
            }
        })

        local v62

        if isClaimed or v26 == nil then
            if not isClaimed then
                v62 = react.createElement(default2, {
                    shadowYScale = 0,
                    color = v28,
                    overrideProps = {
                        TextScaled = true,
                        ZIndex = 5,
                        AnchorPoint = bottomLabelAnchor,
                        Font = v19.textFont,
                        Position = bottomLabelPosition,
                        Size = UDim2.fromScale(0.8, 0.25),
                        TextXAlignment = Enum.TextXAlignment.Center
                    },
                    strokeProps = if v29 == nil then nil else {
                        Color = v29
                    },
                    text = v25
                })
            end
        else
            local createElement = react.createElement
            local t8 = {
                shadowYScale = 0,
                color = Color3.fromRGB(100, 255, 100)
            }
            local t9 = {
                TextScaled = true,
                ZIndex = 5,
                AnchorPoint = bottomLabelAnchor,
                Font = v19.textFont
            }

            t9.LineHeight = if v21 then 0.64 else nil

            if v21 then
                bottomLabelPosition = UDim2.fromScale(0.5, 0.985)
            end

            t9.Position = bottomLabelPosition
            t9.Size = if v21 then UDim2.fromScale(0.74, 0.22) else UDim2.fromScale(0.8, 0.25)
            t9.TextXAlignment = Enum.TextXAlignment.Center
            t9.TextYAlignment = if v21 then Enum.TextYAlignment.Bottom else Enum.TextYAlignment.Center
            t8.overrideProps = t9
            t8.strokeProps = {
                Color = Color3.fromRGB(0, 80, 0)
            }
            t8.text = v26
            v62 = createElement(default2, t8)
        end

        local v63 = createElement("frame", t3, v54, v55, v56, createElement2("frame", t4, createElement3(default, t5, v57, v58, v59, v60, v61, v20, v62)))
        local v64 = react.createElement(default, {
            cornerRadius = 0.08,
            strokeThickness = 0.05,
            textureTransparency = 0,
            transparency = 0,
            zIndex = 10,
            anchorPoint = Vector2.new(0.5, 0),
            backgroundColor = Color3.new(1, 1, 1),
            position = UDim2.fromScale(0.5, 0),
            size = UDim2.new(1.005, 0, v30, 0),
            strokeColor = v4
        }, react.createElement("uigradient", {
            Rotation = 90,
            Color = v3
        }), react.createElement(default3, {
            zIndex = 11,
            position = UDim2.fromScale(0.5, 0.5),
            size = UDim2.fromScale(1, 1)
        }), react.createElement(default2, {
            color = Color3.fromRGB(255, 255, 255),
            overrideProps = {
                TextScaled = true,
                ZIndex = 12,
                AnchorPoint = Vector2.new(0.5, 0.5),
                Font = v19.textFont,
                Position = UDim2.fromScale(0.5, 0.5),
                Size = UDim2.fromScale(0.9, 0.75),
                TextXAlignment = Enum.TextXAlignment.Center
            },
            text = ("Day %*"):format(dayNumber)
        }))
        local v65 = not isClaimed

        if v65 then
            if v22 then
                v22 = dailyReward.rewardMoneyDurationSeconds ~= nil and react.createElement("frame", {
                    BackgroundTransparency = 1,
                    ZIndex = 20,
                    AnchorPoint = Vector2.new(0, 0),
                    Position = UDim2.fromScale(0.03, v30 + 0.02),
                    Size = UDim2.fromScale(0.5, 0.175)
                }, react.createElement(default2, {
                    shadowYScale = 0.12,
                    color = Color3.new(1, 1, 1),
                    overrideProps = {
                        TextScaled = true,
                        ZIndex = 21,
                        AnchorPoint = Vector2.new(0, 0.5),
                        Font = v19.textFont,
                        Position = UDim2.fromScale(0, 0.5),
                        Size = UDim2.fromScale(1, 1),
                        TextXAlignment = Enum.TextXAlignment.Left
                    },
                    strokeProps = {
                        Color = Color3.fromRGB(60, 60, 60)
                    },
                    text = v25
                }))
            end
        else
            v22 = v65
        end

        local v66 = not isClaimed
        local createElement5, t10, v67, v68

        if v66 then
            if dailyReward.isOp ~= true or dailyReward.isLimited == true then
                v68 = false
            else
                createElement5 = react.createElement
                t10 = {
                    BackgroundTransparency = 1,
                    ZIndex = 20,
                    AnchorPoint = Vector2.new(0, 0),
                    Position = UDim2.fromScale(0.03, v30 + 0.02)
                }
                v67 = if v21 then UDim2.fromScale(0.35, 0.125) else UDim2.fromScale(0.5, 0.175)
                t10.Size = v67
                v68 = createElement5("frame", t10, react.createElement(default2, {
                    shadowYScale = 0.12,
                    text = "OP!",
                    color = v12,
                    overrideProps = {
                        TextScaled = true,
                        ZIndex = 21,
                        AnchorPoint = Vector2.new(0, 0.5),
                        Font = v19.textFont,
                        Position = UDim2.fromScale(0, 0.5),
                        Size = UDim2.fromScale(1, 1),
                        TextXAlignment = Enum.TextXAlignment.Left
                    },
                    popoutColor = v14,
                    strokeProps = {
                        Color = v13
                    }
                }))
            end
        else
            v68 = v66
        end

        local v69 = not isClaimed and dailyReward.isLimited == true and dailyReward.isOp ~= true and react.createElement("frame", {
            BackgroundTransparency = 1,
            ZIndex = 20,
            AnchorPoint = Vector2.new(0, 0),
            Position = UDim2.fromScale(0.03, v30 + 0.02),
            Size = UDim2.fromScale(0.7, 0.175)
        }, react.createElement(default2, {
            shadowYScale = 0.12,
            text = "LIMITED!",
            color = v15,
            overrideProps = {
                TextScaled = true,
                ZIndex = 21,
                AnchorPoint = Vector2.new(0, 0.5),
                Font = v19.textFont,
                Position = UDim2.fromScale(0, 0.5),
                Size = UDim2.fromScale(1, 1),
                TextXAlignment = Enum.TextXAlignment.Left
            },
            popoutColor = v16,
            strokeProps = {
                Color = v16
            }
        }))
        local v70 = not isClaimed and dailyReward.isLimited == true and dailyReward.isOp == true and react.createElement("frame", {
            BackgroundTransparency = 1,
            ZIndex = 20,
            AnchorPoint = Vector2.new(0, 0),
            Position = UDim2.fromScale(0.03, v30 + 0.02),
            Size = UDim2.fromScale(0.65, 0.125)
        }, react.createElement(default2, {
            shadowYScale = 0.12,
            text = "EXCLUSIVE",
            color = getRarityColor("exclusive"),
            overrideProps = {
                TextScaled = true,
                ZIndex = 21,
                AnchorPoint = Vector2.new(0, 0.5),
                Font = v19.textFont,
                Position = UDim2.fromScale(0, 0.5),
                Size = UDim2.fromScale(1, 1),
                TextXAlignment = Enum.TextXAlignment.Left
            },
            popoutColor = getRarityBorderColor("exclusive"),
            strokeProps = {
                Color = getRarityBorderColor("exclusive")
            }
        }))
        local v71 = isClaimed and react.createElement("frame", {
            BackgroundTransparency = 0.75,
            BorderSizePixel = 0,
            ZIndex = 14,
            AnchorPoint = Vector2.new(0.5, 1),
            BackgroundColor3 = Color3.fromRGB(0, 0, 0),
            Position = UDim2.fromScale(0.5, 1),
            Size = UDim2.new(1, 0, 1 - v30, 0)
        }, react.createElement("uicorner", {
            CornerRadius = UDim.new(0.025, 0)
        }), react.createElement("imagelabel", {
            BackgroundTransparency = 1,
            ZIndex = 15,
            AnchorPoint = Vector2.new(0.5, 0.5),
            Image = images.checkmarkIcon,
            Position = UDim2.fromScale(0.5, 0.5),
            ScaleType = Enum.ScaleType.Fit,
            Size = UDim2.fromScale(0.8, 0.8)
        }))
        local v72

        if isClaimable then
            v72 = not isClaimed
            v72 = v72 and react.createElement("imagebutton", {
                AutoButtonColor = false,
                BackgroundTransparency = 1,
                BorderSizePixel = 0,
                ZIndex = 18,
                AnchorPoint = Vector2.new(0.5, 0.5),
                Event = {
                    Activated = function() -- Activated | line: 539
                        -- upvalues: onClaim (copy), v18 (ref)
                        return onClaim(v18)
                    end
                },
                Position = UDim2.fromScale(0.5, 0.5),
                Size = UDim2.fromScale(1, 1)
            }, react.createElement("uicorner", {
                CornerRadius = UDim.new(0.025, 0)
            }), react.createElement(default4, {
                backgroundTransparency = 0.2,
                strokeSize = 1,
                zIndex = 18,
                color = Color3.fromRGB(30, 160, 60),
                cornerRadius = UDim.new(0.025, 0),
                position = UDim2.fromScale(0.5, 0.6),
                size = UDim2.fromScale(1, 0.25),
                strokeColor = Color3.fromRGB(18, 84, 33)
            }, react.createElement(default2, {
                text = "Claim!",
                color = v6,
                overrideProps = {
                    TextScaled = true,
                    ZIndex = 19,
                    AnchorPoint = Vector2.new(0.5, 0.5),
                    Font = v19.textFont,
                    Position = UDim2.fromScale(0.5, 0.5),
                    Size = UDim2.fromScale(1, 0.8),
                    TextXAlignment = Enum.TextXAlignment.Center
                },
                popoutColor = v7,
                strokeProps = {
                    Color = v7
                }
            })))
        else
            v72 = isClaimable
        end

        if v39 then
            v39 = table.create(#t1)

            local function v73(p4, p5) -- line: 578
                -- upvalues: v37 (copy), react (copy)
                local v74 = v37:map(function(p6) -- line: 579
                    -- upvalues: p4 (copy)
                    local v77 = 1 - math.pow(1 - math.clamp((p6 - p4.delay) / 0.6, 0, 1), 2)

                    return UDim2.fromScale(p4.endX, 0.5 + (p4.endY - 0.5) * v77)
                end)

                return react.createElement("frame", {
                    BorderSizePixel = 0,
                    ZIndex = 25,
                    AnchorPoint = Vector2.new(0.5, 0.5),
                    BackgroundColor3 = p4.color,
                    BackgroundTransparency = v37:map(function(p7) -- line: 587
                        -- upvalues: p4 (copy)
                        if math.clamp((p7 - p4.delay) / 0.6, 0, 1) >= 0.95 then
                            return 1
                        end

                        return 0
                    end),
                    Position = v74,
                    Rotation = v37:map(function(p8) -- line: 593
                        -- upvalues: p5 (copy)
                        return p8 * 540 + p5 * 45
                    end),
                    Size = UDim2.fromOffset(p4.size, (math.max(3, p4.size * 0.5))),
                    key = ("confetti-%*"):format(p5)
                }, react.createElement("uicorner", {
                    CornerRadius = UDim.new(0, 2)
                }))
            end

            for v80, v81 in t1 do
                v39[v80] = v73(v81, v80 - 1, t1)
            end
        end

        return react.createElement("frame", {
            BackgroundTransparency = 1,
            Size = UDim2.fromScale(1, 1)
        }, v51, react.createElement("frame", {
            BackgroundTransparency = 1,
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.fromScale(0.5, 0.5),
            Size = UDim2.fromScale(1, 1)
        }, v52, v53, v63, v64, v22, v68, v69, v70, v71, v72, v39))
    end
}
