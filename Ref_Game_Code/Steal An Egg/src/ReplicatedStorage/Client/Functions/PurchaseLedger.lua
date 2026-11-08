-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local MarketplaceService = game:GetService("MarketplaceService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Products = require(ReplicatedStorage.Data.Products)
local Remotes = require(ReplicatedStorage.Shared.Remotes)
local Save = require(ReplicatedStorage.Shared.Save)
local LocalPlayer = Players.LocalPlayer
local t1 = {}
local t2 = nil
local t3 = {
    OwnedPerProfile = function(p1) -- OwnedPerProfile | line: 22
        -- upvalues: Save (copy)
        local v1 = Save.Peek()
        local Products = if v1 == nil then nil else v1.Products

        if type(Products) == "table" then
            return Products[tostring(p1)] == true
        end

        return false
    end,
    AwaitingReceipt = function(p2) -- AwaitingReceipt | line: 28
        -- upvalues: t1 (copy)
        return t1[p2] == true
    end,
    HasOpenTicket = function() -- HasOpenTicket | line: 32
        -- upvalues: t2 (ref)
        return t2 ~= nil
    end,
    OpenTicket = function(p3) -- OpenTicket | line: 36
        -- upvalues: t2 (ref)
        local t4 = {
            Live = true,
            SkuId = p3
        }

        t2 = t4
        task.delay(90, function() -- line: 39
            -- upvalues: t4 (copy), t2 (ref)
            if t2 == t4 then
                t4.Live = false
                t2 = nil
            end
        end)

        return t4
    end,
    CloseTicket = function(p4) -- CloseTicket | line: 48
        -- upvalues: t2 (ref)
        local t5 = t2

        if t5 ~= nil and t5.SkuId == p4 then
            t5.Live = false
            t2 = nil
        end
    end
}

local function settleReceipt(p5) -- line: 56
    -- upvalues: t1 (copy), t3 (copy)
    t1[p5] = nil
    t3.CloseTicket(p5)
end

local function onPromptClosed(p6, p7, p8) -- line: 61
    -- upvalues: Products (copy), LocalPlayer (copy), t1 (copy), t3 (copy)
    if p6 == LocalPlayer.UserId and p7 ~= nil then
        t3.CloseTicket(p7)

        if p8 then
            local v2 = Products.FromProductId(p7)

            if v2 ~= nil and v2.OneTime and not t3.OwnedPerProfile(p7) then
                t1[p7] = true
            end
        else
            t1[p7] = nil
        end
    end
end

if RunService:IsClient() then
    local Storefront = Remotes.Storefront

    Storefront.PurchaseRejected.OnClientEvent:Connect(function(p9) -- line: 78
        -- upvalues: t1 (copy), t3 (copy)
        local ProductId = p9.ProductId

        t1[ProductId] = nil
        t3.CloseTicket(ProductId)
    end)
    Storefront.PurchaseSettled.OnClientEvent:Connect(function(_, p11) -- line: 81
        -- upvalues: t1 (copy), t3 (copy)
        local ProductId = p11.ProductId

        t1[ProductId] = nil
        t3.CloseTicket(ProductId)
    end)
    Storefront.ReceiptCleared.OnClientEvent:Connect(function(p12, _, _) -- line: 84
        -- upvalues: t1 (copy), t3 (copy)
        t1[p12] = nil
        t3.CloseTicket(p12)
    end)
    MarketplaceService.PromptProductPurchaseFinished:Connect(onPromptClosed)
end

return table.freeze(t3)
