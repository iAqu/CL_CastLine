-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Bytecode (Base64):
-- CQMGBHR5cGUGbnVtYmVyBXRhYmxlBmluc2VydAZpcGFpcnMGc3BsaWNlAAINAwABAAgFAAAFAwSCgkmjAwAAHAMAAP8EAAAAAAAAuygBA1IGAQCkBQEAAAAAQJ8FAgLwBQIAAgAAgGUAAQCMAQEAuygCA1IGAgCkBQEAAAAAQJ8FAgLwBQIAAgAAgGUAAQBSAgMAjAUBAGABAgAFAAAAQwEBA4wFAQBgAgIABQAAAEMCAgOMBwEAeAUBA4wGAQCoBQgAhwoAB540BAQKAAAAUgkEAKQIBgAAFECAnwgDAYsF+P+kBQgAAABwQP8GAAAAAAAA3QgAAMUGCAABAAAAnwUCBFEFBwCeNAQFCQAAAFILBABSDAkApAoGAAAUQICfCgMBbgX4/wIAAICVBwIDUgUDAIwGAQCoBQgAhwoAB540BAQKAAAAUgkEAKQIBgAAFECAnwgDAYsF+P+CBAIACQMBBAAAAEADAgIAAAAAAADwPwMDAwQEABRAgAMFBAAAcEAAFgYBGAABAQACAAAAAAAAAAABAAAAAAAAAAACAAABAwAAAQMAAAABAAAAAAAA/wQAAAAAAAAAAAEAAAAAAAD/AAQAAAABAAAAAAAA/wQWAAAAAAEAAAECAAOjAAAAwAAAAIIAAgABBgABAAEAARgAFR4BAAAAAAGBOKLATdlSWzprum11twqw8SC1tLP8yME=

-- https://lua.expert/
return function(p1, p2, p3, ...) --[[ splice | Line: 22 ]]
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

	for i = 1, p2 - 1 do
		table.insert(t, p1[i])
	end

	for i, v in ipairs({ ... }) do
		table.insert(t, v)
	end

	for j = p3 + 1, v1 do
		table.insert(t, p1[j])
	end

	return t
end