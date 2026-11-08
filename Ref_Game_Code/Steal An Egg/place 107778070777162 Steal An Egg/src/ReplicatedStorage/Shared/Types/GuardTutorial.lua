-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local t = require(ReplicatedStorage.Packages.t)
local t1 = {
    TreadmillIntro = "TreadmillIntro",
    ExpandPen = "ExpandPen",
    PlacePet = "PlacePet",
    HatchEgg = "HatchEgg",
    PlaceEgg = "PlaceEgg",
    EquipEgg = "EquipEgg",
    HeadToPen = "HeadToPen",
    StealEgg = "StealEgg"
}
local t2 = {
    Inactive = "Inactive",
    ForwardRun = "ForwardRun"
}
local t3 = {
    t1.StealEgg,
    t1.HeadToPen,
    t1.EquipEgg,
    t1.PlaceEgg,
    t1.HatchEgg,
    t1.PlacePet,
    t1.ExpandPen,
    t1.TreadmillIntro
}
local t4 = {
    t2.Inactive,
    t2.ForwardRun
}

local function anyOf(p1) -- line: 54
    -- upvalues: t (copy)
    local v1 = table.create(#p1)

    for v2, v3 in p1 do
        v1[v2] = t.literal(v3)
    end

    return t.union(table.unpack(v1))
end

local v4 = anyOf(t3)
local v5 = anyOf(t4)
local v6 = t.interface({
    Completed = t.boolean,
    CurrentStepId = t.optional(v4)
})
local v7 = t.interface({
    Enabled = t.boolean,
    PausedForAdminAbuse = t.boolean,
    Revision = t.number
})
local t5 = {
    Completed = false,
    CurrentStepId = nil
}
local t6 = {
    StepIds = t1,
    RunGuidanceStates = t2,
    DEFAULT_PROGRESS = t5,
    SchemaValidation = {
        StepId = v4,
        RunGuidanceState = v5,
        Progress = v6,
        ProgressUpdatePayload = v6,
        RuntimeState = v7
    },
    CopyProgress = function(p2) -- CopyProgress | line: 92
        return {
            Completed = p2.Completed == true,
            CurrentStepId = p2.CurrentStepId
        }
    end
}

function t6.SanitizeProgress(p3) -- line: 98
    -- upvalues: v6 (copy), t5 (copy), t6 (copy)
    if p3 ~= nil and v6(p3) then
        local v8 = t6.CopyProgress(p3)

        if v8.Completed then
            v8.CurrentStepId = nil
        end

        return v8
    end

    return t6.CopyProgress(t5)
end

function t6.AcceptsStepId(p4) -- line: 110
    -- upvalues: v4 (copy)
    return v4(p4)
end

function t6.AcceptsGuidanceState(p5) -- line: 112
    -- upvalues: v5 (copy)
    return v5(p5)
end

return t6
