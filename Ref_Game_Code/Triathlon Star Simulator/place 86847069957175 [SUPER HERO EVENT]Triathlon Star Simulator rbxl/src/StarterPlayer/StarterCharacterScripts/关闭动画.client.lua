-- Saved by UniversalSynSaveInstance https://discord.gg/wx4ThpAsmw

-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2024-10-02 00:31:27
-- Luau version 6, Types version 3
-- Time taken: 0.000621 seconds

local ServerUtil_upvr = require(game.ReplicatedStorage.ServerUtil)
local Parent_upvr = script.Parent
local var4_upvw
local 自行车动画表现_upvr = require(game.ReplicatedStorage.Tool["自行车动画表现"])
ServerUtil_upvr.AddListen.NumValueAdd(game.Players.LocalPlayer:WaitForChild("运动状态", math.huge), function(arg1) -- Line 13
	--[[ Upvalues[4]:
		[1]: ServerUtil_upvr (readonly)
		[2]: var4_upvw (read and write)
		[3]: 自行车动画表现_upvr (readonly)
		[4]: Parent_upvr (readonly)
	]]
	if arg1 == ServerUtil_upvr.EnumMgr.AniState.Ride then
	end
	if var4_upvw == ServerUtil_upvr.EnumMgr.AniState.Ride then
		自行车动画表现_upvr.DisableBike(Parent_upvr)
	end
	var4_upvw = arg1
end)