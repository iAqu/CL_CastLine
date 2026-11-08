-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local v1 = table.freeze({
    ["0"] = "\000",
    ["1"] = "\001",
    ["2"] = "\002",
    ["3"] = "\003",
    ["4"] = "\004",
    ["5"] = "\005",
    ["6"] = "\006",
    ["7"] = "\007",
    ["8"] = "\008",
    ["9"] = "\t"
})
local t1 = {
    from_double = function(p1) -- from_double | line: 15
        -- upvalues: v1 (copy)
        local v2, v3, v4 = string.match(tostring(p1), "^(%d+)%.?(%d*)e?([+-]?%d*)$")
        local v5, v6 = string.match(v2 .. v3, "^0*(%d-)(0*)$")
        local t2 = { string.byte(string.gsub(v5, ".", v1), 1, -1) }

        return t2, #t2, (tonumber(v4) or 0) - #v3 + #v6
    end
}

return table.freeze(t1)
