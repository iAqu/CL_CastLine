-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:20:25
-- Luau version 6, Types version 3
-- Time taken: 0.003162 seconds

local module_upvr = {
	getCubeoidDiameter = function(arg1) -- Line 31, Named "getCubeoidDiameter"
		return math.sqrt(arg1.x ^ 2 + arg1.y ^ 2 + arg1.z ^ 2)
	end;
}
function module_upvr.fitBoundingBoxToCamera(arg1, arg2, arg3) -- Line 44
	--[[ Upvalues[1]:
		[1]: module_upvr (readonly)
	]]
	return module_upvr.fitSphereToCamera(module_upvr.getCubeoidDiameter(arg1) / 2, arg2, arg3)
end
function module_upvr.GetBoundingBox(arg1, arg2) -- Line 49
	if not arg2 then
	else
		if arg2:IsA("Model") then
			return arg2:GetBoundingBox()
		end
		if arg2:IsA("BasePart") then
			return arg2.CFrame, arg2.Size
		end
	end
end
function module_upvr.getBoundingBoxOf(arg1) -- Line 58
	--[[ Upvalues[1]:
		[1]: module_upvr (readonly)
	]]
	-- KONSTANTWARNING: Variable analysis failed. Output will have some incorrect variable assignments
	local var22
	local var26
	for _, v in pairs(arg1) do
		local any_GetBoundingBox_result1, any_GetBoundingBox_result2 = module_upvr:GetBoundingBox(v)
		if any_GetBoundingBox_result1 and any_GetBoundingBox_result2 then
			local var29 = any_GetBoundingBox_result2 / 2
			for i_2 = -1, 1, 2 do
				for i_3 = -1, 1, 2 do
					for i_4 = -1, 1, 2 do
						local var30 = any_GetBoundingBox_result1 * CFrame.new(var29.X * i_4, var29.Y * i_2, var29.Z * i_3)
						if not var26 then
							var26 = var30
						else
							var26 = Vector3.new(math.max(var26.X, var30.X), math.max(var26.Y, var30.Y), math.max(var26.Z, var30.Z))
						end
						if not var22 then
							local var31 = var30
						else
						end
					end
				end
			end
		end
	end
	-- KONSTANTERROR: Expression was reused, decompilation is incorrect (x3)
	return CFrame.new((var26 + Vector3.new(math.min(var31.X, var30.X), math.min(var31.Y, var30.Y), math.min(var31.Z, var30.Z))) / 2), Vector3.new(var26.X - Vector3.new(math.min(var31.X, var30.X), math.min(var31.Y, var30.Y), math.min(var31.Z, var30.Z)).X, var26.Y - Vector3.new(math.min(var31.X, var30.X), math.min(var31.Y, var30.Y), math.min(var31.Z, var30.Z)).Y, var26.Z - Vector3.new(math.min(var31.X, var30.X), math.min(var31.Y, var30.Y), math.min(var31.Z, var30.Z)).Z)
end
function module_upvr.fitSphereToCamera(arg1, arg2, arg3) -- Line 114
	local var32 = math.rad(arg2) * 0.5
	if arg3 < 1 then
		var32 = math.atan(arg3 * math.tan(var32))
	end
	return arg1 / math.sin(var32)
end
function module_upvr.isOnScreen(arg1, arg2) -- Line 130
	local _, any_WorldToScreenPoint_result2 = arg1:WorldToScreenPoint(arg2)
	return any_WorldToScreenPoint_result2
end
return module_upvr