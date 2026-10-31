-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local useEffect, useState = react.useEffect, react.useState
local Icon = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "topbar-plus", "out").Icon

return {
    useTopbarIcon = function() -- useTopbarIcon | line: 20
        -- upvalues: useEffect (copy), useState (copy), Icon (copy)
        local v1, v2 = useState()

        useEffect(function() -- line: 22
            -- upvalues: v2 (copy), Icon (copy)
            local v3 = Icon.new()

            v2(v3)

            return function() -- line: 25
                -- upvalues: v3 (copy)
                v3:destroy()
            end
        end, {})

        return v1
    end
}
