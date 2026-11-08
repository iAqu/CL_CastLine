-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Bytecode (Base64):
-- CQMEBHR5cGUGbnVtYmVyBXRhYmxlBGZpbmQAAggDAAAACAUAAAUDBA+CFhwDAAC7KAIDUgUCAKQEAQAAAABAnwQCAvAEBwACAACAjAQBAGACBQAEAAAAQwIDAmUAAgBlAAEAjAIBAKQEBQAAEDCAUgUAAFIGAQBSBwIAnwQEAIIEAAAGAwEEAAAAQAMCAwMDBAQAEDCAABkEARgAAgAAAAAAAAAAAAAAAAACAAAAAAAAGgAAAAABAAABAgADowAAAMAAAACCAAIAAQYAAQABAAEYABgIAQAAAAAB

-- https://lua.expert/
return function(p1, p2, p3) --[[ find | Line: 25 ]]
	local v1 = #p1

	if type(p3) == "number" then
		if p3 < 1 then
			p3 = v1 + p3
		end
	else
		p3 = 1
	end

	return table.find(p1, p2, p3)
end