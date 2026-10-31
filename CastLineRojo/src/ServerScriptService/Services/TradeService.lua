local ContentProvider = game:GetService("ContentProvider")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ReplicatedFirst = game:GetService("ReplicatedFirst")
local ServerScriptService = game:GetService("ServerScriptService")

local PlayerDataService = require(ServerScriptService.Services.PlayerDataService)
local LogHelper = require(ReplicatedStorage.Modules.LogHelper)
local Knit = require(ReplicatedStorage.Packages.Knit)
local Constants = require(ReplicatedStorage.Modules.Constants)
local MathUtil = require(ReplicatedStorage.Modules.MathUtil)

local TradeAccepted = {}    -- [playerId] = {targetPlayerId, ...}
local TradeDiamonds = {}        -- [playerId] = diamonds
local TradeRequests = {}    -- [playerId] = {targetPlayerId, ...}
local Trading = {}     -- {[playerId] = [targetPlayerId]}
local CountDownTask = {}   -- [playerId] = task
local PlayersLoginTime = {}     -- [playerId] = loginTime

local TradeService = Knit.CreateService {
    Name = "TradeService",
    Client = {
        TradeRequestReceived = Knit.CreateSignal(),
        
        AcceptTradeRequest = Knit.CreateSignal(),
        TradeBegan = Knit.CreateSignal(),
        TradeDeclined = Knit.CreateSignal(),
        TradeInputDiamond = Knit.CreateSignal(),
        TradeAccept = Knit.CreateSignal(),
        TradeUnaccept = Knit.CreateSignal(),
        TradeCompleted = Knit.CreateSignal(),
        TradeConfirmCountDown = Knit.CreateSignal(),
        TradeFail = Knit.CreateSignal(),
        -- client to server
        IgnoreTradeRequest = Knit.CreateSignal(),

        -- server to client
        RequestBeIgnored = Knit.CreateSignal(),
        TradeRequestExpired = Knit.CreateSignal(),
    },
}

-- function TradeService.IsTrading(player: Player)
local function IsTrading(player: Player)
    return Trading[player.UserId]
end

-- function TradeService:IsOnCooldown(playerId: number, targetPlayerId: number)
local function IsOnCooldown(playerId: number, targetPlayerId: number)
    local requests = TradeRequests[playerId]
    if not requests then return end
    return table.find(requests, targetPlayerId)
end

-- player is being requested by other players
local function IsBeingRequest(playerId: number): boolean
    for _, requests in pairs(TradeRequests) do
        if table.find(requests, playerId) then return true end
    end
    return false
end

local function HasSentRequest(accepterId: number, senderId: number)
    local requestTable = TradeRequests[senderId]
    if not requestTable then return end
    if table.find(requestTable, accepterId) then return true end
    return false
end

function TradeService.Client:SendTradeRequest(player: Player, targetPlayerId: number): {Success: boolean, ResultText: string}
    return self.Server:SendTradeRequest(player, targetPlayerId)
end

function TradeService:SendTradeRequest(player: Player, targetPlayerId: number): boolean
    local targetPlayer = Players:GetPlayerByUserId(targetPlayerId)
    if not targetPlayer then return false end

    local targetPlayerData = PlayerDataService:GetAllData(targetPlayer)
    if not targetPlayerData then return false end

    if IsOnCooldown(player.UserId, targetPlayerId) then
        return {Success = false, ResultText = Constants.NOTIFICATION.TRADE_REQUEST_FAIL_COOLDOWN}
    end

    if not IsOnCooldown(player.UserId, targetPlayerId) and IsBeingRequest(targetPlayerId) then
        return {Success = false, ResultText = Constants.NOTIFICATION.TRADE_REQUEST_FAIL_IN_OTHER_REQUEST}
    end

    if os.time() - PlayersLoginTime[player.UserId] < Constants.TRADE_TIME.LOGIN_WAIT_TIME then
        return {Success = false, ResultText = Constants.NOTIFICATION.TRADE_REQUEST_FAIL_WAIT_PLAYER:gsub("#NAME", "You"):gsub("#TIME", os.time() - PlayersLoginTime[player.UserId])}
    end

    if os.time() - PlayersLoginTime[targetPlayerId] < Constants.TRADE_TIME.LOGIN_WAIT_TIME then
        return {Success = false, ResultText = Constants.NOTIFICATION.TRADE_REQUEST_FAIL_WAIT_PLAYER:gsub("#NAME", targetPlayer.DisplayName):gsub("#TIME", os.time() - PlayersLoginTime[targetPlayerId])}
    end

    -- if targetPlayerData.Rebirths < 3 then
    --     return {Success = false, ResultText = Constants.NOTIFICATION.TRADE_TARGET_NOT_ENOUGH_REBIRTH:gsub("#NAME", targetPlayer.DisplayName)}
    -- end

    local playerTable = TradeRequests[player.UserId]
    if not playerTable then
        TradeRequests[player.UserId] = {}
        playerTable = TradeRequests[player.UserId]
    end

    self.Client.TradeRequestReceived:Fire(targetPlayer, player)
    table.insert(playerTable, targetPlayerId)
    task.delay(Constants.TRADE_TIME.REQUEST_COOLDOWN, function()
        local index = table.find(playerTable, targetPlayerId)
        if index then
            table.remove(playerTable, index)
            self.Client.TradeRequestExpired:Fire(targetPlayer, player)
        end
        -- table.remove(playerTable, table.find(playerTable, targetPlayerId))
    end)

    return {Success = true, ResultText = Constants.NOTIFICATION.TRADE_REQUEST_SEND}
end

local function AcceptTradeRequest(player: Player, targetId: number)
    local target = Players:GetPlayerByUserId(targetId)
    if not target then return false end

    if IsTrading(player) or IsTrading(target) then return false end
    if not HasSentRequest(player.UserId, targetId) then return false end

    -- clear the requests to other players
    local playerTable = TradeRequests[player.UserId]
    if playerTable then
        for _, targetPlayerId in ipairs(playerTable) do
            local targetPlayer = Players:GetPlayerByUserId(targetPlayerId)
            if targetPlayer then
                TradeService.Client.TradeRequestExpired:Fire(targetPlayer, player)
            end
        end
        TradeRequests[player.UserId] = nil
    end

    local targetTable = TradeRequests[targetId]
    if targetTable then
        for _, targetPlayerId in ipairs(targetTable) do
            local targetPlayer = Players:GetPlayerByUserId(targetPlayerId)
            if targetPlayer then
                TradeService.Client.TradeRequestExpired:Fire(targetPlayer, target)
            end
        end
        TradeRequests[targetId] = nil
    end

    Trading[player.UserId] = targetId
    Trading[targetId] = player.UserId

    LogHelper.Print("Trade began between " .. player.Name .. " and " .. target.Name)
    TradeService.Client.TradeBegan:Fire(player, targetId)
    TradeService.Client.TradeBegan:Fire(target, player.UserId)
end

local function IgnoreTradeRequest(player: Player, requestPlayerId: number)
    local requestPlayer = Players:GetPlayerByUserId(requestPlayerId)
    if not requestPlayer then return end

    local requestTable = TradeRequests[requestPlayerId]
    if not requestTable then return end

    local index = table.find(requestTable, player.UserId)
    if index then
        table.remove(requestTable, index)
    end
    TradeService.Client.RequestBeIgnored:Fire(requestPlayer, player)
end

local function ResetTradeState(player: Player)
    TradeAccepted[player.UserId] = nil
    TradeRequests[player.UserId] = nil
    Trading[player.UserId] = nil
    TradeDiamonds[player.UserId] = nil
    CountDownTask[player.UserId] = nil
end

local function TradeDeclined(player: Player)
    LogHelper.Print("Trade declined by " .. player.Name)
    local targetId = IsTrading(player)

    ResetTradeState(player)

    if not targetId then return end

    local target = Players:GetPlayerByUserId(targetId)
    if not target then return end

    ResetTradeState(target)

    TradeService.Client.TradeDeclined:Fire(target, player.UserId)
end

local function TradeInputDiamond(player: Player, count: number)
    if MathUtil.IsNaN(count) or MathUtil.IsInfinity(count) or type(count) ~= "number" or not MathUtil.IsInteger(count) then return end
    
    local profile = PlayerDataService:GetProfile(player)
    if not profile then return end

    local targetId = Trading[player.UserId]
    if not targetId then return end

    local target = Players:GetPlayerByUserId(targetId)
    if not target then return end

    local diamonds = profile.Data.Diamonds
    if diamonds < count then return end

    TradeDiamonds[player.UserId] = count
    TradeService.Client.TradeInputDiamond:Fire(target, count)
end

local function TradeFail(player: Player, target: Player, reason: string)
    TradeService.Client.TradeFail:Fire(player, reason)
    TradeService.Client.TradeFail:Fire(target, reason)
    ResetTradeState(player)
    ResetTradeState(target)
end

local function CompleteTrade(player: Player, target: Player)
    local playerProfile = PlayerDataService:GetProfile(player)
    local targetProfile = PlayerDataService:GetProfile(target)
    if not playerProfile or not targetProfile then TradeFail(player, target, Constants.NOTIFICATION.TRADE_FAIL_PLAYER_NOT_FOUND) return end

    -- 先锁定双方状态，防止交易过程中退出
    local isPlayerConnected = true
    local isTargetConnected = true

    -- 监听玩家断开连接
    local playerConnection = player.AncestryChanged:Connect(function()
        isPlayerConnected = false
    end)
    local targetConnection = target.AncestryChanged:Connect(function()
        isTargetConnected = false
    end)

    -- 通知客户端交易正在完成中
    TradeService.Client.TradeCompleted:Fire(player, true) -- true 表示等待确认中
    TradeService.Client.TradeCompleted:Fire(target, true)

    -- 等待3秒确认
    task.wait(3)

    -- 清理连接监听
    playerConnection:Disconnect()
    targetConnection:Disconnect()

     -- 如果有玩家断开连接，取消交易
     if not isPlayerConnected or not isTargetConnected then
        TradeFail(player, target, Constants.NOTIFICATION.TRADE_FAIL_PLAYER_DISCONNECTED)
        return
    end

    -- 重新获取配置文件确保数据最新
    playerProfile = PlayerDataService:GetProfile(player)
    targetProfile = PlayerDataService:GetProfile(target)
    if not playerProfile or not targetProfile then
        TradeFail(player, target, Constants.NOTIFICATION.TRADE_FAIL_PLAYER_NOT_FOUND) 
        return
    end

    -- 检查交易双方是否还在交易
    if Trading[player.UserId] ~= target.UserId or Trading[target.UserId] ~= player.UserId then
        TradeFail(player, target, Constants.NOTIFICATION.TRADE_FAIL_PLAYER_DISCONNECTED)
        return
    end

    local playerTradeDiamond = TradeDiamonds[player.UserId] or 0
    local targetTradeDiamond = TradeDiamonds[target.UserId] or 0
    if playerTradeDiamond > playerProfile.Data.Diamonds or targetTradeDiamond > targetProfile.Data.Diamonds then
        TradeFail(player, target, Constants.NOTIFICATION.TRADE_FAIL_NO_ENOUGH_DIAMOND)
        return
    end

    if playerTradeDiamond < 0 or targetTradeDiamond < 0 then
        TradeFail(player, target, Constants.NOTIFICATION.TRADE_FAIL_INVALID_DIAMOND)
        return
    end

    PlayerDataService:AdjustDiamonds(player, targetTradeDiamond - playerTradeDiamond)
    PlayerDataService:AdjustDiamonds(target, playerTradeDiamond - targetTradeDiamond)

    ResetTradeState(player)
    ResetTradeState(target)

	TradeService.Client.TradeCompleted:Fire(player, false)
	TradeService.Client.TradeCompleted:Fire(target, false)
end

local function TradeConfirmCountDown(player: Player, target: Player)
    TradeService.Client.TradeConfirmCountDown:Fire(player)
    TradeService.Client.TradeConfirmCountDown:Fire(target)
    local task = task.delay(Constants.TRADE_TIME.CONFIRM_COOLDOWN, function()
        if TradeAccepted[player.UserId] and TradeAccepted[target.UserId] then
            CompleteTrade(player, target)
        end
    end)
    CountDownTask[player.UserId] = task
    CountDownTask[target.UserId] = task
end

local function TradeAccept(player: Player)
	local targetID = IsTrading(player)
	if not targetID then return end
	local target = Players:GetPlayerByUserId(targetID)
	if not target then return end
	
	TradeAccepted[player.UserId] = true
	local targetAcceptance = TradeAccepted[targetID]
	if targetAcceptance and targetAcceptance == true then
		-- CompleteTrade(player, target)
        TradeConfirmCountDown(player, target)
	end
	TradeService.Client.TradeAccept:Fire(target)
end

local function TradeUnaccept(player: Player)
	local targetID = IsTrading(player)
	if not targetID then return end
	local target = Players:GetPlayerByUserId(targetID)
	if not target then return end
	
	local acceptance = TradeAccepted[player.UserId]
	if acceptance then
		TradeAccepted[player.UserId] = nil
	end

    if CountDownTask[player.UserId] then
        task.cancel(CountDownTask[player.UserId])
        CountDownTask[player.UserId] = nil
    end
    if CountDownTask[target.UserId] then
        task.cancel(CountDownTask[target.UserId])
        CountDownTask[target.UserId] = nil
    end
	
	TradeService.Client.TradeUnaccept:Fire(target)
end


function TradeService:KnitInit()
    Players.PlayerAdded:Connect(function(player: Player)
        PlayersLoginTime[player.UserId] = os.time()
    end)

    Players.PlayerRemoving:Connect(function(player: Player)
        TradeDeclined(player)
        ResetTradeState(player)
        PlayersLoginTime[player.UserId] = nil
    end)
end

function TradeService:KnitStart()
    self.Client.AcceptTradeRequest:Connect(AcceptTradeRequest)
    self.Client.IgnoreTradeRequest:Connect(IgnoreTradeRequest)
    -- self.Client.CancelTradeRequest:Connect(CancelTradeRequest)
    self.Client.TradeDeclined:Connect(TradeDeclined)
    self.Client.TradeInputDiamond:Connect(TradeInputDiamond)
    self.Client.TradeAccept:Connect(TradeAccept)
    self.Client.TradeUnaccept:Connect(TradeUnaccept)
end

return TradeService