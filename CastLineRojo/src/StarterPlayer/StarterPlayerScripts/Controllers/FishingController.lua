local MarketplaceService = game:GetService("MarketplaceService")
local ContextActionService = game:GetService("ContextActionService")
local GuiService = game:GetService("GuiService")
local Players = game:GetService("Players")
local ProximityPromptService = game:GetService("ProximityPromptService")
local ReplicatedFirst = game:GetService("ReplicatedFirst")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local StarterGui = game:GetService("StarterGui")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")

local Knit = require(ReplicatedStorage.Packages.Knit)
local FishingRigUtil = require(ReplicatedStorage.Modules.FishingRigUtil)
local FishingVisibility = require(ReplicatedStorage.Modules.FishingVisibility)
local FishingCastSequence = require(ReplicatedStorage.Modules.FishingCastSequence)
local FishingAudio = require(ReplicatedStorage.Modules.FishingAudio)
local FishingOnboarding = require(ReplicatedStorage.Modules.FishingOnboarding)
local Analytics = require(ReplicatedStorage.Modules.FishingAnalyticsPresentation)
local Config = require(ReplicatedStorage.Modules.FishingConfig)
local FishingAssets = require(ReplicatedStorage.Modules.FishingAssets)
local FishingBaitSelect = require(ReplicatedStorage.Modules.FishingBaitSelect)
local BaitConfig = require(ReplicatedStorage.Modules.FishingBaitConfig)
local FishingSpotUtil = require(ReplicatedStorage.Modules.FishingSpotUtil)
local PlotWorkspaceUtil = require(ReplicatedStorage.Modules.PlotWorkspaceUtil)
local NotificationClient = require(ReplicatedStorage.Modules.NotificationClient)
local Constants = require(ReplicatedStorage.Modules.Constants)
local GameplayInputGate = require(ReplicatedStorage.Modules.GameplayInputGate)
local LoadingAttributes = require(ReplicatedFirst.LoadingAttributes)

local fishingData = ReplicatedFirst:WaitForChild("Data")
local RodsData = require(fishingData:WaitForChild("RodsData"))
local BaitsData = require(fishingData:WaitForChild("BaitsData"))
local PurchaseData = require(fishingData:WaitForChild("PurchaseData"))
local FishesData = require(fishingData:WaitForChild("FishesData"))
local PetFeatureConfig = require(ReplicatedStorage.Modules.PetFeatureConfig)
local EggsData = if PetFeatureConfig.Enabled then require(fishingData:WaitForChild("EggsData")) else {}

local localPlayer = Players.LocalPlayer
local CAMERA_BINDING = "CastLineFishingCamera"
local CONFIRM_BINDING = "CastLineFishingConfirm"
local MOVEMENT_BINDING = "CastLineFishingMovement"
local ENTRY_RETRY_SECONDS = 0.1
local ENTRY_TIMEOUT_SECONDS = 1
local EVENT_ENTRY_TIMEOUT_SECONDS = 5
local ACTIVE_DISPLACEMENT_LIMIT = 20
local FishingController = Knit.CreateController({ Name = "FishingController" })
local session = nil
local pendingEntry = nil
local mustLeaveArea = false
local warned = {}

local function warnOnce(message: string)
	if not warned[message] then
		warned[message] = true
		warn("FishingController: " .. message)
	end
end

local function remember(state, instance: Instance, property: string, value)
	local properties = state.saved[instance]
	if not properties then
		properties = {}
		state.saved[instance] = properties
	end
	if properties[property] == nil then
		properties[property] = instance[property]
	end
	instance[property] = value
end

local function hold(state, instance: Instance, property: string, value)
	local alreadySaved = state.saved[instance] and state.saved[instance][property] ~= nil
	remember(state, instance, property, value)
	if not alreadySaved then
		table.insert(
			state.connections,
			instance:GetPropertyChangedSignal(property):Connect(function()
				if session == state and instance[property] ~= value then
					instance[property] = value
				end
			end)
		)
	end
end

local function hideSceneUi(state, playerGui: PlayerGui)
	local function hideGui(instance: Instance)
		if
			session == state
			and not state.restored
			and (instance:IsA("BillboardGui") or instance:IsA("SurfaceGui"))
			and instance:GetAttribute("FishingBillboardExempt") ~= true
		then
			-- The event controller owns the countdown's visibility and restores it from the live event.
			if instance.Name == "Overhead" and instance:IsA("BillboardGui") then
				local areas = Workspace:FindFirstChild("Areas")
				if areas and instance.Parent == areas:FindFirstChild("EventFish") then
					return
				end
			end
			state.visibility:Hide(instance, "Enabled", false)
		end
	end
	for _, container in ipairs({ Workspace, playerGui }) do
		table.insert(state.connections, container.DescendantAdded:Connect(hideGui))
		for _, descendant in ipairs(container:GetDescendants()) do
			hideGui(descendant)
		end
	end
end

local function bindBaitCash(state, playerGui: PlayerGui, baitGui: ScreenGui): ScreenGui?
	local homeGui = playerGui:FindFirstChild("HomeGui")
	local bottom = homeGui and homeGui:FindFirstChild("BottomFrame")
	local currency = bottom and bottom:FindFirstChild("CurrencyFrame")
	local wins = currency and currency:FindFirstChild("Wins")
	if not (homeGui and homeGui:IsA("ScreenGui") and wins and wins:IsA("GuiObject")) then
		return nil
	end

	for _, branch in ipairs({ bottom, currency, wins }) do
		for _, child in ipairs(branch.Parent:GetChildren()) do
			if child:IsA("GuiObject") then
				hold(state, child, "Visible", child == branch)
			end
		end
	end

	remember(state, homeGui, "Enabled", baitGui.Enabled)
	local function syncCash()
		if session == state and not state.restored and homeGui.Enabled ~= baitGui.Enabled then
			homeGui.Enabled = baitGui.Enabled
		end
	end
	table.insert(state.connections, baitGui:GetPropertyChangedSignal("Enabled"):Connect(syncCash))
	table.insert(state.connections, homeGui:GetPropertyChangedSignal("Enabled"):Connect(syncCash))
	return homeGui
end

local function hidePlayer(state, player: Player)
	if player.Character then
		state.visibility:HideCharacter(player.Character)
	end
	if player ~= localPlayer then
		table.insert(
			state.connections,
			player.CharacterAdded:Connect(function(character)
				if session == state then
					state.visibility:HideCharacter(character)
				end
			end)
		)
	end
end

local function getOwnPlot(): Instance?
	local slotId = localPlayer:GetAttribute("PlotSlotId")
	local plot = if typeof(slotId) == "number" then PlotWorkspaceUtil.getPlotBySlot(slotId) else nil
	return if plot and plot:GetAttribute("OwnerUserId") == localPlayer.UserId then plot else nil
end

local function getCastPrompt()
	local playerGui = localPlayer:FindFirstChildOfClass("PlayerGui")
	local gui = playerGui and playerGui:FindFirstChild("CastMeterGui")
	local meter = gui and gui:FindFirstChild("Meter")
	local bar = meter and meter:FindFirstChild("Bar")
	local marker = bar and bar:FindFirstChild("Marker")
	local label = marker and marker:FindFirstChild("MultLabel")
	local prompt = meter and meter:FindFirstChild("Prompt")
	if not (gui and gui:IsA("ScreenGui") and meter and meter:IsA("GuiObject")
		and bar and bar:IsA("GuiObject") and marker and marker:IsA("GuiObject")
		and label and label:IsA("TextLabel") and prompt and prompt:IsA("TextLabel"))
	then
		return nil
	end
	return { gui = gui, holder = meter, bar = bar, marker = marker, label = label, prompt = prompt }
end

local function cancelServerSession(state, finished, emptyReelRound)
	if state.token then
		local token = state.token
		state.token = nil
		return state.service:Cancel(token, finished == true, emptyReelRound):catch(function() end)
	end
end

local function restore(state, returnToSpawn: boolean)
	if state.restored then
		return
	end
	state.restored = true
	if state.baitSelection then
		state.baitSelection.Destroy()
		state.baitSelection = nil
	end
	if state.fishingMusic then
		Knit.GetController("MusicController"):SetFishingActive(false)
	end
	for _, connection in ipairs(state.connections) do
		connection:Disconnect()
	end
	state.visibility:Destroy()
	if state.sequence then
		state.sequence:Destroy(returnToSpawn)
	elseif state.audio then
		state.audio:Destroy(false)
	end
	if state.rig then
		state.rig:Destroy()
	end
	if state.originalRootCFrame and state.character.Parent and state.root.Parent and localPlayer.Character == state.character then
		if returnToSpawn then
			local plot = getOwnPlot()
			local spawn = plot and plot:FindFirstChild("AreaSpawnPoint")
			local target = state.originalRootCFrame
			if spawn and spawn:IsA("BasePart") then
				target = spawn.CFrame * CFrame.new(0, spawn.Size.Y / 2 + state.footHeight + 0.1, 0)
			end
			-- 以 HRP 为基准传送，兼容 Model pivot 与 HRP 不重合的角色。
			state.character:PivotTo(target * state.root.CFrame:ToObjectSpace(state.character:GetPivot()))
		end
		state.root.AssemblyLinearVelocity = Vector3.zero
		state.root.AssemblyAngularVelocity = Vector3.zero
	end
	for instance, properties in pairs(state.saved) do
		if instance.Parent then
			for property, value in pairs(properties) do
				local ok, err = pcall(function()
					instance[property] = value
				end)
				if not ok then
					warnOnce(tostring(err))
				end
			end
		end
	end
	if state.meter and state.meter.gui.Parent then
		state.meter.gui.Enabled = false
	end
	if state.backpackEnabled ~= nil then
		pcall(function()
			StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Backpack, state.backpackEnabled)
		end)
	end
	if state.camera.changed then
		local camera = Workspace.CurrentCamera
		if camera then
			local character = localPlayer.Character
			camera.CameraSubject = (character and character:FindFirstChildOfClass("Humanoid")) or state.camera.subject
			camera.FieldOfView = state.camera.fov
			local offset = CFrame.identity
			if returnToSpawn and state.root.Parent and character == state.character then
				offset = state.root.CFrame * state.originalRootCFrame:Inverse()
			end
			camera.CFrame = offset * state.camera.cframe
			camera.Focus = offset * state.camera.focus
			camera.CameraType = state.camera.cameraType
		end
	end
end

local function finish(returnToSpawn: boolean, completedReturn: boolean?)
	if not completedReturn then
		FishingAudio.ClearTails()
	end
	local state = session
	if not state then
		return
	end
	session = nil
	if state.originalRootCFrame then
		mustLeaveArea = true
	end
	RunService:UnbindFromRenderStep(CAMERA_BINDING)
	ContextActionService:UnbindAction(MOVEMENT_BINDING)
	ContextActionService:UnbindAction(CONFIRM_BINDING)
	restore(state, returnToSpawn)
	cancelServerSession(state, completedReturn and state.caughtOnReturn)
	if state.coverGui then
		state.coverGui:Destroy()
	end
	GameplayInputGate.SetActive("Fishing", FishingController, false)
	if state.lesson then
		localPlayer:SetAttribute(FishingOnboarding.LessonActiveAttribute, false)
	end
end

local function startTransition(state, mode)
	state.readyAt = math.huge
	state.transition = { mode = mode, started = os.clock() }
	state.coverGui.Enabled = true
	state.cover.BackgroundTransparency = 1
end

local function rollbackEntryPresentation(state)
	local transition = state.transition
	if not transition or transition.mode ~= "Entering" or not state.coverGui.Parent or not state.cover.Parent
		or state.cover.BackgroundTransparency == 1
	then
		finish(false)
		return
	end
	if state.restored then
		return
	end
	-- Restore the world under the current cover, even if the fade in was interrupted.
	restore(state, false)
	cancelServerSession(state)
	transition.revealFrom = state.cover.BackgroundTransparency
	transition.revealedAt = os.clock()
end

local function showBaitSelection(state, now)
	if session == state and not state.transition and state.onReady then
		local onReady = state.onReady
		state.onReady = nil
		state.readyAt = now
		onReady()
	end
end

local function updateTransition(state, now)
	local transition = state.transition
	if not transition then
		return
	end
	local timing = Config.Transition[transition.mode]
	if not transition.revealedAt then
		local alpha = math.clamp((now - transition.started) / timing.Cover, 0, 1)
		state.cover.BackgroundTransparency = 1 - alpha
		if alpha == 1 then
			if transition.mode == "Entering" then
				if state.prepare then
					state.prepare()
					state.prepare = nil
				end
				if not state.onReady then
					return
				end
			else
				restore(state, true)
			end
			transition.revealedAt = now
		end
	else
		local alpha = math.clamp((now - transition.revealedAt) / timing.Reveal, 0, 1)
		local revealFrom = transition.revealFrom or 0
		state.cover.BackgroundTransparency = revealFrom + (1 - revealFrom) * alpha
		if alpha == 1 then
			state.transition = nil
			state.coverGui.Enabled = false
			if state.restored then
				finish(false, transition.mode == "Returning")
			else
				showBaitSelection(state, now)
			end
		end
	end
end

function FishingController:IsPreparing(): boolean
	return session ~= nil
end

function FishingController:GetEventFishSnapshot()
	return session and session.eventFish
end

function FishingController:GetOnboardingHint()
	local state = session
	if not state or not state.lesson then
		return false
	end
	if state.transition then
		return true
	end
	if state.lesson == "FinalCatch" and state.baitSelection then
		local target = state.baitSelection.GetButton(state.guideBaitId)
		if target then
			local bait = BaitsData[state.guideBaitId]
			return true, nil, target, "SELECT " .. string.upper(bait.DisplayName)
		end
	end
	local seq = state.sequence
	if not seq then
		return true
	end
	local now = os.clock()
	local phase = seq.phase
	if phase == "Preparing" then
		return true, "FinalCast"
	elseif phase == "Caught" and seq:CanReturn(now) then
		return true, "Continue"
	elseif state.earlyUntil and now < state.earlyUntil then
		return true, "Retry"
	elseif phase == "Bite" and not seq.hookPending then
		return true, "Hook", nil, nil, phase
	elseif phase == "Nibbling" then
		return true, "Waiting", nil, nil, phase
	elseif phase == "Waiting" or phase == "Approaching" or phase == "Holding" then
		return true, "Waiting"
	end
	return true
end

function FishingController:ReportOnboardingPrompt(hint, baitTarget)
	if not session or not session.lesson then
		return
	end
	if baitTarget then
		Analytics.Report(session, "BaitPrompt")
	elseif hint == "Cast" or hint == "FinalCast" then
		Analytics.Report(session, "CastPrompt")
	elseif hint == "Hook" then
		Analytics.Report(session, "HookPrompt")
	elseif hint == "Continue" then
		Analytics.Report(session, "ContinuePrompt")
	end
end

function FishingController:ReturnToSpawn()
	local state = session
	if state and pendingEntry and pendingEntry.preview == state then
		rollbackEntryPresentation(state)
		return
	end
	local sequence = state and state.sequence
	if state and not state.transition and not (sequence and sequence.hookPending) then
		state.caughtOnReturn = sequence ~= nil and sequence.phase == "Caught"
		startTransition(state, "Returning")
	end
end

local function startEntryPresentation(entry)
	local part, character, root, humanoid = entry.part, entry.character, entry.root, entry.humanoid
	local meter = getCastPrompt()
	local characters = ReplicatedStorage:FindFirstChild("Character")
	local template = characters and characters:FindFirstChild("PoseDefaultCharacter")
	local templateRoot = template and template:FindFirstChild("HumanoidRootPart")
	local templateHumanoid = template and template:FindFirstChildOfClass("Humanoid")
	local playerGui = localPlayer:FindFirstChildOfClass("PlayerGui")
	local baitGui = playerGui and playerGui:FindFirstChild("BaitSelectGui")
	local fishingAnimations = ReplicatedStorage:FindFirstChild("Animation")
	fishingAnimations = fishingAnimations and fishingAnimations:FindFirstChild("Fishing")
	local animation = fishingAnimations and fishingAnimations:FindFirstChild("CastRod")
	local specialCastAnimation = fishingAnimations and fishingAnimations:FindFirstChild("SpecialCastRod")
	if not meter or not baitGui or not baitGui:IsA("ScreenGui") then
		warnOnce("Fishing cast prompt or BaitSelectGui is missing")
		return
	end
	if not (template and template:IsA("Model") and templateRoot and templateRoot:IsA("BasePart") and templateHumanoid) then
		warnOnce("PoseDefaultCharacter or its root and humanoid are missing")
		return
	end
	if not (animation and animation:IsA("Animation")) then
		warnOnce("Animation.Fishing.CastRod is missing")
		return
	end
	local camera = Workspace.CurrentCamera
	if not camera then
		return
	end
	local look = part.CFrame.LookVector
	local forward = Vector3.new(look.X, 0, look.Z)
	if forward.Magnitude < 0.001 then
		warnOnce("FishingStartPart must face horizontally")
		return
	end
	local state = {
		character = character,
		root = root,
		humanoid = humanoid,
		saved = {},
		connections = {},
		visibility = FishingVisibility.new(),
		meter = meter,
		service = entry.service,
		camera = {
			cameraType = camera.CameraType,
			subject = camera.CameraSubject,
			fov = camera.FieldOfView,
			cframe = camera.CFrame,
			focus = camera.Focus,
		},
	}
	session = state
	FishingAudio.ClearTails()
	local ok, err = xpcall(function()
		hideSceneUi(state, playerGui)
		state.coverGui = Instance.new("ScreenGui")
		state.coverGui.Name, state.coverGui.DisplayOrder = "FishingTransitionGui", 10000
		state.coverGui.IgnoreGuiInset, state.coverGui.ResetOnSpawn = true, false
		state.cover = Instance.new("Frame")
		state.cover.Name, state.cover.Size = "Cover", UDim2.fromScale(1, 1)
		state.cover.BackgroundColor3, state.cover.BorderSizePixel = Color3.new(0, 0, 0), 0
		state.cover.BackgroundTransparency, state.cover.Active = 1, true
		state.cover.Parent = state.coverGui
		state.coverGui.Parent = playerGui
		GameplayInputGate.SetActive("Fishing", FishingController, true)
		ContextActionService:BindActionAtPriority(MOVEMENT_BINDING, function()
			return Enum.ContextActionResult.Sink
		end, false, Enum.ContextActionPriority.High.Value + 100, unpack(Enum.PlayerActions:GetEnumItems()))
		table.insert(
			state.connections,
			humanoid.Died:Connect(function()
				finish(false)
			end)
		)
		local function prepareConfirmedScene()
			local models = ReplicatedStorage:FindFirstChild("Models")
			local rods = models and models:FindFirstChild("FishRod")
			local rodData = RodsData[entry.rodId]
			local rod = rods and rodData and rods:FindFirstChild(rodData.Model)
			assert(rod and rod:IsA("Tool"), "Equipped rod model is missing")
			state.rig = FishingRigUtil.Create(template, character, rod)
			local rig = state.rig
			local _, _, groundY = FishingRigUtil.PlaceAtFishingSpot(rig, part)
			rig.Parent = Workspace
			local dataController = Knit.GetController("PlayerDataController")
			local function isSoundEnabled()
				local data = dataController:GetData()
				return data ~= nil and data.Settings[Constants.SETTINGS_ID.SOUND] ~= false
			end
			local function fail(message)
				if session == state then
					NotificationClient.RedNotify(message)
					finish(false)
				end
			end
			state.fail = fail
			local function chooseBait(baitId)
				if session ~= state or state.transition or not state.token or state.choosing then
					return
				end
				if state.lesson == "FinalCatch" and baitId ~= "NONE" and baitId ~= state.guideBaitId then
					NotificationClient.RedNotify(FishingOnboarding.GetBaitSelectionHint(BaitsData[state.guideBaitId]))
					return
				end
				local picker = state.baitSelection
				local baitData = BaitsData[baitId]
				local bait, baitModel = FishingAssets.GetBait(if baitData then baitData.Model else nil)
				if not bait then
					if picker then
						NotificationClient.RedNotify("Bait model unavailable")
					else
						fail("Bait model unavailable")
					end
					return
				end
				state.choosing = true
				if picker then
					picker.SetBusy(true)
				end
				local quote = entry.baitQuotes and entry.baitQuotes[baitId]
				local productId = if picker and quote and quote.credits == 0 and not state.awaitingReceiptUntil
					then quote.productId else nil
				local purchaseConnection
				if productId then
					purchaseConnection = MarketplaceService.PromptProductPurchaseFinished:Connect(
						function(userId, finishedProductId, purchased)
							if userId ~= localPlayer.UserId or finishedProductId ~= productId then
								return
							end
							purchaseConnection:Disconnect()
							if session ~= state or state.restored then
								return
							end
							state.choosing = false
							if purchased then
								state.awaitingReceiptUntil = os.clock() + 15
								chooseBait(baitId)
							else
								picker.SetBusy(false)
							end
						end
					)
					table.insert(state.connections, purchaseConnection)
				end
				state.service
					:SelectBait(state.token, baitId, productId ~= nil)
					:andThen(function(result)
						if session ~= state or state.restored or result.prompted then
							return
						end
						if purchaseConnection then
							purchaseConnection:Disconnect()
						end
						if not result.ok then
							if not picker then
								fail(result.message)
								return
							end
							if result.needsPurchase and state.awaitingReceiptUntil then
								if os.clock() < state.awaitingReceiptUntil then
									task.delay(0.5, function()
										if session == state and not state.restored then
											state.choosing = false
											chooseBait(baitId)
										end
									end)
									return
								end
								state.awaitingReceiptUntil = nil
								result.message = "Purchase is processing. Select this bait again shortly."
							end
							state.choosing = false
							picker.SetBusy(false)
							NotificationClient.RedNotify(result.message)
							return
						end
						if state.lesson and not result.lesson then
							localPlayer:SetAttribute(FishingOnboarding.LessonActiveAttribute, false)
						end
						state.lesson = result.lesson
						state.awaitingReceiptUntil = nil
						if picker then
							picker.Destroy()
							state.baitSelection = nil
						end
						state.audio = FishingAudio.new(isSoundEnabled)
						state.sequence = FishingCastSequence.new(rig, playerGui, meter, animation, baitModel or bait, {
							specialCastAnimation = specialCastAnimation,
							tutorial = state.lesson ~= nil,
							onEarlyHook = function()
								state.earlyUntil = os.clock() + 1.3
								if state.lesson then
									Analytics.Report(state, "EarlyHook")
								end
							end,
							playBaitAppear = baitData ~= nil,
							isSoundEnabled = isSoundEnabled,
							audio = state.audio,
							initialYaw = result.initialYaw,
							initialLuck = result.luck,
							fixedCast = true,
							castGroundY = groundY,
							meterStartsAt = result.meterStartsAt,
							launchPosition = part.Position,
							resolveFish = function(fishId)
								local fish = FishesData[fishId]
								return fish, fish and FishingAssets.GetFish(fish.Model)
							end,
							resolveCatch = function(kind, id)
								local config = if kind == "Egg" then EggsData[id] else FishesData[id]
								return config,
									config and (if kind == "Egg"
										then FishingAssets.GetEgg(config.Model)
										else FishingAssets.GetFish(config.Model))
							end,
							requestRound = function(previousRound)
								return state.service:NextRound(state.token, previousRound)
							end,
								hook = function(round, pressedAt)
									return state.service:Hook(state.token, round, pressedAt)
							end,
							getHookResult = function(round)
							return state.service:GetHookResult(state.token, round)
						end,
						cancel = function(emptyReelRound)
								cancelServerSession(state, false, emptyReelRound)
							end,
							onFailure = fail,
						})
						ContextActionService:BindActionAtPriority(CONFIRM_BINDING, function(_, inputState, input)
							if session ~= state or GameplayInputGate.IsUiBlockingWorld() or GuiService.SelectedObject then
								return Enum.ContextActionResult.Pass
							end
							if inputState == Enum.UserInputState.Begin then
								FishingController:HandleFishingInput(input, false, true)
							end
							return Enum.ContextActionResult.Sink
						end, false, Enum.ContextActionPriority.High.Value + 120, Enum.KeyCode.ButtonA)
					end)
					:catch(function(purchaseError)
						if session == state then
							warnOnce(tostring(purchaseError))
							if purchaseConnection then
								if purchaseConnection.Connected then
									purchaseConnection:Disconnect()
									state.choosing = false
									picker.SetBusy(false)
									NotificationClient.RedNotify("Could not open the bait purchase.")
								end
								return
							end
							fail("Could not start fishing")
						end
					end)
			end
			local leaderstats = localPlayer:FindFirstChild("leaderstats")
			local cash = leaderstats and leaderstats:FindFirstChild("💵Cash")
			local function closeBaitSelection()
				if not state.choosing then
					FishingController:ReturnToSpawn()
				end
			end
			state.baitSelection = FishingBaitSelect.Bind(
				baitGui,
				rodData,
				BaitsData,
				chooseBait,
				closeBaitSelection,
				entry.baitQuotes,
				entry.lesson == "FinalCatch",
				if cash and cash:IsA("NumberValue") then cash else nil,
				if entry.lesson == "FinalCatch" then entry.guideBaitId else nil
			)
			local cashHome = bindBaitCash(state, playerGui, baitGui)
			-- 真实角色留在进入处，演出角色独立居中，避免多人在中心发生物理挤压。
			for _, player in ipairs(Players:GetPlayers()) do
				hidePlayer(state, player)
			end
			table.insert(
				state.connections,
				Players.PlayerAdded:Connect(function(player)
					if session == state and not state.restored then
						hidePlayer(state, player)
					end
				end)
			)
			local function hideGui(gui)
				if
					gui:IsA("ScreenGui")
					and gui ~= meter.gui
					and gui.Name ~= "FishingSequenceGui"
					and gui.Name ~= "FishingVignetteGui"
					and gui.Name ~= "FishingOnboardingGui"
					and gui.Name ~= "NotificationGui"
					and gui ~= baitGui
					and gui ~= cashHome
					and gui ~= state.coverGui
				then
					hold(state, gui, "Enabled", false)
				end
			end
			for _, gui in ipairs(playerGui:GetChildren()) do
				hideGui(gui)
			end
			table.insert(state.connections, playerGui.ChildAdded:Connect(hideGui))
			hold(state, ProximityPromptService, "Enabled", false)
			local success, enabled = pcall(function()
				return StarterGui:GetCoreGuiEnabled(Enum.CoreGuiType.Backpack)
			end)
			if success then
				state.backpackEnabled = enabled
			end
			pcall(function()
				StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Backpack, false)
			end)
			state.fishingMusic = true
			Knit.GetController("MusicController"):SetFishingActive(true)
			state.onReady = state.baitSelection.Show
		end
		state.prepare = function()
			local target = FishingRigUtil.GetSpotRootCFrame(part, templateRoot, templateHumanoid)
			local behindFocus = target.Position + target.LookVector * 14 + Vector3.new(0, 0.5, 0)
			state.camera.changed = true
			camera.CameraType = Enum.CameraType.Scriptable
			camera.CFrame = CFrame.lookAt(target:PointToWorldSpace(Vector3.new(3.2, 2.4, 7.5)), behindFocus)
			camera.Focus, camera.FieldOfView = CFrame.new(behindFocus), 62
			if state.token then
				prepareConfirmedScene()
			end
		end
		state.confirm = function()
			state.token, entry.token = entry.token, nil
			state.lesson, state.guideBaitId, state.eventFish = entry.lesson, entry.guideBaitId, entry.eventFish
			if state.lesson then
				localPlayer:SetAttribute(FishingOnboarding.LessonActiveAttribute, true)
			end
			state.footHeight = FishingSpotUtil.GetFootHeight(root, humanoid)
			state.originalRootCFrame = root.CFrame
			remember(state, root, "Anchored", true)
			remember(state, humanoid, "AutoRotate", false)
			root.AssemblyLinearVelocity, root.AssemblyAngularVelocity = Vector3.zero, Vector3.zero
			if state.camera.changed then
				prepareConfirmedScene()
			end
		end
		startTransition(state, "Entering")
		RunService:BindToRenderStep(CAMERA_BINDING, Enum.RenderPriority.Camera.Value + 2, function(dt)
			if session ~= state then
				return
			end
			local updated, updateError = pcall(function()
				assert(state.coverGui.Parent and state.cover.Parent, "Fishing transition disappeared")
				local now = os.clock()
				updateTransition(state, now)
				if session ~= state or state.restored or not state.sequence then
					return
				end
				assert(
					state.rig.Parent
						and root.Parent
						and meter.gui.Parent
						and meter.holder:IsDescendantOf(meter.gui)
						and meter.bar:IsDescendantOf(meter.gui)
						and meter.marker:IsDescendantOf(meter.gui)
						and meter.prompt:IsDescendantOf(meter.gui),
					"Fishing cast prompt or rig disappeared"
				)
				state.sequence:Update(now, dt)
				if state.lesson then
					meter.prompt.Visible = false
					state.sequence.continueLabel.Visible = false
					Analytics.ObserveSequence(state)
				end
				if not state.transition and state.sequence.phase == "Reeled" and state.sequence:CanReturn(now) then
					FishingController:ReturnToSpawn()
				end
			end)
			if not updated then
				warnOnce(tostring(updateError))
				rollbackEntryPresentation(state)
			end
		end)
	end, debug.traceback)
	if not ok then
		warnOnce(tostring(err))
		finish(false)
		return
	end
	return state
end

local function clearEntry(entry)
	if pendingEntry == entry then
		pendingEntry = nil
		if entry.onComplete then
			entry.onComplete(entry.started == true)
		end
	end
end

local function releaseEntry(entry)
	local cancellation = cancelServerSession(entry)
	if cancellation then
		-- Finish cancelling a late token before allowing another Begin.
		entry.inFlight = true
		cancellation:andThen(function()
			clearEntry(entry)
		end)
	else
		clearEntry(entry)
	end
end

local function abandonEntry(entry, message: string?)
	if not entry.abandoned then
		entry.abandoned = true
		if entry.preview and session == entry.preview then
			rollbackEntryPresentation(entry.preview)
		end
		if message then
			NotificationClient.RedNotify(message)
		end
	end
	if not entry.inFlight then
		releaseEntry(entry)
	end
end

local function canKeepEntry(entry): boolean
	local character = localPlayer.Character
	local allowed = if entry.eventSlotId ~= nil
		then GameplayInputGate.IsPlacementActionAllowed()
		else entry.preview ~= nil and session == entry.preview and not entry.preview.restored
			and not GameplayInputGate.IsUiBlockingWorld()
	return character == entry.character
		and character:FindFirstChild("HumanoidRootPart") == entry.root
		and character:FindFirstChildOfClass("Humanoid") == entry.humanoid
		and entry.humanoid.Health > 0
		and not entry.root.Anchored
		and FishingSpotUtil.GetStartPart(getOwnPlot()) == entry.part
		and (entry.eventSlotId ~= nil or FishingSpotUtil.Contains(entry.part, entry.root))
		and allowed
end

local function entryInterruption(entry): string?
	if entry.eventSlotId ~= nil and FishingSpotUtil.GetStartPart(getOwnPlot()) ~= entry.part then
		return "Your fishing spot is unavailable."
	end
	return nil
end

local function completeEntry(entry)
	if entry.eventSlotId ~= nil and not FishingSpotUtil.Contains(entry.part, entry.root) then
		return -- The teleport and the response can replicate in either order.
	end
	mustLeaveArea = true
	local state = entry.preview or startEntryPresentation(entry)
	if state and session == state then
		local ok, err = xpcall(state.confirm, debug.traceback)
		if not ok then
			warnOnce(tostring(err))
			rollbackEntryPresentation(state)
		end
		entry.started = session == state and not state.restored
	end
	if entry.onComplete and not entry.started then
		NotificationClient.RedNotify("Could not start fishing.")
	end
	releaseEntry(entry)
end

local function updateEntry(entry, now: number)
	if entry.abandoned then
		return
	end
	if now >= entry.deadline then
		abandonEntry(entry, entry.lastMessage or "Could not start fishing")
		return
	end
	if entry.token then
		completeEntry(entry)
		return
	end
	if entry.inFlight or now < entry.nextAttemptAt then
		return
	end

	entry.inFlight = true
	entry.nextAttemptAt = now + ENTRY_RETRY_SECONDS
	local request = if entry.eventSlotId ~= nil then entry.service:JoinEvent(entry.eventSlotId) else entry.service:Begin()
	request:andThen(function(result)
		entry.inFlight = false
		if result.ok then
			entry.token = result.token
			entry.rodId = result.rodId
			entry.baitQuotes = result.baitQuotes
			entry.lesson = result.lesson
			entry.guideBaitId = result.guideBaitId
			entry.eventFish = result.eventFish
		end
		if entry.abandoned or not canKeepEntry(entry) then
			abandonEntry(entry, entryInterruption(entry))
			return
		end
		if os.clock() >= entry.deadline then
			abandonEntry(entry, entry.lastMessage or "Could not start fishing")
			return
		end
		if result.ok then
			completeEntry(entry)
		elseif entry.eventSlotId == nil and (result.code == "ProfileNotReady" or result.code == "OutsideFishingSpot") then
			-- The server can briefly lag behind the locally controlled character.
			entry.lastMessage = result.message
		else
			abandonEntry(entry, result.message)
		end
	end):catch(function()
		entry.inFlight = false
		local message = if canKeepEntry(entry) then "Could not start fishing" else nil
		abandonEntry(entry, message)
	end)
end

function FishingController:JoinEvent(slotId: number, onComplete: (boolean) -> ()): (boolean, string?)
	if session or pendingEntry or not GameplayInputGate.IsPlacementActionAllowed()
		or localPlayer:GetAttribute(LoadingAttributes.LOADING_SCREEN_DONE) ~= true
	then
		return false
	end
	local character = localPlayer.Character
	local root = character and character:FindFirstChild("HumanoidRootPart")
	local humanoid = character and character:FindFirstChildOfClass("Humanoid")
	local part = FishingSpotUtil.GetStartPart(getOwnPlot())
	if not part then
		return false, "Your fishing spot is unavailable."
	end
	if not root or not root:IsA("BasePart") or root.Anchored or not humanoid or humanoid.Health <= 0 then
		return false
	end

	local now = os.clock()
	local entry = {
		part = part,
		character = character,
		root = root,
		humanoid = humanoid,
		service = Knit.GetService("FishingService"),
		eventSlotId = slotId,
		onComplete = onComplete,
		deadline = now + EVENT_ENTRY_TIMEOUT_SECONDS,
		nextAttemptAt = now,
	}
	pendingEntry = entry
	updateEntry(entry, now)
	return true
end

function FishingController:KnitInit()
	FishingAudio.PreloadLuckSounds()
	local gui = localPlayer:FindFirstChildOfClass("PlayerGui")
	local baitGui = gui and gui:FindFirstChild("BaitSelectGui")
	if baitGui and baitGui:IsA("ScreenGui") then
		baitGui.Enabled = false
	end
	local meter = gui and gui:FindFirstChild("CastMeterGui")
	if meter and meter:IsA("ScreenGui") then
		meter.Enabled = false
	end
	local sequenceGui = gui and gui:FindFirstChild("FishingSequenceGui")
	if sequenceGui and sequenceGui:IsA("ScreenGui") then
		sequenceGui.Enabled = false
	end
	local vignetteGui = gui and gui:FindFirstChild("FishingVignetteGui")
	if vignetteGui and vignetteGui:IsA("ScreenGui") then
		vignetteGui.Enabled = false
	end
end

function FishingController:HandleFishingInput(input, processed, fromGamepad)
	local state = session
	if
		not state
		or state.transition
		or not state.sequence
		or state.castPending
		or not state.readyAt
		or os.clock() < state.readyAt
		or processed
		or GameplayInputGate.IsUiBlockingWorld()
	then
		return
	end
	if
		input.UserInputType == Enum.UserInputType.MouseButton1
		or input.UserInputType == Enum.UserInputType.Touch
		or fromGamepad
	then
		-- 可交互 UI 即使未将输入标为 processed，也不能当成场景点击。
		local playerGui = localPlayer:FindFirstChildOfClass("PlayerGui")
		if not fromGamepad then
			for _, gui in ipairs(playerGui:GetGuiObjectsAtPosition(input.Position.X, input.Position.Y)) do
				if gui:IsA("GuiButton") or gui:IsA("TextBox") or gui.Active then
					return
				end
			end
		end
		local sequence = state.sequence
		local now = os.clock()
		if sequence.phase == "Preparing" then
			if Workspace:GetServerTimeNow() < sequence.options.meterStartsAt then
				return
			end
			state.castPending = true
			sequence:BeginCast(now)
			state.service:Cast(state.token):timeout(Config.CastConfirmationTimeout):andThen(function(result)
				if session ~= state or state.restored or state.transition then
					return
				end
				state.castPending = false
				if result.ok then
					sequence:Cast(result.castProgress, result.distance, result.luck, result.castRating)
				else
					state.fail(result.message)
				end
			end):catch(function()
				if session == state and not state.restored and not state.transition then
					state.fail("Could not confirm the cast.")
				end
			end)
		elseif sequence.phase == "Reeling" or sequence.phase == "Reeled" then
			return
		elseif sequence:CanReturn(now) then
			self:ReturnToSpawn()
		else
			sequence:TryHook(now)
			if sequence:CanReturn(now) then
				self:ReturnToSpawn()
			end
		end
	end
end

function FishingController:KnitStart()
	local paidBait = PurchaseData[BaitConfig.PurchaseId]
	if paidBait then
		FishingBaitSelect.WarmProductPrice(paidBait.ProductId)
	end
	Knit.GetController("SettingsGuiController").ToggleSound:Connect(function()
		FishingAudio.RefreshTails()
		if session and not session.restored and session.sequence then
			session.sequence:RefreshSoundSetting()
		end
	end)
	localPlayer.CharacterRemoving:Connect(function()
		if pendingEntry then
			mustLeaveArea = false
			abandonEntry(pendingEntry)
		end
		finish(false)
	end)
	UserInputService.InputBegan:Connect(function(input, processed)
		self:HandleFishingInput(input, processed)
	end)
	RunService.Heartbeat:Connect(function()
		local character = localPlayer.Character
		local humanoid = character and character:FindFirstChildOfClass("Humanoid")
		local root = character and character:FindFirstChild("HumanoidRootPart")
		if session and (not pendingEntry or session ~= pendingEntry.preview) then
			if
				character ~= session.character
				or not root
				or not humanoid
				or humanoid.Health <= 0
				or (not session.restored and (root.Position - session.originalRootCFrame.Position).Magnitude > ACTIVE_DISPLACEMENT_LIMIT)
			then
				finish(false)
			end
			return
		end
		local alive = root and root:IsA("BasePart") and humanoid and humanoid.Health > 0
		local part = if alive then FishingSpotUtil.GetStartPart(getOwnPlot()) else nil
		local inside = part ~= nil and FishingSpotUtil.Contains(part, root)
		if not inside then
			mustLeaveArea = false
		end
		if pendingEntry then
			if not canKeepEntry(pendingEntry) then
				abandonEntry(pendingEntry, entryInterruption(pendingEntry))
			else
				updateEntry(pendingEntry, os.clock())
			end
			return
		end
		if not alive then
			FishingAudio.ClearTails()
			return
		end
		if not part then
			return
		end
		if
			not inside
			or mustLeaveArea
			or root.Anchored
			or localPlayer:GetAttribute(LoadingAttributes.LOADING_SCREEN_DONE) ~= true
			or not GameplayInputGate.IsWorldActionAllowed()
		then
			return
		end
		mustLeaveArea = true
		local now = os.clock()
		local entry = {
			part = part,
			character = character,
			root = root,
			humanoid = humanoid,
			service = Knit.GetService("FishingService"),
			deadline = now + ENTRY_TIMEOUT_SECONDS,
			nextAttemptAt = now,
		}
		pendingEntry = entry
		entry.preview = startEntryPresentation(entry)
		if entry.preview then
			updateEntry(entry, now)
		else
			clearEntry(entry)
		end
	end)
end

return FishingController
