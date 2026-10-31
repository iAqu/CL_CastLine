local TweenService = game:GetService("TweenService")

local HOVER_SCALE = 1.1
local DEFAULT_SCALE = 1
local TWEEN_INFO = TweenInfo.new(0.1)

local ButtonScaleEffectUtil = {}

function ButtonScaleEffectUtil.Apply(button: GuiButton)
	if not button:IsA("GuiButton") then
		return
	end

	local uiScale = button:FindFirstChildOfClass("UIScale")
	if not uiScale then
		uiScale = Instance.new("UIScale")
		uiScale.Parent = button
	end

	local function tweenTo(scale: number)
		TweenService:Create(uiScale, TWEEN_INFO, {
			Scale = scale,
		}):Play()
	end

	button.MouseButton1Down:Connect(function()
		tweenTo(DEFAULT_SCALE)
	end)

	button.MouseButton1Up:Connect(function()
		tweenTo(HOVER_SCALE)
	end)

	button.MouseEnter:Connect(function()
		tweenTo(HOVER_SCALE)
	end)

	button.MouseLeave:Connect(function()
		tweenTo(DEFAULT_SCALE)
	end)
end

return ButtonScaleEffectUtil
