-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local images = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "images").images

return {
    default = function(p1) -- RadialBackground | line: 5
        -- upvalues: react (copy), images (copy)
        local t1 = {
            BackgroundTransparency = 1,
            AnchorPoint = p1.anchorPoint
        }
        local imageId = p1.imageId

        t1.Image = if imageId == nil then images.radialBackground else imageId
        t1.ImageColor3 = p1.imageColor3 or Color3.fromRGB(0, 0, 0)

        local imageTransparency = p1.imageTransparency

        t1.ImageTransparency = if imageTransparency == nil then 0 else imageTransparency
        t1.Position = p1.position
        t1.Size = p1.size
        t1.ZIndex = p1.zIndex

        return react.createElement("imagelabel", t1, p1.children)
    end
}
