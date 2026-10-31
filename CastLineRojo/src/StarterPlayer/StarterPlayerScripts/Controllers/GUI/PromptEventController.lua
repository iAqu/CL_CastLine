local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ReplicatedFirst = game:GetService("ReplicatedFirst")
local StarterPlayer = game:GetService("StarterPlayer")
local Players = game:GetService("Players")

local SocialService = game:GetService("SocialService")

local Knit = require(ReplicatedStorage.Packages.Knit)
local PlayerDataController = require(StarterPlayer.StarterPlayerScripts.Controllers.PlayerDataController)
local NumberUtil = require(ReplicatedStorage.Modules.NumberUtil)
local ViewportModel = require(ReplicatedStorage.Libs.ViewportModel)
local GuiUtil = require(ReplicatedStorage.Modules.GuiUtil)
local ButtonAnimation = require(ReplicatedStorage.Modules.ButtonAnimation)
local GuiAnimation = require(ReplicatedStorage.Modules.GuiAnimation)
local SoundHelper = require(ReplicatedStorage.Modules.SoundHelper)
local Constants = require(ReplicatedStorage.Modules.Constants)
local PurchaseDataHelper = require(ReplicatedFirst.DataHelpers.PurchaseDataHelper)
local NotificationClient = require(ReplicatedStorage.Modules.NotificationClient)
local LogHelper = require(ReplicatedStorage.Modules.LogHelper)
local RotationGradientModule = require(ReplicatedStorage.Modules.RotationGradientModule)
local DistanceDetectUtil = require(ReplicatedStorage.Modules.DistanceDetectUtil)
local Timer = require(ReplicatedStorage.Packages.Timer)

local player = Players.LocalPlayer


local PromptEventController = Knit.CreateController {
    Name = "PromptEventController",
}

-- 自动检测并提示 RSVP 的 LocalScript
-- 放在 StarterPlayerScripts 中

-- 获取当前 RSVP 状态
local function getRsvpStatus(eventId): Enum.RsvpStatus?
	local success, result = pcall(function()
		return SocialService:GetEventRsvpStatusAsync(eventId)
	end)

	if success then
		LogHelper.Print("✅ current RSVP status:", result)
		return result
	else
		LogHelper.Print("❌ failed to get RSVP status:", result)
		return nil
	end
end

local function promptEvent()
    -- -- 自动提示 RSVP（动态获取最近即将开始的活动）
    -- task.defer(function()
    --     -- 等待玩家加载完成
    --     repeat task.wait() until player

        -- 获取即将开始的活动列表
        local success, eventsOrError = pcall(function()
            return SocialService:GetUpcomingExperienceEventsAsync()
        end)

        if not success then
            -- warn("❌ 无法获取即将开始的活动列表：", eventsOrError)
            warn("❌ failed to get upcoming events:", eventsOrError)
            return
        end

        local upcomingEvents = eventsOrError
        local selectedEvent

        -- 筛选尚未开始也未结束的活动
        for _, event in ipairs(upcomingEvents) do
            if not event.HasStarted and not event.HasEnded then
                selectedEvent = event
                break
            end
        end

        if not selectedEvent then
            LogHelper.Print("⚠️ no upcoming events")
            return
        end

        LogHelper.Print("📅 found upcoming event:", selectedEvent.Name, selectedEvent.Id)

        -- 检查 RSVP 状态
        local rsvpStatus = getRsvpStatus(selectedEvent.Id)
        if rsvpStatus == Enum.RsvpStatus.Going then
            LogHelper.Print("🎉 player already RSVPed, no prompt needed")
            return
        end

        -- 延迟弹窗提示
        -- task.wait(300)
        -- task.wait(15)

        -- 提示 RSVP
        local successPrompt, resultPrompt = pcall(function()
            return SocialService:PromptRsvpToEventAsync(selectedEvent.Id)
        end)

        if successPrompt then
            if resultPrompt == Enum.RsvpStatus.Going then
                LogHelper.Print("🙌 player successfully RSVPed to the event!")
            else
                LogHelper.Print("⛔ player did not confirm RSVP")
            end
        else
            warn("❌ RSVP prompt failed:", resultPrompt)
        end
    -- end)
end

function PromptEventController:InitGui()

end
function PromptEventController:KnitInit()
end

function PromptEventController:KnitStart()
    -- promptEvent()
    task.delay(2, function()
        promptEvent()
    end)
end

return PromptEventController