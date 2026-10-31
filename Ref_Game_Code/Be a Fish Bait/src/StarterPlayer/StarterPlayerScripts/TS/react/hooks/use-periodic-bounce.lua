-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local useMotion = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "pretty-react-hooks", "out").useMotion
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local useEffect, useRef = react.useEffect, react.useRef

return {
    usePeriodicBounce = function(p1) -- usePeriodicBounce | line: 13
        -- upvalues: useMotion (copy), useEffect (copy), useRef (copy)
        local isActive, interval = p1.isActive, p1.interval
        local v1 = interval

        if interval == nil then
            v1 = 2
        end

        local initialScale = p1.initialScale
        local v2 = initialScale

        if initialScale == nil then
            v2 = 1
            initialScale = 1
        end

        local peakScale = p1.peakScale
        local v3 = peakScale

        if peakScale == nil then
            v3 = 1.2
        end

        local peakDuration = p1.peakDuration
        local v4 = peakDuration

        if peakDuration == nil then
            v4 = 0.3
        end

        local tension = p1.tension
        local v5 = tension

        if tension == nil then
            v5 = 400
        end

        local friction = p1.friction
        local v6 = friction

        if friction == nil then
            v6 = 20
        end

        local v7, v8 = useMotion(initialScale)
        local v9 = useRef(nil)
        local v10 = useRef(isActive)

        useEffect(function() -- line: 44
            -- upvalues: isActive (copy), v10 (copy)
            v10.current = isActive
        end, { isActive })
        useEffect(function() -- line: 47
            -- upvalues: isActive (copy), v1 (ref), v2 (ref), v3 (ref), v4 (ref), v5 (ref), v6 (ref), v8 (copy), v9 (copy), v10 (copy)
            if v9.current ~= nil then
                task.cancel(v9.current)
                v9.current = nil
            end

            if isActive then
                local v11 = v2

                v8:spring(v11, {
                    tension = v5,
                    friction = v6
                })

                local function v12() -- line: 61
                    -- upvalues: v2 (ref), v3 (ref), v4 (ref), v5 (ref), v6 (ref), v8 (copy)
                    local v13 = v3

                    v8:spring(v13, {
                        tension = v5,
                        friction = v6
                    })
                    task.delay(v4, function() -- line: 68
                        -- upvalues: v2 (ref), v5 (ref), v6 (ref), v8 (copy)
                        v8:spring(v2, {
                            tension = v5,
                            friction = v6
                        })
                    end)
                end

                v12()
                v9.current = task.spawn(function() -- line: 77
                    -- upvalues: v12 (copy), v1 (ref), v10 (copy)
                    while true do
                        if v10.current then
                            task.wait(v1)

                            if v10.current then
                                v12()
                                continue
                            end
                        end

                        break
                    end
                end)
            else
                local v15 = v2

                v8:spring(v15, {
                    tension = v5,
                    friction = v6
                })
            end

            return function() -- line: 94
                -- upvalues: v9 (copy)
                if v9.current ~= nil then
                    task.cancel(v9.current)
                    v9.current = nil
                end
            end
        end, { isActive, v8, v2, v3, v4, v5, v6, v1 })

        return v7
    end
}
