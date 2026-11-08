-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Bytecode (Base64):
-- CQMHB0h5ZHJhdGUGc2NyaXB0BlBhcmVudAdyZXF1aXJlCFB1YlR5cGVzCUluc3RhbmNlcxJhcHBseUluc3RhbmNlUHJvcHMAAwQBAgAAAAb7AQAAUgIAAPsDAQCfAQMB+wEBAIIBAgAAAA0AARgAAAAAAQAOAAAAAAIBAQAABgMAAAUBBwTZAQAAEgIAABIAAACCAQIAAAEADAEBGAAAAAANAAAAAAQAAAECABajAAAApAABAAAAAEBNAAAkAgAAAE0AACQCAAAApAEEAAAAMEBNAgCnBQAAAJ8BAgKkAgQAAAAwQE0DAOcGAAAATQMDFAcAAACfAgICwAMIABIAAgCCAwIACQMCBAAAAEADAwMEBAAAMEADBQMGAwcGAQEBAQABGAAHAAAAAAABAAAAAAEAAAAAAAACAAcBAAAAAAJaMCGiFJavg8v3TFj32wdtKig21mj0S6M=

-- https://lua.expert/
local v1 = script.Parent.Parent

require(v1.PubTypes)

local applyInstanceProps = require(v1.Instances.applyInstanceProps)

return function(p1) --[[ Hydrate | Line: 12 | Upvalues: applyInstanceProps (copy) ]]
	return function(p12) --[[ Line: 13 | Upvalues: applyInstanceProps (ref), p1 (copy) ]]
		applyInstanceProps(p12, p1)

		return p1
	end
end