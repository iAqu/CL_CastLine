-- Saved by UniversalSynSaveInstance https://discord.gg/wx4ThpAsmw

-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2024-10-02 00:23:42
-- Luau version 6, Types version 3
-- Time taken: 0.001953 seconds

local module = {}
local ReplicatedStorage_upvr = game:GetService("ReplicatedStorage")
local EnumMgr_upvr = require(ReplicatedStorage_upvr.Tool.EnumMgr)
function module.GetToolModelByName(arg1, arg2) -- Line 15
	--[[ Upvalues[2]:
		[1]: EnumMgr_upvr (readonly)
		[2]: ReplicatedStorage_upvr (readonly)
	]]
	if arg2 == EnumMgr_upvr.AniState.Swim then
		local SOME_7 = ReplicatedStorage_upvr.ModelRes.Avatar.Swim:FindFirstChild(arg1)
		if SOME_7 then
			return SOME_7
		end
	end
	if arg2 == EnumMgr_upvr.AniState.Ride then
		local SOME_5 = ReplicatedStorage_upvr.ModelRes.Avatar.Bike:FindFirstChild(arg1)
		if SOME_5 then
			return SOME_5
		end
	end
	if arg2 == EnumMgr_upvr.AniState.Run then
		local SOME_9 = ReplicatedStorage_upvr.ModelRes.Avatar.Shoe:FindFirstChild(arg1)
		if SOME_9 then
			return SOME_9
		end
	end
end
function module.GetModelCloneByModelName(arg1, arg2) -- Line 37
	--[[ Upvalues[2]:
		[1]: EnumMgr_upvr (readonly)
		[2]: ReplicatedStorage_upvr (readonly)
	]]
	if arg2 == EnumMgr_upvr.ItemType.Hero then
		local SOME_3 = ReplicatedStorage_upvr.ModelRes.Anime:FindFirstChild(arg1)
		if SOME_3 then
			return SOME_3:Clone()
		end
	end
	if arg2 == EnumMgr_upvr.ItemType.Weapon then
		local SOME_10 = ReplicatedStorage_upvr.ModelRes.ShowSword:FindFirstChild(arg1)
		if SOME_10 then
			return SOME_10:Clone()
		end
	end
	if arg2 == EnumMgr_upvr.ItemType.Coach then
		local SOME_8 = ReplicatedStorage_upvr.ModelRes.Coach:FindFirstChild(arg1)
		if SOME_8 then
			return SOME_8:Clone()
		end
	end
	return nil
end
return module