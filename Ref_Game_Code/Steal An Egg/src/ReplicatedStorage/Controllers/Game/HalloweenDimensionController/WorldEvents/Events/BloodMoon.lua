-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HalloweenDimension = require(ReplicatedStorage.Shared.Util.HalloweenDimension)

require(ReplicatedStorage.Packages.Trove)
require(script.Parent.Parent.Types)

local WaterTint = require(script.Parent.Parent.WaterTint)
local v1 = Color3.fromRGB(96, 4, 8)
local v2 = Color3.new(2.2, 0.25, 0.2)
local t1 = {
    Preset = "HalloweenBloodMoon",
    Icon = "rbxassetid://85674946431202",
    Id = HalloweenDimension.WorldEvents.BloodMoon,
    MoonColor = Color3.fromRGB(200, 30, 30),
    Bind = function(p1, p2) -- Bind | line: 23
        -- upvalues: WaterTint (copy), v1 (copy), v2 (copy)
        WaterTint.Bind(p1, p2, v1, v2)
    end
}

return table.freeze(t1)
