-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TrimmedNumberString = require(ReplicatedStorage.UserGenerated.Strings.TrimmedNumberString)

local function Commas(p1) -- line: 35
    -- upvalues: TrimmedNumberString (copy)
    local v1 = if type(p1) == "string" then p1 else TrimmedNumberString(p1)
    local v2, v3, v4 = string.match(v1, "^(.-)([0-9,]+)(.*)$")

    if not v3 then
        return v1
    end

    local t1 = {}

    if v2 then
        table.insert(t1, v2)
    end

    local v5 = string.gsub(v3, ",", "")
    local v6 = #v5 % 3
    local v7 = 1

    if v6 > 0 then
        table.insert(t1, (string.sub(v5, 1, 1 + v6 - 1)))
        v7 = 1 + v6
    end

    while v7 <= #v5 do
        if v7 > 1 then
            table.insert(t1, ",")
        end

        table.insert(t1, (string.sub(v5, v7, v7 + 2)))
        v7 += 3
    end

    if v4 then
        table.insert(t1, v4)
    end

    return table.concat(t1)
end

return Commas
