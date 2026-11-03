-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Disk = require(ReplicatedStorage:WaitForChild("AceworksUtils"):WaitForChild("Disk"))
local Array = Disk.Array
local Map = Disk.Map
local function verifyInstanceClass(p1, p2) --[[ verifyInstanceClass | Line: 8 ]]
	if #p2 == 0 then
		return true
	end
	for v1, v2 in p2 do
		if p1:IsA(v2) then
			return true
		end
	end
	return false
end
local t = {
	quote = "\'",
	separator = "or"
}
local function formatList(p1, p2) --[[ formatList | Line: 25 | Upvalues: Map (copy), t (copy), Array (copy) ]]
	local v1 = if type(p1) == "string" then { p1 } else p1
	local v2 = #v1
	local v3 = Map.merge(t, p2)
	local quote = v3.quote
	if v2 == 0 then
		return ""
	end
	if v2 == 1 then
		return quote .. v1[1] .. quote
	else
		return ("%*%*%* %* %*%*%*"):format(quote, table.concat(Array.range(v1, -1), quote .. ", " .. quote), quote, v3.separator, quote, v1[v2], quote)
	end
end
local function formatInvalidTagClassMessage(p1, p2, p3) --[[ formatInvalidTagClassMessage | Line: 44 | Upvalues: formatList (copy) ]]
	return ("unable to define \'%*\' tag on a \'%*\' instance (%*),"):format(p1, p2.ClassName, (p2:GetFullName())) .. (" it must inherit %*"):format((formatList(p3)))
end
local function getType(p1) --[[ getType | Line: 53 ]]
	local v1 = type(p1)
	if v1 == "userdata" or v1 == "vector" then
		return typeof(p1)
	else
		return v1
	end
end
local function getDisplayType(p1) --[[ getDisplayType | Line: 63 ]]
	local v1 = type(p1)
	local v2 = if v1 == "userdata" or v1 == "vector" then typeof(p1) else v1
	if v2 == "Instance" then
		return p1.ClassName
	else
		return v2
	end
end
local function extractTypes(p1) --[[ extractTypes | Line: 73 ]]
	local v1 = string.split(p1, "|")
	local v2 = v1[#v1]
	if string.sub(v2, -1, -1) == "?" then
		v1[#v1] = string.sub(v2, 1, -2)
		table.insert(v1, "nil")
	end
	return v1
end
local function validateType(p1, p2) --[[ validateType | Line: 85 | Upvalues: Array (copy) ]]
	local v1 = type(p1)
	local v2 = if v1 == "userdata" or v1 == "vector" then typeof(p1) else v1
	if v2 == "Instance" then
		local v3 = string.split(p2, "|")
		local v4 = v3[#v3]
		if string.sub(v4, -1, -1) == "?" then
			v3[#v3] = string.sub(v4, 1, -2)
			table.insert(v3, "nil")
		end
		return Array.any(v3, function(p12) --[[ Line: 90 | Upvalues: v2 (copy), p1 (copy) ]]
			return if v2 == p12 or p1.ClassName == p12 then true else p1:IsA(p12)
		end)
	else
		local v5 = string.split(p2, "|")
		local v6 = v5[#v5]
		if string.sub(v6, -1, -1) == "?" then
			v5[#v5] = string.sub(v6, 1, -2)
			table.insert(v5, "nil")
		end
		return Array.any(v5, function(p1) --[[ Line: 95 | Upvalues: v2 (copy) ]]
			return v2 == p1
		end)
	end
end
return {
	verifyInstanceClass = verifyInstanceClass,
	formatList = formatList,
	formatInvalidTagClassMessage = formatInvalidTagClassMessage,
	formatInvalidConfigurationMessage = function(p1, p2, p3, p4) --[[ formatInvalidConfigurationMessage | Line: 100 | Upvalues: formatList (copy) ]]
		return ("invalid %* configuration on \'%*\' for \'%*\' tag, %*"):format(formatList(p3), p2:GetFullName(), p1, p4)
	end,
	formatInvalidConfigurationMemberClass = function(p1, p2, p3, p4) --[[ formatInvalidConfigurationMemberClass | Line: 109 | Upvalues: formatList (copy) ]]
		local v1 = ("unexpected class \'%*\' (expected a %*)"):format(p2.ClassName, (formatList(p4)))
		return ("invalid %* configuration on \'%*\' for \'%*\' tag, %*"):format(formatList(p3), p2:GetFullName(), p1, v1)
	end,
	formatInvalidConfigurationMemberSubClass = function(p1, p2, p3, p4) --[[ formatInvalidConfigurationMemberSubClass | Line: 123 | Upvalues: formatList (copy) ]]
		local v1 = ("unexpected class \'%*\' (expected a sub-class of %*)"):format(p2.ClassName, (formatList(p4)))
		return ("invalid %* configuration on \'%*\' for \'%*\' tag, %*"):format(formatList(p3), p2:GetFullName(), p1, v1)
	end,
	extractTypes = extractTypes,
	getType = getType,
	getDisplayType = getDisplayType,
	validateType = validateType
}