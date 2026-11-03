-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local None = require(script.Parent.Parent:WaitForChild("None"))
return function(...) --[[ merge | Line: 3 | Upvalues: None (copy) ]]
	local v1 = select("#", ...)
	local v2 = nil
	local v3 = nil
	for i = 1, v1 do
		local v4 = select(i, ...)
		if v4 ~= nil then
			v2 = v4
			v3 = i
			break
		end
	end
	if v2 == nil then
		error("attempt to merge only nil values")
	end
	if v3 == v1 then
		return v2
	end
	local v5 = nil
	for j = v3 + 1, v1 do
		local v6 = select(j, ...)
		if v6 ~= nil then
			if v5 == nil then
				local v7 = table.clone(v2)
				setmetatable(v7, nil)
				v5 = v7
			end
			local v8 = getmetatable(v6)
			if v8 ~= nil and type(v8.__call) == "function" then
				for k, v in pairs(v6) do
					if v == None then
						v5[k] = nil
						continue
					end
					v5[k] = v
				end
				continue
			end
			for v9, v10 in v6 do
				if v10 == None then
					v5[v9] = nil
					continue
				end
				v5[v9] = v10
			end
		end
	end
	return v5 or v2
end