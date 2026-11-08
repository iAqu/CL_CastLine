-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Bytecode (Base64):
-- CQMCBmlwYWlycwh3aXRoS2V5cwACCAEAAQAGAwAABQEEEaMBAAD/AQAAAAAAAKQCAQAAAABA/wMAAAAAAADdBQAAxQMFAAEAAACfAgIEUQICAIcHAAZqBwEGbgL9/wIAAICCAQIAAgMBBAAAAEAAEwIBGAABAAIAAAAAAAAAAAEA/wAEEwAAAAABAAABAgADowAAAMAAAACCAAIAAQYAAQABAAEYABIKAQAAAAAB

-- https://lua.expert/
return function(p1, ...) --[[ withKeys | Line: 19 ]]
	local t = {}

	for i, v in ipairs({ ... }) do
		t[v] = p1[v]
	end

	return t
end