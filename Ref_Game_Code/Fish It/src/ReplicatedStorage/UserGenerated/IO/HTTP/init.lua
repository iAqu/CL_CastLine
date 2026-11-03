-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local HttpService = game:GetService("HttpService")
local Asserts = require(game.ReplicatedStorage.UserGenerated.Lang.Asserts)
local v1 = Asserts.Set({ "GET", "HEAD", "POST", "PUT", "DELETE", "OPTIONS", "TRACE", "PATCH" })
local v2 = Asserts.Optional(Asserts.Enum(Enum.HttpCompression))
local v3 = Asserts.Table({
	Url = Asserts.String,
	Method = v1,
	Headers = Asserts.Optional(Asserts.Map(Asserts.String, Asserts.String)),
	Body = Asserts.Optional(Asserts.RawString),
	Compress = v2,
	NoCache = Asserts.Optional(Asserts.Boolean)
})
return table.freeze({
	AssertCompress = v2,
	AssertMethod = v1,
	AssertParams = v3,
	Execute = function(p1) --[[ Execute | Line: 69 | Upvalues: v3 (copy), HttpService (copy) ]]
		v3(p1)
		local v1 = p1.Headers or {}
		if p1.NoCache then
			local v2 = table.clone(v1)
			v2["Cache-Control"] = "no-cache, no-store, must-revalidate"
			v2.Pragma = "no-cache"
			v2.Expires = "0"
			v1 = v2
		end
		local v32, v4 = pcall(HttpService.RequestAsync, HttpService, {
			Url = p1.Url,
			Method = p1.Method,
			Headers = v1,
			Body = p1.Body,
			Compress = p1.Compress
		})
		if v32 then
			return v4
		else
			return {
				Success = false,
				StatusCode = 400,
				StatusMessage = tostring(v4),
				Headers = {}
			}
		end
	end
})