local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local StarterGui = game:GetService("StarterGui")
local Lighting = game:GetService("Lighting")
local ProximityPromptService = game:GetService("ProximityPromptService")
local ReplicatedFirst = game:GetService("ReplicatedFirst")
local SoundService = game:GetService("SoundService")
local Workspace = game:GetService("Workspace")

local LoadingAttributes = require(ReplicatedFirst:WaitForChild("LoadingAttributes"))
local CriticalResourcePreloader = require(ReplicatedFirst:WaitForChild("CriticalResourcePreloader"))
CriticalResourcePreloader.Start()

local localPlayer = Players.LocalPlayer
local playerGui = localPlayer:WaitForChild("PlayerGui")

local LOADING_FOV = 45
local MENU_DISTANCE = 16
local ENTRY_FADE_DURATION_SECONDS = 0.4
local ENTRY_CAMERA_DURATION_SECONDS = 1.25
local ENTRY_CAMERA_DISTANCE = 25
local ENTRY_CAMERA_BINDING_NAME = "SeaDigLoadingEntryCamera"
local ENTRY_CAMERA_DEFAULT_STATE_BINDING_NAME = "SeaDigLoadingEntryCameraDefaultState"
local ENTRY_CAMERA_MIN_ARC_HEIGHT = 4
local ENTRY_CAMERA_MAX_ARC_HEIGHT = 10
local ENTRY_CAMERA_SCALE = 0.96
local HIDDEN_SCENE_GUI_DISTANCE = 0.01
local SCENE_GUI_ORIGINAL_DISTANCE = "LoadingSceneGuiOriginalDistance"

type SceneGui = BillboardGui | SurfaceGui
type SceneGuiState = {
	distance: number,
	hiddenDistance: number,
	connection: RBXScriptConnection,
}

local hiddenGuis: { [ScreenGui]: boolean } = {}
local guiConnections: { [ScreenGui]: RBXScriptConnection } = {}
local sceneGuiStates: { [SceneGui]: SceneGuiState } = {}
local sceneGuiConnections: { RBXScriptConnection } = {}
local anchoredRoots: { [BasePart]: boolean } = {}
local depthOfFieldStates: { [DepthOfFieldEffect]: boolean } = {}

local playerGuiConnection: RBXScriptConnection? = nil
local characterConnection: RBXScriptConnection? = nil
local cameraConnection: RBXScriptConnection? = nil
local menuConnection: RBXScriptConnection? = nil
local loadingPart: BasePart? = nil
local loadingGui: SurfaceGui? = nil
local loadingFrame: Frame? = nil
local loadingBlur: BlurEffect? = nil
local loadingCameraPart: BasePart? = nil
local logoTween: Tween? = nil
local originalFieldOfView: number? = nil
local originalPromptEnabled = ProximityPromptService.Enabled
local anchoringEnabled = true
local runtimeRestored = false

local function getCurrentCamera(): Camera
	local camera = Workspace.CurrentCamera
	while not camera do
		Workspace:GetPropertyChangedSignal("CurrentCamera"):Wait()
		camera = Workspace.CurrentCamera
	end
	return camera
end

local function getLoadingCameraPart(): BasePart?
	if loadingCameraPart and loadingCameraPart.Parent then
		return loadingCameraPart
	end
	local areas = Workspace:FindFirstChild("Areas")
	local cameraPart = areas and areas:FindFirstChild("LoadingScreenCam")
	if cameraPart and cameraPart:IsA("BasePart") then
		loadingCameraPart = cameraPart
	end
	return loadingCameraPart
end

local function setLoadingCamera()
	local camera = getCurrentCamera()
	camera.CameraType = Enum.CameraType.Scriptable
	camera.FieldOfView = LOADING_FOV
	local cameraPart = getLoadingCameraPart()
	if cameraPart then
		camera.CFrame = cameraPart.CFrame
		camera.Focus = cameraPart.CFrame
	end
end

local function setCoreGuiEnabled(coreGuiType: Enum.CoreGuiType, enabled: boolean)
	pcall(function()
		StarterGui:SetCoreGuiEnabled(coreGuiType, enabled)
	end)
end

local function hideGui(gui: ScreenGui)
	if gui.Name == "FishingIntroLoadingCover" then
		return
	end
	if gui.Enabled then
		hiddenGuis[gui] = true
		gui.Enabled = false
	end
	guiConnections[gui] = gui:GetPropertyChangedSignal("Enabled"):Connect(function()
		if gui.Enabled then
			hiddenGuis[gui] = true
			gui.Enabled = false
		end
	end)
end

local function hideOtherGuis()
	for _, child in ipairs(playerGui:GetChildren()) do
		if child:IsA("ScreenGui") then
			hideGui(child)
		end
	end
	playerGuiConnection = playerGui.ChildAdded:Connect(function(child)
		if child:IsA("ScreenGui") then
			hideGui(child)
		end
	end)
end

local function restoreOtherGuis()
	if playerGuiConnection then
		playerGuiConnection:Disconnect()
		playerGuiConnection = nil
	end
	for gui, connection in pairs(guiConnections) do
		connection:Disconnect()
		guiConnections[gui] = nil
	end
	for gui in pairs(hiddenGuis) do
		if gui.Parent then
			gui.Enabled = true
		end
		hiddenGuis[gui] = nil
	end
end

local function hideSceneGui(instance: Instance)
	if #sceneGuiConnections == 0 or not (instance:IsA("BillboardGui") or instance:IsA("SurfaceGui")) then
		return
	end
	if sceneGuiStates[instance] or (loadingPart and instance:IsDescendantOf(loadingPart)) then
		return
	end

	-- Leave Enabled available to the controllers that own each scene GUI.
	local currentDistance = instance.MaxDistance
	local inheritedDistance = instance:GetAttribute(SCENE_GUI_ORIGINAL_DISTANCE)
	instance.MaxDistance = HIDDEN_SCENE_GUI_DISTANCE
	local hiddenDistance = instance.MaxDistance
	-- Clones of masked templates need the original distance along with the temporary value.
	local distance = if currentDistance == hiddenDistance and typeof(inheritedDistance) == "number"
		then inheritedDistance
		else currentDistance
	instance:SetAttribute(SCENE_GUI_ORIGINAL_DISTANCE, distance)
	local connection = instance:GetPropertyChangedSignal("MaxDistance"):Connect(function()
		local state = sceneGuiStates[instance]
		local updatedDistance = instance.MaxDistance
		if state and updatedDistance ~= hiddenDistance then
			state.distance = updatedDistance
			instance:SetAttribute(SCENE_GUI_ORIGINAL_DISTANCE, updatedDistance)
			instance.MaxDistance = hiddenDistance
		end
	end)
	sceneGuiStates[instance] = { distance = distance, hiddenDistance = hiddenDistance, connection = connection }
end

local function hideSceneGuis()
	for _, root in { Workspace, playerGui } do
		table.insert(sceneGuiConnections, root.DescendantAdded:Connect(hideSceneGui))
		for _, instance in root:GetDescendants() do
			hideSceneGui(instance)
		end
	end
end

local function restoreSceneGuis()
	for _, connection in sceneGuiConnections do
		connection:Disconnect()
	end
	table.clear(sceneGuiConnections)
	for gui, state in sceneGuiStates do
		state.connection:Disconnect()
		if gui.MaxDistance == state.hiddenDistance then
			gui.MaxDistance = state.distance
		end
		gui:SetAttribute(SCENE_GUI_ORIGINAL_DISTANCE, nil)
	end
	table.clear(sceneGuiStates)
end

local function anchorCharacter(character: Model)
	if not anchoringEnabled then
		return
	end
	local root = character:FindFirstChild("HumanoidRootPart") or character:WaitForChild("HumanoidRootPart", 10)
	if anchoringEnabled and root and root:IsA("BasePart") and anchoredRoots[root] == nil then
		anchoredRoots[root] = root.Anchored
		root.Anchored = true
	end
end

local function restoreCharacterAnchoring()
	anchoringEnabled = false
	for root, wasAnchored in pairs(anchoredRoots) do
		if root.Parent then
			root.Anchored = wasAnchored
		end
		anchoredRoots[root] = nil
	end
end

local function updateMenuPlacement()
	if not loadingPart or not loadingGui then
		return
	end
	local camera = getCurrentCamera()
	local viewport = camera.ViewportSize
	if viewport.Y <= 0 then
		return
	end
	local height = math.tan(math.rad(camera.FieldOfView / 2)) * MENU_DISTANCE * 2
	loadingGui.CanvasSize = viewport
	loadingPart.Size = Vector3.new(height * viewport.X / viewport.Y, height, 0.1)
	loadingPart.CFrame = camera.CFrame * CFrame.new(0, 0, -MENU_DISTANCE)
end

local function startBlur()
	for _, effect in ipairs(Lighting:GetChildren()) do
		if effect:IsA("DepthOfFieldEffect") then
			depthOfFieldStates[effect] = effect.Enabled
			effect.Enabled = false
		end
	end
	loadingBlur = Instance.new("BlurEffect")
	loadingBlur.Name = "AFLoadingBlur"
	loadingBlur.Size = 20
	loadingBlur.Parent = Lighting
end

local function restoreLighting()
	if loadingBlur then
		loadingBlur:Destroy()
		loadingBlur = nil
	end
	for effect, wasEnabled in pairs(depthOfFieldStates) do
		if effect.Parent then
			effect.Enabled = wasEnabled
		end
		depthOfFieldStates[effect] = nil
	end
end

local function disconnectConnections()
	if cameraConnection then
		cameraConnection:Disconnect()
		cameraConnection = nil
	end
	if menuConnection then
		menuConnection:Disconnect()
		menuConnection = nil
	end
end

local function fadeLoadingPresentation(): Tween?
	local tweenInfo = TweenInfo.new(
		ENTRY_FADE_DURATION_SECONDS,
		Enum.EasingStyle.Quad,
		Enum.EasingDirection.Out
	)
	local completionTween: Tween? = nil
	if loadingFrame then
		for _, descendant in ipairs(loadingFrame:GetDescendants()) do
			if descendant:IsA("GuiObject") then
				TweenService:Create(descendant, tweenInfo, { BackgroundTransparency = 1 }):Play()
			end
			if descendant:IsA("TextLabel") or descendant:IsA("TextButton") then
				TweenService:Create(descendant, tweenInfo, { TextTransparency = 1 }):Play()
			elseif descendant:IsA("ImageLabel") or descendant:IsA("ImageButton") then
				TweenService:Create(descendant, tweenInfo, { ImageTransparency = 1 }):Play()
			elseif descendant:IsA("UIStroke") then
				TweenService:Create(descendant, tweenInfo, { Transparency = 1 }):Play()
			end
		end
		local fadeScale = Instance.new("UIScale")
		fadeScale.Name = "LoadingExitScale"
		fadeScale.Parent = loadingFrame
		TweenService:Create(fadeScale, tweenInfo, { Scale = ENTRY_CAMERA_SCALE }):Play()
		completionTween = TweenService:Create(loadingFrame, tweenInfo, { BackgroundTransparency = 1 })
		completionTween:Play()
	end
	if loadingBlur then
		TweenService:Create(loadingBlur, tweenInfo, { Size = 0 }):Play()
	end
	return completionTween
end

local function animateEntryCamera(
	camera: Camera,
	humanoid: Humanoid,
	seedCFrame: CFrame,
	seedFocus: CFrame,
	targetFieldOfView: number
)
	local startCFrame = camera.CFrame
	local startPosition = startCFrame.Position
	local startRotation = startCFrame.Rotation
	local startFocus = camera.Focus
	local startFieldOfView = camera.FieldOfView
	local defaultCFrame = seedCFrame
	local defaultFocus = seedFocus
	local defaultFieldOfView = targetFieldOfView
	local priority = Enum.RenderPriority.Camera.Value
	local elapsed = 0
	local completed = false

	local function isCurrentCustomCamera(): boolean
		return Workspace.CurrentCamera == camera and camera.CameraType == Enum.CameraType.Custom
	end

	-- Give PlayerModule its own previous result before each update, rather than the rendered entry view.
	RunService:BindToRenderStep(ENTRY_CAMERA_DEFAULT_STATE_BINDING_NAME, priority - 1, function()
		if not completed and isCurrentCustomCamera() then
			camera.CFrame = defaultCFrame
			camera.Focus = defaultFocus
			camera.FieldOfView = defaultFieldOfView
		end
	end)
	RunService:BindToRenderStep(ENTRY_CAMERA_BINDING_NAME, priority + 1, function(deltaTime)
		if completed or not isCurrentCustomCamera() then
			completed = true
			return
		end

		defaultCFrame = camera.CFrame
		defaultFocus = camera.Focus
		defaultFieldOfView = camera.FieldOfView
		elapsed += deltaTime
		if elapsed >= ENTRY_CAMERA_DURATION_SECONDS then
			-- PlayerModule's current output is already the final visible frame.
			completed = true
			return
		end

		local alpha = TweenService:GetValue(
			elapsed / ENTRY_CAMERA_DURATION_SECONDS,
			Enum.EasingStyle.Sine,
			Enum.EasingDirection.InOut
		)
		local targetPosition = defaultCFrame.Position
		local offset = Vector3.new(targetPosition.X - startPosition.X, 0, targetPosition.Z - startPosition.Z)
		local arcHeight = math.clamp(offset.Magnitude * 0.08, ENTRY_CAMERA_MIN_ARC_HEIGHT, ENTRY_CAMERA_MAX_ARC_HEIGHT)
		local cameraPosition = startPosition:Lerp(targetPosition, alpha) + Vector3.yAxis * (2 * alpha * (1 - alpha) * arcHeight)
		-- Loading's focus is at the camera position, so preserve its starting rotation directly.
		camera.CFrame = CFrame.new(cameraPosition) * startRotation:Lerp(defaultCFrame.Rotation, alpha)
		camera.Focus = startFocus:Lerp(defaultFocus, alpha)
		camera.FieldOfView = startFieldOfView + (defaultFieldOfView - startFieldOfView) * alpha
	end)

	camera.CameraSubject = humanoid
	camera.CameraType = Enum.CameraType.Custom
	while not completed do
		RunService.RenderStepped:Wait()
	end
	RunService:UnbindFromRenderStep(ENTRY_CAMERA_DEFAULT_STATE_BINDING_NAME)
	RunService:UnbindFromRenderStep(ENTRY_CAMERA_BINDING_NAME)
end

local function playEntryCamera(): boolean
	local character = localPlayer.Character or localPlayer.CharacterAdded:Wait()
	local humanoid = character:FindFirstChildOfClass("Humanoid") or character:WaitForChild("Humanoid", 10)
	local root = character:FindFirstChild("HumanoidRootPart") or character:WaitForChild("HumanoidRootPart", 10)
	if not humanoid or not humanoid:IsA("Humanoid") or not root or not root:IsA("BasePart") then
		return false
	end

	local camera = getCurrentCamera()
	local originalMinZoomDistance = localPlayer.CameraMinZoomDistance
	local originalMaxZoomDistance = localPlayer.CameraMaxZoomDistance
	local entryZoomDistance = math.clamp(ENTRY_CAMERA_DISTANCE, originalMinZoomDistance, originalMaxZoomDistance)
	localPlayer.CameraMinZoomDistance = entryZoomDistance
	localPlayer.CameraMaxZoomDistance = entryZoomDistance
	local fadeTween = fadeLoadingPresentation()
	if fadeTween then
		fadeTween.Completed:Wait()
	else
		task.wait(ENTRY_FADE_DURATION_SECONDS)
	end

	-- UI 和模糊完全淡出后，才释放 Loading 相机并开始入场镜头。
	disconnectConnections()
	local seedFocus = root.Position + Vector3.new(0, math.max(2.25, root.Size.Y * 1.25), 0)
	local seedPosition = seedFocus - root.CFrame.LookVector * entryZoomDistance
		+ Vector3.new(0, math.max(1.5, entryZoomDistance * 0.18), 0)

	local whoosh = SoundService:FindFirstChild("Whoosh", true)
	if whoosh and whoosh:IsA("Sound") then
		whoosh:Play()
	end

	animateEntryCamera(
		camera,
		humanoid,
		CFrame.lookAt(seedPosition, seedFocus),
		CFrame.new(seedFocus),
		originalFieldOfView or camera.FieldOfView
	)
	localPlayer.CameraMinZoomDistance = originalMinZoomDistance
	localPlayer.CameraMaxZoomDistance = originalMaxZoomDistance
	-- Let the settled gameplay camera render once before revealing the scene UI.
	RunService.RenderStepped:Wait()
	return true
end

local function restoreRuntimeState(deferCompletion: boolean?)
	-- Loading releases its snapshots once, under cover, before the intro captures them.
	if not runtimeRestored then
		runtimeRestored = true
		if characterConnection then
			characterConnection:Disconnect()
			characterConnection = nil
		end
		if logoTween then
			logoTween:Cancel()
			logoTween = nil
		end
		disconnectConnections()
		restoreCharacterAnchoring()
		restoreLighting()
		restoreOtherGuis()
		ProximityPromptService.Enabled = originalPromptEnabled
		setCoreGuiEnabled(Enum.CoreGuiType.Health, true)
		setCoreGuiEnabled(Enum.CoreGuiType.Chat, true)
		local camera = getCurrentCamera()
		camera.CameraType = Enum.CameraType.Custom
		if originalFieldOfView then
			camera.FieldOfView = originalFieldOfView
		end
	end
	if deferCompletion then
		return
	end
	restoreSceneGuis()
	if loadingGui then
		loadingGui.Enabled = false
	end
	if loadingPart then
		loadingPart:Destroy()
		loadingPart = nil
	end
	localPlayer:SetAttribute(LoadingAttributes.LOADING_BASE_READY, true)
	localPlayer:SetAttribute(LoadingAttributes.LOADING_SCREEN_ACTIVE, false)
	localPlayer:SetAttribute(LoadingAttributes.LOADING_SCREEN_DONE, true)
end

local function handoffToIntro(): boolean
	local deadline = os.clock() + LoadingAttributes.INTRO_PREPARE_TIMEOUT
	local function getState()
		return localPlayer:GetAttribute(LoadingAttributes.INTRO_STARTUP_STATE)
	end
	local states = LoadingAttributes.INTRO_STATE
	while localPlayer.Parent and (getState() == nil or getState() == states.Pending) and os.clock() < deadline do
		RunService.RenderStepped:Wait()
	end
	if getState() ~= states.Preparing then
		if getState() ~= states.Skipped then
			localPlayer:SetAttribute(LoadingAttributes.INTRO_STARTUP_STATE, states.Skipped)
		end
		return false
	end

	local cover = Instance.new("ScreenGui")
	cover.Name, cover.IgnoreGuiInset, cover.ResetOnSpawn, cover.DisplayOrder = "FishingIntroLoadingCover", true, false, 10000
	local black = Instance.new("Frame")
	black.Size, black.BackgroundColor3, black.BorderSizePixel = UDim2.fromScale(1, 1), Color3.new(), 0
	black.Parent = cover
	cover.Parent = playerGui
	local ok, err = xpcall(function()
		restoreRuntimeState(true)
		-- Capture the normal home camera beneath cover for the intro's eventual return.
		local character = localPlayer.Character
		local humanoid = character and character:FindFirstChildOfClass("Humanoid")
		local root = character and character:FindFirstChild("HumanoidRootPart")
		assert(humanoid and root, "Opening handoff character unavailable")
		local camera = getCurrentCamera()
		local focus = root.Position + Vector3.yAxis * 2.5
		camera.CameraSubject = humanoid
		camera.CFrame = CFrame.lookAt(focus - root.CFrame.LookVector * ENTRY_CAMERA_DISTANCE + Vector3.yAxis * 4, focus)
		camera.Focus = CFrame.new(focus)
		RunService.RenderStepped:Wait()
		RunService.RenderStepped:Wait()
		localPlayer:SetAttribute(LoadingAttributes.INTRO_HANDOFF_READY, true)
		while localPlayer.Parent and (getState() == states.Preparing or getState() == states.Pending) and os.clock() < deadline do
			RunService.RenderStepped:Wait()
		end
		if getState() ~= states.Prepared then
			if getState() ~= states.Skipped then
				warn("LoadingScreen: opening preparation timed out")
			end
			localPlayer:SetAttribute(LoadingAttributes.INTRO_STARTUP_STATE, states.Skipped)
		end
	end, debug.traceback)
	if not ok then
		warn("LoadingScreen: " .. tostring(err))
		localPlayer:SetAttribute(LoadingAttributes.INTRO_STARTUP_STATE, states.Skipped)
	end
	-- The intro has rendered frame zero before loading and the cover disappear.
	restoreRuntimeState()
	cover:Destroy()
	return true
end

local function getLoadingTarget(): (number, string, boolean)
	local preload = CriticalResourcePreloader.GetStatus()
	if game:IsLoaded()
		and preload.phase ~= "Idle" and preload.phase ~= "Loading"
		and localPlayer:GetAttribute(LoadingAttributes.PLAYER_DATA_LOADED) == true
		and localPlayer:GetAttribute(LoadingAttributes.CLIENT_CONTROLLERS_READY) == true
	then
		return 1, "Ready!", true
	end
	if not game:IsLoaded() then
		return 0.05, "Loading game...", false
	end
	if preload.phase == "Idle" or preload.phase == "Loading" then
		local ratio = if preload.total > 0 then math.clamp(preload.loaded / preload.total, 0, 1) else 0
		return 0.05 + ratio * 0.15, ("Preloading assets... (%d/%d)"):format(preload.loaded, preload.total), false
	end
	if localPlayer:GetAttribute(LoadingAttributes.PLAYER_DATA_LOADED) ~= true then
		return 1, "Loading player data...", false
	end
	return 1, "Loading controllers...", false
end

localPlayer:SetAttribute(LoadingAttributes.LOADING_SCREEN_ACTIVE, true)
localPlayer:SetAttribute(LoadingAttributes.LOADING_SCREEN_DONE, false)
localPlayer:SetAttribute(LoadingAttributes.LOADING_BASE_READY, false)
localPlayer:SetAttribute(LoadingAttributes.INTRO_HANDOFF_READY, false)
hideSceneGuis()

local template = ReplicatedFirst:WaitForChild("LoadingScreenMenu", 15)
if not template or not template:IsA("BasePart") then
	warn("LoadingScreen: ReplicatedFirst.LoadingScreenMenu is missing or is not a BasePart")
	restoreRuntimeState()
	return
end

loadingPart = template:Clone()
loadingPart.Anchored = true
loadingPart.CanCollide = false
loadingPart.CanQuery = false
loadingPart.CanTouch = false
loadingPart.Parent = Workspace

local gui = loadingPart:FindFirstChild("LoadingGui")
local frame = gui and gui:FindFirstChild("Frame")
local innerFrame = frame and frame:FindFirstChild("Frame")
if not gui or not gui:IsA("SurfaceGui") or not frame or not frame:IsA("Frame") or not innerFrame or not innerFrame:IsA("Frame") then
	warn("LoadingScreen: LoadingScreenMenu must contain LoadingGui.Frame.Frame")
	restoreRuntimeState()
	return
end

loadingGui = gui
loadingFrame = frame
loadingGui.Enabled = true
frame.Visible = true
local counterText = innerFrame:FindFirstChild("CounterTxt")
local progressBar = innerFrame:FindFirstChild("ProgressBar")
local bar = progressBar and progressBar:FindFirstChild("Bar")
local logo = innerFrame:FindFirstChild("LOGO")
if not counterText or not counterText:IsA("TextLabel") or not bar or not bar:IsA("GuiObject") then
	warn("LoadingScreen: CounterTxt or ProgressBar.Bar is missing")
	restoreRuntimeState()
	return
end

bar.Size = UDim2.fromScale(0, 1)
counterText.Text = "Loading... 0%"
local tipLabel = innerFrame:FindFirstChild("TipLabel")
if tipLabel and tipLabel:IsA("GuiObject") then
	tipLabel.Visible = false
end
for _, labelName in ipairs({ "SkipTxt", "PressAnyTxt" }) do
	local label = innerFrame:FindFirstChild(labelName)
	if label and label:IsA("TextLabel") then
		label.Text = ""
		label.TextTransparency = 1
	end
end
if logo and logo:IsA("ImageLabel") then
	logo.Rotation = -3
	logoTween = TweenService:Create(logo, TweenInfo.new(1.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true), {
		Rotation = 3,
	})
	logoTween:Play()
end

local camera = getCurrentCamera()
originalFieldOfView = camera.FieldOfView
hideOtherGuis()
setCoreGuiEnabled(Enum.CoreGuiType.Health, false)
setCoreGuiEnabled(Enum.CoreGuiType.Chat, false)
ProximityPromptService.Enabled = false
if localPlayer.Character then
	task.spawn(anchorCharacter, localPlayer.Character)
end
characterConnection = localPlayer.CharacterAdded:Connect(function(character)
	task.spawn(anchorCharacter, character)
end)

startBlur()
setLoadingCamera()
cameraConnection = RunService.RenderStepped:Connect(setLoadingCamera)
menuConnection = RunService.RenderStepped:Connect(updateMenuPlacement)
updateMenuPlacement()

task.delay(15, function()
	if localPlayer:GetAttribute(LoadingAttributes.LOADING_SCREEN_ACTIVE) == true and not getLoadingCameraPart() then
		warn("LoadingScreen: Workspace.Areas.LoadingScreenCam is missing or is not a BasePart")
	end
end)

local displayedProgress = 0
local monotonicTarget = 0
local activeBarTween: Tween? = nil
while localPlayer.Parent do
	local target, statusText, ready = getLoadingTarget()
	monotonicTarget = math.max(monotonicTarget, target)
	local delta = monotonicTarget - displayedProgress
	if delta > 0 then
		displayedProgress = math.min(monotonicTarget, displayedProgress + math.clamp(delta * 0.06, 0.001, 0.015))
	end
	if activeBarTween then
		activeBarTween:Cancel()
	end
	activeBarTween = TweenService:Create(bar, TweenInfo.new(0.05, Enum.EasingStyle.Linear), {
		Size = UDim2.fromScale(displayedProgress, 1),
	})
	activeBarTween:Play()
	counterText.Text = ready and "Loading... 100%" or statusText
	if ready then
		activeBarTween:Cancel()
		activeBarTween = nil
		bar.Size = UDim2.fromScale(1, 1)
		localPlayer:SetAttribute(LoadingAttributes.LOADING_BASE_READY, true)
		if not handoffToIntro() then
			playEntryCamera()
		end
		break
	end
	task.wait(0.05)
end

restoreRuntimeState()
