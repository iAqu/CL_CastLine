-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local AnalyticsService = game:GetService("AnalyticsService")
local Name = Enum.AnalyticsCustomFieldKeys.CustomField01.Name
local Name2 = Enum.AnalyticsCustomFieldKeys.CustomField02.Name
local Name3 = Enum.AnalyticsCustomFieldKeys.CustomField03.Name
local t1 = {
    Boot = true,
    RegisterOpportunity = true,
    AdStarted = true,
    AdComplete = true,
    AdIncomplete = true
}
local t2 = {}

t2.__index = t2

function t2.new(p1) -- line: 27
    -- upvalues: t2 (copy)
    local self = setmetatable({}, t2)

    self._devProductId = tostring(p1.DevProductId)
    self._placementId = tostring(p1.PlacementId)
    self._bucket = tostring(p1.Bucket)
    self._rawConfigValue = ""
    self._productPlacementKey = self._devProductId .. "|" .. self._placementId

    return self
end

function t2:Log(p3, p4) -- line: 37
    -- upvalues: AnalyticsService (copy), Name (copy), Name2 (copy), Name3 (copy), t1 (copy)
    if t1[p4] then
        print(("[RVBillboard/Telemetry] %s | %s | %s | bucket=%s"):format(p3.Name, p4, self._productPlacementKey, self._bucket))

        local LogCustomEvent = AnalyticsService.LogCustomEvent
        local t4 = {
            [Name] = p4,
            [Name2] = self._productPlacementKey,
            [Name3] = self._bucket
        }
        local ok, result = pcall(LogCustomEvent, AnalyticsService, p3, "RVB", nil, t4)

        if not ok then
            warn("[RVBillboard/Telemetry] LogCustomEvent failed — " .. tostring(result))
        end
    end
end

function t2:SetBucket(p6) -- line: 61
    self._bucket = tostring(p6) .. "|" .. self._rawConfigValue
end

function t2:SetPlacementId(p8) -- line: 65
    self._placementId = tostring(p8)
    self._productPlacementKey = self._devProductId .. "|" .. self._placementId
end

function t2:SetDevProductId(p10) -- line: 70
    self._devProductId = tostring(p10)
    self._productPlacementKey = self._devProductId .. "|" .. self._placementId
end

function t2:SetRawConfigValue(p12) -- line: 75
    self._rawConfigValue = tostring(p12)
    self._bucket = tostring(self._bucket:match("^[^|]+") or self._bucket) .. "|" .. self._rawConfigValue
end

return t2
