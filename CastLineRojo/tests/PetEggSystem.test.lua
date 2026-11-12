local function loadSource(path, environment)
	local file = assert(io.open(path, "r"))
	local source = file:read("*a")
	file:close()
	return assert(load(source, path, "t", environment or getfenv()))()
end

local root = "src/ReplicatedStorage/Modules/"
local pets = loadSource(root .. "PetInventory.lua")
local eggs = loadSource(root .. "EggInventory.lua")
local placement = loadSource(root .. "EggPlacementUtil.lua")
local configs = {
	A = { LuckBoost = 1.1 },
	B = { LuckBoost = 2 },
	C = { LuckBoost = 0.5 },
	D = { LuckBoost = 6.5 },
}
local data = { Pets = {}, PetIndex = {}, Eggs = {} }
assert(pets.Give(data, configs, "A", "a").Equipped)
assert(not pets.Give(data, configs, "B", "b").Equipped)
assert(pets.Equip(data, "b", true))
assert(math.abs(pets.GetLuckMultiplier(data, configs) - 4.1) < 1e-12)
assert(pets.Give(data, configs, "C", "c"))
assert(pets.Give(data, configs, "D", "d"))
assert(pets.Equip(data, "c", true))
assert(not pets.Equip(data, "d", true), "Enforce the equipment limit")
pets.EquipBest(data, configs)
assert(data.Pets.d.Equipped and data.Pets.b.Equipped and data.Pets.a.Equipped and not data.Pets.c.Equipped)
data.Pets.a.Locked = true
assert(not pets.Delete(data, "a"), "Locked pets survive deletion")
assert(pets.Delete(data, "b") and data.PetIndex.B, "Discovery survives pet deletion")
for index = pets.Count(data.Pets) + 1, 100 do
	assert(pets.Give(data, configs, "A", tostring(index)))
end
assert(not pets.Give(data, configs, "A", "overflow"), "Enforce storage capacity")
data.Pets.invalid = { PetID = "Missing" }
pets.Reconcile(data, configs)
assert(not data.Pets.invalid)

for index = 1, 31 do
	data.Eggs[tostring(index)] = { EggId = "Draw001" }
end
for index = 1, 30 do
	assert(eggs.Place(data.Eggs, tostring(index), index, 0, 0, 1000, 10))
end
assert(not eggs.Place(data.Eggs, "31", 0, 0, 0, 1000, 10))
assert(not eggs.Place(data.Eggs, "1", 0, 0, 0, 1000, 10), "An egg cannot be placed twice")
assert(not eggs.IsReady(data.Eggs["1"], 1009.99))
assert(eggs.IsReady(data.Eggs["1"], 1010), "Exact completion timestamp is ready")
assert(eggs.IsReady(data.Eggs["2"], 5000), "Elapsed offline time counts")
assert(eggs.Pickup(data.Eggs, "1", 1004))
assert(data.Eggs["1"].RemainingSeconds == 6)
assert(eggs.Place(data.Eggs, "1", 0, 0, 0, 2000, 10))
assert(data.Eggs["1"].Placement.ReadyAt == 2006, "Pickup pauses rather than resets the timer")
assert(eggs.Pickup(data.Eggs, "1", 3000))
assert(eggs.Place(data.Eggs, "1", 0, 0, 0, 4000, 10))
assert(eggs.IsReady(data.Eggs["1"], 4000), "Ready eggs stay ready after pickup")
assert(not eggs.IsReady(nil, 5000), "Consumed eggs cannot be claimed again")
assert(placement.Check(0, 0, 2, 5, 5, {}))
assert(placement.Check(3, 3, 2, 5, 5, {}), "Allow a full footprint exactly on the boundary")
assert(not placement.Check(3.01, 0, 2, 5, 5, {}))
assert(not placement.Check(0 / 0, 0, 2, 5, 5, {}))
assert(not placement.Check(0, 0, 2, 5, 5, { { X = 4, Z = 0, Radius = 2 } }))

local egg = {
	PetId1 = "A",
	Chance1 = 5500,
	PetId2 = "B",
	Chance2 = 2800,
	PetId3 = "C",
	Chance3 = 1600,
	PetId4 = "D",
	Chance4 = 99,
	PetId5 = "E",
	Chance5 = 1,
	PetId6 = "nil",
	Chance6 = 0,
}
for _, sample in ipairs({ { 0, "A" }, { 0.55, "B" }, { 0.83, "C" }, { 0.99, "D" }, { 0.9999, "E" } }) do
	assert(eggs.ChoosePet(egg, {
		NextNumber = function()
			return sample[1]
		end,
	}) == sample[2])
end

local config = loadSource(root .. "FishingConfig.lua")
local roll = loadSource(
	root .. "FishingRoll.lua",
	setmetatable({
		script = { Parent = { FishingConfig = config, PetFeatureConfig = { Enabled = true }, RarityConfig = {} } },
		require = function(value)
			return value
		end,
	}, { __index = getfenv() })
)
local fishPool = { { fish = { FishID = "F1", LuckExponent = 0 }, weight = 1 }, {
	fish = { FishID = "F2", LuckExponent = 1 },
	weight = 1,
} }
local eggPool = { { fish = { EggId = "E1", LuckExponent = 0 }, weight = 1 }, {
	fish = { EggId = "E2", LuckExponent = 1 },
	weight = 1,
} }
local function choose(category, luck, petLuck, entry)
	local calls = 0
	local kind, item = roll.ChooseCatch(fishPool, eggPool, luck, petLuck, {
		NextNumber = function()
			calls += 1
			return if calls == 1 then category else entry
		end,
	})
	assert(calls == 2, "Category and species use independent draws")
	return kind, item
end
for _, multiplier in ipairs({ 1, 4.1, 1000 }) do
	assert(choose(0.099999, 1, multiplier, 0.1) == "Egg")
	assert(choose(0.1, 1, multiplier, 0.1) == "Fish")
end
local _, lowEgg = choose(0.05, 1, 1000, 0.4)
local _, highEgg = choose(0.05, 10, 1, 0.4)
assert(lowEgg.EggId == "E1" and highEgg.EggId == "E2", "Base luck affects egg species")
local _, sameEgg = choose(0.05, 1, 1, 0.4)
assert(sameEgg == lowEgg, "Pet luck does not affect egg species")
local _, lowFish = choose(0.5, 1, 1, 0.4)
local _, highFish = choose(0.5, 1, 10, 0.4)
assert(lowFish.FishID == "F1" and highFish.FishID == "F2", "Pet luck affects fish species")

local petData = loadSource("src/ReplicatedFirst/Data/PetsData.lua")
local eggData = loadSource("src/ReplicatedFirst/Data/EggsData.lua")
assert(pets.Count(petData) == 140 and pets.Count(eggData) == 29)
local memberships = 0
for _, pet in pairs(petData) do
	assert(type(pet.IconId) == "number")
	memberships += #pet.LocatedEggs
end
assert(memberships == 145)
for _, entry in pairs(eggData) do
	assert(entry.HatchTime == 10 and entry.ModelDefaultScale > 0)
	assert(entry.RollWeight == (if entry.EggId == "Draw001" then 1000 else 0))
	for slot = 1, 5 do
		assert(petData[entry["PetId" .. slot]])
	end
end
