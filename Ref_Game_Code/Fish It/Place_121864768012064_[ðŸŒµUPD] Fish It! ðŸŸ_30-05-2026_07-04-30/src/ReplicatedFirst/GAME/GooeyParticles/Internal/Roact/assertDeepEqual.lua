-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local function v1(p1, p2) --[[ deepEqual | Line: 9 | Upvalues: v1 (copy) ]]
	if typeof(p1) ~= typeof(p2) then
		return false, ("{1} is of type %s, but {2} is of type %s"):format(typeof(p1), (typeof(p2)))
	end
	if typeof(p1) == "table" then
		local t = {}
		for k, v in pairs(p1) do
			t[k] = true
			local v12, v2 = v1(v, p2[k])
			if not v12 then
				return false, v2:gsub("{1}", ("{1}[%s]"):format((tostring(k)))):gsub("{2}", ("{2}[%s]"):format((tostring(k))))
			end
		end
		for k, v in pairs(p2) do
			if not t[k] then
				local v3, v4 = v1(v, p1[k])
				if not v3 then
					return false, v4:gsub("{1}", ("{1}[%s]"):format((tostring(k)))):gsub("{2}", ("{2}[%s]"):format((tostring(k))))
				end
			end
		end
		return true
	elseif p1 == p2 then
		return true
	else
		return false, "{1} ~= {2}"
	end
end
return function(p1, p2) --[[ assertDeepEqual | Line: 56 | Upvalues: v1 (copy) ]]
	local v12, v2 = v1(p1, p2)
	if v12 then
		return
	end
	error(("Values were not deep-equal.\n%s"):format((v2:gsub("{1}", "first"):gsub("{2}", "second"))), 2)
end