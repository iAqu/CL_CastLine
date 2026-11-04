-- Saved by UniversalSynSaveInstance https://discord.gg/wx4ThpAsmw

-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2024-10-02 00:28:45
-- Luau version 6, Types version 3
-- Time taken: 0.000631 seconds

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Parent = script.Parent
local OnlyTag_upvr = Parent.OnlyTag
local any_FindCfgByOnlyTag_result1 = require(ReplicatedStorage.Tool.CfgFind).FindCfgByOnlyTag(OnlyTag_upvr.Value)
if not any_FindCfgByOnlyTag_result1 then
else
	local SystemBuyRoblox_upvr = require(ReplicatedStorage.System.SystemBuyRoblox)
	local LocalPlayer_upvr = game.Players.LocalPlayer
	require(ReplicatedStorage.Tool.AddListen).AddMouseCLick(Parent.Button, function() -- Line 21
		--[[ Upvalues[3]:
			[1]: SystemBuyRoblox_upvr (readonly)
			[2]: LocalPlayer_upvr (readonly)
			[3]: OnlyTag_upvr (readonly)
		]]
		SystemBuyRoblox_upvr.BuyRobloxByOnlyTag(LocalPlayer_upvr, OnlyTag_upvr.Value)
	end, Parent)
	require(ReplicatedStorage.Tool.TranslationHelper).SetText_UnTrans(Parent.PayName, 'x'..require(ReplicatedStorage.Tool.MathMgr).getNumStr(any_FindCfgByOnlyTag_result1.itemCount[1]))
end