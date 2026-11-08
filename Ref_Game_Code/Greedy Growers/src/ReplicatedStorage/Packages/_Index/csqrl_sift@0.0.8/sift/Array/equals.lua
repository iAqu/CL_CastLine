-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Bytecode (Base64):
-- CQMLBHR5cGUFdGFibGUHY29tcGFyZQxlcXVhbE9iamVjdHMBIwZzZWxlY3QGZXF1YWxzBnNjcmlwdAZQYXJlbnQHcmVxdWlyZQRVdGlsAAMIAgAAAAAmuygAA1IDAACkAgEAAAAAQJ8CAgLwAggAAgAAgLsoAQNSAwEApAIBAAAAAECfAgIC8AIGAAIAAADxAAIAAQAAAKkCAAGpAgEAggICABwCAAAcAwEA8QMDAAIAAACpAwAAggMCAIwFAQBSAwIAjAQBAKgDBwCHBgAFhwcBBfEGAwAHAAAAqQYAAIIGAgCLA/n/qQMBAIIDAgADAwEEAAAAQAMCAAYDARgAAAAAAAAAAAAAAAAAAAEAAAAAAwIAAAEAAwAAAAEAAAABAP4GAAcAAAAACQACAQAAKaMAAAD7AAAATQAAuAAAAADdAQAAnwAAAg4AAgCpAAEAggACAG8BAQC7OQEDpAADAAAAIEDdAgAAnwAAAowCAQC7OQIDpAEDAAAAIEDdAwAAnwEAAowEAgBSAgAAjAMBAKgCDgC7OQQEpAUDAAAAIEBSBgQA3QcAAJ8FAAL7BgEAUgcBAFIIBQCfBgMCKwYCAKkGAACCBgIAiwLy/6kCAQCCAgIABAMEAwUDBgQAACBAACwHARgAAQAAAAAAAQADAAAAAAABAAAAAAACAAAAAQAAAAAAAgAAAAABAPwIACwAAAAABAAAAQIAEaMAAACkAAEAAAAAQE0AACQCAAAATQAAJAIAAACkAQQAAAAwQE0CAJ4FAAAAnwECAsACBgDAAwcAEgABABIAAgCCAwIACAMIBAAAAEADCQMKBAAAMEADCwYABgECAAEBAAEYAAEAAAAAAAIAAAAAAiYAABMBAAAAAAII5jCqAmzXkYKOqmnhxi9WeP4n3joiWqs=

-- https://lua.expert/
local Util = require(script.Parent.Parent.Util)

local function compare(p1, p2) --[[ compare | Line: 6 ]]
	if type(p1) == "table" and type(p2) == "table" then
		local v1 = #p1

		if #p2 ~= v1 then
			return false
		end

		for i = 1, v1 do
			if p1[i] ~= p2[i] then
				return false
			end
		end

		return true
	end

	return p1 == p2
end

return function(...) --[[ equals | Line: 44 | Upvalues: Util (copy), compare (copy) ]]
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