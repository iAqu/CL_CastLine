local file = assert(io.open("src/ServerScriptService/Services/ProductPurchases.lua", "r"))
local source = file:read("*a")
file:close()

local function copy(value)
	if type(value) ~= "table" then return value end
	local result = {}
	for key, child in value do result[key] = copy(child) end
	return result
end

local now, paused, blockHistory, nextMailboxId, promptCount = 0, false, false, 0, 0
local legacy, active, disk, mail, live, listeners = {}, {}, {}, {}, {}, {}
local delayed = {}
local beforeWait
local yieldOnWait = false
local saveCalls = 0
local persistenceMock = require("./helpers/PurchasePersistenceMock")
local buyer = {UserId = 1, DisplayName = "Buyer"}
local recipient = {UserId = 2, DisplayName = "Recipient"}
local other = {UserId = 3, DisplayName = "Other"}
local Data = {}
local stores, checkoutFixture
local function join(player)
	player.Parent = stores.Players
	local snapshot = disk[player.UserId]
	local profile = {active = true, MetaData = {MetaTags = {}, MetaTagsLatest = {}}}
	profile.Data = if snapshot then copy(snapshot.data) else {
		Wins = 0, RobuxSpent = 0, GamePasses = {}, LimitedPurchaseHistory = {},
		ProductPurchases = {Intent = false, Receipts = {}, Gifts = {}, Review = {}, Revision = 0},
	}
	if snapshot then
		profile.MetaData.MetaTags = copy(snapshot.tags)
		profile.MetaData.MetaTagsLatest = copy(snapshot.tags)
	end
	function profile:IsActive() return self.active end
	function profile:SetMetaTag(tag, value) self.MetaData.MetaTags[tag] = value end
	function profile:Save()
		saveCalls += 1
		if paused then return end
		self.MetaData.MetaTagsLatest = copy(self.MetaData.MetaTags)
		disk[player.UserId] = {data = copy(self.Data), tags = copy(self.MetaData.MetaTags)}
	end
	active[player], live[player.UserId] = profile, player
	return profile
end

local function leave(player)
	active[player].active = false
	active[player], live[player.UserId], listeners[player] = nil, nil, nil
end

function Data:IsUsingMockProfiles() return false end
function Data:GetProfile(player) return active[player] end
function Data:AdjustWins(player, amount)
	active[player].Data.Wins += amount
	return true
end
function Data:QueuePaidDelivery(userId, kind, order)
	assert(kind == "PaidProductV1")
	for _, entry in pairs(mail[userId] or {}) do
		if entry.OrderId == order.OrderId then return true end
	end
	nextMailboxId += 1
	mail[userId] = mail[userId] or {}
	mail[userId][nextMailboxId] = copy(order)
	return true
end
function Data:WatchPaidDeliveries(player, _, callback)
	listeners[player] = callback
	for id, order in table.clone(mail[player.UserId] or {}) do
		callback(id, order)
	end
	return {}
end
function Data:ClearPaidDelivery(player, _, id)
	mail[player.UserId][id] = nil
end

stores = {
	Players = {GetPlayerByUserId = function(_, id) return live[id] end},
	ReplicatedStorage = {Packages = {Knit = {
		GetService = function(name)
			assert(name == "GamePassService")
			return {GiveGamePass = function(_, player, id) active[player].Data.GamePasses[id] = true end}
		end,
	}}},
	ReplicatedFirst = {DataHelpers = {PurchaseDataHelper = {
		IsRetired = function() return false end, GetPurchaseId = function() return "Cash" end,
	}}},
	ServerScriptService = {Services = {PlayerDataService = Data}},
	DataStoreService = {GetDataStore = function(_, name)
		assert(name == "PurchaseHistory")
		return {
			GetAsync = function(_, key) return legacy[key] end,
			SetAsync = function(_, key, value)
				if blockHistory then error("simulated DataStore failure") end
				legacy[key] = value
			end,
		}
	end},
	MarketplaceService = {PromptProductPurchase = function()
		promptCount += 1
		if stores.ServerScriptService.Services.PurchaseCheckout.WritesEnabled() then
			assert(checkoutFixture.Records["Product:1"].Snapshot, "Dedicated context must be saved before prompting")
		else
			assert(disk[buyer.UserId].data.ProductPurchases.Intent, "Intent must be saved before prompting")
		end
	end},
}

checkoutFixture = require("./helpers/PurchaseCheckoutFixture")(stores.Players, stores.MarketplaceService, {
	defer = function(callback, ...) callback(...) end,
	delay = function(_, callback, ...) callback(...) end,
}, function() return math.floor(now) end)

local function loadProducts()
	stores.ServerScriptService.Services.PurchaseCheckout = checkoutFixture.Load()
	local function wait(seconds)
		now += seconds
		if yieldOnWait then
			coroutine.yield()
		end
		if beforeWait then
			local callback = beforeWait
			beforeWait = nil
			callback()
		end
	end
	stores.ServerScriptService.Services.PurchasePersistence = persistenceMock(function() return now end, wait)
	return assert(load(source, "ProductPurchases", "t", setmetatable({
		game = {GetService = function(_, name) return assert(stores[name], name) end},
		require = function(module) return assert(module) end,
		Enum = {ProductPurchaseChannel = {ExperienceDetailsPage = "Details"}},
		os = {clock = function() return now end},
		task = {
			wait = wait,
			delay = function(_, callback)
				table.insert(delayed, callback)
			end,
		},
		warn = function() end,
	}, {__index = getfenv()})))()
end

local function receipt(id, productId)
	return {PlayerId = buyer.UserId, PurchaseId = id, ProductId = productId or 101, CurrencySpent = 19}
end

local row = {Type = "Wins", BuyNum = 50000, Price = 19}
local profile = join(buyer)
local products = loadProducts()
assert(products.Prompt(buyer, "Cash", row, 101, buyer))
assert(not products.Prompt(buyer, "Cash", row, 101, other) and promptCount == 1)
products.OnPromptFinished(buyer, 101, true)
paused = true
assert(not products.Process(receipt("cash")) and not legacy["1_cash"])
assert(profile.Data.Wins == 50000 and disk[1].data.Wins == 0)
paused = false
blockHistory = true
assert(not products.Process(receipt("cash")))
assert(disk[1].data.Wins == 50000 and disk[1].data.RobuxSpent == 19)
leave(buyer)
profile = join(buyer)
products = loadProducts()
blockHistory = false
assert(products.Process(receipt("cash")) and products.Process(receipt("cash")))
assert(profile.Data.Wins == 50000 and profile.Data.RobuxSpent == 19 and legacy["1_cash"])

join(recipient)
local offlineGiftAmount = 2_500_000
assert(products.Prompt(buyer, "Cash", row, 101, recipient, offlineGiftAmount))
products.OnPromptFinished(buyer, 101, true)
leave(recipient)
leave(buyer)
profile = join(buyer)
products = loadProducts()
assert(products.Process(receipt("gift")) and products.Process(receipt("gift")))
assert(profile.Data.Wins == 50000 and profile.Data.RobuxSpent == 38)
assert(next(mail[2]) and not mail[3], "Offline delivery uses the original recipient after a server change")
local giftId, queued = next(mail[2])
local receivingProfile = join(recipient)
products.Watch(recipient, function(player) assert(player == recipient) end)
assert(receivingProfile.Data.Wins == offlineGiftAmount and disk[2].data.Wins == offlineGiftAmount and next(mail[2]) == nil)
mail[2][giftId] = queued
leave(recipient)
receivingProfile = join(recipient)
products = loadProducts()
products.Watch(recipient, function() end)
assert(receivingProfile.Data.Wins == offlineGiftAmount and next(mail[2]) == nil, "Duplicate mailbox delivery is idempotent")

assert(products.Prompt(buyer, "DoubleTrain", {Type = "GamePass", BuyNum = 1, Price = 19}, 102, recipient))
products.OnPromptFinished(buyer, 102, true)
assert(products.Process(receipt("pass", 102)))
local passId, passOrder = next(mail[2])
listeners[recipient](passId, passOrder)
assert(receivingProfile.Data.GamePasses.DoubleTrain == true and not profile.Data.GamePasses.DoubleTrain)
assert(disk[2].data.GamePasses.DoubleTrain and next(mail[2]) == nil)

legacy["1_old"] = true
assert(products.Process(receipt("old")) and profile.Data.Wins == 50000)
assert(not products.Process(receipt("ambiguous")))
assert(profile.Data.ProductPurchases.Review.ambiguous == 101 and profile.Data.Wins == 50000)

print("Cash receipts, failed saves, cross-server replay, offline gifting and legacy reconciliation passed")

-- An identical canceled prompt can reopen using its durable intent.
local originalRecipient = join(other)
assert(products.Prompt(buyer, "Cash", row, 104, other))
local frozen = profile.Data.ProductPurchases.Intent
products.OnPromptFinished(buyer, 104, false)
assert(not products.Process(receipt("canceled", 104)), "A canceled prompt cannot consume an unrelated receipt")
local savesBeforeReopen = saveCalls
assert(products.Prompt(buyer, "Cash", row, 104, other))
assert(saveCalls == savesBeforeReopen and profile.Data.ProductPurchases.Intent == frozen)
delayed[#delayed]()
assert(profile.Data.ProductPurchases.Intent == frozen, "The first cancellation cannot clear a reopened prompt")
products.OnPromptFinished(buyer, 104, false)

-- A different recipient becomes eligible only after the changed intent is persisted.
assert(products.Prompt(buyer, "Cash", row, 104, buyer))
assert(saveCalls > savesBeforeReopen and disk[buyer.UserId].data.ProductPurchases.Intent.RecipientUserId == buyer.UserId)
local confirmedBalance = profile.Data.Wins
products.OnPromptFinished(buyer, 104, true)
paused = true
local savesBeforeReceipt = saveCalls
beforeWait = function() paused = false end
assert(products.Process(receipt("save-retry", 104)))
assert(saveCalls >= savesBeforeReceipt + 2, "Reissue a save missed by the write queue within the same receipt callback")
assert(profile.Data.Wins == confirmedBalance + row.BuyNum and products.Process(receipt("save-retry", 104)))
assert(profile.Data.Wins == confirmedBalance + row.BuyNum and originalRecipient.Data.Wins == 0)

assert(products.Prompt(buyer, "Cash", row, 104, buyer))
products.OnPromptFinished(buyer, 104, false)
delayed[#delayed]()
assert(profile.Data.ProductPurchases.Intent == false and disk[buyer.UserId].data.ProductPurchases.Intent == false)

-- The release hook clears a canceled intent before a reconnect reads the profile.
assert(products.Prompt(buyer, "Cash", row, 104, buyer))
products.OnPromptFinished(buyer, 104, false)
products.ClearCanceledPrompt(buyer, profile)
profile:Save()
leave(buyer)
profile = join(buyer)
assert(profile.Data.ProductPurchases.Intent == false)

-- Roblox can deliver a new receipt before the player's profile finishes loading.
assert(products.Prompt(buyer, "Cash", row, 104, buyer))
products.OnPromptFinished(buyer, 104, true)
leave(buyer)
products = loadProducts()
live[buyer.UserId] = buyer
beforeWait = function() profile = join(buyer) end
local balanceBeforeJoinReceipt = disk[buyer.UserId].data.Wins
assert(products.Process(receipt("during-join", 104)))
assert(profile.Data.Wins == balanceBeforeJoinReceipt + row.BuyNum)

assert(products.Prompt(buyer, "Cash", row, 104, buyer))
products.OnPromptFinished(buyer, 104, true)
local concurrentReceipt = receipt("queued-receipt", 104)
local queuedBalance = profile.Data.Wins
local worker = coroutine.create(function() return products.Process(concurrentReceipt) end)
local replay = coroutine.create(function() return products.Process(concurrentReceipt) end)
yieldOnWait = true
assert(coroutine.resume(worker))
assert(coroutine.resume(replay) and coroutine.status(replay) == "suspended")
local ok, granted = coroutine.resume(worker)
assert(ok and granted)
ok, granted = coroutine.resume(replay)
assert(ok and granted and profile.Data.Wins == queuedBalance + row.BuyNum)
yieldOnWait = false

print("Shared SKU reopening, safe recipient change, same-session save retry and join replay passed")


-- The dedicated path must call Roblox even when the player profile is unable to save.
checkoutFixture.SetConfigValue(nil)
paused = true
local promptStarted, savedAtStart, shownAtStart = now, saveCalls, promptCount
local writesAtStart = checkoutFixture.Writes
assert(products.Prompt(buyer, "Cash", row, 105, buyer))
assert(now == promptStarted and saveCalls == savedAtStart and promptCount == shownAtStart + 1)
assert(checkoutFixture.Writes == writesAtStart + 1, "Default checkout opens cash packs after one order write")
assert(not profile.Data.ProductPurchases.Intent, "Dedicated checkout must not write the profile intent")
products.OnPromptFinished(buyer, 105, false)
local dedicatedGiftAmount = 8_000_000
assert(products.Prompt(buyer, "Cash", row, 105, other, dedicatedGiftAmount))
products.OnPromptFinished(buyer, 105, true)
assert(not products.Process(receipt("dedicated-gift", 105)), "Keep the checkout until delivery is saved")
assert(checkoutFixture.Records["Product:1"].ReceiptId == "dedicated-gift")
paused = false
profile:Save()
leave(buyer)
profile = join(buyer)
products = loadProducts()
checkoutFixture.SetConfigValue(false)
assert(not products.Prompt(buyer, "Cash", row, 105, buyer), "Rollback must guard pending dedicated checkouts")
assert(products.Process(receipt("dedicated-gift", 105)) and products.Process(receipt("dedicated-gift", 105)))
assert(checkoutFixture.Records["Product:1"].Status == "Complete")
local count = 0
for _, order in mail[other.UserId] do
	if order.OrderId == "1_dedicated-gift" then
		count += 1
		assert(order.RecipientUserId == other.UserId and order.Amount == dedicatedGiftAmount)
	end
end
assert(count == 1, "Replay delivers the shared SKU once to the frozen recipient")

checkoutFixture.SetConfigValue(true)
local balanceBeforeDedicated = profile.Data.Wins
local selfReceipt = receipt("dedicated-self", 105)
assert(products.Prompt(buyer, "Cash", row, 105, buyer))
assert(products.Process(selfReceipt) and products.Process(selfReceipt))
assert(profile.Data.Wins == balanceBeforeDedicated + row.BuyNum)
assert(not products.Prompt(buyer, "Cash", row, 105, buyer), "Wait for the real window to close even when payment is already saved")
products.OnPromptFinished(buyer, 105, true)
assert(products.Prompt(buyer, "DoubleTrain", { Type = "GamePass", BuyNum = 1, Price = 19 }, 106, recipient))
products.OnPromptFinished(buyer, 106, true)
assert(products.Process(receipt("dedicated-pass-gift", 106)))
local grantedGift
for _, order in mail[recipient.UserId] do
	if order.OrderId == "1_dedicated-pass-gift" then
		grantedGift = order
	end
end
assert(grantedGift and grantedGift.PurchaseId == "DoubleTrain" and grantedGift.RecipientUserId == recipient.UserId)

for _, dedicated in { false, true } do
	checkoutFixture.SetConfigValue(dedicated)
	local sku = if dedicated then 108 else 107
	local cashBefore = profile.Data.Wins
	assert(products.Prompt(buyer, "WinsTier1", row, sku, buyer, 100_000))
	products.OnPromptFinished(buyer, sku, false)
	assert(products.Prompt(buyer, "WinsTier1", row, sku, buyer, 2_500_000))
	local snapshot = if dedicated then checkoutFixture.Records["Product:1"].Snapshot else profile.Data.ProductPurchases.Intent
	assert(snapshot.Amount == 2_500_000, "A changed quote must replace a canceled snapshot")
	products.OnPromptFinished(buyer, sku, true)
	local dynamicReceipt = receipt("dynamic-" .. sku, sku)
	assert(products.Process(dynamicReceipt) and products.Process(dynamicReceipt))
	assert(profile.Data.Wins == cashBefore + 2_500_000, "Receipt and replay must use the frozen quote")
end
