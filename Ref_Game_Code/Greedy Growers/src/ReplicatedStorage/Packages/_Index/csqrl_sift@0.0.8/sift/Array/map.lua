-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Bytecode (Base64):
-- CQMEBmlwYWlycwV0YWJsZQZpbnNlcnQDbWFwAAIMAgAAAAcEAAAFAgQFGP8CAAAAAAAApAMBAAAAAEBSBAAAnwMCBFEDDgBSCAEAUgkHAFIKBgBSCwAAnwgEAkcICAAAAAAAnjQCBQgAAABSCgIAUgsIAKQJBAAADCCAnwkDAW4D8f8CAACAggICAAUDAQQAAABAAwIDAwQADCCAABQEARgAAAIAAAAAAQAAAAACAAEAAAAAAAD8AAgVAAAAAAEAAAECAAOjAAAAwAAAAIIAAgABBgABAAEAARgAEw4BAAAAAAE=

-- https://lua.expert/
return function(p1, p2) --[[ map | Line: 20 ]]
	local t = {}

	for i, v in ipairs(p1) do
		local v1 = p2(v, i, p1)

		if v1 ~= nil then
			table.insert(t, v1)
		end
	end

	return t
end