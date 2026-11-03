-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
return function(p1) --[[ isArray | Line: 1 ]]
	if type(p1) ~= "table" then
		return false
	end
	if next(p1) == nil then
		return true
	end
	local v1 = #p1
	if v1 == 0 then
		return false
	end
	local count = 0
	for v2 in p1 do
		count = count + 1
		if type(v2) ~= "number" or v2 ~= count then
			return false
		end
	end
	return v1 == count
end