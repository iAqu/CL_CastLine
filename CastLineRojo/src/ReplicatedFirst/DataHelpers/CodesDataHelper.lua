local ReplicatedFirst = game:GetService("ReplicatedFirst")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local CodesData = require(ReplicatedFirst.Data.CodesData)
local PlayerData = require(ReplicatedStorage.PlayerData.Template)
local LogHelper = require(ReplicatedStorage.Modules.LogHelper)

local CodesDataHelper = {}

function CodesDataHelper.GetAllData(): {CodesData.CodeConfig}
    return CodesData
end

function CodesDataHelper.GetData(codeId: string): {CodesData.CodeConfig}
    if CodesData[codeId] == nil then return end
    return CodesData[codeId]
end

function CodesDataHelper.GetCount(codeId: string): number
    if CodesDataHelper.GetData(codeId) == nil then return end
    if CodesDataHelper.GetData(codeId).Count == nil then return end
    return CodesDataHelper.GetData(codeId).Count
end

function CodesDataHelper.GetType(codeId: string): string
    if CodesDataHelper.GetData(codeId) == nil then return end
    if CodesDataHelper.GetData(codeId).Count == nil then return end
    return CodesDataHelper.GetData(codeId).Type
end

function CodesDataHelper.GetLimited(codeId: string): string
    if CodesDataHelper.GetData(codeId) == nil then return end
    return CodesDataHelper.GetData(codeId).Limited
end


function CodesDataHelper.GetItemId(codeId: string): string
    if CodesDataHelper.GetData(codeId) == nil then return end
    if CodesDataHelper.GetData(codeId).Count == nil then return end
    return CodesDataHelper.GetData(codeId).ItemId
end

function CodesDataHelper.GetRarityIndex(codeId: string): number
    if CodesDataHelper.GetData(codeId) == nil then return end
    if CodesDataHelper.GetData(codeId).RarityIndex == nil then return end
    return CodesDataHelper.GetData(codeId).RarityIndex
end

-- function CodesDataHelper.GetYTCodeType(codeId: string): string
--     if CodesDataHelper.GetYTCodeData(codeId) == nil then return end
--     return CodesDataHelper.GetYTCodeData(codeId).Type
-- end

-- function CodesDataHelper.GetYTCodeActive(codeId: string): string
--     if CodesDataHelper.GetYTCodeData(codeId) == nil then return end
--     return CodesDataHelper.GetYTCodeData(codeId).Active
-- end

-- function CodesDataHelper.GetYTCodeLimitCount(codeId: string): string
--     if CodesDataHelper.GetYTCodeData(codeId) == nil then return end
--     return CodesDataHelper.GetYTCodeData(codeId).Limited
-- end

return CodesDataHelper