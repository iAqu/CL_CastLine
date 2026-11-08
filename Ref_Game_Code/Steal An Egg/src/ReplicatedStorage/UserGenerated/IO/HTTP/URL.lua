-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local HttpService = game:GetService("HttpService")
local Keys = require(game.ReplicatedStorage.UserGenerated.Lang.Keys)
local Asserts = require(game.ReplicatedStorage.UserGenerated.Lang.Asserts)
local JSONEncoder = require(game.ReplicatedStorage.UserGenerated.IO.JSONEncoder)
local t1 = {
    http = 80,
    https = 443
}
local v1 = Asserts.Optional(Asserts.Set(Keys(t1)))
local String = Asserts.String
local v2 = Asserts.Optional(Asserts.IntegerRange(0, 65535))

local function v3(p1) -- line: 34
    if type(p1) ~= "string" then
        error("string", 2)
    end

    if not utf8.len(p1) then
        error("UTF8", 2)
    end

    if #p1 > 0 and string.byte(p1, 1) ~= 47 then
        error("PathPrefix", 2)
    end

    return p1
end

local v4 = Asserts.Map(Asserts.String, Asserts.Any)
local v5 = Asserts.Table({
    Protocol = v1,
    Host = String,
    Port = v2,
    Path = v3,
    Params = Asserts.Optional(v4),
    Fragment = Asserts.Optional(Asserts.String)
})
local t2 = {
    AssertProtocol = v1,
    AssertHost = String,
    AssertPort = v2,
    AssertPath = v3,
    AssertEncodeParams = v4,
    AssertParams = v5,
    EncodePath = function(p2) -- EncodePath | line: 77
        -- upvalues: HttpService (copy), Asserts (copy)
        Asserts.String(p2)

        return (p2:gsub("([^/]+)", function(p3) -- line: 79
            -- upvalues: HttpService (copy)
            return HttpService:UrlEncode(p3)
        end))
    end,
    EncodeParams = function(p4) -- EncodeParams | line: 85
        -- upvalues: HttpService (copy), Keys (copy), JSONEncoder (copy), v4 (copy)
        v4(p4)

        local v6 = Keys(p4)

        table.sort(v6)

        local t3 = {}

        for _, v7 in ipairs(v6) do
            local v8 = JSONEncoder.Compact(p4[v7])

            table.insert(t3, HttpService:UrlEncode(v7) .. "=" .. HttpService:UrlEncode(v8))
        end

        return table.concat(t3, "&")
    end
}

function t2.Build(p5) -- line: 97
    -- upvalues: HttpService (copy), t1 (copy), v5 (copy), t2 (copy)
    v5(p5)

    local v10 = p5.Protocol or "https"
    local v11 = t1[v10] or 80
    local v12 = p5.Port or v11
    local t4 = {}

    table.insert(t4, v10)
    table.insert(t4, "://")
    table.insert(t4, p5.Host)

    if v12 ~= v11 then
        table.insert(t4, ":")
        table.insert(t4, (tostring(v12)))
    end

    table.insert(t4, t2.EncodePath(p5.Path))

    local Params = p5.Params

    if Params and next(Params) ~= nil then
        table.insert(t4, "?")
        table.insert(t4, t2.EncodeParams(Params))
    end

    if p5.Fragment then
        table.insert(t4, "#")
        table.insert(t4, HttpService:UrlEncode(p5.Fragment))
    end

    return table.concat(t4)
end

return table.freeze(t2)
