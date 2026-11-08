-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Bytecode (Base64):
-- CQMJBVN0YXRlA2dldAZ1bndyYXAGc2NyaXB0BlBhcmVudAdyZXF1aXJlCFB1YlR5cGVzB1V0aWxpdHkHeHR5cGVvZgACBQIBAAAHBAAABQIPgQz7AwAAUgQAAJ8DAgLwAwYAAAAAgFIEAQC8AgBfAQAAAJ8CAwKCAgIAUgIAAIICAgACAwEDAgALAwEYAAAAAAAAAAAAAAAADAAAAAAEAAABAgAWowAAAKQAAQAAAABATQAAJAIAAABNAAAkAgAAAKQBBAAAADBATQIApwUAAACfAQICpAIEAAAAMEBNAwAPBgAAAE0DA+QHAAAAnwICAsADCAASAAIAggMCAAkDBAQAAABAAwUDBgQAADBAAwcDCAMJBgABAAEAARgABgAAAAAAAQAAAAABAAAAAAAAAgAEAQAAAAABtdxUhchDdh/4QkUq+dlBrMXEQ/GHGD6E

-- https://lua.expert/
local v1 = script.Parent.Parent

require(v1.PubTypes)

local xtypeof = require(v1.Utility.xtypeof)

return function(p1, p2) --[[ unwrap | Line: 11 | Upvalues: xtypeof (copy) ]]
	if xtypeof(p1) == "State" then
		return p1:get(p2)
	end

	return p1
end