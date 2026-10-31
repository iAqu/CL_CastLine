-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

require(script.Parent.Parent.data.__typeHeader)

local v1 = table.freeze({})
local t1 = {
    leftBisect = function(p1, p2) -- line: 10
        local v2 = #p1

        if p2 <= p1[1].time then
            return 1
        end

        if p1[v2].time <= p2 then
            return v2
        end

        local n1 = 1

        while n1 < v2 do
            local v4 = math.floor((n1 + v2) / 2)

            if p1[v4].time < p2 then
                n1 = v4 + 1
            else
                v2 = v4
            end
        end

        return n1 - 1
    end
}

t1.rangeSearch = function(p3, p4, p5) -- line: 35
    -- upvalues: v1 (copy), t1 (copy)
    if not p3[1] then
        return v1
    end

    local v5 = math.max(p4, p5)
    local v6 = math.min(p4, p5)
    local t2 = {}
    local v7 = t1.leftBisect(p3, v6)

    if p3[v7].time < v6 then
        v7 += 1
    end

    while v7 <= #p3 and p3[v7].time < v5 do
        table.insert(t2, v7)
        v7 += 1
    end

    return t2
end

t1.clampedBoundedBisect = function(p6, p7) -- line: 70
    local v8 = #p6

    if p7 <= p6[1].time then
        return 0, 1, 1
    end

    if p6[v8].time <= p7 then
        return 0, v8, v8
    end

    local n2 = 1
    local v9

    while true do
        if n2 <= v8 then
            v9 = (n2 + v8) // 2

            if p6[v9].time == p7 then
                break
            end

            local v10, v11

            if p6[v9].time < p7 then
                v11 = v8
                v10 = v9 + 1
            else
                v10 = n2
                v11 = v9 - 1
            end

            n2 = v10
            v8 = v11
            continue
        end

        local time = p6[n2 - 1].time
        local time2 = p6[n2].time

        return (p7 - time) / (time2 - time), n2 - 1, n2
    end

    return 0, v9, v9 + 1
end

return t1
