-- Saved by UniversalSynSaveInstance https://discord.gg/wx4ThpAsmw

-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2024-10-02 00:28:59
-- Luau version 6, Types version 3
-- Time taken: 0.000578 seconds

local ServerUtil = require(game.ReplicatedStorage.ServerUtil)
local EnumMgr_upvr = require(game.ReplicatedStorage.Tool.EnumMgr)
ServerUtil.AddListen.NumValueAdd(ServerUtil.Players.LocalPlayer:WaitForChild("运动状态", math.huge), function(arg1) -- Line 8
	--[[ Upvalues[1]:
		[1]: EnumMgr_upvr (readonly)
	]]
	local script = script
	if arg1 == EnumMgr_upvr.AniState.Safe then
		script = false
	else
		script = true
	end
	script.Parent.Visible = script
end)