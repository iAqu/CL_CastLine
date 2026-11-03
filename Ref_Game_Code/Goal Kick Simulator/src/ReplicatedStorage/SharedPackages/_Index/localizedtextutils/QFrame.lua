-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:24:56
-- Luau version 6, Types version 3
-- Time taken: 0.011066 seconds

local module_upvr = {}
module_upvr.__index = module_upvr
function module_upvr.new(arg1, arg2, arg3, arg4, arg5, arg6, arg7) -- Line 21
	--[[ Upvalues[1]:
		[1]: module_upvr (readonly)
	]]
	local setmetatable_result1 = setmetatable({}, module_upvr)
	setmetatable_result1.x = arg1 or 0
	setmetatable_result1.y = arg2 or 0
	setmetatable_result1.z = arg3 or 0
	setmetatable_result1.W = arg4 or 1
	setmetatable_result1.X = arg5 or 0
	setmetatable_result1.Y = arg6 or 0
	setmetatable_result1.Z = arg7 or 0
	return setmetatable_result1
end
function module_upvr.isQFrame(arg1) -- Line 39
	--[[ Upvalues[1]:
		[1]: module_upvr (readonly)
	]]
	local var3
	if getmetatable(arg1) ~= module_upvr then
		var3 = false
	else
		var3 = true
	end
	return var3
end
function module_upvr.fromCFrameClosestTo(arg1, arg2) -- Line 49
	--[[ Upvalues[1]:
		[1]: module_upvr (readonly)
	]]
	local var4
	if typeof(arg1) ~= "CFrame" then
		var4 = false
	else
		var4 = true
	end
	assert(var4, "Bad cframe")
	var4 = module_upvr.isQFrame(arg2)
	assert(var4, "Bad closestTo")
	local any_toAxisAngle_result1, any_toAxisAngle_result2 = arg1:toAxisAngle()
	local cosine_2 = math.cos(any_toAxisAngle_result2 / 2)
	local var8 = math.sin(any_toAxisAngle_result2 / 2) * any_toAxisAngle_result1.x
	local var9 = math.sin(any_toAxisAngle_result2 / 2) * any_toAxisAngle_result1.y
	local var10 = math.sin(any_toAxisAngle_result2 / 2) * any_toAxisAngle_result1.z
	if cosine_2 * arg2.W + var8 * arg2.X + var9 * arg2.Y + var10 * arg2.Z < 0 then
		return module_upvr.new(arg1.x, arg1.y, arg1.z, -cosine_2, -var8, -var9, -var10)
	end
	return module_upvr.new(arg1.x, arg1.y, arg1.z, cosine_2, var8, var9, var10)
end
function module_upvr.fromVector3(arg1, arg2) -- Line 74
	--[[ Upvalues[1]:
		[1]: module_upvr (readonly)
	]]
	local var11
	if typeof(arg1) ~= "Vector3" then
		var11 = false
	else
		var11 = true
	end
	assert(var11, "Bad vector")
	var11 = module_upvr.isQFrame(arg2)
	assert(var11)
	var11 = module_upvr
	var11 = arg1.x
	return var11.new(var11, arg1.y, arg1.z, arg2.W, arg2.X, arg2.Y, arg2.Z)
end
function module_upvr.toCFrame(arg1) -- Line 86
	local cframe = CFrame.new(arg1.x, arg1.y, arg1.z, arg1.X, arg1.Y, arg1.Z, arg1.W)
	if cframe == cframe then
		return cframe
	end
	return nil
end
function module_upvr.toPosition(arg1) -- Line 100
	return Vector3.new(arg1.x, arg1.y, arg1.z)
end
function module_upvr.isNAN(arg1) -- Line 109
	local var18 = true
	if arg1.x == arg1.x then
		var18 = true
		if arg1.y == arg1.y then
			var18 = true
			if arg1.z == arg1.z then
				var18 = true
				if arg1.W == arg1.W then
					var18 = true
					if arg1.X == arg1.X then
						var18 = true
						if arg1.Y == arg1.Y then
							if arg1.Z == arg1.Z then
								var18 = false
							else
								var18 = true
							end
						end
					end
				end
			end
		end
	end
	return var18
end
function module_upvr.__unm(arg1) -- Line 119
	--[[ Upvalues[1]:
		[1]: module_upvr (readonly)
	]]
	return module_upvr.new(-arg1.x, -arg1.y, -arg1.z, -arg1.W, -arg1.X, -arg1.Y, -arg1.Z)
end
function module_upvr.__add(arg1, arg2) -- Line 129
	--[[ Upvalues[1]:
		[1]: module_upvr (readonly)
	]]
	local any_isQFrame_result1 = module_upvr.isQFrame(arg1)
	if any_isQFrame_result1 then
		any_isQFrame_result1 = module_upvr.isQFrame(arg2)
	end
	assert(any_isQFrame_result1, "QFrame + non-QFrame attempted")
	return module_upvr.new(arg1.x + arg2.x, arg1.y + arg2.y, arg1.z + arg2.z, arg1.W + arg2.W, arg1.X + arg2.X, arg1.Y + arg2.Y, arg1.Z + arg2.Z)
end
function module_upvr.__sub(arg1, arg2) -- Line 142
	--[[ Upvalues[1]:
		[1]: module_upvr (readonly)
	]]
	local any_isQFrame_result1_2 = module_upvr.isQFrame(arg1)
	if any_isQFrame_result1_2 then
		any_isQFrame_result1_2 = module_upvr.isQFrame(arg2)
	end
	assert(any_isQFrame_result1_2, "QFrame - non-QFrame attempted")
	return module_upvr.new(arg1.x - arg2.x, arg1.y - arg2.y, arg1.z - arg2.z, arg1.W - arg2.W, arg1.X - arg2.X, arg1.Y - arg2.Y, arg1.Z - arg2.Z)
end
function module_upvr.__pow(arg1, arg2) -- Line 155
	--[[ Upvalues[1]:
		[1]: module_upvr (readonly)
	]]
	local any_isQFrame_result1_3 = module_upvr.isQFrame(arg1)
	if any_isQFrame_result1_3 then
		if type(arg2) ~= "number" then
			any_isQFrame_result1_3 = false
		else
			any_isQFrame_result1_3 = true
		end
	end
	assert(any_isQFrame_result1_3, "Bad a or b")
	local x = arg1.x
	local y = arg1.y
	local z = arg1.z
	local W = arg1.W
	local X = arg1.X
	local Y = arg1.Y
	local Z = arg1.Z
	local squareroot = math.sqrt(W * W + X * X + Y * Y + Z * Z)
	local squareroot_2 = math.sqrt(X * X + Y * Y + Z * Z)
	local var31 = squareroot ^ arg2
	if squareroot_2 <= squareroot * 1e-08 then
		return module_upvr.new(arg2 * x, arg2 * y, arg2 * z, var31, 0, 0, 0)
	end
	local var32 = X / squareroot_2
	local var33 = Y / squareroot_2
	local var34 = Z / squareroot_2
	local var35 = arg2 * math.atan2(squareroot_2, W)
	local cosine = math.cos(var35)
	local sine = math.sin(var35)
	local var38 = x * var32 + y * var33 + z * var34
	local var39 = var38 * var32
	local var40 = var38 * var33
	local var41 = var38 * var34
	local var42 = sine * (W / squareroot_2 * cosine + sine)
	local var43 = sine * (W / squareroot_2 * sine - cosine)
	return module_upvr.new(var42 * (x - var39) + var43 * (var33 * z - var34 * y) + arg2 * var39, var42 * (y - var40) + var43 * (var34 * x - var32 * z) + arg2 * var40, var42 * (z - var41) + var43 * (var32 * y - var33 * x) + arg2 * var41, var31 * cosine, var31 * sine * var32, var31 * sine * var33, var31 * sine * var34)
end
function module_upvr.__mul(arg1, arg2) -- Line 208
	--[[ Upvalues[1]:
		[1]: module_upvr (readonly)
	]]
	if type(arg1) == "number" and module_upvr.isQFrame(arg2) then
		return module_upvr.new(arg1 * arg2.x, arg1 * arg2.y, arg1 * arg2.z, arg1 * arg2.W, arg1 * arg2.X, arg1 * arg2.Y, arg1 * arg2.Z)
	end
	if module_upvr.isQFrame(arg1) and type(arg2) == "number" then
		return module_upvr.new(arg1.x * arg2, arg1.y * arg2, arg1.z * arg2, arg1.W * arg2, arg1.X * arg2, arg1.Y * arg2, arg1.Z * arg2)
	end
	if module_upvr.isQFrame(arg1) and module_upvr.isQFrame(arg2) then
		local var44 = arg1.W * arg1.W + arg1.X * arg1.X + arg1.Y * arg1.Y + arg1.Z * arg1.Z
		return module_upvr.new(arg1.x + ((arg1.W * arg1.W + arg1.X * arg1.X - arg1.Y * arg1.Y - arg1.Z * arg1.Z) * arg2.x + 2 * (arg1.X * arg1.Y - arg1.W * arg1.Z) * arg2.y + 2 * (arg1.W * arg1.Y + arg1.X * arg1.Z) * arg2.z) / var44, arg1.y + (2 * (arg1.X * arg1.Y + arg1.W * arg1.Z) * arg2.x + (arg1.W * arg1.W - arg1.X * arg1.X + arg1.Y * arg1.Y - arg1.Z * arg1.Z) * arg2.y + 2 * (arg1.Y * arg1.Z - arg1.W * arg1.X) * arg2.z) / var44, arg1.z + (2 * (arg1.X * arg1.Z - arg1.W * arg1.Y) * arg2.x + 2 * (arg1.W * arg1.X + arg1.Y * arg1.Z) * arg2.y + (arg1.W * arg1.W - arg1.X * arg1.X - arg1.Y * arg1.Y + arg1.Z * arg1.Z) * arg2.z) / var44, arg1.W * arg2.W - arg1.X * arg2.X - arg1.Y * arg2.Y - arg1.Z * arg2.Z, arg1.W * arg2.X + arg1.X * arg2.W + arg1.Y * arg2.Z - arg1.Z * arg2.Y, arg1.W * arg2.Y - arg1.X * arg2.Z + arg1.Y * arg2.W + arg1.Z * arg2.X, arg1.W * arg2.Z + arg1.X * arg2.Y - arg1.Y * arg2.X + arg1.Z * arg2.W)
	end
	error("QFrame * non-QFrame attempted")
end
function module_upvr.__div(arg1, arg2) -- Line 238
	--[[ Upvalues[1]:
		[1]: module_upvr (readonly)
	]]
	if type(arg2) == "number" then
		return module_upvr.new(arg1.x / arg2, arg1.y / arg2, arg1.z / arg2, arg1.W / arg2, arg1.X / arg2, arg1.Y / arg2, arg1.Z / arg2)
	end
	error("QFrame / non-QFrame attempted")
end
function module_upvr.__eq(arg1, arg2) -- Line 252
	local var45 = false
	if arg1.x == arg2.x then
		var45 = false
		if arg1.y == arg2.y then
			var45 = false
			if arg1.z == arg2.z then
				var45 = false
				if arg1.W == arg2.W then
					var45 = false
					if arg1.X == arg2.X then
						var45 = false
						if arg1.Y == arg2.Y then
							if arg1.Z ~= arg2.Z then
								var45 = false
							else
								var45 = true
							end
						end
					end
				end
			end
		end
	end
	return var45
end
return module_upvr