-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local images = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "images").images

return {
    default = function(p1) -- GlowSparkle | line: 5
        -- upvalues: react (copy), images (copy)
        local anchorPoint, position, size, zIndex = p1.anchorPoint, p1.position, p1.size, p1.zIndex

        if zIndex == nil then
            zIndex = 25
        end

        return react.createElement("imagelabel", {
            BackgroundTransparency = 1,
            ImageTransparency = 0.4,
            AnchorPoint = anchorPoint or Vector2.new(0.5, 0.5),
            Image = images.glowIcon,
            ImageColor3 = Color3.new(1, 1, 1),
            Position = position,
            Size = size,
            ZIndex = zIndex
        }, react.createElement("uiaspectratioconstraint", {
            AspectRatio = 1
        }), react.createElement("imagelabel", {
            BackgroundTransparency = 1,
            AnchorPoint = Vector2.new(0.5, 0.5),
            Image = images.sparkleIcon,
            ImageColor3 = Color3.new(1, 1, 1),
            Position = UDim2.fromScale(0.5, 0.5),
            Size = UDim2.fromScale(1, 1),
            ZIndex = zIndex + 1
        }, react.createElement("uiaspectratioconstraint", {
            AspectRatio = 1
        })))
    end
}
