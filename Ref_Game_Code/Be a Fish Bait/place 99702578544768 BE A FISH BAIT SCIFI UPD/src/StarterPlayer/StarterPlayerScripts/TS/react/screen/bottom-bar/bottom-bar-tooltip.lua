-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local default = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "brainrot-style", "popout-text-two").default
local default2 = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "styled-text-label").default
local useScreenSizeState = RuntimeLib.import(script, script.Parent.Parent.Parent, "hooks", "use-screen-size").useScreenSizeState
local default3 = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "brainrot-style", "shiny-overlay").default
local t1 = {
    sm = 6,
    md = 10,
    lg = 14
}

return {
    default = function(p1) -- BottomBarTooltip | line: 13
        -- upvalues: react (copy), default (copy), default2 (copy), useScreenSizeState (copy), default3 (copy), t1 (copy)
        local isEdge = p1.isEdge

        if isEdge == nil then
            isEdge = false
        end

        local name, subtitle, titleSize, zIndex = p1.name, p1.subtitle, p1.titleSize, p1.zIndex

        if zIndex == nil then
            zIndex = 500
        end

        local v2 = t1[useScreenSizeState()]
        local v3, v4, v5, v6, v7

        if isEdge then
            v4 = Vector2.new(1, 1)
            v5 = UDim2.fromScale(1, -0.5)
            v7 = 0.85
            v6 = Vector2.new(1, 0)
            v3 = UDim2.fromScale(1.6, 0.2)
        else
            v4 = Vector2.new(0.5, 1)
            v5 = UDim2.fromScale(0.5, -0.5)
            v7 = 0.5
            v6 = Vector2.new(0, 0)
            v3 = UDim2.fromScale(0, 0.2)
        end

        return react.createElement("frame", {
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            AnchorPoint = v4,
            Position = v5,
            Size = UDim2.fromScale(3, 1.8),
            ZIndex = zIndex
        }, react.createElement("frame", {
            BackgroundTransparency = 0,
            BorderSizePixel = 0,
            AnchorPoint = v6,
            BackgroundColor3 = Color3.fromRGB(0, 0, 0),
            Position = v3,
            Size = UDim2.fromScale(1, 0.88),
            ZIndex = zIndex
        }, react.createElement("uicorner", {
            CornerRadius = UDim.new(0.1, 0)
        }), react.createElement("frame", {
            BackgroundTransparency = 0,
            BorderSizePixel = 0,
            AnchorPoint = Vector2.new(0.5, 0.5),
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
            Position = UDim2.fromScale(0.5, 0.49),
            Size = UDim2.fromScale(0.94, 0.84),
            ZIndex = zIndex + 1
        }, react.createElement(default3, {
            position = UDim2.fromScale(0.5, 0.5),
            scaleType = Enum.ScaleType.Fit,
            size = UDim2.fromScale(1, 1),
            zIndex = zIndex + 1
        }), react.createElement("uigradient", {
            Rotation = 90,
            Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(196, 196, 196))
            })
        }), react.createElement("uicorner", {
            CornerRadius = UDim.new(0.08, 0)
        }), react.createElement(default, {
            shadowYScale = 0.05,
            color = Color3.new(1, 1, 1),
            overrideProps = {
                TextScaled = true,
                AnchorPoint = Vector2.new(0.5, 0),
                Position = UDim2.fromScale(0.5, 0.05),
                Size = titleSize or UDim2.fromScale(0.9, 0.6),
                TextXAlignment = Enum.TextXAlignment.Center,
                ZIndex = zIndex + 2
            },
            text = name
        }), react.createElement(default2, {
            hasStroke = true,
            overrideProps = {
                AnchorPoint = Vector2.new(0.5, 1),
                Position = UDim2.fromScale(0.5, 0.95),
                Size = UDim2.fromScale(0.9, 0.28),
                TextXAlignment = Enum.TextXAlignment.Center,
                ZIndex = zIndex + 2
            },
            strokeProps = {
                Thickness = 0.04,
                Color = Color3.fromRGB(180, 180, 180)
            },
            text = subtitle,
            textColor3 = Color3.fromRGB(80, 80, 80)
        }))), react.createElement("frame", {
            BackgroundTransparency = 0,
            BorderSizePixel = 0,
            Rotation = 45,
            AnchorPoint = Vector2.new(0.5, 0.5),
            BackgroundColor3 = Color3.fromRGB(12, 12, 18),
            Position = UDim2.fromScale(v7, 1.08),
            Size = UDim2.fromOffset(v2, v2),
            ZIndex = zIndex - 1
        }))
    end
}
