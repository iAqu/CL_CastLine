-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Bytecode (Base64):
-- CQMPBXBjYWxsCEluc3RhbmNlA25ldxFjYW5ub3RDcmVhdGVDbGFzcwVwYWlycwNOZXcGc2NyaXB0BlBhcmVudAdyZXF1aXJlCFB1YlR5cGVzCUluc3RhbmNlcwxkZWZhdWx0UHJvcHMSYXBwbHlJbnN0YW5jZVByb3BzB0xvZ2dpbmcIbG9nRXJyb3IAAwkBBAAAAB6kAQEAAAAAQKQCBAAADCCA+wMAAJ8BAwMrAQUA+wMBAG8EBQDGBQAA+wYAAJ8DBAH7BAIA+wUAAIcDBAVHAwkAAAAAAKQEBwAAAGBAUgUDAJ8EAgQXBAEAaggCB24E/v8CAAAA+wQDAFIFAABSBgIAnwQDAYICAgAIAwEEAAAAQAMCAwMEAAwggAMEAwUEAABgQAAPAAEYAAAAAAAAAgEAAAAAAwAAAQABAAAAAAH/AAUAAAACEAAAAAACAQMAAAYDAAAFAQMG2QEAABIAAAASAgAAEgIBABICAgCCAQIAAAEADgYBGAAAAAAAAA8AAAAABgAAAQIAJqMAAACkAAEAAAAAQE0AACQCAAAATQAAJAIAAACkAQQAAAAwQE0CAKcFAAAAnwECAqQCBAAAADBATQMA5wYAAABNAwOSBwAAAJ8CAgKkAwQAAAAwQE0EAOcGAAAATQQEFAgAAACfAwICpAQEAAAAMEBNBQB8CQAAAE0FBdMKAAAAnwQCAsAFCwASAAQAEgACABIAAwCCBQIADAMHBAAAAEADCAMJBAAAMEADCgMLAwwDDQMOAw8GAQEBAQABGAAHAAAAAAABAAAAAAEAAAAAAAABAAAAAAAAAQAAAAAAAAIAAAAVAQAAAAACTxNRIqZWDTCjCwyH9Hk/Fj8LRlZ91zsj

-- https://lua.expert/
local v1 = script.Parent.Parent

require(v1.PubTypes)

local defaultProps = require(v1.Instances.defaultProps)
local applyInstanceProps = require(v1.Instances.applyInstanceProps)
local logError = require(v1.Logging.logError)

return function(p1) --[[ New | Line: 14 | Upvalues: logError (copy), defaultProps (copy), applyInstanceProps (copy) ]]
	return function(p12) --[[ Line: 15 | Upvalues: p1 (copy), logError (ref), defaultProps (ref), applyInstanceProps (ref) ]]
		local ok, result = pcall(Instance.new, p1)

		if not ok then
			logError("cannotCreateClass", nil, p1)
		end

		local v1 = defaultProps[p1]

		if v1 ~= nil then
			for k, v in pairs(v1) do
				result[k] = v
			end
		end

		applyInstanceProps(p12, result)

		return result
	end
end