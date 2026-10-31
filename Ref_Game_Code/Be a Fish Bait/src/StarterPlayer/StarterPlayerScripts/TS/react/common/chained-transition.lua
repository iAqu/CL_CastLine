-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local transition = RuntimeLib.import(script, script.Parent, "transition", "transition")
local default, useTransition = transition.default, transition.useTransition

return {
    default = function(p1) -- ChainedTransition | line: 7
        -- upvalues: react (copy), default (copy), useTransition (copy)
        local t1 = {
            ["in"] = useTransition()["in"]
        }

        for v1, v2 in p1 do
            t1[v1] = v2
        end

        return react.createElement(default, t1, p1.children)
    end
}
