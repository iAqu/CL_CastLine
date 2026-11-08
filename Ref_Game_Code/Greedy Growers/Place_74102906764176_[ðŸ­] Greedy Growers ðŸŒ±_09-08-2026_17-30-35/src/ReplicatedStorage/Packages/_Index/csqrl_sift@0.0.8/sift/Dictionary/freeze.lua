-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Bytecode (Base64):
-- CQMHBXRhYmxlBmZyZWV6ZQdyZXF1aXJlBnNjcmlwdAZQYXJlbnQFVHlwZXMEY29weQACBAEBAAAACPsBAABSAgAAnwECAqQCAgAABACAUgMBAJ8CAgGCAQIAAwMBAwIEAAQAgAAXAgEYAAAAAgAAAAIYAAAAAAMAAAECABijAAAApAABAAAAAECkAQMAAAAgQE0BASQEAAAATQEBJAQAAABNAQHvBQAAAJ8AAgKkAQEAAAAAQKQCAwAAACBATQICJAQAAABNAgIJBgAAAJ8BAgLAAgcAEgABAIICAgAIAwMEAAAAQAMEBAAAIEADBQMGAwcGAAEAAQABGAABAAAAAAAAAAAAAAEAAAAAAAAAABQACAEAAAAAAft96P689bZbWKPpiBpL95aLZf+KybmC/w==

-- https://lua.expert/
require(script.Parent.Parent.Types)

local copy = require(script.Parent.copy)

return function(p1) --[[ freeze | Line: 23 | Upvalues: copy (copy) ]]
	local v1 = copy(p1)

	table.freeze(v1)

	return v1
end