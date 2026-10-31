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
local v1 = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "celebration-reward-utils")
local celebrationRewardWeekLength, getCelebrationRewardDisplayText = v1.celebrationRewardWeekLength, v1.getCelebrationRewardDisplayText
local formatDurationSeconds = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "daily-rewards-utils").formatDurationSeconds
local v2 = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "rarity-utils")
local getRarityBorderColor, getRarityColor = v2.getRarityBorderColor, v2.getRarityColor
local images = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "images").images
local v3 = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(130, 95, 10)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(210, 160, 20))
})
local v4 = Color3.fromRGB(110, 80, 10)
local v5 = Color3.fromRGB(0, 0, 0)
local v6 = Color3.fromRGB(78, 254, 86)
local v7 = Color3.fromRGB(0, 100, 10)
local v8 = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 248, 220)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 226, 150))
})
local v9 = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 180, 180)),
    ColorSequenceKeypoint.new(0.17, Color3.fromRGB(255, 210, 170)),
    ColorSequenceKeypoint.new(0.33, Color3.fromRGB(255, 255, 180)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(180, 255, 190)),
    ColorSequenceKeypoint.new(0.67, Color3.fromRGB(180, 210, 255)),
    ColorSequenceKeypoint.new(0.83, Color3.fromRGB(210, 180, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 180, 230))
})
local v10 = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 70, 100)),
    ColorSequenceKeypoint.new(0.17, Color3.fromRGB(255, 220, 70)),
    ColorSequenceKeypoint.new(0.34, Color3.fromRGB(80, 255, 120)),
    ColorSequenceKeypoint.new(0.51, Color3.fromRGB(80, 220, 255)),
    ColorSequenceKeypoint.new(0.68, Color3.fromRGB(120, 110, 255)),
    ColorSequenceKeypoint.new(0.85, Color3.fromRGB(255, 90, 230)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 70, 100))
})
local v11 = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 240, 80)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 200, 20))
})
local v12 = Color3.fromRGB(180, 80, 0)
local v13 = Color3.fromRGB(220, 100, 0)
local v14 = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(220, 80, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(160, 40, 220))
})
local v15 = Color3.fromRGB(80, 0, 140)

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
    default = function(p1) -- CelebrationRewardItem | line: 86
        -- upvalues: react (copy), useEffect (copy), useState (copy), useMotion (copy), default (copy), default2 (copy), default3 (copy), default4 (copy), useTheme (copy), celebrationRewardWeekLength (copy), getCelebrationRewardDisplayText (copy), formatDurationSeconds (copy), getRarityBorderColor (copy), getRarityColor (copy), images (copy), v3 (copy), v4 (copy), v5 (copy), v6 (copy), v7 (copy), v8 (copy), v9 (copy), v10 (copy), v11 (copy), v12 (copy), v13 (copy), v14 (copy), v15 (copy), t1 (copy)
        local celebrationReward, dayNumber, isClaimable, isClaimed = p1.celebrationReward, p1.dayNumber, p1.isClaimable, p1.isClaimed
        local justClaimed = p1.justClaimed
        local v16 = justClaimed

        if justClaimed == nil then
            v16 = false
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
        local v17 = claimDayIndex

        if claimDayIndex == nil then
            v17 = dayNumber
        end

        local v18 = useTheme()
        local v19 = celebrationReward.rewardId == "celebration-7" or celebrationReward.rewardId == "celebration-14"
        local v20 = celebrationReward.rewardType == "money"
        local v21 = (dayNumber - 1) % celebrationRewardWeekLength + 1
        local v22, v23 = useMotion(0)
        local v24 = if not v20 or celebrationReward.rewardMoneyDurationSeconds == nil then getCelebrationRewardDisplayText(celebrationReward, moneyPerSecond) else formatDurationSeconds(celebrationReward.rewardMoneyDurationSeconds)
        local v25 = if v20 then getCelebrationRewardDisplayText(celebrationReward, moneyPerSecond) else nil
        local v26 = celebrationReward.rewardType == "fish"
        local rewardFishRarity = celebrationReward.rewardFishRarity
        local v27 = if not v26 or rewardFishRarity == nil then Color3.new(1, 1, 1) else getRarityColor(rewardFishRarity)
        local v28 = if not v26 or rewardFishRarity == nil then nil else getRarityBorderColor(rewardFishRarity)
        local v29 = if v19 then 0.1 else 0.25
        local v30, v31 = useMotion(0)
        local v32, v33 = useMotion(0)
        local v34, v35 = useMotion(1)
        local v36, v37 = useMotion(0)
        local v38, v39 = useState(false)

        useEffect(function() -- line: 134
            -- upvalues: v33 (copy)
            v33:linear(360, {
                speed = 24
            })

            local v40 = v33:onComplete(function() -- line: 141
                -- upvalues: v33 (copy)
                v33:immediate(0)
                v33:linear(360, {
                    speed = 24
                })
            end)

            return function() -- line: 145
                -- upvalues: v40 (copy)
                return v40()
            end
        end, { v33 })
        useEffect(function() -- line: 149
            -- upvalues: v23 (copy), v19 (copy)
            if not v19 then
                return nil
            end

            v23:linear(360, {
                speed = 90
            })

            local v41 = v23:onComplete(function() -- line: 159
                -- upvalues: v23 (copy)
                v23:immediate(0)
                v23:linear(360, {
                    speed = 90
                })
            end)

            return function() -- line: 163
                -- upvalues: v41 (copy)
                return v41()
            end
        end, { v19, v23 })
        useEffect(function() -- line: 167
            -- upvalues: isClaimable (copy), isClaimed (copy), v31 (copy)
            if not isClaimable or isClaimed then
                v31:immediate(0)

                return nil
            end

            local t2 = {}
            local v42

            v42 = function(p2) -- line: 175
                -- upvalues: v42 (ref), t2 (copy), v31 (copy)
                v31:tween(p2 and 5 or -5, {
                    time = 0.3,
                    style = Enum.EasingStyle.Sine
                })
                table.insert(t2, (task.delay(0.3, function() -- line: 180
                    -- upvalues: p2 (copy), v42 (ref)
                    return v42(not p2)
                end)))
            end

            v42(true)

            return function() -- line: 186
                -- upvalues: t2 (copy), v31 (copy)
                local function v45(p3) -- line: 188
                    return task.cancel(p3)
                end

                for v46, v47 in t2 do
                    local _ = v46 - 1

                    task.cancel(v47)
                end

                v31:immediate(0)
            end
        end, { isClaimable, isClaimed, v31 })
        useEffect(function() -- line: 198
            -- upvalues: v16 (ref), v35 (copy), v37 (copy), v39 (copy)
            if not v16 then
                return nil
            end

            v39(true)
            v35:spring(1.1, {
                damping = 0.3,
                frequency = 3.5
            })

            local v48 = task.delay(0.18, function() -- line: 207
                -- upvalues: v35 (copy)
                v35:spring(1, {
                    damping = 0.55,
                    frequency = 4
                })
            end)

            v37:linear(1, {
                speed = 1.4285714285714286
            })

            local v49 = task.delay(1.2, function() -- line: 216
                -- upvalues: v37 (copy), v39 (copy)
                v39(false)
                v37:impulse(0)
            end)

            return function() -- line: 220
                -- upvalues: v48 (copy), v49 (copy)
                task.cancel(v48)
                task.cancel(v49)
            end
        end, { v16, v35, v37 })

        local v50 = not v19 and react.createElement("uiaspectratioconstraint", {
            AspectRatio = 1
        })
        local v51 = react.createElement("uiscale", {
            Scale = v34
        })
        local v52 = v19 and react.createElement("frame", {
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
            Color = v10,
            Rotation = v22
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
        local v53 = react.createElement("uicorner", {
            CornerRadius = UDim.new(0.025, 0)
        })
        local v54 = react.createElement("uistroke", {
            Thickness = 0.005,
            ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
            Color = Color3.fromRGB(0, 0, 0),
            StrokeSizingMode = Enum.StrokeSizingMode.ScaledSize
        })
        local v55 = react.createElement("frame", {
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            ZIndex = 1,
            AnchorPoint = Vector2.new(0.5, 0),
            Position = UDim2.fromScale(0.5, 0),
            Size = UDim2.fromScale(1, v29)
        })
        local createElement2 = react.createElement
        local t4 = {
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            ClipsDescendants = true,
            ZIndex = 1,
            AnchorPoint = Vector2.new(0.5, 1),
            Position = UDim2.fromScale(0.5, 1),
            Size = UDim2.new(1, 0, 1 - v29 + 0.01, 0)
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
            backgroundColor = Color3.fromRGB(255, 240, 210),
            position = UDim2.fromScale(0.5, 0.45),
            size = UDim2.fromScale(1, 1.1),
            strokeColor = v5
        }
        local v56 = react.createElement("uigradient", {
            Color = if v19 then v9 else v8,
            Rotation = v19 and 45 or 90
        })
        local v57 = (v21 == 2 or v21 == 4 or v21 == 6 or v21 == 7) and react.createElement("imagelabel", {
            BackgroundTransparency = 1,
            ImageTransparency = 0.38,
            ZIndex = 2,
            AnchorPoint = Vector2.new(0.5, 0.5),
            Image = images.shineBackground,
            ImageColor3 = Color3.fromRGB(255, 255, 255),
            Position = UDim2.fromScale(0.5, 0.45),
            Rotation = v32,
            ScaleType = Enum.ScaleType.Fit,
            Size = UDim2.fromScale(1.1, 1.1)
        }, react.createElement("uiaspectratioconstraint", {
            AspectRatio = 1
        }))
        local v58 = react.createElement("imagelabel", {
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
        local v59 = react.createElement("imagelabel", {
            BackgroundTransparency = 1,
            ZIndex = 3,
            AnchorPoint = Vector2.new(0.5, 0.5),
            Image = celebrationReward.rewardIcon,
            Position = UDim2.fromScale(0.5, 0.45),
            Rotation = v30,
            ScaleType = Enum.ScaleType.Fit,
            Size = UDim2.fromScale(0.8, 0.8)
        })
        local v60

        if isClaimed or v25 == nil then
            if not isClaimed then
                v60 = react.createElement(default2, {
                    shadowYScale = 0,
                    color = v27,
                    overrideProps = {
                        TextScaled = true,
                        ZIndex = 5,
                        AnchorPoint = bottomLabelAnchor,
                        Font = v18.textFont,
                        Position = bottomLabelPosition,
                        Size = UDim2.fromScale(0.8, 0.25),
                        TextXAlignment = Enum.TextXAlignment.Center
                    },
                    strokeProps = if v28 == nil then nil else {
                        Color = v28
                    },
                    text = v24
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
                Font = v18.textFont
            }

            t9.LineHeight = if v19 then 0.64 else nil

            if v19 then
                bottomLabelPosition = UDim2.fromScale(0.5, 0.985)
            end

            t9.Position = bottomLabelPosition
            t9.Size = if v19 then UDim2.fromScale(0.74, 0.22) else UDim2.fromScale(0.8, 0.25)
            t9.TextXAlignment = Enum.TextXAlignment.Center
            t9.TextYAlignment = if v19 then Enum.TextYAlignment.Bottom else Enum.TextYAlignment.Center
            t8.overrideProps = t9
            t8.strokeProps = {
                Color = Color3.fromRGB(0, 80, 0)
            }
            t8.text = v25
            v60 = createElement(default2, t8)
        end

        local v61 = createElement("frame", t3, v53, v54, v55, createElement2("frame", t4, createElement3(default, t5, v56, v57, v58, v59, v60)))
        local v62 = react.createElement(default, {
            cornerRadius = 0.08,
            strokeThickness = 0.05,
            textureTransparency = 0,
            transparency = 0,
            zIndex = 10,
            anchorPoint = Vector2.new(0.5, 0),
            backgroundColor = Color3.new(1, 1, 1),
            position = UDim2.fromScale(0.5, 0),
            size = UDim2.new(1.005, 0, v29, 0),
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
                Font = v18.textFont,
                Position = UDim2.fromScale(0.5, 0.5),
                Size = UDim2.fromScale(0.9, 0.75),
                TextXAlignment = Enum.TextXAlignment.Center
            },
            text = ("Day %*"):format(dayNumber)
        }))
        local v63 = not isClaimed

        if v63 then
            if v20 then
                v20 = celebrationReward.rewardMoneyDurationSeconds ~= nil and react.createElement("frame", {
                    BackgroundTransparency = 1,
                    ZIndex = 20,
                    AnchorPoint = Vector2.new(0, 0),
                    Position = UDim2.fromScale(0.03, v29 + 0.02),
                    Size = UDim2.fromScale(0.5, 0.175)
                }, react.createElement(default2, {
                    shadowYScale = 0.12,
                    color = Color3.new(1, 1, 1),
                    overrideProps = {
                        TextScaled = true,
                        ZIndex = 21,
                        AnchorPoint = Vector2.new(0, 0.5),
                        Font = v18.textFont,
                        Position = UDim2.fromScale(0, 0.5),
                        Size = UDim2.fromScale(1, 1),
                        TextXAlignment = Enum.TextXAlignment.Left
                    },
                    strokeProps = {
                        Color = Color3.fromRGB(60, 60, 60)
                    },
                    text = v24
                }))
            end
        else
            v20 = v63
        end

        local v64 = not isClaimed
        local createElement5, t10, v65, v66

        if v64 then
            if celebrationReward.isOp ~= true or celebrationReward.isLimited == true then
                v66 = false
            else
                createElement5 = react.createElement
                t10 = {
                    BackgroundTransparency = 1,
                    ZIndex = 20,
                    AnchorPoint = Vector2.new(0, 0),
                    Position = UDim2.fromScale(0.03, v29 + 0.02)
                }
                v65 = if v19 then UDim2.fromScale(0.35, 0.125) else UDim2.fromScale(0.5, 0.175)
                t10.Size = v65
                v66 = createElement5("frame", t10, react.createElement(default2, {
                    shadowYScale = 0.12,
                    text = "OP!",
                    color = v11,
                    overrideProps = {
                        TextScaled = true,
                        ZIndex = 21,
                        AnchorPoint = Vector2.new(0, 0.5),
                        Font = v18.textFont,
                        Position = UDim2.fromScale(0, 0.5),
                        Size = UDim2.fromScale(1, 1),
                        TextXAlignment = Enum.TextXAlignment.Left
                    },
                    popoutColor = v13,
                    strokeProps = {
                        Color = v12
                    }
                }))
            end
        else
            v66 = v64
        end

        local v67 = not isClaimed and celebrationReward.isLimited == true and celebrationReward.isOp ~= true and react.createElement("frame", {
            BackgroundTransparency = 1,
            ZIndex = 20,
            AnchorPoint = Vector2.new(0, 0),
            Position = UDim2.fromScale(0.03, v29 + 0.02),
            Size = UDim2.fromScale(0.7, 0.175)
        }, react.createElement(default2, {
            shadowYScale = 0.12,
            text = "LIMITED!",
            color = v14,
            overrideProps = {
                TextScaled = true,
                ZIndex = 21,
                AnchorPoint = Vector2.new(0, 0.5),
                Font = v18.textFont,
                Position = UDim2.fromScale(0, 0.5),
                Size = UDim2.fromScale(1, 1),
                TextXAlignment = Enum.TextXAlignment.Left
            },
            popoutColor = v15,
            strokeProps = {
                Color = v15
            }
        }))
        local v68 = not isClaimed and celebrationReward.isLimited == true and celebrationReward.isOp == true and react.createElement("frame", {
            BackgroundTransparency = 1,
            ZIndex = 20,
            AnchorPoint = Vector2.new(0, 0),
            Position = UDim2.fromScale(0.03, v29 + 0.02),
            Size = UDim2.fromScale(0.65, 0.125)
        }, react.createElement(default2, {
            shadowYScale = 0.12,
            text = "EXCLUSIVE",
            color = getRarityColor("exclusive"),
            overrideProps = {
                TextScaled = true,
                ZIndex = 21,
                AnchorPoint = Vector2.new(0, 0.5),
                Font = v18.textFont,
                Position = UDim2.fromScale(0, 0.5),
                Size = UDim2.fromScale(1, 1),
                TextXAlignment = Enum.TextXAlignment.Left
            },
            popoutColor = getRarityBorderColor("exclusive"),
            strokeProps = {
                Color = getRarityBorderColor("exclusive")
            }
        }))
        local v69 = isClaimed and react.createElement("frame", {
            BackgroundTransparency = 0.75,
            BorderSizePixel = 0,
            ZIndex = 14,
            AnchorPoint = Vector2.new(0.5, 1),
            BackgroundColor3 = Color3.fromRGB(0, 0, 0),
            Position = UDim2.fromScale(0.5, 1),
            Size = UDim2.new(1, 0, 1 - v29, 0)
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
        local v70

        if isClaimable then
            v70 = not isClaimed
            v70 = v70 and react.createElement("imagebutton", {
                AutoButtonColor = false,
                BackgroundTransparency = 1,
                BorderSizePixel = 0,
                ZIndex = 18,
                AnchorPoint = Vector2.new(0.5, 0.5),
                Event = {
                    Activated = function() -- Activated | line: 512
                        -- upvalues: onClaim (copy), v17 (ref)
                        return onClaim(v17)
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
                    Font = v18.textFont,
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
            v70 = isClaimable
        end

        if v38 then
            v38 = table.create(#t1)

            local function v71(p4, p5) -- line: 551
                -- upvalues: v36 (copy), react (copy)
                local v72 = v36:map(function(p6) -- line: 552
                    -- upvalues: p4 (copy)
                    local v75 = 1 - math.pow(1 - math.clamp((p6 - p4.delay) / 0.6, 0, 1), 2)

                    return UDim2.fromScale(p4.endX, 0.5 + (p4.endY - 0.5) * v75)
                end)

                return react.createElement("frame", {
                    BorderSizePixel = 0,
                    ZIndex = 25,
                    AnchorPoint = Vector2.new(0.5, 0.5),
                    BackgroundColor3 = p4.color,
                    BackgroundTransparency = v36:map(function(p7) -- line: 560
                        -- upvalues: p4 (copy)
                        if math.clamp((p7 - p4.delay) / 0.6, 0, 1) >= 0.95 then
                            return 1
                        end

                        return 0
                    end),
                    Position = v72,
                    Rotation = v36:map(function(p8) -- line: 566
                        -- upvalues: p5 (copy)
                        return p8 * 540 + p5 * 45
                    end),
                    Size = UDim2.fromOffset(p4.size, (math.max(3, p4.size * 0.5))),
                    key = ("confetti-%*"):format(p5)
                }, react.createElement("uicorner", {
                    CornerRadius = UDim.new(0, 2)
                }))
            end

            for v78, v79 in t1 do
                v38[v78] = v71(v79, v78 - 1, t1)
            end
        end

        return react.createElement("frame", {
            BackgroundTransparency = 1,
            Size = UDim2.fromScale(1, 1)
        }, v50, react.createElement("frame", {
            BackgroundTransparency = 1,
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.fromScale(0.5, 0.5),
            Size = UDim2.fromScale(1, 1)
        }, v51, v52, v61, v62, v20, v66, v67, v68, v69, v70, v38))
    end
}
