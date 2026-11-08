-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Eggs = require(ReplicatedStorage.Shared.Types.Eggs)
local t = require(ReplicatedStorage.Packages.t)
local v1 = t.interface({
    Uid = t.string,
    Egg = Eggs.SchemaValidation.SerializedSavedEgg
})
local v2 = t.map(t.string, t.number)
local t1 = {
    Requirements = {
        check = t.array(t.string),
        blank = function() -- blank | line: 40
            return {}
        end
    },
    RequirementsBannerId = {
        check = t.string,
        blank = function() -- blank | line: 46
            return ""
        end
    },
    Pity = {
        check = v2,
        blank = function() -- blank | line: 52
            return {}
        end
    },
    FreeRefreshDayKey = {
        check = t.string,
        blank = function() -- blank | line: 58
            return ""
        end
    },
    FreeRefreshesUsed = {
        check = t.number,
        blank = function() -- blank | line: 64
            return 0
        end
    },
    TradeInsByBanner = {
        check = v2,
        blank = function() -- blank | line: 70
            return {}
        end
    },
    PendingReward = {
        check = t.union(t.literal(false), v1),
        blank = function() -- blank | line: 76
            return false
        end
    },
    PaidRefreshDayKey = {
        check = t.optional(t.string),
        blank = function() -- blank | line: 83
            return ""
        end
    },
    PaidRefreshesUsed = {
        check = t.optional(t.number),
        blank = function() -- blank | line: 89
            return 0
        end
    }
}
local t2 = {}

for v3, v4 in t1 do
    t2[v3] = v4.check
end

return {
    PendingReward = v1,
    State = t.interface(t2),
    Blank = function() -- Blank | line: 107
        -- upvalues: t1 (copy)
        local t4 = {}

        for v5, v6 in t1 do
            t4[v5] = v6.blank()
        end

        return t4
    end
}
