-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Flamework = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Flamework
local services = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services")
local MarketplaceService, Players = services.MarketplaceService, services.Players
local functions = RuntimeLib.import(script, script.Parent, "network").functions
local clientProducer = RuntimeLib.import(script, script.Parent, "reflex", "producer").clientProducer
local v1 = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "store-utils")
local getTimeSkipConfigs, getMoneyPackConfigs = v1.getTimeSkipConfigs, v1.getMoneyPackConfigs

local function fallbackToRealPurchasePrompt(p1, p2) -- line: 12
    -- upvalues: MarketplaceService (copy), Players (copy), clientProducer (copy)
    if p2 ~= nil then
        clientProducer.purchaseExtraInfoQueued({
            productId = p1,
            extraInfo = p2
        })
    end

    clientProducer.purchaseRetryStarted({
        productId = p1
    })
    MarketplaceService:PromptProductPurchase(Players.LocalPlayer, p1)
end

local function attemptStorePurchase(p3, p4) -- line: 37
    -- upvalues: Flamework (copy), functions (copy), fallbackToRealPurchasePrompt (copy)
    functions.requestFreeTestPurchase(p3, p4):andThen(function(p5) -- line: 38
        -- upvalues: p3 (copy), p4 (copy), Flamework (copy), fallbackToRealPurchasePrompt (copy)
        if p5.kind == "not_eligible" then
            fallbackToRealPurchasePrompt(p3, p4)

            return nil
        end

        Flamework.resolveDependency("client/controllers/store-controller@StoreController"):handlePurchaseResult(p3, p5)
    end):catch(function() -- line: 44
        -- upvalues: p3 (copy), p4 (copy), fallbackToRealPurchasePrompt (copy)
        return fallbackToRealPurchasePrompt(p3, p4)
    end)
end

local function attemptGiftPurchase(p6, p7) -- line: 55
    -- upvalues: Flamework (copy), MarketplaceService (copy), Players (copy), functions (copy), clientProducer (copy)
    local function v2() -- line: 56
        -- upvalues: p6 (copy), MarketplaceService (copy), Players (copy), clientProducer (copy)
        clientProducer.purchaseRetryStarted({
            productId = p6
        })
        MarketplaceService:PromptProductPurchase(Players.LocalPlayer, p6)
    end

    functions.requestFreeTestPurchase(p6, nil, p7):andThen(function(p8) -- line: 65
        -- upvalues: p6 (copy), p7 (copy), Flamework (copy), MarketplaceService (copy), Players (copy), clientProducer (copy)
        if p8.kind == "not_eligible" then
            clientProducer.purchaseRetryStarted({
                productId = p6
            })
            MarketplaceService:PromptProductPurchase(Players.LocalPlayer, p6)

            return nil
        end

        Flamework.resolveDependency("client/controllers/store-controller@StoreController"):handlePurchaseResult(p6, p8, p7)
    end):catch(v2)
end

local function promptProductPurchaseWithExtraInfo(p9, p10) -- line: 73
    -- upvalues: attemptStorePurchase (copy)
    attemptStorePurchase(p9, p10)
end

return {
    attemptStorePurchase = attemptStorePurchase,
    attemptGiftPurchase = attemptGiftPurchase,
    promptProductPurchaseWithExtraInfo = promptProductPurchaseWithExtraInfo,
    promptCashPurchase = function(p11, p12) -- promptCashPurchase | line: 84
        -- upvalues: getTimeSkipConfigs (copy), getMoneyPackConfigs (copy), attemptStorePurchase (copy)
        local t1 = {}

        if p12 > 0 then
            for _, v3 in getTimeSkipConfigs() do
                local v5 = math.floor(p12 * v3.seconds)

                if v5 > 0 then
                    table.insert(t1, {
                        productId = v3.storeProductId,
                        cashValue = v5
                    })
                end
            end
        end

        for _, v6 in getMoneyPackConfigs() do
            table.insert(t1, {
                productId = v6.storeProductId,
                cashValue = v6.cashAmount
            })
        end

        if #t1 == 0 then
            return nil
        end

        table.sort(t1, function(p13, p14) -- line: 111
            return p13.cashValue < p14.cashValue
        end)

        local v7 = t1[#t1]

        for _, v8 in t1 do
            if p11 <= v8.cashValue then
                v7 = v8
                break
            end
        end

        attemptStorePurchase(v7.productId)
    end
}
