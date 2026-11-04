-- Saved by UniversalSynSaveInstance https://discord.gg/wx4ThpAsmw

-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2024-10-02 00:30:35
-- Luau version 6, Types version 3
-- Time taken: 0.001079 seconds

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local EnumMgr_upvr = require(ReplicatedStorage.Tool.EnumMgr)
local tbl_upvr = {
	[EnumMgr_upvr.Rare.Legendary] = "<font color='#ffaa00'>";
	[EnumMgr_upvr.Rare.Mysterious] = "<font color='#ff00ff'>";
	[EnumMgr_upvr.Rare.Immortal] = "<font color='#ff00ff'>";
	[EnumMgr_upvr.Rare.Secret] = "<font color='#9f0800'>";
}
local TextChatService_upvr = game:GetService("TextChatService")
local CfgFind_upvr = require(ReplicatedStorage.Tool.CfgFind)
local TranslationHelper_upvr = require(ReplicatedStorage.Tool.TranslationHelper)
local GradientsMgr_upvr = require(ReplicatedStorage.Tool.GradientsMgr)
ReplicatedStorage.Msg.SystemMsg.OnClientEvent:Connect(function(arg1) -- Line 21
	--[[ Upvalues[6]:
		[1]: TextChatService_upvr (readonly)
		[2]: CfgFind_upvr (readonly)
		[3]: EnumMgr_upvr (readonly)
		[4]: TranslationHelper_upvr (readonly)
		[5]: GradientsMgr_upvr (readonly)
		[6]: tbl_upvr (readonly)
	]]
	-- KONSTANTERROR: [0] 1. Error Block 1 start (CF ANALYSIS FAILED)
	local TextChannels = TextChatService_upvr:FindFirstChild("TextChannels")
	-- KONSTANTERROR: [0] 1. Error Block 1 end (CF ANALYSIS FAILED)
	-- KONSTANTERROR: [10] 8. Error Block 2 start (CF ANALYSIS FAILED)
	do
		return
	end
	-- KONSTANTERROR: [10] 8. Error Block 2 end (CF ANALYSIS FAILED)
	-- KONSTANTERROR: [11] 9. Error Block 3 start (CF ANALYSIS FAILED)
	-- KONSTANTERROR: [11] 9. Error Block 3 end (CF ANALYSIS FAILED)
end)