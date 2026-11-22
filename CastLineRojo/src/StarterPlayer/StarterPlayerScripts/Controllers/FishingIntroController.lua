local ContextActionService = game:GetService("ContextActionService")
local Players = game:GetService("Players")
local ProximityPromptService = game:GetService("ProximityPromptService")
local ReplicatedFirst = game:GetService("ReplicatedFirst")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local StarterGui = game:GetService("StarterGui")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")

local Modules = ReplicatedStorage.Modules
local Knit = require(ReplicatedStorage.Packages.Knit)
local FishingInstructionView = require(ReplicatedStorage.Modules.FishingInstructionView)
local Config = require(Modules.FishingIntroConfig)
local FishingConfig = require(Modules.FishingConfig)
local Scene = require(Modules.FishingIntroScene)
local FishingVisibility = require(Modules.FishingVisibility)
local Sequence = require(Modules.FishingCastSequence)
local Analytics = require(Modules.FishingAnalyticsPresentation)
local Audio = require(Modules.FishingAudio)
local UiConfettiUtil = require(Modules.UiConfettiUtil)
local Assets = require(Modules.FishingAssets)
local Gate = require(Modules.GameplayInputGate)
local GuiAnimation = require(Modules.GuiAnimation)
local NotificationClient = require(Modules.NotificationClient)
local PlotWorkspaceUtil = require(Modules.PlotWorkspaceUtil)
local Loading = require(ReplicatedFirst.LoadingAttributes)
local Constants = require(Modules.Constants)
local Fishes = require(ReplicatedFirst.Data.FishesData)
local Rods = require(ReplicatedFirst.Data.RodsData)

local Controller = Knit.CreateController({ Name = "FishingIntroController" })
local player = Players.LocalPlayer
local CAMERA_BINDING, MOVEMENT_BINDING = "FishingIntroCamera", "FishingIntroMovement"
local CONFIRM_BINDING = "FishingIntroConfirm"
local BITE_GUIDE_PHASES = { Waiting = true, Approaching = true, Holding = true, Nibbling = true, Bite = true }
local session

local function remember(state, object, property, value)
	local properties = state.saved[object]
	if not properties then
		properties = {}
		state.saved[object] = properties
	end
	if properties[property] == nil then
		properties[property] = object[property]
	end
	object[property] = value
end

local function hold(state, object, property, value)
	local saved = state.saved[object] and state.saved[object][property] ~= nil
	remember(state, object, property, value)
	if saved then
		return
	end
	table.insert(
		state.connections,
		object:GetPropertyChangedSignal(property):Connect(function()
			if session == state and object[property] ~= value then
				object[property] = value
			end
		end)
	)
end

local function instruction(state, kind)
	FishingInstructionView.ShowFishing(state.hint, kind)
end

local function makeGui(state, playerGui)
	state.gui, state.hint, state.tapIcon, state.biteCue = FishingInstructionView.Create(playerGui, "FishingIntroGui")
	local template = playerGui.FishingSequenceGui:FindFirstChild("IntroBiteGuide")
	if template and template:IsA("ImageLabel") then
		local guide = template:Clone()
		guide.Visible = false
		guide.Parent = state.gui
		state.biteGuide = guide
	end
	instruction(state, "Cast")
end

local function getMeter(playerGui)
	local gui = assert(playerGui:FindFirstChild("CastMeterGui"), "CastMeterGui missing")
	local holder = gui.Meter
	local bar, marker = holder.Bar, holder.Bar.Marker
	return { gui = gui, holder = holder, bar = bar, marker = marker, label = marker.MultLabel, prompt = holder.Prompt }
end

function Controller:IsPlaying()
	return session ~= nil
end

function Controller:Cancel()
	self._startupGeneration = (self._startupGeneration or 0) + 1
	local state = session
	session = nil
	player:SetAttribute(Loading.INTRO_STARTUP_STATE, Loading.INTRO_STATE.Skipped)
	if not state then
		return
	end
	RunService:UnbindFromRenderStep(CAMERA_BINDING)
	ContextActionService:UnbindAction(MOVEMENT_BINDING)
	ContextActionService:UnbindAction(CONFIRM_BINDING)
	for _, c in state.connections do
		c:Disconnect()
	end
	state.visibility:Destroy()
	if state.sequence then
		state.sequence:Destroy()
	end
	if state.audio then
		state.audio:Destroy(false)
	end
	if state.scene then
		state.scene:Destroy()
	end
	if state.gui then
		state.gui:Destroy()
	end
	for object, properties in pairs(state.saved) do
		if object.Parent then
			for property, value in pairs(properties) do
				pcall(function()
					object[property] = value
				end)
			end
		end
	end
	if state.backpackEnabled ~= nil then
		pcall(StarterGui.SetCoreGuiEnabled, StarterGui, Enum.CoreGuiType.Backpack, state.backpackEnabled)
	end
	local music = Knit.GetController("MusicController")
	music:SetCinematicDuck(Controller, nil)
	if state.musicActive ~= nil then
		music:SetFishingActive(state.musicActive)
	end
	local camera = Workspace.CurrentCamera
	if camera and state.camera then
		camera.CFrame, camera.Focus, camera.FieldOfView = state.camera.frame, state.camera.focus, state.camera.fov
		local h = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
		camera.CameraSubject = if player.Character ~= state.character then h else state.camera.subject
		camera.CameraType = state.camera.kind
	end
	Gate.SetActive("Fishing", Controller, false)
	if state.dismissedOffline and state.dismissedOffline.gui.Parent then
		local dismissed = state.dismissedOffline
		dismissed.gui.Enabled = dismissed.enabled
		if dismissed.enabled then
			GuiAnimation.PushModal(dismissed.gui, dismissed.gui.Frame.ConfirmButton)
		end
	end
	player:SetAttribute("FishingIntroPhase", nil)
	if state.token then
		local request = state.service:Cancel(state.token, state.exitRequested == true)
		if state.exitRequested and not state.preview then
			-- Give the server a chance to equip the fish before the placement hints appear.
			request:timeout(Loading.INTRO_CLAIM_TIMEOUT):finally(function()
				if not session then
					player:SetAttribute("FishingIntroActive", false)
				end
			end):catch(function() end)
			return
		end
		request:catch(function() end)
	end
	player:SetAttribute("FishingIntroActive", false)
end

local function failed(state, message)
	if session ~= state then
		return
	end
	warn("FishingIntroController: " .. tostring(message))
	Controller:Cancel()
end

local function failFishingAction(state, message)
	if session == state then
		failed(state, message)
		NotificationClient.RedNotify(message)
	end
end


local function prepareTeaching(state)
	local fishingAnimations = ReplicatedStorage.Animation.Fishing
	local animation = fishingAnimations.CastRod
	local bait, model = Assets.GetBait(nil)
	state.sequence = Sequence.new(state.scene.playerRig, state.playerGui, state.meter, animation, model or bait, {
		specialCastAnimation = fishingAnimations:FindFirstChild("SpecialCastRod"),
		tutorial = true,
		fixedCast = true,
		initialYaw = 0,
		initialLuck = 1,
		launchPosition = state.part.Position,
		audio = state.audio,
		isSoundEnabled = function()
			return state.phase == "Teaching" and state.soundEnabled()
		end,
		updateBiteGuide = function(sequence)
			local guide = state.biteGuide
			if not guide then
				return nil
			end
			guide.Visible = BITE_GUIDE_PHASES[sequence.phase] == true and not sequence.hookPending
			return guide.Visible
		end,
		presentCaught = function(bite, now, camera)
			if not state.caughtAt then
				state.caughtAt = now
				UiConfettiUtil.startSideCannons(state.sequence.gui)
			end
			return state.scene:PresentCatch(bite, now - state.caughtAt, camera)
		end,
		resolveCatch = function(_, id)
			local fish = Fishes[id]
			return fish, fish and Assets.GetFish(fish.Model)
		end,
		requestRound = function(previous)
			return state.service:NextRound(state.token, previous)
		end,
		hook = function(round, pressedAt)
			return state.service:Hook(state.token, round, pressedAt)
		end,
		getHookResult = function(round)
			return state.service:GetHookResult(state.token, round)
		end,
		onFailure = function(message)
			failFishingAction(state, message)
		end,
		onEarlyHook = function()
			state.earlyUntil = os.clock() + 1.3
			instruction(state, "Retry")
			Analytics.Report(state, "EarlyHook")
		end,
	})
	state.preparedAt = os.clock()
end

local function startTeaching(state, meterStartsAt)
	local now = os.clock()
	state.phase, state.startedAt, state.readyAt = "Teaching", now, now + 0.15
	state.sequence.options.meterStartsAt = meterStartsAt
	state.sequence.meterStarted, state.sequence.lastMeterStep = now, -1
	instruction(state, "Cast")
end

local function beginPlayback(state)
	state.phase = "PlaybackStarting"
	state.service
		:StartPlayback(state.token)
		:timeout(Loading.INTRO_CLAIM_TIMEOUT)
		:andThen(function(result)
			if session ~= state then
				return
			end
			if not result.ok then
				failed(state, result.message)
				return
			end
			startTeaching(state, result.meterStartsAt)
			Knit.GetController("MusicController"):SetFishingActive(true)
		end)
		:catch(function(err)
			failed(state, err)
		end)
end

local function update(state, now, dt)
	if state.exitRequested then
		Controller:Cancel()
		return
	end
	local camera = Workspace.CurrentCamera
	local cuePhase, cueElapsed
	assert(
		camera and state.root.Parent and state.character == player.Character and state.humanoid.Health > 0,
		"Opening character or camera disappeared"
	)
	if state.phase == "Prepared" or state.phase == "PlaybackStarting" then
		-- Render the actual ready-to-cast frame under the loading cover without advancing it.
		state.sequence:Update(state.preparedAt, 0)
		state.sequence.meter.prompt.Visible = false
		state.sequence.continueLabel.Visible = false
		instruction(state, "Cast")
		if state.phase == "Prepared" then
			Analytics.Report(state, "FirstFrame")
			player:SetAttribute(Loading.INTRO_STARTUP_STATE, Loading.INTRO_STATE.Prepared)
			if player:GetAttribute(Loading.LOADING_SCREEN_DONE) == true then
				beginPlayback(state)
			end
		end
	else
		local seq = state.sequence
		Knit.GetController("MusicController"):SetCinematicDuck(Controller, nil)
		seq:Update(now, dt)
		local phase = seq.phase
		seq.meter.prompt.Visible, seq.continueLabel.Visible = false, false
		instruction(state, nil)
		local timeline = seq.bite and seq.bite.timeline
		if phase == "Caught" then
			seq.gui.RevealInfo.Visible = true
			seq.vignette.gui.Enabled = false
			seq.continueLabel.Visible = state.caughtAt ~= nil and now >= state.caughtAt + Config.SuccessHold
			if seq.continueLabel.Visible then
				Analytics.Report(state, "ContinuePrompt")
			end
			if seq.continueLabel.Visible and UserInputService.PreferredInput == Enum.PreferredInput.Gamepad then
				seq.continueLabel.Text = "press A to continue"
			end
		elseif state.earlyUntil and now < state.earlyUntil then
			instruction(state, "Retry")
		elseif phase == "Bite" then
			instruction(state, "Hook")
			if not seq.hookPending then
				cuePhase, cueElapsed = phase, now - timeline.startedAt
				Analytics.Report(state, "HookPrompt")
			end
		else
			if phase == "Preparing" then
				instruction(state, "Cast")
				Analytics.Report(state, "CastPrompt")
			elseif phase == "Waiting" or phase == "Approaching" or phase == "Holding" or phase == "Nibbling" then
				instruction(state, "Waiting")
				if phase == "Nibbling" then
					cuePhase = phase
				end
			end
		end
		Analytics.ObserveSequence(state)
		state.lastPhase = phase
	end
	FishingInstructionView.ShowBiteCue(state.biteCue, state.tapIcon, cuePhase, cueElapsed)
	player:SetAttribute("FishingIntroPhase", state.phase == "Teaching" and state.sequence.phase or state.phase)
	state.gui:SetAttribute("Preview", state.preview)
end

function Controller:PlayPreview()
	if not RunService:IsStudio() then
		return
	end
	self:Cancel()
	if player:GetAttribute(Loading.LOADING_SCREEN_DONE) ~= true then
		task.spawn(function()
			self:_RunStartup("Preview")
		end)
		return true
	end
	return self:_PlayPreviewReady()
end

function Controller:_PlayPreviewReady()
	local offline = player.PlayerGui:FindFirstChild("OfflineResultGui")
	local enabled = offline and offline.Enabled
	if offline then
		GuiAnimation.PopModal(offline)
		offline.Enabled = false
	end
	local started = self:Play("Preview")
	if started and session and offline then
		session.dismissedOffline = { gui = offline, enabled = enabled }
	elseif offline then
		offline.Enabled = enabled
		if enabled then
			GuiAnimation.PushModal(offline, offline.Frame.ConfirmButton)
		end
	end
	return started
end

function Controller:Play(mode)
	if session or not Gate.IsWorldActionAllowed() then
		return false
	end
	local character = player.Character
	local root = character and character:FindFirstChild("HumanoidRootPart")
	local humanoid = character and character:FindFirstChildOfClass("Humanoid")
	local plot = PlotWorkspaceUtil.getPlotBySlot(player:GetAttribute("PlotSlotId"))
	local part = plot and plot:FindFirstChild("FishingStartPart")
	local playerGui = player:FindFirstChildOfClass("PlayerGui")
	if
		not root
		or not humanoid
		or humanoid.Health <= 0
		or not part
		or not playerGui
		or (
			player:GetAttribute(Loading.LOADING_SCREEN_DONE) ~= true
			and player:GetAttribute(Loading.INTRO_HANDOFF_READY) ~= true
		)
	then
		return false
	end
	local state = {
		character = character,
		root = root,
		humanoid = humanoid,
		part = part,
		playerGui = playerGui,
		connections = {},
		saved = {},
		visibility = FishingVisibility.new(),
		service = Knit.GetService("FishingIntroService"),
		phase = "Starting",
	}
	session = state
	Gate.SetActive("Fishing", Controller, true)
	player:SetAttribute("FishingIntroActive", true)
	local data = Knit.GetController("PlayerDataController"):GetData()
	local function soundEnabled()
		return data.Settings[Constants.SETTINGS_ID.SOUND] ~= false
	end
	state.soundEnabled = soundEnabled
	task.delay(Loading.INTRO_PREPARE_TIMEOUT, function()
		if
			session == state
			and (state.phase == "Starting" or state.phase == "Prepared" or state.phase == "PlaybackStarting")
		then
			failed(state, "Opening preparation timed out")
		end
	end)
	state.service
		:Begin(mode)
		:andThen(function(result)
			if session ~= state then
				if result.token then
					state.service:Cancel(result.token):catch(function() end)
				end
				return
			end
			if not result.ok or result.completed then
				Controller:Cancel()
				return
			end
			state.token, state.preview = result.token, result.preview
			local ok, err = xpcall(function()
				state.meter = getMeter(playerGui)
				local camera = assert(Workspace.CurrentCamera, "Opening camera unavailable")
				state.camera = {
					frame = camera.CFrame,
					focus = camera.Focus,
					fov = camera.FieldOfView,
					kind = camera.CameraType,
					subject = camera.CameraSubject,
				}
				state.musicActive = Knit.GetController("MusicController")._FishingActive
				state.audio = Audio.new(soundEnabled)
				local rod = assert(Assets.GetRod(Rods[FishingConfig.DefaultRodId].Model))
				state.scene = Scene.new(character, part, rod)
				makeGui(state, playerGui)
				local function hideGui(gui)
					if not gui:IsA("ScreenGui") or gui == state.gui or gui.Name == "FishingIntroLoadingCover" then
						return
					end
					if
						gui.Name == "CastMeterGui"
						or gui.Name == "FishingSequenceGui"
						or gui.Name == "FishingVignetteGui"
					then
						remember(state, gui, "Enabled", false)
					else
						hold(state, gui, "Enabled", false)
					end
				end
				for _, gui in playerGui:GetChildren() do
					hideGui(gui)
				end
				table.insert(state.connections, playerGui.ChildAdded:Connect(hideGui))
				local function hideUiBillboard(d)
					if
						(d:IsA("BillboardGui") or d:IsA("SurfaceGui"))
						and d:GetAttribute("FishingBillboardExempt") ~= true
					then
						state.visibility:Hide(d, "Enabled", false)
					end
				end
				for _, d in playerGui:GetDescendants() do
					hideUiBillboard(d)
				end
				table.insert(state.connections, playerGui.DescendantAdded:Connect(hideUiBillboard))
				local function hidePlayer(p)
					if p.Character then
						state.visibility:HideCharacter(p.Character)
					end
					if p ~= player then
						table.insert(
							state.connections,
							p.CharacterAdded:Connect(function(c)
								state.visibility:HideCharacter(c)
							end)
						)
					end
				end
				for _, p in Players:GetPlayers() do
					hidePlayer(p)
				end
				-- Hide only runtime gameplay displays; source scenery and templates stay intact.
				for _, livePlot in PlotWorkspaceUtil.getSortedPlots() do
					for _, child in livePlot:GetChildren() do
						if child:IsA("Model") and child.Name:match("^PlotFish_") then
							state.visibility:HideCharacter(child)
						end
					end
					table.insert(
						state.connections,
						livePlot.ChildAdded:Connect(function(child)
							if child:IsA("Model") and child.Name:match("^PlotFish_") then
								state.visibility:HideCharacter(child)
							end
						end)
					)
				end
				local localProps = Workspace:FindFirstChild("LocalPlotProps")
				if localProps then
					state.visibility:HideCharacter(localProps)
				end
				table.insert(state.connections, Players.PlayerAdded:Connect(hidePlayer))
				for _, d in Workspace:GetDescendants() do
					if (d:IsA("BillboardGui") or d:IsA("SurfaceGui")) and not d:IsDescendantOf(state.scene.folder) then
						state.visibility:Hide(d, "Enabled", false)
					end
				end
				table.insert(
					state.connections,
					Workspace.DescendantAdded:Connect(function(d)
						if
							(d:IsA("BillboardGui") or d:IsA("SurfaceGui"))
							and d:GetAttribute("FishingBillboardExempt") ~= true
						then
							state.visibility:Hide(d, "Enabled", false)
						end
					end)
				)
				remember(state, root, "Anchored", true)
				remember(state, humanoid, "AutoRotate", false)
				hold(state, ProximityPromptService, "Enabled", false)
				local success, enabled = pcall(StarterGui.GetCoreGuiEnabled, StarterGui, Enum.CoreGuiType.Backpack)
				if success then
					state.backpackEnabled = enabled
				end
				pcall(StarterGui.SetCoreGuiEnabled, StarterGui, Enum.CoreGuiType.Backpack, false)
				ContextActionService:BindActionAtPriority(MOVEMENT_BINDING, function()
					return Enum.ContextActionResult.Sink
				end, false, Enum.ContextActionPriority.High.Value + 110, unpack(Enum.PlayerActions:GetEnumItems()))
				ContextActionService:BindActionAtPriority(CONFIRM_BINDING, function(_, inputState, input)
					if inputState == Enum.UserInputState.Begin then
						Controller:HandleInput(input, false)
					end
					return Enum.ContextActionResult.Sink
				end, false, Enum.ContextActionPriority.High.Value + 120, Enum.KeyCode.ButtonA)
				table.insert(
					state.connections,
					humanoid.Died:Connect(function()
						Controller:Cancel()
					end)
				)
				camera.CameraType = Enum.CameraType.Scriptable
				state.phase = "Prepared"
				prepareTeaching(state)
				RunService:BindToRenderStep(CAMERA_BINDING, Enum.RenderPriority.Camera.Value + 3, function(dt)
					if session ~= state then
						return
					end
					local updated, updateError = pcall(update, state, os.clock(), dt)
					if not updated then
						failed(state, updateError)
					end
				end)
			end, debug.traceback)
			if not ok then
				failed(state, err)
			end
		end)
		:catch(function(err)
			failed(state, err)
		end)
	return true
end

function Controller:HandleInput(input, processed)
	local state = session
	if
		not state
		or state.phase ~= "Teaching"
		or processed
		or Gate.IsUiBlockingWorld()
		or os.clock() < state.readyAt
		or state.castPending
		or state.exitRequested
	then
		return
	end
	if
		input.UserInputType ~= Enum.UserInputType.MouseButton1
		and input.UserInputType ~= Enum.UserInputType.Touch
		and input.KeyCode ~= Enum.KeyCode.ButtonA
	then
		return
	end
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		for _, gui in state.playerGui:GetGuiObjectsAtPosition(input.Position.X, input.Position.Y) do
			if gui:IsA("GuiButton") or gui:IsA("TextBox") or gui.Active then
				return
			end
		end
	end
	local sequence = state.sequence
	if sequence.phase == "Preparing" then
		if Workspace:GetServerTimeNow() < sequence.options.meterStartsAt then
			return
		end
		state.castPending = true
		sequence:BeginCast(os.clock())
		state.service
			:Cast(state.token)
			:timeout(FishingConfig.CastConfirmationTimeout)
			:andThen(function(result)
				if session ~= state then
					return
				end
				state.castPending = false
				if result.ok then
					sequence:Cast(result.castProgress, result.distance, result.luck, result.castRating)
				else
					failFishingAction(state, result.message)
				end
			end)
			:catch(function()
				failFishingAction(state, "Could not confirm the cast.")
			end)
	elseif sequence.phase == "Caught" and state.caughtAt and os.clock() >= state.caughtAt + Config.SuccessHold then
		-- Keep the gameplay input gate closed for the rest of this input dispatch.
		state.exitRequested = true
	elseif sequence.bite and os.clock() >= sequence.readyAt then
		sequence:TryHook(os.clock())
		if session == state and (sequence.hookPending or sequence.bite.timeline.phase ~= "Bite") then
			if state.biteGuide then
				state.biteGuide.Visible = false
			end
			FishingInstructionView.ShowBiteCue(state.biteCue, state.tapIcon)
		end
	end
end

function Controller:KnitInit()
	self._startupGeneration = 0
	player:SetAttribute(Loading.INTRO_STARTUP_STATE, Loading.INTRO_STATE.Pending)
end

local function readyCharacter()
	local character = player.Character
	local root = character and character:FindFirstChild("HumanoidRootPart")
	local humanoid = character and character:FindFirstChildOfClass("Humanoid")
	local plot = PlotWorkspaceUtil.getPlotBySlot(player:GetAttribute("PlotSlotId"))
	return character
		and character:IsDescendantOf(Workspace)
		and root
		and humanoid
		and humanoid.Health > 0
		and player:HasAppearanceLoaded()
		and Workspace.CurrentCamera
		and plot
		and plot:FindFirstChild("FishingStartPart")
end

function Controller:_RunStartup(mode)
	self._startupGeneration += 1
	local generation = self._startupGeneration
	player:SetAttribute(Loading.INTRO_STARTUP_STATE, Loading.INTRO_STATE.Pending)
	local deadline
	local function pending()
		return self._startupGeneration == generation
			and player.Parent ~= nil
			and player:GetAttribute(Loading.INTRO_STARTUP_STATE) ~= Loading.INTRO_STATE.Skipped
	end
	local function expired()
		if player:GetAttribute(Loading.LOADING_BASE_READY) == true and not deadline then
			deadline = os.clock() + Loading.INTRO_PREPARE_TIMEOUT
		end
		return deadline and os.clock() >= deadline
	end
	local ok, err = xpcall(function()
		while pending() and player:GetAttribute(Loading.PLAYER_DATA_LOADED) ~= true do
			if expired() then
				error("Opening data wait timed out")
			end
			task.wait()
		end
		if not pending() then
			return
		end
		if mode == "Auto" then
			local claimed, eligible =
				Knit.GetService("FishingIntroService"):ClaimAutoPlay():timeout(Loading.INTRO_CLAIM_TIMEOUT):await()
			if not pending() then
				return
			end
			if not claimed then
				error("Opening eligibility request failed: " .. tostring(eligible))
			end
			if eligible ~= true then
				self:Cancel()
				return
			end
		end
		while pending() do
			if expired() then
				error("Opening character or scene wait timed out")
			end
			if readyCharacter() and player:GetAttribute(Loading.CLIENT_CONTROLLERS_READY) == true then
				player:SetAttribute(Loading.INTRO_STARTUP_STATE, Loading.INTRO_STATE.Preparing)
				if
					player:GetAttribute(Loading.INTRO_HANDOFF_READY) == true
					or player:GetAttribute(Loading.LOADING_SCREEN_DONE) == true
				then
					local started = if mode == "Preview" then self:_PlayPreviewReady() else self:Play(mode)
					if not started then
						error("Opening could not acquire gameplay controls")
					end
					return
				end
			end
			task.wait()
		end
	end, debug.traceback)
	if not ok and pending() then
		warn("FishingIntroController: " .. tostring(err))
		self:Cancel()
	end
end

function Controller:KnitStart()
	player:GetAttributeChangedSignal(Loading.INTRO_STARTUP_STATE):Connect(function()
		if player:GetAttribute(Loading.INTRO_STARTUP_STATE) == Loading.INTRO_STATE.Skipped and session then
			self:Cancel()
		end
	end)
	if RunService:IsStudio() then
		local control = Instance.new("BindableFunction")
		control.Name = "FishingIntroPreview"
		control.OnInvoke = function(action, time)
			if action == "Play" then
				return self:PlayPreview()
			elseif action == "Cancel" then
				self:Cancel()
				return true
			elseif action == "Status" then
				local state = session
				local seq = state and state.sequence
				local timeline = seq and seq.bite and seq.bite.timeline
				return {
					active = state ~= nil,
					startup = player:GetAttribute(Loading.INTRO_STARTUP_STATE),
					loadingDone = player:GetAttribute(Loading.LOADING_SCREEN_DONE),
					blocked = Gate.IsUiBlockingWorld(),
					worldAllowed = Gate.IsWorldActionAllowed(),
					phase = state and state.phase,
					preview = state and state.preview,
					elapsed = state and (os.clock() - (state.startedAt or os.clock())),
					fishingPhase = seq and seq.phase,
					round = seq and seq.round,
					nibbles = timeline and timeline.completedNibbles,
				}
			end
			return false
		end
		control.Parent = player:WaitForChild("PlayerGui")
	end
	player.CharacterRemoving:Connect(function()
		self:Cancel()
	end)
	UserInputService.InputBegan:Connect(function(input, processed)
		if RunService:IsStudio() then
			if input.KeyCode == Enum.KeyCode.F7 then
				self:Cancel()
				return
			elseif
				input.KeyCode == Enum.KeyCode.F6
				and (session or (not processed and not UserInputService:GetFocusedTextBox()))
			then
				self:PlayPreview()
				return
			end
		end
		if input.KeyCode ~= Enum.KeyCode.ButtonA then
			self:HandleInput(input, processed)
		end
	end)
	task.spawn(function()
		self:_RunStartup("Auto")
	end)
end

return Controller
