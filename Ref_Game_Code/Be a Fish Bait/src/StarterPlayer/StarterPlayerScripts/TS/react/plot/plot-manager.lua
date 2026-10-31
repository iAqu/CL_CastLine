-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local useEffect, useState = react.useEffect, react.useState
local useFlameworkComponents = RuntimeLib.import(script, script.Parent.Parent, "hooks", "use-flamework-components").useFlameworkComponents
local default = RuntimeLib.import(script, script.Parent, "plot-component").default
local ErrorBoundary = RuntimeLib.import(script, script.Parent.Parent, "common", "error-boundary").ErrorBoundary

local function Fallback(p1) -- line: 10
    -- upvalues: react (copy), useEffect (copy)
    local onError = p1.onError

    warn("[src/client/react/plot/plot-manager.tsx:10]", "FoodPointsPopupManager failed to render")
    useEffect(function() -- line: 14
        -- upvalues: onError (copy)
        warn("[src/client/react/plot/plot-manager.tsx:12]", "Calling onError")
        onError()
    end, { onError })

    return react.createElement(react.Fragment)
end

return {
    default = function(_) -- PlotManager | line: 20
        -- upvalues: react (copy), useState (copy), useFlameworkComponents (copy), default (copy), ErrorBoundary (copy), Fallback (copy)
        local v1 = useFlameworkComponents(function() -- line: 21
            return true
        end, "client/components/plot-component@PlotComponent")
        local v2, v3 = useState(0)
        local v4 = table.create(#v1)

        local function v5(p3) -- line: 27
            -- upvalues: react (copy), default (copy)
            return react.createElement(react.Fragment, {
                key = p3.instance:GetFullName()
            }, react.createElement(default, {
                plotInstance = p3.instance
            }))
        end

        for v6, v7 in v1 do
            v4[v6] = v5(v7, v6 - 1, v1)
        end

        return react.createElement(ErrorBoundary, {
            fallback = function() -- fallback | line: 39
                -- upvalues: v2 (copy), v3 (copy), react (copy), Fallback (copy)
                return react.createElement(Fallback, {
                    onError = function() -- onError | line: 41
                        -- upvalues: v2 (copy), v3 (copy)
                        return v3(v2 + 1)
                    end
                })
            end,
            key = ("error-boundary-%*"):format(v2)
        }, v4)
    end
}
