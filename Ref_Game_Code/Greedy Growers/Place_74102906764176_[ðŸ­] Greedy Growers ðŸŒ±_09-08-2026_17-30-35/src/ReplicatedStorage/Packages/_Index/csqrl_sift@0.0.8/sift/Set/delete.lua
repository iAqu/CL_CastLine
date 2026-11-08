-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Bytecode (Base64):
-- CQMDBXBhaXJzBmlwYWlycwZkZWxldGUAAggBAAEABgMAAAUBBBqjAQAA/wEAAAAAAACkAgEAAAAAQFIDAACfAgIEFwICAKkHAQBqBwEFbgL9/wIAAACkAgMAAAAgQP8DAAAAAAAA3QUAAMUDBQABAAAAnwICBFECAgDGBwAAagcBBm4C/f8CAACAggECAAQDAQQAAABAAwIEAAAgQAAUAwEYAAEAAgAAAAABAP8ABAAAAAAAAAAAAQD/AAQUAAAAAAEAAAECAAOjAAAAwAAAAIIAAgABBgABAAEAARgAEw4BAAAAAAE=

-- https://lua.expert/
return function(p1, ...) --[[ delete | Line: 20 ]]
	local t = {}

	for k, v in pairs(p1) do
		t[k] = true
	end

	for i, v in ipairs({ ... }) do
		t[v] = nil
	end

	return t
end