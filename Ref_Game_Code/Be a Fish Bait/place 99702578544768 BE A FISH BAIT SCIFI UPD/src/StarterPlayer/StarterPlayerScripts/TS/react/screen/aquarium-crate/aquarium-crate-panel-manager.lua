-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local Players = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services").Players
local attemptStorePurchase = RuntimeLib.import(script, script.Parent.Parent.Parent.Parent, "store-purchase-utils").attemptStorePurchase
local usePaidItemsAllowed = RuntimeLib.import(script, script.Parent.Parent.Parent, "hooks", "use-local-player-policy-info").usePaidItemsAllowed
local useProductPrice = RuntimeLib.import(script, script.Parent.Parent.Parent, "hooks", "use-product-price").useProductPrice
local reflex = RuntimeLib.import(script, script.Parent.Parent.Parent, "hooks", "reflex")
local useRootProducer, useRootSelector = reflex.useRootProducer, reflex.useRootSelector
local v1 = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "data", "aquarium-crates")
local activeAquariumCrateSeries, firstAquariumCratePriceRobux, getAquariumCrateProductForQuantity, getAquariumCrateSeriesById = v1.activeAquariumCrateSeries, v1.firstAquariumCratePriceRobux, v1.getAquariumCrateProductForQuantity, v1.getAquariumCrateSeriesById
local singleAquariumCratePriceRobux, tenAquariumCratesPriceRobux, threeAquariumCratesPriceRobux = v1.singleAquariumCratePriceRobux, v1.tenAquariumCratesPriceRobux, v1.threeAquariumCratesPriceRobux
local selectors = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "slices", "player-data", "selectors")
local selectPlayerAquariumCratePityCount, selectPlayerHasClaimedAquariumCrateFirstPurchase = selectors.selectPlayerAquariumCratePityCount, selectors.selectPlayerHasClaimedAquariumCrateFirstPurchase
local default = RuntimeLib.import(script, script.Parent, "aquarium-crate-panel").default
local v2 = tostring(Players.LocalPlayer.UserId)

return {
    default = function(p1) -- AquariumCratePanelManager | line: 24
        -- upvalues: react (copy), attemptStorePurchase (copy), usePaidItemsAllowed (copy), useProductPrice (copy), useRootProducer (copy), useRootSelector (copy), activeAquariumCrateSeries (copy), firstAquariumCratePriceRobux (copy), getAquariumCrateProductForQuantity (copy), getAquariumCrateSeriesById (copy), singleAquariumCratePriceRobux (copy), tenAquariumCratesPriceRobux (copy), threeAquariumCratesPriceRobux (copy), selectPlayerAquariumCratePityCount (copy), selectPlayerHasClaimedAquariumCrateFirstPurchase (copy), default (copy), v2 (copy)
        local v3 = useRootProducer()
        local seriesId = p1.seriesId

        if seriesId == nil then
            seriesId = activeAquariumCrateSeries.id
        end

        local v4 = getAquariumCrateSeriesById(seriesId)

        if v4 == nil then
            v4 = activeAquariumCrateSeries
        end

        local v5 = useRootSelector(selectPlayerAquariumCratePityCount(v2))
        local v6 = useRootSelector(selectPlayerHasClaimedAquariumCrateFirstPurchase(v2, v4.id))
        local v7 = usePaidItemsAllowed()
        local v8 = getAquariumCrateProductForQuantity(v4.id, 1, true)
        local v9 = getAquariumCrateProductForQuantity(v4.id, 1)
        local v10 = getAquariumCrateProductForQuantity(v4.id, 3)
        local v11 = getAquariumCrateProductForQuantity(v4.id, 10)

        if v8 ~= nil then
            v8 = v8.productId
        end

        local v12 = useProductPrice(v8, Enum.InfoType.Product)

        if v9 ~= nil then
            v9 = v9.productId
        end

        local v13 = useProductPrice(v9, Enum.InfoType.Product)

        if v10 ~= nil then
            v10 = v10.productId
        end

        local v14 = useProductPrice(v10, Enum.InfoType.Product)

        if v11 ~= nil then
            v11 = v11.productId
        end

        local v15 = useProductPrice(v11, Enum.InfoType.Product)
        local t1 = {
            compact = p1.compact,
            crateIconVisible = p1.crateIconVisible,
            embeddedInShop = p1.embeddedInShop,
            hasPurchasedFirstCrate = v6,
            onPurchase = function(p2) -- onPurchase | line: 67
                -- upvalues: v4 (ref), v6 (copy), attemptStorePurchase (copy), getAquariumCrateProductForQuantity (copy)
                local v17 = getAquariumCrateProductForQuantity(v4.id, p2, p2 == 1 and not v6)

                if v17 ~= nil and v17.productId > 0 then
                    attemptStorePurchase(v17.productId)
                end
            end,
            onShards = function() -- onShards | line: 73
                -- upvalues: v3 (copy)
                return v3.windowOpened({
                    aquariumShopSection = "shards",
                    currentWindow = "aquariumShop"
                })
            end,
            paidItemsAllowed = v7,
            pityCount = v5
        }

        if v12 == nil then
            v12 = firstAquariumCratePriceRobux
        end

        t1.prices = {
            first = v12,
            one = if v13 == nil then singleAquariumCratePriceRobux else v13,
            ten = if v15 == nil then tenAquariumCratesPriceRobux else v15,
            three = if v14 == nil then threeAquariumCratesPriceRobux else v14
        }
        t1.purchasesDisabled = p1.purchasesDisabled
        t1.series = v4
        t1.showShardsButton = not p1.hideShardsButton
        t1.showTitle = p1.showTitle
        t1.variant = p1.variant

        return react.createElement(default, t1)
    end
}
