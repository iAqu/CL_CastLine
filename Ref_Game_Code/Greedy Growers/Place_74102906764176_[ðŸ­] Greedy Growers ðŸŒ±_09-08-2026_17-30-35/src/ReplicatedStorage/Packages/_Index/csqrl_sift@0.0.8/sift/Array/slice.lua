-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Bytecode (Base64):
-- CQMFBHR5cGUGbnVtYmVyBXRhYmxlBmluc2VydAVzbGljZQACCwMAAAAIBQAABQMEgoIqHAMAAP8EAAAAAAAAuygBA1IGAQCkBQEAAAAAQJ8FAgLwBQIAAgAAgGUAAQCMAQEAuygCA1IGAgCkBQEAAAAAQJ8FAgLwBQIAAgAAgGUAAQBSAgMAjAUBAGABAgAFAAAAQwEBA4wFAQBgAgIABQAAAEMCAgNSBwEAUgUCAIwGAQCoBQgAhwoAB540BAQKAAAAUgkEAKQIBQAAEDCAnwgDAYsF+P+CBAIABgMBBAAAAEADAgMDAwQEABAwgAAVBQEYAAEAAgAAAAAAAAAAAQAAAAAAAAAAAgAAAQMAAAEDAAAAAQAAAAAAAP8EFgAAAAABAAABAgADowAAAMAAAACCAAIAAQYAAQABAAEYABQWAQAAAAABrJjOI8u0sPnDTOzqXVQtANyA2VeeXKQi

-- https://lua.expert/
return function(p1, p2, p3) --[[ slice | Line: 21 ]]
	local v1 = #p1
	local t = {}

	if type(p2) ~= "number" then
		p2 = 1
	end

	if type(p3) ~= "number" then
		p3 = v1
	end

	if p2 < 1 then
		p2 = p2 + v1
	end

	if p3 < 1 then
		p3 = p3 + v1
	end

	for i = p2, p3 do
		table.insert(t, p1[i])
	end

	return t
end