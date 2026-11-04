-- Saved by UniversalSynSaveInstance https://discord.gg/wx4ThpAsmw

-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2024-10-02 00:26:02
-- Luau version 6, Types version 3
-- Time taken: 0.000458 seconds

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RemoteEvent_upvr = ReplicatedStorage.Msg.RemoteEvent
require(ReplicatedStorage.Tool.AddListen).AddMouseCLick(script.Parent, function() -- Line 7
	--[[ Upvalues[1]:
		[1]: RemoteEvent_upvr (readonly)
	]]
	RemoteEvent_upvr:FireServer("增加挡位")
end, script.Parent, "音效-场景-点击-通用点击")