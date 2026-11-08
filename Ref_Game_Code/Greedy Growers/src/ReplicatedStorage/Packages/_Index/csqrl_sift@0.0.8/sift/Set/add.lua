-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Bytecode (Base64):
-- CQMDBXBhaXJzBmlwYWlycwNhZGQAAggBAAEABgMAAAUBBBqjAQAA/wEAAAAAAACkAgEAAAAAQFIDAACfAgIEFwICAKkHAQBqBwEFbgL9/wIAAACkAgMAAAAgQP8DAAAAAAAA3QUAAMUDBQABAAAAnwICBFECAgCpBwEAagcBBm4C/f8CAACAggECAAQDAQQAAABAAwIEAAAgQAASAwEYAAEAAgAAAAABAP8ABAAAAAAAAAAAAQD/AAQSAAAAAAEAAAECAAOjAAAAwAAAAIIAAgABBgABAAEAARgAEQ4BAAAAAAE=

-- https://lua.expert/
return function(p1, ...) --[[ add | Line: 18 ]]
	local t = {}

	for k, v in pairs(p1) do
		t[k] = true
	end

	for i, v in ipairs({ ... }) do
		t[v] = true
	end

	return t
end