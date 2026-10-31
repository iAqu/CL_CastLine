-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local useEffect, useRef, useState = react.useEffect, react.useRef, react.useState
local out = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "pretty-react-hooks", "out")
local useCamera, useMotion = out.useCamera, out.useMotion
local subscribe = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "charm").subscribe
local v1 = RuntimeLib.import(script, script.Parent.Parent.Parent.Parent, "training-boost-atom")
local trainingBoostFillAtom, trainingIsFrenzyAtom = v1.trainingBoostFillAtom, v1.trainingIsFrenzyAtom
local baseFov = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "fishing-hook-utils").baseFov
local t1 = {
    frequency = 0.5,
    damping = 0.7
}
local t2 = {
    frequency = 0.3,
    damping = 0.3
}

return {
    TrainingFrenzyCameraFov = function(p1) -- TrainingFrenzyCameraFov | line: 30
        -- upvalues: react (copy), useEffect (copy), useRef (copy), useState (copy), useCamera (copy), useMotion (copy), subscribe (copy), trainingBoostFillAtom (copy), trainingIsFrenzyAtom (copy), baseFov (copy), t1 (copy), t2 (copy)
        local isActive = p1.isActive
        local v2 = useCamera()
        local _, v3 = useMotion(v2.FieldOfView)
        local v4, v5 = useState(trainingIsFrenzyAtom())
        local v6 = useRef(trainingBoostFillAtom())
        local v7 = useRef(baseFov)
        local v8 = useRef(isActive)
        local v9 = useRef(v4)

        v8.current = isActive
        v9.current = v4
        useEffect(function() -- line: 44
            -- upvalues: v3 (copy), v5 (copy), v6 (copy), v7 (copy), v8 (copy), v9 (copy), subscribe (copy), trainingBoostFillAtom (copy), trainingIsFrenzyAtom (copy), baseFov (copy), t1 (copy)
            local v10 = subscribe(trainingIsFrenzyAtom, function(p2) -- line: 45
                -- upvalues: v5 (copy), v9 (copy)
                v9.current = p2
                v5(p2)
            end)
            local v11 = subscribe(trainingBoostFillAtom, function(p3) -- line: 49
                -- upvalues: v3 (copy), v6 (copy), v7 (copy), v8 (copy), v9 (copy), baseFov (copy), t1 (copy)
                v6.current = p3

                if v8.current and not v9.current then
                    local v12 = baseFov + p3 * 25

                    if math.abs(v12 - v7.current) >= 0.25 then
                        v7.current = v12
                        v3:spring(v12, t1)
                    end

                    return
                end

                return nil
            end)

            return function() -- line: 61
                -- upvalues: v10 (copy), v11 (copy)
                v10()
                v11()
            end
        end, { v3 })
        useEffect(function() -- line: 66
            -- upvalues: v2 (copy), v3 (copy), baseFov (copy)
            local v14 = v3:onStep(function(p4) -- line: 67
                -- upvalues: v2 (copy)
                v2.FieldOfView = p4
            end)

            return function() -- line: 70
                -- upvalues: v14 (copy), v2 (copy), baseFov (copy)
                v14()
                v2.FieldOfView = baseFov
            end
        end, { v3, v2 })
        useEffect(function() -- line: 76
            -- upvalues: isActive (copy), v3 (copy), v4 (copy), v6 (copy), v7 (copy), baseFov (copy), t1 (copy), t2 (copy)
            if not isActive then
                v7.current = baseFov
                v3:spring(baseFov, t2)

                return nil
            end

            if v4 then
                local v15 = baseFov + 50

                v7.current = v15
                v3:spring(v15, t1)
            else
                local v16 = baseFov + v6.current * 25

                v7.current = v16
                v3:spring(v16, t1)
            end
        end, { isActive, v4, v3 })

        return react.createElement(react.Fragment)
    end
}
