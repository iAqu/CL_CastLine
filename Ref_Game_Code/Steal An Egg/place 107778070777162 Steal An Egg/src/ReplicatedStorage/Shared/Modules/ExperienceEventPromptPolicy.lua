-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local t1 = {
    Id = "string",
    HasStarted = "boolean",
    HasEnded = "boolean"
}

local function coerce(p1) -- line: 18
    -- upvalues: t1 (copy)
    local t2 = {}

    for v1, v2 in t1 do
        local v3 = if type(p1) == "table" then p1[v1] else nil

        if type(v3) ~= v2 then
            return nil
        end

        t2[v1] = v3
    end

    return t2
end

local function isUsableId(p2) -- line: 33
    if type(p2) == "string" and #p2 > 0 then
        return #p2 <= 128
    end

    return false
end

local function countKeys(p3) -- line: 37
    local n1 = 0

    for _ in p3 do
        n1 += 1
    end

    return n1
end

local t3 = {
    PromptDelaySeconds = 300,
    RetryDelaySeconds = 30,
    NoEventRecheckSeconds = 60,
    MaxAttempts = 5,
    IsValidEventId = isUsableId,
    IsSafeToPrompt = function(p4, p5, p6) -- IsSafeToPrompt | line: 54
        return p4 and not p5 and not p6
    end,
    IsReturningPlayer = function(p7, p8, p9) -- IsReturningPlayer | line: 60
        return p7 > 1 and p8 >= 0 and p8 <= p9 and p9 // 86400 > p8 // 86400
    end,
    GetSoonestUnseenEvent = function(p10, p11) -- GetSoonestUnseenEvent | line: 65
        -- upvalues: coerce (copy)
        local v4 = if type(p10) == "table" then p10 else {}

        for _, v5 in v4 do
            local v6 = coerce(v5)

            if v6 ~= nil and not v6.HasStarted and not v6.HasEnded and not p11[v6.Id] then
                return v6
            end
        end

        return nil
    end,
    TryMarkSeen = function(p12, p13, p14) -- TryMarkSeen | line: 80
        if type(p13) ~= "string" or not (#p13 > 0) or not (#p13 <= 128) then
            return false
        end

        assert(type(p13) == "string")

        local v8 = p12[p13] == true

        if not v8 then
            local n2 = 0

            for _ in p12 do
                n2 += 1
            end

            v8 = n2 < p14
        end

        if v8 then
            p12[p13] = true
        else
            p12[p13] = p12[p13]
        end

        return v8
    end
}

return table.freeze(t3)
