-- Saved by UniversalSynSaveInstance https://discord.gg/wx4ThpAsmw

-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2024-10-02 00:26:36
-- Luau version 6, Types version 3
-- Time taken: 0.000757 seconds

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CfgFind_upvr = require(ReplicatedStorage.Tool.CfgFind)
local EnumMgr_upvr = require(ReplicatedStorage.Tool.EnumMgr)
local HatchEffect_upvr = require(ReplicatedStorage.Tool.HatchEffect)
script.Parent.MouseButton1Click:Connect(function() -- Line 10
	--[[ Upvalues[3]:
		[1]: CfgFind_upvr (readonly)
		[2]: EnumMgr_upvr (readonly)
		[3]: HatchEffect_upvr (readonly)
	]]
	for _, v in pairs(CfgFind_upvr.FindCfgByID(script.Parent.Parent.Parent["背包系统"]["道具ID"].Text, EnumMgr_upvr.ItemType.Egg).ItemIDVt) do
		HatchEffect_upvr.ShowItemEffect({v}, true)
		wait(1)
	end
end)