-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:20:46
-- Luau version 6, Types version 3
-- Time taken: 0.003464 seconds

local module = {}
local Maid_upvr = require(script.Parent.Maid)
local Signal_upvr = require(script.Parent.Signal)
local function DeepSearch_upvr(arg1, ...) -- Line 5, Named "DeepSearch"
	--[[ Upvalues[2]:
		[1]: Maid_upvr (readonly)
		[2]: Signal_upvr (readonly)
	]]
	local any_new_result1_upvr = Maid_upvr.new()
	any_new_result1_upvr.Active = true
	local any_new_result1_upvr_5 = Signal_upvr.new()
	local module_3_upvr = {
		Objects = {};
	}
	local function Destroy() -- Line 12
		--[[ Upvalues[1]:
			[1]: any_new_result1_upvr (readonly)
		]]
		any_new_result1_upvr:Destroy()
	end
	module_3_upvr.Destroy = Destroy
	local tbl = {}
	local function Connect(arg1_2, arg2) -- Line 19
		--[[ Upvalues[3]:
			[1]: module_3_upvr (readonly)
			[2]: any_new_result1_upvr_5 (readonly)
			[3]: any_new_result1_upvr (readonly)
		]]
		for i in pairs(module_3_upvr.Objects) do
			arg2(i)
		end
		local any_Connect_result1 = any_new_result1_upvr_5:Connect(arg2)
		any_new_result1_upvr:GiveTask(any_Connect_result1)
		return any_Connect_result1
	end
	tbl.Connect = Connect
	function tbl.QuickConnect(arg1_3, arg2) -- Line 27
		--[[ Upvalues[3]:
			[1]: module_3_upvr (readonly)
			[2]: any_new_result1_upvr (readonly)
			[3]: any_new_result1_upvr_5 (readonly)
		]]
		for i_2 in pairs(module_3_upvr.Objects) do
			arg2(i_2)
		end
		any_new_result1_upvr:GiveTask(any_new_result1_upvr_5:Connect(arg2))
		return module_3_upvr
	end
	module_3_upvr.Loaded = tbl
	local function Find_upvr(arg1_4, arg2, ...) -- Line 36, Named "Find"
		--[[ Upvalues[4]:
			[1]: Maid_upvr (copied, readonly)
			[2]: Find_upvr (readonly)
			[3]: module_3_upvr (readonly)
			[4]: any_new_result1_upvr_5 (readonly)
		]]
		local any_new_result1 = Maid_upvr.new()
		local any_new_result1_upvr_3 = Maid_upvr.new()
		local args_list_upvr = {...}
		local next_result1_upvr = next(args_list_upvr)
		local function OnNameCheck_upvr(arg1_5) -- Line 43, Named "OnNameCheck"
			--[[ Upvalues[9]:
				[1]: arg2 (readonly)
				[2]: Maid_upvr (copied, readonly)
				[3]: OnNameCheck_upvr (readonly)
				[4]: next_result1_upvr (readonly)
				[5]: Find_upvr (copied, readonly)
				[6]: args_list_upvr (readonly)
				[7]: module_3_upvr (copied, readonly)
				[8]: any_new_result1_upvr_5 (copied, readonly)
				[9]: any_new_result1_upvr_3 (readonly)
			]]
			if arg1_5.Name == arg2 then
				local any_new_result1_2 = Maid_upvr.new()
				any_new_result1_2.NameChanged = arg1_5:GetPropertyChangedSignal("Name"):Connect(function() -- Line 46
					--[[ Upvalues[2]:
						[1]: OnNameCheck_upvr (copied, readonly)
						[2]: arg1_5 (readonly)
					]]
					OnNameCheck_upvr(arg1_5)
				end)
				if next_result1_upvr then
					any_new_result1_2.Tracker = Find_upvr(arg1_5, unpack(args_list_upvr))
				else
					module_3_upvr.Objects[arg1_5] = true
					any_new_result1_upvr_5:Fire(arg1_5)
					function any_new_result1_2.Remove() -- Line 55
						--[[ Upvalues[2]:
							[1]: module_3_upvr (copied, readonly)
							[2]: arg1_5 (readonly)
						]]
						module_3_upvr.Objects[arg1_5] = nil
					end
				end
				any_new_result1_upvr_3[arg1_5] = any_new_result1_2
			else
				any_new_result1_upvr_3[arg1_5] = arg1_5:GetPropertyChangedSignal("Name"):Connect(function() -- Line 61
					--[[ Upvalues[2]:
						[1]: OnNameCheck_upvr (copied, readonly)
						[2]: arg1_5 (readonly)
					]]
					OnNameCheck_upvr(arg1_5)
				end)
			end
		end
		for _, v in pairs(arg1_4:GetChildren()) do
			OnNameCheck_upvr(v)
		end
		any_new_result1.NamesMaid = any_new_result1_upvr_3
		any_new_result1.ChildAdded = arg1_4.ChildAdded:Connect(OnNameCheck_upvr)
		any_new_result1.ChildRemoved = arg1_4.ChildRemoved:Connect(function(arg1_6) -- Line 72
			--[[ Upvalues[1]:
				[1]: any_new_result1_upvr_3 (readonly)
			]]
			any_new_result1_upvr_3[arg1_6] = nil
		end)
		return any_new_result1
	end
	any_new_result1_upvr.Tracker = Find_upvr(arg1, ...)
	return module_3_upvr
end
function module.Sync(arg1, arg2, ...) -- Line 82
	--[[ Upvalues[1]:
		[1]: DeepSearch_upvr (readonly)
	]]
	return DeepSearch_upvr(arg2, ...)
end
function module.SyncPrimaryPart(arg1, arg2) -- Line 86
	--[[ Upvalues[2]:
		[1]: Maid_upvr (readonly)
		[2]: Signal_upvr (readonly)
	]]
	local any_new_result1_upvr_4 = Maid_upvr.new()
	any_new_result1_upvr_4.Active = true
	local any_new_result1_upvr_2 = Signal_upvr.new()
	local module_2_upvr = {
		Destroy = function() -- Line 92, Named "Destroy"
			--[[ Upvalues[1]:
				[1]: any_new_result1_upvr_4 (readonly)
			]]
			any_new_result1_upvr_4:Destroy()
		end;
		Loaded = {
			Connect = function(arg1_7, arg2_2) -- Line 98, Named "Connect"
				--[[ Upvalues[2]:
					[1]: module_2_upvr (readonly)
					[2]: any_new_result1_upvr_2 (readonly)
				]]
				if module_2_upvr.Object then
					arg2_2(module_2_upvr.Object)
				end
				return any_new_result1_upvr_2:Connect(arg2_2)
			end;
		};
	}
	task.spawn(function() -- Line 106
		--[[ Upvalues[4]:
			[1]: any_new_result1_upvr_4 (readonly)
			[2]: arg2 (readonly)
			[3]: any_new_result1_upvr_2 (readonly)
			[4]: module_2_upvr (readonly)
		]]
		local var38
		while any_new_result1_upvr_4.Active and not var38 do
			task.wait(0.25)
			var38 = arg2.PrimaryPart
		end
		if not any_new_result1_upvr_4.Active then
		else
			any_new_result1_upvr_2:Fire(var38)
			module_2_upvr.Object = var38
		end
	end)
	return module_2_upvr
end
return module