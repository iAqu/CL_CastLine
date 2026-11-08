-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Bytecode (Base64):
-- CQMWBl92YWx1ZQNnZXQDc2V0BHR5cGUFU3RhdGUEa2luZAVWYWx1ZQxkZXBlbmRlbnRTZXQMc2V0bWV0YXRhYmxlBnNjcmlwdAZQYXJlbnQHcmVxdWlyZQVUeXBlcwxEZXBlbmRlbmNpZXMNdXNlRGVwZW5kZW5jeQ5pbml0RGVwZW5kZW5jeQl1cGRhdGVBbGwHVXRpbGl0eQlpc1NpbWlsYXIHX19pbmRleAZfX21vZGUBawAEBAIBAAAHBAAABQIEgQgqAQQAAAAAAPsCAABSAwAAnwICAU0CAOMAAAAAggICAAEDAQAZAgEYAAABAAACAAAaAAAAAAcDAgAACAUAAAUDBA+BDk0DAOMAAAAAKwIFAPsEAABSBQMAUgYBAJ8EAwIrBAUAMAEA4wAAAAD7BAEAUgUAAJ8EAgGCAAEAAQMBACcDARgAAAEAAAAAAAEAAQAAAigAAAAABgEDAAAAF+ICBgD/BAAAAAAAAPsFAACePQQDBQAAAKQDCAAAAHBAnwMDAjADAmEEAAAAMAAC4wUAAAD7AwEAnj0CAwMAAACkAQgAAABwQJ8BAwL7AgIAUgMBAJ8CAgGCAQIACQMEAwUDBgMHAwgDAQgEAAEAAAACAwAAAAT/////Bf////8DCQQAAHBAAC8HARgABQAAAAAAAAAAAAEAAQAA+QAACQAAAjAAAAAACgAAAQIAPKMAAACkAAEAAAAAQE0AACQCAAAATQAAJAIAAACkAQQAAAAwQE0CAO8FAAAAnwECAqQCBAAAADBATQMA7AYAAABNAwOwBwAAAJ8CAgKkAwQAAAAwQE0EAOwGAAAATQQEsAgAAACfAwICpAQEAAAAMEBNBQDsBgAAAE0FBXIJAAAAnwQCAqQFBAAAADBATQYADwoAAABNBgayCwAAAJ8FAgL/BgIAAAAAAOIHDQAwBgduDAAAAOIIEADACREAEgACADAJBl8SAAAAwAkTABIABQASAAQAMAkGUxQAAADACRUAEgAIABIABwASAAMAggkCABYDCgQAAABAAwsDDAQAADBAAw0DDgMPAxADEQMSAxMDFAUBDAMVAxYIAQ4PAAAABgADAgYBAwMGAgMAAQIBAAEYAAcAAAAAAAEAAAAAAQAAAAAAAAEAAAAAAAABAAAAAAAAAQAAAAAAAAIAAgAAAQcAAAAOAAAAAAgAAAAPAQAAAAADOYDGNpgfGUBz3fFTOWQ68EmY0UILRKw3

-- https://lua.expert/
local v1 = script.Parent.Parent

require(v1.Types)

local useDependency = require(v1.Dependencies.useDependency)
local initDependency = require(v1.Dependencies.initDependency)
local updateAll = require(v1.Dependencies.updateAll)
local isSimilar = require(v1.Utility.isSimilar)
local t = {}
local t2 = {
	__index = t
}
local t3 = {
	__mode = "k"
}

function t.get(p1, p2) --[[ get | Line: 25 | Upvalues: useDependency (copy) ]]
	if p2 ~= false then
		useDependency(p1)
	end

	return p1._value
end
function t.set(p1, p2, p3) --[[ set | Line: 39 | Upvalues: isSimilar (copy), updateAll (copy) ]]
	if not p3 and isSimilar(p1._value, p2) then
		return
	end

	p1._value = p2
	updateAll(p1)
end

return function(p1) --[[ Value | Line: 47 | Upvalues: t3 (copy), t2 (copy), initDependency (copy) ]]
	local t = {
		type = "State",
		kind = "Value"
	}

	t.dependentSet = setmetatable({}, t3)
	t._value = p1

	local v3 = setmetatable(t, t2)

	initDependency(v3)

	return v3
end