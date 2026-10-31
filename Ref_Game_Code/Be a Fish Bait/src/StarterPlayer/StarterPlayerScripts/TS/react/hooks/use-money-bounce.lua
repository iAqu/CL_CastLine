-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local useMotion = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "pretty-react-hooks", "out").useMotion
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local useEffect, useRef = react.useEffect, react.useRef

return {
    useMoneyBounce = function(p1, p2) -- useMoneyBounce | line: 14
        -- upvalues: useMotion (copy), useEffect (copy), useRef (copy)
        p2 = p2 or {}

        local damping = p2.damping
        local v2 = damping

        if damping == nil then
            v2 = 0.5
        end

        local frequency = p2.frequency
        local v3 = frequency

        if frequency == nil then
            v3 = 0.1
        end

        local maxOffset = p2.maxOffset
        local v4 = maxOffset

        if maxOffset == nil then
            v4 = -15
        end

        local v5, v6 = useMotion(0)
        local v7 = useRef(p1)
        local v8 = useRef(true)

        useEffect(function() -- line: 31
            -- upvalues: p1 (copy), v2 (ref), v3 (ref), v4 (ref), v6 (copy), v7 (copy), v8 (copy)
            if not v8.current and v7.current == p1 then
                return
            end

            v8.current = false
            v7.current = p1

            local v9 = v4

            v6:spring(v9, {
                damping = v2,
                frequency = v3
            })

            local v10 = task.delay(0.1, function() -- line: 42
                -- upvalues: v3 (ref), v6 (copy)
                v6:spring(0, {
                    damping = 0.2,
                    frequency = v3
                })
            end)

            return function() -- line: 48
                -- upvalues: v10 (copy)
                task.cancel(v10)
            end
        end, { p1, v6, v4, v2, v3 })

        return v5
    end
}
