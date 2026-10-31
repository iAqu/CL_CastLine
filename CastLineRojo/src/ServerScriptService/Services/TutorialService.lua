local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

local Constants = require(ReplicatedStorage.Modules.Constants)
local ItemToolUtil = require(ReplicatedStorage.Modules.ItemToolUtil)
local Knit = require(ReplicatedStorage.Packages.Knit)
local TideConfig = require(ReplicatedStorage.Modules.TideConfig)
local TutorialConfig = require(ReplicatedStorage.Modules.TutorialConfig)
local UpgradeShopConfig = require(ReplicatedStorage.Modules.UpgradeShopConfig)
local PlayerDataService = require(ServerScriptService.Services.PlayerDataService)

local TutorialService = Knit.CreateService({
	Name = "TutorialService",
	Client = {
		TutorialStateChanged = Knit.CreateSignal(),
	},
})

TutorialService.CASH_SPEND_BLOCKED_MESSAGE = "Finish the tutorial first!"

local function isTutorialEnabled(): boolean
	return Constants.TUTORIAL_ENABLED == true
end

local function isLowTideDigPhase(phase: unknown): boolean
	return phase == TideConfig.PHASE.RECEDING or phase == TideConfig.PHASE.LOW
end

local function isTutorialSiteDigPhase(phase: unknown): boolean
	return isLowTideDigPhase(phase) or phase == TideConfig.PHASE.RISING
end

local function getDigOpensAt(tideSnapshot): number?
	if typeof(tideSnapshot) ~= "table" or tideSnapshot.isPaused == true then
		return nil
	end
	if tideSnapshot.phase == TideConfig.PHASE.FULL and typeof(tideSnapshot.phaseEndsAt) == "number" then
		return tideSnapshot.phaseEndsAt
	end
	if tideSnapshot.phase == TideConfig.PHASE.RISING and typeof(tideSnapshot.cycleEndsAt) == "number" then
		return tideSnapshot.cycleEndsAt + TideConfig.FULL_DURATION
	end
	return nil
end

local function getStateFromData(playerData, tideSnapshot)
	local step = TutorialConfig.GetCurrentStep(playerData)
	local tidePhase = if typeof(tideSnapshot) == "table" then tideSnapshot.phase else nil
	local wins = math.max(0, tonumber(playerData and playerData.Wins) or 0)
	local cashCollected = playerData and playerData.TutorialCashCollected == true or false
	local carryLevel = UpgradeShopConfig.GetLevel(playerData, Constants.UPGRADE_ID.CARRY_WEIGHT)
	local carryUpgradePrice = UpgradeShopConfig.GetBundlePrice(
		Constants.UPGRADE_ID.CARRY_WEIGHT,
		carryLevel,
		1
	)
	return {
		version = TutorialConfig.VERSION,
		step = step,
		completed = step == TutorialConfig.COMPLETE_STEP,
		duckInstanceId = playerData and playerData.TutorialDuckInstanceId or "",
		tidePhase = tidePhase,
		digOpensAt = getDigOpensAt(tideSnapshot),
		canDig = step == TutorialConfig.STEP.DIG_DUCK and isTutorialSiteDigPhase(tidePhase),
		returnedToDigZone = playerData and playerData.TutorialReturnedToDigZone == true or false,
		secondItemInstanceId = playerData and playerData.TutorialSecondItemInstanceId or "",
		secondItemPlaced = playerData and playerData.TutorialSecondItemPlaced == true or false,
		cashPoolSlot = math.max(0, math.floor(tonumber(playerData and playerData.TutorialCashPoolSlot) or 0)),
		cashCollected = cashCollected,
		backpackUpgraded = playerData and playerData.TutorialBackpackUpgraded == true or false,
		backpackEligible = playerData ~= nil
			and playerData.TutorialSecondItemPlaced == true
			and cashCollected
			and playerData.TutorialBackpackUpgraded ~= true
			and wins >= carryUpgradePrice,
	}
end

local function getCompleteState(tideSnapshot)
	return {
		version = TutorialConfig.VERSION,
		step = TutorialConfig.COMPLETE_STEP,
		completed = true,
		duckInstanceId = "",
		tidePhase = if typeof(tideSnapshot) == "table" then tideSnapshot.phase else nil,
		digOpensAt = nil,
		canDig = false,
		returnedToDigZone = true,
		secondItemInstanceId = "",
		secondItemPlaced = true,
		cashPoolSlot = 0,
		cashCollected = true,
		backpackUpgraded = true,
		backpackEligible = false,
	}
end

local function findItemTool(player: Player, instanceId: string): Tool?
	for _, container in ipairs({ player:FindFirstChildOfClass("Backpack"), player.Character }) do
		if container then
			for _, child in ipairs(container:GetChildren()) do
				if child:IsA("Tool") and ItemToolUtil.GetInstanceId(child) == instanceId then
					return child
				end
			end
		end
	end
	return nil
end

function TutorialService:GetState(player: Player)
	local tideSnapshot = Knit.GetService("TideService"):GetStateSnapshot()
	local profile = PlayerDataService:GetProfile(player)
	if not profile or not isTutorialEnabled() or profile.Data.TutorialVersion ~= TutorialConfig.VERSION then
		return getCompleteState(tideSnapshot)
	end
	return getStateFromData(profile.Data, tideSnapshot)
end

function TutorialService:IsAtStep(player: Player, step: number): boolean
	local profile = PlayerDataService:GetProfile(player)
	return profile ~= nil
		and isTutorialEnabled()
		and TutorialConfig.GetCurrentStep(profile.Data) == step
end

function TutorialService:IsPrimaryActive(player: Player): boolean
	local profile = PlayerDataService:GetProfile(player)
	return profile ~= nil
		and profile.Data.TutorialVersion == TutorialConfig.VERSION
		and isTutorialEnabled()
		and not TutorialConfig.IsComplete(profile.Data)
end

function TutorialService:CanDigTutorialSite(player: Player): boolean
	if not self:IsAtStep(player, TutorialConfig.STEP.DIG_DUCK) then
		return false
	end
	local snapshot = Knit.GetService("TideService"):GetStateSnapshot()
	return snapshot ~= nil and isTutorialSiteDigPhase(snapshot.phase)
end

function TutorialService:IsProtectedItem(player: Player, instanceId: string): boolean
	local profile = PlayerDataService:GetProfile(player)
	return profile ~= nil
		and profile.Data.TutorialVersion == TutorialConfig.VERSION
		and isTutorialEnabled()
		and TutorialConfig.GetCurrentStep(profile.Data) == TutorialConfig.STEP.RETURN_HOME
		and profile.Data.TutorialDuckInstanceId == instanceId
end

function TutorialService:CanSpendWins(player: Player, allowedSteps: number | { number }?): (boolean, string?)
	local profile = PlayerDataService:GetProfile(player)
	if not profile or not isTutorialEnabled() then
		return true, nil
	end

	local currentStep = TutorialConfig.GetCurrentStep(profile.Data)
	if currentStep == TutorialConfig.COMPLETE_STEP or currentStep == allowedSteps then
		return true, nil
	end
	if typeof(allowedSteps) == "table" then
		for _, allowedStep in ipairs(allowedSteps) do
			if currentStep == allowedStep then
				return true, nil
			end
		end
	end
	return false, TutorialService.CASH_SPEND_BLOCKED_MESSAGE
end

function TutorialService:_pushState(player: Player)
	if player.Parent then
		self.Client.TutorialStateChanged:Fire(player, self:GetState(player))
	end
end

function TutorialService:_ensureStepResources(player: Player)
	local digItemService = Knit.GetService("DigItemService")
	local profile = PlayerDataService:GetProfile(player)
	local step = profile and TutorialConfig.GetCurrentStep(profile.Data) or TutorialConfig.COMPLETE_STEP
	if step == TutorialConfig.STEP.WAIT_FOR_LOW_TIDE or step == TutorialConfig.STEP.DIG_DUCK then
		digItemService:EnsureTutorialSite(player)
	else
		digItemService:RemoveTutorialSite(player)
		if step == TutorialConfig.COMPLETE_STEP then
			digItemService:RefreshPlayerSites(player)
		end
	end
end

function TutorialService:TryAdvance(player: Player, expectedStep: number, context): boolean
	local profile = PlayerDataService:GetProfile(player)
	if not profile or not isTutorialEnabled() then
		return false
	end
	if not TutorialConfig.TryAdvanceData(profile.Data, expectedStep, context) then
		return false
	end

	self:_ensureStepResources(player)
	self:_pushState(player)
	return true
end

function TutorialService:_removeItem(player: Player, instanceId: string)
	if instanceId == "" then
		return
	end
	local profile = PlayerDataService:GetProfile(player)
	if profile and typeof(profile.Data.Items) == "table" then
		profile.Data.Items[instanceId] = nil
	end
	local tool = findItemTool(player, instanceId)
	if tool then
		tool:Destroy()
	end
	Knit.GetService("HotbarLayoutService"):RemoveItemDescriptors(player, { instanceId })
	Knit.GetService("CarryCapacityService"):RefreshPlayer(player)
end

function TutorialService:_rollbackReturnHome(player: Player)
	local profile = PlayerDataService:GetProfile(player)
	if not profile or TutorialConfig.GetCurrentStep(profile.Data) ~= TutorialConfig.STEP.RETURN_HOME then
		return
	end
	local instanceId = if typeof(profile.Data.TutorialDuckInstanceId) == "string"
		then profile.Data.TutorialDuckInstanceId
		else ""
	self:_removeItem(player, instanceId)
	profile.Data.TutorialDuckInstanceId = ""
	profile.Data.TutorialComplete[TutorialConfig.STEP.DIG_DUCK] = nil
	task.defer(function()
		if player.Parent then
			self:_ensureStepResources(player)
			self:_pushState(player)
		end
	end)
end

function TutorialService:OnItemDug(player: Player, itemId: string, instanceId: string, isTutorialSite: boolean)
	if isTutorialSite then
		self:TryAdvance(player, TutorialConfig.STEP.DIG_DUCK, {
			itemId = itemId,
			instanceId = instanceId,
		})
		return
	end

	local profile = PlayerDataService:GetProfile(player)
	if not profile
		or profile.Data.TutorialVersion ~= TutorialConfig.VERSION
		or not isTutorialEnabled()
		or not TutorialConfig.IsComplete(profile.Data)
	then
		return
	end
	if profile.Data.TutorialSecondItemPlaced == true then
		return
	end
	local currentTarget = profile.Data.TutorialSecondItemInstanceId
	if typeof(currentTarget) ~= "string" or currentTarget == "" then
		profile.Data.TutorialSecondItemInstanceId = instanceId
		self:_pushState(player)
	end
end

function TutorialService:OnItemsSold(player: Player, itemIds: { string })
	local profile = PlayerDataService:GetProfile(player)
	if not profile or not isTutorialEnabled() then
		return
	end
	local step = TutorialConfig.GetCurrentStep(profile.Data)
	if step == TutorialConfig.STEP.SELL_DUCK then
		for _, instanceId in ipairs(itemIds) do
			if instanceId == profile.Data.TutorialDuckInstanceId then
				self:TryAdvance(player, step, { instanceId = instanceId })
				break
			end
		end
	elseif not TutorialConfig.IsComplete(profile.Data) then
		return
	end

	local secondItemId = profile.Data.TutorialSecondItemInstanceId
	if typeof(secondItemId) == "string" and secondItemId ~= "" and table.find(itemIds, secondItemId) then
		profile.Data.TutorialSecondItemInstanceId = ""
		self:_pushState(player)
	end
end

function TutorialService:OnShovelPurchased(player: Player, shovelId: string)
	self:TryAdvance(player, TutorialConfig.STEP.BUY_SHOVEL, { shovelId = shovelId })
end

function TutorialService:OnItemPlaced(player: Player, instanceId: string, slot: number)
	local profile = PlayerDataService:GetProfile(player)
	if not profile
		or profile.Data.TutorialVersion ~= TutorialConfig.VERSION
		or not isTutorialEnabled()
		or not TutorialConfig.IsComplete(profile.Data)
	then
		return
	end
	if typeof(slot) ~= "number" or slot % 1 ~= 0 or slot < 1 then
		return
	end
	if profile.Data.TutorialSecondItemPlaced ~= true
		and profile.Data.TutorialSecondItemInstanceId == instanceId
	then
		profile.Data.TutorialSecondItemPlaced = true
		profile.Data.TutorialSecondItemInstanceId = ""
		profile.Data.TutorialCashPoolSlot = slot
		self:_pushState(player)
	end
end

function TutorialService:OnCashCollected(player: Player, slot: number, amount: number)
	local profile = PlayerDataService:GetProfile(player)
	if not profile
		or profile.Data.TutorialVersion ~= TutorialConfig.VERSION
		or not isTutorialEnabled()
		or not TutorialConfig.IsComplete(profile.Data)
		or profile.Data.TutorialSecondItemPlaced ~= true
		or profile.Data.TutorialCashCollected == true
		or typeof(slot) ~= "number"
		or slot % 1 ~= 0
		or slot ~= profile.Data.TutorialCashPoolSlot
		or typeof(amount) ~= "number"
		or amount < 1
	then
		return
	end

	profile.Data.TutorialCashCollected = true
	self:_pushState(player)
end

function TutorialService:OnBackpackUpgraded(player: Player)
	local profile = PlayerDataService:GetProfile(player)
	if not profile
		or profile.Data.TutorialVersion ~= TutorialConfig.VERSION
		or not isTutorialEnabled()
		or not TutorialConfig.IsComplete(profile.Data)
	then
		return
	end
	if profile.Data.TutorialSecondItemPlaced == true and profile.Data.TutorialBackpackUpgraded ~= true then
		profile.Data.TutorialBackpackUpgraded = true
		self:_pushState(player)
	end
end

function TutorialService.Client:GetTutorialState(player: Player)
	return self.Server:GetState(player)
end

function TutorialService.Client:ReportReturnedHome(player: Player)
	if player:GetAttribute("IsInDigZone") == true then
		return false
	end
	return self.Server:TryAdvance(player, TutorialConfig.STEP.RETURN_HOME, {})
end

function TutorialService.Client:ReportEnteredDigZone(player: Player)
	local profile = PlayerDataService:GetProfile(player)
	if not profile
		or not isTutorialEnabled()
		or profile.Data.TutorialVersion ~= TutorialConfig.VERSION
		or not TutorialConfig.IsComplete(profile.Data)
		or player:GetAttribute("IsInDigZone") ~= true
	then
		return false
	end
	if profile.Data.TutorialReturnedToDigZone == true then
		return true
	end

	profile.Data.TutorialReturnedToDigZone = true
	self.Server:_pushState(player)
	return true
end

function TutorialService:KnitStart()
	local tideService = Knit.GetService("TideService")

	local function syncTideForPlayer(player: Player, snapshot)
		local profile = PlayerDataService:GetProfile(player)
		if not profile or not self:IsPrimaryActive(player) then
			return
		end

		local step = TutorialConfig.GetCurrentStep(profile.Data)
		local canAdvanceToDig = typeof(snapshot) == "table" and isLowTideDigPhase(snapshot.phase)
		if step == TutorialConfig.STEP.WAIT_FOR_LOW_TIDE and canAdvanceToDig then
			self:TryAdvance(player, step, {})
			return
		end
		if step == TutorialConfig.STEP.DIG_DUCK or step == TutorialConfig.STEP.WAIT_FOR_LOW_TIDE then
			self:_pushState(player)
		end
	end

	local function initializePlayer(player: Player)
		local profile = PlayerDataService:GetProfile(player)
		if not profile then
			return
		end
		local data = profile.Data
		if data.TutorialVersion == TutorialConfig.VERSION then
			data.TutorialDuckInstanceId = if typeof(data.TutorialDuckInstanceId) == "string"
				then data.TutorialDuckInstanceId
				else ""
			data.TutorialReturnedToDigZone = data.TutorialReturnedToDigZone == true
			data.TutorialSecondItemInstanceId = if typeof(data.TutorialSecondItemInstanceId) == "string"
				then data.TutorialSecondItemInstanceId
				else ""
			data.TutorialSecondItemPlaced = data.TutorialSecondItemPlaced == true
			data.TutorialCashPoolSlot = math.max(0, math.floor(tonumber(data.TutorialCashPoolSlot) or 0))
			data.TutorialCashCollected = data.TutorialCashCollected == true
			data.TutorialBackpackUpgraded = data.TutorialBackpackUpgraded == true
		end
		if self:IsAtStep(player, TutorialConfig.STEP.RETURN_HOME)
			and (data.TutorialDuckInstanceId == ""
				or typeof(data.Items) ~= "table"
				or data.Items[data.TutorialDuckInstanceId] == nil)
		then
			self:_rollbackReturnHome(player)
		else
			self:_ensureStepResources(player)
			syncTideForPlayer(player, tideService:GetStateSnapshot())
			if not self:IsPrimaryActive(player)
				or TutorialConfig.GetCurrentStep(data) > TutorialConfig.STEP.DIG_DUCK
			then
				self:_pushState(player)
			end
		end

		local function bindCharacter(character: Model)
			local humanoid = character:FindFirstChildOfClass("Humanoid") or character:WaitForChild("Humanoid", 5)
			if humanoid and humanoid:IsA("Humanoid") then
				humanoid.Died:Connect(function()
					self:_rollbackReturnHome(player)
					local currentProfile = PlayerDataService:GetProfile(player)
					if currentProfile and TutorialConfig.IsComplete(currentProfile.Data) then
						local targetId = currentProfile.Data.TutorialSecondItemInstanceId
						if typeof(targetId) == "string"
							and targetId ~= ""
							and (typeof(currentProfile.Data.Items) ~= "table"
								or currentProfile.Data.Items[targetId] == nil)
						then
							currentProfile.Data.TutorialSecondItemInstanceId = ""
							self:_pushState(player)
						end
					end
				end)
			end
		end
		player.CharacterAdded:Connect(bindCharacter)
		if player.Character then
			bindCharacter(player.Character)
		end
	end

	PlayerDataService.ProfileLoaded:Connect(function(player: Player)
		task.defer(initializePlayer, player)
	end)
	PlayerDataService.WinsChangedServerEvent:Connect(function(player: Player)
		if isTutorialEnabled() then
			self:_pushState(player)
		end
	end)
	tideService.StateChangedServerEvent:Connect(function(snapshot)
		for _, player in Players:GetPlayers() do
			syncTideForPlayer(player, snapshot)
		end
	end)
	for _, player in ipairs(Players:GetPlayers()) do
		if PlayerDataService:GetProfile(player) then
			task.defer(initializePlayer, player)
		end
	end
end

return TutorialService
