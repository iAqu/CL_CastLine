-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local useEffect, useRef, useState = react.useEffect, react.useRef, react.useState
local useCamera = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "pretty-react-hooks", "out").useCamera
local subscribe = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "charm").subscribe
local shake = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxutil", "shake")
local deluluRiftCameraPunchAtom = RuntimeLib.import(script, script.Parent.Parent.Parent.Parent, "delulu-rift-camera-punch-atom").deluluRiftCameraPunchAtom
local cameraShakeEnabledAtom = RuntimeLib.import(script, script.Parent.Parent.Parent.Parent, "haptics").cameraShakeEnabledAtom

return {
    default = function() -- DeluluRiftCameraPunch | line: 14
        -- upvalues: react (copy), useEffect (copy), useRef (copy), useState (copy), useCamera (copy), subscribe (copy), shake (copy), deluluRiftCameraPunchAtom (copy), cameraShakeEnabledAtom (copy)
        local v1 = useCamera()
        local v2, v3 = useState(false)
        local v4 = useRef()

        useEffect(function() -- line: 18
            -- upvalues: v3 (copy), subscribe (copy), deluluRiftCameraPunchAtom (copy)
            local v5 = subscribe(deluluRiftCameraPunchAtom, function(p1) -- line: 19
                -- upvalues: v3 (copy)
                if p1 then
                    v3(true)
                end
            end)

            return function() -- line: 24
                -- upvalues: v5 (copy), deluluRiftCameraPunchAtom (copy)
                v5()
                deluluRiftCameraPunchAtom(false)
            end
        end, {})
        useEffect(function() -- line: 29
            -- upvalues: v1 (copy), v2 (copy), v3 (copy), v4 (copy), shake (copy), deluluRiftCameraPunchAtom (copy), cameraShakeEnabledAtom (copy)
            if not v2 then
                return nil
            end

            if cameraShakeEnabledAtom() then
                local v6 = shake.new()

                v4.current = v6
                v6.Amplitude = 4
                v6.Frequency = 0.2
                v6.FadeInTime = 0
                v6.FadeOutTime = 0.5
                v6.SustainTime = 0.05
                v6.PositionInfluence = Vector3.new(0.2, 0.2, 0.2)
                v6.RotationInfluence = Vector3.new(0.15, 0.15, 0.15)
                v6:Start()
                v6:BindToRenderStep(shake.NextRenderName(), Enum.RenderPriority.Last.Value, function(p2, p3) -- line: 48
                    -- upvalues: v1 (copy)
                    local _CFrame = v1.CFrame
                    local v7 = CFrame.new(p2)
                    local v8 = CFrame.Angles(p3.X, p3.Y, p3.Z)

                    v1.CFrame = _CFrame * v7 * v8
                end)

                local v9 = task.delay(0.5, function() -- line: 54
                    -- upvalues: v6 (copy), v3 (copy), v4 (copy), deluluRiftCameraPunchAtom (copy)
                    v6:Destroy()
                    v4.current = nil
                    v3(false)
                    deluluRiftCameraPunchAtom(false)
                end)

                return function() -- line: 60
                    -- upvalues: v6 (copy), v9 (copy), v4 (copy)
                    task.cancel(v9)
                    v6:Destroy()
                    v4.current = nil
                end
            end

            v3(false)
            deluluRiftCameraPunchAtom(false)

            return nil
        end, { v2, v1 })

        return react.createElement(react.Fragment)
    end
}
