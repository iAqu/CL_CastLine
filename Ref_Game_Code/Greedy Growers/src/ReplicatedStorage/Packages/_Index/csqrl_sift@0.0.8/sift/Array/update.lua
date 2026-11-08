-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Bytecode (Base64):
-- CQMLBHR5cGUIZnVuY3Rpb24EY2FsbARmdW5jCHJldHVybmVkBnVwZGF0ZQZzY3JpcHQGUGFyZW50B3JlcXVpcmUEVXRpbARjb3B5AAMEAgAAAAcEAAAFAgUCDLsoAANSAwAApAIBAAAAAECfAgIC8AIFAAIAAIBSAgAAUgMBAJ8CAgCCAgAAggABAAMDAQQAAABAAwIACgMBGAAAAAAAAAABAAAAAgsAAAAACgQCAAAJBgAABQQEAoWFLhwEAAD7BQAAUgYAAJ8FAgKMBgEAYAECAAYAAABDAQEEuygCA1IHAgCkBgEAAAAAQJ8GAgLwBgIAAgAAgGUABQD7BgEATQYGZgMAAABNAgbDBAAAAIcGBQFHBgcAAAAAAFIGAgCHBwUBUggBAJ8GAwJqBgUBggUCAFIHAQC7KAMDUgkDAKQIAQAAAABAnwgCAvAIBgACAACAUggDAFIJBwCfCAICUgYIAGUAAQDGBgAAagYFAYIFAgAFAwEEAAAAQAMCAwQDBQAsBgEYJwEAAAIAAAEDAAAAAAAAAAAAAAAAAgAAAQAAAAAAAs0AAAAAAAABAAAAAAAyAwsAAAAABQAAAQIAGqMAAACkAAEAAAAAQE0AACQCAAAATQAAJAIAAACkAQQAAAAwQE0CAJ4FAAAAnwECAqQCBAAAADBApAMBAAAAAEBNAwMkAgAAAE0DAwkGAAAAnwICAsADBwDABAgAEgACABIAAQCCBAIACQMHBAAAAEADCAMJBAAAMEADCgMLBgAGAQIAAQEAARgAAQAAAAAAAgAAAAABAAAAAAAAAAAFIgAAGAEAAAAAAux23RP80Gj2tHiAOn35HHacbspn3rK3Eg==

-- https://lua.expert/
local Util = require(script.Parent.Parent.Util)
local copy = require(script.Parent.copy)

local function call(p1, p2) --[[ call | Line: 10 ]]
	if type(p1) == "function" then
		return p1(p2)
	end
end

return function(p1, p2, p3, p4) --[[ update | Line: 44 | Upvalues: copy (copy), Util (copy) ]]
	local v1 = copy(p1)

	if p2 < 1 then
		p2 = p2 + #p1
	end

	if type(p3) ~= "function" then
		p3 = Util.func.returned
	end

	if v1[p2] ~= nil then
		v1[p2] = p3(v1[p2], p2)

		return v1
	end

	v1[p2] = if type(p4) == "function" then p4(p2) else nil

	return v1
end