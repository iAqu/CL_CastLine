-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Bytecode (Base64):
-- CQMFBHR5cGUGbnVtYmVyBXRhYmxlBmluc2VydAVzaGlmdAACCgIAAAAHBAAABQIEghocAgAA/wMAAAAAAAC7KAEDUgUBAKQEAQAAAABAnwQCAvAEAwACAACAlQEBA2UAAQCMAQIAUgYBAFIEAgCMBQEAqAQIAIcJAAaeNAMECQAAAFIIAwCkBwYAABRAgJ8HAwGLBPj/ggMCAAcDAQQAAABAAwICAAAAAAAA8D8DAwMEBAAUQIAAFAUBGAABAAIAAAAAAAAAAAACAAAAAQAAAAAAAP8EFQAAAAABAAABAgADowAAAMAAAACCAAIAAQYAAQABAAEYABMNAQAAAAAB

-- https://lua.expert/
return function(p1, p2) --[[ shift | Line: 20 ]]
	local t = {}

	for i = if type(p2) == "number" then p2 + 1 else 2, #p1 do
		table.insert(t, p1[i])
	end

	return t
end