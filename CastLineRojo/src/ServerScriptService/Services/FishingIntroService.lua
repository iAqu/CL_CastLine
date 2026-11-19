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
local Progression = require(Modules.FishingProgression)
local Rods = require(ReplicatedFirst.Data.RodsData)

local Service = Knit.CreateService({ Name = "FishingIntroService", Client = {} })
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

function Service.Client:ClaimAutoPlay(player)
	if PlayerDataService:IsStudioOnboardingTest() then
		return false
	end
	local profile = PlayerDataService:GetProfile(player)
	if not profile or not profile:IsActive() or autoClaims[player] or profile.MetaData.SessionLoadCount ~= 1 then
		return false
	end
	-- Claim and consume without yielding. Cancel/death never restores this first-session claim.
	autoClaims[player] = "Claimed"
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
		if autoClaims[player] ~= "Claimed" or profile.MetaData.SessionLoadCount ~= 1 then
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
	return { ok = true, token = token, preview = preview }
end

function Service.Client:StartPlayback(player, token)
	local state = current(player, token)
	if not state or state.phase ~= "Prepared" then
		return failure("Opening playback unavailable")
	end
	state.phase = "ReadyToCast"
	return { ok = true }
end

function Service.Client:Cast(player, token, progress)
	local state = current(player, token)
	local now = Workspace:GetServerTimeNow()
	if
		not state
		or state.phase ~= "ReadyToCast"
		or type(progress) ~= "number"
		or progress ~= progress
		or progress < 0
		or progress > 1
	then
		return failure("Opening cast unavailable")
	end
	state.phase = "Waiting"
	state.spin = ProjectileMath.FlightTime(FishingConfig.FixedCastDistance) * 7
	state.landingAt = now
		+ FishingConfig.CastLeadTime
		+ FishingConfig.ReleaseTime
		+ ProjectileMath.FlightTime(FishingConfig.FixedCastDistance)
	return { ok = true, distance = FishingConfig.FixedCastDistance, luck = 1 }
end

function Service.Client:NextRound(player, token, previousRound)
	local state = current(player, token)
	local now = Workspace:GetServerTimeNow()
	if
		not state
		or state.phase ~= "Waiting"
		or previousRound ~= state.round
		or now < math.max(state.landingAt, state.nextRoundAt or 0)
	then
		return failure("Opening round unavailable")
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
	local biteAt = BiteSequence.GetBiteWindow(
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
	state.biteAt = biteAt
	return {
		ok = true,
		round = state.round,
		fishId = fish.FishID,
		catchId = fish.FishID,
		catchKind = "Fish",
		weight = state.weight,
		startedAt = startedAt,
		readyAt = readyAt,
		seed = seed,
		motionSeed = motionSeed,
		retryAt = math.huge,
		luck = 1,
	}
end

function Service.Client:Hook(player, token, round, pressedAt)
	local state = current(player, token)
	local now = Workspace:GetServerTimeNow()
	if
		not state
		or state.phase ~= "Waiting"
		or state.round == 0
		or state.round ~= round
		or type(pressedAt) ~= "number"
		or pressedAt ~= pressedAt
		or pressedAt < state.biteAt
		or pressedAt > now + 0.08
		or now - pressedAt > 0.45
	then
		return failure("Missed the bite")
	end
	state.phase = "Claiming" -- Claim before ItemGrantUtil, which may yield.
	local fish = Fishes[Config.StarterFishId]
	local profile = PlayerDataService:GetProfile(player)
	if not profile then
		return failure("Opening data unavailable")
	end
	if not state.preview then
		if (profile.Data.FishingIntroVersion or 0) >= Config.Version then
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
		local uid = "FishingIntro_" .. tostring(Config.Version)
		local succeeded, granted, err = pcall(ItemGrantUtil.Grant, player, fish.FishID, {
			Weight = state.weight,
			CountTowardTotalWeight = true,
			InstanceId = uid,
			BeforeCommit = function()
				return (profile.Data.FishingIntroVersion or 0) < Config.Version, "Opening reward already received"
			end,
			OnCommitted = function()
				profile.Data.FishingIntroVersion = Config.Version
				Onboarding.Advance(player, profile.Data, nil, "FirstCatch")
				if starter then
					Progression.Record(progress, "Rod_101", fish.FishID, starter.band, starter.isMax)
				end
			end,
		})
		if not succeeded or not granted then
			claiming[player] = nil
			return failure(err or "Could not store your first fish")
		end
		profile.Data.FishingIntroVersion = Config.Version
		claiming[player] = nil
	end
	state.phase = "Caught"
	return { ok = true, weight = state.weight, catchId = fish.FishID, catchKind = "Fish", isNewDiscovery = true }
end

function Service.Client:Cancel(player, token)
	local state = sessions[player]
	if state and state.token == token then
		sessions[player] = nil
	end
end

function Service:IsActive(player)
	return sessions[player] ~= nil
end

function Service:KnitStart()
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
