local ReplicatedStorage = game:GetService("ReplicatedStorage")

local GameAnalytics = require(ReplicatedStorage.GameAnalytics)
local Constants = require(ReplicatedStorage.Modules.Constants)

if Constants.DEBUG then
    GameAnalytics:setEnabledInfoLog(true)
    GameAnalytics:setEnabledVerboseLog(true)
else
    GameAnalytics:setEnabledInfoLog(false)
    GameAnalytics:setEnabledVerboseLog(false)
end

GameAnalytics:setEnabledAutomaticSendBusinessEvents(false)

GameAnalytics:configureBuild(Constants.RESOURCE_VERSION)

GameAnalytics:initServer("87fe99b75454663925a4680dc2ddb0bd", "acea06f3953c38a9861eb2ad1c19f0674462180b")

GameAnalytics:configureAvailableResourceCurrencies({"Wins", "Diamonds", "Rebirths"})
GameAnalytics:configureAvailableResourceItemTypes({"Cup", "Purchase", "Codes", "Area"})

-- GameAnalytics:initialize({
--     useCustomUserId = true,
--     -- more settings
-- })

print("GameAnalytics initialized")
