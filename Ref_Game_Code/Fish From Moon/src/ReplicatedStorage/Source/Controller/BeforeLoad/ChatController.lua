--获取服务
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TextChatService = game:GetService("TextChatService")
--获取模组
local Knit = require(ReplicatedStorage.Packages.Knit)

local ChatService

local textChannel = TextChatService:FindFirstChild("TextChannels"):FindFirstChild("RBXGeneral")

local ChatController = Knit.CreateController { Name = "ChatController" }

local function color3ToHex(color)
	local r = math.floor(color.R * 255)
	local g = math.floor(color.G * 255)
	local b = math.floor(color.B * 255)
	return string.format("#%02X%02X%02X", r, g, b)
end

--发送全服通知
local function sendChatNotice(sendText,color)
	local colorHex = color3ToHex(color)

	local coloredMessage = string.format('<font color="%s">%s</font>', colorHex, sendText)

	textChannel:DisplaySystemMessage(coloredMessage)
end

function ChatController:KnitInit()
	ChatService = Knit.GetService("ChatService")
end

function ChatController:KnitStart()
	ChatService.SendChatNotice:Connect(sendChatNotice)
end

return ChatController