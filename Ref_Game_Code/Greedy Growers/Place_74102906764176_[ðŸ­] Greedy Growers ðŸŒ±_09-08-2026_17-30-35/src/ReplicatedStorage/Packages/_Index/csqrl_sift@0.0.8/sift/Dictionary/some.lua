-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Bytecode (Base64):
-- CQMCBXBhaXJzBHNvbWUAAgsCAAAABwQAAAUCBAURpAIBAAAAAEBSAwAAnwICBBcCCABSBwEAUggGAFIJBQBSCgAAnwcEAg4HAgCpBwEAggcCAG4C9/8CAAAAqQIAAIICAgACAwEEAAAAQAAYAgEYAAAAAAABAAAAAAABAP4ABgAcAAAAAAEAAAECAAOjAAAAwAAAAIIAAgABBgABAAEAARgAFw0BAAAAAAE=

-- https://lua.expert/
return function(p1, p2) --[[ some | Line: 24 ]]
	for k, v in pairs(p1) do
		if p2(v, k, p1) then
			return true
		end
	end

	return false
end