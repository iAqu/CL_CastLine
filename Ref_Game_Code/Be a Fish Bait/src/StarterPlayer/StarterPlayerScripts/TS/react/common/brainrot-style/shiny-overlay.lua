-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local images = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "images").images

return {
    default = function(p1) -- ShinyOverlay | line: 5
        -- upvalues: react (copy), images (copy)
        local position, scaleType, size, zIndex = p1.position, p1.scaleType, p1.size, p1.zIndex
        local t1 = {
            BackgroundTransparency = 1,
            ImageTransparency = 0.7,
            AnchorPoint = Vector2.new(0.5, 0.5),
            Image = images.shineImage,
            Position = position or UDim2.fromScale(0.35, 0.5),
            ScaleType = scaleType or Enum.ScaleType.Crop,
            Size = size or UDim2.fromScale(0.5, 1),
            ZIndex = if zIndex == nil then 1 else zIndex
        }

        return react.createElement("imagelabel", t1)
    end
}
