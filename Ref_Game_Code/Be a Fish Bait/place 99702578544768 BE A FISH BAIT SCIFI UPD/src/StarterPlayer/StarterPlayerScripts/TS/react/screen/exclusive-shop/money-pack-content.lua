-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local useTheme = RuntimeLib.import(script, script.Parent.Parent.Parent, "hooks", "use-theme").useTheme
local images = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "images").images
local default = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "brainrot-style", "popout-text-two").default
local default2 = RuntimeLib.import(script, script.Parent, "exclusive-shop-buy-button").default
local default3 = RuntimeLib.import(script, script.Parent, "exclusive-shop-purchase-buttons").default
local v1 = Color3.fromRGB(255, 255, 255)

local function CrossedPrice(p1) -- line: 12
    -- upvalues: react (copy), useTheme (copy), images (copy)
    local v2 = useTheme()

    return react.createElement("frame", {
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ZIndex = 5,
        AnchorPoint = Vector2.new(1, 0.5),
        Position = UDim2.fromScale(0.97, 0.62),
        Size = UDim2.fromScale(0.42, 0.18)
    }, react.createElement("frame", {
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ZIndex = 5,
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
        ZIndex = 5,
        Image = images.robuxIcon,
        ScaleType = Enum.ScaleType.Fit,
        Size = UDim2.fromScale(0.32, 0.7)
    }, react.createElement("uiaspectratioconstraint", {
        AspectRatio = 1
    })), react.createElement("textlabel", {
        BackgroundTransparency = 1,
        LayoutOrder = 1,
        TextScaled = true,
        ZIndex = 5,
        Font = v2.textFont,
        Size = UDim2.fromScale(0.55, 0.8),
        Text = tostring(p1.price),
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextXAlignment = Enum.TextXAlignment.Left
    }, react.createElement("uistroke", {
        Thickness = 0.06,
        Color = Color3.new(0, 0, 0),
        StrokeSizingMode = Enum.StrokeSizingMode.ScaledSize
    }))), react.createElement("frame", {
        BorderSizePixel = 0,
        Rotation = 8,
        ZIndex = 6,
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = Color3.fromRGB(230, 30, 30),
        Position = UDim2.fromScale(0.52, 0.5),
        Size = UDim2.fromScale(0.62, 0.12)
    }, react.createElement("uicorner", {
        CornerRadius = UDim.new(1, 0)
    }), react.createElement("uistroke", {
        Thickness = 0.15,
        Color = Color3.fromRGB(120, 0, 0),
        StrokeSizingMode = Enum.StrokeSizingMode.ScaledSize
    })))
end

return {
    default = function(p2) -- MoneyPackContent | line: 71
        -- upvalues: react (copy), useTheme (copy), images (copy), default (copy), default2 (copy), default3 (copy), v1 (copy), CrossedPrice (copy)
        local v5 = useTheme()
        local v6 = p2.originalPrice ~= nil
        local v9 = react.createElement("frame", {
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            ZIndex = 10,
            AnchorPoint = Vector2.new(0.5, 0),
            Position = UDim2.fromScale(0.5, 0.01),
            Size = UDim2.fromScale(0.92, p2.subtitle == nil and 0.2 or 0.29)
        }, if p2.subtitle == nil then react.createElement(default, {
            shadowYScale = 0.06,
            anchorPoint = Vector2.new(0.5, 0.5),
            color = p2.titleColor or v1,
            overrideProps = {
                TextScaled = true,
                TextWrapped = true,
                ZIndex = 4,
                Font = v5.textFont2,
                Size = UDim2.fromScale(1, 1),
                TextXAlignment = Enum.TextXAlignment.Center
            },
            position = UDim2.fromScale(0.5, 0.5),
            strokeProps = {
                Thickness = 0.08
            },
            text = p2.title
        }) else react.createElement(react.Fragment, nil, react.createElement("frame", {
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            ZIndex = 10,
            AnchorPoint = Vector2.new(0.5, 0),
            Position = UDim2.fromScale(0.5, 0),
            Size = UDim2.fromScale(1, 0.58)
        }, react.createElement(default, {
            shadowYScale = 0.06,
            anchorPoint = Vector2.new(0.5, 0.5),
            color = p2.titleColor or v1,
            overrideProps = {
                TextScaled = true,
                ZIndex = 4,
                Font = v5.textFont2,
                Size = UDim2.fromScale(1, 1),
                TextXAlignment = Enum.TextXAlignment.Center
            },
            position = UDim2.fromScale(0.5, 0.5),
            strokeProps = {
                Thickness = 0.08
            },
            text = p2.title
        })), react.createElement("frame", {
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            ZIndex = 10,
            AnchorPoint = Vector2.new(0.5, 1),
            Position = UDim2.fromScale(v6 and 0.66 or 0.5, 1),
            Size = UDim2.fromScale(0.75, 0.42)
        }, react.createElement(default, {
            shadowYScale = 0.06,
            anchorPoint = Vector2.new(0.5, 0.5),
            color = p2.subtitleColor or Color3.fromRGB(100, 255, 100),
            overrideProps = {
                TextScaled = true,
                ZIndex = 4,
                Font = v5.textFont2,
                Size = UDim2.fromScale(1, 1),
                TextXAlignment = Enum.TextXAlignment.Center
            },
            position = UDim2.fromScale(0.5, 0.5),
            strokeProps = {
                Thickness = 0.08
            },
            text = p2.subtitle
        }))))
        local t10 = {
            BackgroundTransparency = 1,
            AnchorPoint = Vector2.new(0.5, 0.5)
        }
        local icon = p2.icon

        t10.Image = if icon == nil then images.money else icon
        t10.Position = UDim2.fromScale(v6 and 0.34 or 0.5, 0.48)
        t10.ScaleType = Enum.ScaleType.Fit
        t10.Size = p2.iconSize or UDim2.fromScale(1, 0.72)
        t10.ZIndex = 4

        return react.createElement("frame", {
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            ZIndex = 3,
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.fromScale(0.5, 0.5),
            Size = UDim2.fromScale(0.92, 0.9)
        }, v9, react.createElement("imagelabel", t10, react.createElement("uiaspectratioconstraint", {
            AspectRatio = 1
        })), if v6 then react.createElement(CrossedPrice, {
            price = p2.originalPrice
        }) else nil, if p2.onGift == nil then react.createElement(default2, {
            zIndex = 4,
            anchorPoint = Vector2.new(0.5, 1),
            frameSize = UDim2.fromScale(0.92, 0.22),
            onClick = p2.onBuy,
            position = UDim2.fromScale(0.5, 0.94),
            price = p2.price,
            productId = p2.productId
        }) else react.createElement(default3, {
            zIndex = 4,
            onBuy = p2.onBuy,
            onGift = p2.onGift,
            position = UDim2.fromScale(0.96, 0.94),
            price = p2.price,
            productId = p2.productId,
            size = UDim2.fromScale(0.92, 0.22)
        }))
    end
}
