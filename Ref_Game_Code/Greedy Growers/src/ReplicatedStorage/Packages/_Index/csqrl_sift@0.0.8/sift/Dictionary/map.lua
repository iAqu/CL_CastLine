-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Bytecode (Base64):
-- CQMCBXBhaXJzA21hcAACDAIAAAAHBAAABQIEBRH/AgAAAAAAAKQDAQAAAABAUgQAAJ8DAgQXAwcAUggBAFIJBwBSCgYAUgsAAJ8IBAPKCgkGaggCCm4D+P8CAAAAggICAAIDAQQAAABAABoCARgAAAIAAAAAAQAAAAABAP4ABR4AAAAAAQAAAQIAA6MAAADAAAAAggACAAEGAAEAAQABGAAZDgEAAAAAAQ==

-- https://lua.expert/
return function(p1, p2) --[[ map | Line: 26 ]]
	local t = {}

	for k, v in pairs(p1) do
		local v1, v2 = p2(v, k, p1)

		t[v2 or k] = v1
	end

	return t
end