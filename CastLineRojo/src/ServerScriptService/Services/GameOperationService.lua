local ReplicatedStorage = game:GetService("ReplicatedStorage")
local DataStoreService = game:GetService("DataStoreService")

local Knit = require(ReplicatedStorage.Packages.Knit)
local Constants = require(ReplicatedStorage.Modules.Constants)
local Timer = require(ReplicatedStorage.Packages.Timer)

local DataStore_Game_Operation = DataStoreService:GetDataStore("Game_Operation")
local blackListCache = {}
local blackListLoaded = false
local blackListLoading = false
local blackListLoadedEvent = Instance.new("BindableEvent")

local GameOperationService = Knit.CreateService {
    Name = "GameOperationService",
    Client = {
		  ShowNotification = Knit.CreateSignal(),
    },
}

function GameOperationService:GetBlackList()
  if blackListLoaded then
    return blackListCache
  end
  if blackListLoading then
    blackListLoadedEvent.Event:Wait()
    return blackListCache
  end
  blackListLoading = true
  local success, blackList = pcall(function()
      return DataStore_Game_Operation:GetAsync("BlackList")
  end)
  blackListCache = {}
  if success and typeof(blackList) == "table" and next(blackList) ~= nil then
    blackListCache = blackList
  end
  blackListLoaded = success
  blackListLoading = false
  blackListLoadedEvent:Fire()
  return blackListCache
end

function GameOperationService:UpdateNotification()
  local getSuccess, notification = pcall(function()
    return DataStore_Game_Operation:GetAsync("SystemNotification")
  end)
  if not getSuccess then
    warn("Failed to get system notification")
    return
  end
  if not notification then
    local setSuccess = pcall(function()
      DataStore_Game_Operation:SetAsync("SystemNotification", {
        Active = false,
        Type = "Countdown",   -- "Countdown" | "Text"
        Text = "",
        TargetDate = 0        -- unix timestamp
      })
    end)
    if not setSuccess then
      warn("Failed to set system notification")
    end
  else
      self.Client.ShowNotification:FireAll(notification)
  end
end

function GameOperationService:KnitInit()
end

function GameOperationService:KnitStart()
	local notifUpdateTimer = Timer.new(Constants.SYSTEM_NOTIFICATION_DURATION)
	notifUpdateTimer.Tick:Connect(function()
    task.spawn(function()
      self:UpdateNotification()
    end)
  end)
	notifUpdateTimer:StartNow()
end

return GameOperationService
