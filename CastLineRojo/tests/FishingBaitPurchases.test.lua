local new = require("./helpers/FishingHarness")

local h = new()
local productId = h.purchaseData.PremiumBait.ProductId
local unrelatedId = productId + 1
local premiumBaitId = h.rods.Rod_101.BaitsSelect[4]
local progress = h.progression.Ensure(h.profile.Data)
local client, player, purchases = h.client, h.player, h.purchases
local function requestPurchase(baitId)
	return client:RequestBaitPurchase(player, h.token, baitId or premiumBaitId)
end
local function receipt(id, sku)
	return { PlayerId = player.UserId, ProductId = sku or productId, PurchaseId = id }
end

assert(purchases.IsPurchaseId("PremiumBait") and not purchases.IsPurchaseId("WinsTier1"))
assert(purchases.GetProductId() == productId and not purchases.IsProduct(unrelatedId))
h.env.game.GameId = h.baitConfig.DevPurchaseUniverseId
assert(not purchases.GetProductId() and not purchases.IsProduct(productId), "Published DEV cannot sell the production SKU")
h.studio = true
h.env.game.GameId = 999
assert(not purchases.GetProductId() and not purchases.IsProduct(productId))
h.env.game.GameId = h.baitConfig.DevPurchaseUniverseId
assert(purchases.GetProductId() == productId and purchases.IsProduct(productId), "DEV Studio uses the table SKU")
h.purchaseData.PremiumBait.ProductId = unrelatedId
assert(purchases.GetProductId() == unrelatedId and not purchases.IsProduct(productId), "Table updates change the SKU")
h.purchaseData.PremiumBait.ProductId = productId

h.begin()
assert(h.beginResult.baitQuotes[premiumBaitId].productId == productId)
assert(not requestPurchase(h.rods.Rod_101.BaitsSelect[3]).ok)
assert(not client:RequestBaitPurchase(player, "stale", premiumBaitId).ok)
assert(not purchases.Process(player, receipt("unmatched")))
h.restrictPaid = true
assert(not requestPurchase().ok and #h.prompts == 0)
h.restrictPaid = false
h.noPolicy = true
assert(not requestPurchase().ok and #h.prompts == 0)
h.noPolicy = false

-- Never open a prompt when the purchase intent has not reached storage.
h.pauseSave = true
assert(not requestPurchase().ok and #h.prompts == 0 and not progress.PendingBaitPurchase)
h.pauseSave = false
h.profile:Save()

h.pauseSave = true
h.onWait = function()
	h.onWait = nil
	h.profile.Data.EquippedRodId = "Rod_102"
	h.pauseSave = false
	h.profile:Save()
end
assert(not requestPurchase().ok and #h.prompts == 0 and not progress.PendingBaitPurchase,
	"Changing the rod during intent persistence prevents the purchase prompt")
h.profile.Data.EquippedRodId = "Rod_101"

h.onPrompt = function()
	local intent = assert(progress.PendingBaitPurchase)
	assert(intent.RodId == "Rod_101" and intent.SessionToken == h.token)
	assert(h.profile.MetaData.MetaTagsLatest.FishingBaitReceiptRevision == progress.ReceiptRevision)
	assert(not requestPurchase().ok, "Concurrent requests cannot open another prompt")
end
assert(client:SelectBait(player, h.token, premiumBaitId, true).prompted and #h.prompts == 1 and h.prompts[1] == productId)
h.onPrompt = nil
purchases.OnPromptFinished(player, 1, false)
assert(progress.PendingBaitPurchase, "Unrelated prompt events must be ignored")
purchases.OnPromptFinished(player, productId, false)
local canceled = progress.PendingBaitPurchase
local saves = h.saveCalls
assert(canceled and not progress.Credits.Rod_101)
assert(not purchases.Process(player, receipt("unexpected")))
assert(requestPurchase().ok and #h.prompts == 2 and h.saveCalls == saves and progress.PendingBaitPurchase == canceled)

-- Closing the Roblox prompt never issues credit. A delayed receipt stays bound to the original rod.
purchases.OnPromptFinished(player, productId, true)
assert(not progress.Credits.Rod_101 and progress.PendingBaitPurchase)
h.cancel()
h.ready = false
assert(not purchases.Process(player, receipt("payment")))
h.ready = true
h.profile.Data.EquippedRodId = "Rod_102"
h.begin()
assert(not requestPurchase().ok, "A pending receipt cannot be reassigned to the new rod")
assert(not purchases.Process(nil, receipt("payment")))
assert(not purchases.Process(player, receipt("not-bait", 99999)))
assert(not purchases.Process(player, receipt("unrelated", unrelatedId)) and progress.PendingBaitPurchase)
local mismatched = receipt("wrong-player")
mismatched.PlayerId += 1
assert(not purchases.Process(player, mismatched))
local external = receipt("external")
external.ProductPurchaseChannel = h.env.Enum.ProductPurchaseChannel.ExperienceDetailsPage
assert(not purchases.Process(player, external) and progress.PendingBaitPurchase)

h.pauseSave = true
assert(not purchases.Process(player, receipt("payment")), "Unpersisted receipt must be retried")
assert(progress.Credits.Rod_101 == 1 and progress.Receipts.payment == "Rod_101")
assert(purchases.GetCredits(h.profile, progress, "Rod_101") == 0, "Unpersisted purchase cannot be spent")
h.pauseSave = false
assert(purchases.Process(player, receipt("payment")))
assert(progress.Credits.Rod_101 == 1 and not progress.Credits.Rod_102)
assert(client:SelectBait(player, h.token, premiumBaitId).needsPurchase)
h.cancel()

h.profile.Data.EquippedRodId = "Rod_101"
h.begin(premiumBaitId)
h.cancel()
assert(progress.Credits.Rod_101 == 1, "Leaving before a cast keeps the paid use")
h.begin(premiumBaitId)
h.pauseSave = true
assert(not h.castAt(1).ok and progress.Credits.Rod_101 == 1)
h.pauseSave = false
h.profile:Save()
local wins = h.profile.Data.Wins
h.cast()
assert(progress.Credits.Rod_101 == 0 and h.profile.Data.Wins == wins)
assert(not client:Cast(player, h.token, 1).ok, "Repeating Cast cannot consume again")

-- A missed round preserves the paid effect for the next bite in the same session.
h.now = h.round.retryAt + 0.1
local retry = client:NextRound(player, h.token, h.round.round)
assert(retry.ok and retry.fishId == h.round.fishId)
h.round = retry
h.failGrant = true
assert(not h.hook().ok)
h.failGrant = false
local caught = h.hook()
assert(caught.ok and caught.mutationId == "Rainbow")
assert(h.lastOptions.PaidOrigin == "PremiumBait", "Paid catches follow the existing transfer policy")
assert(progress.Credits.Rod_101 == 0 and h.profile.Data.Wins == wins)

local granted, added = purchases.Process(player, receipt("payment"))
assert(granted and not added and progress.Credits.Rod_101 == 0, "Replay never restores spent credit")
assert(not h.hook().ok)
h.cancel()
h.begin()
assert(client:SelectBait(player, h.token, premiumBaitId).needsPurchase, "A new cast needs a new purchase")
assert(requestPurchase().ok)
purchases.OnPromptFinished(player, productId, false)
local firstSession = progress.PendingBaitPurchase.SessionToken
local savesBeforeSessionChange = h.saveCalls
h.cancel()
h.begin()
assert(h.token ~= firstSession)
assert(requestPurchase().ok and progress.PendingBaitPurchase.SessionToken == h.token
	and h.saveCalls > savesBeforeSessionChange, "A different fishing round needs a newly saved order")
purchases.OnPromptFinished(player, productId, false)
h.advance(3)
assert(not progress.PendingBaitPurchase, "Canceled orders expire and are cleaned up")
