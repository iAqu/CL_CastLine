-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local out = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "pretty-react-hooks", "out")
local useBindingListener, useMotion = out.useBindingListener, out.useMotion
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local useEffect, useRef = react.useEffect, react.useRef
local services = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services")
local Lighting, Workspace = services.Lighting, services.Workspace

return {
    useWindowCameraEffects = function(p1) -- useWindowCameraEffects | line: 16
        -- upvalues: useBindingListener (copy), useMotion (copy), useEffect (copy), useRef (copy), Lighting (copy), Workspace (copy)
        local v1 = useRef(nil)
        local v2, v3 = useMotion(0)
        local v4, v5 = useMotion(70)

        useEffect(function() -- line: 20
            -- upvalues: v1 (copy), Lighting (copy), Workspace (copy)
            for _, child in Lighting:GetChildren() do
                if child:IsA("BlurEffect") then
                    child.Size = 0
                end
            end

            local BlurEffect = Instance.new("BlurEffect")

            BlurEffect.Size = 0
            BlurEffect.Parent = Lighting
            v1.current = BlurEffect

            return function() -- line: 30
                -- upvalues: BlurEffect (copy), v1 (copy), Workspace (copy)
                BlurEffect:Destroy()
                v1.current = nil

                local CurrentCamera = Workspace.CurrentCamera

                if CurrentCamera ~= nil then
                    CurrentCamera.FieldOfView = 70
                end
            end
        end, {})
        useEffect(function() -- line: 39
            -- upvalues: p1 (copy), v3 (copy), v5 (copy)
            if p1 then
                v3:tween(20, {
                    time = 0.35
                })
                v5:tween(60, {
                    time = 0.35
                })
            else
                v3:tween(0, {
                    time = 0.35
                })
                v5:tween(70, {
                    time = 0.35
                })
            end
        end, { p1, v3, v5 })
        useBindingListener(v2, function(p2) -- line: 56
            -- upvalues: v1 (copy)
            local current = v1.current

            if current ~= nil then
                current.Size = p2
            end
        end)
        useBindingListener(v4, function(p3) -- line: 62
            -- upvalues: Workspace (copy)
            local CurrentCamera = Workspace.CurrentCamera

            if CurrentCamera ~= nil then
                CurrentCamera.FieldOfView = p3
            end
        end)
    end
}
