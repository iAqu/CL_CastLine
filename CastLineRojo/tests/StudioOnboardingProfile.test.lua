local function readModule(path, environment)
	local file = assert(io.open("src/" .. path .. ".lua", "r"), "Could not read " .. path)
	local source = file:read("*a")
	file:close()
	local chunk, err = loadstring(source, path)
	return setfenv(assert(chunk, err), setmetatable(environment or {}, { __index = getfenv() }))()
end

local onboarding = readModule("ReplicatedStorage/Modules/FishingOnboarding")
local args = { plugin = "RestartTest", castLineOnboarding = true }
local devPlace = 84106335829275
local function loadProfile(isStudio, placeId, testArgs, forceMock, loadCount, initialStage)
	local loadedFrom
	local data = { Wins = 200, Items = {}, PlotPlacements = {}, EquippedRodId = "Rod_101", Training = { Level = 1 } }
	if initialStage then
		data.FishingOnboarding = { Stage = initialStage }
	end
	local profile = {
		MetaData = { SessionLoadCount = loadCount or 1 }, Data = data,
		AddUserId = function() end, Reconcile = function() end, ListenToRelease = function() end,
	}
	local function store(name)
		return { LoadProfileAsync = function()
			loadedFrom = name
			return profile
		end }
	end
	local profileStore = store("regular")
	profileStore.Mock = store("mock")
	local players = {}
	local attributes = {}
	local player = {
		UserId = 123, IsDescendantOf = function(_, instance) return instance == players end,
		SetAttribute = function(_, name, value) attributes[name] = value end,
	}
	local function newSignal()
		return { Fire = function() end }
	end
	local function noop() end
	local services = {
		Players = players,
		RunService = { IsStudio = function() return isStudio end },
		StudioTestService = { GetTestArgs = function() return testArgs end },
		ServerScriptService = { Libs = { ProfileService = { GetProfileStore = function() return profileStore end } } },
		ReplicatedFirst = { Data = {} },
		ReplicatedStorage = {
			Packages = { Knit = { CreateService = function(service) return service end, CreateSignal = newSignal }, Signal = { new = newSignal } },
			PlayerData = { Template = {} },
			Modules = {
				FishingOnboarding = onboarding,
				FishingProgression = { Ensure = noop },
				RodInventory = { Reconcile = noop },
				PetInventory = { Reconcile = noop },
				EggInventory = { Reconcile = noop },
				TrainingProgress = { Ensure = noop },
				ItemPriceMigration = noop,
				PlotUpgradeData = { NormalizeLevel = function() return 0 end },
			PlotPlacementUtil = {
				GetCapacity = function() return 0 end,
				CoerceNumericKeys = function(value) return value end,
			},
				PlotFishIncome = { PrepareOffline = function() return {} end },
			},
		},
	}
	local service = readModule("ServerScriptService/Services/PlayerDataService", {
		game = { PlaceId = placeId, GetService = function(_, name)
			assert(name ~= "StudioTestService" or isStudio and placeId == devPlace, "Test args belong to Studio CL_DEV only")
			return assert(services[name], name)
		end },
		workspace = { GetAttribute = function() return forceMock end },
		require = function(value) return value end,
	})
	service._FrameworkReady = true
	service.CreateLeaderstats = noop
	service:LoadProfile(player)
	assert(service:IsStudioOnboardingTest() == (isStudio and placeId == devPlace and testArgs == args), "Unexpected mode")
	assert(service:IsUsingMockProfiles() == (loadedFrom == "mock"), "Mock flag must match the actual store")
	assert(service:GetProfile(player) == profile, "The loaded profile must be available to gameplay services")
	return loadedFrom, attributes[onboarding.StageAttribute]
end

local source, stage = loadProfile(true, devPlace, args)
assert(source == "mock" and stage == "FirstCatch", "A fresh onboarding test starts at FirstCatch on the mock store")
source, stage = loadProfile(true, devPlace, args, false, 2, "Train")
assert(source == "mock" and stage == "Train", "Reloads in the same test retain existing progress")
source, stage = loadProfile(true, devPlace, nil, true)
assert(source == "mock" and stage == nil, "Ordinary mock play keeps the automatic intro")
for _, case in ipairs({
	{ true, devPlace, { plugin = "RestartTest" } },
	{ true, devPlace, { plugin = "Other", castLineOnboarding = true } },
	{ true, 1, args },
	{ false, devPlace, args, true },
}) do
	source, stage = loadProfile(table.unpack(case))
	assert(source == "regular" and stage == nil, "Other starts must retain the regular store and onboarding state")
end

local onboardingTest, leaderboardWrites = true, 0
local function writeLeaderboard()
	leaderboardWrites += 1
end
local function getBlacklist()
	return nil
end
local leaderboardDependencies = {
	DataStoreService = { GetOrderedDataStore = function()
		return { SetAsync = writeLeaderboard }
	end },
	ReplicatedStorage = {
		Modules = {},
		Packages = { Knit = {
			CreateService = function(service) return service end,
			CreateSignal = function() return { Fire = function() end } end,
			GetService = function() return { GetBlackList = getBlacklist } end,
		} },
	},
	ServerScriptService = { Services = { PlayerDataService = {
		IsStudioOnboardingTest = function() return onboardingTest end,
		GetProfile = function() return { Data = { TotalCashEarned = 300, TotalItemWeightTenths = 100 } } end,
	} } },
	ServerStorage = { Gui = {} },
}
local leaderboard = readModule("ServerScriptService/Services/GlobalLeaderboardService", {
	game = { GetService = function(_, name)
		return leaderboardDependencies[name] or {}
	end },
	require = function(value) return value end,
})
local player = { UserId = 123 }
leaderboard:SyncPlayerLeaderboardData(player)
assert(leaderboardWrites == 0, "Onboarding progress must not reach the global leaderboard")
onboardingTest = false
leaderboard:SyncPlayerLeaderboardData(player)
assert(leaderboardWrites == 2, "Regular play still records cash and weight")
