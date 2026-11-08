-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Bytecode (Base64):
-- CQMEBmlwYWlycwV0YWJsZQZpbnNlcnQDc2V0AAINAwAAAAgFAAAFAwQCDyAcAwAA/wQAAAAAAACMBQEAYAECAAUAAABDAQEDpAUBAAAAAEBSBgAAnwUCBFEFEQCaCAkAAQAAAJ40BAUCAAAAUgsEAFIMAgCkCgQAAAwggJ8KAwFlAAcAnjQEBQkAAABSCwQAUgwJAKQKBAAADCCAnwoDAW4F7v8CAACAggQCAAUDAQQAAABAAwIDAwQADCCAABQEARgAAQACAAABAwAAAAABAAEAAAAAAAAAAgAAAAAAAPwACBUAAAAAAQAAAQIAA6MAAADAAAAAggACAAEGAAEAAQABGAATEwEAAAAAAdqm+SYj4E+NwwyaKVajCE+qvu5S6GKTJw==

-- https://lua.expert/
return function(p1, p2, p3) --[[ set | Line: 20 ]]
	local t = {}

	if p2 < 1 then
		p2 = p2 + #p1
	end

	for i, v in ipairs(p1) do
		if i == p2 then
			table.insert(t, p3)

			continue
		end

		table.insert(t, v)
	end

	return t
end