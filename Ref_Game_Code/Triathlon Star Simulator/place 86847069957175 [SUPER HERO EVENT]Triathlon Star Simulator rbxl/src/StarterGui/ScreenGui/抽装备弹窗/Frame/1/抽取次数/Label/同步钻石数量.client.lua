-- Saved by UniversalSynSaveInstance https://discord.gg/wx4ThpAsmw

-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2024-10-02 00:29:38
-- Luau version 6, Types version 3
-- Time taken: 0.000573 seconds

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local MathMgr_upvr = require(ReplicatedStorage.Tool.MathMgr)
local Parent_upvr = script.Parent
local any_WaitBagNumberValue_result1 = require(ReplicatedStorage.Tool.GetData).WaitBagNumberValue(game.Players.LocalPlayer, require(ReplicatedStorage.Tool.EnumMgr).ItemID.HatchToolToken)
Parent_upvr.Text = MathMgr_upvr.getNumStr(math.floor(any_WaitBagNumberValue_result1.Value))
any_WaitBagNumberValue_result1.Changed:Connect(function(arg1) -- Line 15
	--[[ Upvalues[2]:
		[1]: Parent_upvr (readonly)
		[2]: MathMgr_upvr (readonly)
	]]
	Parent_upvr.Text = MathMgr_upvr.getNumStr(math.floor(arg1))
end)