-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:28:25
-- Luau version 6, Types version 3
-- Time taken: 0.001541 seconds

local any_load_result1 = require(script.Parent.loader).load(script)
local var1_result1_upvr = any_load_result1("StateStack")
local var1_result1_upvr_3 = any_load_result1("Brio")
local module = {}
local var1_result1_upvr_2 = any_load_result1("Observable")
local var1_result1_upvr_4 = any_load_result1("Maid")
function module.topOfStack() -- Line 18
	--[[ Upvalues[4]:
		[1]: var1_result1_upvr_2 (readonly)
		[2]: var1_result1_upvr_4 (readonly)
		[3]: var1_result1_upvr (readonly)
		[4]: var1_result1_upvr_3 (readonly)
	]]
	return function(arg1) -- Line 19
		--[[ Upvalues[4]:
			[1]: var1_result1_upvr_2 (copied, readonly)
			[2]: var1_result1_upvr_4 (copied, readonly)
			[3]: var1_result1_upvr (copied, readonly)
			[4]: var1_result1_upvr_3 (copied, readonly)
		]]
		return var1_result1_upvr_2.new(function(arg1_2) -- Line 20
			--[[ Upvalues[4]:
				[1]: var1_result1_upvr_4 (copied, readonly)
				[2]: var1_result1_upvr (copied, readonly)
				[3]: arg1 (readonly)
				[4]: var1_result1_upvr_3 (copied, readonly)
			]]
			local any_new_result1 = var1_result1_upvr_4.new()
			local any_new_result1_upvr = var1_result1_upvr.new(nil)
			any_new_result1:GiveTask(any_new_result1_upvr)
			any_new_result1:GiveTask(arg1:Subscribe(function(arg1_3) -- Line 26
				--[[ Upvalues[2]:
					[1]: var1_result1_upvr_3 (copied, readonly)
					[2]: any_new_result1_upvr (readonly)
				]]
				if not var1_result1_upvr_3.isBrio(arg1_3) then
					warn("Not a brio")
				elseif not arg1_3:IsDead() then
					arg1_3:ToMaid():GiveTask(any_new_result1_upvr:PushState(arg1_3:GetValue()))
				end
			end))
			any_new_result1:GiveTask(any_new_result1_upvr.Changed:Connect(function() -- Line 37, Named "update"
				--[[ Upvalues[2]:
					[1]: arg1_2 (readonly)
					[2]: any_new_result1_upvr (readonly)
				]]
				arg1_2:Fire(any_new_result1_upvr:GetState())
			end))
			arg1_2:Fire(any_new_result1_upvr:GetState())
			return any_new_result1
		end)
	end
end
function module.createStateStack(arg1) -- Line 57
	--[[ Upvalues[2]:
		[1]: var1_result1_upvr (readonly)
		[2]: var1_result1_upvr_3 (readonly)
	]]
	local any_new_result1_2_upvr = var1_result1_upvr.new(nil)
	any_new_result1_2_upvr._maid:GiveTask(arg1:Subscribe(function(arg1_4) -- Line 60
		--[[ Upvalues[2]:
			[1]: var1_result1_upvr_3 (copied, readonly)
			[2]: any_new_result1_2_upvr (readonly)
		]]
		assert(var1_result1_upvr_3.isBrio(arg1_4), "Observable must emit brio")
		if arg1_4:IsDead() then
		else
			arg1_4:ToMaid():GiveTask(any_new_result1_2_upvr:PushState(arg1_4:GetValue()))
		end
	end))
	return any_new_result1_2_upvr
end
return module