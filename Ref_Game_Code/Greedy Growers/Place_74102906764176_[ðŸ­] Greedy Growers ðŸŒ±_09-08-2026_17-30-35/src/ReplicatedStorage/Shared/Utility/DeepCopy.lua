-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Bytecode (Base64):
-- CQMCBnR5cGVvZgV0YWJsZQACEwEAAAAGAwAABQEERv8BAAAAAAAA/wIAAAAAAAD/AwAAAAAAAFIEAADGBQAAxgYAAGQECgAcCgMAlQkKAP8KAAADAAAAUgsBAFIMBwBSDQgAxQoLBAEAAABqCgMJbgT1/wIAAAAcBAMAjAUAAGAFLAAEAAAAHAUDAIcEAwUTBQQAEwYEARMHBAIcCAMAxgkAAGoJAwi7LAcDUgkHAKQIAgAAABBAnwgCAvAIAwADAAAAagcFBmUAGQCHCAIHDggDAIcIAgdqCAUGZQAUAP8IAAAAAAAAaggCB2oIBQZSCQcAxgoAAMYLAABkCQoAHA8DAJUODwD/DwAAAwAAAFIQCABSEQwAUhINAMUPEAQBAAAAag8DDm4J9f8CAAAASADR/4IBAgAEAgAAAAAAAPA/AwEEAAAQQAMCAAMAARgAAAEAAQABAAAAAQAAAAAAAAAAAP8ABAAAAAEAAQEBAQAAAQAAAAAAAAEAAQABAAACAAEBAQAAAAEAAAAAAAAAAAD/APITBAAAAAABAAABAgADowAAAMAAAACCAAIAAQYAAQABAAEYAAIAAQAAAAABT0k5dkQDMQjoLWSzvywmmj9RLgJ9jVN3

-- https://lua.expert/
return function(p1) --[[ Line: 3 ]]
	local t = {}
	local t2 = {}
	local t3 = {}

	for v1, v2 in p1 do
		t[#t + 1] = { t2, v1, v2 }
	end

	while #t > 0 do
		local v3 = t[#t]
		local v4 = v3[1]
		local v5 = v3[2]
		local v6 = v3[3]

		t[#t] = nil

		if typeof(v6) == "table" then
			if t3[v6] then
				v4[v5] = t3[v6]

				continue
			end

			local t4 = {}

			t3[v6] = t4
			v4[v5] = t4

			for v7, v8 in v6 do
				t[#t + 1] = { t4, v7, v8 }
			end

			continue
		end

		v4[v5] = v6
	end

	return t2
end