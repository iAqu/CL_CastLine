-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Bytecode (Base64):
-- CQMWBXBhaXJzEF9jaGFuZ2VMaXN0ZW5lcnMEdGFzawVzcGF3bgZ1cGRhdGUTX251bUNoYW5nZUxpc3RlbmVycwhvbkNoYW5nZQR0eXBlBVN0YXRlBGtpbmQIT2JzZXJ2ZXINZGVwZW5kZW5jeVNldAxkZXBlbmRlbnRTZXQMc2V0bWV0YXRhYmxlBnNjcmlwdAZQYXJlbnQHcmVxdWlyZQhQdWJUeXBlcwVUeXBlcwxEZXBlbmRlbmNpZXMOaW5pdERlcGVuZGVuY3kHX19pbmRleAAFCAEAAAAADqQBAQAAAABATQIAfgIAAACfAQIEFwEEAKQGBQAAEDCAUgcFAJ8GAgFuAfv/AgAAAKkBAACCAQIABgMBBAAAAEADAgMDAwQEABAwgAAaBQEYAAAAAAAAAQAAAP8AAwAbAAAAAAMABAAAABv7AAAADgABAIIAAQCpAAEA3gAAAPsAAQBNAAB+AAAAAPsBAgDGAgAAagIAAfsAAQBNAQDBAQAAAHgBAQIwAQDBAQAAAPsAAQBNAADBAQAAAA0ABQADAACA+wADAPsBAQDGAgAAagIAAYIAAQAEAwIDBgIAAAAAAADwPwIAAAAAAAAAAAAzAAEYAAABAgABAAAAAAABAAAAAAACAAAAAAIAAAACNAAAAAAFAgEAAAcEAAAFAgQFFf8CAAAAAAAATQMAwQAAAACVAwMBMAMAwQAAAABNAwB+AgAAAGoBAwL7AwAAqQQBAGoEAwCpAwAA2QQAABIBA/8SAAAAEgACABICAADBAwAAggQCAAMDBgIAAAAAAADwPwMCAQEpBwEYAAACAAAAAAEAAAMAAAIBAAAAAAAAKgAAAAAFAQIAAAAd4gIJAP8DAQAAAAAAqQQBAGoEAwAwAwIfBAAAAP8DAAAAAAAAMAMCYQUAAAD/AwAAAAAAADADAn4GAAAA+wMAAJ49AgMDAAAApAELAAAAoECfAQMC+wIBAFIDAQCfAgIBTQIAYQUAAACpAwEAagMCAYIBAgAMAwgDCQMKAwsDDAMNAwIDBgIAAAAAAAAAAAgGAAEAAAACAwAAAAT/////Bf////8G/////wcIAAAAAw4EAACgQABCCwEYAAMAAAAAAAEAAAABAAAAAgAA+QAACQAAAgAAAAJDAAAAAAgAAAECACqjAAAApAABAAAAAEBNAAAkAgAAAE0AACQCAAAApAEEAAAAMEBNAgCnBQAAAJ8BAgKkAgQAAAAwQE0DAO8GAAAAnwICAqQDBAAAADBATQQA7AcAAABNBASwCAAAAJ8DAgL/BAIAAAAAAOIFCgAwBAVuCQAAAP8GAAAAAAAAwAcLADAHBMYMAAAAwAcNABIABgAwBwRZDgAAAMAHDwASAAUAEgADAIIHAgAQAw8EAAAAQAMQAxEEAAAwQAMSAxMDFAMVAxYFAQkGAAMFBgIDBwYDAwACAwEAARgACQAAAAAAAQAAAAABAAAAAAEAAAAAAAAEAAEAAAMABQAADwAAABkAABEBAAAAAASocx0GLEnbZ0UkMP3IlyVF2GsKcpq3dwc=

-- https://lua.expert/
local v1 = script.Parent.Parent

require(v1.PubTypes)
require(v1.Types)

local initDependency = require(v1.Dependencies.initDependency)
local t = {}
local t2 = {
	__index = t
}
local t3 = {}

function t.update(p1) --[[ update | Line: 26 ]]
	for k, v in pairs(p1._changeListeners) do
		task.spawn(v)
	end

	return false
end
function t.onChange(p1, p2) --[[ onChange | Line: 41 | Upvalues: t3 (copy) ]]
	local t = {}

	p1._numChangeListeners = p1._numChangeListeners + 1
	p1._changeListeners[t] = p2
	t3[p1] = true

	local v1 = false

	return function() --[[ Line: 51 | Upvalues: v1 (ref), p1 (copy), t (copy), t3 (ref) ]]
		if v1 then
			return
		end

		v1 = true
		p1._changeListeners[t] = nil

		local v12 = p1

		v12._numChangeListeners = v12._numChangeListeners - 1

		if p1._numChangeListeners ~= 0 then
			return
		end

		t3[p1] = nil
	end
end

return function(p1) --[[ Observer | Line: 66 | Upvalues: t2 (copy), initDependency (copy) ]]
	local v2 = setmetatable({
		type = "State",
		kind = "Observer",
		_numChangeListeners = 0,
		dependencySet = {
			[p1] = true
		},
		dependentSet = {},
		_changeListeners = {}
	}, t2)

	initDependency(v2)
	p1.dependentSet[v2] = true

	return v2
end