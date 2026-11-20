local source = assert(io.open("src/ServerScriptService/Services/OnboardingAnalyticsService.lua")):read("*a")
local function loadService(studio)
	local sent, listeners, players, warnings = {}, {}, {}, {}
	local now, rejected = 100, nil
	local function signal(name)
		return {
			Connect = function(_, callback)
				listeners[name] = callback
			end,
		}
	end
	local services = {
		AnalyticsService = {
			LogFunnelStepEvent = function(_, player, funnel, sessionId, step, name)
				assert(funnel == "CL_Onboarding_v1" and sessionId == "")
				if step == rejected then
					error("Simulated analytics failure")
				end
				table.insert(sent, { player = player, step = step, name = name })
			end,
			LogCustomEvent = function(_, player, name, value, fields)
				table.insert(sent, { player = player, name = name, value = value, fields = fields })
			end,
		},
		Players = {
			PlayerRemoving = signal("leave"),
			GetPlayers = function() return players end,
		},
		RunService = { IsStudio = function() return studio end },
		ReplicatedStorage = { Packages = { Knit = {
			CreateSignal = function() return signal("guide") end,
			CreateService = function(service) return service end,
		} } },
	}
	local environment = setmetatable({
		game = { GetService = function(_, name) return services[name] end },
		Enum = { AnalyticsCustomFieldKeys = {
			CustomField01 = { Name = "Field1" },
			CustomField02 = { Name = "Field2" },
			CustomField03 = { Name = "Field3" },
		} },
		Random = { new = function()
			return { NextInteger = function(_, low, high)
				assert(low == 1 and high == 4)
				return 2
			end }
		end },
		os = { clock = function() return now end },
		warn = function(message) table.insert(warnings, message) end,
		require = function(module) return module end,
	}, { __index = getfenv() })
	local service = assert(load(source, "OnboardingAnalyticsService", "t", environment))()
	service:KnitInit()
	return service, sent, listeners, warnings, function(failureStep, dt)
		rejected = failureStep
		now += dt or 1
		service:Pump()
	end
end

local function profile(count, data)
	return { Data = data or {}, MetaData = { SessionLoadCount = count }, IsActive = function() return true end }
end

local function player()
	return { Character = { FindFirstChildOfClass = function() return { Health = 100 } end } }
end

local service, events, listeners, warnings, pump = loadService(false)
local newcomer = player()
local first = profile(1, { FishingOnboarding = { Stage = "PlaceFish" } })
service:Initialize(newcomer, first)
service:Step(newcomer, "IntroCreated") -- Remote and server observations can arrive out of order.
service:Step(newcomer, "IntroCreated")
service:Step(newcomer, "Unknown")
service:FishingPresentation(newcomer, "Intro", "Waiting", 0, "HookPrompt")
service:FishingPresentation(newcomer, "Intro", "Waiting", 1, "Reveal")
service:FishingPresentation(newcomer, "Intro", "Waiting", 1, {})
listeners.guide(newcomer, "RodShopOpened")
pump()
pump()
assert(#events == 1 and events[1].step == 1)
assert(next(first.Data.OnboardingAnalyticsV1.Details) == nil)

service:Step(newcomer, "IntroClaimed")
pump(2)
assert(#warnings == 1 and #events == 1, "A failed send must not advance the cursor")
pump(nil, 1)
assert(#events == 1)
pump(nil, 1)
pump()
assert(#events == 3 and events[2].step == 2 and events[3].step == 3)
service:FishingPresentation(newcomer, "Intro", "Waiting", 1, "Nibble1")
service:FishingPresentation(newcomer, "Intro", "Waiting", 1, "Nibble1")
listeners.guide(newcomer, "PlacementPrompt")
for _, step in { "IntroStarted", "IntroCast", "IntroLanded", "IntroBite", "IntroCaught" } do
	service:Step(newcomer, step)
end

listeners.leave(newcomer)
local returned = player()
service:Initialize(returned, profile(2, first.Data))
for _, step in {
	"FirstCatchStarted", "FirstCatchCast", "FirstCatchLanded", "FirstCatchBite",
	"FirstCatchCaught", "FishPlaced", "TrainingStarted", "TrainingLevel2", "TrainingEnded",
	"RodReady", "FinalCatchStarted",
} do
	service:Step(returned, step)
end
service:Detail(returned, "Guide", "RodAlreadyReady")
service:Detail(returned, "FinalCatch", "FreePracticeSelected")
for _ = 1, 24 do
	pump()
end
assert(first.Data.OnboardingAnalyticsV1.Sent == 19, "Free practice must not complete bait selection")
assert(first.Data.OnboardingAnalyticsV1.Details["Intro/Reveal"] == nil, "Rejoin must not invent a reveal")
for _, step in { "FinalBaitSelected", "FinalCatchCast", "FinalCatchLanded", "FinalCatchBite", "FinalCatchCaught" } do
	service:Step(returned, step)
end
local veteran = player()
local existing = profile(8)
service:Initialize(veteran, existing)
service:Step(veteran, "IntroClaimed")
service:Growth(veteran, "CL_PlotUpgrade_v1", 500, 2, 6)
service:Growth(veteran, "InvalidValue", math.huge)
for _ = 1, 8 do
	pump()
end
local cursor, nibbleCount, veteranCount = 0, 0, 0
for _, event in events do
	if event.step then
		cursor += 1
		assert(event.step == cursor)
	elseif event.fields.Field2 == "Nibble1" then
		nibbleCount += 1
	end
	if event.player == veteran then
		veteranCount += 1
		assert(event.name == "CL_PlotUpgrade_v1" and event.value == 500 and event.fields.Field2 == "6")
	end
end
assert(cursor == 24 and nibbleCount == 1 and veteranCount == 1 and existing.Data.OnboardingAnalyticsV1 == nil)
assert(not service:SampleFishingCast())

local dryRun, outgoing, _, _, pumpStudio = loadService(true)
local mock = profile(1)
dryRun:Initialize(newcomer, mock)
dryRun:Step(newcomer, "IntroClaimed")
dryRun:Growth(newcomer, "CL_TrainingLevelUp_v1", 1, "Training_101", 2, 2)
pumpStudio()
pumpStudio()
local snapshot = dryRun:GetStudioSnapshot(newcomer)
assert(snapshot.Sent == 2 and #snapshot.Events == 3 and mock.Data.OnboardingAnalyticsV1 == nil)
assert(#outgoing == 0 and dryRun:SampleFishingCast())

local fishingHarness = require("./helpers/FishingHarness")
local normal = fishingHarness()
normal.sampleAnalyticsCast = true
normal.begin("NONE")
normal.cast()
normal.failGrant = true
assert(not normal.hook().ok and #normal.analytics == 1)
normal.failGrant = false
assert(normal.hook().ok and #normal.analytics == 3)
assert(not normal.hook().ok, "Duplicate hooks must not duplicate a sample")
assert(normal.analytics[1][2] == "CL_FishingCast_v1" and normal.analytics[1][3] == 1)
assert(normal.analytics[2][2] == "CL_FishingCatch_v1" and normal.analytics[2][3] == normal.lastOptions.Weight)
assert(normal.analytics[3][2] == "CL_FishWeight_v1" and normal.analytics[3][4] == normal.lastFish)

local free = fishingHarness()
free.newAnalyticsPlayer = true
free.profile.Data.FishingOnboarding = { Stage = "FinalCatch" }
free.profile.Data.EquippedRodId = "Rod_102"
free.profile.Data.Wins = 0
free.begin("NONE")
free.cast()
assert(free.hook().ok and free.profile.Data.FishingOnboarding.Stage == "FinalCatch")
assert(#free.analytics == 2 and free.analytics[1][2] == "FinalCatchStarted")
assert(free.analytics[2][1] == "Detail" and free.analytics[2][3] == "FreePracticeSelected")
assert(free.fireBiteTimer == nil)
