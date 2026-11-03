-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:28:46
-- Luau version 6, Types version 3
-- Time taken: 0.008214 seconds

local HttpService_upvr = game:GetService("HttpService")
local any_load_result1 = require(script.Parent.loader).load(script)
local module_upvr = {
	create = function(arg1, arg2) -- Line 35, Named "create"
		local var4
		if type(arg1) ~= "string" then
			var4 = false
		else
			var4 = true
		end
		assert(var4, "Bad translationKey")
		var4 = true
		if type(arg2) ~= "table" then
			if arg2 ~= nil then
				var4 = false
			else
				var4 = true
			end
		end
		assert(var4, "Bad translationArgs")
		local module = {}
		module.translationKey = arg1
		module.translationArgs = arg2
		return module
	end;
	isLocalizedText = function(arg1) -- Line 50, Named "isLocalizedText"
		local var8 = false
		if type(arg1) == "table" then
			var8 = false
			if type(arg1.translationKey) == "string" then
				var8 = true
				if type(arg1.translationArgs) ~= "table" then
					if arg1.translationArgs ~= nil then
						var8 = false
					else
						var8 = true
					end
				end
			end
		end
		return var8
	end;
}
function module_upvr.formatByKeyRecursive(arg1, arg2, arg3, arg4) -- Line 65
	--[[ Upvalues[1]:
		[1]: module_upvr (readonly)
	]]
	local var17 = arg1
	assert(var17, "Bad translator")
	if type(arg2) ~= "string" then
		var17 = false
	else
		var17 = true
	end
	assert(var17, "Bad translationKey")
	var17 = true
	if type(arg3) ~= "table" then
		if arg3 ~= nil then
			var17 = false
		else
			var17 = true
		end
	end
	assert(var17, "Bad translationArgs")
	if arg3 then
		var17 = pairs(arg3)
		local pairs_result1_2, pairs_result2_2, pairs_result3_3 = pairs(arg3)
		for i, v in pairs_result1_2, pairs_result2_2, pairs_result3_3 do
			if type(v) == "table" then
				assert(v.translationKey, "Table, but no translationKey")
				if v.translationArgs then
					({})[i] = module_upvr.formatByKeyRecursive(arg1, v.translationKey, v.translationArgs, arg4)
				else
					-- KONSTANTERROR: Expression was reused, decompilation is incorrect
					;({})[i] = arg1:FormatByKey(v.translationKey)
				end
			else
				-- KONSTANTERROR: Expression was reused, decompilation is incorrect
				;({})[i] = v
			end
		end
	end
	if arg4 then
		pairs_result1_2 = pairs(arg4)
		local pairs_result1_3, pairs_result2, pairs_result3 = pairs(arg4)
		for i_2, v_2 in pairs_result1_3, pairs_result2, pairs_result3 do
			-- KONSTANTERROR: Expression was reused, decompilation is incorrect
			;({})[i_2] = v_2
			local var24
		end
	end
	pairs_result1_3 = arg1:FormatByKey(arg2, var24)
	return pairs_result1_3
end
function module_upvr.observeFormatByKeyRecursive(arg1, arg2, arg3, arg4) -- Line 106
	--[[ Upvalues[1]:
		[1]: module_upvr (readonly)
	]]
	local var33 = arg1
	assert(var33, "Bad translator")
	if type(arg2) ~= "string" then
		var33 = false
	else
		var33 = true
	end
	assert(var33, "Bad translationKey")
	var33 = true
	if type(arg3) ~= "table" then
		if arg3 ~= nil then
			var33 = false
		else
			var33 = true
		end
	end
	assert(var33, "Bad translationArgs")
	if arg3 then
		var33 = pairs(arg3)
		local pairs_result1, pairs_result2_4, pairs_result3_2 = pairs(arg3)
		for i_3, v_3 in pairs_result1, pairs_result2_4, pairs_result3_2 do
			if type(v_3) == "table" then
				assert(v_3.translationKey, "Table, but no translationKey")
				if v_3.translationArgs then
					({})[i_3] = module_upvr.observeFormatByKeyRecursive(arg1, v_3.translationKey, v_3.translationArgs, arg4)
				else
					-- KONSTANTERROR: Expression was reused, decompilation is incorrect
					;({})[i_3] = arg1:ObserveFormatByKey(v_3.translationKey)
				end
			else
				-- KONSTANTERROR: Expression was reused, decompilation is incorrect
				;({})[i_3] = v_3
			end
		end
	end
	if arg4 then
		pairs_result1 = pairs(arg4)
		local pairs_result1_4, pairs_result2_3, pairs_result3_4 = pairs(arg4)
		for i_4, v_4 in pairs_result1_4, pairs_result2_3, pairs_result3_4 do
			-- KONSTANTERROR: Expression was reused, decompilation is incorrect
			;({})[i_4] = v_4
			local var40
		end
	end
	pairs_result1_4 = arg1:ObserveFormatByKey(arg2, var40)
	return pairs_result1_4
end
function module_upvr.localizedTextToString(arg1, arg2, arg3) -- Line 145
	--[[ Upvalues[1]:
		[1]: module_upvr (readonly)
	]]
	assert(arg1, "Bad translator")
	assert(module_upvr.isLocalizedText(arg2), "No localizedText")
	return module_upvr.formatByKeyRecursive(arg1, arg2.translationKey, arg2.translationArgs, arg3)
end
function module_upvr.fromJSON(arg1) -- Line 161
	--[[ Upvalues[1]:
		[1]: HttpService_upvr (readonly)
	]]
	local var41
	if type(arg1) ~= "string" then
		var41 = false
	else
		var41 = true
	end
	assert(var41, "Bad text")
	local var42_upvw
	var41 = pcall
	var41 = var41(function() -- Line 165
		--[[ Upvalues[3]:
			[1]: var42_upvw (read and write)
			[2]: HttpService_upvr (copied, readonly)
			[3]: arg1 (readonly)
		]]
		var42_upvw = HttpService_upvr:JSONDecode(arg1)
	end)
	if not var41 then
		return nil
	end
	return var42_upvw
end
function module_upvr.toJSON(arg1) -- Line 180
	--[[ Upvalues[2]:
		[1]: module_upvr (readonly)
		[2]: HttpService_upvr (readonly)
	]]
	assert(module_upvr.isLocalizedText(arg1), "Bad localizedText")
	return HttpService_upvr:JSONEncode(arg1)
end
function module_upvr.setFromAttribute(arg1, arg2, arg3, arg4) -- Line 195
	--[[ Upvalues[1]:
		[1]: module_upvr (readonly)
	]]
	local var44
	if typeof(arg1) ~= "Instance" then
		var44 = false
	else
		var44 = true
	end
	assert(var44, "Bad obj")
	if type(arg2) ~= "string" then
		var44 = false
	else
		var44 = true
	end
	assert(var44, "Bad attributeName")
	var44 = module_upvr
	var44 = arg3
	var44 = arg1:SetAttribute
	var44(arg2, module_upvr.toJSON(var44.create(var44, arg4)))
end
function module_upvr.getFromAttribute(arg1, arg2) -- Line 209
	--[[ Upvalues[1]:
		[1]: module_upvr (readonly)
	]]
	local var45
	if typeof(arg1) ~= "Instance" then
		var45 = false
	else
		var45 = true
	end
	assert(var45, "Bad obj")
	if type(arg2) ~= "string" then
		var45 = false
	else
		var45 = true
	end
	assert(var45, "Bad attributeName")
	local attribute = arg1:GetAttribute(arg2)
	var45 = type(attribute)
	if var45 == "string" then
		var45 = module_upvr.fromJSON(attribute)
		return var45
	end
	var45 = nil
	return var45
end
function module_upvr.getTranslationFromAttribute(arg1, arg2, arg3, arg4) -- Line 229
	--[[ Upvalues[1]:
		[1]: module_upvr (readonly)
	]]
	local var47 = arg1
	assert(var47, "Bad translator")
	if typeof(arg2) ~= "Instance" then
		var47 = false
	else
		var47 = true
	end
	assert(var47, "Bad obj")
	if type(arg3) ~= "string" then
		var47 = false
	else
		var47 = true
	end
	assert(var47, "Bad attributeName")
	var47 = module_upvr
	var47 = arg2
	local any_getFromAttribute_result1 = var47.getFromAttribute(var47, arg3)
	if any_getFromAttribute_result1 then
		var47 = module_upvr.localizedTextToString(arg1, any_getFromAttribute_result1, arg4)
		return var47
	end
	var47 = nil
	return var47
end
function module_upvr.initializeAttribute(arg1, arg2, arg3, arg4) -- Line 249
	--[[ Upvalues[1]:
		[1]: module_upvr (readonly)
	]]
	-- KONSTANTERROR: [0] 1. Error Block 30 start (CF ANALYSIS FAILED)
	local var49
	if typeof(arg1) ~= "Instance" then
		var49 = false
	else
		var49 = true
	end
	assert(var49, "Bad obj")
	if type(arg2) ~= "string" then
		var49 = false
		-- KONSTANTWARNING: GOTO [24] #19
	end
	-- KONSTANTERROR: [0] 1. Error Block 30 end (CF ANALYSIS FAILED)
	-- KONSTANTERROR: [23] 18. Error Block 33 start (CF ANALYSIS FAILED)
	var49 = true
	assert(var49, "Bad attributeName")
	if type(arg3) ~= "string" then
		var49 = false
		-- KONSTANTWARNING: GOTO [39] #30
	end
	-- KONSTANTERROR: [23] 18. Error Block 33 end (CF ANALYSIS FAILED)
end
local var2_result1_upvr_2 = any_load_result1("RxAttributeUtils")
local var2_result1_upvr = any_load_result1("Rx")
function module_upvr.observeTranslation(arg1, arg2, arg3, arg4) -- Line 270
	--[[ Upvalues[3]:
		[1]: var2_result1_upvr_2 (readonly)
		[2]: var2_result1_upvr (readonly)
		[3]: module_upvr (readonly)
	]]
	local var52 = arg1
	assert(var52, "Bad translator")
	if typeof(arg2) ~= "Instance" then
		var52 = false
	else
		var52 = true
	end
	assert(var52, "Bad obj")
	if type(arg3) ~= "string" then
		var52 = false
	else
		var52 = true
	end
	assert(var52, "Bad attributeName")
	var52 = var2_result1_upvr_2
	var52 = arg2
	return var52.observeAttribute(var52, arg3, nil):Pipe({var2_result1_upvr.switchMap(function(arg1_2) -- Line 277
		--[[ Upvalues[4]:
			[1]: module_upvr (copied, readonly)
			[2]: arg1 (readonly)
			[3]: arg4 (readonly)
			[4]: var2_result1_upvr (copied, readonly)
		]]
		if type(arg1_2) == "string" then
			local any_fromJSON_result1 = module_upvr.fromJSON(arg1_2)
			if any_fromJSON_result1 then
				return module_upvr.observeFormatByKeyRecursive(arg1, any_fromJSON_result1.translationKey, any_fromJSON_result1.translationArgs, arg4)
			end
			return var2_result1_upvr.of(nil)
		end
		return var2_result1_upvr.of(nil)
	end)})
end
return module_upvr