local ConfigService = game:GetService("ConfigService")
local DataStoreService = game:GetService("DataStoreService")
local HttpService = game:GetService("HttpService")
local MarketplaceService = game:GetService("MarketplaceService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local Data = require(script.Parent.PlayerDataService)

local Checkout = {}
local CONFIG_KEY = "DedicatedPurchaseCheckout"
local DEV_PLACE_ID = 84106335829275
local STUDIO_EGG_CHECKOUT_ATTRIBUTE = "StudioDedicatedPaidEggCheckout"
local REOPEN_SECONDS = 3
local STORAGE_MESSAGE = "Could not prepare this purchase. Please try again."
local PENDING_MESSAGE = "A purchase is still pending. Please contact support if it persists."
local sessions = setmetatable({}, { __mode = "k" })
local mockRecords = {}
local store
local dedicatedWritesEnabled = false

local function applyConfig(snapshot)
	local value = snapshot:GetValue(CONFIG_KEY)
	dedicatedWritesEnabled = value == nil or value == true
end

local function loadConfig()
	local ok, snapshot = pcall(ConfigService.GetConfigAsync, ConfigService)
	if not ok or snapshot.Error ~= Enum.ConfigSnapshotErrorState.None then
		warn("Purchase checkout config could not be loaded", if ok then snapshot.Error else snapshot)
		task.delay(60, loadConfig)
		return
	end
	applyConfig(snapshot)
	snapshot.UpdateAvailable:Connect(function()
		local refreshed, message = pcall(snapshot.Refresh, snapshot)
		if not refreshed or snapshot.Error ~= Enum.ConfigSnapshotErrorState.None then
			warn("Purchase checkout config could not be refreshed", if refreshed then snapshot.Error else message)
			return
		end
		applyConfig(snapshot)
	end)
end

function Checkout.Start()
	task.spawn(loadConfig)
end

function Checkout.WritesEnabled(kind)
	if kind == "Egg" and RunService:IsStudio() and game.PlaceId == DEV_PLACE_ID then
		return workspace:GetAttribute(STUDIO_EGG_CHECKOUT_ATTRIBUTE) ~= false
	end
	return dedicatedWritesEnabled
end

local function update(kind, userId, transform)
	local key = kind .. ":" .. tostring(userId)
	local ok, result = pcall(function()
		if Data:IsUsingMockProfiles() then
			local changed = transform(mockRecords[key])
			if changed ~= nil then
				mockRecords[key] = changed
			end
			return changed
		end
		store = store or DataStoreService:GetDataStore("PurchaseCheckout_v1")
		return store:UpdateAsync(key, transform)
	end)
	if not ok then
		warn("Purchase checkout storage failed", kind, userId, result)
		return false
	end
	return true, result
end

function Checkout.CanUseLegacy(kind, player)
	if sessions[player] then
		return false, PENDING_MESSAGE
	end
	local pending
	local ok = update(kind, player.UserId, function(current)
		pending = current and current.Status == "Open"
		return nil
	end)
	if not ok then
		return false, STORAGE_MESSAGE
	end
	if pending then
		return false, PENDING_MESSAGE
	end
	return true
end

local function changeOpen(kind, userId, checkoutId, transform)
	return update(kind, userId, function(current)
		if current and current.Id == checkoutId and current.Status == "Open" then
			return transform(current)
		end
		return nil
	end)
end

local function cancel(session, userId)
	return changeOpen(session.Kind, userId, session.Id, function(current)
		if current.ReceiptId then
			return nil
		end
		local canceled = table.clone(current)
		canceled.Status = "Canceled"
		canceled.CanceledAt = session.CanceledAt
		return canceled
	end)
end

local function finishCancellation(player, session, attempts)
	local ok = cancel(session, player.UserId)
	if ok then
		if sessions[player] == session then
			sessions[player] = nil
		end
	elseif attempts > 1 then
		task.delay(2, finishCancellation, player, session, attempts - 1)
	elseif not session.Attempted and sessions[player] == session then
		sessions[player] = nil
	end
end

local function abandonUnopened(player, session)
	session.CanceledAt = os.time()
	task.defer(finishCancellation, player, session, 3)
end

function Checkout.Open(kind, player, snapshot, isCurrent, matches, beforePrompt)
	if sessions[player] then
		return false, PENDING_MESSAGE
	end
	local id = HttpService:GenerateGUID(false)
	local session = { Kind = kind, ProductId = snapshot.ProductId, Id = id }
	sessions[player] = session
	local now = os.time()
	local saved, record = update(kind, player.UserId, function(current)
		if current and current.Status == "Open" then
			return nil
		end
		if current and current.Status == "Canceled" and now - current.CanceledAt < REOPEN_SECONDS
			and matches(current.Snapshot) then
			return { Id = id, Status = "Open", Snapshot = current.Snapshot }
		end
		return { Id = id, Status = "Open", Snapshot = snapshot }
	end)
	if not saved then
		-- A failed response can hide a committed write. This attempt never reached Roblox.
		abandonUnopened(player, session)
		return false, STORAGE_MESSAGE
	end
	if not record or record.Id ~= id then
		sessions[player] = nil
		return false, PENDING_MESSAGE
	end
	local ready, current = pcall(isCurrent)
	if not ready or not current or player.Parent ~= Players then
		abandonUnopened(player, session)
		return false, "Purchase selection is no longer available."
	end
	if beforePrompt then
		local prepared, message = pcall(beforePrompt)
		if not prepared then
			warn("Purchase checkout could not notify client", kind, message)
			abandonUnopened(player, session)
			return false, STORAGE_MESSAGE
		end
	end
	-- Keep the session until the matching closing event, even when the receipt arrives first.
	session.Attempted = true
	local ok, reason = pcall(MarketplaceService.PromptProductPurchase, MarketplaceService, player, snapshot.ProductId)
	if not ok then
		warn("Purchase checkout prompt failed", kind, player.UserId, reason)
		return false, "Could not open this purchase. Your order is awaiting confirmation."
	end
	return true
end

function Checkout.Finish(kind, player, productId, purchased)
	local session = player and sessions[player]
	if not session or not session.Attempted or session.Kind ~= kind or session.ProductId ~= productId
		or session.CanceledAt then
		return
	end
	if purchased then
		sessions[player] = nil
		return
	end
	session.CanceledAt = os.time()
	finishCancellation(player, session, 3)
end

-- The second result indicates whether the store was available. Missing and failed reads
-- have different meanings to handlers that put unmatched receipts into support review.
function Checkout.Bind(kind, player, receipt)
	local session = sessions[player]
	if session and session.Kind == kind and (not session.Attempted or session.CanceledAt) then
		return nil, false
	end
	local alreadyBound
	local ok, record = update(kind, receipt.PlayerId, function(current)
		alreadyBound = nil
		if not current or current.Status ~= "Open" or current.Snapshot.ProductId ~= receipt.ProductId then
			return nil
		end
		if current.ReceiptId == receipt.PurchaseId then
			alreadyBound = current
			return nil
		end
		if current.ReceiptId then
			return nil
		end
		local bound = table.clone(current)
		bound.ReceiptId = receipt.PurchaseId
		return bound
	end)
	if not ok then
		return nil, false
	end
	return record or alreadyBound, true
end

function Checkout.Complete(kind, receipt, checkoutId)
	if not checkoutId then
		return true
	end
	local matched = true
	local ok = changeOpen(kind, receipt.PlayerId, checkoutId, function(current)
		matched = current.ReceiptId == receipt.PurchaseId and current.Snapshot.ProductId == receipt.ProductId
		if matched then
			return { Id = checkoutId, Status = "Complete" }
		end
		return nil
	end)
	return ok and matched
end

return Checkout
