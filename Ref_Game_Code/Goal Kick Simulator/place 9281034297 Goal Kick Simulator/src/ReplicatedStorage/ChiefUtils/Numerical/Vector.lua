-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:20:18
-- Luau version 6, Types version 3
-- Time taken: 0.010161 seconds

local module_upvr = {
	ClampMagnitude = function(arg1, arg2) -- Line 68, Named "ClampMagnitude"
		local var2
		local function INLINED() -- Internal function, doesn't exist in bytecode
			var2 = arg1.Unit * arg2
			return var2
		end
		if arg2 >= arg1.Magnitude or not INLINED() then
			var2 = arg1
		end
		return var2
	end;
	AngleBetween = function(arg1, arg2) -- Line 73, Named "AngleBetween"
		return math.acos(math.clamp(arg1.Unit:Dot(arg2.Unit), -1, 1))
	end;
}
function module_upvr.AngleBetweenSigned(arg1, arg2, arg3) -- Line 78
	--[[ Upvalues[1]:
		[1]: module_upvr (readonly)
	]]
	return module_upvr.AngleBetween(arg1, arg2) * math.sign(arg3:Dot(arg1:Cross(arg2)))
end
function module_upvr.FromAxisToPolar(arg1) -- Line 84
	local magnitude = arg1.magnitude
	return Vector3.new(math.atan2(arg1.z, arg1.x), math.asin(arg1.y / magnitude), magnitude)
end
function module_upvr.FromPolarToAxis(arg1) -- Line 90
	local x = arg1.x
	local y = arg1.y
	local z = arg1.z
	return Vector3.new(z * math.cos(x) * math.cos(y), z * math.sin(y), z * math.sin(x) * math.cos(y))
end
function module_upvr.Lerp(arg1, arg2, arg3) -- Line 99
	return arg1 + arg3 * (arg2 - arg1)
end
function module_upvr.Slerp(arg1, arg2, arg3) -- Line 104
	--[[ Upvalues[1]:
		[1]: module_upvr (readonly)
	]]
	local Magnitude_4 = arg1.Magnitude
	local Magnitude_3 = arg2.Magnitude
	local var9
	if Magnitude_4 == 0 or Magnitude_3 == 0 then
		return module_upvr.Lerp(var9, arg2, arg3)
	end
	local any_Dot_result1 = var9 / Magnitude_4:Dot(arg2 / Magnitude_3)
	if any_Dot_result1 < 0 then
		var9 = -var9
		any_Dot_result1 = -any_Dot_result1
	end
	if 0.99995 < any_Dot_result1 then
		return module_upvr.Lerp(var9, arg2, arg3)
	end
	local arccosine = math.acos(any_Dot_result1)
	local var12 = arccosine * arg3
	local sine = math.sin(var12)
	local sine_2 = math.sin(arccosine)
	return ((math.cos(var12) - any_Dot_result1 * sine / sine_2) * var9 + sine / sine_2 * arg2) * (Magnitude_4 + arg3 * (Magnitude_3 - Magnitude_4))
end
function module_upvr.TorqueFromForce(arg1, arg2, arg3) -- Line 132
	return arg1 - arg2:Cross(arg3)
end
function module_upvr.Reach(arg1, arg2, arg3) -- Line 136
	local var15 = arg2 - arg1
	if var15.Magnitude < arg3 then
		return arg2, var15
	end
	local var16 = var15.Unit * arg3
	return arg1 + var16, var16
end
function module_upvr.Raycast(arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8) -- Line 146
	--[[ Upvalues[1]:
		[1]: module_upvr (readonly)
	]]
	local RaycastParams_new_result1_2 = RaycastParams.new()
	local tbl = {workspace:FindFirstChild("Ignore")}
	local var19 = tbl
	tbl = arg7
	local var20 = tbl
	if not var20 then
		var20 = Enum.RaycastFilterType.Blacklist
	end
	RaycastParams_new_result1_2.FilterType = var20
	RaycastParams_new_result1_2.FilterDescendantsInstances = var19
	RaycastParams_new_result1_2.IgnoreWater = arg4 or false
	if arg6 then
		RaycastParams_new_result1_2.CollisionGroup = arg6
	end
	local workspace_Raycast_result1 = workspace:Raycast(arg1, arg2, RaycastParams_new_result1_2)
	if workspace_Raycast_result1 then
		local Instance_2 = workspace_Raycast_result1.Instance
		if Instance_2.CanCollide ~= false and (arg8 or 0.45 >= Instance_2.Transparency) or arg5 and (Instance_2.Parent:FindFirstChild("Humanoid") or Instance_2.Parent.Parent:FindFirstChild("Humanoid")) or Instance_2.Name == "Collision" then
			table.insert(var19, Instance_2)
			return module_upvr.Raycast(workspace_Raycast_result1.Position, arg2.Unit * (arg2.Magnitude - (workspace_Raycast_result1.Position - arg1).Magnitude), var19, arg4, arg5, arg6, arg7, arg8)
		end
	end
	return workspace_Raycast_result1
end
local function var23_upvr(arg1) -- Line 164
	local var25 = true
	if arg1.CanCollide ~= false then
		var25 = true
		if 0.45 >= arg1.Transparency then
			if arg1.Name ~= "Collision" then
				var25 = false
			else
				var25 = true
			end
		end
	end
	return var25
end
local RaycastParams_new_result1_upvr = RaycastParams.new()
RaycastParams_new_result1_upvr.FilterType = Enum.RaycastFilterType.Blacklist
RaycastParams_new_result1_upvr.FilterDescendantsInstances = {workspace:FindFirstChild("Ignore")}
RaycastParams_new_result1_upvr.IgnoreWater = true
function module_upvr.Raycast2(arg1, arg2, arg3, arg4) -- Line 173
	--[[ Upvalues[3]:
		[1]: RaycastParams_new_result1_upvr (readonly)
		[2]: var23_upvr (readonly)
		[3]: module_upvr (readonly)
	]]
	local var28 = arg3
	if not var28 then
		var28 = RaycastParams_new_result1_upvr
	end
	local var29 = var28
	local workspace_Raycast_result1_2 = workspace:Raycast(arg1, arg2, var29)
	if workspace_Raycast_result1_2 then
		local Instance = workspace_Raycast_result1_2.Instance
		local var32 = arg4
		if not var32 then
			var32 = var23_upvr
		end
		if var32(Instance, workspace_Raycast_result1_2.Position) then
			local RaycastParams_new_result1 = RaycastParams.new()
			RaycastParams_new_result1.FilterType = var29.FilterType
			local FilterDescendantsInstances = var29.FilterDescendantsInstances
			table.insert(FilterDescendantsInstances, Instance)
			RaycastParams_new_result1.FilterDescendantsInstances = FilterDescendantsInstances
			RaycastParams_new_result1.IgnoreWater = var29.IgnoreWater
			return module_upvr.Raycast2(arg1, arg2, RaycastParams_new_result1, arg4)
		end
	end
	return workspace_Raycast_result1_2
end
function module_upvr.GetTrackMagnitude(arg1, arg2) -- Line 198
	assert(arg1, "No track given")
	if not arg1.__Magnitude or arg2 then
		if #arg1 <= 1 then
			arg1.__Magnitude = 0
		else
			for var36 = 2, #arg1 do
				local Magnitude = (arg1[var36] - arg1[1]).Magnitude
				local var39
				local function INLINED_2() -- Internal function, doesn't exist in bytecode
					var39 = arg1.__Magnitude + Magnitude
					return var39
				end
				if not arg1.__Magnitude or not INLINED_2() then
					var39 = Magnitude
				end
				arg1.__Magnitude = var39
			end
		end
	end
	return arg1.__Magnitude
end
function module_upvr.GetVectorFromTrack(arg1, arg2) -- Line 217
	--[[ Upvalues[1]:
		[1]: module_upvr (readonly)
	]]
	local var41 = module_upvr.GetTrackMagnitude(arg2) * arg1
	local const_number = 0
	local _1_2 = arg2[1]
	for i = 2, #arg2 do
		local var44 = arg2[i]
		local Magnitude_2 = (var44 - _1_2).Magnitude
		if var41 < const_number + Magnitude_2 then
			return _1_2:lerp(var44, (var41 - const_number) / Magnitude_2)
		end
	end
end
function module_upvr.ShowTrack(arg1, arg2) -- Line 235
	assert(arg1, "No track given")
	local Folder = Instance.new("Folder")
	if 1 < #arg1 then
		local _1 = arg1[1]
		for i_2, v in pairs({
			[Color3.new(1, 0, 0)] = _1;
			[Color3.new(0, 1, 0)] = arg1[#arg1];
		}) do
			local Part = Instance.new("Part")
			Part.Color = i_2
			Part.Anchored = true
			Part.CanCollide = false
			Part.Shape = "Ball"
			Part.Size = Vector3.new(1, 1, 1)
			Part.Massless = true
			Part.CanTouch = false
			Part.CanQuery = false
			Part.Name = "VectorViewer"
			Part.CFrame = CFrame.new(v)
			Part.Parent = Folder
		end
		for i_3 = 2, #arg1 do
			i_2 = arg1[i_3]
			v = i_2 - _1
			local Part_2 = Instance.new("Part")
			local var60 = arg2
			if not var60 then
				var60 = Color3.new(0, 0, 1)
			end
			Part_2.Color = var60
			Part_2.Anchored = true
			Part_2.CanCollide = false
			Part_2.Size = Vector3.new(0.1, 0.1, (_1 - i_2).Magnitude)
			Part_2.Massless = true
			Part_2.CanTouch = false
			Part_2.CanQuery = false
			Part_2.Name = "VectorViewer"
			Part_2.CFrame = CFrame.new(_1 + v / 2, _1 + v)
			Part_2.Parent = Folder
		end
	end
	Folder.Parent = workspace.Ignore
end
local function _(arg1, arg2, arg3) -- Line 280, Named "lerp"
	return (arg2 - arg1) * arg3 + arg1
end
function module_upvr.SquareBezier(arg1, arg2, arg3, arg4) -- Line 284
	local var61 = (arg2 - arg1) * arg4 + arg1
	return ((arg3 - arg2) * arg4 + arg2 - var61) * arg4 + var61
end
function module_upvr.CubicBezier(arg1, arg2, arg3, arg4, arg5) -- Line 289
	local var62 = (arg2 - arg1) * arg5 + arg1
	local var63 = (arg3 - arg2) * arg5 + arg2
	local var64 = (var63 - var62) * arg5 + var62
	return (((arg4 - arg3) * arg5 + arg3 - var63) * arg5 + var63 - var64) * arg5 + var64
end
local CubicBezier_2_upvr = module_upvr.CubicBezier
function module_upvr.CubicBezierArcLength(arg1, arg2, arg3, arg4, arg5) -- Line 296
	--[[ Upvalues[1]:
		[1]: CubicBezier_2_upvr (readonly)
	]]
	local module = {0}
	local var69 = arg1
	local var70 = 0
	for i_4 = 1, arg5 - 1 do
		local CubicBezier_2_upvr_result1 = CubicBezier_2_upvr(arg1, arg2, arg3, arg4, i_4 / arg5)
		var70 += (var69 - CubicBezier_2_upvr_result1).Magnitude
		table.insert(module, var70)
		var69 = CubicBezier_2_upvr_result1
	end
	local var72 = var70 + (var69 - arg4).Magnitude
	table.insert(module, var72)
	return var72, module
end
function module_upvr.Lightning(arg1, arg2, arg3) -- Line 313
	local table_create_result1 = table.create(arg3, arg1)
	local var76 = (arg2 - arg1) / arg3
	for i_5 = 2, arg3 - 1 do
		table_create_result1[i_5] = arg1 + var76 * i_5 + Vector3.new(math.random() - 0.5, math.random() - 0.5, math.random() - 0.5)
	end
	table_create_result1[arg3] = arg2
	return table_create_result1
end
function module_upvr.KineticDirectionMath(arg1, arg2, arg3, arg4) -- Line 331
	-- KONSTANTWARNING: Variable analysis failed. Output will have some incorrect variable assignments
	local var77 = arg2 * arg2
	local var78
	if var77 ~= var77 then
	end
	if var78 ~= var78 then
		var78 = 0
	end
	local var79 = arg3 * arg3
	local var80 = arg1 * arg1 * (0 * (var78 * var78 - 1) + var79)
	if 0 < var80 then
		-- KONSTANTERROR: Expression was reused, decompilation is incorrect
		local var81 = (math.sqrt(var80) + arg2 * var78 * arg1) / (0 - var79)
		if 0 < var81 then
			return var81
		end
		-- KONSTANTERROR: Expression was reused, decompilation is incorrect
		local var82 = (-math.sqrt(var80) + arg2 * var78 * arg1) / (0 - var79)
		if 0 < var82 then
			return var82
		end
	end
	return nil
end
function module_upvr.KineticDirectionAccelerationMath(arg1, arg2, arg3, arg4) -- Line 356
end
local random_upvr = math.random
function module_upvr.Random() -- Line 362
	--[[ Upvalues[1]:
		[1]: random_upvr (readonly)
	]]
	return Vector3.new(random_upvr() * 2 - 1, random_upvr() * 2 - 1, random_upvr() * 2 - 1)
end
return module_upvr