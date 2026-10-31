local Lighting = game:GetService("Lighting")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")

local Knit = require(ReplicatedStorage.Packages.Knit)
local NotificationClient = require(ReplicatedStorage.Modules.NotificationClient)

local WARNING_DELAY = 0
local UNDERWATER_TWEEN_INFO = TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local DROWNING_ATTRIBUTE = "WaterDrowning"
local DROWN_STARTED_AT_ATTRIBUTE = "WaterDrownStartedAt"
local COLOR_CORRECTION_NAME = "UnderwaterColorCorrection"
local BLUR_NAME = "UnderwaterBlur"
local WARNING_GUI_NAME = "SeaDigWaterDrownWarning"
local DEFAULT_DEATH_SOUND_ID = "rbxasset://sounds/uuhhh.wav"
local DEFAULT_DEATH_SOUND_VOLUME = 0.5

local UNDERWATER_COLOR = Color3.fromRGB(87, 158, 174)
local UNDERWATER_PROPERTIES = {
	Brightness = -0.12,
	Contrast = 0.08,
	Saturation = -0.25,
	TintColor = UNDERWATER_COLOR,
}
local SURFACE_PROPERTIES = {
	Brightness = 0,
	Contrast = 0,
	Saturation = 0,
	TintColor = Color3.new(1, 1, 1),
}

local localPlayer = Players.LocalPlayer

local WaterDrownController = Knit.CreateController {
	Name = "WaterDrownController",
	_ColorCorrection = nil,
	_Blur = nil,
	_Underwater = false,
	_EffectTween = nil,
	_BlurTween = nil,
	_WarningFrame = nil,
	_PendingDroppedItemCount = 0,
}

local function getWaterTop(): BasePart?
	local areas = Workspace:FindFirstChild("Areas")
	local water = areas and areas:FindFirstChild("Water")
	local top = water and water:FindFirstChild("Top")
	if top and top:IsA("BasePart") then
		return top
	end
	return nil
end

local function isPointBelowWaterSurface(part: BasePart, point: Vector3): boolean
	local localPoint = part.CFrame:PointToObjectSpace(point)
	local halfSize = part.Size * 0.5
	return math.abs(localPoint.X) <= halfSize.X
		and math.abs(localPoint.Z) <= halfSize.Z
		and localPoint.Y <= halfSize.Y
end

function WaterDrownController:IsPointSubmerged(worldPosition: Vector3): boolean
	local waterTop = getWaterTop()
	return waterTop ~= nil and isPointBelowWaterSurface(waterTop, worldPosition)
end

function WaterDrownController:_ensureEffects()
	local colorCorrection = Lighting:FindFirstChild(COLOR_CORRECTION_NAME)
	if not colorCorrection or not colorCorrection:IsA("ColorCorrectionEffect") then
		warn("WaterDrownController: Lighting.UnderwaterColorCorrection is missing")
		return false
	end
	for property, value in pairs(SURFACE_PROPERTIES) do
		colorCorrection[property] = value
	end
	colorCorrection.Enabled = false

	local blur = Lighting:FindFirstChild(BLUR_NAME)
	if not blur or not blur:IsA("BlurEffect") then
		warn("WaterDrownController: Lighting.UnderwaterBlur is missing")
		return false
	end
	blur.Size = 0
	blur.Enabled = false

	self._ColorCorrection = colorCorrection
	self._Blur = blur
	return true
end

function WaterDrownController:_ensureWarningGui()
	local playerGui = localPlayer:WaitForChild("PlayerGui")
	local oldGui = playerGui:FindFirstChild(WARNING_GUI_NAME)
	if oldGui then
		oldGui:Destroy()
	end

	local gui = Instance.new("ScreenGui")
	gui.Name = WARNING_GUI_NAME
	gui.DisplayOrder = 100
	gui.IgnoreGuiInset = true
	gui.ResetOnSpawn = false
	gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	gui.Parent = playerGui

	local frame = Instance.new("Frame")
	frame.Name = "RedFlash"
	frame.BackgroundColor3 = Color3.fromRGB(220, 24, 24)
	frame.BackgroundTransparency = 1
	frame.BorderSizePixel = 0
	frame.Size = UDim2.fromScale(1, 1)
	frame.Visible = false
	frame.Parent = gui

	self._WarningFrame = frame
end

function WaterDrownController:_setUnderwater(enabled: boolean)
	if self._Underwater == enabled then
		return
	end
	self._Underwater = enabled
	if not self:_ensureEffects() then
		return
	end

	if self._EffectTween then
		self._EffectTween:Cancel()
	end
	if self._BlurTween then
		self._BlurTween:Cancel()
	end

	local colorCorrection = self._ColorCorrection
	local blur = self._Blur
	if not colorCorrection or not blur then
		return
	end

	colorCorrection.Enabled = true
	blur.Enabled = true
	self._EffectTween = TweenService:Create(colorCorrection, UNDERWATER_TWEEN_INFO, enabled and UNDERWATER_PROPERTIES or SURFACE_PROPERTIES)
	self._BlurTween = TweenService:Create(blur, UNDERWATER_TWEEN_INFO, { Size = enabled and 8 or 0 })
	self._EffectTween:Play()
	self._BlurTween:Play()

	if not enabled then
		local finishedTween = self._BlurTween
		finishedTween.Completed:Connect(function(playbackState)
			if playbackState == Enum.PlaybackState.Completed and not self._Underwater and self._Blur == blur then
				colorCorrection.Enabled = false
				blur.Enabled = false
			end
		end)
	end
end

function WaterDrownController:_updateWarning()
	local frame = self._WarningFrame
	if not frame then
		return
	end

	local character = localPlayer.Character
	local humanoid = character and character:FindFirstChildOfClass("Humanoid")
	local startedAt = character and character:GetAttribute(DROWN_STARTED_AT_ATTRIBUTE)
	local drowning = character and character:GetAttribute(DROWNING_ATTRIBUTE) == true
	if not humanoid or humanoid.Health <= 0 or not drowning or type(startedAt) ~= "number" then
		frame.Visible = false
		return
	end

	local elapsed = Workspace:GetServerTimeNow() - startedAt
	if elapsed < WARNING_DELAY then
		frame.Visible = false
		return
	end

	frame.Visible = true
	local pulse = (math.sin((elapsed - WARNING_DELAY) * math.pi * 4) + 1) * 0.5
	frame.BackgroundTransparency = 0.58 + pulse * 0.2
end

function WaterDrownController:_resetCharacterVisuals()
	if self._WarningFrame then
		self._WarningFrame.Visible = false
	end
	self:_setUnderwater(false)
end

function WaterDrownController:_showPendingDropNotice()
	if self._PendingDroppedItemCount <= 0 then
		return
	end
	local character = localPlayer.Character
	local humanoid = character and character:FindFirstChildOfClass("Humanoid")
	if not humanoid or humanoid.Health <= 0 then
		return
	end
	local count = self._PendingDroppedItemCount
	self._PendingDroppedItemCount = 0
	NotificationClient.RedNotify(string.format("You dropped %d item%s while drowning!", count, if count == 1 then "" else "s"))
end

local function playDefaultDeathSound(character: Model)
	if localPlayer.Character ~= character then
		return
	end

	local root = character:FindFirstChild("HumanoidRootPart")
	if not root or not root:IsA("BasePart") then
		return
	end

	local defaultSound = root:FindFirstChild("Died")
	if defaultSound and defaultSound:IsA("Sound") then
		defaultSound:Play()
		return
	end

	local fallbackSound = Instance.new("Sound")
	fallbackSound.Name = "Died"
	fallbackSound.SoundId = DEFAULT_DEATH_SOUND_ID
	fallbackSound.Volume = DEFAULT_DEATH_SOUND_VOLUME
	fallbackSound.Parent = root
	fallbackSound.Ended:Once(function()
		fallbackSound:Destroy()
	end)
	fallbackSound:Play()
end

function WaterDrownController:KnitStart()
	self:_ensureEffects()
	self:_ensureWarningGui()
	local waterDrownService = Knit.GetService("WaterDrownService")
	waterDrownService.Drowned:Connect(function(character: Model)
		playDefaultDeathSound(character)
	end)
	waterDrownService.DrownedItemsDropped:Connect(function(count: number)
		if typeof(count) ~= "number" or count <= 0 then
			return
		end
		self._PendingDroppedItemCount += math.floor(count)
		task.defer(function()
			self:_showPendingDropNotice()
		end)
	end)

	localPlayer.CharacterAdded:Connect(function()
		self:_resetCharacterVisuals()
		task.defer(function()
			self:_showPendingDropNotice()
		end)
	end)

	RunService:BindToRenderStep("SeaDigWaterDrownVisuals", Enum.RenderPriority.Camera.Value + 1, function()
		local camera = Workspace.CurrentCamera
		local cameraUnderwater = camera and self:IsPointSubmerged(camera.CFrame.Position) or false
		self:_setUnderwater(cameraUnderwater)
		self:_updateWarning()
	end)
end

return WaterDrownController
