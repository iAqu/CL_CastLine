-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:19:31
-- Luau version 6, Types version 3
-- Time taken: 0.005442 seconds

local module_2_upvr = {
	Escape = function(arg1) -- Line 174, Named "Escape"
		return arg1:gsub("([%.%$%^%(%)%[%]%+%-%*%?%%])", "%%%1")
	end;
	Trim = function(arg1) -- Line 180, Named "Trim"
		return arg1:match("^%s*(.-)%s*$")
	end;
	TrimStart = function(arg1) -- Line 185, Named "TrimStart"
		return arg1:match("^%s*(.+)")
	end;
	TrimEnd = function(arg1) -- Line 190, Named "TrimEnd"
		return arg1:match("(.-)%s*$")
	end;
	RemoveExcessWhitespace = function(arg1) -- Line 195, Named "RemoveExcessWhitespace"
		return arg1:gsub("%s+", ' ')
	end;
	RemoveWhitespace = function(arg1) -- Line 200, Named "RemoveWhitespace"
		return arg1:gsub("%s+", "")
	end;
}
function module_2_upvr.EndsWith(arg1, arg2) -- Line 205
	--[[ Upvalues[1]:
		[1]: module_2_upvr (readonly)
	]]
	local var2
	if arg1:match(module_2_upvr.Escape(arg2)..'$') == nil then
		var2 = false
	else
		var2 = true
	end
	return var2
end
function module_2_upvr.StartsWith(arg1, arg2) -- Line 210
	--[[ Upvalues[1]:
		[1]: module_2_upvr (readonly)
	]]
	local var3
	if arg1:match('^'..module_2_upvr.Escape(arg2)) == nil then
		var3 = false
	else
		var3 = true
	end
	return var3
end
function module_2_upvr.Contains(arg1, arg2) -- Line 215
	local var4
	if arg1:find(arg2) == nil then
		var4 = false
	else
		var4 = true
	end
	return var4
end
function module_2_upvr.StringBuilder() -- Line 220
	local module = {}
	local module_3_upvr = {}
	function module.Append(arg1, arg2) -- Line 223
		--[[ Upvalues[1]:
			[1]: module_3_upvr (readonly)
		]]
		module_3_upvr[#module_3_upvr + 1] = arg2
	end
	function module.Prepend(arg1, arg2) -- Line 226
		--[[ Upvalues[1]:
			[1]: module_3_upvr (readonly)
		]]
		table.insert(module_3_upvr, 1, arg2)
	end
	function module.ToString(arg1) -- Line 229
		--[[ Upvalues[1]:
			[1]: module_3_upvr (readonly)
		]]
		return table.concat(module_3_upvr, "")
	end
	setmetatable(module, {
		__tostring = module.ToString;
	})
	return module
end
function module_2_upvr.ToCharArray(arg1) -- Line 237
	local len = #arg1
	local table_create_result1 = table.create(len)
	for i = 1, len do
		table_create_result1[i] = arg1:sub(i, i)
	end
	return table_create_result1
end
function module_2_upvr.ToByteArray(arg1) -- Line 247
	local len_2 = #arg1
	if len_2 == 0 then
		return {}
	end
	if len_2 <= 7997 then
		return table.pack(arg1:byte(1, #arg1))
	end
	for i_2 = 1, len_2 do
		table.create(len_2)[i_2] = arg1:sub(i_2, i_2):byte()
		local var16
	end
	return var16
end
function module_2_upvr.ByteArrayToString(arg1) -- Line 261
	-- KONSTANTWARNING: Variable analysis failed. Output will have some incorrect variable assignments
	local len_3 = #arg1
	if len_3 <= 7997 then
		return string.char(table.unpack(arg1))
	end
	local ceiled = math.ceil(len_3 / 7997)
	for i_3 = 1, ceiled do
		table.create(ceiled)[i_3] = string.char(table.unpack(arg1, (i_3 - 1) * 7997 + 1, math.min(len_3, (i_3 - 1) * 7997 + 7997)))
		local var24
	end
	return table.concat(var24, "")
end
function module_2_upvr.EqualsIgnoreCase(arg1, arg2) -- Line 276
	local var25
	if arg1:lower() ~= arg2:lower() then
		var25 = false
	else
		var25 = true
	end
	return var25
end
function module_2_upvr.ToCamelCase(arg1) -- Line 281
	local any_gsub_result1 = arg1:gsub("[%-_]+([^%-_])", function(arg1_2) -- Line 282
		return arg1_2:upper()
	end)
	return any_gsub_result1:sub(1, 1):lower()..any_gsub_result1:sub(2)
end
function module_2_upvr.ToPascalCase(arg1) -- Line 287
	--[[ Upvalues[1]:
		[1]: module_2_upvr (readonly)
	]]
	local any_ToCamelCase_result1 = module_2_upvr.ToCamelCase(arg1)
	return any_ToCamelCase_result1:sub(1, 1):upper()..any_ToCamelCase_result1:sub(2)
end
function module_2_upvr.ToSnakeCase(arg1, arg2) -- Line 293
	arg1 = arg1:gsub("[%-_]+", '_'):gsub("([^%u%-_])(%u)", function(arg1_3, arg2_2) -- Line 294
		return arg1_3..'_'..arg2_2:lower()
	end)
	local var30 = arg1
	if arg2 then
		var30 = var30:upper()
		return var30
	end
	return var30:lower()
end
function module_2_upvr.ToKebabCase(arg1, arg2) -- Line 300
	arg1 = arg1:gsub("[%-_]+", '-'):gsub("([^%u%-_])(%u)", function(arg1_4, arg2_3) -- Line 301
		return arg1_4..'-'..arg2_3:lower()
	end)
	local var32 = arg1
	if arg2 then
		var32 = var32:upper()
		return var32
	end
	return var32:lower()
end
local any_len_result1_upvr = `abcdefghijklmnopqrstuvwxzyABCDEFGHIJKLMNOPQRSTUVWXZY0123456789-_*?/=()[]{}&%+^'"\`!#$,. \xA3@<>:;~`
function module_2_upvr.Random(arg1) -- Line 308
	--[[ Upvalues[1]:
		[1]: any_len_result1_upvr (readonly)
	]]
	local var36 = ""
	for _ = 1, arg1 do
		local randint = math.random(0, any_len_result1_upvr)
		var36 = var36..string.sub("abcdefghijklmnopqrstuvwxzyABCDEFGHIJKLMNOPQRSTUVWXZY0123456789-_*?/=()[]{}&%+^'\"`!#$,. \xA3@<>:;~", randint, randint)
	end
	return var36
end
setmetatable(module_2_upvr, {
	__index = string;
})
return module_2_upvr