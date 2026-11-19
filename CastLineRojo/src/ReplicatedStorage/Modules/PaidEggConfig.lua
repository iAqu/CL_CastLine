local Config = { Version = 1 }

Config.Purchases = { Egg_R_1 = 1, Egg_R_1x3 = 3, Egg_R_1x10 = 10 }
Config.PurchaseOrder = { "Egg_R_1", "Egg_R_1x3", "Egg_R_1x10" }
Config.Fish = {
	{ Id = "Fish_001", Card = "NeonCyber", Chance = 55 },
	{ Id = "Fish_002", Card = "Flamingo", Chance = 30 },
	{ Id = "Fish_003", Card = "HellShark", Chance = 10 },
	{ Id = "Fish_004", Card = "UndeadMegalodon", Chance = 4.5 },
	{ Id = "Fish_005", Card = "GalaxyMegalodon", Chance = 0.5 },
}
Config.Mutations = {
	{ Id = "Golden", Weight = 10 },
	{ Id = "Diamond", Weight = 5 },
	{ Id = "Rainbow", Weight = 2 },
}

function Config.GetPurchase(purchaseId, purchases)
	local quantity = Config.Purchases[purchaseId]
	local row = quantity and purchases[purchaseId]
	if
		row
		and row.Type == "Hatch"
		and row.BuyNum == quantity
		and type(row.ProductId) == "number"
		and row.ProductId > 0
	then
		return row, quantity
	end
	return nil
end

function Config.FindProduct(productId, purchases)
	for _, id in ipairs(Config.PurchaseOrder) do
		local row = Config.GetPurchase(id, purchases)
		if row and row.ProductId == productId then
			return id
		end
	end
	return nil
end

local function choose(entries, field, total, sample)
	local bound = sample * total
	local cumulative = 0
	for _, entry in ipairs(entries) do
		cumulative += entry[field]
		if bound < cumulative then
			return entry.Id
		end
	end
	return entries[#entries].Id
end

function Config.Roll(quantity, maximum, fishes, random, calculateWeight, snapshot)
	assert(quantity == 1 or quantity == 3 or quantity == 10, "Invalid paid egg quantity")
	local fishPool = if snapshot then snapshot.Fish else Config.Fish
	local mutations = if snapshot then snapshot.Mutations else Config.Mutations
	local mutationTotal = 0
	for _, mutation in ipairs(mutations) do
		mutationTotal += mutation.Weight
	end
	local rewards = {}
	for index = 1, quantity do
		local fishId = choose(fishPool, "Chance", 100, random:NextNumber())
		local mutationId = choose(mutations, "Weight", mutationTotal, random:NextNumber())
		local fish = assert(fishes[fishId], "Paid egg fish is unavailable")
		rewards[index] = {
			ItemId = fishId,
			Weight = calculateWeight(fish.DefaultWeight, maximum),
			MutationId = mutationId,
		}
	end
	return rewards
end

function Config.GetOutcomePercent(fish, mutation)
	local total = 0
	for _, entry in ipairs(Config.Mutations) do
		total += entry.Weight
	end
	return fish.Chance * mutation.Weight / total
end

return Config
