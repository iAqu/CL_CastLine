-- Saved by UniversalSynSaveInstance https://discord.gg/wx4ThpAsmw

-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2024-10-02 00:24:48
-- Luau version 6, Types version 3
-- Time taken: 0.002085 seconds

local module = {}
local RunService_upvr = game:GetService("RunService")
function module.Run_Timeline(arg1) -- Line 21
	--[[ Upvalues[1]:
		[1]: RunService_upvr (readonly)
	]]
	local tbl_upvr = {}
	for i, _ in pairs(arg1) do
		tbl_upvr[i] = false
	end
	local var12_upvw = 0
	local var13_upvw
	var13_upvw = RunService_upvr.RenderStepped:Connect(function(arg1_2) -- Line 33
		--[[ Upvalues[4]:
			[1]: arg1 (readonly)
			[2]: tbl_upvr (readonly)
			[3]: var12_upvw (read and write)
			[4]: var13_upvw (read and write)
		]]
		local _, pairs_result2_2, pairs_result3 = pairs(arg1)
		local var25
		for i_2, v_2 in var25, pairs_result2_2, pairs_result3 do
			if tbl_upvr[i_2] == false and v_2.StartTimePoint <= var12_upvw and v_2.Func then
				v_2.Func()
				tbl_upvr[i_2] = true
			end
		end
		var25 = true
		for _, v_3 in pairs(tbl_upvr) do
			if v_3 == false then
				var25 = false
			end
		end
		if var25 then
			var13_upvw:Disconnect()
			var13_upvw = nil
		else
			var12_upvw += arg1_2
		end
	end)
end
local AnimationModule_upvr = require(game:GetService("ReplicatedStorage").Tool.AnimationModule)
function module.Run_Animation(arg1) -- Line 83
	--[[ Upvalues[1]:
		[1]: AnimationModule_upvr (readonly)
	]]
	local AnimationName = arg1.AnimationName
	local AnimationSpeed = arg1.AnimationSpeed
	local AnimationLooped = arg1.AnimationLooped
	local AnimationPriority = arg1.AnimationPriority
	local KeyPointName = arg1.KeyPointName
	local KeyPointFunc = arg1.KeyPointFunc
	local AnimationModel = arg1.AnimationModel
	local var37
	if AnimationModel then
		var37 = AnimationModel:FindFirstChildOfClass("Humanoid")
		if not var37 then
			var37 = AnimationModel:FindFirstChildOfClass("AnimationController")
		end
		if var37 then
			local class_Animator = var37:FindFirstChildOfClass("Animator")
			if not class_Animator then
				class_Animator = Instance.new("Animator", var37)
			end
			AnimationModule_upvr.PreloadAnim(class_Animator, AnimationName)
			AnimationModule_upvr.PlayAnim(class_Animator, AnimationName, AnimationSpeed, KeyPointName, KeyPointFunc, AnimationPriority, AnimationLooped)
			AnimationModule_upvr.StopAnim(class_Animator, AnimationName)
			AnimationModule_upvr.PlayAnim(class_Animator, AnimationName, AnimationSpeed, KeyPointName, KeyPointFunc, AnimationPriority, AnimationLooped)
		end
	end
end
return module