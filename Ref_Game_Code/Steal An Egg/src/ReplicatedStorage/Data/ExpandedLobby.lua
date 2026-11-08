-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local t1 = {
    TestAttributeKey = "ExpandedLobby.Group",
    ServerTypeAttributeKey = "ExpandedLobby.ServerType",
    Groups = table.freeze({
        Control = "Control",
        Variant = "Variant"
    }),
    UnlockedValue = "None",
    ServerAttribute = "ExpandedLobbyServerGroup",
    TeleportDataKey = "ExpandedLobbyGroup",
    StudioForceAttribute = "ExpandedLobbyForceGroup",
    RemovalTag = "ExpandedLobbyABTestRemoval",
    JobAttributeWaitSeconds = 15,
    ApplyDeadlineSeconds = 120,
    PlotSpread = table.freeze({
        CenterZ = -364.1,
        ZScale = 1.35,
        WestColumnXOffset = -20,
        WestColumnMaxX = 500
    })
}

function t1.IsValidGroup(p1) -- line: 26
    -- upvalues: t1 (copy)
    if p1 == t1.Groups.Control then
        return true
    end

    return p1 == t1.Groups.Variant
end

return table.freeze(t1)
