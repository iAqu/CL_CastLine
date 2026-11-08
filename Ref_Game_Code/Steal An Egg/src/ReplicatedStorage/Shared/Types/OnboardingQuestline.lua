-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local t = require(ReplicatedStorage.Packages.t)
local t1 = {
    Variant = {
        check = t.string,
        blank = function() -- blank | line: 22
            return ""
        end
    },
    StartedAt = {
        check = t.number,
        blank = function() -- blank | line: 28
            return 0
        end
    },
    SetIndex = {
        check = t.number,
        blank = function() -- blank | line: 34
            return 1
        end
    },
    Progress = {
        check = t.map(t.string, t.number),
        blank = function() -- blank | line: 40
            return {}
        end
    },
    Claimed = {
        check = t.map(t.string, t.boolean),
        blank = function() -- blank | line: 46
            return {}
        end
    },
    UnlockedPadlocks = {
        check = t.number,
        blank = function() -- blank | line: 52
            return 0
        end
    },
    PadlocksAcknowledged = {
        check = t.number,
        blank = function() -- blank | line: 58
            return 0
        end
    },
    RewardGranted = {
        check = t.boolean,
        blank = function() -- blank | line: 64
            return false
        end
    },
    RewardAcknowledged = {
        check = t.boolean,
        blank = function() -- blank | line: 70
            return false
        end
    }
}
local t2 = {}

for v1, v2 in t1 do
    t2[v1] = v2.check
end

local t3 = {
    State = t.interface(t2)
}

function t3.Blank() -- line: 85
    -- upvalues: t1 (copy)
    local t4 = {}

    for v3, v4 in t1 do
        t4[v3] = v4.blank()
    end

    return t4
end

function t3.Reconcile(p1) -- line: 95
    -- upvalues: t1 (copy), t3 (copy)
    if type(p1) ~= "table" then
        return t3.Blank()
    end

    local v5 = table.clone(p1)

    for v6, v7 in t1 do
        if not v7.check(v5[v6]) then
            v5[v6] = v7.blank()
        end
    end

    return v5
end

return t3
