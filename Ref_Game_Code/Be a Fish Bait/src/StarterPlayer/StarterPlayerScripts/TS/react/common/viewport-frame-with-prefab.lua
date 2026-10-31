-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local useRefState = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "react", "hooks", "use-ref-state").useRefState
local default = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "react", "prefab").default

return {
    default = function(p1) -- ViewportFrameWithPrefab | line: 6
        -- upvalues: react (copy), useRefState (copy), default (copy)
        local v1 = useRefState()
        local v2 = v1[1]
        local v3 = v1[2]
        local getPrefabInstance, onPrefabInstantiated, viewportFrameProps, prefabRef = p1.getPrefabInstance, p1.onPrefabInstantiated, p1.viewportFrameProps, p1.prefabRef
        local cameraCFrame = p1.cameraCFrame
        local t1 = {
            CurrentCamera = v2
        }

        for v4, v5 in viewportFrameProps do
            t1[v4] = v5
        end

        local t2 = {
            CFrame = cameraCFrame
        }
        local cameraFov = p1.cameraFov

        t2.FieldOfView = if cameraFov == nil then 70 else cameraFov
        t2.ref = v3

        return react.createElement("viewportframe", t1, react.createElement("camera", t2), react.createElement(default, {
            getPrefabInstance = getPrefabInstance,
            onPrefabInstantiated = onPrefabInstantiated,
            prefabRef = prefabRef
        }))
    end
}
