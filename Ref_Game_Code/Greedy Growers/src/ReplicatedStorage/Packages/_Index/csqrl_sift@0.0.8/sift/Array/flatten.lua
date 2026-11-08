-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Bytecode (Base64):
-- CQMGBHR5cGUGbnVtYmVyBmlwYWlycwV0YWJsZQZpbnNlcnQHZmxhdHRlbgACEQIBAAAHBAAABQIEgje7KAEDUgMBAKQCAQAAAABAnwICAvACAgACAACAZQABAG8BAwD/AgAAAAAAAKQDBQAAAEBAUgQAAJ8DAgRRAyQAuygHA1IJBwCkCAEAAAAAQJ8IAgLwCBcABgAAgIwIAABgCBQAAQAAAPsIAABSCQcAeAoBB58IAwKkCQUAAABAQFIKCACfCQIEUQkHAJ40AgUNAAAAUg8CAFIQDQCkDgkAACBggJ8OAwFuCfj/AgAAgGUABwCeNAIFBwAAAFIJAgBSCgcApAgJAAAgYICfCAMBbgPb/wIAAICCAgIACgMBBAAAAEADAgIAAAAAAADwfwMDBAAAQEADBAIAAAAAAADwPwMFBAAgYIAAGAYBGAAAAAAAAAAAAAIAAgAAAAABAAAAAAAAAAAAAQAAAAIAAAAAAQAAAAAAAP8AAAQAAAAAAAD4AAwZAAAAAAEAAAECAASjAAAAwAAAABIAAACCAAIAAQYAAQABAAEYABcAFAEAAAAAAZ4mPHlzfWxF0ol6W4uer53uPisNrOJWeA==

-- https://lua.expert/
local function v1(p1, p2) --[[ flatten | Line: 24 | Upvalues: v1 (copy) ]]
	if type(p2) ~= "number" then
		p2 = (1 / 0)
	end

	local t = {}

	for i, v in ipairs(p1) do
		if type(v) == "table" and p2 > 0 then
			for i2, v2 in ipairs((v1(v, p2 - 1))) do
				table.insert(t, v2)
			end

			continue
		end

		table.insert(t, v)
	end

	return t
end

return v1