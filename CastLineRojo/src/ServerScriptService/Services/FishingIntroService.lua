local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local ReplicatedFirst = game:GetService("ReplicatedFirst")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")

local Modules = ReplicatedStorage.Modules
local Config = require(Modules.FishingIntroConfig)
local Onboarding = require(Modules.FishingOnboarding)
local FishingConfig = require(Modules.FishingConfig)
local Assets = require(Modules.FishingAssets)
local BiteSequence = require(Modules.FishingBiteSequence)
local ProjectileMath = require(Modules.FishingProjectileMath)
local Fishes = require(ReplicatedFirst.Data.FishesData)
local Knit = require(ReplicatedStorage.Packages.Knit)
local PlayerDataService = require(script.Parent.PlayerDataService)
local ItemGrantUtil = require(script.Parent.ItemGrantUtil)
local Analytics = require(script.Parent.OnboardingAnalyticsService)
local Progression = require(Modules.FishingProgression)
local Rods = require(ReplicatedFirst.Data.RodsData)

local Service = Knit.CreateService({
	Name = "FishingIntroService",
	Client = { AnalyticsPresentation = Knit.CreateSignal() },
})
local sessions = {}
local claiming = {}
local autoClaims = {}
local random = Random.new()

local function failure(message)
	return { ok = false, message = message }
end

local function current(player, token)
	local state = sessions[player]
	local humanoid = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
	return if state
			and state.token == token
			and state.character == player.Character
			and humanoid
			and humanoid.Health > 0
		then state
		else nil
end

local function canAutoPlay(profile)
	local progress = profile.Data.FishingOnboarding
	return profile.MetaData.SessionLoadCount == 1 and not (progress and progress.Stage)
end

function Service.Client:ClaimAutoPlay(player)
	if PlayerDataService:IsStudioOnboardingTest() then
		return false
	end
	local profile = PlayerDataService:GetProfile(player)
	if not profile or not profile:IsActive() or autoClaims[player] or not canAutoPlay(profile) then
		return false
	end
	-- Claim and consume without yielding. Cancel/death never restores this first-session claim.
	autoClaims[player] = "Claimed"
	Analytics:Step(player, "IntroClaimed")
	return true
end

function Service.Client:Begin(player, mode)
	local profile = PlayerDataService:GetProfile(player)
	local character = player.Character
	local humanoid = character and character:FindFirstChildOfClass("Humanoid")
	if mode ~= "Auto" and mode ~= "Preview" then
		return failure("Invalid opening mode")
	end
	if mode == "Preview" and not RunService:IsStudio() then
		return failure("Opening preview is Studio-only")
	end
	local preview = mode == "Preview"
	if not profile or not profile:IsActive() or not humanoid or humanoid.Health <= 0 then
		return failure("Opening character or data is not ready")
	end
	if claiming[player] or (sessions[player] and not (mode == "Preview" and sessions[player].preview)) then
		return failure("Opening already active")
	end
	if mode == "Auto" then
		if autoClaims[player] ~= "Claimed" or not canAutoPlay(profile) then
			return failure("Opening first-session claim unavailable")
		end
		autoClaims[player] = "Started"
	end
	local token = HttpService:GenerateGUID(false)
	Knit.GetService("TrainingService"):Stop(player, false)
	sessions[player] = {
		token = token,
		character = character,
		phase = "Prepared",
		round = 0,
		preview = preview,
	}
	if not preview then
		Analytics:Step(player, "IntroCreated")
	end
	return { ok = true, token = token, preview = preview }
end

function Service.Client:StartPlayback(player, token)
	local state = current(player, token)
	if not state or state.phase ~= "Prepared" then
		return failure("Opening playback unavailable")
	end
	state.phase = "ReadyToCast"
	state.meterStartsAt = Workspace:GetServerTimeNow() + 0.25
	if not state.preview then
		Analytics:Step(player, "IntroStarted")
	end
	return { ok = true, meterStartsAt = state.meterStartsAt }
end

function Service.Client:Cast(player, token)
	local state = current(player, token)
	local now = Workspace:GetServerTimeNow()
	if not state or state.phase ~= "ReadyToCast" or now < state.meterStartsAt then
		return failure("Opening cast unavailable")
	end
	local progress = FishingConfig.GetCastMeterProgress(now - state.meterStartsAt - FishingConfig.GetFishingInputDelay(player))
	local castRating = FishingConfig.GetCastRating(progress).Id
	local castProfile = FishingConfig.GetCastProfile(castRating)
	local distance = FishingConfig.FixedCastDistance
	local flightTime = ProjectileMath.FlightTime(distance)
	state.phase = "Waiting"
	state.spin = flightTime * 7
	state.landingAt = now + castProfile.LeadTime + castProfile.ReleaseTime + flightTime
	if not state.preview then
		Analytics:Step(player, "IntroCast")
	end
	return { ok = true, distance = distance, luck = 1, castRating = castRating, castProgress = progress }
end

function Service.Client:NextRound(player, token, previousRound)
	local state = current(player, token)
	local now = Workspace:GetServerTimeNow()
	if
		not state
		or state.phase ~= "Waiting"
		or previousRound ~= state.round
	then
		return failure("Opening round unavailable")
	end
	local nextRoundAt = math.max(state.landingAt, state.nextRoundAt or 0)
	if now < nextRoundAt then
		return { ok = false, code = "RoundNotReady", retryAfter = nextRoundAt - now }
	end
	-- Repeating a request cannot skip the server's scheduled bite or mint more rewards.
	state.nextRoundAt = now + 0.8
	local fish = Fishes[Config.StarterFishId]
	local template = Assets.GetFish(fish.Model)
	state.weight = fish.DefaultWeight
	local bait = Assets.GetBait(nil)
	if not template or not bait then
		return failure("Opening fishing assets unavailable")
	end
	local startedAt = now + 0.35
	local readyAt = startedAt + 0.5
	local seed, motionSeed = random:NextInteger(1, 2 ^ 30), random:NextInteger(1, 2 ^ 30)
	local biteAt, biteEndsAt = BiteSequence.GetBiteWindow(
		template,
		bait.Size * FishingConfig.BaitFlightScale,
		startedAt,
		readyAt,
		seed,
		motionSeed,
		state.spin,
		fish,
		"Fish",
		true,
		state.weight
	)
	state.round += 1
	state.hookResult = nil
	state.biteAt, state.biteEndsAt = biteAt, biteEndsAt
	if not state.preview and Analytics:IsNewPlayer(player) then
		Analytics:Step(player, "IntroLanded")
		local round = state.round
		task.delay(math.max(0, biteAt - Workspace:GetServerTimeNow()), function()
			if current(player, token) == state and state.phase == "Waiting" and state.round == round then
				Analytics:Step(player, "IntroBite")
			end
		end)
	end
	return {
		ok = true,
		round = state.round,
		fishId = fish.FishID,
		catchId = fish.FishID,
		catchKind = "Fish",
		weight = state.weight,
		startedAt = startedAt,
		readyAt = readyAt,
		biteAt = biteAt,
		biteEndsAt = biteEndsAt,
		seed = seed,
		motionSeed = motionSeed,
		retryAt = math.huge,
		luck = 1,
		sentAt = Workspace:GetServerTimeNow(),
	}
end

local function claimHook(player, state)
	if not state.preview then
		Analytics:Step(player, "IntroBite")
	end
	local fish = Fishes[Config.StarterFishId]
	local profile = PlayerDataService:GetProfile(player)
	if not profile then
		state.phase = "Waiting"
		return failure("Opening data unavailable")
	end
	if not state.preview then
		if (profile.Data.FishingIntroVersion or 0) >= Config.Version then
			state.phase = "Waiting"
			return failure("Opening reward already received")
		end
		claiming[player] = true
		local progress = Progression.Ensure(profile.Data)
		local pool = Progression.BuildPool(Fishes, Rods.Rod_101, Rods, Assets.GetFish)
		local starter
		for _, entry in ipairs(pool) do
			if entry.fish.FishID == fish.FishID then
				starter = entry
				break
			end
		end
		local uid = Config.RewardUidPrefix .. tostring(Config.Version)
		local committed = false
		local succeeded, granted, err = pcall(ItemGrantUtil.Grant, player, fish.FishID, {
			Weight = state.weight,
			CountTowardTotalWeight = true,
			RecordFishingCatch = true,
			InstanceId = uid,
			BeforeCommit = function()
				return (profile.Data.FishingIntroVersion or 0) < Config.Version, "Opening reward already received"
			end,
			OnCommitted = function()
				profile.Data.FishingIntroVersion = Config.Version
				state.caughtUid = uid
				committed = true
				Onboarding.Advance(player, profile.Data, nil, "PlaceFish", uid)
				Analytics:Step(player, "IntroCaught")
				if starter then
					Progression.Record(progress, "Rod_101", fish.FishID, starter.band, starter.isMax)
				end
			end,
		})
		claiming[player] = nil
		if not committed then
			state.phase = "Waiting"
			return failure(if succeeded then err or "Could not store your first fish" else "Could not store your first fish")
		end
		if not succeeded then
			warn("FishingIntroService: opening reward committed; presentation failed", granted)
		end
	end
	state.phase = "Caught"
	return { ok = true, weight = state.weight, catchId = fish.FishID, catchKind = "Fish", isNewDiscovery = true }
end

function Service.Client:Hook(player, token, round, pressedAt)
	local state = current(player, token)
	local now = Workspace:GetServerTimeNow()
	if
		not state
		or state.phase ~= "Waiting"
		or state.round == 0
		or state.round ~= round
	then
		return failure("Missed the bite")
	end
	if not FishingConfig.GetHookTime(now, pressedAt, state.biteAt, state.biteEndsAt, player:GetNetworkPing()) then
		local result = failure("Missed the bite")
		state.hookResult = result
		return result
	end

	-- A duplicate request cannot grant again while this call is waiting for the backpack.
	state.hookResult = nil
	state.phase = "Claiming"
	local result = claimHook(player, state)
	state.hookResult = result
	return result
end

function Service.Client:GetHookResult(player, token, round)
	local state = current(player, token)
	if not state or state.round == 0 or state.round ~= round then
		return { status = "Unknown" }
	end
	if state.hookResult then
		return { status = if state.hookResult.ok then "Succeeded" else "Rejected", result = state.hookResult }
	end
	return { status = if state.phase == "Claiming" then "Pending" else "Unknown" }
end

function Service.Client:Cancel(player, token, continued)
	local state = sessions[player]
	if state and state.token == token then
		sessions[player] = nil
		if continued == true and state.phase == "Caught" and state.caughtUid then
			Analytics:Detail(player, "Intro", "ContinueConfirmed")
			Analytics:Detail(player, "Intro", "ControlsRestored")
			ItemGrantUtil.EquipCaughtFish(player, state.character, state.caughtUid)
		end
	end
end

function Service:IsActive(player)
	return sessions[player] ~= nil
end

function Service:KnitStart()
	self.Client.AnalyticsPresentation:Connect(function(player, token, detail)
		local state = current(player, token)
		if state and not state.preview then
			Analytics:FishingPresentation(player, "Intro", state.phase, state.round, detail)
		end
	end)
	Players.PlayerRemoving:Connect(function(player)
		sessions[player] = nil
		autoClaims[player] = nil
		claiming[player] = nil
	end)
	local function bind(player)
		player.CharacterRemoving:Connect(function(character)
			if sessions[player] and sessions[player].character == character then
				sessions[player] = nil
			end
		end)
	end
	Players.PlayerAdded:Connect(bind)
	for _, player in Players:GetPlayers() do
		bind(player)
	end
end

return Service
