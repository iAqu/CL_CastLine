-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local out = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "pretty-react-hooks", "out")
local useLatest, useMotion = out.useLatest, out.useMotion
local useEffect = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react").useEffect

return {
    useLoopMotion = function(p1) -- useLoopMotion | line: 7
        -- upvalues: useLatest (copy), useMotion (copy), useEffect (copy)
        local min, max, motionType = p1.min, p1.max, p1.motionType
        local v1, v2 = useMotion(0)
        local v3 = useLatest(if motionType == "linear" then p1.linearOptions else nil)
        local v4 = useLatest(if motionType == "spring" then p1.springOptions else nil)

        useEffect(function() -- line: 15
            -- upvalues: motionType (copy), v2 (copy), v3 (copy), v4 (copy)
            local n1 = 1

            if motionType == "spring" then
                v2:spring(1, v4.current)
            else
                v2:linear(1, v3.current)
            end

            local v5 = v2:onComplete(function() -- line: 22
                -- upvalues: n1 (ref), motionType (copy), v2 (copy), v3 (copy), v4 (copy)
                n1 = if n1 == 1 then 0 else 1

                if motionType == "spring" then
                    v2:spring(n1, v4.current)
                else
                    v2:linear(n1, v3.current)
                end
            end)

            return function() -- line: 34
                -- upvalues: v5 (copy)
                v5()
            end
        end, { v2, min, max, motionType, v3, v4 })

        return {
            v1:map(function(p2) -- line: 38
                -- upvalues: min (copy), max (copy)
                return p2 * (max - min) + min
            end),
            v2
        }
    end
}
