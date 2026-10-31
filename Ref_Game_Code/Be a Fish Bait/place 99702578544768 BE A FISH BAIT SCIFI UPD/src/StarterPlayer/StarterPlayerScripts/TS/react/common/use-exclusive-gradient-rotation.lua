-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local useEffect = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react").useEffect
local useMotion = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "pretty-react-hooks", "out").useMotion
local v1 = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 245, 120)),
    ColorSequenceKeypoint.new(0.35, Color3.fromRGB(60, 255, 240)),
    ColorSequenceKeypoint.new(0.7, Color3.fromRGB(255, 90, 220)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 245, 120))
})
local v2 = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(85, 255, 235)),
    ColorSequenceKeypoint.new(0.3, Color3.fromRGB(255, 255, 140)),
    ColorSequenceKeypoint.new(0.65, Color3.fromRGB(255, 120, 235)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(85, 255, 235))
})

local function useLoopingGradientRotation(p1, p2) -- line: 8
    -- upvalues: useEffect (copy), useMotion (copy)
    local v3 = p1
    local v4 = p2

    if p1 == nil then
        v3 = true
    end

    if p2 == nil then
        v4 = 90
    end

    local v5, v6 = useMotion(0)

    useEffect(function() -- line: 16
        -- upvalues: v3 (ref), v4 (ref), v6 (copy)
        if not v3 then
            return nil
        end

        v6:linear(360, {
            speed = v4
        })

        local v7 = v6:onComplete(function() -- line: 26
            -- upvalues: v4 (ref), v6 (copy)
            v6:immediate(0)
            v6:linear(360, {
                speed = v4
            })
        end)

        return function() -- line: 30
            -- upvalues: v7 (copy)
            return v7()
        end
    end, { v3, v6, v4 })

    return v5
end

return {
    useLoopingGradientRotation = useLoopingGradientRotation,
    useExclusiveGradientRotation = function(p3) -- useExclusiveGradientRotation | line: 37
        -- upvalues: useLoopingGradientRotation (copy)
        return (useLoopingGradientRotation(p3 == nil or p3))
    end,
    exclusiveEditionGradient = v1,
    exclusiveMpsMultiplierGradient = v2
}
