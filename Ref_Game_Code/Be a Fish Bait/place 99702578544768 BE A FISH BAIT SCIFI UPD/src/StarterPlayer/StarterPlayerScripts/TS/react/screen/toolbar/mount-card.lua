-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local default = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "brainrot-style", "br-frame").default
local default2 = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "brainrot-style", "popout-text-two").default
local default3 = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "brainrot-style", "popout-text-button").default
local default4 = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "brainrot-style", "preview-icon-button").default
local default5 = RuntimeLib.import(script, script.Parent.Parent, "exclusive-shop", "exclusive-shop-buy-button").default
local useTheme = RuntimeLib.import(script, script.Parent.Parent.Parent, "hooks", "use-theme").useTheme
local rarityColors = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "rarity-utils").rarityColors
local v1 = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(95, 255, 130)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(25, 190, 70))
})
local v2 = Color3.fromRGB(22, 120, 52)
local v3 = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(55, 55, 55)),
    ColorSequenceKeypoint.new(0.25, Color3.fromRGB(193, 193, 193)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(193, 193, 193)),
    ColorSequenceKeypoint.new(0.75, Color3.fromRGB(193, 193, 193)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(55, 55, 55))
})
local v4 = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 246, 135)),
    ColorSequenceKeypoint.new(0.32, Color3.fromRGB(255, 158, 70)),
    ColorSequenceKeypoint.new(0.68, Color3.fromRGB(255, 96, 190)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(90, 225, 255))
})
local v5 = Color3.fromRGB(255, 235, 80)
local exclusive = rarityColors.exclusive

return {
    default = function(p1) -- MountCard | line: 20
        -- upvalues: react (copy), default (copy), default2 (copy), default3 (copy), default4 (copy), default5 (copy), useTheme (copy), v1 (copy), v2 (copy), v3 (copy), v4 (copy), v5 (copy), exclusive (copy)
        local data, isActive, layoutOrder, onBuy = p1.data, p1.isActive, p1.layoutOrder, p1.onBuy
        local onEquip, onPreview, owned = p1.onEquip, p1.onPreview, p1.owned
        local v6 = useTheme()
        local v8 = math.round((data.speedMultiplier - 1) * 100)

        return react.createElement(default, {
            cornerRadius = 0.01,
            isStudded = true,
            strokeThickness = 0.01,
            textureTransparency = 0.6,
            tileSize = 80,
            transparency = 0.65,
            anchorPoint = Vector2.new(0.5, 0.5),
            backgroundColor = v3,
            layoutOrder = layoutOrder,
            position = UDim2.fromScale(0.5, 0.5),
            size = UDim2.fromScale(1, 1),
            strokeColor = Color3.fromRGB(64, 64, 64),
            zIndex = isActive and 10 or 1
        }, react.createElement("uiaspectratioconstraint", {
            AspectRatio = 1
        }), react.createElement(default4, {
            zIndex = 3,
            anchorPoint = Vector2.new(1, 0),
            onClick = onPreview,
            position = UDim2.fromScale(0.94, 0.055),
            size = UDim2.fromScale(0.16, 0.16)
        }), react.createElement("textlabel", {
            BackgroundTransparency = 1,
            TextScaled = true,
            ZIndex = 2,
            Font = Enum.Font.GothamBlack,
            Position = UDim2.fromScale(0.06, 0.055),
            Size = UDim2.fromScale(0.68, 0.11),
            Text = data.displayName,
            TextColor3 = Color3.fromRGB(255, 255, 255)
        }, react.createElement("uigradient", {
            Color = v4
        }), react.createElement("uistroke", {
            Thickness = 0.08,
            Color = Color3.fromRGB(0, 0, 0),
            StrokeSizingMode = Enum.StrokeSizingMode.ScaledSize
        })), react.createElement(default, {
            clipsDescendants = true,
            cornerRadius = 0.045,
            strokeThickness = 0.014,
            transparency = 0,
            zIndex = 2,
            anchorPoint = Vector2.new(0.5, 0),
            backgroundColor = Color3.fromRGB(9, 12, 18),
            position = UDim2.fromScale(0.5, 0.19),
            size = UDim2.fromScale(0.46, 0.35),
            strokeColor = exclusive
        }, react.createElement("imagelabel", {
            BackgroundTransparency = 1,
            Image = data.iconImageId,
            Position = UDim2.fromScale(0.03, 0.03),
            ScaleType = Enum.ScaleType.Fit,
            Size = UDim2.fromScale(0.94, 0.94)
        })), react.createElement("frame", {
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            ZIndex = 2,
            Position = UDim2.fromScale(0.08, 0.57),
            Size = UDim2.fromScale(0.84, 0.13)
        }, react.createElement(default2, {
            shadowYScale = 0.06,
            color = v5,
            overrideProps = {
                TextScaled = true,
                TextWrapped = true,
                ZIndex = 2,
                Font = v6.textFont2,
                Size = UDim2.fromScale(1, 1)
            },
            strokeProps = {
                Thickness = 0.045
            },
            text = data.description
        })), react.createElement("frame", {
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            ZIndex = 2,
            Position = UDim2.fromScale(0.08, 0.72),
            Size = UDim2.fromScale(0.84, 0.1)
        }, react.createElement(default2, {
            shadowYScale = 0.06,
            color = Color3.fromRGB(120, 255, 160),
            overrideProps = {
                TextScaled = true,
                TextWrapped = true,
                ZIndex = 2,
                Font = v6.textFont2,
                Size = UDim2.fromScale(1, 1)
            },
            strokeProps = {
                Thickness = 0.045
            },
            text = ("+%*%% MOVEMENT SPEED"):format(v8)
        })), if isActive then react.createElement("frame", {
            BackgroundTransparency = 1,
            ZIndex = 2,
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.fromScale(0.5, 0.895),
            Size = UDim2.fromScale(0.78, 0.13)
        }, react.createElement(default2, {
            shadowYScale = 0.06,
            text = "Active Mount",
            anchorPoint = Vector2.new(0.5, 0.5),
            color = Color3.fromRGB(76, 255, 118),
            overrideProps = {
                TextScaled = true,
                ZIndex = 2,
                Font = v6.textFont2,
                Size = UDim2.fromScale(1, 1)
            },
            position = UDim2.fromScale(0.5, 0.5),
            strokeProps = {
                Thickness = 0.05
            }
        }))
            elseif owned then react.createElement(default3, {
                isStudded = true,
                label = "EQUIP",
                zIndex = 2,
                color = v1,
                font = v6.textFont2,
                frameSize = UDim2.fromScale(0.78, 0.13),
                onClick = onEquip,
                popoutColor = v2,
                position = UDim2.fromScale(0.5, 0.895)
            })
            else react.createElement(default5, {
                zIndex = 2,
                anchorPoint = Vector2.new(0.5, 0.5),
                frameSize = UDim2.fromScale(0.78, 0.13),
                onClick = onBuy,
                position = UDim2.fromScale(0.5, 0.895),
                price = data.priceRobux,
                productId = data.productId
            }))
    end
}
