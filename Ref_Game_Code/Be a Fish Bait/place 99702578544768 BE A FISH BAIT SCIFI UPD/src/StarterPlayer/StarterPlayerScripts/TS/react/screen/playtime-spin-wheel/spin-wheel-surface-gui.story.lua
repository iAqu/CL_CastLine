-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local storyForSurfaceGui = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "story", "story-utils").storyForSurfaceGui
local default = RuntimeLib.import(script, script.Parent, "spin-wheel-surface-gui").default

return storyForSurfaceGui(function(p1) -- line: 8
    -- upvalues: react (copy), default (copy)
    return react.createElement(default, {
        canvasSize = 600,
        adornee = p1
    })
end, (Vector3.new(0.73, 14.63, 14.63)))
