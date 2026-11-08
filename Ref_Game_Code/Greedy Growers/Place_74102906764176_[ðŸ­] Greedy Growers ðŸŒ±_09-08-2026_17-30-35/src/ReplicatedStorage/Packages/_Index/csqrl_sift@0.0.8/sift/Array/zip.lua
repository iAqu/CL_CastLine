-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Bytecode (Base64):
-- CQMMBG1hdGgDbWluASMGc2VsZWN0BmlwYWlycwV0YWJsZQZpbnNlcnQDemlwB3JlcXVpcmUGc2NyaXB0BlBhcmVudAZyZWR1Y2UAAwUCAAAAAAgcBAEAnhMABAQAAABSAwAApAICAAAEAICfAgMCggICAAMDAQMCBAAEAIAAHgABGAAAAAAAAAAAHwAAAAAQAAEBAAA0owAAAG8BAAC7OQEDpAACAAAAEEDdAgAAnwAAAv8BAAAAAAAA3QIAAMUBAgABAAAA/wIAAAAAAAANAAIAAwAAgIICAgD7AwAAUgQBAMAFBAATBwEAHAYHAJ8DBAKMBgEAUgQDAIwFAQCoBBgA/wcAAAAAAACkCAYAAABQQFIJAQCfCAIEUQgHAIcPDAaeNAcEDwAAAFIOBwCkDQkAACBwgJ8NAwFuCPj/AgAAgJ40AgUHAAAAUgkCAFIKBwCkCAkAACBwgJ8IAwGLBOj/ggICAAoDAwMEBAAAEEACAAAAAAAAAAAGAAMFBAAAUEADBgMHBAAgcIABABQIARgAAQAAAAAAAQAAAAACAAIAAQMAAAIA/gQAAAABAAIAAAAAAQAAAAAAAP8ABAAAAAAAAPkKFAAAAAACAAABAgANowAAAKQAAQAAAABApAEDAAAAIEBNAQEkBAAAAE0BAf4FAAAAnwACAsABBgASAAAAggECAAcDCQQAAABAAwoEAAAgQAMLAwwGAQEBAQABGAABAAAAAAAAAAASABsBAAAAAAKOzvHSH0hltaIJoJdspRuo/tbmprwKm9M=

-- https://lua.expert/
local reduce = require(script.Parent.reduce)

return function(...) --[[ zip | Line: 20 | Upvalues: reduce (copy) ]]
	local list = { ... }
	local t = {}

	if select("#", ...) == 0 then
		return t
	end

	for i = 1, reduce(list, function(p1, p2) --[[ Line: 30 ]]
		return math.min(p1, #p2)
	end, #list[1]) do
		local t2 = {}

		for i2, v in ipairs(list) do
			table.insert(t2, v[i])
		end

		table.insert(t, t2)
	end

	return t
end