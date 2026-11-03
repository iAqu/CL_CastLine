-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local TextChatService = game:GetService("TextChatService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local Replion = require(ReplicatedStorage.Packages.Replion)
require(ReplicatedStorage.Packages.Net)
local ChatTags = require(ReplicatedStorage.Shared.ChatTags)
require(ReplicatedStorage.Shared.Leaderboards)
require(ReplicatedStorage.Shared.TierUtility):GetTierFromRarity(2e-6)
local LocalPlayer = Players.LocalPlayer
local t = {}
function t.Init(p1) --[[ Init | Line: 26 | Upvalues: TextChatService (copy), Players (copy), t (copy) ]]
	function TextChatService.OnIncomingMessage(p1) --[[ Line: 63 | Upvalues: Players (ref), t (ref) ]]
		local TextChatMessageProperties = Instance.new("TextChatMessageProperties")
		if p1.TextSource then
			local UserId = p1.TextSource.UserId
			local v1 = Players:GetPlayerByUserId(UserId)
			local v2 = if v1 then t:_getChatTag(v1) else v1
			if v2 then
				local v3 = v2.TagColor:ToHex()
				local v4, v5, v6 = v2.TagColor:ToHSV()
				local v7 = Color3.fromHSV(v4, v5 * 0.3, v6):ToHex()
				TextChatMessageProperties.PrefixText = ("<b><font color=\"#%*\">%*</font></b> "):format(v3, v2.Tag)
				TextChatMessageProperties.Text = ("<font color=\"#%*\">%*</font>"):format(v7, p1.Text)
			end
			if TopFishLeaderboard then
				local v8 = TopFishLeaderboard:Find("OrderedUserIds", UserId)
				if v8 then
					TextChatMessageProperties.PrefixText = TextChatMessageProperties.PrefixText .. ("<font color=\"#ffba26\">[#%*]</font> "):format(v8)
				end
			end
			TextChatMessageProperties.PrefixText = TextChatMessageProperties.PrefixText .. p1.PrefixText
		end
		return TextChatMessageProperties
	end
end
function t.Start(p1) --[[ Start | Line: 94 | Upvalues: Replion (copy), TextChatService (copy) ]]
	Replion.Client:AwaitReplion("Data", function(p1) --[[ Line: 95 | Upvalues: TextChatService (ref) ]]
		local RBXGeneral = TextChatService:WaitForChild("TextChannels"):WaitForChild("RBXGeneral")
		RBXGeneral:DisplaySystemMessage("<b><font size=\"20\" color=\"rgb(69, 255, 112)\">Welcome! </font></b>Please report any \240\159\144\158 bugs you find in our group")
		RBXGeneral:DisplaySystemMessage("<b><font size=\"18\" color=\"rgb(112, 236, 255)\">[Tip]: </font></b>Start your adventure by equipping your Fishing Rod! Click, hold and release to begin!")
	end)
	TopFishLeaderboard = Replion.Client:WaitReplion("Monthly Caught Fish")
end
function t._getChatTag(p1, p2) --[[ _getChatTag | Line: 110 | Upvalues: ChatTags (copy) ]]
	for i, v in ipairs(ChatTags) do
		if v.PlayerCondition then
			if v.PlayerCondition(p2) then
				return v
			end
			continue
		end
		if p2:GetAttribute(v.PlayerAttribute) then
			return v
		end
	end
end
return t