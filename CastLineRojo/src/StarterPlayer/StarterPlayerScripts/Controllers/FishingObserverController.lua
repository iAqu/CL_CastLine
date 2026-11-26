local Players = game:GetService("Players")
local ReplicatedFirst = game:GetService("ReplicatedFirst")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")

local Modules = ReplicatedStorage.Modules
local Assets = require(Modules.FishingAssets)
local ObserverState = require(Modules.FishingObserverState)
local ObserverVisual = require(Modules.FishingObserverVisual)
local GameplayInputGate = require(Modules.GameplayInputGate)
local FishingSpotUtil = require(Modules.FishingSpotUtil)
local PetFeatureConfig = require(Modules.PetFeatureConfig)
local WaterSurfaceUtil = require(Modules.WaterSurfaceUtil)
local Knit = require(ReplicatedStorage.Packages.Knit)

local data = ReplicatedFirst:WaitForChild("Data")
local RodsData = require(data:WaitForChild("RodsData"))
local BaitsData = require(data:WaitForChild("BaitsData"))
local FishesData = require(data:WaitForChild("FishesData"))
local EggsData = if PetFeatureConfig.Enabled then require(data:WaitForChild("EggsData")) else {}

local localPlayer = Players.LocalPlayer
local Controller = Knit.CreateController({ Name = "FishingObserverController" })
local RECHECK_SECONDS = 0.12

local function getPhaseAsset(state)
	if state.phase == "Catch" then
		local isEgg = state.catchKind == "Egg"
		local config = if isEgg then EggsData[state.catchId] else FishesData[state.catchId]
		local asset = config and (if isEgg then Assets.GetEgg(config.Model) else Assets.GetFish(config.Model))
		return asset, config
	elseif state.phase == "Cast" or state.phase == "Preparing" then
		local bait = BaitsData[state.baitId]
		local part, model = Assets.GetBait(if bait then bait.Model else nil)
		return model or part
	end
	return true
end

local function getRigAssets(state)
	local characters = ReplicatedStorage:FindFirstChild("Character")
	local template = characters and characters:FindFirstChild("PoseDefaultCharacter")
	local rodData = RodsData[state.rodId]
	local rod = rodData and Assets.GetRod(rodData.Model)
	local animations = ReplicatedStorage:FindFirstChild("Animation")
	local fishing = animations and animations:FindFirstChild("Fishing")
	local cast = fishing and fishing:FindFirstChild("CastRod")
	if template and template:IsA("Model") and rod and cast and cast:IsA("Animation") then
		return template, rod, cast, fishing:FindFirstChild("SpecialCastRod")
	end
	return nil
end

local function getLiveCharacter(player)
	local character = player.Character
	local humanoid = character and character:FindFirstChildOfClass("Humanoid")
	if
		character
		and character:IsDescendantOf(Workspace)
		and character:FindFirstChild("HumanoidRootPart")
		and character:FindFirstChild("Head")
		and humanoid
		and humanoid.Health > 0
	then
		return character
	end
	return nil
end

function Controller:KnitStart()
	local entries = {}
	local warned = {}
	local nextCheck = 0

	local function clearVisual(entry)
		if entry.visual then
			entry.visual:Destroy()
			entry.visual = nil
		end
		entry.shownState, entry.asset, entry.catchConfig = nil, nil, nil
	end

	local function remove(player)
		local entry = entries[player]
		if entry then
			entry.attributeConnection:Disconnect()
			clearVisual(entry)
			entries[player] = nil
		end
	end

	local function onError(entry, message)
		entry.failed = true
		clearVisual(entry)
		if not warned[message] then
			warned[message] = true
			warn("FishingObserverController: " .. tostring(message))
		end
	end

	local function reconcile(player, plotRoot, now, waterY)
		local character = getLiveCharacter(player)
		local raw = character and character:GetAttribute(ObserverState.Attribute)
		if not raw then
			remove(player)
			return
		end
		local entry = entries[player]
		if not entry or entry.character ~= character then
			remove(player)
			entry = { character = character }
			entry.attributeConnection = character:GetAttributeChangedSignal(ObserverState.Attribute):Connect(function()
				nextCheck = 0
			end)
			entries[player] = entry
		end
		if entry.raw ~= raw then
			entry.raw, entry.state, entry.failed = raw, ObserverState.Decode(raw), false
		end
		local state = entry.state
		local plot = state and plotRoot and plotRoot:FindFirstChild(state.plot)
		local part = plot and plot:GetAttribute("OwnerUserId") == player.UserId and FishingSpotUtil.GetStartPart(plot)
		if
			not state
			or not part
			or entry.failed
			or (state.distance and not waterY)
			or (state.expiresAt and now >= state.expiresAt)
		then
			clearVisual(entry)
			return
		end
		if entry.shownState and (entry.shownState.id ~= state.id or entry.part ~= part) then
			clearVisual(entry)
		end
		if entry.shownState == state then
			return
		end
		local asset, catchConfig = getPhaseAsset(state)
		if not asset then
			return
		end
		if not entry.visual then
			local template, rod, cast, special = getRigAssets(state)
			if not template then
				return
			end
			local ok, visual = pcall(ObserverVisual.new, player, character, part, template, rod, cast, special)
			if not ok then
				onError(entry, visual)
				return
			end
			entry.visual, entry.part = visual, part
		end
		entry.shownState, entry.asset, entry.catchConfig = state, asset, catchConfig
	end

	localPlayer:GetAttributeChangedSignal("FishingIntroActive"):Connect(function()
		nextCheck = 0
		if localPlayer:GetAttribute("FishingIntroActive") then
			for player in pairs(entries) do
				remove(player)
			end
		end
	end)
	GameplayInputGate.ContextChanged:Connect(function(context)
		if context ~= "Fishing" then
			return
		end
		nextCheck = 0
		if GameplayInputGate.IsActive("Fishing") then
			for _, entry in pairs(entries) do
				if entry.visual then
					entry.visual:ClearFishShadow()
				end
			end
		end
	end)
	Players.PlayerRemoving:Connect(remove)
	RunService.RenderStepped:Connect(function()
		if localPlayer:GetAttribute("FishingIntroActive") then
			return
		end
		local now = Workspace:GetServerTimeNow()
		local waterY = WaterSurfaceUtil.GetWaterSurfaceY()
		if now >= nextCheck then
			nextCheck = now + RECHECK_SECONDS
			local areas = Workspace:FindFirstChild("Areas")
			local plotRoot = areas and areas:FindFirstChild("Plot")
			for _, player in ipairs(Players:GetPlayers()) do
				if player ~= localPlayer then
					reconcile(player, plotRoot, now, waterY)
				end
			end
		end
		local canSeeFish = not GameplayInputGate.IsActive("Fishing")
		for _, entry in pairs(entries) do
			local state = entry.shownState
			if state and (waterY or not state.distance) then
				local fish = if canSeeFish and state.bite then FishesData[state.bite.fishId] else nil
				local ok, err = pcall(
					entry.visual.Update, entry.visual, state, now, waterY, entry.asset, entry.catchConfig, fish
				)
				if not ok then
					onError(entry, err)
				end
			end
		end
	end)
end

return Controller
