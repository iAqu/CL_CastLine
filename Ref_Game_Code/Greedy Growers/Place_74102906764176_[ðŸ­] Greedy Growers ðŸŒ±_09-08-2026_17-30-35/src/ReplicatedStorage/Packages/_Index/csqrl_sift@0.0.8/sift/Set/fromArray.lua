-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Bytecode (Base64):
-- CQMEBXRhYmxlBmNyZWF0ZQZpcGFpcnMJZnJvbUFycmF5AAIIAQAAAAYDAAAFAQQOpAECAAAEAIAcAgAAnwECAqQCBAAAADBAUgMAAJ8CAgRRAgIAqQcBAGoHAQZuAv3/AgAAgIIBAgAFAwEDAgQABACAAwMEAAAwQAAUBAEYAAAAAAIAAAAAAQD/AAQVAAAAAAEAAAECAAOjAAAAwAAAAIIAAgABBgABAAEAARgAEwoBAAAAAAE=

-- https://lua.expert/
return function(p1) --[[ fromArray | Line: 20 ]]
	local v1 = table.create(#p1)

	for i, v in ipairs(p1) do
		v1[v] = true
	end

	return v1
end