-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local t1 = {
    s = 1,
    m = 60,
    h = 3600,
    d = 86400,
    w = 604800
}
local t2 = {
    perm = true,
    permanent = true,
    forever = true
}

local function parseDuration(p1) -- line: 17
    -- upvalues: t1 (copy), t2 (copy)
    if p1 == nil or p1 == "" then
        return nil
    end

    local v1 = string.lower(p1)

    if t2[v1] then
        return -1
    end

    if string.gsub(v1, "(%d+)([smhdw])", "") ~= "" then
        return nil
    end

    local n1 = 0

    for match, v2 in string.gmatch(v1, "(%d+)([smhdw])") do
        n1 += tonumber(match) * t1[v2]
    end

    return if not (n1 <= 0) and not (n1 > 3153600000) then n1 else nil
end

local t3 = {
    DisplayName = "Ban Duration"
}

function t3.Transform(p2) -- line: 47
    -- upvalues: parseDuration (copy)
    return p2, (parseDuration(p2))
end

function t3.Validate(_, p4) -- line: 51
    return p4 ~= nil, "Use a length like 30m, 12h, 7d, 2w, 1d12h, or perm."
end

function t3.Autocomplete(p5) -- line: 55
    local v3 = string.lower(p5)

    if not (#v3 > 0 and string.sub("permanent", 1, #v3) == v3) then
        return {}
    end

    return { "perm" }
end

function t3.Parse(_, p7) -- line: 63
    return p7
end

return function(p8) -- line: 68
    -- upvalues: t3 (copy)
    p8:RegisterType("banDuration", t3)
end
