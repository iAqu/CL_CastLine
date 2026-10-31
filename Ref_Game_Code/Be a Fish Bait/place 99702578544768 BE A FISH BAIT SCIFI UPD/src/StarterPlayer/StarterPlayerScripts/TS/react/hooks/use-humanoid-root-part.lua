-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local react = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib")).import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local useEffect, useState = react.useEffect, react.useState

return {
    useHumanoidRootPart = function(p1) -- useHumanoidRootPart | line: 14
        -- upvalues: useEffect (copy), useState (copy)
        local v1, v2 = useState(function() -- line: 15
            -- upvalues: p1 (copy)
            return if p1 then p1:FindFirstChild("HumanoidRootPart") else nil
        end)

        useEffect(function() -- line: 18
            -- upvalues: p1 (copy), v2 (copy)
            if p1 then
                local HumanoidRootPart = p1:FindFirstChild("HumanoidRootPart")

                if HumanoidRootPart then
                    v2(HumanoidRootPart)

                    return nil
                end

                local connection = p1.ChildAdded:Connect(function(p2) -- line: 28
                    -- upvalues: v2 (copy)
                    if p2.Name == "HumanoidRootPart" and p2:IsA("BasePart") then
                        v2(p2)
                    end
                end)

                return function() -- line: 33
                    -- upvalues: connection (copy)
                    return connection:Disconnect()
                end
            end

            v2(nil)

            return nil
        end, { p1 })

        return v1
    end
}
