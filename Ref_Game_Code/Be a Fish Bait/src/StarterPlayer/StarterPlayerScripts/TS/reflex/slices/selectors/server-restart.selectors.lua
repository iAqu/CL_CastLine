-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

return {
    selectRestartEndTimestamp = function(p1) -- selectRestartEndTimestamp | line: 2
        return p1.serverRestart.endTimestamp
    end,
    selectRestartCloseReason = function(p2) -- selectRestartCloseReason | line: 5
        return p2.serverRestart.closeReason
    end,
    selectRestartMessage = function(p3) -- selectRestartMessage | line: 8
        return p3.serverRestart.message
    end
}
