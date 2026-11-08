-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Bytecode (Base64):
-- CQMCBXBhaXJzCGlzU3Vic2V0AAIIAgAAAAcEAAAFAgQEDqQCAQAAAABAUgMAAJ8CAgQXAgUAhwcBBfEHAwAGAAAAqQcAAIIHAgBuAvr/AgAAAKkCAQCCAgIAAgMBBAAAAEAAEwIBGAAAAAAAAQAAAQD+AAYAFAAAAAABAAABAgADowAAAMAAAACCAAIAAQYAAQABAAEYABIKAQAAAAAB

-- https://lua.expert/
return function(p1, p2) --[[ isSubset | Line: 19 ]]
	for k, v in pairs(p1) do
		if p2[k] ~= v then
			return false
		end
	end

	return true
end