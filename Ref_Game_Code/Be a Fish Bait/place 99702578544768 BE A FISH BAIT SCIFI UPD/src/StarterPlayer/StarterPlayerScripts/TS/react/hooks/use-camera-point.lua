-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local out = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "pretty-react-hooks", "out")
local useBindingListener, useMotion = out.useBindingListener, out.useMotion
local useEffect = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react").useEffect

return {
    useCameraAnimateToPoint = function(p1, p2) -- useCameraAnimateToPoint | line: 7
        -- upvalues: useBindingListener (copy), useMotion (copy), useEffect (copy)
        local v1, v2 = useMotion(p1.CFrame)

        useEffect(function() -- line: 9
            -- upvalues: p1 (copy)
            p1.CameraType = Enum.CameraType.Scriptable
        end, { p1 })
        useEffect(function() -- line: 12
            -- upvalues: p2 (copy), v2 (copy)
            v2:spring(p2, {
                damping = 0.8,
                frequency = 1
            })
        end, { p2, v2 })
        useBindingListener(v1, function(p3) -- line: 18
            -- upvalues: p1 (copy)
            p1.CFrame = p3
        end)
    end
}
