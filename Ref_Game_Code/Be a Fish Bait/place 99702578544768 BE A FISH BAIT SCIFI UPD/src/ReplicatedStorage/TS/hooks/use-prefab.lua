-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local useEffect, useState, useCallback, useRef = react.useEffect, react.useState, react.useCallback, react.useRef
local useUnmountEffect = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "pretty-react-hooks", "out").useUnmountEffect

return {
    usePrefab = function(p1) -- usePrefab | line: 9
        -- upvalues: useEffect (copy), useState (copy), useCallback (copy), useRef (copy), useUnmountEffect (copy)
        local getPrefabInstance, onPrefabInstantiated, parent, _ = p1.getPrefabInstance, p1.onPrefabInstantiated, p1.parent, p1.name
        local v1 = useRef(nil)
        local v2, v3 = useState(nil)
        local v4 = useRef(false)
        local v5 = useCallback(function() -- line: 18
            -- upvalues: getPrefabInstance (copy), onPrefabInstantiated (copy), parent (copy), v1 (copy), v3 (copy), v4 (copy)
            if not parent or v4.current == true then
                return nil
            end

            local v6 = getPrefabInstance()

            if not v6 then
                return nil
            end

            local clone = v6:Clone()

            onPrefabInstantiated(clone)
            clone.Parent = parent

            if v1.current then
                v1.current:Destroy()
            end

            v1.current = clone
            v3(clone)
        end, { getPrefabInstance, onPrefabInstantiated, parent })

        useEffect(function() -- line: 39
            -- upvalues: v5 (copy)
            v5()
        end, { v5 })
        useUnmountEffect(function() -- line: 43
            -- upvalues: v1 (copy), v4 (copy)
            v4.current = true

            local current = v1.current

            if current ~= nil then
                current:Destroy()
            end
        end)

        return {
            reinstantiatePrefab = v5,
            prefabInstance = v2
        }
    end
}
