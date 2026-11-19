local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local ReplicatedFirst = game:GetService("ReplicatedFirst")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")

local Modules = ReplicatedStorage.Modules
local Config = require(Modules.FishingConfig)
local PetFeatureConfig = require(Modules.PetFeatureConfig)
local Assets = require(Modules.FishingAssets)
local BiteSequence = require(Modules.FishingBiteSequence)
local ProjectileMath = require(Modules.FishingProjectileMath)
local RodInventory = require(Modules.RodInventory)
local FishingRoll = require(Modules.FishingRoll)
local TrainingProgress = require(Modules.TrainingProgress)
local Progression = require(Modules.FishingProgression)
local BaitConfig = require(Modules.FishingBaitConfig)
local FishingSpotUtil = require(Modules.FishingSpotUtil)
local Onboarding = require(Modules.FishingOnboarding)
local Knit = require(ReplicatedStorage.Packages.Knit)
local ItemGrantUtil = require(script.Parent.ItemGrantUtil)
local PlayerDataService = require(script.Parent.PlayerDataService)

local data = ReplicatedFirst:WaitForChild("Data")
local FishesData = require(data:WaitForChild("FishesData"))
local EggsData = if PetFeatureConfig.Enabled then require(data:WaitForChild("EggsData")) else {}
local BaitsData = require(data:WaitForChild("BaitsData"))
local RodsData = require(data:WaitForChild("RodsData"))
local mutationRanges = FishingRoll.BuildMutationRanges(require(data:WaitForChild("MutationsData")))
local FishingService = Knit.CreateService({ Name = "FishingService", Client = {} })

local sessions = {}
local random = Random.new()
local ROUND_LEAD_SECONDS = 0.35
local MAX_HOOK_LATENCY = 0.45
local START_TIMEOUT = 60
local START_HORIZONTAL_TOLERANCE = 1

local function failure(message: string, code: string?)
	return { ok = false, message = message, code = code }
end

local function getLiveCharacter(player: Player): (Model?, BasePart?, Humanoid?)
	local character = player.Character
	local root = character and character:FindFirstChild("HumanoidRootPart")
	local humanoid = character and character:FindFirstChildOfClass("Humanoid")
	if root and root:IsA("BasePart") and humanoid and humanoid.Health > 0 then
		return character, root, humanoid
	end
	return nil, nil, nil
end

local function getSession(player: Player, token)
	local state = sessions[player]
	if state and state.token == token and getLiveCharacter(player) == state.character then
		return state
	end
	return nil
end

function FishingService.Client:Begin(player: Player)
	local character, root, humanoid = getLiveCharacter(player)
	if not character or not root or not humanoid then
		return failure("Fishing character unavailable")
	end
	local profile = PlayerDataService:GetProfile(player)
	if not profile then
		return failure("Your fishing data is still loading", "ProfileNotReady")
	end
	local plot = Knit.GetService("PlotSlotService"):GetPlayerPlot(player)
	local part = FishingSpotUtil.GetStartPart(plot)
	if not part or not FishingSpotUtil.Contains(part, root, humanoid, START_HORIZONTAL_TOLERANCE) then
		return failure("Stand at your fishing spot to start fishing", "OutsideFishingSpot")
	end
	local existing = sessions[player]
	local now = Workspace:GetServerTimeNow()
	if existing and existing.character == character and existing.expiresAt > now then
		return failure("Already fishing")
	end
	local rodId = RodInventory.GetEquippedId(profile.Data)
	local rod = RodsData[rodId]
	if not rod then
		return failure("Fishing rod unavailable")
	end
	local token = HttpService:GenerateGUID(false)
	Knit.GetService("TrainingService"):Stop(player, false)
	local progress = Progression.Ensure(profile.Data)
	local onboarding = profile.Data.FishingOnboarding
	local stage = onboarding and onboarding.Stage
	local lesson = if stage == "FirstCatch" or stage == "FinalCatch" then stage else nil
	local guideBaitId = if lesson == "FirstCatch" then "NONE" elseif lesson == "FinalCatch" then rod.BaitsSelect[1] else nil
	local quotes = {}
	if lesson ~= "FirstCatch" then
		for _, id in ipairs(rod.BaitsSelect) do
			quotes[id] = Progression.Quote(rod, id, BaitConfig, progress)
		end
	end
	if lesson == "FinalCatch" and not quotes[guideBaitId] then
		return failure("Your rod has no first-tier bait")
	end
	sessions[player] = {
		token = token,
		rod = rod,
		rodId = rodId,
		lesson = lesson,
		guideBaitId = guideBaitId,
		character = character,
		phase = "Selecting",
		expiresAt = math.huge,
		round = 0,
	}
	return {
		ok = true,
		token = token,
		rodId = rodId,
		baitQuotes = quotes,
		lesson = lesson,
		guideBaitId = guideBaitId,
	}
end

function FishingService.Client:SelectBait(player: Player, token, baitId)
	local state = getSession(player, token)
	if not state or state.phase ~= "Selecting" then
		return failure("Fishing selection unavailable")
	end
	if typeof(baitId) ~= "string" then
		return failure("Bait unavailable")
	end
	if state.lesson == "FirstCatch" and baitId ~= "NONE" then
		return failure("This lesson uses no bait.")
	end
	if state.lesson == "FinalCatch" and baitId ~= "NONE" and baitId ~= state.guideBaitId then
		return failure(Onboarding.GetBaitSelectionHint(BaitsData[state.guideBaitId]))
	end
	local bait = BaitsData[baitId]
	if baitId ~= "NONE" and (not bait or not table.find(state.rod.BaitsSelect, baitId)) then
		return failure("Bait unavailable for this rod")
	end
	local template = Assets.GetBait(if bait then bait.Model else nil)
	if not template then
		return failure("Bait model unavailable")
	end
	local pool, pity = Progression.BuildPool(FishesData, state.rod, RodsData, Assets.GetFish)
	local eggPool = if PetFeatureConfig.Enabled then FishingRoll.GetEggPool(EggsData, math.huge, Assets.GetEgg) else {}
	if #pool == 0 then
		return failure("No fish match this rod")
	end
	local profile = PlayerDataService:GetProfile(player)
	if not profile then
		return failure("Your fishing data is still loading")
	end
	local progress = Progression.Ensure(profile.Data)
	local practiceWithoutBait = state.lesson == "FinalCatch" and baitId == "NONE"
	if practiceWithoutBait then
		local firstTier = Progression.Quote(state.rod, state.guideBaitId, BaitConfig, progress)
		if profile.Data.Wins >= firstTier.price then
			return failure(Onboarding.GetBaitSelectionHint(BaitsData[state.guideBaitId]))
		end
	end
	local quote = Progression.Quote(state.rod, baitId, BaitConfig, progress)
	if not quote then
		return failure("Bait unavailable")
	end
	if not quote.available then
		return failure("Robux bait is not configured yet")
	end
	if quote.tier == 4 and quote.credits <= 0 then
		return { ok = false, needsPurchase = true, productId = quote.productId, message = "Purchase a Rainbow bait" }
	end
	if profile.Data.Wins < quote.price then
		if state.lesson == "FinalCatch" and bait then
			return failure("Not enough cash for " .. bait.DisplayName .. ". Select NONE to fish for free.")
		end
		return failure("Not enough cash")
	end
	if practiceWithoutBait then
		state.lesson = nil
	end
	state.quote, state.pity = quote, pity
	state.phase = "Preparing"
	state.bait, state.baitSize, state.pool = bait, template.Size * Config.BaitFlightScale, pool
	state.eggPool = eggPool
	state.initialYaw = random:NextNumber(0, 2 * math.pi)
	-- Meter preparation can stay open until the player casts or leaves.
	state.expiresAt = math.huge
	return {
		ok = true,
		initialYaw = state.initialYaw,
		lesson = state.lesson,
		luck = FishingRoll.GetLuck(state.rod, bait, Config.FixedCastDistance) * Knit.GetService("PetService")
			:GetLuckMultiplier(player),
	}
end

function FishingService.Client:Cast(player: Player, token, progress)
	local state = getSession(player, token)
	local now = Workspace:GetServerTimeNow()
	if not state or state.phase ~= "Preparing" then
		return failure("Cast unavailable")
	end
	if type(progress) ~= "number" or progress ~= progress or progress < 0 or progress > 1 then
		return failure("Invalid cast progress")
	end
	local pool, pity = Progression.BuildPool(FishesData, state.rod, RodsData, Assets.GetFish, progress)
	if #pool == 0 then return failure("No fish match this rod") end
	local rating = Config.GetCastRating(progress)
	state.castProgress, state.castRating = progress, rating.Id
	state.pool, state.pity = pool, pity
	local distance = Config.FixedCastDistance
	local eventFish = Knit.GetService("EventFishService"):GetActiveFish()
	state.eventFishId = eventFish and eventFish.FishID
	state.castLuckMultiplier = FishingRoll.GetCastLuckMultiplier(progress)
	state.phase, state.distance = "Waiting", distance
	local flightTime = ProjectileMath.FlightTime(distance)
	local presentation = Config.GetCastProfile(state.castRating)
	state.earliestLanding = now + presentation.LeadTime + presentation.ReleaseTime + flightTime
	state.spin = state.initialYaw + flightTime * 7
	state.expiresAt = math.huge
	return {
		ok = true,
		distance = distance,
		castRating = state.castRating,
		luck = FishingRoll.GetLuck(state.rod, state.bait, distance, state.castLuckMultiplier)
			* Knit.GetService("PetService"):GetLuckMultiplier(player),
	}
end

function FishingService.Client:NextRound(player: Player, token, previousRound)
	local state = getSession(player, token)
	local now = Workspace:GetServerTimeNow()
	if
		not state
		or state.phase ~= "Waiting"
		or previousRound ~= state.round
		or now < (state.retryAt or state.earliestLanding)
	then
		return failure("Fishing round unavailable")
	end
	local startedAt = now + ROUND_LEAD_SECONDS
	local luck = FishingRoll.GetLuck(state.rod, state.bait, state.distance, state.castLuckMultiplier)
	local petMultiplier = Knit.GetService("PetService"):GetLuckMultiplier(player)
	local profile = PlayerDataService:GetProfile(player)
	if not profile then
		return failure("Fishing data unavailable")
	end
	local progress = Progression.Ensure(profile.Data)
	local pending = state.pending
	if not pending then
		local lesson = state.lesson
		local lessonFishId = if lesson == "FirstCatch" then "Fish_103" elseif lesson == "FinalCatch" then "Fish_106" else nil
		local entry
		if lessonFishId then
			for _, candidate in ipairs(state.pool) do
				if candidate.fish.FishID == lessonFishId then
					entry = candidate
					break
				end
			end
			entry = entry or { fish = FishesData[lessonFishId], band = 1, isMax = false }
		else
			entry = Progression.Choose(state.pool, progress, state.rodId, state.pity, random)
		end
		if not entry then
			return failure("Fishing pool unavailable")
		end
		local kind, fish = "Fish", entry.fish
		if not lesson and state.eventFishId then
			fish = FishesData[state.eventFishId]
		elseif not lesson and PetFeatureConfig.Enabled and random:NextNumber() < Config.EggCatchChance then
			kind, fish = "Egg", FishingRoll.Choose(state.eggPool, 1, random)
		end
		if not fish then
			return failure("Catch unavailable")
		end
		pending = {
			Id = HttpService:GenerateGUID(false),
			Kind = kind,
			FishId = if kind == "Fish" then fish.FishID else fish.EggId,
			IsEvent = not lesson and state.eventFishId ~= nil,
			Band = entry.band,
			IsMax = entry.isMax,
			Weight = if kind == "Egg" then FishingRoll.RollWeight(fish.DefaultWeight, math.huge, random) else fish.DefaultWeight,
			MutationId = if lesson == "FinalCatch" then "Golden"
				elseif not lesson then Progression.RollMutation(state.quote.tier, BaitConfig, mutationRanges, random)
				else nil,
		}
		state.pending = pending
	end
	local catchKind = pending.Kind
	local fish = if catchKind == "Egg" then EggsData[pending.FishId] else FishesData[pending.FishId]
	if catchKind == "Fish" and fish then
		pending.MaxCatchWeight = Knit.GetService("TrainingService"):GetMaxCatchWeight(player)
		if state.lesson then
			local levels = require(data:WaitForChild("TrainingLevelsData"))
			local level = if state.lesson == "FirstCatch" then 1 else Onboarding.TrainingLevel
			pending.MaxCatchWeight = math.min(pending.MaxCatchWeight, TrainingProgress.GetLevel(levels, level).MaxCatchWeight)
		end
		pending.Weight = TrainingProgress.CalculateFishWeight(fish.DefaultWeight, pending.MaxCatchWeight)
	end
	local template = fish and (if catchKind == "Egg" then Assets.GetEgg(fish.Model) else Assets.GetFish(fish.Model))
	if not template then
		return failure("Fish model unavailable")
	end
	local seed, motionSeed = random:NextInteger(1, 2 ^ 30), random:NextInteger(1, 2 ^ 30)
	local landing = Config.Landing
	local settleTime = math.max(Config.ReturnInputDelay, landing.SinkTime + landing.ReboundTime + landing.SettleTime)
	local readyAt = if state.round == 0 then startedAt + settleTime else startedAt
	local biteAt, biteEndsAt = BiteSequence.GetBiteWindow(
		template,
		state.baitSize,
		startedAt,
		readyAt,
		seed,
		motionSeed,
		state.spin,
		fish,
		catchKind,
		state.lesson ~= nil,
		pending.Weight
	)
	state.round += 1
	state.roundLuck = luck * petMultiplier
	state.fishId = pending.FishId
	state.catchKind, state.catchId = catchKind, if catchKind == "Egg" then fish.EggId else fish.FishID
	state.biteAt, state.biteEndsAt = biteAt, biteEndsAt
	state.retryAt = if state.lesson then now + 0.2 else biteEndsAt + Config.Bite.EscapeTime
	return {
		ok = true,
		round = state.round,
		fishId = fish.FishID,
		catchKind = state.catchKind,
		catchId = state.catchId,
		weight = pending.Weight,
		maxCatchWeight = pending.MaxCatchWeight,
		startedAt = startedAt,
		readyAt = readyAt,
		retryAt = if state.lesson then math.huge else state.retryAt,
		mutationId = if state.lesson then pending.MutationId else nil,
		seed = seed,
		motionSeed = motionSeed,
		luck = state.roundLuck,
		castRating = state.castRating,
	}
end

function FishingService.Client:Hook(player: Player, token, round, pressedAt)
	local state = getSession(player, token)
	local now = Workspace:GetServerTimeNow()
	local pending = state and state.pending
	if
		not state
		or not pending
		or state.phase ~= "Waiting"
		or state.round == 0
		or state.round ~= round
		or typeof(pressedAt) ~= "number"
		or pressedAt ~= pressedAt
		or pressedAt < state.biteAt
		or pressedAt >= state.biteEndsAt
		or pressedAt > now + 0.08
		or now - pressedAt > MAX_HOOK_LATENCY
	then
		return failure("Missed the bite")
	end
	-- Claim before Grant, which may yield waiting for a Backpack.
	state.phase = "Claiming"
	local profile = PlayerDataService:GetProfile(player)
	if not profile then
		state.phase = "Waiting"
		return failure("Fishing data unavailable")
	end
	if pending.Kind == "Egg" then
		-- Eggs do not consume fish bait or advance fish progression.
		if not PetFeatureConfig.Enabled then
			state.phase = "Waiting"
			return failure(PetFeatureConfig.DisabledMessage)
		end
		local uuid, eggError = Knit.GetService("EggService"):GiveEgg(player, pending.FishId)
		if not uuid then
			state.phase = "Waiting"
			return failure(eggError or "Could not store the egg")
		end
		state.pending = nil
		state.phase, state.expiresAt = "Claimed", now + START_TIMEOUT
		return { ok = true, catchKind = "Egg", catchId = pending.FishId, eggUid = uuid }
	end
	local progress = Progression.Ensure(profile.Data)
	local tier, price = state.quote.tier, state.quote.price
	local committed = false
	local succeeded, granted, err = pcall(ItemGrantUtil.Grant, player, pending.FishId, {
		Weight = pending.Weight,
		MutationId = pending.MutationId,
		InstanceId = pending.Id,
		CountTowardTotalWeight = true,
		BeforeCommit = function()
			if
				PlayerDataService:GetProfile(player) ~= profile
				or getSession(player, token) ~= state
				or state.pending ~= pending
			then
				return false, "Catch no longer active"
			end
			if state.lesson and profile.Data.FishingOnboarding.Stage ~= state.lesson then
				return false, "Practice catch already completed"
			end
			if tier == 4 then
				if (progress.Credits[state.rodId] or 0) < 1 then
					return false, "Rainbow bait unavailable"
				end
			elseif profile.Data.Wins < price then
				return false, "Not enough cash"
			end
			return true
		end,
		OnCommitted = function()
			if tier == 4 then
				progress.Credits[state.rodId] -= 1
			else
				profile.Data.Wins = math.round(profile.Data.Wins - price)
			end
			if not pending.IsEvent then
				Progression.Record(progress, state.rodId, pending.FishId, pending.Band, pending.IsMax)
			end
			if state.lesson == "FirstCatch" then
				Onboarding.Advance(player, profile.Data, "FirstCatch", "PlaceFish", pending.Id)
			elseif state.lesson == "FinalCatch" then
				Onboarding.Advance(player, profile.Data, "FinalCatch", "Complete")
			end
			state.caughtUid = pending.Id
			state.pending = nil
			committed = true
		end,
	})
	if not committed then
		state.phase = "Waiting"
		warn("FishingService: " .. tostring(if succeeded then err else granted))
		return failure(
			if succeeded then (err or "Could not put the fish in your backpack") else "Could not store your catch"
		)
	end
	state.phase, state.expiresAt = "Claimed", now + START_TIMEOUT
	if tier ~= 4 and price > 0 then
		local refreshed, refreshError = pcall(PlayerDataService.AdjustWins, PlayerDataService, player, 0)
		if not refreshed then
			warn("FishingService: cash display refresh failed: " .. tostring(refreshError))
		end
	end
	if not succeeded then
		warn("FishingService: catch committed; presentation failed: " .. tostring(granted))
	end
	return {
		ok = true,
		weight = pending.Weight,
		catchKind = "Fish",
		catchId = pending.FishId,
		mutationId = pending.MutationId,
		isNewDiscovery = succeeded and granted and granted.IsNewDiscovery == true,
	}
end

function FishingService.Client:Cancel(player: Player, token, finished)
	local state = sessions[player]
	if state and state.token == token then
		sessions[player] = nil
		if finished == true and state.phase == "Claimed" and state.caughtUid then
			ItemGrantUtil.EquipCaughtFish(player, state.character, state.caughtUid)
		end
	end
end

function FishingService:IsActive(player)
	local state = sessions[player]
	return state ~= nil and getLiveCharacter(player) == state.character
end

function FishingService:KnitStart()
	local function bind(player: Player)
		player.CharacterRemoving:Connect(function(character)
			local state = sessions[player]
			if state and state.character == character then
				sessions[player] = nil
			end
		end)
	end
	Players.PlayerAdded:Connect(bind)
	Players.PlayerRemoving:Connect(function(player)
		sessions[player] = nil
	end)
	for _, player in ipairs(Players:GetPlayers()) do
		bind(player)
	end
end

return FishingService
