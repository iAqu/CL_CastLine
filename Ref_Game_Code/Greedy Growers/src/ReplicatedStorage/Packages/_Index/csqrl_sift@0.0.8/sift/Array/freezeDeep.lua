-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Bytecode (Base64):
-- CQMFBHR5cGUFdGFibGUGaW5zZXJ0BmZyZWV6ZQpmcmVlemVEZWVwAAIKAQEAAAYDAAAFAQQk/wEAAAAAAACMBAEAHAIAAIwDAQCoAhkAhwUABLsoBQNSBwUApAYBAAAAAECfBgIC8AYKAAIAAIBSBwEA+wgAAFIJBQCfCAIATDQAAqQGBAAADCCAnwYAAWUABwCeNAEFBQAAAFIHAQBSCAUApAYEAAAMIICfBgMBiwLn/6QCBgAAFCCAUgMBAJ8CAgGCAQIABwMBBAAAAEADAgMDBAAMIIADBAQAFCCAABUFARgAAAIAAAABAgAAAAAAAAEAAAAAAAAAAAIAAAAAAAD6CgAAAAIWAAAAAAEAAAECAASjAAAAwAAAABIAAACCAAIAAQYAAQABAAEYABQAEgEAAAAAATqQBKdj0CKduwgXGgvojdFKiBPTCFRupg==

-- https://lua.expert/
local function v1(p1) --[[ freezeDeep | Line: 21 | Upvalues: v1 (copy) ]]
	local t = {}

	for i = 1, #p1 do
		local v12 = p1[i]

		if type(v12) == "table" then
			table.insert(t, v1(v12))

			continue
		end

		table.insert(t, v12)
	end

	table.freeze(t)

	return t
end

return v1