--获取服务
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players =game:GetService("Players")

--获取模组
local Knit = require(ReplicatedStorage.Packages.Knit)

local ChatService = Knit.CreateService {
	Name = "ChatService",
	Client = {
		SendChatNotice = Knit.CreateSignal(),
	},
}
--发送全服通知
function ChatService:SendChatNotice(message,color)
	for i,player in pairs(Players:GetPlayers()) do
		self.Client.SendChatNotice:Fire(player,message,color)	
	end
end

function ChatService:KnitInit()
end

function ChatService:KnitStart()
end

return ChatService
