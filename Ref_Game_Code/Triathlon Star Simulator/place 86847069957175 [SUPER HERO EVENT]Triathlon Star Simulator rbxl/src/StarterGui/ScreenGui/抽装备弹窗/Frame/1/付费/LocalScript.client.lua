-- Saved by UniversalSynSaveInstance https://discord.gg/wx4ThpAsmw

-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2024-10-02 00:29:39
-- Luau version 6, Types version 3
-- Time taken: 0.001118 seconds

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TranslationHelper = require(ReplicatedStorage.Tool.TranslationHelper)
for _, v in pairs(script.Parent:GetChildren()) do
	if v:IsA("Frame") then
		local var8_upvr = "HatchTool_"..v.Name
		local any_FindCfgByOnlyTag_result1 = require(ReplicatedStorage.Tool.CfgFind).FindCfgByOnlyTag(var8_upvr)
		if any_FindCfgByOnlyTag_result1 then
			TranslationHelper.SetText_UnTrans(v.PayName, 'x'..any_FindCfgByOnlyTag_result1.itemCount[1])
			TranslationHelper.SetText_UnTrans(v.Price, any_FindCfgByOnlyTag_result1.price..'R')
		end
		local SystemBuyRoblox_upvr = require(ReplicatedStorage.System.SystemBuyRoblox)
		local LocalPlayer_upvr = game.Players.LocalPlayer
		require(ReplicatedStorage.Tool.AddListen).AddMouseCLick(v.Button, function() -- Line 42
			--[[ Upvalues[3]:
				[1]: SystemBuyRoblox_upvr (readonly)
				[2]: LocalPlayer_upvr (readonly)
				[3]: var8_upvr (readonly)
			]]
			SystemBuyRoblox_upvr.BuyRobloxByOnlyTag(LocalPlayer_upvr, var8_upvr)
		end, v)
	end
end