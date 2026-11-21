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
local function join(player)
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

local stores = {
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
		assert(disk[buyer.UserId].data.ProductPurchases.Intent, "Intent must be saved before prompting")
	end},
}

local function loadProducts()
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
assert(products.Prompt(buyer, "Cash", row, 101, recipient))
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
assert(receivingProfile.Data.Wins == 50000 and disk[2].data.Wins == 50000 and next(mail[2]) == nil)
mail[2][giftId] = queued
leave(recipient)
receivingProfile = join(recipient)
products = loadProducts()
products.Watch(recipient, function() end)
assert(receivingProfile.Data.Wins == 50000 and next(mail[2]) == nil, "Duplicate mailbox delivery is idempotent")

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
