-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local useEffect, useState = react.useEffect, react.useState
local usePrefab = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "hooks", "use-prefab").usePrefab
local useRefState = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "react", "hooks", "use-ref-state").useRefState

local function useParentState(p1) -- line: 9
    -- upvalues: useEffect (copy), useState (copy)
    local v2, v3 = useState(if p1 == nil then p1 else p1.Parent)

    useEffect(function() -- line: 15
        -- upvalues: p1 (copy), v3 (copy)
        local v4 = p1

        if p1 ~= nil then
            v4 = p1.Parent
        end

        v3(v4)

        local v5 = p1

        if p1 ~= nil then
            v5 = p1.AncestryChanged:Connect(function(_, p3) -- line: 23
                -- upvalues: v3 (copy)
                v3(p3)
            end)
        end

        return function() -- line: 28
            -- upvalues: v5 (ref)
            if v5 ~= nil then
                v5:Disconnect()
            end
        end
    end, { p1 })

    return v2
end

return {
    default = function(p4) -- Prefab | line: 37
        -- upvalues: react (copy), useEffect (copy), usePrefab (copy), useRefState (copy), useParentState (copy)
        local getPrefabInstance, onPrefabInstantiated, prefabRef = p4.getPrefabInstance, p4.onPrefabInstantiated, p4.prefabRef
        local v6 = useRefState()
        local v7 = v6[1]
        local v8 = v6[2]
        local prefabInstance = usePrefab({
            getPrefabInstance = getPrefabInstance,
            onPrefabInstantiated = onPrefabInstantiated,
            parent = useParentState(v7)
        }).prefabInstance

        useEffect(function() -- line: 52
            -- upvalues: prefabRef (copy), prefabInstance (copy)
            if prefabRef then
                if type(prefabRef) == "function" then
                    prefabRef(prefabInstance)
                else
                    prefabRef.current = prefabInstance
                end
            end
        end, { prefabInstance, prefabRef })

        return react.createElement("folder", {
            ref = v8
        })
    end
}
