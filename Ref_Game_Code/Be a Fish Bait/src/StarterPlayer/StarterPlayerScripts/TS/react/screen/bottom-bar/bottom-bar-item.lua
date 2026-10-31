-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local useEffect, useState = react.useEffect, react.useState
local useMotion = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "pretty-react-hooks", "out").useMotion
local default = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "brainrot-style", "popout-text-two").default
local default2 = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "notification-badge").default
local useTheme = RuntimeLib.import(script, script.Parent.Parent.Parent, "hooks", "use-theme").useTheme
local default3 = RuntimeLib.import(script, script.Parent, "bottom-bar-tooltip").default
local v1 = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 220, 50)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(210, 140, 0))
})
local v2 = Color3.fromRGB(100, 50, 0)

return {
    default = function(p1) -- BottomBarItem | line: 14
        -- upvalues: react (copy), useEffect (copy), useState (copy), useMotion (copy), default (copy), default2 (copy), useTheme (copy), default3 (copy), v1 (copy), v2 (copy)
        local imageId, imageSize = p1.imageId, p1.imageSize

        if imageSize == nil then
            imageSize = 1
        end

        local isEdge = p1.isEdge

        if isEdge == nil then
            isEdge = false
        end

        local name, notificationBadgeText, promoBadgeText, shake = p1.name, p1.notificationBadgeText, p1.promoBadgeText, p1.shake
        local v3 = shake

        if shake == nil then
            v3 = false
        end

        local shakeDelay = p1.shakeDelay
        local v4 = shakeDelay

        if shakeDelay == nil then
            v4 = 3
        end

        local showNotification = p1.showNotification

        if showNotification == nil then
            showNotification = false
        end

        local statIncrease, subtitle, titleSize, onClick = p1.statIncrease, p1.subtitle, p1.titleSize, p1.onClick
        local zIndex = p1.zIndex

        if zIndex == nil then
            zIndex = 10
        end

        local v5 = useTheme()
        local v6, v7 = useState(false)
        local v8, v9 = useMotion(1)
        local v10, v11 = useMotion(0)

        useEffect(function() -- line: 51
            -- upvalues: v3 (ref), v4 (ref), v9 (copy), v11 (copy)
            if v3 then
                local t1 = {}
                local v12

                v12 = function() -- line: 62
                    -- upvalues: v12 (ref), t1 (copy), v4 (ref), v9 (copy), v11 (copy)
                    v9:tween(1.1, {
                        time = 0.5,
                        style = Enum.EasingStyle.Quad
                    })
                    table.insert(t1, (task.delay(0.5, function() -- line: 68
                        -- upvalues: v11 (copy)
                        return v11:tween(-20, {
                            time = 0.2,
                            style = Enum.EasingStyle.Sine
                        })
                    end)))
                    table.insert(t1, (task.delay(0.7, function() -- line: 75
                        -- upvalues: v11 (copy)
                        return v11:tween(40, {
                            time = 0.2,
                            style = Enum.EasingStyle.Sine
                        })
                    end)))
                    table.insert(t1, (task.delay(0.9, function() -- line: 82
                        -- upvalues: v11 (copy)
                        return v11:tween(-40, {
                            time = 0.2,
                            style = Enum.EasingStyle.Sine
                        })
                    end)))
                    table.insert(t1, (task.delay(1.1, function() -- line: 89
                        -- upvalues: v11 (copy)
                        return v11:tween(20, {
                            time = 0.2,
                            style = Enum.EasingStyle.Sine
                        })
                    end)))
                    table.insert(t1, (task.delay(1.3, function() -- line: 96
                        -- upvalues: v11 (copy)
                        return v11:tween(0, {
                            time = 0.2,
                            style = Enum.EasingStyle.Sine
                        })
                    end)))
                    table.insert(t1, (task.delay(1.5, function() -- line: 103
                        -- upvalues: v9 (copy)
                        return v9:tween(1, {
                            time = 0.5,
                            style = Enum.EasingStyle.Quad
                        })
                    end)))
                    table.insert(t1, (task.delay(2 + v4, v12)))
                end

                v12()

                return function() -- line: 115
                    -- upvalues: t1 (copy)
                    local function v20(p2) -- line: 117
                        return task.cancel(p2)
                    end

                    for v21, v22 in t1 do
                        local _ = v21 - 1

                        task.cancel(v22)
                    end
                end
            end

            v9:tween(1, {
                time = 0.15,
                style = Enum.EasingStyle.Quad
            })
            v11:immediate(0)

            return nil
        end, { v3, v4, v9, v11 })

        local v23 = react.createElement("uiaspectratioconstraint", {
            AspectRatio = 1
        })
        local v24 = v6 and react.createElement(default3, {
            isEdge = isEdge,
            name = name,
            subtitle = subtitle,
            titleSize = titleSize,
            zIndex = zIndex + 30
        })
        local v25 = react.createElement("imagelabel", {
            BackgroundTransparency = 1,
            AnchorPoint = Vector2.new(0.5, 0.5),
            Image = imageId,
            Position = UDim2.fromScale(0.5, 0.5),
            Rotation = v10,
            ScaleType = Enum.ScaleType.Fit,
            Size = UDim2.fromScale(imageSize, imageSize),
            ZIndex = zIndex + 1
        })
        local v26 = promoBadgeText ~= nil and react.createElement("frame", {
            BackgroundTransparency = 1,
            Rotation = -18,
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.fromScale(0.12, 0.08),
            Size = UDim2.fromScale(0.77, 0.41),
            ZIndex = zIndex + 3
        }, react.createElement(default, {
            shadowYScale = 0.12,
            anchorPoint = Vector2.new(0.5, 0.5),
            color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.fromRGB(80, 255, 130)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(20, 205, 80))
            }),
            overrideProps = {
                BackgroundTransparency = 1,
                TextScaled = true,
                Font = v5.textFont2,
                Position = UDim2.fromScale(0.5, 0.5),
                Size = UDim2.fromScale(1, 1),
                ZIndex = zIndex + 3
            },
            popoutColor = Color3.fromRGB(0, 0, 0),
            strokeProps = {
                Thickness = 0.14,
                Color = Color3.fromRGB(0, 0, 0),
                StrokeSizingMode = Enum.StrokeSizingMode.ScaledSize
            },
            text = promoBadgeText
        }))
        local v27 = statIncrease ~= nil and react.createElement(default, {
            color = v1,
            overrideProps = {
                TextScaled = true,
                AnchorPoint = Vector2.new(0.5, 1),
                Position = UDim2.fromScale(0.5, 1.05),
                Size = UDim2.fromScale(1.1, 0.38),
                TextXAlignment = Enum.TextXAlignment.Center,
                ZIndex = zIndex + 2
            },
            popoutColor = v2,
            strokeProps = {
                Thickness = 0.08,
                Color = v2
            },
            text = ("+%*%%"):format(statIncrease)
        })
        local v28 = showNotification or notificationBadgeText ~= nil

        if v28 then
            local t2 = {
                anchorPoint = Vector2.new(1, 0),
                position = UDim2.fromScale(0.3, -0.05),
                size = UDim2.fromScale(0.4, 0.4),
                text = if notificationBadgeText == nil then "!" else notificationBadgeText
            }

            t2.zIndex = zIndex + 2
            v28 = react.createElement(default2, t2)
        end

        return react.createElement("textbutton", {
            AutoButtonColor = false,
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            Text = "",
            AnchorPoint = Vector2.new(0.5, 0.5),
            Event = {
                Activated = function() -- Activated | line: 211
                    -- upvalues: onClick (copy)
                    local v29 = onClick

                    if onClick ~= nil then
                        v29 = onClick()
                    end

                    return v29
                end,
                MouseEnter = function() -- MouseEnter | line: 218
                    -- upvalues: v7 (copy), v9 (copy)
                    v7(true)
                    v9:spring(1.1, {
                        frequency = 0.1
                    })
                end,
                MouseLeave = function() -- MouseLeave | line: 224
                    -- upvalues: v7 (copy), v9 (copy)
                    v7(false)
                    v9:spring(1, {
                        frequency = 0.1
                    })
                end
            },
            Position = UDim2.fromScale(0.5, 0.5),
            Size = v8:map(function(p3) -- line: 232
                return UDim2.fromScale(p3, p3)
            end),
            ZIndex = zIndex
        }, v23, v24, v25, v26, v27, v28)
    end
}
