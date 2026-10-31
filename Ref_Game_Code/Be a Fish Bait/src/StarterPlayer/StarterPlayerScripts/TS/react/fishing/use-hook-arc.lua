-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local useEffect, useRef = react.useEffect, react.useRef
local RunService = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services").RunService
local v1 = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "fishing-hook-utils")
local castDistanceFromPower, castDuration, castEndYFromPower, drag = v1.castDistanceFromPower, v1.castDuration, v1.castEndYFromPower, v1.drag
local waterSurfaceY = v1.waterSurfaceY

local function computeArcOffset(p1, p2, p3) -- line: 13
    local v2 = math.clamp(p3, 0.01, 0.99)
    local v3 = p2 / (v2 * 2 * (1 - v2))

    return 2 * (1 - p1) * p1 * v3
end

return {
    useHookArc = function(p4, p5, p6) -- useHookArc | line: 18
        -- upvalues: useEffect (copy), useRef (copy), RunService (copy), castDistanceFromPower (copy), castDuration (copy), castEndYFromPower (copy), drag (copy), waterSurfaceY (copy)
        local startPosition, direction, drag2 = p4.startPosition, p4.direction, p4.drag
        local drag3 = drag2

        if drag2 == nil then
            drag3 = drag
        end

        local power, peakBias, peakHeight = p4.power, p4.peakBias, p4.peakHeight
        local v4 = castEndYFromPower(power)
        local v5 = useRef(p6)

        v5.current = p6
        useEffect(function() -- line: 32
            -- upvalues: p5 (copy), startPosition (copy), direction (copy), drag3 (ref), power (copy), peakBias (copy), peakHeight (copy), v4 (copy), v5 (copy), RunService (copy), castDistanceFromPower (copy), castDuration (copy), waterSurfaceY (copy)
            local v6 = castDistanceFromPower(power)
            local v7 = castDuration(power)
            local Unit = (direction * Vector3.new(1, 0, 1)).Unit
            local v9 = math.clamp((startPosition.Y - waterSurfaceY) / (startPosition.Y - v4), 0, 1)
            local v11 = v9 + (1 - v9) / math.max(drag3, 0.001)
            local v12 = v6 / v11
            local v13 = (v4 - startPosition.Y) / v11
            local v14 = p5

            if p5 == nil then
                v14 = tick()
            end

            local v15 = true
            local connection = RunService.Heartbeat:Connect(function() -- line: 47
                -- upvalues: v7 (copy), Unit (copy), v9 (copy), v11 (copy), v12 (copy), v13 (copy), v14 (ref), v15 (ref), startPosition (copy), drag3 (ref), peakBias (copy), peakHeight (copy), v5 (copy)
                if not v15 then
                    return nil
                end

                local v17 = math.max(0, (tick() - v14) / v7)
                local v19 = math.max(0, v17 - v9)
                local v20 = if v17 <= v9 then v17 else v9 + (1 - v9) * (1 - math.exp(-drag3 * v19)) / drag3
                local v24 = Unit * (v12 * v20)
                local v25 = startPosition.Y + v13 * v20
                local v26 = v20 / v11
                local v27 = math.clamp(peakBias, 0.01, 0.99)
                local v28 = peakHeight / (v27 * 2 * (1 - v27))
                local v29 = v25 + 2 * (1 - v26) * v26 * v28
                local v30 = startPosition * Vector3.new(1, 0, 1) + v24 + Vector3.new(0, v29, 0)
                local current = v5.current

                if current ~= nil then
                    current(v30)
                end

                if if v9 >= 1 then v17 >= 1 else math.exp(-drag3 * v19) < 0.01 then
                    v15 = false
                end
            end)

            return function() -- line: 71
                -- upvalues: v15 (ref), connection (copy)
                v15 = false
                connection:Disconnect()
            end
        end, { startPosition, direction, drag3, power, peakBias, peakHeight, p5, v4 })
    end
}
