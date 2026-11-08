-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Bytecode (Base64):
-- CQMSDWRlcGVuZGVuY3lTZXQUaW5pdGlhbGlzZWRTdGFja1NpemUFdGFibGUFY2xlYXIEcGFjawZ4cGNhbGwBbgZ1bnBhY2sTY2FwdHVyZURlcGVuZGVuY2llcwZzY3JpcHQGUGFyZW50B3JlcXVpcmUIUHViVHlwZXMHTG9nZ2luZwpwYXJzZUVycm9yDERlcGVuZGVuY2llcwtzaGFyZWRTdGF0ZRBpbml0aWFsaXNlZFN0YWNrAAIKAgQBAAcEAAAFAgQFPKMCAAD7AgAATQICHwAAAAD7AwAAMAADHwAAAAD7AwAATQQDWwEAAACVBAQCMAQDWwEAAAD7AwAATQMDWwEAAADGBAAA+wUBAGAFBwADAAAA/wQAAAAAAAD7BQIAagQFA94DAQBlAAYA+wUCAIcEBQOkBQUAABAwgFIGBACfBQIBpAUHAAAYMICkBgkAAACAQFIHAQD7CAMA3QkAAJ8GAACfBQAC+wYAADACBh8AAAAA+wYAAE0HBlsBAAAAeAcHAjAHBlsBAAAAjAgBAE0JBY8KAAAANDUFBAgJAABSBwUApAYMAAAsMICfBgQAggYAAA0DAQMCAgAAAAAAAPA/AwMDBAQAEDCAAwUEABgwgAMGBAAAgEADBwMIBAAsMIAAGQkBGAAGAAABAAACAAAAAAABAAACAQAAAQABAAEAAgABAAAAAwAAAAAAAAAAAgAAAQAAAAAAAgAAAAAAAAAAABkAAAAABwAAAQIAJKMAAACkAAEAAAAAQE0AACQCAAAATQAAJAIAAACkAQQAAAAwQE0CAKcFAAAAnwECAqQCBAAAADBATQMAfAYAAABNAwNsBwAAAJ8CAgKkAwQAAAAwQE0EAOwIAAAATQQEYQkAAACfAwICTQQDPAoAAACMBQAA2QYAABIAAwASAQX/EgAEABIAAgDBBQAAggYCAAsDCgQAAABAAwsDDAQAADBAAw0DDgMPAxADEQMSAQABAAEYAA4AAAAAAAEAAAAAAQAAAAAAAAEAAAAAAAAEAAECAAAAAB4AAQAAAAAB/4hSYWn9K6kbl5VOymONiY+QRRXNTDhg

-- https://lua.expert/
local v1 = script.Parent.Parent

require(v1.PubTypes)

local parseError = require(v1.Logging.parseError)
local sharedState = require(v1.Dependencies.sharedState)
local initialisedStack = sharedState.initialisedStack
local v2 = 0

return function(p1, p2, ...) --[[ captureDependencies | Line: 25 | Upvalues: sharedState (copy), v2 (ref), initialisedStack (copy), parseError (copy) ]]
	local dependencySet = sharedState.dependencySet

	sharedState.dependencySet = p1

	local v1 = sharedState

	v1.initialisedStackSize = v1.initialisedStackSize + 1

	local initialisedStackSize = sharedState.initialisedStackSize

	if v2 < initialisedStackSize then
		initialisedStack[initialisedStackSize] = {}
		v2 = initialisedStackSize
	else
		table.clear(initialisedStack[initialisedStackSize])
	end

	local v3 = table.pack(xpcall(p2, parseError, ...))

	sharedState.dependencySet = dependencySet

	local v4 = sharedState

	v4.initialisedStackSize = v4.initialisedStackSize - 1

	return table.unpack(v3, 1, v3.n)
end