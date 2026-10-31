-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local react = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib")).import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")

return {
    default = function(p1) -- TileBackground | line: 4
        -- upvalues: react (copy)
        return react.createElement("imagelabel", {
            Image = "http://www.roblox.com/asset/?id=105996018865716",
            ScaleType = "Tile",
            ImageColor3 = p1.color,
            Position = p1.position,
            Size = p1.size or UDim2.fromScale(1, 1),
            TileSize = UDim2.fromOffset(110, 110)
        }, p1.children)
    end
}
