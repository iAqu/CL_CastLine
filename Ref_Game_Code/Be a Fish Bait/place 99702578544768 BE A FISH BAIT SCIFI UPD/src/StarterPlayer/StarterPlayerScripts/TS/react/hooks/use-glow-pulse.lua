-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local useEffect, useRef = react.useEffect, react.useRef
local useMotion = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "pretty-react-hooks", "out").useMotion

return {
    useGlowPulse = function(p1) -- useGlowPulse | line: 11
        -- upvalues: useEffect (copy), useRef (copy), useMotion (copy)
        local v1 = if p1 == nil then {} else p1
        local riseTime = v1.riseTime

        if riseTime == nil then
            riseTime = 0.5
        end

        local holdTime = v1.holdTime

        if holdTime == nil then
            holdTime = 1
        end

        local fallTime = v1.fallTime

        if fallTime == nil then
            fallTime = 0.5
        end

        local v2, v3 = useMotion(0)
        local v4 = useRef(nil)

        useEffect(function() -- line: 32
            -- upvalues: riseTime (ref), holdTime (ref), fallTime (ref), v3 (copy), v4 (copy)
            local v5 = false

            v3:tween(1, {
                time = riseTime,
                style = Enum.EasingStyle.Quad,
                direction = Enum.EasingDirection.Out
            })

            local v6 = v3:onComplete(function() -- line: 39
                -- upvalues: v5 (ref), riseTime (ref), holdTime (ref), fallTime (ref), v3 (copy), v4 (copy)
                if v5 then
                    v5 = false
                    v3:tween(1, {
                        time = riseTime,
                        style = Enum.EasingStyle.Quad,
                        direction = Enum.EasingDirection.Out
                    })
                else
                    v5 = true
                    v4.current = task.delay(holdTime, function() -- line: 42
                        -- upvalues: fallTime (ref), v3 (copy), v4 (copy)
                        v4.current = nil
                        v3:tween(0, {
                            time = fallTime,
                            style = Enum.EasingStyle.Sine,
                            direction = Enum.EasingDirection.In
                        })
                    end)
                end
            end)

            return function() -- line: 59
                -- upvalues: v6 (copy), v4 (copy)
                v6()

                if v4.current ~= nil then
                    task.cancel(v4.current)
                    v4.current = nil
                end
            end
        end, { v3, riseTime, holdTime, fallTime })

        return v2
    end
}
