-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Bytecode (Base64):
-- CQMCBmlwYWlycwtmcm9tRW50cmllcwACCQEAAAAKAwABBQEEBwcJAQ3/AQAAAAAAAKQCAQAAAABAUgMAAJ8CAgRRAgMAEwcGABMIBgFqCAEHbgL8/wIAAICCAQIAAgMBBAAAAEAAEQIBGAAAAgAAAAABAAD/AAQSAAAAAAEAAAECAAOjAAAAwAAAAIIAAgABBgABAAEAARgAEAoBAAAAAAE=

-- https://lua.expert/
return function(p1) --[[ fromEntries | Line: 17 ]]
	local t = {}

	for i, v in ipairs(p1) do
		t[v[1]] = v[2]
	end

	return t
end