-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local t1 = {
    RefreshSeconds = 60,
    RetryBackoffSeconds = 30,
    TimerUpdateSeconds = 1,
    PromptDistance = 12,
    ToUnix = function(p1) -- ToUnix | line: 42
        if type(p1) ~= "table" then
            return nil
        end

        local function v1() -- line: 47
            -- upvalues: p1 (copy)
            return DateTime.fromUniversalTime(p1.Year, p1.Month, p1.Day, p1.Hour, p1.Minute, p1.Second, p1.Millisecond or 0)
        end

        local ok, result = pcall(v1)

        return if ok and result then result.UnixTimestamp else nil
    end
}

function t1.IsEligible(p2, p3) -- line: 61
    -- upvalues: t1 (copy)
    if type(p2) ~= "table" then
        return false
    end

    if type(p2.Id) == "string" and p2.Id ~= "" then
        if p2.Status ~= Enum.ExperienceEventStatus.Active or p2.HasStarted == true or p2.HasEnded == true then
            return false
        end

        local v2 = t1.ToUnix(p2.StartTime)

        return v2 ~= nil and p3 < v2
    end

    return false
end

function t1.Pick(p4, p5) -- line: 76
    -- upvalues: t1 (copy)
    if type(p4) ~= "table" then
        return nil
    end

    local t2

    for _, v3 in p4 do
        if t1.IsEligible(v3, p5) then
            local v4 = t1.ToUnix(v3.StartTime)

            if t2 == nil or v4 < t2.StartsAt then
                t2 = {}
                t2.Id = v3.Id

                if type(v3.Title) == "string" then
                    t2.Title = v3.Title
                else
                    t2.Title = ""
                end

                t2.StartsAt = v4
                t2.Going = v3.UserRsvpStatus == Enum.RsvpStatus.Going
            end
        end
    end

    return t2
end

function t1.ShouldShow(p6) -- line: 100
    return p6 ~= nil and not p6.Going
end

function t1.Countdown(p7) -- line: 104
    local v6 = math.max(0, (math.floor(p7)))
    local v7 = v6 // 86400
    local v8 = v6 % 86400 // 3600
    local v9 = v6 % 3600 // 60
    local v10 = v6 % 60

    if v7 > 0 then
        return string.format("%dd %dh %dm", v7, v8, v9)
    end

    if v8 > 0 then
        return string.format("%dh %dm %ds", v8, v9, v10)
    end

    return string.format("%dm %ds", v9, v10)
end

return table.freeze(t1)
