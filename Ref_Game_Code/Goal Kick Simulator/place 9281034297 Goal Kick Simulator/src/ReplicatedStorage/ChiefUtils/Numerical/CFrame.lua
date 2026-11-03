-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:20:15
-- Luau version 6, Types version 3
-- Time taken: 0.009339 seconds

local module_upvr = {}
local abs_upvr = math.abs
local new = CFrame.new
local components_upvr = new().components
local inverse_upvr = new().inverse
local fromAxisAngle_upvr = CFrame.fromAxisAngle
local new_upvr = Vector3.new
function module_upvr.AxisAngleInterpolate(arg1, arg2, arg3) -- Line 10
	--[[ Upvalues[4]:
		[1]: components_upvr (readonly)
		[2]: inverse_upvr (readonly)
		[3]: fromAxisAngle_upvr (readonly)
		[4]: new_upvr (readonly)
	]]
	-- KONSTANTWARNING: Variable analysis failed. Output will have some incorrect variable assignments
	local _, _, _, components_upvr_result4, components_upvr_result5, components_upvr_result6, components_upvr_result7, components_upvr_result8, var4_result9, var4_result10, var4_result11, var4_result12 = components_upvr(inverse_upvr(arg1) * arg2)
	local var20 = (components_upvr_result4 + components_upvr_result8 + var4_result12 - 1) / 2
	local var21
	local function INLINED() -- Internal function, doesn't exist in bytecode
		var21 = components_upvr_result7 - components_upvr_result5
		return new_upvr(var4_result11 - var4_result9, components_upvr_result6 - var4_result10, var21)
	end
	if math.abs(var20) >= 1 or not INLINED() then
	end
	if 1 < var20 then
		var21 = 1
	elseif var20 < -1 then
		var21 = -1
	else
		var21 = var20
	end
	return arg1 * fromAxisAngle_upvr(Vector3.new(0, 1, 0), math.acos(var21) * arg3) + (arg2.p - arg1.p) * arg3
end
function module_upvr.PosInObj(arg1, arg2, arg3, arg4) -- Line 18
	--[[ Upvalues[1]:
		[1]: abs_upvr (readonly)
	]]
	if abs_upvr(arg1[4] * arg2 + arg1[5] * arg3 + arg1[6] * arg4 + arg1[1]) < 1 and abs_upvr(arg1[7] * arg2 + arg1[8] * arg3 + arg1[9] * arg4 + arg1[2]) < 1 and abs_upvr(arg1[10] * arg2 + arg1[11] * arg3 + arg1[12] * arg4 + arg1[3]) < 1 then
		return true
	end
	return false
end
function module_upvr.PosInObjBlock(arg1, arg2, arg3, arg4) -- Line 37
	--[[ Upvalues[1]:
		[1]: abs_upvr (readonly)
	]]
	local var22 = arg1[4] * arg2 + arg1[5] * arg3 + arg1[6] * arg4 + arg1[1]
	local var23 = arg1[7] * arg2 + arg1[8] * arg3 + arg1[9] * arg4 + arg1[2]
	local var24 = arg1[10] * arg2 + arg1[11] * arg3 + arg1[12] * arg4 + arg1[3]
	local var2_result1_3 = abs_upvr(var22)
	local var2_result1 = abs_upvr(var23)
	local abs_upvr_result1_2 = abs_upvr(var24)
	if var2_result1_3 < 1.03 and var2_result1 < 1.03 and abs_upvr_result1_2 < 1.03 then
		if var2_result1 < var2_result1_3 then
			if abs_upvr_result1_2 < var2_result1_3 then
				local var28 = var2_result1_3 / var22
				return arg1[13] * var28, arg1[14] * var28, arg1[15] * var28
			end
			local var29 = abs_upvr_result1_2 / var24
			return arg1[19] * var29, arg1[20] * var29, arg1[21] * var29
		end
		if abs_upvr_result1_2 < var2_result1 then
			local var30 = var2_result1 / var23
			return arg1[16] * var30, arg1[17] * var30, arg1[18] * var30
		end
		local var31 = abs_upvr_result1_2 / var24
		return arg1[19] * var31, arg1[20] * var31, arg1[21] * var31
	end
	return false
end
function module_upvr.GetInvSizeComponents(arg1, arg2) -- Line 63
	local any_components_result1_3, any_components_result2, any_components_result3_2, any_components_result4_3, any_components_result5, any_components_result6_3, any_components_result7_3, any_components_result8_2, any_components_result9_3, any_components_result10_2, any_components_result11_2, any_components_result12_4 = arg1:inverse():components()
	local var44 = arg2.x / 2
	local var45 = arg2.y / 2
	local var46 = arg2.z / 2
	return {any_components_result1_3 / var44, any_components_result2 / var45, any_components_result3_2 / var46, any_components_result4_3 / var44, any_components_result5 / var44, any_components_result6_3 / var44, any_components_result7_3 / var45, any_components_result8_2 / var45, any_components_result9_3 / var45, any_components_result10_2 / var46, any_components_result11_2 / var46, any_components_result12_4 / var46}
end
function module_upvr.NormalOfPart(arg1, arg2) -- Line 72
	--[[ Upvalues[1]:
		[1]: abs_upvr (readonly)
	]]
	local x = arg2.x
	local y = arg2.y
	local z_2 = arg2.z
	local Size = arg1.Size
	local CFrame = arg1.CFrame
	local _, _, _, any_components_result4_2, any_components_result5_4, any_components_result6_4, any_components_result7, any_components_result8_3, any_components_result9_2, any_components_result10, any_components_result11, any_components_result12 = CFrame:components()
	local any_components_result1, any_components_result2_2, any_components_result3, any_components_result4_4, any_components_result5_2, any_components_result6_2, any_components_result7_2, any_components_result8, any_components_result9, any_components_result10_4, any_components_result11_4, any_components_result12_2 = CFrame:inverse():components()
	local var77 = Size.x / 2
	local var78 = Size.y / 2
	local var79 = Size.z / 2
	local module = {any_components_result1 / var77, any_components_result2_2 / var78, any_components_result3 / var79, any_components_result4_4 / var77, any_components_result5_2 / var77, any_components_result6_2 / var77, any_components_result7_2 / var78, any_components_result8 / var78, any_components_result9 / var78, any_components_result10_4 / var79, any_components_result11_4 / var79, any_components_result12_2 / var79, any_components_result4_2, any_components_result7, any_components_result10, any_components_result5_4, any_components_result8_3, any_components_result11, any_components_result6_4, any_components_result9_2, any_components_result12}
	local var81 = module[4] * x + module[5] * y + module[6] * z_2 + module[1]
	local var82 = module[7] * x + module[8] * y + module[9] * z_2 + module[2]
	local var83 = module[10] * x + module[11] * y + module[12] * z_2 + module[3]
	local var2_result1_2 = abs_upvr(var81)
	local abs_upvr_result1_3 = abs_upvr(var82)
	local abs_upvr_result1 = abs_upvr(var83)
	if abs_upvr_result1_3 < var2_result1_2 then
		if abs_upvr_result1 < var2_result1_2 then
			local var87 = var2_result1_2 / var81
			return Vector3.new(module[13] * var87, module[14] * var87, module[15] * var87)
		end
		local var88 = abs_upvr_result1 / var83
		return Vector3.new(module[19] * var88, module[20] * var88, module[21] * var88)
	end
	if abs_upvr_result1 < abs_upvr_result1_3 then
		local var89 = abs_upvr_result1_3 / var82
		return Vector3.new(module[16] * var89, module[17] * var89, module[18] * var89)
	end
	local var90 = abs_upvr_result1 / var83
	return Vector3.new(module[19] * var90, module[20] * var90, module[21] * var90)
end
function module_upvr.InsidePart(arg1, arg2, arg3) -- Line 105
	--[[ Upvalues[1]:
		[1]: abs_upvr (readonly)
	]]
	local var91 = arg3 or 1
	local x_2 = arg2.x
	local y_2 = arg2.y
	local z = arg2.z
	local any_components_result1_2, any_components_result2_3, any_components_result3_3, any_components_result4, any_components_result5_3, any_components_result6, any_components_result7_4, any_components_result8_4, any_components_result9_4, any_components_result10_3, any_components_result11_3, any_components_result12_3 = arg1.CFrame:inverse():components()
	local Size_2 = arg1.Size
	local var108 = Size_2.x / 2
	local var109 = Size_2.y / 2
	local var110 = Size_2.z / 2
	if abs_upvr(any_components_result4 / var108 * x_2 + any_components_result5_3 / var108 * y_2 + any_components_result6 / var108 * z + any_components_result1_2 / var108) < var91 and abs_upvr(any_components_result7_4 / var109 * x_2 + any_components_result8_4 / var109 * y_2 + any_components_result9_4 / var109 * z + any_components_result2_3 / var109) < var91 and abs_upvr(any_components_result10_3 / var110 * x_2 + any_components_result11_3 / var110 * y_2 + any_components_result12_3 / var110 * z + any_components_result3_3 / var110) < var91 then
		return true
	end
	return false
end
function module_upvr.GetChildrenInRange(arg1, arg2, arg3, arg4) -- Line 118
	--[[ Upvalues[1]:
		[1]: module_upvr (readonly)
	]]
	local module_2 = {}
	for _, v in pairs(arg1:GetChildren()) do
		local var119
		local function INLINED_2() -- Internal function, doesn't exist in bytecode
			var119 = v.PrimaryPart.Position
			return var119
		end
		local function INLINED_3() -- Internal function, doesn't exist in bytecode
			var119 = v.Position
			return var119
		end
		if not v:IsA("Model") or not v.PrimaryPart or not INLINED_2() or not v:IsA("BasePart") or not INLINED_3() then
			var119 = nil
		end
		local function INLINED_4() -- Internal function, doesn't exist in bytecode
			tbl.Size = arg3
			tbl.CFrame = arg2
			local tbl = {}
			return module_upvr.InsidePart(tbl, var119)
		end
		local function INLINED_5() -- Internal function, doesn't exist in bytecode
			local class_Humanoid = v:FindFirstChildOfClass("Humanoid")
			return class_Humanoid
		end
		if var119 and INLINED_4() and INLINED_5() and (not arg4 or not arg4[class_Humanoid]) then
			module_2[#module_2 + 1] = {
				Humanoid = class_Humanoid;
				Position = var119;
				Model = v;
			}
		end
	end
	return module_2
end
function module_upvr.CreatePart(arg1, arg2) -- Line 132
	local Part_upvr = Instance.new("Part")
	Part_upvr.Size = Vector3.new()
	Part_upvr.Anchored = true
	Part_upvr.Massless = true
	Part_upvr.CanCollide = false
	Part_upvr.Position = arg1
	Part_upvr.Transparency = 1
	Part_upvr.Parent = workspace
	if arg2 then
		task.delay(arg2, function() -- Line 143
			--[[ Upvalues[1]:
				[1]: Part_upvr (readonly)
			]]
			Part_upvr:Destroy()
		end)
	end
	return Part_upvr
end
function module_upvr.Weld(arg1, arg2, arg3, arg4, arg5) -- Line 151
	local Weld_2 = Instance.new("Weld")
	Weld_2.Part0 = arg1
	Weld_2.Part1 = arg2
	local var126 = arg4
	if not var126 then
		var126 = arg1.CFrame:Inverse() * arg2.CFrame
	end
	Weld_2.C0 = var126
	var126 = arg5
	local var127 = var126
	if not var127 then
		var127 = CFrame.new()
	end
	Weld_2.C1 = var127
	Weld_2.Parent = arg3 or arg1
	return Weld_2
end
function module_upvr.RigToPrimaryPart(arg1, arg2) -- Line 162
	--[[ Upvalues[1]:
		[1]: module_upvr (readonly)
	]]
	if not arg2 then
		return warn("No PrimaryPart given!")
	end
	for _, v_2 in pairs(arg1:GetDescendants()) do
		if v_2:IsA("BasePart") and v_2 ~= arg2 then
			module_upvr.Weld(v_2, arg2)
		end
	end
	return arg1
end
function module_upvr.Motor6D(arg1, arg2, arg3, arg4, arg5, arg6) -- Line 172
	local var133 = arg3 or arg1
	local cframe = CFrame.new(var133.Position)
	local NEVER = CFrame.Angles(var133.CFrame:ToEulerAnglesXYZ())
	local Motor6D_2 = Instance.new("Motor6D")
	Motor6D_2.Part0 = arg1
	Motor6D_2.Part1 = arg2
	local var137 = arg5
	if not var137 then
		var137 = arg1.CFrame:inverse() * cframe * NEVER
	end
	Motor6D_2.C0 = var137
	var137 = arg5
	local var138 = var137
	if not var138 then
		var138 = arg2.CFrame:inverse() * cframe * NEVER
	end
	Motor6D_2.C1 = var138
	Motor6D_2.Parent = arg4 or arg1
	return Motor6D_2
end
return module_upvr