-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local images = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "images").images

return {
    WaterSplash = function() -- WaterSplash | line: 5
        -- upvalues: react (copy), images (copy)
        return react.createElement("imagelabel", {
            BackgroundTransparency = 1,
            Image = images.waterSplash,
            Position = UDim2.fromScale(0, 0),
            ScaleType = Enum.ScaleType.Stretch,
            Size = UDim2.fromScale(1, 1)
        })
    end
}
