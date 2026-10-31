-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local useMotion = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "pretty-react-hooks", "out").useMotion
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local useEffect, useRef, useState = react.useEffect, react.useRef, react.useState

return {
    useProgressBarFade = function(p1, p2) -- useProgressBarFade | line: 20
        -- upvalues: useMotion (copy), useEffect (copy), useRef (copy), useState (copy)
        local v1 = math.clamp(p1, 0, 1)

        p2 = p2 or {}

        local fadeDuration = p2.fadeDuration

        if fadeDuration == nil then
            fadeDuration = 0.8
        end

        local damping = p2.damping
        local v3 = damping

        if damping == nil then
            v3 = 1
        end

        local frequency = p2.frequency

        if frequency == nil then
            frequency = 2
        end

        local v4 = useRef(v1)
        local v5, v6 = useState(false)
        local v7, v8 = useMotion(v1)
        local v9, v10 = useMotion(v1)
        local v11, v12 = useMotion(v1)

        useEffect(function() -- line: 40
            -- upvalues: v1 (copy), v3 (ref), v4 (copy), v6 (copy), v8 (copy), v10 (copy), v12 (copy)
            local current = v4.current
            local v13 = v1 - current
            local v14 = v13 < -0.001
            local v15 = v13 > 0.001

            if v14 then
                v6(true)
                v10:immediate(v1)
                v12:immediate(current)
                v12:spring(v1, {
                    frequency = 0.5,
                    damping = v3
                })
                v8:immediate(v1)
            elseif v15 then
                v6(true)
                v10:immediate(current)
                v10:spring(v1, {
                    frequency = 0.5,
                    damping = v3
                })
                v12:immediate(v1)
                v8:spring(v1, {
                    frequency = 0.5,
                    damping = v3
                })
            else
                v8:immediate(v1)
                v10:immediate(v1)
                v12:immediate(v1)
                v6(false)
            end

            v4.current = v1
        end, { v1, fadeDuration, v3, frequency, v8, v10, v12 })

        return {
            mainFill = v7,
            fadeStart = v9,
            fadeEnd = v11,
            showFade = v5
        }
    end
}
