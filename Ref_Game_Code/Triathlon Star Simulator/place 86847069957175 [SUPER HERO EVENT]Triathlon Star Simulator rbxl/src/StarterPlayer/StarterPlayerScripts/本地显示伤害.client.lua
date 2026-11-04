-- Saved by UniversalSynSaveInstance https://discord.gg/wx4ThpAsmw

-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2024-10-02 00:30:42
-- Luau version 6, Types version 3
-- Time taken: 0.001029 seconds

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local MathMgr_upvr = require(game.ReplicatedStorage.Tool.MathMgr)
local DmgAni_upvr = require(ReplicatedStorage.Tool.DmgAni)
local function _(arg1, arg2, arg3, arg4) -- Line 18, Named "showDmg"
	--[[ Upvalues[2]:
		[1]: MathMgr_upvr (readonly)
		[2]: DmgAni_upvr (readonly)
	]]
	local ceiled = math.ceil(arg1)
	if ceiled <= 0 then
	else
		DmgAni_upvr.start(arg2, '-'..MathMgr_upvr.getNumStr(ceiled), arg3, arg4)
	end
end
local function _(arg1, arg2) -- Line 32, Named "showHpAdd"
	--[[ Upvalues[2]:
		[1]: MathMgr_upvr (readonly)
		[2]: DmgAni_upvr (readonly)
	]]
	local floored = math.floor(arg1)
	if floored <= 0 then
	else
		DmgAni_upvr.startHpAdd(arg2, '+'..MathMgr_upvr.getNumStr(floored))
	end
end
ReplicatedStorage.ClientMsg.ShowDmgPlr.OnClientEvent:Connect(function(arg1, arg2, arg3, arg4) -- Line 46
	--[[ Upvalues[2]:
		[1]: MathMgr_upvr (readonly)
		[2]: DmgAni_upvr (readonly)
	]]
	local ceiled_2 = math.ceil(arg1)
	if ceiled_2 <= 0 then
	else
		DmgAni_upvr.start(arg2, '-'..MathMgr_upvr.getNumStr(ceiled_2), arg3, arg4)
	end
end)