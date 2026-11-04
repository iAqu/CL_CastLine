-- Saved by UniversalSynSaveInstance https://discord.gg/wx4ThpAsmw

-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2024-10-02 00:25:48
-- Luau version 6, Types version 3
-- Time taken: 0.001650 seconds

local module = {}
local AnimationModule_upvr = require(game.ReplicatedStorage.Tool.AnimationModule)
function module.SetAnim(arg1, arg2, arg3, arg4, arg5, arg6) -- Line 26
	--[[ Upvalues[1]:
		[1]: AnimationModule_upvr (readonly)
	]]
	local Animation = Instance.new("Animation")
	local any_GetAnimID_result1 = AnimationModule_upvr.GetAnimID(arg4)
	if not any_GetAnimID_result1 then
		warn("AI do not find animation ID!")
	else
		Animation.AnimationId = "http://www.roblox.com/asset/?id="..any_GetAnimID_result1
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
	end
end
function module.Init(arg1, arg2, arg3) -- Line 48
	-- KONSTANTWARNING: Variable analysis failed. Output will have some incorrect variable assignments
	arg1.allAnim = {}
	local var7
	if arg3 and arg3.Running then
		var7 = arg3.Running
		local var8
	end
	if arg3 and arg3.Idle then
		var8 = arg3.Idle
	end
	arg1:SetAnim(arg2, "Walk", var7, Enum.AnimationPriority.Movement, true)
	arg1:SetAnim(arg2, "Idle", var8, Enum.AnimationPriority.Idle, true)
	arg1:SetAnim(arg2, "Run", arg3.Running, Enum.AnimationPriority.Movement, true)
end
function module.Play(arg1, arg2) -- Line 73
	local var9 = arg1.allAnim[arg2]
	if var9.isPlay == false then
		var9.track:Play(0, 1, 1)
		var9.isPlay = true
	end
end
function module.PlayNow(arg1, arg2) -- Line 82
	local var10 = arg1.allAnim[arg2]
	var10.track:Play(0, 1, 1)
	var10.isPlay = true
end
function module.Stop(arg1, arg2) -- Line 88
	local var11 = arg1.allAnim[arg2]
	if var11.isPlay then
		var11.track:Stop()
		var11.isPlay = false
	end
end
return module