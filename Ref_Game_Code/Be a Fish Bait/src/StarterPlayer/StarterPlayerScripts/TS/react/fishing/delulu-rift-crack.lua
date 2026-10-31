-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local useCallback, useEffect, useRef, useState = react.useCallback, react.useEffect, react.useRef, react.useState
local createPortal = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react-roblox").createPortal
local out = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "pretty-react-hooks", "out")
local useCamera, useMotion = out.useCamera, out.useMotion
local services = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services")
local RunService, Workspace = services.RunService, services.Workspace
local subscribe = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "charm").subscribe
local riftCrack = RuntimeLib.import(script, script.Parent.Parent.Parent, "vfx").riftCrack
local deluluRiftFlashAtom = RuntimeLib.import(script, script.Parent.Parent.Parent, "delulu-rift-flash-atom").deluluRiftFlashAtom
local deluluRiftZoomOffsetAtom = RuntimeLib.import(script, script.Parent.Parent.Parent, "delulu-rift-zoom-offset-atom").deluluRiftZoomOffsetAtom
local v1 = RuntimeLib.import(script, script.Parent.Parent.Parent, "fishing-phase-atom")
local catchFadeAtom, fishingMovementLockedAtom = v1.catchFadeAtom, v1.fishingMovementLockedAtom
local default = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "react", "prefab").default

return {
    default = function() -- DeluluRiftCrack | line: 35
        -- upvalues: react (copy), useCallback (copy), useEffect (copy), useRef (copy), useState (copy), createPortal (copy), useCamera (copy), useMotion (copy), RunService (copy), Workspace (copy), subscribe (copy), riftCrack (copy), deluluRiftFlashAtom (copy), deluluRiftZoomOffsetAtom (copy), catchFadeAtom (copy), fishingMovementLockedAtom (copy), default (copy)
        local v2 = useCamera()
        local v3, v4 = useState(false)
        local v5 = useRef()
        local _, v6 = useMotion(0)
        local v7 = useCallback(function() -- line: 40
            -- upvalues: riftCrack (copy)
            return riftCrack
        end, {})
        local v8 = useCallback(function(p1) -- line: 43
            for _, descendant in p1:GetDescendants() do
                if descendant:IsA("BasePart") then
                    descendant.Anchored = true
                    descendant.CanCollide = false
                    descendant.CanQuery = false
                    descendant.CanTouch = false
                    descendant.CastShadow = false
                elseif descendant:IsA("ParticleEmitter") then
                    descendant.Rate *= 0.3
                end
            end
        end, {})

        useEffect(function() -- line: 56
            -- upvalues: v4 (copy), subscribe (copy), deluluRiftFlashAtom (copy)
            local v9 = subscribe(deluluRiftFlashAtom, function(p2) -- line: 57
                -- upvalues: v4 (copy)
                if p2 then
                    v4(true)
                end
            end)

            return function() -- line: 62
                -- upvalues: v9 (copy), deluluRiftFlashAtom (copy)
                v9()
                deluluRiftFlashAtom(false)
            end
        end, {})
        useEffect(function() -- line: 69
            -- upvalues: v4 (copy), subscribe (copy), deluluRiftFlashAtom (copy), catchFadeAtom (copy)
            return subscribe(catchFadeAtom, function(p3) -- line: 70
                -- upvalues: v4 (copy), deluluRiftFlashAtom (copy)
                if p3 ~= nil then
                    v4(false)
                    deluluRiftFlashAtom(false)
                end
            end)
        end, {})
        useEffect(function() -- line: 79
            -- upvalues: v4 (copy), subscribe (copy), deluluRiftFlashAtom (copy), fishingMovementLockedAtom (copy)
            return subscribe(fishingMovementLockedAtom, function(p4) -- line: 80
                -- upvalues: v4 (copy), deluluRiftFlashAtom (copy)
                if not p4 then
                    v4(false)
                    deluluRiftFlashAtom(false)
                end
            end)
        end, {})
        useEffect(function() -- line: 88
            -- upvalues: v6 (copy), deluluRiftZoomOffsetAtom (copy)
            local v10 = v6:onStep(function(p5) -- line: 89
                -- upvalues: deluluRiftZoomOffsetAtom (copy)
                return deluluRiftZoomOffsetAtom(p5)
            end)

            return function() -- line: 92
                -- upvalues: v10 (copy), deluluRiftZoomOffsetAtom (copy)
                v10()
                deluluRiftZoomOffsetAtom(0)
            end
        end, { v6 })
        useEffect(function() -- line: 97
            -- upvalues: v3 (copy), v6 (copy)
            if v3 then
                v6:tween(-15, {
                    time = 3.2,
                    style = Enum.EasingStyle.Sine,
                    direction = Enum.EasingDirection.Out
                })
            else
                v6:tween(0, {
                    time = 0.8,
                    style = Enum.EasingStyle.Sine,
                    direction = Enum.EasingDirection.Out
                })
            end
        end, { v3, v6 })
        useEffect(function() -- line: 112
            -- upvalues: v2 (copy), v3 (copy), v5 (copy), RunService (copy)
            if not v3 then
                return nil
            end

            local connection = RunService.RenderStepped:Connect(function() -- line: 116
                -- upvalues: v2 (copy), v5 (copy)
                local current = v5.current

                if current ~= nil then
                    current:PivotTo(v2.CFrame * CFrame.new(0, 0, -12))
                end
            end)

            return function() -- line: 124
                -- upvalues: connection (copy)
                return connection:Disconnect()
            end
        end, { v3, v2 })

        if v3 then
            return createPortal(react.createElement(default, {
                getPrefabInstance = v7,
                onPrefabInstantiated = v8,
                prefabRef = v5
            }), Workspace)
        end

        return react.createElement(react.Fragment)
    end
}
