-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

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
local t1 = {
    AssertCompress = v2,
    AssertMethod = v1,
    AssertParams = v3,
    Execute = function(p1) -- Execute | line: 75
        -- upvalues: HttpService (copy), v3 (copy)
        v3(p1)

        local v4 = p1.Headers or {}

        if p1.NoCache then
            v4 = table.clone(v4)
            v4["Cache-Control"] = "no-cache, no-store, must-revalidate"
            v4.Pragma = "no-cache"
            v4.Expires = "0"
        end

        local t2 = {
            Url = p1.Url,
            Method = p1.Method,
            Headers = v4,
            Body = p1.Body,
            Compress = p1.Compress
        }
        local RequestAsync = HttpService.RequestAsync
        local ok, result = pcall(RequestAsync, HttpService, t2)

        if ok then
            return result
        end

        return {
            Success = false,
            StatusCode = 400,
            StatusMessage = tostring(result),
            Headers = {}
        }
    end
}

return table.freeze(t1)
