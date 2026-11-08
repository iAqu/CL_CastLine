-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Bytecode (Base64):
-- CQMHBXBhaXJzDHJlbW92ZVZhbHVlcwZzY3JpcHQGUGFyZW50B3JlcXVpcmUFQXJyYXkFdG9TZXQAAgkBAQEABgMAAAUBBBWjAQAA+wEAAP8CAAAAAAAA3QMAAMUCAwABAAAAnwECAv8CAAAAAAAApAMBAAAAAEBSBAAAnwMCBBcDAwCHCAEHKwgBAGoHAgZuA/z/AgAAAIICAgACAwEEAAAAQAAXAgEYAAEAAAAAAAABAAIAAAAAAQAB/gAGFwAAAAADAAABAgARowAAAKQAAQAAAABATQAAJAIAAABNAAAkAgAAAKQBBAAAADBATQIA/QUAAABNAgK+BgAAAJ8BAgLAAgcAEgABAIICAgAIAwMEAAAAQAMEAwUEAAAwQAMGAwcGAAEAAQABGAABAAAAAAACAAAAAAAAEwANAQAAAAABt25KbTEZjSVdWApZmV5XQcd2XRmFqiBs

-- https://lua.expert/
local toSet = require(script.Parent.Parent.Array.toSet)

return function(p1, ...) --[[ removeValues | Line: 23 | Upvalues: toSet (copy) ]]
	local v1 = toSet({ ... })
	local t = {}

	for k, v in pairs(p1) do
		if not v1[v] then
			t[k] = v
		end
	end

	return t
end