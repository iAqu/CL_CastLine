local function read(path)
	local file = assert(io.open(path, "r"))
	local source = file:read("*a")
	file:close()
	return source
end

local callbacks = {}
local function signal()
	return {
		Connect = function(_, callback) table.insert(callbacks, callback) end,
		Fire = function(self, ...)
			self.count = (self.count or 0) + 1
			self.last = { ... }
		end,
	}
end
local knit = {
	CreateService = function(spec) return spec end,
	CreateSignal = signal,
}
local profile
local playerDataService = {
	GetProfile = function() return profile end,
	ProfileLoaded = signal(),
}
local services = {
	ReplicatedFirst = { Data = { ConditionsData = "conditions", ItemsData = "items" } },
	ReplicatedStorage = {
		Packages = { Knit = "knit" },
		Modules = {
			GamePassEffectUtil = "effects", PlayerLuckUtil = "luck", ItemStatUtil = "stats",
			ItemToolUtil = "tools", MutationDataUtil = "mutation",
		},
	},
	ServerScriptService = { Services = { PlayerDataService = "profiles" } },
	Players = {},
}
local dependencies = {
	knit = knit, profiles = playerDataService,
	conditions = { Codition_1 = { ValueMult = 1, LuckMult = 1 }, Good = { ValueMult = 2, LuckMult = 3 } },
	items = { Duck = {} },
	effects = { GetItemLuckMultiplier = function() return 1.5 end },
	mutation = { NormalizeMutationId = function(id) return id end, GetPriceRate = function() return 1 end },
	stats = {
		CalculateLuck = function(_, weight, multiplier) return weight * multiplier end,
		CalculatePrice = function(_, weight, multiplier) return weight * multiplier end,
	},
}
local function loadModule(path, extras)
	local env = setmetatable({
		game = { GetService = function(_, name) return assert(services[name], name) end },
		require = function(key) return assert(dependencies[key], tostring(key)) end,
		warn = function() end,
	}, { __index = getfenv() })
	for key, value in pairs(extras or {}) do env[key] = value end
	local chunk = assert(loadstring(read(path), path))
	setfenv(chunk, env)
	return chunk()
end

dependencies.luck = loadModule("src/ReplicatedStorage/Modules/PlayerLuckUtil.lua", {
	script = { Parent = { ItemStatUtil = "stats" } },
})
local util = dependencies.luck
assert(math.abs(util.CombineRollLuck(2, 0.1, 1.5) - 3.15) < 0.000001)
assert(util.CombineRollLuck(-2, 0.1, 1) == 0.1)
assert(util.CombineRollLuck(nil, nil, nil) == 0)

local discoveryLuck = 0.1
knit.GetService = function(name)
	assert(name == "IndexService")
	return { GetDiscoveryLuck = function() return discoveryLuck end }
end
local player = {}
profile = {
	Data = {
		Items = {
			placed = { ItemId = "Duck", Weight = 2, ConditionId = "Good" },
			carried = { ItemId = "Duck", Weight = 1, ConditionId = "Missing" },
			invalid = { ItemId = "Duck", Weight = -1 },
		},
		PlotPlacements = { [1] = "placed", [2] = "placed" },
	},
}
local luckService = loadModule("src/ServerScriptService/Services/PlayerLuckService.lua")
assert(math.abs(luckService:GetPlayerRollLuck(player) - 9.15) < 0.000001, "Placed entries must count once and retain condition luck")
luckService:RefreshPlayerLuck(player)
luckService:RefreshPlayerLuck(player)
assert(luckService.Client.LuckChanged.count == 1, "Unchanged totals must not send redundant notifications")
discoveryLuck = 0.2
luckService:RefreshPlayerLuck(player)
assert(luckService.Client.LuckChanged.count == 2)
assert(luckService.Client.LuckChanged.last[1] == player)
assert(math.abs(luckService.Client.LuckChanged.last[2] - 9.3) < 0.000001)
local savedProfile = profile
profile = nil
assert(luckService:GetPlayerRollLuck(player) == nil)
luckService:RefreshPlayerLuck(player)
assert(luckService.Client.LuckChanged.count == 2)
profile = savedProfile

local backpack = { children = {} }
function backpack:IsA(class) return class == "Backpack" end
function backpack:GetChildren() return self.children end
function player:FindFirstChildOfClass(class) return class == "Backpack" and backpack or nil end
local created = {}
dependencies.tools = {
	GetInstanceId = function(tool) return tool.id end,
	Create = function(id, _, data)
		local tool = setmetatable({ id = id, data = data, IsA = function(_, class) return class == "Tool" end }, {
			__newindex = function(self, key, value)
				rawset(self, key, value)
				if key == "Parent" then table.insert(value.children, self) end
			end,
		})
		table.insert(created, tool)
		return tool
	end,
}
local inventory = loadModule("src/ServerScriptService/Services/ItemInventoryService.lua")
inventory:RestoreItemTools(player)
inventory:RestoreItemTools(player)
assert(#created == 1 and created[1].id == "carried", "Restore must exclude placed/invalid items and avoid duplicates")
assert(created[1].data.ConditionId == "Codition_1", "Unknown conditions must use the existing default")
player.Character = { GetChildren = function() return { created[1] } end }
backpack.children = {}
inventory:RestoreItemTools(player)
assert(#created == 1, "Equipped tools must not be restored again")

local layoutService = loadModule("src/ServerScriptService/Services/HotbarLayoutService.lua")
profile.Data.HotbarLayout = { ["1"] = { Kind = "Item", Id = "carried" } }
local layout = layoutService:NormalizeStoredLayout(player)
assert(layout["1"] and layout["1"].Id == "carried", "Slot 1 must retain ordinary items")
assert(layoutService:SaveHotbarLayout(player, { ["10"] = { Kind = "Item", Id = "carried" } }, 10))
assert(profile.Data.HotbarLayout["10"].Id == "carried")
assert(not layoutService:SaveHotbarLayout(player, {}, 9))
assert(layoutService:SaveHotbarLayout(player, {
	["1"] = { Kind = "Item", Id = "carried" }, ["2"] = { Kind = "Item", Id = "carried" },
	["3"] = { Kind = "Item", Id = "not-owned" },
}, 10))
assert(profile.Data.HotbarLayout["1"] and profile.Data.HotbarLayout["2"] == nil and profile.Data.HotbarLayout["3"] == nil)

print("EquipmentServices.test.lua passed")
