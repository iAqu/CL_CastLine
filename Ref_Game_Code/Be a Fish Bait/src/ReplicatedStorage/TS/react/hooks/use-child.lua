-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local react = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib")).import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local useEffect, useState = react.useEffect, react.useState

return {
    useChild = function(p1, p2, p3) -- useChild | line: 6
        -- upvalues: useEffect (copy), useState (copy)
        local v1, v2 = useState(function() -- line: 7
            -- upvalues: p1 (copy), p2 (copy), p3 (copy)
            if not p1 then
                return nil
            end

            local v3 = p1:FindFirstChild(p2)

            return if v3 and v3:IsA(p3) then v3 else nil
        end)

        useEffect(function() -- line: 17
            -- upvalues: p1 (copy), p2 (copy), p3 (copy), v2 (copy)
            if p1 then
                local v4 = p1:FindFirstChild(p2)

                if not (v4 and v4:IsA(p3)) then
                    v2(nil)
                else
                    v2(v4)
                end

                local connection = p1.ChildAdded:Connect(function(p4) -- line: 28
                    -- upvalues: p2 (copy), p3 (copy), v2 (copy)
                    if p4.Name == p2 and p4:IsA(p3) then
                        v2(p4)
                    end
                end)
                local connection2 = p1.ChildRemoved:Connect(function(p5) -- line: 33
                    -- upvalues: p2 (copy), v2 (copy)
                    if p5.Name == p2 then
                        v2(nil)
                    end
                end)

                return function() -- line: 38
                    -- upvalues: connection (copy), connection2 (copy)
                    connection:Disconnect()
                    connection2:Disconnect()
                end
            end

            v2(nil)

            return nil
        end, { p1, p2, p3 })

        return v1
    end
}
