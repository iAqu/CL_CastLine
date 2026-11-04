-- Saved by UniversalSynSaveInstance https://discord.gg/wx4ThpAsmw

-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2024-10-02 00:28:28
-- Luau version 6, Types version 3
-- Time taken: 0.000707 seconds

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ____________ = ReplicatedStorage["游戏全局配置"]["好友加成"]
local Value_upvr = ____________["单个好友加成"].Value
local Value_upvr_2 = ____________["上限"].Value
local TranslationHelper_upvr = require(ReplicatedStorage.Tool.TranslationHelper)
local Add_upvr = script.Parent:FindFirstChild("Add")
require(ReplicatedStorage.Tool.AddListen).NumValueAdd(game:GetService("Players").LocalPlayer:WaitForChild("FriendOnlineNum", math.huge), function(arg1) -- Line 20
	--[[ Upvalues[4]:
		[1]: Value_upvr (readonly)
		[2]: Value_upvr_2 (readonly)
		[3]: TranslationHelper_upvr (readonly)
		[4]: Add_upvr (readonly)
	]]
	local var8 = arg1 * Value_upvr
	if Value_upvr_2 <= var8 then
		var8 = Value_upvr_2
	end
	TranslationHelper_upvr.SetText(Add_upvr, "好友加成", {tostring(var8)})
end)