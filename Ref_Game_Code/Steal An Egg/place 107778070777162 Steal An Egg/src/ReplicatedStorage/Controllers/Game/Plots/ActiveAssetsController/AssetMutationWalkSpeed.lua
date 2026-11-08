-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local AssetItem = require(ReplicatedStorage.Shared.Types.AssetItem)
local v1 = require(ReplicatedStorage.Shared.Modules.Mutations).Ids()
local t1 = {}

local function hasMutation(p1, p2) -- line: 20
    if p1.BaseMutation == p2 then
        return true
    end

    return table.find(p1.Mutations, p2) ~= nil
end

function t1.GetMultiplier(p3) -- line: 28
    -- upvalues: AssetItem (copy), v1 (copy)
    assert(AssetItem.AssetItemData(p3), "Invalid asset item data")

    local Rainbow = v1.Rainbow

    if p3.BaseMutation == Rainbow or table.find(p3.Mutations, Rainbow) ~= nil then
        return 2
    end

    local Golden = v1.Golden

    if p3.BaseMutation == Golden or table.find(p3.Mutations, Golden) ~= nil then
        return 0.5
    end

    local Silver = v1.Silver

    if p3.BaseMutation == Silver or table.find(p3.Mutations, Silver) ~= nil then
        return 0.7
    end

    return 1
end

return t1
