-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local MarketplaceService = game:GetService("MarketplaceService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Products = require(ReplicatedStorage:WaitForChild("Shared").Data.Products)
local OfferGate = require(script.Parent.OfferGate)
local LocalPlayer = Players.LocalPlayer
local n1 = -100
local t1 = {}

t1.Last = nil
t1.Count = 0
t1.Mute = false

function t1.Pick(p1) -- line: 18
    -- upvalues: Products (copy), LocalPlayer (copy)
    local v1 = LocalPlayer:GetAttribute("IncomePerSecond") or 0
    local v2, v3

    for _, v4 in ipairs(Products.CashPacks) do
        if v4.id ~= 0 then
            if p1 <= Products.CashFor(v4, v1) then
                v3 = v4
                break
            end

            v2 = v4
        end

        v3 = v2
    end

    return v3
end

function t1.Init() -- line: 32
    -- upvalues: MarketplaceService (copy), ReplicatedStorage (copy), OfferGate (copy), t1 (copy), LocalPlayer (copy), n1 (ref)
    ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("OfferCash").OnClientEvent:Connect(function(p2) -- line: 33
        -- upvalues: MarketplaceService (copy), OfferGate (copy), t1 (copy), LocalPlayer (copy), n1 (ref)
        local Shared = OfferGate.Shared
        local v5 = t1.Pick(tonumber(p2) or 0)

        if os.clock() - n1 < 4 or Shared.TutorialActive and Shared.TutorialActive() or not v5 then
            require(script.Parent.Toasts).Show("error", "Not enough money!")

            return
        end

        n1 = os.clock()
        t1.Last = v5.key
        t1.Count += 1

        if not t1.Mute then
            local function v6() -- line: 44
                -- upvalues: v5 (copy), MarketplaceService (copy), LocalPlayer (copy)
                MarketplaceService:PromptProductPurchase(LocalPlayer, v5.id)
            end

            pcall(v6)
        end
    end)
end

return t1
