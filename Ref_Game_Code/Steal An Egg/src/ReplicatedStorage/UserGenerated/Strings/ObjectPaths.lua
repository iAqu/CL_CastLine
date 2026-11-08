-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local t1 = {
    QueryObject = function(p1, p2, p3) -- QueryObject | line: 29
        for _, v2 in ipairs(string.split(p2, ".")) do
            if p1 == nil then
                return false
            end

            if p1 == p3 then
                return true
            end

            if type(p1) ~= "table" then
                return false
            end

            p1 = p1[v2]
        end

        if p1 == nil then
            return false
        end

        if p1 == p3 then
            return true
        end

        return true, p1
    end,
    HasHierarchicalOverlap = function(p4, p5) -- HasHierarchicalOverlap | line: 57
        if p4 == p5 then
            return true
        end

        local v3 = string.split(p4, ".")
        local v4 = string.split(p5, ".")

        for i = 1, math.min(#v3, #v4) do
            if v3[i] ~= v4[i] then
                return false
            end
        end

        return true
    end
}

return table.freeze(t1)
