-- 客户端 FOV 分层控制（参考 garden2 FieldOfViewController）
-- 实际 FOV = BaseFOV + Adjuster

local TweenService = game:GetService("TweenService")

local DEFAULT_BASE_FOV = 70
local GUI_BASE_FOV = 60
local MENU_ADJUSTER = -12
local ROLL_ADJUSTER = -22
local DEFAULT_TWEEN_TIME = 0.3
local MENU_TWEEN_TIME = 0.6
local ROLL_TWEEN_TIME = 0.8
local ROLL_RESTORE_TWEEN_TIME = 0.35

local baseFov = DEFAULT_BASE_FOV
local adjuster = 0
local activeTween: Tween? = nil
local initialized = false

local FovController = {
	DEFAULT_BASE_FOV = DEFAULT_BASE_FOV,
	GUI_BASE_FOV = GUI_BASE_FOV,
	MENU_ADJUSTER = MENU_ADJUSTER,
	ROLL_ADJUSTER = ROLL_ADJUSTER,
	DEFAULT_TWEEN_TIME = DEFAULT_TWEEN_TIME,
	MENU_TWEEN_TIME = MENU_TWEEN_TIME,
	ROLL_TWEEN_TIME = ROLL_TWEEN_TIME,
	ROLL_RESTORE_TWEEN_TIME = ROLL_RESTORE_TWEEN_TIME,
}

local function getTargetFov(): number
	return baseFov + adjuster
end

local function getCamera(): Camera?
	return workspace.CurrentCamera
end

local function applyFov(tweenTime: number?)
	local camera = getCamera()
	if not camera then
		return
	end

	local targetFov = getTargetFov()

	-- Cancel() 会同步触发 Completed 回调，先摘掉引用再取消，避免二次销毁 nil
	local previousTween = activeTween
	activeTween = nil
	if previousTween then
		previousTween:Cancel()
		previousTween:Destroy()
	end

	local duration = tweenTime or DEFAULT_TWEEN_TIME
	local tween = TweenService:Create(
		camera,
		TweenInfo.new(duration, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
		{ FieldOfView = targetFov }
	)
	activeTween = tween
	tween.Completed:Once(function()
		if activeTween == tween then
			activeTween = nil
			tween:Destroy()
		end
	end)
	tween:Play()
end

local function init()
	if initialized then
		return
	end
	initialized = true

	baseFov = DEFAULT_BASE_FOV
	adjuster = 0

	local camera = getCamera()
	if camera then
		camera.FieldOfView = baseFov
	end

	workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(function()
		local cam = getCamera()
		if not cam then
			return
		end

		local previousTween = activeTween
		activeTween = nil
		if previousTween then
			previousTween:Cancel()
			previousTween:Destroy()
		end

		cam.FieldOfView = getTargetFov()
	end)
end

function FovController.SetBaseFOV(fov: number, tweenTime: number?)
	init()
	baseFov = fov
	adjuster = 0
	applyFov(tweenTime)
end

function FovController.SetAdjuster(offset: number, tweenTime: number?)
	init()
	adjuster = offset
	applyFov(tweenTime)
end

function FovController.ClearAdjuster(tweenTime: number?)
	init()
	adjuster = 0
	applyFov(tweenTime)
end

function FovController.Reset(tweenTime: number?)
	init()
	baseFov = DEFAULT_BASE_FOV
	adjuster = 0
	applyFov(tweenTime)
end

return FovController
