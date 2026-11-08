-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Bytecode (Base64):
-- CQMGBXRhYmxlBHNvcnQHcmVxdWlyZQZzY3JpcHQGUGFyZW50BGNvcHkAAgYCAQAABwQAAAUCBIUJ+wIAAFIDAACfAgICpAMCAAAEAIBSBAIAUgUBAJ8DAwGCAgIAAwMBAwIEAAQAgAAWAgEYAAAAAgAAAAACFwAAAAACAAABAgANowAAAKQAAQAAAABApAEDAAAAIEBNAQEkBAAAAE0BAQkFAAAAnwACAsABBgASAAAAggECAAcDAwQAAABAAwQEAAAgQAMFAwYGAAEAAQABGAABAAAAAAAAAAAUAAgBAAAAAAE=

-- https://lua.expert/
local copy = require(script.Parent.copy)

return function(p1, p2) --[[ sort | Line: 22 | Upvalues: copy (copy) ]]
	local v1 = copy(p1)

	table.sort(v1, p2)

	return v1
end