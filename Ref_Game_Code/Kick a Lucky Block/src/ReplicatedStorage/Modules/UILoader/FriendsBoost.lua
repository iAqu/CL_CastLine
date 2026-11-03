-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local StarterGui = game:GetService("StarterGui")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local SocialService = game:GetService("SocialService")
local FriendBoostServiceClient = require(ReplicatedStorage.Modules.ServicesLoader.FriendBoostServiceClient)
local FriendsBoostConfig = require(ReplicatedStorage.Shared.Config.FriendsBoostConfig)
local LocalPlayer = game:GetService("Players").LocalPlayer
local PlayerGui = LocalPlayer.PlayerGui
local v1 = PlayerGui:FindFirstChild("HUD") or PlayerGui:WaitForChild("HUD")
local t = {}
function UpdateBoost(p1) --[[ UpdateBoost | Line: 24 | Upvalues: FriendsBoostConfig (copy), v1 (copy) ]]
	v1.BottomLeft.FriendsBoost.FriendsLabel.Text = ("Friends Boost: %s Coins"):format((("%*%%"):format((math.min(#p1 * FriendsBoostConfig.MULTIPLIER_PER_FRIEND, FriendsBoostConfig.MAX_MULTIPLIER)))))
end
function Prompt(p1) --[[ Prompt | Line: 30 | Upvalues: StarterGui (copy) ]]
	pcall(function() --[[ Line: 31 | Upvalues: StarterGui (ref), p1 (copy) ]]
		StarterGui:SetCore("PromptSendFriendRequest", p1)
	end)
end
function PromptFriendRequest() --[[ PromptFriendRequest | Line: 36 | Upvalues: Players (copy), LocalPlayer (copy), FriendBoostServiceClient (copy), SocialService (copy) ]]
	for i, v in ipairs((Players:GetPlayers())) do
		if v ~= LocalPlayer and not table.find(FriendBoostServiceClient.Friends, v.UserId) then
			Prompt(v)
			return
		end
	end
	SocialService:PromptGameInvite(LocalPlayer)
end
function InitButton() --[[ InitButton | Line: 51 | Upvalues: v1 (copy) ]]
	v1.LeftPanel.Friends.Activated:Connect(PromptFriendRequest)
end
function t._init() --[[ _init | Line: 56 | Upvalues: FriendBoostServiceClient (copy) ]]
	InitButton()
	UpdateBoost(FriendBoostServiceClient.Friends)
	FriendBoostServiceClient.Changed:Connect(UpdateBoost)
end
return t