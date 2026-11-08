-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Bytecode (Base64):
-- CQMDBHR5cGUGbnVtYmVyCGZpbmRMYXN0AAIIAwAAAAgFAAAFAwQPghkcAwAAuygCA1IFAgCkBAEAAAAAQJ8EAgLwBAcAAgAAgIwEAQBgAgUABAAAAEMCAwJlAAIAZQABAFICAwBSBgIAjAQBAIwF//+oBAUAhwcABpoHAgABAAAAggYCAIsE+/+CAAEAAwMBBAAAAEADAgAUAwEYAAIAAAAAAAAAAAAAAAAAAgAAAAEAAAH+BhUAAAAAAQAAAQIAA6MAAADAAAAAggACAAEGAAEAAQABGAATDgEAAAAAAQ==

-- https://lua.expert/
return function(p1, p2, p3) --[[ findLast | Line: 20 ]]
	local v1 = #p1

	if type(p3) == "number" then
		if p3 < 1 then
			p3 = v1 + p3
		end
	else
		p3 = v1
	end

	for i = p3, 1, -1 do
		if p1[i] == p2 then
			return i
		end
	end
end