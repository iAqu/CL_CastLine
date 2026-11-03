-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:25:53
-- Luau version 6, Types version 3
-- Time taken: 0.001635 seconds

local module_upvr = {
	encodeAsString = function(arg1) -- Line 20, Named "encodeAsString"
		local var2
		if typeof(arg1) ~= "EnumItem" then
			var2 = false
		else
			var2 = true
		end
		assert(var2, "Bad enumItem")
		return "Enum.%s.%s":format(tostring(arg1.EnumType), arg1.Name)
	end;
}
function module_upvr.isOfType(arg1, arg2) -- Line 38
	--[[ Upvalues[1]:
		[1]: module_upvr (readonly)
	]]
	local var3
	if typeof(arg1) ~= "Enum" then
		var3 = false
	else
		var3 = true
	end
	assert(var3, "Bad enum")
	var3 = arg2
	if typeof(var3) ~= "EnumItem" then
		var3 = "Bad enumItem. Expected enumItem to be %s, got %s '%s'":format(tostring(arg1), typeof(arg2), tostring(arg2))
		return false, var3
	end
	if arg2.EnumType == arg1 then
		return true
	end
	var3 = "Bad enumItem. Expected enumItem to be %s, got %s":format(tostring(arg1), module_upvr.encodeAsString(arg2))
	return false, var3
end
function module_upvr.isEncodedEnum(arg1) -- Line 58
	--[[ Upvalues[1]:
		[1]: module_upvr (readonly)
	]]
	local var4
	if module_upvr.decodeFromString(arg1) == nil then
		var4 = false
	else
		var4 = true
	end
	return var4
end
function module_upvr.decodeFromString(arg1) -- Line 68
	if type(arg1) ~= "string" then
		return nil
	end
	local string_match_result1_upvr, string_match_result2_upvr = string.match(arg1, "^Enum%.([^%.%s]+)%.([^%.%s]+)$")
	if string_match_result1_upvr and string_match_result2_upvr then
		local var7_upvw
		local pcall_result1, pcall_result2 = pcall(function() -- Line 76
			--[[ Upvalues[3]:
				[1]: var7_upvw (read and write)
				[2]: string_match_result1_upvr (readonly)
				[3]: string_match_result2_upvr (readonly)
			]]
			var7_upvw = Enum[string_match_result1_upvr][string_match_result2_upvr]
		end)
		if not pcall_result1 then
			warn(pcall_result2, "[EnumUtils.decodeFromString] - Failed to decode %q into an enum value due to %q":format(arg1, tostring(pcall_result2)))
			return nil
		end
		return var7_upvw
	end
	return nil
end
return module_upvr