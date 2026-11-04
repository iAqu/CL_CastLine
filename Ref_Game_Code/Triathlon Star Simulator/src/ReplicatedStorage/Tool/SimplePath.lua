-- Saved by UniversalSynSaveInstance https://discord.gg/wx4ThpAsmw

-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2024-10-02 00:24:24
-- Luau version 6, Types version 3
-- Time taken: 0.012561 seconds

local tbl_upvr = {
	TIME_VARIANCE = 0.07;
	COMPARISON_CHECKS = 1;
	JUMP_WHEN_STUCK = false;
}
local function _(arg1, arg2) -- Line 24, Named "output"
	local var2
	if arg1 == error then
		var2 = "SimplePath Error: "
	else
		var2 = "SimplePath: "
	end
	arg1(var2..arg2)
end
local module_upvr = {
	StatusType = {
		Idle = "Idle";
		Active = "Active";
	};
	ErrorType = {
		LimitReached = "LimitReached";
		TargetUnreachable = "TargetUnreachable";
		ComputationError = "ComputationError";
		AgentStuck = "AgentStuck";
	};
}
function module_upvr.__index(arg1, arg2) -- Line 39
	--[[ Upvalues[1]:
		[1]: module_upvr (readonly)
	]]
	if arg2 == "Stopped" then
		local var9
		if not arg1._humanoid then
			local error = error
			if error == error then
				var9 = "SimplePath Error: "
			else
				var9 = "SimplePath: "
			end
			error(var9.."Attempt to use Path.Stopped on a non-humanoid.")
		end
	end
	if not arg1._events[arg2] or not arg1._events[arg2].Event or arg2 ~= "LastError" or not arg1._lastError or arg2 ~= "Status" or not arg1._status then
	end
	return module_upvr[arg2]
end
local function _(arg1, arg2) -- Line 51, Named "declareError"
	arg1._lastError = arg2
	arg1._events.Error:Fire(arg2)
end
local function getNonHumanoidWaypoint_upvr(arg1) -- Line 58, Named "getNonHumanoidWaypoint"
	for i = 2, #arg1._waypoints do
		if 0.1 < (arg1._waypoints[i].Position - arg1._waypoints[i - 1].Position).Magnitude then
			return i
		end
	end
	return 2
end
local function _(arg1) -- Line 69, Named "setJumpState"
	pcall(function() -- Line 70
		--[[ Upvalues[1]:
			[1]: arg1 (readonly)
		]]
		if arg1._humanoid:GetState() ~= Enum.HumanoidStateType.Jumping and arg1._humanoid:GetState() ~= Enum.HumanoidStateType.Freefall then
			arg1._humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
		end
	end)
end
local function _(arg1) -- Line 78, Named "move"
	if arg1._waypoints[arg1._currentWaypoint].Action == Enum.PathWaypointAction.Jump then
		pcall(function() -- Line 70
			--[[ Upvalues[1]:
				[1]: arg1 (readonly)
			]]
			if arg1._humanoid:GetState() ~= Enum.HumanoidStateType.Jumping and arg1._humanoid:GetState() ~= Enum.HumanoidStateType.Freefall then
				arg1._humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
			end
		end)
	end
	arg1._humanoid:MoveTo(arg1._waypoints[arg1._currentWaypoint].Position)
end
local function _(arg1) -- Line 86, Named "disconnectMoveConnection"
	arg1._moveConnection:Disconnect()
	arg1._moveConnection = nil
end
local function _(arg1) -- Line 92, Named "invokeWaypointReached"
	arg1._events.WaypointReached:Fire(arg1._agent, arg1._waypoints[arg1._currentWaypoint - 1], arg1._waypoints[arg1._currentWaypoint])
end
local function moveToFinished_upvr(arg1, arg2) -- Line 98, Named "moveToFinished"
	--[[ Upvalues[1]:
		[1]: module_upvr (readonly)
	]]
	if not getmetatable(arg1) then
	else
		if not arg1._humanoid then
			if arg2 and arg1._currentWaypoint + 1 <= #arg1._waypoints then
				arg1._events.WaypointReached:Fire(arg1._agent, arg1._waypoints[arg1._currentWaypoint - 1], arg1._waypoints[arg1._currentWaypoint])
				arg1._currentWaypoint += 1
			else
				if arg2 then
					arg1._target = nil
					arg1._events.Reached:Fire(arg1._agent, arg1._waypoints[arg1._currentWaypoint])
					return
				end
				arg1._target = nil
				local TargetUnreachable_2 = arg1.ErrorType.TargetUnreachable
				arg1._lastError = TargetUnreachable_2
				arg1._events.Error:Fire(TargetUnreachable_2)
			end
		end
		if arg2 and arg1._currentWaypoint + 1 <= #arg1._waypoints then
			if arg1._currentWaypoint + 1 < #arg1._waypoints then
				arg1._events.WaypointReached:Fire(arg1._agent, arg1._waypoints[arg1._currentWaypoint - 1], arg1._waypoints[arg1._currentWaypoint])
			end
			arg1._currentWaypoint += 1
			if arg1._waypoints[arg1._currentWaypoint].Action == Enum.PathWaypointAction.Jump then
				pcall(function() -- Line 70
					--[[ Upvalues[1]:
						[1]: arg1 (readonly)
					]]
					if arg1._humanoid:GetState() ~= Enum.HumanoidStateType.Jumping and arg1._humanoid:GetState() ~= Enum.HumanoidStateType.Freefall then
						arg1._humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
					end
				end)
			end
			arg1._humanoid:MoveTo(arg1._waypoints[arg1._currentWaypoint].Position)
			return
		end
		if arg2 then
			arg1._moveConnection:Disconnect()
			arg1._moveConnection = nil
			arg1._status = module_upvr.StatusType.Idle
			arg1._events.Reached:Fire(arg1._agent, arg1._waypoints[arg1._currentWaypoint])
			return
		end
		arg1._moveConnection:Disconnect()
		arg1._moveConnection = nil
		arg1._status = module_upvr.StatusType.Idle
		local TargetUnreachable = arg1.ErrorType.TargetUnreachable
		arg1._lastError = TargetUnreachable
		arg1._events.Error:Fire(TargetUnreachable)
	end
end
local function comparePosition_upvr(arg1) -- Line 136, Named "comparePosition"
	local var18
	if arg1._currentWaypoint == var18 then
	else
		local function INLINED() -- Internal function, doesn't exist in bytecode
			var18 = arg1._position._count + 1
			return var18
		end
		if (arg1._agent.PrimaryPart.Position - arg1._position._last).Magnitude > 0.07 or not INLINED() then
			var18 = 0
		end
		arg1._position._count = var18
		var18 = arg1._agent.PrimaryPart.Position
		arg1._position._last = var18
		var18 = arg1._position
		var18 = arg1._settings.COMPARISON_CHECKS
		if var18 <= var18._count then
			var18 = arg1._settings
			if var18.JUMP_WHEN_STUCK then
				function var18() -- Line 70
					--[[ Upvalues[1]:
						[1]: arg1 (readonly)
					]]
					if arg1._humanoid:GetState() ~= Enum.HumanoidStateType.Jumping and arg1._humanoid:GetState() ~= Enum.HumanoidStateType.Freefall then
						arg1._humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
					end
				end
				pcall(var18)
			end
			var18 = arg1.ErrorType
			local AgentStuck = var18.AgentStuck
			arg1._lastError = AgentStuck
			var18 = arg1._events.Error:Fire
			var18(AgentStuck)
		end
	end
end
local Players_upvr = game:GetService("Players")
function module_upvr.GetNearestCharacter(arg1) -- Line 149
	--[[ Upvalues[1]:
		[1]: Players_upvr (readonly)
	]]
	local var28
	for _, v in ipairs(Players_upvr:GetPlayers()) do
		if v.Character and (v.Character.PrimaryPart.Position - arg1).Magnitude < math.huge then
		end
	end
	return nil
end
local PathfindingService_upvr = game:GetService("PathfindingService")
function module_upvr.new(arg1, arg2, arg3) -- Line 160
	--[[ Upvalues[3]:
		[1]: tbl_upvr (readonly)
		[2]: PathfindingService_upvr (readonly)
		[3]: module_upvr (readonly)
	]]
	-- KONSTANTERROR: [0] 1. Error Block 1 start (CF ANALYSIS FAILED)
	-- KONSTANTERROR: [0] 1. Error Block 1 end (CF ANALYSIS FAILED)
	-- KONSTANTERROR: [1] 2. Error Block 31 start (CF ANALYSIS FAILED)
	local var34
	if not arg1:IsA("Model") or not arg1.PrimaryPart then
		-- KONSTANTERROR: [9] 8. Error Block 29 start (CF ANALYSIS FAILED)
		local error_2 = error
		if error_2 == error then
			var34 = "SimplePath Error: "
		else
			var34 = "SimplePath: "
		end
		error_2(var34.."Pathfinding agent must be a valid Model Instance with a set PrimaryPart.")
		-- KONSTANTERROR: [9] 8. Error Block 29 end (CF ANALYSIS FAILED)
	end
	local tbl = {}
	local var37 = arg3
	if not var37 then
		var37 = tbl_upvr
	end
	tbl._settings = var37
	tbl._events = {
		Reached = Instance.new("BindableEvent");
		WaypointReached = Instance.new("BindableEvent");
		Blocked = Instance.new("BindableEvent");
		Error = Instance.new("BindableEvent");
		Stopped = Instance.new("BindableEvent");
	}
	tbl._agent = arg1
	tbl._humanoid = arg1:FindFirstChildOfClass("Humanoid")
	tbl._path = PathfindingService_upvr:CreatePath(arg2)
	tbl._status = "Idle"
	tbl._t = 0
	tbl._position = {
		_last = Vector3.new();
		_count = 0;
	}
	local setmetatable_result1 = setmetatable(tbl, module_upvr)
	for i_3, v_2 in pairs(tbl_upvr) do
		local var44
		local function INLINED_2() -- Internal function, doesn't exist in bytecode
			var44 = v_2
			return var44
		end
		if setmetatable_result1._settings[i_3] ~= nil or not INLINED_2() then
			var44 = setmetatable_result1._settings[i_3]
		end
		setmetatable_result1._settings[i_3] = var44
	end
	do
		return setmetatable_result1
	end
	-- KONSTANTERROR: [1] 2. Error Block 31 end (CF ANALYSIS FAILED)
end
function module_upvr.Destroy(arg1) -- Line 203
	for _, v_3 in ipairs(arg1._events) do
		v_3:Destroy()
	end
	arg1._events = nil
	arg1._path:Destroy()
	setmetatable(arg1, nil)
	for i_5, _ in pairs(arg1) do
		arg1[i_5] = nil
	end
end
function module_upvr.Stop(arg1) -- Line 215
	--[[ Upvalues[1]:
		[1]: module_upvr (readonly)
	]]
	local var55
	if not arg1._humanoid then
		local error_5 = error
		if error_5 == error then
			var55 = "SimplePath Error: "
		else
			var55 = "SimplePath: "
		end
		error_5(var55.."Attempt to call Path:Stop() on a non-humanoid.")
	else
		var55 = module_upvr
		if arg1._status == var55.StatusType.Idle then
			local function var57(arg1_2) -- Line 221
				warn(debug.traceback(arg1_2))
			end
			if var57 == error then
				var55 = "SimplePath Error: "
			else
				var55 = "SimplePath: "
			end
			var57(var55.."Attempt to run Path:Stop() in idle state")
			return
		end
		arg1._moveConnection:Disconnect()
		arg1._moveConnection = nil
		arg1._status = module_upvr.StatusType.Idle
		arg1._events.Stopped:Fire(arg1._model)
	end
end
function module_upvr.Run(arg1, arg2) -- Line 231
	--[[ Upvalues[4]:
		[1]: moveToFinished_upvr (readonly)
		[2]: module_upvr (readonly)
		[3]: comparePosition_upvr (readonly)
		[4]: getNonHumanoidWaypoint_upvr (readonly)
	]]
	-- KONSTANTERROR: [0] 1. Error Block 62 start (CF ANALYSIS FAILED)
	if not arg2 then
		if not arg1._humanoid and arg1._target then
			moveToFinished_upvr(arg1, true)
			do
				return
			end
			local var68
		end
	end
	if not arg2 or typeof(arg2) ~= "Vector3" and not arg2:IsA("BasePart") then
		local error_4 = error
		if error_4 == error then
			var68 = "SimplePath Error: "
		else
			var68 = "SimplePath: "
		end
		error_4(var68.."Pathfinding target must be a valid Vector3 or BasePart.")
	end
	local pcall_result1_2, _ = pcall(function() -- Line 246
		--[[ Upvalues[2]:
			[1]: arg1 (readonly)
			[2]: arg2 (readonly)
		]]
		local var71
		local function INLINED_4() -- Internal function, doesn't exist in bytecode
			var71 = arg2
			return var71
		end
		if typeof(arg2) ~= "Vector3" or not INLINED_4() then
			var71 = arg2.Position
		end
		arg1._path:ComputeAsync(arg1._agent.PrimaryPart.Position, var71)
	end)
	if not arg1._path then
		return false
	end
	if not pcall_result1_2 or arg1._path.Status == Enum.PathStatus.NoPath or #arg1._path:GetWaypoints() < 2 or arg1._humanoid and arg1._humanoid:GetState() == Enum.HumanoidStateType.Freefall then
		task.wait()
		local ComputationError_2 = arg1.ErrorType.ComputationError
		arg1._lastError = ComputationError_2
		arg1._events.Error:Fire(ComputationError_2)
		return false
	end
	if not arg1._humanoid or not module_upvr.StatusType.Active then
	end
	arg1._status = module_upvr.StatusType.Idle
	arg1._target = arg2
	pcall(function() -- Line 271
		--[[ Upvalues[1]:
			[1]: arg1 (readonly)
		]]
		arg1._agent.PrimaryPart:SetNetworkOwner(nil)
	end)
	arg1._waypoints = arg1._path:GetWaypoints()
	arg1._currentWaypoint = 2
	if arg1._humanoid then
		comparePosition_upvr(arg1)
	end
	local _humanoid = arg1._humanoid
	if _humanoid then
		_humanoid = arg1._moveConnection
		if not _humanoid then
			_humanoid = arg1._humanoid.MoveToFinished
			_humanoid = _humanoid:Connect(function(...) -- Line 286
				--[[ Upvalues[2]:
					[1]: moveToFinished_upvr (copied, readonly)
					[2]: arg1 (readonly)
				]]
				moveToFinished_upvr(arg1, ...)
			end)
		end
	end
	arg1._moveConnection = _humanoid
	if arg1._humanoid then
		arg1._humanoid:MoveTo(arg1._waypoints[arg1._currentWaypoint].Position)
		-- KONSTANTWARNING: GOTO [201] #139
	end
	if #arg1._waypoints == 2 then
		arg1._target = nil
		arg1._events.Reached:Fire(arg1._agent, arg1._waypoints[2])
	else
		arg1._currentWaypoint = getNonHumanoidWaypoint_upvr(arg1)
		moveToFinished_upvr(arg1, true)
	end
	-- KONSTANTERROR: [0] 1. Error Block 62 end (CF ANALYSIS FAILED)
	-- KONSTANTERROR: [201] 139. Error Block 39 start (CF ANALYSIS FAILED)
	do
		return true
	end
	-- KONSTANTERROR: [201] 139. Error Block 39 end (CF ANALYSIS FAILED)
end
return module_upvr