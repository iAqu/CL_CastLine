-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Bytecode (Base64):
-- CQMKFGluaXRpYWxpc2VkU3RhY2tTaXplBmlwYWlycw5pbml0RGVwZW5kZW5jeQZzY3JpcHQGUGFyZW50B3JlcXVpcmUIUHViVHlwZXMMRGVwZW5kZW5jaWVzC3NoYXJlZFN0YXRlEGluaXRpYWxpc2VkU3RhY2sAAggBAgAAABD7AQAATQEBWwAAAACkAgIAAAAQQPsDAQCfAgIEUQIFAGABAgAFAAAAggABAKkHAQBqBwYAbgL6/wIAAICCAAEAAwMBAwIEAAAQQAAQAwEYAAAAAgAAAAABAAEDAPsABxEAAAAABQAAAQIAGaMAAACkAAEAAAAAQE0AACQCAAAATQAAJAIAAACkAQQAAAAwQE0CAKcFAAAAnwECAqQCBAAAADBATQMA7AYAAABNAwNhBwAAAJ8CAgJNAwI8CAAAAMAECQASAAIAEgADAIIEAgAKAwQEAAAAQAMFAwYEAAAwQAMHAwgDCQMKBgABAAEAARgACQAAAAAAAQAAAAABAAAAAAAAAgACAAAMAQAAAAABvCLeqBFK7CmMNDMrXOu2/sw6ydyO5rSp

-- https://lua.expert/
local v1 = script.Parent.Parent

require(v1.PubTypes)

local sharedState = require(v1.Dependencies.sharedState)
local initialisedStack = sharedState.initialisedStack

return function(p1) --[[ initDependency | Line: 16 | Upvalues: sharedState (copy), initialisedStack (copy) ]]
	local initialisedStackSize = sharedState.initialisedStackSize

	for i, v in ipairs(initialisedStack) do
		if initialisedStackSize < i then
			break
		end

		v[p1] = true
	end
end