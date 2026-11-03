-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local t = {
	append = function(p1, p2) --[[ append | Line: 19 ]]
		for v1, v2 in p2 do
			p1[#p1 + 1] = v2
		end
		return p1
	end,
	merge = function(p1, p2) --[[ merge | Line: 34 ]]
		local v1 = table.clone(p1)
		for v2, v3 in p2 do
			v1[v2] = v3
		end
		return v1
	end,
	reverse = function(p1) --[[ reverse | Line: 48 ]]
		local t = {}
		for i = #p1, 1, -1 do
			table.insert(t, p1[i])
		end
		return t
	end,
	values = function(p1) --[[ values | Line: 62 ]]
		local t = {}
		for v1, v2 in p1 do
			table.insert(t, v2)
		end
		return t
	end,
	keys = function(p1) --[[ keys | Line: 76 ]]
		local t = {}
		for v1, v2 in p1 do
			table.insert(t, v1)
		end
		return t
	end,
	mergeLists = function(p1, p2) --[[ mergeLists | Line: 91 ]]
		local t = {}
		for v1, v2 in p1 do
			table.insert(t, v2)
		end
		for v3, v4 in p2 do
			table.insert(t, v4)
		end
		return t
	end,
	swapKeyValue = function(p1) --[[ swapKeyValue | Line: 108 ]]
		local t = {}
		for v1, v2 in p1 do
			t[v2] = v1
		end
		return t
	end,
	toList = function(p1) --[[ toList | Line: 122 ]]
		local t = {}
		for v1, v2 in p1 do
			table.insert(t, v2)
		end
		return t
	end,
	count = function(p1) --[[ count | Line: 137 ]]
		local count = 0
		for v1, v2 in p1 do
			count = count + 1
		end
		return count
	end,
	copy = table.clone
}
function t.deepCopy(p1, p2) --[[ deepCopy | Line: 162 | Upvalues: t (copy) ]]
	local v1 = if p2 then p2 else {}
	if v1[p1] then
		return v1[p1]
	elseif type(p1) == "table" then
		local t2 = {}
		v1[p1] = t2
		for v2, v3 in p1 do
			t2[t.deepCopy(v2, v1)] = t.deepCopy(v3, v1)
		end
		return setmetatable(t2, (t.deepCopy(getmetatable(p1), v1)))
	else
		return p1
	end
end
function t.deepOverwrite(p1, p2) --[[ deepOverwrite | Line: 186 | Upvalues: t (copy) ]]
	for v1, v2 in p2 do
		if type(p1[v1]) == "table" and type(v2) == "table" then
			p1[v1] = t.deepOverwrite(p1[v1], v2)
		end
		p1[v1] = v2
	end
	return p1
end
function t.getIndex(p1, p2) --[[ getIndex | Line: 204 ]]
	assert(if p2 == nil then false else true, "Needle cannot be nil")
	for v2, v3 in p1 do
		if p2 == v3 then
			return v2
		end
	end
	return nil
end
function t.stringify(p1, p2, p3) --[[ stringify | Line: 224 | Upvalues: t (copy) ]]
	local v1 = if p3 then p3 else tostring(p1)
	local v2 = p2 or 0
	for v3, v4 in p1 do
		local v5 = "\n" .. string.rep("  ", v2) .. tostring(v3) .. ": "
		if type(v4) == "table" then
			v1 = t.stringify(v4, v2 + 1, v1 .. v5)
		end
		v1 = v1 .. v5 .. tostring(v4)
	end
	return v1
end
function t.contains(p1, p2) --[[ contains | Line: 246 ]]
	for v1, v2 in p1 do
		if v2 == p2 then
			return true
		end
	end
	return false
end
function t.overwrite(p1, p2) --[[ overwrite | Line: 263 ]]
	for v1, v2 in p2 do
		p1[v1] = v2
	end
	return p1
end
function t.deepEquivalent(p1, p2) --[[ deepEquivalent | Line: 278 | Upvalues: t (copy) ]]
	if p1 == p2 then
		return true
	elseif type(p1) == type(p2) and type(p1) == "table" then
		for v1, v2 in p1 do
			if not t.deepEquivalent(v2, p2[v1]) then
				return false
			end
		end
		for v3, v4 in p2 do
			if not t.deepEquivalent(v4, p1[v3]) then
				return false
			end
		end
		return true
	else
		return false
	end
end
function t.take(p1, p2) --[[ take | Line: 316 ]]
	local v1 = math.min(#p1, p2)
	local v2 = table.create(v1)
	for i = 1, v1 do
		v2[i] = p1[i]
	end
	return v2
end
local function errorOnIndex(p1, p2) --[[ errorOnIndex | Line: 327 ]]
	error(string.format("Bad index %q", (tostring(p2))), 2)
end
local t2 = {
	__index = errorOnIndex,
	__newindex = errorOnIndex
}
function t.readonly(p1) --[[ readonly | Line: 343 | Upvalues: t2 (copy) ]]
	return table.freeze((setmetatable(p1, t2)))
end
function t.errorOnNilIndex(p1) --[[ errorOnNilIndex | Line: 354 | Upvalues: t2 (copy) ]]
	return setmetatable(p1, t2)
end
function t.deepReadonly(p1) --[[ deepReadonly | Line: 364 | Upvalues: t (copy) ]]
	for v1, v2 in p1 do
		if type(v2) == "table" then
			t.deepReadonly(v2)
		end
	end
	return t.readonly(p1)
end
function t.reduce(p1, p2, p3) --[[ reduce | Line: 382 ]]
	local v1 = p3
	for v2, v3 in p1 do
		v1 = p2(v1, v3)
	end
	return v1
end
return t