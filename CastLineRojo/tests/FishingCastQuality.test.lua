local new = require("./helpers/FishingHarness")
local feedbackHarness = require("./helpers/FishingCastFeedbackHarness")
local C = feedbackHarness.config
local cases = {
	{ 0, "BAD" },
	{ 0.499999, "BAD" },
	{ 0.5, "GOOD" },
	{ 0.799999, "GOOD" },
	{ 0.8, "PERFECT" },
	{ 0.95, "PERFECT" },
	{ 0.950001, "GODLIKE" },
	{ 1, "GODLIKE" },
}
for _, case in ipairs(cases) do
	assert(C.GetCastRating(case[1]).Id == case[2])
	local h = new()
	h.begin("NONE")
	local response = h.client:Cast(h.player, h.token, case[1])
	assert(response.ok and response.castRating == case[2])
	assert(not h.client:Cast(h.player, h.token, 1 - case[1]).ok, "An accepted cast cannot change grade")
	h.now += 5
	local r = h.client:NextRound(h.player, h.token, 0)
	assert(r.ok and r.castRating == case[2])
	h.now = r.retryAt + 0.1
	local retry = h.client:NextRound(h.player, h.token, 1)
	assert(retry.ok and retry.fishId == r.fishId and retry.castRating == r.castRating)
end
local missing = new()
missing.begin("NONE")
assert(not missing.client:Cast(missing.player, missing.token).ok, "Missing progress is invalid")
local h = new()
local P = h.progression
local expected = {
	{ p = 0, rows = { { 0.8, 0.18, 0.02 }, { 0.65, 0.3, 0.05 }, { 0.5, 0.4, 0.1 } } },
	{ p = 0.5, rows = { { 0.7, 0.25, 0.05 }, { 0.45, 0.4, 0.15 }, { 0.25, 0.45, 0.3 } } },
	{ p = 0.8, rows = { { 0.6, 0.3, 0.1 }, { 0.3, 0.45, 0.25 }, { 0.1, 0.4, 0.5 } } },
}
for _, group in ipairs(expected) do
	for i, id in ipairs({ "Rod_105", "Rod_106", "Rod_107" }) do
		local curve = P.GetCurve(h.rods[id], h.rods, group.p)
		for j = 1, 3 do
			assert(math.abs(curve.probabilities[j] - group.rows[i][j]) < 1e-10)
		end
		assert(curve.pity == ({ 12, 8, 5 })[i])
	end
	for _, rod in pairs(h.rods) do
		local pool, pity = P.BuildPool(h.fishes, rod, h.rods, function()
			return true
		end, group.p)
		if #pool == 0 then
			continue
		end
		local sums = { 0, 0, 0 }
		for _, entry in ipairs(pool) do
			sums[entry.band] += entry.weight
			assert(entry.fish.Rarity == rod.Rarity)
		end
		local total = 0
		for _, v in ipairs(sums) do
			total += v
		end
		assert(math.abs(total - 1) < 1e-10)
		local progress = P.Ensure({ FishingIntroVersion = 1 })
		for catch = 1, pity do
			local entry = P.Choose(pool, progress, rod.RodID, pity, {
				NextNumber = function()
					return 0
				end,
			})
			assert((entry.band == 3) == (catch == pity), "Even BAD must receive the existing pity")
			P.Record(progress, rod.RodID, entry.fish.FishID, entry.band, entry.isMax)
		end
	end
end
for _, rod in pairs(h.rods) do
	local perfect = P.GetCurve(rod, h.rods, 0.8)
	for _, value in ipairs({ 0.95, 0.950001, 1 }) do
		local other = P.GetCurve(rod, h.rods, value)
		for j = 1, 3 do
			assert(other.probabilities[j] == perfect.probabilities[j])
		end
	end
end
local one = { RodID = "one", Rarity = "Common", LayoutOrder = 1 }
assert(P.GetCurve(one, { one }, 0).probabilities[1] == 0.8)
local peers = {}
for i = 1, 5 do
	peers[i] = { RodID = tostring(i), Rarity = "Common", LayoutOrder = i }
end
local quarter = P.GetCurve(peers[2], peers, 0.5)
assert(math.abs(quarter.probabilities[1] - 0.575) < 1e-10 and quarter.pity == 10)
-- The fish/rod can change the outcome; bait mutation and training still use their existing algorithms.
local saved
for _, value in ipairs({ 0, 0.5, 0.8, 1 }) do
	local fixture = new()
	fixture.assets.GetFish = function(model)
		return model == "Fish_103"
	end
	fixture.begin("Bait_102")
	assert(fixture.client:Cast(fixture.player, fixture.token, value).ok)
	fixture.now += 5
	fixture.round = fixture.client:NextRound(fixture.player, fixture.token, 0)
	assert(fixture.hook().ok)
	local result = { fixture.lastOptions.Weight, fixture.lastOptions.MutationId }
	if saved then
		assert(result[1] == saved[1] and result[2] == saved[2])
	else
		saved = result
	end
end
for _, case in ipairs(cases) do
	local owner = feedbackHarness.attach({})
	local F = feedbackHarness.feedback
	F.Show(owner, C.GetCastRating(case[1]), 10)
	assert(owner.popup.Text == C.GetCastRating(case[1]).Text)
	assert(owner.popupScale.Scale == 0.3 and not owner.meter.prompt.Visible)
	if case[2] == "GODLIKE" then
		assert(owner.meterFeedback.gradient.Enabled and #owner.meterFeedback.gradient.Color == 7)
	else
		assert(owner.meterFeedback.gradient == nil)
	end
	for _, time in ipairs({ 10, 10.3, 10.899, 10.9, 11.049, 11.05, 11.199, 11.2, 11.49, 11.5 }) do
		F.Update(owner, time)
		assert(owner.meter.gui.Enabled == (time < 11.2))
		assert(owner.popup.Visible == (time < 11.5))
		if time <= 11.05 then
			assert(math.abs(owner.popup.TextTransparency) < 1e-10)
		end
	end
	local gradient = owner.meterFeedback.gradient
	F.Destroy(owner)
	if gradient then
		assert(gradient.Parent == nil)
	end
	local before = owner.popup.Visible
	F.Update(owner, 12)
	assert(
		owner.meterFeedback == nil and owner.popup.Visible == before,
		"No delayed work may resurrect destroyed feedback"
	)
	for _, original in ipairs(owner.originals) do
		original.instance[original.property] = original.value
	end
	assert(owner.meter.marker.BackgroundTransparency == 0.2 and owner.meter.holder.BackgroundTransparency == 0.2)
end
