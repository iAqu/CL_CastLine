-- Saved by UniversalSynSaveInstance https://discord.gg/wx4ThpAsmw

-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2024-10-02 00:29:04
-- Luau version 6, Types version 3
-- Time taken: 0.000993 seconds

local ReplicatedStorage = game.ReplicatedStorage
local CfgFind_upvr = require(ReplicatedStorage.Tool.CfgFind)
local EnumMgr_upvr = require(ReplicatedStorage.Tool.EnumMgr)
local TranslationHelper_upvr = require(ReplicatedStorage.Tool.TranslationHelper)
require(ReplicatedStorage.Tool.AddListen).NumValueAdd(game.Players.LocalPlayer:WaitForChild("运动状态", math.huge), function(arg1) -- Line 11
	--[[ Upvalues[3]:
		[1]: CfgFind_upvr (readonly)
		[2]: EnumMgr_upvr (readonly)
		[3]: TranslationHelper_upvr (readonly)
	]]
	local any_FindCfgByID_result1 = CfgFind_upvr.FindCfgByID(EnumMgr_upvr.ItemID.Attr_1 + arg1)
	if arg1 == -1 then
		any_FindCfgByID_result1 = CfgFind_upvr.FindCfgByID(EnumMgr_upvr.ItemID.Attr_3)
	end
	if any_FindCfgByID_result1 then
		script.Parent.Image = "rbxassetid://"..any_FindCfgByID_result1.Icon
		if arg1 == EnumMgr_upvr.AniState.Swim then
			TranslationHelper_upvr.SetText(script.Parent.Value, "游泳中")
		end
		if arg1 == EnumMgr_upvr.AniState.Run or arg1 == EnumMgr_upvr.AniState.Safe then
			TranslationHelper_upvr.SetText(script.Parent.Value, "跑步中")
		end
		if arg1 == EnumMgr_upvr.AniState.Ride then
			TranslationHelper_upvr.SetText(script.Parent.Value, "骑行中")
		end
	end
end)