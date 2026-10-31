-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local useCallback, useEffect = react.useCallback, react.useEffect
local functions = RuntimeLib.import(script, script.Parent.Parent.Parent.Parent, "network").functions
local useConfig = RuntimeLib.import(script, script.Parent.Parent.Parent, "context", "config-context").useConfig
local reflex = RuntimeLib.import(script, script.Parent.Parent.Parent, "hooks", "reflex")
local useRootProducer, useRootSelector = reflex.useRootProducer, reflex.useRootSelector
local localPlayerUserId = RuntimeLib.import(script, script.Parent.Parent.Parent.Parent, "utils").localPlayerUserId
local selectPlayerZoneGacha = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "slices", "player-data", "selectors").selectPlayerZoneGacha
local default = RuntimeLib.import(script, script.Parent, "zone-gacha-window").default

return {
    default = function() -- ZoneGachaWindowManager | line: 15
        -- upvalues: RuntimeLib (copy), react (copy), useCallback (copy), useEffect (copy), functions (copy), useConfig (copy), useRootProducer (copy), useRootSelector (copy), localPlayerUserId (copy), selectPlayerZoneGacha (copy), default (copy)
        local v1 = useRootProducer()
        local v2 = useRootSelector(selectPlayerZoneGacha(localPlayerUserId))
        local v3 = useConfig()
        local disableMovement, enableMovement = v3.disableMovement, v3.enableMovement

        useEffect(function() -- line: 21
            -- upvalues: disableMovement (copy), enableMovement (copy)
            disableMovement()

            return function() -- line: 23
                -- upvalues: enableMovement (copy)
                return enableMovement()
            end
        end, { disableMovement, enableMovement })

        local v4 = useCallback(RuntimeLib.async(function(p1) -- line: 27
            -- upvalues: RuntimeLib (copy), functions (copy)
            local v5 = RuntimeLib.await(functions.rollZoneGacha(p1))

            return if v5 ~= false then v5 else nil
        end), {})
        local v6 = useCallback(function(p2, p3) -- line: 31
            -- upvalues: functions (copy)
            functions.equipZoneGachaSkin(p2, p3):catch(function(p4) -- line: 32
                warn("[src/client/react/screen/zone-gacha/zone-gacha-window-manager.tsx:31]", (("Zone gacha skin equip request failed: %*"):format(p4)))
            end)
        end, {})
        local v7 = useCallback(function(p5, p6) -- line: 36
            -- upvalues: functions (copy)
            functions.equipZoneGachaBuff(p5, p6):catch(function(p7) -- line: 37
                warn("[src/client/react/screen/zone-gacha/zone-gacha-window-manager.tsx:37]", (("Zone gacha buff equip request failed: %*"):format(p7)))
            end)
        end, {})
        local v8 = useCallback(function() -- line: 42
            warn("[src/client/react/screen/zone-gacha/zone-gacha-window-manager.tsx:43]", "Zone gacha token purchases are not implemented yet.")
        end, {})
        local v9 = useCallback(function() -- line: 45
            -- upvalues: v1 (copy)
            return v1.windowClosed({})
        end, { v1 })
        local t2 = {
            eyes = if v2 == nil then v2 else v2.eyesEquippedBuffId,
            head = if v2 == nil then v2 else v2.headEquippedBuffId,
            legendary = if v2 == nil then v2 else v2.legendaryEquippedBuffId
        }
        local t1 = {}

        t1.equippedBuffIdByCategory = t2
        t1.equippedSkinIdByCategory = {
            eyes = if v2 == nil then v2 else v2.eyesEquippedSkinId,
            head = if v2 == nil then v2 else v2.headEquippedSkinId,
            legendary = if v2 == nil then v2 else v2.legendaryEquippedSkinId
        }
        t1.onBuyMoreTokens = v8
        t1.onClose = v9
        t1.onEquipAsBuff = v7
        t1.onEquipAsSkin = v6
        t1.onRoll = v4

        local v10 = if v2 == nil then v2 else v2.ownedItemIds

        t1.ownedItemIds = if v10 == nil then {} else v10

        local v11 = if v2 == nil then v2 else v2.tokenA

        if v11 == nil then
            v11 = 0
        end

        local t4 = {
            tokenA = v11
        }
        local v12 = if v2 == nil then v2 else v2.tokenB

        t4.tokenB = if v12 == nil then 0 else v12

        if v2 ~= nil then
            v2 = v2.tokenC
        end

        t4.tokenC = if v2 == nil then 0 else v2
        t1.tokenBalances = t4

        return react.createElement(default, t1)
    end
}
