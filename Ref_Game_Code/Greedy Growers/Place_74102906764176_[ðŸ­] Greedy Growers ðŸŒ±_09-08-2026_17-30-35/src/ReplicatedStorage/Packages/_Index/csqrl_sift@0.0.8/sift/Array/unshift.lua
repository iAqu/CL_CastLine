-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Bytecode (Base64):
-- CQMEBmlwYWlycwV0YWJsZQZpbnNlcnQHdW5zaGlmdAACCgEAAQAGAwAABQEEFaMBAAD/AQAAAAAAAN0CAADFAQIAAQAAAKQCAQAAAABAUgMAAJ8CAgRRAgcAnjQBBQYAAABSCAEAUgkGAKQHBAAADCCAnwcDAW4C+P8CAACAggECAAUDAQQAAABAAwIDAwQADCCAABYEARgAAQAAAAACAAAAAAEAAAAAAAD/AAQWAAAAAAEAAAECAAOjAAAAwAAAAIIAAgABBgABAAEAARgAFQoBAAAAAAE=

-- https://lua.expert/
return function(p1, ...) --[[ unshift | Line: 22 ]]
	local t = { ... }

	for i, v in ipairs(p1) do
		table.insert(t, v)
	end

	return t
end