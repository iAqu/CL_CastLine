local function loadSource(path, env)
	local file = assert(io.open(path, "r"))
	local source = file:read("*a")
	file:close()
	return assert(load(source, path, "t", setmetatable(env or {}, { __index = getfenv() })))()
end
local function copy(value)
	if type(value) ~= "table" then
		return value
	end
	local result = {}
	for k, v in pairs(value) do
		result[k] = copy(v)
	end
	return result
end
local Config = loadSource("src/ReplicatedStorage/Modules/PaidEggConfig.lua")
local Delivery = loadSource("src/ReplicatedStorage/Modules/PaidEggDelivery.lua")
local Training = loadSource("src/ReplicatedStorage/Modules/TrainingProgress.lua")
local purchases = loadSource("src/ReplicatedFirst/Data/PurchaseData.lua")
local fishes = loadSource("src/ReplicatedFirst/Data/FishesData.lua")

local sampleOrder = { Rewards = { {ItemId = "seen"}, {ItemId = "new"}, {ItemId = "new"} } }
local preview = Delivery.Result(sampleOrder, { seen = true })
assert(not preview.NewFish[1] and preview.NewFish[2] and not preview.NewFish[3], "Mark only the first new species for the recipient")

local samples = { 0, 0.55, 0.85, 0.95, 0.995, 0.999999 }
local expected = { "Fish_001", "Fish_002", "Fish_003", "Fish_004", "Fish_005", "Fish_005" }
for i, sample in ipairs(samples) do
	local index = 0
	local reward = Config.Roll(1, 100, fishes, {
		NextNumber = function()
			index += 1
			return if index % 2 == 1 then sample else 0
		end,
	}, Training.CalculateFishWeight)[1]
	assert(reward.ItemId == expected[i] and reward.MutationId == "Golden")
	assert(reward.Weight == Training.CalculateFishWeight(fishes[reward.ItemId].DefaultWeight, 100))
end
for i, sample in ipairs({ 0, 10 / 17, 15 / 17, 0.99999 }) do
	local index = 0
	local reward = Config.Roll(1, 20, fishes, {
		NextNumber = function()
			index += 1
			return if index % 2 == 1 then 0 else sample
		end,
	}, Training.CalculateFishWeight)[1]
	assert(reward.MutationId == ({ "Golden", "Diamond", "Rainbow", "Rainbow" })[i])
	assert(reward.Weight == fishes[reward.ItemId].DefaultWeight and reward.Weight > 20, "Keep the base weight above the training cap")
end
for _, id in ipairs(Config.PurchaseOrder) do
	local row, count = Config.GetPurchase(id, purchases)
	assert(row and count == row.BuyNum and Config.FindProduct(row.ProductId, purchases) == id)
end
assert(Config.FindProduct(0, purchases) == nil)
local total = 0
for _, fish in ipairs(Config.Fish) do
	total += fish.Chance
end
assert(total == 100)
local outcomeTotal = 0
for _, fish in ipairs(Config.Fish) do
	for _, mutation in ipairs(Config.Mutations) do
		outcomeTotal += Config.GetOutcomePercent(fish, mutation)
	end
end
assert(math.abs(outcomeTotal - 100) < 1e-8)
local Layout = loadSource("src/ReplicatedStorage/Modules/PaidEggLayout.lua")
local Motion = loadSource("src/ReplicatedStorage/Modules/PaidEggMotion.lua")
local function closeEnough(actual, expected)
	assert(math.abs(actual - expected) < 1e-8, "Wrong paid egg animation key frame")
end
closeEnough(Motion.GetBurstScale(Motion.SqueezeAt), 1)
closeEnough(Motion.GetBurstScale(Motion.ExpansionAt), 0.85)
closeEnough(Motion.GetBurstScale(Motion.EggPeakAt), 1.35)
closeEnough(Motion.GetBurstScale(Motion.RevealAt), 1.35)
closeEnough(Motion.GetFishScale(0), 0.30)
closeEnough(Motion.GetFishScale(Motion.FishPeakAt), 1.16)
closeEnough(Motion.GetFishScale(Motion.FishDipAt), 0.94)
closeEnough(Motion.GetFishScale(Motion.FishSettledAt), 1)
closeEnough(Motion.GetFishScale(Motion.FishSettledAt + Motion.TurnDuration), 1)
local depth, outlinePixels = 6.6, 2
local flatFish = { Radius = math.sqrt(4.16), HorizontalRadius = 2, HalfHeight = 0.4 }
local original = depth * (105 / 600) / math.sqrt(1 + (105 / 600) ^ 2) * 0.96 / flatFish.Radius
assert(
	math.abs(Layout.GetFishScale(depth, 600, 0, 0, 240, 105, flatFish, outlinePixels) / original - 1.3) < 1e-8,
	"Fish should grow by 30 percent when the cell has room"
)

local box = { Radius = math.sqrt(4.36), HorizontalRadius = 2, HalfHeight = 0.6 }
for _, view in ipairs({ { 1440, 900, 5 }, { 390, 844, 3 } }) do
	local cells = Layout.Get(10, view[1], view[2])
	assert(#cells == 10 and cells[view[3]].Y == cells[1].Y and cells[view[3] + 1].Y > cells[1].Y)
	for i, cell in ipairs(cells) do
		assert(cell.X - cell.Width / 2 > 0 and cell.X + cell.Width / 2 < 1)
		assert(cell.Y + cell.VisualHeight + cell.CaptionHeight < 0.9)
		for j = i + 1, #cells do
			local nextCell = cells[j]
			assert(nextCell.Y ~= cell.Y or math.abs(nextCell.X - cell.X) >= cell.Width)
		end

		local focal = view[2] / (2 * math.tan(math.rad(26)))
		local x, y = (cell.X - 0.5) * view[1], (0.5 - cell.Y - cell.VisualHeight / 2) * view[2]
		local halfWidth, halfHeight = cell.Width * view[1] / 2, cell.VisualHeight * view[2] / 2
		local outlineScale = 1.045
		local scale, maxScale = Layout.GetFishScale(depth, focal, x, y, halfWidth, halfHeight, box, outlinePixels, outlineScale)
		local peak = math.min(scale * Motion.GetFishScale(Motion.FishPeakAt), maxScale) * outlineScale
		local worldShift = depth * outlinePixels / focal
		assert(scale > 0, "Fish scale must stay positive")
		for degrees = 0, 355, 5 do
			local angle = math.rad(degrees)
			local dx, dz =
				math.cos(angle) * box.HorizontalRadius * peak, math.sin(angle) * box.HorizontalRadius * peak
			local projection = focal / (depth - dz)
			assert(
				math.abs((x * depth / focal + dx) * projection - x) + worldShift * projection <= halfWidth,
				"Rotating outline crosses a column edge"
			)
			for sign = -1, 1, 2 do
				local dy = sign * box.HalfHeight * peak
				assert(
					math.abs((y * depth / focal + dy) * projection - y) + worldShift * projection <= halfHeight,
					"Rotating outline crosses a row edge"
				)
			end
		end
	end
end

-- A failed batch never publishes half an order. A late side effect cannot repeat the grant.
local data = { Items = {} }
local order =
	{ OrderId = "order", PurchaseId = "Egg_R_1x10", BuyerUserId = 1, SenderName = "Buyer", CreatedAt = 1, Rewards = {} }
for i = 1, 10 do
	order.Rewards[i] = { ItemId = "Fish_001", InstanceId = "fish:" .. i }
end
assert(not Delivery.Apply(data, order, function()
	return false, "Backpack unavailable"
end))
assert(next(data.Items) == nil and #Delivery.Pending(data) == 0)
assert(Delivery.Apply(data, order, function(rewards, commit)
	assert(#rewards == 10)
	for _, reward in ipairs(rewards) do
		data.Items[reward.InstanceId] = copy(reward)
	end
	commit()
	error("Presentation failure after commit")
end))
local _, added = Delivery.Apply(data, order, function()
	error("Duplicate grant")
end)
assert(added == false and #Delivery.Pending(data) == 1)
assert(Delivery.Acknowledge(data, "order") and Delivery.Acknowledge(data, "order"))
assert(not Delivery.Acknowledge(data, "unknown") and #Delivery.Pending(data) == 0)
assert(Delivery.Apply(data, order, function()
	error("Seen results cannot mint items")
end))
assert(#Delivery.Pending(data) == 0)

-- Mock the service boundary: all writes are in-memory, no real receipts or DataStores.
local byId, profiles, ledger, mailbox, prompts, jobs = {}, {}, {}, {}, {}, {}
local players = { PlayerRemoving = {
	Connect = function()
		return {}
	end,
} }
function players:GetPlayerByUserId(id)
	return byId[id]
end
function players:GetPlayers()
	return {}
end
local function makePlayer(id)
	local player = { UserId = id, DisplayName = "Player" .. id, Parent = players, Maximum = 100 }
	local profile = {
		Data = { Items = {}, RobuxSpent = 0 },
		IsActive = function()
			return true
		end,
	}
	byId[id], profiles[player] = player, profile
	return player, profile
end
local buyer, buyerProfile = makePlayer(1)
local friend, friendProfile = makePlayer(2)
local saveSucceeds, queueSucceeds, policyAllows = true, true, true
local saves = 0
local delayed = {}
local playerData = {}
function playerData:GetProfile(player)
	return profiles[player]
end
function playerData:SavePaidEggProfile(_player)
	saves += 1
	return saveSucceeds
end
function playerData:MarkPaidEggProfileChanged(profile)
	Delivery.Ensure(profile.Data).Revision += 1
end
function playerData:QueuePaidEggDelivery(userId, value)
	if not queueSucceeds then
		return false
	end
	mailbox[userId] = mailbox[userId] or {}
	mailbox[userId][value.OrderId] = copy(value)
	return true
end
function playerData:ClearPaidEggDelivery() end
local function signal()
	return {
		Fire = function() end,
		Connect = function()
			return { Disconnect = function() end }
		end,
	}
end
local purchaseService = { _PlayerGifted = {} }
local services = {
	PurchaseService = purchaseService,
	TrainingService = {
		GetMaxCatchWeight = function(_, target)
			return target.Maximum
		end,
	},
}
local knit = {
	CreateSignal = signal,
	CreateService = function(value)
		value.Client.Server = value
		return value
	end,
	GetService = function(name)
		return assert(services[name], name)
	end,
}
local modules = { PaidEggConfig = Config, PaidEggDelivery = Delivery, TrainingProgress = Training }
local updates = 0
local reenter
local store = {}
function store:GetAsync(key)
	return copy(ledger[key])
end
function store:UpdateAsync(key, transform)
	updates += 1
	if reenter then
		local callback = reenter
		reenter = nil
		callback()
	end
	ledger[key] = copy(transform(copy(ledger[key])))
	return copy(ledger[key])
end
local guid = 0
local grantCount = 0
local dependencies = {
	PlayerDataService = playerData,
	PurchasePersistence = { Request = function() saves += 1 end },
	PaidItemPolicy = {
		CanPurchase = function()
			return policyAllows, "Restricted"
		end,
	},
	ItemGrantUtil = {
		GrantPaidOrder = function(_, profile, rewards, orderId, commit)
			for _, reward in ipairs(rewards) do
				assert(not profile.Data.Items[reward.InstanceId])
				profile.Data.Items[reward.InstanceId] = {
					ItemId = reward.ItemId,
					Weight = reward.Weight,
					MutationId = reward.MutationId,
					PaidOrigin = orderId,
				}
			end
			grantCount += #rewards
			commit()
			return true
		end,
	},
}
local checkoutFixture, checkout
local api = {
	Players = players,
	ReplicatedFirst = { Data = { PurchaseData = purchases, FishesData = fishes } },
	ReplicatedStorage = { Modules = modules, Packages = { Knit = knit } },
	DataStoreService = {
		GetDataStore = function()
			return store
		end,
	},
	HttpService = {
		GenerateGUID = function()
			guid += 1
			return "intent-" .. guid
		end,
	},
	MarketplaceService = {
		PromptProductPurchase = function(_, player, productId)
			if checkout.WritesEnabled("Egg") then
				assert(checkoutFixture.Records["Egg:" .. player.UserId].Snapshot)
			else
				assert(Delivery.Ensure(profiles[player].Data).Intent and saves > 0)
			end
			table.insert(prompts, productId)
		end,
	},
}
checkoutFixture = require("./helpers/PurchaseCheckoutFixture")(players, api.MarketplaceService, {
	defer = function(callback, ...) callback(...) end,
	delay = function(_, callback, ...) callback(...) end,
}, function() return 1 end)
checkoutFixture.Studio = true
checkoutFixture.PlaceId = 84106335829275
checkoutFixture.StudioPaidEggOverride = false
checkout = checkoutFixture.Load()
dependencies.PurchaseCheckout = checkout
local service = loadSource("src/ServerScriptService/Services/PaidEggService.lua", {
	game = {
		GetService = function(_, name)
			return assert(api[name], name)
		end,
	},
	script = { Parent = dependencies },
	Enum = { ProductPurchaseChannel = { ExperienceDetailsPage = "Details" } },
	require = function(value)
		return value
	end,
	Random = {
		new = function()
			return {
				NextNumber = function()
					return 0
				end,
			}
		end,
	},
	task = {
		delay = function(_, callback)
			table.insert(delayed, callback)
		end,
		spawn = function(fn, ...)
			table.insert(jobs, { fn, ... })
		end,
	},
	warn = function() end,
})
services.PaidEggService = service
assert(service:IsProduct(purchases.Egg_R_1.ProductId) and not service:IsProduct(0))
policyAllows = false
assert(not service:Prompt(buyer, "Egg_R_1") and #prompts == 0)
local uncertain, uncertainProfile = makePlayer(3)
policyAllows, saveSucceeds = true, false
assert(not service:Prompt(uncertain, "Egg_R_1") and #prompts == 0)
assert(Delivery.Ensure(uncertainProfile.Data).Intent, "Unknown persistence keeps the intent reserved")
saveSucceeds = true
service:CancelPrompt(uncertain, purchases.Egg_R_1.ProductId, false)
assert(uncertainProfile.Data.PaidEgg.Intent, "Only a prompt opened in this session can be canceled")

local eggProduct = purchases.Egg_R_1.ProductId
assert(service:Prompt(buyer, "Egg_R_1"))
local reopenedIntent = buyerProfile.Data.PaidEgg.Intent
local savedBeforeCancel = saves
service:CancelPrompt(buyer, eggProduct, false)
assert(not service:ProcessReceipt({ PlayerId = 1, PurchaseId = "unexpected", ProductId = eggProduct }))
assert(service:Prompt(buyer, "Egg_R_1") and saves == savedBeforeCancel
	and buyerProfile.Data.PaidEgg.Intent == reopenedIntent, "Reopening the same SKU and recipient must skip saving")
delayed[#delayed]()
assert(buyerProfile.Data.PaidEgg.Intent == reopenedIntent, "Stale callbacks cannot clear a reopened prompt")
service:CancelPrompt(buyer, purchases.Egg_R_1.ProductId, false)
buyer.Maximum += 1
assert(service:Prompt(buyer, "Egg_R_1") and saves > savedBeforeCancel
	and buyerProfile.Data.PaidEgg.Intent.MaxWeight == buyer.Maximum, "Changed reward snapshot must be saved")
service:CancelPrompt(buyer, eggProduct, false)
purchaseService._PlayerGifted[1] = 2
local previousSaves = saves
assert(service:Prompt(buyer, "Egg_R_1") and saves > previousSaves
	and buyerProfile.Data.PaidEgg.Intent.RecipientUserId == 2, "A new recipient must be saved")
service:CancelPrompt(buyer, eggProduct, false)
delayed[#delayed]()
assert(not buyerProfile.Data.PaidEgg.Intent)

purchaseService._PlayerGifted[1] = 2
assert(service:Prompt(buyer, "Egg_R_1x3"))
local frozen = copy(buyerProfile.Data.PaidEgg.Intent)
assert(frozen.RecipientUserId == 2 and frozen.MaxWeight == 100 and not frozen.Rewards)
assert(not service:Prompt(buyer, "Egg_R_1"), "Only one unsettled paid-egg prompt per buyer")
service:CancelPrompt(buyer, purchases.Egg_R_1x3.ProductId, true)
assert(buyerProfile.Data.PaidEgg.Intent, "Prompt-finished cannot grant or consume an order")
service:CancelPrompt(buyer, purchases.Egg_R_1.ProductId, false)
assert(buyerProfile.Data.PaidEgg.Intent, "A different product cannot cancel this order")
friend.Maximum, purchaseService._PlayerGifted[1], byId[2], friend.Parent = 1000, nil, nil, nil
local receipt =
	{ PlayerId = 1, PurchaseId = "receipt-1", ProductId = purchases.Egg_R_1x3.ProductId, CurrencySpent = 199 }
queueSucceeds = false
assert(not service:ProcessReceipt(receipt))
assert(ledger["1:receipt-1"] and buyerProfile.Data.PaidEgg.Intent)
local reserved = copy(ledger["1:receipt-1"].Rewards)
queueSucceeds = true
reenter = function()
	assert(not service:ProcessReceipt(receipt), "Concurrent receipt must not enter twice")
end
assert(service:ProcessReceipt(receipt))
assert(not buyerProfile.Data.PaidEgg.Intent and buyerProfile.Data.RobuxSpent == 199)
assert(service:ProcessReceipt(receipt) and buyerProfile.Data.RobuxSpent == 199)
local sent = mailbox[2]["1:receipt-1"]
assert(sent.RecipientUserId == 2 and #sent.Rewards == 3 and #jobs == 0, "Offline recipient remains the owner")
for i, reward in ipairs(sent.Rewards) do
	assert(
		reward.Weight == reserved[i].Weight
			and reward.Weight == Training.CalculateFishWeight(fishes[reward.ItemId].DefaultWeight, 100)
	)
	assert(reward.InstanceId == reserved[i].InstanceId)
end
byId[2], friend.Parent = friend, players
saveSucceeds = false
service:_stage(friend, 7, sent)
service:_stage(friend, 7, sent)
assert(grantCount == 0 and #service.Client:GetPendingResults(friend) == 1)
assert(not service:RevealResult(buyer, sent.OrderId) and grantCount == 0)
assert(not service:RevealResult(friend, sent.OrderId))
assert(grantCount == 3 and #service.Client:GetPendingResults(friend) == 1, "Failed save leaves delivery recoverable")
assert(not service.Client:AcknowledgeResult(friend, sent.OrderId))
saveSucceeds = true
assert(service:RevealResult(friend, sent.OrderId) and grantCount == 3)
assert(service.Client:AcknowledgeResult(friend, sent.OrderId))
service:_stage(friend, 7, sent)
assert(
	service:RevealResult(friend, sent.OrderId) and grantCount == 3 and #service.Client:GetPendingResults(friend) == 0
)
for _, reward in pairs(friendProfile.Data.Items) do
	assert(reward.PaidOrigin == sent.OrderId and reward.ConditionId == nil)
end
assert(not service:ProcessReceipt({ PlayerId = 1, PurchaseId = "unmatched", ProductId = purchases.Egg_R_1.ProductId }))
assert(updates >= 2 and #prompts == 5)

checkoutFixture.StudioPaidEggOverride = nil
local staleEgg = { PlayerId = 1, PurchaseId = "old-unmatched", ProductId = receipt.ProductId }
assert(not service:ProcessReceipt(staleEgg))
saveSucceeds = false
local beforeDedicated = saves
purchaseService._PlayerGifted[1] = 2
assert(service:Prompt(buyer, "Egg_R_1x3") and saves == beforeDedicated)
assert(not buyerProfile.Data.PaidEgg.Intent)
assert(not service:ProcessReceipt(staleEgg), "A known unmatched receipt cannot claim a later checkout")
local dedicated = checkoutFixture.Records["Egg:1"]
assert(dedicated.Snapshot.RecipientUserId == 2 and dedicated.Snapshot.MaxWeight == 1000)
service:CancelPrompt(buyer, receipt.ProductId, true)
purchaseService._PlayerGifted[1] = nil
friend.Maximum = 1500
local dedicatedReceipt = { PlayerId = 1, PurchaseId = "dedicated-egg", ProductId = receipt.ProductId, CurrencySpent = 199 }
assert(not service:ProcessReceipt(dedicatedReceipt) and checkoutFixture.Records["Egg:1"].Status == "Open")
saveSucceeds = true
assert(service:ProcessReceipt(dedicatedReceipt) and service:ProcessReceipt(dedicatedReceipt))
local dedicatedDelivery = mailbox[2]["1:dedicated-egg"]
assert(dedicatedDelivery and dedicatedDelivery.MaxWeight == 1000 and buyerProfile.Data.RobuxSpent == 398)
assert(checkoutFixture.Records["Egg:1"].Status == "Complete")

-- Compare the legacy profile wait to the default production checkout for all three egg sizes.
local savePaidEggProfile = playerData.SavePaidEggProfile
local elapsed = 0
function playerData:SavePaidEggProfile(player)
	elapsed += 7
	return savePaidEggProfile(self, player)
end
checkoutFixture.StudioPaidEggOverride = false
assert(service:Prompt(buyer, "Egg_R_1", true) and elapsed == 7)
service:CancelPrompt(buyer, eggProduct, false)
delayed[#delayed]()
assert(not buyerProfile.Data.PaidEgg.Intent)
checkoutFixture.Studio = false
checkoutFixture.SetConfigValue(nil)

for _, sku in Config.PurchaseOrder do
	local row, quantity = Config.GetPurchase(sku, purchases)
	local before = #prompts
	local writesBefore = checkoutFixture.Writes
	checkoutFixture.OnUpdate = function()
		assert(#prompts == before, "Roblox must wait for the dedicated write")
		elapsed += 0.035
	end
	local started = elapsed
	assert(service:Prompt(buyer, sku, true))
	assert(math.abs(elapsed - started - 0.035) < 1e-8 and #prompts == before + 1)
	assert(checkoutFixture.Writes == writesBefore + 1, "Default egg checkout opens after one order write")
	assert(checkoutFixture.Records["Egg:1"].Snapshot.Quantity == quantity)
	checkoutFixture.OnUpdate = nil
	local snapshot = checkoutFixture.Records["Egg:1"].Snapshot
	service:CancelPrompt(buyer, row.ProductId, false)
	assert(service:Prompt(buyer, sku, true) and checkoutFixture.Records["Egg:1"].Snapshot == snapshot)
	service:CancelPrompt(buyer, row.ProductId, false)
end
playerData.SavePaidEggProfile = savePaidEggProfile

-- Policy reads fail closed; transfer checks both sides and cached entries expire.
local policyRows, clock = {}, 0
local policyCalls = 0
local yieldPolicy = false
players.PlayerAdded = signal()
local policyApi = {
	GetPolicyInfoForPlayerAsync = function(_, target)
		policyCalls += 1
		if yieldPolicy then
			coroutine.yield()
		end
		return assert(policyRows[target.UserId], "Policy unavailable")
	end,
}
local policy = loadSource("src/ServerScriptService/Services/PaidItemPolicy.lua", {
	game = {
		GetService = function(_, name)
			return if name == "Players" then players else policyApi
		end,
	},
	os = {
		clock = function()
			return clock
		end,
	},
	task = { defer = function(callback, ...)
		if type(callback) == "thread" then
			assert(coroutine.resume(callback, ...))
		else
			callback(...)
		end
	end },
})
assert(not policy.CanPurchase(buyer, friend))
policyRows[1] = { ArePaidRandomItemsRestricted = false, IsPaidItemTradingAllowed = true }
policyRows[2] = { ArePaidRandomItemsRestricted = false, IsPaidItemTradingAllowed = true }
assert(policy.CanPurchase(buyer, friend) and policy.CanTransfer(buyer, friend))
clock = 61
policyRows[2].ArePaidRandomItemsRestricted = true
assert(not policy.CanPurchase(buyer, friend))
clock = 122
policyRows[2].IsPaidItemTradingAllowed = false
assert(not policy.CanTransfer(buyer, friend))
clock, yieldPolicy = 183, true
local beforeConcurrent = policyCalls
local first = coroutine.create(function() assert(policy.Get(buyer) == policyRows[1]) end)
local second = coroutine.create(function() assert(policy.Get(buyer) == policyRows[1]) end)
assert(coroutine.resume(first) and coroutine.resume(second))
assert(coroutine.resume(first) and coroutine.status(second) == "dead" and policyCalls == beforeConcurrent + 1)
print("Paid egg probability, frozen intents, durable delivery, receipt replay, cancellation and policy tests passed")
