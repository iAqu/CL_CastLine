-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local HttpService = game:GetService("HttpService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local BalanceConfig = require(ReplicatedStorage.Shared.Flags.BalanceConfig)

require(ReplicatedStorage.Shared.Types.Eggs)
require(ReplicatedStorage.Data.LimitedEgg.Types.Interface)

local LimitedEgg = require(ReplicatedStorage.Data.LimitedEgg)
local Numeric = require(ReplicatedStorage.Shared.Utils.Numeric)

require(script.Parent.Parent.Internal.ProductTypes)

local t = require(ReplicatedStorage.Packages.t)
local t1 = {
    HoldWhilePending = true,
    Icon = "",
    Silent = true
}
local v1 = Random.new()

local function withDefaults(p1) -- line: 25
    -- upvalues: t1 (copy)
    local v2 = table.clone(t1)

    for v3, v4 in p1 do
        v2[v3] = v4
    end

    return v2
end

local function presentation(p2) -- line: 33
    local v5 = if p2 == 1 then "A limited pet egg." else ("%* limited pet eggs."):format(p2)

    return ("Limited Egg x%*"):format(p2), v5
end

local function rollGrants(p3, p4, p5) -- line: 38
    -- upvalues: HttpService (copy), ReplicatedStorage (copy), Numeric (copy), t (copy), v1 (copy)
    local EggRecords = require(ReplicatedStorage.Shared.Util.EggRecords)
    local v6 = table.create(p4)

    for i = 1, p4 do
        local v7 = Numeric.RollWeighted(p3.DropTable, v1)

        t.strict(t.string)(v7)

        local v8 = EggRecords.NewEgg(v7)

        v8.PurchaseId = p5
        v6[i] = {
            Uid = HttpService:GenerateGUID(false):gsub("-", ""):lower(),
            Record = v8
        }
    end

    return v6
end

local function CreateLimitedEggProductConfig(p6, p7, p8, p9) -- line: 57
    -- upvalues: ReplicatedStorage (copy), ServerScriptService (copy), BalanceConfig (copy), LimitedEgg (copy), t (copy), t1 (copy), rollGrants (copy)
    t.strict(t.string)(p6)
    t.strict(t.numberPositive)(p7)
    t.strict(t.intersection(t.integer, t.numberPositive))(p8)
    t.strict(t.table)(p9)

    local function liveCount() -- line: 68
        -- upvalues: p6 (copy), p8 (copy), p9 (copy)
        for _, v9 in p9.Offers do
            if v9.ProductName == p6 or v9.GiftProductName == p6 then
                return v9.Amount
            end
        end

        return p8
    end

    local function authorize(p10, p11) -- line: 77
        -- upvalues: p9 (copy), ServerScriptService (copy), LimitedEgg (copy), t (copy)
        t.strict(t.instanceIsA("Player"))(p10)

        if p11 == nil and not LimitedEgg.IsOnSale(p9) then
            return false, "This egg is no longer on sale."
        end

        if require(ServerScriptService.Library.Database).IsPlayerLoaded(p10) then
            return true
        end

        return false, "Data not loaded"
    end

    local function precheck() -- line: 87
        -- upvalues: p9 (copy), ReplicatedStorage (copy), LimitedEgg (copy)
        if not LimitedEgg.IsOnSale(p9) then
            return false, "This egg is no longer on sale."
        end

        if require(ReplicatedStorage.Shared.Save).Await() == nil then
            return false, "Data not loaded"
        end

        return true
    end

    local function grant(p12, p13) -- line: 96
        -- upvalues: p6 (copy), p8 (copy), p9 (copy), ServerScriptService (copy), t (copy), rollGrants (copy)
        t.strict(t.instanceIsA("Player"))(p12)

        local Eggs = require(ServerScriptService.Controllers.Eggs)
        local v10 = if p13 ~= nil and p13.PurchaseId ~= nil then tostring(p13.PurchaseId) else nil
        local GrantPaidEggBatch = Eggs.GrantPaidEggBatch
        local v11 = false
        local v12

        for _, v13 in p9.Offers do
            if v13.ProductName == p6 or v13.GiftProductName == p6 then
                v12 = v13.Amount
                v11 = true
                break
            end
        end

        if not v11 then
            v12 = p8
        end

        return GrantPaidEggBatch(p12, (rollGrants(p9, v12, v10)))
    end

    local v14 = false
    local v15

    for _, v16 in p9.Offers do
        if v16.ProductName == p6 or v16.GiftProductName == p6 then
            v15 = v16.Amount
            v14 = true
            break
        end
    end

    if not v14 then
        v15 = p8
    end

    local v17 = if v15 == 1 then "A limited pet egg." else ("%* limited pet eggs."):format(v15)
    local t2 = {
        Name = p6,
        ProductId = p7,
        DisplayName = ("Limited Egg x%*"):format(v15),
        Desc = v17,
        Precheck = precheck,
        Authorize = authorize,
        Grant = grant
    }
    local v18 = table.clone(t1)

    for v19, v20 in t2 do
        v18[v19] = v20
    end

    BalanceConfig.Changed:Connect(function() -- line: 114
        -- upvalues: p6 (copy), p8 (copy), p9 (copy), v18 (copy)
        local v21 = false
        local v22

        for _, v23 in p9.Offers do
            if v23.ProductName == p6 or v23.GiftProductName == p6 then
                v22 = v23.Amount
                v21 = true
                break
            end
        end

        if not v21 then
            v22 = p8
        end

        local v24 = if v22 == 1 then "A limited pet egg." else ("%* limited pet eggs."):format(v22)

        v18.DisplayName = ("Limited Egg x%*"):format(v22)
        v18.Desc = v24
    end)

    return v18
end

return CreateLimitedEggProductConfig
