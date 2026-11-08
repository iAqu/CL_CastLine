-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Bytecode (Base64):
-- CQMFCXJlbW92ZUtleQdyZXF1aXJlBnNjcmlwdAZQYXJlbnQEY29weQACBAIBAAAHBAAABQIEDwb7AgAAUgMAAJ8CAgLGAwAAagMCAYICAgAAABUBARgAAAACAAIWAAAAAAIAAAECAA2jAAAApAABAAAAAECkAQMAAAAgQE0BASQEAAAATQEBCQUAAACfAAICwAEGABIAAACCAQIABwMCBAAAAEADAwQAACBAAwQDBQYAAQABAAEYAAEAAAAAAAAAABMACAEAAAAAAQ==

-- https://lua.expert/
local copy = require(script.Parent.copy)

return function(p1, p2) --[[ removeKey | Line: 21 | Upvalues: copy (copy) ]]
	local v1 = copy(p1)

	v1[p2] = nil

	return v1
end