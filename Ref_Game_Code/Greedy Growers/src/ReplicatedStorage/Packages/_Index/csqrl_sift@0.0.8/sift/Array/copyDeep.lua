-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Bytecode (Base64):
-- CQMEBXRhYmxlBWNsb25lBHR5cGUIY29weURlZXAAAgkBAQAABgMAAAUBBBakAQIAAAQAgFICAACfAQICUgIAAMYDAADGBAAAZAILALsoBgNSCAYApAcEAAAAMECfBwIC8AcFAAAAAID7BwAAUggGAJ8HAgJqBwEFbgL0/wIAAACCAQIABQMBAwIEAAQAgAMDBAAAMEAAFAQBGAAAAAACAAAAAQAAAAAAAAEAAAD+AAYVAAAAAAEAAAECAASjAAAAwAAAABIAAACCAAIAAQYAAQABAAEYABMADAEAAAAAAQ==

-- https://lua.expert/
local function v1(p1) --[[ copyDeep | Line: 20 | Upvalues: v1 (copy) ]]
	local v12 = table.clone(p1)

	for v2, v3 in p1 do
		if type(v3) == "table" then
			v12[v2] = v1(v3)
		end
	end

	return v12
end

return v1