-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local TextChatService = game:GetService("TextChatService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local Attributes = require(ReplicatedStorage.Shared.Data.Attributes)
Random.new()
local RBXGeneral = TextChatService:WaitForChild("TextChannels").RBXGeneral
function OnIncomingMessage(p1) --[[ OnIncomingMessage | Line: 15 | Upvalues: Players (copy), Attributes (copy) ]]
	local TextChatMessageProperties = Instance.new("TextChatMessageProperties")
	if p1.TextSource then
		local v1 = "" and v1 .. "[<font color = \'#FFD700\'>VIP</font>] "
		if p1.TextSource and v1 ~= "" then
			TextChatMessageProperties.PrefixText = ("%*%*"):format(v1, p1.PrefixText)
		end
		return TextChatMessageProperties
	end
end
TextChatService.OnIncomingMessage = OnIncomingMessage