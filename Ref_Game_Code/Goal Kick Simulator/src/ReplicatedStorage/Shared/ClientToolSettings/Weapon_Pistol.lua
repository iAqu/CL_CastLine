-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:20:04
-- Luau version 6, Types version 3
-- Time taken: 0.002152 seconds

local module = {}
local Util_upvr = require(game:GetService("ReplicatedStorage").Util)
local mouse_upvr = game:GetService("Players").LocalPlayer:GetMouse()
function module.Active(arg1) -- Line 7
	--[[ Upvalues[2]:
		[1]: Util_upvr (readonly)
		[2]: mouse_upvr (readonly)
	]]
	if arg1.Cooldown and not arg1.Reloading then
		arg1:Fire("Reload")
		arg1.Reloading = true
		arg1.Maid.Cooldown = Util_upvr.Thread.Delay(arg1.ReloadTime, function() -- Line 11
			--[[ Upvalues[1]:
				[1]: arg1 (readonly)
			]]
			arg1.Cooldown = nil
		end)
	elseif not arg1.Stunned and arg1.Tool and arg1.Tool.HandleObject.Value then
		arg1.Cooldown = true
		arg1:Fire("Shoot", mouse_upvr.Hit.Position)
		arg1.Maid.Cooldown = Util_upvr.Thread.Delay(0.5, function() -- Line 19
			--[[ Upvalues[3]:
				[1]: arg1 (readonly)
				[2]: mouse_upvr (copied, readonly)
				[3]: Util_upvr (copied, readonly)
			]]
			arg1.Reloading = true
			arg1:Fire("Reload", mouse_upvr.Hit.Position)
			arg1.Maid.Cooldown = Util_upvr.Thread.Delay(arg1.ReloadTime, function() -- Line 22
				--[[ Upvalues[1]:
					[1]: arg1 (copied, readonly)
				]]
				arg1.Reloading = nil
				arg1.Cooldown = nil
			end)
		end)
	end
end
function module.OnEquip() -- Line 30
	--[[ Upvalues[1]:
		[1]: Util_upvr (readonly)
	]]
	Util_upvr.Sounds:Play("Equip")
end
function module.OnUnequip(arg1) -- Line 34
	arg1.Maid.Cooldown = nil
	arg1.Reloading = nil
end
function module.Deactive(arg1, arg2) -- Line 39
end
function module.Setup(arg1, arg2) -- Line 43
	arg1.Maid:GiveTask(arg2.Activated:Connect(function() -- Line 45
		--[[ Upvalues[1]:
			[1]: arg1 (readonly)
		]]
		if arg1.Active then
			arg1:Active()
		end
		if arg1.Deactive then
			arg1.Maid.Deactivate = function() -- Line 50
				--[[ Upvalues[1]:
					[1]: arg1 (copied, readonly)
				]]
				arg1:Deactive()
			end
		end
	end))
	arg1.Maid:GiveTask(arg2.Deactivated:Connect(function() -- Line 56
		--[[ Upvalues[1]:
			[1]: arg1 (readonly)
		]]
		arg1.Maid.Deactivate = nil
	end))
	arg1.Maid:GiveTask(arg2.Equipped:Connect(function() -- Line 60
		--[[ Upvalues[1]:
			[1]: arg1 (readonly)
		]]
		if arg1.OnEquip then
			arg1:OnEquip()
		end
	end))
	arg1.Maid:GiveTask(arg2.Unequipped:Connect(function() -- Line 66
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