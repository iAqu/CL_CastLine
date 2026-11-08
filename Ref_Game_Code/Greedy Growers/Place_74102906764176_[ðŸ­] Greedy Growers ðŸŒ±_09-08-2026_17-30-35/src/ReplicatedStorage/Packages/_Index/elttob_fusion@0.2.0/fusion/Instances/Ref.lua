-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Bytecode (Base64):
-- CQMVA3NldAVTdGF0ZQRraW5kBVZhbHVlDmludmFsaWRSZWZUeXBlBXRhYmxlBmluc2VydAVhcHBseQZzY3JpcHQGUGFyZW50B3JlcXVpcmUIUHViVHlwZXMHTG9nZ2luZwhsb2dFcnJvcgdVdGlsaXR5B3h0eXBlb2YKU3BlY2lhbEtleQR0eXBlA1JlZghvYnNlcnZlcgVzdGFnZQADAwABAAAABvsAAADGAgAAvAAAUwAAAACfAAMBggABAAEDAQAXAAEYAAAAAAABGAAAAAAHBAIAAAkGAAAFBAQPBwQa+wQAAFIFAQCfBAIC8AQFAAAAAIBNBAFdAQAAAPAEBQACAAAA+wQBAG8FAwCfBAIBggABAFIGAgC8BAFTBAAAAJ8EAwHZBgAAEgABAJ40AwQGAAAAUgUDAKQEBwAAGFCAnwQDAYIAAQAIAwIDAwMEAwUDAQMGAwcEABhQgAEAEggBGAAAAAAAAAAAAAEAAAACAAAAAQAAAAAAAAAEEwAAAAAGAAABAgArowAAAKQAAQAAAABATQAAJAIAAABNAAAkAgAAAKQBBAAAADBATQIApwUAAACfAQICpAIEAAAAMEBNAwB8BgAAAE0DA9MHAAAAnwICAqQDBAAAADBATQQADwgAAABNBATkCQAAAJ8DAgL/BAMAAAAAAG8FCgAwBQRxCwAAAG8FDAAwBQRdDQAAAG8FDgAwBQQ+DwAAAMAFEAASAAMAEgACADAFBM8RAAAAggQCABIDCQQAAABAAwoDCwQAADBAAwwDDQMOAw8DEAMRAxIDEwMDAxQDFQYBAwgBAQEAARgABwAAAAAAAQAAAAABAAAAAAAAAQAAAAAAAAIAAQAAAQAAAQAAAgAAAAALAQAAAAAC6aI3f7M2Fxi7msHo/QMw95m6IAvbZl1+

-- https://lua.expert/
local v1 = script.Parent.Parent

require(v1.PubTypes)

local logError = require(v1.Logging.logError)
local xtypeof = require(v1.Utility.xtypeof)

return {
	type = "SpecialKey",
	kind = "Ref",
	stage = "observer",
	apply = function(p1, p2, p3, p4) --[[ apply | Line: 18 | Upvalues: xtypeof (copy), logError (copy) ]]
		if xtypeof(p2) == "State" and p2.kind == "Value" then
			p2:set(p3)
			table.insert(p4, function() --[[ Line: 23 | Upvalues: p2 (copy) ]]
				p2:set(nil)
			end)
		else
			logError("invalidRefType")
		end
	end
}