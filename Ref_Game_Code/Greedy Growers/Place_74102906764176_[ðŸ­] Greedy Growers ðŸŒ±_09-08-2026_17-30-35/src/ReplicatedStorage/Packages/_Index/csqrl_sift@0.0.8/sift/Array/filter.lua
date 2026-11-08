-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Bytecode (Base64):
-- CQMMBHR5cGUIZnVuY3Rpb24EZnVuYwZ0cnV0aHkGaXBhaXJzBXRhYmxlBmluc2VydAZmaWx0ZXIGc2NyaXB0BlBhcmVudAdyZXF1aXJlBFV0aWwAAgwCAQAABwQAAAUCBIUk/wIAAAAAAAC7KAEDUgQBAKQDAQAAAABAnwMCAvADAgACAACAZQAFAPsDAABNAwNmAwAAAE0BA+8EAAAApAMGAAAAUEBSBAAAnwMCBFEDDQBSCAEAUgkHAFIKBgBSCwAAnwgEAg4IBwCeNAIFBwAAAFIJAgBSCgcApAgJAAAgcICfCAMBbgPy/wIAAICCAgIACgMBBAAAAEADAgMDAwQDBQQAAFBAAwYDBwQAIHCAABoIARgAAAIAAAAAAAAAAAAAAAACAAAAAAEAAAAAAAEAAAAAAAD+AAYeAAAAAAMAAAECAA+jAAAApAABAAAAAEBNAAAkAgAAAE0AACQCAAAApAEEAAAAMEBNAgCeBQAAAJ8BAgLAAgYAEgABAIICAgAHAwkEAAAAQAMKAwsEAAAwQAMMBgABAAEAARgAAQAAAAAAAgAAAAAWABEBAAAAAAE0gHF+MCyK8j3sktgaDdelRJhmCgZEG38=

-- https://lua.expert/
local Util = require(script.Parent.Parent.Util)

return function(p1, p2) --[[ filter | Line: 26 | Upvalues: Util (copy) ]]
	local t = {}

	if type(p2) ~= "function" then
		p2 = Util.func.truthy
	end

	for i, v in ipairs(p1) do
		if p2(v, i, p1) then
			table.insert(t, v)
		end
	end

	return t
end