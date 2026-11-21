local Players = game:GetService("Players")
local ReplicatedFirst = game:GetService("ReplicatedFirst")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local DataStoreService = game:GetService("DataStoreService")
local HttpService = game:GetService("HttpService")
local MarketplaceService = game:GetService("MarketplaceService")
local Knit = require(ReplicatedStorage.Packages.Knit)
local Config = require(ReplicatedStorage.Modules.PaidEggConfig)
local Delivery = require(ReplicatedStorage.Modules.PaidEggDelivery)
local TrainingProgress = require(ReplicatedStorage.Modules.TrainingProgress)
local PurchaseData = require(ReplicatedFirst.Data.PurchaseData)
local FishesData = require(ReplicatedFirst.Data.FishesData)
local PlayerDataService = require(script.Parent.PlayerDataService)
local ItemGrantUtil = require(script.Parent.ItemGrantUtil)
local Policy = require(script.Parent.PaidItemPolicy)
local Persistence = require(script.Parent.PurchasePersistence)

local Service = Knit.CreateService({
	Name = "PaidEggService",
	Client = {
		ResultReady = Knit.CreateSignal(),
		PromptPrepared = Knit.CreateSignal(),
		PurchaseCompleted = Knit.CreateSignal(),
	},
})
local orders = DataStoreService:GetDataStore("PaidEggReceipts_v1")
local random = Random.new()
local promptBusy, receiptBusy = {}, {}
local openPrompts, canceledPrompts, preparing = {}, {}, {}
local staged, watchers = {}, {}
local REOPEN_WINDOW = 3

function Service:IsProduct(productId)
	return Config.FindProduct(productId, PurchaseData) ~= nil
end

local function recipientFor(player)
	local target = Knit.GetService("PurchaseService")._PlayerGifted[player.UserId]
	return if target then Players:GetPlayerByUserId(target) else player
end

function Service:GetAvailability(player)
	local profile = PlayerDataService:GetProfile(player)
	if not profile or not profile:IsActive() then
		return { Allowed = false }
	end
	local recipient = recipientFor(player)
	local recipientProfile = recipient and PlayerDataService:GetProfile(recipient)
	if not recipientProfile or not recipientProfile:IsActive() then
		return { Allowed = false, Message = "Gift recipient is unavailable." }
	end
	for _, purchaseId in ipairs(Config.PurchaseOrder) do
		if not Config.GetPurchase(purchaseId, PurchaseData) then
			return { Allowed = false, Message = "Paid eggs are not configured." }
		end
	end
	local allowed, message, retryable = Policy.CanPurchase(player, recipient)
	return { Allowed = allowed, Message = message, Retryable = retryable }
end

local function matchesSnapshot(intent, maxWeight)
	if intent.Version ~= Config.Version or intent.MaxWeight ~= maxWeight
		or #intent.Pool.Fish ~= #Config.Fish or #intent.Pool.Mutations ~= #Config.Mutations
	then
		return false
	end
	for index, fish in ipairs(Config.Fish) do
		local saved = intent.Pool.Fish[index]
		local data = intent.FishData[fish.Id]
		if saved.Id ~= fish.Id or saved.Chance ~= fish.Chance or saved.Card ~= fish.Card
			or not data or data.DefaultWeight ~= FishesData[fish.Id].DefaultWeight
		then
			return false
		end
	end
	for index, mutation in ipairs(Config.Mutations) do
		local saved = intent.Pool.Mutations[index]
		if saved.Id ~= mutation.Id or saved.Weight ~= mutation.Weight then
			return false
		end
	end
	return true
end

function Service:_prompt(player, purchaseId, forSelf)
	local row, quantity = Config.GetPurchase(purchaseId, PurchaseData)
	if not row then
		return false, "Paid egg is unavailable."
	end
	local recipient = if forSelf then player else recipientFor(player)
	local profile = PlayerDataService:GetProfile(player)
	local recipientProfile = recipient and PlayerDataService:GetProfile(recipient)
	if not profile or not profile:IsActive() or not recipientProfile or not recipientProfile:IsActive() then
		return false, "Player data is unavailable."
	end
	local allowed, policyMessage = Policy.CanPurchase(player, recipient)
	if not allowed then
		return false, policyMessage
	end
	if PlayerDataService:GetProfile(player) ~= profile or not profile:IsActive()
		or PlayerDataService:GetProfile(recipient) ~= recipientProfile or not recipientProfile:IsActive()
	then
		return false, "Player data is unavailable."
	end
	local state = Delivery.Ensure(profile.Data)
	local canceled = canceledPrompts[player]
	local intent = state.Intent
	if openPrompts[player] or (intent and (not canceled or canceled.Profile ~= profile or canceled.Intent ~= intent)) then
		return false, "Your previous paid egg purchase is still processing."
	end

	local maxWeight = Knit.GetService("TrainingService"):GetMaxCatchWeight(recipient)
	local reopening = intent and os.clock() < canceled.Expires and intent.PurchaseId == purchaseId
		and intent.ProductId == row.ProductId and intent.RecipientUserId == recipient.UserId
		and intent.Quantity == quantity and intent.Price == row.Price and matchesSnapshot(intent, maxWeight)
	canceledPrompts[player] = nil
	if not reopening then
		local snapshot = { Fish = {}, Mutations = {} }
		local fishData = {}
		for _, entry in ipairs(Config.Fish) do
			table.insert(snapshot.Fish, table.clone(entry))
			fishData[entry.Id] = { DefaultWeight = FishesData[entry.Id].DefaultWeight }
		end
		for _, entry in ipairs(Config.Mutations) do
			table.insert(snapshot.Mutations, table.clone(entry))
		end
		intent = {
			Token = HttpService:GenerateGUID(false),
			PurchaseId = purchaseId,
			ProductId = row.ProductId,
			RecipientUserId = recipient.UserId,
			Quantity = quantity,
			Price = row.Price,
			MaxWeight = maxWeight,
			Version = Config.Version,
			Pool = snapshot,
			FishData = fishData,
			CreatedAt = os.time(),
		}
		state.Intent = intent
		preparing[player] = intent
		local saved = PlayerDataService:SavePaidEggProfile(player)
		preparing[player] = nil
		if not saved then
			return false, "Could not save the order. Please try again later."
		end
	end
	if PlayerDataService:GetProfile(player) ~= profile or player.Parent ~= Players or state.Intent ~= intent then
		return false
	end
	-- The target and training snapshot are immutable after this point, including when the shop closes.
	self.Client.PromptPrepared:Fire(player, row.ProductId, quantity, recipient == player)
	openPrompts[player] = intent
	MarketplaceService:PromptProductPurchase(player, row.ProductId)
	return true
end

function Service:Prompt(player, purchaseId, forSelf)
	if promptBusy[player] then
		return false, "A purchase is already being prepared."
	end
	promptBusy[player] = true
	local ok, success, message = pcall(self._prompt, self, player, purchaseId, forSelf)
	promptBusy[player] = nil
	preparing[player] = nil
	if not ok then
		warn("PaidEggService: purchase prompt failed: " .. tostring(success))
		return false, "Purchase could not be opened. Your order is awaiting confirmation."
	end
	return success, message
end

function Service:_clearCanceledPrompt(player, profile)
	local canceled = canceledPrompts[player]
	if not canceled or canceled.Profile ~= profile then
		return false
	end
	canceledPrompts[player] = nil
	local state = Delivery.Ensure(profile.Data)
	if state.Intent ~= canceled.Intent then
		return false
	end
	state.Intent = false
	PlayerDataService:MarkPaidEggProfileChanged(profile)
	return true
end

function Service:CancelPrompt(player, productId, purchased)
	local intent = openPrompts[player]
	if not intent or intent.ProductId ~= productId then
		return
	end
	openPrompts[player] = nil
	local profile = PlayerDataService:GetProfile(player)
	if purchased or not profile or not profile:IsActive() or Delivery.Ensure(profile.Data).Intent ~= intent then
		return
	end
	local canceled = { Intent = intent, Profile = profile, Expires = os.clock() + REOPEN_WINDOW }
	canceledPrompts[player] = canceled
	task.delay(REOPEN_WINDOW, function()
		if canceledPrompts[player] == canceled and profile:IsActive() and self:_clearCanceledPrompt(player, profile) then
			Persistence.Request(profile)
		end
	end)
end

function Service:_processReceipt(player, receipt)
	if not player then
		return false
	end
	local profile = PlayerDataService:GetProfile(player)
	if not profile or not profile:IsActive() then
		return false
	end
	local key = tostring(receipt.PlayerId) .. ":" .. tostring(receipt.PurchaseId)
	local order = orders:GetAsync(key)
	local state = Delivery.Ensure(profile.Data)
	if not order then
		local intent = state.Intent
		local canceled = canceledPrompts[player]
		if (canceled and canceled.Intent == intent) or (intent and preparing[player] == intent) then
			return false
		end
		if receipt.ProductPurchaseChannel == Enum.ProductPurchaseChannel.ExperienceDetailsPage then
			return false, "Receipt originated outside the paid egg shop"
		end
		if not intent or intent.ProductId ~= receipt.ProductId then
			return false, "Receipt has no durable matching purchase intent"
		end
		local rewards = Config.Roll(
			intent.Quantity,
			intent.MaxWeight,
			intent.FishData,
			random,
			TrainingProgress.CalculateFishWeight,
			intent.Pool
		)
		for index, reward in ipairs(rewards) do
			reward.InstanceId = key .. ":" .. index
		end
		local candidate = {
			OrderId = key,
			ReceiptId = receipt.PurchaseId,
			PurchaseId = intent.PurchaseId,
			ProductId = receipt.ProductId,
			BuyerUserId = player.UserId,
			SenderName = player.DisplayName,
			RecipientUserId = intent.RecipientUserId,
			IntentToken = intent.Token,
			Price = intent.Price,
			Version = intent.Version,
			MaxWeight = intent.MaxWeight,
			Rewards = rewards,
			CreatedAt = os.time(),
			Enqueued = false,
		}
		order = orders:UpdateAsync(key, function(existing)
			return existing or candidate
		end)
	end
	if not order or order.BuyerUserId ~= player.UserId or order.ProductId ~= receipt.ProductId then
		return false
	end
	if not order.Enqueued then
		if not PlayerDataService:QueuePaidEggDelivery(order.RecipientUserId, order) then
			return false
		end
		self:_notifyRecipient(order)
		order = orders:UpdateAsync(key, function(existing)
			if not existing then
				return nil
			end
			existing.Enqueued = true
			return existing
		end)
		if not order or not order.Enqueued then
			return false
		end
	else
		self:_notifyRecipient(order)
	end
	if PlayerDataService:GetProfile(player) ~= profile or not profile:IsActive() then
		return false
	end
	if not state.Purchases[key] then
		state.Purchases[key] = true
		profile.Data.RobuxSpent += if type(receipt.CurrencySpent) == "number"
			then receipt.CurrencySpent
			else order.Price
	end
	if state.Intent and state.Intent.Token == order.IntentToken then
		if openPrompts[player] == state.Intent then
			openPrompts[player] = nil
		end
		state.Intent = false
	end
	if not PlayerDataService:SavePaidEggProfile(player) then
		return false
	end
	self.Client.PurchaseCompleted:Fire(player, {
		OrderId = key,
		ProductId = order.ProductId,
		Quantity = #order.Rewards,
		IsGift = order.RecipientUserId ~= player.UserId,
	})
	return true
end

function Service:ProcessReceipt(receipt)
	local userId = receipt.PlayerId
	if receiptBusy[userId] then
		return false
	end
	receiptBusy[userId] = true
	local ok, granted, message = pcall(self._processReceipt, self, Players:GetPlayerByUserId(userId), receipt)
	receiptBusy[userId] = nil
	if not ok or (not granted and message) then
		warn("PaidEggService: receipt pending: " .. tostring(if ok then message else granted))
	end
	return ok and granted == true
end

function Service:_notifyRecipient(order)
	local recipient = Players:GetPlayerByUserId(order.RecipientUserId)
	if recipient then
		self:_stage(recipient, nil, order)
	end
end

function Service:_stage(player, updateId, order)
	local profile = PlayerDataService:GetProfile(player)
	if not profile or not profile:IsActive() or order.RecipientUserId ~= player.UserId then
		return
	end
	local state = Delivery.Ensure(profile.Data)
	local pending = staged[player]
	if not pending then
		pending = {}
		staged[player] = pending
	end
	local entry = pending[order.OrderId]
	if entry then
		if updateId then
			entry.Updates[updateId] = true
		end
		return
	end
	local receipt = state.Receipts[order.OrderId]
	if receipt and receipt.Complete then
		if updateId then
			PlayerDataService:ClearPaidEggDelivery(player, updateId)
		end
		return
	end
	-- The caller has either persisted the mailbox write or observed its locked update.
	entry = { Order = order, Result = Delivery.Result(order, profile.Data.IndexDiscoveryLog or {}), Updates = {} }
	if updateId then
		entry.Updates[updateId] = true
	end
	pending[order.OrderId] = entry
	self.Client.ResultReady:Fire(player, entry.Result)
end

function Service:RevealResult(player, orderId)
	local profile = PlayerDataService:GetProfile(player)
	if type(orderId) ~= "string" or not profile or not profile:IsActive() then
		return false
	end
	local pending = staged[player]
	local entry = pending and pending[orderId]
	local receipt = Delivery.Ensure(profile.Data).Receipts[orderId]
	if not entry then
		-- Results created before the presentation change were already delivered.
		return receipt ~= nil and receipt.Complete == true
	end
	if entry.Busy then
		return false
	end
	entry.Busy = true
	local ok, saved, message = pcall(function()
		local complete, _, reason = Delivery.Apply(profile.Data, entry.Order, function(rewards, commit)
			return ItemGrantUtil.GrantPaidOrder(player, profile, rewards, orderId, commit)
		end, entry.Result)
		if not complete then
			return false, reason
		end
		return PlayerDataService:SavePaidEggProfile(player)
	end)
	entry.Busy = false
	if not ok or not saved then
		if not entry.Warned then
			entry.Warned = true
			warn("PaidEggService: delivery pending: " .. tostring(if ok then message or "save pending" else saved))
		end
		return false
	end
	pending[orderId] = nil
	for updateId in pairs(entry.Updates) do
		PlayerDataService:ClearPaidEggDelivery(player, updateId)
	end
	return true
end

function Service.Client:RevealResult(player, orderId)
	return self.Server:RevealResult(player, orderId)
end

function Service.Client:GetAvailability(player)
	return self.Server:GetAvailability(player)
end

function Service.Client:GetPendingResults(player)
	local profile = PlayerDataService:GetProfile(player)
	if not profile then
		return {}
	end
	local results = Delivery.Pending(profile.Data)
	local included = {}
	for _, result in ipairs(results) do
		included[result.OrderId] = true
	end
	for orderId, entry in pairs(staged[player] or {}) do
		if not included[orderId] then
			table.insert(results, entry.Result)
		end
	end
	table.sort(results, function(a, b)
		if a.CreatedAt == b.CreatedAt then
			return a.OrderId < b.OrderId
		end
		return a.CreatedAt < b.CreatedAt
	end)
	return results
end

function Service.Client:AcknowledgeResult(player, orderId)
	local profile = PlayerDataService:GetProfile(player)
	if
		not profile
		or (staged[player] and staged[player][orderId])
		or not Delivery.Acknowledge(profile.Data, orderId)
	then
		return false
	end
	return PlayerDataService:SavePaidEggProfile(player)
end

function Service:KnitStart()
	PlayerDataService:RegisterBeforeProfileRelease(function(player)
		local profile = PlayerDataService:GetProfile(player)
		if profile and profile:IsActive() then
			self:_clearCanceledPrompt(player, profile)
		end
	end)
	local function bind(player)
		if watchers[player] or not PlayerDataService:GetProfile(player) then
			return
		end
		watchers[player] = PlayerDataService:WatchPaidEggDeliveries(player, function(id, order)
			self:_stage(player, id, order)
		end)
	end
	PlayerDataService.ProfileLoaded:Connect(bind)
	for _, player in ipairs(Players:GetPlayers()) do
		bind(player)
	end
	Players.PlayerRemoving:Connect(function(player)
		local profile = PlayerDataService:GetProfile(player)
		if profile and profile:IsActive() then
			self:_clearCanceledPrompt(player, profile)
		end
		openPrompts[player], canceledPrompts[player], preparing[player] = nil, nil, nil
		for _, connection in ipairs(watchers[player] or {}) do
			connection:Disconnect()
		end
		watchers[player], staged[player], promptBusy[player] = nil, nil, nil
	end)
	MarketplaceService.PromptProductPurchaseFinished:Connect(function(userId, productId, purchased)
		local player = Players:GetPlayerByUserId(userId)
		if player then
			self:CancelPrompt(player, productId, purchased)
		end
	end)
end

return Service
