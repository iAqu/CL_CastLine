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
local FishingSpotUtil = require(Modules.FishingSpotUtil)
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
	sessions[player] = {
		token = token,
		rod = rod,
		character = character,
		phase = "Selecting",
		expiresAt = math.huge,
		round = 0,
	}
	return { ok = true, token = token, rodId = rodId }
end

function FishingService.Client:SelectBait(player: Player, token, baitId)
	local state = getSession(player, token)
	if not state or state.phase ~= "Selecting" then
		return failure("Fishing selection unavailable")
	end
	if typeof(baitId) ~= "string" then
		return failure("Bait unavailable")
	end
	local bait = BaitsData[baitId]
	if baitId ~= "NONE" and (not bait or not table.find(state.rod.BaitsSelect, baitId)) then
		return failure("Bait unavailable for this rod")
	end
	local template = Assets.GetBait(if bait then bait.Model else nil)
	if not template then
		return failure("Bait model unavailable")
	end
	local pool = FishingRoll.GetPool(FishesData, state.rod.MaxWeight, bait, Assets.GetFish)
	local eggPool = if PetFeatureConfig.Enabled then FishingRoll.GetEggPool(EggsData, state.rod.MaxWeight, Assets.GetEgg) else {}
	if #pool == 0 then
		return failure("No fish match this bait within your rod's weight limit")
	end
	if PetFeatureConfig.Enabled and #eggPool == 0 then return failure("No eggs are available for this rod") end
	local profile = PlayerDataService:GetProfile(player)
	local price = if bait then bait.Price else 0
	if not profile or profile.Data.Wins < price then
		return failure("Not enough cash")
	end
	state.phase = "Preparing"
	state.bait, state.baitSize, state.pool = bait, template.Size, pool
	state.eggPool = eggPool
	state.initialYaw = random:NextNumber(0, 2 * math.pi)
	if price > 0 and not PlayerDataService:AdjustWins(player, -price) then
		state.phase = "Selecting"
		return failure("Could not purchase bait")
	end
	-- Meter preparation can stay open until the player casts or leaves.
	state.expiresAt = math.huge
	return {
		ok = true,
		initialYaw = state.initialYaw,
		luck = FishingRoll.GetLuck(state.rod, bait, Config.FixedCastDistance, 0) * Knit.GetService("PetService"):GetLuckMultiplier(player),
	}
end

function FishingService.Client:Cast(player: Player, token, progress)
	local state = getSession(player, token)
	local now = Workspace:GetServerTimeNow()
	if not state or state.phase ~= "Preparing" then
		return failure("Cast unavailable")
	end
	if progress ~= nil and (type(progress) ~= "number" or progress ~= progress or progress < 0 or progress > 1) then
		return failure("Invalid cast progress")
	end
	local distance = Config.FixedCastDistance
	state.castLuckMultiplier = FishingRoll.GetCastLuckMultiplier(progress)
	state.phase, state.distance = "Waiting", distance
	local flightTime = ProjectileMath.FlightTime(distance)
	state.earliestLanding = now + Config.CastLeadTime + Config.ReleaseTime + flightTime
	state.spin = state.initialYaw + flightTime * 7
	state.expiresAt = math.huge
	return {
		ok = true,
		distance = distance,
		luck = FishingRoll.GetLuck(state.rod, state.bait, distance, 0, state.castLuckMultiplier) * Knit.GetService("PetService"):GetLuckMultiplier(player),
	}
end

function FishingService.Client:NextRound(player: Player, token, previousRound)
	local state = getSession(player, token)
	local now = Workspace:GetServerTimeNow()
	if not state or state.phase ~= "Waiting" or previousRound ~= state.round
		or now < (state.retryAt or state.earliestLanding)
	then
		return failure("Fishing round unavailable")
	end
	local startedAt = now + ROUND_LEAD_SECONDS
	state.landedAt = state.landedAt or startedAt
	local luck = FishingRoll.GetLuck(
		state.rod, state.bait, state.distance, startedAt - state.landedAt, state.castLuckMultiplier
	)
	local petMultiplier = Knit.GetService("PetService"):GetLuckMultiplier(player)
	local catchKind, fish = FishingRoll.ChooseCatch(state.pool, state.eggPool, luck, petMultiplier, random)
	local template = fish and (if catchKind == "Egg" then Assets.GetEgg(fish.Model) else Assets.GetFish(fish.Model))
	if not template then
		return failure("Fish model unavailable")
	end
	local seed, motionSeed = random:NextInteger(1, 2 ^ 30), random:NextInteger(1, 2 ^ 30)
	local landing = Config.Landing
	local settleTime = math.max(Config.ReturnInputDelay, landing.SinkTime + landing.ReboundTime + landing.SettleTime)
	local readyAt = if state.round == 0 then startedAt + settleTime else startedAt
	local biteAt, biteEndsAt = BiteSequence.GetBiteWindow(
		template, state.baitSize, startedAt, readyAt, seed, motionSeed, state.spin, fish, catchKind
	)
	state.round += 1
	state.fishId = fish.FishID
	state.catchKind, state.catchId = catchKind, if catchKind == "Egg" then fish.EggId else fish.FishID
	state.biteAt, state.biteEndsAt = biteAt, biteEndsAt
	state.retryAt = biteEndsAt + Config.Bite.EscapeTime
	return {
		ok = true,
		round = state.round,
		fishId = fish.FishID,
		catchKind = state.catchKind,
		catchId = state.catchId,
		startedAt = startedAt,
		readyAt = readyAt,
		retryAt = state.retryAt,
		seed = seed,
		motionSeed = motionSeed,
		luck = luck * petMultiplier,
	}
end

function FishingService.Client:Hook(player: Player, token, round, pressedAt)
	local state = getSession(player, token)
	local now = Workspace:GetServerTimeNow()
	if not state or state.phase ~= "Waiting" or state.round == 0 or state.round ~= round
		or typeof(pressedAt) ~= "number" or pressedAt ~= pressedAt
		or pressedAt < state.biteAt or pressedAt >= state.biteEndsAt
		or pressedAt > now + 0.08 or now - pressedAt > MAX_HOOK_LATENCY
	then
		return failure("Missed the bite")
	end
	-- Claim the round before Grant, which may yield while waiting for a Backpack.
	state.phase = "Claimed"
	state.expiresAt = now + START_TIMEOUT
	if state.catchKind == "Egg" then
		if not PetFeatureConfig.Enabled then return failure(PetFeatureConfig.DisabledMessage) end
		local uuid, err = Knit.GetService("EggService"):GiveEgg(player, state.catchId)
		if not uuid then return failure(err or "Could not store the egg") end
		return { ok = true, catchKind = "Egg", catchId = state.catchId, eggUid = uuid }
	end
	local fish = FishesData[state.fishId]
	local granted, err = ItemGrantUtil.Grant(player, state.fishId, {
		Weight = FishingRoll.RollWeight(fish.DefaultWeight, state.rod.MaxWeight, random),
		MutationId = FishingRoll.RollMutation(mutationRanges, random),
		CountTowardTotalWeight = true,
	})
	if not granted then
		warn("FishingService: " .. (err or "No fish was granted"))
		return failure("Could not put the fish in your backpack")
	end
	return {
		ok = true,
		weight = granted.Weight,
		catchKind = "Fish",
		catchId = state.catchId,
		mutationId = granted.MutationId,
		isNewDiscovery = granted.IsNewDiscovery == true,
	}
end

function FishingService.Client:Cancel(player: Player, token)
	local state = sessions[player]
	if state and state.token == token then
		sessions[player] = nil
	end
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
