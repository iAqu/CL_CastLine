-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Bytecode (Base64):
-- CQMHBnNlbGVjdAEjDGVxdWFsT2JqZWN0cwdyZXF1aXJlBnNjcmlwdAZQYXJlbnQFVHlwZXMAAgcAAAEAAB6jAAAAjAEBALs5AQOkAAEAAAAAQN0CAACfAAACjAMCAG8FAgC7OQUDpAQBAAAAAEDdBgAAnwQAAlIBBACMAgEAqAELALs5AwSkBAEAAAAAQFIFAwDdBgAAnwQAAvEAAwAEAAAAqQQAAIIEAgCLAfX/qQEBAIIBAgADAwEEAAAAQAMCABQDARgAAQAAAAAAAgAAAAAAAAAAAAEAAAAAAAAAAQD+BgAUAAAAAAIAAAECAA6jAAAApAABAAAAAECkAQMAAAAgQE0BASQEAAAATQEBJAQAAABNAQHvBQAAAJ8AAgLAAQYAggECAAcDBAQAAABAAwUEAAAgQAMGAwcGAAEAAQABGAABAAAAAAAAAAAAABIMAQAAAAAB7UID7CcqRLECBtYyzwWFFZ1aFJjfhmnt

-- https://lua.expert/
require(script.Parent.Parent.Types)

return function(...) --[[ equalObjects | Line: 20 ]]
	local v1 = select(1, ...)

	for i = 2, select("#", ...) do
		if v1 ~= select(i, ...) then
			return false
		end
	end

	return true
end