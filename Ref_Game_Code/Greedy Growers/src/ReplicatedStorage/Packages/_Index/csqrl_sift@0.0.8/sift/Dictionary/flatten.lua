-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Bytecode (Base64):
-- CQMJBHR5cGUGbnVtYmVyBXBhaXJzBXRhYmxlB2ZsYXR0ZW4HcmVxdWlyZQZzY3JpcHQGUGFyZW50BVR5cGVzAAIOAgEAAAcEAAAFAg+CLLsoAQNSAwEApAIBAAAAAECfAgIC8AICAAIAAIBlAAEAbwEDAP8CAAAAAAAApAMFAAAAQEBSBAAAnwMCBBcDGQC7KAcDUgkHAKQIAQAAAABAnwgCAvAIEgAGAACAjAgAAGAIDwABAAAA+wgAAFIJBwB4CgEHnwgDAqQJBQAAAEBAUgoCAJ8JAgQXCQEAag0IDG4J/v8CAAAAUgIIAGUAAQBqBwIGbgPm/wIAAACCAgIACAMBBAAAAEADAgIAAAAAAADwfwMDBAAAQEADBAIAAAAAAADwPwAeBQEYAAAAAAAAAAAAAgACAAAAAAEAAAAAAAAAAAABAAAAAgAAAAAB/wAEAAL2AA4fAAAAAAIAAAECAA+jAAAApAABAAAAAECkAQMAAAAgQE0BASQEAAAATQEBJAQAAABNAQHvBQAAAJ8AAgLAAQYAEgABAIIBAgAHAwYEAAAAQAMHBAAAIEADCAMJBgABAAEAARgAAQAAAAAAAAAAAAAcABYBAAAAAAHezi3X8GODAbuU3VYsov1YrtY6o+wKR9Y=

-- https://lua.expert/
require(script.Parent.Parent.Types)

local function v1(p1, p2) --[[ flatten | Line: 30 | Upvalues: v1 (copy) ]]
	if type(p2) ~= "number" then
		p2 = (1 / 0)
	end

	local tbl = {}

	for k, v in pairs(p1) do
		if type(v) == "table" and p2 > 0 then
			local v12 = v1(v, p2 - 1)

			for k2, v2 in pairs(tbl) do
				v12[k2] = v2
			end

			tbl = v12

			continue
		end

		tbl[k] = v
	end

	return tbl
end

return v1