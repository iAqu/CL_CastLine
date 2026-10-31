-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local useTheme = RuntimeLib.import(script, script.Parent.Parent.Parent, "hooks", "use-theme").useTheme
local default = RuntimeLib.import(script, script.Parent, "shiny-overlay").default
local default2 = RuntimeLib.import(script, script.Parent, "popout-button").default
local default3 = RuntimeLib.import(script, script.Parent, "br-frame").default
local default4 = RuntimeLib.import(script, script.Parent, "popout-text-two").default
local useScreenSizeState = RuntimeLib.import(script, script.Parent.Parent.Parent, "hooks", "use-screen-size").useScreenSizeState
local getTextSize = RuntimeLib.import(script, script.Parent.Parent.Parent, "utils", "responsive-utils").getTextSize

return {
    default = function(p1) -- BRWindow | line: 11
        -- upvalues: react (copy), useTheme (copy), default (copy), default2 (copy), default3 (copy), default4 (copy), useScreenSizeState (copy), getTextSize (copy)
        local v1 = useTheme()
        local v2 = useScreenSizeState()
        local v3 = Color3.fromRGB(0, 0, 0)

        Color3.fromRGB(150, 150, 150)

        local v4 = Color3.fromRGB(80, 80, 80)
        local v5 = Color3.fromRGB(50, 50, 50)
        local v6 = typeof(p1.headerBg) == "ColorSequence"
        local v7 = typeof(p1.bodyBg) == "ColorSequence"
        local zIndexOffset = p1.zIndexOffset

        if zIndexOffset == nil then
            zIndexOffset = 0
        end

        local v8 = p1.aspectRatio ~= nil and react.createElement("uiaspectratioconstraint", {
            AspectRatio = p1.aspectRatio
        })
        local v9 = react.createElement("uicorner", {
            CornerRadius = UDim.new(0.02, 0)
        })
        local v10 = react.createElement("uistroke", {
            Thickness = 0.005,
            ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
            Color = v3,
            StrokeSizingMode = Enum.StrokeSizingMode.ScaledSize
        })
        local v11 = react.createElement("frame", {
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            AnchorPoint = Vector2.new(0.5, 0),
            Position = UDim2.fromScale(0.5, 0),
            Size = UDim2.fromScale(1, 0.13),
            ZIndex = 1 + zIndexOffset
        })
        local v12 = react.createElement("uicorner", {
            CornerRadius = UDim.new(0.02, 0)
        })
        local v13 = react.createElement("uipadding", {
            PaddingBottom = UDim.new(0.0125, 0),
            PaddingLeft = UDim.new(0.0075, 0),
            PaddingRight = UDim.new(0.0075, 0)
        })
        local t1 = {
            cornerRadius = 0.02,
            strokeThickness = 0.005,
            textureTransparency = 0.9,
            anchorPoint = Vector2.new(0.5, 0.5),
            backgroundColor = if v7 then Color3.new(1, 1, 1) else p1.bodyBg,
            isStudded = p1.bodyOverlay ~= false,
            position = UDim2.fromScale(0.5, 0.45),
            size = UDim2.fromScale(1, 1.1),
            strokeColor = v4
        }
        local bodyTransparency = p1.bodyTransparency

        t1.transparency = if bodyTransparency == nil then 0.5 else bodyTransparency
        t1.zIndex = 1 + zIndexOffset

        if v7 then
            local t2 = {
                Color = p1.bodyBg
            }
            local bodyGradientRotation = p1.bodyGradientRotation

            t2.Rotation = if bodyGradientRotation == nil then 90 else bodyGradientRotation
            v7 = react.createElement("uigradient", t2)
        end

        local v14 = react.createElement("frame", {
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            ClipsDescendants = true,
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.fromScale(0.5, 0.5),
            Size = UDim2.fromScale(1, 1),
            ZIndex = 15 + zIndexOffset
        }, v9, v10, v11, react.createElement("frame", {
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            ClipsDescendants = true,
            AnchorPoint = Vector2.new(0.5, 1),
            Position = UDim2.fromScale(0.5, 1),
            Size = UDim2.new(1, 0, 0.88, 0),
            ZIndex = 1 + zIndexOffset
        }, v12, v13, react.createElement(default3, t1, v7, p1.children)))
        local v15

        if v6 then
            local t3 = {
                Color = p1.headerBg
            }
            local headerGradientRotation = p1.headerGradientRotation

            t3.Rotation = if headerGradientRotation == nil then 90 else headerGradientRotation
            v15 = react.createElement("uigradient", t3)
        else
            v15 = v6
        end

        return react.createElement("frame", {
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = p1.position or UDim2.fromScale(0.5, 0.5),
            Size = p1.size,
            ZIndex = 0 + zIndexOffset
        }, v8, v14, react.createElement(default3, {
            cornerRadius = 0.05,
            isStudded = true,
            strokeThickness = 0.05,
            textureTransparency = 0,
            transparency = 0,
            anchorPoint = Vector2.new(0.5, 0),
            backgroundColor = if v6 then Color3.new(1, 1, 1) else p1.headerBg,
            position = UDim2.fromScale(0.5, 0),
            size = UDim2.new(1.005, 0, 0.13, 0),
            strokeColor = v5,
            zIndex = 20 + zIndexOffset
        }, v15, react.createElement(default, {
            zIndex = 20 + zIndexOffset
        }), if p1.headerNode == nil then react.createElement("frame", {
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            AnchorPoint = Vector2.new(0, 0.5),
            Position = UDim2.fromScale(0.04, 0.5),
            Size = UDim2.fromScale(0.83, 0.72),
            ZIndex = 21 + zIndexOffset
        }, react.createElement("uilistlayout", {
            FillDirection = Enum.FillDirection.Horizontal,
            HorizontalAlignment = Enum.HorizontalAlignment.Left,
            Padding = UDim.new(0.01, 0),
            SortOrder = Enum.SortOrder.LayoutOrder,
            VerticalAlignment = Enum.VerticalAlignment.Center
        }), react.createElement("frame", {
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            LayoutOrder = 1,
            Size = if p1.titleNode == nil then UDim2.fromScale(1, 1) else UDim2.fromScale(0.55, 1),
            ZIndex = 21 + zIndexOffset
        }, react.createElement(default4, {
            color = Color3.new(1, 1, 1),
            overrideProps = {
                TextScaled = true,
                Font = v1.textFont2,
                Size = UDim2.fromScale(1, 1),
                TextSize = getTextSize(v2, "lg"),
                TextXAlignment = Enum.TextXAlignment.Left,
                ZIndex = 21 + zIndexOffset
            },
            text = p1.title
        })), p1.titleNode ~= nil and react.createElement("frame", {
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            LayoutOrder = 2,
            Size = UDim2.fromScale(0.4, 1),
            ZIndex = 21 + zIndexOffset
        }, p1.titleNode)) else react.createElement("frame", {
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.fromScale(0.5, 0.5),
            Size = UDim2.fromScale(1, 1),
            ZIndex = 21 + zIndexOffset
        }, p1.headerNode), react.createElement("frame", {
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            AnchorPoint = Vector2.new(1, 0.5),
            Position = p1.closeButtonPosition or UDim2.fromScale(1, 0.5),
            Size = UDim2.fromScale(0.1, 0.78),
            ZIndex = 22 + zIndexOffset
        }, react.createElement(default2, {
            aspectRatio = 1,
            cornerRadius = 0.1,
            anchorPoint = Vector2.new(0.5, 0.5),
            color = Color3.fromRGB(255, 43, 43),
            onClick = p1.onClose,
            popoutColor = Color3.fromRGB(122, 31, 31),
            position = UDim2.fromScale(0.5, 0.5),
            size = UDim2.fromScale(1, 1),
            strokeColor = Color3.fromRGB(255, 179, 179),
            zIndex = 22 + zIndexOffset
        }, react.createElement(default4, {
            shadowYScale = 0.075,
            text = "X",
            anchorPoint = Vector2.new(0.5, 0.5),
            color = Color3.new(1, 1, 1),
            overrideProps = {
                TextScaled = true,
                Font = v1.textFont2,
                Size = UDim2.fromScale(0.8, 0.8),
                ZIndex = 25 + zIndexOffset
            },
            position = UDim2.fromScale(0.5, 0.5)
        })))))
    end
}
