-- Pure probability and profile transitions; only successful grants advance progress.
local Config = require(script.Parent.FishingConfig)
local Progression = {}

function Progression.GetCurve(rod, rods, castProgress: number?)
	local rating = Config.GetCastRating(castProgress)
	local curves = Config.Meter.ProbabilityCurves[rating.ProbabilityGrade]
	local peers = {}
	for _, candidate in pairs(rods) do
		if candidate.Rarity == rod.Rarity then
			table.insert(peers, candidate)
		end
	end
	table.sort(peers, function(a, b)
		if a.LayoutOrder == b.LayoutOrder then
			return a.RodID < b.RodID
		end
		return a.LayoutOrder < b.LayoutOrder
	end)
	local rank = 1
	for i, candidate in ipairs(peers) do
		if candidate.RodID == rod.RodID then
			rank = i
			break
		end
	end
	local position = if #peers > 1 then (rank - 1) / (#peers - 1) else 0
	local segment = if position <= 0.5 then 1 else 2
	local alpha = if segment == 1 then position * 2 else (position - 0.5) * 2
	local result = {}
	for i = 1, 4 do
		result[i] = curves[segment][i] * (1 - alpha) + curves[segment + 1][i] * alpha
	end
	return { probabilities = { result[1], result[2], result[3] }, pity = math.round(result[4]) }
end

function Progression.BuildPool(fishes, rod, rods, hasModel, castProgress: number?)
	local sorted = {}
	for _, fish in pairs(fishes) do
		if fish.Rarity ~= "Event" and fish.Rarity == rod.Rarity and hasModel(fish.Model) then
			table.insert(sorted, fish)
		end
	end
	table.sort(sorted, function(a, b)
		if a.Index == b.Index then
			return a.FishID < b.FishID
		end
		return a.Index < b.Index
	end)
	local curve = Progression.GetCurve(rod, rods, castProgress)
	local pool, groups = {}, { {}, {}, {} }
	local lowEnd, midEnd = math.floor(#sorted / 3), math.floor(#sorted * 2 / 3)
	for i, fish in ipairs(sorted) do
		local band = if i <= lowEnd then 1 elseif i <= midEnd then 2 else 3
		local group = groups[band]
		local entry = { fish = fish, band = band, rank = #group + 1, isMax = i == #sorted }
		table.insert(group, entry)
		table.insert(pool, entry)
	end
	for band, group in ipairs(groups) do
		local total = #group * (#group + 1) / 2
		for _, entry in ipairs(group) do
			entry.weight = curve.probabilities[band] * entry.rank / total
		end
	end
	return pool, curve.pity
end

function Progression.Ensure(data, hasPriorSession)
	if type(data.FishingProgress) ~= "table" then
		local played = hasPriorSession == true
			or (data.FishingIntroVersion or 0) > 0
			or (data.TotalItemWeightTenths or 0) > 0
			or next(data.IndexDiscoveryLog or {}) ~= nil
			or next(data.Items or {}) ~= nil
		data.FishingProgress = {
			Version = 2,
			Count = 0,
			Seen = {},
			GotHigh = false,
			GotMax = false,
			NewbieComplete = played,
			Rods = {},
			Credits = {},
			Receipts = {},
		}
	end
	local progress = data.FishingProgress
	if progress.Version == 1 then
		for _, rod in pairs(progress.Rods) do
			rod.Pending = nil
		end
		progress.Version = 2
	end
	return progress
end

function Progression.GetRod(progress, rodId)
	if not progress.Rods[rodId] then
		progress.Rods[rodId] = { MissHigh = 0 }
	end
	return progress.Rods[rodId]
end

function Progression.Choose(pool, progress, rodId, pity, random)
	local state = Progression.GetRod(progress, rodId)
	local forceMax, forceHigh, forceNew = false, state.MissHigh >= pity - 1, false
	if not progress.NewbieComplete then
		local distinct = 0
		for _, seen in pairs(progress.Seen) do
			if seen then
				distinct += 1
			end
		end
		forceMax = progress.Count >= 19 and not progress.GotMax
		forceHigh = forceHigh or (progress.Count >= 9 and not progress.GotHigh)
		forceNew = distinct < 3 and 5 - progress.Count <= 3 - distinct
	end
	-- Intersect requirements when possible, then prioritize the milestone with the deadline.
	local candidates = {}
	for _, entry in ipairs(pool) do
		if
			(not forceMax or entry.isMax)
			and (not forceHigh or entry.band == 3)
			and (not forceNew or not progress.Seen[entry.fish.FishID])
		then
			table.insert(candidates, entry)
		end
	end
	if #candidates == 0 then
		for _, entry in ipairs(pool) do
			if
				(forceMax and entry.isMax)
				or (not forceMax and forceNew and not progress.Seen[entry.fish.FishID])
				or (not forceMax and not forceNew and forceHigh and entry.band == 3)
			then
				table.insert(candidates, entry)
			end
		end
	end
	local total = 0
	for _, entry in ipairs(candidates) do
		total += entry.weight
	end
	if total <= 0 then
		return nil
	end
	local sample = random:NextNumber() * total
	for _, entry in ipairs(candidates) do
		sample -= entry.weight
		if sample < 0 then
			return entry
		end
	end
	return candidates[#candidates]
end

function Progression.Record(progress, rodId, fishId, band, isMax)
	local rod = Progression.GetRod(progress, rodId)
	rod.MissHigh = if band == 3 then 0 else rod.MissHigh + 1
	if not progress.NewbieComplete then
		progress.Count += 1
		progress.Seen[fishId] = true
		progress.GotHigh = progress.GotHigh or band == 3
		progress.GotMax = progress.GotMax or isMax == true
		if progress.Count >= 20 then
			progress.NewbieComplete = true
		end
	end
end

function Progression.Quote(rod, baitId, config, productId, credits)
	local tier = if baitId == "NONE" then 0 else table.find(rod.BaitsSelect, baitId)
	if not tier or tier > config.PaidTier then
		return nil
	end
	local isPaid = tier == config.PaidTier
	return {
		baitId = baitId,
		tier = tier,
		price = if tier > 0 and not isPaid then math.round(rod.Price * config.CashMultipliers[tier]) else 0,
		productId = if isPaid then productId else nil,
		credits = if isPaid then credits or 0 else 0,
		available = not isPaid or (credits or 0) > 0 or productId ~= nil,
	}
end

function Progression.RollMutation(tier, config, ranges, random)
	local weights = config.MutationWeights[tier]
	local sample = random:NextNumber()
	if weights then
		local cumulative = 0
		for _, id in ipairs({ "Golden", "Diamond", "Rainbow" }) do
			cumulative += weights[id] / 100
			if sample < cumulative then
				return id
			end
		end
		return "Rainbow"
	end
	for _, range in ipairs(ranges) do
		if sample < range.upperBound then
			return range.mutationId
		end
	end
	return nil
end

function Progression.GrantReceipt(progress, rodId, purchaseId)
	if progress.Receipts[purchaseId] then
		return false
	end
	progress.Receipts[purchaseId] = rodId
	progress.Credits[rodId] = (progress.Credits[rodId] or 0) + 1
	return true
end

return Progression
