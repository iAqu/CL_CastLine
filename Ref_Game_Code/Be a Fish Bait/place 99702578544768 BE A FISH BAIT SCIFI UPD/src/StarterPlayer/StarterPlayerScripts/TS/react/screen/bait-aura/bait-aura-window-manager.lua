-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local useEffect = react.useEffect
local Players = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services").Players
local useConfig = RuntimeLib.import(script, script.Parent.Parent.Parent, "context", "config-context").useConfig
local attemptStorePurchase = RuntimeLib.import(script, script.Parent.Parent.Parent.Parent, "store-purchase-utils").attemptStorePurchase
local network = RuntimeLib.import(script, script.Parent.Parent.Parent.Parent, "network")
local events, functions = network.events, network.functions
local reflex = RuntimeLib.import(script, script.Parent.Parent.Parent, "hooks", "reflex")
local useRootProducer, useRootSelector = reflex.useRootProducer, reflex.useRootSelector
local default = RuntimeLib.import(script, script.Parent, "bait-aura-window").default
local v1 = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "store-utils")
local getRerollProductId, getBaitAuraSlotProductId = v1.getRerollProductId, v1.getBaitAuraSlotProductId
local selectors = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "slices", "player-data", "selectors")
local selectPlayerBaitAuras, selectPlayerRebirthCount, selectPlayerStat = selectors.selectPlayerBaitAuras, selectors.selectPlayerRebirthCount, selectors.selectPlayerStat
local v2 = tostring(Players.LocalPlayer.UserId)

return {
    default = function() -- BaitAuraWindowManager | line: 24
        -- upvalues: RuntimeLib (copy), react (copy), useEffect (copy), useConfig (copy), attemptStorePurchase (copy), events (copy), functions (copy), useRootProducer (copy), useRootSelector (copy), default (copy), getRerollProductId (copy), getBaitAuraSlotProductId (copy), selectPlayerBaitAuras (copy), selectPlayerRebirthCount (copy), selectPlayerStat (copy), v2 (copy)
        local v3 = useRootProducer()
        local v4 = useConfig()
        local disableMovement, enableMovement = v4.disableMovement, v4.enableMovement
        local v5 = useRootSelector(selectPlayerStat(v2, "rerolls"))

        if v5 == nil then
            v5 = 0
        end

        local v6 = useRootSelector(selectPlayerRebirthCount(v2))
        local v7 = useRootSelector(selectPlayerBaitAuras(v2))

        useEffect(function() -- line: 36
            -- upvalues: disableMovement (copy), enableMovement (copy)
            disableMovement()

            return function() -- line: 38
                -- upvalues: enableMovement (copy)
                return enableMovement()
            end
        end, { disableMovement, enableMovement })
        useEffect(function() -- line: 42
            -- upvalues: events (copy)
            events.analyticsAuraWindowOpened:fire()
        end, {})

        local v8 = if v7 == nil then v7 else v7.slots

        if v8 == nil then
            v8 = { "", "", "" }
        end

        local t1 = {}

        t1.auraSlots = v8

        local v9 = if v7 == nil then v7 else v7.equippedSlotIndex

        t1.equippedSlotIndex = if v9 == nil then 0 else v9

        t1.onBuyReroll = function(p1) -- line: 64
            -- upvalues: attemptStorePurchase (copy), getRerollProductId (copy)
            local v10 = getRerollProductId(p1)

            if v10 ~= nil then
                attemptStorePurchase(v10)
            end
        end

        t1.onBuySlotWithRobux = function(p2) -- line: 70
            -- upvalues: attemptStorePurchase (copy), getBaitAuraSlotProductId (copy)
            local v11 = getBaitAuraSlotProductId(p2)

            if v11 ~= nil then
                attemptStorePurchase(v11)
            end
        end

        t1.onClose = function() -- line: 76
            -- upvalues: v3 (copy)
            return v3.windowClosed({})
        end

        t1.onEquipSlot = function(p3) -- line: 79
            -- upvalues: functions (copy)
            return functions.equipBaitAura(p3)
        end

        t1.onRollAura = RuntimeLib.async(function(p4) -- line: 82
            -- upvalues: RuntimeLib (copy), functions (copy)
            local v12 = RuntimeLib.await(functions.rollBaitAura(p4))

            return if v12 ~= false then v12 else nil
        end)
        t1.rebirthCount = v6
        t1.rerolls = v5

        if v7 ~= nil then
            v7 = v7.unlockedSlots
        end

        t1.unlockedSlots = if v7 == nil then { true, false, false } else v7

        return react.createElement(default, t1)
    end
}
