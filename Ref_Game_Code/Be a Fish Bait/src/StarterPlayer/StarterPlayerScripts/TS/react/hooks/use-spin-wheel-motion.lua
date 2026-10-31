-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local useEffect = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react").useEffect
local useMotion = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "pretty-react-hooks", "out").useMotion
local RunService = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services").RunService

return {
    useSpinWheelMotion = function(p1) -- useSpinWheelMotion | line: 16
        -- upvalues: useEffect (copy), useMotion (copy), RunService (copy)
        local v1, v2 = useMotion(p1)
        local v3, v4 = useMotion(1)
        local v5, v6 = useMotion(0)

        useEffect(function() -- line: 20
            -- upvalues: v4 (copy), RunService (copy)
            local n1 = 0
            local connection = RunService.Heartbeat:Connect(function(p2) -- line: 22
                -- upvalues: n1 (ref), v4 (copy)
                n1 += p2
                v4:spring(math.sin(n1 * 3.141592653589793 * 2) * 0.035 + 1, {
                    damping = 0.88,
                    frequency = 0.2
                })
            end)

            return function() -- line: 29
                -- upvalues: connection (copy)
                return connection:Disconnect()
            end
        end, { v4 })

        return {
            pointerRotation = v5,
            pointerRotationMotion = v6,
            pointerScale = v3,
            pointerScaleMotion = v4,
            wheelScale = v1,
            wheelScaleMotion = v2
        }
    end
}
