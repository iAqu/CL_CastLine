-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Bytecode (Base64):
-- CQMNDnVua25vd25NZXNzYWdlBHdhcm4Gc3RyaW5nBmZvcm1hdAlbRnVzaW9uXSAGCihJRDogASkHbG9nV2FybgZzY3JpcHQGUGFyZW50B3JlcXVpcmUHTG9nZ2luZwhtZXNzYWdlcwACCgEBAQAAGqMBAADGAQAA+wMAAIcCAwBHAgQAAAAAAPsCAACHAQIAZQADAG8AAAD7AgAAhwECAKQCAgAAABBApAMFAAAQMIBvBQYAUgYBAG8HBwBSCAAAbwkIAHMEBQndBQAAnwMAAJ8CAAGCAAEACQMBAwIEAAAQQAMDAwQEABAwgAMFAwYDBwAKCAEYAAECAAAAAQAAAgEAAwAAAAAAAAAAAAAAAAEKAAAAAAMAAAECABGjAAAApAABAAAAAEBNAAAkAgAAAE0AACQCAAAApAEEAAAAMEBNAgB8BQAAAE0CAgIGAAAAnwECAsACBwASAAEAggICAAgDCQQAAABAAwoDCwQAADBAAwwDDQYAAQABAAEYAAYAAAAAAAEAAAAAAAACAA0BAAAAAAEYloQPdk/TARYUqMtoBNG8aI6TeypS7g4=

-- https://lua.expert/
local messages = require(script.Parent.Parent.Logging.messages)

return function(p1, ...) --[[ logWarn | Line: 10 | Upvalues: messages (copy) ]]
	if messages[p1] == nil then
		p1 = "unknownMessage"
	end

	warn(string.format("[Fusion] " .. messages[p1] .. "\n(ID: " .. p1 .. ")", ...))
end