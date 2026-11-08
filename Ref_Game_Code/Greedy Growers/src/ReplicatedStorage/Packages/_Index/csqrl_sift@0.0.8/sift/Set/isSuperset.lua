-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Bytecode (Base64):
-- CQMFCmlzU3VwZXJzZXQHcmVxdWlyZQZzY3JpcHQGUGFyZW50CGlzU3Vic2V0AAIFAgEAAAcEAAAFAgQEBfsCAABSAwEAUgQAAJ8CAwCCAgAAAAAVAQEYAAAAAAAWAAAAAAIAAAECAA2jAAAApAABAAAAAECkAQMAAAAgQE0BASQEAAAATQEBmQUAAACfAAICwAEGABIAAACCAQIABwMCBAAAAEADAwQAACBAAwQDBQYAAQABAAEYAAEAAAAAAAAAABMABAEAAAAAAQ==

-- https://lua.expert/
local isSubset = require(script.Parent.isSubset)

return function(p1, p2) --[[ isSuperset | Line: 21 | Upvalues: isSubset (copy) ]]
	return isSubset(p2, p1)
end