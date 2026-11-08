-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Bytecode (Base64):
-- CQMCBXBhaXJzC3JlbW92ZVZhbHVlAAIIAgAAAAcEAAAFAgQPDf8CAAAAAAAApAMBAAAAAEBSBAAAnwMCBBcDAwDxBwIAAQAAAGoHAgZuA/z/AgAAAIICAgACAwEEAAAAQAATAgEYAAACAAAAAAEAAf4ABhQAAAAAAQAAAQIAA6MAAADAAAAAggACAAEGAAEAAQABGAASDAEAAAAAAQ==

-- https://lua.expert/
return function(p1, p2) --[[ removeValue | Line: 19 ]]
	local t = {}

	for k, v in pairs(p1) do
		if v ~= p2 then
			t[k] = v
		end
	end

	return t
end