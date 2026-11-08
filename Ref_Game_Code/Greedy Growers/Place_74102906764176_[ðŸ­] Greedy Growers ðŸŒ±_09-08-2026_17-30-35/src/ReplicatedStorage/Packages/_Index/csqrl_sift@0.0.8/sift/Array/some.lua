-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Bytecode (Base64):
-- CQMCBmlwYWlycwRzb21lAAILAgAAAAcEAAAFAgQFEaQCAQAAAABAUgMAAJ8CAgRRAggAUgcBAFIIBgBSCQUAUgoAAJ8HBAIOBwIAqQcBAIIHAgBuAvf/AgAAgKkCAACCAgIAAgMBBAAAAEAAGAIBGAAAAAAAAQAAAAAAAQD+AAYAHAAAAAABAAABAgADowAAAMAAAACCAAIAAQYAAQABAAEYABcNAQAAAAAB

-- https://lua.expert/
return function(p1, p2) --[[ some | Line: 24 ]]
	for i, v in ipairs(p1) do
		if p2(v, i, p1) then
			return true
		end
	end

	return false
end