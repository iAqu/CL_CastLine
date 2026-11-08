-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Bytecode (Base64):
-- CQMGBmlwYWlycwpyZW1vdmVLZXlzB3JlcXVpcmUGc2NyaXB0BlBhcmVudARjb3B5AAIIAQEBAAYDAAAFAQQSowEAAPsBAABSAgAAnwECAqQCAQAAAABA/wMAAAAAAADdBQAAxQMFAAEAAACfAgIEUQICAMYHAABqBwEGbgL9/wIAAICCAQIAAgMBBAAAAEAAFAIBGAABAAACAAAAAAAAAAABAP8ABBQAAAAAAgAAAQIADaMAAACkAAEAAAAAQKQBAwAAACBATQEBJAQAAABNAQEJBQAAAJ8AAgLAAQYAEgAAAIIBAgAHAwMEAAAAQAMEBAAAIEADBQMGBgABAAEAARgAAQAAAAAAAAAAEgAKAQAAAAABeeNHoeh3nFK7hkXbm0iUswn7UNVLJy2g

-- https://lua.expert/
local copy = require(script.Parent.copy)

return function(p1, ...) --[[ removeKeys | Line: 20 | Upvalues: copy (copy) ]]
	local v1 = copy(p1)

	for i, v in ipairs({ ... }) do
		v1[v] = nil
	end

	return v1
end