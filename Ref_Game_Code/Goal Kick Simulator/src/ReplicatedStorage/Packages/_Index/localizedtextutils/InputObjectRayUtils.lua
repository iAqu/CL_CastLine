-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:24:32
-- Luau version 6, Types version 3
-- Time taken: 0.001953 seconds

local Workspace_upvr = game:GetService("Workspace")
local module_upvr = {}
function module_upvr.cameraRayFromInputObject(arg1, arg2, arg3, arg4) -- Line 20
	--[[ Upvalues[1]:
		[1]: module_upvr (readonly)
	]]
	assert(arg1, "Bad inputObject")
	local var3 = arg3
	if not var3 then
		var3 = Vector3.new()
	end
	local var4 = var3
	local Position = arg1.Position
	return module_upvr.cameraRayFromScreenPosition(Vector2.new(Position.x + var4.x, Position.y + var4.y), arg2, arg4)
end
function module_upvr.cameraRayFromMouse(arg1, arg2, arg3, arg4) -- Line 36
	--[[ Upvalues[1]:
		[1]: module_upvr (readonly)
	]]
	assert(arg1, "Bad mouse")
	local var6 = arg3 or Vector3.new(0, 0, 0)
	return module_upvr.cameraRayFromScreenPosition(Vector2.new(arg1.x + var6.x, arg1.y + var6.y), arg2, arg4)
end
function module_upvr.cameraRayFromInputObjectWithOffset(arg1, arg2, arg3, arg4) -- Line 53
	--[[ Upvalues[1]:
		[1]: module_upvr (readonly)
	]]
	assert(arg1, "Bad inputObject")
	local Position_2 = arg1.Position
	return module_upvr.cameraRayFromScreenPosition(Vector2.new(Position_2.x + arg3.x, Position_2.y + arg3.y), arg2, arg4)
end
function module_upvr.cameraRayFromScreenPosition(arg1, arg2, arg3) -- Line 69
	--[[ Upvalues[1]:
		[1]: Workspace_upvr (readonly)
	]]
	local var8 = arg3
	if not var8 then
		var8 = Workspace_upvr.CurrentCamera
	end
	local any_ScreenPointToRay_result1 = var8:ScreenPointToRay(arg1.X, arg1.Y)
	return Ray.new(any_ScreenPointToRay_result1.Origin, any_ScreenPointToRay_result1.Direction.unit * (arg2 or 1000))
end
function module_upvr.cameraRayFromViewportPosition(arg1, arg2, arg3) -- Line 83
	--[[ Upvalues[1]:
		[1]: Workspace_upvr (readonly)
	]]
	local var10 = arg3
	if not var10 then
		var10 = Workspace_upvr.CurrentCamera
	end
	local any_ViewportPointToRay_result1 = var10:ViewportPointToRay(arg1.X, arg1.Y)
	return Ray.new(any_ViewportPointToRay_result1.Origin, any_ViewportPointToRay_result1.Direction.unit * (arg2 or 1000))
end
function module_upvr.generateCircleRays(arg1, arg2, arg3) -- Line 98
	local module = {}
	local Origin = arg1.Origin
	local Direction = arg1.Direction
	local cframe = CFrame.new(Origin, Origin + Direction)
	for i = 1, arg2 do
		local var18 = (-math.pi*2) * (i - 1) / arg2
		table.insert(module, Ray.new(Origin + cframe:vectorToWorldSpace(Vector3.new(math.cos(var18) * arg3, math.sin(var18) * arg3, 0)), Direction))
	end
	return module
end
return module_upvr