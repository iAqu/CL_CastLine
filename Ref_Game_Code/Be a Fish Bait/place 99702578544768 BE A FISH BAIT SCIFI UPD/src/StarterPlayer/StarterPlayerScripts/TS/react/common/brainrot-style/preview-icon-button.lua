-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local default = RuntimeLib.import(script, script.Parent, "br-button").default
local v1 = Color3.fromRGB(14, 29, 30)
local v2 = Color3.fromRGB(132, 154, 151)
local v3 = UDim2.fromOffset(35, 35)

return {
    default = function(p1) -- PreviewIconButton | line: 10
        -- upvalues: react (copy), default (copy), v1 (copy), v2 (copy), v3 (copy)
        local zIndex = p1.zIndex

        if zIndex == nil then
            zIndex = 1
        end

        return react.createElement("frame", {
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            AnchorPoint = p1.anchorPoint or Vector2.new(0.5, 0.5),
            Position = p1.position,
            Size = p1.size or v3,
            ZIndex = zIndex
        }, react.createElement("uiaspectratioconstraint", {
            AspectRatio = 1,
            DominantAxis = Enum.DominantAxis.Width
        }), react.createElement(default, {
            cornerRadius = 1,
            strokeThickness = 0.04,
            transparency = 0.08,
            anchorPoint = Vector2.new(0.5, 0.5),
            backgroundColor = v1,
            onClick = p1.onClick,
            position = UDim2.fromScale(0.5, 0.5),
            size = UDim2.fromScale(1, 1),
            strokeColor = v2,
            zIndex = zIndex + 1
        }, react.createElement("imagelabel", {
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            Image = "rbxassetid://133911389227055",
            AnchorPoint = Vector2.new(0.5, 0.5),
            ImageColor3 = Color3.new(1, 1, 1),
            Position = UDim2.fromScale(0.5, 0.5),
            ScaleType = Enum.ScaleType.Fit,
            Size = UDim2.fromScale(0.66, 0.66),
            ZIndex = zIndex + 5
        })))
    end
}
