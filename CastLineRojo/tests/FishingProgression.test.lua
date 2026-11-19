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
for _, rod in pairs(rods) do
	for tier, baitId in ipairs(rod.BaitsSelect) do
		local q = P.Quote(rod, baitId, C, p)
		assert(q.tier == tier)
		if tier < 4 then
			assert(q.price == math.round(rod.Price * C.CashMultipliers[tier]))
		else
			assert(not q.available)
		end
	end
end
assert(P.Quote(rods.Rod_101, "NONE", C, p).price == 0)
assert(P.Quote(rods.Rod_101, "not-allowed", C, p) == nil)
assert(P.GrantReceipt(p, "Rod_101", "receipt-1"))
assert(not P.GrantReceipt(p, "Rod_101", "receipt-1") and p.Credits.Rod_101 == 1)
assert(P.Quote(rods.Rod_101, rods.Rod_101.BaitsSelect[4], C, p).available)
-- The same bait has a contextual tier determined by the current rod.
assert(P.Quote(rods.Rod_101, "Bait_104", C, p).tier == 2)
assert(P.Quote(rods.Rod_105, "Bait_104", C, p).tier == 1)
-- Premium bait is consumed once on success, and is preserved after a failed grant.
local paid = new()
paid.baitConfig.ProductIds.Rod_101 = 123456
paid.begin()
local r = paid.client:SelectBait(paid.player, paid.token, "Bait_108")
assert(r.needsPurchase and r.productId == 123456 and not r.ok)
local pp = P.Ensure(paid.profile.Data)
P.GrantReceipt(pp, "Rod_101", "paid-1")
assert(paid.client:SelectBait(paid.player, paid.token, "Bait_108").ok)
paid.cast()
paid.failGrant = true
assert(not paid.hook().ok and pp.Credits.Rod_101 == 1)
paid.failGrant = false
assert(paid.hook().mutationId == "Rainbow" and pp.Credits.Rod_101 == 0)
assert(not paid.hook().ok and pp.Credits.Rod_101 == 0)
