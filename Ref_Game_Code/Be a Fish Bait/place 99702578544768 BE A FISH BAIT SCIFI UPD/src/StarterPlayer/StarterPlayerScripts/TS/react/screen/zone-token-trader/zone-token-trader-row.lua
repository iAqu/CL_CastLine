-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local default = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "brainrot-style", "br-frame").default
local default2 = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "brainrot-style", "popout-text-two").default
local default3 = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "brainrot-style", "popout-text-button").default
local useTheme = RuntimeLib.import(script, script.Parent.Parent.Parent, "hooks", "use-theme").useTheme
local v1 = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(70, 195, 185)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(25, 145, 135))
})

return {
    default = function(p1) -- ZoneTokenTraderRow | line: 9
        -- upvalues: react (copy), default (copy), default2 (copy), default3 (copy), useTheme (copy), v1 (copy)
        local v2 = useTheme()

        return react.createElement(default, {
            cornerRadius = 0.1,
            isStudded = false,
            transparency = 0,
            zIndex = 2,
            backgroundColor = Color3.fromRGB(125, 115, 120),
            layoutOrder = p1.layoutOrder,
            size = UDim2.fromScale(1, 1)
        }, react.createElement("uipadding", {
            PaddingBottom = UDim.new(0.08, 0),
            PaddingLeft = UDim.new(0.03, 0),
            PaddingRight = UDim.new(0.03, 0),
            PaddingTop = UDim.new(0.08, 0)
        }), react.createElement("frame", {
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            ZIndex = 3,
            AnchorPoint = Vector2.new(0, 0.5),
            Position = UDim2.fromScale(0, 0.5),
            Size = UDim2.fromScale(0.5, 1)
        }, react.createElement("uilistlayout", {
            FillDirection = Enum.FillDirection.Horizontal,
            HorizontalAlignment = Enum.HorizontalAlignment.Left,
            Padding = UDim.new(0.04, 0),
            SortOrder = Enum.SortOrder.LayoutOrder,
            VerticalAlignment = Enum.VerticalAlignment.Center
        }), react.createElement("frame", {
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            LayoutOrder = 1,
            ZIndex = 3,
            Size = UDim2.fromScale(0.24, 0.8)
        }, react.createElement("uiaspectratioconstraint", {
            AspectRatio = 1
        }), react.createElement(default, {
            cornerRadius = 0.5,
            isStudded = false,
            strokeThickness = 0.04,
            transparency = 0,
            zIndex = 4,
            anchorPoint = Vector2.new(0.5, 0.5),
            backgroundColor = p1.tokenBadgeColor,
            position = UDim2.fromScale(0.5, 0.5),
            size = UDim2.fromScale(1, 1),
            strokeColor = Color3.fromRGB(0, 0, 0)
        })), react.createElement("frame", {
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            LayoutOrder = 2,
            ZIndex = 3,
            Size = UDim2.fromScale(0.5, 0.4)
        }, react.createElement(default2, {
            color = Color3.new(1, 1, 1),
            overrideProps = {
                TextScaled = true,
                ZIndex = 4,
                Font = v2.textFont2,
                Size = UDim2.fromScale(1, 1),
                TextXAlignment = Enum.TextXAlignment.Left
            },
            text = p1.tokenLabel
        }))), react.createElement(default3, {
            isStudded = true,
            label = "EXCHANGE",
            zIndex = 3,
            anchorPoint = Vector2.new(1, 0.5),
            color = v1,
            font = v2.textFont2,
            frameSize = UDim2.fromScale(0.28, 0.86),
            onClick = p1.onSelectToken,
            position = UDim2.fromScale(1, 0.5)
        }))
    end
}
