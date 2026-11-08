-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Bytecode (Base64):
-- CQMDBXRhYmxlBmluc2VydAdyZXZlcnNlAAIIAQAAAAYDAAAFAQQP/wEAAAAAAAAcBAAAjAIBAIwD//+oAggAhwcABJ40AQQHAAAAUgYBAKQFAgAABACAnwUDAYsC+P+CAQIAAwMBAwIEAAQAgAARAwEYAAACAAAAAQAAAAAAAP8EEgAAAAABAAABAgADowAAAMAAAACCAAIAAQYAAQABAAEYABAKAQAAAAAB

-- https://lua.expert/
return function(p1) --[[ reverse | Line: 17 ]]
	local t = {}

	for i = #p1, 1, -1 do
		table.insert(t, p1[i])
	end

	return t
end