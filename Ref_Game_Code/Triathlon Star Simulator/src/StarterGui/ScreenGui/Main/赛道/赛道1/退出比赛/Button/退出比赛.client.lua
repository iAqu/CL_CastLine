-- Saved by UniversalSynSaveInstance https://discord.gg/wx4ThpAsmw

-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2024-10-02 00:29:01
-- Luau version 6, Types version 3
-- Time taken: 0.000430 seconds

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RemoteFunction_upvr = ReplicatedStorage.Msg.RemoteFunction
require(ReplicatedStorage.Tool.AddListen).AddMouseCLick(script.Parent, function() -- Line 7
	--[[ Upvalues[1]:
		[1]: RemoteFunction_upvr (readonly)
	]]
	RemoteFunction_upvr:InvokeServer("退出比赛")
end, script.Parent.Parent)