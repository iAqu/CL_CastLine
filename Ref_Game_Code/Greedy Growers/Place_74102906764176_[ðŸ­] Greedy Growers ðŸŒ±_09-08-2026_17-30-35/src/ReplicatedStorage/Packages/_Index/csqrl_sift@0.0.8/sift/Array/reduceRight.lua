-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Bytecode (Base64):
-- CQMBC3JlZHVjZVJpZ2h0AAINAwAAAAgFAAAFAwQFDxNSAwIAHAQAAEcDAwAAAACAhwMABHgEBABSBwQAjAUBAIwG//+oBQgAUggBAFIJAwCHCgAHUgsHAFIMAACfCAUCUgMIAIsF+P+CAwIAAQIAAAAAAADwPwAcAQEYAAECAAEBAwAAAAEAAAAAAAD/BCEAAAAAAQAAAQIAA6MAAADAAAAAggACAAEGAAEAAQABGAAbFAEAAAAAAQ==

-- https://lua.expert/
return function(p1, p2, p3) --[[ reduceRight | Line: 28 ]]
	local count = #p1
	local v1

	if p3 == nil then
		v1 = p1[count]
		count = count - 1
	else
		v1 = p3
	end

	for i = count, 1, -1 do
		v1 = p2(v1, p1[i], i, p1)
	end

	return v1
end