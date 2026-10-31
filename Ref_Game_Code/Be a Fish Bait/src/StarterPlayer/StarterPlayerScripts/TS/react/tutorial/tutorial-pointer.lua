-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local default = RuntimeLib.import(script, script.Parent, "pointer").default

return {
    default = function(p1) -- TutorialPointer | line: 5
        -- upvalues: react (copy), default (copy)
        local adornee, studsOffset, studsOffsetWorldSpace, direction = p1.adornee, p1.studsOffset, p1.studsOffsetWorldSpace, p1.direction
        local t1 = {
            AlwaysOnTop = true,
            MaxDistance = 200,
            Adornee = adornee,
            Size = UDim2.new(5, 0, 5, 0)
        }

        t1.StudsOffset = (studsOffset or Vector3.new(0, 0, 0)) + (if direction == "right" or direction == "left" then Vector3.new(if direction == "right" then -2.5 else 2.5, 0, 0) else Vector3.new(0, if direction == "down" then 2.5 else -2.5, 0))
        t1.StudsOffsetWorldSpace = studsOffsetWorldSpace or Vector3.new(0, 0, 0)

        return react.createElement("billboardgui", t1, react.createElement(default, {
            direction = direction
        }))
    end
}
