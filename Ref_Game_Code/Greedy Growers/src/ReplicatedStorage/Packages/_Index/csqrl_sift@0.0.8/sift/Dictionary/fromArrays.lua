-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Bytecode (Base64):
-- CQMBCmZyb21BcnJheXMAAgkCAAAACwQAAQUCBAQHBwkBDBwCAAD/AwAAAAAAAIwGAQBSBAIAjAUBAKgEBACHBwAGhwgBBmoIAweLBPz/ggMCAAAAFAEBGAABAAIAAAABAAD/BBUAAAAAAQAAAQIAA6MAAADAAAAAggACAAEGAAEAAQABGAATCwEAAAAAAQ==

-- https://lua.expert/
return function(p1, p2) --[[ fromArrays | Line: 20 ]]
	local t = {}

	for i = 1, #p1 do
		t[p1[i]] = p2[i]
	end

	return t
end