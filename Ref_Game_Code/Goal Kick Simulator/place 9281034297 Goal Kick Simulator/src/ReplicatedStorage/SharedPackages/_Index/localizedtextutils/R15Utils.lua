-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:26:05
-- Luau version 6, Types version 3
-- Time taken: 0.005020 seconds

local module_upvr = {
	searchForRigAttachment = function(arg1, arg2, arg3) -- Line 15, Named "searchForRigAttachment"
		local SOME = arg1:FindFirstChild(arg2)
		if not SOME then
			return nil
		end
		return SOME:FindFirstChild(arg3)
	end;
	getRigMotor = function(arg1, arg2, arg3) -- Line 31, Named "getRigMotor"
		-- KONSTANTERROR: [0] 1. Error Block 27 start (CF ANALYSIS FAILED)
		local var3
		if typeof(arg1) ~= "Instance" then
			var3 = false
		else
			var3 = true
		end
		assert(var3, "Bad character")
		if type(arg2) ~= "string" then
			var3 = false
			-- KONSTANTWARNING: GOTO [24] #19
		end
		-- KONSTANTERROR: [0] 1. Error Block 27 end (CF ANALYSIS FAILED)
		-- KONSTANTERROR: [23] 18. Error Block 29 start (CF ANALYSIS FAILED)
		var3 = true
		assert(var3, "Bad partName")
		if type(arg3) ~= "string" then
			var3 = false
		else
			var3 = true
		end
		assert(var3, "Bad motorName")
		if not arg1:FindFirstChild(arg2) then
			var3 = nil
			return var3
		end
		var3 = arg1:FindFirstChild(arg2):FindFirstChild(arg3)
		if not var3 then
			return nil
		end
		do
			return var3
		end
		-- KONSTANTERROR: [23] 18. Error Block 29 end (CF ANALYSIS FAILED)
	end;
	getUpperTorso = function(arg1) -- Line 55, Named "getUpperTorso"
		return arg1:FindFirstChild("UpperTorso")
	end;
	getLowerTorso = function(arg1) -- Line 64, Named "getLowerTorso"
		return arg1:FindFirstChild("LowerTorso")
	end;
}
function module_upvr.getWaistJoint(arg1) -- Line 73
	--[[ Upvalues[1]:
		[1]: module_upvr (readonly)
	]]
	local any_getUpperTorso_result1 = module_upvr.getUpperTorso(arg1)
	if not any_getUpperTorso_result1 then
		return nil
	end
	return any_getUpperTorso_result1:FindFirstChild("Waist")
end
function module_upvr.getNeckJoint(arg1) -- Line 87
	local Head = arg1:FindFirstChild("Head")
	if not Head then
		return nil
	end
	return Head:FindFirstChild("Neck")
end
function module_upvr.getHand(arg1, arg2) -- Line 102
	--[[ Upvalues[1]:
		[1]: module_upvr (readonly)
	]]
	return arg1:FindFirstChild(module_upvr.getHandName(arg2))
end
function module_upvr.getGripWeld(arg1, arg2) -- Line 112
	--[[ Upvalues[1]:
		[1]: module_upvr (readonly)
	]]
	local any_getHand_result1 = module_upvr.getHand(arg1, arg2)
	if any_getHand_result1 then
		return any_getHand_result1:FindFirstChild(module_upvr.getGripWeldName(arg2))
	end
	return nil
end
function module_upvr.getGripWeldName(arg1) -- Line 126
	if arg1 == "Left" then
		return "LeftGrip"
	end
	if arg1 == "Right" then
		return "RightGrip"
	end
	error("Bad side")
end
function module_upvr.getHandName(arg1) -- Line 141
	if arg1 == "Left" then
		return "LeftHand"
	end
	if arg1 == "Right" then
		return "RightHand"
	end
	error("Bad side")
end
function module_upvr.getGripAttachmentName(arg1) -- Line 156
	if arg1 == "Left" then
		return "LeftGripAttachment"
	end
	if arg1 == "Right" then
		return "RightGripAttachment"
	end
	error("Bad side")
end
function module_upvr.getShoulderRigAttachment(arg1, arg2) -- Line 172
	--[[ Upvalues[1]:
		[1]: module_upvr (readonly)
	]]
	if arg2 == "Left" then
		return module_upvr.searchForRigAttachment(arg1, "UpperTorso", "LeftShoulderRigAttachment")
	end
	if arg2 == "Right" then
		return module_upvr.searchForRigAttachment(arg1, "UpperTorso", "RightShoulderRigAttachment")
	end
	error("Bad side")
end
function module_upvr.getGripAttachment(arg1, arg2) -- Line 188
	--[[ Upvalues[1]:
		[1]: module_upvr (readonly)
	]]
	if arg2 == "Left" then
		return module_upvr.searchForRigAttachment(arg1, "LeftHand", "LeftGripAttachment")
	end
	if arg2 == "Right" then
		return module_upvr.searchForRigAttachment(arg1, "RightHand", "RightGripAttachment")
	end
	error("Bad side")
end
function module_upvr.getExpectedRootPartYOffset(arg1) -- Line 203
	local RootPart = arg1.RootPart
	if not RootPart then
		return nil
	end
	return arg1.HipHeight + RootPart.Size.Y / 2
end
function module_upvr.getRigLength(arg1, arg2, arg3, arg4) -- Line 220
	--[[ Upvalues[1]:
		[1]: module_upvr (readonly)
	]]
	local any_searchForRigAttachment_result1 = module_upvr.searchForRigAttachment(arg1, arg2, arg3)
	if not any_searchForRigAttachment_result1 then
		return nil
	end
	local any_searchForRigAttachment_result1_2 = module_upvr.searchForRigAttachment(arg1, arg2, arg4)
	if not any_searchForRigAttachment_result1_2 then
		return nil
	end
	return (any_searchForRigAttachment_result1.Position - any_searchForRigAttachment_result1_2.Position).magnitude
end
function module_upvr.addLengthsOrNil(arg1) -- Line 239
	local var18
	for _, v in pairs(arg1) do
		if not v then
			return nil
		end
		var18 += v
	end
	return var18
end
function module_upvr.getUpperArmRigLength(arg1, arg2) -- Line 258
	--[[ Upvalues[1]:
		[1]: module_upvr (readonly)
	]]
	if arg2 == "Left" then
		return module_upvr.getRigLength(arg1, "LeftUpperArm", "LeftShoulderRigAttachment", "LeftElbowRigAttachment")
	end
	if arg2 == "Right" then
		return module_upvr.getRigLength(arg1, "RightUpperArm", "RightShoulderRigAttachment", "RightElbowRigAttachment")
	end
	error("Bad side")
end
function module_upvr.getLowerArmRigLength(arg1, arg2) -- Line 274
	--[[ Upvalues[1]:
		[1]: module_upvr (readonly)
	]]
	if arg2 == "Left" then
		return module_upvr.getRigLength(arg1, "LeftLowerArm", "LeftElbowRigAttachment", "LeftWristRigAttachment")
	end
	if arg2 == "Right" then
		return module_upvr.getRigLength(arg1, "RightLowerArm", "RightElbowRigAttachment", "RightWristRigAttachment")
	end
	error("Bad side")
end
function module_upvr.getWristToGripLength(arg1, arg2) -- Line 290
	--[[ Upvalues[1]:
		[1]: module_upvr (readonly)
	]]
	if arg2 == "Left" then
		return module_upvr.getRigLength(arg1, "LeftHand", "LeftWristRigAttachment", "LeftGripAttachment")
	end
	if arg2 == "Right" then
		return module_upvr.getRigLength(arg1, "RightHand", "RightWristRigAttachment", "RightGripAttachment")
	end
	error("Bad side")
end
function module_upvr.getArmRigToGripLength(arg1, arg2) -- Line 306
	--[[ Upvalues[1]:
		[1]: module_upvr (readonly)
	]]
	return module_upvr.addLengthsOrNil({module_upvr.getUpperArmRigLength(arg1, arg2), module_upvr.getLowerArmRigLength(arg1, arg2), module_upvr.getWristToGripLength(arg1, arg2)})
end
return module_upvr