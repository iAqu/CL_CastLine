-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Bytecode (Base64):
-- CQMaA3NldAVwY2FsbBhHZXRQcm9wZXJ0eUNoYW5nZWRTaWduYWwSaW52YWxpZE91dFByb3BlcnR5CUNsYXNzTmFtZQVTdGF0ZQRraW5kBVZhbHVlDmludmFsaWRPdXRUeXBlB0Nvbm5lY3QFdGFibGUGaW5zZXJ0BWFwcGx5ClNwZWNpYWxLZXkEdHlwZQNPdXQIb2JzZXJ2ZXIFc3RhZ2UGc2NyaXB0BlBhcmVudAdyZXF1aXJlCFB1YlR5cGVzB0xvZ2dpbmcIbG9nRXJyb3IHVXRpbGl0eQd4dHlwZW9mAAUFAAMAAAAI+wAAAPsDAQD7BAIAhwIDBLwAAFMAAAAAnwADAYIAAQABAwEAHQABGAAAAAAAAAABHgAAAAADAAEAAAAG+wAAAMYCAAC8AABTAAAAAJ8AAwGCAAEAAQMBACEAARgAAAAAAAEiAAAAAAsEAwAACQYAAAUEBA8HBDekBAEAAAAAQE0FApQCAAAAUgYCAPsHAACfBAQDKwQIAPsGAQBvBwMAxggAAE0JAtsEAAAA+woAAJ8GBQGCAAEA+wYCAFIHAQCfBgIC8AYFAAUAAIBNBgFdBgAAAPAGBQAHAAAA+wYBAG8HCACfBgIBggABAPsJAACHCAIJvAYBUwkAAACfBgMBUgcDANkKAAASAAEAEgACABICAAC8CAXHCgAAAJ8IAwBMNAACpAYNAAAwsICfBgAB2QgBABIAAQCeNAMECAAAAFIHAwCkBg0AADCwgJ8GAwGCAAEADgMCBAAAAEADAwMEAwUDBgMHAwgDCQMBAwoDCwMMBAAwsIACAAETDQEYAAAAAAAAAAEBAAAAAAAAAAEAAAAAAAAAAAEAAAACAAAAAAIBAAAAAAAA/gAAAAYAAAAAAAAABBQAAAAAAwECAAAGAwAABQEDEv8BAwAAAAAAbwIAADACAXEBAAAAbwICADACAV0DAAAAbwIEADACAT4FAAAA2QIAABIAAAASAgAAEgIBADACAc8GAAAAggECAAcDDgMPAxADBwMRAxIDDQECDRABGAAAAQAAAQAAAQAAAgAAAAAAFA4AAAAABQAAAQIAHqMAAACkAAEAAAAAQE0AACQCAAAATQAAJAIAAACkAQQAAAAwQE0CAKcFAAAAnwECAqQCBAAAADBATQMAfAYAAABNAwPTBwAAAJ8CAgKkAwQAAAAwQE0EAA8IAAAATQQE5AkAAACfAwICwAQKABIAAgASAAMAggQCAAsDEwQAAABAAxQDFQQAADBAAxYDFwMYAxkDGgYDAQMBAAEYAAcAAAAAAAEAAAAAAQAAAAAAAAEAAAAAAAACAAAdAQAAAAAEteZu0ENdcCxOaQogyATxYcX+eaSHIgTR

-- https://lua.expert/
local v1 = script.Parent.Parent

require(v1.PubTypes)

local logError = require(v1.Logging.logError)
local xtypeof = require(v1.Utility.xtypeof)

return function(p1) --[[ Out | Line: 13 | Upvalues: logError (copy), xtypeof (copy) ]]
	return {
		type = "SpecialKey",
		kind = "Out",
		stage = "observer",
		apply = function(p12, p2, p3, p4) --[[ apply | Line: 19 | Upvalues: p1 (copy), logError (ref), xtypeof (ref) ]]
			local ok, result = pcall(p3.GetPropertyChangedSignal, p3, p1)

			if not ok then
				logError("invalidOutProperty", nil, p3.ClassName, p1)

				return
			end

			if xtypeof(p2) == "State" and p2.kind == "Value" then
				p2:set(p3[p1])

				local function f1() --[[ Line: 29 | Upvalues: p2 (copy), p3 (copy), p1 (ref) ]]
					p2:set(p3[p1])
				end

				table.insert(p4, result:Connect(f1))
				table.insert(p4, function() --[[ Line: 33 | Upvalues: p2 (copy) ]]
					p2:set(nil)
				end)
			else
				logError("invalidOutType")
			end
		end
	}
end