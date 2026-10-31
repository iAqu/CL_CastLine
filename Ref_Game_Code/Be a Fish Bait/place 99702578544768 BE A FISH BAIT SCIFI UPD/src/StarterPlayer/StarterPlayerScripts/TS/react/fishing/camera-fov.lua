-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local useEffect, useRef = react.useEffect, react.useRef
local out = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "pretty-react-hooks", "out")
local useCamera, useMotion = out.useCamera, out.useMotion
local RunService = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services").RunService
local subscribe = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "charm").subscribe
local v1 = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "fishing-hook-utils")
local baseFov, fovFromSpeed = v1.baseFov, v1.fovFromSpeed
local deluluRiftZoomOffsetAtom = RuntimeLib.import(script, script.Parent.Parent.Parent, "delulu-rift-zoom-offset-atom").deluluRiftZoomOffsetAtom

return {
    CameraFov = function(p1) -- CameraFov | line: 16
        -- upvalues: react (copy), useEffect (copy), useRef (copy), useCamera (copy), useMotion (copy), RunService (copy), subscribe (copy), baseFov (copy), fovFromSpeed (copy), deluluRiftZoomOffsetAtom (copy)
        local rigRef = p1.rigRef
        local v2 = useCamera()
        local _, v3 = useMotion(baseFov)
        local v4 = useRef(baseFov)
        local v5 = useRef(0)

        useEffect(function() -- line: 24
            -- upvalues: v3 (copy), v4 (copy), baseFov (copy)
            local v6 = v3:onStep(function(p2) -- line: 25
                -- upvalues: v4 (copy)
                v4.current = p2
            end)

            return function() -- line: 28
                -- upvalues: v6 (copy), v4 (copy), baseFov (copy)
                v6()
                v4.current = baseFov
            end
        end, { v3 })
        useEffect(function() -- line: 33
            -- upvalues: v5 (copy), subscribe (copy), deluluRiftZoomOffsetAtom (copy)
            return subscribe(deluluRiftZoomOffsetAtom, function(p3) -- line: 34
                -- upvalues: v5 (copy)
                v5.current = p3
            end)
        end, {})
        useEffect(function() -- line: 38
            -- upvalues: v2 (copy), v4 (copy), v5 (copy), RunService (copy), baseFov (copy)
            local connection = RunService.RenderStepped:Connect(function() -- line: 39
                -- upvalues: v2 (copy), v4 (copy), v5 (copy)
                v2.FieldOfView = v4.current + v5.current
            end)

            return function() -- line: 42
                -- upvalues: connection (copy), v2 (copy), baseFov (copy)
                connection:Disconnect()
                v2.FieldOfView = baseFov
            end
        end, { v2 })
        useEffect(function() -- line: 47
            -- upvalues: rigRef (copy), v3 (copy), RunService (copy), baseFov (copy), fovFromSpeed (copy)
            if not rigRef then
                return nil
            end

            local Position = rigRef:GetPivot().Position
            local connection = RunService.RenderStepped:Connect(function(p4) -- line: 52
                -- upvalues: Position (ref), rigRef (copy), v3 (copy), fovFromSpeed (copy)
                local Position2 = rigRef:GetPivot().Position
                local v7 = if p4 > 0 then (Position2 - Position).Magnitude / p4 else 0

                Position = Position2
                v3:spring(fovFromSpeed(v7), {
                    frequency = 0.7
                })
            end)

            return function() -- line: 67
                -- upvalues: connection (copy), v3 (copy), baseFov (copy)
                connection:Disconnect()
                v3:immediate(baseFov)
            end
        end, { rigRef, v3 })

        return react.createElement(react.Fragment)
    end
}
