-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:25:59
-- Luau version 6, Types version 3
-- Time taken: 0.014268 seconds

local any_load_result1 = require(script.Parent.loader).load(script)
local any_load_result1_result1_upvr = any_load_result1("Brio")
local var1_result1_upvr_2 = any_load_result1("Maid")
local var1_result1_upvr = any_load_result1("Observable")
local any_named_result1_upvr = any_load_result1("Symbol").named("unsetValue")
local module_upvr = {
	observeProperty = function(arg1, arg2) -- Line 32, Named "observeProperty"
		--[[ Upvalues[2]:
			[1]: var1_result1_upvr (readonly)
			[2]: var1_result1_upvr_2 (readonly)
		]]
		local var8
		if typeof(arg1) ~= "Instance" then
			var8 = false
		else
			var8 = true
		end
		assert(var8, "'instance' should be of type Instance")
		if type(arg2) ~= "string" then
			var8 = false
		else
			var8 = true
		end
		assert(var8, "'propertyName' should be of type string")
		var8 = var1_result1_upvr
		function var8(arg1_2) -- Line 36
			--[[ Upvalues[3]:
				[1]: var1_result1_upvr_2 (copied, readonly)
				[2]: arg1 (readonly)
				[3]: arg2 (readonly)
			]]
			local any_new_result1_14 = var1_result1_upvr_2.new()
			any_new_result1_14:GiveTask(arg1:GetPropertyChangedSignal(arg2):Connect(function() -- Line 39
				--[[ Upvalues[3]:
					[1]: arg1_2 (readonly)
					[2]: arg1 (copied, readonly)
					[3]: arg2 (copied, readonly)
				]]
				arg1_2:Fire(arg1[arg2], arg1)
			end))
			arg1_2:Fire(arg1[arg2], arg1)
			return any_new_result1_14
		end
		return var8.new(var8)
	end;
}
local var1_result1_upvr_3 = any_load_result1("Rx")
function module_upvr.observeAncestry(arg1) -- Line 54
	--[[ Upvalues[1]:
		[1]: var1_result1_upvr_3 (readonly)
	]]
	return var1_result1_upvr_3.start(function() -- Line 55
		--[[ Upvalues[1]:
			[1]: arg1 (readonly)
		]]
		return arg1, arg1.Parent
	end)(var1_result1_upvr_3.fromSignal(arg1.AncestryChanged))
end
function module_upvr.observeFirstAncestorBrio(arg1, arg2) -- Line 69
	--[[ Upvalues[3]:
		[1]: var1_result1_upvr (readonly)
		[2]: var1_result1_upvr_2 (readonly)
		[3]: any_load_result1_result1_upvr (readonly)
	]]
	local var14
	if typeof(arg1) ~= "Instance" then
		var14 = false
	else
		var14 = true
	end
	assert(var14, "Bad instance")
	if type(arg2) ~= "string" then
		var14 = false
	else
		var14 = true
	end
	assert(var14, "Bad className")
	var14 = var1_result1_upvr
	function var14(arg1_3) -- Line 73
		--[[ Upvalues[4]:
			[1]: var1_result1_upvr_2 (copied, readonly)
			[2]: arg1 (readonly)
			[3]: arg2 (readonly)
			[4]: any_load_result1_result1_upvr (copied, readonly)
		]]
		-- KONSTANTERROR: [0] 1. Error Block 9 start (CF ANALYSIS FAILED)
		local any_new_result1_15_upvr = var1_result1_upvr_2.new()
		local var16_upvw
		local function handleAncestryChanged() -- Line 77
			--[[ Upvalues[6]:
				[1]: arg1 (copied, readonly)
				[2]: arg2 (copied, readonly)
				[3]: var16_upvw (read and write)
				[4]: any_load_result1_result1_upvr (copied, readonly)
				[5]: any_new_result1_15_upvr (readonly)
				[6]: arg1_3 (readonly)
			]]
			-- KONSTANTERROR: [0] 1. Error Block 1 start (CF ANALYSIS FAILED)
			local instance_4 = arg1:FindFirstAncestorWhichIsA(arg2)
			-- KONSTANTERROR: [0] 1. Error Block 1 end (CF ANALYSIS FAILED)
			-- KONSTANTERROR: [9] 8. Error Block 3 start (CF ANALYSIS FAILED)
			var16_upvw = instance_4
			local any_new_result1_8 = any_load_result1_result1_upvr.new(instance_4)
			any_new_result1_15_upvr._current = any_new_result1_8
			arg1_3:Fire(any_new_result1_8)
			do
				return
			end
			-- KONSTANTERROR: [9] 8. Error Block 3 end (CF ANALYSIS FAILED)
			-- KONSTANTERROR: [24] 20. Error Block 7 start (CF ANALYSIS FAILED)
			if var16_upvw then
				any_new_result1_15_upvr._current = nil
				var16_upvw = nil
			end
			-- KONSTANTERROR: [24] 20. Error Block 7 end (CF ANALYSIS FAILED)
		end
		any_new_result1_15_upvr:GiveTask(arg1.AncestryChanged:Connect(handleAncestryChanged))
		local instance = arg1:FindFirstAncestorWhichIsA(arg2)
		if instance then
			if instance ~= var16_upvw then
				var16_upvw = instance
				local any_new_result1 = any_load_result1_result1_upvr.new(instance)
				any_new_result1_15_upvr._current = any_new_result1
				arg1_3:Fire(any_new_result1)
				-- KONSTANTWARNING: GOTO [48] #39
			end
		elseif var16_upvw then
			any_new_result1_15_upvr._current = nil
			var16_upvw = nil
		end
		-- KONSTANTERROR: [0] 1. Error Block 9 end (CF ANALYSIS FAILED)
		-- KONSTANTERROR: [48] 39. Error Block 6 start (CF ANALYSIS FAILED)
		do
			return any_new_result1_15_upvr
		end
		-- KONSTANTERROR: [48] 39. Error Block 6 end (CF ANALYSIS FAILED)
	end
	return var14.new(var14)
end
function module_upvr.observeFirstAncestor(arg1, arg2) -- Line 107
	--[[ Upvalues[3]:
		[1]: var1_result1_upvr (readonly)
		[2]: var1_result1_upvr_2 (readonly)
		[3]: any_named_result1_upvr (readonly)
	]]
	local var22
	if typeof(arg1) ~= "Instance" then
		var22 = false
	else
		var22 = true
	end
	assert(var22, "Bad instance")
	if type(arg2) ~= "string" then
		var22 = false
	else
		var22 = true
	end
	assert(var22, "Bad className")
	var22 = var1_result1_upvr
	function var22(arg1_4) -- Line 111
		--[[ Upvalues[4]:
			[1]: var1_result1_upvr_2 (copied, readonly)
			[2]: any_named_result1_upvr (copied, readonly)
			[3]: arg1 (readonly)
			[4]: arg2 (readonly)
		]]
		local any_new_result1_5 = var1_result1_upvr_2.new()
		local var24_upvw = any_named_result1_upvr
		any_new_result1_5:GiveTask(arg1.AncestryChanged:Connect(function() -- Line 115, Named "handleAncestryChanged"
			--[[ Upvalues[4]:
				[1]: arg1 (copied, readonly)
				[2]: arg2 (copied, readonly)
				[3]: var24_upvw (read and write)
				[4]: arg1_4 (readonly)
			]]
			local instance_2 = arg1:FindFirstAncestorWhichIsA(arg2)
			if instance_2 ~= var24_upvw then
				var24_upvw = instance_2
				arg1_4:Fire(instance_2)
			end
		end))
		local instance_3 = arg1:FindFirstAncestorWhichIsA(arg2)
		if instance_3 ~= var24_upvw then
			var24_upvw = instance_3
			arg1_4:Fire(instance_3)
		end
		return any_new_result1_5
	end
	return var22.new(var22)
end
function module_upvr.observePropertyBrio(arg1, arg2, arg3) -- Line 138
	--[[ Upvalues[4]:
		[1]: var1_result1_upvr (readonly)
		[2]: var1_result1_upvr_2 (readonly)
		[3]: any_named_result1_upvr (readonly)
		[4]: any_load_result1_result1_upvr (readonly)
	]]
	local var28
	if typeof(arg1) ~= "Instance" then
		var28 = false
	else
		var28 = true
	end
	assert(var28, "Bad instance")
	if type(arg2) ~= "string" then
		var28 = false
	else
		var28 = true
	end
	assert(var28, "Bad propertyName")
	var28 = true
	if type(arg3) ~= "function" then
		if arg3 ~= nil then
			var28 = false
		else
			var28 = true
		end
	end
	assert(var28, "Bad predicate")
	var28 = var1_result1_upvr
	function var28(arg1_5) -- Line 143
		--[[ Upvalues[6]:
			[1]: var1_result1_upvr_2 (copied, readonly)
			[2]: any_named_result1_upvr (copied, readonly)
			[3]: arg1 (readonly)
			[4]: arg2 (readonly)
			[5]: arg3 (readonly)
			[6]: any_load_result1_result1_upvr (copied, readonly)
		]]
		-- KONSTANTERROR: [0] 1. Error Block 14 start (CF ANALYSIS FAILED)
		local any_new_result1_13_upvr = var1_result1_upvr_2.new()
		local var30_upvw = any_named_result1_upvr
		any_new_result1_13_upvr:GiveTask(arg1:GetPropertyChangedSignal(arg2):Connect(function() -- Line 147, Named "handlePropertyChanged"
			--[[ Upvalues[7]:
				[1]: arg1 (copied, readonly)
				[2]: arg2 (copied, readonly)
				[3]: var30_upvw (read and write)
				[4]: arg3 (copied, readonly)
				[5]: any_load_result1_result1_upvr (copied, readonly)
				[6]: any_new_result1_13_upvr (readonly)
				[7]: arg1_5 (readonly)
			]]
			-- KONSTANTERROR: [0] 1. Error Block 1 start (CF ANALYSIS FAILED)
			-- KONSTANTERROR: [0] 1. Error Block 1 end (CF ANALYSIS FAILED)
			-- KONSTANTERROR: [13] 13. Error Block 9 start (CF ANALYSIS FAILED)
			local any_new_result1_2 = any_load_result1_result1_upvr.new(arg1[arg2])
			any_new_result1_13_upvr._lastBrio = any_new_result1_2
			-- KONSTANTERROR: [13] 13. Error Block 9 end (CF ANALYSIS FAILED)
			-- KONSTANTERROR: [34] 29. Error Block 7 start (CF ANALYSIS FAILED)
			any_new_result1_13_upvr._lastBrio = nil
			-- KONSTANTERROR: [34] 29. Error Block 7 end (CF ANALYSIS FAILED)
			-- KONSTANTERROR: [38] 32. Error Block 8 start (CF ANALYSIS FAILED)
			-- KONSTANTERROR: [38] 32. Error Block 8 end (CF ANALYSIS FAILED)
		end))
		local var32 = arg1[arg2]
		if var30_upvw ~= var32 then
			var30_upvw = var32
			if not arg3 or arg3(var32) then
				local any_new_result1_17 = any_load_result1_result1_upvr.new(arg1[arg2])
				any_new_result1_13_upvr._lastBrio = any_new_result1_17
				if any_new_result1_13_upvr._lastBrio == any_new_result1_17 then
					arg1_5:Fire(any_new_result1_17)
					-- KONSTANTWARNING: GOTO [58] #48
				end
			else
				any_new_result1_13_upvr._lastBrio = nil
			end
		end
		-- KONSTANTERROR: [0] 1. Error Block 14 end (CF ANALYSIS FAILED)
		-- KONSTANTERROR: [58] 48. Error Block 9 start (CF ANALYSIS FAILED)
		do
			return any_new_result1_13_upvr
		end
		-- KONSTANTERROR: [58] 48. Error Block 9 end (CF ANALYSIS FAILED)
	end
	return var28.new(var28)
end
function module_upvr.observeLastNamedChildBrio(arg1, arg2, arg3) -- Line 186
	--[[ Upvalues[3]:
		[1]: var1_result1_upvr (readonly)
		[2]: var1_result1_upvr_2 (readonly)
		[3]: any_load_result1_result1_upvr (readonly)
	]]
	-- KONSTANTERROR: [0] 1. Error Block 20 start (CF ANALYSIS FAILED)
	local var35
	if typeof(arg1) ~= "Instance" then
		var35 = false
	else
		var35 = true
	end
	assert(var35, "Bad parent")
	if type(arg2) ~= "string" then
		var35 = false
		-- KONSTANTWARNING: GOTO [24] #19
	end
	-- KONSTANTERROR: [0] 1. Error Block 20 end (CF ANALYSIS FAILED)
	-- KONSTANTERROR: [23] 18. Error Block 22 start (CF ANALYSIS FAILED)
	var35 = true
	assert(var35, "Bad className")
	if type(arg3) ~= "string" then
		var35 = false
	else
		var35 = true
	end
	assert(var35, "Bad name")
	var35 = var1_result1_upvr
	function var35(arg1_6) -- Line 191
		--[[ Upvalues[5]:
			[1]: var1_result1_upvr_2 (copied, readonly)
			[2]: arg2 (readonly)
			[3]: arg3 (readonly)
			[4]: any_load_result1_result1_upvr (copied, readonly)
			[5]: arg1 (readonly)
		]]
		local any_new_result1_12_upvr = var1_result1_upvr_2.new()
		local function handleChild(arg1_7) -- Line 194
			--[[ Upvalues[6]:
				[1]: arg2 (copied, readonly)
				[2]: var1_result1_upvr_2 (copied, readonly)
				[3]: arg3 (copied, readonly)
				[4]: any_load_result1_result1_upvr (copied, readonly)
				[5]: any_new_result1_12_upvr (readonly)
				[6]: arg1_6 (readonly)
			]]
			if not arg1_7:IsA(arg2) then
			else
				local any_new_result1_23_upvr = var1_result1_upvr_2.new()
				local function handleNameChanged() -- Line 201
					--[[ Upvalues[6]:
						[1]: arg1_7 (readonly)
						[2]: arg3 (copied, readonly)
						[3]: any_load_result1_result1_upvr (copied, readonly)
						[4]: any_new_result1_23_upvr (readonly)
						[5]: any_new_result1_12_upvr (copied, readonly)
						[6]: arg1_6 (copied, readonly)
					]]
					if arg1_7.Name == arg3 then
						local any_new_result1_11 = any_load_result1_result1_upvr.new(arg1_7)
						any_new_result1_23_upvr._brio = any_new_result1_11
						any_new_result1_12_upvr._lastBrio = any_new_result1_11
						arg1_6:Fire(any_new_result1_11)
					else
						any_new_result1_23_upvr._brio = nil
					end
				end
				any_new_result1_23_upvr:GiveTask(arg1_7:GetPropertyChangedSignal("Name"):Connect(handleNameChanged))
				if arg1_7.Name == arg3 then
					local any_new_result1_21 = any_load_result1_result1_upvr.new(arg1_7)
					any_new_result1_23_upvr._brio = any_new_result1_21
					any_new_result1_12_upvr._lastBrio = any_new_result1_21
					arg1_6:Fire(any_new_result1_21)
				else
					any_new_result1_23_upvr._brio = nil
				end
				any_new_result1_12_upvr[arg1_7] = any_new_result1_23_upvr
			end
		end
		any_new_result1_12_upvr:GiveTask(arg1.ChildAdded:Connect(handleChild))
		any_new_result1_12_upvr:GiveTask(arg1.ChildRemoved:Connect(function(arg1_8) -- Line 220
			--[[ Upvalues[1]:
				[1]: any_new_result1_12_upvr (readonly)
			]]
			any_new_result1_12_upvr[arg1_8] = nil
		end))
		for _, v in pairs(arg1:GetChildren()) do
			handleChild(v)
		end
		return any_new_result1_12_upvr
	end
	do
		return var35.new(var35)
	end
	-- KONSTANTERROR: [23] 18. Error Block 22 end (CF ANALYSIS FAILED)
end
function module_upvr.observeChildrenOfNameBrio(arg1, arg2, arg3) -- Line 240
	--[[ Upvalues[3]:
		[1]: var1_result1_upvr (readonly)
		[2]: var1_result1_upvr_2 (readonly)
		[3]: any_load_result1_result1_upvr (readonly)
	]]
	-- KONSTANTERROR: [0] 1. Error Block 20 start (CF ANALYSIS FAILED)
	local var49
	if typeof(arg1) ~= "Instance" then
		var49 = false
	else
		var49 = true
	end
	assert(var49, "Bad parent")
	if type(arg2) ~= "string" then
		var49 = false
		-- KONSTANTWARNING: GOTO [24] #19
	end
	-- KONSTANTERROR: [0] 1. Error Block 20 end (CF ANALYSIS FAILED)
	-- KONSTANTERROR: [23] 18. Error Block 22 start (CF ANALYSIS FAILED)
	var49 = true
	assert(var49, "Bad className")
	if type(arg3) ~= "string" then
		var49 = false
	else
		var49 = true
	end
	assert(var49, "Bad name")
	var49 = var1_result1_upvr
	function var49(arg1_9) -- Line 245
		--[[ Upvalues[5]:
			[1]: var1_result1_upvr_2 (copied, readonly)
			[2]: arg2 (readonly)
			[3]: arg3 (readonly)
			[4]: any_load_result1_result1_upvr (copied, readonly)
			[5]: arg1 (readonly)
		]]
		local any_new_result1_3_upvr = var1_result1_upvr_2.new()
		local function handleChild(arg1_10) -- Line 248
			--[[ Upvalues[6]:
				[1]: arg2 (copied, readonly)
				[2]: var1_result1_upvr_2 (copied, readonly)
				[3]: arg3 (copied, readonly)
				[4]: any_load_result1_result1_upvr (copied, readonly)
				[5]: arg1_9 (readonly)
				[6]: any_new_result1_3_upvr (readonly)
			]]
			if not arg1_10:IsA(arg2) then
			else
				local any_new_result1_20_upvr = var1_result1_upvr_2.new()
				any_new_result1_20_upvr:GiveTask(arg1_10:GetPropertyChangedSignal("Name"):Connect(function() -- Line 255, Named "handleNameChanged"
					--[[ Upvalues[5]:
						[1]: arg1_10 (readonly)
						[2]: arg3 (copied, readonly)
						[3]: any_load_result1_result1_upvr (copied, readonly)
						[4]: any_new_result1_20_upvr (readonly)
						[5]: arg1_9 (copied, readonly)
					]]
					if arg1_10.Name == arg3 then
						local any_new_result1_22 = any_load_result1_result1_upvr.new(arg1_10)
						any_new_result1_20_upvr._brio = any_new_result1_22
						arg1_9:Fire(any_new_result1_22)
					else
						any_new_result1_20_upvr._brio = nil
					end
				end))
				if arg1_10.Name == arg3 then
					local any_new_result1_18 = any_load_result1_result1_upvr.new(arg1_10)
					any_new_result1_20_upvr._brio = any_new_result1_18
					arg1_9:Fire(any_new_result1_18)
				else
					any_new_result1_20_upvr._brio = nil
				end
				any_new_result1_3_upvr[arg1_10] = any_new_result1_20_upvr
			end
		end
		any_new_result1_3_upvr:GiveTask(arg1.ChildAdded:Connect(handleChild))
		any_new_result1_3_upvr:GiveTask(arg1.ChildRemoved:Connect(function(arg1_11) -- Line 273
			--[[ Upvalues[1]:
				[1]: any_new_result1_3_upvr (readonly)
			]]
			any_new_result1_3_upvr[arg1_11] = nil
		end))
		for _, v_2 in pairs(arg1:GetChildren()) do
			handleChild(v_2)
		end
		return any_new_result1_3_upvr
	end
	do
		return var49.new(var49)
	end
	-- KONSTANTERROR: [23] 18. Error Block 22 end (CF ANALYSIS FAILED)
end
function module_upvr.observeChildrenOfClassBrio(arg1, arg2) -- Line 292
	--[[ Upvalues[1]:
		[1]: module_upvr (readonly)
	]]
	local var62
	if typeof(arg1) ~= "Instance" then
		var62 = false
	else
		var62 = true
	end
	assert(var62, "Bad parent")
	if type(arg2) ~= "string" then
		var62 = false
	else
		var62 = true
	end
	assert(var62, "Bad className")
	var62 = module_upvr
	var62 = arg1
	return var62.observeChildrenBrio(var62, function(arg1_12) -- Line 296
		--[[ Upvalues[1]:
			[1]: arg2 (readonly)
		]]
		return arg1_12:IsA(arg2)
	end)
end
function module_upvr.observeChildrenBrio(arg1, arg2) -- Line 308
	--[[ Upvalues[3]:
		[1]: var1_result1_upvr (readonly)
		[2]: var1_result1_upvr_2 (readonly)
		[3]: any_load_result1_result1_upvr (readonly)
	]]
	local var65
	if typeof(arg1) ~= "Instance" then
		var65 = false
	else
		var65 = true
	end
	assert(var65, "Bad parent")
	var65 = true
	if type(arg2) ~= "function" then
		if arg2 ~= nil then
			var65 = false
		else
			var65 = true
		end
	end
	assert(var65, "Bad predicate")
	var65 = var1_result1_upvr
	function var65(arg1_13) -- Line 312
		--[[ Upvalues[4]:
			[1]: var1_result1_upvr_2 (copied, readonly)
			[2]: arg2 (readonly)
			[3]: any_load_result1_result1_upvr (copied, readonly)
			[4]: arg1 (readonly)
		]]
		local any_new_result1_19_upvr = var1_result1_upvr_2.new()
		any_new_result1_19_upvr:GiveTask(arg1.ChildAdded:Connect(function(arg1_14) -- Line 315, Named "handleChild"
			--[[ Upvalues[4]:
				[1]: arg2 (copied, readonly)
				[2]: any_load_result1_result1_upvr (copied, readonly)
				[3]: any_new_result1_19_upvr (readonly)
				[4]: arg1_13 (readonly)
			]]
			if not arg2 or arg2(arg1_14) then
				local any_new_result1_16 = any_load_result1_result1_upvr.new(arg1_14)
				any_new_result1_19_upvr[arg1_14] = any_new_result1_16
				arg1_13:Fire(any_new_result1_16)
			end
		end))
		any_new_result1_19_upvr:GiveTask(arg1.ChildRemoved:Connect(function(arg1_15) -- Line 324
			--[[ Upvalues[1]:
				[1]: any_new_result1_19_upvr (readonly)
			]]
			any_new_result1_19_upvr[arg1_15] = nil
		end))
		for _, v_3 in pairs(arg1:GetChildren()) do
			if not arg2 or arg2(v_3) then
				local any_new_result1_10 = any_load_result1_result1_upvr.new(v_3)
				any_new_result1_19_upvr[v_3] = any_new_result1_10
				arg1_13:Fire(any_new_result1_10)
			end
		end
		return any_new_result1_19_upvr
	end
	return var65.new(var65)
end
function module_upvr.observeDescendants(arg1, arg2) -- Line 343
	--[[ Upvalues[2]:
		[1]: var1_result1_upvr (readonly)
		[2]: var1_result1_upvr_2 (readonly)
	]]
	local var76
	if typeof(arg1) ~= "Instance" then
		var76 = false
	else
		var76 = true
	end
	assert(var76, "Bad parent")
	var76 = true
	if type(arg2) ~= "function" then
		if arg2 ~= nil then
			var76 = false
		else
			var76 = true
		end
	end
	assert(var76, "Bad predicate")
	var76 = var1_result1_upvr
	function var76(arg1_16) -- Line 347
		--[[ Upvalues[3]:
			[1]: var1_result1_upvr_2 (copied, readonly)
			[2]: arg2 (readonly)
			[3]: arg1 (readonly)
		]]
		local any_new_result1_7 = var1_result1_upvr_2.new()
		local tbl_upvr = {}
		local function handleDescendant(arg1_17) -- Line 351
			--[[ Upvalues[3]:
				[1]: arg2 (copied, readonly)
				[2]: tbl_upvr (readonly)
				[3]: arg1_16 (readonly)
			]]
			if not arg2 or arg2(arg1_17) then
				tbl_upvr[arg1_17] = true
				arg1_16:Fire(arg1_17, true)
			end
		end
		any_new_result1_7:GiveTask(arg1.DescendantAdded:Connect(handleDescendant))
		any_new_result1_7:GiveTask(arg1.DescendantRemoving:Connect(function(arg1_18) -- Line 359
			--[[ Upvalues[2]:
				[1]: tbl_upvr (readonly)
				[2]: arg1_16 (readonly)
			]]
			if tbl_upvr[arg1_18] then
				tbl_upvr[arg1_18] = nil
				arg1_16:Fire(arg1_18, false)
			end
		end))
		for _, v_4 in pairs(arg1:GetDescendants()) do
			if not arg2 or arg2(v_4) then
				tbl_upvr[v_4] = true
				arg1_16:Fire(v_4, true)
			end
		end
		return any_new_result1_7
	end
	return var76.new(var76)
end
function module_upvr.observeDescendantsBrio(arg1, arg2) -- Line 381
	--[[ Upvalues[3]:
		[1]: var1_result1_upvr (readonly)
		[2]: var1_result1_upvr_2 (readonly)
		[3]: any_load_result1_result1_upvr (readonly)
	]]
	local var86
	if typeof(arg1) ~= "Instance" then
		var86 = false
	else
		var86 = true
	end
	assert(var86, "Bad parent")
	var86 = true
	if type(arg2) ~= "function" then
		if arg2 ~= nil then
			var86 = false
		else
			var86 = true
		end
	end
	assert(var86, "Bad predicate")
	var86 = var1_result1_upvr
	function var86(arg1_19) -- Line 385
		--[[ Upvalues[4]:
			[1]: var1_result1_upvr_2 (copied, readonly)
			[2]: arg2 (readonly)
			[3]: any_load_result1_result1_upvr (copied, readonly)
			[4]: arg1 (readonly)
		]]
		local any_new_result1_6_upvr = var1_result1_upvr_2.new()
		any_new_result1_6_upvr:GiveTask(arg1.DescendantAdded:Connect(function(arg1_20) -- Line 388, Named "handleDescendant"
			--[[ Upvalues[4]:
				[1]: arg2 (copied, readonly)
				[2]: any_load_result1_result1_upvr (copied, readonly)
				[3]: any_new_result1_6_upvr (readonly)
				[4]: arg1_19 (readonly)
			]]
			if not arg2 or arg2(arg1_20) then
				local any_new_result1_4 = any_load_result1_result1_upvr.new(arg1_20)
				any_new_result1_6_upvr[arg1_20] = any_new_result1_4
				arg1_19:Fire(any_new_result1_4)
			end
		end))
		any_new_result1_6_upvr:GiveTask(arg1.DescendantRemoving:Connect(function(arg1_21) -- Line 397
			--[[ Upvalues[1]:
				[1]: any_new_result1_6_upvr (readonly)
			]]
			any_new_result1_6_upvr[arg1_21] = nil
		end))
		for _, v_5 in pairs(arg1:GetDescendants()) do
			if not arg2 or arg2(v_5) then
				local any_new_result1_9 = any_load_result1_result1_upvr.new(v_5)
				any_new_result1_6_upvr[v_5] = any_new_result1_9
				arg1_19:Fire(any_new_result1_9)
			end
		end
		return any_new_result1_6_upvr
	end
	return var86.new(var86)
end
function module_upvr.observeDescendantsOfClassBrio(arg1, arg2) -- Line 417
	--[[ Upvalues[1]:
		[1]: module_upvr (readonly)
	]]
	local var96
	if typeof(arg1) ~= "Instance" then
		var96 = false
	else
		var96 = true
	end
	assert(var96, "Bad parent")
	if type(arg2) ~= "string" then
		var96 = false
	else
		var96 = true
	end
	assert(var96, "Bad className")
	var96 = module_upvr
	var96 = arg1
	return var96.observeChildrenBrio(var96, function(arg1_22) -- Line 421
		--[[ Upvalues[1]:
			[1]: arg2 (readonly)
		]]
		return arg1_22:IsA(arg2)
	end)
end
return module_upvr