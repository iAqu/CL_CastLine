-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:19:42
-- Luau version 6, Types version 3
-- Time taken: 0.002370 seconds

local module = {}
local Maid_upvr = require(game:GetService("ReplicatedStorage").ChiefUtils.Utilities.Maid)
local Signal_upvr = require(game:GetService("ReplicatedStorage").ChiefUtils.Utilities.Signal)
function module.Sync(arg1, arg2, ...) -- Line 5
	--[[ Upvalues[2]:
		[1]: Maid_upvr (readonly)
		[2]: Signal_upvr (readonly)
	]]
	local any_new_result1_upvr = Maid_upvr.new()
	any_new_result1_upvr.Active = true
	local any_new_result1_upvr_3 = Signal_upvr.new()
	local module_upvr = {}
	local function Destroy() -- Line 11
		--[[ Upvalues[1]:
			[1]: any_new_result1_upvr (readonly)
		]]
		any_new_result1_upvr:Destroy()
	end
	module_upvr.Destroy = Destroy
	local tbl = {}
	local function Connect(arg1_2, arg2_2, ...) -- Line 17
		--[[ Upvalues[2]:
			[1]: module_upvr (readonly)
			[2]: any_new_result1_upvr_3 (readonly)
		]]
		if module_upvr.Object then
			arg2_2(module_upvr.Object)
		end
		return any_new_result1_upvr_3:Connect(arg2_2)
	end
	tbl.Connect = Connect
	module_upvr.Loaded = tbl
	local args_list_upvr = {...}
	task.spawn(function() -- Line 26
		--[[ Upvalues[5]:
			[1]: arg2 (readonly)
			[2]: any_new_result1_upvr (readonly)
			[3]: args_list_upvr (readonly)
			[4]: any_new_result1_upvr_3 (readonly)
			[5]: module_upvr (readonly)
		]]
		local var10
		while any_new_result1_upvr.Active and next(args_list_upvr) do
			local SOME = var10:FindFirstChild(args_list_upvr[1])
			if SOME then
				var10 = SOME
				table.remove(args_list_upvr, 1)
			else
				task.wait(0.25)
			end
		end
		if not any_new_result1_upvr.Active then
		else
			any_new_result1_upvr_3:Fire(var10)
			module_upvr.Object = var10
		end
	end)
	return module_upvr
end
function module.SyncPrimaryPart(arg1, arg2) -- Line 45
	--[[ Upvalues[2]:
		[1]: Maid_upvr (readonly)
		[2]: Signal_upvr (readonly)
	]]
	local any_new_result1_upvr_4 = Maid_upvr.new()
	any_new_result1_upvr_4.Active = true
	local any_new_result1_upvr_2 = Signal_upvr.new()
	local module_upvr_2 = {
		Destroy = function() -- Line 51, Named "Destroy"
			--[[ Upvalues[1]:
				[1]: any_new_result1_upvr_4 (readonly)
			]]
			any_new_result1_upvr_4:Destroy()
		end;
		Loaded = {
			Connect = function(arg1_3, arg2_3) -- Line 57, Named "Connect"
				--[[ Upvalues[2]:
					[1]: module_upvr_2 (readonly)
					[2]: any_new_result1_upvr_2 (readonly)
				]]
				if module_upvr_2.Object then
					arg2_3(module_upvr_2.Object)
				end
				return any_new_result1_upvr_2:Connect(arg2_3)
			end;
		};
	}
	task.spawn(function() -- Line 65
		--[[ Upvalues[4]:
			[1]: any_new_result1_upvr_4 (readonly)
			[2]: arg2 (readonly)
			[3]: any_new_result1_upvr_2 (readonly)
			[4]: module_upvr_2 (readonly)
		]]
		local var17
		while any_new_result1_upvr_4.Active and not var17 do
			task.wait(0.25)
			var17 = arg2.PrimaryPart
		end
		if not any_new_result1_upvr_4.Active then
		else
			any_new_result1_upvr_2:Fire(var17)
			module_upvr_2.Object = var17
		end
	end)
	return module_upvr_2
end
return module