local file = assert(io.open("src/ReplicatedStorage/Modules/PetInventory.lua", "r"))
local source = file:read("*a")
file:close()
local inventory = assert(loadstring(source))()
local configs = { A = { LuckBoost = 2 }, B = { LuckBoost = 3.5 } }
local function data()
	return { Pets = {}, PetIndex = { Historical = true } }
end
local function add(d, id, uuid, size, equipped, locked)
	local pet = assert(inventory.Give(d, configs, id, uuid))
	pet.Size, pet.Equipped, pet.Locked = size or 0, equipped == true, locked == true
	return pet
end
assert(type(inventory.Craft) == "function", "Pet inventory must implement authoritative crafting")
local d = data()
local base = add(d, "A", "base", 0, true)
add(d, "A", "a-equipped", 0, true)
add(d, "A", "b-free", 0)
add(d, "A", "c-free", 0)
add(d, "A", "locked", 0, false, true)
assert(inventory.GetCraftCount(d, base) == 4, "Locked pets must not count as materials")
assert(inventory.Craft(d, "base", 0))
assert(
	d.Pets.base == base and base.UUID == "base" and base.Equipped and base.Size == 1,
	"Keep the base UUID and equipped state"
)
assert(
	d.Pets["a-equipped"] and d.Pets.locked and not d.Pets["b-free"] and not d.Pets["c-free"],
	"Consume unequipped materials first"
)
assert(d.PetIndex.Historical and d.PetIndex.A, "Crafting must retain historical discovery")
assert(
	inventory.GetLuckBoost(base, configs) == 3 and inventory.GetModelScale(base) == 1.5,
	"Big must use WR multipliers"
)
assert(inventory.GetLuckMultiplier(d, configs) == 6, "Fish luck includes actual size boosts")
local before = inventory.Count(d.Pets)
assert(not inventory.Craft(d, "base", 0), "A stale retry must not perform another upgrade")
assert(not inventory.Craft(d, "base", 1), "Not enough Big pets")
assert(not inventory.Craft(d, "locked", 0), "Locked bases cannot craft")
assert(inventory.Count(d.Pets) == before, "Rejected requests cannot consume anything")
add(d, "A", "big-1", 1)
add(d, "A", "big-2", 1)
assert(inventory.Craft(d, "base", 1) and base.Size == 2, "Three Big pets must craft into Huge")
assert(
	inventory.GetLuckBoost(base, configs) == 4 and inventory.GetModelScale(base) == 2.2,
	"Huge must use WR multipliers"
)
assert(not inventory.Craft(d, "base", 2), "Huge is the final tier")
local bulk = data()
for n = 1, 9 do
	add(bulk, "A", string.format("a-%02d", n), 0, n == 9)
end
add(bulk, "A", "a-locked", 0, false, true)
add(bulk, "B", "b-one", 0)
assert(inventory.CraftAll(bulk) == 4, "Nine Babies must chain through three Big crafts to one Huge")
assert(bulk.Pets["a-09"].Size == 2 and bulk.Pets["a-09"].Equipped, "Prefer an equipped survivor in bulk crafting")
assert(
	inventory.Count(bulk.Pets) == 3 and bulk.Pets["a-locked"] and bulk.Pets["b-one"],
	"Bulk cannot mix IDs or consume locked pets"
)
assert(inventory.CraftAll(bulk) == 0, "Repeating Craft All cannot consume any more pets")
add(bulk, "B", "b-two", 0)
add(bulk, "B", "b-three", 0)
assert(inventory.CraftAll(bulk) == 1 and bulk.Pets["b-one"].Size == 1, "Use stable UUID order for equal candidates")
inventory.EquipBest(bulk, configs)
assert(bulk.Pets["b-one"].Equipped, "Best equip must accept crafted pets")
local migrated = data()
migrated.Pets = {
	old = { PetID = "A" },
	big = { PetID = "A", Size = 1 },
	high = { PetID = "A", Size = 3 },
	invalid = { PetID = "A", Size = 0 / 0 },
}
inventory.Reconcile(migrated, configs)
assert(
	migrated.Pets.old.Size == 0
		and migrated.Pets.big.Size == 1
		and migrated.Pets.high.Size == 2
		and migrated.Pets.invalid.Size == 0,
	"Reconcile missing, valid, out-of-range and non-finite legacy sizes"
)
local full = data()
for n = 1, 100 do
	add(full, "A", string.format("%03d", n), 0)
end
assert(inventory.Craft(full, "001", 0) and inventory.Count(full.Pets) == 98, "A full backpack can still craft")
local ranking = data()
add(ranking, "A", "huge", 2)
add(ranking, "B", "baby-1", 0)
add(ranking, "B", "baby-2", 0)
add(ranking, "B", "baby-3", 0)
inventory.EquipBest(ranking, configs)
assert(ranking.Pets.huge.Equipped and not ranking.Pets["baby-3"].Equipped, "Best equip must sort by size-adjusted luck")
