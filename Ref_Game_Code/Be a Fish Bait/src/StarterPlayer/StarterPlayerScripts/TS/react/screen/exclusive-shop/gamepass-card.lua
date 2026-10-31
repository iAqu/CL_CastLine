-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local default = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "brainrot-style", "br-frame").default
local default2 = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "brainrot-style", "popout-text-two").default
local default3 = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "brainrot-style", "popout-text-button").default
local useTheme = RuntimeLib.import(script, script.Parent.Parent.Parent, "hooks", "use-theme").useTheme
local robuxIconPrefix = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "store-utils").robuxIconPrefix
local useOwnsGamepass = RuntimeLib.import(script, script.Parent.Parent.Parent, "hooks", "use-owns-gamepass").useOwnsGamepass
local useProductPrice = RuntimeLib.import(script, script.Parent.Parent.Parent, "hooks", "use-product-price").useProductPrice
local v1 = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(80, 220, 50)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(20, 175, 20))
})

local function darkenSequence(p1, p2) -- line: 13
    local Value = p1.Keypoints[1].Value

    return Color3.new(Value.R * p2, Value.G * p2, Value.B * p2)
end

return {
    default = function(p3) -- GamepassCard | line: 17
        -- upvalues: react (copy), default (copy), default2 (copy), default3 (copy), useTheme (copy), robuxIconPrefix (copy), useOwnsGamepass (copy), useProductPrice (copy), v1 (copy)
        local v2 = useTheme()
        local Value = p3.backgroundColor.Keypoints[1].Value
        local v3 = Color3.new(Value.R * 0.45, Value.G * 0.45, Value.B * 0.45)
        local v4 = useOwnsGamepass(p3.gamepassName)
        local v5 = useProductPrice(p3.gamepassProductId, Enum.InfoType.GamePass)

        if v5 == nil then
            v5 = p3.price
        end

        local createElement = react.createElement
        local t1 = {
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            LayoutOrder = p3.layoutOrder,
            Size = UDim2.fromScale(0.49, 1)
        }
        local v6 = react.createElement("frame", {
            BorderSizePixel = 0,
            ZIndex = 1,
            AnchorPoint = Vector2.new(0.5, 0.5),
            BackgroundColor3 = v3,
            Position = UDim2.fromScale(0.5, 0.525),
            Size = UDim2.fromScale(1, 1.03)
        }, react.createElement("uicorner", {
            CornerRadius = UDim.new(0.06, 0)
        }))
        local createElement2 = react.createElement
        local t2 = {
            clipsDescendants = true,
            cornerRadius = 0.06,
            isStudded = true,
            isStuddedTransparency = 0.15,
            strokeThickness = 0.012,
            textureTransparency = 0.82,
            zIndex = 2,
            anchorPoint = Vector2.new(0.5, 0.5),
            backgroundColor = p3.backgroundColor,
            position = UDim2.fromScale(0.5, 0.5),
            size = UDim2.fromScale(1, 1),
            strokeColor = Color3.fromRGB(0, 0, 0)
        }
        local v7 = react.createElement("frame", {
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            ZIndex = 4,
            AnchorPoint = Vector2.new(0.5, 0),
            Position = UDim2.fromScale(0.5, 0.04),
            Size = UDim2.fromScale(0.92, 0.2)
        }, react.createElement(default2, {
            shadowYScale = 0.06,
            color = Color3.new(1, 1, 1),
            overrideProps = {
                TextScaled = true,
                ZIndex = 4,
                Font = v2.textFont2,
                Size = UDim2.fromScale(1, 1),
                TextXAlignment = Enum.TextXAlignment.Center
            },
            strokeProps = {
                Thickness = 0.04
            },
            text = p3.title
        }))
        local v8 = react.createElement("imagelabel", {
            BackgroundTransparency = 1,
            ZIndex = 4,
            AnchorPoint = Vector2.new(0, 0.5),
            Image = p3.icon,
            Position = UDim2.fromScale(0.05, 0.58),
            ScaleType = Enum.ScaleType.Fit,
            Size = UDim2.fromScale(0.4, 0.5)
        }, react.createElement("uiaspectratioconstraint", {
            AspectRatio = 1
        }))
        local v9 = react.createElement("frame", {
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            ZIndex = 4,
            AnchorPoint = Vector2.new(1, 0.5),
            Position = UDim2.fromScale(0.96, 0.46),
            Size = UDim2.fromScale(0.46, 0.42)
        }, react.createElement(default2, {
            shadowYScale = 0.04,
            color = Color3.new(1, 1, 1),
            overrideProps = {
                TextScaled = true,
                TextWrapped = true,
                ZIndex = 4,
                Font = v2.textFont,
                Size = UDim2.fromScale(1, 1),
                TextXAlignment = Enum.TextXAlignment.Left,
                TextYAlignment = Enum.TextYAlignment.Center
            },
            strokeProps = {
                Thickness = 0.03
            },
            text = p3.description
        }))
        local createElement3 = react.createElement
        local t3 = {
            zIndex = 4,
            anchorPoint = Vector2.new(1, 1)
        }

        t3.color = if v4 then ColorSequence.new(Color3.fromRGB(100, 100, 100)) else v1
        t3.frameSize = UDim2.fromScale(0.48, 0.19)

        if v4 then
            t3.label = "Owned"

            t3.onClick = function() -- line: 113
            end

            t3.popoutColor = Color3.fromRGB(60, 60, 60)
        else
            t3.label = ("%*%*"):format(robuxIconPrefix, v5)
            t3.onClick = p3.onClick
            t3.popoutColor = Color3.fromRGB(10, 120, 10)
        end

        t3.position = UDim2.fromScale(0.95, 0.95)

        return createElement("frame", t1, v6, createElement2(default, t2, v7, v8, v9, createElement3(default3, t3)))
    end
}
