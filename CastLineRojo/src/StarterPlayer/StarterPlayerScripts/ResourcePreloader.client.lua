local ReplicatedFirst = game:GetService("ReplicatedFirst")
local CriticalResourcePreloader = require(ReplicatedFirst:WaitForChild("CriticalResourcePreloader"))

-- 与 ReplicatedFirst 加载界面共用一次任务；界面模板缺失时仍继续预加载。
CriticalResourcePreloader.Start()
