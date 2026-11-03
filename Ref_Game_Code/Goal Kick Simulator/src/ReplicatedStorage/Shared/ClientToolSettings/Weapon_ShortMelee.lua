-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:20:05
-- Luau version 6, Types version 3
-- Time taken: 0.004403 seconds

local module = {}
local Util_upvr = require(game:GetService("ReplicatedStorage").Util)
function module.Active(arg1) -- Line 6
	--[[ Upvalues[1]:
		[1]: Util_upvr (readonly)
	]]
	if not arg1.Cooldown and not arg1.Stunned and arg1.Tool then
		local var15_upvr
		if var15_upvr then
			var15_upvr = true
			arg1.Cooldown = var15_upvr
			local function INLINED_3() -- Internal function, doesn't exist in bytecode
				var15_upvr = arg1.CurrentAnim + 1
				return var15_upvr
			end
			if not arg1.CurrentAnim or not INLINED_3() then
				var15_upvr = 1
			end
			arg1.CurrentAnim = var15_upvr
			local function INLINED_4() -- Internal function, doesn't exist in bytecode
				var15_upvr = arg1.CurrentAnim
				return var15_upvr
			end
			if arg1.CurrentAnim > #arg1.Slashes or not INLINED_4() then
				var15_upvr = 1
			end
			arg1.CurrentAnim = var15_upvr
			var15_upvr = arg1.Slashes[arg1.CurrentAnim]
			arg1.Maid.Cooldown = Util_upvr.Thread.Delay(var15_upvr.Cooldown, function() -- Line 15
				--[[ Upvalues[1]:
					[1]: arg1 (readonly)
				]]
				arg1.Cooldown = nil
			end)
			arg1:PlayAnimation("Slash"..arg1.CurrentAnim)
			arg1.Maid.ResetSlash = Util_upvr.Thread.Delay(2, function() -- Line 22
				--[[ Upvalues[1]:
					[1]: arg1 (readonly)
				]]
				arg1.CurrentAnim = nil
			end)
			arg1:Fire("SwordSlash", arg1.CurrentAnim)
			Util_upvr.Thread.Delay(var15_upvr.Delay, function() -- Line 26
				--[[ Upvalues[3]:
					[1]: arg1 (readonly)
					[2]: Util_upvr (copied, readonly)
					[3]: var15_upvr (readonly)
				]]
				local tbl_upvr_2 = {}
				arg1.Maid.SlashDetect = Util_upvr.Thread.Loop(function() -- Line 28
					--[[ Upvalues[2]:
						[1]: arg1 (copied, readonly)
						[2]: tbl_upvr_2 (readonly)
					]]
					local any_GetEntityInRange_result1_2 = arg1:GetEntityInRange(arg1.Character.PrimaryPart.CFrame, Vector3.new(5, 5, 5), tbl_upvr_2)
					if 0 < #any_GetEntityInRange_result1_2 then
						for _, v in pairs(any_GetEntityInRange_result1_2) do
							tbl_upvr_2[v.Humanoid] = true
						end
						arg1:Fire("SwordHit", any_GetEntityInRange_result1_2)
					end
					task.wait(0.1)
				end)
				Util_upvr.Thread.Wait(var15_upvr.SlashDuration)
				arg1.Maid.SlashDetect = nil
			end)
		end
	end
end
function module.OnEquip() -- Line 44
	--[[ Upvalues[1]:
		[1]: Util_upvr (readonly)
	]]
	Util_upvr.Sounds:Play("Equip")
end
function module.Deactive(arg1, arg2) -- Line 48
end
function module.Setup(arg1, arg2) -- Line 52
	warn("setting up", arg2)
	arg1.Maid:GiveTask(arg2.Activated:Connect(function() -- Line 55
		--[[ Upvalues[1]:
			[1]: arg1 (readonly)
		]]
		if arg1.Active then
			arg1:Active()
		end
		if arg1.Deactive then
			arg1.Maid.Deactivate = function() -- Line 60
				--[[ Upvalues[1]:
					[1]: arg1 (copied, readonly)
				]]
				arg1:Deactive()
			end
		end
	end))
	arg1.Maid:GiveTask(arg2.Deactivated:Connect(function() -- Line 66
		--[[ Upvalues[1]:
			[1]: arg1 (readonly)
		]]
		arg1.Maid.Deactivate = nil
	end))
	arg1.Maid:GiveTask(arg2.Equipped:Connect(function() -- Line 70
		--[[ Upvalues[1]:
			[1]: arg1 (readonly)
		]]
		if arg1.OnEquip then
			arg1:OnEquip()
		end
	end))
	arg1.Maid:GiveTask(arg2.Unequipped:Connect(function() -- Line 76
		--[[ Upvalues[1]:
			[1]: arg1 (readonly)
		]]
		if arg1.OnUnequip then
			arg1:OnUnequip()
		end
		arg1.Maid.Deactivate = nil
	end))
end
return module