-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Bytecode (Base64):
-- CQMNBHR5cGUFdGFibGUFcGFpcnMLY29tcGFyZURlZXAMZXF1YWxPYmplY3RzASMGc2VsZWN0CmVxdWFsc0RlZXAGc2NyaXB0BlBhcmVudAdyZXF1aXJlBFV0aWwFVHlwZXMAAwoCAQAAADG7KAADUgMAAKQCAQAAAABAnwICAvACCAACAACAuygBA1IDAQCkAgEAAAAAQJ8CAgLwAgYAAgAAAPEAAgABAAAAqQIAAakCAQCCAgIApAIEAAAAMEBSAwAAnwICBBcCBwD7BwAAUggGAIcJAQWfBwMCKwcCAKkHAACCBwIAbgL4/wIAAACkAgQAAAAwQFIDAQCfAgIEFwIHAPsHAABSCAYAhwkABZ8HAwIrBwIAqQcAAIIHAgBuAvj/AgAAAKkCAQCCAgIABQMBBAAAAEADAgMDBAAAMEAABwQBGAAAAAAAAAAAAAAAAAAAAQAAAAADAAAAAAEAAAAAAQD+AAYAAAAAAQAAAAABAP4ABgAIAAAAAAkAAgEAACmjAAAA+wAAAE0AALgAAAAA3QEAAJ8AAAIOAAIAqQABAIIAAgBvAQEAuzkBA6QAAwAAACBA3QIAAJ8AAAKMAgEAuzkCA6QBAwAAACBA3QMAAJ8BAAKMBAIAUgIAAIwDAQCoAg4AuzkEBKQFAwAAACBAUgYEAN0HAACfBQAC+wYBAFIHAQBSCAUAnwYDAisGAgCpBgAAggYCAIsC8v+pAgEAggICAAQDBQMGAwcEAAAgQAAtCAEYAAEAAAAAAAEAAwAAAAAAAQAAAAAAAgAAAAEAAAAAAAIAAAAAAQD8CAAtAAAAAAUAAAECABejAAAApAABAAAAAEBNAAAkAgAAAE0AACQCAAAApAEEAAAAMEBNAgCeBQAAAJ8BAgKkAgQAAAAwQE0DAO8GAAAAnwICAsADBwASAAMAwAQIABIAAQASAAMAggQCAAkDCQQAAABAAwoDCwQAADBAAwwDDQYABgECAAEBAAEYAAEAAAAAAAIAAAAAAQAAAAACACYAABMBAAAAAALPAmcQ2JpTL53rZbcTKxSuvxpwZP3GDRE=

-- https://lua.expert/
local v1 = script.Parent.Parent
local Util = require(v1.Util)

require(v1.Types)

local function v2(p1, p2) --[[ compareDeep | Line: 7 | Upvalues: v2 (copy) ]]
	if type(p1) == "table" and type(p2) == "table" then
		for k, v in pairs(p1) do
			if not v2(v, p2[k]) then
				return false
			end
		end

		for k, v in pairs(p2) do
			if not v2(v, p1[k]) then
				return false
			end
		end

		return true
	end

	return p1 == p2
end

return function(...) --[[ equalsDeep | Line: 45 | Upvalues: Util (copy), v2 (copy) ]]
	if Util.equalObjects(...) then
		return true
	end

	local v1 = select("#", ...)
	local v22 = select(1, ...)

	for i = 2, v1 do
		if not v2(v22, (select(i, ...))) then
			return false
		end
	end

	return true
end