-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Bytecode (Base64):
-- CQMEBmlwYWlycwV0YWJsZQZpbnNlcnQNcmVtb3ZlSW5kaWNlcwACDAEAAQAGAwAABQEEKKMBAAAcAQAA/wIAAAAAAAD/AwAAAAAAAKQEAQAAAABA/wUAAAAAAADdBwAAxQUHAAEAAACfBAIEUQQGAIwJAQBgCAIACQAAAEMICAGpCQEAagkCCG4E+f8CAACApAQBAAAAAEBSBQAAnwQCBFEECQCHCQIHKwkHAJ40AwUIAAAAUgoDAFILCACkCQQAAAwggJ8JAwFuBPb/AgAAgIIDAgAFAwEEAAAAQAMCAwMEAAwggAATBAEYAAEBAAEAAgAAAAAAAAAAAQAAAQMA+wAIAAAAAAEAAQAAAAAAAP4ABhMAAAAAAQAAAQIAA6MAAADAAAAAggACAAEGAAEAAQABGAASFgEAAAAAAYGumTCZcwQGy4uwucesxdTxto5Es2rzMQ==

-- https://lua.expert/
return function(p1, ...) --[[ removeIndices | Line: 19 ]]
	local v1 = #p1
	local t = {}
	local t2 = {}

	for i, v in ipairs({ ... }) do
		if v < 1 then
			v = v + v1
		end

		t[v] = true
	end

	for i, v in ipairs(p1) do
		if not t[i] then
			table.insert(t2, v)
		end
	end

	return t2
end