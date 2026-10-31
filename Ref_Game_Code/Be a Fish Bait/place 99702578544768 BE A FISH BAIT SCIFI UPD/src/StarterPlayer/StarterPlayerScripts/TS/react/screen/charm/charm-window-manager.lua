-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local useCallback = react.useCallback
local functions = RuntimeLib.import(script, script.Parent.Parent.Parent.Parent, "network").functions
local reflex = RuntimeLib.import(script, script.Parent.Parent.Parent, "hooks", "reflex")
local useRootProducer, useRootSelector = reflex.useRootProducer, reflex.useRootSelector
local localPlayerUserId = RuntimeLib.import(script, script.Parent.Parent.Parent.Parent, "utils").localPlayerUserId
local selectPlayerCharms = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "slices", "player-data", "selectors").selectPlayerCharms
local default = RuntimeLib.import(script, script.Parent, "charm-window").default

return {
    default = function() -- CharmWindowManager | line: 13
        -- upvalues: react (copy), useCallback (copy), functions (copy), useRootProducer (copy), useRootSelector (copy), localPlayerUserId (copy), selectPlayerCharms (copy), default (copy)
        local v1 = useRootProducer()
        local v2 = useRootSelector(selectPlayerCharms(localPlayerUserId))
        local v3 = useCallback(function(p1) -- line: 16
            -- upvalues: functions (copy)
            functions.equipCharm(p1, "skin"):catch(function(p2) -- line: 17
                warn("[src/client/react/screen/charm/charm-window-manager.tsx:15]", (("Charm skin equip request failed: %*"):format(p2)))
            end)
        end, {})
        local v4 = useCallback(function() -- line: 21
            -- upvalues: functions (copy)
            functions.unequipCharm("skin"):catch(function(p3) -- line: 22
                warn("[src/client/react/screen/charm/charm-window-manager.tsx:21]", (("Charm skin unequip request failed: %*"):format(p3)))
            end)
        end, {})
        local v5 = useCallback(function(p4) -- line: 26
            -- upvalues: functions (copy)
            functions.equipCharm(p4, "attributes"):catch(function(p5) -- line: 27
                warn("[src/client/react/screen/charm/charm-window-manager.tsx:27]", (("Charm Attributes equip request failed: %*"):format(p5)))
            end)
        end, {})
        local v6 = useCallback(function() -- line: 31
            -- upvalues: functions (copy)
            functions.unequipCharm("attributes"):catch(function(p6) -- line: 32
                warn("[src/client/react/screen/charm/charm-window-manager.tsx:33]", (("Charm Attributes unequip request failed: %*"):format(p6)))
            end)
        end, {})
        local v7 = useCallback(function() -- line: 36
            -- upvalues: v1 (copy)
            return v1.windowClosed({})
        end, { v1 })
        local v8 = if v2 == nil then v2 else v2.ownedCharmIds

        if v8 == nil then
            v8 = {}
        end

        local v9 = if v2 == nil then v2 else v2.charmCoresByTier

        if v9 == nil then
            v9 = {}
        end

        local t1 = {
            inventoryProps = {
                charmCoresByTier = v9,
                displayedCharmId = if v2 == nil then v2 else v2.displayedCharmId,
                equippedAttributesCharmId = if v2 ~= nil then v2.equippedCharmId else v2,
                onEquipAttributes = v5,
                onEquipSkin = v3,
                onUnequipAttributes = v6,
                onUnequipSkin = v4,
                ownedCharmIds = v8
            },
            onClose = v7
        }

        return react.createElement(default, t1)
    end
}
