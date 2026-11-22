local new = require("./helpers/FishingHarness")
local h = new()
local P, C = h.progression, h.baitConfig
local function data(name)
	local f = assert(io.open("src/ReplicatedFirst/Data/" .. name .. ".lua"))
	local s = f:read("*a")
	f:close()
	return assert(loadstring(s))()
end
local fishes, rods = data("FishesData"), data("RodsData")
local function closeTo(actual, expected)
	assert(math.abs(actual - expected) < 1e-9, tostring(actual) .. " differs from " .. tostring(expected))
end

do
	local sample = { NextNumber = function() return 0.85 end }
	local pool, pity = P.BuildPool(fishes, rods.Rod_101, rods, function() return true end)
	local progress = P.Ensure({ FishingIntroVersion = 1 })
	assert(P.Choose(pool, progress, "Rod_101", pity, sample).band == 2)
	assert(P.Choose(pool, progress, "Rod_101", pity, sample, 2).band == 3)
	local state = P.GetRod(progress, "Rod_101")
	state.MissHigh = pity - 1
	local candidates = P.GetCandidates(pool, progress, "Rod_101", pity)
	local base, baseTotal = P.GetWeights(candidates)
	local boosted, boostedTotal = P.GetWeights(candidates, 2)
	for index, entry in ipairs(candidates) do
		assert(entry.band == 3)
		closeTo(base[index] / baseTotal, boosted[index] / boostedTotal)
	end
	assert(state.MissHigh == pity - 1, "Calculating odds must not advance pity")
end

for _, mode in ipairs({ "owned", "restricted", "unknown", "midCast" }) do
	local fisher = new()
	fisher.profile.Data.FishingIntroVersion = 1
	fisher.profile.Data.GamePasses = { MegaLuck = mode ~= "midCast" }
	fisher.restrictPaid, fisher.noPolicy = mode == "restricted", mode == "unknown"
	fisher.sample = 0.85
	local multiplier = if mode == "owned" then P.ULTRA_LUCK_HIGH_BAND_WEIGHT else 1
	local pool, pity = P.BuildPool(fishes, rods.Rod_101, rods, function() return true end, 1)
	local candidates = P.GetCandidates(pool, P.Ensure(fisher.profile.Data), "Rod_101", pity)
	local weights, weightTotal = P.GetWeights(candidates, multiplier)
	fisher.begin("NONE")
	local cast = fisher.castAt(1)
	assert(cast.ok and cast.odds.boosted == (mode == "owned"))
	fisher.profile.Data.GamePasses.MegaLuck = true
	fisher.advance(5)
	local first = fisher.client:NextRound(fisher.player, fisher.token, 0)
	assert(first.ok and first.odds.boosted == cast.odds.boosted)
	local total = 0
	for index, row in ipairs(first.odds.rows) do
		total += row.chance
		closeTo(row.chance, weights[index] / weightTotal)
	end
	closeTo(total, 1)
	assert((fisher.fishes[first.fishId].Index >= 7) == (mode == "owned"), mode .. " drew " .. first.fishId)
	fisher.now = first.retryAt + 0.1
	local retry = fisher.client:NextRound(fisher.player, fisher.token, first.round)
	assert(retry.ok and retry.fishId == first.fishId and retry.odds.boosted == first.odds.boosted)
	if mode == "midCast" then
		fisher.cancel()
		fisher.begin("NONE")
		assert(fisher.castAt(1).odds.boosted, "An in-session grant starts on the next cast")
	end
end
for _, rod in pairs(rods) do
	local pool, pity = P.BuildPool(fishes, rod, rods, function()
		return true
	end)
	assert(#pool == 9 or #pool == 10, "All 27 rods must have a populated same-rarity pool")
	local bandCounts, bandWeights = { 0, 0, 0 }, { 0, 0, 0 }
	local curve = P.GetCurve(rod, rods)
	local previous = 0
	for _, entry in ipairs(pool) do
		assert(entry.fish.Rarity == rod.Rarity and entry.fish.Index > previous)
		previous = entry.fish.Index
		bandCounts[entry.band] += 1
		bandWeights[entry.band] += entry.weight
	end
	assert(bandCounts[1] == 3 and bandCounts[2] == 3 and bandCounts[3] == #pool - 6)
	for i = 1, 3 do
		assert(math.abs(bandWeights[i] - curve.probabilities[i]) < 1e-10)
	end
	assert(pity >= 5 and pity <= 12)
end
for _, example in ipairs({ { "Rod_101", 12, 0.6, 0.3, 0.1 }, { "Rod_102", 5, 0.1, 0.4, 0.5 }, {
	"Rod_106",
	8,
	0.3,
	0.45,
	0.25,
} }) do
	local c = P.GetCurve(rods[example[1]], rods)
	assert(c.pity == example[2])
	for i = 1, 3 do
		assert(math.abs(c.probabilities[i] - example[i + 2]) < 1e-10)
	end
end
-- Every nonzero random sample still respects the hard pity deadline.
for _, rodId in ipairs({ "Rod_101", "Rod_102", "Rod_106" }) do
	local pool, pity = P.BuildPool(fishes, rods[rodId], rods, function()
		return true
	end)
	local progress = P.Ensure({ FishingIntroVersion = 1 })
	for i = 1, pity do
		local entry = P.Choose(pool, progress, rodId, pity, {
			NextNumber = function()
				return 0
			end,
		})
		assert((entry.band == 3) == (i == pity))
		P.Record(progress, rodId, entry.fish.FishID, entry.band, entry.isMax)
	end
	assert(progress.Rods[rodId].MissHigh == 0)
	P.GetRod(progress, "other").MissHigh = 3
	assert(P.GetRod(progress, rodId).MissHigh == 0 and progress.Rods.other.MissHigh == 3)
end
for _, sample in ipairs({ 0, 0.1, 0.59, 0.8, 0.999999 }) do
	local progress = P.Ensure({})
	local pool, pity = P.BuildPool(fishes, rods.Rod_101, rods, function()
		return true
	end)
	for count = 1, 20 do
		local entry = P.Choose(pool, progress, "Rod_101", pity, {
			NextNumber = function()
				return sample
			end,
		})
		P.Record(progress, "Rod_101", entry.fish.FishID, entry.band, entry.isMax)
		if count == 5 then
			local n = 0
			for _ in pairs(progress.Seen) do
				n += 1
			end
			assert(n >= 3)
		end
		if count == 10 then
			assert(progress.GotHigh)
		end
	end
	assert(progress.GotMax and progress.NewbieComplete)
end
for _, old in ipairs({
	{ FishingIntroVersion = 1 },
	{ TotalItemWeightTenths = 1 },
	{ Items = { old = {} } },
	{ IndexDiscoveryLog = { Fish_101 = true } },
}) do
	assert(P.Ensure(old).NewbieComplete, "Legacy players must not receive replayed onboarding")
end
assert(not P.Ensure({}).NewbieComplete)
local legacy = {
	Wins = 123,
	Items = { fish = {} },
	FishingProgress = {
		Version = 1,
		Count = 6,
		Seen = { Fish_101 = true },
		GotHigh = true,
		GotMax = false,
		NewbieComplete = false,
		Rods = {
			Rod_101 = { MissHigh = 3, Pending = { BaitId = "NONE" } },
			Rod_102 = { MissHigh = 1, Pending = { BaitId = "Bait_102" } },
		},
		Credits = { Rod_101 = 2 },
		Receipts = { receipt = "Rod_101" },
		ReceiptRevision = 2,
	},
}
local migrated = P.Ensure(legacy)
assert(migrated.Version == 2 and migrated == P.Ensure(legacy))
assert(migrated.Rods.Rod_101.Pending == nil and migrated.Rods.Rod_102.Pending == nil)
assert(migrated.Rods.Rod_101.MissHigh == 3 and migrated.Rods.Rod_102.MissHigh == 1)
assert(migrated.Count == 6 and migrated.Seen.Fish_101 and migrated.GotHigh and not migrated.NewbieComplete)
assert(migrated.Credits.Rod_101 == 2 and migrated.Receipts.receipt == "Rod_101" and migrated.ReceiptRevision == 2)
assert(legacy.Wins == 123 and legacy.Items.fish)
local ranges = h.roll.BuildMutationRanges(data("MutationsData"))
for tier, expected in ipairs({ { 7000, 2500, 500 }, { 0, 8000, 2000 }, { 0, 2000, 8000 }, { 0, 0, 10000 } }) do
	local tally = { Golden = 0, Diamond = 0, Rainbow = 0 }
	for i = 0, 9999 do
		local id = P.RollMutation(tier, C, ranges, {
			NextNumber = function()
				return (i + 0.5) / 10000
			end,
		})
		tally[id] += 1
	end
	assert(tally.Golden == expected[1] and tally.Diamond == expected[2] and tally.Rainbow == expected[3])
end
assert(P.RollMutation(0, C, ranges, {
	NextNumber = function()
		return 0.9
	end,
}) == nil)
local p = P.Ensure({})
local expectedCashMultipliers = { 0.15, 2, 25 }
for _, rod in pairs(rods) do
	for tier, baitId in ipairs(rod.BaitsSelect) do
		local q = P.Quote(rod, baitId, C)
		assert(q.tier == tier)
		if tier < 4 then
			assert(q.price == math.round(rod.Price * expectedCashMultipliers[tier]))
		else
			assert(not q.available)
		end
	end
end
assert(P.Quote(rods.Rod_101, "NONE", C).price == 0)
assert(P.Quote(rods.Rod_101, "not-allowed", C) == nil)
assert(P.GrantReceipt(p, "Rod_101", "receipt-1"))
assert(not P.GrantReceipt(p, "Rod_101", "receipt-1") and p.Credits.Rod_101 == 1)
assert(P.Quote(rods.Rod_101, rods.Rod_101.BaitsSelect[4], C, nil, p.Credits.Rod_101).available)
-- The same bait has a contextual tier determined by the current rod.
assert(P.Quote(rods.Rod_101, "Bait_104", C).tier == 2)
assert(P.Quote(rods.Rod_105, "Bait_104", C).tier == 1)
-- The fourth slot always uses the same product, including overlapping bait IDs on other rods.
local productId = h.purchaseData.PremiumBait.ProductId
local paidIds = {}
for _, rod in pairs(rods) do
	for tier, baitId in ipairs(rod.BaitsSelect) do
		local quote = P.Quote(rod, baitId, C, productId)
		assert(quote.productId == (if tier == 4 then productId else nil))
		if tier == 4 then
			assert(quote.price == 0 and quote.available)
			paidIds[baitId] = true
		end
	end
end
assert(paidIds.Bait_108 and paidIds.Bait_117)
assert(P.Quote(rods.Rod_105, "Bait_108", C, productId).price > 0)
