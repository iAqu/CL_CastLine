-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:28:55
-- Luau version 6, Types version 3
-- Time taken: 0.004294 seconds

local any_load_result1 = require(script.Parent.loader).load(script)
local var1_result1_upvr_4 = any_load_result1("RxR15Utils")
local var1_result1_upvr_2 = any_load_result1("Maid")
local module_upvr = {}
local module_upvr_2 = {{"LowerTorso", "LeftUpperArm"}, {"LeftUpperArm", "LeftHand"}, {"LowerTorso", "RightUpperArm"}, {"RightUpperArm", "RightHand"}, {"LeftUpperLeg", "RightUpperLeg"}, {"UpperTorso", "RightUpperLeg"}, {"RightUpperLeg", "RightFoot"}, {"UpperTorso", "LeftUpperLeg"}, {"LeftUpperLeg", "LeftFoot"}, {"UpperTorso", "LeftLowerLeg"}, {"UpperTorso", "RightLowerLeg"}, {"LowerTorso", "LeftLowerLeg"}, {"LowerTorso", "RightLowerLeg"}, {"UpperTorso", "LeftLowerArm"}, {"UpperTorso", "RightLowerArm"}, {"Head", "LeftUpperArm"}, {"Head", "RightUpperArm"}, {"HumanoidRootPart", "LeftUpperArm"}, {"HumanoidRootPart", "RightUpperArm"}, {"HumanoidRootPart", "LeftLowerArm"}, {"HumanoidRootPart", "RightLowerArm"}, {"HumanoidRootPart", "LeftLowerLeg"}, {"HumanoidRootPart", "RightLowerLeg"}, {"HumanoidRootPart", "LeftUpperLeg"}, {"HumanoidRootPart", "RightUpperLeg"}, {"HumanoidRootPart", "Head"}, {"HumanoidRootPart", "LeftFoot"}, {"HumanoidRootPart", "RightFoot"}, {"HumanoidRootPart", "LeftHand"}, {"HumanoidRootPart", "RightHand"}, {"HumanoidRootPart", "UpperTorso"}, {"HumanoidRootPart", "LowerTorso"}}
local tbl_upvr = {"LeftUpperArm", "RightUpperArm", "LeftLowerArm", "RightLowerArm", "LeftLowerLeg", "RightLowerLeg", "LeftUpperLeg", "RightUpperLeg", "Head", "LeftFoot", "RightFoot", "LeftHand", "RightHand", "UpperTorso", "LowerTorso"}
local module_upvr_3 = {{"Left Leg", "Right Leg"}, {"Head", "Right Arm"}, {"Head", "Left Arm"}, {"HumanoidRootPart", "Head"}, {"HumanoidRootPart", "Right Leg"}, {"HumanoidRootPart", "Right Arm"}, {"HumanoidRootPart", "Left Leg"}, {"HumanoidRootPart", "Left Arm"}}
function module_upvr.getCollisionData(arg1) -- Line 89
	--[[ Upvalues[2]:
		[1]: module_upvr_2 (readonly)
		[2]: module_upvr_3 (readonly)
	]]
	if arg1 == Enum.HumanoidRigType.R15 then
		return module_upvr_2
	end
	if arg1 == Enum.HumanoidRigType.R6 then
		return module_upvr_3
	end
	error("[RagdollCollisionUtils] - Unknown rigType %q":format(tostring(arg1)))
end
function module_upvr.preventCollisionAmongOthers(arg1, arg2) -- Line 99
	--[[ Upvalues[3]:
		[1]: var1_result1_upvr_2 (readonly)
		[2]: tbl_upvr (readonly)
		[3]: var1_result1_upvr_4 (readonly)
	]]
	local any_new_result1_2 = var1_result1_upvr_2.new()
	for _, v in pairs(tbl_upvr) do
		any_new_result1_2:GiveTask(var1_result1_upvr_4.observeCharacterPartBrio(arg1, v):Subscribe(function(arg1_2) -- Line 103
			--[[ Upvalues[1]:
				[1]: arg2 (readonly)
			]]
			if arg1_2:IsDead() then
			else
				local NoCollisionConstraint = Instance.new("NoCollisionConstraint")
				NoCollisionConstraint.Name = "RagdollNoCollisionConstraint_Animating"
				NoCollisionConstraint.Part0 = arg2
				NoCollisionConstraint.Part1 = arg1_2:GetValue()
				NoCollisionConstraint.Parent = arg2
				arg1_2:ToMaid():GiveTask(NoCollisionConstraint)
			end
		end))
	end
	return any_new_result1_2
end
local var1_result1_upvr = any_load_result1("EnumUtils")
local var1_result1_upvr_3 = any_load_result1("RxBrioUtils")
function module_upvr.ensureNoCollides(arg1, arg2) -- Line 123
	--[[ Upvalues[5]:
		[1]: var1_result1_upvr (readonly)
		[2]: var1_result1_upvr_2 (readonly)
		[3]: module_upvr (readonly)
		[4]: var1_result1_upvr_3 (readonly)
		[5]: var1_result1_upvr_4 (readonly)
	]]
	-- KONSTANTWARNING: Variable analysis failed. Output will have some incorrect variable assignments
	local var68 = false
	if typeof(arg1) == "Instance" then
		var68 = arg1:IsA("Model")
	end
	assert(var68, "Bad character")
	assert(var1_result1_upvr.isOfType(Enum.HumanoidRigType, arg2), "Bad rigType")
	local any_new_result1_3_upvr = var1_result1_upvr_2.new()
	for _, v_2_upvr in pairs(module_upvr.getCollisionData(arg2)) do
		local unpack_result1, unpack_result2 = unpack(v_2_upvr)
		any_new_result1_3_upvr:GiveTask(var1_result1_upvr_3.flatCombineLatest({
			part0 = var1_result1_upvr_4.observeCharacterPartBrio(arg1, unpack_result1);
			part1 = var1_result1_upvr_4.observeCharacterPartBrio(arg1, unpack_result2);
		}):Subscribe(function(arg1_3) -- Line 137
			--[[ Upvalues[3]:
				[1]: var1_result1_upvr_2 (copied, readonly)
				[2]: any_new_result1_3_upvr (readonly)
				[3]: v_2_upvr (readonly)
			]]
			if arg1_3.part0 and arg1_3.part1 then
				local any_new_result1 = var1_result1_upvr_2.new()
				local NoCollisionConstraint_2 = Instance.new("NoCollisionConstraint")
				NoCollisionConstraint_2.Name = "RagdollNoCollisionConstraint"
				NoCollisionConstraint_2.Part0 = arg1_3.part0
				NoCollisionConstraint_2.Part1 = arg1_3.part1
				NoCollisionConstraint_2.Parent = arg1_3.part1
				any_new_result1:GiveTask(NoCollisionConstraint_2)
				any_new_result1_3_upvr[v_2_upvr] = any_new_result1
			else
				any_new_result1_3_upvr[v_2_upvr] = nil
			end
		end))
		local var79
	end
	return var79
end
return module_upvr