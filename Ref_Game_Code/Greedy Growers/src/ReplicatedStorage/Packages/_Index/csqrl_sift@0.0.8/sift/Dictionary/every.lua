-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Bytecode (Base64):
-- CQMCBXBhaXJzBWV2ZXJ5AAILAgAAAAcEAAAFAgQFEaQCAQAAAABAUgMAAJ8CAgQXAggAUgcBAFIIBgBSCQUAUgoAAJ8HBAIrBwIAqQcAAIIHAgBuAvf/AgAAAKkCAQCCAgIAAgMBBAAAAEAAGAIBGAAAAAAAAQAAAAAAAQD+AAYAHAAAAAABAAABAgADowAAAMAAAACCAAIAAQYAAQABAAEYABcNAQAAAAAB

-- https://lua.expert/
return function(p1, p2) --[[ every | Line: 24 ]]
	for k, v in pairs(p1) do
		if not p2(v, k, p1) then
			return false
		end
	end

	return true
end