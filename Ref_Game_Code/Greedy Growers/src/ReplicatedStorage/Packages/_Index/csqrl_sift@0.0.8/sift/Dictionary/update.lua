-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Bytecode (Base64):
-- CQMIBHR5cGUIZnVuY3Rpb24EY2FsbAZ1cGRhdGUHcmVxdWlyZQZzY3JpcHQGUGFyZW50BGNvcHkAAwQCAAAABwQAAAUCBQ8MuygAA1IDAACkAgEAAAAAQJ8CAgLwAgUAAgAAgFICAABSAwEAnwICAIICAACCAAEAAwMBBAAAAEADAgAHAwEYAAAAAAAAAAEAAAACCAAAAAAIBAEAAAkGAAAFBAQPhYUc+wQAAFIFAACfBAIChwUEAUcFCAAAAAAADgIUAFIFAgCHBgQBUgcBAJ8FAwJqBQQBggQCAA4DDQC7KAMDUgcDAKQGAQAAAABAnwYCAvAGBQACAACAUgUDAFIGAQCfBQICZQABAMYFAABqBQQBggQCAAMDAQQAAABAAwIAJwQBGCUAAAIAAAEBAAAAAAAD1AAAAAAAAAEAAAAALAQIAAAAAAMAAAECAA6jAAAApAABAAAAAECkAQMAAAAgQE0BASQEAAAATQEBCQUAAACfAAICwAEGAMACBwASAAAAggICAAgDBQQAAABAAwYEAAAgQAMHAwgGAAYBAgABAQABGAABAAAAAAAAAAAFIAAVAQAAAAACZTNF0IXxd6deVdkU0VCzGxUrUqRX9y/R

-- https://lua.expert/
local copy = require(script.Parent.copy)

local function call(p1, p2) --[[ call | Line: 7 ]]
	if type(p1) == "function" then
		return p1(p2)
	end
end

return function(p1, p2, p3, p4) --[[ update | Line: 39 | Upvalues: copy (copy) ]]
	local v1 = copy(p1)

	if v1[p2] == nil then
		if p4 then
			v1[p2] = if type(p4) == "function" then p4(p2) else nil
		end
	elseif p3 then
		v1[p2] = p3(v1[p2], p2)

		return v1
	end

	return v1
end