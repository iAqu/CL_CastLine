-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Bytecode (Base64):
-- CQMEBXBhaXJzBXRhYmxlBmluc2VydARrZXlzAAIKAQAAAAYDAAAFAQQR/wEAAAAAAACkAgEAAAAAQFIDAACfAgIEFwIHAJ40AQUFAAAAUggBAFIJBQCkBwQAAAwggJ8HAwFuAvj/AQAAAIIBAgAFAwEEAAAAQAMCAwMEAAwggAARBAEYAAACAAAAAAEAAAAAAAD/AAQSAAAAAAEAAAECAAOjAAAAwAAAAIIAAgABBgABAAEAARgAEAoBAAAAAAE=

-- https://lua.expert/
return function(p1) --[[ keys | Line: 17 ]]
	local t = {}

	for k in pairs(p1) do
		table.insert(t, k)
	end

	return t
end