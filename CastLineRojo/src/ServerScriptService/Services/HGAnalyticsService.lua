local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ReplicatedFirst = game:GetService("ReplicatedFirst")
local ServerScriptService = game:GetService("ServerScriptService")
local Players = game:GetService("Players")
local AnalyticsService = game:GetService("AnalyticsService")

local Knit = require(ReplicatedStorage.Packages.Knit)
local PurchaseDataHelper = require(ReplicatedFirst.DataHelpers.PurchaseDataHelper)
local LogHelper = require(ReplicatedStorage.Modules.LogHelper)
local AreasDataHelper = require(ReplicatedFirst.DataHelpers.AreasDataHelper)

local PAY_PLAYER_TYPES = {
   WHALE = "Whale",
   DOLPHIN_1 = "Dolphin_1",
   DOLPHIN_2 = "Dolphin_2",
   MINNOW = "Minnow",
   F2P = "F2P",
}

local WHALE_PURCHASE_FLOW = {
}

local DOLPHIN_1_PURCHASE_FLOW = {
    [1] = {"LimitedStarterPack"},
    [2] = {"LimitedAdvancedPack"},
}

local DOLPHIN_2_PURCHASE_FLOW = {
}

local MINNOW_PURCHASE_FLOW = {
    [1] = {"LimitedStarterPack"},
}

local F2P_PURCHASE_FLOW = {
}

local HGAnalyticsService = Knit.CreateService {
    Name = "HGAnalyticsService",
    Client = {
    },
}

local function logPurchaseFunnel (player: Player, payPlayerType: string, stepNumber: number, stepName: string)
    local success, result = pcall(function()
        AnalyticsService:LogFunnelStepEvent(player, "PurchaseFlow_" .. payPlayerType, "", stepNumber, stepName)
    end)
    if not success then warn(result) end
end

function HGAnalyticsService:LogPurchase(player: Player, purchaseId: string)
    local purchaseType = PurchaseDataHelper.GetTypeByPurchaseId(purchaseId)
    if not purchaseType then warn("Purchase type not found for purchaseId: " .. purchaseId) return end
    local stepName = purchaseType .. ":" .. purchaseId

    -- Whale
    for stepNumber, purchaseIds in pairs(WHALE_PURCHASE_FLOW) do
        if table.find(purchaseIds, purchaseId) then
            logPurchaseFunnel(player, PAY_PLAYER_TYPES.WHALE, stepNumber, stepName)
            LogHelper.Print("Whale purchase flow step: " .. stepNumber .. " - " .. stepName)
        end
    end

    -- Dolphin 1
    for stepNumber, purchaseIds in pairs(DOLPHIN_1_PURCHASE_FLOW) do
        if table.find(purchaseIds, purchaseId) then
            logPurchaseFunnel(player, PAY_PLAYER_TYPES.DOLPHIN_1, stepNumber, stepName)
            LogHelper.Print("Dolphin 1 purchase flow step: " .. stepNumber .. " - " .. stepName)
        end
    end

    -- Dolphin 2
    for stepNumber, purchaseIds in pairs(DOLPHIN_2_PURCHASE_FLOW) do
        if table.find(purchaseIds, purchaseId) then
            logPurchaseFunnel(player, PAY_PLAYER_TYPES.DOLPHIN_2, stepNumber, stepName)
            LogHelper.Print("Dolphin 2 purchase flow step: " .. stepNumber .. " - " .. stepName)
        end
    end

    -- Minnow
    for stepNumber, purchaseIds in pairs(MINNOW_PURCHASE_FLOW) do
        if table.find(purchaseIds, purchaseId) then
            logPurchaseFunnel(player, PAY_PLAYER_TYPES.MINNOW, stepNumber, stepName)
            LogHelper.Print("Minnow purchase flow step: " .. stepNumber .. " - " .. stepName)
        end
    end

    -- F2P
    for stepNumber, purchaseIds in pairs(F2P_PURCHASE_FLOW) do
        if table.find(purchaseIds, purchaseId) then
            logPurchaseFunnel(player, PAY_PLAYER_TYPES.F2P, stepNumber, stepName)
            LogHelper.Print("F2P purchase flow step: " .. stepNumber .. " - " .. stepName)
        end
    end
end

function HGAnalyticsService:LogWorldProgress(player: Player, areaId: string)
    local areaName = AreasDataHelper.GetName(areaId)
    local areaIndex = AreasDataHelper.GetIndex(areaId)

    if not areaName then warn("Area name not found for areaId: " .. areaId) return end
    if not areaIndex then warn("Area index not found for areaId: " .. areaId) return end

    local success, result = pcall(function()
        AnalyticsService:LogFunnelStepEvent(player, "World Progress", "", areaIndex, areaName)
        LogHelper.Print("World progress: " .. areaIndex .. " - " .. areaName)
    end)
    if not success then warn(result) end
end

function HGAnalyticsService:KnitInit()
end

function HGAnalyticsService:KnitStart()
end

return HGAnalyticsService