-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local react = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib")).import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local useEffect, useState = react.useEffect, react.useState

return {
    useAttribute = function(p1, p2, p3) -- useAttribute | line: 17
        -- upvalues: useEffect (copy), useState (copy)
        local v1, v2 = useState(p3)

        useEffect(function() -- line: 19
            -- upvalues: p1 (copy), p2 (copy), p3 (copy), v2 (copy)
            if p1 then
                local connection = p1:GetAttributeChangedSignal(p2):Connect(function() -- line: 25
                    -- upvalues: p1 (copy), p2 (copy), p3 (copy), v2 (copy)
                    local Attribute = p1:GetAttribute(p2)

                    if Attribute == nil then
                        Attribute = p3
                    end

                    v2(Attribute)
                end)
                local Attribute = p1:GetAttribute(p2)

                if Attribute == nil then
                    Attribute = p3
                end

                v2(Attribute)

                return function() -- line: 40
                    -- upvalues: connection (copy)
                    return connection:Disconnect()
                end
            end

            v2(p3)

            return nil
        end, { p1, p2, p3 })

        return v1
    end
}
