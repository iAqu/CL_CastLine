-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local t = {}
t.__index = t
function t.new(p1) --[[ new | Line: 4 | Upvalues: t (copy) ]]
	return setmetatable({
		Reference = p1,
		_Free = {},
		_Used = {}
	}, t)
end
function t.Free(p1, p2, p3) --[[ Free | Line: 13 ]]
	if p2 and p1._Used[p2] then
		if p3 then
			p3(p2)
		end
		p1._Used[p2] = nil
		table.insert(p1._Free, p2)
	elseif p2 then
		p2:Destroy()
	end
end
function t.Get(p1, p2) --[[ Get | Line: 32 ]]
	local v1 = table.remove(p1._Free)
	if v1 then
		p1._Used[v1] = true
		return v1
	elseif p2 or p1.Reference then
		local v2 = p2 and p2:Clone() or p1.Reference:Clone()
		p1._Used[v2] = true
		return v2
	end
end
return t