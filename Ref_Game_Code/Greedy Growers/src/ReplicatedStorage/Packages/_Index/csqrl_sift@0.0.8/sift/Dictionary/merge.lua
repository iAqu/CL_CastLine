-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Bytecode (Base64):
-- CQMKASMGc2VsZWN0BHR5cGUFdGFibGUFcGFpcnMFbWVyZ2UGc2NyaXB0BlBhcmVudAdyZXF1aXJlBE5vbmUAAgwAAQEAACqjAAAA/wAAAAAAAACMAwEAbwUAALs5BQOkBAIAAAAQQN0GAACfBAACUgEEAIwCAQCoARwAuzkDBKQEAgAAABBAUgUDAN0GAACfBAACuygEA1IGBACkBQQAAAAwQJ8FAgLwBQ8ABQAAgKQFBwAAAGBAUgYEAJ8FAgQXBQcA+wsAAJoJAwALAAAAxgoAAGUAAQBSCgkAagoACG4F+P8CAAAAiwHk/4IAAgAIAwEDAgQAABBAAwMEAAAwQAMEAwUEAABgQAAbBgEYAAEAAgAAAAAAAAAAAAEAAAAAAAIAAAAAAAAEAAAAAAEAAAAAAAD/APkMGwAAAAADAAABAgAPowAAAKQAAQAAAABATQAAJAIAAABNAAAkAgAAAKQBBAAAADBATQIAPwUAAACfAQICwAIGABIAAQCCAgIABwMHBAAAAEADCAMJBAAAMEADCgYAAQABAAEYAAEAAAAAAAIAAAAAFwASAQAAAAABFxh53w1CCL0g2TffCJUqdWcAbqsl3BPe

-- https://lua.expert/
local None = require(script.Parent.Parent.None)

return function(...) --[[ merge | Line: 27 | Upvalues: None (copy) ]]
	local t = {}

	for i = 1, select("#", ...) do
		local v1 = select(i, ...)

		if type(v1) == "table" then
			for k, v in pairs(v1) do
				t[k] = if v == None then nil else v
			end
		end
	end

	return t
end