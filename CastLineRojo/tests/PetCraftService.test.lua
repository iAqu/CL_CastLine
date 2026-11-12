local function read(path)
	local f = assert(io.open(path, "r"))
	local s = f:read("*a")
	f:close()
	return s
end
local inventory = assert(loadstring(read("src/ReplicatedStorage/Modules/PetInventory.lua")))()
local owner, stranger = {}, {}
local configs = { A = { LuckBoost = 2 } }
local profiles =
	{ [owner] = { Data = { Pets = {}, PetIndex = {} } }, [stranger] = { Data = { Pets = {}, PetIndex = {} } } }
for n = 1, 3 do
	assert(inventory.Give(profiles[owner].Data, configs, "A", tostring(n)), "Fixture grant failed")
end
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
local dataService = {
	GetProfile = function(_, player)
		return profiles[player]
	end,
}
owner.UserId, stranger.UserId = 1, 2
local services = {
	Players = {},
	HttpService = {},
	ReplicatedFirst = { Data = { PetsData = configs } },
	ReplicatedStorage = { Packages = { Knit = knit }, Modules = { PetInventory = inventory } },
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
		script = { Parent = { PlayerDataService = dataService } },
		require = function(value)
			return value
		end,
	}, { __index = getfenv() })
)
local service = chunk()
assert(not service.Client:CraftPet(stranger, "1", 0).ok, "Cannot craft someone else's inventory")
assert(not service.Client:CraftPet(owner, "1", "0").ok, "Reject string tier")
assert(not service.Client:CraftPet(owner, {}, 0).ok, "Reject malformed UUID")
assert(not service.Client:CraftPet({}, "1", 0).ok, "Unloaded profile must fail safely")
assert(#deliveries == 0 and #rosters == 0, "Rejected operations must not publish mutations")
local result = service.Client:CraftPet(owner, "1", 0)
assert(result.ok and result.craftedCount == 1 and profiles[owner].Data.Pets["1"].Size == 1, "Single craft contract")
assert(
	#deliveries == 1 and deliveries[1].player == owner and deliveries[1].state.Pets["1"].Size == 1,
	"Only owner receives full inventory"
)
assert(#rosters == 1 and rosters[1].roster[1].Size == 1, "Equipped size must be replicated")
assert(service:GetLuckMultiplier(owner) == 4, "Service luck must include Big multiplier")
assert(not service.Client:CraftPet(owner, "1", 0).ok, "Reject duplicate tier request")
for n = 4, 5 do
	local p = assert(inventory.Give(profiles[owner].Data, configs, "A", tostring(n)), "Fixture grant failed")
	p.Size = 1
end
result = service.Client:CraftAllPets(owner)
assert(result.ok and result.craftedCount == 1 and profiles[owner].Data.Pets["1"].Size == 2, "Bulk craft contract")
assert(service:GetLuckMultiplier(owner) == 5, "Huge multiplier must reach fishing service")
assert(not service.Client:CraftAllPets(owner).ok, "No-op bulk must report no eligible materials")
assert(not service.Client:CraftPet(owner, "1", 2).ok, "Huge cannot advance")
assert(next(profiles[stranger].Data.Pets) == nil, "Other inventory remains untouched")
