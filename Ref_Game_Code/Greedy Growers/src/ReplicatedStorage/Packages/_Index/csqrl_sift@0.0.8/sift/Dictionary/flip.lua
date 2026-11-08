-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Bytecode (Base64):
-- CQMCBXBhaXJzBGZsaXAAAgcBAAAABgMAAAUBBAv/AQAAAAAAAKQCAQAAAABAUgMAAJ8CAgQXAgEAagUBBm4C/v8CAAAAggECAAIDAQQAAABAABECARgAAAIAAAAAAf8ABBIAAAAAAQAAAQIAA6MAAADAAAAAggACAAEGAAEAAQABGAAQCgEAAAAAAQ==

-- https://lua.expert/
return function(p1) --[[ flip | Line: 17 ]]
	local t = {}

	for k, v in pairs(p1) do
		t[v] = k
	end

	return t
end