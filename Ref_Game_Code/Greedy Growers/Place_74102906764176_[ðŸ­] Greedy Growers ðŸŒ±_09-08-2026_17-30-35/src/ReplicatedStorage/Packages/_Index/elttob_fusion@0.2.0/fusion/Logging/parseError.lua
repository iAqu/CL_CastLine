-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Bytecode (Base64):
-- CQMPBHR5cGUFRXJyb3IDcmF3B21lc3NhZ2UFdHJhY2ULXi4rOiVkKzolcyoABGdzdWIFZGVidWcJdHJhY2ViYWNrCnBhcnNlRXJyb3IGc2NyaXB0BlBhcmVudAdyZXF1aXJlBVR5cGVzAAIGAQAAAAYDAAAFAQMS4gEFADAAAWACAAAAbwQGAG8FBwC8AgDMCAAAAJ8CBAIwAgGYAwAAAKQCCwAAKJCAxgMAAIwEAgCfAgMCMAIBTQQAAACCAQIADAMBAwIDAwMEAwUIBAABAAAAAv////8D/////wT/////AwYDBwMIAwkDCgQAKJCAAA0LARgAAgABAAAAAAAAAQAAAAAAAAAOAAAAAAMAAAECAA6jAAAApAABAAAAAEBNAAAkAgAAAE0AACQCAAAApAEEAAAAMEBNAgDvBQAAAJ8BAgLAAgYAggICAAcDDAQAAABAAw0DDgQAADBAAw8GAAEAAQABGAAJAAAAAAABAAAAAAIJAQAAAAABpXH57OWHSz0rse/ZUef3CtVp7piXtZPt

-- https://lua.expert/
require(script.Parent.Parent.Types)

return function(p1) --[[ parseError | Line: 13 ]]
	return {
		type = "Error",
		raw = p1,
		message = p1:gsub("^.+:%d+:%s*", ""),
		trace = debug.traceback(nil, 2)
	}
end