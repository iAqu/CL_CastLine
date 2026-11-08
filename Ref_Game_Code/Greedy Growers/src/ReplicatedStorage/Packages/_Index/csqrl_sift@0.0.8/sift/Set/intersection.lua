-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Bytecode (Base64):
-- CQMEASMGc2VsZWN0BXBhaXJzDGludGVyc2VjdGlvbgACDwAAAQAAK6MAAABvAQAAuzkBA6QAAgAAABBA3QIAAJ8AAAKMAgEAuzkCA6QBAgAAABBA3QMAAJ8BAAL/AgAAAAAAAKQDBAAAADBAUgQBAJ8DAgQXAxQAqQgBAIwLAgBSCQAAjAoBAKgJDAC7OQsEpAwCAAAAEEBSDQsA3Q4AAJ8MAAKHDQwGKg0DAAEAAACpCAAAZQABAIsJ9P8OCAIAqQkBAGoJAgZuA+v/AgAAAIICAgAFAwEDAgQAABBAAwMEAAAwQAAUBAEYAAEAAAAAAAEAAAAAAAIAAgAAAAABAgAAAAEAAAAAAAIAAAEB+wkBAPMAERQAAAAAAQAAAQIAA6MAAADAAAAAggACAAEGAAEAAQABGAATGgEAAAAAAX0sn9wlztum2U974elp8V0NNIioT+j13Q==

-- https://lua.expert/
return function(...) --[[ intersection | Line: 20 ]]
	local v1 = select("#", ...)
	local t = {}

	for k, v in pairs((select(1, ...))) do
		local v3 = true

		for i = 2, v1 do
			if select(i, ...)[k] ~= true then
				v3 = false

				break
			end
		end

		if v3 then
			t[k] = true
		end
	end

	return t
end