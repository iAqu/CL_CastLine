-- Saved by UniversalSynSaveInstance https://discord.gg/wx4ThpAsmw

-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2024-10-02 00:29:53
-- Luau version 6, Types version 3
-- Time taken: 0.000594 seconds

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local OnlyID_upvr = script.Parent.Parent.Parent.Parent:FindFirstChild("OnlyID")
local RemoteEvent_upvr = ReplicatedStorage.Msg.RemoteEvent
local ShowDetail_upvr = require(ReplicatedStorage.Tool.ShowDetail)
require(ReplicatedStorage.Tool.AddListen).AddMouseCLick(script.Parent, function() -- Line 9
	--[[ Upvalues[3]:
		[1]: OnlyID_upvr (readonly)
		[2]: RemoteEvent_upvr (readonly)
		[3]: ShowDetail_upvr (readonly)
	]]
	local Value = OnlyID_upvr.Value
	if Value then
		RemoteEvent_upvr:FireServer("装备宠物", Value)
	end
	ShowDetail_upvr.HideAllDetail()
end, script.Parent.Parent)