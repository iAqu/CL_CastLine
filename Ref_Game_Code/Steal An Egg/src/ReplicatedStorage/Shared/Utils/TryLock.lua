-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local self = setmetatable({}, {
    __mode = "k"
})

local function isEngaged(p1, p2) -- line: 11
    -- upvalues: self (copy)
    local v2 = self[p1]

    if v2 == nil then
        return false
    end

    if p2 == nil then
        return true
    end

    return os.clock() - v2.Since < p2
end

local function conclude(p3, p4, p5, ...) -- line: 19
    -- upvalues: self (copy)
    if self[p3] == p4 then
        self[p3] = nil
    end

    if p5 then
        return true, ...
    end

    error(..., 0)
end

return function(p6) -- line: 29
    -- upvalues: self (copy), conclude (copy)
    local t3 = {}

    return function(p7, ...) -- line: 31
        -- upvalues: p6 (copy), t3 (copy), self (copy), conclude (copy)
        local v3 = self[t3]

        if v3 ~= nil and (p6 == nil or os.clock() - v3.Since < p6) then
            return false
        end

        local t4 = {
            Since = os.clock()
        }

        self[t3] = t4

        return conclude(t3, t4, pcall(p7, ...))
    end
end
