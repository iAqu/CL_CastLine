-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Log = require(ReplicatedStorage.Packages.Log)
local Marketplace = require(ReplicatedStorage.Shared.Utils.Marketplace)

require(script.Parent.ProductTypes)

local v1 = if game.CreatorType == Enum.CreatorType.Group then "Group" else "User"
local CreatorId = game.CreatorId
local v2 = Log.new()
local t1 = {}

local function creatorId(p1) -- line: 19
    if p1 then
        local v3 = p1.CreatorTargetId or p1.Id

        if v3 and v3 > 0 then
            return v3
        end
    end

    return nil
end

function t1.Validate(p2, p3) -- line: 27
    -- upvalues: Marketplace (copy), CreatorId (copy), v2 (copy), v1 (copy)
    local v4 = Marketplace.Current(p3.ProductId, Enum.InfoType.Product)

    if v4 ~= nil then
        local v5 = v4.PriceInRobux or 0

        if v5 <= 0 then
            v2:AtWarning():Log(("Product %* has an invalid Robux price"):format(p2), {
                ProductId = p3.ProductId,
                PriceInRobux = v5
            })
        elseif v5 > 10000 then
            v2:AtWarning():Log(("Product %* is priced above the Studio validation threshold"):format(p2), {
                MaxAllowedPrice = 10000,
                ProductId = p3.ProductId,
                PriceInRobux = v5
            })
        end

        local Creator = v4.Creator
        local v6, v7

        if Creator then
            v6 = Creator.CreatorTargetId or Creator.Id
            v7 = false
        else
            v7 = true
        end

        if v7 or not (v6 and v6 > 0) then
            v6 = nil
        end

        if Creator and Creator.CreatorType and v6 and (Creator.CreatorType ~= v1 or v6 ~= CreatorId) then
            v2:AtWarning():Log(("Product %* is owned by the wrong creator"):format(p2), {
                ProductId = p3.ProductId
            })
        end
    else
        v2:AtWarning():Log(("Failed to validate marketplace product info for %*"):format(p2), {
            ProductId = p3.ProductId
        })
    end
end

return t1
