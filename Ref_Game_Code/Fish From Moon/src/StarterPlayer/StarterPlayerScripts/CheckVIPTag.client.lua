local TextChatService = game:GetService("TextChatService")
local Players = game:GetService("Players")

local player = Players.LocalPlayer

TextChatService.OnIncomingMessage = function(message: TextChatMessage)
	if not message.TextSource then
		return
	end
	local properties = Instance.new("TextChatMessageProperties")
	local player = Players:GetPlayerByUserId(message.TextSource.UserId)

	local haveVIP = player:GetAttribute("VIP")
	if haveVIP then
		properties.PrefixText = "<font color='#ff0000'>[VIP]</font> " .. message.PrefixText
	end
	
	return properties
end