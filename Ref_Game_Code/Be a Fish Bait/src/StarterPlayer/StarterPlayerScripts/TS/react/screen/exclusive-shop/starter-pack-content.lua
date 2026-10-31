-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local useTheme = RuntimeLib.import(script, script.Parent.Parent.Parent, "hooks", "use-theme").useTheme
local images = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "images").images
local default = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "brainrot-style", "popout-text-two").default
local default2 = RuntimeLib.import(script, script.Parent, "exclusive-shop-purchase-buttons").default
local rarityColors = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "rarity-utils").rarityColors
local v1 = Color3.fromRGB(255, 255, 255)

local function ItemColumn(p1) -- line: 12
    -- upvalues: react (copy), useTheme (copy), images (copy), default (copy), rarityColors (copy)
    local v2 = useTheme()
    local iconScale = p1.iconScale

    if iconScale == nil then
        iconScale = 1
    end

    local createElement = react.createElement
    local t1 = {
        BackgroundTransparency = 1,
        ImageTransparency = 0.28,
        Rotation = 0,
        ZIndex = 3,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Image = images.shineBackground
    }
    local rayColor = p1.rayColor

    if not rayColor then
        rayColor = if p1.rarity ~= nil then rarityColors[p1.rarity] else Color3.fromRGB(255, 232, 82)
    end

    t1.ImageColor3 = rayColor
    t1.Position = UDim2.fromScale(0.5, 0.44)
    t1.Size = UDim2.fromScale(1.5, 1.5)

    local v3 = createElement("imagelabel", t1, react.createElement("uiaspectratioconstraint", {
        AspectRatio = 1
    }))
    local v4 = react.createElement("imagelabel", {
        BackgroundTransparency = 1,
        ZIndex = 4,
        AnchorPoint = Vector2.new(0.5, 0),
        Image = p1.icon,
        Position = UDim2.fromScale(0.5, 0.02),
        ScaleType = Enum.ScaleType.Fit,
        Size = UDim2.fromScale(1.3 * iconScale, 0.85 * iconScale)
    }, react.createElement("uiaspectratioconstraint", {
        AspectRatio = 1
    }))
    local v5

    if p1.titleLabel ~= nil then
        local v6 = react.createElement("frame", {
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            ZIndex = 4,
            AnchorPoint = Vector2.new(0.5, 0),
            Position = UDim2.fromScale(0.5, 0),
            Size = UDim2.fromScale(1, 0.5)
        }, react.createElement(default, {
            shadowYScale = 0.05,
            anchorPoint = Vector2.new(0.5, 0.5),
            color = Color3.new(1, 1, 1),
            overrideProps = {
                TextScaled = true,
                ZIndex = 4,
                Font = v2.textFont2,
                Size = UDim2.fromScale(1, 1),
                TextXAlignment = Enum.TextXAlignment.Center
            },
            position = UDim2.fromScale(0.5, 0.5),
            strokeProps = {
                Thickness = 0.08
            },
            text = p1.titleLabel
        }))
        local t2 = {
            shadowYScale = 0.05,
            anchorPoint = Vector2.new(0.5, 0.5),
            color = p1.subtitleColor or Color3.fromRGB(100, 255, 100),
            overrideProps = {
                TextScaled = true,
                ZIndex = 4,
                Font = v2.textFont2,
                Size = UDim2.fromScale(1, 1),
                TextXAlignment = Enum.TextXAlignment.Center
            },
            position = UDim2.fromScale(0.5, 0.5),
            strokeProps = {
                Thickness = 0.08
            }
        }
        local subtitleLabel = p1.subtitleLabel

        t2.text = if subtitleLabel == nil then "" else subtitleLabel
        v5 = react.createElement(react.Fragment, nil, v6, react.createElement("frame", {
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            ZIndex = 4,
            AnchorPoint = Vector2.new(0.5, 1),
            Position = UDim2.fromScale(0.5, 1),
            Size = UDim2.fromScale(1.08, 0.5)
        }, react.createElement(default, t2)))
    else
        v5 = react.createElement(default, {
            shadowYScale = 0.05,
            anchorPoint = Vector2.new(0.5, 0.5),
            color = Color3.new(1, 1, 1),
            overrideProps = {
                TextScaled = true,
                TextWrapped = true,
                ZIndex = 4,
                Font = v2.textFont2,
                Size = UDim2.fromScale(1, 1),
                TextXAlignment = Enum.TextXAlignment.Center
            },
            position = UDim2.fromScale(0.5, 0.5),
            strokeProps = {
                Thickness = 0.08
            },
            text = p1.label
        })
    end

    return react.createElement("frame", {
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ZIndex = 4,
        Size = UDim2.fromScale(0.28, 1)
    }, v3, v4, react.createElement("frame", {
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ZIndex = 4,
        AnchorPoint = Vector2.new(0.5, 1),
        Position = UDim2.fromScale(0.5, p1.titleLabel == nil and 1 or 1.04),
        Size = UDim2.fromScale(1.32, p1.titleLabel == nil and 0.22 or 0.34)
    }, v5))
end

local function PlusSeparator() -- line: 133
    -- upvalues: react (copy), useTheme (copy), default (copy)
    local v7 = useTheme()

    return react.createElement("frame", {
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ZIndex = 4,
        Size = UDim2.fromScale(0.11, 1)
    }, react.createElement(default, {
        shadowYScale = 0.06,
        text = "+",
        anchorPoint = Vector2.new(0.5, 0.5),
        color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 220, 90)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 160, 20))
        }),
        overrideProps = {
            TextScaled = true,
            ZIndex = 4,
            Font = v7.textFont2,
            Size = UDim2.fromScale(0.6, 0.45)
        },
        position = UDim2.fromScale(0.5, 0.42),
        strokeProps = {
            Thickness = 0.06
        }
    }))
end

return {
    default = function(p2) -- StarterPackContent | line: 157
        -- upvalues: react (copy), useTheme (copy), images (copy), default (copy), default2 (copy), v1 (copy), ItemColumn (copy), PlusSeparator (copy)
        local v8 = useTheme()
        local t5 = {}
        local items = p2.items

        local function v9(p3, p4) -- line: 163
            -- upvalues: t5 (copy), react (copy), ItemColumn (copy), PlusSeparator (copy)
            if p4 > 0 then
                table.insert(t5, (react.createElement(PlusSeparator, {
                    key = ("plus-%*"):format(p4)
                })))
            end

            table.insert(t5, (react.createElement(ItemColumn, {
                icon = p3.icon,
                key = ("item-%*"):format(p4),
                label = p3.label,
                rarity = p3.rarity,
                rayColor = p3.rayColor,
                subtitleColor = p3.subtitleColor,
                subtitleLabel = p3.subtitleLabel,
                titleLabel = p3.titleLabel
            })))
        end

        for v12, v13 in items do
            v9(v13, v12 - 1, items)
        end

        local t6 = {
            shadowYScale = 0.06,
            color = v1,
            overrideProps = {
                TextScaled = true,
                ZIndex = 4,
                Font = v8.textFont2,
                Size = UDim2.fromScale(1, 1),
                TextXAlignment = Enum.TextXAlignment.Left
            },
            strokeProps = {
                Thickness = 0.08
            }
        }
        local title = p2.title

        t6.text = if title == nil then "Starter Pack" else title

        return react.createElement("frame", {
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            ZIndex = 3,
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.fromScale(0.5, 0.5),
            Size = UDim2.fromScale(0.94, 0.88)
        }, react.createElement("frame", {
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            ZIndex = 10,
            AnchorPoint = Vector2.new(0, 0),
            Position = UDim2.fromScale(0.01, 0.02),
            Size = UDim2.fromScale(0.48, 0.22)
        }, react.createElement(default, t6)), react.createElement("frame", {
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            ZIndex = 4,
            AnchorPoint = Vector2.new(0, 1),
            Position = UDim2.fromScale(0.01, 0.9),
            Size = UDim2.fromScale(0.64, 0.66)
        }, react.createElement("uilistlayout", {
            FillDirection = Enum.FillDirection.Horizontal,
            HorizontalAlignment = Enum.HorizontalAlignment.Left,
            SortOrder = Enum.SortOrder.LayoutOrder,
            VerticalAlignment = Enum.VerticalAlignment.Center
        }), t5), react.createElement("frame", {
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            ZIndex = 4,
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.fromScale(0.815, 0.55),
            Size = UDim2.fromScale(0.2, 0.2)
        }, react.createElement("frame", {
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            ZIndex = 4,
            Size = UDim2.fromScale(1, 1)
        }, react.createElement("uilistlayout", {
            FillDirection = Enum.FillDirection.Horizontal,
            HorizontalAlignment = Enum.HorizontalAlignment.Right,
            Padding = UDim.new(0.02, 0),
            SortOrder = Enum.SortOrder.LayoutOrder,
            VerticalAlignment = Enum.VerticalAlignment.Center
        }), react.createElement("imagelabel", {
            BackgroundTransparency = 1,
            LayoutOrder = 0,
            ZIndex = 4,
            Image = images.robuxIcon,
            ScaleType = Enum.ScaleType.Fit,
            Size = UDim2.fromScale(0.35, 0.85)
        }, react.createElement("uiaspectratioconstraint", {
            AspectRatio = 1
        })), react.createElement("textlabel", {
            BackgroundTransparency = 1,
            LayoutOrder = 1,
            TextScaled = true,
            ZIndex = 4,
            Font = v8.textFont,
            Size = UDim2.fromScale(0.5, 1),
            Text = tostring(p2.originalPrice),
            TextColor3 = Color3.fromRGB(255, 255, 255),
            TextXAlignment = Enum.TextXAlignment.Left
        }, react.createElement("uistroke", {
            Thickness = 0.06,
            Color = Color3.new(0, 0, 0),
            StrokeSizingMode = Enum.StrokeSizingMode.ScaledSize
        }))), react.createElement("frame", {
            BorderSizePixel = 0,
            Rotation = 8,
            ZIndex = 5,
            AnchorPoint = Vector2.new(0.5, 0.5),
            BackgroundColor3 = Color3.fromRGB(230, 30, 30),
            Position = UDim2.fromScale(0.54, 0.5),
            Size = UDim2.fromScale(0.9, 0.16)
        }, react.createElement("uicorner", {
            CornerRadius = UDim.new(1, 0)
        }), react.createElement("uistroke", {
            Thickness = 0.15,
            Color = Color3.fromRGB(120, 0, 0),
            StrokeSizingMode = Enum.StrokeSizingMode.ScaledSize
        }))), react.createElement(default2, {
            zIndex = 4,
            onBuy = p2.onBuy,
            onGift = p2.onGift,
            owned = p2.owned,
            position = UDim2.fromScale(0.99, 0.9),
            price = p2.price,
            productId = p2.productId,
            size = UDim2.fromScale(0.27, 0.24)
        }))
    end
}
