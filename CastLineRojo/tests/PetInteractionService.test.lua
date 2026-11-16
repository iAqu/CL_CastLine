local function read(path)
	local f = assert(io.open(path, "r"))
	local source = f:read("*a")
	f:close()
	return source
end
local inventory = assert(loadstring(read("src/ReplicatedStorage/Modules/PetInventory.lua")))()
local owner, stranger = { UserId = 1 }, { UserId = 2 }
local profiles = {
	[owner] = { Data = { Pets = {}, PetIndex = {} } },
	[stranger] = { Data = { Pets = {}, PetIndex = {} } },
}
local configs = { A = { LuckBoost = 2 }, B = { LuckBoost = 3 } }
local pets = profiles[owner].Data.Pets
for _, uuid in ipairs({ "equipped", "locked", "free", "raceEquip", "raceLock" }) do
	assert(inventory.Give(profiles[owner].Data, configs, "A", uuid))
end
pets.locked.Locked = true
assert(inventory.Give(profiles[stranger].Data, configs, "B", "foreign"))
local deliveries, rosters = {}, {}
local knit = {
	CreateService = function(spec)
		spec.Client.Server = spec
		return spec
	end,
	CreateSignal = function()
		return {
			Fire = function(_, player, state)
				table.insert(deliveries, { player = player, state = state })
			end,
			FireAll = function(_, id, roster)
				table.insert(rosters, { id = id, roster = roster })
			end,
		}
	end,
}
local services = {
	Players = {},
	HttpService = {},
	ReplicatedFirst = { Data = { PetsData = configs } },
	ReplicatedStorage = { Packages = { Knit = knit }, Modules = { PetInventory = inventory, PetFeatureConfig = { Enabled = true } } },
}
local chunk = assert(loadstring(read("src/ServerScriptService/Services/PetService.lua")))
setfenv(
	chunk,
	setmetatable({
		game = {
			GetService = function(_, name)
				return assert(services[name], name)
			end,
		},
		script = {
			Parent = { PlayerDataService = {
				GetProfile = function(_, player)
					return profiles[player]
				end,
			} },
		},
		require = function(value)
			return value
		end,
	}, { __index = getfenv() })
)
local service = chunk()
local client = service.Client
local function unchanged()
	assert(pets.locked.Locked and not pets.free.Locked, "Rejected batch must not partially lock or unlock")
	assert(#deliveries == 0 and #rosters == 0, "Rejected requests cannot publish mutations")
end
for _, request in ipairs({
	"free",
	{ 1 },
	{ "free", "foreign" },
	{ "missing" },
	{ [1] = "free", [3] = "locked" },
	{ field = "free" },
}) do
	assert(not client:LockPets(owner, request).ok, "Malformed and foreign lock selections must fail")
	unchanged()
end
local overflow = table.create(101, "free")
assert(not client:LockPets(owner, overflow).ok)
assert(not client:LockPets({}, {}).ok, "Unloaded profiles must fail")
assert(not client:LockPets(stranger, { "free" }).ok, "Cannot lock another inventory")
unchanged()
local luckBefore = service:GetLuckMultiplier(owner)
assert(client:LockPets(owner, { "free", "equipped" }).ok)
assert(pets.free.Locked and pets.equipped.Locked and not pets.locked.Locked, "Replace complete lock selection")
assert(#deliveries == 1 and deliveries[1].player == owner and #rosters == 1, "One inventory publication per batch")
assert(deliveries[1].state.Pets.free.Locked, "Publish committed lock state")
assert(service:GetLuckMultiplier(owner) == luckBefore, "Locking cannot change Luck")
assert(client:LockPets(owner, {}).ok, "Empty selection unlocks all owned pets")
assert(not pets.free.Locked and not pets.equipped.Locked)
assert(not client:LockPet(owner, "foreign", true), "Legacy lock endpoint remains owner scoped")
assert(client:LockPet(owner, "locked", true), "Legacy lock endpoint remains compatible")

-- Both were eligible when selected; their current state must win at confirmation.
pets.raceEquip.Equipped, pets.raceLock.Locked = true, true
local before = #deliveries
local result = client:DeletePets(
	owner,
	{ "equipped", "locked", "raceEquip", "raceLock", "foreign", "missing", {}, "free", "free" }
)
assert(result.ok and result.deleted == 1, "Only count actually deleted, eligible owned pets")
assert(pets.equipped and pets.locked and pets.raceEquip and pets.raceLock and not pets.free)
assert(profiles[stranger].Data.Pets.foreign, "Foreign pets must survive")
assert(profiles[owner].Data.PetIndex.A, "Historical discovery must survive deletion")
assert(#deliveries == before + 1, "One publication for a delete batch")
assert(service:GetLuckMultiplier(owner) == 5, "Protected equipped pets retain their Luck")
before = #deliveries
result = client:DeletePets(owner, { "equipped", "locked", "foreign", "missing" })
assert(not result.ok and result.deleted == 0 and type(result.message) == "string")
assert(#deliveries == before, "No eligible pets cannot publish a fake mutation")
assert(not client:DeletePets(owner, "free").ok)
assert(not client:DeletePets(owner, table.create(101, "missing")).ok)
assert(not client:DeletePets({}, {}).ok)

local ranking = { Pets = {}, PetIndex = {} }
for _, id in ipairs({ "a", "b", "c", "d" }) do
	assert(inventory.Give(ranking, configs, "A", id))
end
ranking.Pets.a.Equipped = false
ranking.Pets.b.Equipped, ranking.Pets.c.Equipped, ranking.Pets.d.Equipped = true, true, true
inventory.EquipBest(ranking, configs)
assert(not ranking.Pets.a.Equipped and ranking.Pets.d.Equipped, "Equal Luck preserves existing equipment")
ranking.Pets.a.PetID = "B"
inventory.EquipBest(ranking, configs)
assert(ranking.Pets.a.Equipped and not ranking.Pets.d.Equipped, "Higher Luck still wins; UUID breaks remaining ties")
inventory.EquipBest(ranking, configs)
assert(ranking.Pets.a.Equipped and ranking.Pets.b.Equipped and ranking.Pets.c.Equipped, "Repeated best equip is stable")
