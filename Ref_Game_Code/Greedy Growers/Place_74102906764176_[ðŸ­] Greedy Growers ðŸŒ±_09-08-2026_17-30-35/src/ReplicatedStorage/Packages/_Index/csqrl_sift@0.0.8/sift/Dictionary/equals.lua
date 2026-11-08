-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Bytecode (Base64):
-- CQMNBHR5cGUFdGFibGUFcGFpcnMHY29tcGFyZQxlcXVhbE9iamVjdHMBIwZzZWxlY3QGZXF1YWxzBnNjcmlwdAZQYXJlbnQHcmVxdWlyZQRVdGlsBVR5cGVzAAMIAgAAAAAtuygAA1IDAACkAgEAAAAAQJ8CAgLwAggAAgAAgLsoAQNSAwEApAIBAAAAAECfAgIC8AIGAAIAAADxAAIAAQAAAKkCAAGpAgEAggICAKQCBAAAADBAUgMAAJ8CAgQXAgUAhwcBBfEHAwAGAAAAqQcAAIIHAgBuAvr/AgAAAKQCBAAAADBAUgMBAJ8CAgQXAgUAhwcABfEHAwAGAAAAqQcAAIIHAgBuAvr/AgAAAKkCAQCCAgIABQMBBAAAAEADAgMDBAAAMEAABwQBGAAAAAAAAAAAAAAAAAAAAQAAAAADAAAAAAEAAAEA/gAGAAAAAAEAAAEA/gAGAAgAAAAACQACAQAAKaMAAAD7AAAATQAAuAAAAADdAQAAnwAAAg4AAgCpAAEAggACAG8BAQC7OQEDpAADAAAAIEDdAgAAnwAAAowCAQC7OQIDpAEDAAAAIEDdAwAAnwEAAowEAgBSAgAAjAMBAKgCDgC7OQQEpAUDAAAAIEBSBgQA3QcAAJ8FAAL7BgEAUgcBAFIIBQCfBgMCKwYCAKkGAACCBgIAiwLy/6kCAQCCAgIABAMFAwYDBwQAACBAAC0IARgAAQAAAAAAAQADAAAAAAABAAAAAAACAAAAAQAAAAAAAgAAAAABAPwIAC0AAAAABQAAAQIAFqMAAACkAAEAAAAAQE0AACQCAAAATQAAJAIAAACkAQQAAAAwQE0CAJ4FAAAAnwECAqQCBAAAADBATQMA7wYAAACfAgICwAMHAMAECAASAAEAEgADAIIEAgAJAwkEAAAAQAMKAwsEAAAwQAMMAw0GAAYBAgABAQABGAABAAAAAAACAAAAAAEAAAAAAiYAABMBAAAAAAJcU8jfqZeHpMOMWhku0Hg2LEvfq26Xot4=

-- https://lua.expert/
local v1 = script.Parent.Parent
local Util = require(v1.Util)

require(v1.Types)

local function compare(p1, p2) --[[ compare | Line: 7 ]]
	if type(p1) == "table" and type(p2) == "table" then
		for k, v in pairs(p1) do
			if p2[k] ~= v then
				return false
			end
		end

		for k, v in pairs(p2) do
			if p1[k] ~= v then
				return false
			end
		end

		return true
	end

	return p1 == p2
end

return function(...) --[[ equals | Line: 45 | Upvalues: Util (copy), compare (copy) ]]
	if Util.equalObjects(...) then
		return true
	end

	local v1 = select("#", ...)
	local v2 = select(1, ...)

	for i = 2, v1 do
		if not compare(v2, (select(i, ...))) then
			return false
		end
	end

	return true
end