-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local useMotion = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "pretty-react-hooks", "out").useMotion
local useEffect = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react").useEffect

local function hsvToRgb(p1, p2, p3) -- line: 5
    local v1 = p3 * p2
    local v3 = v1 * (1 - math.abs(p1 * 6 % 2 - 1))
    local v4 = p3 - v1
    local v5

    if p1 * 6 < 1 then
        v5 = 0
    elseif p1 * 6 < 2 then
        v1, v3, v5 = v3, v1, 0
    elseif p1 * 6 < 3 then
        v1, v3, v5 = 0, v1, v3
    elseif p1 * 6 < 4 then
        v1, v5 = 0, v1
    else
        if p1 * 6 < 5 then
            v1, v5 = v3, v1
        else
            v5 = v3
        end

        v3 = 0
    end

    return Color3.new(v1 + v4, v3 + v4, v5 + v4)
end

local function getRainbowColorSequence(p4, p5) -- line: 39
    -- upvalues: hsvToRgb (copy)
    local t1 = {}
    local v7 = math.max(1, p5 - 1)
    local n1 = 0
    local v8 = false

    while true do
        if v8 then
            n1 += 1
        else
            v8 = true
        end

        if n1 < p5 then
            local v9 = n1 / v7
            local v11 = hsvToRgb((p4 + v9) % 1, 1, 1)

            table.insert(t1, (ColorSequenceKeypoint.new(v9, v11)))
            continue
        end

        break
    end

    return ColorSequence.new(t1)
end

return {
    useRainbowGradient = function(p6) -- useRainbowGradient | line: 71
        -- upvalues: useMotion (copy), useEffect (copy), getRainbowColorSequence (copy)
        local v13 = if p6 == nil then {} else p6
        local speed = v13.speed
        local v14 = speed

        if speed == nil then
            v14 = 0.15
        end

        local keypointCount = v13.keypointCount
        local v15 = keypointCount

        if keypointCount == nil then
            v15 = 8
        end

        local v16, v17 = useMotion(0)

        useEffect(function() -- line: 85
            -- upvalues: v14 (ref), v17 (copy)
            v17:linear(-1, {
                speed = v14
            })

            local v18 = v17:onComplete(function() -- line: 92
                -- upvalues: v14 (ref), v17 (copy)
                v17:immediate(0)
                v17:linear(-1, {
                    speed = v14
                })
            end)

            return function() -- line: 96
                -- upvalues: v18 (copy)
                v18()
            end
        end, { v17 })

        return v16:map(function(p7) -- line: 100
            -- upvalues: v15 (ref), getRainbowColorSequence (copy)
            return getRainbowColorSequence(p7, v15)
        end)
    end
}
