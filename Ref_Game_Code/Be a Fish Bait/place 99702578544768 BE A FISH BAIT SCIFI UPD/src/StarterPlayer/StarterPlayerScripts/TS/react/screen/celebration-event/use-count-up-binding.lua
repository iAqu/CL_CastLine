-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local useBinding, useEffect, useRef = react.useBinding, react.useEffect, react.useRef
local RunService = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services").RunService

return {
    useCountUpBinding = function(p1, p2) -- useCountUpBinding | line: 16
        -- upvalues: useBinding (copy), useEffect (copy), useRef (copy), RunService (copy)
        local v1 = p2

        if p2 == nil then
            v1 = 0.3
        end

        local v2, v3 = useBinding(p1)
        local v4 = useRef(p1)

        v4.current = p1

        local v5 = useRef(p1)
        local v6 = useRef(nil)

        useEffect(function() -- line: 25
            -- upvalues: v1 (ref), v3 (copy), v4 (copy), v5 (copy), v6 (copy), RunService (copy)
            local connection = RunService.Heartbeat:Connect(function() -- line: 26
                -- upvalues: v1 (ref), v3 (copy), v4 (copy), v5 (copy), v6 (copy)
                local current = v4.current
                local current2 = v6.current

                if not current2 or current2.to ~= current then
                    v6.current = {
                        from = v5.current,
                        startTime = os.clock(),
                        to = current
                    }
                end

                local current3 = v6.current
                local v9 = 1 - math.pow(1 - math.min((os.clock() - current3.startTime) / v1, 1), 3)
                local v11 = math.floor(current3.from + (current3.to - current3.from) * v9)

                v5.current = v11
                v3(v11)
            end)

            return function() -- line: 43
                -- upvalues: connection (copy)
                return connection:Disconnect()
            end
        end, { v1 })

        return v2
    end
}
