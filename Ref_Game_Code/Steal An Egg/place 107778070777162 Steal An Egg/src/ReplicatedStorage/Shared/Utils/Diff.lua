-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local function deepEquals(p1, p2) -- line: 8
    -- upvalues: deepEquals (copy)
    if p1 == p2 or p1 ~= p1 and p2 ~= p2 then
        return true
    end

    if type(p1) ~= "table" or type(p2) ~= "table" then
        return false
    end

    for v1, v2 in pairs(p1) do
        if not deepEquals(v2, p2[v1]) then
            return false
        end
    end

    for v3 in pairs(p2) do
        if p1[v3] == nil then
            return false
        end
    end

    return true
end

return function(p3, p4, p5) -- line: 27
    -- upvalues: deepEquals (copy)
    if type(p3) ~= "table" or type(p4) ~= "table" then
        return {}, {}
    end

    local SkipKeys = if p5 then p5.SkipKeys else nil
    local t1 = {}

    for v4, v5 in p4 do
        if not SkipKeys or not SkipKeys[v4] then
            local v7 = p3[v4]

            if v7 ~= v5 and (typeof(v5) ~= typeof(v7) or type(v5) ~= "table" or not deepEquals(v5, v7)) then
                t1[v4] = v5
            end
        end
    end

    local t2 = {}

    for v8 in p3 do
        if (not SkipKeys or not SkipKeys[v8]) and p4[v8] == nil then
            t2[v8] = true
        end
    end

    return t1, t2
end
