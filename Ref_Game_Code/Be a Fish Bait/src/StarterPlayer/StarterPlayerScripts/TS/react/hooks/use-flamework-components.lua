-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Components = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "components", "out").Components
local Modding = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Modding
local Maid = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "maid", "Maid")
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local useState, useEffect, useMemo = react.useState, react.useEffect, react.useMemo

return {
    useFlameworkComponents = function(p1, p2) -- useFlameworkComponents | line: 16
        -- upvalues: Components (copy), Modding (copy), Maid (copy), useState (copy), useEffect (copy), useMemo (copy)
        assert(p2 ~= "" and p2)

        local v2, v3 = useState({})

        useEffect(function() -- line: 20
            -- upvalues: p1 (copy), p2 (copy), v3 (copy), Components (copy), Modding (copy), Maid (copy)
            local v4 = Maid.new()
            local v5 = Modding.resolveSingleton(Components)

            local function updateComponents() -- line: 23
                -- upvalues: v5 (copy), p1 (copy), p2 (copy), v3 (copy)
                local v6 = v5:getAllComponents(p2)
                local t1 = {}
                local n1 = 0

                for v7, v8 in v6 do
                    if p1(v8, v7 - 1, v6) == true then
                        n1 += 1
                        t1[n1] = v8
                    end
                end

                v3(t1)
            end

            local function updateComponentsIfChangePassesCondition(p3) -- line: 39
                -- upvalues: updateComponents (copy), p1 (copy)
                if p1(p3) then
                    updateComponents()
                end
            end

            updateComponents()
            v4:GiveTask(v5:onComponentAdded(updateComponentsIfChangePassesCondition, p2))
            v4:GiveTask(v5:onComponentRemoved(function(p4) -- line: 46
                -- upvalues: updateComponents (copy), p1 (copy)
                task.wait()

                if p1(p4) then
                    updateComponents()
                end
            end, p2))

            return function() -- line: 50
                -- upvalues: v4 (copy)
                return v4:Destroy()
            end
        end, {})

        return (useMemo(function() -- line: 55
            -- upvalues: v2 (copy)
            local t2 = {}

            local function v10(p5) -- line: 58
                return p5.instance.Parent ~= nil
            end

            local n2 = 0

            for v11, v12 in v2 do
                local _ = v11 - 1

                if v10(v12) == true then
                    n2 += 1
                    t2[n2] = v12
                end
            end

            return t2
        end, { v2 }))
    end
}
