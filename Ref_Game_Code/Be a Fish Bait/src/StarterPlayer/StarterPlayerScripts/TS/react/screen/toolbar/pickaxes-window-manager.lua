-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local useCallback, useMemo = react.useCallback, react.useMemo
local reflex = RuntimeLib.import(script, script.Parent.Parent.Parent, "hooks", "reflex")
local useRootProducer, useRootSelector = reflex.useRootProducer, reflex.useRootSelector
local selectPlayerInventory = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "slices", "player-data", "selectors").selectPlayerInventory
local localPlayerUserId = RuntimeLib.import(script, script.Parent.Parent.Parent.Parent, "utils").localPlayerUserId
local functions = RuntimeLib.import(script, script.Parent.Parent.Parent.Parent, "network").functions
local default = RuntimeLib.import(script, script.Parent.Parent, "pickaxes-window").default
local mapToArray = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "utils").mapToArray

return {
    PickaxesWindowManager = function() -- PickaxesWindowManager | line: 15
        -- upvalues: react (copy), useCallback (copy), useMemo (copy), useRootProducer (copy), useRootSelector (copy), selectPlayerInventory (copy), localPlayerUserId (copy), functions (copy), default (copy), mapToArray (copy)
        local v1 = useRootProducer()
        local v2 = useRootSelector(selectPlayerInventory(localPlayerUserId))
        local v3 = useMemo(function() -- line: 18
            -- upvalues: v2 (copy), mapToArray (copy)
            if not v2 then
                return {}
            end

            local t1 = {}
            local t2 = {}

            for _, v4 in (mapToArray(v2)) do
                if v4.itemType == "pickaxe" then
                    if v4.isInToolbar then
                        table.insert(t1, v4)
                    else
                        table.insert(t2, v4)
                    end
                end
            end

            local t3 = {}
            local v5 = #t3
            local v6 = #t1

            table.move(t1, 1, v6, v5 + 1, t3)

            local v7 = v5 + v6

            table.move(t2, 1, #t2, v7 + 1, t3)

            return t3
        end, { v2 })
        local v8 = useCallback(function(p1) -- line: 42
            -- upvalues: v3 (copy), functions (copy)
            local v9

            for v10, v11 in v3 do
                local _ = v10 - 1

                if v11.itemId == p1 == true then
                    v9 = v11
                    break
                end

                v9 = nil
            end

            if v9 == nil or v9.itemType == "pickaxe" and v9.isInToolbar then
                return nil
            end

            if v9.itemType == "pickaxe" then
                functions.setPickaxeInToolbar(v9.itemId)
                functions.equipInventoryItem(v9.itemId)
            end
        end, { v3 })

        return react.createElement(default, {
            onClose = function() -- onClose | line: 68
                -- upvalues: v1 (copy)
                v1.windowClosed({})
            end,
            onItemClick = v8,
            pickaxeItems = v3
        })
    end
}
