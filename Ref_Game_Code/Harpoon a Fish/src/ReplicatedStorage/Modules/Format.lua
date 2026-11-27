-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Loc = require(script.Parent:WaitForChild("Loc"))
local t2 = { "K", "M", "B", "T", "Qa", "Qi", "Sx", "Sp" }
local t1 = {}

function t1.short(p1) -- line: 15
    -- upvalues: t2 (copy)
    if p1 < 1000 then
        return (tostring((math.floor(p1))))
    end

    local v2 = p1
    local n1 = 0

    while v2 >= 1000 and n1 < #t2 do
        v2 /= 1000
        n1 += 1
    end

    return string.format("%.1f", v2):gsub("%.0$", "") .. t2[n1]
end

function t1.money(p2) -- line: 24
    -- upvalues: t1 (copy)
    return "$" .. t1.short(p2)
end

function t1.kg(p3) -- line: 28
    local v3, v4 = string.format("%.1f", p3):match("^(%d+)%.(%d)$")

    return v3:reverse():gsub("(%d%d%d)", "%1,"):reverse():gsub("^,", "") .. (v4 ~= "0" and "." .. v4 or "") .. "Kg"
end

function t1.time(p4) -- line: 33
    -- upvalues: Loc (copy)
    local v6 = math.max(0, (math.floor(p4)))

    if v6 < 60 then
        return Loc.F("time.sec", "{s}s", {
            s = tostring(v6)
        })
    end

    if v6 < 3600 then
        return Loc.F("time.min_sec", "{m}m {s}s", {
            m = tostring((math.floor(v6 / 60))),
            s = string.format("%02d", v6 % 60)
        })
    end

    if v6 < 86400 then
        return Loc.F("time.hour_min", "{h}h {m}m", {
            h = tostring((math.floor(v6 / 3600))),
            m = string.format("%02d", math.floor(v6 / 60) % 60)
        })
    end

    return Loc.F("time.day_hour", "{d}d {h}h", {
        d = tostring((math.floor(v6 / 86400))),
        h = tostring(math.floor(v6 / 3600) % 24)
    })
end

return t1
