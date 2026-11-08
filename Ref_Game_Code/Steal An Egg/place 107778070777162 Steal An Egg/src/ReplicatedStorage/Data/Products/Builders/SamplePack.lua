-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local Simple = require(ReplicatedStorage.Packages.FormatNumber.Simple)

require(script.Parent.Parent.Internal.ProductTypes)

local SamplePacks = require(ReplicatedStorage.Data.SamplePacks)

local function createSamplePack(p1, p2) -- line: 10
    -- upvalues: ServerScriptService (copy), Simple (copy), SamplePacks (copy)
    local t1 = {
        SamplePackProduct = true,
        HoldWhilePending = true,
        Giftable = true,
        Name = p1,
        ProductId = p2,
        Authorize = function(p3, p4) -- Authorize | line: 20
            -- upvalues: p2 (copy), ServerScriptService (copy)
            return require(ServerScriptService.Controllers.ScrambleService.Commerce).getCanPurchase(p3, {
                productId = p2,
                receipt = p4
            })
        end
    }

    function t1.Precheck() -- line: 32
        return false, "Samples are no longer available for purchase."
    end

    function t1.Grant(p5, p6) -- line: 35
        -- upvalues: ServerScriptService (copy)
        if p6 == nil then
            return false
        end

        return require(ServerScriptService.Controllers.ScrambleService.Commerce).GrantGift(p5, p6)
    end

    local function refresh() -- line: 50
        -- upvalues: p2 (copy), t1 (copy), Simple (copy), SamplePacks (copy)
        local v1 = SamplePacks.Find(p2)

        if v1 == nil then
            return
        end

        local v2 = Simple.Format(v1.Amount, "precision-integer") .. " Samples"

        t1.DisplayName = v2
        t1.Desc = "Purchase " .. v2 .. "."
    end

    local v3 = SamplePacks.Find(p2)

    if v3 ~= nil then
        local v4 = Simple.Format(v3.Amount, "precision-integer") .. " Samples"

        t1.DisplayName = v4
        t1.Desc = "Purchase " .. v4 .. "."
    end

    SamplePacks.getChangedSignal():Connect(refresh)

    return t1
end

return createSamplePack
