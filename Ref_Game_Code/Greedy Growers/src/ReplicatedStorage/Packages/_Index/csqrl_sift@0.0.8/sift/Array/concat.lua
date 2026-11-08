-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Bytecode (Base64):
-- CQMLASMGc2VsZWN0BHR5cGUFdGFibGUGaXBhaXJzBmluc2VydAZjb25jYXQGc2NyaXB0BlBhcmVudAdyZXF1aXJlBE5vbmUAAg0AAQEAAC2jAAAA/wAAAAAAAACMAwEAbwUAALs5BQOkBAIAAAAQQN0GAACfBAACUgEEAIwCAQCoAR8AuzkDBKQEAgAAABBAUgUDAN0GAACfBAACuygEA1IGBACkBQQAAAAwQJ8FAgLwBRIABQAAgKQFBwAAAGBAUgYEAJ8FAgRRBQoA+woAAPEJCAAKAAAAnjQABQkAAABSCwAAUgwJAKQKCQAAIFCAnwoDAW4F9f8CAACAiwHh/4IAAgAKAwEDAgQAABBAAwMEAAAwQAMEAwUEAABgQAMGBAAgUIAAGgcBGAABAAIAAAAAAAAAAAABAAAAAAACAAAAAAAABAAAAAABAAABAAAAAAAA/gD5DhoAAAAAAwAAAQIAD6MAAACkAAEAAAAAQE0AACQCAAAATQAAJAIAAACkAQQAAAAwQE0CAD8FAAAAnwECAsACBgASAAEAggICAAcDCAQAAABAAwkDCgQAADBAAwsGAAEAAQABGAABAAAAAAACAAAAABYAFAEAAAAAAdPYr6bPvOKo28XH3naYvIKjwLjS4RzFpw==

-- https://lua.expert/
local None = require(script.Parent.Parent.None)

return function(...) --[[ concat | Line: 26 | Upvalues: None (copy) ]]
	local t = {}

	for i = 1, select("#", ...) do
		local v1 = select(i, ...)

		if type(v1) == "table" then
			for i2, v in ipairs(v1) do
				if v ~= None then
					table.insert(t, v)
				end
			end
		end
	end

	return t
end