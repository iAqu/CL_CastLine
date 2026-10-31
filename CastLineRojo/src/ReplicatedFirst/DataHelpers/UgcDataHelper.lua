local ReplicatedFirst = game:GetService("ReplicatedFirst")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local UgcData = require(ReplicatedFirst.Data.UgcData)

local UgcDataHelper = {}

function UgcDataHelper.GetAllData(): {UgcData.UgcConfig}
    return UgcData
end

function UgcDataHelper.GetData(ugcId: string): {UgcData.UgcConfig}
    if UgcData[ugcId] == nil then return end
    return UgcData[ugcId]
end

function UgcDataHelper.GetName(ugcId: string): number
    if UgcDataHelper.GetData(ugcId) == nil then warn("UgcData not found for ugcId: " , ugcId) return end
    return UgcDataHelper.GetData(ugcId).Name
end

function UgcDataHelper.GetStartDate(ugcId: string): number
    if UgcDataHelper.GetData(ugcId) == nil then warn("UgcData not found for ugcId: " , ugcId) return end
    return UgcDataHelper.GetData(ugcId).StartDate
end

function UgcDataHelper.GetCount(ugcId: string): number
    if UgcDataHelper.GetData(ugcId) == nil then warn("UgcData not found for ugcId: " , ugcId) return end
    return UgcDataHelper.GetData(ugcId).Count
end

function UgcDataHelper.GetImageId(ugcId: string): number
    if UgcDataHelper.GetData(ugcId) == nil then warn("UgcData not found for ugcId: " , ugcId) return end
    return UgcDataHelper.GetData(ugcId).ImageId
end

function UgcDataHelper.GetTasksCount(ugcId: string): number
    if UgcDataHelper.GetData(ugcId) == nil then warn("UgcData not found for ugcId: " , ugcId) return end
    return UgcDataHelper.GetData(ugcId).TasksCount
end

function UgcDataHelper.GetTaskType(ugcId: string, index: number): number
    if UgcDataHelper.GetData(ugcId) == nil then warn("UgcData not found for ugcId: " , ugcId) return end
    if not UgcDataHelper.GetData(ugcId)["Task_" .. index .. "_Type"] then warn("UgcData.Task not found for ugcId: " .. ugcId) return end
    return UgcDataHelper.GetData(ugcId)["Task_" .. index .. "_Type"]
end

function UgcDataHelper.GetTaskInfo(ugcId: string, index: number): number
    if UgcDataHelper.GetData(ugcId) == nil then warn("UgcData not found for ugcId: " , ugcId) return end
    if not UgcDataHelper.GetData(ugcId)["Task_" .. index .. "_Info"] then warn("UgcData.Task not found for ugcId: " .. ugcId) return end
    return UgcDataHelper.GetData(ugcId)["Task_" .. index .. "_Info"]
end

function UgcDataHelper.GetTaskProgressMax(ugcId: string, index: number): number
    if UgcDataHelper.GetData(ugcId) == nil then warn("UgcData not found for ugcId: " , ugcId) return end
    if not UgcDataHelper.GetData(ugcId)["Task_" .. index .. "_ProgressMax"] then warn("UgcData.Task not found for ugcId: " .. ugcId) return end
    return UgcDataHelper.GetData(ugcId)["Task_" .. index .. "_ProgressMax"]
end

return UgcDataHelper