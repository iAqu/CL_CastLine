local function loadSource(path, environment)
	local file = assert(io.open(path, "r"))
	local source = file:read("*a")
	file:close()
	return assert(load(source, path, "t", setmetatable(environment or {}, { __index = getfenv() })))()
end

local root = "src/ReplicatedStorage/Modules/"
local feature = loadSource(root .. "PetFeatureConfig.lua")
assert(feature.Enabled == false, "Pet gameplay must default to disabled")
local function unexpected()
	error("Disabled pet gameplay must not subscribe, render, create tools, or broadcast")
end
local inventory = loadSource(root .. "PetInventory.lua")
local eggs = loadSource(root .. "EggInventory.lua")
local player = { UserId = 1, Name = "Owner" }
local petsData = { A = { LuckBoost = 5 } }
local data = { Pets = {}, PetIndex = {}, Eggs = {
	placed = { EggId = "E", Placement = { X = 0, Z = 0, Yaw = 0, ReadyAt = 1234 } },
	held = { EggId = "E", RemainingSeconds = 8 },
} }
for _, uuid in ipairs({ "equipped", "free", "third" }) do
	assert(inventory.Give(data, petsData, "A", uuid))
end
assert(inventory.GetLuckMultiplier(data, petsData) > 1, "Fixture must have an active pet bonus")
local profile = { Data = data }
local profiles = { [player] = profile }
local function copy(value)
	if type(value) ~= "table" then return value end
	local result = {}
	for key, entry in pairs(value) do result[key] = copy(entry) end
	return result
end
local function equal(actual, expected)
	assert(type(actual) == type(expected), "Saved data type changed")
	if type(actual) ~= "table" then
		assert(actual == expected, "Saved data changed")
		return
	end
	for key, entry in pairs(expected) do equal(actual[key], entry) end
	for key in pairs(actual) do assert(expected[key] ~= nil, "Unexpected saved field") end
end
local before = copy(data)
local nextId = 0
local knit = {
	CreateService = function(spec)
		spec.Client.Server = spec
		return spec
	end,
	CreateController = function(spec) return spec end,
	CreateSignal = function() return { Fire = unexpected, FireAll = unexpected } end,
	GetService = unexpected,
}
local modules = setmetatable({
	PetFeatureConfig = feature,
	PetInventory = inventory,
	EggInventory = eggs,
	EggToolUtil = { GetTemplate = unexpected, Create = unexpected },
}, { __index = function() return {} end })
local serviceModules = {}
local services = {
	Players = { GetPlayers = unexpected },
	HttpService = { GenerateGUID = function()
		nextId += 1
		return "admin" .. nextId
	end },
	ReplicatedFirst = { Data = { PetsData = petsData, EggsData = { E = {} } } },
	ReplicatedStorage = { Modules = modules, Packages = { Knit = knit } },
	ServerScriptService = { Services = serviceModules },
	Workspace = {},
}
local environment = {
	game = { GetService = function(_, name) return services[name] or {} end },
	require = function(value) return value end,
	script = { Parent = { PlayerDataService = {
		GetProfile = function(_, requester) return profiles[requester] end,
	} } },
	Random = { new = function() return {} end },
	Vector3 = { new = function() return {} end },
}
local function loadServices()
	local petService = loadSource("src/ServerScriptService/Services/PetService.lua", environment)
	local eggService = loadSource("src/ServerScriptService/Services/EggService.lua", environment)
	serviceModules.PetService, serviceModules.EggService = petService, eggService
	petService:KnitStart()
	eggService:KnitStart()
	return petService, eggService
end
local petService, eggService = loadServices()
assert(petService:GetLuckMultiplier(player) == 1, "Saved equipped pets must not add luck")
local state = petService.Client:GetState(player)
assert(next(state.Pets) == nil and next(state.PetIndex) == nil and state.LuckMultiplier == 1)
assert(next(petService.Client:GetAllPlayersEquippedPets(player)) == nil)
assert(next(eggService.Client:GetState(player).Eggs) == nil)
assert(not petService.Client:EquipPet(player, "free", true).ok)
assert(not petService.Client:EquipBest(player))
assert(not petService.Client:UnequipAll(player))
assert(not petService.Client:LockPet(player, "free", true))
assert(not petService.Client:LockPets(player, { "free" }).ok)
local deleted = petService.Client:DeletePets(player, { "free" })
assert(not deleted.ok and deleted.deleted == 0)
local crafted = petService.Client:CraftPet(player, "equipped", 0)
assert(not crafted.ok and crafted.craftedCount == 0)
crafted = petService.Client:CraftAllPets(player)
assert(not crafted.ok and crafted.craftedCount == 0)
assert(not eggService.Client:PlaceEgg(player, "held", {}, 0).ok)
assert(not eggService.Client:PickupEgg(player, "placed").ok)
assert(not eggService.Client:HatchEgg(player, "placed").ok)
-- Server entrypoints must also reject gameplay, without consulting scene geometry.
assert(not eggService:PlaceEgg(player, "held", {}, 0).ok)
assert(not eggService:PickupEgg(player, "placed").ok)
assert(not eggService:HatchEgg(player, "placed").ok)
eggService:_restore(player)
eggService:_giveTool(player, "held")
eggService:_renderEgg(player, "placed")
petService:_changed(player)
eggService:_changed(player)
equal(data, before)

-- Exercise the real Admin command handlers and services, rather than grant stubs.
local givePet = loadSource("src/ServerScriptService/Cmdr/Commands/GivePetServer.lua", environment)
local giveEgg = loadSource("src/ServerScriptService/Cmdr/Commands/GiveEggServer.lua", environment)
assert(givePet({}, player, "A", 2) == "Gave 2 A to Owner")
assert(giveEgg({}, player, "E", 2) == "Gave 2 E to Owner")
assert(inventory.Count(data.Pets) == 5 and inventory.Count(data.Eggs) == 4)
assert(data.Eggs.admin3.EggId == "E" and data.Eggs.admin4.EggId == "E")
equal(data.Eggs.placed, before.Eggs.placed)
equal(data.Eggs.held, before.Eggs.held)
local saved = copy(data)
profiles[player] = { Data = copy(saved) }
petService, eggService = loadServices()
eggService:_restore(player) -- Rejoin and respawn must not restore visuals or tools.
assert(petService:GetLuckMultiplier(player) == 1)
equal(profiles[player].Data, saved)

-- Disabled client startup must not obtain services or bind gameplay input/render events.
local panels = {
	{ Name = "PetGui", Enabled = true, IsA = function(_, kind) return kind == "ScreenGui" end },
	{ Name = "EggHatchResultGui", Enabled = true, IsA = function(_, kind) return kind == "ScreenGui" end },
	{ Name = "IndexGui", Enabled = true, IsA = function(_, kind) return kind == "ScreenGui" end },
}
local onGuiAdded
local playerGui = {
	ChildAdded = { Connect = function(_, callback) onGuiAdded = callback end },
	GetChildren = function() return panels end,
}
services.Players.LocalPlayer = { WaitForChild = function(_, name)
	assert(name == "PlayerGui")
	return playerGui
end }
for _, name in ipairs({ "EggPlacementController", "PetFollowController", "GUI/PetGuiController" }) do
	local controller = loadSource("src/StarterPlayer/StarterPlayerScripts/Controllers/" .. name .. ".lua", environment)
	controller:KnitStart()
	if name == "GUI/PetGuiController" then
		controller._ready = true -- A direct caller must not bypass the feature gate.
		controller:OpenGui()
		controller:ToggleGui()
		controller:_setup()
	end
end
assert(not panels[1].Enabled and not panels[2].Enabled and panels[3].Enabled,
	"Hide pet panels while preserving the fish index")
local respawnPanel = table.clone(panels[1])
respawnPanel.Enabled = true
onGuiAdded(respawnPanel)
assert(not respawnPanel.Enabled, "Respawned pet panels must remain hidden")
