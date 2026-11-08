-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Bytecode (Base64):
-- CQMIBmlwYWlycwV0YWJsZQZpbnNlcnQMcmVtb3ZlVmFsdWVzB3JlcXVpcmUGc2NyaXB0BlBhcmVudAV0b1NldAACCwEBAQAGAwAABQEEG6MBAAD7AQAA/wIAAAAAAADdAwAAxQIDAAEAAACfAQIC/wIAAAAAAACkAwEAAAAAQFIEAACfAwIEUQMJAIcIAQcrCAcAnjQCBQcAAABSCQIAUgoHAKQIBAAADCCAnwgDAW4D9v8CAACAggICAAUDAQQAAABAAwIDAwQADCCAABQEARgAAQAAAAAAAAEAAgAAAAABAAEAAAAAAAD+AAYUAAAAAAIAAAECAA2jAAAApAABAAAAAECkAQMAAAAgQE0BASQEAAAATQEBvgUAAACfAAICwAEGABIAAACCAQIABwMFBAAAAEADBgQAACBAAwcDCAYAAQABAAEYAAEAAAAAAAAAABIADQEAAAAAAVQCVtRZePc88w90iIOWDcokGkGgZsY81Q==

-- https://lua.expert/
local toSet = require(script.Parent.toSet)

return function(p1, ...) --[[ removeValues | Line: 20 | Upvalues: toSet (copy) ]]
	local v1 = toSet({ ... })
	local t = {}

	for i, v in ipairs(p1) do
		if not v1[v] then
			table.insert(t, v)
		end
	end

	return t
end