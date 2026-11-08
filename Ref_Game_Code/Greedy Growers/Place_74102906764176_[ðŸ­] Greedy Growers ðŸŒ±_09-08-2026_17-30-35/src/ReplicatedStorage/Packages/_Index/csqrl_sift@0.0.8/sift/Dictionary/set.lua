-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Bytecode (Base64):
-- CQMFA3NldAdyZXF1aXJlBnNjcmlwdAZQYXJlbnQEY29weQACBQMBAAAIBQAABQMEDw8F+wMAAFIEAACfAwICagIDAYIDAgAAABUBARgAAAACAhYAAAAAAgAAAQIADaMAAACkAAEAAAAAQKQBAwAAACBATQEBJAQAAABNAQEJBQAAAJ8AAgLAAQYAEgAAAIIBAgAHAwIEAAAAQAMDBAAAIEADBAMFBgABAAEAARgAAQAAAAAAAAAAEwAIAQAAAAAB

-- https://lua.expert/
local copy = require(script.Parent.copy)

return function(p1, p2, p3) --[[ set | Line: 21 | Upvalues: copy (copy) ]]
	local v1 = copy(p1)

	v1[p2] = p3

	return v1
end