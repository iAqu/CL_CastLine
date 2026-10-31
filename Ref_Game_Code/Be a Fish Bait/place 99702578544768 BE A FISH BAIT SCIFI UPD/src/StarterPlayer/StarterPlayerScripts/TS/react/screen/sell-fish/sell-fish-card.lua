-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local default = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "brainrot-style", "br-frame").default
local default2 = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "brainrot-style", "popout-text-two").default
local default3 = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "brainrot-style", "popout-text-button").default
local useTheme = RuntimeLib.import(script, script.Parent.Parent.Parent, "hooks", "use-theme").useTheme
local abbreviate = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "abbreviate").abbreviate
local v1 = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "rarity-utils")
local getRarityColor, getRarityBorderColor, getRarityDisplayName = v1.getRarityColor, v1.getRarityBorderColor, v1.getRarityDisplayName
local v2 = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 100, 180)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(210, 40, 130))
})
local v3 = Color3.fromRGB(140, 20, 80)
local v4 = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(80, 255, 100)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(30, 190, 50))
})

return {
    default = function(p1) -- SellFishCard | line: 16
        -- upvalues: react (copy), default (copy), default2 (copy), default3 (copy), useTheme (copy), abbreviate (copy), getRarityColor (copy), getRarityBorderColor (copy), getRarityDisplayName (copy), v2 (copy), v3 (copy), v4 (copy)
        local v5 = useTheme()
        local v6 = getRarityColor(p1.rarity)
        local v7 = getRarityBorderColor(p1.rarity)

        return react.createElement(default, {
            cornerRadius = 0.06,
            isStudded = false,
            strokeThickness = 0.025,
            transparency = 0.1,
            zIndex = 2,
            backgroundColor = Color3.fromRGB(30, 30, 36),
            layoutOrder = p1.layoutOrder,
            size = UDim2.fromScale(1, 1)
        }, react.createElement("uilistlayout", {
            FillDirection = Enum.FillDirection.Vertical,
            HorizontalAlignment = Enum.HorizontalAlignment.Center,
            Padding = UDim.new(0.015, 0),
            SortOrder = Enum.SortOrder.LayoutOrder,
            VerticalAlignment = Enum.VerticalAlignment.Top
        }), react.createElement("uipadding", {
            PaddingBottom = UDim.new(0.04, 0),
            PaddingLeft = UDim.new(0.06, 0),
            PaddingRight = UDim.new(0.06, 0),
            PaddingTop = UDim.new(0.04, 0)
        }), react.createElement("frame", {
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            LayoutOrder = 1,
            ZIndex = 3,
            Size = UDim2.fromScale(1, 0.1)
        }, react.createElement(default2, {
            color = Color3.new(1, 1, 1),
            overrideProps = {
                TextScaled = true,
                ZIndex = 3,
                Font = v5.textFont2,
                Size = UDim2.fromScale(1, 1),
                TextXAlignment = Enum.TextXAlignment.Center
            },
            text = p1.name
        })), react.createElement("frame", {
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            LayoutOrder = 2,
            ZIndex = 3,
            Size = UDim2.fromScale(1, 0.44)
        }, react.createElement("uiaspectratioconstraint", {
            AspectRatio = 1
        }), react.createElement(default, {
            cornerRadius = 0.08,
            isStudded = false,
            strokeThickness = 0.012,
            transparency = 0,
            zIndex = 3,
            anchorPoint = Vector2.new(0.5, 0.5),
            backgroundColor = Color3.fromRGB(20, 20, 26),
            position = UDim2.fromScale(0.5, 0.5),
            size = UDim2.fromScale(1, 1),
            strokeColor = v7
        }, react.createElement("imagelabel", {
            BackgroundTransparency = 1,
            ZIndex = 4,
            AnchorPoint = Vector2.new(0.5, 0.5),
            Image = p1.imageId,
            Position = UDim2.fromScale(0.5, 0.5),
            ScaleType = Enum.ScaleType.Fit,
            Size = UDim2.fromScale(0.9, 0.9)
        })), react.createElement("frame", {
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            ZIndex = 6,
            AnchorPoint = Vector2.new(0, 0),
            Position = UDim2.fromScale(0, 0),
            Size = UDim2.fromScale(0.42, 0.26)
        }, react.createElement(default2, {
            color = Color3.new(1, 1, 1),
            overrideProps = {
                TextScaled = true,
                ZIndex = 7,
                AnchorPoint = Vector2.new(0, 0),
                Font = v5.textFont2,
                Position = UDim2.fromScale(0, 0),
                Size = UDim2.fromScale(1, 1),
                TextXAlignment = Enum.TextXAlignment.Left
            },
            text = ("Lvl %*"):format(p1.level)
        }))), react.createElement("frame", {
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            LayoutOrder = 3,
            ZIndex = 3,
            Size = UDim2.fromScale(1, 0.09)
        }, react.createElement(default2, {
            color = v6,
            overrideProps = {
                TextScaled = true,
                ZIndex = 3,
                Font = v5.textFont2,
                Size = UDim2.fromScale(1, 1),
                TextXAlignment = Enum.TextXAlignment.Center
            },
            text = getRarityDisplayName(p1.rarity)
        })), react.createElement("frame", {
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            LayoutOrder = 4,
            ZIndex = 3,
            Size = UDim2.fromScale(1, 0.1)
        }, react.createElement(default2, {
            color = v4,
            overrideProps = {
                TextScaled = true,
                ZIndex = 3,
                Font = v5.textFont2,
                Size = UDim2.fromScale(1, 1),
                TextXAlignment = Enum.TextXAlignment.Center
            },
            text = ("$%*"):format((abbreviate(p1.sellPrice)))
        })), react.createElement(default3, {
            isStudded = true,
            label = "Sell $",
            layoutOrder = 5,
            zIndex = 3,
            anchorPoint = Vector2.new(0.5, 0),
            color = v2,
            font = v5.textFont2,
            frameSize = UDim2.fromScale(0.88, 0.16),
            onClick = p1.onSell,
            popoutColor = v3,
            position = UDim2.fromScale(0.5, 0)
        }))
    end
}
