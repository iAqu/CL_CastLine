-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Bytecode (Base64):
-- CQMKDWRlcGVuZGVuY3lTZXQUaW5pdGlhbGlzZWRTdGFja1NpemUNdXNlRGVwZW5kZW5jeQZzY3JpcHQGUGFyZW50B3JlcXVpcmUIUHViVHlwZXMMRGVwZW5kZW5jaWVzC3NoYXJlZFN0YXRlEGluaXRpYWxpc2VkU3RhY2sAAgUBAgAAABT7AQAATQEBHwAAAABHAQ8AAAAAAPsCAABNAgJbAQAAAIwDAABgAwcAAgAAAPsEAQCHAwQChwQDAEcEAgAAAAAAggABAKkDAQBqAwEAggABAAIDAQMCAA4DARgAAAACAAEAAAEAAAEAAQAAAQMAAg8AAAAABQAAAQIAGaMAAACkAAEAAAAAQE0AACQCAAAATQAAJAIAAACkAQQAAAAwQE0CAKcFAAAAnwECAqQCBAAAADBATQMA7AYAAABNAwNhBwAAAJ8CAgJNAwI8CAAAAMAECQASAAIAEgADAIIEAgAKAwQEAAAAQAMFAwYEAAAwQAMHAwgDCQMKBgABAAEAARgABwAAAAAAAQAAAAABAAAAAAAAAgACAAAPAQAAAAABZQcKBFN4xKkGk4+FJ9ux7RUfHXBXw2AF

-- https://lua.expert/
local v1 = script.Parent.Parent

require(v1.PubTypes)

local sharedState = require(v1.Dependencies.sharedState)
local initialisedStack = sharedState.initialisedStack

return function(p1) --[[ useDependency | Line: 14 | Upvalues: sharedState (copy), initialisedStack (copy) ]]
	local dependencySet = sharedState.dependencySet

	if dependencySet == nil then
		return
	end

	local initialisedStackSize = sharedState.initialisedStackSize

	if initialisedStackSize > 0 and initialisedStack[initialisedStackSize][p1] ~= nil then
		return
	end

	dependencySet[p1] = true
end