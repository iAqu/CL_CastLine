-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local v1 = newproxy()
local v2 = newproxy()
local function CreateEnumItem(p1, p2, p3) --[[ CreateEnumItem | Line: 23 ]]
	local t = {
		Name = p1,
		Value = p2,
		EnumType = p3
	}
	table.freeze(t)
	return t
end
local t = {}
t.__index = t
function t.new(p1, p2) --[[ new | Line: 57 | Upvalues: v1 (copy), v2 (copy), t (copy) ]]
	assert(if type(p1) == "string" then true else false, "Name string required")
	assert(if type(p2) == "table" then true else false, "Enums table required")
	local t2 = {
		[v1] = {},
		[v2] = p1
	}
	for i, v in ipairs(p2) do
		assert(if type(v) == "string" then true else false, "Enum name must be a string")
		local t3 = {
			Name = v,
			Value = i,
			EnumType = t2
		}
		table.freeze(t3)
		t2[v] = t3
		table.insert(t2[v1], t3)
	end
	return table.freeze((setmetatable(t2, t)))
end
function t.BelongsTo(p1, p2) --[[ BelongsTo | Line: 77 ]]
	return if type(p2) == "table" then p2.EnumType == p1 else false
end
function t.GetEnumItems(p1) --[[ GetEnumItems | Line: 86 | Upvalues: v1 (copy) ]]
	return p1[v1]
end
function t.GetName(p1) --[[ GetName | Line: 95 | Upvalues: v2 (copy) ]]
	return p1[v2]
end
return t