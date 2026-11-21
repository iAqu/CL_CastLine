local Players = game:GetService("Players")
local ReplicatedFirst = game:GetService("ReplicatedFirst")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Knit = require(ReplicatedStorage.Packages.Knit)
local Progress = require(ReplicatedStorage.Modules.TrainingProgress)
local Onboarding = require(ReplicatedStorage.Modules.FishingOnboarding)
local Config = require(ReplicatedStorage.Modules.TrainingConfig)
local Spot = require(ReplicatedStorage.Modules.TrainingSpotUtil)
local Grip = require(ReplicatedStorage.Modules.TrainingGrip)
local CharacterLock = require(ReplicatedStorage.Modules.TrainingCharacterLock)
local Display = require(ReplicatedStorage.Modules.TrainingDisplay)
local Items = require(ReplicatedFirst.Data.TrainingData)
local Levels = require(ReplicatedFirst.Data.TrainingLevelsData)
local PlayerDataService = require(script.Parent.PlayerDataService)
local Analytics = require(script.Parent.OnboardingAnalyticsService)

local Service = Knit.CreateService({ Name = "TrainingService", Client = { Changed = Knit.CreateSignal() } })
local states = {}

function Service:_syncDisplay(player, state, plot)
	Display.Sync(state, plot, player, Items[state.training.TrainingID])
end

local function liveCharacter(player)
	local character = player.Character
	local humanoid = character and character:FindFirstChildOfClass("Humanoid")
	local root = character and character:FindFirstChild("HumanoidRootPart")
	if humanoid and root and humanoid.Health > 0 then
		return character, root, humanoid
	end
	return nil
end

function Service:_state(player)
	local profile = PlayerDataService:GetProfile(player)
	if not profile then
		return nil
	end
	local state = states[player]
	if not state then
		state = { active = false, allowed = false, blocked = false, elapsed = 0, revision = 0, resumeChecked = false }
		states[player] = state
	end
	state.training = Progress.Ensure(profile.Data, Items, Levels)
	state.data = profile.Data
	return state
end

function Service:GetMaxCatchWeight(player)
	local state = self:_state(player)
	return Progress.GetLevel(Levels, if state then state.training.Level else 1).MaxCatchWeight
end

function Service:GetSnapshot(player)
	local state = self:_state(player)
	if not state then
		return nil
	end
	local t = state.training
	local level = Progress.GetLevel(Levels, t.Level)
	local nextLevel = Progress.GetLevel(Levels, t.Level + 1)
	local item = Items[t.TrainingID]
	local multiplier = Progress.GetMultiplier(state.data)
	return {
		revision = state.revision,
		active = state.active,
		level = t.Level,
		xp = t.Xp,
		xpToNextLevel = level.XpToNextLevel,
		maxCatchWeight = level.MaxCatchWeight,
		nextWeight = nextLevel and nextLevel.MaxCatchWeight,
		trainingId = t.TrainingID,
		xpPerRep = item.XpPerRep * multiplier,
		xpPerSecond = item.XpPerRep * multiplier / Config.RepInterval,
		multiplier = multiplier,
	}
end

function Service:_publish(player)
	local state = states[player]
	if not state then
		return
	end
	state.revision += 1
	local snapshot = self:GetSnapshot(player)
	if snapshot then
		player:SetAttribute("MaxCatchWeight", snapshot.maxCatchWeight)
		player:SetAttribute("TrainingLevel", snapshot.level)
		player:SetAttribute("TrainingID", snapshot.trainingId)
		player:SetAttribute("IsTraining", snapshot.active)
		self.Client.Changed:Fire(player, snapshot)
	end
end

local function clearVisual(state)
	if state.track then
		state.track:Stop(0.15)
		state.track:Destroy()
		state.track = nil
	end
	if state.barbell then
		state.barbell:Destroy()
		state.barbell = nil
	end
end

local function equip(player, state)
	clearVisual(state)
	local character, _, humanoid = liveCharacter(player)
	local hand = character and (character:FindFirstChild("RightHand") or character:FindFirstChild("Right Arm"))
	local models = ReplicatedStorage:FindFirstChild("Models")
	local folder = models and models:FindFirstChild("Barbell")
	local template = folder and folder:FindFirstChild(Items[state.training.TrainingID].Model)
	local handle = template and template:FindFirstChild("Handle")
	if not hand or not handle or not handle:IsA("BasePart") then
		return false
	end
	local model = template:Clone()
	model.Name = "TrainingBarbell"
	handle = model.Handle
	for _, part in ipairs(model:GetDescendants()) do
		if part:IsA("BasePart") then
			part.Anchored, part.CanCollide, part.CanTouch, part.CanQuery, part.Massless =
				false, false, false, false, true
			if part ~= handle then
				local weld = Instance.new("WeldConstraint")
				weld.Part0, weld.Part1, weld.Parent = handle, part, handle
			end
		end
	end
	local gripOffset = Grip.GetC0(character) or CFrame.identity
	model:PivotTo(hand.CFrame * gripOffset * handle.CFrame:ToObjectSpace(model:GetPivot()))
	local grip = Instance.new("Weld")
	grip.Name, grip.Part0, grip.Part1, grip.C0 = "TrainingGrip", hand, handle, gripOffset
	grip.Parent = handle
	model.Parent = character
	state.barbell = model
	local animationFolder = ReplicatedStorage:FindFirstChild("Animation")
	animationFolder = animationFolder and animationFolder:FindFirstChild("Character")
	local animation = animationFolder and animationFolder:FindFirstChild(Config.AnimationName)
	local animator = humanoid:FindFirstChildOfClass("Animator")
	if animation and animator then
		local ok, track = pcall(function()
			return animator:LoadAnimation(animation)
		end)
		if ok then
			track.Looped, track.Priority = true, Enum.AnimationPriority.Action
			track:Play(0.15)
			state.track = track
		else
			warn("TrainingService: could not load weightlifting animation", track)
		end
	end
	return true
end

function Service:Stop(player, mustLeave, moveOutside)
	local state = self:_state(player)
	if not state then
		return
	end
	local wasActive = state.active
	local changed = wasActive or state.training.ResumeActive
	local character, root, humanoid = liveCharacter(player)
	local plot = Knit.GetService("PlotSlotService"):GetPlayerPlot(player)
	local exitFrame = if moveOutside
			and wasActive
			and character == state.character
			and plot == state.plot
		then Spot.ExitCFrame(plot, character)
		else nil
	state.active, state.elapsed = false, 0
	state.training.ResumeActive = false
	if mustLeave then
		state.blocked = true
	end
	clearVisual(state)
	CharacterLock.Release(state.characterLock)
	state.characterLock = nil
	if exitFrame and root then
		character:PivotTo(exitFrame)
		root.AssemblyLinearVelocity, root.AssemblyAngularVelocity = Vector3.zero, Vector3.zero
	end
	local tool = state.previousTool
	state.previousTool = nil
	if
		character == state.character
		and humanoid
		and tool
		and tool.Parent == player:FindFirstChildOfClass("Backpack")
		and not character:FindFirstChildOfClass("Tool")
	then
		humanoid:EquipTool(tool)
	end
	self:_syncDisplay(player, state, plot)
	if changed then
		self:_publish(player)
	end
	if wasActive then
		local stage = state.data.FishingOnboarding
		if stage and stage.Stage == "StopTraining" then
			local rod = require(ReplicatedStorage.Modules.RodInventory).GetEquippedId(state.data)
			local rods = require(ReplicatedFirst.Data.RodsData)
			local upgraded = rods[rod].LayoutOrder >= rods[Onboarding.RewardRodId].LayoutOrder
			Onboarding.Advance(player, state.data, "StopTraining", if upgraded then "FinalCatch" else "RodReward")
			Analytics:Step(player, "TrainingEnded")
			if upgraded then
				Analytics:Step(player, "RodReady")
				Analytics:Detail(player, "Guide", "RodAlreadyReady")
			end
		end
	end
end

-- Called by the single plot spawn path, before any normal spawn teleport.
function Service:ConsumeResumeSpawn(player, plot, character)
	local state = self:_state(player)
	if not state or state.resumeChecked then
		return nil
	end
	state.resumeChecked = true
	if not Progress.CanResume(state.training, os.time(), Config.ResumeSeconds) then
		state.training.ResumeActive = false
		return nil
	end
	local frame = Spot.SpawnCFrame(plot, character)
	if not frame then
		state.training.ResumeActive = false
	end
	return frame
end

function Service:_step(player, dt)
	local state = self:_state(player)
	if not state then
		return
	end
	local character, root, humanoid = liveCharacter(player)
	local plot = Knit.GetService("PlotSlotService"):GetPlayerPlot(player)
	if plot and plot:GetAttribute("OwnerUserId") ~= player.UserId then
		plot = nil
	end
	local anchor = plot and plot:FindFirstChild("TrainingAnchor")
	local inside = character ~= nil and Spot.Contains(anchor, root, humanoid)
	if not inside then
		state.blocked = false
	end
	local busy = Knit.GetService("FishingService"):IsActive(player)
		or Knit.GetService("FishingIntroService"):IsActive(player)
	local selectedTool = state.active and character and character:FindFirstChildOfClass("Tool") ~= nil
	if
		state.active
		and (
			not inside
			or not state.allowed
			or busy
			or selectedTool
			or state.character ~= character
			or state.plot ~= plot
		)
	then
		self:Stop(player, selectedTool == true)
	end
	self:_syncDisplay(player, state, plot)
	if not inside or state.blocked or not state.allowed or busy then
		return
	end
	if not state.active then
		local frame = Spot.SpawnCFrame(plot, character)
		local lease = frame and CharacterLock.Acquire(character, frame)
		if not lease then
			return
		end
		state.characterLock = lease
		state.previousTool = character:FindFirstChildOfClass("Tool")
		humanoid:UnequipTools()
		if not equip(player, state) then
			CharacterLock.Release(state.characterLock)
			state.characterLock = nil
			if state.previousTool and state.previousTool.Parent == player:FindFirstChildOfClass("Backpack") then
				humanoid:EquipTool(state.previousTool)
			end
			state.previousTool = nil
			if not state.warned then
				state.warned = true
				warn("TrainingService: training barbell or character grip is unavailable")
			end
			return
		end
		state.character, state.active, state.elapsed = character, true, 0
		state.plot = plot
		state.training.ResumeActive, state.training.LastActiveAt = true, os.time()
		self:_syncDisplay(player, state, plot)
		self:_publish(player)
		return
	end
	state.elapsed += dt
	local onboarding = state.data.FishingOnboarding
	local isOnboardingTraining = onboarding and onboarding.Stage == "Train"
	if isOnboardingTraining and not state.onboardingTrainingObserved then
		-- The roster can begin this step while the player is already training.
		state.onboardingTrainingObserved = true
		Analytics:Step(player, "TrainingStarted")
	end
	local reps = math.floor(state.elapsed / Config.RepInterval)
	if reps > 0 then
		state.elapsed -= reps * Config.RepInterval
		local multiplier = Progress.GetMultiplier(state.data)
		local xp = Items[state.training.TrainingID].XpPerRep * multiplier * reps
		local gained = Progress.Advance(state.training, xp, Levels)
		if gained > 0 then
			Analytics:Growth(player, "CL_TrainingLevelUp_v1", gained, state.training.TrainingID,
				state.training.Level, multiplier)
		end
		if isOnboardingTraining and state.training.Level >= 2 and not state.onboardingTrainingLevel2Observed then
			state.onboardingTrainingLevel2Observed = true
			Analytics:Step(player, "TrainingLevel2")
		end
		if isOnboardingTraining and state.training.Level >= Onboarding.TrainingLevel then
			Onboarding.Advance(player, state.data, "Train", "StopTraining")
		end
		state.training.LastActiveAt = os.time()
		self:_publish(player)
	end
end

function Service.Client:GetState(player)
	local state = self.Server:_state(player)
	if state and state.revision == 0 then
		self.Server:_publish(player)
	end
	return self.Server:GetSnapshot(player)
end

function Service.Client:SetAllowed(player, allowed)
	if type(allowed) ~= "boolean" then
		return false
	end
	local state = self.Server:_state(player)
	if not state then
		return false
	end
	state.allowed = allowed
	if not allowed and state.active then
		self.Server:Stop(player, false)
	end
	return true
end

function Service.Client:Stop(player)
	self.Server:Stop(player, true, true)
	return self.Server:GetSnapshot(player)
end

function Service.Client:Upgrade(player, expectedId)
	local state = self.Server:_state(player)
	local _, root = liveCharacter(player)
	local plot = Knit.GetService("PlotSlotService"):GetPlayerPlot(player)
	local anchor = plot and plot:FindFirstChild("TrainingUpgradeAnchor")
	if
		not state
		or not root
		or not anchor
		or (root.Position - anchor.Position).Magnitude > Config.PromptDistance + 2
	then
		return { ok = false, message = "Move closer to your training upgrade." }
	end
	if state.training.TrainingID ~= expectedId then
		return { ok = false, message = "Your training equipment has changed." }
	end
	local nextItem = Progress.GetNextEquipment(Items, expectedId)
	if not nextItem then
		return { ok = false, message = "Training equipment is already MAX." }
	end
	if state.data.Wins < nextItem.Price then
		return { ok = false, message = "Not enough cash." }
	end
	-- No yield between the stale-state check, cash debit and equipment update.
	if not PlayerDataService:AdjustWins(player, -nextItem.Price) then
		return { ok = false, message = "Could not purchase training equipment." }
	end
	state.training.TrainingID = nextItem.TrainingID
	Analytics:Growth(player, "CL_TrainingEquipmentUpgrade_v1", nextItem.Price, nextItem.TrainingID, expectedId)
	if state.active then
		equip(player, state)
	end
	self.Server:_syncDisplay(player, state, plot)
	self.Server:_publish(player)
	return { ok = true, state = self.Server:GetSnapshot(player) }
end

function Service:KnitInit()
	PlayerDataService:RegisterBeforeProfileRelease(function(player, data)
		local state = states[player]
		if state and state.active and data.Training then
			data.Training.LastActiveAt = os.time()
		end
		if state then
			clearVisual(state)
			CharacterLock.Release(state.characterLock)
			Display.Clear(state)
		end
		states[player] = nil
	end)
end

function Service:KnitStart()
	PlayerDataService.ProfileLoaded:Connect(function(player)
		self:_state(player)
		self:_publish(player)
	end)
	local elapsed = 0
	RunService.Heartbeat:Connect(function(dt)
		elapsed += dt
		if elapsed < Config.ScanInterval then
			return
		end
		local step = elapsed
		elapsed = 0
		for _, player in ipairs(Players:GetPlayers()) do
			self:_step(player, step)
		end
	end)
end

return Service
