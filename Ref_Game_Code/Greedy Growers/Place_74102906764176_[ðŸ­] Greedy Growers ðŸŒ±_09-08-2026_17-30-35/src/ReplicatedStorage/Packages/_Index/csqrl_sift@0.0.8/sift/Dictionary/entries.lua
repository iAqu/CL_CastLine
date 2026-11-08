-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Bytecode (Base64):
-- CQMEBXBhaXJzBXRhYmxlBmluc2VydAdlbnRyaWVzAAIMAQAAAAYDAAAFAQQW/wEAAAAAAACkAgEAAAAAQFIDAACfAgIEFwIMAP8JAAACAAAAUgoFAFILBgDFCQoDAQAAAJ40AQQJAAAAUggBAKQHBAAADCCAnwcDAW4C8/8CAAAAggECAAUDAQQAAABAAwIDAwQADCCAABEEARgAAAIAAAAAAQAAAAAAAAAAAAAA/wAEEgAAAAABAAABAgADowAAAMAAAACCAAIAAQYAAQABAAEYABAKAQAAAAAB

-- https://lua.expert/
return function(p1) --[[ entries | Line: 17 ]]
	local t = {}

	for k, v in pairs(p1) do
		table.insert(t, { k, v })
	end

	return t
end