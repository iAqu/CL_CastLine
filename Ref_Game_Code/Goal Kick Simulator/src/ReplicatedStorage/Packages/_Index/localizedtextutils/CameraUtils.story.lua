-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:21:14
-- Luau version 6, Types version 3
-- Time taken: 0.001834 seconds

local any_load_result1 = require(game:GetService("ServerScriptService"):FindFirstChild("LoaderUtils", true).Parent).load(script)
local var1_result1_upvr_2 = any_load_result1("Maid")
local var1_result1_upvr = any_load_result1("CameraUtils")
return function(arg1) -- Line 11
	--[[ Upvalues[2]:
		[1]: var1_result1_upvr_2 (readonly)
		[2]: var1_result1_upvr (readonly)
	]]
	local any_new_result1_upvr = var1_result1_upvr_2.new()
	local ViewportFrame_upvr = Instance.new("ViewportFrame")
	ViewportFrame_upvr.BorderSizePixel = 0
	ViewportFrame_upvr.BackgroundColor3 = Color3.new(0.7, 0.7, 0.7)
	ViewportFrame_upvr.Size = UDim2.new(1, 0, 1, 0)
	any_new_result1_upvr:GiveTask(ViewportFrame_upvr)
	local Camera_upvr = Instance.new("Camera")
	Camera_upvr.FieldOfViewMode = Enum.FieldOfViewMode.Diagonal
	Camera_upvr.FieldOfView = 70
	ViewportFrame_upvr.CurrentCamera = Camera_upvr
	any_new_result1_upvr:GiveTask(Camera_upvr)
	local Part = Instance.new("Part")
	Part.Color = Color3.new(1, 0.5, 0.5)
	Part.Size = Vector3.new(10, 10, 10)
	Part.Shape = Enum.PartType.Ball
	Part.CFrame = CFrame.new()
	Part.Anchored = true
	Part.Parent = ViewportFrame_upvr
	local function update() -- Line 36
		--[[ Upvalues[3]:
			[1]: ViewportFrame_upvr (readonly)
			[2]: var1_result1_upvr (copied, readonly)
			[3]: Camera_upvr (readonly)
		]]
		local AbsoluteSize_2 = ViewportFrame_upvr.AbsoluteSize
		if 0 < AbsoluteSize_2.x and 0 < AbsoluteSize_2.y then
			Camera_upvr.CFrame = CFrame.new(0, 0, var1_result1_upvr.fitSphereToCamera(5, Camera_upvr.FieldOfView, AbsoluteSize_2.x / AbsoluteSize_2.y))
		end
	end
	any_new_result1_upvr:GiveTask(Camera_upvr:GetPropertyChangedSignal("FieldOfView"):Connect(update))
	any_new_result1_upvr:GiveTask(ViewportFrame_upvr:GetPropertyChangedSignal("AbsoluteSize"):Connect(update))
	local AbsoluteSize = ViewportFrame_upvr.AbsoluteSize
	if 0 < AbsoluteSize.x and 0 < AbsoluteSize.y then
		Camera_upvr.CFrame = CFrame.new(0, 0, var1_result1_upvr.fitSphereToCamera(5, Camera_upvr.FieldOfView, AbsoluteSize.x / AbsoluteSize.y))
	end
	ViewportFrame_upvr.Parent = arg1
	return function() -- Line 50
		--[[ Upvalues[1]:
			[1]: any_new_result1_upvr (readonly)
		]]
		any_new_result1_upvr:DoCleaning()
	end
end