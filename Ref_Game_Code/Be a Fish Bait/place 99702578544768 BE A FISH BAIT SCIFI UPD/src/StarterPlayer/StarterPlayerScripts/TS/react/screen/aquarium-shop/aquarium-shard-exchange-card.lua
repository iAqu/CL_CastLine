-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local useMotion = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "pretty-react-hooks", "out").useMotion
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local useEffect, useState = react.useEffect, react.useState
local default = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "brainrot-style", "br-frame").default
local default2 = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "brainrot-style", "popout-text-two").default
local default3 = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "brainrot-style", "popout-text-button").default
local useTheme = RuntimeLib.import(script, script.Parent.Parent.Parent, "hooks", "use-theme").useTheme
local default4 = RuntimeLib.import(script, script.Parent.Parent, "exclusive-shop", "long-shop-section").default
local images = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "images").images
local v1 = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "rarity-utils")
local getRarityBorderColor, getRarityColor, getRarityDisplayName = v1.getRarityBorderColor, v1.getRarityColor, v1.getRarityDisplayName
local v2 = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(89, 255, 80)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(17, 172, 56))
})
local v3 = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(62, 223, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(31, 101, 228))
})
local v4 = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 105, 164)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(184, 45, 112))
})
local v5 = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 70, 100)),
    ColorSequenceKeypoint.new(0.17, Color3.fromRGB(255, 220, 70)),
    ColorSequenceKeypoint.new(0.34, Color3.fromRGB(80, 255, 120)),
    ColorSequenceKeypoint.new(0.51, Color3.fromRGB(80, 220, 255)),
    ColorSequenceKeypoint.new(0.68, Color3.fromRGB(120, 110, 255)),
    ColorSequenceKeypoint.new(0.85, Color3.fromRGB(255, 90, 230)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 70, 100))
})

local function getShardImage(p1) -- line: 22
    -- upvalues: images (copy)
    if p1 == "epic" then
        return images.epicShard
    end

    if p1 == "legendary" then
        return images.legendaryShard
    end

    if p1 == "mythic" then
        return images.mythicShard
    end

    return images.rareShard
end

local function ShardIcon(p2) -- line: 34
    -- upvalues: react (copy), default (copy), default2 (copy), useTheme (copy)
    local v6 = useTheme()

    return react.createElement("frame", {
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Position = p2.position,
        Size = UDim2.fromScale(0.18, 0.72),
        ZIndex = p2.zIndex
    }, p2.strokeGradient ~= nil and react.createElement("frame", {
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromScale(0.5, 0.5),
        Size = UDim2.fromScale(1, 1),
        ZIndex = p2.zIndex + 5
    }, react.createElement("uicorner", {
        CornerRadius = UDim.new(0.12, 0)
    }), react.createElement("uistroke", {
        Thickness = 0.035,
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
        Color = Color3.fromRGB(255, 255, 255),
        StrokeSizingMode = Enum.StrokeSizingMode.ScaledSize
    }, react.createElement("uigradient", {
        Color = p2.strokeGradient,
        Rotation = p2.strokeGradientRotation or 0
    }))), react.createElement("uiaspectratioconstraint", {
        AspectRatio = 1,
        DominantAxis = Enum.DominantAxis.Width
    }), react.createElement(default, {
        cornerRadius = 0.12,
        isStudded = true,
        isStuddedTransparency = 0.35,
        strokeThickness = 0.035,
        textureTransparency = 0.76,
        anchorPoint = Vector2.new(0.5, 0.5),
        backgroundColor = Color3.fromRGB(10, 19, 36),
        position = UDim2.fromScale(0.5, 0.5),
        size = UDim2.fromScale(1, 1),
        strokeColor = if p2.strokeGradient == nil then p2.color else Color3.fromRGB(3, 5, 8),
        zIndex = p2.zIndex + 1
    }, react.createElement("imagelabel", {
        BackgroundTransparency = 1,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Image = p2.image,
        Position = UDim2.fromScale(0.5, 0.45),
        ScaleType = Enum.ScaleType.Fit,
        Size = UDim2.fromScale(0.82, 0.68),
        ZIndex = p2.zIndex + 2
    }), react.createElement(default2, {
        shadowYScale = 0.04,
        color = Color3.fromRGB(255, 255, 255),
        overrideProps = {
            TextScaled = true,
            TextWrapped = true,
            Font = Enum.Font.FredokaOne,
            Position = UDim2.fromScale(0.06, 0.77),
            Size = UDim2.fromScale(0.88, 0.15),
            ZIndex = p2.zIndex + 3
        },
        strokeProps = {
            Thickness = 0.05
        },
        text = p2.label
    })), react.createElement(default2, {
        shadowYScale = 0.04,
        anchorPoint = Vector2.new(0, 0.5),
        color = Color3.fromRGB(255, 255, 255),
        overrideProps = {
            TextScaled = true,
            Font = v6.textFont2,
            Size = UDim2.fromScale(0.46, 0.24),
            TextXAlignment = Enum.TextXAlignment.Left,
            ZIndex = p2.zIndex + 6
        },
        position = UDim2.fromScale(-0.05, -0.025),
        strokeProps = {
            Thickness = 0.115,
            Color = Color3.fromRGB(0, 0, 0)
        },
        text = p2.quantityLabel
    }))
end

return {
    default = function(p3) -- AquariumShardExchangeCard | line: 117
        -- upvalues: useMotion (copy), react (copy), useEffect (copy), useState (copy), default (copy), default3 (copy), useTheme (copy), default4 (copy), images (copy), getRarityBorderColor (copy), getRarityColor (copy), getRarityDisplayName (copy), v2 (copy), v3 (copy), v4 (copy), v5 (copy), ShardIcon (copy)
        local v9 = useTheme()
        local v10, v11 = useMotion(0)
        local v13 = math.floor(p3.sourceBalance / p3.sourceShardsPerCraft)
        local v14, v15 = useState(1)
        local v16, v17 = useState("1")
        local v18 = p3.source == "wild"
        local v19 = if p3.source == "wild" then Color3.fromRGB(132, 226, 255) else getRarityColor(p3.source).Keypoints[1].Value
        local Value = getRarityColor(p3.targetRarity).Keypoints[1].Value
        local v20 = v13 > 0 and v14 <= v13
        local v21

        if p3.source == "wild" then
            v21 = images.universalShard
        else
            local source = p3.source

            v21 = if source == "epic" then images.epicShard
                elseif source == "legendary" then images.legendaryShard
                elseif source == "mythic" then images.mythicShard
                else images.rareShard
        end

        local v22 = if p3.source == "wild" then "WILD" else string.upper(getRarityDisplayName(p3.source))
        local targetRarity = p3.targetRarity
        local v23 = if targetRarity == "epic" then images.epicShard
            elseif targetRarity == "legendary" then images.legendaryShard
            elseif targetRarity == "mythic" then images.mythicShard
            else images.rareShard

        useEffect(function() -- line: 130
            -- upvalues: v11 (copy)
            v11:linear(360, {
                speed = 90
            })

            local v24 = v11:onComplete(function() -- line: 137
                -- upvalues: v11 (copy)
                v11:immediate(0)
                v11:linear(360, {
                    speed = 90
                })
            end)

            return function() -- line: 141
                -- upvalues: v24 (copy)
                return v24()
            end
        end, { v11 })
        useEffect(function() -- line: 145
            -- upvalues: v13 (copy), v14 (copy), v15 (copy), v17 (copy)
            local v26 = math.clamp(v14, 1, (math.max(1, v13)))

            if v26 ~= v14 then
                v15(v26)
            end

            v17((tostring(v26)))
        end, { v13, v14 })

        local function v27(p4) -- line: 152
            -- upvalues: v13 (copy), v14 (copy), v15 (copy), v17 (copy)
            local v28 = tonumber(p4)

            if v28 == nil then
                v17((tostring(v14)))

                return nil
            end

            local v31 = math.clamp(math.floor(v28), 1, (math.max(1, v13)))

            v15(v31)
            v17((tostring(v31)))
        end

        local createElement = react.createElement
        local t3 = {
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            LayoutOrder = p3.layoutOrder,
            Size = UDim2.fromScale(1, 0.4)
        }
        local createElement2 = react.createElement
        local t4 = {
            sectionType = "LongBlackSection",
            zIndex = 4,
            size = UDim2.fromScale(1, 1)
        }
        local createElement3 = react.createElement
        local t5 = {
            zIndex = 6,
            color = v19,
            image = v21,
            label = v22,
            position = UDim2.fromScale(0.025, 0.14),
            quantityLabel = ("x%*"):format(p3.sourceShardsPerCraft)
        }

        if v18 then
            t5.strokeGradient = v5
        else
            v10 = nil
            t5.strokeGradient = nil
        end

        t5.strokeGradientRotation = v10

        return createElement("frame", t3, createElement2(default4, t4, createElement3(ShardIcon, t5), react.createElement("imagelabel", {
            BackgroundTransparency = 1,
            ZIndex = 8,
            AnchorPoint = Vector2.new(0.5, 0.5),
            Image = images.arrowRight,
            Position = UDim2.fromScale(0.285, 0.5),
            ScaleType = Enum.ScaleType.Fit,
            Size = UDim2.fromScale(0.12, 0.38)
        }, react.createElement("uiaspectratioconstraint", {
            AspectRatio = 1
        })), react.createElement(ShardIcon, {
            quantityLabel = "x1",
            zIndex = 6,
            color = Value,
            image = v23,
            label = string.upper(getRarityDisplayName(p3.targetRarity)),
            position = UDim2.fromScale(0.37, 0.14)
        }), react.createElement(default3, {
            isStudded = true,
            label = "-",
            zIndex = 8,
            anchorPoint = Vector2.new(0.5, 0),
            color = v4,
            disabled = v14 <= 1,
            font = v9.textFont,
            frameSize = UDim2.fromScale(0.07, 0.25),
            onClick = function() -- onClick | line: 205
                -- upvalues: v14 (copy), v15 (copy)
                return v15((math.max(1, v14 - 1)))
            end,
            popoutColor = Color3.fromRGB(128, 36, 86),
            position = UDim2.fromScale(0.705, 0.14),
            size = UDim2.fromScale(0.68, 0.58)
        }), react.createElement(default, {
            cornerRadius = 0.08,
            isStudded = true,
            isStuddedTransparency = 0.45,
            strokeThickness = 0.025,
            textureTransparency = 0.9,
            zIndex = 7,
            backgroundColor = Color3.fromRGB(45, 48, 56),
            position = UDim2.fromScale(0.74, 0.14),
            size = UDim2.fromScale(0.12, 0.25),
            strokeColor = Color3.fromRGB(12, 14, 20)
        }, react.createElement("textbox", {
            BackgroundTransparency = 1,
            ClearTextOnFocus = false,
            TextScaled = true,
            TextStrokeTransparency = 0,
            ZIndex = 9,
            Change = {
                Text = function(p5) -- Text | line: 226
                    -- upvalues: v17 (copy)
                    return v17(p5.Text)
                end
            },
            Event = {
                FocusLost = function(p6) -- FocusLost | line: 232
                    -- upvalues: v27 (copy)
                    return v27(p6.Text)
                end
            },
            Font = v9.textFont,
            Position = UDim2.fromScale(0.08, 0.12),
            Size = UDim2.fromScale(0.84, 0.72),
            Text = v16,
            TextColor3 = Color3.fromRGB(255, 255, 255),
            TextStrokeColor3 = Color3.fromRGB(0, 0, 0),
            TextXAlignment = Enum.TextXAlignment.Center
        })), react.createElement(default3, {
            isStudded = true,
            label = "+",
            zIndex = 8,
            anchorPoint = Vector2.new(0.5, 0),
            color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.fromRGB(167, 255, 132)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(69, 197, 73))
            }),
            disabled = v13 <= v14,
            font = v9.textFont,
            frameSize = UDim2.fromScale(0.07, 0.25),
            onClick = function() -- onClick | line: 254
                -- upvalues: v13 (copy), v14 (copy), v15 (copy)
                return v15((math.min(v13, v14 + 1)))
            end,
            popoutColor = Color3.fromRGB(44, 122, 57),
            position = UDim2.fromScale(0.895, 0.14),
            size = UDim2.fromScale(0.68, 0.58)
        }), react.createElement(default3, {
            isShiny = true,
            isStudded = true,
            label = "MAX",
            zIndex = 8,
            color = v3,
            disabled = v13 <= 0,
            font = v9.textFont,
            frameSize = UDim2.fromScale(0.19, 0.28),
            onClick = function() -- onClick | line: 269
                -- upvalues: v13 (copy), v15 (copy)
                return v15((math.max(1, v13)))
            end,
            popoutColor = Color3.fromRGB(19, 81, 162),
            position = UDim2.fromScale(0.69, 0.62),
            size = UDim2.fromScale(0.78, 0.6)
        }), react.createElement(default3, {
            isShiny = true,
            isStudded = true,
            label = "CRAFT",
            zIndex = 8,
            color = v2,
            disabled = not v20,
            font = v9.textFont,
            frameSize = UDim2.fromScale(0.19, 0.28),
            onClick = function() -- onClick | line: 284
                -- upvalues: p3 (copy), v14 (copy)
                return p3.onCraft(v14)
            end,
            popoutColor = Color3.fromRGB(13, 125, 40),
            position = UDim2.fromScale(0.89, 0.62),
            size = UDim2.fromScale(0.78, 0.6),
            strokeColor = getRarityBorderColor(p3.targetRarity)
        })))
    end
}
