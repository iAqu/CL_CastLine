-- Saved by UniversalSynSaveInstance https://discord.gg/wx4ThpAsmw

-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2024-10-02 00:29:59
-- Luau version 6, Types version 3
-- Time taken: 0.000582 seconds

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local any_WaitBagNumberValue_result1_upvr = require(ReplicatedStorage.Tool.GetData).WaitBagNumberValue(game.Players.LocalPlayer, require(ReplicatedStorage.Tool.EnumMgr).ItemID.DinosaurHatch)
require(ReplicatedStorage.Tool.UIanima).RedPointAnim(script.Parent)
require(ReplicatedStorage.Tool.AddListen).NumValueAdd(any_WaitBagNumberValue_result1_upvr, function(arg1) -- Line 13, Named "updateRed"
	--[[ Upvalues[1]:
		[1]: any_WaitBagNumberValue_result1_upvr (readonly)
	]]
	if 0 < any_WaitBagNumberValue_result1_upvr.Value then
		script.Parent.Visible = true
	else
		script.Parent.Visible = false
	end
end)