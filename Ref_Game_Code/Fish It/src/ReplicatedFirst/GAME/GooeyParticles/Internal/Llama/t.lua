-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local t = {
	type = function(p1) --[[ type | Line: 5 ]]
		return function(p12) --[[ Line: 6 | Upvalues: p1 (copy) ]]
			local v1 = type(p12)
			if v1 == p1 then
				return true
			else
				return false, string.format("%s expected, got %s", p1, v1)
			end
		end
	end,
	typeof = function(p1) --[[ typeof | Line: 16 ]]
		return function(p12) --[[ Line: 17 | Upvalues: p1 (copy) ]]
			local v1 = typeof(p12)
			if v1 == p1 then
				return true
			else
				return false, string.format("%s expected, got %s", p1, v1)
			end
		end
	end,
	any = function(p1) --[[ any | Line: 34 ]]
		if p1 == nil then
			return false, "any expected, got nil"
		else
			return true
		end
	end
}
t.boolean = t.typeof("boolean")
t.thread = t.typeof("thread")
t.callback = t.typeof("function")
t["function"] = t.callback
t.none = t.typeof("nil")
t["nil"] = t.none
t.string = t.typeof("string")
t.table = t.typeof("table")
t.userdata = t.type("userdata")
function t.number(p1) --[[ number | Line: 116 ]]
	local v1 = typeof(p1)
	if v1 ~= "number" then
		return false, string.format("number expected, got %s", v1)
	end
	if p1 == p1 then
		return true
	else
		return false, "unexpected NaN value"
	end
end
function t.nan(p1) --[[ nan | Line: 136 ]]
	local v1 = typeof(p1)
	if v1 ~= "number" then
		return false, string.format("number expected, got %s", v1)
	end
	if p1 == p1 then
		return false, "unexpected non-NaN value"
	else
		return true
	end
end
t.Axes = t.typeof("Axes")
t.BrickColor = t.typeof("BrickColor")
t.CatalogSearchParams = t.typeof("CatalogSearchParams")
t.CFrame = t.typeof("CFrame")
t.Color3 = t.typeof("Color3")
t.ColorSequence = t.typeof("ColorSequence")
t.ColorSequenceKeypoint = t.typeof("ColorSequenceKeypoint")
t.DateTime = t.typeof("DateTime")
t.DockWidgetPluginGuiInfo = t.typeof("DockWidgetPluginGuiInfo")
t.Enum = t.typeof("Enum")
t.EnumItem = t.typeof("EnumItem")
t.Enums = t.typeof("Enums")
t.Faces = t.typeof("Faces")
t.Instance = t.typeof("Instance")
t.NumberRange = t.typeof("NumberRange")
t.NumberSequence = t.typeof("NumberSequence")
t.NumberSequenceKeypoint = t.typeof("NumberSequenceKeypoint")
t.PathWaypoint = t.typeof("PathWaypoint")
t.PhysicalProperties = t.typeof("PhysicalProperties")
t.Random = t.typeof("Random")
t.Ray = t.typeof("Ray")
t.RaycastParams = t.typeof("RaycastParams")
t.RaycastResult = t.typeof("RaycastResult")
t.RBXScriptConnection = t.typeof("RBXScriptConnection")
t.RBXScriptSignal = t.typeof("RBXScriptSignal")
t.Rect = t.typeof("Rect")
t.Region3 = t.typeof("Region3")
t.Region3int16 = t.typeof("Region3int16")
t.TweenInfo = t.typeof("TweenInfo")
t.UDim = t.typeof("UDim")
t.UDim2 = t.typeof("UDim2")
t.Vector2 = t.typeof("Vector2")
t.Vector2int16 = t.typeof("Vector2int16")
t.Vector3 = t.typeof("Vector3")
t.Vector3int16 = t.typeof("Vector3int16")
function t.literal(...) --[[ literal | Line: 473 | Upvalues: t (copy) ]]
	local v1 = select("#", ...)
	if v1 == 1 then
		local v2 = ...
		return function(p1) --[[ Line: 477 | Upvalues: v2 (copy) ]]
			if p1 == v2 then
				return true
			else
				return false, string.format("expected %s, got %s", tostring(v2), (tostring(p1)))
			end
		end
	end
	local t2 = {}
	for i = 1, v1 do
		t2[i] = t.literal((select(i, ...)))
	end
	return t.union(table.unpack(t2, 1, v1))
end
t.exactly = t.literal
function t.keyOf(p1) --[[ keyOf | Line: 508 | Upvalues: t (copy) ]]
	local count = 0
	local t2 = {}
	for k in pairs(p1) do
		count = count + 1
		t2[count] = k
	end
	return t.literal(table.unpack(t2, 1, count))
end
function t.valueOf(p1) --[[ valueOf | Line: 526 | Upvalues: t (copy) ]]
	local count = 0
	local t2 = {}
	for k, v in pairs(p1) do
		count = count + 1
		t2[count] = v
	end
	return t.literal(table.unpack(t2, 1, count))
end
function t.integer(p1) --[[ integer | Line: 544 | Upvalues: t (copy) ]]
	local v1, v2 = t.number(p1)
	if not v1 then
		return false, v2 or ""
	end
	if p1 % 1 == 0 then
		return true
	else
		return false, string.format("integer expected, got %s", p1)
	end
end
function t.numberMin(p1) --[[ numberMin | Line: 564 | Upvalues: t (copy) ]]
	return function(p12) --[[ Line: 565 | Upvalues: t (ref), p1 (copy) ]]
		local v1, v2 = t.number(p12)
		if not v1 then
			return false, v2 or ""
		end
		if p1 <= p12 then
			return true
		else
			return false, string.format("number >= %s expected, got %s", p1, p12)
		end
	end
end
function t.numberMax(p1) --[[ numberMax | Line: 586 | Upvalues: t (copy) ]]
	return function(p12) --[[ Line: 587 | Upvalues: t (ref), p1 (copy) ]]
		local v1, v2 = t.number(p12)
		if not v1 then
			return false, v2
		end
		if p12 <= p1 then
			return true
		else
			return false, string.format("number <= %s expected, got %s", p1, p12)
		end
	end
end
function t.numberMinExclusive(p1) --[[ numberMinExclusive | Line: 608 | Upvalues: t (copy) ]]
	return function(p12) --[[ Line: 609 | Upvalues: t (ref), p1 (copy) ]]
		local v1, v2 = t.number(p12)
		if not v1 then
			return false, v2 or ""
		end
		if p1 < p12 then
			return true
		else
			return false, string.format("number > %s expected, got %s", p1, p12)
		end
	end
end
function t.numberMaxExclusive(p1) --[[ numberMaxExclusive | Line: 630 | Upvalues: t (copy) ]]
	return function(p12) --[[ Line: 631 | Upvalues: t (ref), p1 (copy) ]]
		local v1, v2 = t.number(p12)
		if not v1 then
			return false, v2 or ""
		end
		if p12 < p1 then
			return true
		else
			return false, string.format("number < %s expected, got %s", p1, p12)
		end
	end
end
t.numberPositive = t.numberMinExclusive(0)
t.numberNegative = t.numberMaxExclusive(0)
function t.numberConstrained(p1, p2) --[[ numberConstrained | Line: 667 | Upvalues: t (copy) ]]
	assert(t.number(p1))
	assert(t.number(p2))
	local v1 = t.numberMin(p1)
	local v2 = t.numberMax(p2)
	return function(p1) --[[ Line: 673 | Upvalues: v1 (copy), v2 (copy) ]]
		local v12, v22 = v1(p1)
		if not v12 then
			return false, v22 or ""
		end
		local v3, v4 = v2(p1)
		if v3 then
			return true
		else
			return false, v4 or ""
		end
	end
end
function t.numberConstrainedExclusive(p1, p2) --[[ numberConstrainedExclusive | Line: 696 | Upvalues: t (copy) ]]
	assert(t.number(p1))
	assert(t.number(p2))
	local v1 = t.numberMinExclusive(p1)
	local v2 = t.numberMaxExclusive(p2)
	return function(p1) --[[ Line: 702 | Upvalues: v1 (copy), v2 (copy) ]]
		local v12, v22 = v1(p1)
		if not v12 then
			return false, v22 or ""
		end
		local v3, v4 = v2(p1)
		if v3 then
			return true
		else
			return false, v4 or ""
		end
	end
end
function t.match(p1) --[[ match | Line: 724 | Upvalues: t (copy) ]]
	local string = t.string
	assert(string(p1))
	return function(p12) --[[ Line: 726 | Upvalues: t (ref), p1 (copy) ]]
		local v1, v2 = t.string(p12)
		if not v1 then
			return false, v2
		end
		if string.match(p12, p1) == nil then
			return false, string.format("%q failed to match pattern %q", p12, p1)
		else
			return true
		end
	end
end
function t.optional(p1) --[[ optional | Line: 747 | Upvalues: t (copy) ]]
	assert(t.callback(p1))
	return function(p12) --[[ Line: 749 | Upvalues: p1 (copy) ]]
		if p12 == nil then
			return true
		end
		local v1, v2 = p1(p12)
		if v1 then
			return true
		else
			return false, string.format("(optional) %s", v2 or "")
		end
	end
end
function t.tuple(...) --[[ tuple | Line: 770 ]]
	local t = { ... }
	return function(...) --[[ Line: 772 | Upvalues: t (copy) ]]
		local t2 = { ... }
		for i, v in ipairs(t) do
			local v1, v2 = v(t2[i])
			if v1 == false then
				return false, string.format("Bad tuple index #%s:\n\t%s", i, v2 or "")
			end
		end
		return true
	end
end
function t.keys(p1) --[[ keys | Line: 792 | Upvalues: t (copy) ]]
	local callback = t.callback
	assert(callback(p1))
	return function(p12) --[[ Line: 794 | Upvalues: t (ref), p1 (copy) ]]
		local v1, v2 = t.table(p12)
		if v1 == false then
			return false, v2 or ""
		end
		for k in pairs(p12) do
			local v3, v4 = p1(k)
			if v3 == false then
				return false, string.format("bad key %s:\n\t%s", tostring(k), v4 or "")
			end
		end
		return true
	end
end
function t.values(p1) --[[ values | Line: 818 | Upvalues: t (copy) ]]
	local callback = t.callback
	assert(callback(p1))
	return function(p12) --[[ Line: 820 | Upvalues: t (ref), p1 (copy) ]]
		local v1, v2 = t.table(p12)
		if v1 == false then
			return false, v2 or ""
		end
		for k, v in pairs(p12) do
			local v3, v4 = p1(v)
			if v3 == false then
				return false, string.format("bad value for key %s:\n\t%s", tostring(k), v4 or "")
			end
		end
		return true
	end
end
function t.map(p1, p2) --[[ map | Line: 845 | Upvalues: t (copy) ]]
	assert(t.callback(p1))
	assert(t.callback(p2))
	local v1 = t.keys(p1)
	local v2 = t.values(p2)
	return function(p1) --[[ Line: 851 | Upvalues: v1 (copy), v2 (copy) ]]
		local v12, v22 = v1(p1)
		if not v12 then
			return false, v22 or ""
		end
		local v3, v4 = v2(p1)
		if v3 then
			return true
		else
			return false, v4 or ""
		end
	end
end
function t.set(p1) --[[ set | Line: 873 | Upvalues: t (copy) ]]
	return t.map(p1, t.literal(true))
end
local v1 = t.keys(t.integer)
function t.array(p1) --[[ array | Line: 886 | Upvalues: t (copy), v1 (copy) ]]
	assert(t.callback(p1))
	local v12 = t.values(p1)
	return function(p1) --[[ Line: 890 | Upvalues: v1 (ref), v12 (copy) ]]
		local v13, v2 = v1(p1)
		if v13 == false then
			return false, string.format("[array] %s", v2 or "")
		end
		local count = 0
		for i in ipairs(p1) do
			count = count + 1
		end
		for k in pairs(p1) do
			if k < 1 or count < k then
				return false, string.format("[array] key %s must be sequential", (tostring(k)))
			end
		end
		local v3, v4 = v12(p1)
		if v3 then
			return true
		else
			return false, string.format("[array] %s", v4 or "")
		end
	end
end
function t.strictArray(...) --[[ strictArray | Line: 926 | Upvalues: t (copy), v1 (copy) ]]
	local t2 = { ... }
	assert(t.array(t.callback)(t2))
	return function(p1) --[[ Line: 930 | Upvalues: v1 (ref), t2 (copy) ]]
		local v12, v2 = v1(p1)
		if v12 == false then
			return false, string.format("[strictArray] %s", v2 or "")
		end
		if #t2 < #p1 then
			return false, string.format("[strictArray] Array size exceeds limit of %d", #t2)
		end
		for k, v in pairs(t2) do
			local v3, v4 = v(p1[k])
			if not v3 then
				return false, string.format("[strictArray] Array index #%d - %s", k, v4)
			end
		end
		return true
	end
end
local v2 = t.array(t.callback)
function t.union(...) --[[ union | Line: 962 | Upvalues: v2 (copy) ]]
	local t = { ... }
	assert(v2(t))
	return function(p1) --[[ Line: 966 | Upvalues: t (copy) ]]
		for i, v in ipairs(t) do
			if v(p1) then
				return true
			end
		end
		return false, "bad type for union"
	end
end
t.some = t.union
function t.intersection(...) --[[ intersection | Line: 989 | Upvalues: v2 (copy) ]]
	local t = { ... }
	assert(v2(t))
	return function(p1) --[[ Line: 993 | Upvalues: t (copy) ]]
		for i, v in ipairs(t) do
			local v1, v2 = v(p1)
			if not v1 then
				return false, v2 or ""
			end
		end
		return true
	end
end
t.every = t.intersection
local v3 = t.map(t.any, t.callback)
function t.interface(p1) --[[ interface | Line: 1020 | Upvalues: v3 (copy), t (copy) ]]
	assert(v3(p1))
	return function(p12) --[[ Line: 1022 | Upvalues: t (ref), p1 (copy) ]]
		local v1, v2 = t.table(p12)
		if v1 == false then
			return false, v2 or ""
		end
		for k, v in pairs(p1) do
			local v3, v4 = v(p12[k])
			if v3 == false then
				return false, string.format("[interface] bad value for %s:\n\t%s", tostring(k), v4 or "")
			end
		end
		return true
	end
end
function t.strictInterface(p1) --[[ strictInterface | Line: 1046 | Upvalues: v3 (copy), t (copy) ]]
	assert(v3(p1))
	return function(p12) --[[ Line: 1048 | Upvalues: t (ref), p1 (copy) ]]
		local v1, v2 = t.table(p12)
		if v1 == false then
			return false, v2 or ""
		end
		for k, v in pairs(p1) do
			local v3, v4 = v(p12[k])
			if v3 == false then
				return false, string.format("[interface] bad value for %s:\n\t%s", tostring(k), v4 or "")
			end
		end
		for k in pairs(p12) do
			if not p1[k] then
				return false, string.format("[interface] unexpected field %q", (tostring(k)))
			end
		end
		return true
	end
end
function t.instanceOf(p1, p2) --[[ instanceOf | Line: 1079 | Upvalues: t (copy) ]]
	local string = t.string
	assert(string(p1))
	local v1 = if p2 == nil then nil else t.children(p2)
	return function(p12) --[[ Line: 1087 | Upvalues: t (ref), p1 (copy), v1 (ref) ]]
		local v12, v2 = t.Instance(p12)
		if not v12 then
			return false, v2 or ""
		end
		if p12.ClassName ~= p1 then
			return false, string.format("%s expected, got %s", p1, p12.ClassName)
		end
		if not v1 then
			return true
		end
		local v3, v4 = v1(p12)
		if v3 then
			return true
		else
			return false, v4
		end
	end
end
t.instance = t.instanceOf
function t.instanceIsA(p1, p2) --[[ instanceIsA | Line: 1117 | Upvalues: t (copy) ]]
	local string = t.string
	assert(string(p1))
	local v1 = if p2 == nil then nil else t.children(p2)
	return function(p12) --[[ Line: 1125 | Upvalues: t (ref), p1 (copy), v1 (ref) ]]
		local v12, v2 = t.Instance(p12)
		if not v12 then
			return false, v2 or ""
		end
		if not p12:IsA(p1) then
			return false, string.format("%s expected, got %s", p1, p12.ClassName)
		end
		if not v1 then
			return true
		end
		local v3, v4 = v1(p12)
		if v3 then
			return true
		else
			return false, v4
		end
	end
end
function t.enum(p1) --[[ enum | Line: 1153 | Upvalues: t (copy) ]]
	local v1 = t.Enum
	assert(v1(p1))
	return function(p12) --[[ Line: 1155 | Upvalues: t (ref), p1 (copy) ]]
		local v1, v2 = t.EnumItem(p12)
		if not v1 then
			return false, v2
		end
		if p12.EnumType == p1 then
			return true
		else
			return false, string.format("enum of %s expected, got enum of %s", tostring(p1), (tostring(p12.EnumType)))
		end
	end
end
local v4 = t.tuple(t.callback, t.callback)
function t.wrap(p1, p2) --[[ wrap | Line: 1180 | Upvalues: v4 (copy) ]]
	assert(v4(p1, p2))
	return function(...) --[[ Line: 1182 | Upvalues: p2 (copy), p1 (copy) ]]
		assert(p2(...))
		return p1(...)
	end
end
function t.strict(p1) --[[ strict | Line: 1196 ]]
	return function(...) --[[ Line: 1197 | Upvalues: p1 (copy) ]]
		assert(p1(...))
	end
end
local v5 = t.map(t.string, t.callback)
function t.children(p1) --[[ children | Line: 1216 | Upvalues: v5 (copy), t (copy) ]]
	assert(v5(p1))
	return function(p12) --[[ Line: 1219 | Upvalues: t (ref), p1 (copy) ]]
		local v1, v2 = t.Instance(p12)
		if not v1 then
			return false, v2 or ""
		end
		local t2 = {}
		for i, v in ipairs(p12:GetChildren()) do
			local v3 = v.Name
			if p1[v3] then
				if t2[v3] then
					return false, string.format("Cannot process multiple children with the same name %q", v3)
				end
				t2[v3] = v
			end
		end
		for k, v in pairs(p1) do
			local v4, v5 = v(t2[k])
			if not v4 then
				return false, string.format("[%s.%s] %s", p12:GetFullName(), k, v5 or "")
			end
		end
		return true
	end
end
return t