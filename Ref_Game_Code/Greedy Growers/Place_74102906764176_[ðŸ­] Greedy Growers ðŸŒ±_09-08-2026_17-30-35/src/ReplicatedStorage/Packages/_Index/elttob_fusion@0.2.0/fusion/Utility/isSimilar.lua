-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Bytecode (Base64):
-- CQMDBnR5cGVvZgV0YWJsZQlpc1NpbWlsYXIAAgQCAAAAAA67LAADUgMAAKQCAQAAAABAnwICAvACAwACAACAqQIAAIICAgDxAAIAAQAAAKkCAAGpAgEAggICAAMDAQQAAABAAwIABwMBGAAAAAAAAAABAAIAAAAACgAAAAABAAABAgADowAAAMAAAACCAAIAAQYAAQABAAEYAAYKAQAAAAAB

-- https://lua.expert/
return function(p1, p2) --[[ isSimilar | Line: 7 ]]
	if typeof(p1) == "table" then
		return false
	end

	return p1 == p2
end