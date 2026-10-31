-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local react = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib")).import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local useCallback, useState = react.useCallback, react.useState

return {
    useScrollableArray = function(p1) -- useScrollableArray | line: 12
        -- upvalues: useCallback (copy), useState (copy)
        local v1, v2 = useState(0)
        local v3 = #p1

        return {
            if v3 > 0 then p1[v1 + 1] else nil,
            useCallback(function() -- line: 16
                -- upvalues: v2 (copy), v3 (copy)
                if v3 <= 0 then
                    return nil
                end

                v2(function(p2) -- line: 20
                    -- upvalues: v3 (copy)
                    return (p2 + 1) % v3
                end)
            end, { v3 }),
            useCallback(function() -- line: 24
                -- upvalues: v2 (copy), v3 (copy)
                if v3 <= 0 then
                    return nil
                end

                v2(function(p3) -- line: 28
                    -- upvalues: v3 (copy)
                    return (p3 - 1 + v3) % v3
                end)
            end, { v3 }),
            v1
        }
    end
}
