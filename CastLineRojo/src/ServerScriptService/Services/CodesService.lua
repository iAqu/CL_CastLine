local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ReplicatedFirst = game:GetService("ReplicatedFirst")
local ServerScriptService = game:GetService("ServerScriptService")
local DataStoreService = game:GetService("DataStoreService")

local PlayerDataService = require(ServerScriptService.Services.PlayerDataService)
local CodesDataHelper = require(ReplicatedFirst.DataHelpers.CodesDataHelper)
local Knit = require(ReplicatedStorage.Packages.Knit)
local LogHelper = require(ReplicatedStorage.Modules.LogHelper)
local PurchaseDataHelper = require(ReplicatedFirst.DataHelpers.PurchaseDataHelper)
local Constants = require(ReplicatedStorage.Modules.Constants)
local PotionFeatureHelper = require(ReplicatedStorage.Modules.PotionFeatureHelper)

export type RedeemResult = {
    isSuccess: boolean,
    resultText: string,
}

type CodeConfig = {
    Type: string,             -- 类型
    ItemId: string,           -- 物品ID
    Amount: number,           -- 数量
    Limited: number,      -- 剩余次数，-1表示无限次
    RarityIndex: number,  -- 稀有度
}

-- local DataStore_YTCodes_Redeem_Log = DataStoreService:GetDataStore("YTCodes_Redeem_Log")
-- local DataStore_Codes = DataStoreService:GetDataStore("Codes")
local DataStore_Game_Operation = DataStoreService:GetDataStore("Game_Operation")

local function isValidCodeConfig(code: unknown): boolean
    return typeof(code) == "table"
        and typeof(code.Type) == "string"
        and (code.Type == "Wins" or code.Type == "Fruit" or code.Type == "Diamonds" or code.Type == "Potion" or code.Type == "GamePass")
        and typeof(code.ItemId) == "string"
        and typeof(code.Amount) == "number"
        and code.Amount == code.Amount
        and code.Amount ~= math.huge
        and code.Amount ~= -math.huge
        and code.Amount >= 0
        and typeof(code.Limited) == "number"
        and code.Limited == math.floor(code.Limited)
        and code.Limited >= -1
end

local function getDefaultCodeConfig(codeId: string): CodeConfig
    return {
        Type = CodesDataHelper.GetType(codeId),
        ItemId = CodesDataHelper.GetItemId(codeId),
        Amount = CodesDataHelper.GetCount(codeId),
        Limited = CodesDataHelper.GetLimited(codeId),
        RarityIndex = CodesDataHelper.GetRarityIndex(codeId),
    }
end

local CodesService = Knit.CreateService {
    Name = "CodesService",
    Client = {
        -- Redeem = Knit.CreateSignal(),
    },
    _RedeemingPlayers = {} :: {[Player]: boolean},
}

function CodesService.Client:RedeemItem(player: Player, codeId: string) : RedeemResult
    return self.Server:RedeemItem(player, codeId)
end

function CodesService:RedeemItem(player: Player, codeId: string) : RedeemResult
	if not PotionFeatureHelper.IsAcquisitionEnabled() then
		return {isSuccess = false, resultText = PotionFeatureHelper.ACQUISITION_DISABLED_MESSAGE}
	end
	if typeof(codeId) ~= "string" then
		return {isSuccess = false, resultText = Constants.NOTIFICATION.CODE_INVALID}
	end
	local profile = PlayerDataService:GetProfile(player)
    if not profile then return {isSuccess = false, resultText = "No profile found!"} end

    codeId = codeId:upper()
    LogHelper.Print("RedeemItem", codeId)

    if self._RedeemingPlayers[player] then
        return {isSuccess = false, resultText = "Code redemption is already in progress"}
    end
    if typeof(profile.Data.RedeemedCodesHistory) ~= "table" then
        profile.Data.RedeemedCodesHistory = {}
    end
    if table.find(profile.Data.RedeemedCodesHistory, codeId) then
        return {isSuccess = false, resultText = Constants.NOTIFICATION.CODE_INVALID_ALREADY_REDEEMED}
    end

    self._RedeemingPlayers[player] = true
    local claimedCode: CodeConfig? = nil
    local rejection = "invalid"
    local updated, updateError = pcall(function()
        DataStore_Game_Operation:UpdateAsync("Codes", function(codes)
            if typeof(codes) ~= "table" then
                rejection = "invalid"
                return nil
            end

            local storedCode = codes[codeId]
            if not isValidCodeConfig(storedCode) then
                rejection = "invalid"
                return nil
            end
            if storedCode.Limited ~= -1 and storedCode.Limited <= 0 then
                rejection = "limit"
                return nil
            end

            claimedCode = table.clone(storedCode)
            if storedCode.Limited == -1 then
                return codes
            end

            local updatedCodes = table.clone(codes)
            local updatedCode = table.clone(storedCode)
            updatedCode.Limited -= 1
            updatedCodes[codeId] = updatedCode
            return updatedCodes
        end)
    end)
    self._RedeemingPlayers[player] = nil

    if not updated then
        warn("Failed to update code inventory", updateError)
        return {isSuccess = false, resultText = Constants.NOTIFICATION.CODE_INVALID}
    end
    if not claimedCode then
        if rejection == "limit" then
            return {isSuccess = false, resultText = Constants.NOTIFICATION.CODE_INVALID_LIMIT}
        end
        return {isSuccess = false, resultText = Constants.NOTIFICATION.CODE_INVALID}
    end

    table.insert(profile.Data.RedeemedCodesHistory, codeId)

    local codeType = claimedCode.Type
    local itemId = claimedCode.ItemId
    local itemCount = claimedCode.Amount
    if codeType == "Wins" or codeType == "Fruit" then
        PlayerDataService:AdjustWins(player, itemCount)
        return {isSuccess = true, resultText = Constants.NOTIFICATION.GOT_WINS:gsub("#NUM", itemCount)}

    elseif codeType == "Diamonds" then
        PlayerDataService:AdjustDiamonds(player, itemCount)
        return {isSuccess = true, resultText = Constants.NOTIFICATION.GOT_DIAMOND:gsub("#NUM", itemCount)}

    elseif codeType == "Potion" then
        local PotionService = Knit.GetService("PotionService")
        PotionService:AdjustPotionCount(player, itemId, itemCount)
        local potionName = PurchaseDataHelper.GetName(itemId)
        return {isSuccess = true, resultText = Constants.NOTIFICATION.GOT_POTION_NUM:gsub("#NUM", itemCount):gsub("#POTION", potionName)}

    elseif codeType == "GamePass" then
        Knit.GetService("GamePassService"):GiveGamePass(player, itemId)
        return {isSuccess = true, resultText = Constants.NOTIFICATION.GOT_GAMEPASS:gsub("#NAME", PurchaseDataHelper.GetName(itemId))}
    end

    return {isSuccess = false, resultText = Constants.NOTIFICATION.CODE_INVALID}
end

local function exportDefaultToDataStore()
    local success, updateError = pcall(function()
        DataStore_Game_Operation:UpdateAsync("Codes", function(codes)
            local updatedCodes = if typeof(codes) == "table" then table.clone(codes) else {}
            for codeId in pairs(CodesDataHelper.GetAllData()) do
                local storedCode = updatedCodes[codeId]
                if typeof(storedCode) ~= "table" or storedCode.Limited == -1 then
                    updatedCodes[codeId] = getDefaultCodeConfig(codeId)
                end
            end
            return updatedCodes
        end)
    end)
    if not success then
        warn("Failed to initialize codes", updateError)
    end
end

function CodesService:KnitInit()
end

function CodesService:KnitStart()
    exportDefaultToDataStore()
end

return CodesService
