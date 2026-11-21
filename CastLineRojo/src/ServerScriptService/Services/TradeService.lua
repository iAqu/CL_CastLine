local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

local Knit = require(ReplicatedStorage.Packages.Knit)
local Constants = require(ReplicatedStorage.Modules.Constants)
local PlayerDataService = require(ServerScriptService.Services.PlayerDataService)

local TradeService = Knit.CreateService({
	Name = "TradeService",
	Client = {
		TradeRequestReceived = Knit.CreateSignal(),
		TradeRequestExpired = Knit.CreateSignal(),
		RequestBeIgnored = Knit.CreateSignal(),
		AcceptTradeRequest = Knit.CreateSignal(),
		IgnoreTradeRequest = Knit.CreateSignal(),
		TradeBegan = Knit.CreateSignal(),
		TradeDeclined = Knit.CreateSignal(),
		TradeInputDiamond = Knit.CreateSignal(),
		TradeAccept = Knit.CreateSignal(),
		TradeUnaccept = Knit.CreateSignal(),
		TradeCompleted = Knit.CreateSignal(),
		TradeConfirmCountDown = Knit.CreateSignal(),
		TradeFail = Knit.CreateSignal(),
	},
})

local requests = {}
local trades = {}
local loginTimes = {}

local function getPlayer(userId)
	if type(userId) == "number" and userId % 1 == 0 then
		return Players:GetPlayerByUserId(userId)
	end
	return nil
end

local function getTradeProfile(player)
	local profile = PlayerDataService:GetProfile(player)
	if profile and profile:IsActive() and profile.Data.Settings[Constants.SETTINGS_ID.TRADE] == true then
		return profile
	end
	return nil
end

local function getPartner(trade, player)
	return if player == trade.first then trade.second else trade.first
end

local function removeRequest(target, sender)
	local entry = requests[target]
	if entry and entry.sender == sender then
		requests[target] = nil
		return true
	end
	return false
end

function TradeService.Client:SendTradeRequest(player, targetPlayerId)
	return self.Server:SendTradeRequest(player, targetPlayerId)
end

function TradeService:SendTradeRequest(player, targetPlayerId)
	local target = getPlayer(targetPlayerId)
	if not target or target == player or not getTradeProfile(player) or not getTradeProfile(target) then
		return {Success = false, ResultText = "Trading is unavailable for this player."}
	end
	if trades[player] or trades[target] or requests[target] then
		return {Success = false, ResultText = Constants.NOTIFICATION.TRADE_REQUEST_FAIL_IN_OTHER_REQUEST}
	end
	local now = os.clock()
	local waitTime = Constants.TRADE_TIME.LOGIN_WAIT_TIME
	if now - (loginTimes[player] or now) < waitTime or now - (loginTimes[target] or now) < waitTime then
		return {Success = false, ResultText = Constants.NOTIFICATION.TRADE_REQUEST_FAIL_WAIT}
	end
	local entry = {sender = player}
	requests[target] = entry
	self.Client.TradeRequestReceived:Fire(target, player)
	task.delay(Constants.TRADE_TIME.REQUEST_COOLDOWN, function()
		if requests[target] == entry then
			requests[target] = nil
			self.Client.TradeRequestExpired:Fire(target, player)
		end
	end)
	return {Success = true, ResultText = Constants.NOTIFICATION.TRADE_REQUEST_SEND}
end

local function acceptRequest(player, senderId)
	local sender = getPlayer(senderId)
	if not sender or trades[player] or trades[sender] or not removeRequest(player, sender) then
		return
	end
	if not getTradeProfile(player) or not getTradeProfile(sender) then
		return
	end
	local trade = {first = sender, second = player, offers = {}, accepted = {}, revision = 0}
	trades[player], trades[sender] = trade, trade
	TradeService.Client.TradeBegan:Fire(player, sender.UserId)
	TradeService.Client.TradeBegan:Fire(sender, player.UserId)
end

local function stopCountdown(trade)
	if trade.countdown then
		task.cancel(trade.countdown)
		trade.countdown = nil
	end
end

local function closeTrade(trade)
	stopCountdown(trade)
	trades[trade.first], trades[trade.second] = nil, nil
end

local function editOffer(player, count)
	local trade = trades[player]
	if not trade or trade.committing or type(count) ~= "number" or count % 1 ~= 0 or count < 0 then
		return
	end
	local profile = getTradeProfile(player)
	if not profile or count > profile.Data.Diamonds or count == (trade.offers[player] or 0) then
		return
	end
	local partner = getPartner(trade, player)
	trade.offers[player] = count
	trade.revision += 1
	if next(trade.accepted) then
		stopCountdown(trade)
		table.clear(trade.accepted)
		TradeService.Client.TradeUnaccept:Fire(player, true)
		TradeService.Client.TradeUnaccept:Fire(partner, true)
	end
	TradeService.Client.TradeInputDiamond:Fire(player, count, trade.revision, true)
	TradeService.Client.TradeInputDiamond:Fire(partner, count, trade.revision)
end

local function commitTrade(trade)
	local first, second = trade.first, trade.second
	trade.committing = true
	TradeService.Client.TradeCompleted:Fire(first, true)
	TradeService.Client.TradeCompleted:Fire(second, true)
	task.wait(3)
	trade.countdown = nil
	local firstProfile, secondProfile = getTradeProfile(first), getTradeProfile(second)
	local firstOffer, secondOffer = trade.offers[first] or 0, trade.offers[second] or 0
	closeTrade(trade)
	local failure
	if not firstProfile or not secondProfile then
		failure = Constants.NOTIFICATION.TRADE_FAIL_PLAYER_NOT_FOUND
	elseif firstOffer > firstProfile.Data.Diamonds or secondOffer > secondProfile.Data.Diamonds then
		failure = Constants.NOTIFICATION.TRADE_FAIL_NO_ENOUGH_DIAMOND
	end
	if failure then
		TradeService.Client.TradeFail:Fire(first, failure)
		TradeService.Client.TradeFail:Fire(second, failure)
		return
	end
	PlayerDataService:AdjustDiamonds(first, secondOffer - firstOffer)
	PlayerDataService:AdjustDiamonds(second, firstOffer - secondOffer)
	TradeService.Client.TradeCompleted:Fire(first, false)
	TradeService.Client.TradeCompleted:Fire(second, false)
end

local function acceptTrade(player, revision)
	local trade = trades[player]
	if not trade or trade.accepted[player] or not getTradeProfile(player) then
		return
	end
	local partner = getPartner(trade, player)
	if not getTradeProfile(partner) or revision ~= trade.revision then
		TradeService.Client.TradeUnaccept:Fire(player, true, trade.accepted[partner] == true)
		return
	end
	trade.accepted[player] = true
	TradeService.Client.TradeAccept:Fire(partner)
	if trade.accepted[partner] then
		trade.countdown = task.delay(Constants.TRADE_TIME.CONFIRM_COOLDOWN, commitTrade, trade)
		TradeService.Client.TradeConfirmCountDown:Fire(player)
		TradeService.Client.TradeConfirmCountDown:Fire(partner)
	end
end

local function unacceptTrade(player)
	local trade = trades[player]
	if not trade or trade.committing or not trade.accepted[player] then
		return
	end
	trade.accepted[player] = nil
	stopCountdown(trade)
	TradeService.Client.TradeUnaccept:Fire(getPartner(trade, player))
end

local function declineTrade(player)
	local trade = trades[player]
	if trade then
		closeTrade(trade)
		TradeService.Client.TradeDeclined:Fire(getPartner(trade, player), player.UserId)
	end
end

function TradeService:KnitInit()
	local function joined(player)
		loginTimes[player] = os.clock()
	end
	Players.PlayerAdded:Connect(joined)
	for _, player in Players:GetPlayers() do
		joined(player)
	end
	Players.PlayerRemoving:Connect(function(player)
		declineTrade(player)
		requests[player], loginTimes[player] = nil, nil
		for target, entry in requests do
			if entry.sender == player then
				requests[target] = nil
				self.Client.TradeRequestExpired:Fire(target, player)
			end
		end
	end)
end

function TradeService:KnitStart()
	self.Client.AcceptTradeRequest:Connect(acceptRequest)
	self.Client.IgnoreTradeRequest:Connect(function(player, senderId)
		local sender = getPlayer(senderId)
		if sender and removeRequest(player, sender) then
			self.Client.RequestBeIgnored:Fire(sender, player)
		end
	end)
	self.Client.TradeDeclined:Connect(declineTrade)
	self.Client.TradeInputDiamond:Connect(editOffer)
	self.Client.TradeAccept:Connect(acceptTrade)
	self.Client.TradeUnaccept:Connect(unacceptTrade)
end

return TradeService
