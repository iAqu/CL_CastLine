-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:26:03
-- Luau version 6, Types version 3
-- Time taken: 0.007314 seconds

local module_2_upvr = {}
function module_2_upvr.getPartsBoundingBox(arg1, arg2) -- Line 16
	--[[ Upvalues[1]:
		[1]: module_2_upvr (readonly)
	]]
	return module_2_upvr.getBoundingBox(arg1, arg2)
end
function module_2_upvr.clampPointToBoundingBox(arg1, arg2, arg3) -- Line 31
	local any_pointToObjectSpace_result1_8 = arg1:pointToObjectSpace(arg3)
	local var3 = arg2 * 0.5
	return arg1 * Vector3.new(math.clamp(any_pointToObjectSpace_result1_8.x, -var3.x, var3.x), math.clamp(any_pointToObjectSpace_result1_8.y, -var3.y, var3.y), math.clamp(any_pointToObjectSpace_result1_8.z, -var3.z, var3.z)), arg1.Position
end
function module_2_upvr.pushPointToLieOnBoundingBox(arg1, arg2, arg3) -- Line 49
	-- KONSTANTWARNING: Variable analysis failed. Output will have some incorrect variable assignments
	local any_pointToObjectSpace_result1 = arg1:pointToObjectSpace(arg3)
	local var5 = arg2 * 0.5
	local var6
	local function INLINED() -- Internal function, doesn't exist in bytecode
		var6 = -var5.x
		return var6
	end
	if any_pointToObjectSpace_result1.x >= 0 or not INLINED() then
		var6 = var5.x
	end
	if any_pointToObjectSpace_result1.y >= 0 or not -var5.y then
	end
	if any_pointToObjectSpace_result1.z >= 0 or not -var5.z then
	end
	return arg1 * Vector3.new(var6, var5.y, var5.z), arg1.Position
end
function module_2_upvr.getChildrenBoundingBox(arg1, arg2) -- Line 66
	--[[ Upvalues[1]:
		[1]: module_2_upvr (readonly)
	]]
	local module = {}
	for _, v in pairs(arg1:GetDescendants()) do
		if v:IsA("BasePart") then
			table.insert(module, v)
		end
	end
	if not next(module) then
		return nil, nil
	end
	return module_2_upvr.getPartsBoundingBox(module, arg2)
end
function module_2_upvr.axisAlignedBoxSize(arg1, arg2) -- Line 87
	local any_inverse_result1 = arg1:inverse()
	local var14 = arg2 * any_inverse_result1.XVector
	local var15 = arg2 * any_inverse_result1.YVector
	local var16 = arg2 * any_inverse_result1.ZVector
	return Vector3.new(math.abs(var14.x) + math.abs(var14.y) + math.abs(var14.z), math.abs(var15.x) + math.abs(var15.y) + math.abs(var15.z), math.abs(var16.x) + math.abs(var16.y) + math.abs(var16.z))
end
function module_2_upvr.getBoundingBox(arg1, arg2) -- Line 112
	-- KONSTANTWARNING: Variable analysis failed. Output will have some incorrect variable assignments
	local var25 = arg2
	if not var25 then
		var25 = CFrame.new()
	end
	for _, v_2 in pairs(arg1) do
		local Size = v_2.Size
		local X = Size.X
		local Y = Size.Y
		local Z = Size.Z
		local any_components_result1, any_components_result2, any_components_result3, any_components_result4, any_components_result5, any_components_result6, any_components_result7, any_components_result8, any_components_result9, any_components_result10, any_components_result11, any_components_result12 = var25:toObjectSpace(v_2.CFrame):components()
		local var45 = 0.5 * (math.abs(any_components_result4) * X + math.abs(any_components_result5) * Y + math.abs(any_components_result6) * Z)
		local var46 = 0.5 * (math.abs(any_components_result7) * X + math.abs(any_components_result8) * Y + math.abs(any_components_result9) * Z)
		local var47 = 0.5 * (math.abs(any_components_result10) * X + math.abs(any_components_result11) * Y + math.abs(any_components_result12) * Z)
		if any_components_result1 - var45 < math.huge then
			local var48 = any_components_result1 - var45
		end
		if any_components_result2 - var46 < math.huge then
			local var49 = any_components_result2 - var46
		end
		if any_components_result3 - var47 < math.huge then
			local var50 = any_components_result3 - var47
		end
		if (-math.huge) < any_components_result1 + var45 then
			local var51 = any_components_result1 + var45
		end
		if (-math.huge) < any_components_result2 + var46 then
			local var52 = any_components_result2 + var46
		end
		if (-math.huge) < any_components_result3 + var47 then
			local var53 = any_components_result3 + var47
		end
	end
	return Vector3.new(var51 - var48, var52 - var49, var53 - var50), Vector3.new((var51 + var48) / 2, (var52 + var49) / 2, (var53 + var50) / 2)
end
function module_2_upvr.inBoundingBox(arg1, arg2, arg3) -- Line 164
	local any_pointToObjectSpace_result1_7 = arg1:pointToObjectSpace(arg3)
	local var83 = arg2.X / 2
	local var84 = arg2.Y / 2
	local var85 = arg2.Z / 2
	local x = any_pointToObjectSpace_result1_7.x
	local y_5 = any_pointToObjectSpace_result1_7.y
	local z_4 = any_pointToObjectSpace_result1_7.z
	local var89 = false
	if -var83 <= x then
		var89 = false
		if x <= var83 then
			var89 = false
			if -var84 <= y_5 then
				var89 = false
				if y_5 <= var84 then
					var89 = false
					if -var85 <= z_4 then
						if z_4 > var85 then
							var89 = false
						else
							var89 = true
						end
					end
				end
			end
		end
	end
	return var89
end
function module_2_upvr.inCylinderBoundingBox(arg1, arg2, arg3) -- Line 185
	local any_pointToObjectSpace_result1_3 = arg1:pointToObjectSpace(arg3)
	local var91 = math.min(arg2.y, arg2.z) / 2
	local y_6 = any_pointToObjectSpace_result1_3.y
	local z_3 = any_pointToObjectSpace_result1_3.z
	local var94 = false
	if math.abs(any_pointToObjectSpace_result1_3.x) <= arg2.x / 2 then
		if y_6 * y_6 + z_3 * z_3 > var91 * var91 then
			var94 = false
		else
			var94 = true
		end
	end
	return var94
end
function module_2_upvr.inBallBoundingBox(arg1, arg2, arg3) -- Line 204
	local any_pointToObjectSpace_result1_5 = arg1:pointToObjectSpace(arg3)
	local var96 = math.min(arg2.x, arg2.y, arg2.z) / 2
	local x_2 = any_pointToObjectSpace_result1_5.x
	local y = any_pointToObjectSpace_result1_5.y
	local z = any_pointToObjectSpace_result1_5.z
	local var100 = x_2 * x_2 + y * y
	if var100 + z * z > var96 * var96 then
		var100 = false
	else
		var100 = true
	end
	return var100
end
return module_2_upvr