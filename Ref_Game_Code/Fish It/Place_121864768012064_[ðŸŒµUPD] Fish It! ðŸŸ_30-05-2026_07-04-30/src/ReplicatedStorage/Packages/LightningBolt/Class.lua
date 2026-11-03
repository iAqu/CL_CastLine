-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local t = {
	__index = function(p1, p2) --[[ __index | Line: 28 ]]
		if rawget(p1, "__baseclass") then
			return p1.__baseclass[p2]
		else
			return nil
		end
	end,
	__call = function(p1, ...) --[[ __call | Line: 35 ]]
		return p1:new(...)
	end,
	__add = function(p1, p2) --[[ __add | Line: 39 ]]
		return p1:addparent(p2)
	end,
	__eq = function(p1, p2) --[[ __eq | Line: 43 ]]
		if not p2.__baseclass or p2.__baseclass ~= p1.__baseclass then
			return false
		end
		for k, v in pairs(p1) do
			if not p2[k] then
				return false
			end
		end
		for k, v in pairs(p2) do
			if not p1[k] then
				return false
			end
		end
		return true
	end,
	__lt = function(p1, p2) --[[ __lt | Line: 58 ]]
		if not p2.__baseclass then
			return false
		end
		if rawget(p2.__baseclass, "__isparenttable") then
			for k, v in pairs(p2.__baseclass) do
				if p1 == v or getmetatable(p1).__lt(p1, v) then
					return true
				end
			end
		elseif p1 == p2.__baseclass or getmetatable(p1).__t(p1, p2.__baseclass) then
			return true
		end
		return false
	end,
	__le = function(p1, p2) --[[ __le | Line: 70 ]]
		return if p1 < p2 then true else p1 == p2
	end
}
local t2 = {
	__index = function(p1, p2) --[[ __index | Line: 75 ]]
		for k, v in pairs(p1) do
			if k ~= "__isparenttable" and v[p2] then
				return v[p2]
			end
		end
		return nil
	end
}
class = setmetatable({
	__baseclass = {}
}, t)
local function new(p1, ...) --[[ new | Line: 86 ]]
	local t = {
		__baseclass = p1
	}
	setmetatable(t, (getmetatable(p1)))
	if t.init then
		t:init(...)
	end
	return t
end
class.new = new
local function convert(p1, p2) --[[ convert | Line: 96 ]]
	p2.__baseclass = p1
	setmetatable(p2, (getmetatable(p1)))
	return p2
end
class.convert = convert
local function addparent(p1, ...) --[[ addparent | Line: 102 | Upvalues: t2 (copy) ]]
	if not rawget(p1.__baseclass, "__isparenttable") then
		p1.__baseclass = setmetatable({
			__isparenttable = true,
			p1.__baseclass,
			...
		}, t2)
		return p1
	end
	for i, v in ipairs({ ... }) do
		table.insert(p1.__baseclass, v)
	end
	return p1
end
class.addparent = addparent
local function setmetamethod(p1, p2, p3) --[[ setmetamethod | Line: 114 ]]
	local t = {}
	for k, v in pairs((getmetatable(p1))) do
		t[k] = v
	end
	t[p2] = p3
	setmetatable(p1, t)
end
class.setmetamethod = setmetamethod
return class