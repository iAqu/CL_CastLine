-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local useCallback, useEffect, useRef = react.useCallback, react.useEffect, react.useRef
local useCamera = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "pretty-react-hooks", "out").useCamera
local RunService = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services").RunService
local speedlines = RuntimeLib.import(script, script.Parent.Parent.Parent, "vfx").speedlines
local speedlineDistanceFromSpeed = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "fishing-hook-utils").speedlineDistanceFromSpeed
local default = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "react", "prefab").default

return {
    CameraSpeedlines = function(p1) -- CameraSpeedlines | line: 13
        -- upvalues: react (copy), useCallback (copy), useEffect (copy), useRef (copy), useCamera (copy), RunService (copy), speedlines (copy), speedlineDistanceFromSpeed (copy), default (copy)
        local speed = p1.speed
        local v1 = useCamera()
        local v2 = useRef()
        local v3 = useCallback(function() -- line: 17
            -- upvalues: speedlines (copy)
            return speedlines
        end, {})
        local v4 = useCallback(function(p2) -- line: 20
            for _, descendant in p2:GetDescendants() do
                if descendant:IsA("BasePart") then
                    descendant.Anchored = true
                    descendant.CanCollide = false
                    descendant.CanQuery = false
                    descendant.CanTouch = false
                    descendant.CastShadow = false
                end
            end
        end, {})

        useEffect(function() -- line: 31
            -- upvalues: speed (copy), v1 (copy), v2 (copy), RunService (copy), speedlineDistanceFromSpeed (copy)
            local v5 = speedlineDistanceFromSpeed(speed)
            local connection = RunService.RenderStepped:Connect(function() -- line: 33
                -- upvalues: v5 (copy), v1 (copy), v2 (copy)
                local current = v2.current

                if current ~= nil then
                    current:PivotTo(v1.CFrame * CFrame.new(0, 0, -v5))
                end
            end)

            return function() -- line: 41
                -- upvalues: connection (copy)
                return connection:Disconnect()
            end
        end, { speed, v1 })

        return react.createElement(default, {
            getPrefabInstance = v3,
            onPrefabInstantiated = v4,
            prefabRef = v2
        })
    end
}
