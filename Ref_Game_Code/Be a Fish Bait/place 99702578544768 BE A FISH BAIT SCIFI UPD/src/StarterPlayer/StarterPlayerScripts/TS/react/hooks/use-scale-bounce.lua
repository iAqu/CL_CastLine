-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local useMotion = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "pretty-react-hooks", "out").useMotion
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local useEffect, useRef = react.useEffect, react.useRef

return {
    useScaleBounce = function(p1, p2, p3) -- useScaleBounce | line: 14
        -- upvalues: useMotion (copy), useEffect (copy), useRef (copy)
        local v1 = p2
        local v2 = p3

        if p2 == nil then
            v1 = 1.4
        end

        if p3 == nil then
            v2 = 0.25
        end

        local v3, v4 = useMotion(1)
        local v5 = useRef(true)
        local v6 = useRef(p1)

        useEffect(function() -- line: 24
            -- upvalues: v1 (ref), v2 (ref), p1 (copy), v4 (copy), v5 (copy), v6 (copy)
            if v5.current then
                v5.current = false
                v6.current = p1

                return nil
            end

            if v6.current == p1 then
                return
            end

            v6.current = p1

            local v7 = v2 * 0.3
            local v8 = v2 * 0.7
            local v9 = v1

            v4:tween(v9, {
                time = v7,
                style = Enum.EasingStyle.Quad,
                direction = Enum.EasingDirection.Out
            })

            local v10 = task.delay(v7, function() -- line: 39
                -- upvalues: v8 (copy), v4 (copy)
                v4:tween(1, {
                    time = v8,
                    style = Enum.EasingStyle.Quad,
                    direction = Enum.EasingDirection.Out
                })
            end)

            return function() -- line: 46
                -- upvalues: v10 (copy)
                return task.cancel(v10)
            end
        end, { p1 })

        return v3
    end
}
