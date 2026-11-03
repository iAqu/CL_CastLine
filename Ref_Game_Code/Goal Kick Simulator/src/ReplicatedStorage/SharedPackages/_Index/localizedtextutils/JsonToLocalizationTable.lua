-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:24:52
-- Luau version 6, Types version 3
-- Time taken: 0.004927 seconds

local module_upvr = {}
local function recurseAdd_upvr(arg1, arg2, arg3, arg4, arg5) -- Line 24, Named "recurseAdd"
	--[[ Upvalues[1]:
		[1]: recurseAdd_upvr (readonly)
	]]
	if arg3 ~= "" then
	end
	for i, v in pairs(arg4) do
		local var9 = arg3..'.'..i
		if type(v) == "table" then
			recurseAdd_upvr(arg1, arg2, var9, v, arg5)
		elseif type(v) == "string" then
			local var10 = ""
			if arg2 == "en" then
				var10 = v
			end
			arg1:SetEntryValue(var9, var10, arg5..'.'..var9, arg2, v)
		else
			error("Bad type for value in '"..var9.."'.")
		end
	end
end
function module_upvr.localeFromName(arg1) -- Line 57
	if arg1:sub(-5) == ".json" then
		return arg1:sub(1, #arg1 - 5)
	end
	return arg1
end
local LocalizationService_upvr = game:GetService("LocalizationService")
local RunService_upvr = game:GetService("RunService")
function module_upvr.getOrCreateLocalizationTable() -- Line 71
	--[[ Upvalues[2]:
		[1]: LocalizationService_upvr (readonly)
		[2]: RunService_upvr (readonly)
	]]
	local GeneratedJSONTable = LocalizationService_upvr:FindFirstChild("GeneratedJSONTable")
	if not GeneratedJSONTable then
		GeneratedJSONTable = Instance.new("LocalizationTable")
		GeneratedJSONTable.Name = "GeneratedJSONTable"
		if RunService_upvr:IsRunning() then
			GeneratedJSONTable.Parent = LocalizationService_upvr
		end
	end
	return GeneratedJSONTable
end
function module_upvr.loadFolder(arg1, arg2) -- Line 92
	--[[ Upvalues[2]:
		[1]: module_upvr (readonly)
		[2]: recurseAdd_upvr (readonly)
	]]
	local var19
	if type(arg1) ~= "string" then
		var19 = false
	else
		var19 = true
	end
	assert(var19, "Bad tableName")
	var19 = module_upvr
	var19 = pairs(arg2:GetDescendants())
	for _, v_2 in pairs(arg2:GetDescendants()) do
		if v_2:IsA("StringValue") then
			module_upvr.addJsonToTable(var19.getOrCreateLocalizationTable(), module_upvr.localeFromName(v_2.Name), v_2.Value, arg1)
		elseif v_2:IsA("ModuleScript") then
			-- KONSTANTERROR: Expression was reused, decompilation is incorrect
			recurseAdd_upvr(var19.getOrCreateLocalizationTable(), module_upvr.localeFromName(v_2.Name), "", require(v_2), arg1)
		end
	end
	-- KONSTANTERROR: Expression was reused, decompilation is incorrect
	return var19.getOrCreateLocalizationTable()
end
function module_upvr.toLocalizationTable(arg1, arg2, arg3) -- Line 117
	--[[ Upvalues[1]:
		[1]: module_upvr (readonly)
	]]
	local var24
	if type(arg1) ~= "string" then
		var24 = false
	else
		var24 = true
	end
	assert(var24, "Bad tableName")
	var24 = arg2
	if typeof(var24) == "Instance" then
		var24 = module_upvr
		var24 = arg1
		return var24.loadFolder(var24, arg2)
	end
	var24 = arg2
	if type(var24) == "string" then
		var24 = arg3
		if type(var24) == "table" then
			var24 = module_upvr
			var24 = arg1
			return var24.loadTable(var24, arg2, arg3)
		end
	end
	var24 = "Bad args"
	error(var24)
end
function module_upvr.loadTable(arg1, arg2, arg3) -- Line 140
	--[[ Upvalues[2]:
		[1]: module_upvr (readonly)
		[2]: recurseAdd_upvr (readonly)
	]]
	local var25
	if type(arg1) ~= "string" then
		var25 = false
	else
		var25 = true
	end
	assert(var25, "Bad tableName")
	var25 = module_upvr
	local any_getOrCreateLocalizationTable_result1 = var25.getOrCreateLocalizationTable()
	var25 = recurseAdd_upvr
	var25(any_getOrCreateLocalizationTable_result1, arg2, "", arg3, arg1)
	return any_getOrCreateLocalizationTable_result1
end
local HttpService_upvr = game:GetService("HttpService")
function module_upvr.addJsonToTable(arg1, arg2, arg3, arg4) -- Line 158
	--[[ Upvalues[2]:
		[1]: HttpService_upvr (readonly)
		[2]: recurseAdd_upvr (readonly)
	]]
	local var28
	if type(arg4) ~= "string" then
		var28 = false
	else
		var28 = true
	end
	assert(var28, "Bad tableName")
	var28 = recurseAdd_upvr
	var28(arg1, arg2, "", HttpService_upvr:JSONDecode(arg3), arg4)
end
return module_upvr