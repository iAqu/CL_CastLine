local MarketplaceService = game:GetService("MarketplaceService")
local ContextActionService = game:GetService("ContextActionService")
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
local FishingCastSequence = require(ReplicatedStorage.Modules.FishingCastSequence)
local FishingAudio = require(ReplicatedStorage.Modules.FishingAudio)
local FishingOnboarding = require(ReplicatedStorage.Modules.FishingOnboarding)
local Config = require(ReplicatedStorage.Modules.FishingConfig)
local FishingAssets = require(ReplicatedStorage.Modules.FishingAssets)
local FishingBaitSelect = require(ReplicatedStorage.Modules.FishingBaitSelect)
local FishingSpotUtil = require(ReplicatedStorage.Modules.FishingSpotUtil)
local PlotWorkspaceUtil = require(ReplicatedStorage.Modules.PlotWorkspaceUtil)
local NotificationClient = require(ReplicatedStorage.Modules.NotificationClient)
local Constants = require(ReplicatedStorage.Modules.Constants)
local GameplayInputGate = require(ReplicatedStorage.Modules.GameplayInputGate)
local LoadingAttributes = require(ReplicatedFirst.LoadingAttributes)

local fishingData = ReplicatedFirst:WaitForChild("Data")
local RodsData = require(fishingData:WaitForChild("RodsData"))
local BaitsData = require(fishingData:WaitForChild("BaitsData"))
local FishesData = require(fishingData:WaitForChild("FishesData"))
local PetFeatureConfig = require(ReplicatedStorage.Modules.PetFeatureConfig)
local EggsData = if PetFeatureConfig.Enabled then require(fishingData:WaitForChild("EggsData")) else {}

local localPlayer = Players.LocalPlayer
local CAMERA_BINDING = "CastLineFishingCamera"
local LESSON_CONFIRM_BINDING = "FishingLessonConfirm"
local MOVEMENT_BINDING = "CastLineFishingMovement"
local ENTRY_RETRY_SECONDS = 0.1
local ENTRY_TIMEOUT_SECONDS = 1
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

local function hideSceneBillboards(state, playerGui: PlayerGui)
	local function hideBillboard(instance: Instance)
		if
			session == state
			and not state.restored
			and instance:IsA("BillboardGui")
			and instance:GetAttribute("FishingBillboardExempt") ~= true
		then
			hold(state, instance, "Enabled", false)
		end
	end
	for _, container in ipairs({ Workspace, playerGui }) do
		table.insert(state.connections, container.DescendantAdded:Connect(hideBillboard))
		for _, descendant in ipairs(container:GetDescendants()) do
			hideBillboard(descendant)
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

local function hideDescendant(state, instance: Instance)
	if instance:IsA("BasePart") then
		hold(state, instance, "LocalTransparencyModifier", 1)
	elseif instance:IsA("Decal") then
		hold(state, instance, "Transparency", 1)
	elseif
		instance:IsA("BillboardGui")
		or instance:IsA("SurfaceGui")
		or instance:IsA("ParticleEmitter")
		or instance:IsA("Trail")
		or instance:IsA("Beam")
	then
		hold(state, instance, "Enabled", false)
	end
end

local function hideCharacter(state, character: Model)
	for _, descendant in ipairs(character:GetDescendants()) do
		hideDescendant(state, descendant)
	end
	table.insert(
		state.connections,
		character.DescendantAdded:Connect(function(descendant)
			if session == state then
				hideDescendant(state, descendant)
			end
		end)
	)
end

local function hidePlayer(state, player: Player)
	if player.Character then
		hideCharacter(state, player.Character)
	end
	if player ~= localPlayer then
		table.insert(
			state.connections,
			player.CharacterAdded:Connect(function(character)
				if session == state then
					hideCharacter(state, character)
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

local function cancelServerSession(state, finished)
	if state.token then
		local token = state.token
		state.token = nil
		return state.service:Cancel(token, finished == true):catch(function() end)
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
	Knit.GetController("MusicController"):SetFishingActive(false)
	for _, connection in ipairs(state.connections) do
		connection:Disconnect()
	end
	if state.sequence then
		state.sequence:Destroy(returnToSpawn)
	elseif state.audio then
		state.audio:Destroy(false)
	end
	if state.rig then
		state.rig:Destroy()
	end
	if state.character.Parent and state.root.Parent and localPlayer.Character == state.character then
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
	if state.camera then
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
			camera.CameraType = Enum.CameraType.Custom
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
	mustLeaveArea = true
	RunService:UnbindFromRenderStep(CAMERA_BINDING)
	ContextActionService:UnbindAction(MOVEMENT_BINDING)
	if state.lesson then
		ContextActionService:UnbindAction(LESSON_CONFIRM_BINDING)
	end
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
				state.prepare()
				state.prepare = nil
			else
				restore(state, true)
			end
			transition.revealedAt = now
		end
	else
		local alpha = math.clamp((now - transition.revealedAt) / timing.Reveal, 0, 1)
		state.cover.BackgroundTransparency = alpha
		if alpha == 1 then
			state.transition = nil
			state.coverGui.Enabled = false
			if state.restored then
				finish(false, true)
			else
				state.readyAt = now
				local onReady = state.onReady
				state.onReady = nil
				onReady()
			end
		end
	end
end

function FishingController:IsPreparing(): boolean
	return session ~= nil
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
		return true, if state.lesson == "FirstCatch" then "Cast" else "FinalCast"
	elseif phase == "Caught" and seq:CanReturn(now) then
		return true, "Continue"
	elseif state.earlyUntil and now < state.earlyUntil then
		return true, "Retry"
	elseif phase == "Bite" and not seq.hookPendingAt then
		return true, "Hook", nil, nil, phase
	elseif phase == "Nibbling" then
		return true, "Waiting", nil, nil, phase
	elseif phase == "Waiting" or phase == "Approaching" or phase == "Holding" then
		return true, "Waiting"
	end
	return true
end

function FishingController:ReturnToSpawn()
	if session and not session.transition then
		session.caughtOnReturn = session.sequence ~= nil and session.sequence.phase == "Caught"
		startTransition(session, "Returning")
	end
end

local function begin(entry)
	local part, character, root, humanoid = entry.part, entry.character, entry.root, entry.humanoid
	local meter = getCastPrompt()
	local characters = ReplicatedStorage:FindFirstChild("Character")
	local template = characters and characters:FindFirstChild("PoseDefaultCharacter")
	local models = ReplicatedStorage:FindFirstChild("Models")
	local rods = models and models:FindFirstChild("FishRod")
	local rodData = RodsData[entry.rodId]
	local rod = rods and rodData and rods:FindFirstChild(rodData.Model)
	local playerGui = localPlayer:FindFirstChildOfClass("PlayerGui")
	local autoSelect = entry.lesson == "FirstCatch"
	local baitGui = if not autoSelect and playerGui then playerGui:FindFirstChild("BaitSelectGui") else nil
	local fishingAnimations = ReplicatedStorage:FindFirstChild("Animation")
	fishingAnimations = fishingAnimations and fishingAnimations:FindFirstChild("Fishing")
	local animation = fishingAnimations and fishingAnimations:FindFirstChild("CastRod")
	local specialCastAnimation = fishingAnimations and fishingAnimations:FindFirstChild("SpecialCastRod")
	if not meter or not playerGui or (not autoSelect and not (baitGui and baitGui:IsA("ScreenGui"))) then
		warnOnce("Fishing cast prompt or BaitSelectGui is missing")
		return
	end
	if not (template and template:IsA("Model") and rod and rod:IsA("Tool")) then
		warnOnce("PoseDefaultCharacter or equipped rod model is missing")
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
		originalRootCFrame = root.CFrame,
		footHeight = FishingSpotUtil.GetFootHeight(root, humanoid),
		saved = {},
		connections = {},
		meter = meter,
		service = entry.service,
		token = entry.token,
		lesson = entry.lesson,
		guideBaitId = entry.guideBaitId,
		camera = {
			subject = camera.CameraSubject,
			fov = camera.FieldOfView,
			cframe = camera.CFrame,
			focus = camera.Focus,
		},
	}
	entry.token = nil
	session = state
	if state.lesson then
		localPlayer:SetAttribute(FishingOnboarding.LessonActiveAttribute, true)
	end
	FishingAudio.ClearTails()
	local ok, err = xpcall(function()
		hideSceneBillboards(state, playerGui)
		state.coverGui = Instance.new("ScreenGui")
		state.coverGui.Name, state.coverGui.DisplayOrder = "FishingTransitionGui", 10000
		state.coverGui.IgnoreGuiInset, state.coverGui.ResetOnSpawn = true, false
		state.cover = Instance.new("Frame")
		state.cover.Name, state.cover.Size = "Cover", UDim2.fromScale(1, 1)
		state.cover.BackgroundColor3, state.cover.BorderSizePixel = Color3.new(0, 0, 0), 0
		state.cover.BackgroundTransparency, state.cover.Active = 1, true
		state.cover.Parent = state.coverGui
		state.coverGui.Parent = playerGui
		remember(state, root, "Anchored", true)
		remember(state, humanoid, "AutoRotate", false)
		root.AssemblyLinearVelocity, root.AssemblyAngularVelocity = Vector3.zero, Vector3.zero
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
		state.prepare = function()
			state.rig = FishingRigUtil.Create(template, character, rod)
			local rig = state.rig
			local rigRoot = rig.PrimaryPart
			local rigHumanoid = rig:FindFirstChildOfClass("Humanoid")
			local ground = part.Position + part.CFrame.UpVector * part.Size.Y / 2
			local position = ground + Vector3.new(0, rigHumanoid.HipHeight + rigRoot.Size.Y / 2, 0)
			rig:PivotTo(CFrame.lookAt(position, position + forward))
			rig.Parent = Workspace
			local dataController = Knit.GetController("PlayerDataController")
			local function isSoundEnabled()
				local data = dataController:GetData()
				return data ~= nil and data.Settings[Constants.SETTINGS_ID.SOUND] ~= false
			end
			local behindFocus = position + rigRoot.CFrame.LookVector * 14 + Vector3.new(0, 0.5, 0)
			camera.CameraType = Enum.CameraType.Scriptable
			camera.CFrame = CFrame.lookAt(rigRoot.CFrame:PointToWorldSpace(Vector3.new(3.2, 2.4, 7.5)), behindFocus)
			camera.Focus, camera.FieldOfView = CFrame.new(behindFocus), 62

			local function fail(message)
				if session == state then
					NotificationClient.RedNotify(message)
					finish(false)
				end
			end
			state.fail = fail
			local function chooseBait(baitId)
				if session ~= state or not state.token or state.choosing then
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
				state.service
					:SelectBait(state.token, baitId)
					:andThen(function(result)
						if session ~= state or state.restored then
							return
						end
						if not result.ok then
							if not picker then
								fail(result.message)
								return
							end
							if result.needsPurchase and result.productId and not state.buyingBait then
								state.buyingBait = true
								local purchaseConnection
								purchaseConnection = MarketplaceService.PromptProductPurchaseFinished:Connect(
									function(userId, productId, purchased)
										if userId ~= localPlayer.UserId or productId ~= result.productId then
											return
										end
										purchaseConnection:Disconnect()
										state.buyingBait = false
										if session ~= state or state.restored then
											return
										end
										state.choosing = false
										picker.SetBusy(false)
										if purchased then
											-- The purchase UI is not proof of payment; SelectBait checks server receipt credits.
											state.awaitingReceiptUntil = os.clock() + 15
											chooseBait(baitId)
										end
									end
								)
								table.insert(state.connections, purchaseConnection)
								if state.awaitingReceiptUntil then
									purchaseConnection:Disconnect()
									state.buyingBait, state.choosing = false, false
									if os.clock() < state.awaitingReceiptUntil then
										task.delay(0.5, function()
											if session == state and not state.restored then
												chooseBait(baitId)
											end
										end)
									else
										state.awaitingReceiptUntil = nil
										picker.SetBusy(false)
										NotificationClient.RedNotify(
											"Purchase is processing. Select this bait again shortly."
										)
									end
								else
									local prompted, promptError = pcall(
										MarketplaceService.PromptProductPurchase,
										MarketplaceService,
										localPlayer,
										result.productId
									)
									if not prompted then
										purchaseConnection:Disconnect()
										state.buyingBait, state.choosing = false, false
										picker.SetBusy(false)
										NotificationClient.RedNotify(tostring(promptError))
									end
								end
								return
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
							end,
							playBaitAppear = baitData ~= nil,
							isSoundEnabled = isSoundEnabled,
							audio = state.audio,
							initialYaw = result.initialYaw,
							initialLuck = result.luck,
							fixedCast = true,
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
							cancel = function()
								cancelServerSession(state)
							end,
							onFailure = fail,
						})
						if state.lesson then
							ContextActionService:BindActionAtPriority(LESSON_CONFIRM_BINDING, function(_, inputState, input)
								if inputState == Enum.UserInputState.Begin then
									FishingController:HandleFishingInput(input, false, true)
								end
								return Enum.ContextActionResult.Sink
							end, false, Enum.ContextActionPriority.High.Value + 120, Enum.KeyCode.ButtonA)
						end
					end)
					:catch(function(purchaseError)
						if session == state then
							warnOnce(tostring(purchaseError))
							fail("Could not start fishing")
						end
					end)
			end
			local cashHome
			if baitGui then
				state.baitSelection = FishingBaitSelect.Bind(baitGui, rodData, BaitsData, chooseBait, function()
					if not state.choosing then
						FishingController:ReturnToSpawn()
					end
				end, entry.baitQuotes, entry.lesson == "FinalCatch")
				cashHome = bindBaitCash(state, playerGui, baitGui)
				state.onReady = state.baitSelection.Show
			else
				state.onReady = function()
					chooseBait("NONE")
				end
			end
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
			Knit.GetController("MusicController"):SetFishingActive(true)
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
				end
				if not state.transition and state.sequence.phase == "Reeled" and state.sequence:CanReturn(now) then
					FishingController:ReturnToSpawn()
				end
			end)
			if not updated then
				warnOnce(tostring(updateError))
				finish(false)
			end
		end)
	end, debug.traceback)
	if not ok then
		warnOnce(tostring(err))
		finish(false)
	end
end

local function clearEntry(entry)
	if pendingEntry == entry then
		pendingEntry = nil
	end
end

local function abandonEntry(entry, message: string?)
	if not entry.abandoned then
		entry.abandoned = true
		if message then
			NotificationClient.RedNotify(message)
		end
	end
	if not entry.inFlight then
		clearEntry(entry)
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

local function canCompleteEntry(entry): boolean
	local character = localPlayer.Character
	return character == entry.character
		and character:FindFirstChild("HumanoidRootPart") == entry.root
		and character:FindFirstChildOfClass("Humanoid") == entry.humanoid
		and entry.humanoid.Health > 0
		and not entry.root.Anchored
		and FishingSpotUtil.GetStartPart(getOwnPlot()) == entry.part
		and FishingSpotUtil.Contains(entry.part, entry.root, entry.humanoid)
		and GameplayInputGate.IsWorldActionAllowed()
end

local function updateEntry(entry, now: number)
	if entry.abandoned then
		return
	end
	if now >= entry.deadline then
		abandonEntry(entry, entry.lastMessage or "Could not start fishing")
		return
	end
	if entry.inFlight or now < entry.nextAttemptAt then
		return
	end

	entry.inFlight = true
	entry.nextAttemptAt = now + ENTRY_RETRY_SECONDS
	entry.service:Begin():andThen(function(result)
		entry.inFlight = false
		if result.ok then
			entry.token = result.token
			entry.rodId = result.rodId
			entry.baitQuotes = result.baitQuotes
			entry.lesson = result.lesson
			entry.guideBaitId = result.guideBaitId
		end
		if entry.abandoned or not canCompleteEntry(entry) then
			entry.abandoned = true
			releaseEntry(entry)
			return
		end
		if os.clock() >= entry.deadline then
			-- Retain the pending entry until a late successful reply is cancelled.
			entry.inFlight = entry.token ~= nil
			abandonEntry(entry, entry.lastMessage or "Could not start fishing")
			releaseEntry(entry)
			return
		end
		if result.ok then
			begin(entry)
			releaseEntry(entry)
		elseif result.code == "ProfileNotReady" or result.code == "OutsideFishingSpot" then
			-- The server can briefly lag behind the locally controlled character.
			entry.lastMessage = result.message
		else
			abandonEntry(entry, result.message)
		end
	end):catch(function()
		entry.inFlight = entry.token ~= nil
		local message = if canCompleteEntry(entry) then "Could not start fishing" else nil
		abandonEntry(entry, message)
		releaseEntry(entry)
	end)
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
			if state.castPending then
				return
			end
			state.castPending = true
			local progress = sequence:LockCastMeter()
			state.service:Cast(state.token, progress):andThen(function(result)
				if session ~= state or state.restored or state.transition then
					return
				end
				state.castPending = false
				if result.ok then
					sequence:Cast(progress, result.distance, result.luck, result.castRating)
				else
					state.fail(result.message)
				end
			end):catch(function()
				state.fail("Could not cast")
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
		if session then
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
		local inside = part ~= nil and FishingSpotUtil.Contains(part, root, humanoid)
		if not inside then
			mustLeaveArea = false
		end
		if pendingEntry then
			if not canCompleteEntry(pendingEntry) then
				abandonEntry(pendingEntry)
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
		updateEntry(entry, now)
	end)
end

return FishingController
