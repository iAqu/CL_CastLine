local MarketplaceService = game:GetService("MarketplaceService")
local ReplicatedFirst = game:GetService("ReplicatedFirst")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local Config = require(ReplicatedStorage.Modules.FishingBaitConfig)
local Progression = require(ReplicatedStorage.Modules.FishingProgression)
local PurchaseData = require(ReplicatedFirst.Data.PurchaseData)
local PlayerDataService = require(script.Parent.PlayerDataService)
local Policy = require(script.Parent.PaidItemPolicy)
local Persistence = require(script.Parent.PurchasePersistence)

local Purchases = {}
local opening = {}
local preparing = {}
-- Only locally opened prompts may clear a persisted intent on cancellation.
local openPrompts = setmetatable({}, { __mode = "k" })
local canceledPrompts = setmetatable({}, { __mode = "k" })
local REOPEN_WINDOW = 3
local REVISION_TAG = "FishingBaitReceiptRevision"
local PROCESSING_MESSAGE = "Your bait purchase is still processing."

local function getProfile(player)
	local profile = player and PlayerDataService:GetProfile(player)
	return if profile and profile:IsActive() then profile else nil
end

local function getSavedRevision(profile)
	return profile.MetaData.MetaTagsLatest[REVISION_TAG] or 0
end

local function markChanged(profile, progress)
	local revision = (progress.ReceiptRevision or 0) + 1
	progress.ReceiptRevision = revision
	profile:SetMetaTag(REVISION_TAG, revision)
	return revision
end

local requestSave = Persistence.Request

local function saveThrough(profile, revision)
	return Persistence.Wait(profile, REVISION_TAG, revision)
end

function Purchases.GetProductId()
	local allowedUniverseId = if RunService:IsStudio() then Config.DevPurchaseUniverseId else Config.PurchaseUniverseId
	if game.GameId ~= allowedUniverseId then
		return nil
	end
	local row = PurchaseData[Config.PurchaseId]
	local id = row and row.ProductId
	return if type(id) == "number" and id > 0 and id % 1 == 0 then id else nil
end

function Purchases.IsPurchaseId(purchaseId)
	return purchaseId == Config.PurchaseId
end

function Purchases.IsProduct(productId)
	return type(productId) == "number" and productId == Purchases.GetProductId()
end

function Purchases.GetCredits(profile, progress, rodId)
	local revision = progress.BaitCreditRevisions and progress.BaitCreditRevisions[rodId]
	return if revision and getSavedRevision(profile) < revision then 0 else progress.Credits[rodId] or 0
end

local function clearIntent(profile, progress, intent)
	if progress.PendingBaitPurchase == intent then
		progress.PendingBaitPurchase = nil
		markChanged(profile, progress)
		requestSave(profile)
	end
end

local function pendingIntent(player, profile, progress)
	local intent = progress.PendingBaitPurchase
	local canceled = canceledPrompts[player]
	if canceled and canceled.Profile == profile and canceled.Intent == intent then
		return nil, canceled
	end
	return intent, nil
end

local function preparePrompt(player, rodId, token, isCurrent)
	local productId = Purchases.GetProductId()
	local profile = getProfile(player)
	if not productId or not profile then
		return false, "Robux bait is unavailable."
	end
	local progress = Progression.Ensure(profile.Data)
	if pendingIntent(player, profile, progress) or openPrompts[player]
		or getSavedRevision(profile) < (progress.ReceiptRevision or 0)
	then
		return false, PROCESSING_MESSAGE
	end
	if Purchases.GetCredits(profile, progress, rodId) > 0 then
		return false, "Bait ready. Select it again to use it."
	end
	local policy = Policy.Get(player)
	if not policy then
		return false, "Purchase availability could not be checked. Please try again."
	end
	if policy.ArePaidRandomItemsRestricted ~= false then
		return false, "Robux bait is unavailable for this player."
	end
	if getProfile(player) ~= profile or not isCurrent() then
		return false, "Fishing selection unavailable."
	end
	-- Policy checks can yield while the canceled intent expires or a receipt is saved.
	local unresolved, canceled = pendingIntent(player, profile, progress)
	if unresolved or getSavedRevision(profile) < (progress.ReceiptRevision or 0) then
		return false, PROCESSING_MESSAGE
	end
	if Purchases.GetCredits(profile, progress, rodId) > 0 then
		return false, "Bait ready. Select it again to use it."
	end
	local intent = canceled and canceled.Intent
	local reopening = intent and os.clock() < canceled.Expires and intent.ProductId == productId
		and intent.RodId == rodId and intent.SessionToken == token
	canceledPrompts[player] = nil
	local saved = true
	if not reopening then
		intent = { ProductId = productId, RodId = rodId, SessionToken = token }
		progress.PendingBaitPurchase = intent
		preparing[player] = intent
		saved = saveThrough(profile, markChanged(profile, progress))
		preparing[player] = nil
	end
	if not saved or getProfile(player) ~= profile or not isCurrent() then
		if profile:IsActive() then
			clearIntent(profile, progress, intent)
		end
		return false, "Could not prepare a bait purchase. Please try again."
	end
	openPrompts[player] = intent
	local ok, err = pcall(MarketplaceService.PromptProductPurchase, MarketplaceService, player, productId)
	if not ok then
		warn("Fishing bait prompt failed: " .. tostring(err))
		return false, "Could not open the bait purchase."
	end
	return true
end

function Purchases.Prompt(player, rodId, token, isCurrent)
	if opening[player] then
		return false, PROCESSING_MESSAGE
	end
	opening[player] = true
	local ok, prompted, message = pcall(preparePrompt, player, rodId, token, isCurrent)
	opening[player] = nil
	preparing[player] = nil
	if not ok then
		warn("Fishing bait purchase preparation failed: " .. tostring(prompted))
		return false, "Could not prepare a bait purchase. Please try again."
	end
	return prompted, message
end

function Purchases.OnPromptFinished(player, productId, purchased)
	local intent = player and openPrompts[player]
	if not intent or intent.ProductId ~= productId then
		return
	end
	openPrompts[player] = nil
	local profile = getProfile(player)
	if purchased or not profile or Progression.Ensure(profile.Data).PendingBaitPurchase ~= intent then
		return
	end
	local canceled = { Intent = intent, Profile = profile, Expires = os.clock() + REOPEN_WINDOW }
	canceledPrompts[player] = canceled
	task.delay(REOPEN_WINDOW, function()
		if canceledPrompts[player] == canceled and getProfile(player) == profile
			and Purchases.ClearCanceledPrompt(player, profile) then
			requestSave(profile)
		end
	end)
end

function Purchases.ClearCanceledPrompt(player, profile)
	local canceled = canceledPrompts[player]
	if not canceled or canceled.Profile ~= profile then
		return false
	end
	canceledPrompts[player] = nil
	local progress = Progression.Ensure(profile.Data)
	if progress.PendingBaitPurchase ~= canceled.Intent then
		return false
	end
	progress.PendingBaitPurchase = nil
	markChanged(profile, progress)
	return true
end

function Purchases.Process(player, receipt)
	local profile = getProfile(player)
	if not profile or player.UserId ~= receipt.PlayerId or not Purchases.IsProduct(receipt.ProductId) then
		return false
	end
	local progress = Progression.Ensure(profile.Data)
	local added = false
	if not progress.Receipts[receipt.PurchaseId] then
		if receipt.ProductPurchaseChannel == Enum.ProductPurchaseChannel.ExperienceDetailsPage then
			warn("Fishing bait receipt originated outside the fishing picker: " .. tostring(receipt.PurchaseId))
			return false
		end
		local intent = progress.PendingBaitPurchase
		local canceled = canceledPrompts[player]
		if (canceled and canceled.Intent == intent) or (intent and preparing[player] == intent) then
			return false
		end
		if not intent or intent.ProductId ~= receipt.ProductId then
			warn("Fishing bait receipt has no matching purchase intent: " .. tostring(receipt.PurchaseId))
			return false
		end
		added = Progression.GrantReceipt(progress, intent.RodId, receipt.PurchaseId)
		if openPrompts[player] == intent then
			openPrompts[player] = nil
		end
		progress.PendingBaitPurchase = nil
		progress.BaitCreditRevisions = progress.BaitCreditRevisions or {}
		progress.BaitCreditRevisions[intent.RodId] = markChanged(profile, progress)
	end
	if not saveThrough(profile, progress.ReceiptRevision or 0) then
		return false
	end
	return true, added
end

function Purchases.Consume(profile, rodId)
	if not profile:IsActive() then
		return false
	end
	local progress = Progression.Ensure(profile.Data)
	if Purchases.GetCredits(profile, progress, rodId) < 1 then
		return false
	end
	progress.Credits[rodId] -= 1
	if saveThrough(profile, markChanged(profile, progress)) then
		return true
	end
	if profile:IsActive() then
		progress.Credits[rodId] += 1
		markChanged(profile, progress)
		requestSave(profile)
	end
	return false
end

return Purchases
