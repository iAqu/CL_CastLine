-- Saved by UniversalSynSaveInstance https://discord.gg/wx4ThpAsmw

-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2024-10-02 00:29:48
-- Luau version 6, Types version 3
-- Time taken: 0.000446 seconds

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local SystemBuyRoblox_upvr = require(ReplicatedStorage.System.SystemBuyRoblox)
local LocalPlayer_upvr = game.Players.LocalPlayer
require(ReplicatedStorage.Tool.AddListen).AddMouseCLick(script.Parent, function() -- Line 8
	--[[ Upvalues[2]:
		[1]: SystemBuyRoblox_upvr (readonly)
		[2]: LocalPlayer_upvr (readonly)
	]]
	SystemBuyRoblox_upvr.BuyRobloxByOnlyTag(LocalPlayer_upvr, "HeroSlot1")
end, script.Parent)