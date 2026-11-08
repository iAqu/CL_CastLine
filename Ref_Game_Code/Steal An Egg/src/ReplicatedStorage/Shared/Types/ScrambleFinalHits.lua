-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local t = require(ReplicatedStorage.Packages.t)

local function whole(p1) -- line: 18
    if type(p1) == "number" and p1 >= 0 and p1 <= 9007199254740991 then
        return p1 % 1 == 0
    end

    return false
end

local t1 = {
    Blank = function() -- Blank | line: 24
        return {
            Total = 0,
            Scheduled = 0,
            Admin = 0,
            BeforeWeapon = 0,
            AfterWeapon = 0,
            FirstHitAt = 0,
            LastHitAt = 0,
            RecentFightUids = {}
        }
    end,
    Credit = function(p2, p3, p4, p5, p6) -- Credit | line: 37
        assert(type(p3) == "string" and #p3 > 0 and #p3 <= 128)

        local v2 = false

        if type(p4) == "boolean" then
            local v3 = type(p5) == "number" and p5 >= 0 and p5 <= 9007199254740991 and p5 % 1 == 0

            v2 = v3 and type(p6) == "number" and p6 >= 0 and p6 <= 9007199254740991 and p6 % 1 == 0
        end

        assert(v2)

        if table.find(p2.RecentFightUids, p3) then
            return nil, "AlreadyRecorded"
        end

        if p2.Total >= 9007199254740991 then
            return nil, "LimitReached"
        end

        local v4 = table.clone(p2)

        v4.RecentFightUids = table.clone(p2.RecentFightUids)
        table.insert(v4.RecentFightUids, p3)

        if #v4.RecentFightUids > 64 then
            table.remove(v4.RecentFightUids, 1)
        end

        v4.Total += 1

        if p4 then
            v4.Admin += 1
        else
            v4.Scheduled += 1
        end

        if not (p6 > 0 and p6 <= p5) then
            v4.BeforeWeapon += 1
        else
            v4.AfterWeapon += 1
        end

        if p2.Total == 0 then
            v4.FirstHitAt = p5
        else
            v4.FirstHitAt = math.min(p2.FirstHitAt, p5)
        end

        v4.LastHitAt = math.max(p2.LastHitAt, p5)

        return v4, "Recorded"
    end,
    State = t.interface({
        Total = whole,
        Scheduled = whole,
        Admin = whole,
        BeforeWeapon = whole,
        AfterWeapon = whole,
        FirstHitAt = whole,
        LastHitAt = whole,
        RecentFightUids = t.array(t.string)
    })
}

return table.freeze(t1)
