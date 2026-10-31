local tweenService = game:GetService("TweenService")

-- -- 获取目标 UI 元素（由 LocalScriptAttach 系统设置的 Target）
local targetElement = script.Target.Value
-- local targetElement = script.Parent

-- 保存元素的原始旋转角度，用于动画结束后恢复
local originalRotation = targetElement.Rotation

-- 创建补间动画信息配置
-- 参数：持续时间 0.1 秒，正弦缓动，先加速后减速
local tweenInfo = TweenInfo.new(
	0.12,                          -- 持续时间（秒）
	Enum.EasingStyle.Sine,        -- 缓动样式：正弦曲线
	Enum.EasingDirection.InOut     -- 缓动方向：先加速后减速
)

local function playShakeAnimation()
	if not targetElement or not targetElement.Parent then
		warn("targetElement not found")
		return
	end
	
	-- 执行 2 次完整的左右摆动
	for _ = 1, 2 do
		-- 向右旋转 +15 度
		local rightTween = tweenService:Create(
			targetElement,
			tweenInfo,
			{
				Rotation = originalRotation + 15  -- 向右旋转 15 度
			}
		)
		rightTween:Play()
		rightTween.Completed:Wait()  -- 等待动画完成
		
		-- 向左旋转 -15 度
		local leftTween = tweenService:Create(
			targetElement,
			tweenInfo,
			{
				Rotation = originalRotation - 15  -- 向左旋转 15 度
			}
		)
		leftTween:Play()
		leftTween.Completed:Wait()  -- 等待动画完成
	end
	
	-- 最后恢复到原始角度
	local returnTween = tweenService:Create(
		targetElement,
		tweenInfo,
		{
			Rotation = originalRotation  -- 恢复到原始角度
		}
	)
	returnTween:Play()
end

-- 启动循环动画任务
-- 在独立协程中运行，不阻塞主线程
task.spawn(function()
	while true do
		local randomDelay = math.random(1.5, 2.5)
		task.wait(randomDelay)
		
		-- 执行晃动动画
		playShakeAnimation()
	end
end)

