-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:29:12
-- Luau version 6, Types version 3
-- Time taken: 0.003174 seconds

local any_load_result1 = require(script.Parent.loader).load(script)
local module_upvr_2 = {}
local zero_vector3 = Vector3.new()
local module_upvr_3 = {{"UpperTorso", "RightShoulderRagdollAttachment", CFrame.fromMatrix(zero_vector3, Vector3.new(1, 0, 0), Vector3.new(0, 1, 0)), "RightShoulderRigAttachment"}, {"RightUpperArm", "RightShoulderRagdollAttachment", CFrame.fromMatrix(zero_vector3, Vector3.new(0, -1, 0), Vector3.new(1, 0, 0)), "RightShoulderRigAttachment"}, {"UpperTorso", "LeftShoulderRagdollAttachment", CFrame.fromMatrix(zero_vector3, Vector3.new(-1, 0, 0), Vector3.new(0, 1, 0)), "LeftShoulderRigAttachment"}, {"LeftUpperArm", "LeftShoulderRagdollAttachment", CFrame.fromMatrix(zero_vector3, Vector3.new(0, -1, 0), Vector3.new(-1, 0, 0)), "LeftShoulderRigAttachment"}}
local module_upvr = {{"Head", "NeckAttachment", CFrame.new(0, -0.5, 0)}, {"Torso", "NeckAttachment", CFrame.new(0, 1, 0)}, {"Torso", "RightShoulderRagdollAttachment", CFrame.fromMatrix(Vector3.new(1, 0.5, 0), Vector3.new(1, 0, 0), Vector3.new(0, 1, 0))}, {"Right Arm", "RightShoulderRagdollAttachment", CFrame.fromMatrix(Vector3.new(-0.5, 0.5, 0), Vector3.new(0, -1, 0), Vector3.new(1, 0, 0))}, {"Torso", "LeftShoulderRagdollAttachment", CFrame.fromMatrix(Vector3.new(-1, 0.5, 0), Vector3.new(-1, 0, 0), Vector3.new(0, 1, 0))}, {"Left Arm", "LeftShoulderRagdollAttachment", CFrame.fromMatrix(Vector3.new(0.5, 0.5, 0), Vector3.new(0, -1, 0), Vector3.new(-1, 0, 0))}, {"Torso", "RightHipAttachment", CFrame.new(0.5, -1, 0)}, {"Right Leg", "RightHipAttachment", CFrame.new(0, 1, 0)}, {"Torso", "LeftHipAttachment", CFrame.new(-0.5, -1, 0)}, {"Left Leg", "LeftHipAttachment", CFrame.new(0, 1, 0)}}
function module_upvr_2.getAdditionalAttachmentData(arg1) -- Line 49
	--[[ Upvalues[2]:
		[1]: module_upvr_3 (readonly)
		[2]: module_upvr (readonly)
	]]
	if arg1 == Enum.HumanoidRigType.R15 then
		return module_upvr_3
	end
	if arg1 == Enum.HumanoidRigType.R6 then
		return module_upvr
	end
	error("[RagdollAdditionalAttachmentUtils] - Unknown rigType %q":format(tostring(arg1)))
end
local any_load_result1_result1_upvr_5 = any_load_result1("EnumUtils")
local any_load_result1_result1_upvr_3 = any_load_result1("Maid")
local any_load_result1_result1_upvr = any_load_result1("RxBrioUtils")
local any_load_result1_result1_upvr_2 = any_load_result1("RxR15Utils")
local any_load_result1_result1_upvr_4 = any_load_result1("RxInstanceUtils")
function module_upvr_2.ensureAdditionalAttachments(arg1, arg2) -- Line 59
	--[[ Upvalues[6]:
		[1]: any_load_result1_result1_upvr_5 (readonly)
		[2]: any_load_result1_result1_upvr_3 (readonly)
		[3]: module_upvr_2 (readonly)
		[4]: any_load_result1_result1_upvr (readonly)
		[5]: any_load_result1_result1_upvr_2 (readonly)
		[6]: any_load_result1_result1_upvr_4 (readonly)
	]]
	local var29 = false
	if typeof(arg1) == "Instance" then
		var29 = arg1:IsA("Model")
	end
	assert(var29, "Bad character")
	assert(any_load_result1_result1_upvr_5.isOfType(Enum.HumanoidRigType, arg2), "Bad rigType")
	local any_new_result1_2_upvr = any_load_result1_result1_upvr_3.new()
	for _, v_upvr in pairs(module_upvr_2.getAdditionalAttachmentData(arg2)) do
		local unpack_result1, unpack_result2_upvr, unpack_result3_upvr, unpack_result4 = unpack(v_upvr)
		if unpack_result4 then
			any_new_result1_2_upvr:GiveTask(any_load_result1_result1_upvr.flatCombineLatest({
				part = any_load_result1_result1_upvr_2.observeCharacterPartBrio(arg1, unpack_result1);
				baseAttachment = any_load_result1_result1_upvr_2.observeRigAttachmentBrio(arg1, unpack_result1, unpack_result4);
			}):Subscribe(function(arg1_2) -- Line 74
				--[[ Upvalues[6]:
					[1]: any_load_result1_result1_upvr_3 (copied, readonly)
					[2]: unpack_result2_upvr (readonly)
					[3]: any_load_result1_result1_upvr_4 (copied, readonly)
					[4]: unpack_result3_upvr (readonly)
					[5]: any_new_result1_2_upvr (readonly)
					[6]: v_upvr (readonly)
				]]
				if arg1_2.part and arg1_2.baseAttachment then
					local any_new_result1 = any_load_result1_result1_upvr_3.new()
					local Attachment_2_upvr = Instance.new("Attachment")
					Attachment_2_upvr.Name = unpack_result2_upvr
					any_new_result1:GiveTask(any_load_result1_result1_upvr_4.observeProperty(arg1_2.baseAttachment, "CFrame"):Subscribe(function(arg1_3) -- Line 81
						--[[ Upvalues[3]:
							[1]: Attachment_2_upvr (readonly)
							[2]: unpack_result3_upvr (copied, readonly)
							[3]: arg1_2 (readonly)
						]]
						Attachment_2_upvr.CFrame = arg1_3 * unpack_result3_upvr
						Attachment_2_upvr.Parent = arg1_2.part
					end))
					any_new_result1:GiveTask(Attachment_2_upvr)
					any_new_result1_2_upvr[v_upvr] = any_new_result1
				else
					Attachment_2_upvr = v_upvr
					any_new_result1_2_upvr[Attachment_2_upvr] = nil
				end
			end))
		else
			any_new_result1_2_upvr:GiveTask(any_load_result1_result1_upvr_2.observeCharacterPartBrio(arg1, unpack_result1):Subscribe(function(arg1_4) -- Line 94
				--[[ Upvalues[2]:
					[1]: unpack_result2_upvr (readonly)
					[2]: unpack_result3_upvr (readonly)
				]]
				if arg1_4:IsDead() then
				else
					local Attachment = Instance.new("Attachment")
					Attachment.Name = unpack_result2_upvr
					Attachment.CFrame = unpack_result3_upvr
					Attachment.Parent = arg1_4:GetValue()
					arg1_4:ToMaid():GiveTask(Attachment)
				end
			end))
		end
	end
	return any_new_result1_2_upvr
end
return module_upvr_2