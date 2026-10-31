-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local default = RuntimeLib.import(script, script.Parent, "gradient-button").default

return {
    default = function(p1) -- GradientIconButton | line: 5
        -- upvalues: react (copy), default (copy)
        local v1 = table.clone(p1)

        setmetatable(v1, nil)
        v1.overrideProps = p1.overrideProps

        return react.createElement(default, v1)
    end
}
