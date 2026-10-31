-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local useBinding = react.useBinding
local out = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "pretty-react-hooks", "out")
local useBindingListener, useMotion = out.useBindingListener, out.useMotion
local useTheme = RuntimeLib.import(script, script.Parent.Parent.Parent, "hooks", "use-theme").useTheme
local useSound = RuntimeLib.import(script, script.Parent.Parent.Parent, "hooks", "use-sound").useSound
local default = RuntimeLib.import(script, script.Parent, "popout-text-two").default
local default2 = RuntimeLib.import(script, script.Parent, "br-frame").default
local default3 = RuntimeLib.import(script, script.Parent, "shiny-overlay").default

local function darkenColor(p1, p2) -- line: 14
    return Color3.new(p1.R * p2, p1.G * p2, p1.B * p2)
end

return {
    default = function(p3) -- PopoutTextButton | line: 17
        -- upvalues: react (copy), useBinding (copy), useBindingListener (copy), useMotion (copy), useTheme (copy), useSound (copy), default (copy), default2 (copy), default3 (copy)
        local v1 = useTheme()
        local playSound = useSound("ButtonClick").playSound
        local playSound2 = useSound("ButtonHover").playSound
        local v2, v3 = useBinding(false)
        local v4, v5 = useBinding(false)
        local v6, v7 = useMotion(1)
        local v8, v9 = useMotion(1)

        useBindingListener(v2, function(p4) -- line: 27
            -- upvalues: p3 (copy), v7 (copy), v9 (copy)
            if p3.disabled then
                return nil
            end

            if p4 then
                v7:spring(1.05, {
                    frequency = 0.1
                })
                v9:spring(0.82, {
                    frequency = 0.1
                })
            else
                v7:spring(1, {
                    frequency = 0.1
                })
                v9:spring(1, {
                    frequency = 0.1
                })
            end
        end)
        useBindingListener(v4, function(p5) -- line: 47
            -- upvalues: p3 (copy), v2 (copy), v7 (copy)
            if p3.disabled then
                return nil
            end

            if p5 then
                v7:spring(0.93, {
                    frequency = 0.1
                })
            else
                v7:spring(v2:getValue() and 1.05 or 1, {
                    frequency = 0.1
                })
            end
        end)

        local v11 = typeof(p3.color) == "ColorSequence"
        local v12 = if v11 then p3.color.Keypoints[1].Value else p3.color
        local cornerRadius = p3.cornerRadius

        if cornerRadius == nil then
            cornerRadius = 0.1
        end

        local v13 = Color3.new(v12.R * 0.72, v12.G * 0.72, v12.B * 0.72)
        local zIndex = p3.zIndex

        if zIndex == nil then
            zIndex = 1
        end

        local v14 = p3.frameSize or UDim2.fromScale(1, 0.2)
        local v15 = v6:map(function(p6) -- line: 76
            -- upvalues: v14 (copy)
            return UDim2.new(v14.X.Scale * p6, v14.X.Offset * p6, v14.Y.Scale * p6, v14.Y.Offset * p6)
        end)
        local createElement = react.createElement
        local t1 = {
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            AnchorPoint = p3.anchorPoint or Vector2.new(0.5, 0.5),
            LayoutOrder = p3.layoutOrder,
            Position = p3.position,
            Size = v15,
            ZIndex = zIndex
        }
        local v16 = p3.minimumSize ~= nil and react.createElement("uisizeconstraint", {
            MinSize = p3.minimumSize
        })
        local v17 = p3.aspectRatio ~= nil and react.createElement("uiaspectratioconstraint", {
            AspectRatio = p3.aspectRatio,
            DominantAxis = Enum.DominantAxis.Width
        })
        local createElement2 = react.createElement
        local t2 = {
            AutoButtonColor = false,
            BorderSizePixel = 0,
            Active = not p3.disabled,
            BackgroundColor3 = p3.popoutColor or v13,
            Event = {
                Activated = function() -- Activated | line: 98
                    -- upvalues: p3 (copy), playSound (copy)
                    if p3.disabled then
                        return nil
                    end

                    playSound()
                    p3.onClick()
                end,
                MouseEnter = function() -- MouseEnter | line: 105
                    -- upvalues: p3 (copy), playSound2 (copy), v3 (copy)
                    if p3.disabled then
                        return nil
                    end

                    playSound2()
                    v3(true)
                end,
                MouseLeave = function() -- MouseLeave | line: 112
                    -- upvalues: v3 (copy)
                    return v3(false)
                end,
                MouseButton1Down = function() -- MouseButton1Down | line: 115
                    -- upvalues: v5 (copy)
                    return v5(true)
                end,
                MouseButton1Up = function() -- MouseButton1Up | line: 118
                    -- upvalues: v5 (copy)
                    return v5(false)
                end,
                MouseButton2Down = function() -- MouseButton2Down | line: 121
                    -- upvalues: v5 (copy)
                    return v5(true)
                end,
                MouseButton2Up = function() -- MouseButton2Up | line: 124
                    -- upvalues: v5 (copy)
                    return v5(false)
                end
            },
            Position = UDim2.fromScale(0, 0),
            Size = UDim2.fromScale(1, 1),
            ZIndex = zIndex + 1
        }
        local v18 = react.createElement("uicorner", {
            CornerRadius = UDim.new(cornerRadius, 0)
        })
        local v19 = react.createElement("uistroke", {
            Thickness = 0.055,
            ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
            Color = p3.strokeColor or Color3.new(0, 0, 0),
            StrokeSizingMode = Enum.StrokeSizingMode.ScaledSize
        })
        local v20 = react.createElement(default2, {
            transparency = 0,
            anchorPoint = Vector2.new(0.5, 0.5),
            backgroundColor = p3.color,
            cornerRadius = cornerRadius,
            gradientRotation = p3.gradientRotation,
            isStudded = p3.isStudded,
            position = UDim2.fromScale(0.5, 0.45),
            size = UDim2.fromScale(1, 0.88),
            zIndex = zIndex + 2
        })
        local v21 = p3.isShiny and react.createElement(default3, {
            position = UDim2.fromScale(0.5, 0.5),
            size = UDim2.fromScale(1, 1),
            zIndex = zIndex + 2
        })
        local v22 = p3.coverImage ~= nil and react.createElement("imagelabel", {
            BackgroundTransparency = 1,
            AnchorPoint = Vector2.new(0.5, 0.5),
            Image = p3.coverImage,
            ImageColor3 = if v11 then Color3.new(1, 1, 1) else p3.color,
            Position = UDim2.fromScale(0.5, 0.5),
            ScaleType = p3.coverImageScaleType,
            Size = UDim2.fromScale(1, 0.8),
            ZIndex = zIndex + 2
        }, react.createElement("uicorner", {
            CornerRadius = UDim.new(cornerRadius, 0)
        }))
        local v23 = react.createElement("frame", {
            BorderSizePixel = 0,
            AnchorPoint = Vector2.new(0.5, 0.5),
            BackgroundColor3 = Color3.new(0, 0, 0),
            BackgroundTransparency = v8,
            Position = UDim2.fromScale(0.5, 0.5),
            Size = UDim2.fromScale(1, 1),
            ZIndex = zIndex + 3
        }, react.createElement("uicorner", {
            CornerRadius = UDim.new(cornerRadius, 0)
        }))

        if p3.children ~= nil then
            local v24 = react.createElement("frame", {
                BackgroundTransparency = 1,
                BorderSizePixel = 0,
                AnchorPoint = Vector2.new(0.5, 0.5),
                Position = UDim2.fromScale(0.5, 0.5),
                Size = UDim2.fromScale(1, 1),
                ZIndex = zIndex + 4
            }, p3.children)

            return createElement("frame", t1, v16, v17, createElement2("imagebutton", t2, v18, v19, v20, v21, v22, v23, v24))
        end

        return createElement("frame", t1, v16, v17, createElement2("imagebutton", t2, v18, v19, v20, v21, v22, v23, (react.createElement("frame", {
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.fromScale(0.5, 0.475),
            Size = p3.size or UDim2.fromScale(0.9, 0.7),
            ZIndex = zIndex + 4
        }, react.createElement(default, {
            anchorPoint = Vector2.new(0.5, 0.5),
            color = Color3.new(1, 1, 1),
            overrideProps = {
                TextScaled = true,
                Font = p3.font or v1.textFont,
                ZIndex = zIndex + 4
            },
            position = UDim2.fromScale(0.5, 0.45),
            shadowYScale = p3.shadowYScale,
            strokeProps = {
                Thickness = 0.05
            },
            text = p3.label
        })))))
    end
}
