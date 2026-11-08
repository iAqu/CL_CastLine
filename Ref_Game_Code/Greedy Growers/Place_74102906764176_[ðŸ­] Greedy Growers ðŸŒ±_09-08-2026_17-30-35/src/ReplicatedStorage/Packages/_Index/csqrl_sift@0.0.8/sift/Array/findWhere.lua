-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Bytecode (Base64):
-- CQMDBHR5cGUGbnVtYmVyCWZpbmRXaGVyZQACCwMAAAAIBQAABQMEBYIcHAMAALsoAgNSBQIApAQBAAAAAECfBAIC8AQHAAIAAICMBAEAYAIFAAQAAABDAgMCZQACAGUAAQCMAgEAUgYCABwEAACMBQEAqAQIAFIHAQCHCAAGUgkGAFIKAACfBwQCDgcBAIIGAgCLBPj/ggABAAMDAQQAAABAAwIAFQMBGAACAAAAAAAAAAAAAAAAAAIAAAABAAAAAAAB/gYaAAAAAAEAAAECAAOjAAAAwAAAAIIAAgABBgABAAEAARgAFBIBAAAAAAE=

-- https://lua.expert/
return function(p1, p2, p3) --[[ findWhere | Line: 21 ]]
	local v1 = #p1

	if type(p3) == "number" then
		if p3 < 1 then
			p3 = v1 + p3
		end
	else
		p3 = 1
	end

	for i = p3, #p1 do
		if p2(p1[i], i, p1) then
			return i
		end
	end
end