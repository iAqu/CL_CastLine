-- Saved by UniversalSynSaveInstance https://discord.gg/wx4ThpAsmw

-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2024-10-02 00:25:49
-- Luau version 6, Types version 3
-- Time taken: 0.002387 seconds

local module = {}
local AnimationModule_upvr = require(game.ReplicatedStorage.Tool.AnimationModule)
function module.SetAnim(arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8) -- Line 34
	--[[ Upvalues[1]:
		[1]: AnimationModule_upvr (readonly)
	]]
	local Animation = Instance.new("Animation")
	local any_GetAnimID_result1 = AnimationModule_upvr.GetAnimID(arg4)
	if not any_GetAnimID_result1 then
		warn("AI do not find animation ID!", arg4)
	else
		Animation.AnimationId = "http://www.roblox.com/asset/?id="..any_GetAnimID_result1
		Animation.Name = arg4
		local any_LoadAnimation_result1 = arg2:LoadAnimation(Animation)
		any_LoadAnimation_result1.Priority = arg5
		any_LoadAnimation_result1.Looped = arg6
		if arg7 then
			local function _(arg1_2) -- Line 50
				--[[ Upvalues[1]:
					[1]: arg8 (readonly)
				]]
				arg8()
			end
		end
		local tbl = {}
		tbl.name = arg3
		tbl.isPlay = false
		tbl.animation = Animation
		tbl.track = any_LoadAnimation_result1
		arg1.allAnim[arg3] = tbl
	end
end
local CfgFind_upvr = require(game.ReplicatedStorage.Tool.CfgFind)
local EnumMgr_upvr = require(game.ReplicatedStorage.Tool.EnumMgr)
local 教练特效_upvr = require(game.ReplicatedStorage.Tool["教练特效"])
function module.Init(arg1, arg2, arg3, arg4) -- Line 64
	--[[ Upvalues[3]:
		[1]: CfgFind_upvr (readonly)
		[2]: EnumMgr_upvr (readonly)
		[3]: 教练特效_upvr (readonly)
	]]
	arg1.allAnim = {}
	local var11
	if next(arg3) and arg3.EncourageAction then
		var11 = arg3.EncourageAction
	end
	arg1:SetAnim(arg2, "Walk", "行走", Enum.AnimationPriority.Movement, true)
	arg1:SetAnim(arg2, "Idle", "待机", Enum.AnimationPriority.Idle, true)
	arg1:SetAnim(arg2, "Run", "战斗奔跑", Enum.AnimationPriority.Movement, true)
	arg1:SetAnim(arg2, "Encourage", var11, Enum.AnimationPriority.Action4, true, "开始", function() -- Line 79
		--[[ Upvalues[4]:
			[1]: arg4 (readonly)
			[2]: CfgFind_upvr (copied, readonly)
			[3]: EnumMgr_upvr (copied, readonly)
			[4]: 教练特效_upvr (copied, readonly)
		]]
		local any_FindCfgByID_result1 = CfgFind_upvr.FindCfgByID(arg4:GetAttribute("ID"), EnumMgr_upvr.ItemType.Coach)
		if any_FindCfgByID_result1 then
			教练特效_upvr.PlayEffect(arg4, any_FindCfgByID_result1.ZhName)
		end
	end)
end
function module.Play(arg1, arg2) -- Line 95
	local var14 = arg1.allAnim[arg2]
	if var14.isPlay == false then
		local track_2 = var14.track
		track_2:Play(track_2.Length * 1 * 0.2, 1, 1)
		var14.isPlay = true
	end
end
function module.PlayNow(arg1, arg2) -- Line 104
	local var16 = arg1.allAnim[arg2]
	local track = var16.track
	track:Play(track.Length * 1 * 0.2, 1, 1)
	var16.isPlay = true
end
function module.Stop(arg1, arg2) -- Line 110
	local var18 = arg1.allAnim[arg2]
	if var18.isPlay then
		var18.track:Stop()
		var18.isPlay = false
	end
end
return module