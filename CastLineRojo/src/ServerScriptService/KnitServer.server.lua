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

local airWalls = areas and areas:FindFirstChild("AirWalls")
if airWalls then
    for _, descendant in airWalls:GetDescendants() do
        if descendant:IsA("BasePart") then
            descendant.Transparency = 1
        end
    end
end

local Knit = require(ReplicatedStorage.Packages.Knit)
local LogHelper = require(ReplicatedStorage.Modules.LogHelper)
local PlayerDataService = require(ServerScriptService.Services.PlayerDataService)

-- 尽早发起 DataStore 请求，让网络读取与其余 Service 的加载/初始化并行。
PlayerDataService:BeginEarlyLoading()

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
