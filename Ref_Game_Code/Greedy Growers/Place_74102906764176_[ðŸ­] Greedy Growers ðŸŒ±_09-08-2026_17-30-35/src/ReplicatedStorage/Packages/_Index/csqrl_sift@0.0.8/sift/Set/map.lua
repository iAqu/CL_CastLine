-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Bytecode (Base64):
-- CQMCBXBhaXJzA21hcAACCwIAAAAHBAAABQIEBRL/AgAAAAAAAKQDAQAAAABAUgQAAJ8DAgQXAwgAUggBAFIJBgBSCgAAnwgDAkcIAwAAAAAAqQkBAGoJAghuA/f/AgAAAIICAgACAwEEAAAAQAAUAgEYAAACAAAAAAEAAAACAAEA/AAIFQAAAAABAAABAgADowAAAMAAAACCAAIAAQYAAQABAAEYABMOAQAAAAAB

-- https://lua.expert/
return function(p1, p2) --[[ map | Line: 20 ]]
	local t = {}

	for k, v in pairs(p1) do
		local v1 = p2(k, p1)

		if v1 ~= nil then
			t[v1] = true
		end
	end

	return t
end