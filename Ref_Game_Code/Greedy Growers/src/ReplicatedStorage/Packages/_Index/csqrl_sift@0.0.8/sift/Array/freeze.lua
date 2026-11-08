-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Bytecode (Base64):
-- CQMGBXRhYmxlBmZyZWV6ZQdyZXF1aXJlBnNjcmlwdAZQYXJlbnQEY29weQACBAEBAAAGAwAABQEECPsBAABSAgAAnwECAqQCAgAABACAUgMBAJ8CAgGCAQIAAwMBAwIEAAQAgAAWAgEYAAAAAgAAAAIXAAAAAAIAAAECAA2jAAAApAABAAAAAECkAQMAAAAgQE0BASQEAAAATQEBCQUAAACfAAICwAEGABIAAACCAQIABwMDBAAAAEADBAQAACBAAwUDBgYAAQABAAEYAAEAAAAAAAAAABQACAEAAAAAAQ==

-- https://lua.expert/
local copy = require(script.Parent.copy)

return function(p1) --[[ freeze | Line: 22 | Upvalues: copy (copy) ]]
	local v1 = copy(p1)

	table.freeze(v1)

	return v1
end