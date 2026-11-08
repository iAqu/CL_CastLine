-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Stringify = require(game.ReplicatedStorage.UserGenerated.Strings.Stringify)
local DeepEquals = require(game.ReplicatedStorage.UserGenerated.Collections.DeepEquals)

local function Equals(p1, p2) -- line: 21
    if rawequal(p1, p2) then
        return true
    end

    return not (type(p1) == "table" and type(p2) == "table") and p1 ~= p1 and p2 ~= p2
end

local function StripErrorSource(p3) -- line: 35
    local v1 = tostring(p3)
    local v2, v3 = string.match(v1, "^(.*:%d+): (.+)$")

    return v2 and v3 or v1
end

local function ToString(p4) -- line: 45
    -- upvalues: Stringify (copy)
    return Stringify.Pretty(p4, {
        Pretty = false,
        IndentChar = "",
        IndentSize = 0
    })
end

local t1 = {
    IsEqual = Equals
}

function t1.ErrorUnsafe(p5, p6, ...) -- line: 57
    local v4
    local pack = table.pack

    local function v5(p7) -- line: 59
        -- upvalues: v4 (ref)
        v4 = p7
    end

    local v6 = pack(xpcall(p6, v5, ...))

    if v6[1] then
        error("ExpectedError", 2)
    end

    if v4 ~= p5 then
        error(("ExpectedError Mismatch: %*"):format((string.format("%q", (tostring(v4))))), 2)
    end

    return table.unpack(v6, 2)
end

function t1.Error(p8, p9, ...) -- line: 72
    -- upvalues: Stringify (copy)
    local v8
    local pack = table.pack

    local function v9(p10) -- line: 74
        -- upvalues: v8 (ref)
        v8 = p10
    end

    local v10 = pack(xpcall(p9, v9, ...))

    if v10[1] then
        error(("ExpectedError(%*)"):format((Stringify.Pretty(p8, {
            Pretty = false,
            IndentChar = "",
            IndentSize = 0
        }))), 2)
    end

    if type(v8) == "string" then
        local v13 = tostring(v8)
        local v14, v15 = string.match(v13, "^(.*:%d+): (.+)$")

        v8 = v14 and v15 or v13
    end

    if p8 ~= v8 then
        local _error = error
        local v16 = Stringify.Pretty(p8, {
            Pretty = false,
            IndentChar = "",
            IndentSize = 0
        })
        local v17 = v8

        _error(("ExpectedError(%*): %*"):format(v16, (Stringify.Pretty(v17, {
            Pretty = false,
            IndentChar = "",
            IndentSize = 0
        }))), 2)
    end

    return table.unpack(v10, 2)
end

function t1.Equal(p11, p12) -- line: 90
    -- upvalues: Stringify (copy)
    if not rawequal(p11, p12) and not ((type(p11) ~= "table" or type(p12) ~= "table") and p11 ~= p11 and p12 ~= p12) then
        error(("Equal(%*, %*)"):format(Stringify.Pretty(p11, {
            Pretty = false,
            IndentChar = "",
            IndentSize = 0
        }), (Stringify.Pretty(p12, {
            Pretty = false,
            IndentChar = "",
            IndentSize = 0
        }))), 2)
    end
end

function t1.DeepEqual(p13, p14) -- line: 96
    -- upvalues: Stringify (copy), DeepEquals (copy)
    if not DeepEquals(p13, p14) then
        error(("DeepEqual(%*, %*)"):format(Stringify.Pretty(p13, {
            Pretty = false,
            IndentChar = "",
            IndentSize = 0
        }), (Stringify.Pretty(p14, {
            Pretty = false,
            IndentChar = "",
            IndentSize = 0
        }))), 2)
    end
end

function t1.FuzzyEqual(p15, p16, p17) -- line: 102
    if not ((p17 or 0.001) < math.abs(p15 - p16)) then
        return
    end

    error(("FuzzyEqual(%*, %*): %*"):format(tostring(p15), tostring(p16), (math.abs(p15 - p16))), 2)
end

function t1.ColorEqual(p18, p19, p20) -- line: 109
    -- upvalues: Stringify (copy)
    p20 = p20 or 0.001

    local v24 = Vector3.new(p18.R, p18.G, p18.B) * 255

    if p20 < (Vector3.new(p19.R, p19.G, p19.B) * 255 - v24).Magnitude then
        error(("ColorEqual(%*, %*)"):format(Stringify.Pretty(p18, {
            Pretty = false,
            IndentChar = "",
            IndentSize = 0
        }), (Stringify.Pretty(p19, {
            Pretty = false,
            IndentChar = "",
            IndentSize = 0
        }))), 2)
    end
end

return table.freeze(t1)
