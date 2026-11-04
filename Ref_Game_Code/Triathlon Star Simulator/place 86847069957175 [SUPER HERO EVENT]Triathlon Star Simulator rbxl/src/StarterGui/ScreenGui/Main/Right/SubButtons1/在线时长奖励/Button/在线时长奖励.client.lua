-- Saved by UniversalSynSaveInstance https://discord.gg/wx4ThpAsmw

-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2024-10-02 00:28:42
-- Luau version 6, Types version 3
-- Time taken: 0.000429 seconds

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local showLocalUI_upvr = ReplicatedStorage.LocalMsg.showLocalUI
require(ReplicatedStorage.Tool.AddListen).AddMouseCLick(script.Parent, function() -- Line 6
	--[[ Upvalues[1]:
		[1]: showLocalUI_upvr (readonly)
	]]
	showLocalUI_upvr:Fire("在线时长奖励", nil, true)
end, script.Parent.Parent.Frame)