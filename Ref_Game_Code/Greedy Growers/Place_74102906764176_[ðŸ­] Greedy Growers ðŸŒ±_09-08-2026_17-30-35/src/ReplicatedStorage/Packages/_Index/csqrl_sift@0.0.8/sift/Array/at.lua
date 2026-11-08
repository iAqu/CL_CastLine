-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Bytecode (Base64):
-- CQMBAmF0AAIEAgAAAAcEAAAFAgQCBxwCAACMAwEAYAECAAMAAABDAQEChwMAAYIDAgAAABMBARgAAgAAAQMAFAAAAAABAAABAgADowAAAMAAAACCAAIAAQYAAQABAAEYABIKAQAAAAAB

-- https://lua.expert/
return function(p1, p2) --[[ at | Line: 19 ]]
	if p2 < 1 then
		p2 = p2 + #p1
	end

	return p1[p2]
end