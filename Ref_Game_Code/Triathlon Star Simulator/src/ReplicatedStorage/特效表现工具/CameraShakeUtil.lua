-- Saved by UniversalSynSaveInstance https://discord.gg/wx4ThpAsmw

-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2024-10-02 00:25:03
-- Luau version 6, Types version 3
-- Time taken: 0.001008 seconds

local module = {}
local Players_upvr = game:GetService("Players")
local CameraShake_upvr = require(game:GetService("ReplicatedStorage").Tool.CameraShake)
local CurrentCamera_upvr = workspace.CurrentCamera
module.Enum = CameraShake_upvr.Presets
function module.CreateAShake(arg1, arg2, arg3) -- Line 14
	--[[ Upvalues[3]:
		[1]: Players_upvr (readonly)
		[2]: CurrentCamera_upvr (readonly)
		[3]: CameraShake_upvr (readonly)
	]]
	if arg1 ~= Players_upvr.LocalPlayer then
	else
		CameraShake_upvr:Stop()
		local any_new_result1 = CameraShake_upvr.new(Enum.RenderPriority.Camera.Value, function(arg1_2) -- Line 22
			--[[ Upvalues[1]:
				[1]: CurrentCamera_upvr (copied, readonly)
			]]
			CurrentCamera_upvr.CFrame *= arg1_2
		end)
		any_new_result1:Stop()
		any_new_result1:Start()
		any_new_result1:Shake(arg3)
	end
end
function module.CreateAFixedShake(arg1, arg2) -- Line 32
	--[[ Upvalues[3]:
		[1]: Players_upvr (readonly)
		[2]: CameraShake_upvr (readonly)
		[3]: CurrentCamera_upvr (readonly)
	]]
	if arg1 ~= Players_upvr.LocalPlayer then
	else
		CameraShake_upvr:Stop()
		local any_newFixed_result1 = CameraShake_upvr.newFixed(Enum.RenderPriority.Camera.Value, function(arg1_3) -- Line 39
			--[[ Upvalues[1]:
				[1]: CurrentCamera_upvr (copied, readonly)
			]]
			CurrentCamera_upvr.CFrame = CurrentCamera_upvr.CFrame:ToWorldSpace(CFrame.new(arg1_3.Position)) * arg1_3.Rotation
		end)
		any_newFixed_result1:Stop()
		any_newFixed_result1:StartFixed()
		any_newFixed_result1:Shake(arg2)
	end
end
return module