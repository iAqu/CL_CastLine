-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local useEffect, useRef, useState = react.useEffect, react.useRef, react.useState
local createPortal = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react-roblox").createPortal
local Workspace = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services").Workspace
local subscribe = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "charm").subscribe
local v1 = RuntimeLib.import(script, script.Parent.Parent.Parent.Parent, "training-boost-atom")
local trainingBoostFillAtom, trainingIsFrenzyAtom = v1.trainingBoostFillAtom, v1.trainingIsFrenzyAtom
local CameraSpeedlines = RuntimeLib.import(script, script.Parent.Parent.Parent, "fishing", "camera-speedlines").CameraSpeedlines

return {
    TrainingSpeedlines = function(p1) -- TrainingSpeedlines | line: 19
        -- upvalues: react (copy), useEffect (copy), useRef (copy), useState (copy), createPortal (copy), Workspace (copy), subscribe (copy), trainingBoostFillAtom (copy), trainingIsFrenzyAtom (copy), CameraSpeedlines (copy)
        local isActive = p1.isActive
        local v2, v3 = useState(false)
        local v4 = useRef(false)
        local v5 = useRef(trainingIsFrenzyAtom())
        local v6 = useRef(trainingBoostFillAtom())

        useEffect(function() -- line: 26
            -- upvalues: isActive (copy), v3 (copy), v4 (copy), v5 (copy), v6 (copy), subscribe (copy), trainingBoostFillAtom (copy), trainingIsFrenzyAtom (copy)
            local function update() -- line: 27
                -- upvalues: isActive (copy), v3 (copy), v4 (copy), v5 (copy), v6 (copy)
                local v7 = isActive and (v5.current or v6.current >= 0.5)

                if v7 ~= v4.current then
                    v4.current = v7
                    v3(v7)
                end
            end

            local v8 = subscribe(trainingIsFrenzyAtom, function(p2) -- line: 34
                -- upvalues: isActive (copy), v3 (copy), v4 (copy), v5 (copy), v6 (copy)
                v5.current = p2

                local v9 = isActive and (v5.current or v6.current >= 0.5)

                if v9 ~= v4.current then
                    v4.current = v9
                    v3(v9)
                end
            end)
            local v10 = subscribe(trainingBoostFillAtom, function(p3) -- line: 38
                -- upvalues: isActive (copy), v3 (copy), v4 (copy), v5 (copy), v6 (copy)
                v6.current = p3

                local v11 = isActive and (v5.current or v6.current >= 0.5)

                if v11 ~= v4.current then
                    v4.current = v11
                    v3(v11)
                end
            end)
            local v12 = isActive and (v5.current or v6.current >= 0.5)

            if v12 ~= v4.current then
                v4.current = v12
                v3(v12)
            end

            return function() -- line: 44
                -- upvalues: v8 (copy), v10 (copy)
                v8()
                v10()
            end
        end, { isActive })

        if v2 then
            return createPortal(react.createElement(CameraSpeedlines, {
                speed = 600
            }), Workspace)
        end

        return react.createElement(react.Fragment)
    end
}
