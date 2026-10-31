-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local reflex = RuntimeLib.import(script, script.Parent.Parent.Parent, "hooks", "reflex")
local useRootProducer, useRootSelector = reflex.useRootProducer, reflex.useRootSelector
local selectPlayerStat = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "slices", "player-data", "selectors").selectPlayerStat
local localPlayerUserId = RuntimeLib.import(script, script.Parent.Parent.Parent.Parent, "utils").localPlayerUserId
local default = RuntimeLib.import(script, script.Parent, "set-power-modal").default

return {
    default = function() -- SetPowerWindowManager | line: 10
        -- upvalues: react (copy), useRootProducer (copy), useRootSelector (copy), selectPlayerStat (copy), localPlayerUserId (copy), default (copy)
        local v1 = useRootProducer()
        local v2 = useRootSelector(selectPlayerStat(localPlayerUserId, "power"))

        if v2 == nil then
            v2 = 0
        end

        return react.createElement(default, {
            maxPower = v2,
            onClose = function() -- onClose | line: 19
                -- upvalues: v1 (copy)
                return v1.windowClosed({})
            end
        })
    end
}
