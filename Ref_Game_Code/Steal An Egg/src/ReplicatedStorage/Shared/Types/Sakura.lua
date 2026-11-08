-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Eggs = require(ReplicatedStorage.Shared.Types.Eggs)
local t = require(ReplicatedStorage.Packages.t)
local v1 = t.interface({
    Uid = t.string,
    Egg = Eggs.SchemaValidation.SerializedSavedEgg
})
local t1 = {
    Egg = {
        blank = false,
        check = t.union(t.literal(false), v1)
    },
    Unlocked = {
        blank = false,
        check = t.boolean
    },
    TutorialSeen = {
        blank = false,
        check = t.boolean
    },
    Deposited = {
        blank = 0,
        check = t.number
    },
    LuckBoost = {
        blank = 0,
        check = t.number
    },
    Uses = {
        blank = 0,
        check = t.number
    },
    CostResetAt = {
        blank = 0,
        check = t.number
    },
    TotalMutations = {
        blank = 0,
        check = t.number
    }
}
local t2 = {}
local t3 = {}

for v2, v3 in t1 do
    t2[v2] = v3.check
    t3[v2] = v3.blank
end

table.freeze(t3)

return {
    IncubatorEgg = v1,
    State = t.interface(t2),
    MutateResult = t.interface({
        Uid = t.string,
        Egg = Eggs.SchemaValidation.SerializedSavedEgg,
        Mutation = t.string
    }),
    Blank = function() -- Blank | line: 66
        -- upvalues: t3 (copy)
        return (table.clone(t3))
    end
}
