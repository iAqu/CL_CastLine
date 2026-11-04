-- Saved by UniversalSynSaveInstance https://discord.gg/wx4ThpAsmw

-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2024-10-02 00:27:41
-- Luau version 6, Types version 3
-- Time taken: 0.000428 seconds

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RemoteEvent_upvr = ReplicatedStorage.Msg.RemoteEvent
local ShowDetail_upvr = require(ReplicatedStorage.Tool.ShowDetail)
require(ReplicatedStorage.Tool.AddListen).AddMouseCLick(script.Parent, function() -- Line 9
	--[[ Upvalues[2]:
		[1]: RemoteEvent_upvr (readonly)
		[2]: ShowDetail_upvr (readonly)
	]]
	RemoteEvent_upvr:FireServer("装备最佳装备")
	ShowDetail_upvr.HideAllDetail()
end, script.Parent.Parent)