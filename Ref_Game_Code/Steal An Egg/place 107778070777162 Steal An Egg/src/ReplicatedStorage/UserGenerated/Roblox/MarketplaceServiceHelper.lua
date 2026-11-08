-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local MarketplaceService = game:GetService("MarketplaceService")
local Cache = require(game.ReplicatedStorage.UserGenerated.Concurrency.Cache)
local Asserts = require(game.ReplicatedStorage.UserGenerated.Lang.Asserts)
local v1 = Asserts.TablePermissive({
    PurchaseId = Asserts.String,
    PlayerId = Asserts.Integer,
    ProductId = Asserts.Integer,
    PlaceIdWherePurchased = Asserts.Integer,
    CurrencySpent = Asserts.IntegerNonNegative,
    CurrencyType = Asserts.AnyOf(Asserts.Enum(Enum.CurrencyType), Asserts.String),
    ProductPurchaseChannel = Asserts.Enum(Enum.ProductPurchaseChannel)
})
local v2 = Asserts.Table({
    AssetId = Asserts.Integer,
    InfoType = Asserts.Enum(Enum.InfoType)
})
local v3 = Cache.new({
    Callback = function(p1) -- Callback | line: 158
        -- upvalues: MarketplaceService (copy)
        return MarketplaceService:GetProductInfo(p1.AssetId, p1.InfoType)
    end,
    AssertKey = function(p2) -- AssertKey | line: 161
        -- upvalues: v2 (copy)
        v2(p2)

        return (("%*,%*"):format(p2.AssetId, p2.InfoType.Value))
    end
})
local t2 = {
    AssertReceiptInfo = v1
}

function t2.GetInfoAsync(p3, p4, p5) -- line: 171
    -- upvalues: Asserts (copy), v3 (copy)
    Asserts.Integer(p3)
    Asserts.Enum(Enum.InfoType)(p4)
    Asserts.Optional(Asserts.Boolean)(p5)

    local t3 = {
        AssetId = p3,
        InfoType = p4
    }

    if p5 then
        return v3:Get(t3)
    end

    return v3:GetAsync(t3)
end

return table.freeze(t2)
