-- Saved by UniversalSynSaveInstance https://discord.gg/wx4ThpAsmw

-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2024-10-02 00:25:46
-- Luau version 6, Types version 3
-- Time taken: 0.002670 seconds

local module = {
	allAnim = {};
	animator = nil;
	SetAnim = function(arg1, arg2, arg3, arg4, arg5, arg6) -- Line 37, Named "SetAnim"
		local Animation = Instance.new("Animation")
		Animation.AnimationId = "http://www.roblox.com/asset/?id="..arg4
		Animation.Name = arg4
		local any_LoadAnimation_result1 = arg2:LoadAnimation(Animation)
		any_LoadAnimation_result1.Priority = arg5
		any_LoadAnimation_result1.Looped = arg6
		local tbl = {}
		tbl.name = arg3
		tbl.isPlay = false
		tbl.animation = Animation
		tbl.track = any_LoadAnimation_result1
		arg1.allAnim[arg3] = tbl
		arg1.animator = arg2
	end;
	Clear = function(arg1) -- Line 65, Named "Clear"
		for _, v in pairs(arg1.allAnim) do
			if v.animation then
				v.animation:Destroy()
			end
			v.animation = nil
			if v.track then
				v.track:Destroy()
			end
			v.track = nil
		end
		arg1.allAnim = {}
		if arg1.animator then
			arg1.animator:Destroy()
			arg1.animator = nil
		end
	end;
}
local AnimationModule_upvr = require(game.ReplicatedStorage.Tool.AnimationModule)
function module.Init(arg1, arg2) -- Line 89
	--[[ Upvalues[1]:
		[1]: AnimationModule_upvr (readonly)
	]]
	arg1.allAnim = {}
	arg1:SetAnim(arg2, "Walk", AnimationModule_upvr.GetAnimID("战斗奔跑"), Enum.AnimationPriority.Movement, true)
	arg1:SetAnim(arg2, "Idle", AnimationModule_upvr.GetAnimID("战斗待机"), Enum.AnimationPriority.Idle, true)
	arg1:SetAnim(arg2, "Run", AnimationModule_upvr.GetAnimID("战斗奔跑"), Enum.AnimationPriority.Movement, true)
end
function module.Play(arg1, arg2) -- Line 102
	local var11 = arg1.allAnim[arg2]
	if var11.isPlay == false then
		local track_3 = var11.track
		track_3:Play(track_3.Length * 1 * 0.2, 1, 1)
		var11.isPlay = true
	end
end
function module.PlayRun(arg1) -- Line 112
	local Run = arg1.allAnim.Run
	if Run.isPlay == false then
		local track_2 = Run.track
		track_2:Play(track_2.Length * 1 * 0.2, 1, 1)
		Run.isPlay = true
	end
	arg1:Stop("Walk")
end
function module.PlayWalk(arg1) -- Line 124
	local Walk = arg1.allAnim.Walk
	if Walk.isPlay == false then
		local track = Walk.track
		track:Play(track.Length * 1 * 0.2, 1, 1)
		Walk.isPlay = true
	end
	arg1:Stop("Run")
end
function module.PlayNow(arg1, arg2) -- Line 137
	local var17 = arg1.allAnim[arg2]
	var17.track:Play()
	var17.isPlay = true
end
function module.Stop(arg1, arg2) -- Line 144
	local var18 = arg1.allAnim[arg2]
	if var18.isPlay then
		var18.track:Stop()
		var18.isPlay = false
	end
end
return module