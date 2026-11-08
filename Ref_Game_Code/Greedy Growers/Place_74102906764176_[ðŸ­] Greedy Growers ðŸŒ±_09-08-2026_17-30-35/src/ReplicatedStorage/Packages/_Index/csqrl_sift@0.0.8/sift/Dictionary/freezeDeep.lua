-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Bytecode (Base64):
-- CQMJBXBhaXJzBHR5cGUFdGFibGUGZnJlZXplCmZyZWV6ZURlZXAHcmVxdWlyZQZzY3JpcHQGUGFyZW50BVR5cGVzAAIJAQEAAAAb/wEAAAAAAACkAgEAAAAAQFIDAACfAgIEFwINALsoBgNSCAYApAcDAAAAIECfBwIC8AcGAAQAAID7BwAAUggGAJ8HAgJqBwEFZQABAGoGAQVuAvL/AgAAAKQCBgAAFECAUgMBAJ8CAgGCAQIABwMBBAAAAEADAgQAACBAAwMDBAQAFECAABYFARgAAAIAAAAAAQAAAAAAAAEAAAAAAvwACAAAAAIXAAAAAAIAAAECAA+jAAAApAABAAAAAECkAQMAAAAgQE0BASQEAAAATQEBJAQAAABNAQHvBQAAAJ8AAgLAAQYAEgABAIIBAgAHAwYEAAAAQAMHBAAAIEADCAMJBgABAAEAARgAAQAAAAAAAAAAAAAUABABAAAAAAGSBEYVeWKmJqFXMt8hj8894hxRYaDALBQ=

-- https://lua.expert/
require(script.Parent.Parent.Types)

local function v1(p1) --[[ freezeDeep | Line: 22 | Upvalues: v1 (copy) ]]
	local t = {}

	for k, v in pairs(p1) do
		if type(v) == "table" then
			t[k] = v1(v)

			continue
		end

		t[k] = v
	end

	table.freeze(t)

	return t
end

return v1