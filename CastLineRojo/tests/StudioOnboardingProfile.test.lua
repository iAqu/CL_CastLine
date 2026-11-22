local function readModule(path, environment)
	local file = assert(io.open("src/" .. path .. ".lua", "r"), "Could not read " .. path)
	local source = file:read("*a")
	file:close()
	local chunk, err = loadstring(source, path)
	return setfenv(assert(chunk, err), setmetatable(environment or {}, { __index = getfenv() }))()
end

local onboarding = readModule("ReplicatedStorage/Modules/FishingOnboarding")
local intro = readModule("ReplicatedStorage/Modules/FishingIntroConfig")
local trainingProgress = readModule("ReplicatedStorage/Modules/TrainingProgress")
local starterUid = intro.RewardUidPrefix .. tostring(intro.Version)
local args = { plugin = "RestartTest", castLineOnboarding = true }
local devPlace = 84106335829275
local function loadProfile(isStudio, placeId, testArgs, forceMock, loadCount, initialStage, storedData, interruption)
	local loadedFrom
	local deadline, service
	local connected, kicks, releases = true, 0, 0
	local player
	local data = { Wins = 200, Items = {}, PlotPlacements = {}, EquippedRodId = "Rod_101", Training = { Level = 1 } }
	if initialStage then
		data.FishingOnboarding = { Stage = initialStage }
	end
	for key, value in pairs(storedData or {}) do
		data[key] = value
	end
	local profile = {
		MetaData = { SessionLoadCount = loadCount or 1 }, Data = data,
		AddUserId = function() end, Reconcile = function() end, ListenToRelease = function() end,
		IsActive = function() return releases == 0 end,
		Release = function() releases += 1 end,
	}
	local function store(name)
		return { LoadProfileAsync = function(_, key, _, shouldCancel)
			assert(key == "Player_123")
			loadedFrom = name
			if interruption == "timeout" then
				deadline()
			elseif interruption == "leave" then
				connected = false
				service:_ReleasePlayerProfile(player)
			end
			assert(shouldCancel() == (interruption ~= nil))
			return profile
		end }
	end
	local profileStore = store("regular")
	profileStore.Mock = store("mock")
	local players = {}
	local attributes = {}
	player = {
		UserId = 123, IsDescendantOf = function(_, instance) return connected and instance == players end,
		SetAttribute = function(_, name, value) attributes[name] = value end,
		Kick = function() kicks += 1 end,
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
		ReplicatedFirst = { Data = {
			FishesData = { [intro.StarterFishId] = { DefaultWeight = 1 }, Fish_103 = {} },
			TrainingData = { Training_101 = { TrainingID = "Training_101", LayoutOrder = 1 } },
			TrainingLevelsData = {
				[1] = { Level = 1, XpToNextLevel = 5 },
				[2] = { Level = 2, XpToNextLevel = 5 },
				[3] = { Level = 3, XpToNextLevel = 5 },
				[4] = { Level = 4, XpToNextLevel = 0 },
			},
		} },
		ReplicatedStorage = {
			Packages = {
				Knit = {
					CreateService = function(service) return service end,
					CreateSignal = newSignal,
					GetService = function(name)
						assert(name == "OnboardingAnalyticsService")
						return { Initialize = noop }
					end,
				},
				Signal = { new = newSignal },
			},
			PlayerData = { Template = { Settings = {} } },
			Modules = {
				FishingOnboarding = onboarding,
				FishingIntroConfig = intro,
				FishingProgression = { Ensure = noop },
				RodInventory = { Reconcile = noop },
				PetInventory = { Reconcile = noop },
				EggInventory = { Reconcile = noop },
				TrainingProgress = trainingProgress,
				ItemPriceMigration = noop,
				PlotUpgradeData = { NormalizeLevel = function() return 0 end },
			PlotPlacementUtil = {
				GetCapacity = function() return 4 end,
				Reconcile = function(placements) return placements end,
				IsPlaced = function(placements, uid) return table.find(placements, uid) ~= nil end,
			},
				PlotFishIncome = { PrepareOffline = function() return {} end },
			},
		},
	}
	service = readModule("ServerScriptService/Services/PlayerDataService", {
		game = { PlaceId = placeId, GetService = function(_, name)
			assert(name ~= "StudioTestService" or isStudio and placeId == devPlace, "Test args belong to Studio CL_DEV only")
			return assert(services[name], name)
		end },
		workspace = { GetAttribute = function() return forceMock end },
		require = function(value) return value end,
		warn = noop,
		task = { delay = function(seconds, callback, reason)
			assert(seconds == 90)
			deadline = function() callback(reason) end
		end },
	})
	service._FrameworkReady = true
	service.CreateLeaderstats = noop
	service:LoadProfile(player)
	if interruption then
		assert(service:GetProfile(player) == nil and service._PendingProfiles[player] == nil)
		assert(attributes.PlayerProfileReady == nil, "A late load must never reach gameplay")
		assert(releases == 1, "The late profile must release its session exactly once")
		assert(kicks == (if interruption == "timeout" then 1 else 0))
		return
	end
	deadline()
	assert(kicks == 0, "A successful load must disarm its timeout")
	assert(service:IsStudioOnboardingTest() == (isStudio and placeId == devPlace and testArgs == args), "Unexpected mode")
	assert(service:IsUsingMockProfiles() == (loadedFrom == "mock"), "Mock flag must match the actual store")
	assert(service:GetProfile(player) == profile, "The loaded profile must be available to gameplay services")
	return loadedFrom, attributes[onboarding.StageAttribute], attributes[onboarding.FishAttribute], data
end

loadProfile(true, devPlace, nil, false, 2, nil, nil, "timeout")
loadProfile(true, devPlace, nil, false, 2, nil, nil, "leave")

local source, stage, target, data = loadProfile(true, devPlace, args)
assert(source == "mock" and stage == "PlaceFish" and target == starterUid,
	"A fresh onboarding test starts at placement on the mock store")
assert(data.Items[target].ItemId == intro.StarterFishId and next(data.Items, target) == nil)
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

local starter = { ItemId = intro.StarterFishId, Weight = 1 }
local other = { ItemId = "Fish_103", Weight = 1 }
local function loadLegacy(items, placements)
	local _, migratedStage, fishUid, saved = loadProfile(true, devPlace, nil, true, 2, "FirstCatch", {
		Items = items,
		PlotPlacements = placements,
		FishingIntroVersion = intro.Version,
		OnboardingAnalyticsV1 = { Sent = 8 },
	})
	assert(saved.OnboardingAnalyticsV1.Retired and saved.OnboardingAnalyticsV1.Sent == 8)
	assert(saved.Items == items, "Migration does not grant or replace inventory")
	return migratedStage, fishUid
end
stage, target = loadLegacy({ [starterUid] = starter, other = other }, {})
assert(stage == "PlaceFish" and target == starterUid)
assert(loadLegacy({ [starterUid] = starter }, { starterUid }) == "Train")
assert(loadLegacy({ other = other }, {}) == "PlaceFish")
assert(loadLegacy({}, {}) == "Train")
assert(loadLegacy({ other = other }, { "other" }) == "Train")
source, stage, target = loadProfile(true, devPlace, nil, true, 2, nil, {
	Items = { oldLesson = other },
	FishingOnboarding = { Stage = "PlaceFish", FishUid = "oldLesson" },
})
assert(stage == "PlaceFish" and target == "oldLesson", "An existing placement target survives rejoining")

for _, checkpoint in ipairs({ "Train", "StopTraining", "RodReward", "FinalCatch", "Complete" }) do
	local level = if checkpoint == "Train" then 2 else 3
	local storeName, savedStage, _, saved = loadProfile(false, devPlace, nil, false, 2, checkpoint, {
		Training = { Level = level, Xp = 4 },
	})
	assert(storeName == "regular" and savedStage == checkpoint, "Rejoining publishes the saved checkpoint: " .. checkpoint)
	assert(saved.Training.Level == level and saved.Training.Xp == 4, "Rejoining preserves training progress")
end

local onboardingTest, leaderboardWrites = true, 0
local function writeLeaderboard()
	leaderboardWrites += 1
end
local function getBlacklist()
	return nil
end
local globalLeaderboardConfig = readModule("ReplicatedStorage/Modules/GlobalLeaderboardConfig", {
	game = { GetService = function() return { Modules = { NumberUtil = {}, WeightFormat = {} } } end },
	require = function(value) return value end,
})
local leaderboardDependencies = {
	Players = { GetPlayerByUserId = function() return nil end },
	ReplicatedStorage = {
		Modules = { GlobalLeaderboardConfig = globalLeaderboardConfig },
		Packages = { Knit = {
			CreateService = function(service) return service end,
			CreateSignal = function() return { Fire = function() end } end,
			GetService = function() return { GetBlackList = getBlacklist } end,
		} },
	},
	ServerScriptService = { Services = { PlayerDataService = {
		IsStudioOnboardingTest = function() return onboardingTest end,
		IsUsingMockProfiles = function() return false end,
		GetProfile = function()
			return { Data = { TotalCashEarned = 300, MaxCaughtFishWeightTenths = 100, TotalFishCaught = 2, PlayTime = 50 } }
		end,
	} } },
	ServerStorage = { Gui = {} },
}
local leaderboard = readModule("ServerScriptService/Services/GlobalLeaderboardService", {
	game = { GetService = function(_, name)
		return leaderboardDependencies[name] or {}
	end },
	require = function(value) return value end,
})
for _, boardType in globalLeaderboardConfig.Types do
	leaderboard._Stores[boardType] = {
		UpdateAsync = function(_, _, transform)
			assert(transform(nil) > 0)
			writeLeaderboard()
		end,
	}
end
local player = { UserId = 123 }
leaderboard:SyncPlayerLeaderboardData(player)
assert(leaderboardWrites == 0, "Onboarding progress must not reach the global leaderboard")
onboardingTest = false
leaderboard:SyncPlayerLeaderboardData(player)
assert(leaderboardWrites == 4, "Regular play records all four scores")
