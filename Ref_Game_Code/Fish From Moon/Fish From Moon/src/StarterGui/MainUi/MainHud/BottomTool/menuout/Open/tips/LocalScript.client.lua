local TweenService = game:GetService("TweenService")

local frame = script.Parent
local imageLabel = frame:WaitForChild("ImageLabel")

-- 设置缩放大小
local scaleUp = UDim2.new(1.2, 0, 1.2, 0)
local scaleDown = UDim2.new(1, 0, 1, 0)

-- 设置Tween信息
local tweenInfo = TweenInfo.new(
	0.5, -- 时间（秒）
	Enum.EasingStyle.Quad, -- 缓动类型
	Enum.EasingDirection.Out, -- 缓动方向
	0, -- 重复次数（0表示不重复）
	false, -- 是否往返
	0 -- 延迟时间
)

-- 创建Tween
local tweenUp = TweenService:Create(imageLabel, tweenInfo, {Size = scaleUp})
local tweenDown = TweenService:Create(imageLabel, tweenInfo, {Size = scaleDown})

-- 无限循环来回缩放
while true do
	tweenUp:Play()
	tweenUp.Completed:Wait()

	tweenDown:Play()
	tweenDown.Completed:Wait()
end
