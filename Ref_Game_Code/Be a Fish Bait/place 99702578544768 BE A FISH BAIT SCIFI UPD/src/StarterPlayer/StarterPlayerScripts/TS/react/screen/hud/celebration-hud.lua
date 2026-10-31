-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local default = RuntimeLib.import(script, script.Parent, "hud").default

return {
    default = function(p1) -- CelebrationHud | line: 8
        -- upvalues: react (copy), default (copy)
        local v1 = if p1 == nil then {} else p1
        local v2 = table.clone(v1)

        setmetatable(v2, nil)
        v2.isCelebrationPlace = true

        return react.createElement(default, v2)
    end
}
