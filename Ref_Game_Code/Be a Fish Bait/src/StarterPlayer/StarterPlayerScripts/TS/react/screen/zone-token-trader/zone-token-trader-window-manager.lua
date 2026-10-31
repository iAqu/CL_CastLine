-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local useCallback, useEffect, useState = react.useCallback, react.useEffect, react.useState
local useRootProducer = RuntimeLib.import(script, script.Parent.Parent.Parent, "hooks", "reflex").useRootProducer
local useConfig = RuntimeLib.import(script, script.Parent.Parent.Parent, "context", "config-context").useConfig
local default = RuntimeLib.import(script, script.Parent, "zone-token-trader-window").default
local default2 = RuntimeLib.import(script, script.Parent, "zone-token-trader-fish-select-modal").default

return {
    default = function() -- ZoneTokenTraderWindowManager | line: 12
        -- upvalues: react (copy), useCallback (copy), useEffect (copy), useState (copy), useRootProducer (copy), useConfig (copy), default (copy), default2 (copy)
        local v1 = useRootProducer()
        local v2, v3 = useState(nil)
        local v4 = useConfig()
        local disableMovement, enableMovement = v4.disableMovement, v4.enableMovement

        useEffect(function() -- line: 18
            -- upvalues: disableMovement (copy), enableMovement (copy)
            disableMovement()

            return function() -- line: 20
                -- upvalues: enableMovement (copy)
                return enableMovement()
            end
        end, { disableMovement, enableMovement })

        local v5 = useCallback(function() -- line: 24
            -- upvalues: v1 (copy)
            return v1.windowClosed({})
        end, { v1 })

        return react.createElement(react.Fragment, nil, react.createElement(default, {
            onClose = v5,
            onSelectToken = v3
        }), v2 ~= nil and react.createElement(default2, {
            onClose = function() -- onClose | line: 31
                -- upvalues: v3 (copy)
                return v3(nil)
            end,
            tokenType = v2
        }))
    end
}
