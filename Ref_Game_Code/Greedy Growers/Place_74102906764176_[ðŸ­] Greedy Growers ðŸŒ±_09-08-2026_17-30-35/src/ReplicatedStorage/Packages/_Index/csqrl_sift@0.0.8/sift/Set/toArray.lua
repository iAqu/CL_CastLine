-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Bytecode (Base64):
-- CQMEBXBhaXJzBXRhYmxlBmluc2VydAd0b0FycmF5AAIKAQAAAAYDAAAFAQQR/wEAAAAAAACkAgEAAAAAQFIDAACfAgIEFwIHAJ40AQUFAAAAUggBAFIJBQCkBwQAAAwggJ8HAwFuAvj/AgAAAIIBAgAFAwEEAAAAQAMCAwMEAAwggAARBAEYAAACAAAAAAEAAAAAAAD/AAQSAAAAAAEAAAECAAOjAAAAwAAAAIIAAgABBgABAAEAARgAEAoBAAAAAAE=

-- https://lua.expert/
return function(p1) --[[ toArray | Line: 17 ]]
	local t = {}

	for k, v in pairs(p1) do
		table.insert(t, k)
	end

	return t
end