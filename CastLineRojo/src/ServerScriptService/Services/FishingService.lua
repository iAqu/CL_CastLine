local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local ReplicatedFirst = game:GetService("ReplicatedFirst")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")

local Modules = ReplicatedStorage.Modules
local Config = require(Modules.FishingConfig)
local Constants = require(Modules.Constants)
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
local ObserverState = require(Modules.FishingObserverState)
local Onboarding = require(Modules.FishingOnboarding)
local Knit = require(ReplicatedStorage.Packages.Knit)
local ItemGrantUtil = require(script.Parent.ItemGrantUtil)
local PlayerDataService = require(script.Parent.PlayerDataService)
local BaitPurchases = require(script.Parent.FishingBaitPurchases)
local PaidItemPolicy = require(script.Parent.PaidItemPolicy)
local Analytics = require(script.Parent.OnboardingAnalyticsService)

local data = ReplicatedFirst:WaitForChild("Data")
local FishesData = require(data:WaitForChild("FishesData"))
local EggsData = if PetFeatureConfig.Enabled then require(data:WaitForChild("EggsData")) else {}
local BaitsData = require(data:WaitForChild("BaitsData"))
local RodsData = require(data:WaitForChild("RodsData"))
local mutationRanges = FishingRoll.BuildMutationRanges(require(data:WaitForChild("MutationsData")))
local FishingService = Knit.CreateService({
	Name = "FishingService",
	Client = { AnalyticsPresentation = Knit.CreateSignal() },
})

local sessions = {}
local presentations = {}
local nextPresentationId = 0
local random = Random.new()
local ROUND_LEAD_SECONDS = 0.35
local START_TIMEOUT = 60
local START_HORIZONTAL_TOLERANCE = 5
local BAIT_SPEND_FAILURE = "Could not use the Rainbow bait. Please try again."
local CATCH_CHANCE_MUTATION_MULTIPLIERS = { Golden = 4, Diamond = 8, Rainbow = 16 }
local CATCH_CHANCE_WEIGHT_STEP_MULTIPLIER = 1.25

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

local poolsByRod = {}

local function getPool(rod, progress)
	local cache = poolsByRod[rod.RodID]
	if not cache then
		cache = {}
		poolsByRod[rod.RodID] = cache
	end
	local grade = Config.GetCastRating(progress).ProbabilityGrade
	local entry = cache[grade]
	if not entry then
		local pool, pity = Progression.BuildPool(FishesData, rod, RodsData, Assets.GetFish, progress)
		if #pool == 0 then
			return pool, pity
		end
		for _, fish in pool do
			table.freeze(fish)
		end
		entry = {pool = table.freeze(pool), pity = pity}
		cache[grade] = entry
	end
	return entry.pool, entry.pity
end

local function quoteBait(rod, baitId, profile, progress)
	local credits = BaitPurchases.GetCredits(profile, progress, rod.RodID)
	return Progression.Quote(rod, baitId, BaitConfig, BaitPurchases.GetProductId(), credits)
end

local function ownsUltraLuck(profile)
	local passes = profile.Data.GamePasses
	return passes and passes[Constants.GAMEPASS.MEGA_LUCK] == true
end

local function fishOdds(pool, progress, rodId, pity, multiplier)
	local candidates = Progression.GetCandidates(pool, progress, rodId, pity)
	local weights, total = Progression.GetWeights(candidates, multiplier)
	local rows = {}
	for index, entry in ipairs(candidates) do
		if weights[index] > 0 then
			table.insert(rows, {
				name = entry.fish.DisplayName or entry.fish.FishID,
				chance = weights[index] / total,
			})
		end
	end
	return rows
end

local function getCastOdds(state, progress, pending)
	local odds = { name = state.castRating, boosted = false }
	if pending and pending.Kind == "Egg" then
		local egg = EggsData[pending.FishId]
		odds.rows = { { name = egg.DisplayName or egg.EggId, chance = 1 } }
		return odds
	end
	if state.lesson then
		local fish = FishesData.Fish_106
		odds.rows = { { name = fish.DisplayName or fish.FishID, chance = 1 } }
		odds.variants = { { name = "Golden", chance = 1 } }
		return odds
	end
	odds.variants = Progression.GetMutationOdds(state.quote.tier, BaitConfig, mutationRanges)
	if state.eventFish then
		local fish = FishesData[state.eventFish.FishId]
		odds.rows = { { name = fish.DisplayName or fish.FishID, chance = 1 } }
		return odds
	end
	odds.rows = fishOdds(state.pool, progress, state.rodId, state.pity, state.highBandMultiplier)
	odds.boosted = state.highBandMultiplier > 1
	if state.round == 0 and PetFeatureConfig.Enabled then
		local eggChance = Config.EggCatchChance
		for _, row in ipairs(odds.rows) do
			row.chance *= 1 - eggChance
		end
		local total = 0
		for _, entry in ipairs(state.eggPool) do
			total += entry.weight
		end
		for _, entry in ipairs(state.eggPool) do
			table.insert(odds.rows, {
				name = entry.fish.DisplayName or entry.fish.EggId,
				chance = entry.weight / total * eggChance,
			})
		end
		if total == 0 and eggChance > 0 then
			table.insert(odds.rows, { name = "No catch", chance = eggChance })
		end
	end
	return odds
end

local function clearPresentation(player: Player, state)
	if presentations[player] ~= state then
		return
	end
	presentations[player] = nil
	state.deathConnection:Disconnect()
	state.character:SetAttribute(ObserverState.Attribute, nil)
end

local function publishPresentation(state, phase, now)
	state.presentation.phase = phase
	state.presentation.startedAt = now
	state.character:SetAttribute(ObserverState.Attribute, ObserverState.Encode(state.presentation))
end

local function scheduleCatchPresentation(player, state, pending, pressedAt, isNewDiscovery)
	local now = Workspace:GetServerTimeNow()
	local liftAt = math.max(now, pressedAt + state.struggleTime)
	task.delay(liftAt - now, function()
		if presentations[player] ~= state or getSession(player, state.token) ~= state then
			return
		end
		state.presentation.catchKind = pending.Kind
		state.presentation.catchId = pending.FishId
		state.presentation.weight = pending.Weight
		state.presentation.mutationId = pending.MutationId
		state.presentation.isNewDiscovery = isNewDiscovery
		publishPresentation(state, "Catch", liftAt)
	end)
	task.delay(START_TIMEOUT, function()
		clearPresentation(player, state)
	end)
end

local function beginFishing(player: Player, eventSlotId: number?)
	local character, root, humanoid = getLiveCharacter(player)
	if not character or not root or not humanoid then
		return failure("Fishing character unavailable")
	end
	local profile = PlayerDataService:GetProfile(player)
	if not profile or (eventSlotId ~= nil and not profile:IsActive()) then
		return failure("Your fishing data is still loading", "ProfileNotReady")
	end
	local plot = Knit.GetService("PlotSlotService"):GetPlayerPlot(player)
	local part = FishingSpotUtil.GetStartPart(plot)
	if eventSlotId == nil and (not part or not FishingSpotUtil.Contains(part, root, START_HORIZONTAL_TOLERANCE)) then
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
	local training = Knit.GetService("TrainingService")
	if eventSlotId == nil then
		training:Stop(player, false)
	end
	local progress = Progression.Ensure(profile.Data)
	local onboarding = profile.Data.FishingOnboarding
	local stage = onboarding and onboarding.Stage
	local destination
	if eventSlotId ~= nil then
		if root.Anchored
			or humanoid.Sit
			or player:GetAttribute("IsTraining") == true
			or Onboarding.IsActiveStage(stage)
			or Knit.GetService("FishingIntroService"):IsActive(player)
		then
			return failure("Finish what you're doing before joining Secret Fish.", "FishingBusy")
		end
		if part and plot:GetAttribute("OwnerUserId") == player.UserId then
			destination = FishingSpotUtil.GetEntryRootCFrame(part, root, humanoid)
		end
		if not destination then
			return failure("Your fishing spot is unavailable.", "MissingFishingSpot")
		end
	end
	local lesson = if stage == "FinalCatch" then stage else nil
	local guideBaitId = if lesson then rod.BaitsSelect[1] else nil
	local quotes = {}
	for _, id in ipairs(rod.BaitsSelect) do
		quotes[id] = quoteBait(rod, id, profile, progress)
	end
	if lesson == "FinalCatch" and not quotes[guideBaitId] then
		return failure("Your rod has no first-tier bait")
	end
	now = Workspace:GetServerTimeNow()
	local eventFish
	-- The final lesson can turn into free practice after the bait choice.
	local fish, window = Knit.GetService("EventFishService"):GetActiveFish(now)
	if eventSlotId ~= nil and (not fish or not window or window.SlotId ~= eventSlotId) then
		return failure("This Secret Fish event has ended.", "EventExpired")
	end
	if fish then
		eventFish = {
			FishId = fish.FishID,
			SlotId = window.SlotId,
			StartsAt = window.StartsAt,
			EndsAt = window.EndsAt,
		}
	end
	local token = HttpService:GenerateGUID(false)
	if destination then
		training:Stop(player, false)
		character:PivotTo(destination * root.CFrame:ToObjectSpace(character:GetPivot()))
		root.AssemblyLinearVelocity, root.AssemblyAngularVelocity = Vector3.zero, Vector3.zero
	end
	local previousPresentation = presentations[player]
	if previousPresentation then
		clearPresentation(player, previousPresentation)
	end
	nextPresentationId += 1
	local state = {
		token = token,
		plot = plot,
		rod = rod,
		rodId = rodId,
		lesson = lesson,
		guideBaitId = guideBaitId,
		eventFish = eventFish,
		character = character,
		phase = "Selecting",
		expiresAt = math.huge,
		round = 0,
		presentation = {
			id = nextPresentationId,
			plot = plot.Name,
			rodId = rodId,
		},
	}
	sessions[player], presentations[player] = state, state
	state.deathConnection = humanoid.Died:Connect(function()
		if sessions[player] == state then
			sessions[player] = nil
		end
		clearPresentation(player, state)
	end)
	publishPresentation(state, "Selecting", now)
	if lesson then
		Analytics:Step(player, lesson .. "Started")
	else
		BaitPurchases.PrewarmPolicy(player, rod)
		if ownsUltraLuck(profile) then
			task.defer(PaidItemPolicy.Get, player)
		end
	end
	return {
		ok = true,
		token = token,
		rodId = rodId,
		baitQuotes = quotes,
		lesson = lesson,
		guideBaitId = guideBaitId,
		eventFish = eventFish,
	}
end

function FishingService.Client:Begin(player: Player)
	return beginFishing(player)
end

function FishingService.Client:JoinEvent(player: Player, slotId: number)
	if typeof(slotId) ~= "number" then
		return failure("This Secret Fish event has ended.", "EventExpired")
	end
	return beginFishing(player, slotId)
end

local function openBaitPurchase(player, profile, state, token)
	local function isCurrent()
		return getSession(player, token) == state and state.phase == "Selecting"
			and PlayerDataService:GetProfile(player) == profile and RodInventory.GetEquippedId(profile.Data) == state.rodId
	end
	if not isCurrent() then
		return false, "Fishing selection unavailable"
	end
	return BaitPurchases.Prompt(player, state.rodId, token, isCurrent)
end

function FishingService.Client:SelectBait(player: Player, token, baitId, purchaseOnSelect)
	local state = getSession(player, token)
	if not state or state.phase ~= "Selecting" then
		return failure("Fishing selection unavailable")
	end
	if typeof(baitId) ~= "string" then
		return failure("Bait unavailable")
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
	local pool, pity = getPool(state.rod)
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
		local firstTier = quoteBait(state.rod, state.guideBaitId, profile, progress)
		if profile.Data.Wins >= firstTier.price then
			return failure(Onboarding.GetBaitSelectionHint(BaitsData[state.guideBaitId]))
		end
	end
	local quote = quoteBait(state.rod, baitId, profile, progress)
	if not quote then
		return failure("Bait unavailable")
	end
	if not quote.available then
		return failure("Robux bait is not configured yet")
	end
	if quote.tier == BaitConfig.PaidTier then
		if RodInventory.GetEquippedId(profile.Data) ~= state.rodId then
			return failure("Fishing rod changed")
		end
		if quote.credits <= 0 then
			if purchaseOnSelect == true and not state.lesson then
				local prompted, message = openBaitPurchase(player, profile, state, token)
				return if prompted then { ok = false, prompted = true } else failure(message)
			end
			return { ok = false, needsPurchase = true, productId = quote.productId, message = "Purchase a Rainbow bait" }
		end
	end
	if profile.Data.Wins < quote.price then
		if state.lesson == "FinalCatch" and bait then
			return failure("Not enough cash for " .. bait.DisplayName .. ". Select NONE to fish for free.")
		end
		return failure("Not enough cash")
	end
	if practiceWithoutBait then
		Analytics:Detail(player, "FinalCatch", "FreePracticeSelected")
		state.lesson = nil
	elseif state.lesson == "FinalCatch" then
		Analytics:Step(player, "FinalBaitSelected")
	end
	state.quote, state.pity = quote, pity
	state.phase = "Preparing"
	state.bait, state.baitSize, state.pool = bait, template.Size * Config.BaitFlightScale, pool
	state.eggPool = eggPool
	state.initialYaw = random:NextNumber(0, 2 * math.pi)
	state.presentation.baitId, state.presentation.initialYaw = baitId, state.initialYaw
	local now = Workspace:GetServerTimeNow()
	state.meterStartsAt = now + 0.25
	publishPresentation(state, "Preparing", now)
	-- Meter preparation can stay open until the player casts or leaves.
	state.expiresAt = math.huge
	if not state.lesson and not state.eventFish and ownsUltraLuck(profile) then
		task.defer(PaidItemPolicy.Get, player)
	end
	return {
		ok = true,
		initialYaw = state.initialYaw,
		meterStartsAt = state.meterStartsAt,
		lesson = state.lesson,
		luck = FishingRoll.GetLuck(state.rod, bait, Config.FixedCastDistance) * Knit.GetService("PetService")
			:GetLuckMultiplier(player),
	}
end

function FishingService.Client:RequestBaitPurchase(player: Player, token, baitId)
	local state = getSession(player, token)
	local profile = PlayerDataService:GetProfile(player)
	if
		not profile
		or not state
		or state.lesson
		or state.phase ~= "Selecting"
		or baitId ~= state.rod.BaitsSelect[BaitConfig.PaidTier]
		or not BaitsData[baitId]
	then
		return failure("Fishing selection unavailable")
	end
	if not Assets.GetBait(BaitsData[baitId].Model) then
		return failure("Bait model unavailable")
	end
	local prompted, message = openBaitPurchase(player, profile, state, token)
	return if prompted then { ok = true } else failure(message)
end

function FishingService.Client:Cast(player: Player, token)
	local state = getSession(player, token)
	local receivedAt = Workspace:GetServerTimeNow()
	if not state or state.phase ~= "Preparing" or receivedAt < state.meterStartsAt then
		return failure("Cast unavailable")
	end
	local elapsed = receivedAt - state.meterStartsAt - Config.GetFishingInputDelay(player)
	local progress = Config.GetCastMeterProgress(elapsed)
	local pool, pity = getPool(state.rod, progress)
	if #pool == 0 then return failure("No fish match this rod") end
	local profile = PlayerDataService:GetProfile(player)
	if not profile then
		return failure("Fishing data unavailable")
	end
	local policy
	if not state.lesson and not state.eventFish and ownsUltraLuck(profile) then
		policy = PaidItemPolicy.GetCached(player)
		if not policy then
			task.defer(PaidItemPolicy.Get, player)
		end
	end
	state.highBandMultiplier = if policy and policy.ArePaidRandomItemsRestricted == false
		then Progression.ULTRA_LUCK_HIGH_BAND_WEIGHT else 1
	if state.quote.tier == BaitConfig.PaidTier then
		if RodInventory.GetEquippedId(profile.Data) ~= state.rodId then
			return failure("Fishing rod unavailable")
		end
		state.awaitBaitSpend = BaitPurchases.BeginConsume(profile, state.rodId)
		if not state.awaitBaitSpend then
			return failure(BAIT_SPEND_FAILURE)
		end
	end
	local now = Workspace:GetServerTimeNow()
	local rating = Config.GetCastRating(progress)
	state.castProgress, state.castRating = progress, rating.Id
	state.pool, state.pity = pool, pity
	local distance = Config.FixedCastDistance
	state.castLuckMultiplier = FishingRoll.GetCastLuckMultiplier(progress)
	state.phase, state.distance = "Waiting", distance
	local flightTime = ProjectileMath.FlightTime(distance)
	local presentation = Config.GetCastProfile(state.castRating)
	state.earliestLanding = now + presentation.LeadTime + presentation.ReleaseTime + flightTime
	state.spin = state.initialYaw + flightTime * 7
	state.expiresAt = math.huge
	state.presentation.distance, state.presentation.castRating = distance, state.castRating
	publishPresentation(state, "Cast", now)
	if state.lesson then
		Analytics:Step(player, state.lesson .. "Cast")
	elseif Analytics:SampleFishingCast() then
		state.sampledCast = true
		Analytics:Growth(player, "CL_FishingCast_v1", 1, state.rodId, state.quote.tier, state.castRating)
	end
	return {
		ok = true,
		distance = distance,
		castRating = state.castRating,
		castProgress = progress,
		odds = getCastOdds(state, Progression.Ensure(profile.Data)),
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
	then
		return failure("Fishing round unavailable")
	end
	local nextRoundAt = state.retryAt or state.earliestLanding
	if now < nextRoundAt then
		return { ok = false, code = "RoundNotReady", retryAfter = nextRoundAt - now }
	end
	if state.awaitBaitSpend then
		-- The cast and flight run while the spend is being saved.
		state.phase = "AwaitingBaitSave"
		local paidProfile = state.awaitBaitSpend()
		if getSession(player, token) ~= state then
			return failure("Fishing session ended")
		end
		state.awaitBaitSpend = nil
		if not paidProfile or PlayerDataService:GetProfile(player) ~= paidProfile then
			state.phase = "CastFailed"
			return failure(BAIT_SPEND_FAILURE)
		end
		state.phase = "Waiting"
		now = Workspace:GetServerTimeNow()
	end
	local startedAt = now + ROUND_LEAD_SECONDS
	local luck = FishingRoll.GetLuck(state.rod, state.bait, state.distance, state.castLuckMultiplier)
	local petMultiplier = Knit.GetService("PetService"):GetLuckMultiplier(player)
	local profile = PlayerDataService:GetProfile(player)
	if not profile then
		return failure("Fishing data unavailable")
	end
	local progress = Progression.Ensure(profile.Data)
	local lesson = state.lesson
	local pending = state.pending
	local odds = getCastOdds(state, progress, pending)
	if not pending or (not lesson and pending.Kind == "Fish") then
		local lessonFishId = if lesson then "Fish_106" else nil
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
			entry = Progression.Choose(state.pool, progress, state.rodId, state.pity, random, state.highBandMultiplier)
		end
		if not entry then
			return failure("Fishing pool unavailable")
		end
		local kind, fish = "Fish", entry.fish
		local eventFish = if lesson then nil else state.eventFish
		if eventFish then
			fish = FishesData[eventFish.FishId]
		elseif state.round == 0 and not lesson and PetFeatureConfig.Enabled
			and random:NextNumber() < Config.EggCatchChance
		then
			kind, fish = "Egg", FishingRoll.Choose(state.eggPool, 1, random)
		end
		if not fish then
			return failure("Catch unavailable")
		end
		pending = {
			Id = HttpService:GenerateGUID(false),
			Kind = kind,
			FishId = if kind == "Fish" then fish.FishID else fish.EggId,
			IsEvent = eventFish ~= nil,
			Band = entry.band,
			IsMax = entry.isMax,
			Weight = if kind == "Egg" then FishingRoll.RollWeight(fish.DefaultWeight, math.huge, random) else fish.DefaultWeight,
			MutationId = if lesson == "FinalCatch" then "Golden"
				elseif not lesson then Progression.RollMutation(state.quote.tier, BaitConfig, mutationRanges, random)
				else nil,
		}
	end
	local catchKind = pending.Kind
	local fish = if catchKind == "Egg" then EggsData[pending.FishId] else FishesData[pending.FishId]
	if catchKind == "Fish" and fish then
		pending.MaxCatchWeight = Knit.GetService("TrainingService"):GetMaxCatchWeight(player)
		if lesson then
			local levels = require(data:WaitForChild("TrainingLevelsData"))
			local cap = TrainingProgress.GetLevel(levels, Onboarding.FinalCatchWeightCapLevel).MaxCatchWeight
			pending.MaxCatchWeight = math.min(pending.MaxCatchWeight, cap)
		end
		local weight, weightSteps = TrainingProgress.CalculateFishWeight(fish.DefaultWeight, pending.MaxCatchWeight)
		pending.Weight = weight
		local baseChance = fish.DisplayChance
		if type(baseChance) == "number" and baseChance >= 1 and baseChance < math.huge and baseChance % 1 == 0 then
			local mutationMultiplier = CATCH_CHANCE_MUTATION_MULTIPLIERS[pending.MutationId] or 1
			pending.CatchChanceDenominator = math.round(
				baseChance * mutationMultiplier * CATCH_CHANCE_WEIGHT_STEP_MULTIPLIER ^ weightSteps
			)
		end
	end
	local template = fish and (if catchKind == "Egg" then Assets.GetEgg(fish.Model) else Assets.GetFish(fish.Model))
	if not template then
		return failure("Fish model unavailable")
	end
	local seed, motionSeed = random:NextInteger(1, 2 ^ 30), random:NextInteger(1, 2 ^ 30)
	local landing = Config.Landing
	local settleTime = math.max(Config.ReturnInputDelay, landing.SinkTime + landing.ReboundTime + landing.SettleTime)
	local readyAt = if state.round == 0 then startedAt + settleTime else startedAt
	local biteAt, biteEndsAt, struggleTime = BiteSequence.GetBiteWindow(
		template,
		state.baitSize,
		startedAt,
		readyAt,
		seed,
		motionSeed,
		state.spin,
		fish,
		catchKind,
		lesson ~= nil,
		pending.Weight
	)
	state.pending = pending
	state.round += 1
	state.hookResult = nil
	state.roundLuck = luck * petMultiplier
	state.fishId = pending.FishId
	state.catchKind, state.catchId = catchKind, if catchKind == "Egg" then fish.EggId else fish.FishID
	state.biteAt, state.biteEndsAt, state.struggleTime = biteAt, biteEndsAt, struggleTime
	state.retryAt = if lesson then now + 0.2 else biteEndsAt + Config.Bite.EscapeTime
	if lesson and Analytics:IsNewPlayer(player) then
		Analytics:Step(player, lesson .. "Landed")
		local round = state.round
		task.delay(math.max(0, biteAt - Workspace:GetServerTimeNow()), function()
			if getSession(player, token) == state and state.phase == "Waiting" and state.round == round then
				Analytics:Step(player, lesson .. "Bite")
			end
		end)
	end
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
		biteAt = biteAt,
		biteEndsAt = biteEndsAt,
		retryAt = if lesson then math.huge else state.retryAt,
		mutationId = if lesson then pending.MutationId else nil,
		seed = seed,
		motionSeed = motionSeed,
		luck = state.roundLuck,
		castRating = state.castRating,
		odds = odds,
		sentAt = Workspace:GetServerTimeNow(),
	}
end

local function claimHook(player, state, pending, pressedAt, now)
	if state.lesson then
		Analytics:Step(player, state.lesson .. "Bite")
	end
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
		scheduleCatchPresentation(player, state, pending, pressedAt, false)
		return { ok = true, catchKind = "Egg", catchId = pending.FishId, eggUid = uuid }
	end
	local progress = Progression.Ensure(profile.Data)
	local tier, price = state.quote.tier, state.quote.price
	local committed = false
	local succeeded, granted, err = pcall(ItemGrantUtil.Grant, player, pending.FishId, {
		Weight = pending.Weight,
		MutationId = pending.MutationId,
		PaidOrigin = if tier == BaitConfig.PaidTier then BaitConfig.PurchaseId else nil,
		InstanceId = pending.Id,
		CountTowardTotalWeight = true,
		RecordFishingCatch = true,
		BeforeCommit = function()
			if
				PlayerDataService:GetProfile(player) ~= profile
				or getSession(player, state.token) ~= state
				or state.pending ~= pending
			then
				return false, "Catch no longer active"
			end
			if state.lesson and profile.Data.FishingOnboarding.Stage ~= state.lesson then
				return false, "Practice catch already completed"
			end
			if tier ~= BaitConfig.PaidTier and profile.Data.Wins < price then
				return false, "Not enough cash"
			end
			return true
		end,
		OnCommitted = function()
			if tier ~= BaitConfig.PaidTier then
				profile.Data.Wins = math.round(profile.Data.Wins - price)
			end
			if not pending.IsEvent then
				Progression.Record(progress, state.rodId, pending.FishId, pending.Band, pending.IsMax)
			end
			if state.lesson == "FinalCatch" then
				Onboarding.Advance(player, profile.Data, "FinalCatch", "Complete")
			end
			state.caughtUid = pending.Id
			state.pending = nil
			committed = true
			if state.lesson then
				Analytics:Step(player, state.lesson .. "Caught")
			elseif state.sampledCast then
				Analytics:Growth(player, "CL_FishingCatch_v1", pending.Weight, state.rodId, tier, state.castRating)
				Analytics:Growth(player, "CL_FishWeight_v1", pending.Weight, pending.FishId, state.rodId,
					pending.MutationId or "None")
			end
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
	local isNewDiscovery = succeeded and granted and granted.IsNewDiscovery == true or false
	scheduleCatchPresentation(player, state, pending, pressedAt, isNewDiscovery)
	if tier ~= BaitConfig.PaidTier and price > 0 then
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
		catchChanceDenominator = pending.CatchChanceDenominator,
		isNewDiscovery = isNewDiscovery,
	}
end

function FishingService.Client:Hook(player: Player, token, round, clickTime)
	local state = getSession(player, token)
	local now = Workspace:GetServerTimeNow()
	local pending = state and state.pending
	if
		not state
		or not pending
		or state.phase ~= "Waiting"
		or state.round == 0
		or state.round ~= round
	then
		return failure("Missed the bite")
	end
	local pressedAt = Config.GetHookTime(now, clickTime, state.biteAt, state.biteEndsAt, player:GetNetworkPing())
	if not pressedAt then
		local result = failure("Missed the bite")
		state.hookResult = result
		return result
	end

	-- A duplicate request cannot grant again while this call is waiting for the backpack.
	state.hookResult = nil
	state.phase = "Claiming"
	local result = claimHook(player, state, pending, pressedAt, now)
	state.hookResult = result
	return result
end

function FishingService.Client:GetHookResult(player, token, round)
	local state = getSession(player, token)
	if not state or state.round == 0 or state.round ~= round then
		return { status = "Unknown" }
	end
	if state.hookResult then
		return { status = if state.hookResult.ok then "Succeeded" else "Rejected", result = state.hookResult }
	end
	return { status = if state.phase == "Claiming" then "Pending" else "Unknown" }
end

function FishingService.Client:Cancel(player: Player, token, finished, emptyReelRound)
	local state = sessions[player]
	if state and state.token == token then
		sessions[player] = nil
		if
			finished ~= true
			and state.phase == "Waiting"
			and state.round > 0
			and state.round == emptyReelRound
			and getLiveCharacter(player) == state.character
		then
			local now = Workspace:GetServerTimeNow()
			state.presentation.expiresAt = now + ObserverState.EmptyReelDuration
			publishPresentation(state, "EmptyReel", now)
			task.delay(ObserverState.EmptyReelDuration, function()
				clearPresentation(player, state)
			end)
		else
			clearPresentation(player, state)
		end
		if finished == true and state.phase == "Claimed" and state.caughtUid then
			if state.lesson then
				Analytics:Detail(player, state.lesson, "ContinueConfirmed")
			end
			ItemGrantUtil.EquipCaughtFish(player, state.character, state.caughtUid)
		end
	end
end

function FishingService:IsActive(player)
	local state = sessions[player]
	return state ~= nil and getLiveCharacter(player) == state.character
end

function FishingService:KnitStart()
	self.Client.AnalyticsPresentation:Connect(function(player, token, detail)
		local state = getSession(player, token)
		if state and state.lesson then
			Analytics:FishingPresentation(player, state.lesson, state.phase, state.round, detail)
		end
	end)
	local slotService = Knit.GetService("PlotSlotService")
	slotService.SlotReleased:Connect(function(plot)
		for player, state in pairs(presentations) do
			if state.plot == plot and plot:GetAttribute("OwnerUserId") ~= player.UserId then
				if sessions[player] == state then
					sessions[player] = nil
				end
				clearPresentation(player, state)
			end
		end
	end)
	local function bind(player: Player)
		player.CharacterRemoving:Connect(function(character)
			local state = sessions[player]
			if state and state.character == character then
				sessions[player] = nil
			end
			local presentation = presentations[player]
			if presentation and presentation.character == character then
				clearPresentation(player, presentation)
			end
		end)
	end
	Players.PlayerAdded:Connect(bind)
	Players.PlayerRemoving:Connect(function(player)
		sessions[player] = nil
		local presentation = presentations[player]
		if presentation then
			clearPresentation(player, presentation)
		end
	end)
	for _, player in ipairs(Players:GetPlayers()) do
		bind(player)
	end
end

return FishingService
