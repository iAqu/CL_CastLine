-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Bytecode (Base64):
-- CQMEBnR5cGVvZgV0YWJsZQRuZXh0AmlzAAIFAQAAAAAXqQEAALssAANSAwAApAIBAAAAAECfAgIC8AIPAAIAAICpAQAAHAIAAIwDAABgAwoAAgAAAKQCBAAAADBAUgMAABwEAACfAgMCRwICAAAAAACpAQABqQEBAIIBAgAFAwEEAAAAQAMCAwMEAAAwQAAVBAEYAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAWAAAAAAEAAAECAAOjAAAAwAAAAIIAAgABBgABAAEAARgAFAQBAAAAAAE=

-- https://lua.expert/
return function(p1) --[[ is | Line: 21 ]]
	return if typeof(p1) == "table" and #p1 > 0 then next(p1, #p1) == nil else false
end