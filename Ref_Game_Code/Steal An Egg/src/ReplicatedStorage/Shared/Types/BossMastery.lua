-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local t = require(ReplicatedStorage.Packages.t)
local v1 = t.interface({
    BannerId = t.string,
    AssetId = t.string
})
local t1 = {
    Mastery = {
        check = t.number,
        blank = function() -- blank | line: 38
            return 0
        end
    },
    ClaimedMilestoneIds = {
        check = t.map(t.string, t.boolean),
        blank = function() -- blank | line: 44
            return {}
        end
    },
    ClaimedTokenBoostPercents = {
        check = t.map(t.string, t.number),
        blank = function() -- blank | line: 50
            return {}
        end
    },
    InfiniteRewardsClaimed = {
        check = t.number,
        blank = function() -- blank | line: 56
            return 0
        end
    },
    HasUsedMutationConsumable = {
        check = t.boolean,
        blank = function() -- blank | line: 62
            return false
        end
    },
    MutationConsumables = {
        check = t.number,
        blank = function() -- blank | line: 68
            return 0
        end
    },
    EggGrowthBoostExpiresAt = {
        check = t.number,
        blank = function() -- blank | line: 74
            return 0
        end
    },
    LuckBoostExpiresAt = {
        check = t.number,
        blank = function() -- blank | line: 80
            return 0
        end
    },
    SpeedBoostExpiresAt = {
        check = t.number,
        blank = function() -- blank | line: 86
            return 0
        end
    },
    RevealedRewards = {
        check = t.map(t.string, v1),
        blank = function() -- blank | line: 92
            return {}
        end
    }
}
local t2 = {}

for v2, v3 in t1 do
    t2[v2] = v3.check
end

local t3 = {
    State = t.interface(t2)
}

function t3.Blank() -- line: 107
    -- upvalues: t1 (copy)
    local t4 = {}

    for v4, v5 in t1 do
        t4[v4] = v5.blank()
    end

    return t4
end

function t3.Reconcile(p1) -- line: 115
    -- upvalues: v1 (copy), t1 (copy), t3 (copy)
    if type(p1) ~= "table" then
        return t3.Blank()
    end

    local v6 = table.clone(p1)

    for v7, v8 in t1 do
        if v7 == "RevealedRewards" then
            if type(v6[v7]) == "table" then
                local t5 = {}

                for v10, v11 in v6[v7] do
                    if type(v10) == "string" and v1(v11) then
                        t5[v10] = v11
                    end
                end

                v6[v7] = t5
            elseif not v8.check(v6[v7]) then
                v6[v7] = v8.blank()
            end
        elseif not v8.check(v6[v7]) then
            v6[v7] = v8.blank()
        end
    end

    return v6
end

return t3
