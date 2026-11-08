-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Bytecode (Base64):
-- CQMFBHR5cGUGbnVtYmVyBXRhYmxlBmluc2VydANwb3AAAgoCAAAABwQAAAUCBIIZHAIAAP8DAAAAAAAAuygBA1IFAQCkBAEAAAAAQJ8EAgLwBAIAAgAAgGUAAQCMAQEAjAYBACYEAgGMBQEAqAQIAIcJAAaeNAMECQAAAFIIAwCkBwUAABAwgJ8HAwGLBPj/ggMCAAYDAQQAAABAAwIDAwMEBAAQMIAAFAUBGAABAAIAAAAAAAAAAAIAAAABAAAAAAAA/wQVAAAAAAEAAAECAAOjAAAAwAAAAIIAAgABBgABAAEAARgAEw0BAAAAAAE=

-- https://lua.expert/
return function(p1, p2) --[[ pop | Line: 20 ]]
	local t = {}

	if type(p2) ~= "number" then
		p2 = 1
	end

	for i = 1, #p1 - p2 do
		table.insert(t, p1[i])
	end

	return t
end