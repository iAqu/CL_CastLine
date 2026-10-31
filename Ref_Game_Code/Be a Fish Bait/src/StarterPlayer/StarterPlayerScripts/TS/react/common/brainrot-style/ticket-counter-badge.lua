-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local default = RuntimeLib.import(script, script.Parent, "br-frame").default
local default2 = RuntimeLib.import(script, script.Parent, "popout-text-two").default
local useTheme = RuntimeLib.import(script, script.Parent.Parent.Parent, "hooks", "use-theme").useTheme
local v1 = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 183, 24)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(220, 111, 0))
})

return {
    default = function(p1) -- TicketCounterBadge | line: 13
        -- upvalues: react (copy), default (copy), default2 (copy), useTheme (copy), v1 (copy)
        local anchorPoint = p1.anchorPoint

        if anchorPoint == nil then
            anchorPoint = Vector2.new(0, 0.5)
        end

        local icon, position, text, width = p1.icon, p1.position, p1.text, p1.width
        local zIndex = p1.zIndex

        if zIndex == nil then
            zIndex = 23
        end

        local v2 = useTheme()

        return react.createElement(default, {
            cornerRadius = 0.32,
            gradientRotation = 90,
            strokeThickness = 0.05,
            anchorPoint = anchorPoint,
            backgroundColor = v1,
            position = position,
            size = UDim2.fromScale(width, 0.55),
            strokeColor = Color3.fromRGB(81, 43, 12),
            zIndex = zIndex
        }, react.createElement("frame", {
            BackgroundTransparency = 0.72,
            BorderSizePixel = 0,
            AnchorPoint = Vector2.new(0.5, 0),
            BackgroundColor3 = Color3.fromRGB(255, 229, 126),
            Position = UDim2.fromScale(0.49, 0.06),
            Size = UDim2.fromScale(0.98, 0.45),
            ZIndex = zIndex + 1
        }, react.createElement("uicorner", {
            CornerRadius = UDim.new(0.5, 0)
        })), react.createElement("imagelabel", {
            BackgroundTransparency = 1,
            Rotation = -6,
            AnchorPoint = Vector2.new(0.5, 0.5),
            Image = icon,
            Position = UDim2.fromScale(0.06, 0.5),
            ScaleType = Enum.ScaleType.Fit,
            Size = UDim2.fromScale(0.48, 1.5),
            ZIndex = zIndex + 2
        }, react.createElement("uiaspectratioconstraint", {
            AspectRatio = 1,
            DominantAxis = Enum.DominantAxis.Height
        })), react.createElement(default2, {
            anchorPoint = Vector2.new(0.5, 0.5),
            color = Color3.new(1, 1, 1),
            overrideProps = {
                TextScaled = true,
                Font = v2.textFont,
                Size = UDim2.fromScale(0.62, 0.84),
                TextTruncate = Enum.TextTruncate.AtEnd,
                ZIndex = zIndex + 3
            },
            position = UDim2.fromScale(0.64, 0.5),
            strokeProps = {
                Thickness = 0.05
            },
            text = text
        }))
    end
}
