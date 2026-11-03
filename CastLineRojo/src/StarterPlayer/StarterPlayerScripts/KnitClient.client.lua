local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ReplicatedFirst = game:GetService("ReplicatedFirst")
local Players = game:GetService("Players")
local StarterPlayer = game:GetService("StarterPlayer")

local Knit = require(ReplicatedStorage.Packages.Knit)
local LogHelper = require(ReplicatedStorage.Modules.LogHelper)
local LoadingAttributes = require(ReplicatedFirst:WaitForChild("LoadingAttributes"))
local localPlayer = Players.LocalPlayer
local controllersFolder = StarterPlayer.StarterPlayerScripts.Controllers
local PlayerDataController = require(controllersFolder:WaitForChild("PlayerDataController"))
local EventController = require(controllersFolder:WaitForChild("EventController"))
local FarmSignController = require(controllersFolder:WaitForChild("FarmSignController"))

-- 与其余 Controller 的 require 并行等待服务端存档，避免 HomeGui 先显示模板占位值。
PlayerDataController:BeginEarlyFetch()
EventController:BeginEarlyState()
-- 首屏农场头像不依赖 Knit 启动，先绑定 UI，再加载其余 Controller。
FarmSignController:BeginEarlyUi()

-- Controller 顶层若用 WaitForChild 等待缺失/改名的实例，会卡死整个 require 循环，
-- 导致 Knit 不启动、背包快捷栏等全部消失；超时告警帮助定位卡住的 Controller。
local REQUIRE_STUCK_WARN_SECONDS = 10

localPlayer:SetAttribute(LoadingAttributes.CLIENT_CONTROLLERS_READY, false)

for _,v in ipairs(controllersFolder:GetDescendants()) do
    if v:IsA("ModuleScript") and v.Name:match("Controller$") then
        local finished = false
        task.delay(REQUIRE_STUCK_WARN_SECONDS, function()
            if not finished then
                warn("KnitClient: controller require stuck (possible missing WaitForChild target):", v:GetFullName())
            end
        end)
        require(v)
        finished = true
    end
end

Knit.Start():andThen(function()
	-- Knit 已 require 全部 Controller、完成 KnitInit，并调度所有 KnitStart。
	-- 留出一个调度周期，让首批 KnitStart 回调先运行，再允许 loading 交还镜头。
	task.wait()
	localPlayer:SetAttribute(LoadingAttributes.CLIENT_CONTROLLERS_READY, true)
    LogHelper.Print("Knit started")
end):catch(warn)
