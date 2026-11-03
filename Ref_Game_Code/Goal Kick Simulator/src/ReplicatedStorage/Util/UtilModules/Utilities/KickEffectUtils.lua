-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:19:38
-- Luau version 6, Types version 3
-- Time taken: 0.002126 seconds

local module = {}
local Workspace_upvr = game:GetService("Workspace")
local ServerStorage_upvr = game:GetService("ServerStorage")
function module.playKickParticles(arg1, arg2) -- Line 6
	--[[ Upvalues[2]:
		[1]: Workspace_upvr (readonly)
		[2]: ServerStorage_upvr (readonly)
	]]
	-- KONSTANTWARNING: Variable analysis failed. Output will have some incorrect variable assignments
	do
		return
	end
	local any_new_result1_upvr = require(game:GetService("ReplicatedStorage").Util).Maid.new()
	local RightFoot = arg1:FindFirstChild("RightFoot")
	if not RightFoot then
	else
		local magnitude = arg2.magnitude
		if magnitude < 300 then return end
		local Attachment = Instance.new("Attachment")
		Attachment.Name = "ParticleEmit"
		Attachment.Parent = Workspace_upvr.Terrain
		Attachment.CFrame = (function(arg1_2, arg2_2, arg3) -- Line 10, Named "redirectLocalAxis"
			local any_VectorToObjectSpace_result1 = arg1_2:VectorToObjectSpace(arg3)
			local any_Cross_result1 = arg2_2:Cross(any_VectorToObjectSpace_result1)
			local cframe = CFrame.new(0, 0, 0, any_Cross_result1.x, any_Cross_result1.y, any_Cross_result1.z, arg2_2:Dot(any_VectorToObjectSpace_result1) + arg2_2.magnitude * any_VectorToObjectSpace_result1.magnitude)
			if cframe == cframe then
				return arg1_2 * cframe
			end
			return arg1_2
		end)(RightFoot.CFrame, Vector3.new(0, 1, 0), arg2.unit)
		any_new_result1_upvr:GiveTask(Attachment)
		for _, v in pairs(ServerStorage_upvr.KickParticleTemplate:GetDescendants()) do
			if v:IsA("ParticleEmitter") then
				local clone_upvr = v:Clone()
				any_new_result1_upvr:GiveTask(clone_upvr)
				clone_upvr.Enabled = false
				clone_upvr.Speed = NumberRange.new(0.25 * magnitude, 0.3 * magnitude)
				clone_upvr.Parent = Attachment
				clone_upvr:Emit(1)
				for i_2 = 1, math.clamp((magnitude - 300) / 150, 1, 7) - 1 do
					task.delay(i_2 * 0.1, function() -- Line 57
						--[[ Upvalues[1]:
							[1]: clone_upvr (readonly)
						]]
						clone_upvr:Emit(1)
					end)
					local _
				end
			end
		end
		-- KONSTANTERROR: Expression was reused, decompilation is incorrect
		task.delay(math.clamp((magnitude - 300) / 150, 1, 7) * 0.1 + 5, function() -- Line 64
			--[[ Upvalues[1]:
				[1]: any_new_result1_upvr (readonly)
			]]
			any_new_result1_upvr:Destroy()
		end)
	end
end
return module