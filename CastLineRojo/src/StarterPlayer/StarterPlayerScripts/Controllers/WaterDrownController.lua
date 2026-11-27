local Lighting = game:GetService("Lighting")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")

local Knit = require(ReplicatedStorage.Packages.Knit)
local NotificationClient = require(ReplicatedStorage.Modules.NotificationClient)
local WaterSurfaceUtil = require(ReplicatedStorage.Modules.WaterSurfaceUtil)

local WARNING_DELAY = 0
local UNDERWATER_TWEEN_INFO = TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local DROWNING_ATTRIBUTE = "WaterDrowning"
local DROWN_STARTED_AT_ATTRIBUTE = "WaterDrownStartedAt"
local WARNING_GUI_NAME = "SeaDigWaterDrownWarning"
local DEFAULT_DEATH_SOUND_ID = "rbxasset://sounds/uuhhh.wav"
local DEFAULT_DEATH_SOUND_VOLUME = 0.5

local localPlayer = Players.LocalPlayer

local WaterDrownController = Knit.CreateController {
	Name = "WaterDrownController",
	_ColorCorrection = nil,
	_Blur = nil,
	_SurfacePreset = nil,
	_UnderwaterPreset = nil,
	_SurfaceLighting = nil,
	_UnderwaterLighting = nil,
	_Underwater = false,
	_EffectTween = nil,
	_BlurTween = nil,
	_LightingTween = nil,
	_WarningFrame = nil,
	_PendingDroppedItemCount = 0,
}

local function getPreset(colorName: string, blurName: string)
	local color = Lighting:FindFirstChild(colorName)
	if not color or not color:IsA("ColorCorrectionEffect") then
		warn("WaterDrownController: expected ColorCorrectionEffect at Lighting." .. colorName)
		return nil
	end

	local blur = Lighting:FindFirstChild(blurName)
	if not blur or not blur:IsA("BlurEffect") then
		warn("WaterDrownController: expected BlurEffect at Lighting." .. blurName)
		return nil
	end
	return { Color = color, Blur = blur }
end

local function colorProperties(color: ColorCorrectionEffect)
	return {
		TintColor = color.TintColor,
		Brightness = color.Brightness,
		Contrast = color.Contrast,
		Saturation = color.Saturation,
	}
end

function WaterDrownController:_initializeEffects()
	local surface = getPreset("ColorCorrectionEffect", "Blur_Default")
	if not surface then
		return
	end
	local underwater = getPreset("UnderwaterColorCorrection", "UnderwaterBlur")
	if not underwater then
		return
	end

	local colorCorrection = Instance.new("ColorCorrectionEffect")
	colorCorrection.Name = "WaterTransitionColorCorrection"
	for property, value in pairs(colorProperties(surface.Color)) do
		colorCorrection[property] = value
	end
	local blur = Instance.new("BlurEffect")
	blur.Name = "WaterTransitionBlur"
	blur.Size = surface.Blur.Size

	-- Render with one pair while keeping the authored values available as tween targets.
	surface.Color.Enabled = false
	surface.Blur.Enabled = false
	underwater.Color.Enabled = false
	underwater.Blur.Enabled = false
	colorCorrection.Parent = Lighting
	blur.Parent = Lighting

	self._SurfacePreset = surface
	self._UnderwaterPreset = underwater
	self._ColorCorrection = colorCorrection
	self._Blur = blur

	local ambient = underwater.Color:GetAttribute("Ambient")
	local brightness = underwater.Color:GetAttribute("Brightness")
	if typeof(ambient) == "Color3" and typeof(brightness) == "number" then
		self._UnderwaterLighting = { Ambient = ambient, Brightness = brightness }
	else
		warn("WaterDrownController: Lighting.UnderwaterColorCorrection requires Ambient (Color3) and Brightness (number) attributes")
	end
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

function WaterDrownController:_tweenLighting(underwater: boolean)
	local underwaterLighting = self._UnderwaterLighting
	if not underwaterLighting then
		return
	end
	if underwater and not self._SurfaceLighting then
		self._SurfaceLighting = { Ambient = Lighting.Ambient, Brightness = Lighting.Brightness }
	end
	local target = if underwater then underwaterLighting else self._SurfaceLighting
	if not target then
		return
	end

	local previousTween = self._LightingTween
	self._LightingTween = nil
	if previousTween then
		previousTween:Cancel()
	end
	local tween = TweenService:Create(Lighting, UNDERWATER_TWEEN_INFO, target)
	self._LightingTween = tween
	tween.Completed:Once(function(playbackState)
		if self._LightingTween ~= tween then
			return
		end
		self._LightingTween = nil
		if not underwater and playbackState == Enum.PlaybackState.Completed then
			self._SurfaceLighting = nil
		end
	end)
	tween:Play()
end

function WaterDrownController:_setUnderwater(enabled: boolean)
	if self._Underwater == enabled then
		return
	end
	local preset = if enabled then self._UnderwaterPreset else self._SurfacePreset
	local colorCorrection = self._ColorCorrection
	local blur = self._Blur
	if not preset or not colorCorrection or not blur then
		return
	end
	self._Underwater = enabled

	if self._EffectTween then
		self._EffectTween:Cancel()
	end
	if self._BlurTween then
		self._BlurTween:Cancel()
	end

	self._EffectTween = TweenService:Create(colorCorrection, UNDERWATER_TWEEN_INFO, colorProperties(preset.Color))
	self._BlurTween = TweenService:Create(blur, UNDERWATER_TWEEN_INFO, { Size = preset.Blur.Size })
	self._EffectTween:Play()
	self._BlurTween:Play()
	self:_tweenLighting(enabled)
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
	self:_initializeEffects()
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

	-- 常规钓鱼和新手教学分别在 Camera + 2、Camera + 3 更新。
	RunService:BindToRenderStep("SeaDigWaterDrownVisuals", Enum.RenderPriority.Camera.Value + 4, function()
		local camera = Workspace.CurrentCamera
		local cameraUnderwater = camera and WaterSurfaceUtil.IsPointSubmerged(camera.CFrame.Position) or false
		self:_setUnderwater(cameraUnderwater)
		self:_updateWarning()
	end)
end

return WaterDrownController
