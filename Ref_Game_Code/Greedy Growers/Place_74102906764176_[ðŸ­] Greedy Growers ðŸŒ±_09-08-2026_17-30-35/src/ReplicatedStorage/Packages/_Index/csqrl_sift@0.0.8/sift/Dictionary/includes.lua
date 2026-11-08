-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Bytecode (Base64):
-- CQMCBXBhaXJzCGluY2x1ZGVzAAIIAgAAAAcEAAAFAgQPDaQCAQAAAABAUgMAAJ8CAgQXAgQAmgYDAAEAAACpBwEAggcCAG4C+/8CAAAAqQIAAIICAgACAwEEAAAAQAATAgEYAAAAAAABAAEA/gAGABQAAAAAAQAAAQIAA6MAAADAAAAAggACAAEGAAEAAQABGAASCgEAAAAAAQ==

-- https://lua.expert/
return function(p1, p2) --[[ includes | Line: 19 ]]
	for k, v in pairs(p1) do
		if v == p2 then
			return true
		end
	end

	return false
end