-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Bytecode (Base64):
-- CQMGBXRhYmxlBmluc2VydAtOZXh0SW50ZWdlcgZyZW1vdmUGUmFuZG9tA25ldwACEAMBAAAIBQAABQMEAocq/wMAAAAAAAD/BAAAAAAAAIwHAQAcBQAAjAYBAKgFCACeNAQFBwAAAFIJBABSCgcApAgCAAAEAICfCAMBiwX4/1IFAgArBQEA+wUAAIwIAQBSBgEAjAcBAKgGEgCMCwEAHAwEALwJBYwDAAAAnwkEAqQNBQAAEACAUg4EAFIPCQCfDQMChwwADZ40AwQMAAAAUgsDAKQKAgAABACAnwoDAYsG7v+CAwIABgMBAwIEAAQAgAMDAwQEABAAgAAGAAEYAAACAAEAAAABAAAAAAAA/wQAAAIAAAABAAAAAAEAAAAAAAAAAAAAAP4FBwAAAAACAAABAgAHowAAAKQAAgAABACAnwABAsABAwASAAAAggECAAQDBQMGBAAEAIAGAAEAAQABGAADAAACAAABAAAAAAEHue/2ybJyFWvH5+dgeBaId6H4gjV9hfc=

-- https://lua.expert/
local v1 = Random.new()

return function(p1, p2, p3) --[[ Line: 6 | Upvalues: v1 (copy) ]]
	local t = {}
	local t2 = {}

	for i = 1, #p1 do
		table.insert(t, i)
	end

	local v12 = if p3 then p3 else v1

	for j = 1, p2 do
		table.insert(t2, p1[table.remove(t, (v12:NextInteger(1, #t)))])
	end

	return t2
end