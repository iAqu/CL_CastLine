-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local useEffect = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react").useEffect
local useMotion = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "pretty-react-hooks", "out").useMotion
local RunService = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services").RunService

return {
    usePulseAnimation = function(p1) -- usePulseAnimation | line: 12
        -- upvalues: useEffect (copy), useMotion (copy), RunService (copy)
        p1 = p1 or {}

        local enabled = p1.enabled
        local v2 = enabled

        if enabled == nil then
            v2 = true
        end

        local interval = p1.interval
        local v3 = interval

        if interval == nil then
            v3 = 5
        end

        local peakScale = p1.peakScale
        local v4 = peakScale

        if peakScale == nil then
            v4 = 1.2
        end

        local peakDuration = p1.peakDuration
        local v5 = peakDuration

        if peakDuration == nil then
            v5 = 0.3
        end

        local damping = p1.damping
        local v6 = damping

        if damping == nil then
            v6 = 0.3
        end

        local v7, v8 = useMotion(1)

        useEffect(function() -- line: 35
            -- upvalues: v2 (ref), v3 (ref), v4 (ref), v5 (ref), v6 (ref), v8 (copy), RunService (copy)
            if v2 then
                local function v9() -- line: 43
                    -- upvalues: v4 (ref), v5 (ref), v6 (ref), v8 (copy)
                    local v10 = v4

                    v8:spring(v10, {
                        damping = v6
                    })
                    task.delay(v5, function() -- line: 49
                        -- upvalues: v6 (ref), v8 (copy)
                        v8:spring(1, {
                            damping = v6
                        })
                    end)
                end

                v9()

                local v11 = tick()
                local connection = RunService.Heartbeat:Connect(function() -- line: 59
                    -- upvalues: v9 (copy), v11 (ref), v3 (ref)
                    local v12 = tick()

                    if v12 - v11 >= v3 then
                        v11 = v12
                        v9()
                    end
                end)

                return function() -- line: 66
                    -- upvalues: connection (copy)
                    connection:Disconnect()
                end
            end

            v8:spring(1, {
                damping = 1
            })

            return nil
        end, { v8, v2, v3, v4, v5, v6 })

        return v7
    end
}
