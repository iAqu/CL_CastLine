-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local useEffect = react.useEffect
local useMotion = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "pretty-react-hooks", "out").useMotion
local abbreviate = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "abbreviate").abbreviate
local default = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "brainrot-style", "br-frame").default
local default2 = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "brainrot-style", "popout-text-two").default
local useTheme = RuntimeLib.import(script, script.Parent.Parent.Parent, "hooks", "use-theme").useTheme
local images = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "images").images
local v1 = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "data", "rebirth-utils")
local getRebirthPowerCost, isMaxRebirth = v1.getRebirthPowerCost, v1.isMaxRebirth
local t1 = {
    slideArrival = 1,
    barFadeIn = 1.5
}
local t2 = {
    dark = Color3.fromRGB(0, 170, 0),
    light = Color3.fromRGB(120, 255, 60)
}
local t3 = {
    dark = Color3.fromRGB(160, 140, 0),
    light = Color3.fromRGB(255, 230, 50)
}
local t4 = {
    dark = Color3.fromRGB(200, 70, 0),
    light = Color3.fromRGB(255, 160, 40)
}
local t5 = {
    dark = Color3.fromRGB(180, 0, 0),
    light = Color3.fromRGB(255, 60, 40)
}

local function buildFillGradient(p1) -- line: 37
    -- upvalues: t2 (copy), t3 (copy), t4 (copy), t5 (copy)
    local v2, v3

    if p1 <= 0.3333333333333333 then
        local v4 = p1 / 0.3333333333333333

        v2 = t2.dark:Lerp(t3.dark, v4)
        v3 = t2.light:Lerp(t3.light, v4)
    elseif p1 <= 0.6666666666666666 then
        local v5 = (p1 - 0.3333333333333333) / 0.3333333333333333

        v2 = t3.dark:Lerp(t4.dark, v5)
        v3 = t3.light:Lerp(t4.light, v5)
    else
        local v6 = (p1 - 0.6666666666666666) / 0.3333333333333333

        v2 = t4.dark:Lerp(t5.dark, v6)
        v3 = t4.light:Lerp(t5.light, v6)
    end

    return ColorSequence.new({
        ColorSequenceKeypoint.new(0, v2),
        ColorSequenceKeypoint.new(0.5, v3),
        ColorSequenceKeypoint.new(1, v2)
    })
end

local v7 = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(200, 75, 0)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(240, 145, 20)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 185, 40))
})
local v8 = Color3.fromRGB(255, 215, 60)
local v9 = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(180, 0, 0)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 60, 40)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(180, 0, 0))
})

return {
    default = function(p2) -- CastPowerCapBar | line: 72
        -- upvalues: react (copy), useEffect (copy), useMotion (copy), abbreviate (copy), default (copy), default2 (copy), useTheme (copy), images (copy), getRebirthPowerCost (copy), isMaxRebirth (copy), buildFillGradient (copy), v7 (copy), v8 (copy), v9 (copy)
        local forceVisible, powerCap, rawPower, rebirthCount = p2.forceVisible, p2.powerCap, p2.rawPower, p2.rebirthCount
        local rodImageId, hidden, visible = p2.rodImageId, p2.hidden, p2.visible
        local v10 = visible

        if visible == nil then
            v10 = true
        end

        local v11 = useTheme()
        local v12 = powerCap <= rawPower
        local v14 = math.clamp(rawPower / powerCap, 0, 1)
        local v15 = if rebirthCount == nil or isMaxRebirth(rebirthCount) then 1e999 else getRebirthPowerCost(rebirthCount)
        local v16 = v15 / powerCap
        local v17 = v16 < 1 and v15 ~= 1e999
        local v18, v19 = useMotion(UDim2.fromScale(0.5, -0.4))

        useEffect(function() -- line: 92
            -- upvalues: v10 (ref), v19 (copy)
            v19:tween(UDim2.fromScale(0.5, if v10 then 0.15 else -0.4), {
                time = 0.3,
                style = Enum.EasingStyle.Back,
                direction = if v10 then Enum.EasingDirection.Out else Enum.EasingDirection.In
            })
        end, { v10, v19 })

        if not (forceVisible or hidden ~= true and powerCap ~= 1e999) then
            return nil
        end

        local v21 = buildFillGradient(v14)
        local v22 = react.createElement("uiaspectratioconstraint", {
            AspectRatio = 4.55
        })
        local v23 = react.createElement(default2, {
            textTransparency = 0,
            anchorPoint = Vector2.new(0.5, 1),
            color = if v12 then Color3.fromRGB(255, 70, 37) else Color3.fromRGB(255, 255, 255),
            overrideProps = {
                TextScaled = true,
                ZIndex = 10,
                Font = v11.textFont2,
                Size = UDim2.fromScale(1, 0.35),
                TextXAlignment = Enum.TextXAlignment.Center
            },
            position = UDim2.fromScale(0.5, 0.22999999999999998),
            text = v12 and "Rod Power Cap Reached!" or "Rod Power Output"
        })
        local v24 = react.createElement(default, {
            clipsDescendants = false,
            cornerRadius = 0.1,
            isStudded = true,
            isStuddedTransparency = 0.8,
            strokeThickness = 0.1,
            strokeTransparency = 0,
            textureTransparency = 0,
            tileSize = 90,
            transparency = 0,
            zIndex = 1,
            anchorPoint = Vector2.new(0, 0.5),
            backgroundColor = Color3.fromRGB(180, 180, 180),
            position = UDim2.fromScale(0, 0.48),
            size = UDim2.fromScale(0.82, 0.22),
            strokeColor = Color3.fromRGB(20, 20, 20)
        }, react.createElement("frame", {
            BackgroundTransparency = 0.4,
            BorderSizePixel = 0,
            ZIndex = 2,
            AnchorPoint = Vector2.new(0, 0.5),
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
            Position = UDim2.fromScale(0, 0.5),
            Size = UDim2.fromScale(v14, 1)
        }, react.createElement("uicorner", {
            CornerRadius = UDim.new(0.1, 0)
        }), react.createElement("uigradient", {
            Rotation = 90,
            Color = v21
        }), not v12 and react.createElement("frame", {
            BackgroundTransparency = 0.4,
            BorderSizePixel = 0,
            ZIndex = 3,
            AnchorPoint = Vector2.new(1, 0.5),
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
            Position = UDim2.fromScale(1, 0.5),
            Size = UDim2.fromScale(0.01, 1)
        }, react.createElement("uigradient", {
            Rotation = 90,
            Color = v21
        }), react.createElement("frame", {
            BackgroundTransparency = 0,
            BorderSizePixel = 0,
            ZIndex = 4,
            AnchorPoint = Vector2.new(0, 0.5),
            BackgroundColor3 = Color3.fromRGB(0, 0, 0),
            Position = UDim2.fromScale(0, 0.5),
            Size = UDim2.fromScale(1, 1)
        }))), v17 and react.createElement(default, {
            cornerRadius = 0.1,
            strokeThickness = 0.3,
            strokeTransparency = 0,
            transparency = 0,
            zIndex = 5,
            anchorPoint = Vector2.new(0.5, 0.5),
            backgroundColor = v9,
            position = UDim2.fromScale(v16, 0.5),
            size = UDim2.fromScale(0.008, 1.2),
            strokeColor = Color3.fromRGB(0, 0, 0)
        }))
        local v25 = rodImageId ~= nil and react.createElement("imagelabel", {
            BackgroundTransparency = 1,
            ImageTransparency = 0,
            ZIndex = 9,
            AnchorPoint = Vector2.new(0.5, 0.5),
            Image = rodImageId,
            Position = UDim2.fromScale(0.875, 0.5),
            Size = UDim2.fromScale(0.4, 0.4)
        }, react.createElement("uiaspectratioconstraint", {
            AspectRatio = 1
        }))
        local v28 = react.createElement("frame", {
            BackgroundTransparency = 1,
            ZIndex = 6,
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.new(1, 0, 0.48, 0),
            Size = if v12 then UDim2.fromScale(0.2, 0.47) else UDim2.fromScale(0.16, 0.5)
        }, react.createElement("uilistlayout", {
            FillDirection = Enum.FillDirection.Vertical,
            HorizontalAlignment = Enum.HorizontalAlignment.Center,
            Padding = UDim.new(0.04, 0),
            SortOrder = Enum.SortOrder.LayoutOrder,
            VerticalAlignment = Enum.VerticalAlignment.Center
        }), react.createElement(default2, {
            textTransparency = 0,
            color = if v12 then v7 else v8,
            overrideProps = {
                LayoutOrder = 1,
                TextScaled = true,
                ZIndex = 6,
                Font = v11.textFont2,
                Size = if v12 then UDim2.fromScale(1, 0.6382978723404256) else UDim2.fromScale(1, 0.6),
                TextXAlignment = Enum.TextXAlignment.Center
            },
            strokeProps = {
                Thickness = 0.06
            },
            text = abbreviate(powerCap)
        }), react.createElement(default2, {
            textTransparency = 0,
            color = if v12 then v7 else v8,
            overrideProps = {
                LayoutOrder = 2,
                TextScaled = true,
                ZIndex = 6,
                Font = v11.textFont2,
                Size = UDim2.fromScale(1.5, 0.35),
                TextXAlignment = Enum.TextXAlignment.Center
            },
            strokeProps = {
                Thickness = 0.06
            },
            text = v12 and "Rod Cap Reached!" or "Rod Cap"
        }))
        local v29 = not v12 and react.createElement("frame", {
            BackgroundTransparency = 1,
            ZIndex = 6,
            AnchorPoint = Vector2.new(0, 0),
            Position = UDim2.fromScale(0, 0.63),
            Size = UDim2.fromScale(0.82, 0.72)
        }, react.createElement("imagelabel", {
            BackgroundTransparency = 1,
            ImageTransparency = 0,
            Rotation = 180,
            ZIndex = 7,
            AnchorPoint = Vector2.new(0.5, 0),
            Image = images.triangleIcon,
            ImageColor3 = Color3.fromRGB(0, 0, 0),
            Position = UDim2.fromScale(v14, -0.05),
            Size = UDim2.fromScale(0.03, 0.25)
        }, react.createElement("uiaspectratioconstraint", {
            AspectRatio = 1
        })), react.createElement("frame", {
            BackgroundTransparency = 1,
            ZIndex = 8,
            AnchorPoint = Vector2.new(0.5, 0),
            Position = UDim2.fromScale(v14, 0.24),
            Size = UDim2.fromScale(0.25, 0.38888888888888895)
        }, react.createElement(default2, {
            textTransparency = 0,
            anchorPoint = Vector2.new(0.5, 0.5),
            color = v7,
            overrideProps = {
                TextScaled = true,
                ZIndex = 6,
                Font = v11.textFont2,
                Size = UDim2.fromScale(0.74, 1.1),
                TextXAlignment = Enum.TextXAlignment.Center
            },
            position = UDim2.fromScale(0.505, 0.5),
            strokeProps = {
                Thickness = 0.06
            },
            text = abbreviate(rawPower)
        })), react.createElement(default2, {
            text = "Current power",
            textTransparency = 0,
            anchorPoint = Vector2.new(0.5, 0),
            color = v7,
            overrideProps = {
                TextScaled = true,
                ZIndex = 8,
                Font = v11.textFont2,
                Size = UDim2.fromScale(0.29000000000000004, 0.29),
                TextXAlignment = Enum.TextXAlignment.Center
            },
            position = UDim2.fromScale(v14, 0.6488888888888888),
            strokeProps = {
                Thickness = 0.06
            }
        }))

        if v17 then
            local t12 = {
                anchorPoint = Vector2.new(0.5, 0),
                color = v9,
                overrideProps = {
                    TextScaled = true,
                    ZIndex = 8,
                    Font = v11.textFont2,
                    Size = UDim2.fromScale(0.205, 0.14),
                    TextXAlignment = Enum.TextXAlignment.Center
                },
                position = UDim2.fromScale(v16 * 0.82, 0.6407999999999999),
                strokeProps = {
                    Thickness = 0.06
                },
                text = `Rebirth { (if rebirthCount == nil then 0 else rebirthCount) + 1 }`,
                textTransparency = 0
            }

            v17 = react.createElement(default2, t12)
        end

        return react.createElement("frame", {
            BackgroundTransparency = 1,
            ZIndex = 5,
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = v18,
            Size = UDim2.fromScale(0.38, 0.16)
        }, v22, v23, v24, v25, v28, v29, v17)
    end,
    castPowerCapTimings = t1
}
