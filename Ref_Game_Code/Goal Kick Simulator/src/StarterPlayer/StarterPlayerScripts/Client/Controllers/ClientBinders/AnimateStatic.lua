-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:31:03
-- Luau version 6, Types version 3
-- Time taken: 0.011970 seconds

local Util_upvr = require(game:GetService("ReplicatedStorage").Util)
local BaseObject_upvr = Util_upvr.BaseObject
local Maid_upvr = Util_upvr.Maid
local module = {}
local module_2_upvr = {
	map = function(arg1, arg2, arg3, arg4, arg5) -- Line 28, Named "map"
		if arg3 == arg2 then
			error("Range of zero")
		end
		return (arg1 - arg2) * (arg5 - arg4) / (arg3 - arg2) + arg4
	end;
}
local tbl_upvr_3 = {
	loadAnimationFromId = function(arg1, arg2) -- Line 45, Named "loadAnimationFromId"
		local Animation = Instance.new("Animation")
		Animation.AnimationId = arg2
		return arg1:LoadAnimation(Animation)
	end;
	setWeightTargetIfNotSet = function(arg1, arg2, arg3) -- Line 58, Named "setWeightTargetIfNotSet"
		-- KONSTANTERROR: [0] 1. Error Block 24 start (CF ANALYSIS FAILED)
		local var8
		if typeof(arg1) ~= "Instance" then
			var8 = false
		else
			var8 = true
		end
		assert(var8, "Bad track")
		if type(arg2) ~= "number" then
			var8 = false
			-- KONSTANTWARNING: GOTO [24] #19
		end
		-- KONSTANTERROR: [0] 1. Error Block 24 end (CF ANALYSIS FAILED)
		-- KONSTANTERROR: [23] 18. Error Block 26 start (CF ANALYSIS FAILED)
		var8 = true
		assert(var8, "Bad weight")
		if type(arg3) ~= "number" then
			var8 = false
		else
			var8 = true
		end
		assert(var8, "Bad fadeTime")
		if arg1.WeightTarget ~= arg2 then
			arg1:AdjustWeight(arg2, arg3)
		end
		-- KONSTANTERROR: [23] 18. Error Block 26 end (CF ANALYSIS FAILED)
	end;
}
local tbl_upvr_2 = {}
function tbl_upvr_2.createdWeightedTracks(arg1, arg2) -- Line 90
	--[[ Upvalues[2]:
		[1]: tbl_upvr_2 (readonly)
		[2]: tbl_upvr_3 (readonly)
	]]
	assert(arg1, "Bad humanoid")
	assert(arg2, "Bad weightedAnimationList")
	local module_5 = {}
	for _, v in pairs(arg2) do
		assert(v.animationId, "Bad weightedAnimation.animationId")
		assert(v.weight, "Bad weightedAnimation.weight")
		table.insert(module_5, tbl_upvr_2.createdWeightedTrack(tbl_upvr_3.loadAnimationFromId(arg1, v.animationId), v.weight))
	end
	return module_5
end
function tbl_upvr_2.createdWeightedAnimation(arg1, arg2) -- Line 113
	local var18
	if type(arg1) ~= "string" then
		var18 = false
	else
		var18 = true
	end
	assert(var18, "Bad animationId")
	if type(arg2) ~= "number" then
		var18 = false
	else
		var18 = true
	end
	assert(var18, "Bad weight")
	local module_3 = {}
	module_3.animationId = arg1
	module_3.weight = arg2
	return module_3
end
function tbl_upvr_2.createdWeightedTrack(arg1, arg2) -- Line 130
	local var20 = false
	if typeof(arg1) == "Instance" then
		var20 = arg1:IsA("AnimationTrack")
	end
	assert(var20, "Bad track")
	if type(arg2) ~= "number" then
		var20 = false
	else
		var20 = true
	end
	assert(var20, "Bad weight")
	local module_4 = {}
	module_4.track = arg1
	module_4.weight = arg2
	return module_4
end
function tbl_upvr_2.selectFromWeightedTracks(arg1) -- Line 146
	-- KONSTANTWARNING: Variable analysis failed. Output will have some incorrect variable assignments
	-- KONSTANTERROR: [0] 1. Error Block 36 start (CF ANALYSIS FAILED)
	local var38
	if type(arg1) ~= "table" then
		var38 = false
	else
		var38 = true
	end
	assert(var38, "Bad weightedTracks")
	if 0 >= #arg1 then
		var38 = false
		-- KONSTANTWARNING: GOTO [21] #17
	end
	-- KONSTANTERROR: [0] 1. Error Block 36 end (CF ANALYSIS FAILED)
	-- KONSTANTERROR: [20] 16. Error Block 38 start (CF ANALYSIS FAILED)
	var38 = true
	assert(var38, "Bad weightedTracks")
	if #arg1 == 1 then
		return arg1[1]
	end
	var38 = pairs(arg1)
	local pairs_result1, pairs_result2_2, pairs_result3_2 = pairs(arg1)
	for _, _ in pairs_result1, pairs_result2_2, pairs_result3_2 do
		local var42
	end
	if var42 == 0 then
	else
	end
	pairs_result1 = assert
	pairs_result1(true, "total weight is 0")
	pairs_result1 = math.random()
	for _, v_3 in pairs(arg1) do
		if pairs_result1 <= 0 + v_3.weight / var42 then
			return v_3
		end
	end
	error("[AnimationGroupUtils.selectFromWeightedTracks] - Failed to find a selection with option at %d":format(pairs_result1))
	do
		return nil
	end
	-- KONSTANTERROR: [20] 16. Error Block 38 end (CF ANALYSIS FAILED)
end
local setmetatable_result1_upvr_2 = setmetatable({}, BaseObject_upvr)
setmetatable_result1_upvr_2.ClassName = "AnimationGroup"
setmetatable_result1_upvr_2.__index = setmetatable_result1_upvr_2
local function new(arg1) -- Line 188
	--[[ Upvalues[2]:
		[1]: BaseObject_upvr (readonly)
		[2]: setmetatable_result1_upvr_2 (readonly)
	]]
	local setmetatable_result1_upvr_3 = setmetatable(BaseObject_upvr.new(), setmetatable_result1_upvr_2)
	local var54 = arg1
	if not var54 then
		var54 = error("No tracksWithWeight")
	end
	setmetatable_result1_upvr_3._weightedTracks = var54
	for _, v_4 in pairs(setmetatable_result1_upvr_3._weightedTracks) do
		assert(v_4.track, "Bad animation.track")
		assert(v_4.weight, "Bad animation.weight")
	end
	setmetatable_result1_upvr_3._maid:GiveTask(function() -- Line 197
		--[[ Upvalues[1]:
			[1]: setmetatable_result1_upvr_3 (readonly)
		]]
		setmetatable_result1_upvr_3:Stop(0)
	end)
	return setmetatable_result1_upvr_3
end
setmetatable_result1_upvr_2.new = new
function setmetatable_result1_upvr_2.Play(arg1, arg2) -- Line 208
	if arg1._currentTrack and arg1._currentTrack.IsPlaying then
	else
		arg1:_playNewTrack(arg2)
	end
end
function setmetatable_result1_upvr_2.Stop(arg1, arg2) -- Line 219
	if arg1._currentTrack then
		arg1._currentTrack:Stop(arg2)
		arg1._currentTrack = nil
	end
end
function setmetatable_result1_upvr_2._playNewTrack(arg1, arg2) -- Line 226
	--[[ Upvalues[2]:
		[1]: tbl_upvr_2 (readonly)
		[2]: Maid_upvr (readonly)
	]]
	local var59
	if not var59 then
		var59 = error("No track")
	end
	if arg1._currentTrack == var59 and arg1._currentTrack.IsPlaying then
	else
		local any_new_result1 = Maid_upvr.new()
		arg1:Stop(arg2)
		any_new_result1:GiveTask(var59.KeyframeReached:Connect(function(...) -- Line 238
			--[[ Upvalues[1]:
				[1]: arg1 (readonly)
			]]
			arg1:_handleKeyframeReached(...)
		end))
		var59:Play(arg2)
		arg1._currentTrack = var59
		arg1._maid._trackMaid = any_new_result1
	end
end
function setmetatable_result1_upvr_2._handleKeyframeReached(arg1, arg2) -- Line 248
	if arg2 == "End" then
		arg1:_playNewTrack()
	end
end
local tbl_upvr = {
	getHeightScale = function(arg1) -- Line 261, Named "getHeightScale"
		if not arg1.AutomaticScalingEnabled then
			return 1
		end
		return arg1.HipHeight / 2
	end;
	getSwimAnimationSpeed = function(arg1) -- Line 269, Named "getSwimAnimationSpeed"
		return arg1 / 10
	end;
	getRunWalkAnimationSpeed = function(arg1, arg2) -- Line 273, Named "getRunWalkAnimationSpeed"
		return arg1 / 12.8 / arg2
	end;
	getRunWeight = function(arg1) -- Line 277, Named "getRunWeight"
		--[[ Upvalues[1]:
			[1]: module_2_upvr (readonly)
		]]
		return math.clamp(module_2_upvr.map(arg1, 0.33, 0.66, 0.0001, 1), 0.0001, 1)
	end;
	getWalkWeight = function(arg1) -- Line 281, Named "getWalkWeight"
		--[[ Upvalues[1]:
			[1]: module_2_upvr (readonly)
		]]
		return math.clamp(module_2_upvr.map(arg1, 0.33, 0.66, 1, 0.0001), 0.0001, 1)
	end;
}
local setmetatable_result1_upvr = setmetatable({}, BaseObject_upvr)
setmetatable_result1_upvr.ClassName = "AnimatedNPCHumanoid"
setmetatable_result1_upvr.__index = setmetatable_result1_upvr
function setmetatable_result1_upvr.new(arg1) -- Line 290
	--[[ Upvalues[5]:
		[1]: BaseObject_upvr (readonly)
		[2]: setmetatable_result1_upvr (readonly)
		[3]: setmetatable_result1_upvr_2 (readonly)
		[4]: tbl_upvr_2 (readonly)
		[5]: tbl_upvr_3 (readonly)
	]]
	local setmetatable_result1_upvr_4 = setmetatable(BaseObject_upvr.new(arg1), setmetatable_result1_upvr)
	setmetatable_result1_upvr_4._idleAnimationGroup = setmetatable_result1_upvr_2.new(tbl_upvr_2.createdWeightedTracks(arg1, {tbl_upvr_2.createdWeightedAnimation("rbxassetid://507766666", 1), tbl_upvr_2.createdWeightedAnimation("rbxassetid://507766951", 1), tbl_upvr_2.createdWeightedAnimation("rbxassetid://507766388", 18)}))
	setmetatable_result1_upvr_4._maid:GiveTask(setmetatable_result1_upvr_4._idleAnimationGroup)
	setmetatable_result1_upvr_4._runTrack = tbl_upvr_3.loadAnimationFromId(setmetatable_result1_upvr_4._obj, "rbxassetid://507767714")
	setmetatable_result1_upvr_4._maid:GiveTask(setmetatable_result1_upvr_4._runTrack)
	setmetatable_result1_upvr_4._walkTrack = tbl_upvr_3.loadAnimationFromId(setmetatable_result1_upvr_4._obj, "rbxassetid://507777826")
	setmetatable_result1_upvr_4._maid:GiveTask(setmetatable_result1_upvr_4._walkTrack)
	setmetatable_result1_upvr_4._jumpTrack = tbl_upvr_3.loadAnimationFromId(setmetatable_result1_upvr_4._obj, "rbxassetid://507765000")
	setmetatable_result1_upvr_4._maid:GiveTask(setmetatable_result1_upvr_4._jumpTrack)
	setmetatable_result1_upvr_4._fallTrack = tbl_upvr_3.loadAnimationFromId(setmetatable_result1_upvr_4._obj, "rbxassetid://507767968")
	setmetatable_result1_upvr_4._maid:GiveTask(setmetatable_result1_upvr_4._fallTrack)
	setmetatable_result1_upvr_4._swimTrack = tbl_upvr_3.loadAnimationFromId(setmetatable_result1_upvr_4._obj, "rbxassetid://507784897")
	setmetatable_result1_upvr_4._maid:GiveTask(setmetatable_result1_upvr_4._swimTrack)
	setmetatable_result1_upvr_4._swimIdleTrack = tbl_upvr_3.loadAnimationFromId(setmetatable_result1_upvr_4._obj, "rbxassetid://507785072")
	setmetatable_result1_upvr_4._maid:GiveTask(setmetatable_result1_upvr_4._swimIdleTrack)
	setmetatable_result1_upvr_4._sitTrack = tbl_upvr_3.loadAnimationFromId(setmetatable_result1_upvr_4._obj, "rbxassetid://2506281703")
	setmetatable_result1_upvr_4._maid:GiveTask(setmetatable_result1_upvr_4._sitTrack)
	setmetatable_result1_upvr_4._idleAnimationGroup:Play()
	setmetatable_result1_upvr_4._maid:GiveTask(setmetatable_result1_upvr_4._obj.Running:Connect(function(...) -- Line 324
		--[[ Upvalues[1]:
			[1]: setmetatable_result1_upvr_4 (readonly)
		]]
		setmetatable_result1_upvr_4:_handleRun(...)
	end))
	setmetatable_result1_upvr_4._maid:GiveTask(setmetatable_result1_upvr_4._obj.Swimming:Connect(function(...) -- Line 328
		--[[ Upvalues[1]:
			[1]: setmetatable_result1_upvr_4 (readonly)
		]]
		setmetatable_result1_upvr_4:_handleSwim(...)
	end))
	setmetatable_result1_upvr_4._maid:GiveTask(setmetatable_result1_upvr_4._obj.Jumping:Connect(function() -- Line 332
		--[[ Upvalues[1]:
			[1]: setmetatable_result1_upvr_4 (readonly)
		]]
		setmetatable_result1_upvr_4:_handleJump()
	end))
	setmetatable_result1_upvr_4._maid:GiveTask(setmetatable_result1_upvr_4._obj.FreeFalling:connect(function() -- Line 336
		--[[ Upvalues[1]:
			[1]: setmetatable_result1_upvr_4 (readonly)
		]]
		setmetatable_result1_upvr_4:_handleFreeFall()
	end))
	setmetatable_result1_upvr_4._maid:GiveTask(setmetatable_result1_upvr_4._obj.Seated:connect(function(...) -- Line 340
		--[[ Upvalues[1]:
			[1]: setmetatable_result1_upvr_4 (readonly)
		]]
		setmetatable_result1_upvr_4:_handleSit(...)
	end))
	setmetatable_result1_upvr_4._maid:GiveTask(setmetatable_result1_upvr_4._obj.Ragdoll:Connect(function(...) -- Line 344
		--[[ Upvalues[1]:
			[1]: setmetatable_result1_upvr_4 (readonly)
		]]
		setmetatable_result1_upvr_4:_handleRagdoll(...)
	end))
	setmetatable_result1_upvr_4._maid:GiveTask(setmetatable_result1_upvr_4._jumpTrack.KeyframeReached:Connect(function(arg1_2) -- Line 348
		--[[ Upvalues[1]:
			[1]: setmetatable_result1_upvr_4 (readonly)
		]]
		if arg1_2 == "End" and setmetatable_result1_upvr_4._obj:GetState() == Enum.HumanoidStateType.Freefall then
			setmetatable_result1_upvr_4._fallTrack:Play(0.2)
			setmetatable_result1_upvr_4._walkTrack:Stop(0.2)
			setmetatable_result1_upvr_4._runTrack:Stop(0.2)
			setmetatable_result1_upvr_4._swimIdleTrack:Stop(0.2)
			setmetatable_result1_upvr_4._swimTrack:Stop(0.2)
			setmetatable_result1_upvr_4._sitTrack:Stop(0.5)
		end
	end))
	setmetatable_result1_upvr_4._maid:GiveTask(function() -- Line 362
		--[[ Upvalues[1]:
			[1]: setmetatable_result1_upvr_4 (readonly)
		]]
		setmetatable_result1_upvr_4._sitTrack:Stop(0.1)
		setmetatable_result1_upvr_4._walkTrack:Stop(0.1)
		setmetatable_result1_upvr_4._runTrack:Stop(0.1)
		setmetatable_result1_upvr_4._swimIdleTrack:Stop(0.1)
		setmetatable_result1_upvr_4._swimTrack:Stop(0.1)
		setmetatable_result1_upvr_4._fallTrack:Stop(0.1)
		if setmetatable_result1_upvr_4._idleAnimationGroup.Destroy then
			setmetatable_result1_upvr_4._idleAnimationGroup:Stop(0.1)
		end
	end)
	return setmetatable_result1_upvr_4
end
function setmetatable_result1_upvr._handleRagdoll(arg1, arg2) -- Line 378
	if arg2 then
		arg1._sitTrack:Stop(0.1)
		arg1._walkTrack:Stop(0.1)
		arg1._runTrack:Stop(0.1)
		arg1._swimIdleTrack:Stop(0.1)
		arg1._swimTrack:Stop(0.1)
		arg1._fallTrack:Stop(0.1)
		arg1._idleAnimationGroup:Stop(0.1)
	end
end
function setmetatable_result1_upvr._handleSit(arg1, arg2) -- Line 390
	if arg2 then
		arg1._sitTrack:Play(0.5)
		arg1._walkTrack:Stop(0.5)
		arg1._runTrack:Stop(0.5)
		arg1._swimIdleTrack:Stop(0.5)
		arg1._swimTrack:Stop(0.5)
		arg1._fallTrack:Stop(0.5)
		arg1._idleAnimationGroup:Stop(0.5)
	end
end
function setmetatable_result1_upvr._handleJump(arg1, arg2) -- Line 403
	arg1._jumpTrack:Play(0.1)
	arg1._walkTrack:Stop(0.1)
	arg1._runTrack:Stop(0.1)
	arg1._swimIdleTrack:Stop(0.2)
	arg1._swimTrack:Stop(0.2)
	arg1._fallTrack:Stop(0.2)
	arg1._sitTrack:Stop(0.5)
end
function setmetatable_result1_upvr._handleFreeFall(arg1) -- Line 414
	if not arg1._jumpTrack.IsPlaying then
		arg1._fallTrack:Play(0.2)
		arg1._walkTrack:Stop(0.2)
		arg1._runTrack:Stop(0.2)
		arg1._swimIdleTrack:Stop(0.2)
		arg1._swimTrack:Stop(0.2)
		arg1._sitTrack:Stop(0.5)
		arg1._idleAnimationGroup:Stop(0.2)
	end
end
function setmetatable_result1_upvr._handleSwim(arg1, arg2) -- Line 427
	--[[ Upvalues[1]:
		[1]: tbl_upvr (readonly)
	]]
	-- KONSTANTERROR: [0] 1. Error Block 1 start (CF ANALYSIS FAILED)
	local var74 = 1
	-- KONSTANTERROR: [0] 1. Error Block 1 end (CF ANALYSIS FAILED)
	-- KONSTANTERROR: [61] 42. Error Block 5 start (CF ANALYSIS FAILED)
	arg1._currentSwimSpeed = var74
	arg1._swimTrack:AdjustSpeed(var74)
	do
		return
	end
	-- KONSTANTERROR: [61] 42. Error Block 5 end (CF ANALYSIS FAILED)
	-- KONSTANTERROR: [70] 48. Error Block 11 start (CF ANALYSIS FAILED)
	if not arg1._swimIdleTrack.IsPlaying then
		arg1._swimIdleTrack:Play(0.4, 1, 1)
	end
	arg1._swimTrack:Stop(0.4)
	arg1._walkTrack:Stop(0.4)
	arg1._runTrack:Stop(0.4)
	arg1._sitTrack:Stop(0.4)
	arg1._fallTrack:Stop(0.4)
	arg1._idleAnimationGroup:Stop(0.4)
	-- KONSTANTERROR: [70] 48. Error Block 11 end (CF ANALYSIS FAILED)
end
function setmetatable_result1_upvr._handleRun(arg1, arg2) -- Line 459
	--[[ Upvalues[2]:
		[1]: tbl_upvr (readonly)
		[2]: tbl_upvr_3 (readonly)
	]]
	-- KONSTANTERROR: [0] 1. Error Block 1 start (CF ANALYSIS FAILED)
	-- KONSTANTERROR: [0] 1. Error Block 1 end (CF ANALYSIS FAILED)
	-- KONSTANTERROR: [83] 58. Error Block 7 start (CF ANALYSIS FAILED)
	-- KONSTANTWARNING: Failed to evaluate expression, replaced with nil [83.3]
	arg1._currentRunSpeed = nil
	-- KONSTANTERROR: Expression was reused, decompilation is incorrect
	tbl_upvr_3.setWeightTargetIfNotSet(arg1._walkTrack, tbl_upvr.getWalkWeight(nil), 0.1)
	-- KONSTANTERROR: Expression was reused, decompilation is incorrect
	tbl_upvr_3.setWeightTargetIfNotSet(arg1._runTrack, tbl_upvr.getRunWeight(nil), 0.1)
	-- KONSTANTERROR: Expression was reused, decompilation is incorrect
	arg1._walkTrack:AdjustSpeed(nil)
	-- KONSTANTERROR: Expression was reused, decompilation is incorrect
	arg1._runTrack:AdjustSpeed(nil)
	do
		return
	end
	-- KONSTANTERROR: [83] 58. Error Block 7 end (CF ANALYSIS FAILED)
	-- KONSTANTERROR: [122] 86. Error Block 8 start (CF ANALYSIS FAILED)
	arg1._walkTrack:Stop(0.2)
	arg1._runTrack:Stop(0.2)
	arg1._swimIdleTrack:Stop(0.2)
	arg1._swimTrack:Stop(0.2)
	arg1._fallTrack:Stop(0.2)
	arg1._sitTrack:Stop(0.5)
	arg1._idleAnimationGroup:Play(0.2)
	-- KONSTANTERROR: [122] 86. Error Block 8 end (CF ANALYSIS FAILED)
end
function module.Binder(arg1) -- Line 499
	--[[ Upvalues[3]:
		[1]: Maid_upvr (readonly)
		[2]: Util_upvr (readonly)
		[3]: setmetatable_result1_upvr (readonly)
	]]
	local any_new_result1_2_upvr = Maid_upvr.new()
	any_new_result1_2_upvr.Active = true
	task.spawn(function() -- Line 502
		--[[ Upvalues[4]:
			[1]: arg1 (readonly)
			[2]: any_new_result1_2_upvr (readonly)
			[3]: Util_upvr (copied, readonly)
			[4]: setmetatable_result1_upvr (copied, readonly)
		]]
		local Humanoid_upvr = arg1:WaitForChild("Humanoid")
		if not any_new_result1_2_upvr.Active then
		else
			any_new_result1_2_upvr:GiveTask(Util_upvr.AnimationsDisabled.Changed:Connect(function() -- Line 505, Named "update"
				--[[ Upvalues[4]:
					[1]: Util_upvr (copied, readonly)
					[2]: any_new_result1_2_upvr (copied, readonly)
					[3]: setmetatable_result1_upvr (copied, readonly)
					[4]: Humanoid_upvr (readonly)
				]]
				if Util_upvr.AnimationsDisabled.Value then
					any_new_result1_2_upvr._current = nil
				else
					any_new_result1_2_upvr._current = setmetatable_result1_upvr.new(Humanoid_upvr)
				end
			end))
			if Util_upvr.AnimationsDisabled.Value then
				any_new_result1_2_upvr._current = nil
				return
			end
			any_new_result1_2_upvr._current = setmetatable_result1_upvr.new(Humanoid_upvr)
		end
	end)
	return any_new_result1_2_upvr
end
return module