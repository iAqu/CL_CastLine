-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Bytecode (Base64):
-- CQMFBXRhYmxlBWNsb25lBXBhaXJzBHR5cGUIY29weURlZXAAAgkBAQAAABekAQIAAAQAgFICAACfAQICpAIEAAAAMEBSAwAAnwICBBcCCwC7KAYDUggGAKQHBgAAAFBAnwcCAvAHBQAAAACA+wcAAFIIBgCfBwICagcBBW4C9P8CAAAAggECAAcDAQMCBAAEAIADAwQAADBAAwQEAABQQAAUBQEYAAAAAAIAAAAAAQAAAAAAAAEAAAD+AAYVAAAAAAEAAAECAASjAAAAwAAAABIAAACCAAIAAQYAAQABAAEYABMADAEAAAAAAQ==

-- https://lua.expert/
local function v1(p1) --[[ copyDeep | Line: 20 | Upvalues: v1 (copy) ]]
	local v12 = table.clone(p1)

	for k, v in pairs(p1) do
		if type(v) == "table" then
			v12[k] = v1(v)
		end
	end

	return v12
end

return v1