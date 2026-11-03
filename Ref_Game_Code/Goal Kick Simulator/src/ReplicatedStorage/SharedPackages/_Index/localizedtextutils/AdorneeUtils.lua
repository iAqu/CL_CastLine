-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:27:03
-- Luau version 6, Types version 3
-- Time taken: 0.008391 seconds

local module_upvr = {
	getCenter = function(arg1) -- Line 16, Named "getCenter"
		local var6
		if typeof(arg1) ~= "Instance" then
			var6 = false
		else
			var6 = true
		end
		assert(var6, "Adornee must by of type 'Instance'")
		if arg1:IsA("BasePart") then
			return arg1.Position
		end
		if arg1:IsA("Model") then
			var6 = arg1:GetBoundingBox()
			return var6.p
		end
		if arg1:IsA("Attachment") then
			return arg1.WorldPosition
		end
		if arg1:IsA("Humanoid") then
			local RootPart_2 = arg1.RootPart
			if RootPart_2 then
				var6 = RootPart_2.Position
				return var6
			end
			var6 = nil
			return var6
		end
		if arg1:IsA("Accessory") or arg1:IsA("Clothing") then
			local class_BasePart_2 = arg1:FindFirstChildWhichIsA("BasePart")
			if class_BasePart_2 then
				var6 = class_BasePart_2.Position
				return var6
			end
			var6 = nil
			return var6
		end
		if arg1:IsA("Tool") then
			local Handle = arg1:FindFirstChild("Handle")
			if Handle then
				var6 = Handle:IsA("BasePart")
				if var6 then
					var6 = Handle.Position
					return var6
				end
			end
			var6 = nil
			return var6
		end
		return nil
	end;
}
function module_upvr.getBoundingBox(arg1) -- Line 57
	--[[ Upvalues[1]:
		[1]: module_upvr (readonly)
	]]
	if arg1:IsA("Model") then
		return arg1:GetBoundingBox()
	end
	if arg1:IsA("Attachment") then
		return arg1.WorldCFrame, Vector3.new(0, 0, 0)
	end
	return module_upvr.getPartCFrame(arg1), module_upvr.getAlignedSize(arg1)
end
function module_upvr.isPartOfAdornee(arg1, arg2) -- Line 73
	assert(arg2:IsA("BasePart"))
	if arg1:IsA("Humanoid") then
		if not arg1.Parent then
			return false
		end
		return arg2:IsDescendantOf(arg1.Parent)
	end
	local var10 = true
	if arg1 ~= arg2 then
		var10 = arg2:IsDescendantOf(arg1)
	end
	return var10
end
function module_upvr.getParts(arg1) -- Line 92
	local var15
	if typeof(arg1) ~= "Instance" then
		var15 = false
	else
		var15 = true
	end
	assert(var15, "Adornee must by of type 'Instance'")
	var15 = arg1:IsA("BasePart")
	if var15 then
		var15 = table.insert
		var15({}, arg1)
	end
	var15 = nil
	if arg1:IsA("Humanoid") then
		var15 = arg1.Parent
	else
		var15 = arg1
	end
	if var15 then
		for _, v in pairs(var15:GetDescendants()) do
			if v:IsA("BasePart") then
				-- KONSTANTERROR: Expression was reused, decompilation is incorrect
				table.insert({}, v)
			end
		end
	end
	-- KONSTANTERROR: Expression was reused, decompilation is incorrect
	return {}
end
function module_upvr.getAlignedSize(arg1) -- Line 123
	--[[ Upvalues[1]:
		[1]: module_upvr (readonly)
	]]
	if arg1:IsA("Model") then
		return select(2, arg1:GetBoundingBox())
	end
	if arg1:IsA("Humanoid") then
		if arg1.Parent then
			return select(2, arg1.Parent:GetBoundingBox())
		end
		return nil
	end
	local any_getPart_result1_2 = module_upvr.getPart(arg1)
	if any_getPart_result1_2 then
		return any_getPart_result1_2.Size
	end
	return nil
end
function module_upvr.getPartCFrame(arg1) -- Line 147
	--[[ Upvalues[1]:
		[1]: module_upvr (readonly)
	]]
	local var20
	if typeof(arg1) ~= "Instance" then
		var20 = false
	else
		var20 = true
	end
	assert(var20, "Adornee must by of type 'Instance'")
	var20 = module_upvr
	var20 = arg1
	local any_getPart_result1_3 = var20.getPart(var20)
	if not any_getPart_result1_3 then
		var20 = nil
		return var20
	end
	var20 = any_getPart_result1_3.CFrame
	return var20
end
function module_upvr.getPartPosition(arg1) -- Line 163
	--[[ Upvalues[1]:
		[1]: module_upvr (readonly)
	]]
	local var22
	if typeof(arg1) ~= "Instance" then
		var22 = false
	else
		var22 = true
	end
	assert(var22, "Adornee must by of type 'Instance'")
	var22 = module_upvr
	var22 = arg1
	local any_getPart_result1 = var22.getPart(var22)
	if not any_getPart_result1 then
		var22 = nil
		return var22
	end
	var22 = any_getPart_result1.Position
	return var22
end
function module_upvr.getPartVelocity(arg1) -- Line 179
	--[[ Upvalues[1]:
		[1]: module_upvr (readonly)
	]]
	local any_getPart_result1_4 = module_upvr.getPart(arg1)
	if not any_getPart_result1_4 then
		return nil
	end
	return any_getPart_result1_4.Velocity
end
function module_upvr.getPart(arg1) -- Line 193
	local var27
	if typeof(arg1) ~= "Instance" then
		var27 = false
	else
		var27 = true
	end
	assert(var27, "Adornee must by of type 'Instance'")
	if arg1:IsA("BasePart") then
		return arg1
	end
	if arg1:IsA("Model") then
		if arg1.PrimaryPart then
			return arg1.PrimaryPart
		end
		return arg1:FindFirstChildWhichIsA("BasePart")
	end
	if arg1:IsA("Attachment") then
		return arg1.Parent
	end
	if arg1:IsA("Humanoid") then
		return arg1.RootPart
	end
	if arg1:IsA("Accessory") or arg1:IsA("Clothing") then
		return arg1:FindFirstChildWhichIsA("BasePart")
	end
	if arg1:IsA("Tool") then
		local Handle_3 = arg1:FindFirstChild("Handle")
		if Handle_3 then
			var27 = Handle_3:IsA("BasePart")
			if var27 then
				return Handle_3
			end
		end
		var27 = nil
		return var27
	end
	return nil
end
function module_upvr.getRenderAdornee(arg1) -- Line 227
	local var31
	if typeof(arg1) ~= "Instance" then
		var31 = false
	else
		var31 = true
	end
	assert(var31, "Adornee must by of type 'Instance'")
	if arg1:IsA("BasePart") then
		return arg1
	end
	if arg1:IsA("Model") then
		return arg1
	end
	if arg1:IsA("Attachment") then
		return arg1
	end
	if arg1:IsA("Humanoid") then
		return arg1.Parent
	end
	if arg1:IsA("Accessory") or arg1:IsA("Clothing") then
		return arg1:FindFirstChildWhichIsA("BasePart")
	end
	if arg1:IsA("Tool") then
		local Handle_6 = arg1:FindFirstChild("Handle")
		if Handle_6 then
			var31 = Handle_6:IsA("BasePart")
			if var31 then
				return Handle_6
			end
		end
		var31 = nil
		return var31
	end
	return nil
end
return module_upvr