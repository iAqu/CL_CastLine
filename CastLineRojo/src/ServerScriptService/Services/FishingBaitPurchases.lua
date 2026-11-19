local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Config = require(ReplicatedStorage.Modules.FishingBaitConfig)
local Progression = require(ReplicatedStorage.Modules.FishingProgression)
local PlayerDataService = require(script.Parent.PlayerDataService)

local Purchases = {}

function Purchases.GetRod(productId)
	return Config.GetProductRod(productId)
end

function Purchases.Process(player, receipt)
	local rodId = Purchases.GetRod(receipt.ProductId)
	local profile = player and PlayerDataService:GetProfile(player)
	if not rodId or not profile or not profile:IsActive() then
		return false
	end
	local progress = Progression.Ensure(profile.Data)
	local added = Progression.GrantReceipt(progress, rodId, receipt.PurchaseId)
	if added then
		progress.ReceiptRevision = (progress.ReceiptRevision or 0) + 1
	end
	local revision = progress.ReceiptRevision or 0
	-- Acknowledge only after the profile containing both the credit and receipt is durable.
	profile:SetMetaTag("FishingBaitReceiptRevision", revision)
	profile:Save()
	local deadline = os.clock() + 10
	while os.clock() < deadline do
		if (profile.MetaData.MetaTagsLatest.FishingBaitReceiptRevision or -1) >= revision then
			return true, added
		end
		if not profile:IsActive() then
			return false
		end
		task.wait(0.1)
	end
	return false
end

return Purchases
