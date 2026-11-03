-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:25:26
-- Luau version 6, Types version 3
-- Time taken: 0.002187 seconds

local any_load_result1 = require(script.Parent.loader).load(script)
local var1_result1_upvr = any_load_result1("Maid")
local any_load_result1_result1_upvr = any_load_result1("Observable")
local module = {
	observeAttribute = function(arg1, arg2, arg3) -- Line 24, Named "observeAttribute"
		--[[ Upvalues[2]:
			[1]: any_load_result1_result1_upvr (readonly)
			[2]: var1_result1_upvr (readonly)
		]]
		local var6
		if typeof(arg1) ~= "Instance" then
			var6 = false
		else
			var6 = true
		end
		assert(var6, "Bad instance")
		if type(arg2) ~= "string" then
			var6 = false
		else
			var6 = true
		end
		assert(var6, "Bad attributeName")
		var6 = any_load_result1_result1_upvr
		function var6(arg1_2) -- Line 28
			--[[ Upvalues[4]:
				[1]: var1_result1_upvr (copied, readonly)
				[2]: arg1 (readonly)
				[3]: arg2 (readonly)
				[4]: arg3 (readonly)
			]]
			local any_new_result1_2 = var1_result1_upvr.new()
			local function handleAttributeChanged() -- Line 31
				--[[ Upvalues[4]:
					[1]: arg1 (copied, readonly)
					[2]: arg2 (copied, readonly)
					[3]: arg1_2 (readonly)
					[4]: arg3 (copied, readonly)
				]]
				local attribute_2 = arg1:GetAttribute(arg2)
				if attribute_2 == nil then
					arg1_2:Fire(arg3)
				else
					arg1_2:Fire(attribute_2)
				end
			end
			any_new_result1_2:GiveTask(arg1:GetAttributeChangedSignal(arg2):Connect(handleAttributeChanged))
			local attribute_3 = arg1:GetAttribute(arg2)
			if attribute_3 == nil then
				arg1_2:Fire(arg3)
				return any_new_result1_2
			end
			arg1_2:Fire(attribute_3)
			return any_new_result1_2
		end
		return var6.new(var6)
	end;
}
local any_named_result1_upvw = any_load_result1("Symbol").named("unsetValue")
local any_load_result1_result1_upvr_2 = any_load_result1("Brio")
function module.observeAttributeBrio(arg1, arg2, arg3) -- Line 54
	--[[ Upvalues[4]:
		[1]: any_load_result1_result1_upvr (readonly)
		[2]: var1_result1_upvr (readonly)
		[3]: any_named_result1_upvw (readonly)
		[4]: any_load_result1_result1_upvr_2 (readonly)
	]]
	local var13
	if typeof(arg1) ~= "Instance" then
		var13 = false
	else
		var13 = true
	end
	assert(var13, "Bad instance")
	if type(arg2) ~= "string" then
		var13 = false
	else
		var13 = true
	end
	assert(var13, "Bad attributeName")
	var13 = any_load_result1_result1_upvr
	function var13(arg1_3) -- Line 58
		--[[ Upvalues[6]:
			[1]: var1_result1_upvr (copied, readonly)
			[2]: any_named_result1_upvw (copied, readonly)
			[3]: arg1 (readonly)
			[4]: arg2 (readonly)
			[5]: arg3 (readonly)
			[6]: any_load_result1_result1_upvr_2 (copied, readonly)
		]]
		local any_new_result1_3_upvr = var1_result1_upvr.new()
		local function handleAttributeChanged() -- Line 62
			--[[ Upvalues[7]:
				[1]: arg1 (copied, readonly)
				[2]: arg2 (copied, readonly)
				[3]: any_named_result1_upvw (read and write)
				[4]: arg3 (copied, readonly)
				[5]: any_load_result1_result1_upvr_2 (copied, readonly)
				[6]: any_new_result1_3_upvr (readonly)
				[7]: arg1_3 (readonly)
			]]
			-- KONSTANTERROR: [0] 1. Error Block 1 start (CF ANALYSIS FAILED)
			local attribute = arg1:GetAttribute(arg2)
			-- KONSTANTERROR: [0] 1. Error Block 1 end (CF ANALYSIS FAILED)
			-- KONSTANTERROR: [15] 14. Error Block 9 start (CF ANALYSIS FAILED)
			local any_new_result1 = any_load_result1_result1_upvr_2.new(attribute)
			any_new_result1_3_upvr._lastBrio = any_new_result1
			-- KONSTANTERROR: [15] 14. Error Block 9 end (CF ANALYSIS FAILED)
			-- KONSTANTERROR: [34] 28. Error Block 7 start (CF ANALYSIS FAILED)
			any_new_result1_3_upvr._lastBrio = nil
			-- KONSTANTERROR: [34] 28. Error Block 7 end (CF ANALYSIS FAILED)
			-- KONSTANTERROR: [38] 31. Error Block 8 start (CF ANALYSIS FAILED)
			-- KONSTANTERROR: [38] 31. Error Block 8 end (CF ANALYSIS FAILED)
		end
		any_new_result1_3_upvr:GiveTask(arg1:GetAttributeChangedSignal(arg2):Connect(handleAttributeChanged))
		handleAttributeChanged()
		return any_new_result1_3_upvr
	end
	return var13.new(var13)
end
return module