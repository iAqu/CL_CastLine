local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
-- local ServerStorage = game:GetService("ServerStorage")
local ServerScriptService = game:GetService("ServerScriptService")

local areas = Workspace:FindFirstChild("Areas")
local function hideAuxiliaryPart(instance: Instance?, path: string)
    if instance and instance:IsA("BasePart") then
        instance.Transparency = 1
        return
    end

    warn("KnitServer: " .. path .. " is missing or is not a BasePart")
end

hideAuxiliaryPart(areas and areas:FindFirstChild("ResetPlayerBox"), "Workspace.Areas.ResetPlayerBox")

local water = areas and areas:FindFirstChild("Water")
hideAuxiliaryPart(water and water:FindFirstChild("Surface"), "Workspace.Areas.Water.Surface")

local Knit = require(ReplicatedStorage.Packages.Knit)
local LogHelper = require(ReplicatedStorage.Modules.LogHelper)
local EventService = require(ServerScriptService.Services.EventService)
local PlayerDataService = require(ServerScriptService.Services.PlayerDataService)

-- 尽早发起 DataStore 请求，让网络读取与其余 Service 的加载/初始化并行。
PlayerDataService:BeginEarlyLoading()
-- 活动同样属于首屏状态，先发布本服务器当前档位的活动快照。
EventService:BeginEarlyState()


for _,v in ipairs(ServerScriptService.Services:GetDescendants()) do
    if v:IsA("ModuleScript") and v.Name:match("Service$") then
        require(v)
    end
end

Knit.Start():andThen(function()
	task.defer(function()
		-- Knit 已启动并已调度各 Service.KnitStart；此后再广播 ProfileLoaded，
		-- 避免提前完成的存档错过业务 Service 的监听器。
		PlayerDataService:MarkFrameworkReady()
	end)
    LogHelper.Print("Knit started")
end):catch(warn)
