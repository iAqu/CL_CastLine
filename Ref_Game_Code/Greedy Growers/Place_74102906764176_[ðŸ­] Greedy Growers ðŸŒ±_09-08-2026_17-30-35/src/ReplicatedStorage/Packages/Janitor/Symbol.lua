-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Bytecode (Base64):
-- CQMECl9fdG9zdHJpbmcIbmV3cHJveHkMZ2V0bWV0YXRhYmxlBlN5bWJvbAADAQABAAAAAvsAAACCAAIAAAAFAQEYAAAGAAAAAAQBAAAABgMAAAUBAw6kAQEAAAAAQKkCAQCfAQICuzwBA1IDAQCkAgMAAAAgQJ8CAgLZAwAAEgAAADADAgYEAAAAggECAAUDAgQAAABAAwMEAAAgQAMBAQACBAEYAAAAAAEAAAAAAQAAAAQDAAAAAAEAAAECAAOjAAAAwAAAAIIAAgABBgEBAQEAARgAAQoBAAAAAAI=

-- https://lua.expert/
return function(p1) --[[ Symbol | Line: 2 ]]
	local v1 = newproxy(true)

	getmetatable(v1).__tostring = function() --[[ __tostring | Line: 5 | Upvalues: p1 (copy) ]]
		return p1
	end

	return v1
end