-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:25:07
-- Luau version 6, Types version 3
-- Time taken: 0.001334 seconds

local any_load_result1 = require(game:GetService("ServerScriptService"):FindFirstChild("LoaderUtils", true).Parent).load(script)
local var1_result1_upvr_2 = any_load_result1("Maid")
local var1_result1_upvr = any_load_result1("RigBuilderUtils")
local Workspace_upvr = game:GetService("Workspace")
local var1_result1_upvr_3 = any_load_result1("ArmIKBase")
local RunService_upvr = game:GetService("RunService")
return function(arg1) -- Line 14
	--[[ Upvalues[5]:
		[1]: var1_result1_upvr_2 (readonly)
		[2]: var1_result1_upvr (readonly)
		[3]: Workspace_upvr (readonly)
		[4]: var1_result1_upvr_3 (readonly)
		[5]: RunService_upvr (readonly)
	]]
	local any_new_result1_upvr = var1_result1_upvr_2.new()
	any_new_result1_upvr:GivePromise(var1_result1_upvr.promisePlayerRig(4397833)):Then(function(arg1_2) -- Line 17
		--[[ Upvalues[4]:
			[1]: any_new_result1_upvr (readonly)
			[2]: Workspace_upvr (copied, readonly)
			[3]: var1_result1_upvr_3 (copied, readonly)
			[4]: RunService_upvr (copied, readonly)
		]]
		any_new_result1_upvr:GiveTask(arg1_2)
		local Humanoid = arg1_2.Humanoid
		local any_pointToWorldSpace_result1 = Workspace_upvr.CurrentCamera.CFrame:pointToWorldSpace(Vector3.new(0, 0, -10))
		local any_new_result1_upvr_2 = var1_result1_upvr_3.new(Humanoid, "Right")
		any_new_result1_upvr:GiveTask(any_new_result1_upvr_2)
		local Attachment = Instance.new("Attachment")
		Attachment.Name = "IKRigStoryTarget"
		Attachment.Parent = workspace.Terrain
		Attachment.WorldPosition = any_pointToWorldSpace_result1 + Workspace_upvr.CurrentCamera.CFrame:vectorToWorldSpace(Vector3.new(2, 0, 1))
		any_new_result1_upvr:GiveTask(Attachment)
		any_new_result1_upvr_2:Grip(Attachment)
		Humanoid.RootPart.CFrame = CFrame.new(any_pointToWorldSpace_result1)
		arg1_2.Parent = workspace
		Humanoid.RootPart.CFrame = CFrame.new(any_pointToWorldSpace_result1)
		any_new_result1_upvr:GiveTask(RunService_upvr.RenderStepped:Connect(function() -- Line 38
			--[[ Upvalues[1]:
				[1]: any_new_result1_upvr_2 (readonly)
			]]
			any_new_result1_upvr_2:Update()
		end))
	end)
	return function() -- Line 44
		--[[ Upvalues[1]:
			[1]: any_new_result1_upvr (readonly)
		]]
		any_new_result1_upvr:DoCleaning()
	end
end