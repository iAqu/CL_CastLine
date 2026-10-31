local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterPlayer = game:GetService("StarterPlayer")
local Players = game:GetService("Players")
local TextChatService = game:GetService("TextChatService")
local ReplicatedFirst = game:GetService("ReplicatedFirst")

local LogHelper = require(ReplicatedStorage.Modules.LogHelper)
local Knit = require(ReplicatedStorage.Packages.Knit)
-- local DistanceDetectClient = require(ReplicatedStorage.Modules.DistanceDetectClient)
local PlayerDataController = require(StarterPlayer.StarterPlayerScripts.Controllers.PlayerDataController)
local Constants = require(ReplicatedStorage.Modules.Constants)
local NotificationClient = require(ReplicatedStorage.Modules.NotificationClient)
local NumberUtil = require(ReplicatedStorage.Modules.NumberUtil)
local PurchaseDataHelper = require(ReplicatedFirst.DataHelpers.PurchaseDataHelper)
-- local CmdrClient = require(ReplicatedStorage.CmdrClient)
-- local CmdrClient = require(StarterPlayer.StarterPlayerScripts.CmdrClient)

local localPlayer = game.Players.LocalPlayer;

local ChatController = Knit.CreateController {
    Name = "ChatController",
}

function ChatController:Init()
    
end

function ChatController:OnPromptHoldBegan(promptObject, player)
    LogHelper.Print("OnPromptHoldBegan", promptObject.Name)
end

function ChatController:OnPromptTriggered(promptObject, player)
    LogHelper.Print("OnPromptTriggered", promptObject.Name)
end

function ChatController:OnPromptHoldEnded(promptObject, player)
    LogHelper.Print("onPromptHoldEnded", promptObject.Name)
end

function ChatController:KnitInit()
end

function ChatController:KnitStart()
    TextChatService.OnIncomingMessage = function(msg: TextChatMessage)
        local p = Instance.new("TextChatMessageProperties")

        if not msg.TextSource then return end
        local userId = msg.TextSource.UserId
        LogHelper.Print("userId", userId)

        local CharacterController = Knit.GetController("CharacterController")
        local tagText = CharacterController:GetTagText(userId)
        if tagText then
            p.PrefixText = tagText.." "..msg.PrefixText
        end
        return p
    end

    self:Init()

    local helloMessage = `<font color="rgb(247, 191, 52)" weight="Bold"> [SYSTEM] Welcome</font>\n<font color="rgb(255, 43, 44)" weight="Bold">If you enjoyed this game, don't forget to 👍 Like, ⭐️ Favorite and 🔔 Follow</font>`
    TextChatService:WaitForChild("TextChannels"):WaitForChild("RBXSystem"):DisplaySystemMessage(helloMessage)

    -- -- 使用TextChatService来监听聊天消息
    -- TextChatService.SendingMessage:Connect(function(textChatMessage)
    --     local text = textChatMessage.Text
    --     LogHelper.Print("发送的聊天消息:", text)
    --     if text:lower() == "cmdr" then
    --         -- 确保CmdrClient已经正确导入和初始化
    --         if CmdrClient then
    --             task.defer(function()
    --                 CmdrClient:Show()
    --             end)
    --         else
    --             warn("CmdrClient未定义或未正确初始化")
    --         end
    --     end
    -- end)
end

return ChatController