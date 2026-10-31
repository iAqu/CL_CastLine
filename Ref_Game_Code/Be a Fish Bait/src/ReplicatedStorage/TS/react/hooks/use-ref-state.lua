-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local react = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib")).import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local useState, useCallback = react.useState, react.useCallback

return {
    useRefState = function() -- useRefState | line: 7
        -- upvalues: useState (copy), useCallback (copy)
        local v1, v2 = useState(nil)

        return {
            v1,
            (useCallback(function(p1) -- line: 9
                -- upvalues: v2 (copy)
                v2(p1)
            end, {}))
        }
    end
}
