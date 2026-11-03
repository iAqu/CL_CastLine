-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:24:49
-- Luau version 6, Types version 3
-- Time taken: 0.003180 seconds

local any_load_result1 = require(script.Parent.loader).load(script)
local var1_result1_upvr_2 = any_load_result1("Maid")
local module_upvr = {
	ClassName = "HumanoidTracker";
}
module_upvr.__index = module_upvr
local var1_result1_upvr = any_load_result1("ValueObject")
local var1_result1_upvr_4 = any_load_result1("Signal")
function module_upvr.new(arg1) -- Line 44
	--[[ Upvalues[4]:
		[1]: module_upvr (readonly)
		[2]: var1_result1_upvr_2 (readonly)
		[3]: var1_result1_upvr (readonly)
		[4]: var1_result1_upvr_4 (readonly)
	]]
	local setmetatable_result1_upvr = setmetatable({}, module_upvr)
	local var7 = arg1
	if not var7 then
		var7 = error("No player")
	end
	setmetatable_result1_upvr._player = var7
	setmetatable_result1_upvr._maid = var1_result1_upvr_2.new()
	setmetatable_result1_upvr.Humanoid = var1_result1_upvr.new()
	setmetatable_result1_upvr._maid:GiveTask(setmetatable_result1_upvr.Humanoid)
	setmetatable_result1_upvr.AliveHumanoid = var1_result1_upvr.new()
	setmetatable_result1_upvr._maid:GiveTask(setmetatable_result1_upvr.AliveHumanoid)
	setmetatable_result1_upvr._maid:GiveTask(setmetatable_result1_upvr.Humanoid.Changed:Connect(function(arg1_2, arg2, arg3) -- Line 58
		--[[ Upvalues[1]:
			[1]: setmetatable_result1_upvr (readonly)
		]]
		if not setmetatable_result1_upvr.Destroy then
		else
			setmetatable_result1_upvr:_handleHumanoidChanged(arg1_2, arg2, arg3)
		end
	end))
	setmetatable_result1_upvr._maid:GiveTask(setmetatable_result1_upvr._player:GetPropertyChangedSignal("Character"):Connect(function() -- Line 65
		--[[ Upvalues[1]:
			[1]: setmetatable_result1_upvr (readonly)
		]]
		if not setmetatable_result1_upvr.Destroy then
		else
			setmetatable_result1_upvr:_onCharacterChanged()
		end
	end))
	setmetatable_result1_upvr.HumanoidDied = var1_result1_upvr_4.new()
	setmetatable_result1_upvr._maid:GiveTask(setmetatable_result1_upvr.HumanoidDied)
	setmetatable_result1_upvr:_onCharacterChanged()
	return setmetatable_result1_upvr
end
local var1_result1_upvr_3 = any_load_result1("Promise")
function module_upvr.PromiseNextHumanoid(arg1) -- Line 87
	--[[ Upvalues[1]:
		[1]: var1_result1_upvr_3 (readonly)
	]]
	if arg1.Humanoid.Value then
		return var1_result1_upvr_3.resolved(arg1.Humanoid.Value)
	end
	if arg1._maid._nextHumanoidPromise then
		return arg1._maid._nextHumanoidPromise
	end
	local any_new_result1_upvr = var1_result1_upvr_3.new()
	local any_Connect_result1_upvr = arg1.Humanoid.Changed:Connect(function(arg1_3) -- Line 98
		--[[ Upvalues[1]:
			[1]: any_new_result1_upvr (readonly)
		]]
		if arg1_3 then
			any_new_result1_upvr:Resolve(arg1_3)
		end
	end)
	any_new_result1_upvr:Finally(function() -- Line 104
		--[[ Upvalues[1]:
			[1]: any_Connect_result1_upvr (readonly)
		]]
		any_Connect_result1_upvr:Disconnect()
	end)
	arg1._maid._nextHumanoidPromise = any_new_result1_upvr
	return any_new_result1_upvr
end
function module_upvr._onCharacterChanged(arg1) -- Line 113
	--[[ Upvalues[1]:
		[1]: var1_result1_upvr_2 (readonly)
	]]
	local any_new_result1_upvr_2 = var1_result1_upvr_2.new()
	arg1._maid._characterMaid = any_new_result1_upvr_2
	local Character = arg1._player.Character
	if not Character then
		arg1.Humanoid.Value = nil
	else
		local class_Humanoid = Character:FindFirstChildOfClass("Humanoid")
		if class_Humanoid then
			arg1.Humanoid.Value = class_Humanoid
			return
		end
		arg1.Humanoid.Value = nil
		any_new_result1_upvr_2._childAdded = Character.ChildAdded:Connect(function(arg1_4) -- Line 132
			--[[ Upvalues[2]:
				[1]: any_new_result1_upvr_2 (readonly)
				[2]: arg1 (readonly)
			]]
			if arg1_4:IsA("Humanoid") then
				any_new_result1_upvr_2._childAdded = nil
				arg1.Humanoid.Value = arg1_4
			end
		end)
	end
end
function module_upvr._handleHumanoidChanged(arg1, arg2, arg3, arg4) -- Line 140
	if not arg2 then
		arg1.AliveHumanoid.Value = nil
	else
		if arg2.Health <= 0 then
			arg1.AliveHumanoid.Value = nil
			return
		end
		arg1.AliveHumanoid.Value = arg2
		local var19_upvw = true
		arg4:GiveTask(function() -- Line 154
			--[[ Upvalues[1]:
				[1]: var19_upvw (read and write)
			]]
			var19_upvw = false
		end)
		arg4:GiveTask(arg2.Died:Connect(function() -- Line 157
			--[[ Upvalues[3]:
				[1]: var19_upvw (read and write)
				[2]: arg1 (readonly)
				[3]: arg2 (readonly)
			]]
			if not var19_upvw then
			else
				arg1.AliveHumanoid.Value = nil
				if arg1.Destroy then
					arg1.HumanoidDied:Fire(arg2)
				end
			end
		end))
	end
end
function module_upvr.Destroy(arg1) -- Line 174
	arg1._maid:DoCleaning()
	setmetatable(arg1, nil)
end
return module_upvr