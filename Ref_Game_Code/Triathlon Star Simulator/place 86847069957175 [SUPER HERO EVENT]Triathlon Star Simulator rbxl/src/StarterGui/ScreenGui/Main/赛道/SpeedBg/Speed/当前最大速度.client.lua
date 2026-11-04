-- Saved by UniversalSynSaveInstance https://discord.gg/wx4ThpAsmw

-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2024-10-02 00:29:02
-- Luau version 6, Types version 3
-- Time taken: 0.000684 seconds

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Parent_upvr = script.Parent
local MathMgr_upvr = require(ReplicatedStorage.Tool.MathMgr)
require(ReplicatedStorage.Tool.AddListen).NumValueAdd(game.Players.LocalPlayer:WaitForChild("当前人物速度属性值", math.huge), function(arg1) -- Line 15
	--[[ Upvalues[2]:
		[1]: Parent_upvr (readonly)
		[2]: MathMgr_upvr (readonly)
	]]
	local var6 = arg1 * 2
	local NEVER_2 = Parent_upvr:FindFirstChild(1)
	if NEVER_2 then
		NEVER_2.Text = MathMgr_upvr.getNumStr(var6 * 1 / 2)
	end
	local NEVER = Parent_upvr:FindFirstChild(2)
	if NEVER then
		NEVER.Text = MathMgr_upvr.getNumStr(var6 * 2 / 2)
	end
end)