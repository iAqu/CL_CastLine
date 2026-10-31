local TweenService = game:GetService("TweenService")

local targetModel = script.Target.Value

-- 获取模型及其主零件
local mainPart = targetModel.PrimaryPart

if not mainPart then
	warn("错误：模型没有设置 PrimaryPart，请在属性面板设置后再运行。")
	return
end

-- 记录初始位置
local startCFrame = mainPart.CFrame

-- 设置移动参数
local moveDistance = 15 -- 移动距离
local moveTime = 2    -- 移动一次所需的时间（秒）

-- 定义目标位置（基于初始位置计算）
local leftTarget = startCFrame * CFrame.new(0, 0, -moveDistance)
local rightTarget = startCFrame * CFrame.new(0, 0, 0)

-- 配置动画平滑度 (线性移动)
local info = TweenInfo.new(moveTime, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut)

-- 创建两个动画：向左和回到原点（或向右）
local tweenToLeft = TweenService:Create(mainPart, info, {CFrame = leftTarget})
local tweenToRight = TweenService:Create(mainPart, info, {CFrame = rightTarget})
local tweenToCenter = TweenService:Create(mainPart, info, {CFrame = startCFrame})

task.spawn(function()
	-- 自动执行循环
	while true do
		-- 1. 向左移动
		tweenToLeft:Play()
		tweenToLeft.Completed:Wait() -- 等待动画播放完成

		-- 2. 移动回原点（再向右移动）
		tweenToRight:Play()
		tweenToRight.Completed:Wait()

		-- 3. 如果你希望“回到原点”后再重新开始：
		tweenToCenter:Play()
		tweenToCenter.Completed:Wait()
	end
end)

