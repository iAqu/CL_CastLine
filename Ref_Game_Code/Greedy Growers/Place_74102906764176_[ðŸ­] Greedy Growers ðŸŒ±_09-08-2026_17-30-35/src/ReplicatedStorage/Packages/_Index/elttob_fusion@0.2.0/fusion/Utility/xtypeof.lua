-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Bytecode (Base64):
-- CQMFBnR5cGVvZgV0YWJsZQR0eXBlBnN0cmluZwd4dHlwZW9mAAIEAQAAAAATuywAA1ICAACkAQEAAAAAQJ8BAgLwAQwAAgAAgE0DAHEDAAAAuywDAqQCAQAAAABAnwICAvACBAAEAACATQIAcQMAAACCAgIAggECAAUDAQQAAABAAwIDAwMEAAkFARgAAAAAAAIAAAAAAAAAAAABAAACCgAAAAABAAABAgADowAAAMAAAACCAAIAAQYAAQABAAEYAAgKAQAAAAAB

-- https://lua.expert/
return function(p1) --[[ xtypeof | Line: 9 ]]
	local v1 = typeof(p1)

	if v1 ~= "table" then
		return v1
	end

	if typeof(p1.type) == "string" then
		return p1.type
	end

	return v1
end