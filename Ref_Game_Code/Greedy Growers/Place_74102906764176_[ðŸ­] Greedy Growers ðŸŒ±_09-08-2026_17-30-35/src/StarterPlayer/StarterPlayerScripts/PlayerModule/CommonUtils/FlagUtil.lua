-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Bytecode (Base64):
-- CQMEDFVzZXJTZXR0aW5ncxRJc1VzZXJGZWF0dXJlRW5hYmxlZAVwY2FsbAtnZXRVc2VyRmxhZwADAwABAAAACKQAAQAAAABAnwABAvsCAAC8AAA6AgAAAJ8AAwCCAAAAAwMBBAAAAEADAgAMAAEYAAAAAAAAAAANAAAAAAQBAAAAAAekAQEAAAAAQNkCAAASAAAAnwECA+cDAQKCAwIAAgMDBAAAAEABAAsEARgAAAAAAAMADAAAAAACAAABAgAHowAAAP8AAAAAAAAAwAEAADABABIBAAAAggACAAIGAQMEAQEBAAEYAAgAAgAABwEAAAAAAg==

-- https://lua.expert/
return {
	getUserFlag = function(p1) --[[ getUserFlag | Line: 11 ]]
		local ok, result = pcall(function() --[[ Line: 12 | Upvalues: p1 (copy) ]]
			return UserSettings():IsUserFeatureEnabled(p1)
		end)

		return ok and result
	end
}