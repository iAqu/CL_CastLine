-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Bytecode (Base64):
-- CQMEBmlwYWlycwV0YWJsZQZpbnNlcnQLcmVtb3ZlVmFsdWUAAgsCAAAABwQAAAUCBA8T/wIAAAAAAACkAwEAAAAAQFIEAACfAwIEUQMJAPEHCAABAAAAnjQCBQcAAABSCQIAUgoHAKQIBAAADCCAnwgDAW4D9v8CAACAggICAAUDAQQAAABAAwIDAwQADCCAABIEARgAAAIAAAAAAQABAAAAAAAA/gAGEwAAAAABAAABAgADowAAAMAAAACCAAIAAQYAAQABAAEYABEMAQAAAAAB

-- https://lua.expert/
return function(p1, p2) --[[ removeValue | Line: 18 ]]
	local t = {}

	for i, v in ipairs(p1) do
		if v ~= p2 then
			table.insert(t, v)
		end
	end

	return t
end