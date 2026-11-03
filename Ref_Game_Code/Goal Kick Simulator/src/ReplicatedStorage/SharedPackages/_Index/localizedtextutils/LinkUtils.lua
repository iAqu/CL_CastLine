-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:28:41
-- Luau version 6, Types version 3
-- Time taken: 0.005637 seconds

local any_load_result1 = require(script.Parent.loader).load(script)
local module = {
	createLink = function(arg1, arg2, arg3) -- Line 20, Named "createLink"
		-- KONSTANTERROR: [0] 1. Error Block 20 start (CF ANALYSIS FAILED)
		local var3
		if type(arg1) ~= "string" then
			var3 = false
		else
			var3 = true
		end
		assert(var3, "Bad linkName")
		if typeof(arg2) ~= "Instance" then
			var3 = false
			-- KONSTANTWARNING: GOTO [24] #19
		end
		-- KONSTANTERROR: [0] 1. Error Block 20 end (CF ANALYSIS FAILED)
		-- KONSTANTERROR: [23] 18. Error Block 22 start (CF ANALYSIS FAILED)
		var3 = true
		assert(var3, "Bad from")
		if typeof(arg3) ~= "Instance" then
			var3 = false
		else
			var3 = true
		end
		assert(var3, "Bad to")
		var3 = "ObjectValue"
		local any = Instance.new(var3)
		any.Name = arg1
		any.Value = arg3
		any.Parent = arg2
		do
			return any
		end
		-- KONSTANTERROR: [23] 18. Error Block 22 end (CF ANALYSIS FAILED)
	end;
	getAllLinkValues = function(arg1, arg2) -- Line 39, Named "getAllLinkValues"
		local var18
		if type(arg1) ~= "string" then
			var18 = false
		else
			var18 = true
		end
		assert(var18, "Bad linkName")
		if typeof(arg2) ~= "Instance" then
			var18 = false
		else
			var18 = true
		end
		assert(var18, "Bad from")
		var18 = pairs(arg2:GetChildren())
		for _, v in pairs(arg2:GetChildren()) do
			if v:IsA("ObjectValue") then
				if v.Name == arg1 then
					local Value = v.Value
					if Value then
						table.insert({}, Value)
					end
				end
			end
		end
		-- KONSTANTERROR: Expression was reused, decompilation is incorrect
		return {}
	end;
	getAllLinks = function(arg1, arg2) -- Line 63, Named "getAllLinks"
		local var27
		if type(arg1) ~= "string" then
			var27 = false
		else
			var27 = true
		end
		assert(var27, "Bad linkName")
		if typeof(arg2) ~= "Instance" then
			var27 = false
		else
			var27 = true
		end
		assert(var27, "Bad from")
		var27 = pairs(arg2:GetChildren())
		for _, v_2 in pairs(arg2:GetChildren()) do
			if v_2:IsA("ObjectValue") then
				if v_2.Name == arg1 then
					table.insert({}, v_2)
				end
			end
		end
		-- KONSTANTERROR: Expression was reused, decompilation is incorrect
		return {}
	end;
	getLinkValue = function(arg1, arg2) -- Line 83, Named "getLinkValue"
		local var31
		if type(arg1) ~= "string" then
			var31 = false
		else
			var31 = true
		end
		assert(var31, "Bad linkName")
		if typeof(arg2) ~= "Instance" then
			var31 = false
		else
			var31 = true
		end
		assert(var31, "Bad from")
		local SOME = arg2:FindFirstChild(arg1)
		if not SOME then
			var31 = nil
			return var31
		end
		var31 = SOME:IsA("ObjectValue")
		if not var31 then
			var31 = warn
			var31("[LinkUtils.getLinkValue] - Bad link %q not an object value, from %q":format(SOME:GetFullName(), arg2:GetFullName()))
			var31 = nil
			return var31
		end
		var31 = SOME.Value
		return var31
	end;
}
local var1_result1_upvr = any_load_result1("promiseChild")
local var1_result1_upvr_2 = any_load_result1("promisePropertyValue")
function module.promiseLinkValue(arg1, arg2, arg3) -- Line 108
	--[[ Upvalues[2]:
		[1]: var1_result1_upvr (readonly)
		[2]: var1_result1_upvr_2 (readonly)
	]]
	local var35 = arg1
	assert(var35, "Bad maid")
	if type(arg2) ~= "string" then
		var35 = false
	else
		var35 = true
	end
	assert(var35, "Bad linkName")
	if typeof(arg3) ~= "Instance" then
		var35 = false
	else
		var35 = true
	end
	assert(var35, "Bad from")
	var35 = arg3
	var35 = arg1:GiveTask
	var35(var1_result1_upvr(var35, arg2))
	var35 = var1_result1_upvr(var35, arg2):Then(function(arg1_2) -- Line 116
		--[[ Upvalues[2]:
			[1]: var1_result1_upvr_2 (copied, readonly)
			[2]: arg1 (readonly)
		]]
		local var1_result1_upvr_2_result1 = var1_result1_upvr_2(arg1_2, "Value")
		arg1:GiveTask(var1_result1_upvr_2_result1)
		return var1_result1_upvr_2_result1
	end)
	return var35
end
return module