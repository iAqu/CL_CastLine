-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Bytecode (Base64):
-- CQMLD3N0cmljdFJlYWRFcnJvcgh0b3N0cmluZwdfX2luZGV4DGdldG1ldGF0YWJsZQxzZXRtZXRhdGFibGUMcmVzdHJpY3RSZWFkBnNjcmlwdAZQYXJlbnQHcmVxdWlyZQdMb2dnaW5nCGxvZ0Vycm9yAAMHAgIAAAAL+wIAAG8DAADGBAAAuz8BA1IGAQCkBQIAAAAQQJ8FAgL7BgEAnwIFAYIAAQADAwEDAgQAABBAABUDARgAAAAAAAAAAAAAARYAAAAABgIBAAAHBAAABQIDBBa7PAEDUgMBAKQCAQAAAABAnwICAkcCCgAAAACA/wIAAAAAAACePQEFAgAAAFIEAQBSBQIApAMDAAAAIECfAwMB2QMAABICAAASAAAAMAMCbgQAAACCAQIABQMEBAAAAEADBQQAACBAAwMBAAwGARgAAAAAAAIAAQABAAAAAAAAAwAAAAAEDgAAAAADAAABAgARowAAAKQAAQAAAABATQAAJAIAAABNAAAkAgAAAKQBBAAAADBATQIAfAUAAABNAgLTBgAAAJ8BAgLAAgcAEgABAIICAgAIAwcEAAAAQAMIAwkEAAAwQAMKAwsGAQEBAQABGAAGAAAAAAABAAAAAAAABAAQAQAAAAAC1LZ3HlX97O2xaH9k2JASdKSuYGrmch0f

-- https://lua.expert/
local logError = require(script.Parent.Parent.Logging.logError)

return function(p1, p2) --[[ restrictRead | Line: 12 | Upvalues: logError (copy) ]]
	local v1 = getmetatable(p2)

	if v1 == nil then
		v1 = {}
		setmetatable(p2, v1)
	end

	function v1.__index(p12, p2) --[[ __index | Line: 21 | Upvalues: logError (ref), p1 (copy) ]]
		logError("strictReadError", nil, tostring(p2), p1)
	end

	return p2
end