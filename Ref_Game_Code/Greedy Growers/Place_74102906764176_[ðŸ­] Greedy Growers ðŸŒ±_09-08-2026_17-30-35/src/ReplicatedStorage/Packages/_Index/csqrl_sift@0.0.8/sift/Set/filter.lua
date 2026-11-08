-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Bytecode (Base64):
-- CQMKBHR5cGUIZnVuY3Rpb24EZnVuYwZ0cnV0aHkFcGFpcnMGZmlsdGVyBnNjcmlwdAZQYXJlbnQHcmVxdWlyZQRVdGlsAAILAgEAAAcEAAAFAgSFHv8CAAAAAAAAuygBA1IEAQCkAwEAAAAAQJ8DAgLwAwIAAgAAgGUABQD7AwAATQMDZgMAAABNAQPvBAAAAKQDBgAAAFBAUgQAAJ8DAgQXAwcAUggBAFIJBgBSCgAAnwgDAg4IAgCpCAEAaggCBm4D+P8CAAAAggICAAcDAQQAAABAAwIDAwMEAwUEAABQQAAYBgEYAAACAAAAAAAAAAAAAAAAAgAAAAABAAAAAAEA/gAGHAAAAAADAAABAgAPowAAAKQAAQAAAABATQAAJAIAAABNAAAkAgAAAKQBBAAAADBATQIAngUAAACfAQICwAIGABIAAQCCAgIABwMHBAAAAEADCAMJBAAAMEADCgYAAQABAAEYAAEAAAAAAAIAAAAAFAARAQAAAAAB/T4leIy5scvk3K529L0a6o0mMgzP+k95

-- https://lua.expert/
local Util = require(script.Parent.Parent.Util)

return function(p1, p2) --[[ filter | Line: 24 | Upvalues: Util (copy) ]]
	local t = {}

	if type(p2) ~= "function" then
		p2 = Util.func.truthy
	end

	for k, v in pairs(p1) do
		if p2(k, p1) then
			t[k] = true
		end
	end

	return t
end