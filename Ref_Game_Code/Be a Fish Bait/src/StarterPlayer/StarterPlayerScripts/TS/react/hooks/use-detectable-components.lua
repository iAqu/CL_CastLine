-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local useCallback, useEffect, useState = react.useCallback, react.useEffect, react.useState
local Modding = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Modding
local DetectableController = RuntimeLib.import(script, script.Parent.Parent.Parent, "controllers", "detectable-controller").DetectableController
local useFlameworkComponents = RuntimeLib.import(script, script.Parent, "use-flamework-components").useFlameworkComponents
local useLatest = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "pretty-react-hooks", "out").useLatest

return {
    useFlameworkComponentsThatPlayerIsIn = function(p1, p2) -- useFlameworkComponentsThatPlayerIsIn | line: 21
        -- upvalues: useCallback (copy), useEffect (copy), useState (copy), Modding (copy), DetectableController (copy), useFlameworkComponents (copy), useLatest (copy)
        assert(p2 ~= "" and p2)

        local v3 = useFlameworkComponents(useCallback(function() -- line: 24
            return true
        end, {}), p2)
        local v4, v5 = useState({})
        local v6 = useLatest(p1)

        useEffect(function() -- line: 30
            -- upvalues: v3 (copy), v5 (copy), v6 (copy), Modding (copy), DetectableController (copy)
            local v7 = Modding.resolveSingleton(DetectableController)

            local function getComponentFromDetectable(p3) -- line: 32
                -- upvalues: v3 (copy), v6 (copy)
                for v8, v9 in v3 do
                    local _ = v8 - 1

                    if v6.current(v9) == p3 == true then
                        return v9
                    end
                end

                return nil
            end

            local function updateComponentsPlayerIsInsideOf(p4) -- line: 47
                -- upvalues: v7 (copy), getComponentFromDetectable (copy), v5 (copy)
                if p4 and not getComponentFromDetectable(p4) then
                    return nil
                end

                local v10 = v7.componentsPlayerIsInsideAtom()
                local t1 = {}
                local n1 = 0

                for v11, v12 in v10 do
                    local v13 = getComponentFromDetectable(v12, v11 - 1, v10)

                    if v13 ~= nil then
                        n1 += 1
                        t1[n1] = v13
                    end
                end

                v5(t1)
            end

            local connection = v7.onPlayerEnter:Connect(updateComponentsPlayerIsInsideOf)
            local connection2 = v7.onPlayerExit:Connect(updateComponentsPlayerIsInsideOf)

            updateComponentsPlayerIsInsideOf()

            return function() -- line: 70
                -- upvalues: connection (copy), connection2 (copy)
                connection:Disconnect()
                connection2:Disconnect()
            end
        end, { v3, v6 })

        return v4
    end
}
