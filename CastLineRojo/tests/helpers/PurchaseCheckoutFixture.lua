local path = "src/ServerScriptService/Services/PurchaseCheckout.lua"
local file = assert(io.open(path, "r"))
local source = file:read("*a")
file:close()

return function(players, marketplace, taskApi, clock)
	local fixture = { Enabled = false, Records = {}, Writes = 0, Warnings = {} }
	local guid = 0
	local configListeners = {}
	function fixture.SetConfigValue(value)
		fixture.Enabled = value
		for _, listener in configListeners do
			listener()
		end
	end

	local function getConfig()
		local value = fixture.Enabled
		return {
			Error = fixture.ConfigError or "None",
			GetValue = function(_, name)
				assert(name == "DedicatedPurchaseCheckout")
				return value
			end,
			Refresh = function(snapshot)
				if fixture.RefreshThrows then
					error("Config refresh unavailable")
				end
				snapshot.Error = fixture.ConfigError or "None"
				value = fixture.Enabled
			end,
			UpdateAvailable = { Connect = function(_, listener)
				table.insert(configListeners, listener)
			end },
		}
	end
	local store = {}
	function store:UpdateAsync(key, apply)
		if fixture.OnUpdate then
			fixture.OnUpdate(key)
		end
		local changed = apply(fixture.Records[key])
		if changed ~= nil then
			fixture.Records[key] = changed
			fixture.Writes += 1
		end
		if fixture.AfterWrite and changed ~= nil then
			fixture.AfterWrite(changed)
		end
		return changed
	end

	local api = {
		ConfigService = { GetConfigAsync = getConfig },
		DataStoreService = { GetDataStore = function(_, name)
			assert(name == "PurchaseCheckout_v1")
			return store
		end },
		HttpService = { GenerateGUID = function()
			guid += 1
			return "checkout-" .. guid
		end },
		Players = players,
		RunService = { IsStudio = function() return fixture.Studio == true end },
		MarketplaceService = marketplace,
	}
	function fixture.Load()
		local services = { PlayerDataService = { IsUsingMockProfiles = function() return fixture.Mock end } }
		local checkout = assert(load(source, path, "t", setmetatable({
			game = {
				PlaceId = fixture.PlaceId,
				GetService = function(_, name) return assert(api[name], name) end,
			},
			Enum = { ConfigSnapshotErrorState = { None = "None" } },
			workspace = { GetAttribute = function(_, name)
				assert(name == "StudioDedicatedPaidEggCheckout")
				return fixture.StudioPaidEggOverride
			end },
			require = function(module) return module end,
			script = { Parent = services },
			task = {
				spawn = function(callback) callback() end,
				defer = taskApi.defer,
				delay = taskApi.delay,
			},
			os = { time = clock },
			warn = function(...) table.insert(fixture.Warnings, { ... }) end,
		}, { __index = getfenv() })))()
		checkout.Start()
		return checkout
	end
	return fixture
end
