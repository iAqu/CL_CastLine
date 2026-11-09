local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local ReplicatedFirst = game:GetService("ReplicatedFirst")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")

local Modules = ReplicatedStorage.Modules
local Config = require(Modules.FishingConfig)
local Assets = require(Modules.FishingAssets)
local BiteSequence = require(Modules.FishingBiteSequence)
local ProjectileMath = require(Modules.FishingProjectileMath)
local FishingRoll = require(Modules.FishingRoll)
local Knit = require(ReplicatedStorage.Packages.Knit)
local ItemGrantUtil = require(script.Parent.ItemGrantUtil)
local PlayerDataService = require(script.Parent.PlayerDataService)

local data = ReplicatedFirst:WaitForChild("Data")
local FishesData = require(data:WaitForChild("FishesData"))
local BaitsData = require(data:WaitForChild("BaitsData"))
local RodsData = require(data:WaitForChild("RodsData"))
local FishingService = Knit.CreateService({ Name = "FishingService", Client = {} })

local sessions = {}
local random = Random.new()
local ROUND_LEAD_SECONDS = 0.35
local MAX_HOOK_LATENCY = 0.45
local START_TIMEOUT = 60

local function failure(message: string)
	return { ok = false, message = message }
end

local function getFishingCharacter(player: Player)
	local areas = Workspace:FindFirstChild("Areas")
	local start = areas and areas:FindFirstChild("CastStartPart")
	local character = player.Character
	local root = character and character:FindFirstChild("HumanoidRootPart")
	local humanoid = character and character:FindFirstChildOfClass("Humanoid")
	if not (start and start:IsA("BasePart") and root and root:IsA("BasePart") and humanoid and humanoid.Health > 0) then
		return nil
	end
	local height = humanoid.HipHeight + root.Size.Y / 2
	if humanoid.RigType == Enum.HumanoidRigType.R6 then
		local leg = character:FindFirstChild("Left Leg")
		if leg and leg:IsA("BasePart") then
			height += leg.Size.Y
		end
	end
	local point = start.CFrame:PointToObjectSpace(root.Position - Vector3.yAxis * height)
	if math.abs(point.X) <= start.Size.X / 2 + 1
		and math.abs(point.Z) <= start.Size.Z / 2 + 1
		and math.abs(point.Y - start.Size.Y / 2) <= 3.5
	then
		return character
	end
	return nil
end

local function getSession(player: Player, token)
	local state = sessions[player]
	if state and state.token == token and getFishingCharacter(player) == state.character then
		return state
	end
	return nil
end

function FishingService.Client:Begin(player: Player)
	local character = getFishingCharacter(player)
	if not character or not PlayerDataService:GetProfile(player) then
		return failure("Fishing is unavailable here")
	end
	local existing = sessions[player]
	local now = Workspace:GetServerTimeNow()
	if existing and existing.character == character and existing.expiresAt > now then
		return failure("Already fishing")
	end
	local rod = RodsData[Config.DefaultRodId]
	if not rod then
		return failure("Fishing rod unavailable")
	end
	local token = HttpService:GenerateGUID(false)
	sessions[player] = {
		token = token,
		rod = rod,
		character = character,
		phase = "Selecting",
		expiresAt = now + START_TIMEOUT,
		round = 0,
	}
	return { ok = true, token = token }
end

function FishingService.Client:SelectBait(player: Player, token, baitId)
	local state = getSession(player, token)
	if not state or state.phase ~= "Selecting" or Workspace:GetServerTimeNow() >= state.expiresAt then
		return failure("Fishing selection expired")
	end
	if typeof(baitId) ~= "string" then
		return failure("Bait unavailable")
	end
	local bait = BaitsData[baitId]
	if baitId ~= "NONE" and (not bait or not table.find(state.rod.BaitsSelect, baitId)) then
		return failure("Bait unavailable for this rod")
	end
	local template = Assets.GetBait(if bait then bait.Model else "1")
	if not template then
		return failure("Bait model unavailable")
	end
	local pool = FishingRoll.GetPool(FishesData, state.rod.Location, bait, Assets.GetFish)
	if #pool == 0 then
		return failure("No fish match this bait here")
	end
	local profile = PlayerDataService:GetProfile(player)
	local price = if bait then bait.Price else 0
	if not profile or profile.Data.Wins < price then
		return failure("Not enough cash")
	end
	state.phase = "Preparing"
	state.bait, state.baitSize, state.pool = bait, template.Size, pool
	state.initialYaw = random:NextNumber(0, 2 * math.pi)
	state.expiresAt = Workspace:GetServerTimeNow() + START_TIMEOUT
	if price > 0 and not PlayerDataService:AdjustWins(player, -price) then
		state.phase = "Selecting"
		return failure("Could not purchase bait")
	end
	return { ok = true, initialYaw = state.initialYaw }
end

function FishingService.Client:Cast(player: Player, token, meterValue)
	local state = getSession(player, token)
	local now = Workspace:GetServerTimeNow()
	if not state or state.phase ~= "Preparing" or now >= state.expiresAt
		or typeof(meterValue) ~= "number" or meterValue ~= meterValue or meterValue < 0 or meterValue > 1
	then
		return failure("Cast unavailable")
	end
	local rod = state.rod
	local distance = ProjectileMath.Distance(meterValue, rod.DistanceMin, rod.DistanceMax)
	state.phase, state.distance = "Waiting", distance
	local flightTime = ProjectileMath.FlightTime(distance)
	state.earliestLanding = now + Config.CastLeadTime + Config.ReleaseTime + flightTime
	state.spin = state.initialYaw + flightTime * 7
	state.expiresAt = math.huge
	return { ok = true, distance = distance }
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
	local luck = FishingRoll.GetLuck(state.rod, state.bait, state.distance, startedAt - state.landedAt)
	local fish = FishingRoll.Choose(state.pool, luck, random)
	local template = fish and Assets.GetFish(fish.Model)
	if not template then
		return failure("Fish model unavailable")
	end
	local seed, motionSeed = random:NextInteger(1, 2 ^ 30), random:NextInteger(1, 2 ^ 30)
	local landing = Config.Landing
	local settleTime = math.max(Config.ReturnInputDelay, landing.SinkTime + landing.ReboundTime + landing.SettleTime)
	local readyAt = if state.round == 0 then startedAt + settleTime else startedAt
	local biteAt, biteEndsAt = BiteSequence.GetBiteWindow(template, state.baitSize, startedAt, readyAt, seed, motionSeed, state.spin)
	state.round += 1
	state.fishId = fish.FishID
	state.biteAt, state.biteEndsAt = biteAt, biteEndsAt
	state.retryAt = biteEndsAt + Config.Bite.EscapeTime
	return {
		ok = true,
		round = state.round,
		fishId = fish.FishID,
		startedAt = startedAt,
		readyAt = readyAt,
		retryAt = state.retryAt,
		seed = seed,
		motionSeed = motionSeed,
		luck = luck,
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
	local _, err = ItemGrantUtil.Grant(player, state.fishId, {
		Weight = FishesData[state.fishId].DefaultWeight,
		CountTowardTotalWeight = true,
	})
	if err then
		warn("FishingService: " .. err)
		return failure("Could not put the fish in your backpack")
	end
	return { ok = true }
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
