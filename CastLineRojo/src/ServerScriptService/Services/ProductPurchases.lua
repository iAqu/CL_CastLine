local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local DataStoreService = game:GetService("DataStoreService")
local MarketplaceService = game:GetService("MarketplaceService")

local Knit = require(ReplicatedStorage.Packages.Knit)
local Data = require(ServerScriptService.Services.PlayerDataService)
local Persistence = require(ServerScriptService.Services.PurchasePersistence)
local Checkout = require(ServerScriptService.Services.PurchaseCheckout)
local PurchaseDataHelper = require(game:GetService("ReplicatedFirst").DataHelpers.PurchaseDataHelper)

local Products = {}
local history = DataStoreService:GetDataStore("PurchaseHistory")
local deliveryKind = "PaidProductV1"
local checkoutKind = "Product"
local revisionTag = "ProductPurchaseRevision"
local busy = {}
local prompts = {}
local preparing = {}
local canceledPrompts = {}
local REOPEN_WINDOW = 3
local RECEIPT_PROFILE_WAIT = 12
local RECEIPT_QUEUE_WAIT = 25
local RECEIPT_SAVE_WAIT = 20
local watches = {}
local notified = {}

local function activeProfile(player)
	local profile = player and Data:GetProfile(player)
	return if profile and profile:IsActive() then profile else nil
end

local function markChanged(profile)
	local state = profile.Data.ProductPurchases
	state.Revision += 1
	profile:SetMetaTag(revisionTag, state.Revision)
end

local function save(profile, revision, timeout)
	return Persistence.Wait(profile, revisionTag, revision, timeout)
end

local function showPrompt(player, productId)
	local prompted, reason = pcall(MarketplaceService.PromptProductPurchase, MarketplaceService, player, productId)
	if not prompted then
		warn("Product purchase prompt failed", reason)
	end
	return prompted
end

local function applyReward(player, profile, order)
	if order.Type == "Wins" then
		if not Data:AdjustWins(player, order.Amount) then
			return false
		end
		profile.Data.LimitedPurchaseHistory[order.PurchaseId] = true
		return true
	end
	if order.Type == "GamePass" then
		Knit.GetService("GamePassService"):GiveGamePass(player, order.PurchaseId)
		return profile.Data.GamePasses[order.PurchaseId] == true
	end
	return false
end

function Products.Prompt(player, purchaseId, row, productId, recipient, amount)
	local profile = activeProfile(player)
	if not profile or busy[player] or prompts[player] or preparing[player] then
		return false, "Please wait for the previous purchase."
	end
	local state = profile.Data.ProductPurchases
	local canceled = canceledPrompts[player]
	if state.Intent and (not canceled or canceled.Intent ~= state.Intent) then
		return false, "A purchase is still pending. Please contact support if it persists."
	end
	for _, reviewProductId in state.Review do
		if reviewProductId == productId then
			return false, "A purchase for this product needs support review."
		end
	end

	local snapshot = {
		PurchaseId = purchaseId,
		ProductId = productId,
		Type = row.Type,
		Amount = amount or row.BuyNum,
		Price = row.Price,
		RecipientUserId = recipient.UserId,
		SenderName = player.DisplayName,
	}
	local function isCurrent()
		return activeProfile(player) == profile and (recipient == player or Players:GetPlayerByUserId(recipient.UserId) == recipient)
	end
	if not state.Intent and Checkout.WritesEnabled() then
		return Checkout.Open(checkoutKind, player, snapshot, isCurrent, function(previous)
			return previous.PurchaseId == purchaseId and previous.ProductId == productId
				and previous.RecipientUserId == recipient.UserId and previous.Amount == snapshot.Amount
				and previous.Price == row.Price and previous.Type == row.Type
		end)
	end

	preparing[player] = snapshot
	local legacyAllowed, reason = Checkout.CanUseLegacy(checkoutKind, player)
	preparing[player] = nil
	if not legacyAllowed or not isCurrent() then
		return false, reason or "Purchase is no longer available."
	end
	canceled = canceledPrompts[player]
	local intent = canceled and canceled.Intent
	local reopening = intent and os.clock() < canceled.Expires and state.Intent == intent and intent.ProductId == productId
		and intent.PurchaseId == purchaseId and intent.RecipientUserId == recipient.UserId and intent.Amount == snapshot.Amount
	if not reopening then
		intent = snapshot
		state.Intent = intent
		markChanged(profile)
	end
	canceledPrompts[player] = nil
	local ready = reopening
	if not ready then
		preparing[player] = intent
		local ok, saved = pcall(save, profile, state.Revision)
		preparing[player] = nil
		ready = ok and saved
	end
	if ready and activeProfile(player) == profile and state.Intent == intent then
		prompts[player] = intent
		if showPrompt(player, productId) then
			return true
		end
		-- Once the native call is attempted, its outcome may be unknown.
		return false, "Could not open this purchase."
	end
	if profile:IsActive() and state.Intent == intent then
		state.Intent = false
		markChanged(profile)
		profile:Save()
	end
	return false, "Could not prepare this purchase."
end

function Products.OnPromptFinished(player, productId, purchased)
	Checkout.Finish(checkoutKind, player, productId, purchased)
	local intent = player and prompts[player]
	if not intent or intent.ProductId ~= productId then
		return
	end
	prompts[player] = nil
	local profile = activeProfile(player)
	if purchased or not profile or profile.Data.ProductPurchases.Intent ~= intent then
		return
	end

	-- Reopen the same saved intent briefly after cancel, including the original recipient.
	local canceled = {Intent = intent, Profile = profile, Expires = os.clock() + REOPEN_WINDOW}
	canceledPrompts[player] = canceled
	task.delay(REOPEN_WINDOW, function()
		if canceledPrompts[player] == canceled and activeProfile(player) == profile
			and Products.ClearCanceledPrompt(player, profile) then
			profile:Save()
		end
	end)
end

function Products.ClearCanceledPrompt(player, profile)
	local canceled = canceledPrompts[player]
	if canceled and canceled.Profile == profile then
		canceledPrompts[player] = nil
		local state = profile.Data.ProductPurchases
		if state.Intent == canceled.Intent then
			state.Intent = false
			markChanged(profile)
			return true
		end
	end
	return false
end

local function process(player, receipt)
	local profile = activeProfile(player)
	local readyDeadline = os.clock() + RECEIPT_PROFILE_WAIT
	while not profile and Players:GetPlayerByUserId(receipt.PlayerId) == player and os.clock() < readyDeadline do
		task.wait(0.2)
		profile = activeProfile(player)
	end
	if not profile then
		return false
	end
	local id = receipt.PurchaseId
	local key = receipt.PlayerId .. "_" .. id
	local state = profile.Data.ProductPurchases
	local record = state.Receipts[id]
	if record == nil then
		if not Data:IsUsingMockProfiles() and history:GetAsync(key) == true then
			if state.Review[id] and activeProfile(player) == profile then
				state.Review[id] = nil
				profile:Save()
			end
			return true
		end
		if PurchaseDataHelper.IsRetired(PurchaseDataHelper.GetPurchaseId(receipt.ProductId)) then
			return false
		end
		if activeProfile(player) ~= profile or state.Review[id] then
			return false
		end
		local intent = state.Intent
		local canceled = canceledPrompts[player]
		if (canceled and canceled.Intent == intent) or (intent and preparing[player] == intent) then
			return false
		end
		local external = receipt.ProductPurchaseChannel == Enum.ProductPurchaseChannel.ExperienceDetailsPage
		local checkout
		if not intent and not external then
			local available
			checkout, available = Checkout.Bind(checkoutKind, player, receipt)
			if not available or activeProfile(player) ~= profile then
				return false
			end
			intent = checkout and checkout.Snapshot
		end
		if not intent or intent.ProductId ~= receipt.ProductId or external then
			state.Review[id] = receipt.ProductId
			profile:Save()
			warn("Paid product requires reconciliation", key, receipt.ProductId)
			return false
		end
		record = table.clone(intent)
		record.CheckoutId = checkout and checkout.Id
		record.OrderId = key
		record.Spent = receipt.CurrencySpent or intent.Price
		if record.RecipientUserId == player.UserId then
			if not applyReward(player, profile, record) then
				return false
			end
			profile.Data.RobuxSpent += record.Spent
			record.Delivered = true
		end
		state.Receipts[id] = record
		if not checkout then
			state.Intent = false
		end
		markChanged(profile)
	end
	if not save(profile, state.Revision, RECEIPT_SAVE_WAIT) then
		return false
	end

	if not record.Delivered then
		if not Data:QueuePaidDelivery(record.RecipientUserId, deliveryKind, record) then
			return false
		end
		if activeProfile(player) ~= profile then
			return false
		end
		record.Delivered = true
		profile.Data.RobuxSpent += record.Spent
		markChanged(profile)
		if not save(profile, state.Revision, RECEIPT_SAVE_WAIT) then
			return false
		end
	end
	-- Keep the original marker readable by servers running the previous release.
	if not Data:IsUsingMockProfiles() and not record.LegacyRecorded then
		history:SetAsync(key, true)
		record.LegacyRecorded = true
	end
	if not Checkout.Complete(checkoutKind, receipt, record.CheckoutId) then
		return false
	end
	return true, record
end

function Products.Process(receipt)
	local player = Players:GetPlayerByUserId(receipt.PlayerId)
	if not player then
		return false
	end
	local deadline = os.clock() + RECEIPT_QUEUE_WAIT
	while busy[player] and Players:GetPlayerByUserId(receipt.PlayerId) == player and os.clock() < deadline do
		task.wait(0.1)
	end
	if busy[player] or Players:GetPlayerByUserId(receipt.PlayerId) ~= player then
		return false
	end
	busy[player] = true
	local ok, granted, record = pcall(process, player, receipt)
	busy[player] = nil
	if not ok then
		warn("Paid product receipt failed", receipt.PurchaseId, granted)
		return false
	end
	if record then
		local sent = notified[player] or {}
		notified[player] = sent
		if sent[receipt.PurchaseId] then
			return granted
		end
		sent[receipt.PurchaseId] = true
	end
	return granted, record, player
end

function Products.Watch(player, onGift)
	watches[player] = Data:WatchPaidDeliveries(player, deliveryKind, function(updateId, order)
		local profile = activeProfile(player)
		if not profile or order.RecipientUserId ~= player.UserId then
			return
		end
		local state = profile.Data.ProductPurchases
		local revision = state.Gifts[order.OrderId]
		local ok, err = pcall(function()
			if not revision then
				if not applyReward(player, profile, order) then
					return
				end
				markChanged(profile)
				revision = state.Revision
				state.Gifts[order.OrderId] = revision
			end
			while activeProfile(player) == profile do
				if save(profile, revision) then
					Data:ClearPaidDelivery(player, deliveryKind, updateId)
					if activeProfile(player) == profile then
						onGift(player, order)
					end
					return
				end
				task.wait(2)
			end
		end)
		if not ok then
			warn("Paid product delivery failed", order.OrderId, err)
		end
	end)
end

function Products.Remove(player)
	local profile = activeProfile(player)
	if profile then
		Products.ClearCanceledPrompt(player, profile)
	end
	canceledPrompts[player] = nil
	preparing[player] = nil
	prompts[player] = nil
	notified[player] = nil
	for _, connection in watches[player] or {} do
		connection:Disconnect()
	end
	watches[player] = nil
end

return Products
