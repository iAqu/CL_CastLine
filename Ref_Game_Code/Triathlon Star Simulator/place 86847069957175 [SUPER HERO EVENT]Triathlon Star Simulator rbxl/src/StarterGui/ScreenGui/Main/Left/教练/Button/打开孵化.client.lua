-- Saved by UniversalSynSaveInstance https://discord.gg/wx4ThpAsmw

-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2024-10-02 00:28:21
-- Luau version 6, Types version 3
-- Time taken: 0.000522 seconds

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local showLocalUI_upvr = ReplicatedStorage.LocalMsg.showLocalUI
local LocalData_upvr = require(game.StarterPlayer.StarterPlayerScripts.LocalData)
require(ReplicatedStorage.Tool.AddListen).AddMouseCLick(script.Parent, function() -- Line 11
	--[[ Upvalues[2]:
		[1]: showLocalUI_upvr (readonly)
		[2]: LocalData_upvr (readonly)
	]]
	showLocalUI_upvr:Fire("教练", LocalData_upvr:GetLocalData())
end, script.Parent.Parent)