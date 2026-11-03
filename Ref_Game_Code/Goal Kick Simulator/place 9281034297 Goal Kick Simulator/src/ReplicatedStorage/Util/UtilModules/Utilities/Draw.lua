-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:19:40
-- Luau version 6, Types version 3
-- Time taken: 0.012893 seconds

local Workspace_upvr = game:GetService("Workspace")
local Terrain_upvr = Workspace_upvr.Terrain
local Color3_new_result1_upvr = Color3.new(1, 0, 0)
local module_upvr = {
	_defaultColor = Color3_new_result1_upvr;
}
function module_upvr.setColor(arg1) -- Line 39
	--[[ Upvalues[1]:
		[1]: module_upvr (readonly)
	]]
	module_upvr._defaultColor = arg1
end
function module_upvr.resetColor() -- Line 46
	--[[ Upvalues[2]:
		[1]: module_upvr (readonly)
		[2]: Color3_new_result1_upvr (readonly)
	]]
	module_upvr._defaultColor = Color3_new_result1_upvr
end
function module_upvr.setRandomColor() -- Line 53
	--[[ Upvalues[1]:
		[1]: module_upvr (readonly)
	]]
	module_upvr.setColor(Color3.fromHSV(math.random(), 0.5 + 0.5 * math.random(), 1))
end
function module_upvr.ray(arg1, arg2, arg3, arg4, arg5) -- Line 72
	--[[ Upvalues[1]:
		[1]: module_upvr (readonly)
	]]
	local var5
	if typeof(arg1) ~= "Ray" then
		var5 = false
	else
		var5 = true
	end
	assert(var5, "Bad typeof(ray) for Ray")
	local var6 = arg2
	if not var6 then
		var5 = module_upvr
		var6 = var5._defaultColor
	end
	local var7 = var6
	var6 = arg3
	local var8 = var6
	if not var8 then
		var5 = module_upvr
		var8 = var5.getDefaultParent()
	end
	local var9 = arg4 or 0.2
	local var10 = arg5 or 0.2
	var5 = arg1.Origin
	var5 = Instance.new("Part")
	var5.Material = Enum.Material.ForceField
	var5.Anchored = true
	var5.Archivable = false
	var5.CanCollide = false
	var5.CanQuery = false
	var5.CanTouch = false
	var5.CastShadow = false
	var5.CFrame = CFrame.new(var5 + arg1.Direction / 2, arg1.Origin + arg1.Direction) * CFrame.Angles((math.pi/2), 0, 0)
	var5.Color = var7
	var5.Name = "DebugRay"
	var5.Shape = Enum.PartType.Cylinder
	var5.Size = Vector3.new(var10, arg1.Direction.Magnitude, var10)
	var5.TopSurface = Enum.SurfaceType.Smooth
	var5.Transparency = 0.5
	local Part = Instance.new("Part")
	Part.Name = "RotatedPart"
	Part.Anchored = true
	Part.Archivable = false
	Part.CanCollide = false
	var5.CanQuery = false
	var5.CanTouch = false
	Part.CastShadow = false
	Part.CFrame = CFrame.new(arg1.Origin, arg1.Origin + arg1.Direction)
	Part.Transparency = 1
	Part.Size = Vector3.new(1, 1, 1)
	Part.Parent = var5
	local LineHandleAdornment = Instance.new("LineHandleAdornment")
	LineHandleAdornment.Name = "DrawRayLineHandleAdornment"
	LineHandleAdornment.Length = arg1.Direction.Magnitude
	LineHandleAdornment.Thickness = 5 * var10
	LineHandleAdornment.ZIndex = 3
	LineHandleAdornment.Color3 = var7
	LineHandleAdornment.AlwaysOnTop = true
	LineHandleAdornment.Transparency = 0
	LineHandleAdornment.Adornee = Part
	LineHandleAdornment.Parent = Part
	local SpecialMesh = Instance.new("SpecialMesh")
	SpecialMesh.Name = "DrawRayMesh"
	SpecialMesh.Scale = Vector3.new(0, 1, 0) + Vector3.new(var9, 0, var9) / var10
	SpecialMesh.Parent = var5
	var5.Parent = var8
	return var5
end
function module_upvr.updateRay(arg1, arg2, arg3) -- Line 151
	local var14 = arg3
	if not var14 then
		var14 = arg1.Color
	end
	local var15 = var14
	local x = arg1.Size.x
	arg1.CFrame = CFrame.new(arg2.Origin + arg2.Direction / 2, arg2.Origin + arg2.Direction) * CFrame.Angles((math.pi/2), 0, 0)
	arg1.Size = Vector3.new(x, arg2.Direction.Magnitude, x)
	arg1.Color = var15
	local RotatedPart = arg1:FindFirstChild("RotatedPart")
	if RotatedPart then
		RotatedPart.CFrame = CFrame.new(arg2.Origin, arg2.Origin + arg2.Direction)
	end
	local var18 = RotatedPart
	if var18 then
		var18 = RotatedPart:FindFirstChild("DrawRayLineHandleAdornment")
	end
	if var18 then
		var18.Length = arg2.Direction.Magnitude
		var18.Thickness = 5 * x
		var18.Color3 = var15
	end
end
function module_upvr.text(arg1, arg2, arg3) -- Line 187
	--[[ Upvalues[2]:
		[1]: Terrain_upvr (readonly)
		[2]: module_upvr (readonly)
	]]
	if typeof(arg1) == "Vector3" then
		local Attachment = Instance.new("Attachment")
		Attachment.WorldPosition = arg1
		Attachment.Parent = Terrain_upvr
		Attachment.Name = "DebugTextAttachment"
		module_upvr._textOnAdornee(Attachment, arg2, arg3)
		return Attachment
	end
	if typeof(arg1) == "Instance" then
		return module_upvr._textOnAdornee(arg1, arg2, arg3)
	end
	error("Bad adornee")
end
local TextService_upvr = game:GetService("TextService")
function module_upvr._textOnAdornee(arg1, arg2, arg3) -- Line 204
	--[[ Upvalues[2]:
		[1]: module_upvr (readonly)
		[2]: TextService_upvr (readonly)
	]]
	local BillboardGui = Instance.new("BillboardGui")
	BillboardGui.Name = "DebugBillboardGui"
	BillboardGui.SizeOffset = Vector2.new(0, 0.5)
	BillboardGui.ExtentsOffset = Vector3.new(0, 1, 0)
	BillboardGui.AlwaysOnTop = true
	BillboardGui.Adornee = arg1
	BillboardGui.StudsOffset = Vector3.new(0, 0, 0.00999)
	local Frame = Instance.new("Frame")
	Frame.Name = "Background"
	Frame.Size = UDim2.new(1, 0, 1, 0)
	Frame.Position = UDim2.new(0.5, 0, 1, 0)
	Frame.AnchorPoint = Vector2.new(0.5, 1)
	Frame.BackgroundTransparency = 0.3
	Frame.BorderSizePixel = 0
	local var23 = arg3
	if not var23 then
		var23 = module_upvr._defaultColor
	end
	Frame.BackgroundColor3 = var23
	Frame.Parent = BillboardGui
	local TextLabel = Instance.new("TextLabel")
	TextLabel.Text = tostring(arg2)
	TextLabel.TextScaled = true
	TextLabel.TextSize = 32
	TextLabel.BackgroundTransparency = 1
	TextLabel.BorderSizePixel = 0
	TextLabel.TextColor3 = Color3.new(1, 1, 1)
	TextLabel.Size = UDim2.new(1, 0, 1, 0)
	TextLabel.Parent = Frame
	if tonumber(arg2) then
		TextLabel.Font = Enum.Font.Code
	else
		TextLabel.Font = Enum.Font.GothamSemibold
	end
	local any_GetTextSize_result1 = TextService_upvr:GetTextSize(TextLabel.Text, TextLabel.TextSize, TextLabel.Font, Vector2.new(1024, 1000000))
	local var26 = TextLabel.TextSize * 0.5
	local var27 = any_GetTextSize_result1.y + 2 * var26
	local var28 = any_GetTextSize_result1.x + 2 * var26
	local var29 = var28 / var27
	local UIAspectRatioConstraint = Instance.new("UIAspectRatioConstraint")
	UIAspectRatioConstraint.AspectRatio = var29
	UIAspectRatioConstraint.Parent = Frame
	local UIPadding = Instance.new("UIPadding")
	UIPadding.PaddingBottom = UDim.new(var26 / var27, 0)
	UIPadding.PaddingTop = UDim.new(var26 / var27, 0)
	UIPadding.PaddingLeft = UDim.new(var26 / var28, 0)
	UIPadding.PaddingRight = UDim.new(var26 / var28, 0)
	UIPadding.Parent = Frame
	local UICorner_2 = Instance.new("UICorner")
	UICorner_2.CornerRadius = UDim.new(var26 / var27 / 2, 0)
	UICorner_2.Parent = Frame
	local var33 = any_GetTextSize_result1.y / TextLabel.TextSize * 2 * 2 * 0.5
	BillboardGui.Size = UDim2.new(var33 * var29, 0, var33, 0)
	BillboardGui.Parent = arg1
	return BillboardGui
end
function module_upvr.sphere(arg1, arg2, arg3, arg4) -- Line 293
	--[[ Upvalues[1]:
		[1]: module_upvr (readonly)
	]]
	return module_upvr.point(arg1, arg3, arg4, arg2 * 2)
end
function module_upvr.point(arg1, arg2, arg3, arg4) -- Line 310
	--[[ Upvalues[1]:
		[1]: module_upvr (readonly)
	]]
	-- KONSTANTWARNING: Variable analysis failed. Output will have some incorrect variable assignments
	local var34
	if typeof(arg1) == "CFrame" then
		var34 = var34.Position
	end
	if typeof(var34) ~= "Vector3" then
	else
	end
	assert(true, "Bad position")
	local var35 = arg2
	if not var35 then
		var35 = module_upvr._defaultColor
	end
	local var36 = var35
	var35 = arg3
	local var37 = var35
	if not var37 then
		var37 = module_upvr.getDefaultParent()
	end
	local var38 = arg4 or 1
	local Part_2 = Instance.new("Part")
	Part_2.Material = Enum.Material.ForceField
	Part_2.Anchored = true
	Part_2.Archivable = false
	Part_2.BottomSurface = Enum.SurfaceType.Smooth
	Part_2.CanCollide = false
	Part_2.CanQuery = false
	Part_2.CanTouch = false
	Part_2.CastShadow = false
	Part_2.CFrame = CFrame.new(var34)
	Part_2.Color = var36
	Part_2.Name = "DebugPoint"
	Part_2.Shape = Enum.PartType.Ball
	Part_2.Size = Vector3.new(var38, var38, var38)
	Part_2.TopSurface = Enum.SurfaceType.Smooth
	Part_2.Transparency = 0.5
	local SphereHandleAdornment = Instance.new("SphereHandleAdornment")
	SphereHandleAdornment.Archivable = false
	SphereHandleAdornment.Radius = var38 / 4
	SphereHandleAdornment.Color3 = var36
	SphereHandleAdornment.AlwaysOnTop = true
	SphereHandleAdornment.Adornee = Part_2
	SphereHandleAdornment.ZIndex = 2
	SphereHandleAdornment.Parent = Part_2
	Part_2.Parent = var37
	return Part_2
end
function module_upvr.labelledPoint(arg1, arg2, arg3, arg4) -- Line 365
	--[[ Upvalues[1]:
		[1]: module_upvr (readonly)
	]]
	local var41
	if typeof(arg1) == "CFrame" then
		var41 = var41.Position
	end
	local any_point_result1 = module_upvr.point(var41, arg3, arg4)
	module_upvr.text(any_point_result1, arg2, arg3)
	return any_point_result1
end
function module_upvr.cframe(arg1) -- Line 387
	--[[ Upvalues[1]:
		[1]: module_upvr (readonly)
	]]
	local Model = Instance.new("Model")
	Model.Name = "DebugCFrame"
	local Position = arg1.Position
	module_upvr.point(Position, nil, Model, 0.1)
	module_upvr.ray(Ray.new(Position, arg1.XVector), Color3.new(0.75, 0.25, 0.25), Model, 0.1).Name = "XVector"
	module_upvr.ray(Ray.new(Position, arg1.YVector), Color3.new(0.25, 0.75, 0.25), Model, 0.1).Name = "YVector"
	module_upvr.ray(Ray.new(Position, arg1.ZVector), Color3.new(0.25, 0.25, 0.75), Model, 0.1).Name = "ZVector"
	Model.Parent = module_upvr.getDefaultParent()
	return Model
end
function module_upvr.box(arg1, arg2, arg3) -- Line 428
	--[[ Upvalues[1]:
		[1]: module_upvr (readonly)
	]]
	-- KONSTANTWARNING: Variable analysis failed. Output will have some incorrect variable assignments
	local var45
	if typeof(arg2) ~= "Vector3" then
		var45 = false
	else
		var45 = true
	end
	assert(var45, "Bad size")
	if not arg3 then
		var45 = module_upvr
	end
	local _defaultColor = var45._defaultColor
	var45 = typeof(arg1)
	local function INLINED() -- Internal function, doesn't exist in bytecode
		var45 = arg1
		return CFrame.new(var45)
	end
	if var45 ~= "Vector3" or not INLINED() then
	end
	var45 = "Part"
	local any = Instance.new(var45)
	any.Color = _defaultColor
	var45 = Enum.Material.ForceField
	any.Material = var45
	var45 = "DebugPart"
	any.Name = var45
	var45 = true
	any.Anchored = var45
	var45 = false
	any.CanCollide = var45
	var45 = false
	any.CanQuery = var45
	var45 = false
	any.CanTouch = var45
	var45 = false
	any.CastShadow = var45
	var45 = false
	any.Archivable = var45
	var45 = Enum.SurfaceType.Smooth
	any.BottomSurface = var45
	var45 = Enum.SurfaceType.Smooth
	any.TopSurface = var45
	var45 = 0.75
	any.Transparency = var45
	any.Size = arg2
	any.CFrame = arg1
	var45 = Instance.new("BoxHandleAdornment")
	var45.Adornee = any
	var45.Size = arg2
	var45.Color3 = _defaultColor
	var45.AlwaysOnTop = true
	var45.Transparency = 0.75
	var45.ZIndex = 1
	var45.Parent = any
	any.Parent = module_upvr.getDefaultParent()
	return any
end
function module_upvr.region3(arg1, arg2) -- Line 475
	--[[ Upvalues[1]:
		[1]: module_upvr (readonly)
	]]
	return module_upvr.box(arg1.CFrame, arg1.Size, arg2)
end
function module_upvr.terrainCell(arg1, arg2) -- Line 491
	--[[ Upvalues[2]:
		[1]: Terrain_upvr (readonly)
		[2]: module_upvr (readonly)
	]]
	local any_WorldToCell_result1 = Terrain_upvr:WorldToCell(arg1)
	local any_box_result1 = module_upvr.box(CFrame.new(Terrain_upvr:CellCenterToWorld(any_WorldToCell_result1.x, any_WorldToCell_result1.y, any_WorldToCell_result1.z)), Vector3.new(4, 4, 4), arg2)
	any_box_result1.Name = "DebugTerrainCell"
	return any_box_result1
end
function module_upvr.screenPointLine(arg1, arg2, arg3, arg4) -- Line 505
	--[[ Upvalues[1]:
		[1]: module_upvr (readonly)
	]]
	local var54 = arg2 - arg1
	local var55 = arg1 + var54 / 2
	local Frame_2 = Instance.new("Frame")
	Frame_2.Name = "DebugScreenLine"
	Frame_2.Size = UDim2.fromScale(math.abs(var54.x), math.abs(var54.y))
	Frame_2.BackgroundTransparency = 1
	Frame_2.Position = UDim2.fromScale(var55.x, var55.y)
	Frame_2.AnchorPoint = Vector2.new(0.5, 0.5)
	Frame_2.BorderSizePixel = 0
	Frame_2.ZIndex = 10000
	Frame_2.Parent = arg3
	if var54.magnitude == 0 then
		return Frame_2
	end
	if 0 < var54.y / var54.x then
		for i = 0, 25 do
			module_upvr.screenPoint(Vector2.new(i / 25, i / 25), Frame_2, arg4, 3)
		end
		return Frame_2
	end
	for i_2 = 0, 25 do
		module_upvr.screenPoint(Vector2.new(i_2 / 25, 1 - i_2 / 25), Frame_2, arg4, 3)
	end
	return Frame_2
end
function module_upvr.screenPoint(arg1, arg2, arg3, arg4) -- Line 543
	local Frame_3 = Instance.new("Frame")
	Frame_3.Name = "DebugScreenPoint"
	Frame_3.Size = UDim2.new(0, arg4, 0, arg4)
	local var58 = arg3
	if not var58 then
		var58 = Color3.new(1, 0.1, 0.1)
	end
	Frame_3.BackgroundColor3 = var58
	Frame_3.BackgroundTransparency = 0.5
	Frame_3.Position = UDim2.fromScale(arg1.x, arg1.y)
	Frame_3.AnchorPoint = Vector2.new(0.5, 0.5)
	Frame_3.BorderSizePixel = 0
	Frame_3.ZIndex = 20000
	local UICorner = Instance.new("UICorner")
	UICorner.CornerRadius = UDim.new(0.5, 0)
	UICorner.Parent = Frame_3
	Frame_3.Parent = arg2
	return Frame_3
end
function module_upvr.vector(arg1, arg2, arg3, arg4, arg5) -- Line 576
	--[[ Upvalues[1]:
		[1]: module_upvr (readonly)
	]]
	return module_upvr.ray(Ray.new(arg1, arg2), arg3, arg4, arg5)
end
function module_upvr.ring(arg1, arg2, arg3, arg4, arg5) -- Line 594
	--[[ Upvalues[1]:
		[1]: module_upvr (readonly)
	]]
	-- KONSTANTWARNING: Variable analysis failed. Output will have some incorrect variable assignments
	local cframe_2 = CFrame.new(arg1, arg1 + arg2)
	local tbl = {}
	for i_3 = 0, (-math.pi*2), 0.39269908169872414 do
		table.insert(tbl, cframe_2:pointToWorldSpace(Vector3.new(math.cos(i_3) * arg3, math.sin(i_3) * arg3, 0)))
	end
	local Folder = Instance.new("Folder")
	Folder.Name = "DebugRing"
	for i_4 = 1, #tbl do
		local var71 = tbl[i_4]
		module_upvr.ray(Ray.new(var71, tbl[i_4 % #tbl + 1] - var71), arg4, Folder)
		local var72
	end
	local var73 = arg5
	if not var73 then
		var73 = module_upvr.getDefaultParent()
	end
	var72.Parent = var73
	return var72
end
local RunService_upvr = game:GetService("RunService")
function module_upvr.getDefaultParent() -- Line 624
	--[[ Upvalues[2]:
		[1]: RunService_upvr (readonly)
		[2]: Workspace_upvr (readonly)
	]]
	if not RunService_upvr:IsRunning() then
		return Workspace_upvr.CurrentCamera
	end
	if RunService_upvr:IsServer() then
		return Workspace_upvr
	end
	return Workspace_upvr.CurrentCamera
end
return module_upvr