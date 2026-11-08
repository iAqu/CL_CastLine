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
local Config = require(ReplicatedStorage.Modules.FishingConfig)
local Constants = require(ReplicatedStorage.Modules.Constants)
local GameplayInputGate = require(ReplicatedStorage.Modules.GameplayInputGate)
local LoadingAttributes = require(ReplicatedFirst.LoadingAttributes)

local localPlayer = Players.LocalPlayer
local CAMERA_BINDING = "CastLineFishingCamera"
local MOVEMENT_BINDING = "CastLineFishingMovement"
local FishingController = Knit.CreateController({ Name = "FishingController" })
local session = nil
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

local function getStartPart(): BasePart?
	local areas = Workspace:FindFirstChild("Areas")
	local part = areas and areas:FindFirstChild("CastStartPart")
	return if part and part:IsA("BasePart") then part else nil
end

local function isInside(part: BasePart, root: BasePart, humanoid: Humanoid): boolean
	-- 触发区是薄地板，不能用 HRP 是否位于 Part 体积内判断。
	local feet = root.Position - Vector3.new(0, humanoid.HipHeight + root.Size.Y / 2, 0)
	if humanoid.RigType == Enum.HumanoidRigType.R6 then
		local leg = root.Parent:FindFirstChild("Left Leg")
		if leg and leg:IsA("BasePart") then
			feet -= Vector3.new(0, leg.Size.Y, 0)
		end
	end
	local point = part.CFrame:PointToObjectSpace(feet)
	return math.abs(point.X) <= part.Size.X / 2
		and math.abs(point.Z) <= part.Size.Z / 2
		and math.abs(point.Y - part.Size.Y / 2) <= 2.5
end

local function getMeter()
	local playerGui = localPlayer:FindFirstChildOfClass("PlayerGui")
	local gui = playerGui and playerGui:FindFirstChild("CastMeterGui")
	local meter = gui and gui:FindFirstChild("Meter")
	local bar = meter and meter:FindFirstChild("Bar")
	local marker = bar and bar:FindFirstChild("Marker")
	local label = marker and marker:FindFirstChild("MultLabel")
	local prompt = meter and meter:FindFirstChild("Prompt")
	local scale = prompt and prompt:FindFirstChildOfClass("UIScale")
	local glow = marker and marker:FindFirstChild("Glow")
	if
		not (
			gui
			and gui:IsA("ScreenGui")
			and meter
			and meter:IsA("GuiObject")
			and marker
			and marker:IsA("GuiObject")
			and label
			and label:IsA("TextLabel")
			and prompt
			and prompt:IsA("TextLabel")
			and scale
			and glow
			and glow:IsA("GuiObject")
		)
	then
		warnOnce("CastMeterGui.Meter/Bar/Marker/MultLabel/Glow or Prompt.UIScale is missing")
		return nil
	end
	return { gui = gui, holder = meter, marker = marker, label = label, prompt = prompt, scale = scale, glow = glow }
end

local function restore(state, returnToSpawn: boolean)
	if state.restored then
		return
	end
	state.restored = true
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
			local spawn = Workspace:FindFirstChild("SpawnLocation")
			local target = state.originalRootCFrame
			if spawn and spawn:IsA("BasePart") then
				local height = state.root.Position.Y - state.feetY
				target = spawn.CFrame * CFrame.new(0, spawn.Size.Y / 2 + height + 0.1, 0)
			else
				warnOnce("Workspace.SpawnLocation is missing; returning to entry position")
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
	restore(state, returnToSpawn)
	if state.coverGui then
		state.coverGui:Destroy()
	end
	GameplayInputGate.SetActive("Fishing", FishingController, false)
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
	if not transition.revealedAt then
		local alpha = math.clamp((now - transition.started) / Config.Transition.Cover, 0, 1)
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
		local alpha = math.clamp((now - transition.revealedAt) / Config.Transition.Reveal, 0, 1)
		state.cover.BackgroundTransparency = alpha
		if alpha == 1 then
			state.transition = nil
			state.coverGui.Enabled = false
			if state.restored then
				finish(false, true)
			else
				state.readyAt = now
			end
		end
	end
end

function FishingController:IsPreparing(): boolean
	return session ~= nil
end

function FishingController:ReturnToSpawn()
	if session and not session.transition then
		startTransition(session, "Returning")
	end
end

local function begin(part: BasePart, character: Model, root: BasePart, humanoid: Humanoid)
	local meter = getMeter()
	local characters = ReplicatedStorage:FindFirstChild("Character")
	local template = characters and characters:FindFirstChild("PoseDefaultCharacter")
	local models = ReplicatedStorage:FindFirstChild("Models")
	local rods = models and models:FindFirstChild("FishRod")
	local rod = rods and rods:FindFirstChild("TestRod")
	local fishingAnimations = ReplicatedStorage:FindFirstChild("Animation")
	fishingAnimations = fishingAnimations and fishingAnimations:FindFirstChild("Fishing")
	local animation = fishingAnimations and fishingAnimations:FindFirstChild("CastRod")
	local baits = models and models:FindFirstChild("FishBait")
	local baitGroup = baits and baits:FindFirstChild("1")
	local bait = baitGroup and baitGroup:FindFirstChild("1")
	if not meter then
		return
	end
	if not (template and template:IsA("Model") and rod and rod:IsA("Tool")) then
		warnOnce("PoseDefaultCharacter or Models.FishRod.TestRod is missing or invalid")
		return
	end
	if not (animation and animation:IsA("Animation") and bait and bait:IsA("BasePart")) then
		warnOnce("Animation.Fishing.CastRod or Models.FishBait[1][1] is missing or invalid")
		return
	end
	local camera = Workspace.CurrentCamera
	if not camera then
		return
	end
	local feetY = root.Position.Y - humanoid.HipHeight - root.Size.Y / 2
	if humanoid.RigType == Enum.HumanoidRigType.R6 then
		local leg = character:FindFirstChild("Left Leg")
		if leg and leg:IsA("BasePart") then
			feetY -= leg.Size.Y
		end
	end
	local state = {
		character = character,
		root = root,
		humanoid = humanoid,
		originalRootCFrame = root.CFrame,
		feetY = feetY,
		saved = {},
		connections = {},
		meter = meter,
		camera = {
			subject = camera.CameraSubject,
			fov = camera.FieldOfView,
			cframe = camera.CFrame,
			focus = camera.Focus,
		},
	}
	session = state
	FishingAudio.ClearTails()
	local ok, err = xpcall(function()
		local playerGui = assert(localPlayer:FindFirstChildOfClass("PlayerGui"))
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
		state.value = 0
		local direction = 1
		state.prepare = function()
			state.rig = FishingRigUtil.Create(template, character, rod)
			local rig = state.rig
			local rigRoot = rig.PrimaryPart
			local rigHumanoid = rig:FindFirstChildOfClass("Humanoid")
			local ground = part.Position + part.CFrame.UpVector * part.Size.Y / 2
			local position = ground + Vector3.new(0, rigHumanoid.HipHeight + rigRoot.Size.Y / 2, 0)
			rig:PivotTo(CFrame.lookAt(position, position + Vector3.zAxis))
			rig.Parent = Workspace
			local dataController = Knit.GetController("PlayerDataController")
			local function isSoundEnabled()
				local data = dataController:GetData()
				return data ~= nil and data.Settings[Constants.SETTINGS_ID.SOUND] ~= false
			end
			state.audio = FishingAudio.new(isSoundEnabled)
			state.sequence = FishingCastSequence.new(rig, playerGui, meter, animation, bait, {
				isSoundEnabled = isSoundEnabled,
				audio = state.audio,
			})
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
					and gui ~= state.sequence.gui
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
						and meter.marker:IsDescendantOf(meter.gui)
						and meter.label:IsDescendantOf(meter.gui)
						and meter.prompt:IsDescendantOf(meter.gui)
						and meter.scale:IsDescendantOf(meter.gui)
						and meter.glow:IsDescendantOf(meter.gui),
					"Fishing meter or rig disappeared"
				)
				if state.sequence.phase == "Preparing" and not state.transition then
					-- 限制单帧步长，避免窗口卡顿时跳过滚动区间。
					state.value += direction * 0.55 * (1 + 1.6 * state.value) * math.min(dt, 0.1)
					if state.value >= 1 then
						state.value, direction = 1, -1
					elseif state.value <= 0 then
						state.value, direction = 0, 1
					end
					meter.marker.Position = UDim2.fromScale(0.5, 1 - state.value)
					meter.label.Text = string.format("+%d", math.floor(state.value * Config.MeterBonus + 0.5))
					state.sequence:UpdateMeter(state.value)
				end
				state.sequence:Update(now, dt)
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

function FishingController:KnitInit()
	local gui = localPlayer:FindFirstChildOfClass("PlayerGui")
	local meter = gui and gui:FindFirstChild("CastMeterGui")
	if meter and meter:IsA("ScreenGui") then
		meter.Enabled = false
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
		finish(false)
	end)
	UserInputService.InputBegan:Connect(function(input, processed)
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
		then
			-- 可交互 UI 即使未将输入标为 processed，也不能当成场景点击。
			local playerGui = localPlayer:FindFirstChildOfClass("PlayerGui")
			for _, gui in ipairs(playerGui:GetGuiObjectsAtPosition(input.Position.X, input.Position.Y)) do
				if gui:IsA("GuiButton") or gui:IsA("TextBox") or gui.Active then
					return
				end
			end
			local sequence = state.sequence
			local now = os.clock()
			if sequence.phase == "Preparing" then
				sequence:Cast(state.value)
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
				or (not session.restored and (root.Position - session.originalRootCFrame.Position).Magnitude > 2)
			then
				finish(false)
			end
			return
		end
		if not (root and root:IsA("BasePart") and humanoid and humanoid.Health > 0) then
			FishingAudio.ClearTails()
			return
		end
		local part = getStartPart()
		if not part then
			warnOnce("Workspace.Areas.CastStartPart is missing")
			return
		end
		local inside = isInside(part, root, humanoid)
		if not inside then
			mustLeaveArea = false
			return
		end
		if
			mustLeaveArea
			or root.Anchored
			or localPlayer:GetAttribute(LoadingAttributes.LOADING_SCREEN_DONE) ~= true
			or not GameplayInputGate.IsWorldActionAllowed()
		then
			return
		end
		mustLeaveArea = true
		begin(part, character, root, humanoid)
	end)
end

return FishingController
