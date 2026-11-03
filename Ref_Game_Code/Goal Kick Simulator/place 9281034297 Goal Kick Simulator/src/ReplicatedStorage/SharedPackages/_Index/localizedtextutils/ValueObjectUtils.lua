-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:28:53
-- Luau version 6, Types version 3
-- Time taken: 0.001521 seconds

local any_load_result1 = require(script.Parent.loader).load(script)
local var1_result1_upvr = any_load_result1("Maid")
local var1_result1_upvr_2 = any_load_result1("Observable")
local module = {
	syncValue = function(arg1, arg2) -- Line 21, Named "syncValue"
		--[[ Upvalues[1]:
			[1]: var1_result1_upvr (readonly)
		]]
		local any_new_result1 = var1_result1_upvr.new()
		arg2.Value = arg1.Value
		any_new_result1:GiveTask(arg1.Changed:Connect(function() -- Line 25
			--[[ Upvalues[2]:
				[1]: arg2 (readonly)
				[2]: arg1 (readonly)
			]]
			arg2.Value = arg1.Value
		end))
		return any_new_result1
	end;
}
local var1_result1_upvr_3 = any_load_result1("ValueObject")
function module.observeValue(arg1) -- Line 37
	--[[ Upvalues[3]:
		[1]: var1_result1_upvr_3 (readonly)
		[2]: var1_result1_upvr_2 (readonly)
		[3]: var1_result1_upvr (readonly)
	]]
	assert(var1_result1_upvr_3.isValueObject(arg1), "Bad valueObject")
	return var1_result1_upvr_2.new(function(arg1_2) -- Line 40
		--[[ Upvalues[2]:
			[1]: arg1 (readonly)
			[2]: var1_result1_upvr (copied, readonly)
		]]
		if not arg1.Destroy then
			warn("[ValueObjectUtils.observeValue] - Connecting to dead ValueObject")
			arg1_2:Complete()
			return
		end
		local any_new_result1_3 = var1_result1_upvr.new()
		any_new_result1_3:GiveTask(arg1.Changed:Connect(function() -- Line 50
			--[[ Upvalues[2]:
				[1]: arg1_2 (readonly)
				[2]: arg1 (copied, readonly)
			]]
			arg1_2:Fire(arg1.Value)
		end))
		arg1_2:Fire(arg1.Value)
		return any_new_result1_3
	end)
end
local var1_result1_upvr_4 = any_load_result1("Brio")
function module.observeValueBrio(arg1) -- Line 65
	--[[ Upvalues[3]:
		[1]: var1_result1_upvr_2 (readonly)
		[2]: var1_result1_upvr (readonly)
		[3]: var1_result1_upvr_4 (readonly)
	]]
	assert(arg1, "Bad valueObject")
	return var1_result1_upvr_2.new(function(arg1_3) -- Line 68
		--[[ Upvalues[3]:
			[1]: var1_result1_upvr (copied, readonly)
			[2]: var1_result1_upvr_4 (copied, readonly)
			[3]: arg1 (readonly)
		]]
		local any_new_result1_upvr = var1_result1_upvr.new()
		any_new_result1_upvr:GiveTask(arg1.Changed:Connect(function() -- Line 71, Named "refire"
			--[[ Upvalues[4]:
				[1]: var1_result1_upvr_4 (copied, readonly)
				[2]: arg1 (copied, readonly)
				[3]: any_new_result1_upvr (readonly)
				[4]: arg1_3 (readonly)
			]]
			local any_new_result1_4 = var1_result1_upvr_4.new(arg1.Value)
			any_new_result1_upvr._lastBrio = any_new_result1_4
			arg1_3:Fire(any_new_result1_4)
		end))
		local any_new_result1_2 = var1_result1_upvr_4.new(arg1.Value)
		any_new_result1_upvr._lastBrio = any_new_result1_2
		arg1_3:Fire(any_new_result1_2)
		return any_new_result1_upvr
	end)
end
return module