-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ABTests = require(ReplicatedStorage.UserGenerated.ABTests)
local t1 = {
    TestName = "AfkTreadmillTest",
    AttributeKey = "AfkTreadmill.Group",
    Groups = table.freeze({
        Control = "Control",
        Variant = "Variant"
    })
}

function t1.GetGroupAsync(p1) -- line: 17
    -- upvalues: ABTests (copy), t1 (copy)
    if ABTests.GetAttributeAsync(p1, t1.AttributeKey, t1.Groups.Control) == t1.Groups.Variant then
        return t1.Groups.Variant
    end

    return t1.Groups.Control
end

function t1.IsVariantAsync(p2) -- line: 29
    -- upvalues: t1 (copy)
    return t1.GetGroupAsync(p2) == t1.Groups.Variant
end

return table.freeze(t1)
