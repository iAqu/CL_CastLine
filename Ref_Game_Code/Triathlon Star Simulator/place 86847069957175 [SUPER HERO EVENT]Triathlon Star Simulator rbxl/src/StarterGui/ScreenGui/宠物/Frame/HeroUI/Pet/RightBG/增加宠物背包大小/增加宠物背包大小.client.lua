-- Saved by UniversalSynSaveInstance https://discord.gg/wx4ThpAsmw

-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2024-10-02 00:29:45
-- Luau version 6, Types version 3
-- Time taken: 0.000531 seconds

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CheckGamePass_upvr = require(ReplicatedStorage.Tool.CheckGamePass)
local LocalPlayer_upvr = game.Players.LocalPlayer
local SystemBuyRoblox_upvr = require(ReplicatedStorage.System.SystemBuyRoblox)
require(ReplicatedStorage.Tool.AddListen).AddMouseCLick(script.Parent, function() -- Line 8
	--[[ Upvalues[3]:
		[1]: CheckGamePass_upvr (readonly)
		[2]: LocalPlayer_upvr (readonly)
		[3]: SystemBuyRoblox_upvr (readonly)
	]]
	if not CheckGamePass_upvr.IsHasPass(LocalPlayer_upvr, "HeroesStorage1") then
		SystemBuyRoblox_upvr.BuyRobloxByOnlyTag(LocalPlayer_upvr, "HeroesStorage1")
		return
	end
end, script.Parent)