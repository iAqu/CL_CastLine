-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:19:43
-- Luau version 6, Types version 3
-- Time taken: 0.010389 seconds

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local BaseObject_upvr = require(ReplicatedStorage.ChiefUtils.Utilities.BaseObject)
local Promise_upvr = require(ReplicatedStorage.ChiefUtils.Utilities.Promise)
local Maid_upvr = require(ReplicatedStorage.ChiefUtils.Utilities.Maid)
local PathfindingUtils_upvr = require(script.Parent.PathfindingUtils)
local Symbol = require(script.Parent.Symbol)
local any_named_result1_upvr = Symbol.named("pathBlocked")
local any_named_result1_upvr_2 = Symbol.named("targetChanged")
local tbl_upvr_3 = {
	[Enum.HumanoidStateType.Running] = true;
	[Enum.HumanoidStateType.Jumping] = true;
	[Enum.HumanoidStateType.Swimming] = true;
	[Enum.HumanoidStateType.RunningNoPhysics] = true;
	[Enum.HumanoidStateType.StrafingNoPhysics] = true;
}
local tbl_upvr = {
	[Enum.HumanoidStateType.Running] = true;
	[Enum.HumanoidStateType.Jumping] = true;
	[Enum.HumanoidStateType.Swimming] = true;
	[Enum.HumanoidStateType.GettingUp] = true;
	[Enum.HumanoidStateType.Landed] = true;
	[Enum.HumanoidStateType.Seated] = true;
	[Enum.HumanoidStateType.Climbing] = true;
	[Enum.HumanoidStateType.RunningNoPhysics] = true;
	[Enum.HumanoidStateType.StrafingNoPhysics] = true;
}
local setmetatable_result1_upvr = setmetatable({}, BaseObject_upvr)
setmetatable_result1_upvr.ClassName = "HumanoidWalkTo"
setmetatable_result1_upvr.__index = setmetatable_result1_upvr
function setmetatable_result1_upvr.new(arg1, arg2) -- Line 46
	--[[ Upvalues[3]:
		[1]: BaseObject_upvr (readonly)
		[2]: setmetatable_result1_upvr (readonly)
		[3]: Promise_upvr (readonly)
	]]
	local setmetatable_result1_upvr_2 = setmetatable(BaseObject_upvr.new(), setmetatable_result1_upvr)
	setmetatable_result1_upvr_2._humanoid = assert(arg1, "No humanoid")
	local RootPart = arg1.RootPart
	if not RootPart then
		RootPart = error("No rootPart")
	end
	setmetatable_result1_upvr_2._rootPart = RootPart
	setmetatable_result1_upvr_2._targetPosition = assert(arg2, "No targetPosition")
	setmetatable_result1_upvr_2._promise = setmetatable_result1_upvr_2:_retryFollowing():Catch(function(arg1_2) -- Line 54
		--[[ Upvalues[2]:
			[1]: setmetatable_result1_upvr_2 (readonly)
			[2]: Promise_upvr (copied, readonly)
		]]
		setmetatable_result1_upvr_2:_stopMovement()
		if arg1_2 then
			warn("[HumanoidWalkTo] - Failed to follow path", arg1_2)
			return Promise_upvr.rejected()
		end
	end)
	return setmetatable_result1_upvr_2
end
function setmetatable_result1_upvr.GetHumanoid(arg1) -- Line 67
	return arg1._humanoid
end
function setmetatable_result1_upvr.PromiseFinished(arg1) -- Line 71
	return arg1._promise
end
function setmetatable_result1_upvr._getTargetPosition(arg1) -- Line 75
	return arg1._targetPosition
end
function setmetatable_result1_upvr.SetTarget(arg1, arg2) -- Line 79
	arg1._targetPosition = arg2
end
function setmetatable_result1_upvr._stopMovement(arg1) -- Line 83
	arg1:GetHumanoid():MoveTo(arg1._rootPart.Position)
end
function setmetatable_result1_upvr.GetFailedToComputePath(arg1) -- Line 88
	return arg1._failedToComputePath
end
function setmetatable_result1_upvr._promiseComputePath(arg1, arg2) -- Line 92
	--[[ Upvalues[2]:
		[1]: Promise_upvr (readonly)
		[2]: PathfindingUtils_upvr (readonly)
	]]
	local any__getTargetPosition_result1_upvr = arg1:_getTargetPosition()
	local var16
	if not any__getTargetPosition_result1_upvr then
		return Promise_upvr.rejected()
	end
	local any__getNewPath_result1_upvr = arg1:_getNewPath()
	if not var16 then
		var16 = arg1._rootPart.Position
	end
	return arg1._maid:GivePromise(PathfindingUtils_upvr.promiseComputeAsync(any__getNewPath_result1_upvr, var16, any__getTargetPosition_result1_upvr)):Then(function() -- Line 105
		--[[ Upvalues[4]:
			[1]: any__getNewPath_result1_upvr (readonly)
			[2]: arg1 (readonly)
			[3]: any__getTargetPosition_result1_upvr (readonly)
			[4]: Promise_upvr (copied, readonly)
		]]
		if any__getNewPath_result1_upvr.Status == Enum.PathStatus.Success then
			arg1._failedToComputePath = false
			return any__getNewPath_result1_upvr, any__getTargetPosition_result1_upvr
		end
		arg1._failedToComputePath = true
		return Promise_upvr.rejected()
	end)
end
function setmetatable_result1_upvr._handleFollowError(arg1, arg2, ...) -- Line 116
	--[[ Upvalues[3]:
		[1]: any_named_result1_upvr (readonly)
		[2]: any_named_result1_upvr_2 (readonly)
		[3]: Promise_upvr (readonly)
	]]
	if arg2 == any_named_result1_upvr then
		return arg1:_handlePathBlocked(...)
	end
	if arg2 == any_named_result1_upvr_2 then
		return arg1:_retryFollowing(...)
	end
	return Promise_upvr.rejected(arg2, ...)
end
function setmetatable_result1_upvr._handlePathBlocked(arg1, arg2) -- Line 126
	--[[ Upvalues[2]:
		[1]: tbl_upvr_3 (readonly)
		[2]: tbl_upvr (readonly)
	]]
	local var19
	if tbl_upvr_3[arg1:GetHumanoid():GetState()] then
		arg1:_handleWaypoint(arg2)
		var19 = arg1:_promiseComputePath(arg2.Position)
	else
		local any__promiseState_result1 = arg1:_promiseState(tbl_upvr)
		arg1._maid:GiveTask(any__promiseState_result1)
		var19 = any__promiseState_result1:Then(function() -- Line 139
			--[[ Upvalues[1]:
				[1]: arg1 (readonly)
			]]
			return arg1:_promiseComputePath()
		end)
	end
	return var19:Then(function(arg1_3, arg2_2) -- Line 144
		--[[ Upvalues[1]:
			[1]: arg1 (readonly)
		]]
		return arg1:_promiseFollowPath(arg1_3, arg2_2)
	end):Catch(function(...) -- Line 147
		--[[ Upvalues[1]:
			[1]: arg1 (readonly)
		]]
		return arg1:_handleFollowError(...)
	end)
end
function setmetatable_result1_upvr._retryFollowing(arg1) -- Line 152
	--[[ Upvalues[1]:
		[1]: Promise_upvr (readonly)
	]]
	local any__getTargetPosition_result1 = arg1:_getTargetPosition()
	if not any__getTargetPosition_result1 then
		return Promise_upvr.rejected()
	end
	if (any__getTargetPosition_result1 - arg1._rootPart.Position).magnitude <= 4 then
		return Promise_upvr.resolved()
	end
	return arg1:_promiseComputePath():Then(function(arg1_4, arg2) -- Line 166
		--[[ Upvalues[1]:
			[1]: arg1 (readonly)
		]]
		return arg1:_promiseFollowPath(arg1_4, arg2)
	end):Catch(function(...) -- Line 169
		--[[ Upvalues[1]:
			[1]: arg1 (readonly)
		]]
		return arg1:_handleFollowError(...)
	end)
end
local tbl_upvr_2 = {
	[Enum.HumanoidStateType.Freefall] = true;
	[Enum.HumanoidStateType.Jumping] = true;
	[Enum.HumanoidStateType.Physics] = true;
}
function setmetatable_result1_upvr._promiseState(arg1, arg2) -- Line 180
	--[[ Upvalues[2]:
		[1]: Promise_upvr (readonly)
		[2]: Maid_upvr (readonly)
	]]
	local any_GetHumanoid_result1 = arg1:GetHumanoid()
	if arg2[any_GetHumanoid_result1:GetState()] then
		return Promise_upvr.resolved()
	end
	local any_new_result1_upvr_3 = Maid_upvr.new()
	local any_new_result1_upvr_4 = Promise_upvr.new()
	any_new_result1_upvr_3:GiveTask(any_GetHumanoid_result1.StateChanged:Connect(function(arg1_5, arg2_3) -- Line 189
		--[[ Upvalues[2]:
			[1]: arg2 (readonly)
			[2]: any_new_result1_upvr_4 (readonly)
		]]
		if arg2[arg2_3] then
			any_new_result1_upvr_4:Resolve()
		end
	end))
	any_new_result1_upvr_4:Finally(function() -- Line 195
		--[[ Upvalues[1]:
			[1]: any_new_result1_upvr_3 (readonly)
		]]
		any_new_result1_upvr_3:DoCleaning()
	end)
	any_new_result1_upvr_3:GiveTask(any_new_result1_upvr_4)
	return any_new_result1_upvr_4
end
function setmetatable_result1_upvr._promiseFollowPath(arg1, arg2, arg3) -- Line 205
	--[[ Upvalues[4]:
		[1]: Promise_upvr (readonly)
		[2]: Maid_upvr (readonly)
		[3]: PathfindingUtils_upvr (readonly)
		[4]: tbl_upvr_2 (readonly)
	]]
	local any_GetHumanoid_result1_3_upvr = arg1:GetHumanoid()
	if any_GetHumanoid_result1_3_upvr.Sit then
		any_GetHumanoid_result1_3_upvr.Sit = false
	end
	local any_new_result1_upvr_2 = Promise_upvr.new()
	local any_new_result1_upvr = Maid_upvr.new()
	any_new_result1_upvr:GiveTask(arg2)
	local any_GetWaypoints_result1_upvr = arg2:GetWaypoints()
	local var37_upvw = 1
	if 1 < #any_GetWaypoints_result1_upvr then
		var37_upvw = 2
	end
	any_new_result1_upvr:GiveTask(any_GetHumanoid_result1_3_upvr.Seated:Connect(function(arg1_6) -- Line 234
		--[[ Upvalues[1]:
			[1]: any_GetHumanoid_result1_3_upvr (readonly)
		]]
		if arg1_6 then
			any_GetHumanoid_result1_3_upvr.Sit = false
		end
	end))
	local var40_upvw = 0
	any_new_result1_upvr:GiveTask(any_GetHumanoid_result1_3_upvr.MoveToFinished:Connect(function(arg1_7) -- Line 242
		--[[ Upvalues[10]:
			[1]: arg1 (readonly)
			[2]: any_GetWaypoints_result1_upvr (readonly)
			[3]: var37_upvw (read and write)
			[4]: var40_upvw (read and write)
			[5]: any_new_result1_upvr (readonly)
			[6]: PathfindingUtils_upvr (copied, readonly)
			[7]: arg2 (readonly)
			[8]: any_new_result1_upvr_2 (readonly)
			[9]: any_GetHumanoid_result1_3_upvr (readonly)
			[10]: tbl_upvr_2 (copied, readonly)
		]]
		-- KONSTANTERROR: [0] 1. Error Block 1 start (CF ANALYSIS FAILED)
		-- KONSTANTERROR: [0] 1. Error Block 1 end (CF ANALYSIS FAILED)
		-- KONSTANTERROR: [59] 51. Error Block 7 start (CF ANALYSIS FAILED)
		do
			return
		end
		-- KONSTANTERROR: [59] 51. Error Block 7 end (CF ANALYSIS FAILED)
		-- KONSTANTERROR: [60] 52. Error Block 38 start (CF ANALYSIS FAILED)
		local any_GetState_result1 = any_GetHumanoid_result1_3_upvr:GetState()
		if any_GetState_result1 == Enum.HumanoidStateType.Dead then
			any_new_result1_upvr_2:Reject()
		else
			if tbl_upvr_2[any_GetState_result1] then
				while tbl_upvr_2[any_GetHumanoid_result1_3_upvr:GetState()] and any_new_result1_upvr_2:IsPending() do
					task.wait(0.1)
				end
				if any_new_result1_upvr_2:IsPending() then
					arg1:_handleWaypoint(any_GetWaypoints_result1_upvr[var37_upvw])
				end
				return
			end
			if var40_upvw < 2 then
				var40_upvw += 1
				arg1:_handleWaypoint(any_GetWaypoints_result1_upvr[var37_upvw])
				return
			end
			warn("[HumanoidWalkTo._promiseFollowPath] - Failed to handle move to finished...")
			any_new_result1_upvr_2:Reject()
			-- KONSTANTERROR: [60] 52. Error Block 38 end (CF ANALYSIS FAILED)
		end
	end))
	any_new_result1_upvr:GiveTask(arg2.Blocked:Connect(function(arg1_8) -- Line 293
		--[[ Upvalues[4]:
			[1]: arg1 (readonly)
			[2]: var37_upvw (read and write)
			[3]: any_new_result1_upvr_2 (readonly)
			[4]: any_GetWaypoints_result1_upvr (readonly)
		]]
		arg1:_handleBlockedWaypoint(arg1_8, var37_upvw, any_new_result1_upvr_2, any_GetWaypoints_result1_upvr)
	end))
	arg1:_handleWaypoint(any_GetWaypoints_result1_upvr[var37_upvw])
	any_new_result1_upvr_2:Finally(function() -- Line 299
		--[[ Upvalues[1]:
			[1]: any_new_result1_upvr (readonly)
		]]
		any_new_result1_upvr:DoCleaning()
	end)
	local var44_upvw = true
	any_new_result1_upvr:GiveTask(function() -- Line 304
		--[[ Upvalues[1]:
			[1]: var44_upvw (read and write)
		]]
		var44_upvw = false
	end)
	task.delay(math.random() * 0.25, function() -- Line 308
		--[[ Upvalues[4]:
			[1]: var44_upvw (read and write)
			[2]: arg1 (readonly)
			[3]: any_new_result1_upvr_2 (readonly)
			[4]: arg3 (readonly)
		]]
		while var44_upvw do
			arg1:_handleTargetMoved(any_new_result1_upvr_2, arg3)
			task.wait(0.1)
		end
	end)
	arg1._maid._currentFollowPathPromise = any_new_result1_upvr_2
	return any_new_result1_upvr_2
end
function setmetatable_result1_upvr._handleTargetMoved(arg1, arg2, arg3) -- Line 320
	--[[ Upvalues[1]:
		[1]: any_named_result1_upvr_2 (readonly)
	]]
	if 6 <= (arg3 - arg1:_getTargetPosition()).magnitude then
		arg2:Reject(any_named_result1_upvr_2, arg3)
	end
end
function setmetatable_result1_upvr._handleBlockedWaypoint(arg1, arg2, arg3, arg4, arg5) -- Line 327
	--[[ Upvalues[1]:
		[1]: any_named_result1_upvr (readonly)
	]]
	if arg2 <= 0 then
	elseif arg3 < arg2 and arg2 - arg3 <= 1000 then
		local var47
		if arg3 + 1 < arg2 and arg3 + 1 <= #arg5 then
			var47 = arg5[arg3 + 1]
		end
		arg4:Reject(any_named_result1_upvr, var47)
	end
end
function setmetatable_result1_upvr._handleWaypoint(arg1, arg2) -- Line 346
	local any_GetHumanoid_result1_2 = arg1:GetHumanoid()
	if arg2.Action == Enum.PathWaypointAction.Walk then
		any_GetHumanoid_result1_2:MoveTo(arg2.Position)
	else
		if arg2.Action == Enum.PathWaypointAction.Jump then
			any_GetHumanoid_result1_2.Jump = true
			any_GetHumanoid_result1_2:MoveTo(arg2.Position)
			return
		end
		warn("[HumanoidWalkTo._handleWaypoint] - Failed to act in waypoint of action type %q":format(tostring(arg2.Action)))
	end
end
function setmetatable_result1_upvr._didReachWaypoint(arg1, arg2) -- Line 361
	local var49 = (arg1._rootPart.Position - arg2.Position) * Vector3.new(1, 0.05000, 1)
	if var49.magnitude > 4 then
		var49 = false
	else
		var49 = true
	end
	return var49
end
local PathfindingService_upvr = game:GetService("PathfindingService")
function setmetatable_result1_upvr._getNewPath(arg1) -- Line 367
	--[[ Upvalues[1]:
		[1]: PathfindingService_upvr (readonly)
	]]
	local any_CreatePath_result1 = PathfindingService_upvr:CreatePath(arg1:_createPathParameters())
	arg1._maid:GiveTask(any_CreatePath_result1)
	return any_CreatePath_result1
end
function setmetatable_result1_upvr._createPathParameters(arg1) -- Line 373
	return {
		AgentHeight = 5;
		AgentRadius = 2;
		AgentCanJump = false;
		WaypointSpacing = math.huge;
	}
end
return setmetatable_result1_upvr