-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local useEffect = react.useEffect
local out = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "pretty-react-hooks", "out")
local useCamera, useMotion = out.useCamera, out.useMotion
local services = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services")
local Players, TweenService, Workspace = services.Players, services.TweenService, services.Workspace
local baseFov = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "fishing-hook-utils").baseFov
local t1 = {
    frequency = 0.3,
    damping = 0.3
}

return {
    NibbleCameraFov = function(p1) -- NibbleCameraFov | line: 23
        -- upvalues: react (copy), useEffect (copy), useCamera (copy), useMotion (copy), Players (copy), TweenService (copy), Workspace (copy), baseFov (copy), t1 (copy)
        local active, bonusComboCount = p1.active, p1.bonusComboCount
        local v1 = bonusComboCount

        if bonusComboCount == nil then
            v1 = 0
        end

        local isFishCaught = p1.isFishCaught
        local v2 = isFishCaught

        if isFishCaught == nil then
            v2 = false
        end

        local nibbleExpireTimestamp = p1.nibbleExpireTimestamp
        local v3 = useCamera()
        local _, v4 = useMotion(v3.FieldOfView)

        useEffect(function() -- line: 37
            -- upvalues: v1 (ref), v2 (ref), Players (copy), TweenService (copy), Workspace (copy)
            if v2 then
                return nil
            end

            local LocalPlayer = Players.LocalPlayer
            local CameraMinZoomDistance, CameraMaxZoomDistance = LocalPlayer.CameraMinZoomDistance, LocalPlayer.CameraMaxZoomDistance
            local NumberValue = Instance.new("NumberValue")

            NumberValue.Value = 22
            NumberValue.Parent = Workspace

            local connection = NumberValue:GetPropertyChangedSignal("Value"):Connect(function() -- line: 47
                -- upvalues: LocalPlayer (copy), NumberValue (copy)
                LocalPlayer.CameraMinZoomDistance = NumberValue.Value
                LocalPlayer.CameraMaxZoomDistance = NumberValue.Value
            end)
            local v5 = 22 * (1 - v1 * 0.1)
            local v6 = TweenService:Create(NumberValue, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                Value = v5
            })

            v6.Completed:Connect(function() -- line: 55
                -- upvalues: LocalPlayer (copy), NumberValue (copy), connection (copy), v5 (copy)
                connection:Disconnect()
                NumberValue:Destroy()
                LocalPlayer.CameraMinZoomDistance = v5
                LocalPlayer.CameraMaxZoomDistance = v5
            end)
            v6:Play()

            return function() -- line: 62
                -- upvalues: LocalPlayer (copy), CameraMinZoomDistance (copy), CameraMaxZoomDistance (copy), NumberValue (copy), connection (copy), v6 (copy)
                connection:Disconnect()
                v6:Cancel()
                NumberValue:Destroy()
                LocalPlayer.CameraMinZoomDistance = CameraMinZoomDistance
                LocalPlayer.CameraMaxZoomDistance = CameraMaxZoomDistance
            end
        end, { v1, v2 })
        useEffect(function() -- line: 71
            -- upvalues: v3 (copy), v4 (copy), baseFov (copy)
            local v7 = v4:onStep(function(p2) -- line: 72
                -- upvalues: v3 (copy)
                v3.FieldOfView = p2
            end)

            return function() -- line: 75
                -- upvalues: v7 (copy), v3 (copy), baseFov (copy)
                v7()
                v3.FieldOfView = baseFov
            end
        end, { v4, v3 })
        useEffect(function() -- line: 80
            -- upvalues: active (copy), v4 (copy), baseFov (copy), t1 (copy)
            if active then
                return nil
            end

            v4:spring(baseFov, t1)
        end, { active, v4 })
        useEffect(function() -- line: 86
            -- upvalues: nibbleExpireTimestamp (copy), v4 (copy), Workspace (copy), baseFov (copy), t1 (copy)
            if nibbleExpireTimestamp <= 0 then
                v4:spring(baseFov, t1)

                return nil
            end

            local v8 = nibbleExpireTimestamp - Workspace:GetServerTimeNow()

            if v8 < 1 then
                return nil
            end

            v4:tween(50, {
                time = v8
            })

            local v9 = task.delay(v8, function() -- line: 98
                -- upvalues: v4 (copy), baseFov (copy), t1 (copy)
                v4:spring(baseFov, t1)
            end)

            return function() -- line: 101
                -- upvalues: v9 (copy)
                return task.cancel(v9)
            end
        end, { nibbleExpireTimestamp, v4 })

        return react.createElement(react.Fragment)
    end
}
