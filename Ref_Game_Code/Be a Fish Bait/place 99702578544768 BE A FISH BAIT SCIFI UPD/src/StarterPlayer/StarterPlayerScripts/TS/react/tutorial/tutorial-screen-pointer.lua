-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local default = RuntimeLib.import(script, script.Parent, "pointer").default

return {
    default = function(p1) -- TutorialScreenPointer | line: 5
        -- upvalues: react (copy), default (copy)
        local anchorPoint, position, direction, image = p1.anchorPoint, p1.position, p1.direction, p1.image
        local size, zIndex = p1.size, p1.zIndex
        local t1 = {
            BackgroundTransparency = 1,
            AnchorPoint = anchorPoint,
            Position = position,
            Size = size or UDim2.fromScale(0.1, 0.1)
        }

        t1.ZIndex = if zIndex == nil then 10 else zIndex

        return react.createElement("frame", t1, react.createElement(default, {
            direction = direction,
            image = image,
            size = UDim2.fromScale(1.5, 1.5)
        }))
    end
}
