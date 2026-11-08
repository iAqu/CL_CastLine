-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Bytecode (Base64):
-- CQMCBmlwYWlycwVldmVyeQACCwIAAAAHBAAABQIEBRGkAgEAAAAAQFIDAACfAgIEUQIIAFIHAQBSCAYAUgkFAFIKAACfBwQCKwcCAKkHAACCBwIAbgL3/wIAAICpAgEAggICAAIDAQQAAABAABgCARgAAAAAAAEAAAAAAAEA/gAGABwAAAAAAQAAAQIAA6MAAADAAAAAggACAAEGAAEAAQABGAAXDQEAAAAAAQ==

-- https://lua.expert/
return function(p1, p2) --[[ every | Line: 24 ]]
	for i, v in ipairs(p1) do
		if not p2(v, i, p1) then
			return false
		end
	end

	return true
end