local function read(path)
	local file = assert(io.open(path, "r"))
	local source = file:read("*a")
	file:close()
	return source
end

local function loadModule(path, environment)
	return assert(load(read("src/" .. path .. ".lua"), path, "t", environment or getfenv()))()
end

local config = loadModule("ReplicatedStorage/Modules/FishingIntroConfig")
local openingUid = config.RewardUidPrefix .. tostring(config.Version)
local fishing = loadModule("ReplicatedStorage/Modules/FishingConfig")
local lift = loadModule("ReplicatedStorage/Modules/FishingLiftMotion")
local bite = loadModule(
	"ReplicatedStorage/Modules/FishingBiteSequence",
	setmetatable({
		game = {
			GetService = function()
				return {}
			end,
		},
		script = { Parent = { FishingConfig = fishing, FishingLiftMotion = lift } },
		require = function(module)
			return module or {}
		end,
	}, { __index = getfenv() })
)
local rng = {
	NextInteger = function(_, minimum)
		return minimum
	end,
	NextNumber = function(_, minimum, maximum)
		return (minimum + maximum) / 2
	end,
}
local fish = { NibbleCountMin = 0, NibbleCountMax = 0, HookWindow = 0.85, StruggleTime = 0.5 }
local tutorial = bite.NewTimeline(0, rng, 0.5, fish, "Fish", true)
local nibbles = 0
while tutorial.phase ~= "Bite" do
	tutorial:Advance(tutorial.endsAt)
	if tutorial.phase == "Nibbling" then
		nibbles += 1
	end
end
assert(nibbles == 2 and tutorial.completedNibbles == 2)
assert(tutorial.endsAt == math.huge and tutorial.struggleTime == 3)
assert(tutorial:Advance(1e6) == "Bite", "First genuine bite must wait for input")
assert(tutorial:TryHook(1e6) and not tutorial:TryHook(1e6), "One input must start one catch")
assert(tutorial:Advance(1e6 + 3) == "Lifting")
local normal = bite.NewTimeline(0, rng, 0.5, fish, "Fish")
while normal.phase ~= "Bite" do
	normal:Advance(normal.endsAt)
end
assert(normal.completedNibbles == 0 and normal.hookWindow == 0.85 and normal.struggleTime == 0.5)
assert(normal:Advance(normal.endsAt) == "Escaped", "Normal fishing must retain its finite hook window")
assert(fish.HookWindow == 0.85 and fish.NibbleCountMin == 0, "Tutorial must not mutate shared fish data")

local function fixture(preview, cancelDuringGrant, onboardingTest)
	local now, grants, guid = 100, 0, 0
	local heldUid, equips = nil, 0
	local profile = {
		Data = { FishingIntroVersion = 0, TotalItemWeightTenths = 0 },
		MetaData = { SessionLoadCount = 1 },
		IsActive = function() return true end,
	}
	local humanoid = { Health = 100 }
	local character = {
		FindFirstChildOfClass = function()
			return humanoid
		end,
	}
	local player = { Character = character, SetAttribute = function() end, GetNetworkPing = function() return 0 end }
	local client, token, round, meterStartsAt
	local grantFails = false
	local services = {
		HttpService = {
			GenerateGUID = function()
				guid += 1
				return tostring(guid)
			end,
		},
		Players = {},
		RunService = {
			IsStudio = function()
				return preview
			end,
		},
		Workspace = {
			GetServerTimeNow = function()
				return now
			end,
		},
		ReplicatedFirst = {
			Data = {
				RodsData = {Rod_101={RodID="Rod_101",Rarity="Common",LayoutOrder=1}},
				FishesData = {
					[config.StarterFishId] = { FishID = config.StarterFishId, Model = "TestFish", DefaultWeight = 1, Rarity="Common",Index=1 },
				},
			},
		},
		ReplicatedStorage = {
			Modules = {
				TrainingProgress = loadModule("ReplicatedStorage/Modules/TrainingProgress"),
				FishingProgression = loadModule("ReplicatedStorage/Modules/FishingProgression",setmetatable({
 script={Parent={FishingConfig=fishing}},require=function(v) return v end,
},{__index=getfenv()})),
				FishingIntroConfig = config,
				FishingOnboarding = loadModule("ReplicatedStorage/Modules/FishingOnboarding"),
				FishingConfig = fishing,
				FishingAssets = {
					GetFish = function()
						return {}
					end,
					GetBait = function()
						return { Size = 1 }
					end,
				},
				FishingProjectileMath = {
					FlightTime = function()
						return 1
					end,
				},
				FishingBiteSequence = {
					GetBiteWindow = function(_, _, _, ready, _, _, _, _, _, isTutorial)
						assert(isTutorial == true, "Server must schedule the protected tutorial timeline")
						return ready + 3, math.huge
					end,
				},
			},
			Packages = { Knit = {
				CreateSignal = function() return {} end,
				GetService = function()
					return { Stop = function() end, GetMaxCatchWeight = function() error("Tutorial must not read training weight") end }
				end,
				CreateService = function(service)
					return service
				end,
			} },
		},
	}
	local service = loadModule(
		"ServerScriptService/Services/FishingIntroService",
		setmetatable({
			game = {
				GetService = function(_, name)
					return services[name]
				end,
			},
			require = function(module)
				return module
			end,
			Random = {
				new = function()
					return rng
				end,
			},
			script = {
				Parent = {
					OnboardingAnalyticsService = {
						Step = function() end, Detail = function() end, IsNewPlayer = function() return false end,
					},
					PlayerDataService = {
						IsStudioOnboardingTest = function() return onboardingTest == true end,
						GetProfile = function()
							return profile
						end,
					},
					ItemGrantUtil = {
						EquipCaughtFish = function(receiver, caughtCharacter, uid)
							assert(receiver == player and caughtCharacter == character)
							heldUid = uid
							equips += 1
						end,
						Grant = function(_, id, options)
							assert(client:GetHookResult(player, token, round).status == "Pending")
							if grantFails then
								return nil, "Backpack unavailable"
							end
							grants += 1
							assert(
								id == config.StarterFishId and options.CountTowardTotalWeight and options.Weight == 1
							)
							assert(
								not client:Hook(player, token, round).ok,
								"Grant yield must not allow a concurrent claim"
							)
							if cancelDuringGrant then
								client:Cancel(player, token)
								assert(not client:Begin(player, "Auto").ok, "Cancellation during a grant must not reopen reward eligibility")
							end
							assert(options.BeforeCommit())
							profile.Data.Items = profile.Data.Items or {}
							profile.Data.Items[options.InstanceId] = { ItemId = id, Weight = options.Weight }
							options.OnCommitted()
							return { Weight = 1 }
						end,
					},
				},
			},
		}, { __index = getfenv() })
	)
	client = service.Client
	local requested = false
	return {
		client = client,
		player = player,
		profile = profile,
		humanoid = humanoid,
		time = function(value)
			now = value or now
			return now
		end,
		heldUid = function() return heldUid end,
		equips = function() return equips end,
		grants = function()
			return grants
		end,
		failGrant = function()
			grantFails = true
		end,
		begin = function(mode, prepareOnly)
			mode = mode or (if preview then "Preview" else "Auto")
			if not requested and mode == "Auto" then
				client:ClaimAutoPlay(player)
			end
			requested = true
			local result = client:Begin(player, mode)
			token = result.token
			if token and not prepareOnly then
				local playback = client:StartPlayback(player, token)
				assert(playback.ok)
				meterStartsAt = playback.meterStartsAt
			end
			return result
		end,
		startPlayback = function()
			local playback = client:StartPlayback(player, token)
			meterStartsAt = playback.meterStartsAt
			return playback
		end,
		cast = function(progress)
			if progress then
				local meter = fishing.Meter
				local acceleration = meter.BaseSpeed * (meter.TopSpeedFactor - 1)
				local period = 2 * math.log(meter.TopSpeedFactor) / acceleration
				local elapsed = math.log(1 + (meter.TopSpeedFactor - 1) * progress) / acceleration
				local cycles = math.max(0, math.ceil((now - meterStartsAt - elapsed) / period))
				now = meterStartsAt + cycles * period + elapsed
			end
			return client:Cast(player, token)
		end,
		round = function(previous)
			local result = client:NextRound(player, token, previous)
			if result.ok then
				round = result.round
			end
			return result
		end,
		hook = function(time, roundOverride)
			return client:Hook(player, token, roundOverride or round, time)
		end,
		hookResult = function(roundOverride)
			return client:GetHookResult(player, token, roundOverride or round)
		end,
		cancel = function(finished)
			client:Cancel(player, token, finished)
		end,
	}
end

for _, case in ipairs({
	{ progress = 0.949999, rating = "PERFECT", profile = fishing.CastProfiles.Normal },
	{ progress = 0.950001, rating = "GODLIKE", profile = fishing.CastProfiles.Godlike },
	{ progress = 1, rating = "GODLIKE", profile = fishing.CastProfiles.Godlike },
}) do
	local intro = fixture(false)
	assert(intro.begin().ok)
	local castTime = 120
	intro.time(castTime)
	local cast = intro.cast(case.progress)
	assert(cast.ok and cast.castRating == case.rating, "Intro must confirm the shared rating for " .. case.progress)
	assert(cast.distance == fishing.FixedCastDistance and cast.luck == 1)
	local landingTime = intro.time() + case.profile.LeadTime + case.profile.ReleaseTime + 1 -- Mocked flight time.
	intro.time(landingTime - 0.001)
	assert(not intro.round(0).ok, "Intro must reject a bite round before " .. case.rating .. " lands")
	intro.time(landingTime + 0.001)
	assert(intro.round(0).ok, "Intro must allow a bite round after " .. case.rating .. " lands")
end

local live = fixture(false)
assert(live.begin("Auto",true).ok)
assert(not live.cast().ok,"Input before loading handoff must not start casting")
assert(live.startPlayback().ok)
live.time(120)
assert(live.cast().ok)
local early = live.round(0)
assert(early.code == "RoundNotReady" and early.retryAfter > 0, "Report how long remains until landing")
assert(live.round(7).code ~= "RoundNotReady")
live.time(124)
local first = live.round(0)
assert(first.ok and first.weight == 1 and not live.round(0).ok,"Tutorial round must use the configured default weight")
assert(not live.hook(124).ok, "Cannot claim before a genuine bite")
assert(live.hookResult().status == "Rejected" and live.hookResult(0).status == "Unknown")
live.time(first.biteAt + 0.4)
assert(not live.hook(first.biteAt + 0.2, 0).ok, "Wrong round must remain ineligible")
assert(not live.hook(first.biteAt).ok, "Opening round must also enforce the delivery budget")
assert(live.hook(first.biteAt + 0.2).ok and live.grants() == 1, "Opening round uses the mapped press")
assert(not live.hook(first.biteAt + 0.2).ok and live.grants() == 1)
assert(live.hookResult().status == "Succeeded" and live.hookResult().result.weight == 1 and live.grants() == 1)
assert(live.profile.Data.FishingIntroVersion == config.Version)
assert(live.profile.Data.FishingOnboarding.Stage == "PlaceFish" and live.profile.Data.FishingOnboarding.FishUid == openingUid)
assert(live.profile.Data.FishingProgress.Count == 1, "Teaching fish counts once toward newcomer milestones")
assert(live.heldUid() == nil)
live.cancel(true)
live.cancel(true)
local introReward = live.profile.Data.Items[openingUid]
assert(live.heldUid() == openingUid and live.equips() == 1, "Continue equips the committed opening fish exactly once")
assert(introReward.ItemId == config.StarterFishId and introReward.Weight == 1 and live.grants() == 1)
assert(not live.begin().ok, "Consumed first-session claim must not reopen after completion")

local disconnected = fixture(false)
disconnected.begin()
disconnected.time(120)
disconnected.cast()
disconnected.time(124)
disconnected.round(0)
disconnected.time(128)
assert(disconnected.hook(128).ok)
disconnected.cancel(false)
disconnected.profile.MetaData.SessionLoadCount = 2
assert(not disconnected.client:ClaimAutoPlay(disconnected.player))
assert(disconnected.profile.Data.FishingOnboarding.Stage == "PlaceFish")
assert(disconnected.profile.Data.FishingOnboarding.FishUid == openingUid and disconnected.profile.Data.Items[openingUid])
assert(disconnected.heldUid() == nil and disconnected.grants() == 1, "Leaving before Continue preserves the fish for placement on rejoin")

local retry = fixture(false)
retry.begin()
retry.time(120)
retry.cast()
retry.time(124)
assert(retry.round(0).ok)
retry.time(125)
assert(retry.round(1).ok, "A mistaken early hook must allow a new round without a new cast")
retry.time(129)
assert(not retry.hook(129, 1).ok and retry.hook(129).ok)

local studio = fixture(true)
assert(studio.begin().preview, "Explicit Studio preview must use the reward-free path")
studio.time(120)
studio.cast()
studio.time(124)
studio.round(0)
studio.time(1e6)
assert(studio.hook(1e6).ok and studio.grants() == 0)
assert(studio.profile.Data.FishingIntroVersion == 0 and studio.profile.Data.FishingOnboarding == nil,
	"Studio preview must not write real onboarding progress")
studio.cancel(true)
assert(studio.heldUid() == nil)
assert(studio.begin().token, "Studio can replay the cutscene")

local interrupted = fixture(false)
interrupted.begin()
interrupted.humanoid.Health = 0
interrupted.time(120)
assert(not interrupted.cast().ok and interrupted.grants() == 0)
local veteran = fixture(false)
veteran.profile.MetaData.SessionLoadCount = 2
assert(not veteran.begin().ok, "Existing zero-catch players must not auto-play")

local failedGrant = fixture(false)
failedGrant.begin()
failedGrant.time(120)
failedGrant.cast()
failedGrant.time(124)
failedGrant.round(0)
failedGrant.time(128)
failedGrant.failGrant()
assert(not failedGrant.hook(128).ok and failedGrant.profile.Data.FishingIntroVersion == 0)

local racing = fixture(false, true)
racing.begin()
racing.time(120)
racing.cast()
racing.time(124)
racing.round(0)
racing.time(128)
assert(racing.hook(128).ok and racing.grants() == 1)
assert(racing.profile.Data.FishingOnboarding.Stage == "PlaceFish" and racing.profile.Data.Items[openingUid])
assert(racing.heldUid() == nil, "A grant completing after interruption leaves the fish for inventory recovery")
assert(not racing.begin().ok, "A grant that finishes after cancellation must still close onboarding eligibility")

local unclaimed = fixture(false)
assert(not unclaimed.client:Begin(unclaimed.player, "Auto").ok, "Auto requires a server claim")
assert(not unclaimed.client:Begin(unclaimed.player, "Preview").ok, "Production rejects preview")
assert(not unclaimed.client:Begin(unclaimed.player, "Other").ok)
assert(unclaimed.client:ClaimAutoPlay(unclaimed.player))
assert(not unclaimed.client:ClaimAutoPlay(unclaimed.player), "First session may only claim once")
local claimedToken = unclaimed.client:Begin(unclaimed.player, "Auto").token
assert(claimedToken)
unclaimed.client:Cancel(unclaimed.player, claimedToken)
assert(not unclaimed.client:Begin(unclaimed.player, "Auto").ok, "Interruption cannot restart auto-play")
unclaimed.profile.MetaData.SessionLoadCount = 2
assert(not unclaimed.client:ClaimAutoPlay(unclaimed.player), "Rejoining cannot claim again")

for _, stage in ipairs({ "PlaceFish", "Train", "StopTraining", "RodReward", "FinalCatch", "Complete" }) do
	local resumed = fixture(false)
	resumed.profile.Data.FishingOnboarding = { Stage = stage }
	assert(not resumed.client:ClaimAutoPlay(resumed.player), "Saved stage must take priority over first-session metadata: " .. stage)
end

local resumedDuringClaim = fixture(false)
assert(resumedDuringClaim.client:ClaimAutoPlay(resumedDuringClaim.player))
resumedDuringClaim.profile.Data.FishingOnboarding = { Stage = "Train" }
assert(not resumedDuringClaim.client:Begin(resumedDuringClaim.player, "Auto").ok,
	"Starting the opening must not interrupt a saved training checkpoint")

local prepared = fixture(false)
assert(prepared.begin("Auto", true).ok)
prepared.time(1000)
assert(not prepared.cast().ok, "Time under loading cannot unlock teaching")
local playback = prepared.startPlayback()
assert(playback.ok)
assert(not prepared.startPlayback().ok, "Repeated start cannot reset the server clock")
assert(not prepared.cast().ok, "The server start time provides time to show the meter")
prepared.time(playback.meterStartsAt)
assert(prepared.cast().ok, "Cast unlocks at the synchronized start time")
assert(not prepared.cast().ok, "Repeated input cannot start another cast")

local progressDoesNotGate = fixture(false)
progressDoesNotGate.profile.Data.TotalItemWeightTenths = 5
progressDoesNotGate.profile.Data.FishingIntroVersion = config.Version
assert(progressDoesNotGate.begin().ok, "Eligibility depends on session metadata, not progression")
progressDoesNotGate.time(120)
progressDoesNotGate.cast()
progressDoesNotGate.time(124)
progressDoesNotGate.round(0)
progressDoesNotGate.time(128)
assert(not progressDoesNotGate.hook(128).ok and progressDoesNotGate.grants() == 0, "Completion version still prevents duplicate grants")

local studioAuto = fixture(true)
local opening = studioAuto.begin("Auto")
assert(opening.ok and not opening.preview, "First-session Studio Auto uses the normal reward flow")
studioAuto.time(120)
assert(studioAuto.cast().ok)
studioAuto.time(124)
assert(studioAuto.round(0).ok)
studioAuto.time(128)
assert(studioAuto.hook(128).ok and studioAuto.grants() == 1)
assert(studioAuto.profile.Data.FishingIntroVersion == config.Version)
assert(studioAuto.profile.Data.FishingOnboarding.Stage == "PlaceFish")
assert(not studioAuto.hook(128).ok and studioAuto.grants() == 1)
assert(studioAuto.heldUid() == nil)
studioAuto.cancel(true)
assert(studioAuto.heldUid() == openingUid)

local onboardingPreview = fixture(true, false, true)
assert(not onboardingPreview.client:ClaimAutoPlay(onboardingPreview.player), "Onboarding tests skip the opening")
assert(not onboardingPreview.begin("Auto").ok)
assert(onboardingPreview.begin("Preview").preview, "F6 can still preview the opening during an onboarding test")

local replacing = fixture(true)
local previous = replacing.client:Begin(replacing.player, "Preview").token
local latest = replacing.client:Begin(replacing.player, "Preview").token
assert(previous and latest and previous ~= latest, "Rapid preview restart replaces the previous Studio session")
replacing.client:Cancel(replacing.player, previous)
assert(replacing.client:StartPlayback(replacing.player, latest).ok, "Late cancellation only owns its original token")
assert(not replacing.client:StartPlayback(replacing.player, previous).ok)
local inactive = fixture(false)
inactive.profile.IsActive = function() return false end
assert(not inactive.client:ClaimAutoPlay(inactive.player))
assert(not inactive.client:Begin(inactive.player, "Auto").ok)

-- Both presentations dispatch the exact normal nibble cue, without a genuine-bite sound.
do
 local effects = loadModule("ReplicatedStorage/Modules/FishingWaterEffects", setmetatable({
  game={GetService=function() return {} end},
  script={Parent={FishingConfig=fishing}},
  require=function(module) return module end,
  Vector3={new=function(x,y,z) return {X=x,Y=y,Z=z} end},
 },{__index=getfenv()}))
 local calls={}
 local position={X=4,Y=5,Z=6}
 local owner={
  _sound=function(_,name,volume,speed) table.insert(calls,{name,volume,speed}) end,
  _playWaterVFX=function(_,now,name,target) assert(now==10 and name==fishing.WaterVFX.Light and target.X==4 and target.Y==5 and target.Z==6) end,
  _waterTarget=function() return position end,
  _ripple=function(_,now,target,strength) assert(now==10 and target==position and strength==0.25) end,
 }
 effects.NibbleRipple(owner,10,position)
 effects.Nibble(owner,10,position)
 assert(#calls==1 and calls[1][1]=="Splash" and calls[1][2]==fishing.Sounds.Splash.Volume*0.25 and calls[1][3]==1.05)
end
