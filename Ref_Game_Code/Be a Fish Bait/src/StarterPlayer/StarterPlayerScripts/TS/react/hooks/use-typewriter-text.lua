-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local useMotion = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "pretty-react-hooks", "out").useMotion
local useEffect = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react").useEffect

return {
    useTypewriterText = function(p1) -- useTypewriterText | line: 5
        -- upvalues: useMotion (copy), useEffect (copy)
        local v1, v2 = useMotion(0)

        useEffect(function() -- line: 7
            -- upvalues: v2 (copy)
            v2:linear(1, {
                speed = 3
            })

            return function() -- line: 11
                -- upvalues: v2 (copy)
                v2:immediate(0)
            end
        end, { p1, v2 })

        return v1:map(function(p2) -- line: 15
            -- upvalues: p1 (copy)
            return (string.sub(p1, 1, (math.floor(p2 * #p1))))
        end)
    end
}
